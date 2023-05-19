*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Test Teardown  Close Browser
Suite Teardown    Disconnect From Database

Force Tags  eManager

*** Variables ***
${carrier}
${express_code}
${code_id}
${mc_reason_desc}
${db_mc_reason_desc}
${issue_to_default}    test
${reason_code_default}    1

*** Test Cases ***
Money Code Reason List permission enabled
    [Tags]    JIRA:FRNT-2091    JIRA:BOT-4970    JIRA:FRNT-2090    JIRA:BOT-4955    JIRA:FRNT-2167    JIRA:BOT-4999
    ...    qTest:98100459
    [Documentation]  Ensure Money Reason Code dropdown is displayed with correct values when the carrier has the Money
    ...    Code Reason List permission
    [Setup]    Setup Carrier for Issue Money Code

    Add Money Code Reason List Permission to Carrier
    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Verify Money Reason Code Dropdown
    Issue Money Code with Reason Code and confirm creation
    Check Reason Money Code From Issued Money Code    ${reason_code_default}
    Search it by Date
    Search it by Reference
    Search it by Money Code
    Search it by Issued To

Money Code Reason List permission not enabled
    [Tags]    JIRA:FRNT-2091    JIRA:BOT-4970    JIRA:FRNT-2090    JIRA:BOT-4955    JIRA:FRNT-2167    JIRA:BOT-4999
    ...    qTest:98108155
    [Documentation]  Ensure Money Reason Code dropdown is not displayed when the carrier has no Money Code Reason List
    ...    permission
    [Setup]    Setup Carrier for Issue Money Code

    Remove Money Code Reason List Permission from Carrier
    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    No Money Reason Code dropdown should be displayed
    Issue Money Code with Reason Code and confirm creation
    Search it by Date Without Money Reason Code
    Search it by Reference Without Money Reason Code
    Search it by Money Code Without Money Reason Code
    Search it by Issued To Without Money Reason Code

Issue Money Code with any Driver ID value with no permission to carrier
    [Tags]    JIRA:FRNT-2202    JIRA:BOT-5030    qTest:118052282    PI:15
    [Documentation]    Ensure any driver id value is valid when the carrier doesn't have the
    ...    Valid Driver ID In Money Codes permission
    [Setup]    Run Keywords    Setup Carrier with Valid Driver ID without permission and Driver ID required
    ...    Add valid Driver IDs

    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code with random value
    Assert Issue Money Code and Driver ID added

Issue Money Code with any or no Driver ID value when not required
    [Tags]    JIRA:FRNT-2202    JIRA:BOT-5030    qTest:118052298    PI:15
    [Documentation]    Ensure any driver ID value is valid when the carrier has the
    ...    Valid Driver ID In Money Codes permission but driver ID is not required
    [Setup]    Run Keywords    Setup Carrier with Valid Driver ID permission and Driver ID not required
    ...    Add valid Driver IDs

    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code
    Assert Money Code Issued
    Add Driver ID Info
    Issue Money Code with random value
    Assert Issue Money Code and Driver ID added

Issue Money Code error for invalid Driver ID value with permission to carrier
    [Tags]    JIRA:FRNT-2202    JIRA:BOT-5030    qTest:118052313    PI:15
    [Documentation]    Ensure any driver id value not assigned to a card is invalid when the carrier has the
    ...    Valid Driver ID In Money Codes permission
    [Setup]    Run Keywords    Setup Carrier with Valid Driver ID with permission and Driver ID required
    ...    Add valid Driver IDs

    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code with random value
    Assert error message for invalid driver id

Issue Money Code with valid Driver ID value with permission to carrier
    [Tags]    JIRA:FRNT-2202    JIRA:BOT-5030    qTest:118052324    PI:15
    [Documentation]    Ensure a valid driver id value is accepted in issue money code when the carrier has the
    ...    Valid Driver ID In Money Codes permission
    [Setup]    Setup Carrier with Valid Driver ID with permission and Driver ID required

    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code with valid 'Exact Match' driver id added in 'active' card
    Assert Issue Money Code and Driver ID added
    Issue Money Code with valid 'Report Only' driver id added in 'active' card
    Assert Issue Money Code and Driver ID added

Issue Money Code with any Driver ID when required but not set in cards
    [Tags]    JIRA:FRNT-2202    JIRA:BOT-5030    qTest:118063904    PI:15
    [Documentation]    Ensure a money code can be issued when driver ID is required but left blank cause there is
    ...    none set in cards
    [Setup]    Run Keywords    Setup Carrier with Valid Driver ID with permission and Driver ID required
    ...    Remove All Exact Match and Report Only Driver IDs

    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code with empty driver id
    Assert error message for driver id required
    Issue Money Code with random value
    Assert Issue Money Code and Driver ID added

