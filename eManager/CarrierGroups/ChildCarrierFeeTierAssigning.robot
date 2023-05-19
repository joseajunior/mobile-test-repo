*** Settings ***
Library  otr_model_lib.Models
Library  String
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setup Carrier for Carrier Group Fee Tiers With Child Carriers
Test Teardown  Close Browser

Force Tags  eManager

*** Variables ***
${carrier}
${visible}
${message}
${fee_tier_description}    Tier 1
${child_carrier_id}
${fee_tier_desc}

*** Test Cases ***
Create New Fee Tier
    [Tags]   JIRA:BOT-161  JIRA:BOT-3584
    Log Carrier into eManager with Carrier Group Fee Tiers permission
    Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tiers
    Create Fee Tier
    Assert Fee Tier Creation on DB
    Delete Fee Tier

Carrier Group Fee Tiers Assignment
    [Tags]   JIRA:BOT-161  JIRA:BOT-3584

    Log Carrier into eManager with Carrier Group Fee Tiers permission
    Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tiers
    Create Fee Tier
    Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tier Assignment
    Search All Child Carriers
    Assign Fee Tier to Child Carrier
    Assert Fee Tier Assignment on DB

Delete Fee Tier
    [Tags]   JIRA:BOT-161  JIRA:BOT-3584

    Log Carrier into eManager with Carrier Group Fee Tiers permission
    Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tiers
    Create Fee Tier
    Delete Fee Tier
    Assert Fee Tier Exclusion on DB

Update fee tier from child carrier
    [Tags]  JIRA:FRNT-2033  JIRA:BOT-3657  qTest:55485746
    [Documentation]  Ensure a child carrier fee tier update reflects to database in Carrier Group Fee Tier Assignment

    Log Carrier into eManager with Carrier Group Fee Tiers permission
    Go to Select Program > Carrier Group Fee Tier Assignment
    Assign Fee Tier for Child Carrier With Added Change Type
    Assign Fee Tier for Child Carrier With Changed Change Type
    Fee Tier Assignment not Available for Child Carrier With Deleted Change Type

*** Keywords ***
Setup Carrier for Carrier Group Fee Tiers With Child Carriers
    [Documentation]  Keyword Setup for Carrier Group Fee Tiers with child carriers

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND status_id = 'A'
    ...    AND surx.user_id in (SELECT user_id FROM sec_user_role_xref WHERE role_id = 'CARRIER_GROUP_FEE_TIERS' AND menu_visible=1)
    ...    AND surx.user_id in (SELECT user_id FROM sec_user_role_xref WHERE role_id = 'CARRIER_GROUP_FEE_TIER_ASSIGNMENT' AND menu_visible=1)
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')

    Get Into DB  TCH
    ${added_list}    Get Parent Carrier By Given Change Type    A
    ${changed_list}    Get Parent Carrier By Given Change Type    C
    ${deleted_list}    Get Parent Carrier By Given Change Type    D

    ${carrier_query}  Catenate  SELECT member_id
    ...    FROM member m
    ...    INNER JOIN carrier_group_fee_tiers ct
    ...    ON m.member_id = ct.parent_id
    ...    INNER JOIN carrier_group_fee_tier_assignment ca
    ...    ON ca.tier_id = ct.tier_id
    ...    WHERE ct.parent_id IN ${carrierList}
    ...    AND ct.parent_id IN ${added_list}
    ...    AND ct.parent_id IN ${changed_list}
    ...    AND ct.parent_id IN ${deleted_list}
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Get Parent Carrier By Given Change Type
    [Arguments]    ${change_type}
    [Documentation]  Get parent carrier wit child carrier with a given change type assignment: A, C or D

    ${list_query}  Catenate  SELECT DISTINCT parent_id
    ...    FROM carrier_group_fee_tier_assignment ca
    ...    INNER JOIN carrier_group_fee_tiers ct
    ...    ON ca.tier_id = ct.tier_id
    ...    WHERE ca.change_type = '${change_type}';
    ${query_result}  Query And Strip To Dictionary  ${list_query}
    ${list}  Get From Dictionary  ${query_result}  parent_id
    ${list}  Evaluate  ${list}.__str__().replace('[','(').replace(']',')')
    [Return]    ${list}

