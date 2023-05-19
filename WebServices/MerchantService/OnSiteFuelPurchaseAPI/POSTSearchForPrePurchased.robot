*** Settings ***
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup    Setup the environment to START

Suite Teardown   Remove User If Still Exists

Force Tags    API   MerchantServicesAPI  OnSite_FuelPurchase    T-check     ditOnly

*** Variables ***
${db}  postgresmerchants

*** Test Cases ***
POST Search for pre-purchased with only start_transaction_date
    [Tags]      Q1:2023      JIRA:O5SA-521      qTest:119072603   SearchPurchase
    [Documentation]  This is to test a POST endpoint to search pre-purchased using only the startDate field to search.
    Use The POST Endpoint To Search For Pre-purchased With Start_date
    Compare the results

POST Search for pre-purchased using start_transaction_date and invoice_number
    [Tags]      Q1:2023      JIRA:O5SA-521      qTest:119072603    SearchPurchase
    Use the POST endpoint to search for pre-purchased with invoice_match and start_date
    Compare the results with invoice_number


POST Search for pre-purchased - ERROR 400 no body
    [Tags]           Q1:2023   JIRA:O5SA-521   qTest:119072604   SearchPurchase
    [Documentation]  This is to test a POST endpoint to search pre-purchased using no field to executed.
    Use The POST Endpoint To Search For Pre-purchased with no body
    Compare the wrong results

POST Search for pre-purchased - ERROR 400 with wrong start_transaction_date
    [Tags]           Q1:2023    JIRA:O5SA-521   qTest:119072604   SearchPurchase
    [Documentation]  This is to test a POST endpoint to search pre-purchased using a wrong startDate to failed.
    Use The POST Endpoint To Search For Pre-purchased with wrong body
    Compare the wrong results with wrong body

*** Keywords ***
Setup the environment to START
    Connect to the API URL
    Get the necessary data to find start date
    Authorize the user for selected MERCHANT_ID

Connect to the API URL
    [Documentation]  Use to connect to the API
    Get URL For Suite    ${MerchantService}

Authorize the user for selected MERCHANT_ID
    [Documentation]    Use to create and authorize the user for selected MERCHANT_ID
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager
    ...             entity_id=${merchant_id}  with_data=N  need_new_user=Y

Get the necessary data to find start date
    [Documentation]    Using this keyword to find data for the execution
    Get Into Db   ${db}
    ${query}   Catenate    select
...    bh.merchant_id,
...    TO_CHAR(pp.pos_date::timestamp - interval '1 day', 'yyyy-MM-ddThh:mm:ss.MSZ') as pos_date,
...    pp.invoice_number
...    from
...    pre_purchase pp
...    inner join batch_history bh on
...    pp.batch_id = bh.batch_id
...       where
...    pp.pos_date is not null
...    and pp.pos_date < now()
...    and pp.pre_purchase_status != 'DELETED'
...    order by
...    random() limit 1;

    ${result}  Query And Strip To Dictionary    ${query}

    Disconnect From Database
    Set Suite Variable     ${merchant_id}       ${result['merchant_id']}
    Set Suite Variable     ${invoice_number}     ${result['invoice_number']}
    Set Suite Variable     ${pos_date}          ${result['pos_date']}
    Set Suite Variable     ${result}

Use the POST endpoint to search for pre-purchased with start_date
    [Documentation]     Creating the body and executing the endpoint

    ${url}   Create List       ${merchant_id}  purchases  search
    ${start_date_dictonary}  Create Dictionary       start_transaction_date=${pos_date}
    ${parameter_option}     Create List          page=0     size=10

    ${response}     ${status}   API Request  POST  merchants  Y  ${url}  ${parameter_option}  application=Merchant Manager  payload=${start_date_dictonary}

    Set Suite Variable   ${response}
    Set Suite Variable    ${status}

Use the POST endpoint to search for pre-purchased with invoice_match and start_date
    [Documentation]     Creating the body and executing the endpoint

    ${url}   Create List       ${merchant_id}    purchases  search
    ${start_date_dictonary}  Create Dictionary   start_transaction_date=${pos_date}     invoice_number=${invoice_number}
    ${parameter_option}     Create List          page=0     size=10

    ${response}     ${status}   API Request  POST  merchants  Y  ${url}  ${parameter_option}  application=Merchant Manager  payload=${start_date_dictonary}

    Set Suite Variable   ${response}
    Set Suite Variable    ${status}

