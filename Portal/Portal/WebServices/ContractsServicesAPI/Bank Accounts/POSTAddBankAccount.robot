*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService

Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This Script tests the endpoint that Adds a Bank Account to a given carrier and contract

Suite Setup  Get Url For Suite    ${creditcontract}

Force Tags    Refactor

*** Test Cases ***
POST Bank Account to Credit Contract of a Carrier
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:53844836  bank_accounts  ditOnly
    [Documentation]  test the endpoint to add a bank account to Credit contract of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Create My User  persona_name=bank_acct_mgr_all_types  entity_id=${data_info}[carrier_id]
    POST Request Add Bank
    Compare Added Bank Data For Credit Contract
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Parent Carrier
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:116072046  bank_accounts  ditOnly
    [Documentation]  test the endpoint to add a bank account to Parent contract of a carrier
    [Setup]  Find Data For Adding Bank Account For Parent_Carrier Contract
    Create My User  persona_name=bank_acct_mgr_all_types  entity_id=${data_info}[carrier_id]
    POST Request Add Bank
    Compare Added Bank Data For Parent_Carrier Contract
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Parent Funded
    [Tags]  JIRA:O5SA-417  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:53751612  bank_accounts  ditOnly
    [Documentation]  test the endpoint to add a bank account to Parent contract of a carrier
    [Setup]  Find Data For Adding Bank Account For Parent_Funded Contract
    Create My User  persona_name=bank_acct_mgr_all_types  entity_id=${data_info}[carrier_id]
    POST Request Add Bank
    Compare Added Bank Data For Parent_Funded Contract
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Different Contract Type
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Add Bank Account With Different Contract Type For Credit And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Existing Account_nbr For Credit
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Add Bank Account With Existing Account_nbr For Credit And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Different Contract Type For Parent_Carrier
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Parent_Carrier Contract
    Add Bank Account With Different Contract Type For Parent_Carrier And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Existing Account_nbr For Parent_Carrier
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Parent_Carrier Contract
    Add Bank Account With Existing Account_nbr For Parent_Carrier And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Different Contract Type For Parent_Funded
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Parent_Funded Contract
    Add Bank Account With Different Contract Type For Parent_Funded And Expect Error
    [Teardown]  Remove Automation User


POST Bank Account to Contract of a Carrier With Existing Account_nbr For Parent_Funded
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Parent_Funded Contract
    Add Bank Account With Existing Account_nbr For Parent_Funded And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Empty Account_name
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Add Bank Account With Empty Account_name And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Empty Account_nbr
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Add Bank Account With Empty Account_nbr And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Empty Routing_nbr
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Add Bank Account With Empty Routing_nbr And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With Empty Name
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Add Bank Account With Empty Name And Expect Error
    [Teardown]  Remove Automation User

POST Bank Account to Contract of a Carrier With An Invalid Account_type
    [Tags]  JIRA:O5SA-298  JIRA:O5SA-27  JIRA:O5SA-105  JIRA:O5SA-416  qTest:55586892  bank_accounts  ditOnly
    [Documentation]  test expected errors from the endpoint to add a bank account to contract (Parent_carrier, Parent_funded and Credit) of a carrier
    [Setup]  Find Data For Adding Bank Account For Credit Contract
    Add Bank Account With An Invalid Account_type And Expect Error
    [Teardown]  Remove Automation User