Issue Money Code with Driver ID from invalid status card
    [Tags]    JIRA:FRNT-2202    JIRA:BOT-5030    qTest:118109592    PI:15
    [Documentation]    Ensure driver id value from invalid status are not accepted when issue a money code
    [Setup]    Run Keywords    Setup Carrier with Valid Driver ID with permission and Driver ID required
    ...    Add valid Driver IDs

    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code with valid 'Exact Match' driver id added in 'inactive' card
    Assert error message for invalid driver id
    Issue Money Code with valid 'Exact Match' driver id added in 'hold' card
    Assert error message for invalid driver id
    Issue Money Code with valid 'Exact Match' driver id added in 'fraud' card
    Assert error message for invalid driver id
    Issue Money Code with valid 'Report Only' driver id added in 'inactive' card
    Assert error message for invalid driver id
    Issue Money Code with valid 'Report Only' driver id added in 'hold' card
    Assert error message for invalid driver id
    Issue Money Code with valid 'Report Only' driver id added in 'fraud' card
    Assert error message for invalid driver id

*** Keywords ***
Setup Carrier for Issue Money Code
    [Documentation]  Keyword Setup Carrier for Issue Money Code

    Get Into DB  MySQL
    # Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]{6}$'
    ...    AND surx.role_id='MONEY_CODES'
    ...    AND surx.menu_visible=1
    ...    AND su.user_id NOT LIKE '134%'
    ...    AND su.user_id NOT LIKE '132%'
    ...    AND su.user_id NOT LIKE '600%'
    ...    AND su.user_id NOT IN ('100211', '103278', '103866')
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...    FROM member m
    ...    INNER JOIN contract c
    ...    ON m.member_id = c.carrier_id
    ...    INNER JOIN carrier_type_xref ctx
    ...    ON ctx.carrier_id = c.carrier_id
    ...    WHERE m.status = 'A'
    ...    AND c.status = 'A'
    ...    AND m.mem_type = 'C'
    ...    AND c.credit_limit > 0
    ...    AND c.daily_limit > 0
    ...    AND member_id IN ${carrier_list}
    ...    ORDER BY c.lastupdated DESC;
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Setup Carrier for Valid Driver ID Feature
    [Documentation]    Setup Carrier for Valid Driver ID Feature
    [Arguments]    ${has_permission}=True    ${driverid_required}=True

    ${driverid_required_cond}    Run Keyword If    '${driverid_required}'=='False'    Set Variable    NOT IN
    ...    ELSE    Set Variable    IN
    Get Into DB  TCH
    ${drid_required_query}  Catenate  SELECT carrier_id
    ...    FROM mon_code_issue_info
    ...    WHERE info_id = 'DRID'
    ...    AND reqd_flag = 'Y';
    ${carriers_drid_required}  Query And Strip To Dictionary  ${drid_required_query}
    ${carriers_drid_required}  Get From Dictionary  ${carriers_drid_required}  carrier_id
    ${carriers_drid_required}  Evaluate  ${carriers_drid_required}.__str__().replace('[','(').replace(']',')')
    Get Into DB  MySQL
    # Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND (su.user_id BETWEEN 100000 AND 200000
    ...    OR su.user_id BETWEEN 250000 AND 299999
    ...    OR su.user_id between 300000 AND 389999)
    ...    AND su.user_id ${driverid_required_cond} ${carriers_drid_required}
    ...    AND surx.role_id='MONEY_CODES'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member m
    ...  INNER JOIN cards c
    ...  ON c.carrier_id = m.member_id
    ...  WHERE c.status = 'A'
    ...  AND c.card_num not like '%OVER'
    ...  AND c.cardoverride = '0'
    ...  AND m.status = 'A'
    ...  AND member_id IN ${carrier_list};
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}
    Run Keyword If    '${has_permission}'=='True'    Add Valid Driver ID in Money Codes Permission to Carrier
    ...    ELSE    Remove Valid Driver ID in Money Codes Permission from Carrier
    Add Issue Money Code Permission to Carrier

Setup Carrier with Valid Driver ID without permission and Driver ID required
    [Documentation]    Setup carrier with Valid Driver ID permission and driver id required in issue money code

    Setup Carrier for Valid Driver ID Feature    False    True

