*** Settings ***
Resource   ../../Variables/validUser.robot
Library    String
Library    otr_robot_lib.ws.CardManagementWS
Library    otr_model_lib.services.GenericService
Library    otr_model_lib.Models
Library    Collections
Resource   otr_robot_lib/robot/RobotKeywords.robot
Resource   otr_robot_lib/robot/eManagerKeywords.robot
Library    otr_robot_lib.ws.RestAPI.RestAPIService
Library    RequestsLibrary

Suite Setup    Run Keywords    Setup Valid Carrier and Contract    Setup Base URL    Init Session
Suite Teardown    Disconnect from Database
#Suite Setup  starting suite
#Suite Teardown  Ending Suite

Force Tags  Web Services

*** Variables ***
${carrier}
${mc_code_default}    1
${session_name}    eManager
${base_url}
${environment}
${response}
${code_id}
${express_code}
${reason_descs}
${login_endpoint}    /efs-json/user/login
${mc_reason_list_endpoint}    /efs-json/code/moneyCodeReasonList
${get_user_endpoint}    /efs-json/user/getUser
${issue_mc_endpoint}    /efs-json/code/issueCode

*** Test Cases ***
Issuing a Money Code
    [Tags]  tier:0  JIRA:BOT-1579  qTest:30780607  Regression    refactor
    [Documentation]  Validate that you can issue a Money Code

    Set Test Variable  ${contractId}  3035
    Set Test Variable  ${masterContractId}  ${EMPTY}
    Set Test Variable  ${amount}  10
    Set Test Variable  ${feeType}  ${False}
    Set Test Variable  ${issuedTo}  joao
    Set Test Variable  ${notes}  Hey There!
    Set Test Variable  ${currency}  USD

    ${status}  Run Keyword And Return Status  issueMoneyCode  ${contractId}  ${amount}  ${issuedTo}  ${notes}  ${feeType}  ${currency}  ${masterContractId}

    Should Be True  ${status}

Check TYPO on the contractId
    [Tags]  JIRA:BOT-1579  qTest:30767217  Regression    refactor
    [Documentation]  Validate that you cannot issue a Money Code with a typo on contractId

    Set Test Variable  ${contractId}  3035
    Set Test Variable  ${masterContractId}  ${EMPTY}
    Set Test Variable  ${amount}  10
    Set Test Variable  ${feeType}  ${False}
    Set Test Variable  ${issuedTo}  joao
    Set Test Variable  ${notes}  Hey There!
    Set Test Variable  ${currency}  USD

    ${status}  run keyword and return status  issueMoneyCode  ${contractId}AAA  ${amount}  ${issuedTo}  ${notes}  ${feeType}  ${currency}  ${masterContractId}

    Should Not Be True  ${status}
    should be equal as strings  ${ws_error}  For input string: "${contractId}AAA"

Check TYPO on the Amount
    [Tags]  JIRA:BOT-1579  qTest:30780503  Regression    refactor
    [Documentation]  Validate that you cannot issue a Money Code with a typo on Amount

    Set Test Variable  ${contractId}  3035
    Set Test Variable  ${masterContractId}  ${EMPTY}
    Set Test Variable  ${amount}  10
    Set Test Variable  ${feeType}  ${False}
    Set Test Variable  ${issuedTo}  joao
    Set Test Variable  ${notes}  Hey There!
    Set Test Variable  ${currency}  USD

    ${status}  Run Keyword And Return Status  issueMoneyCode  ${contractId}  ${amount}AAA  ${issuedTo}  ${notes}  ${feeType}  ${currency}  ${masterContractId}

    Should Not Be True  ${status}
    should be equal as strings  ${ws_error}  For input string: "${amount}AAA"

