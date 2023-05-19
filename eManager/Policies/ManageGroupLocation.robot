*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  otr_robot_lib.ws.CardManagementWS
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

*** Variables ***
${carrier}
${element}
${group_name}
${group_status}
${location_status}
${permission_status}

*** Test Cases ***
Manage Group Location - Check Address and Post Code
    [Tags]  JIRA:FRNT-736  qTest:43977010  JIRA:BOT-2479
    [Documentation]  This test case is for checking if address and post code are displaying on Manage Group Location screen.
    [Setup]  Setup for FRNT-736

    Log into eManager with a Carrier that have Location Group Permission.
    Navigate to Select Program > Manage Policies > Manage Group Location.
    Select the Blue Plus Sign in the Add/Edit Location ID.
    Perform a Search to Return the Locations to a Grid.
    The Address 1 And Postal Code Should be Displayed on the Grid that Shows Locations that are Unauthorized.
    The Address 1 And Postal Code Should be Displayed on the Grid that Shows Locations that are Authorized.

    [Teardown]  Teardown for FRNT-736

*** Keywords ***
Setup for FRNT-736
    [Documentation]  Keyword Setup for FRNT-736
#
    Get Into DB  Mysql

#Get user_id with desired permission to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user_role_xref WHERE role_id='MANAGE_GROUP_LOC' AND menu_visible='1' AND user_id REGEXP '^[0-9]+$' LIMIT 20;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT member_id FROM member WHERE mem_type='C' AND status='A' AND carrier_type='TCH' AND member_id IN ${list_2};
    ${carrier}  Find Carrier Variable  ${query}  member_id

#    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_GROUP_LOC
    Set Test Variable  ${carrier}

Teardown for FRNT-736
    [Documentation]  Keyword Teardown for FRNT-736

    Run Keyword If  '${group_status}'=='False'
    ...  Remove a Group Location on eManager Screen  ${group_name}
    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  MANAGE_GROUP_LOC
    Close Browser

Log into eManager with a Carrier that have Location Group Permission.
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Manage Policies > Manage Group Location.
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/ManageGroupLocation.action

Select the Blue Plus Sign in the Add/Edit Location ID.
    [Documentation]  Click on Blue Plus Sing if doesn't exist create a new group and then click on Blue Plus Sing
#
    ${group_status}  Run Keyword and Return Status  Element Should be Visible  //input[@id='addLocationIds' and @value=1]
    Run Keyword If  '${group_status}'=='True'
    ...  Click Element  //input[@id='addLocationIds' and @value=1]
    ...  ELSE  Create a Group Location on eManager Screen

    Set Test Variable  ${group_status}

Create a Group Location on eManager Screen
    [Documentation]  Keyword for create a group location
#
    ${random}  Generate Random String  4
    ${group_name}  Catenate  FRNT-736 ${random}
    Input Text  //input[@name='groupName']  ${group_name}
    Click Element  //input[@name='createLocName']
    Click Element  //input[@id='addLocationIds' and @value=1]

    Set Test Variable  ${group_name}

Remove a Group Location on eManager Screen
    [Arguments]  ${group_name}

    Go To  ${emanager}/cards/ManageGroupLocation.action
    Click Element  //table[@id='row']/tbody/tr/td[count(//table[@id='row']/thead//th[text()='Group Name']/preceding-sibling::th)+1][text()='${group_name}']//parent::tr//input[@name="delete"]
    Click Element  //span[contains(text(),'Yes')]
    Wait Until Element is Visible  //li[contains(text(),'Group Name Deleted')]

Perform a Search to Return the Locations to a Grid.
    [Documentation]  Search one location on Manage Group Location Screen

    Input Text  //input[@name='id']  ${validLoc}
    Click Element  //input[@name='searchLocation']

The Address 1 And Postal Code Should be Displayed on the Grid that Shows Locations that are Unauthorized.
    [Documentation]  Search for desired fields and validate it with database
#
    ${address}  Search Element in Group Location Table  Unauthorized  ${validLoc}  Address 1
    Validate Group Location Screen Element with Database  address_1  ${address}

    Run Keyword If  '${location_status}'=='False'
    ...  Authorize Location in Group Location on eManager  ${validLoc}

    ${post_code}  Search Element in Group Location Table  Unauthorized  ${validLoc}  Post Code
    Validate Group Location Screen Element with Database  zip  ${post_code}

    Run Keyword If  '${location_status}'=='False'
    ...  Authorize Location in Group Location on eManager  ${validLoc}

The Address 1 And Postal Code Should be Displayed on the Grid that Shows Locations that are Authorized.
    [Documentation]  Search for desired fields and validate it with database
#
    ${address}  Search Element in Group Location Table  Authorized  ${validLoc}  Address 1
    Validate Group Location Screen Element with Database  address_1  ${address}

    Run Keyword If  '${location_status}'=='False'
    ...  Unauthorize Location in Group Location on eManager  ${validLoc}

    ${post_code}  Search Element in Group Location Table  Authorized  ${validLoc}  Post Code
    Validate Group Location Screen Element with Database  zip  ${post_code}

    Run Keyword If  '${location_status}'=='False'
    ...  Unauthorize Location in Group Location on eManager  ${validLoc}

Search Element in Group Location Table
    [Arguments]  ${table}  ${location}  ${column_name}

    ${table_name}  Set Variable If  '${table}'=='Unauthorized'  row1  row2

    ${location_element}  Catenate  //table[@id='${table_name}']//input[@type='checkbox' and @value='${location}']

    ${location_status}  Run Keyword and Return Status
    ...  Wait Until Element is Visible  ${location_element}

    Run Keyword If  '${table}'=='Unauthorized' and '${location_status}'=='False'
    ...  Unauthorize Location in Group Location on eManager  ${location}

    Run Keyword If  '${table}'=='Authorized' and '${location_status}'=='False'
    ...  Authorize Location in Group Location on eManager  ${location}

    ${element}  Get Info From Location  ${table_name}  ${location}  ${column_name}

    Set Test Variable  ${location_status}

    [Return]  ${element}

Get Info From Location
    [Arguments]  ${table_name}  ${location_id}  ${column_name}  ${location_id_header}=Location ID

    ${column_index}  Get Column By Name  ${column_name}  ${table_name}
    ${location_id_index}  Get Column By Name  ${location_id_header}  ${table_name}
    ${data}  Get Text  //table[@id='${table_name}']/tbody/tr/td[${location_id_index}][text()='${location_id}']/parent::tr/td[${column_index}]

    [Return]  ${data}

Get Column By Name
    [Arguments]  ${column_name}  ${table_name}
    ${index}  Get Element Count  //table[@id='${table_name}']/thead//th[text()='${column_name}']/preceding-sibling::th
    [Return]  ${index}+1

Validate Group Location Screen Element with Database
    [Arguments]  ${element}  ${value}

    Get Into DB  TCH
    Row Count Is Equal to X  SELECT * FROM location WHERE location_id=${validLoc} AND ${element}='${value}';  1

Unauthorize Location in Group Location on eManager
    [Arguments]  ${location}

    Select Checkbox  //input[@type='checkbox' and @value='${location}']
    Click Element  //input[@name='removeUnauthorizedLocations']

Authorize Location in Group Location on eManager
    [Arguments]  ${location}

    Select Checkbox  //input[@type='checkbox' and @value='${location}']
    Click Element  //input[@name='saveUnauthorizedLocations']