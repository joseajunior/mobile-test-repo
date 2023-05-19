*** Settings ***
Library  otr_model_lib.Models
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown  Close Browser

Force Tags  eManager  Reports

*** Variables ***
${carrier}

*** Test Cases ***
Build Custom Transaction Report - Restricted chain displayed for CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747426  JIRA:BOT-3647  tag
    [Documentation]  Ensure restricted locations are displayed for CT7 carriers in Build Custom Transaction Report

	Setup 'a' CT7 Carrier with Build Custom Transaction Report Permission
	Log Carrier into eManager with Build Custom Transaction Report permission
	Go to Select Program > Reports/Exports > Build Custom Transaction Report
	Check the main screen chain id dropdown 'has' CT7 carrier chain id
	Select the Location ID and go to Look Up Location section
	Check the chain id dropdown 'has' CT7 carrier chain id
	Check the search results 'has' CT7 carrier location id

Build Custom Transaction Report - Restricted chain not displayed for non CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747422  JIRA:BOT-3647    tag
    [Documentation]  Ensure restricted locations are not displayed for non CT7 carriers in Build  Transaction Report

	Setup 'non' CT7 Carrier with Build Custom Transaction Report Permission
	Log Carrier into eManager with Build Custom Transaction Report permission
	Go to Select Program > Reports/Exports > Build Custom Transaction Report
	Check the main screen chain id dropdown 'has no' CT7 carrier chain id
	Select the Location ID and go to Look Up Location section
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Check the search results 'has no' CT7 carrier location id

*** Keywords ***
Setup '${condition}' CT7 Carrier with Build Custom Transaction Report Permission
    [Documentation]  Setup for a/non CT7 carrier with Build Custom Transaction Report permission

    Get Into DB  Mysql
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 150;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')
    # Build query to get a/non CT7 carrier
    ${CT7Carrier}  Run Keyword If    '${condition}' == 'non'    Set Variable    not in    ELSE    Set Variable    in
    ${query}  Catenate  SELECT member_id FROM member m
    ...  JOIN contract c
    ...  ON m.member_id = c.carrier_id
    ...  WHERE m.mem_type='C'
    ...  AND m.status='A'
    ...  AND m.member_id ${CT7Carrier} (SELECT carrier_id FROM contract WHERE issuer_id in (194148, 194149))
    ...  AND m.member_id IN ${list_2}
    ...  AND m.member_id NOT IN ('381776');
    # Find carrier with given query and set as suite variable
    ${carrier}  Find Carrier Variable  ${query}  member_id
    Set Suite Variable  ${carrier}
    # Ensure carrier has Build Custom Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  BUILD_CUSTOM_TRANS_REPORT

Log Carrier into eManager with Build Custom Transaction Report permission
    [Documentation]  Log carrier into eManager with Build Custom Transaction Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Reports/Exports > Build Custom Transaction Report
    [Documentation]  Go to Select Program > Reports/Exports > Build Custom Transaction Report

    Go To  ${emanager}/cards/BuildCustomTransReport.action
    Wait Until Page Contains    Build New Transaction Report
    Select 'Hide / Show Match By Optional Information'
    Wait Until Page Contains    Notes: Multiple selections can be made by holding down the control key.

Select 'Hide / Show Match By Optional Information'
    Select Checkbox    name=matchByCk

Select 'Location ID'
    Select Checkbox    name=runParams.locationIds.selected

Select the Location ID and go to Look Up Location section
    Select 'Location ID'
    Wait Until Page Contains  Loading all Locations may take a long time.

Check the CT7 carrier chain id
    [Arguments]    ${condition}    ${chainIds}
    Run Keyword If    '${condition}' == 'has'    List Should Contain Value    ${chainIds}    101 - WEX NAF C STORES
    ...  ELSE    List Should Not Contain Value    ${chainIds}    101 - WEX NAF C STORES

Check the main screen chain id dropdown '${condition}' CT7 carrier chain id
    ${chainIds}    Get List Items    //select[@name="runParams.chainIds.values"]
    Check the CT7 carrier chain id    ${condition}    ${chainIds}

Check the chain id dropdown '${condition}' CT7 carrier chain id
    ${chainIds}    Get List Items    //select[@name='chainId']
    Check the CT7 carrier chain id    ${condition}    ${chainIds}

Check the search results '${condition}' CT7 carrier location id
    Get Into DB  TCH
    # Get chaind id 101 location id
    ${nonCT7query}  Catenate  SELECT location_id FROM location WHERE chain_id = '101';
    ${CT7query}  Catenate  SELECT il.location_id
    ...    FROM issr_loc il
    ...    INNER JOIN contract c
    ...    ON il.issuer_id = c.issuer_id
    ...    WHERE c.carrier_id = '${carrier.id}'
    ...    AND il.location_id
    ...    IN (SELECT location_id FROM location WHERE chain_id = '101')
    ...    ORDER BY location_id DESC;
    ${locationId}    Run Keyword If    '${condition}'=='has'    Query And Strip    ${CT7query}
    ...    ELSE    Query And Strip    ${nonCT7query}
    Input Text    name=id    ${locationId}
    Click Button    id=doSearch
    Run Keyword If    '${condition}'=='has'    Wait Until Element is Visible    //td[contains(text(), '${locationId}')]
    ...    ELSE    Wait Until Page Contains    No data available in table