Setup Carrier with Valid Driver ID permission and Driver ID not required
    [Documentation]    Setup carrier with Valid Driver ID permission and driver id not required in issue money code

    Setup Carrier for Valid Driver ID Feature    True    False

Setup Carrier with Valid Driver ID with permission and Driver ID required
    [Documentation]    Setup carrier without Valid Driver ID permission and driver id required in issue money code

    Setup Carrier for Valid Driver ID Feature    True    True

Get available card from carrier setting status
    [Documentation]    Get valid card from carrier and set required status
    [Arguments]    ${card_status}=A

    Get Into DB  TCH
    ${card_num_list}  Catenate  SELECT card_num
    ...    FROM cards
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND card_num NOT LIKE '%OVER'
    ...    AND cardoverride = '0'
    ...    AND card_num NOT IN (SELECT c.card_num
    ...    FROM card_inf ci
    ...    INNER JOIN cards c
    ...    ON c.card_num = ci.card_num
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND info_id = 'DRID')
    ...    LIMIT 1;
    ${card_num}    Query And Strip    ${card_num_list}
    ${upd_card_status}    Catenate    UPDATE cards
    ...    SET status = '${card_status}'
    ...    WHERE card_num = '${card_num}';
    Execute SQL String    ${upd_card_status}

    [Return]    ${card_num}

Add Driver ID
    [Documentation]    Add a driver id to card
    [Arguments]    ${type}    ${card_status}=A

    ${value}    Run Keyword If    '${type}'=='V'    Generate Random String    4    [NUMBERS]
    ...    ELSE    Generate Random String    4    [LETTERS][NUMBERS]
    ${card_num}    Get available card from carrier setting status    ${card_status}
    ${add_validation_query}    Catenate    INSERT INTO card_inf
    ...    (card_num, info_id, info_validation)
    ...    VALUES ('${card_num}','DRID', '${type}${value}');
    Execute SQL String    ${add_validation_query}

    [Return]    ${value}

Add valid Driver IDs
    [Documentation]    Add a exact match and report only driver ids to card

    Add Driver ID    V
    Add Driver ID    Z

Remove Driver ID
    [Documentation]    Remove driver id validation
    [Arguments]    ${card_num}

    Get Into DB  TCH
    ${del_validation_query}    Catenate    DELETE FROM card_inf
    ...    WHERE card_num = '${card_num}'
    ...    AND info_id = 'DRID';
    Execute SQL String    ${del_validation_query}

Remove All Exact Match and Report Only Driver IDs
    [Documentation]    Remove exact match and report only validations from carrier cards

    Get Into DB    TCH
    ${card_num_list_query}    Catenate    SELECT TRIM(c.card_num) as card_num
    ...    FROM card_inf i, cards c
    ...    WHERE c.carrier_id = '${carrier.id}'
    ...    AND c.card_num = i.card_num
    ...    AND i.info_id = 'DRID'
    ...    AND c.card_num NOT LIKE '%OVER'
    ...    AND (i.info_validation like 'V%' or i.info_validation like 'Z%');
    ${status}    Run Keyword And Return Status    Row Count Is Equal to X    ${card_num_list_query}    0
    Return From Keyword If    '${status}'=='True'
    ${query_result}  Query And Strip To Dictionary  ${card_num_list_query}
    ${status}    Run Keyword And Return Status    Row Count Is Equal to X    ${card_num_list_query}    1
    ${card_num}    Run Keyword If    '${status}'=='True'    Get From Dictionary  ${query_result}  card_num
    Run Keyword And Return If    '${status}'=='True'    Remove Driver ID    ${card_num}
    @{card_num_list}  Get From Dictionary  ${query_result}  card_num
    FOR    ${cardnum}    IN    @{card_num_list}
        Remove Driver ID    ${cardnum}
    END

Add Issue Money Code Permission to Carrier
    [Documentation]    Give the carrier the money code reason list permission

    Ensure Carrier has User Permission    ${carrier.id}    MONEY_CODES

Add Money Code Reason List Permission to Carrier
    [Documentation]    Give the carrier the money code reason list permission

    Ensure Carrier has User Permission    ${carrier.id}    MON_CODE_REASON

Remove Money Code Reason List Permission from Carrier
    [Documentation]    Remove from carrier the money code reason list permission

    Remove Carrier User Permission    ${carrier.id}    MON_CODE_REASON

Add Valid Driver ID in Money Codes Permission to Carrier
    [Documentation]    Give the carrier the money code reason list permission

    Ensure Carrier has User Permission    ${carrier.id}    VALID_DRIVER_ID_IN_MONEY_CODES

