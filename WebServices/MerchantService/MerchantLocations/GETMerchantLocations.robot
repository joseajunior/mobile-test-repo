*** Settings ***
Library     Collections
Library     String
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment to START
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint [GET to find locations for a merchant]
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  T-Check  ditOnly

*** Variables ***
${db}  postgresmerchants

*** Test Cases ***
############################### MerchantLocations ##################################
#-----------------------------------------------------------------------------------#
#              Endpoint GET:  /merchants/{merchant_id}/locations                    #
#-----------------------------------------------------------------------------------#
(Merchant Locations) GET - Testing to find locations for a merchant
    [Tags]              Q1:2023   JIRA:O5SA-511   qTest:119200041   MerchantLocations
    [Documentation]     This is to test (GET endpoint) to find locations for a merchant
    ...                 The API response should be 200 with locations displayed
    Use the GET endpoint to find locations for a merchant
    The API response should be 200 with locations displayed
    Compare the API response with the informations in the database

(Merchant Locations) GET ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]              Q1:2023   JIRA:O5SA-511   qTest:119200281   MerchantLocations
    [Documentation]     This is to test all EXPECTED ERRORS about the endpoint [GET to find locations for a merchant]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Connect to the API URL
    Get URL For Suite    ${MerchantService}

Query to find merchants available
    [Documentation]  Use to find "merchants" available to use inside the database
    Get into DB  ${db}
    ${query}    Catenate    select merchant_id from on_site_merchants
    ...                     group by merchant_id limit 10;
    ${finding_data}   query to dictionaries   ${query}
    Disconnect from Database

    ${finding_data}       Evaluate            random.choice(${finding_data})
    Set Suite Variable    ${merchant_ID}      ${finding_data}[merchant_id]

Authorize the user for selected MERCHANT_ID
    [Documentation]    Use to create and authorize the user for selected MERCHANT_ID
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager  entity_id=${merchant_ID}
    ...             with_data=N  need_new_user=Y

Select a valid MERCHANT_ID to run the request
    [Documentation]  Looking for MERCHANT_ID available to use during the request
    Query to find merchants available

Setup the environment to START
    Connect to the API URL
    Select a valid MERCHANT_ID to run the request
    Authorize the user for selected MERCHANT_ID

Sending get request
    [Documentation]  Used to build a generic REQUEST structure of the endpoint (GET merchant's locations)
    [Arguments]      ${path}=${merchantID}/locations?sort=location_id,desc
    ...              ${authorized}=Y  ${what_remove}=${NONE}

    ${path_url}      create dictionary   None=${path}
    ${result}   ${status}  Api request   GET  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    Set Test Variable      ${result}
    Set Test Variable      ${status}

###################################################### HAPPY PATH #####################################################
Use the GET endpoint to find locations for a merchant
    [Documentation]  Sending the request to OTR Merchant API to find locations for a merchant
    Sending Get Request

The API response should be 200 with locations displayed
    [Documentation]  Cheking STATUS and LOCATIONS displayed into the API response
    ${keys}  Get Dictionary Keys  ${result}

    Should Be Equal As Strings  ${status}                 200
    Should Be Equal             ${keys}[3]                name
    Should Be Equal As Strings  ${result}[name]           OK
    Should Be Equal             ${keys}[2]                message
    Should Be Equal As Strings  ${result}[message]        SUCCESSFUL
    Should Be Equal As Strings  ${result}[details][type]  MerchantLocationDTO

#    checking keys inside [details]
    ${keys_details}  Get Dictionary Keys  ${result}[details]
    Should Be Equal  ${keys}[0]          details
    Should Be Equal  ${keys_details}[0]  data
    Should Be Equal  ${keys_details}[1]  type

#    checking keys inside [links]
    ${link_dic}      Convert To Dictionary  ${result}[links]
    ${keys_links}    Get Dictionary Keys    ${link_dic}
    Should Be Equal  ${keys}[1]        links
    Should Be Equal  ${keys_links}[0]  rel

#    checking keys inside [pages]
    ${page_dic}      Convert To Dictionary  ${result}[page]
    ${keys_pages}    Get Dictionary Keys    ${page_dic}
    Should Be Equal  ${keys}[4]        page
    Should Be Equal  ${keys_pages}[0]  number
    Should Be Equal  ${keys_pages}[1]  size
    Should Be Equal  ${keys_pages}[2]  totalElements
    Should Be Equal  ${keys_pages}[3]  totalPages

Query to find locations available for a merchant
    [Documentation]  Use to find locations available for a merchant in the database
    Get into DB  ${db}
    ${query}  Catenate  select merchant_id, location_id, trim(location_name) as location_name
    ...                 from on_site_merchants where merchant_id = ${merchant_ID}
    ...                 order by location_id desc;
    ${locations_result}   query to dictionaries   ${query}
    Disconnect from Database
    Set Suite Variable  ${locations_result}

Compare the API response with the informations in the database
    [Documentation]  Comparing the fields returned in the API REPSONSE BODY with the database
    Query to find locations available for a merchant

    Should Be Equal As Strings      ${locations_result}[0][merchant_id]    ${merchant_ID}
    Should Be Equal As Strings      ${locations_result}[0][location_id]    ${result}[details][data][0][location_id]
    ${api_location_name}  String.Convert To Upper Case  ${locations_result}[0][location_name]
    ${db_location_name}  String.Convert To Upper Case  ${result}[details][data][0][location_name]
    Should Be Equal As Strings      ${api_location_name}  ${db_location_name.strip()}

################################################### EXPECTED ERRORS ###################################################
ERROR 404 - RESPONSE EXPECTED
    [Documentation]  Use to validade ERROR with status 404
    ${response}  Get Dictionary Keys  ${result}

    Should Be Equal As Strings   ${status}          404
    Should Be Equal              ${response}[3]     timestamp
    Should Be Equal              ${response}[2]     status
    Should Be Equal              ${response}[1]     path
    Should Be Equal As Strings   ${result}[path]    /merchants/locations
    Should Be Equal              ${response}[0]     error
    Should Be Equal As Strings   ${result}[error]   Not Found

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests

    ${error_list}  Create List
    ...    MERCHANT Not Send      MERCHANT Invalid      MERCHANT Not assigned to the user    UNAUTHORIZED TOKEN

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (Merchant Locations) GET ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - MERCHANT ${error}
    [Documentation]  Testing the request URL with the field MERCHANT_ID (not send or using invalid string)
    IF  '${error}'=='Not Send'
        Sending Get Request  path=locations
        ERROR 404 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='Invalid'
        Sending Get Request  path=INVALID/locations
        Should Be Equal As Strings   ${status}  400
    ELSE IF  '${error}'=='Not assigned to the user'
        Sending Get Request  path=9999999/locations
        Should Be Equal As Strings   ${status}  403
        Pass Execution  403 - FORBIDDEN
    END

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Get Request   authorized=I
    IF    '${status}'=='401'
        Should Be Equal As Strings  ${status}  401
        Pass Execution  401 - UNAUTHORIZED
    ELSE
        Fail  TOKEN authorization validation failed
    END