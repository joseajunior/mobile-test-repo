*** Settings ***
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint [POST to search for recent purchases for their carrier id and policy number]
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  T-Check  ditOnly  CarrierPurchaseAPI

*** Variables ***
${db}  postgresmerchants

*** Test Cases ***
############################## Carrier Purchase API #################################
#-----------------------------------------------------------------------------------#
#         Endpoint POST:  /carrier-purchases/carriers/{carrier_id}/search           #
#-----------------------------------------------------------------------------------#
(Carrier Purchase API) POST - Search by carrier for "EXISTENT" Purchases
    [Tags]           Q2:2023   JIRA:O5SA-645  qTest:120562636
    [Documentation]  This is to test [POST to search for recent purchases for their carrier id]
    ...              endpoint, using the request body as EMPTY { }. In this case, the data EXIST in the database so,
    ...              The API status should be (200 OK) with purchases READY_FOR_CARRIER_APPROVAL details displayed
    [Setup]     Getting data and authorizing the user
    Use the POST endpoint to search by carrier for Purchases READY_FOR_CARRIER_APPROVAL
    The API status should be "200 with the purchases details displayed"
    Compare the API response with the database
    [Teardown]  Remove Automation User

(Carrier Purchase API) POST - Search by carrier for "EXISTENT" Purchases with Policy Number
    [Tags]           Q2:2023   JIRA:O5SA-660  qTest:120562636
    [Documentation]  This is to test [POST to search for recent purchases for their carrier id and policy number]
    ...              endpoint, using the request body with policy_number informed. In this case, the data EXIST in the
    ...              database so, the API status should be (200 OK) with the details of purchases READY_FOR_CARRIER_APPROVAL
    ...              with the respective policy_number informed displayed
    [Setup]     Getting data and authorizing the user  policy=${TRUE}
    Use the POST endpoint to search by carrier for Purchases READY_FOR_CARRIER_APPROVAL WITH POLICY INFORMED
    The API status should be "200 with the purchases details displayed"
    Compare the API response with the database  policy=${TRUE}
    [Teardown]  Remove Automation User

(Carrier Purchase API) POST - Search by carrier for "NON-EXISTENT" Purchases
    [Tags]           Q2:2023   JIRA:O5SA-645   JIRA:O5SA-660  qTest:120562636
    [Documentation]  This is to test [POST to search for recent purchases for their carrier id and policy number]
    ...              endpoint, using the request body as EMPTY { }. In this case, the data DOES NOT EXIST in the database so,
    ...              The API status should be (204 - NO CONTENT)
    [Setup]     Getting data and authorizing the user
    Use the POST endpoint to search by carrier for Purchases ${NONE}
    The API status should be "204 No Content"
    [Teardown]  Remove Automation User

(Carrier Purchase API) POST ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q2:2023   JIRA:O5SA-645   JIRA:O5SA-660   qTest:120613033
    [Documentation]  This is to test all EXPECTED ERRORS of the endpoint
    ...              [POST to search for recent purchases for their carrier id and policy number]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Setup the environment
    [Documentation]  Access the API url, and create generic request body to use
    Get URL For Suite  ${MerchantService}
    Create payload variables

Getting data and authorizing the user
    [Documentation]  Use this keyword to select data to execute the request, and to create and authorize the user
    [Arguments]      ${policy}=${FALSE}

    IF  '${policy}'=='${FALSE}'
        Query to find prePurchase data
        ...     details=cast(carrier_id as int) as carrierid_int
        ...     end=group by carrier_id limit 20
        ...    policy=${FALSE}
    ELSE IF  '${policy}'=='${TRUE}'
         Query to find prePurchase data
         ...    details=cast(carrier_id as int) as carrierid_int, policy_number
         ...    end=and policy_number is not null group by carrier_id, policy_number limit 20
         ...    policy=${TRUE}
    END

    Create My User   persona_name=carrier_onsite_fuel_manager  application_name=Merchant Manager
    ...     entity_id=${carrierID}  with_data=N  need_new_user=Y  entity_required=CARRIER