Check TYPO on the feeType
    [Tags]  JIRA:BOT-1579  qTest:30780506  Regression    refactor
    [Documentation]  Validate that you cannot issue a Money Code with a typo on feeType

    Set Test Variable  ${contractId}  3035
    Set Test Variable  ${masterContractId}  ${EMPTY}
    Set Test Variable  ${amount}  10
    Set Test Variable  ${feeType}  ${False}
    Set Test Variable  ${issuedTo}  joao
    Set Test Variable  ${notes}  Hey There!
    Set Test Variable  ${currency}  USD

    ${status}  Run Keyword And Return Status  issueMoneyCode  ${contractId}  ${amount}  ${issuedTo}  ${notes}  ${feeType}AAA  ${currency}  ${masterContractId}

    Should Not Be True  ${status}
    should be equal as strings  ${ws_error}  in valid string -${feeType}AAA for boolean value

Validate EMPTY value on contractId
    [Tags]  JIRA:BOT-1579  qTest:30767318  Regression    refactor
    [Documentation]  Validate that you cannot issue a Money Code using an empty contractId.

    Set Test Variable  ${contractId}  ${EMPTY}
    Set Test Variable  ${masterContractId}  ${EMPTY}
    Set Test Variable  ${amount}  10
    Set Test Variable  ${feeType}  ${False}
    Set Test Variable  ${issuedTo}  joao
    Set Test Variable  ${notes}  Hey There!
    Set Test Variable  ${currency}  USD

    ${status}  Run Keyword And Return Status  issueMoneyCode  ${contractId}  ${amount}  ${issuedTo}  ${notes}  ${feeType}  ${currency}  ${masterContractId}

    Should Not Be True  ${status}
    should start with  ${ws_error}  ERROR running command

Validate EMPTY value on Amount
    [Tags]  JIRA:BOT-1579  qTest:30780611  Regression    refactor
    [Documentation]  Validate that you cannot issue a Money Code using an empty Amount.

    Set Test Variable  ${contractId}  3035
    Set Test Variable  ${masterContractId}  ${EMPTY}
    Set Test Variable  ${amount}  ${EMPTY}
    Set Test Variable  ${feeType}  ${False}
    Set Test Variable  ${issuedTo}  joao
    Set Test Variable  ${notes}  Hey There!
    Set Test Variable  ${currency}  USD

    ${status}  Run Keyword And Return Status  issueMoneyCode  ${contractId}  ${amount}  ${issuedTo}  ${notes}  ${feeType}  ${currency}  ${masterContractId}

    Should Not Be True  ${status}
    should start with  ${ws_error}  ERROR running command

Get Money Code Reason List
    [Tags]  JIRA:ATLAS-2092    JIRA:BOT-50003    qTest:116727562
    [Documentation]  Ensure Money Code Reason List API returns correct data
    [Setup]    Add Money Code Reason List Permission to Carrier

    Login with carrier through api
    Check user Money Code Reason List permission in api
    Get Money Code Reason List in api
    Compare Money Code Reason lists
    Remove Money Code Reason List Permission from Carrier
    Login with carrier through api
    Check no user Money Code Reason List permission in api
    Check Money Code Reason List error for no permission

Issue Money Code with Money Code Reason permission
    [Tags]  JIRA:ATLAS-2092    JIRA:BOT-50003    qTest:116727559
    [Documentation]  Ensure the the issue code API works properly for a carrier with Money Code Reason List permission
    ...    and setting the Money Code Reason property
    [Setup]    Add Money Code Reason List Permission to Carrier

    Login with carrier through api
    Check user Money Code Reason List permission in api
    Issue a money code
    Check Reason Money Code From Issued Money Code
    Issue a money code with reason money code as null
    Check empty reason money code from issued money code
    Issue a money code with reason money code as empty string
    Check empty reason money code from issued money code
    Issue a money code without reason money code
    Check empty reason money code from issued money code

Invalid data request with Money Code Reason
    [Tags]  JIRA:ATLAS-2092    JIRA:BOT-50003    qTest:116727601
    [Documentation]  Ensure an error is returned when Money Code Reason has invalid data
    [Setup]    Add Money Code Reason List Permission to Carrier

    Login with carrier through api
    Check user Money Code Reason List permission in api
    Issue a money code with reason money code as string
    Check invalid money code reason error message code
    Issue a money code with invalid reason money code
    Check invalid money code reason error message code
    Issue a money code with reason money code as non integer number
    Check invalid money code reason error message code
    Issue a money code with reason money code as boolean
    Check invalid money code reason error message code