Compare the results with invoice_number
    [Documentation]     Get the results from the endpoint and comparing with the database
    Should Be Equal As Strings         ${status}                 200
    Should Be Equal As Strings         ${response}[name]         OK
    Should Be Equal As Strings         ${response}[message]      SUCCESSFUL

    Get Into Db   ${db}
    ${query}   Catenate  select pp.pre_purchase_id, pp.pre_purchase_status,
     ...   TO_CHAR(pp.pos_date, 'yyyy-MM-ddThh:mm:ss.MSZ') as pos_date,
     ...   TRIM(TO_CHAR(pp.total_amount, '9999999.999')) AS total_amount, pp.invoice_number
     ...   from pre_purchase pp
     ...   inner join batch_history bh ON bh.batch_id = pp.batch_id
     ...   where bh.merchant_id = ${merchant_id} and pp.invoice_number = '${invoice_number}'
     ...   and (pp.pos_date >= '${pos_date}')
     ...   and pp.pre_purchase_status <> 'DELETED'
     ...   order by pp.pos_date DESC,  pp.pre_purchase_id DESC
     ...   limit 1;
    ${result}  Query And Strip To Dictionary      ${query}

    Disconnect From Database

    Should Be Equal As Strings    ${response}[details][data][0][status]   ${result}[pre_purchase_status]
    Should Be Equal As Strings    ${response}[details][data][0][id]   ${result}[pre_purchase_id]
    ${element_exists}    Run Keyword And Return Status    Element Should Be Visible     ${response}[details][data][0][total_amount]
    Run Keyword If      'total_amount' in ${response}[details][data][0]    Should Be True    ${response}[details][data][0][total_amount] - ${result}[total_amount] < 0.0001

Compare the results
    [Documentation]     Get the results from the endpoint and comparing with the database
    Should Be Equal As Strings         ${status}                 200
    Should Be Equal As Strings         ${response}[name]         OK
    Should Be Equal As Strings         ${response}[message]      SUCCESSFUL

    Get Into Db   ${db}
    ${query}   Catenate  select prepurchas0_.pre_purchase_id as pre_purchase_id, prepurchas0_.pre_purchase_status
    ...     from pre_purchase prepurchas0_
    ...     inner join batch_history batchhisto1_ ON prepurchas0_.batch_id = batchhisto1_.batch_id
    ...     where batchhisto1_.merchant_id=${merchant_id}
    ...      and (prepurchas0_.pos_date >= '${pos_date}')
    ...     and prepurchas0_.pre_purchase_status != 'DELETED'
    ...     order by prepurchas0_.pos_date DESC, prepurchas0_.pre_purchase_id DESC
    ...     limit 10;
    ${result}  Query And Strip To Dictionary      ${query}

    Disconnect From Database
    FOR  ${i}  IN RANGE   len(${response}[details][data])
        Should Be Equal As Strings    ${response}[details][data][${i}][status]   ${result}[pre_purchase_status][${i}]
        Should Be Equal As Strings    ${response}[details][data][${i}][id]   ${result}[pre_purchase_id][${i}]
    END

Use The POST Endpoint To Search For Pre-purchased with no body
    [Documentation]     creating a JSON with no body to execute the endpoint

    ${url}   Create List       ${merchant_id}  purchases  search
    ${start_date_dictonary}  Create Dictionary       start_transaction_date=0
    ${parameter_option}     Create List          page=0     size=10

    ${response}     ${status}   API Request  POST  merchants  Y  ${url}  ${parameter_option}  application=Merchant Manager

    Set Test Variable    ${response}
    Set Test Variable    ${status}

Use The POST Endpoint To Search For Pre-purchased with wrong body
    [Documentation]     creating a JSON with a future data to execute the endpoint

    ${date}     Get Current Date   UTC
    ${date}     Add Time To Date   ${date}   1825 days      #it's about 5 years.
    ${date}     Split String       ${date}  ${space}
    ${date}     Evaluate           "T".join(${date})
    ${date}     catenate           ${date}Z

    ${url}   Create List       ${merchant_id}  purchases  search
    ${start_date_dictonary}  Create Dictionary       start_transaction_date=${date}
    ${parameter_option}     Create List          page=0     size=10
    ${response}     ${status}   API Request  POST  merchants  Y  ${url}  ${parameter_option}  application=Merchant Manager  payload=${date}

    Set Test Variable    ${response}
    Set Test Variable    ${status}

Compare the wrong results
    [Documentation]     comparing all the bad results using bad data
    Should Be Equal As Strings         ${status}                400
    Should Be Equal As Strings         ${response}[name]        BAD_REQUEST
    Should Be Equal As Strings         ${response}[message]     Invalid request input

Compare the wrong results with wrong body
    [Documentation]     comparing all the bad results using bad data
    Should Be Equal As Strings         ${status}      400
    #The response body is doesn't show up in the automation.