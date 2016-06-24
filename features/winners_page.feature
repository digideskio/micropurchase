Feature: Guest views winners page
  As a guest
  I want to see details about past auctions
  So I can learn more about Micro-purchase

  @javascript 
  Scenario: Navigating to winners page
    Given there have been many auctions
    When I visit the winners page
    Then I should see the statistics about previous auctions