Issue Money Code without Money Code Reason permission
    [Tags]  JIRA:ATLAS-2092    JIRA:BOT-50003    qTest:116729362
    [Documentation]  Ensure the the issue code API works properly for a carrier without the Money Code Reason List
    ...    permission
    [Setup]    Remove Money Code Reason List Permission from Carrier

    Login with carrier through api
    Check no user Money Code Reason List permission in api
    Issue a money code without reason money code
    Check empty reason money code from issued money code
    Issue a money code
    Check empty reason money code from issued money code

*** Keywords ***
Starting Suite
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Ending Suite
    log out of card managment web services

Setup Base URL
    [Documentation]    Setup base url from portal

    ${env}    Fetch From Right    ${environment}    -
    ${base_url}    Set Variable    https://emgr.${env}.efsllc.com
    Set Suite Variable    ${base_url}

Init Session
    [Documentation]    Init session for money code apis

    RequestsLibrary.Create Session    ${session_name}    ${base_url}

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
    ...    AND member_id NOT IN ('100211', '106756', '700090', '103866')
    ...    ORDER BY c.lastupdated DESC;
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Get Valid Contract from Carrier
    [Documentation]    Get a valid carrier contract to issue money codes

    Get Into DB  TCH
    ${contract_query}  Catenate  SELECT contract_id
    ...    FROM contract
    ...    WHERE carrier_id = '${carrier.id}'
     ...    AND status = 'A';
    ${contract.id}  Query And Strip  ${contract_query}
    Set Suite Variable  ${contract.id}

Setup Valid Carrier and Contract
    [Documentation]    Getting valid data to be able to issue money codes

    Setup Carrier for Issue Money Code
    Get Valid Contract from Carrier

Add Money Code Reason List Permission to Carrier
    [Documentation]    Give the carrier the money code reason list permission

    Ensure Carrier has User Permission    ${carrier.id}    MON_CODE_REASON

Remove Money Code Reason List Permission from Carrier
    [Documentation]    Remove from carrier the money code reason list permission

    Remove Carrier User Permission    ${carrier.id}    MON_CODE_REASON

Login with carrier through api
    [Documentation]    Login through api with test carrier checking successful login

    ${login_payload}    Catenate    {
    ...    "appVersion":"4.0",
    ...    "userName":${carrier.id},
    ...    "password":${carrier.password},
    ...    "osVersion":"6.0",
    ...    "appName":"EFS_CarrierControl",
    ...    "appId":"EFS",
    ...    "osType":"android"
    ...    }
    ${response}    RequestsLibrary.POST On Session    ${session_name}
    ...    ${base_url}${login_endpoint}    ${login_payload}
    ${response}     Set Variable    ${response.json()}
    Should Be Equal As Integers    ${carrier.id}    ${response["customerUserName"]}

Get Money Code Reason List in api
    [Documentation]    Get money code reason list from api

    ${response}    RequestsLibrary.GET On Session    ${session_name}
    ...    ${base_url}${mc_reason_list_endpoint}
    ${response}     Set Variable    ${response.json()}
    ${reason_descs}    Create List
    FOR    ${item}    IN    @{response}
        Append To List    ${reason_descs}    ${item['reasonDesc']}
    END
    Set Suite Variable    ${reason_descs}