Remove Valid Driver ID in Money Codes Permission from Carrier
    [Documentation]    Remove from carrier the money code reason list permission

    Remove Carrier User Permission    ${carrier.id}    VALID_DRIVER_ID_IN_MONEY_CODES

Log Carrier into eManager with Issue Money permission
    [Documentation]  Log carrier into eManager with Issue Money permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Money Codes > Issue Money Code
    [Documentation]  Go to Select Program > Money Codes > Issue Money Code

    Go To  ${emanager}/cards/MoneyCodeManagement.action
    Wait Until Page Contains    Money Code Information

Go to Money Code History
    [Documentation]  Go to Money Code History screen from Issue Money Code

    Click Element    name=history
    Wait Until Page Contains    Money Codes History

Verify Money Reason Code Dropdown
    [Documentation]    Check if page contains element and its values match with db

    Page Should Contain Element    reasonCodeSel
    Compare Money Reason Code Values

Compare Money Reason Code Values
    [Documentation]    Check if money reason code values from screen and db match

    ${expected_money_reason_codes}    Get Money Reason Code Values from DB
    ${money_reason_codes}    Get Money Reason Code Values from Screen
    Lists Should Be Equal    ${money_reason_codes}    ${expected_money_reason_codes}

Get Money Reason Code Values from DB
    [Documentation]    Get money reason code values from db

    Get Into DB  TCH
    ${query}  Catenate  SELECT MCRL.reason_desc
    ...    FROM mon_code_reason_list as MCRL,
    ...    (SELECT first 1 carrier_type
    ...    FROM carrier_type_xref
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND effective_date <= current
    ...    AND (expire_date is null OR expire_date > current)
    ...    ORDER BY effective_date DESC) as CRX
    ...    WHERE MCRL.carrier_type = 0 or MCRL.carrier_type = CRX.carrier_type;
    ${query_result}  Query And Strip To Dictionary  ${query}
    ${money_reason_codes}  Get From Dictionary  ${query_result}  reason_desc
    [Return]    ${money_reason_codes}

Get Money Reason Code Values from Screen
    [Documentation]    Get money reason code values from screen

    ${money_reason_codes}    Get List Items    reasonCodeSel
    [Return]    ${money_reason_codes}

Issue Money Code
    [Documentation]  Issue a money code
    [Arguments]    ${reason_code}=1    ${amount}=5    ${info}=${issue_to_default}    ${driver_id_val}=${issue_to_default}

    Wait Until Page Does Not Contain    Loading...
    Input Text    moneyCode.amount    ${amount}
    Input Text    moneyCode.issuedTo    ${info}
    Input Text    moneyCode.notes    ${info}
    Check and Input Text    infoValCLCD    ${info}
    Check and Input Text    infoValDMLC    ${info}
    Check and Input Text    infoValPDLN    ${info}
    Check and Input Text    infoValVHNB    ${info}
    Check and Input Text    infoValPONB    ${info}
    Check and Input Text    infoValUNIT    ${info}
    Check and Input Text    infoValDRID    ${driver_id_val}
    Check and Select Value    name=reasonCodeSel    ${reason_code}
    Click Button    submitId

Add New Info
    [Documentation]    Add new info in issue money code screen
    [Arguments]    ${prompt}

    Wait Until Element is Visible    id=addInfoBtn
    Click Element    id=addInfoBtn
    Select From List By Value    id=infoSelect    ${prompt}
    Click Element    //*[@id="addinfo-dialog"]/input[@value='OK']
    Wait Until Element is Visible    //input[@id='infoVal${prompt}']

Add Driver ID Info
    [Documentation]    Add driver id validation to issue money code screen

    Add New Info    DRID

Assert Money Code Issued
    [Documentation]    Ensure issue money code is done successfully
    [Arguments]    ${exp_amount}=5    ${exp_info}=${issue_to_default}

    Wait Until Element is Visible    //*[@class="messages"]
    ${express_code}    Get Text    //*[@class="messages"]/li/b[1]
    ${code_id}    Get Text    //*[@class="messages"]/li/b[2]
    Set Test Variable    ${express_code}
    Set Test Variable    ${code_id}
    Get Into DB    TCH
    ${assert_query}    Catenate    SELECT *
    ...    FROM mon_codes
    ...    WHERE express_code = '${express_code}';
    ${query_result}  Query And Strip To Dictionary  ${assert_query}
    ${money_code_id}  Get From Dictionary  ${query_result}  code_id
    Should Be Equal as Strings    ${code_id}    ${money_code_id}
    ${carrier_id}  Get From Dictionary  ${query_result}  carrier_id
    Should Be Equal as Strings    ${carrier.id}    ${carrier_id}
    ${amount}  Get From Dictionary  ${query_result}  original_amt
    Should Be Equal as Numbers    ${amount}    ${exp_amount}
    ${issued_to}  Get From Dictionary  ${query_result}  issued_to
    Should Be Equal as Strings    ${issued_to}    ${exp_info}

