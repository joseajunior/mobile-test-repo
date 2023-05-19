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

Documentation  This is to test the endpoint [POST to CREATE a carrier configuration]
...            OTR Carriers Service API to manage carriers, carrier aliases, etc, within the WEX OTR system.
...            URL: (https://carrierservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.
Force Tags     API  CarrierServiceAPI  ditOnly

*** Variables ***
${db}  postgrespgcarrierservices

*** Test Cases ***
############################## Carrier Configuration ################################
#-----------------------------------------------------------------------------------#
#            Endpoint POST:  /carrier-configs/carriers/{carrier_id}                 #
#-----------------------------------------------------------------------------------#
(Carrier Config) POST - Testing the creation of carrier configuration
    [Tags]           Q2:2023  JIRA:O5SA-654  qTest:120278997  createCarrierConfig
    [Documentation]  This is to test (POST endpoint) to create carrier configuration
    ...              The API response should be 201 created, and the data should be stored in the database
    [Setup]     "CHECK" the carrier configuration in the DB
    Use the POST endpoint to create a carrier configuration
    The API response should be 201 with the carrier configuration created displayed
    Compare the carrier configuration created, with the data storaged in the database
    [Teardown]  "REMOVE" the carrier configuration in the DB

(Carrier Config) POST ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q2:2023  JIRA:O5SA-654  qTest:120279132  createCarrierConfigErrors
    [Documentation]  This is to test all EXPECTED ERRORS about the endpoint [POST to CREATE a carrier configuration]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Setting up the environment
    [Documentation]  Setting up the API URL, creating and authorizing the user
    Get URL For Suite    ${CarrierServiceAPI}
    Create My User   persona_name=am_admin  application_name=OTR_eMgr  entity_id=${EMPTY}  with_data=N

Command to see carrier configuration
    [Documentation]  Use this command to see carrier configuration details in the database
    Get into DB  ${db}
        ${carrier_config_query}  Catenate   select * from carrier_configuration where
        ...                                 carrier_id = '${automation_entity_id}';
        ${carrier_config_count}  Row Count  ${carrier_config_query}  ${db}
        ${DB_carrier_config}  Query to Dictionaries  ${carrier_config_query}
    Disconnect from Database
    Set Test Variable   ${carrier_config_count}
    Set Test Variable   ${DB_carrier_config}

Command to remove carrier configuration
    [Documentation]  Use this command to remove a carrier configuration in the database
    #TODO Replace this respective manual command with the DELETE request when it is implemented
    Get into DB  ${db}
        Execute sql string  dml=delete from carrier_configuration where carrier_id = '${automation_entity_id}';
    Disconnect from Database

"${operation}" the carrier configuration in the DB
    [Documentation]  Use to check if the respective carrier configuration already exists in the database
    IF  ('${operation}'=='GET') or ('${operation}'=='CHECK')
       Command to see carrier configuration
       IF  ('${operation}'=='CHECK') and ('${carrier_config_count}'>='1')
            Command to remove carrier configuration
       END
    ELSE IF  '${operation}'=='REMOVE'
        Command to remove carrier configuration
    ELSE
        Command to see carrier configuration
    END

Sending post request
    [Documentation]  Used to build a generic REQUEST structure of the endpoint [POST to CREATE a carrier config]
    [Arguments]  ${path}=carriers/${automation_entity_id}  ${authorized}=Y   ${what_remove}=${NONE}

    ${path_url}          Create dictionary  None=${path}
    ${config_notes}      Create Dictionary  carrier_name=Automation        notes=test1234
    ${carrier_config}    Create Dictionary  fuel_purchase_carrier=${TRUE}  config_notes=${config_notes}
    ...                  config_property_name=Test automation
    ${payload}  Create Dictionary  carrier_configuration=${carrier_config}

    IF  ${what_remove}!=${NONE}
        FOR  ${remove}  IN   @{what_remove}
            Remove From Dictionary  ${payload}  ${remove.lower()}
        END
    END

    ${result}   ${status}  Api request   POST  carrier-configs  ${authorized}  ${path_url}  application=OTR_eMgr
    ...                                  payload=${payload}
    Set Test Variable  ${result}
    Set Test Variable  ${status}
    Set Test Variable  ${payload}

###################################################### HAPPY PATH #####################################################
Use the POST endpoint to create a carrier configuration
    [Documentation]  Sending the request to OTR Carrier Service API to create a new carrier configuration
    Sending post request

The API response should be 201 with the carrier configuration created displayed
    [Documentation]  Cheking STATUS and the fields [CARRIER_ID | CARRIER_CONFIGURATION] displayed into the API response
    Set Test Variable  ${result_carrierConfig}  ${result}[details][data][carrier_configuration]

    Should Be Equal As Strings  ${status}                             201
    Should Be Equal As Strings  ${result}[name]                       CREATED
    Should Be Equal As Strings  ${result}[details][type]              CarrierConfigurationResponseDTO
    Should Be Equal As Strings  ${result}[details][data][carrier_id]  ${automation_entity_id}
    Should Be Equal As Strings  ${result_carrierConfig}[config_property_name]   ${payload}[carrier_configuration][config_property_name]
    Should Be Equal As Strings  ${result_carrierConfig}[fuel_purchase_carrier]  ${payload}[carrier_configuration][fuel_purchase_carrier]
    Should Be Equal As Strings  ${result_carrierConfig}[config_notes][notes]    ${payload}[carrier_configuration][config_notes][notes]
    Should Be Equal As Strings  ${result_carrierConfig}[config_notes][carrier_name]  ${payload}[carrier_configuration][config_notes][carrier_name]

    ${links_dic}  Convert To Dictionary  ${result}[details][data][links]
    Should Be Equal As Strings   ${links_dic}   {'rel': 'href'}

Compare the carrier configuration created, with the data storaged in the database
    [Documentation]  Compare the carrier configuration created, with the data storaged in the database
    "GET" the carrier configuration in the DB

    ${DB_id}       Convert To String  ${DB_carrier_config}[0][id]
    ${DB_updated}  Convert To String  ${DB_carrier_config}[0][updated]
    Should Not Be Empty  ${DB_id}
    Should Not Be Empty  ${DB_updated}
    Should Be Equal As Strings  ${DB_carrier_config}[0][updated_by]  ${auto_user_id}
    Should Be Equal As Strings  ${DB_carrier_config}[0][carrier_id]  ${automation_entity_id}
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][config_property_name]   ${result_carrierConfig}[config_property_name]
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][fuel_purchase_carrier]  ${result_carrierConfig}[fuel_purchase_carrier]
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][config_notes][notes]    ${result_carrierConfig}[config_notes][notes]
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][config_notes][carrier_name]  ${result_carrierConfig}[config_notes][carrier_name]

