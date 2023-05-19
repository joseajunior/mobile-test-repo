*** Settings ***
Library  otr_model_lib.Models
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Run Keywords
...    Setup Carrier for Enhanced Transaction Report    AND
...    Setup Optional Information Match Keys
Test Teardown    Close Browser
Suite Teardown    Disconnect From Database

Force Tags  eManager  Reports

*** Variables ***
${carrier}
${options_checkbox}
${options_dropdown}
${infoid_list}
${options_list}
${policy}
${cardnum}
${option_data}
${infoid}

*** Test Cases ***
# ROCKET-212 - Greg Parkin 6-23-2022
Check that ipolicy is not negative one for Enhanced Transaction Report
    [Tags]    JIRA:ROCKET-212  qTest:55905522
    [Documentation]    This Test case validates the ipolicy does not contrain a -1
    ...     by producing an Exception Report

    Search for carrier with -1 policy  TRN_REPORT
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Open 'Policy' List from Match By Optional Information
    Verify policy list does not contain -1

Check Match By Optional Information Data for 'Policy' checkbox list
    [Tags]    JIRA:BOT-3586  qTest: 55905577    refactor
    [Documentation]  This test case insures the Policy checkbox is displayed when trying
    ...     to display an Enhanced Transaction Report

    Log Carrier into eManager with Enhanced Transaction Report permission
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Open 'Policy' List from Match By Optional Information
    Assert Policy List Options

Check Match By Optional Information Data for 'Card Number' checkbox list
    [Tags]    JIRA:BOT-3586  qTest: 55905577    refactor
    [Documentation]  This test case insures the Card Number checkbox is displayed when trying
    ...     to display an Enhanced Transaction Report

    Log Carrier into eManager with Enhanced Transaction Report permission
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Open 'Card Number' List from Match By Optional Information
    Assert Card Number List Options

Check Match By Optional Information Data for 'Cardholder' checkbox list
    [Tags]    JIRA:BOT-3586  qTest: 55905577    refactor
    [Documentation]  This test case insures the Cardholder checkbox is displayed when trying
    ...     to display an Enhanced Transaction Report

    Log Carrier into eManager with Enhanced Transaction Report permission
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Open 'Cardholder' List from Match By Optional Information
    Assert 'Cardholder' List Options

Check Match By Optional Information Data for 'Driver ID' checkbox list
    [Tags]    JIRA:BOT-3586  qTest: 55905577
    [Documentation]  This test case insures the Driver ID checkbox is displayed when trying
    ...     to display an Enhanced Transaction Report

    Log Carrier into eManager with Enhanced Transaction Report permission
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Open 'Driver ID' List from Match By Optional Information
    Assert 'Driver ID' List Options

Check Match By Optional Information Data for 'Unit' checkbox list
    [Tags]    JIRA:BOT-3586  qTest: 55905577
    [Documentation]  This test case insures the Unit checkbox is displayed when trying
    ...     to display an Enhanced Transaction Report

    Log Carrier into eManager with Enhanced Transaction Report permission
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Open 'Unit' List from Match By Optional Information
    Assert 'Unit' List Options

Check Match By Optional Information Data for 'Sub Fleet' checkbox list
    [Tags]    JIRA:BOT-3586  qTest: 55905577
    [Documentation]  This test case insures the Sub Fleet checkbox is displayed when trying
    ...     to display an Enhanced Transaction Report

    Log Carrier into eManager with Enhanced Transaction Report permission
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Open 'Sub Fleet' List from Match By Optional Information
    Assert 'Sub Fleet' List Options

Enhanced Transaction Report - Restricted chain displayed for CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747405  JIRA:BOT-3647    refactor
    [Documentation]  Ensure restricted locations are displayed for CT7 carriers in Enhanced Transaction Report

	Setup 'a' CT7 Carrier with Enhanced Transaction Report Permission
	Log Carrier into eManager with Enhanced Transaction Report permission
	Go to Select Program > Reports/Exports > Enhanced Transaction Report
	Check the main screen chain id dropdown 'has' CT7 carrier chain id
	Go to Look Up Location Tool
	Check the chain id dropdown 'has' CT7 carrier chain id
	Check the search results 'has' CT7 carrier location id

