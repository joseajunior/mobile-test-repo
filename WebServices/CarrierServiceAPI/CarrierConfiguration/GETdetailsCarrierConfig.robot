*** Settings ***
Library     String
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setting up the environment
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint [GET to see a carrier configuration details]
...            OTR Carriers Service API to manage carriers, carrier aliases, etc, within the WEX OTR system.
...            URL: (https://carrierservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.
Force Tags     API  CarrierServiceAPI  ditOnly

*** Variables ***
${db}  postgrespgcarrierservices

*** Test Cases ***
############################## Carrier Configuration ################################
#-----------------------------------------------------------------------------------#
#            Endpoint GET:  /carrier-configs/carriers/{carrier_id}                  #
#-----------------------------------------------------------------------------------#
(Carrier Config) GET - To see an EXISTENT carrier configuration
    [Tags]           Q2:2023  JIRA:O5SA-653  qTest:120278705  getCarrierConfig
    [Documentation]  This is to test (GET endpoint) to see an EXISTENT carrier configuration details
    ...              The API response should be 200 SUCCESS, with carrier configuration displayed in the response
    [Setup]    "Find" carrier configuration in the DB
    Use the GET endpoint to see "EXISTENT" carrier configuration details
    The API response should be "200 WITH" carrier configuration displayed
    The carrier configuration displayed, should "EXIST" in the database

(Carrier Config) GET - To see a NON-EXISTENT carrier configuration
    [Tags]           Q2:2023  JIRA:O5SA-653  qTest:120278705  getCarrierConfig
    [Documentation]  This is to test (GET endpoint) to see a NON-EXISTENT carrier configuration
    ...              The API response should be 204 NOT FOUND, without response body
    [Setup]     "Remove" carrier configuration in the DB
    Use the GET endpoint to see "NON-EXISTENT" carrier configuration details
    The API response should be "204 WITHOUT" carrier configuration displayed
    The carrier configuration displayed, should "NOT EXIST" in the database

(Carrier Config) GET ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q2:2023  JIRA:O5SA-653  qTest:120278890  getCarrierConfigErrors
    [Documentation]  This is to test all EXPECTED ERRORS about the endpoint [GGET to see a carrier configuration details]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Setting up the environment
    [Documentation]  Setting up the API URL, creating and authorizing the user
    Get URL For Suite    ${CarrierServiceAPI}
    Create My User   persona_name=am_admin  application_name=OTR_eMgr  entity_id=${EMPTY}  with_data=N

Command to find carrier configuration in the DB
    [Documentation]  Use to see carrier configuration details in the database
    Get into DB  ${db}
        ${query}  Catenate   select * from carrier_configuration where carrier_id = '${automation_entity_id}';
        ${DB_carrier_config}   Query to Dictionaries   ${query}
        ${DB_carrier_config_count}  Row Count   ${query}  ${db}
    Disconnect from Database
    Set Test Variable   ${DB_carrier_config}
    Set Test Variable   ${DB_carrier_config_count}

Command to remove carrier configuration
    [Documentation]  Use this command to remove a carrier configuration in the database
    #TODO Replace this respective manual command with the DELETE request when it is implemented
    Get into DB  ${db}
        Execute sql string  dml=delete from carrier_configuration where carrier_id = '${automation_entity_id}';
    Disconnect from Database

"${operation}" carrier configuration in the DB
    [Documentation]  Use to check if the respective carrier configuration already exists in the database
    IF  ('${operation}'=='Find')
         Command to find carrier configuration in the DB
         IF  ('${DB_carrier_config_count}'<'1')
             Sending Post Request
         END
    ELSE IF  ('${operation}'=='Remove')
         Command to find carrier configuration in the DB
         IF  ('${DB_carrier_config_count}'>='1')
             Command to remove carrier configuration
         END
    ELSE
        Command to find carrier configuration in the DB
    END

Sending post request
    [Documentation]  Used to build a generic REQUEST structure of the endpoint [POST to CREATE a carrier config]
    [Arguments]  ${path}=carriers/${automation_entity_id}  ${authorized}=Y   ${what_remove}=${NONE}

    ${path_url}        Create dictionary  None=${path}
    ${carrier_config}  Create Dictionary  fuel_purchase_carrier=${TRUE}  config_property_name=Creating test
    ${payload}         Create Dictionary  carrier_configuration=${carrier_config}

    ${result_post}  ${status_post}  Api request   POST  carrier-configs  ${authorized}  ${path_url}  application=OTR_eMgr
    ...                                           payload=${payload}
    Should Be Equal As Strings  ${status_post}  201

Sending get request
    [Documentation]  Build a generic REQUEST structure of the endpoint [GET to see a carrier configuration details]
    [Arguments]  ${path}=carriers/${automation_entity_id}  ${authorized}=Y

    ${path_url}  Create dictionary   None=${path}
    ${result}    ${status}  Api request   GET  carrier-configs  ${authorized}  ${path_url}  application=OTR_eMgr
    Set Test Variable  ${result}
    Set Test Variable  ${status}

###################################################### HAPPY PATH #####################################################
Use the GET endpoint to see "${detail}" carrier configuration details
    [Documentation]  Sending the request to OTR Carrier Service API to see carrier configuration details
    IF  ('${detail}'=='EXISTENT') or ('${detail}'=='NON-EXISTENT')
        Sending Get request
    END

The API response should be "${code}" carrier configuration displayed
    [Documentation]  Cheking STATUS and CARRIER_CONFIGURATION details displayed into the API response body
    IF  '${code}'=='200 WITH'
        Should Be Equal As Strings      ${status}                   200
        Should Be Equal As Strings      ${result}[name]             OK
        Should Be Equal As Strings      ${result}[message]          SUCCESSFUL
        Should Be Equal As Strings      ${result}[details][type]    CarrierConfigurationResponseDTO
        Dictionary Should Contain Key   ${result}[details][data]    configuration_id
        Dictionary Should Contain Key   ${result}[details][data]    carrier_configuration
        Dictionary Should Contain Key   ${result}[details][data]    carrier_id
        Should Be Equal As Strings      ${result}[details][data][carrier_id]    ${automation_entity_id}

        ${links_dic}  Convert To Dictionary  ${result}[details][data][links]
        Should Be Equal As Strings   ${links_dic}   {'rel': 'href'}
    ELSE IF  '${code}'=='204 WITHOUT'
        Should Be Equal As Strings      ${status}   204
        Should Be Empty                 ${result}
    ELSE
        FAIL  API response NOT EXPECTED
    END

The carrier configuration displayed, should "${details}" in the database
    [Documentation]  Compare carrier configuration displayed in the response body, with the data storaged in the DB
    "GET" carrier configuration in the DB

    IF  '${details}'=='EXIST'
        Should Be Equal As Numbers  ${DB_carrier_config}[0][id]             ${result}[details][data][configuration_id]
        Should Be Equal As Strings  ${DB_carrier_config}[0][carrier_id]     ${automation_entity_id}
        Should Not Be Empty         ${DB_carrier_config}[0][updated_by]
        Should Not Be Empty         ${DB_carrier_config}[0][configuration]

        ${DB_updated}  Convert To String  ${DB_carrier_config}[0][updated]
        Should Not Be Empty  ${DB_updated}
    ELSE IF  '${details}'=='NOT EXIST'
        Should Be Equal As Numbers  ${DB_carrier_config_count}    0
    END

################################################### EXPECTED ERRORS ###################################################
ERROR - RESPONSE EXPECTED
    [Documentation]  Use to validade EXPECTED ERRORS of this endpoints (401, 403, 404)
    [Arguments]      ${code}=${NONE}   ${with_body}=${NONE}
    IF  '${code}'=='404'
        Should Be Equal As Strings     ${status}          404
        Should Be Equal As Strings     ${result}[status]  404
        Should Be Equal As Strings     ${result}[path]    /carrier-configs/carriers
        Should Be Equal As Strings     ${result}[error]   Not Found
        Dictionary Should Contain Key  ${result}          timestamp

        ${timestamp}  Convert To String  ${result}[timestamp]
        Should Not Be Empty              ${timestamp}
    ELSE IF  '${code}'=='401'
        Should Be Equal As Strings     ${status}  401
        Should Be Empty                ${result}
    ELSE IF  '${code}'=='403'
        Should Be Equal As Strings     ${status}  403
        Should Be Empty                ${result}
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests
    ${error_list}   Create List
    ...  UNAUTHORIZED TOKEN         CARRIER NOT ASSIGNED         CARRIER NOT SEND

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (Carrier Config) GET ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Get Request   authorized=I
    ERROR - RESPONSE EXPECTED   code=401

ERROR - CARRIER ${detail}
    [Documentation]  Testing the request with CARRIER_ID (not send, not assigned to the user, using an unon-existent,
    ...     or using a carrier which the respective carrier_configuration already exist in the database)
    IF  '${detail}'=='NOT ASSIGNED'
        Sending Get Request  path=carriers/9999999
        ERROR - RESPONSE EXPECTED   code=403
    ELSE IF  '${detail}'=='NOT SEND'
        Sending Get Request  path=carriers
        ERROR - RESPONSE EXPECTED   code=404
    END