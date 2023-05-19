*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup        Setting up testing environment
Test Teardown      Delete bank account and remove user
Force Tags      CreditContractServicesAPI  API  refactor

Documentation   Verify the bank account for the user and verify the good or bad amount for it.

*** Test Cases ***
POST Verify a Bank Account for new account for Parent Funded
    [Tags]  JIRA:O5SA-296   qTest:53830542      bank_accounts  ditOnly  PI:15
    [Documentation]     This test case is to create a bank account and verify the amount added.
    [Setup]     Find Data For Adding Bank Account For Parent_funded Contract
    POST Request Add Bank
    Create a verify amount for PARENT_FUNDED
    POST Verify a bank account
    Verify a amount added on Database

POST Verify a bank Account for new account for Parent Funded with wrong value on amount
    [Tags]   JIRA:O5SA-296      qTest:53845459     bank_accounts  ditOnly   PI:15
    [Documentation]     This test case is to create a bank account and verify the wrong amount added.
    [Setup]     Find Data For Adding Bank Account For PARENT_FUNDED Contract
    POST Request Add Bank
    Create a verify wrong amount for PARENT_FUNDED

*** Keywords ***
Setting up testing environment
    [Documentation]         Setting the data for this execution
    Check For My Automation User
    Get url for suite   ${creditcontract}

Find Data For Adding Bank Account For ${contract_type} Contract
    [Documentation]    find data to be used during the test and make the request with it
    ${contract_type}  String.Convert To Upper Case  ${contract_type}
    ${api_data_value}  get variable value  $api_data  default
    ${user_value}  get variable value  $user_status  default

    IF  $api_data_value=='default'
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

        ${url}  Create Dictionary   carriers=${data_info}[carrier_id]  contracts=${data_info}[contract_id]
        ...  contract-types=${contract_type}

        ${payload}  Create Dictionary  ar_number=${data_info}[ar_number]
                    ...                account_name=AccNmRbtGeneral
                    ...                account_nbr=${account_nbr}
                    ...                account_type=${account_type}
                    ...                routing_nbr=${routing_nbr}
                    ...                name=NameRbtGeneral

        Create My User  persona_name=bank_acct_mgr_all_types  entity_id=${data_info}[carrier_id]  with_data=N  need_new_user=N

        Set Suite Variable  ${data_info}
        Set Suite Variable  ${url}
        Set Suite Variable  ${payload}
    END

    Set Suite Variable  ${api_data}  ${data_info}

    IF  '${contract_type}'=='CREDIT'
        Set To Dictionary    ${payload}  account_name=AccNmRbtCredit  name=NameRbtCredit

    ELSE IF  '${contract_type}'=='PARENT_CARRIER'
        Set To Dictionary    ${payload}  account_name=AccNmRbtParentCarrier  name=NameRbtParentCarrier

    ELSE IF  '${contract_type}'=='PARENT_FUNDED'
        Set To Dictionary    ${payload}  account_name=AccNmRbtParentFunded  name=NameRbtParentFunded

    END

POST Request Add Bank
    [Documentation]    request to add a bank account to a contract of a carrier
    ${result}  ${status}  API Request  POST  bank-accounts  Y  ${url}  application=OTR_eMgr  payload=${payload}
    Set Test Variable  ${status}
    Set Test Variable  ${result}

Create a verify amount for ${contract_type}
    [Documentation]         creating a value for amount 1 and 2.

    ${data_query}   Catenate
    ...                         UPDATE ach_ppd_header    SET verify_amount_1 = 0.45,  verify_amount_2 = 0.63
    ...                         WHERE ppd_header_id = ${result}[details][data][bank_account_id];
    execute sql string          dml=${data_query}   db_instance=tch

    ${payload_amount}      Create Dictionary       first_amount=0.45      second_amount=0.63

    ${dictonary_url}       Create Dictionary    ${None}=${result}[details][data][bank_account_id]
    ...                                         carriers=${data_info}[carrier_id]  contracts=${data_info}[contract_id]
    ...                                         contract-types=${contract_type}    bank-account-validation=${none}

    Set Test Variable       ${dictonary_url}
    Set Test Variable       ${payload_amount}

Create a verify wrong amount for ${contract_type}
    [Documentation]    Creating a wrong value for amount 1 and 2.

    ${data_query}   Catenate
    ...                         UPDATE ach_ppd_header    SET verify_amount_1 = 0.40,  verify_amount_2 = 0.63
    ...                         WHERE ppd_header_id = ${result}[details][data][bank_account_id];
    execute sql string          dml=${data_query}   db_instance=tch

    ${payload_amount}      Create Dictionary       first_amount=0.50      second_amount=0.63

    ${dictonary_url}       Create Dictionary    ${None}=${result}[details][data][bank_account_id]
    ...                                         carriers=${data_info}[carrier_id]  contracts=${data_info}[contract_id]
    ...                                         contract-types=${contract_type}    bank-account-validation=${none}

    Set Test Variable       ${dictonary_url}
    Set Test Variable       ${payload_amount}

    ${result}  ${status}  API Request  POST  bank-accounts  Y  ${dictonary_url}  application=OTR_eMgr
    ...                                payload=${payload_amount}

    Set Test Variable    ${result}
    Set Test Variable    ${status}

    Should Be Equal As Strings   ${result}[message]     Invalid deposit amounts
    Should Be Equal As Strings    ${status}     400

POST Verify a bank account
    [Documentation]     Request to execute the API

    ${result}  ${status}  API Request  POST  bank-accounts  Y  ${dictonary_url}  application=OTR_eMgr
    ...                                payload=${payload_amount}

    Set Test Variable    ${result}
    Set Test Variable    ${status}

Verify a amount added on Database
    [Documentation]     resquest to add a value on verify amount

    Get Into Db    Tch
    ${data_query}   Catenate    select * from ach_ppd_header order by verify_date desc limit 1;
    ${data_info}  Query And Strip To Dictionary    ${data_query}

    Should Be Equal As Strings    ${status}     200
    Should Be Equal               ${result}[details][data][bank_account_id]    ${data_info}[ppd_header_id]
    Should Be Equal               ${result}[details][data][status]     VERIFIED

    Disconnect from Database

Delete the bank account
    [Documentation]         Deleting the test

    Remove From Dictionary    ${dictonary_url}      bank-account-validation
    ${result}  ${status}  API Request  DELETE  bank-accounts  Y  ${dictonary_url}  application=OTR_eMgr

    Set Test Variable    ${result}
    Set Test Variable    ${status}

Delete bank account and remove user
    [Documentation]     Using this testing to remove the bank acount and remove the user
    Delete the bank account
    Remove User if Necessary