Assert Driver ID Added
    [Documentation]    Compare expected driver id to added one
    [Arguments]    ${exp_driver_id_val}=${issue_to_default}

    Wait Until Element is Visible    //*[@id="row"]//td[contains(text(), 'Driver ID')]/parent::tr/td[2]
    ${driver_id_val}    Get Text    //*[@id="row"]//td[contains(text(), 'Driver ID')]/parent::tr/td[2]
    Should Be Equal as Strings    ${driver_id_val}    ${exp_driver_id_val}

Assert Issue Money Code and Driver ID added
    [Documentation]    Ensure issue money code with driver id done successfully

    Assert Money Code Issued
    Assert Driver ID Added    ${drid_val}

Issue Money Code with random value
    [Documentation]    Issue a money code with random value to driver id

    ${drid_val}    Generate Random String    4    [LETTERS][NUMBERS]
    Set Test Variable    ${drid_val}
    Issue Money Code    driver_id_val=${drid_val}

Issue Money Code with valid '${type}' driver id added in '${card_status}' card
    [Documentation]    Issue money code with valid driver id value

    ${card_status}    Run Keyword If    '${card_status}'=='inactive'    Set Variable    I
    ...    ELSE IF    '${card_status}'=='hold'    Set Variable    H
    ...    ELSE IF    '${card_status}'=='fraud'    Set Variable    U
    ...    ELSE    Set Variable    A
    ${drid_val}    Run Keyword If    '${type}'=='Exact Match'    Add Driver ID    V    ${card_status}
    ...    ELSE    Add Driver ID    Z    ${card_status}
    Set Test Variable    ${drid_val}
    Issue Money Code    driver_id_val=${drid_val}

Issue Money Code with empty driver id
    [Documentation]    Issue money code with driver id empty

    Issue Money Code    driver_id_val=${EMPTY}

Assert error message for invalid driver id
    [Documentation]    Ensure error message is shown when driver id is invalid

    Page Should Contain    The Driver Id enter is an Invalid Driver Id.

Assert error message for driver id required
    [Documentation]    Ensure error message is shown when driver id is required

    Page Should Contain    The DRID info is required.

Issue Money Code with Reason Code and confirm creation
    [Documentation]    Issue money code with reason code and confirm success

    Issue Money Code    ${reason_code_default}
    Assert Money Code Issued

Check and Input Text
    [Documentation]  Verify screen has the element and if it does it fills the text box with the value
    [Arguments]    ${path}    ${value}

    ${status}    Run Keyword and Return Status    Page Should Contain Element    ${path}
    Run Keyword If    '${status}'=='True'    Input Text    ${path}    ${value}

Check and Select Value
    [Documentation]  Verify screen has the element and if it does it selects the value
    [Arguments]    ${path}    ${value}

    ${status}    Run Keyword and Return Status    Page Should Contain Element    ${path}
    Run Keyword If    '${status}'=='True'    Select From List By Value    ${path}    ${value}

Check Reason Money Code From Issued Money Code
    [Documentation]    Assertion on reason money code list and gets its description to compare later
    [Arguments]    ${mon_code_reason}=1

    Get Into DB  TCH
    ${query}  Catenate  SELECT mon_code_reason_id
    ...    FROM mon_codes
    ...    WHERE code_id = '${code_id}'
    ...    AND express_code = '${express_code}';
    ${mon_code_reason_id}  Query And Strip    ${query}
    Should Be Equal as Numbers    ${mon_code_reason_id}    ${mon_code_reason}
    Get Reason Money Code Description from Database    ${mon_code_reason}

Get Reason Money Code Description from Database
    [Documentation]    Gets reason money code description from database
    [Arguments]    ${mon_code_reason}=1

    Get Into DB  TCH
    ${query}  Catenate  SELECT reason_desc
    ...    FROM mon_code_reason_list
    ...    WHERE reason_code = '${mon_code_reason}';
    ${db_mc_reason_desc}  Query And Strip    ${query}
    Set Test Variable    ${db_mc_reason_desc}