Get Money Reason Code Values from DB
    [Documentation]    Get money reason code values from db

    Get Into DB  TCH
    ${query}  Catenate  SELECT MCRL.reason_desc
    ...    FROM mon_code_reason_list as MCRL,
    ...    (SELECT first 1 carrier_type
    ...    FROM carrier_type_xref
    ...    WHERE carrier_id = ${carrier.id}
    ...    AND effective_date <= current
    ...    AND (expire_date is null OR expire_date > current)
    ...    ORDER BY effective_date DESC) as CRX
    ...    WHERE MCRL.carrier_type = 0 or MCRL.carrier_type = CRX.carrier_type;
    ${query_result}  Query And Strip To Dictionary  ${query}
    ${money_reason_codes}  Get From Dictionary  ${query_result}  reason_desc
    [Return]    ${money_reason_codes}

Get Invalid Money Reason Code from DB
    [Documentation]    Get invalid money reason code value from db

    Get Into DB  TCH
    ${query}  Catenate  SELECT MCRL.reason_code
    ...    FROM mon_code_reason_list as MCRL,
    ...    (SELECT first 1 carrier_type
    ...    FROM carrier_type_xref
    ...    WHERE carrier_id = 143543
    ...    AND effective_date <= current
    ...    AND (expire_date is null OR expire_date > current)
    ...    ORDER BY effective_date DESC) as CRX
    ...    WHERE MCRL.carrier_type = 0 or MCRL.carrier_type = CRX.carrier_type
    ...    ORDER BY MCRL.reason_code DESC;
    ${higher_reason_code}  Query And Strip  ${query}
    ${invalid_reason_code}    Evaluate    ${higher_reason_code}+1
    [Return]    ${invalid_reason_code}

Compare Money Code Reason lists
    [Documentation]    Compare money code reason list from api and from db

    ${exp_mc_reason_list}    Get Money Reason Code Values from DB
    Lists Should Be Equal    ${exp_mc_reason_list}    ${reason_descs}

Check Money Code Reason List error for no permission
    [Documentation]    Check money code reason list api return when the permission is not set

    ${response}    RequestsLibrary.GET On Session    ${session_name}
    ...    ${base_url}${mc_reason_list_endpoint}
    ${response}     Set Variable    ${response.json()}
    Set Test Variable    ${response}
    Check invalid path error message code

Get Role Info from User
    [Documentation]    Verify user roles using the role name and if it has it or not
    [Arguments]    ${role}    ${has_permission}=True

    ${response}    RequestsLibrary.GET On Session    ${session_name}
    ...    ${base_url}${get_user_endpoint}
    ${response}     Set Variable    ${response.json()}
    ${roles}    Convert To List    ${response["roles"]}
    Run Keyword If    '${has_permission}'=='True'    List Should Contain Value    ${roles}    ${role}
    ...    ELSE    List Should Not Contain Value    ${roles}    ${role}

Check user Money Code Reason List permission in api
    [Documentation]    Verify if user has the money code reason list permission

    Get Role Info from User    code/getMoneyCodeReasonList

Check no user Money Code Reason List permission in api
    [Documentation]    Verify if user hasn't the money code reason list permission

    Get Role Info from User    code/getMoneyCodeReasonList    False

Issue a money code
    [Documentation]    Issue a money code through api
    ...    Set empty to the property to has it removed from the body payload
    [Arguments]    ${contract_id}=${contract.id}    ${amount}=5.00    ${issue_to}=Test Issue To    ${notes}=Test Notes
    ...    ${deduct_fee}=true    ${info_list}=[]    ${mc_code_reason}=${mc_code_default}

    ${issue_mc_payload}    Create Dictionary
    Set to dictionary if not empty    ${issue_mc_payload}    ${contract_id}    contract
    Set to dictionary if not empty    ${issue_mc_payload}    ${amount}    amount
    Set to dictionary if not empty    ${issue_mc_payload}    ${issue_to}    issueTo
    Set to dictionary if not empty    ${issue_mc_payload}    ${notes}    notes
    Set to dictionary if not empty    ${issue_mc_payload}    ${deduct_fee}    deductFee
    Set to dictionary if not empty    ${issue_mc_payload}    ${info_list}    infoList
    Set to dictionary if not empty    ${issue_mc_payload}    ${mc_code_reason}    moneyCodeReason
    ${issue_mc_payload}     Convert To String    ${issue_mc_payload}
    ${issue_mc_payload}    Replace String    ${issue_mc_payload}    '    "
    ${issue_mc_payload}    Replace String    ${issue_mc_payload}    "true"    true
    ${issue_mc_payload}    Replace String    ${issue_mc_payload}    "false"    false
    ${issue_mc_payload}    Replace String    ${issue_mc_payload}    "null"    null
    ${issue_mc_payload}    Replace String    ${issue_mc_payload}    "" ""    " "
    ${response}    RequestsLibrary.POST On Session    ${session_name}
    ...    ${base_url}${issue_mc_endpoint}    ${issue_mc_payload}
    ${response}     Set Variable    ${response.json()}
    Set Test Variable    ${response}
    ${hasType}    Run Keyword and Return Status    Get From Dictionary     ${response}    type
    Run Keyword If    '${hasType}'=='True'    Return From Keyword If    '${response['type']}'=='ERROR'
    Set Test Variable    ${code_id}    ${response["reference"]}
    Set Test Variable    ${express_code}    ${response["code"]}

