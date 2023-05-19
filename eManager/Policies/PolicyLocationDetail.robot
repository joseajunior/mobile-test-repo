*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

Suite Setup    Find Carrier  N
Suite Teardown  Close All Browsers

*** Test Cases ***

Add an Unauthorized Location
    [Tags]  JIRA:BOT-437  qTest:33066773  tier:0

    Login and get to Unauth location screen
    Click on Unauthorize Location Button
    Search for location
    Unauthorize the location
    Validate Add of Unathorized Location
    [Teardown]    Close Browser

Remove an Unauthorized Location
    [Tags]  JIRA:BOT-437  qTest:33068292  tier:0
    Login and get to Unauth location screen
    click element  xpath=//*[@name="deletecardAuthorize"]
    Handle Alert  action=ACCEPT
    Validate Removal of Unathorized Location
    [Teardown]    Close Browser


Validate Chain Id filtering
    [Tags]    JIRA:ROCKET-200  qTest:  PI:14
    [Setup]    Prepare for updating Company Attribute
    Add To Attribute to Company Header by Carrier  ${carrier.id}  Allowed Chain Ids  1,2,3,5-10
    Add To Attribute to Company Header by Carrier  ${carrier.id}  Blocked Chain Ids  1,2,3
    Login and get to Unauth location screen
    Click on Unauthorize Location Button
    Verify Chains are Filtered
    Rollback Company Attribute
    [Teardown]  Close Browser

Validate State Province Text change
    [Tags]    JIRA:ROCKET-376  PI:15  qTest:118813761
    [Setup]    Prepare for updating Company Attribute
    Add To Attribute to Company Header by Carrier  ${carrier.id}  Allowed Chain Ids  1,2,3,5-10
    Add To Attribute to Company Header by Carrier  ${carrier.id}  Blocked Chain Ids  1,2,3
    Login and get to Unauth location screen
    Click on Unauthorize Location Button
    page should contain  State/Province
    Verify Chains are Filtered
    Rollback Company Attribute
    [Teardown]  Close Browser

Add an Unauthorized Location for Fleet One
    [Tags]  JIRA:BOT-1133  qTest:28993595  Regression  JIRA:BOT-1943  tier:0
    [Setup]    Find Fleet One Carrier  N
    Login and get to Unauth location screen
    Click on Unauthorize Location Button
    Search for location
    Unauthorize the location
    Validate Add of Unathorized Location
    [Teardown]    Close Browser

Remove an Unauthorized Location for Fleet One
    [Tags]  JIRA:BOT-1133  qTest:28993595  Regression  JIRA:BOT-1943  tier:0
    [Setup]    Find Fleet One Carrier  N
    Login and get to Unauth location screen
    click element  xpath=//*[@name="deletecardAuthorize"]
    Handle Alert  action=ACCEPT
    Validate Removal of Unathorized Location
    [Teardown]    Close Browser

*** Keywords ***
Find Fleet One Carrier
    [Arguments]  ${tranUpdate}
    ${sql}  Catenate  select carrier_id from cards where carrier_id in (
    ...  select member_id from member
    ...  where mem_type = 'C'
    ...  and tran_update = '${tranUpdate}'
    ...  and status = 'A'
    ...  and carrier_type = 'FLT1')
    ...  and status = 'A'
    ...  limit 150
    ${memlist}  Query And Strip To Dictionary  ${sql}  db_instance=TCH
    ${memlist}  Get From Dictionary  ${memlist}  carrier_id
    ${memlist}  Evaluate  ${memlist}.__str__().replace('[','(').replace(']',')')
    ${sql}  Catenate  select user_id from sec_user where user_id in ${memlist} limit 1
    ${carrier.id}  Query And Strip  ${sql}  db_instance=mysql
    ${sql}  Catenate    select passwd from member where member_id = ${carrier.id}
    ${carrier.passwd}  Query And Strip  ${sql}  db_instance=tch
    ${validfltCard}  Find Card Variable    select * from cards where carrier_id = ${carrier.id} and status = 'A' and card_num not like '%OVER'  instance=tch
    Set test Variable    ${carrier.id}
    Set test Variable    ${carrier.passwd}
    ${locationsql}  Catenate  select location_id from location
    ...  where chain_id not in (select chain_id from def_Chains where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id not in (select location_id from def_locs where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  limit 1;
    ${location}  Query And Strip  ${locationsql}  db_instance=tch
    Set test Variable    ${location}


Find Carrier
    [Arguments]  ${tranUpdate}
    ${sql}  Catenate    select member_id from member where mem_type = 'C' and tran_update = '${tranUpdate}' and status = 'A' limit 150
    ${memlist}  Query And Strip To Dictionary  ${sql}  db_instance=TCH
    ${memlist}  Get From Dictionary  ${memlist}  member_id
    ${memlist}  Evaluate  ${memlist}.__str__().replace('[','(').replace(']',')')
    ${sql}  Catenate  select s.user_id from sec_user s, sec_company c
    ...  where s.company_id = c.company_id
    ...  and s.user_id in ${memlist}
    ...  and c.company_header = 'pnc_carrier'
    ...  limit 1
    ${carrier.id}  Query And Strip  ${sql}  db_instance=mysql
    ${sql}  Catenate    select passwd from member where member_id = ${carrier.id}
    ${carrier.passwd}  Query And Strip  ${sql}  db_instance=tch
    Set Suite Variable    ${carrier.id}
    Set Suite Variable    ${carrier.passwd}
    ${locationsql}  Catenate  select location_id from location
    ...  where chain_id not in (select chain_id from def_Chains where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id not in (select location_id from def_locs where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  limit 1;
    ${location}  Query And Strip  ${locationsql}  db_instance=tch
    Set Suite Variable    ${location}

Login and get to Unauth location screen
    Open Browser To EManager
    #need to find a carrier that is tran_update=N
    Log Into EManager  ${carrier.id}  ${carrier.passwd}  ChangeCompanyHeader=${False}

    Go To    ${emanager}/cards/PolicyLocationManagement.action?policy.policyNumber=1&sitePolicy=false
    Wait Until Page Contains    Policy Information

Click on Unauthorize Location Button
    Click Button    doCreatePolicyUnauthorize
    Wait Until Page Contains    Search Location Type

Search for location
    input text  xpath=//*[@name="id"]  ${location}
    click element  xpath=//*[@name="searchLocation"]
    Wait Until Page Contains    Authorized Locations

Unauthorize the location
    click element  xpath=//*[@name="authorizeIds"]
    click element  xpath=//*[@name="saveUnauthorizedLocations"]

Validate Add of Unathorized Location
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully removed location')]
    ${locationId}=  query and strip  select location_id from def_locs where location_id = '${location}' and carrier_id = ${carrier.id} and ipolicy = '1'  db_instance=tch
    should be equal as strings  ${locationId}  ${location}
    close browser

Validate Removal of Unathorized Location
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully removed location')]
    Get Into DB  tch
    row count is 0  select location_id from def_locs where location_id = '${location}' and carrier_id = ${carrier.id} and ipolicy = '1'  db_instance=tch
    close browser

Verify Chains are Filtered
    ${list}  Get List Items    chainId  values=${TRUE}
    Should Be Equal As Strings    ${list}  ['none', '5', '6', '7', '8', '9', '10']