Enhanced Transaction Report - Restricted chain not displayed for non CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747404  JIRA:BOT-3647    refactor
    [Documentation]  Ensure restricted locations are not displayed for non CT7 carriers in Enhanced Transaction Report

	Setup 'non' CT7 Carrier with Enhanced Transaction Report Permission
	Log Carrier into eManager with Enhanced Transaction Report permission
	Go to Select Program > Reports/Exports > Enhanced Transaction Report
	Check the main screen chain id dropdown 'has no' CT7 carrier chain id
	Go to Look Up Location Tool
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Check the search results 'has no' CT7 carrier location id

Exception Transaction Report - Verify Count query is in timeline order
    [Tags]  JIRA:Rocket-218  qTest:56155997  run    refactor
    [Documentation]  Ensure Exception Transaction Reports show count query is in timeline order

    Set Up A Carrier for Test  TCH
	Go to Select Program > Reports/Exports > Exception Report
	Select Date Range for Exception Report and Set up Refreshing Transaction Counts
	${filepath}  Download Report File for Test  ExceptionReport  xlsx
	Check if File is Dowloaded  ExceptionReport  xlsx
	Get Values From Excel Rows  ${filepath}

Update Enhanced Transaction Report for display dynamic prompting
    [Tags]    Q1:2023    JIRA:ATLAS-2338    JIRA:BOT-5073    qTest:119598365
    [Documentation]    Enhanced Transaction Report needs to be updated to show whether a transaction was a dynamic
    ...    prompt transaction or not
    [Setup]    Setup Carrier with Transaction having Dynamic Prompt

    Log Carrier into eManager with Enhanced Transaction Report permission
    Go to Select Program > Reports/Exports > Enhanced Transaction Report
    Set Start and End Date for Transaction
    Select 'PDF' format
    Open 'Selected Columns' tab
    Add Control Number, Unit, Trip Number and Driver ID prompts in Selected Columns
    Run Enhanced Transaction Report in 'pdf' and download it
    Ensure Report has DYNAMIC prompt information

    [Teardown]    Run Keywords    Close Browser    Remove Enhanced Transaction Report

*** Keywords ***
Setup Carrier for Enhanced Transaction Report
    [Documentation]  Keyword Setup for Enhanced Transaction Report

    Get Into DB  MySQL
    # Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND surx.role_id='TRN_REPORT'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND member_id IN ${carrier_list}
    ...  AND member_id NOT IN ('121841', '103866', '600212')
    ...  and verify != 4
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}
    Ensure Carrier has User Permission  ${carrier.id}  EXCEPTION_REPORT

Setup Optional Information Match Keys
    [Documentation]  Keyword Setup for options in match by optional information

    ${options_checkbox}    Create Dictionary    Policy=policyCk    Card Number=cardNumberCk    Cardholder=cardHolderCk    Driver ID=dirverIdCk    Unit=unitCk    Sub Fleet=subFleetCk
    Set Suite Variable    ${options_checkbox}
    ${options_dropdown}    Create Dictionary    Policy=policyTextSel    Card Number=cardNumberTextSel    Cardholder=cardHolderTextSel    Driver ID=driverIdTextSel    Unit=unitTextSel    Sub Fleet=subFleetTextSel
    Set Suite Variable    ${options_dropdown}
    ${infoid_list}    Create Dictionary    Cardholder=NAME    Driver ID=DRID    Unit=UNIT    Sub Fleet=SSUB
    Set Suite Variable    ${infoid_list}
    ${options_list}    Create Dictionary    Cardholder=cardHolderSel    Driver ID=dirverIdSel    Unit=unitSel    Sub Fleet=subFleetSel
    Set Suite Variable    ${options_list}

Setup '${condition}' CT7 Carrier with Enhanced Transaction Report Permission
    [Documentation]  Setup for a/non CT7 carrier with Enhanced Transaction Report permission

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
    # Ensure carrier has Enhanced Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  TRN_REPORT
    # Ensure carrier has Exception Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  EXCEPTION_REPORT