*** Keywords ***
Find Data For Adding Bank Account For ${contract_type} Contract
    [Documentation]    find data to be used during the test and make the request with it
    ${contract_type}  String.Convert To Upper Case  ${contract_type}

    ${carrier}  Find Carrier Types In Oracle  type=${contract_type}  legacy=Y  wildfilter=bank

    IF  '${contract_type}'=='PARENT_CARRIER'
        ${temp_query}  Catenate  and c.issuer_id in (select issuer_id from carrier_group_issuer where role = '1')
    ELSE IF  '${contract_type}'=='PARENT_FUNDED'
        ${temp_query}  Catenate  and c.issuer_id in (select issuer_id from carrier_group_issuer where role = '2' )
    ELSE IF  '${contract_type}'=='CREDIT'
        ${temp_query}  Catenate  and c.issuer_id not in (select issuer_id from carrier_group_issuer)
    END

    ${data_query}  Catenate     select c.contract_id, c.carrier_id, trim(c.ar_number) as ar_number
                   ...          from contract c
                   ...          where c.carrier_id = '${carrier}'
                   ...          and c.last_trans is not null
                   ...          ${temp_query} limit 1
    Get Into DB  TCH
    ${data_info}  Query And Strip To Dictionary    ${data_query}
    Disconnect From Database

    ${account_nbr}  Generate Random String  6  [NUMBERS]
    ${routing_nbr}  Set Variable    124000054
    ${account_type}  Set Variable    CHECKING

    ${url}  Create Dictionary   carriers=${data_info}[carrier_id]  contracts=${data_info}[contract_id]  contract-types=${contract_type}

    ${payload}  Create Dictionary  ar_number=${data_info}[ar_number]
                ...                account_name=AccNmRbtGeneral
                ...                account_nbr=${account_nbr}
                ...                account_type=${account_type}
                ...                routing_nbr=${routing_nbr}
                ...                name=NameRbtGeneral

    IF  '${contract_type}'=='CREDIT'
        Set To Dictionary    ${payload}  account_name=AccNmRbtCredit  name=NameRbtCredit

    ELSE IF  '${contract_type}'=='PARENT_CARRIER'
        Set To Dictionary    ${payload}  account_name=AccNmRbtParentCarrier  name=NameRbtParentCarrier

    ELSE IF  '${contract_type}'=='PARENT_FUNDED'
        Set To Dictionary    ${payload}  account_name=AccNmRbtParentFunded  name=NameRbtParentFunded

    END

    Set Test Variable  ${data_info}
    Set Test Variable  ${url}
    Set Test Variable  ${payload}

POST Request Add Bank
    [Documentation]    request to add a bank account to a contract of a carrier
    ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}
    Set Test Variable  ${status}
    Set Test Variable  ${result}

Compare Added Bank Data For ${contract_type} Contract
    [Documentation]    compare the data from the response body and gathered in the database
    ${contract_type}  String.Convert To Upper Case  ${contract_type}

    Should Be Equal As Strings  ${status}  201

    IF  '${contract_type}'=='CREDIT' or '${contract_type}'=='PARENT_CARRIER'
        Should Be Equal As Strings  ${status}  201

        ${query}  Catenate    select * from apps.xxtch_ar_cust_bank_acct_v
                  ...         where ar_number IN ('${result}[details][data][ar_number]')
                  ...         and bank_account_num = '${payload}[account_nbr]'
                  ...         order by XXTCH_AR_CUST_STG_ID desc
        Get Into DB    ORACLE
        ${query_result}  Query And Strip To Dictionary    ${query}
        Disconnect From Database

        Should Be Equal As Strings  ${result}[details][data][ar_number]  ${query_result}[ar_number]

    ELSE IF  '${contract_type}'=='PARENT_FUNDED'
        ${query}  Catenate    select trim(h.description) as bank_account_name,
                  ...         case h.transaction_code when '22' then 'CHECKING' when '32' then 'SAVINGS' else 'NONE' end as bank_account_type,
                  ...         h.ppd_header_id,
                  ...         case ref.primary_bank when 'Y' then 'Y' else 'N' end as primary_flag,
                  ...         h.receiving_dfi_identification,
                  ...         trim(dfi_account_number) as dfi_account_number,
                  ...         case when (h.verify_date is null and h.verify_amount_1 is null) then 'PENDING' when (h.verify_date is null and h.verify_amount_1 is not null) then 'READY_TO_VERIFY' when (h.verify_date is not null) then 'VERIFIED' end as bank_acct_stg_status
                  ...         from ach_ppd_header h
                  ...         inner join ach_ppd_contract_xref ref on (ref.ppd_header_id = h.ppd_header_id)
                  ...         where h.ppd_header_id = '${result}[details][data][bank_account_id]';
        Get Into DB    TCH
        ${query_result}    Query And Strip To Dictionary    ${query}
        Disconnect From Database

        Should Be Equal As Strings  ${result}[details][data][bank_account_id]  ${query_result}[ppd_header_id]
        Should Be Equal As Strings  ${result}[details][data][routing_nbr]  ${query_result}[receiving_dfi_identification]
        Should Be Equal As Strings  ${payload}[account_nbr]  ${query_result}[dfi_account_number]

    ELSE
        Fail  ${contract_type} is not implemented yet to compare added bank data
    END

    Should Be Equal As Strings  ${result}[details][data][account_name]  ${query_result}[bank_account_name]
    Should Be Equal As Strings  ${result}[details][data][account_type]  ${query_result}[bank_account_type]
    Should Be Equal As Strings  ${result}[details][data][primary_flag]  ${query_result}[primary_flag]
    Should Be Equal As Strings  ${result}[details][data][routing_nbr]  ${payload}[routing_nbr]
    Should Contain   ${query_result}[bank_acct_stg_status]  ${result}[details][data][status]
    Should Contain   ${result}[details][data]  links

