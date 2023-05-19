*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Force Tags  eManager

Test Teardown    Close Browser
Suite Teardown    Disconnect from Database

*** Variables ***
${carrier}

*** Test Cases ***
Secure Fuel Group Maintenanace
    [Documentation]  Secure Fuel Group Maintenanace in emanager
    [Tags]   JIRA:ATLAS-2394    JIRA:BOT-5082    qTest:120004284    Q1:2023
    [Setup]    Setup Carrier with Group Maintenance Hide Fields permission and Data

    Log into eManager with a Carrier
    Go to Select Program > SecureFuel > Group Maintenance
    Adding a New group in Secure Fuel
    Get 'Validation' as SecureFuel Validation
    Get 'Tank VAlidation' as Log Limit
    Enter the Required Value
    Save Add SecureFuel Group
    Check if New SecureFuel Information Load on Screen

*** Keywords ***
Setup Carrier with Group Maintenance Hide Fields permission and Data
    [Documentation]    Setup carrier with Group Maintenance and Group Maintenance Hide Fields permissions and having data

    Get Into DB    TCH
    ${carriers}    Query And Strip to Dictionary    SELECT DISTINCT carrier_id FROM unit_master LIMIT 100;
    ${carrier_ids}    Get From Dictionary    ${carriers}    carrier_id
    ${carrier_id}  Evaluate  random.choice(${carrier_ids})  random
    ${passwd}    Query And Strip    SELECT passwd FROM member WHERE member_id = '${carrier_id}';
    ${carrier}    Create Dictionary    id=${carrier_id}    password=${passwd}
    Set Test Variable    ${carrier}
    Ensure Carrier has User Permission  ${carrier.id}  SECURE_FUEL_GROUPS
    Ensure Carrier has User Permission  ${carrier.id}  SECURE_FUEL_GROUPS_HIDE_FIELDS

Log into eManager with a Carrier
    [Documentation]    Log into eManager with a Carrier

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > SecureFuel > Group Maintenance
    Hover Over  //*[@id="menubar_1x2"]
    Hover Over  //*[@id="TCHONLINE_SECUREFUELMAINx2"]
    Click Element   //*[@id="SECUREFUELMAIN_SECURE_FUEL_GROUPSx2"]

Adding a New group in Secure Fuel
    Click Element   //input[@name='addNew']

Get 'Validation' as SecureFuel Validation
    Click Element   //*[@id="positionVerifyId"]
    Select From List By Label   //*[@id="positionVerifyId"]   Validation

Get 'Tank VAlidation' as Log Limit
    Click Element   //*[@id="tankVerifyId"]
    Select From List By Label   //*[@id="tankVerifyId"]     Log Limit

Enter the Required Value
    Input Text  //*[@id="timeVarianceId"]   1
    Input Text  //*[@id="updateRecCntId"]   1
    Input Text  //*[@id="updateMaxMinId"]   1
    Input Text  //*[@id="speedToleranceId"]  1

Save Add SecureFuel Group
    Click Element   //input[@name='saveNew']

Check if New SecureFuel Information Load on Screen
    Wait Until Element Is Visible   //*[@id="row"]
    Get into db     TCH
    ${query}    Catenate    SELECT proximity_minimum,group_id,country_uom,description,speed_tolerance
    ...    FROM secure_fuel_group
    ...    WHERE carrier_id = '${carrier.id}'
    ...    ORDER BY group_id DESC
    ...    LIMIT 1;
    ${results}  Query and strip to dictionary   ${query}
    ${proximity_minimum}    Get from dictionary    ${results}    group_id
    ${proximity_minimum_UI}     Get text    (//a[contains(text(), 'Group ID')]//following::tbody//tr[last()]//td[1])[1]
    Should Be Equal As Strings   ${proximity_minimum}   ${proximity_minimum_UI}