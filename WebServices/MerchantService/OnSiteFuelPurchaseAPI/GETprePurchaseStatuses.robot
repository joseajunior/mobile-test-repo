*** Settings ***
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment to START
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint (GET PrePurchase statuses) at OTR - Merchant Service API
...            This API is responsable to manage operations available for merchants within the WEX OTR system
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags  API  MerchantServiceAPI  OnSite_FuelPurchase  T-Check  ditOnly

*** Variables ***

*** Test Cases ***
############################ OnSiteFuelPurchaseAPI ###############################
#-----------------------------------------------------------------------------------#
#                 Endpoint GET:  /merchants/purchases/statuses                      #
#-----------------------------------------------------------------------------------#
(OnSite Fuel Purchase API) GET - Testing Pre-Purchase statuses
    [Tags]              Q1:2023   JIRA:O5SA-520   JIRA:O5SA-598   JIRA:O5SA-603  qTest:119024681   GetPerchaseStatus
    [Documentation]     This is to test (GET endpoint) to see PrePurchase statuses
    ...                 The API response should be 200
    Use the GET endpoint to see Pre-Purchase Statuses
    The API response should be (status 200) with more details
    Compare the API response for each [pre_purchase_status]

(OnSite Fuel Purchase API) GET ERRORS - Testing Pre-Purchase statuses endpoint with "unauthorized token"
    [Tags]              Q1:2023   JIRA:O5SA-520   JIRA:O5SA-598   JIRA:O5SA-603   qTest:119024681   GetPerchaseStatus
    [Documentation]     This is to test an EXPECTED ERROR, when we use the endpoint with "unauthorized token"
    Use the GET endpoint with UNAUTHORIZED TOKEN

*** Keywords ***
Setup the environment to START
    Get URL For Suite    ${MerchantService}
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager  entity_id=${EMPTY}
    ...             with_data=N  need_new_user=Y

Sending get request
    [Documentation]  It will be used to build a generic REQUEST structure of the endpoint (GET Pre-Purchase statuses)
    [Arguments]      ${authorized}=Y
    ${path_url}      create dictionary   None=purchases/statuses
    ${result}   ${status}  Api request   GET  merchants  ${authorized}  ${path_url}  application=Merchant Manager

    Set Test Variable      ${result}
    Set Test Variable      ${status}

###################################################### HAPPY PATH #####################################################
Use the GET endpoint to see Pre-Purchase Statuses
    [Documentation]  Sending the request to OTR Merchant API to see Pre-Purchase statuses
    Sending Get Request

The API response should be (status 200) with more details
    [Documentation]     Cheking STATUS and DETAILS returned into the API response
    ${keys}  Get Dictionary Keys  ${result}

    Should Be Equal As Strings      ${status}                        200
    Should Be Equal                 ${keys}[2]                       name
    Should Be Equal As Strings      ${result}[name]                  OK
    Should Be Equal                 ${keys}[1]                       message
    Should Be Equal As Strings      ${result}[message]               SUCCESSFUL
    Should Be Equal                 ${keys}[0]                       details
    Should Be Equal As Strings      ${result}[details][type]         PrePurchaseStatusResponseDTO
    Dictionary Should Contain Key   ${result}[details][data]         links
    Should Be Equal As Strings      ${result}[details][data][links]  []
    Dictionary Should Contain Key   ${result}[details][data]         statuses

