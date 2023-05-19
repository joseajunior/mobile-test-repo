*** Settings ***
Library  Process
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Documentation  Test User filtering for Policy, Subfleet, and Contract\n
    ...   meaning if a carrier sets up a user to only see policy 1 stuff that is all they see\n
    ...   Below notes incase setup gets blown away some how\n
    ...   For the test you'll want a carrier that has multiple contracts, and policies (106744 seems like a good one)\n
    ...   To set up for a company go to sysop\n
    ...   Go to Manage Companies -> Show Groups ->Edit Group Permissions for the Company Admin\n
    ...   add role for Allowed Contracts- note role param defaults to 'ALL'\n
    ...   add role for Allowed Policies- note role param defaults to 'ALL'\n
    ...   add role for Allowed Subfleets - note role param defaults to 'ALL'\n
    ...   add role for Denied Contracts- note role param defaults to 'NONE'\n
    ...   add role for Denied Policies- note role param defaults to 'NONE'\n
    ...   add role for Denied Subfleets - note role param defaults to 'NONE'\n
    ...   turn off menu_item for all of the above\n
    ...   This will make sure the ADMIN user will see all cards and policies.\n
    ...   Go Manage Companies->Search->Edit Company\n
    ...   add attribute Policy Role Filtering = Y\n
    ...   add attribute Subfleet Filtering = Y\n
    ...   add attribute Contract Filtering = Y\n
    ...   Log in as carrier\n
    ...   Go to User Administration > Manage Groups\n
    ...   Add the following groups Policy_group, Subfleet_group, Contract_group\n
    ...   Setup Policy_group with all roles and edit Allowed Policies to policy 1\n
    ...   Setup Subfleet_group with all roles and edit Allowed Subfleets to subfleet1\n
    ...   Setup Contract_group with all roles and edit Allowed Contract to have only 1 of the contracts\n
    ...   Go to User Administration > Manage Users -> Add user\n
    ...   Add pguser and assign to Policy_group\n
    ...   Add sfguser and assign to Subfleet_group\n
    ...   Add cguser and assign to Contract_group\n
    ...   Make sure none of the above users have the COMPANY_ADMIN group\n
    ...   or filtering for them wont apply.\n

Force Tags  eManager

Suite Teardown  close
*** Variables ***
${pguser} =  pguser
${cguser} =  cguser
${sfguser} =  sfguser
${pass} =  w3e4r5t6


*** Test Cases ***
Policy restriction
  [Tags]  JIRA:BOT-174  refactor

   Login user  ${pguser}  ${pass}
   #check that below cards are displayed since they are on policy 1
   page should contain element  xpath=//*[contains(text(), '7083059910674401517')]
   page should contain element  xpath=//*[contains(text(), '7083059910674400428')]
   #check the below cards don't show that are on different policies
   page should not contain element  xpath=//*[contains(text(), '7083059910674402390')]  # card on policy 2
   page should not contain element  xpath=//*[contains(text(), '7083059910674401723')]  # card on policy 3
   page should not contain element  xpath=//*[contains(text(), '7083059910674400519')]  # card on policy 6
   page should not contain element  xpath=//*[contains(text(), '7083059910674400550')]  # card on policy 7
   page should not contain element  xpath=//*[contains(text(), '7083059910674401483')]  # card on policy 11

   [Teardown]  Close Browser

Contract restriction
  [Tags]  JIRA:BOT-174  refactor

   Login user  ${cguser}  ${pass}
   #Check that only see cards on 4767 contract
   page should contain element  xpath=//*[contains(text(), '7083059910674400444')]
   page should contain element  xpath=//*[contains(text(), '7083059910674400451')]
   page should contain element  xpath=//*[contains(text(), '7083059910674401327')]
   page should contain element  xpath=//*[contains(text(), '7083059910674401707')]
   page should contain element  xpath=//*[contains(text(), '7083059910674401715')]
   page should contain element  xpath=//*[contains(text(), '7083059910674401723')]
   page should contain element  xpath=//*[contains(text(), '7083059910674400469')]
   #check cards that are not on the above contract dont show
   page should not contain element  xpath=//*[contains(text(), '7083059910674400519')]  # card on contact 4969
   page should not contain element  xpath=//*[contains(text(), '7083059910674401376')]  # card on contract 4970
   page should not contain element  xpath=//*[contains(text(), '7083059910674401517')]  # card on contract 4971
   page should not contain element  xpath=//*[contains(text(), '7083059910674400550')]  # card on contract 4972
    [Teardown]  Close Browser

Subfleet restrictions
  [Tags]  JIRA:BOT-174  refactor
  Login user  ${sfguser}  ${pass}
  #check that the following cards on subfleet1 appear
  page should contain element  xpath=//*[contains(text(), '7083059910674401707')]
  page should contain element  xpath=//*[contains(text(), '7083059910674401715')]
  page should contain element  xpath=//*[contains(text(), '7083059910674400436')]
  page should contain element  xpath=//*[contains(text(), '7083059910674400469')]
  #check to verify other subfleets don't appear
  page should not contain element  xpath=//*[contains(text(), '7083059910674402390')]  # card on subfleet11
  page should not contain element  xpath=//*[contains(text(), '7083059910674400550')]  # card on subfleet2
  [Teardown]  Close Browser

*** Keywords ***
Login user
   [Arguments]  ${user}  ${pss}
   Open Browser to eManager
   Log into eManager  ${user}  ${pss}
   Go To  ${emanager}/cards/CardLookup.action