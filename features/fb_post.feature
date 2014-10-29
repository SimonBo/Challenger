Feature: Post on users facebook wall
As a user
Who registered with facebook
I can allow the app
To post on my wall
After I take action
  
  @javascript
  Scenario: Registration
    Given I am on the homepage
    And I register with facebook
    Then I can accept that the app will access my facebook profile
    And I can give the app permission to post in my name
    And if I accept
    Then the app posts on my wall "Today, I joined the Challenger. It's uber cool. Check it out at simon-challenger.herokuapp.com"
