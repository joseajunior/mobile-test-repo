*** Settings ***
Library  otr_model_lib.Models
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Run Keywords
...    Setup Carrier for Exception Transaction Report    AND
...    Setup Optional Information Match Keys
Test Teardown  Close Browser

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

# ${carrier_id}  query and strip  select id from def_card where ipolicy = -1 limit 1;  db_instance=tch

*** Test Cases ***
# ROCKET-212 - Greg Parkin/Imran 6-23-2022
Check that ipolicy is not negative one for Exception Report
    [Tags]    JIRA:ROCKET-212  qTest:55905522
    [Documentation]  This Test case validates the ipolicy does not contrain a -1
    ...     by producing an Exception Report

    Search for carrier with -1 policy  EXCEEDED_TRANS_REPORT
    Go to Select Program > Reports/Exports > Exception Report
    Open 'Policy' List from Match By Optional Information
    Verify policy list does not contain -1

*** Keywords ***
Setup Carrier for Exception Transaction Report
    [Documentation]  Keyword Setup for Exception Transaction Report

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
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

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

# ROCKET-212 - Greg Parkin/Imran 6-23-2022
Go to Select Program > Reports/Exports > Exception Report
    [Documentation]  Go to Select Program > Reports/Exports > Exception Report

    Go To  ${emanager}/trn/TRNReport.action
    Wait Until Page Contains    Exception Report

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