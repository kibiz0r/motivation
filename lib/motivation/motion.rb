module Motivation
  class Motion < Context
    def initialize(*args, &block)
      super motives: (Motivation.motives + [Motivation::Motives::SuppressRequire]),
        locators: Motivation.locators,
        path: Motivation.root,
        name: 'Motefile.motion'
      MoteLoader.new(self).eval &block
    end
  end
end
