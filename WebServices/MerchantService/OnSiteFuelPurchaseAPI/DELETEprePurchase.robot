*** Settings ***
Library     String
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setting up the environment
Suite Teardown  Remove User if Still Exists

Documentation  This is to test the (DELETE endpoint) to submit an OnSite Fuel Purchase to the system to be deleted
...            This endpoint is available at OTR - Merchant Service API URL: (https://merchantservice.{env}.efsllc.com)
...            The API is responsable to manage operations available for merchants within the WEX OTR system
...            NOTES = WEX OTR API's are secured with OKTA using OAuth2.

Force Tags  API  MerchantServiceAPI  OnSite_FuelPurchase  T-Check  ditOnly

*** Variables ***
${db}  postgresmerchants

*** Test Cases ***
############################## OnSiteFuelPurchaseAPI ################################
#-----------------------------------------------------------------------------------#
#      Endpoint DELETE:  /merchants/{merchant_id}/purchases/{purchase_id}           #
#-----------------------------------------------------------------------------------#
(OnSite Fuel Purchase API) DELETE - Submit a purchase to be deleted
    [Tags]           Q2:2023   JIRA:O5SA-628  qTest:119932622   DeletePurchase
    [Documentation]  This is to test (GET endpoint) to see PrePurchase statuses
    ...              The API response should be 200
    Use the DELETE endpoint to Submit a Purchase to be DELETED
    The API response should be (200 Successful)
    The data in the [pre_purchase] table should be changed
    A new record in the [pre_purchase_history] table should be added

(OnSite Fuel Purchase API) DELETE ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q2:2023   JIRA:O5SA-628   qTest:119932791    DeletePurchase
    [Documentation]  This is to test all EXPECTED ERRORS about the endpoint [DELETE to sumit a purchase to be deleted]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Finding a valid MERCHANT
    [Documentation]  To find valid "merchant_id" in the database
    Get into DB  ${db}
        ${query}    Catenate    select merchant_id from on_site_merchants osm
        ...                     order by id desc limit 10;
        ${find_merchant_data}   Query To Dictionaries  ${query}
    Disconnect From Database
    ${find_merchant_data}  Evaluate       random.choice(${find_merchant_data})
    Set Suite Variable     ${merchantID}  ${find_merchant_data}[merchant_id]

Authorize the user for selected MERCHANT_ID
    [Documentation]  Use to create and authorize the user for selected MERCHANT_ID
    Create My User   persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager
    ...              entity_id=${merchantID}  with_data=N  need_new_user=Y

Sending post request
    [Documentation]  It will be used to build a generic REQUEST structure of (POST endpoint)
    ...              To submit an OnSite Fuel Purchase to the system to be PROCESSED
    ...              In that case, just the required fields were informed
    ${path_url}  Create dictionary   None=${merchantID}/purchases
    ${payload}   Create Dictionary   card_id=1000008667000  invoice_number=DELETED_invoice_test  location_id=501199
    ${result_post}   ${status_post}  Api request   POST  merchants  Y  ${path_url}   application=Merchant Manager
    ...                                            payload=${payload}
    Should Be Equal As Strings    ${status_post}   201
    Set Suite Variable    ${result_post}

Use the POST endpoint to Submit a Purchase to be PROCESSED
    [Documentation]  Sending the request to OTR Merchant API to create a new prePurchase
    Sending Post Request

    Get into DB  ${db}
    ${query}    Catenate    select cast(pre_purchase_id as varchar) as pre_purchase_id
    ...                     from pre_purchase where batch_id = '${result_post}[details][data][batch_id]'
    ${DB_PrePurchase}   Query To Dictionaries  ${query}
    Disconnect From Database
    Set Suite Variable  ${purchaseID}   ${DB_PrePurchase}[0][pre_purchase_id]

Finding a PURCHASE related with the MERCHANT selected
    [Documentation]  Use to find a valid "merchant_id" and "purchase_id" with status OTHER THAN DELETED in the DB
    Get into DB  ${db}
    ${query}    Catenate    select pp.pre_purchase_id as purchase_id
    ...                     from pre_purchase pp
    ...                     join batch_history bh on (bh.batch_id=pp.batch_id)
    ...                     where pp.pre_purchase_status not in ('DELETED', 'PURCHASE_APPROVED')
    ...                     and bh.merchant_id = '${merchantID}'
    ...                     limit 10;
    ${finding_purchase_data}   query to dictionaries     ${query}
    ${finding_purchase_data_count}  Row Count  ${query}  ${db}
    Disconnect from Database

    IF  '${finding_purchase_data_count}'>='1'
        ${finding_purchase_data}   Evaluate       random.choice(${finding_purchase_data})
        Set Suite Variable         ${purchaseID}  ${finding_purchase_data}[purchase_id]
        Authorize the user for selected MERCHANT_ID
    ELSE
        Authorize the user for selected MERCHANT_ID
        Use the POST endpoint to Submit a Purchase to be PROCESSED
    END

Setting up the environment
    Get URL For Suite    ${MerchantService}
    Finding a valid MERCHANT
    Finding a PURCHASE related with the MERCHANT selected

Sending delete request
    [Documentation]  It will be used to build a generic REQUEST structure of (DELETE endpoint)
    ...              responsable for submit an OnSite Fuel Purchase to the system to be deleted
    [Arguments]      ${path}=${merchantID}/purchases/${purchaseID}     ${authorized}=Y

    ${path_url}  create dictionary  None=${path}
    ${result}   ${status}  Api request   DELETE  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    Set Test Variable  ${result}
    Set Test Variable  ${status}

###################################################### HAPPY PATH #####################################################
Use the DELETE endpoint to Submit a Purchase to be DELETED
    [Documentation]  Sending the request to OTR Merchant API
    Sending Delete Request

The API response should be (200 Successful)
    [Documentation]     Cheking STATUS and KEYS returned into the API response
    Should Be Equal As Strings      ${status}                        200
    Should Be Equal As Strings      ${result}[name]                  OK
    Should Be Equal As Strings      ${result}[message]               SUCCESSFUL
    Should Be Equal As Strings      ${result}[details][type]         SuccessDTO
    Dictionary Should Contain Key   ${result}[details][data]         links
    Should Be Equal As Strings      ${result}[details][data][links]  []

Query to check prePurchase
    [Documentation]    Use to find PrePurchase details using PURCHASE_ID and MERCHANT_ID
    Get into DB  ${db}
    ${query}    Catenate    select bh.merchant_id, p.*
    ...                     from pre_purchase p
    ...                     join batch_history bh on (bh.batch_id = p.batch_id)
    ...                     where bh.merchant_id = '${merchantID}' and pre_purchase_id = '${purchaseID}';
    ${prePuchaseDetails_data}  query to dictionaries   ${query}
    Disconnect from Database
    Set Test Variable   ${prePuchaseDetails_data}

Query to check prePurchase_history
    [Documentation]    Use to find PrePurchase HISTORY details using PURCHASE_ID
    Get into DB  ${db}
    ${query}    Catenate    select * from pre_purchase_history
    ...                     where pre_purchase_id =  '${purchaseID}';
    ${prePuchaseHistory_data_count}  Row Count  ${query}  ${db}
    Disconnect from Database
    Set Test Variable   ${prePuchaseHistory_data_count}

The data in the [pre_purchase] table should be changed
    [Documentation]  The following columns should be changed
    ...              [ pre_purchase_status ] should be changed to the DELETED enumerator
    ...              [ updated_by ] should be changed by the respective used USER_ID
    ...              [ update_date ] should be changed by the current date and time
    Query To Check PrePurchase
    Should Be Equal As Strings    ${prePuchaseDetails_data}[0][pre_purchase_status]   DELETED
    Should Be Equal As Strings    ${prePuchaseDetails_data}[0][updated_by]            ${auto_user_id}

    ${update_date}  Convert To String  ${prePuchaseDetails_data}[0][update_date]
    Should Not Be Empty  ${update_date}

A new record in the [pre_purchase_history] table should be added
    [Documentation]  A new record with the previous prePurchase data should be added
    Query To Check PrePurchase_history
    IF  '${prePuchaseHistory_data_count}'<'1'
        Fail    Validation needs to be reviewed, because no records were found in the history
    END
################################################### EXPECTED ERRORS ###################################################
ERROR "${CODE}" - EXPECTED RETURN
    [Documentation]  Use to validade the delete endpoint EXPECTED ERRORS
    IF  '${CODE}'=='400'
        Should Be Equal As Strings   ${status}  400
        Should Be Empty              ${result}
    ELSE IF   '${CODE}'=='403'
        Should Be Equal As Strings   ${status}  403
        Should Be Empty              ${result}
    ELSE IF   '${CODE}'=='405'
        Should Be Equal As Strings   ${status}  405
        Should Be Empty              ${result}
    ELSE IF   '${CODE}'=='404'
        Should Be Equal As Strings  ${status}             404
        Should Be Equal As Strings  ${result}[error]      Not Found
        Should Be Equal As Strings  ${result}[path]       /merchants/purchases/${purchaseID}
        Should Not Be Empty         ${result}[timestamp]
    END

ERROR 422 - EXPECTED RETURN WHEN PURCHASE_ID "${details}"
    [Documentation]  Use to validade the delete endpoint wiht the EXPECTED ERROR (422)
    Should Be Equal As Strings      ${status}              422
    IF   '${details}'=='DOES NOT BELONG'
        Should Be Equal As Strings  ${result}[name]        PRE_PURCHASE_DOES_NOT_BELONG_TO_MERCHANT
        Should Be Equal As Strings  ${result}[error_code]  PRE_PURCHASE_DOES_NOT_BELONG_TO_MERCHANT
        Should Be Equal As Strings  ${result}[message]     prePurchaseId does not belong to the merchantId
    ELSE IF   '${details}'=='ALREADY APPROVED'
        Should Be Equal As Strings  ${result}[name]        INVALID_STATUS_FOR_DELETE
        Should Be Equal As Strings  ${result}[error_code]  INVALID_STATUS_FOR_DELETE
        Should Be Equal As Strings  ${result}[message]     Update not allowed because purchase is approved
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To test

    ${error_list}   Create List
    ...    MERCHANT_ID NOT SEND     MERCHANT_ID INVALID STRING      MERCHANT_ID NOT ASSIGNED TO THE USER
    ...    UNAUTHORIZED TOKEN       PURCHASE_ID NOT SEND            PURCHASE_ID INVALID STRING
    ...    PURCHASE_ID DOES NOT BELONG TO THE MERCHANT INFORMED     PURCHASE_ID ALREADY APPROVED

    ${test_to_run}     Evaluate    dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (OnSite Fuel Purchase API) DELETE ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - MERCHANT_ID ${error}
    [Documentation]  Testing the request URL with the field MERCHANT_ID (not send, with invalid string or passing
    ...              one not assigned to the user)
    IF  '${error}'=='NOT SEND'
        Sending Delete Request  path=purchases/${purchaseID}
        ERROR "404" - EXPECTED RETURN
    ELSE IF  '${error}'=='INVALID STRING'
        Sending Delete Request  path=INVALID/purchases/${purchaseID}
        ERROR "400" - EXPECTED RETURN
    ELSE IF  '${error}'=='NOT ASSIGNED TO THE USER'
        Sending Delete Request  path=99999/purchases/${purchaseID}
        ERROR "403" - EXPECTED RETURN
    END

ERROR - PURCHASE_ID ${error}
    [Documentation]  Testing the request URL with the field PURCHASE_ID (not send, with invalid string or passing
    ...              a purchase_id does not belong to the merchant_id informed)
    IF  '${error}'=='NOT SEND'
        Sending Delete Request  path=${merchantID}/purchases
        ERROR "405" - EXPECTED RETURN
    ELSE IF  '${error}'=='INVALID STRING'
        Sending Delete Request  path=${merchantID}/purchases/INVALID
        ERROR "400" - EXPECTED RETURN
    ELSE IF  '${error}'=='DOES NOT BELONG TO THE MERCHANT INFORMED'
        Sending Delete Request  path=${merchantID}/purchases/9999999
        ERROR 422 - EXPECTED RETURN WHEN PURCHASE_ID "DOES NOT BELONG"
    ELSE IF  '${error}'=='ALREADY APPROVED'
        Get into DB  ${db}
        Execute sql string
        ...  dml=update pre_purchase set pre_purchase_status ='PURCHASE_APPROVED' where pre_purchase_id ='${purchaseID}'

        Sending Delete Request  path=${merchantID}/purchases/${purchaseID}
        ERROR 422 - EXPECTED RETURN WHEN PURCHASE_ID "ALREADY APPROVED"

        Execute sql string
        ...  dml=update pre_purchase set pre_purchase_status ='DELETED' where pre_purchase_id ='${purchaseID}'
        Disconnect from Database
    END

ERROR - UNAUTHORIZED TOKEN
    [Documentation]     Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Delete Request  authorized=I
    IF    '${status}'=='401'
        Should Be Equal As Strings   ${status}  401
    ELSE
        Fail  TOKEN authorization validation failed
    END