Setup Carrier with Transaction having Dynamic Prompt
    [Documentation]    Get a carrier and its password that has a transaction with dynamic prompt saving also the
    ...    transaction date

    Get into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM transaction
    ...    WHERE trans_id IN
    ...    (SELECT trans_id FROM trans_meta
    ...    WHERE trans_meta_type_id = 'DYNAMIC_PROMPT')
    ...    ORDER BY trans_date DESC
    ...    LIMIT 1;
    ${result}    Query And Strip to Dictionary    ${query}
    ${carrier_id}    Get From Dictionary    ${result}    carrier_id
    ${trans_date}    Get From Dictionary    ${result}    trans_date
    ${trans_date}    Convert To String    ${trans_date}
    ${trans_date}    Get Substring    ${trans_date}    0    10
    ${query}    Catenate    SELECT passwd FROM member WHERE member_id = '${carrier_id}';
    ${passwd}    Query And Strip    ${query}
    ${carrier}    Create Dictionary    id=${carrier_id}    password=${passwd}    transdate=${trans_date}
    Set Test Variable    ${carrier}
    Ensure Carrier has Enhanced Transaction Report permission

Ensure Carrier has Enhanced Transaction Report permission
    [Documentation]    Add Enhanced Transaction Report permission to carrier

    Ensure Carrier has User Permission  ${carrier.id}    TRN_REPORT

Log Carrier into eManager with Enhanced Transaction Report permission
    [Documentation]  Log carrier into eManager with Enhanced Transaction Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

# ROCKET-212 - Greg Parkin 6-23-2022
Go to Select Program > Reports/Exports > Enhanced Transaction Report
    [Documentation]  Go to Select Program > Reports/Exports > Enhanced Transaction Report

    Go To  ${emanager}/trn/TRNReport.action
    Wait Until Page Contains    Enhanced Transaction Report

# ROCKET-212 - Greg Parkin 6-23-2022
Go to Select Program > Reports/Exports > Exception Report
    [Documentation]  Go to Select Program > Reports/Exports > Exception Report

    Go To  ${emanager}/trn/TRNReport.action
    Wait Until Page Contains    Exception Report

# ROCKET-212 - Greg Parkin 6-23-2022
Go to Select Program > Reports/Exports > Transaction Report New
    [Documentation]  Go to Select Program > Reports/Exports > Transaction Report New

    Go To  ${emanager}/trn/TRNReport.action
    Wait Until Page Contains    Transaction Report New

Select Program > Reports/Exports > Transaction Report New
    [Documentation]  Select Program > Reports/Exports > Transaction Report New

    Go To  ${emanager}/trn/TRNReport.action
    Wait Until Page Contains    Transaction Report New

Open '${option}' List from Match By Optional Information
    [Documentation]  Select 'Hide/Show Match By Optional Information' checkbox, then option checkbox and its list option

    Select 'Hide / Show Match By Optional Information'
    ${option_checkbox}    Get From Dictionary    ${options_checkbox}    ${option}
    Select Checkbox    ${option_checkbox}
    ${option_dropdown}    Get From Dictionary    ${options_dropdown}    ${option}
    Select From List By Label    ${option_dropdown}    List

# ROCKET-212 - Greg Parkin 6-23-2022
Verify policy list does not contain -1
    [Documentation]  Check policy list options with db data

    #Get policies from eManager list
    Wait Until Element Is Not Visible    id=statusText
    @{expected_policy_list}    Get List Items    policySel
    List Should Not Contain Value  ${expected_policy_list}  -1

# ROCKET-212 - Greg Parkin 6-23-2022
Search for carrier with -1 policy
    [Arguments]  ${permission}

    ${carrier_id}  query and strip  select id from def_card where ipolicy = -1 limit 1;  db_instance=tch
    set test variable  ${carrier_id}
    Open eManager  ${intern}  ${internPassword}
    Ensure Carrier has User Permission  ${carrier_id}  ${permission}
    Switch to "${carrier_id}" User

