Feature:
  As a Ruby developer
  I want to define my dependencies in a Motefile
  So I can start up my application

    Scenario: Santa's Workshop
      Given I have a module "NorthPole":
      """
      class Santa
        constructor :mrs_claus, :workshop, :sleigh
      end

      class MrsClaus
      end

      class Workshop
        constructor :elves
      end

      class Sleigh
        constructor :reindeer
      end

      class Reindeer
      end

      class Rudolph < Reindeer
      end
      """
      And I have a Motefile:
      """
      namespace "NorthPole" do
        santa!.needs mrs_claus, workshop, sleigh
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
      Then the Mote "santa" should resolve to "NorthPole::Santa"