Query to find prePurchase data
    [Documentation]  Use to find examples of CARRIER_ID with prePurchase created with status "READY_FOR_CARRIER_APPROVAL",
    ...     POLICY_NUMBER not null and, to find more prePurchase details in the Merchant Postgree database
    [Arguments]      ${details}=${NONE}   ${end}=${NONE}   ${policy}=${FALSE}

    Get into DB  ${db}
    ${query}    Catenate    select ${details}
    ...                     from pre_purchase
    ...                     where pre_purchase_status = 'READY_FOR_CARRIER_APPROVAL'
    ...                     and char_length(carrier_id)>=6
    ...                     ${end};
    ${finding_data}   query to dictionaries   ${query}
    ${DB_purchases}   query to dictionaries   ${query}
    Disconnect from Database

    IF  '${details}'=='*'
        Set Suite Variable  ${DB_purchases}
    ELSE
        ${finding_data}     Evaluate            random.choice(${finding_data})
        Set Suite Variable  ${carrierID}        ${finding_data}[carrierid_int]

        IF  '${policy}'=='${TRUE}'
            IF  '''${finding_data}[policy_number]'''!='''${EMPTY}'''
                Set Suite Variable   ${policy_toUse}     ${finding_data}[policy_number]
                #    { policy_number= [ 1 ] }
                ${policy_list}       Create List         ${policy_toUse}
                ${with_policy}       Create Dictionary   policy_numbers=${policy_list}
                Set Suite Variable   ${with_policy}
            END
        END
    END

Create payload variables
    [Documentation]  Use to create all available variables to use in the request body
    #    {}
    Set Suite Variable    ${payload_EMPTY}      &{EMPTY}
    #    { policy_numbers= [ ] }
    ${empty_list}         Create List           ${NONE}
    ${without_policy}     Create Dictionary     policy_numbers=${empty_list}
    Set Suite Variable    ${without_policy}
    #    { policy_numbers= [ INVALID ] }
    ${invalid_list}       Create List           INVALID
    ${invalid_policy}     Create Dictionary     policy_numbers=${invalid_list}
    Set Suite Variable    ${invalid_policy}

Sending post request
    [Documentation]  It will be used to build a generic REQUEST structure of the endpoint
    ...              [POST to search for recent purchases for their carrier id and policy number]
    [Arguments]      ${path}=${carrierID}/search  ${authorized}=Y  ${payload_to_send}=${payload_EMPTY}
    ${path_url}  create dictionary  None=carriers/${path}
    ${result}   ${status}  Api request   POST  carrier-purchases  ${authorized}  ${path_url}
    ...                                  application=Merchant Manager   payload=${payload_to_send}
    Set Test Variable  ${result}
    Set Test Variable  ${status}

###################################################### HAPPY PATH #####################################################
Use the POST endpoint to search by carrier for Purchases ${option}
    [Documentation]  Sending the request to OTR Merchant API
    IF  '${option}'=='READY_FOR_CARRIER_APPROVAL'
         Sending post request  payload_to_send=${payload_EMPTY}

    ELSE IF  '${option}'=='READY_FOR_CARRIER_APPROVAL WITH POLICY INFORMED'
         Sending post request  payload_to_send=${with_policy}

    ELSE IF  '${option}'=='${NONE}'
         Sending post request  payload_to_send=${without_policy}
    END

Checking keys from [purchase_groups]
    [Documentation]     Cheking keys displayed inside [purchase_groups]
    Set Suite Variable  ${purchase_groups}  ${result}[details][data][purchase_groups][0]
    ${purchase_groups_keys}  Get Dictionary Keys  ${purchase_groups}

    Dictionary Should Contain Key  ${purchase_groups_keys}  pos_date
    Dictionary Should Contain Key  ${purchase_groups_keys}  location_id
    Dictionary Should Contain Key  ${purchase_groups_keys}  location_name
    Dictionary Should Contain Key  ${purchase_groups_keys}  card_id
    Dictionary Should Contain Key  ${purchase_groups_keys}  group_total_amount
    Dictionary Should Contain Key  ${purchase_groups_keys}  group_fuel_quantity
    Dictionary Should Contain Key  ${purchase_groups_keys}  carrier_summary_pre_purchases

Checking keys from [carrier_summary_pre_purchases]
    [Documentation]     Cheking keys displayed inside [carrier_summary_pre_purchases][0]
    Set Suite Variable  ${carrier_summ_purchases}  ${purchase_groups}[carrier_summary_pre_purchases][0]
    ${carrier_summ_purchases_keys}  Get Dictionary Keys  ${carrier_summ_purchases}

    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  pre_purchase_id
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  pos_date
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  ulsd_quantity
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  ulsd_ppu
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  ulsd_cost
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  reefer_quantity
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  reefer_ppu
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  reefer_cost
    Dictionary Should Contain Key  ${carrier_summ_purchases_keys}  total_amount

The API status should be "${check_status}"
    [Documentation]     Cheking STATUS and the keys displayed into the API response
    IF  '${check_status}'=='200 with the purchases details displayed'
        Should Be Equal As Strings     ${status}                                  200
        Should Be Equal As Strings     ${result}[name]                            OK
        Should Be Equal As Strings     ${result}[message]                         SUCCESSFUL
        Should Be Equal As Strings     ${result}[details][type]                   CarrierPurchaseSearchResponseDTO
        Should Be Equal As Strings     ${result}[details][data][carrier_id]       ${carrierID}
        Dictionary Should Contain Key  ${result}[details][data]                   purchase_groups

        Checking keys from [purchase_groups]
        Checking keys from [carrier_summary_pre_purchases]
    ELSE IF  '${check_status}'=='204 No Content'
        Should Be Equal As Strings  ${status}    204
        Should Be Empty             ${result}
    END