Assert Policy List Options
    [Documentation]  Check policy list options with db data

    #Get policies from tch db
    Get Into DB  TCH
    ${policy_list_query}  Catenate  SELECT ipolicy
    ...    FROM def_card
    ...    WHERE id = '${carrier.id}'
    ...    AND policy_type_id = 1;
    ${query_result}  Query And Strip To Dictionary  ${policy_list_query}
    ${policies}    Run Keyword If    "${query_result}"!="{}"    Get From Dictionary  ${query_result}  ipolicy
    #Get policies from eManager list
    Wait Until Element Is Not Visible    id=statusText
    @{expected_policy_list}    Get List Items    policySel
    ${length}    Get Length    ${expected_policy_list}
    #Check for empty data
    Run Keyword If    "${query_result}"=="{}"    Should be Equal as Strings    ${length}    0
    Return From Keyword If    "${query_result}"=="{}"
    #Check for one data
    ${one_policy}    Run Keyword And Return Status    Row Count is Equal to X    ${policy_list_query}    1
    ${expected_policy}    Run Keyword If    ${one_policy}    Get From List    ${expected_policy_list}    0
    ${policies_string}    Run Keyword If    ${one_policy}    Convert to String    ${policies}
    ${policy_length}    Run Keyword If    ${one_policy}    Get Length    ${policies_string}
    ${expected_policy}    Run Keyword If    ${one_policy}    Get Substring    ${expected_policy}    0    ${policy_length}
    Run Keyword If    ${one_policy}    Should be Equal as Strings    ${length}    1
    Run Keyword If    ${one_policy}    Should be Equal as Strings    ${expected_policy}    ${policies}
    Return From Keyword If    ${one_policy}
    #Check for several data
    @{policy_list}    Convert to List    ${policies}
    ${length_db}    Get Length    ${policy_list}
    Should be Equal    ${length_db}    ${length}
    #Check if policies match
    ${i}    Set Variable    0
    FOR    ${policy}    IN    @{policy_list}
        ${policy}    Convert to String    ${policy}
        ${length}    Get Length    ${policy}
        ${expected_policy}    Get From List    ${expected_policy_list}    ${i}
        ${expected_policy}    Get Substring    ${expected_policy}    0    ${length}
        Should be Equal as Strings  ${expected_policy}    ${policy}
        ${i}    Evaluate    ${i} + 1
    END

Assert Card Number List Options
    [Documentation]  Check card number list options with db data

    #Get cards from tch db
    Get Into DB  TCH
    ${cardnum_list_query}  Catenate  SELECT TRIM(card_num) AS card_num
    ...    FROM cards
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND status != 'D'
    ...    AND cardoverride != 'Y';
    ${query_result}  Query And Strip To Dictionary  ${cardnum_list_query}
    ${card_numbers}    Run Keyword If    "${query_result}"!="{}"    Get From Dictionary  ${query_result}  card_num
    #Get cards from eManager list
    Wait Until Element Is Not Visible    id=statusText
    @{expected_cardnum_list}    Get List Items    cardNumberSel
    ${length}    Get Length    ${expected_cardnum_list}
    #Check for empty data
    Run Keyword If    "${query_result}"=="{}"    Should be Equal as Strings    ${length}    0
    Return From Keyword If    "${query_result}"=="{}"
    #Check for one data
    ${one_cardnum}    Run Keyword And Return Status    Row Count is Equal to X    ${cardnum_list_query}    1
    ${expected_cardnum}    Run Keyword If    ${one_cardnum}    Get From List    ${expected_cardnum_list}    0
    Run Keyword If    ${one_cardnum}    Should be Equal as Strings    ${length}    1
    Run Keyword If    ${one_cardnum}    Should be Equal as Strings    ${expected_cardnum}    ${card_numbers}
    Return From Keyword If    ${one_cardnum}
    #Check for several data
    @{card_list}    Convert to List    ${card_numbers}
    ${length_db}    Get Length    ${card_list}
    Should be Equal    ${length_db}    ${length}
    #Check if cards match
    ${i}    Set Variable    0
    FOR    ${cardnum}    IN    @{card_list}
        ${flag}    Get Substring    ${cardnum}    0    2
        ${cardnum_first_part}    Run Keyword If    ${flag}==55 or ${flag}==53    Get Substring    ${cardnum}    0    6
        ${cardnum_last_part}    Run Keyword If    ${flag}==55 or ${flag}==53    Get Substring    ${cardnum}    12    16
        Run Keyword If    ${flag}==55 or ${flag}==53    List Should Contain Value  ${expected_cardnum_list}    ${cardnum_first_part}******${cardnum_last_part}
        ...    ELSE    List Should Contain Value  ${expected_cardnum_list}    ${cardnum}
        ${i}    Evaluate    ${i} + 1
    END

