Feature: enter line for help
  
  As a student
  So that I can receive help with my writing
  I want to get in line
  

Scenario: Jennifer wants to wait in line
  Given "Jennifer" "Be" is on the wait time page
  And I press "yes"
  Then "Jennifer" "Be" should be on the home page #create to create a not 
  And "Jennifer" "Be" should see "you are in line"
  And "Jennifer" "Be" should not see "Hope to see you soon"

# Scenario: Jennifer doesn't want to wait in line
#   Given "Jennifer" "Be" is on the wait time page
#   And she clicks on "no"
#   Then "Jennifer" "Be" should not be on the confirmation page
#   And she should see "Hope to see you soon"
#   And she should not see "you are in line"
  

#have to rethink this senario because current implementation won't let 
#jennifer get to the wait time page. But maybe we should show her wait time
#if she attempts to sign up again.

# Scenario: Jennifer Be wants to sign up but is already in the line
#   Given "Jennifer" "Be" is already in line
#   Given "Jennifer" "Be" is on the wait time page
#   Given she clicks on "yes"
#   Then she should be not be on the confirmation page
#   And "Jennifer" "Be" should see "You are already in line Jennifer"
  
  