Add Bank Account With ${mistake} And Expect Error
    [Documentation]    Keyword to attempt and check the Add Bank account errors
    ${mistake}  String.Convert To Upper Case  ${mistake}

    Create My User  persona_name=bank_acct_mgr_all_types  entity_id=${data_info}[carrier_id]

    IF  '${mistake}'=='INVALID TOKEN'
        ${result}  ${status}  API Request  POST  bank-accounts  I  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  401
        Should Be Empty    ${result}

    ELSE IF  '${mistake}'=='CARRIER NOT ASSIGNED'
        ${carrier2}  Find Carrier Types In Oracle    carrierlimit=50  type=credit  legacy=Y  wildfilter=bank
        Set To Dictionary    ${url}  carriers=${carrier2}

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  403
        Should Be Equal     ${result}[0]    message
        Should Be Equal     ${result}[1]    name

    ELSE IF  '${mistake}'=='DIFFERENT CONTRACT TYPE FOR CREDIT'
        Set To Dictionary    ${url}  contract-types=parent_carrier

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    error_code
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE IF  '${mistake}'=='EXISTING ACCOUNT_NBR FOR CREDIT'
        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}
        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  422
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    message
        Should Be Equal     ${response}[1]    name

    ELSE IF  '${mistake}'=='DIFFERENT CONTRACT TYPE FOR PARENT_CARRIER'
        Set To Dictionary    ${url}  contract-types=credit

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    error_code
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE IF  '${mistake}'=='EXISTING ACCOUNT_NBR FOR PARENT_CARRIER'
        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}
        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  422
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    message
        Should Be Equal     ${response}[1]    name

    ELSE IF  '${mistake}'=='DIFFERENT CONTRACT TYPE FOR PARENT_FUNDED'
        Set To Dictionary    ${url}  contract-types=credit

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    error_code
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE IF  '${mistake}'=='EXISTING ACCOUNT_NBR FOR PARENT_FUNDED'
        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}
        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  422
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    message
        Should Be Equal     ${response}[1]    name

    ELSE IF  '${mistake}'=='EMPTY ACCOUNT_NAME'
        Set To Dictionary    ${payload}  account_name=${EMPTY}

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    details
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE IF  '${mistake}'=='EMPTY ACCOUNT_NBR'
        Set To Dictionary    ${payload}  account_nbr=${EMPTY}

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    details
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE IF  '${mistake}'=='EMPTY ROUTING_NBR'
        Set To Dictionary    ${payload}  routing_nbr=${EMPTY}

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    details
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE IF  '${mistake}'=='EMPTY NAME'
        Set To Dictionary    ${payload}  name=${EMPTY}

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    details
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE IF  '${mistake}'=='AN INVALID ACCOUNT_TYPE'
        Set To Dictionary    ${payload}  account_type=INVALID

        ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}

        Should Be Equal As Strings    ${status}  400
        ${response}  Get Dictionary Keys  ${result}
        Should Be Equal     ${response}[0]    details
        Should Be Equal     ${response}[1]    message
        Should Be Equal     ${response}[2]    name

    ELSE
        Fail  The '${mistake}' is not an implemented expected error scenario
    END