Get Child Carrier By Change Type
    [Arguments]    ${status}=A
    [Documentation]  Get child carrier from parent carrier with given change type

    ${child_carrier_list_query}  Catenate  SELECT child_carrier_id
    ...    FROM carrier_group_fee_tier_assignment ca
    ...    INNER JOIN carrier_group_fee_tiers ct
    ...    ON ca.tier_id = ct.tier_id
    ...    WHERE parent_id = '${carrier.id}'
    ...    AND ca.change_type = '${status}';
    ${child_carrier_id}  Query And Strip  ${child_carrier_list_query}
    Set Test Variable    ${child_carrier_id}

Log Carrier into eManager with Carrier Group Fee Tiers permission
    [Documentation]  Log carrier into eManager with Carrier Group Fee Tiers permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tiers
    [Documentation]  Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tiers

    Go To  ${emanager}/cards/CarrierGroupFeeTiers.action
    Wait Until Page Contains    Carrier Group Fee Tiers

Go to Select Program > Carrier Group Fee Tier Assignment
    [Documentation]  Go to Select Program > Carrier Group Fee Tier Assignment

    Go To  ${emanager}/cards/CarrierGroupFeeTierAssignment.action
    Wait Until Page Contains    Loading all child carriers may take a long time.

Get Recent Tiers
    Click Element    //a[text()="Last Updated"]
    Wait Until Element is Visible    (//input[@name="editTiers"])[1]
    Click Element    //a[text()="Last Updated"]

Create Fee Tier
    [Documentation]  Create a new fee tier on Carrier Group Fee Tiers

    ${fee_tier_description}    Generate Random String    8
    Set Test Variable    ${fee_tier_description}
    #Check if Create New Fee Tiers box is available
    ${visible}  Run Keyword And Return Status    Element Should Be Visible   name=add
    Run Keyword If    not ${visible}    Click Button    name=creatNew
    #Input new fee tier description
    Input Text  //*[@for="carrierGroupFeeTiers.jsp.legend.new"]/parent::*/parent::*//input  ${fee_tier_description}
    Click Button  name=add
    #Check if new fee tier was created successfully
    ${message}    Get Text    //*[@class='messages']/li
    Should be Equal as Strings    ${message}    You have successfully added the fee tiers of (${fee_tier_description}).
    Get Recent Tiers
    Page Should Contain Element    //*[@id="row"]//td[contains(text(), '${fee_tier_description}')]

Assert Fee Tier Creation on DB
    [Documentation]  Assert fee tier was created on database

    Get Into DB  TCH
    Row Count is Equal to X  SELECT * FROM carrier_group_fee_tiers WHERE tier_description='${fee_tier_description}' AND parent_id='${carrier.id}'  1

Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tier Assignment
    [Documentation]  Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tier Assignment

    Go To  ${emanager}/cards/CarrierGroupFeeTierAssignment.action
    Wait Until Page Contains    Carrier Group Fee Tiers Assignment

Delete Fee Tier
    [Documentation]  Delete a fee tier on Carrier Group Fee Tiers

    Click Element  //input[@name='removeTiers' and @onclick="return handleMesssage('Are you sure you wish to delete the tier','${fee_tier_description}');"]
    Handle Alert
    #Check if new fee tier was deleted successfully
    ${message}    Get Text    //*[@class='messages']/li
    Should be Equal as Strings    ${message}    You have successfully deleted the fee tiers of (${fee_tier_description}).
    Page Should Not Contain Element    //*[@id="row"]//td[contains(text(), '${fee_tier_description}')]

Assert Fee Tier Exclusion on DB
    [Documentation]  Assert fee tier was deleted on database

    Get Into DB  TCH
    Row Count is Equal to X  SELECT * FROM carrier_group_fee_tiers WHERE tier_description='${fee_tier_description}' AND parent_id='${carrier.id}'  0

Search All Child Carriers
    [Documentation]  Select 'All' and search child carriers

    Click Element  //input[@value='ALL' and @type='radio']
    Click Button  name=search
    Wait Until Page Contains    Please click text box to select tiers.

Search for Child Carrier Id
    [Arguments]    ${child_carrier_id}
    [Documentation]  Select 'Carrier ID' and search for a child carrier id

    Click Element  //input[@value='ID' and @type='radio']
    Input Text    name=searchTxt    ${child_carrier_id}
    Click Button  name=search
    Wait Until Page Contains    Please click text box to select tiers.

Assign Fee Tier for Child Carrier With Added Change Type
    [Documentation]  Assign fee tier to child carrier with added change type

    Get Child Carrier By Change Type    A
    Search for Child Carrier Id    ${child_carrier_id}
    Assign Fee Tier to Child Carrier With Specific Change Type
    Assert Fee Tier Assignment on DB

Assign Fee Tier for Child Carrier With Changed Change Type
    [Documentation]  Assign fee tier to child carrier with changed change type

    Get Child Carrier By Change Type    C
    Search for Child Carrier Id    ${child_carrier_id}
    Assign Fee Tier to Child Carrier With Specific Change Type    Changed
    Assert Fee Tier Assignment on DB

Fee Tier Assignment not Available for Child Carrier With Deleted Change Type
    [Documentation]  Ensure fee tier assignment is not available for child carrier with deleted change type

    Get Child Carrier By Change Type    D
    Search for Child Carrier Id    ${child_carrier_id}
    Double Click Element  //*[contains(text(), 'Deleted')]/parent::td/parent::tr//div
    Sleep    5
    Page Should Not Contain Element      //*[contains(text(), 'Deleted')]/parent::td/parent::tr//select

Assign Fee Tier to Child Carrier
    [Documentation]  Assign fee tier to child carrier

    ${change_type}    Set Variable    Deleted
    ${index}    Set Variable    0
    FOR    ${index}    IN RANGE    9999
        ${index}    Evaluate    ${index}+1
        ${change_type}    Get Text    //*[@id="row"]/tbody/tr[${index}]/td[7]
        Exit For Loop If    '${change_type}'!='Deleted'
    END
    #Assign created fee tier
    Double Click Element  //*[@id="row"]/tbody/tr[${index}]/td[1]/div
    Wait Until Element is Visible      //*[@id="row"]/tbody/tr[${index}]/td[1]/div/select
    Select From List By Label    //*[@id="row"]/tbody/tr[${index}]/td[1]/div/select    ${fee_tier_description}
    ${child_carrier_id}    Get Text    //*[@id="row"]/tbody/tr[${index}]/td[2]
    Set Test Variable    ${child_carrier_id}
    Click Button  name=submitTiers
    #Check if new fee tier was assigned successfully
    Page Should Contain    You have successfully assigned tiers.

Assign Fee Tier to Child Carrier With Specific Change Type
    [Arguments]    ${status}=Added
    [Documentation]  Assign fee tier to child carrier with change type Added or Changed

    #Assign created fee tier
    Double Click Element  //*[contains(text(), '${status}')]/parent::tr//div
    Wait Until Element is Visible      //*[contains(text(), '${status}')]/parent::tr//select
    Select From List By Label    //*[contains(text(), '${status}')]/parent::tr//select    ${fee_tier_description}
    Click Button  name=submitTiers
    #Check if new fee tier was assigned successfully
    Page Should Contain    You have successfully assigned tiers.

Assert Fee Tier Assignment on DB
    [Documentation]  Assert fee tier was assigned on database

    Get Into DB  TCH
    ${assignment_query}  Catenate  SELECT *
    ...    FROM carrier_group_fee_tier_assignment
    ...    WHERE child_carrier_id='${child_carrier_id}'
    ...    AND tier_id in
    ...    (SELECT tier_id
    ...    FROM carrier_group_fee_tiers
    ...    WHERE tier_description='${fee_tier_description}'
    ...    AND parent_id='${carrier.id}');
    Row Count is Equal to X  ${assignment_query}  1