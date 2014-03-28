Feature:
  As a Ruby developer
  I want to define my dependencies in a Motefile
  So I can start up my application

    Scenario: Santa's Workshop
      Given I have a module "NorthPole":
      """
      class Santa
        # constructor :mrs_claus, :workshop, :sleigh
        attr_reader :mrs_claus #, :workshop, :sleigh

        def initialize(mrs_claus, workshop)#, sleigh)
          @mrs_claus = mrs_claus
          @workshop = workshop
          # @sleigh = sleigh
        end
      end

      class MrsClaus
      end

      class Workshop
        # constructor :elves
        attr_reader :elves

        def initialize(elves)
          @elves = elves
        end
      end

      class Elf
      end

      class Sleigh
        # constructor :reindeer
        attr_reader :reindeer

        def initialize(reindeer)
          @reindeer = reindeer
        end
      end

      class Reindeer
      end

      class Rudolph < Reindeer
      end
      """
      And I have a Motefile:
      """
      namespace "NorthPole" do
        santa!.needs mrs_claus, workshop#, sleigh
        mrs_claus!
        workshop!.needs elves
        elves! [elf] * 200
        elf!.singleton false
        sleigh!.needs [
          dasher,
          dancer,
          prancer,
          vixen,
          comet,
          cupid,
          donner,
          blitzen
        ]
        reindeer!
        dasher! reindeer
        dancer! reindeer
        prancer! reindeer
        vixen! reindeer
        comet! reindeer
        cupid! reindeer
        donner! reindeer
        blitzen! reindeer
      end
      """
      When I require the Motefile
      Then the Mote "santa" should resolve to an instance of "NorthPole::Santa"
      And the resolved "santa" should respond to "mrs_claus", which should be an instance of "NorthPole::MrsClaus"
      And the resolved "elves" should have 200 entries, each of which should be an instance of "NorthPole::Elf"
      And the resolved "workshop" should have 200 elves, each of which should be an instance of "NorthPole::Elf"