Get STATUSES details returned in the list at API response
    [Documentation]  Use that keyword to get STATUSES details from the list returned in the API response by each INDEX
    ${list_index_0}     Get From List     ${result}[details][data][statuses]  0
    set suite variable  ${code_index_0}   ${list_index_0}[code]
    set suite variable  ${name_index_0}   ${list_index_0}[status_name]
    set suite variable  ${description_0}  ${list_index_0}[description]

    ${list_index_1}     Get From List     ${result}[details][data][statuses]  1
    set suite variable  ${code_index_1}   ${list_index_1}[code]
    set suite variable  ${name_index_1}   ${list_index_1}[status_name]
    set suite variable  ${description_1}  ${list_index_1}[description]

    ${list_index_2}     Get From List     ${result}[details][data][statuses]  2
    set suite variable  ${code_index_2}   ${list_index_2}[code]
    set suite variable  ${name_index_2}   ${list_index_2}[status_name]
    set suite variable  ${description_2}  ${list_index_2}[description]

    ${list_index_3}     Get From List     ${result}[details][data][statuses]  3
    set suite variable  ${code_index_3}   ${list_index_3}[code]
    set suite variable  ${name_index_3}   ${list_index_3}[status_name]
    set suite variable  ${description_3}  ${list_index_3}[description]

    ${list_index_4}     Get From List     ${result}[details][data][statuses]  4
    set suite variable  ${code_index_4}   ${list_index_4}[code]
    set suite variable  ${name_index_4}   ${list_index_4}[status_name]
    set suite variable  ${description_4}  ${list_index_4}[description]

    ${list_index_5}     Get From List     ${result}[details][data][statuses]  5
    set suite variable  ${code_index_5}   ${list_index_5}[code]
    set suite variable  ${name_index_5}   ${list_index_5}[status_name]
    set suite variable  ${description_5}  ${list_index_5}[description]

    ${list_index_6}     Get From List     ${result}[details][data][statuses]  6
    set suite variable  ${code_index_6}   ${list_index_6}[code]
    set suite variable  ${name_index_6}   ${list_index_6}[status_name]
    set suite variable  ${description_6}  ${list_index_6}[description]

Compare the API response for each [pre_purchase_status]
    [Documentation]  Comparing the fields returned in the API RESPONSE BODY for each [pre_purchase_status]
    ...              CODE, STATUS_NAME, and DESCRIPTION usable during the comparison were based on ENUMERATOR available
    ...              The DEVELOPER created these enumerators in the application code
    Get STATUSES details returned in the list at API response

    Should Be Equal As Strings  ${code_index_0}   READY_FOR_PROCESSING
    Should Be Equal As Strings  ${name_index_0}   Ready for Processing
    Should Be Equal As Strings  ${description_0}  The purchase is ready to be processed by the system.

    Should Be Equal As Strings  ${code_index_1}   RESUBMITTED
    Should Be Equal As Strings  ${name_index_1}   Resubmitted
    Should Be Equal As Strings  ${description_1}  The purchase was resubmitted to be processed again.

    Should Be Equal As Strings  ${code_index_2}   READY_FOR_CARRIER_APPROVAL
    Should Be Equal As Strings  ${name_index_2}   Ready for Carrier approval
    Should Be Equal As Strings  ${description_2}  Ready for Carrier approval. The system pre-authorized this purchase.

    Should Be Equal As Strings  ${code_index_3}   CARRIER_APPROVED
    Should Be Equal As Strings  ${name_index_3}   Carrier Approved Purchase
    Should Be Equal As Strings  ${description_3}  The carrier approved this purchase.

    Should Be Equal As Strings  ${code_index_4}   CARRIER_REJECTED
    Should Be Equal As Strings  ${name_index_4}   Carrier Rejected
    Should Be Equal As Strings  ${description_4}  The carrier rejected this purchase.

    Should Be Equal As Strings  ${code_index_5}   PURCHASE_APPROVED
    Should Be Equal As Strings  ${name_index_5}   Purchase Approved
    Should Be Equal As Strings  ${description_5}  The purchase was authorized by the system.

    Should Be Equal As Strings  ${code_index_6}   PURCHASE_REJECTED
    Should Be Equal As Strings  ${name_index_6}   Purchase Rejected
    Should Be Equal As Strings  ${description_6}  The purchase was rejected by the system.

################################################### EXPECTED ERRORS ###################################################
Use the GET endpoint with UNAUTHORIZED TOKEN
    [Documentation]       Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Get Request   authorized=I

    IF    '${status}'=='401'
        Should Be Equal As Strings  ${status}  401
        Pass Execution  401 - Unauthorized
    ELSE
        Fail  TOKEN authorization validation failed
    END