No Money Reason Code dropdown should be displayed
    [Documentation]  Issue money code has no money reason code without the permission

    Page Should Not Contain Element    reasonCodeSel

Search in Money Codes History
    [Documentation]  Search in Money Codes History with only date or some other search key such as reference, money code
    ...    or issue to
    [Arguments]    ${onlyDate}=True    ${checkbox}=referenceChecked    ${key}=reference    ${value}=${code_id}

    Go to Money Code History
    Run Keyword If    '${onlyDate}'=='False'    Input Search Data    ${checkbox}    ${key}    ${value}
    Click Element    name=lookupHistory
    Wait Until Element is Visible    id=moneyCode

Input Search Data
    [Documentation]  Select the search checkbox and fills the text box with the value
    [Arguments]    ${check_path}    ${txtbox_path}    ${value}

    Select Checkbox    ${check_path}
    Input Text    ${txtbox_path}    ${value}

Check Money Reason Code From Issued Money Code Row
    [Documentation]  Verify Money Reason Code column is displayed and if the money reason code from issued money code
    ...    row matches with description from database
    [Arguments]    ${key}=reference

    Page Should Contain Element    //*[@id="moneyCode"]//a[text()='Money Reason Code']
    ${gen_path}    Set Variable    //a[text()='${code_id}']/parent::td/following-sibling::
    ${ref_path}    Set Variable    td[10]
    ${mc_path}    Set Variable    td[text()='${express_code}']/following-sibling::td[9]
    ${issue_path}    Set Variable    td[text()='${issue_to_default}']/following-sibling::td[6]
    Run Keyword If    '${key}'=='reference'    Get Money Reason Code Description    ${gen_path}${ref_path}
    Run Keyword If    '${key}'=='moneyCode'    Get Money Reason Code Description    ${gen_path}${mc_path}
    Run Keyword If    '${key}'=='issueTo'    Get Money Reason Code Description    ${gen_path}${issue_path}
    Should Be Equal As Strings    ${mc_reason_desc}    ${db_mc_reason_desc}
    Click Element    name=backToMoneyCodes
    Wait Until Page Contains    Money Code Information

Get Money Reason Code Description
    [Documentation]  Get money reason code description from issued money code row
    [Arguments]    ${path}

    ${mc_reason_desc}    Get Text    ${path}
    Set Test Variable    ${mc_reason_desc}

Check No Money Reason Code Column Displayed
    [Documentation]  Verify Money Reason Code column is not displayed

    Page Should Contain Element    //a[text()='${code_id}']
    Page Should Not Contain Element    //*[@id="moneyCode"]//a[text()='Money Reason Code']
    Click Element    name=backToMoneyCodes
    Wait Until Page Contains    Money Code Information

Search it by Date
    [Documentation]  Search the issued money code by date and check reason money code

    Search in Money Codes History
    Check Money Reason Code From Issued Money Code Row

Search it by Reference
    [Documentation]  Search the issued money code by reference and check reason money code

    Search in Money Codes History    False
    Check Money Reason Code From Issued Money Code Row    reference

Search it by Money Code
    [Documentation]  Search the issued money code by money code and check reason money code

    Search in Money Codes History    False    mcChecked    moneyCode    ${express_code}
    Check Money Reason Code From Issued Money Code Row    moneyCode

Search it by Issued To
    [Documentation]  Search the issued money code by issued to and check reason money code

    Search in Money Codes History    False    issueChecked    issueTo    ${issue_to_default}
    Check Money Reason Code From Issued Money Code Row    issueTo

Search it by Date Without Money Reason Code
    [Documentation]  Search the issued money code by date and check there is no reason money code

    Search in Money Codes History
    Check No Money Reason Code Column Displayed

Search it by Reference Without Money Reason Code
    [Documentation]  Search the issued money code by reference and check there is no reason money code

    Search in Money Codes History    False
    Check No Money Reason Code Column Displayed

Search it by Money Code Without Money Reason Code
    [Documentation]  Search the issued money code by money code and check there is no reason money code

    Search in Money Codes History    False    mcChecked    moneyCode    ${express_code}
    Check No Money Reason Code Column Displayed

Search it by Issued To Without Money Reason Code
    [Documentation]  Search the issued money code by issued to and check there is no reason money code

    Search in Money Codes History    False    issueChecked    issueTo    ${issue_to_default}
    Check No Money Reason Code Column Displayed