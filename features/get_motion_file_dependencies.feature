Feature:
  As a RubyMotion developer
  I want to declare my file-level dependencies up front
  So RubyMotion loads my classes in the right order

  Scenario: Getting an explicitly-defined file dependency graph
    Given I have a motefile:
      """
      motivation
      my_mote requires: 'another_mote'
      another_mote
      and_another_mote
      yet_another_mote requires: [:my_mote, :and_another_mote]
      """
    When I get the file dependency graph
    Then I should see the following file dependencies:
      | ./test_data/my_mote.rb          | ./test_data/another_mote.rb                             |
      | ./test_data/another_mote.rb     |                                                         |
      | ./test_data/and_another_mote.rb |                                                         |
      | ./test_data/yet_another_mote.rb | ./test_data/my_mote.rb, ./test_data/and_another_mote.rb |
