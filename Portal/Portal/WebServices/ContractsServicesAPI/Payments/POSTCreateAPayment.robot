*** Settings ***
Library      String
Library      Collections
Library      otr_robot_lib.ws.PortalWS
Library      otr_model_lib.services.GenericService
Library      otr_robot_lib.ws.RestAPI.RestAPIService
Library      otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library      otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Resource     otr_robot_lib/robot/APIKeywords.robot

Force Tags   CreditContractServicesAPI API

Documentation  This is a File for endpoint POST create a payment in invoice_match and FIFO
...  This is the story to add negative settings and Create a payment in FIFO.
...  https://wexinc.atlassian.net/browse/O5SA-414

*** Variables ***


*** Test Cases ***
POST Payment Invoice_match
    [Tags]  JIRA:O5SA-31  qTest:55597658    qTest:55842643  ditOnly     Payment     PI:14  refactor
    [Documentation]  test the post payment invoice endpoint that uses carrier id and contract id
    Find a body for payment for a contract and a carrier      Invoice_Match
    Create My User      persona_name=carrier_manager         entity_id=${carrier}
    Get Url For Suite     ${creditcontract}
    Post Payment
    Compare Data for invoice_match
    [Teardown]  Remove Automation User


*** Keywords ***
Find a body for payment for a contract and a carrier
    [Arguments]    ${type}

    ${date}     Get Current Date   UTC  -5 hour
    ${date}     Add Time To Date  ${date}  302 minute
    ${date}     convert date      ${date}    result_format=datetime
    ${month}    set variable      ${date.month}
    ${month}    evaluate          f'{${month}:02d}'
    ${day}      set variable      ${date.day}
    ${day}      Evaluate          f'{${date.day}:02d}'
    ${date1}    set variable      ${date.year}-${month}-${day}
    ${minute}   Set Variable     ${date.minute}
    ${minute}   Evaluate         f'{${date.minute}:02d}'
    ${second}   Evaluate         f'{${date.second}:02d}'
    ${date2}    set variable      ${date.hour}:${minute}:${second}.${date.microsecond}
    ${date}     catenate          ${date1}T${date2}Z


    IF       '${type}'=='Invoice_Match'
             set test variable    ${carrier}     345016
             set test variable    ${contract}    390054
             set test variable    ${bank_account_id}     327940
             set test variable    ${ar_number}    0006332000026
             set test variable    ${amount}       5
             Set Test Variable    ${payment_application_type}   invoice_match
             set test variable    ${invoice_number}   43185017
             set test variable    ${aplied_amount}    5
             Set Test Variable    ${comments}       test_api_automation

# For this execution, use the QTEST 55597658 to get a good data if the automation brokes.

             ${invoice_list}  Create Dictionary    invoice_number=${invoice_number}  applied_amount=${aplied_amount}
             ${invoice_list}  create list          ${invoice_list}

             ${payload}=  Create Dictionary       bank_account_id=${bank_account_id}      ar_number=${ar_number}
                ...                               amount=${amount}       apply_date=${date}
                ...                               payment_application_type=${payment_application_type}
                ...                               invoice_amount_list=${invoice_list}
                ...                               comments=${comments}
#TODO implement Dynamic data on invoice_match.


             Set Test Variable    ${payload}
    ELSE
             Fail     ${type} not yet implemented
    END


    ${dictonary_url}    Create Dictionary       carriers=${carrier}     contracts=${contract}

             Set Test Variable    ${dictonary_url}

POST Payment
    [Documentation]     Request for carrier and contract_id

    ${result}  ${status}  API Request  POST  payments  Y  ${dictonary_url}  application=OTR_eMgr  payload=${payload}


    Set Test Variable    ${result}
    Set Test Variable    ${status}


Compare Data for invoice_match
    [Documentation]   Get the transaction on Oracle DataBase

    get into db  Oracle
    ${query}    Catenate    Select *
    ...     from xxtch.xxtch_ar_cash_receipts_iface
    ...     Where customer_number = '0006332000026'
    ...     AND NOTES = 'test_api_automation'
    ...     Order by record_id DESC
    ...     FETCH NEXT 1 ROWS ONLY
    ${query_result}     Query And Strip To Dictionary    ${query}
    Disconnect From Database
    Set Test Variable    ${query_result}


    Should Be Equal As Strings         ${status}      200

    Should Be Equal     ${result}[details][type]        SuccessDTO
    Should Be Equal     ${result}[message]    SUCCESSFUL
    Should Be Equal     ${result}[name]    OK