Set to dictionary if not empty
    [Documentation]    Add to dictionay if the value is not empty
    [Arguments]    ${dict}    ${value}    ${property}

    Run Keyword If    '${value}'!='${EMPTY}'    Set To Dictionary    ${dict}    ${property}=${value}

Issue a money code without reason money code
    [Documentation]    Issuing a money code without the reason money code property set

    Issue a Money Code    mc_code_reason=${EMPTY}

Issue a money code with reason money code as null
    [Documentation]    Issuing a money code with the reason money code as null

    Issue a Money Code    mc_code_reason=null

Issue a money code with reason money code as empty string
    [Documentation]    Issuing a money code with the reason money code as an empty string

    Issue a Money Code    mc_code_reason=" "

Issue a money code with invalid reason money code
    [Documentation]    Issuing a money code with an invalid reason money code value
    ...    i.e. out of the range of valid reason codes

    ${invalid_reason_code}    Get Invalid Money Reason Code from DB
    Issue a Money Code    mc_code_reason=${invalid_reason_code}

Issue a money code with reason money code as string
    [Documentation]    Issuing a money code with the reason money code as a string

    Issue a Money Code    mc_code_reason=test

Issue a money code with reason money code as non integer number
    [Documentation]    Issuing a money code with the reason money code as an non integer number

    Issue a Money Code    mc_code_reason=2.5

Issue a money code with reason money code as boolean
    [Documentation]    Issuing a money code with the reason money code as a boolean value

    Issue a Money Code    mc_code_reason=true

Check Reason Money Code From Issued Money Code
    [Documentation]    Assertion on reason money code list and gets its description to compare later
    [Arguments]    ${mon_code_reason}=${mc_code_default}

    Get Into DB  TCH
    ${query}  Catenate  SELECT mon_code_reason_id
    ...    FROM mon_codes
    ...    WHERE code_id = '${code_id}'
    ...    AND express_code = '${express_code}';
    ${mon_code_reason_id}  Query And Strip    ${query}
    Run Keyword If    '${mon_code_reason}'!='${EMPTY}'    Should Be Equal as Numbers    ${mon_code_reason_id}    ${mon_code_reason}
    ...    ELSE    Should Be Equal as Strings    ${mon_code_reason_id}    None

Check empty reason money code from issued money code
    [Documentation]    Verify reason money code is set as empty in database for issued money code

    Check Reason Money Code From Issued Money Code    ${EMPTY}

Check error message code
    [Documentation]    Verify error message from api response
    [Arguments]    ${response}    ${code}

    Should Be Equal As Strings      ${response['type']}    ERROR
    Should Start With    ${response['code']}    ${code}

Check invalid path error message code
    [Documentation]    Verify invalid path error message from api response

    Check error message code    ${response}    InvalidPath-

Check invalid money code reason error message code
    [Documentation]    Verify invalid money code reason error message from api response

    Check error message code    ${response}    InvalidMoneyCodeReason