################################################### EXPECTED ERRORS ###################################################
ERROR - RESPONSE EXPECTED
    [Documentation]  Use to validade EXPECTED ERRORS of this endpoints (400, 401, 403, 404, 422)
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
    ELSE IF  '${code}'=='422'
        Should Be Equal As Strings     ${status}                422
        Should Be Equal As Strings     ${result}[name]          ENTITY_ALREADY_EXISTS
        Should Be Equal As Strings     ${result}[error_code]    ENTITY_ALREADY_EXISTS
        Should Be Equal As Strings     ${result}[message]       The requested entity already exists.
    ELSE IF  '${code}'=='400'
        Should Be Equal As Strings     ${status}  400
        IF    '${with_body}'=='YES'
            Should Be Equal As Strings  ${result}[name]                 BAD_REQUEST
            Should Be Equal As Strings  ${result}[details][0][field]    carrierConfiguration
            Should Be Equal As Strings  ${result}[details][0][issue]    must not be empty
            Should Be Equal As Strings  ${result}[message]              Invalid request input
        ELSE IF    '${with_body}'=='NO'
            Should Be Empty         ${result}
        END
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests
    ${error_list}   Create List
    ...  UNAUTHORIZED TOKEN     CARRIER NOT ASSIGNED    CARRIER NOT SEND    CARRIER CONFIG EMPTY
    ...  CARRIER CONFIG ALREADY EXISTENT

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (Carrier Config) POST ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Post Request  authorized=I
    ERROR - RESPONSE EXPECTED   code=401

ERROR - CARRIER ${detail}
    [Documentation]  Testing the request with CARRIER_ID (not send, not assigned to the user, using an unon-existent,
    ...     or using a carrier which the respective carrier_configuration already exist in the database)
    IF  '${detail}'=='NOT ASSIGNED'
        Sending Post Request  path=carriers/9999999
        ERROR - RESPONSE EXPECTED   code=403
    ELSE IF  '${detail}'=='NOT SEND'
        Sending Post Request  path=carriers
        ERROR - RESPONSE EXPECTED   code=404
    ELSE IF  '${detail}'=='CONFIG ALREADY EXISTENT'
        FOR  ${count}   IN RANGE  0   2
            Sending Post Request
        END
        ERROR - RESPONSE EXPECTED   code=422
        "REMOVE" the carrier configuration in the DB
    END

ERROR - CARRIER CONFIG EMPTY
    [Documentation]  Testing the request with the key (carrier_configuration) EMPTY
    @{fields_to_remove}   Create List    carrier_configuration
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED   code=400    with_body=YES