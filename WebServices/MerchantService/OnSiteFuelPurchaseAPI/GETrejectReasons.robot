*** Settings ***
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment to START
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint (GET Reject Reasons Response) at OTR - Merchant Service API
...            This API is responsable to manage operations available for merchants within the WEX OTR system
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags  API  MerchantServiceAPI  OnSite_FuelPurchase  T-Check  ditOnly

*** Variables ***

*** Test Cases ***

(OnSite Fuel Purchase API) GET - Testing Reject Reason Response
    [Tags]              Q1:2023   JIRA:O5SA-647  qTest:120131645   GetRejectedReasonResponse
    [Documentation]     This is to test (GET endpoint) to see Rejected Reasons Response. The API response should be 200
    Use the GET endpoint to see Rejected Reason Response
    The API response should be (status 200) with more details

(OnSite Fuel Purchase API) GET ERRORS - Testing Reject Reason Response endpoint with "unauthorized token"
    [Tags]              Q1:2023   JIRA:O5SA-647  qTest:120131645   GetRejectedReasonResponse
    [Documentation]     This is to test an EXPECTED ERROR, when we use the endpoint with "unauthorized token"
    Use the GET endpoint with UNAUTHORIZED TOKEN

*** Keywords ***
Setup the environment to START
    Get URL For Suite    ${MerchantService}
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager  entity_id=${EMPTY}
    ...             with_data=N  need_new_user=Y

Sending get request
    [Documentation]  It will be used to build a generic REQUEST structure of the endpoint (GET Rejected Reason Response)
    [Arguments]      ${authorized}=Y
    ${path_url}      create dictionary   None=reject-reasons
    ${result}   ${status}  Api request   GET  purchases  ${authorized}  ${path_url}  application=Merchant Manager

    Set Test Variable      ${result}
    Set Test Variable      ${status}

###################################################### HAPPY PATH #####################################################
Use the GET endpoint to see Rejected Reason Response
    [Documentation]  Sending the request to OTR Merchant API to see Rejected Reason Response
    Sending Get Request

The API response should be (status 200) with more details
    [Documentation]     Cheking STATUS and DETAILS returned into the API response

    Should Be Equal As Strings      ${status}                        200
    Should Be Equal As Strings      ${result}[name]                  OK
    Should Be Equal As Strings      ${result}[message]               SUCCESSFUL
    Should Be Equal As Strings      ${result}[details][type]         PrePurchaseRejectReasonResponseDTO

    Should Be Equal As Strings      ${result}[details][data][reject_reasons][0][name]           WRONG_DATE
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][0][description]    Wrong Purchase Date
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][1][name]           NO_FUEL
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][1][description]    No Fuel Provided
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][2][name]           INVALID_UNIT
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][2][description]    Invalid Unit Number
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][3][name]           INVALID_COST
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][3][description]    Invalid Cost
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][4][name]           OTHER_REASON
    Should Be Equal As Strings      ${result}[details][data][reject_reasons][4][description]    Other Reason

    Should Be Equal As Strings      ${result}[details][data][links]  []


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