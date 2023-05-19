*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ssh.PySSH
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Suite Setup  Start Suite
Test Teardown  End Test

Force Tags  AM

*** Variables ***

*** Test Cases ***
Change Location Information
    [Tags]  JIRA:BOT-675  JIRA:BOT-1556  qTest:27260629  qTest:31750585  Regression  refactor
    [Documentation]  Change location information – Like address and verify changes were saved
    [Setup]  Run Keywords
    ...      Set Test Variable  ${user}  internRobot
    ...      AND  Set Test Variable  ${pass}  testing123
    ...      AND  Set Test Variable  ${business_partner}  EFS LLC
    ...      AND  Set Test Variable  ${location_id}  231010
    ...      AND  Set Test Variable  ${new_location_name}  I'M A ROBOT!
    ...      AND  Set Test Variable  ${expected_message}  Edit Successful
    ...      AND  Get Into DB  TCH
            ${original_location_name}  Query And Strip  SELECT name FROM location WHERE location_id = ${location_id}
    Open eManager  ${user}  ${pass}
    Go To  ${emanager}/acct-mgmt/RecordSearch.action
    click element  id=Location
    sleep  1
    refresh page
    wait until element is visible  name=location_id
    Select From List By Label  name=businessPartnerCode  ${business_partner}
    Input Text  name=location_id  ${location_id}
    Click On  text=Submit  exactMatch=False
    Click on  text=${location_id}
    wait until element is visible  //input[@name="detailRecord.name"]
    Input Text  //input[@name="detailRecord.name"]  ${new_location_name}
    Click on  id=submit

    #  Asserting Results
    Wait Until Element Is Visible  //li[text()='${expected_message}']  timeout=10
    ${location_name}  Query And Strip  SELECT name FROM location WHERE location_id = ${location_id}
    Should be Equal As Strings  ${location_name}  ${new_location_name}
    [Teardown]  Run Keywords
    ...  Get Into DB  TCH
    ...  AND  Execute SQL String  dml=UPDATE location SET name = '${original_location_name}' WHERE location_id = ${location_id}
    ...  AND  Disconnect From Database
    ...  AND  Close Browser

*** Keywords ***
Start Suite
    ${date}=  getdatetimenow  %Y%m%d
    ${date}=  get substring  ${date}  2
    ${time}=  getdatetimenow  %H%M%S
    set global variable  ${date}
    set global variable  ${time}

End Test
    disconnect from database