Compare the API response with the database
    [Documentation]  Compare the data returned in the API response, with the data stored in the database
    [Arguments]      ${policy}=${FALSE}
    IF  '${policy}'=='${FALSE}'
        Query to find prePurchase data
        ...     details=*
        ...     end=and carrier_id='${carrierID}' order by pos_date, location_id
    ELSE IF  '${policy}'=='${TRUE}'
        Query to find prePurchase data
        ...     details=*
        ...     end=and carrier_id='${carrierID}' and policy_number=${policy_toUse} order by pos_date, location_id
    END

    Should Be Equal As Strings  ${DB_purchases}[0][carrier_id]     ${result}[details][data][carrier_id]
    Should Be Equal As Strings  ${DB_purchases}[0][location_id]    ${purchase_groups}[location_id]
    Should Be Equal As Strings  ${DB_purchases}[0][location_name]  ${purchase_groups}[location_name]
    Should Be Equal As Strings  ${DB_purchases}[0][card_id]        ${purchase_groups}[card_id]
    Should Not Be Empty         ${purchase_groups}[pos_date]

    Should Be Equal As Strings  ${DB_purchases}[0][pre_purchase_id]      ${carrier_summ_purchases}[pre_purchase_id]
    Should Be Equal As Strings  ${DB_purchases}[0][pre_purchase_status]  READY_FOR_CARRIER_APPROVAL
    Should Not Be Empty         ${carrier_summ_purchases}[pos_date]

    #In the carrier_summary_pre_purchases  [ ], the field total_amount is the total of the ULSD Cost + Reefer Cost
    ${API_total_amount}  Evaluate  ${carrier_summ_purchases}[ulsd_cost]+${carrier_summ_purchases}[reefer_cost]
    Should Be Equal As Numbers     ${carrier_summ_purchases}[total_amount]  ${API_total_amount}

    IF  '${policy}'=='${TRUE}'
        Should Be Equal As Strings  ${DB_purchases}[0][policy_number]   ${policy_toUse}
    END

################################################### EXPECTED ERRORS ###################################################
ERROR "${code}" - RESPONSE EXPECTED
    [Documentation]  Use to validade EXPECTED ERRORS of this endpoints (400, 401, 403, 404)
    IF  '${code}'=='404'
            Should Be Equal As Strings       ${status}              404
            Should Be Equal As Strings       ${result}[status]      404
            Should Be Equal As Strings       ${result}[path]        /carrier-purchases/carriers/search
            Should Be Equal As Strings       ${result}[error]       Not Found
            ${timestamp}  Convert To String  ${result}[timestamp]
            Should Not Be Empty              ${timestamp}
    ELSE IF  '${code}'=='403'
            Should Be Equal As Strings  ${status}   403
            Should Be Empty             ${result}
    ELSE IF  '${code}'=='401'
            Should Be Equal As Strings  ${status}   401
            Should Be Empty             ${result}
    ELSE IF  '${code}'=='400'
            Should Be Equal As Strings  ${status}   400
            Should Be Empty             ${result}
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests
    ${error_list}   Create List
    ...    CARRIER_ID NOT SEND      CARRIER_ID INVALID STRING       CARRIER_ID NOT ASSIGNED
    ...    POLICY_NUMBER INVALID    UNAUTHORIZED TOKEN

    ${test_to_run}     Evaluate    dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    Getting data and authorizing the user
    FOR  ${error}  IN  @{error_list}
         Add Test Case  (Carrier Purchase API) POST ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Post Request  authorized=I
    ERROR "401" - RESPONSE EXPECTED

ERROR - CARRIER_ID ${error}
    [Documentation]  Testing the request URL with the field CARRIER_ID (not send, using invalid string, or using one
    ...              not assigned to the user)
    IF  '${error}'=='NOT SEND'
        Sending Post Request  path=search
        ERROR "404" - RESPONSE EXPECTED
    ELSE IF  '${error}'=='INVALID STRING'
        Sending Post Request  path=INVALID/search
        ERROR "403" - RESPONSE EXPECTED
    ELSE IF  '${error}'=='NOT ASSIGNED'
        Sending Post Request  path=999999/search
        ERROR "403" - RESPONSE EXPECTED
    END

ERROR - POLICY_NUMBER INVALID
    [Documentation]  Testing the request body with the field POLICY_NUMBER informed as invalid string
    Sending Post Request  payload_to_send=${invalid_policy}
    ERROR "400" - RESPONSE EXPECTED