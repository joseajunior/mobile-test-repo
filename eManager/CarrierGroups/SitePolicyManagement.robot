*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags      eManager  SitePolicy  Policy

Test Teardown  End Test

*** Variables ***


*** Test Cases ***
JB Hunt 360
    [Documentation]  JB Hunt has a specific and unique permission allowing them to dictate
    ...  Site Policies for specific Child accounts belonging to them. Those accounts whose
    ...  site policies JB Hunt wishes to manage are enabled in the carrier_group_xref
    ...  table. This test verifies that eManager sets the enabled flag in the database.

    [Tags]  JIRA:BOT-874  JIRA:BOT-1947  refactor
    Ensure Member is Not Suspended  308385
    set test variable  ${DB}  TCH
    set test variable  ${parent}  308385  # JB Hunt Carrier ID
    set test variable  ${child}  308388
    get into db  ${DB}  ${ENVIRONMENT}
    log to console  \n

#    JB HUNT SHOULD HAVE THIS PERMISSION
    user should have permissions  ${parent}  USE_PARENT_SITE_POLICIES

    get into db  ${DB}  ${ENVIRONMENT}
#    OPEN eMANAGER
    ${validCard.carrier.password}  query and strip  SELECT TRIM(passwd) FROM member WHERE member_id = ${parent}
    Open eManager  ${parent}  ${validCard.carrier.password}

#    GO TO "Use Parent Site Policies"
    go to  ${emanager}/cards/UseParentSitePolicies.action

#    SEARCH BY CHILD CARRIER ID
    tch logging  SEARCHING FOR ${child}...
    click radio button  //*[text() = "Child Carrier ID"]/preceding-sibling::*[1]
    input text  searchTxt  ${child}
    click on  search

#    SELECT THE CHILD. VALUES SHOULD BE UPDATED IN THE DB ACCORDINGLY.
    select checkbox  //*[@* = "selChildIds" and @value="${child}"]
    tch logging  ${child} FOUND!
    click on  Save
    ${flag}=  query and strip  SELECT enforce_parent_site_policy FROM carrier_group_xref WHERE parent = ${parent} and carrier_id = ${child}
    should be equal as strings  ${flag}  Y  carrier_group_xref.enforce_parent_site_policy != 'Y' as expected.
    tch logging  enforce_parent_site_policy = 'Y' as expected

#    UNSELECT THE CHILD. VALUES SHOULD BE UPDATED IN THE DB ACCORDINGLY.
    unselect checkbox  //*[@* = "selChildIds" and @value="${child}"]
    click on  Save
    ${flag}=  query and strip  SELECT enforce_parent_site_policy FROM carrier_group_xref WHERE parent = ${parent} and carrier_id = ${child}
    should be equal as strings  ${flag}  ${SPACE}  carrier_group_xref.enforce_parent_site_policy != ' ' as expected.
    tch logging  enforce_parent_site_policy = ' ' as expected


*** Keywords ***
End Test

    disconnect from database