Assert '${option}' List Options
    [Documentation]  Check list options from selected item with db data

    ${infoid}    Get From Dictionary    ${infoid_list}    ${option}
    ${list}    Get From Dictionary    ${options_list}    ${option}
    #Get options from tch db
    Get Into DB  TCH
    ${option_list_query}  Catenate  SELECT DISTINCT
    ...    TRIM(case
    ...    when infosrc = 'C' then SUBSTR(ci.info_validation, 2, 30)
    ...    when infosrc = 'D' then SUBSTR(di.info_validation, 2, 30)
    ...    when infosrc = 'B' and ci.info_validation is null
    ...    then SUBSTR(di.info_validation, 2, 30)
    ...    else SUBSTR(ci.info_validation, 2, 30)
    ...    end) as effectiveInfo
    ...    FROM cards c
    ...    left outer join card_inf ci on ci.card_num = c.card_num and ci.info_id = '${infoid}'
    ...    left outer join def_info di on di.carrier_id = c.carrier_id
    ...    and di.ipolicy = c.icardpolicy
    ...    and di.info_id = '${infoid}'
    ...    join def_card p on p.ipolicy = c.icardpolicy and p.id = c.carrier_id
    ...    WHERE c.carrier_id = '${carrier.id}';
    ${query_result}  Query And Strip To Dictionary  ${option_list_query}
    ${options}  Get From Dictionary  ${query_result}  effectiveinfo
    #Get options from eManager list
    Wait Until Element Is Not Visible    id=statusText
    @{expected_option_list}    Get List Items    ${list}
    ${length}    Get Length    ${expected_option_list}
    #Check for empty data
    ${one_option}    Run Keyword And Return Status    Row Count is Equal to X    ${option_list_query}    1
    ${empty_option}    Run Keyword If    ${one_option}    Run Keyword If    '${options}'=='None'    Set Variable    True
    ...    ELSE    Set Variable    False
    Run Keyword If    ${one_option} and ${empty_option}    Page Should Contain    No data for ${option}
    Return From Keyword If    ${one_option} and ${empty_option}
    #Check for one data
    ${expected_option}    Run Keyword If    ${one_option}    Get From List    ${expected_option_list}    0
    Run Keyword If    ${one_option}    Should be Equal as Strings    ${length}    1
    Run Keyword If    ${one_option}    Should be Equal as Strings    ${expected_option}    ${options}
    Return From Keyword If    ${one_option}
    #Check for several data
    @{option_list}    Convert to List    ${options}
    ${length_db}    Get Length    ${option_list}
    #Check if options match
    ${i}    Set Variable    0
    FOR    ${option_data}    IN    @{option_list}
        ${empty}    Evaluate    '${option_data}'=='None'
        ${length_db}    Run Keyword If    ${empty}    Evaluate    ${length_db} - 1
        ...    ELSE    Set Variable    ${length_db}
        ${expected_option}    Run Keyword If    not ${empty}    Get From List    ${expected_option_list}    ${i}
        Run Keyword If    not ${empty}    Should be Equal as Strings  ${expected_option}    ${option_data}
        ${i}    Run Keyword If    not ${empty}    Evaluate    ${i} + 1
        ...    ELSE    Set Variable    ${i}
    END
    Should be Equal    ${length_db}    ${length}

Select 'Hide / Show Match By Optional Information'
    Click Element    name=matchByCk

Select 'Location ID'
    Click Element    id=locationIdCk

Go to Look Up Location Tool
    Select 'Location ID'
    Wait Until Page Contains  Loading all Locations may take a long time.

Check the CT7 carrier chain id
    [Arguments]    ${condition}    ${chainIds}
    Run Keyword If    '${condition}' == 'has'    List Should Contain Value    ${chainIds}    101 - WEX NAF C STORES
    ...  ELSE    List Should Not Contain Value    ${chainIds}    101 - WEX NAF C STORES

Check the main screen chain id dropdown '${condition}' CT7 carrier chain id
    Select 'Hide / Show Match By Optional Information'
    Wait Until Page Contains    Match by(Optional):
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

Setup '${condition}' CT7 Carrier with Exception Transaction Report Permission
    [Documentation]  Setup for a/non CT7 carrier with Enhanced Transaction Report permission

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
    # Ensure carrier has Enhanced Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  TRN_REPORT
    # Ensure carrier has Exception Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  EXCEPTION_REPORT

Log Carrier into eManager with Exception Transaction Report permission
    [Documentation]  Log carrier into eManager with Enhanced Transaction Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Download Excel Report File
    [Documentation]  Keyword to download excel format file

    ${excelFile}  Download Report File  ${Report_Name}  xls

    Set Test Variable  ${excelFile}

Verify if Excel Report is Downloaded;
    [Documentation]  Keyword to check if excel Report is downloaded

    Assert if File is Dowloaded  ${report_name}.xls

