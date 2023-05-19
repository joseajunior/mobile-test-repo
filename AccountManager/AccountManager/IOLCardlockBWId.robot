*** Settings ***
Library  DateTime
Library  BuiltIn
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot


Documentation  This suite tests the new field on the IOL Cardlock Record Search detail page called 'Branded Wholesaler BW #'. A BW # can be manually added on the detail page, and edited after being set. Only a numeric number will be valid, alphanumeric will fail.

Force Tags  AM
*** Variables ***
${carrier}
${location}
${existing_bw_location}

*** Test Cases ***

Add BW ID to location on IOL Helpdesk Cardlock screen
  [Tags]  JIRA:BOT-3229  JIRA:FRNT-997  refactor
  [Documentation]  This test checks that a BW # can be added to a loaction in the IOL Cardlock detail screen manually.
  [Setup]  run keywords  Add necessary roles to random carrier
  ...  AND  Get a Valid Location for specific loc_type  'ESSO'


  Open eManager  ${carrier.id}  ${carrier.password}
  Go To  ${emanager}/acct-mgmt/CardlockHelpdesk.action
  Wait Until Element Is Visible  name=locationId  timeout=30
  Input Text  name=locationId  ${location}
  Click On  text=Submit  exactMatch=False
  Click On  text=${location}
  Wait Until Element Is Visible  name=detailRecord.emBWID  timeout=30
  Input Text  name=detailRecord.emBWID  123456
  Click On  text=Submit  exactMatch=False
  Wait until page contains  text=Edit Successful  timeout=10
  sleep  10
  get into db  IMPERIAL
  ${get_bw_id}  catenate  select esso_bw_id from imperial_location_ref where location_id = ${location};
  ${bw_id}  query and strip  ${get_bw_id}
  should be equal as strings  ${bw_id}  123456
  close browser


Edit existing BW ID for location on IOL Helpdesk Cardlock screen
  [Tags]  JIRA:BOT-3229  JIRA:FRNT-997  refactor
  [Documentation]  This test checks that a BW # that has already been added to a location can successfully be edited manually.
  [Setup]  run keywords  Add necessary roles to random carrier
  ...  AND  Find location with existing BW ID

  Open eManager  ${carrier.id}  ${carrier.password}
  Go To  ${emanager}/acct-mgmt/CardlockHelpdesk.action
  Wait Until Element Is Visible  name=locationId  timeout=30
  Input Text  name=locationId  ${existing_bw_location}
  Click On  text=Submit  exactMatch=False
  Click On  text=${existing_bw_location}
  Wait Until Element Is Visible  name=detailRecord.emBWID  timeout=30
  Input Text  name=detailRecord.emBWID  654321
  Click On  text=Submit  exactMatch=False
  Wait until page contains  text=Edit Successful  timeout=10
  sleep  10
  get into db  IMPERIAL
  ${get_bw_id}  catenate  select esso_bw_id from imperial_location_ref where location_id = ${existing_bw_location};
  ${bw_id}  query and strip  ${get_bw_id}
  should be equal as strings  ${bw_id}  654321
  close browser

Confirm error if BW ID attempted input is alpha-numeric
  [Tags]  JIRA:BOT-3229  JIRA:FRNT-997  refactor
  [Documentation]  This test checks to make sure there is an error when attempting to input an alpha-numeric number for BW #.
  [Setup]  run keywords  Add necessary roles to random carrier
  ...  AND  Get a Valid Location for specific loc_type  'ESSO'

  Open eManager  ${carrier.id}  ${carrier.password}
  Go To  ${emanager}/acct-mgmt/CardlockHelpdesk.action
  Wait Until Element Is Visible  name=locationId  timeout=30
  Input Text  name=locationId  ${location}
  Click On  text=Submit  exactMatch=False
  Click On  text=${location}
  Wait Until Element Is Visible  name=detailRecord.emBWID  timeout=30
  Input Text  name=detailRecord.emBWID  1A2B3C
  Click On  text=Submit  exactMatch=False
  Wait until page contains  text=Please enter a valid number.  timeout=10
  close browser

  [Teardown]  Delete BW value from DB under location  ${location}


Confirm error if BW ID attempted input is longer than 20 digits
  [Tags]  JIRA:BOT-3229  JIRA:FRNT-997  refactor
  [Documentation]  This test checks to make sure there is an error when attempting to input more than 20 digits for BW #.
  [Setup]  run keywords  Add necessary roles to random carrier
  ...  AND  Get a Valid Location for specific loc_type  'ESSO'

  Open eManager  ${carrier.id}  ${carrier.password}
  Go To  ${emanager}/acct-mgmt/CardlockHelpdesk.action
  Wait Until Element Is Visible  name=locationId  timeout=30
  Input Text  name=locationId  ${location}
  Click On  text=Submit  exactMatch=False
  Click On  text=${location}
  Wait Until Element Is Visible  name=detailRecord.emBWID  timeout=30
  Input Text  name=detailRecord.emBWID  123456789123456789123
  Click On  text=Submit  exactMatch=False
  ${message}  Handle Alert
  log to console  ${message}
  close browser


*** Keywords ***

Add necessary roles to random carrier
  Get Into DB  Mysql

#Get user_id from the last 30 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 30;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT member_id FROM member WHERE mem_type='C' AND status='A' AND carrier_type='TCH' AND member_id IN ${list_2};
    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set suite Variable  ${carrier}

  add user role if not exists  ${carrier.id}  IOLCL_CARDLOCK_STRIPES  true
  add user role if not exists  ${carrier.id}  IOLCL_CARDLOCK  true
  add user role if not exists  ${carrier.id}  IOLCL_CARDLOCK_MASTER  true
  add user role if not exists  ${carrier.id}  IOLCL_CARDLOCK_SEARCH  true
  add user role if not exists  ${carrier.id}  IOLCL_CARDLOCK_DETAIL  true
  add user role if not exists  ${carrier.id}  IOLCL_COMPANY_MANAGER  true
  add user role if not exists  ${carrier.id}  IOLCL_RECORD_SEARCH  true


Get a Valid Location for specific loc_type
    [Arguments]  ${loc_type}

    Get Into DB  IMPERIAL
    ${location_query}  catenate  SELECT location_id
    ...  FROM location
    ...  WHERE loc_type=${loc_type}
    ...  AND status='A' limit 50
    ${location_list}  Query And Strip To List  ${location_query}
    ${location}  evaluate  random.choice(${location_list})  random
    set suite variable  ${location}


Find location with existing BW ID

   get into db  IMPERIAL
   ${bw_id_query}  catenate  SELECT location_id
   ...  FROM imperial_location_ref
   ...  WHERE esso_bw_id IS NOT NULL
   ...  AND location_id IN
   ...  (select location_id from location where loc_type = 'ESSO' and status = 'A')
   ${location_list_2}  Query And Strip To List  ${bw_id_query}
   ${existing_bw_location}  evaluate  random.choice(${location_list_2})  random
    set suite variable  ${existing_bw_location}


Delete BW value from DB under location
    [Arguments]  ${location}

    get into db  IMPERIAL
    Execute SQL String  dml=UPDATE imperial_location_ref SET esso_bw_id = NULL where location_id = ${location}











