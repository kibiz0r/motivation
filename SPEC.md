# Motivation

## Installation and usage

In your Gemfile:

	gem "motivation"

In your Rakefile:

	Bundler.require
	Motivation.require

In your Motefile:

	motivation

	app do
		app_delegate
	end

## Motefiles

A Motefile is a convention-driven description of a codebase's object graph.

### motivation

	motivation 'lib', lazy: true

The motivation declaration applies to the context as a whole, and sets up the root source path as well as the default values for options on motes and containers.

### Motes

	... do
		... do
			# v-- this is a mote
			text_widget :basic_text_widget, namespace: 'UI', lazy: true, singleton: false
			map_widget opaque: true # <-- so is this
		end
	end

A mote is a complete description of how Motivation should treat a class definition -- how to require it, resolve it to a constant, instantiate it, and so on. This mainly takes the form of passing in flags which are handled by objects called motives. By writing your own motives, you can extend motes to be capable of anything.

### Containers

	effects path: 'fx' do
		big_explosions path: 'explosions', lazy: true, scan: 'boom_*.rb' do
			...
		end

		small_explosions scan: 'pop_*.rb', path: false do
			...
		end
	end

Obviously, you don't want to specify every option on every mote, so containers allow you to declare the conventions that a group of motes will follow by setting values for motives on the container.

Different motives will cascade these values differently , but you can always override how a motive's default values are calculated by passing in a lambda instead, which will be instance_eval'd by the mote when the motive's default value is needed. You can do this on a container-by-container basis, or use the `motivation` declaration to set it for the entire context (since the context is just a fancy container).

### Example: Building a robot

(a.k.a. [the "robot legs" problem](http://code.google.com/p/google-guice/wiki/FrequentlyAskedQuestions#How_do_I_build_two_similar_but_slightly_different_trees_of_objec))

	motivation 'lib', namespace: 'Robot'

	sensors do
		# no configuration here, relying on scan (true by default) to
		# find and define everything according to convention
	end

	voices path: 'audio', scan: '*_voice.rb' do
		generated opaque: true, namespace: false do
			shazbot_voice, dependencies: [:light_voice, :medium_voice, :heavy_voice]
			quake_voice
		end
	end

	views lazy: true do
	end

	robot
	# dependencies are automatically picked up by requiring the class definition
	# class Robot
	#   constructor :head, :torso, :left_arm, :right_arm, :left_leg, :right_leg
	#   ...
	# end
	
	parts do
		# scan picks up:
		#   arm
		#   head
		#   left_foot
		#   left_hand
		#   leg
		#   right_foot
		#   right_hand
		#   torso
		left_arm :arm, dependencies: { hand: 'left_hand' }
		right_arm :arm, dependencies: { hand: 'right_hand' }
		left_leg :leg, dependencies: { foot: 'left_foot' }
		right_leg :leg, dependencies: { foot: right_foot' }
	end

And now in my app, `Motivation.robot!` will instantiate my robot and all of its dependencies. Notice how we mapped the plain leg and arm classes to left and right versions that are injected with the appropriate appendage.

## Motives

Motives are the metadata attached to containers and motes. Some motives inherit values from their parent containers, some are based on other values set on the mote, others are only set directly.

You can define your own motives inside or outside of your Motefile. The `motive` macro takes the name of your motive and its default value (can be a lambda, which is `instance_eval`'d  on the created mote). The body of the macro is module_eval'd in a generated module that gets included on the mote's metaclass. Motives are included in the order they are defined, so you can use super to fall back to the original implementation.

	# Motivation.motive! outside of a Motefile
	motive opaque: lambda { inherited_opt :opaque, false } do
		def can_require?
			!self.opaque && super
		end
	end

### opaque

Defaults to `lambda { inherited_opt :opaque, false }`

If true, this mote's class definition will never be required by Motivation. It is assumed to come into existence through some other means -- a manual require, built-in, generated on the fly, or statically compiled as in RubyMotion.

	# Don't allow Motivation to require my views
	# They reference UIView, which only exists in RubyMotion
	# (where there is no file to require)
	views opaque: true do
		my_ui_view
	end

### lazy

Defaults to `lambda { inherited_opt :lazy, false }`

If true, Motivation will avoid requiring this class definition until the mote is first resolved, probably by instantiating it.

	app do
		# Don't trigger ActiveRecord machinery unless I ask for it
		models lazy: true do
			my_active_record_model
		end
	end

### namespace

Defaults to `true`, which is treated the same as `lambda { "#{inherited_opt :namespace}::#{namespace_part}" }`

If specified, is the fully-qualified module path used to resolve the mote.

If falsy, inherits its container's namespace.

### constant_name

Defaults to `lambda { name.camelize :upper }`

Specifies the module/class name conventionally appended to the container's namespace to get the fully-qualified module path used to resolve the mote.

### instantiated

Defaults to `true`, which is treated the same as `lambda { inherited_opt :instantiated, 'new' }`

If specified, the name of the method to call on the mote's factory (conventionally the mote's class object) in order to instantiate this mote.

If falsy, this mote is never instantiated. Attempting to instantiate it simply returns the class object this mote represents.

### factory

Defaults to `lambda { inherited_opt :factory, "#{name}_factory" }`

Specifies the mote that should be used to instantiate this mote. Conventionally, this is the mote's name plus _factory, which conventionally resolves to the mote's class object.

### singleton

Defaults to `lambda { inherited_opt :singleton, true }`

If true, this mote will cache its first created instance and return it every time Motivation asks for a new instance.

### path

Defaults to `lambda { File.join inherited_opt(:path), directory }`

Specifies the absolute path used to require the mote's class definition, overriding any inherited path.

### directory

Defaults to `lambda { name }`

Specifies the path used to require the mote's class definition, relative to its parent's path.

### scan

Defaults to `true`, which is treated the same as `lambda { File.join path, '**', '*.rb' }`

Only valid on containers.

If specified, a glob used to automatically find class definitions and create motes in this container. Scanning occurs before yielding to the container's block.

### requires

Defaults to `lambda { inherited_opt :requires, [] }`

Specifies a list of motes (or containers of motes) whose class definitions must execute before this one's.

### dependencies

Defaults to `lambda { load_dependencies! }`

Specifies a list or hash of motes (constructor name => mote name) that will be instantiated along with this mote and passed to its constructor.

### args

Defaults to `lambda { inherited_opt(:args, {}).merge(instantiate_dependencies!).merge(extra_args) }`

Specifies the hash (or any object) that will be passed to the constructor when instantiating this mote. If you specify an array, it will be splat'd to the constructor.

### extra_args

Defaults to `lambda { {} }`

Specifies part of the hash combined with the mote's dependencies and passed to its constructor when instantiating the mote. The difference is that `extra_args` does not undergo the processing that `dependencies` does, scanning for mote names and instantiating them.

Any option passed to a new container or mote is assumed to be an extra_arg if it doesn't match any motives.

## Resolvers

Resolvers are macros used to respond to requests for motes that aren't explicitly defined but can be found by convention.

	resolver /(.*)_factory$/ do |name|
		# Mote#pseudo returns a detached (i.e. doesn't exist in any container)
		# copy of the mote with the specified opts replaced
		mote(name).pseudo name: "#{name}_factory", instantiated: false
	end

You can return anything from a resolver.

	resolver /(.*)!$/ do |name, *args|
		mote(name).instantiate *args
	end