Select Date Range for Exception Report and Set up Refreshing Transaction Counts
    [Documentation]  Select date range for Exception Transaction Report and Set up Refreshing Transaction Counts

    ${endDate}  getDateTimeNow  20%y-%m-%d
    ${startDate}  getDateTimeNow  20%y-%m-%d  days=-30

    Input Text  //input[@name='startDate']  ${startDate}
    Input Text  //input[@name='endDate']  ${endDate}
    Click Element  runParams.erRefreshingTransCountSelected
    wait until page contains element  runParams.erRefreshingTransCountPerWeek
    Click Element  runParams.erRefreshingTransCountPerDay
    Input Text  //input[@name='runParams.erRefreshingTransCountPerDayValue']  1
    Click Element  runReportId

Set Up A Carrier for Test
    [Arguments]  ${db}
    [Tags]  qtest
    [Documentation]

    set test variable  ${db}
    set test variable  ${carrier}  #103866
    ${todayDashed}  getDateTimeNow  %Y-%m-%d
    set test variable  ${todayDashed}
    Open eManager  ${intern}  ${internPassword}
    Switch to "${carrier.id}" user
    Ensure Carrier has User Permission  ${carrier.id}  EXCEPTION_REPORT

Download Report File for Test
    [Arguments]  ${report_name}  ${extension}  ${timeout}=120  ${createTimeout}=20
    [Documentation]  Clicks on submit, waits for the download button appears and then it makes download
    ...  report_name: can be a piece of the report file name, for example: Card Status Report
    ...  extension: xls, csv, txt, pdf...
    ...  * It returns the file full path

    Sleep  1
#    Numbered Error On Screen  Could Not Download Report Due to Numbered Error After Clicking Submit
    Wait Until Page Does Not Contain Element  //*[contains(text(), "Please wait while your document is loading ...")]  ${timeout}
    Click Element  //a[contains(text(),'Click here to view the document')]
    Sleep  1
    Numbered Error On Screen  Could Not Download Report Due to Numbered Error After Clicking On Download Link

    Check if File is Dowloaded    ${report_name}  ${extension}  ${createTimeout}
    #Log to console    ${filepath}

    [Return]  ${filepath}

Set Start and End Date for Transaction
    [Documentation]    Add the start and end date from carrier transaction

    Wait Until Element is Visible    name=startDate
    Input Text    name=startDate    ${carrier.transdate}
    Input Text    name=endDate    ${carrier.transdate}

Select '${format}' format
    [Documentation]    Select format for report to be generated

    Wait Until Element is Visible    name=viewFormat
    Select From List By Label    name=viewFormat    ${format}

Open '${tab_name}' tab
    [Documentation]    Open a tab from Enhanced Transaction Report by text

    Click Element    //*[starts-with(@for,'buildCustomTransReportTabs') and text()='${tab_name}']

Add Control Number, Unit, Trip Number and Driver ID prompts in Selected Columns
    [Documentation]    Adding Control Number, Unit, Trip Number and Driver ID prompts to report

    Add 'Control Number' column from Prompts in Selected Columns
    Add 'Driver ID' column from Prompts in Selected Columns
    Add 'Trip Number' column from Prompts in Selected Columns
    Add 'Unit' column from Prompts in Selected Columns

Add '${column}' column from Prompts in Selected Columns
    [Documentation]    Adding a prompt to report

    Wait Until Element is Visible    //*[@name="promptsFields"]
    Select From List By Label    name=promptsFields    ${column}
    Click Element    //*[@name="promptsFields"]/parent::td/parent::tr/following-sibling::tr//input[@value='Add']

Run Enhanced Transaction Report in '${format}' and download it
    [Documentation]    Run Enhanced Transaction Report, download and check

    Click Element    name=runReport
    Wait Until Element is Visible    name=loading
    Wait Until Page Does Not Contain Element  //*[contains(text(), "Please wait while your document is loading ...")]
    Click Element  //a[contains(text(),'Click here to view the document')]
    Check if File is Dowloaded  EnhancedTransactionReport  ${format}

Ensure Report has DYNAMIC prompt information
    [Documentation]    Check if report has label DYNAMIC for the prompt

    Find value in PDF    ${filepath}    DYNAMIC

Remove Enhanced Transaction Report
    [Documentation]    Delete Enhanced Transaction Report downloaded

    Remove Report File  EnhancedTransactionReport