*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager  ManageChildCarrier

Suite Setup    Setup for Parent Carrier with Carrier Group Tier Behavior permission
Test Teardown    Close Browser

*** Variables ***
${carrier}
${emanager}

*** Test Cases ***
Parent Carrier setting Fee Tier contract flag
    [Tags]  JIRA:FRNT-1837  qTest:54955793  JIRA:BOT-3650
    [Documentation]  Ensure a parent carrier has the ability to define fee tier flag as primary or secondary

    Log Carrier into eManager with Carrier Group Tier Behavior permission
    Go to Select Program > Manage Child Carrier > Carrier Group Tier Behavior
    Search all the child carriers
    Select and Save 'Fee' Tier Flag

Parent Carrier setting Discount Tier contract flag
    [Tags]  JIRA:FRNT-1837  qTest:54955798  JIRA:BOT-3650
    [Documentation]  Ensure a parent carrier has the ability to define discount tier flag as primary or secondary

    Log Carrier into eManager with Carrier Group Tier Behavior permission
    Go to Select Program > Manage Child Carrier > Carrier Group Tier Behavior
    Search all the child carriers
    Select and Save 'Discount' Tier Flag

*** Keywords ***
Setup for Parent Carrier with Carrier Group Tier Behavior permission
    [Documentation]  Keyword Setup for parent carrier with Carrier Group Tier Behavior permission

    Get Into DB  Mysql
    # Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${users}  Get From Dictionary  ${list}  user_id
    ${users}  Evaluate  ${users}.__str__().replace('[','(').replace(']',')')
    # Get parent carrier id
    ${query}  Catenate  SELECT member_id FROM member
    ...  WHERE mem_type='C'
    ...  AND status='A'
    ...  AND member_id IN ${users}
    ...  AND member_id IN (SELECT parent FROM carrier_group_xref)

    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable  ${carrier}

    Ensure Carrier has User Permission  ${carrier.id}  CARRIER_GROUP_TIER_BEHAVIOR

Log Carrier into eManager with Carrier Group Tier Behavior permission
    [Documentation]  Log carrier into eManager with Carrier Group Tier Behavior permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Manage Child Carrier > Carrier Group Tier Behavior
    [Documentation]  Go to Select Program > Manage Child Carrier > Carrier Group Tier Behavior

    Go To  ${emanager}/cards/CarrierGroupTierBehavior.action
    Wait Until Page Contains    Loading all child carriers may take a long time.

Search all the child carriers
    [Documentation]  Click the 'All' option and search child

    Click Element    //input[@value='ALL']
    Click Button    id=search

Select and Save '${type}' Tier Flag
    Select and Save '${type}' Tier Flag as 'Primary'
    Select and Save '${type}' Tier Flag as 'Secondary'

Select and Save '${type}' Tier Flag as '${value}'
    ${flagType}    Run Keyword If    '${type}'=='Discount'    Set Variable    Dis    ELSE    Set Variable    Fee
    ${lowerCaseFlagType}    Run Keyword If    '${type}'=='Discount'    Set Variable    dis    ELSE    Set Variable    fee
    ${flagTypeNumber}    Run Keyword If    '${type}'=='Discount'    Set Variable    2    ELSE    Set Variable    1

    # Get contract id from first row
    Wait Until Element is Visible    (//tr[@class='odd']/td[7])[1]
    ${contractId}    Get Text    (//tr[@class='odd']/td[7])[1]
    Set Test Variable    ${contractId}
    # Select flag value and save
    Select From List By Label    //select[@id="${lowerCaseFlagType}TierValueSel_0" and @contractid='${contractId}']    ${value}
    Click Button    //button[@id="addEdit${flagType}Tier" and @contractid='${contractId}']
    Wait Until Page Contains    Are you sure you want to set contract ${contractId} as ${value} for ${type} Tiers?
    Click Button    (//button[contains(text(), 'YES')])[${flagTypeNumber}]
    Wait Until Page Contains    Updated ${type} Tier Successfully!
    Click Element    id=legAlerts_popup_ok

    # Assert database
    Assert Tier Flag Value    ${type}    ${value}

Assert Tier Flag Value
    [Arguments]    ${type}=Fee    ${value}=Primary

    # Set contract meta type id
    ${contractMetaTypeId}    Run Keyword If    '${type}'=='Fee'    Set Variable    18    ELSE    Set Variable    19

    # Assert database flag value
    Get Into DB  TCH
    ${query}  Catenate  SELECT value FROM contract_meta WHERE contract_id='${contractId}' AND contract_meta_type_id = '${contractMetaTypeId}';
    ${list}  Query And Strip To Dictionary  ${query}
    ${flag}  Get From Dictionary  ${list}  value
    Should Be Equal as Strings    ${flag}    ${value[0]}