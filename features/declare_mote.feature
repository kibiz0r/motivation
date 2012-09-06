Feature:
  As a Ruby developer
  I want to declare a mote
  So I can reference it in my application

  Scenario: Declaring an opaque mote for a pre-defined class
    Given I have a motefile:
      """
      motivation
      predefined opaque: true
      """
    And there is a class "Predefined"
    When I locate "predefined"
    And I get its constant
    Then I should have the "Predefined" class

  Scenario: Declaring a mote for a class that needs to be required
    Given I have a motefile:
      """
      motivation
      requirable
      """
    When I locate "requirable"
    And I get its constant
    Then I should have the "Requirable" class
