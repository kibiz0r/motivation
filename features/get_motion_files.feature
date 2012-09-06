Feature:
  As a RubyMotion developer
  I want to declare all of my classes up front
  So I can include them in RubyMotion compilation

  Scenario: Getting an explicitly-defined file list
    Given I have a motefile:
      """
      motivation
      my_mote
      another_mote
      yet_another_mote
      """
    When I get the file list
    Then I should see the following files:
      """
      ./test_data/my_mote.rb
      ./test_data/another_mote.rb
      ./test_data/yet_another_mote.rb
      """
