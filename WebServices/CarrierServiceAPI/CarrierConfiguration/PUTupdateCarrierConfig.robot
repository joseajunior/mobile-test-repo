*** Settings ***
Library     String
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setting up the environment
Suite Teardown  Setting up the environment to FINISH

Documentation  This is to test the endpoint [PUT to update an existent carrier configuration]
...            OTR Carriers Service API to manage carriers, carrier aliases, etc, within the WEX OTR system.
...            URL: (https://carrierservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.
Force Tags     API  CarrierServiceAPI  ditOnly

*** Variables ***
${db}  postgrespgcarrierservices
${created_now}  ${FALSE}

*** Test Cases ***
############################## Carrier Configuration ################################
#-----------------------------------------------------------------------------------#
#        Endpoint PUT:  /carrier-configs/{config_id}/carriers/{carrier_id}          #
#-----------------------------------------------------------------------------------#
(Carrier Config) PUT - To UPDATE an existent carrier configuration
    [Tags]           Q2:2023  JIRA:O5SA-655  qTest:120286901  updateCarrierConfig
    [Documentation]  This is to test (PUT endpoint) to UPDATE an existent carrier configuration
    ...              The API response should be 200 SUCCESS, with carrier configuration displayed in the response and
    ...              updated in the database
    [Setup]    "Find" carrier configuration in the DB
    Use the PUT endpoint to UPDATE an existent carrier configuration
    The API response should be 200 with the carrier configuration updates displayed
    Compare the carrier configuration updated with the respective data in the database
    [Teardown]  "Remove" carrier configuration in the DB

(Carrier Config) PUT ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q2:2023  JIRA:O5SA-655  qTest:120287190  updateCarrierConfigErrors
    [Documentation]  This is to test all EXPECTED ERRORS of [PUT to update an existent carrier configuration]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Setting up the environment
    [Documentation]  Setting up the API URL, creating and authorizing the user
    Get URL For Suite    ${CarrierServiceAPI}
    Create My User   persona_name=am_admin  application_name=OTR_eMgr  entity_id=${EMPTY}  with_data=N

Setting up the environment to FINISH
    [Documentation]  Removing the user and carrier configuration created
    Remove User if Still exists
    "Remove" carrier configuration in the DB

Command to find carrier configuration in the DB
    [Documentation]  Use to see carrier configuration details in the database
    Get into DB  ${db}
        ${query}  Catenate   select * from carrier_configuration where carrier_id = '${automation_entity_id}';
        ${DB_carrier_config}   Query to Dictionaries   ${query}
        ${DB_carrier_config_count}  Row Count   ${query}  ${db}
    Disconnect from Database
    Set Suite Variable   ${DB_carrier_config}
    Set Suite Variable   ${DB_carrier_config_count}

Command to remove carrier configuration
    [Documentation]  Use this command to remove a carrier configuration in the database
    #TODO Replace this respective manual command with the DELETE request when it is implemented
    Get into DB  ${db}
        Execute sql string  dml=delete from carrier_configuration where carrier_id = '${automation_entity_id}';
    Disconnect from Database

Sending post request
    [Documentation]  Used to build a generic REQUEST structure of the endpoint [POST to CREATE a carrier config]
    [Arguments]  ${path}=carriers/${automation_entity_id}  ${authorized}=Y   ${what_remove}=${NONE}

    ${path_post}       Create dictionary  None=${path}
    ${carrier_config}  Create Dictionary  fuel_purchase_carrier=${TRUE}  config_property_name=Creating test
    ${payload_post}    Create Dictionary  carrier_configuration=${carrier_config}

    ${result_post}  ${status_post}  Api request   POST  carrier-configs  ${authorized}  ${path_post}  application=OTR_eMgr
    ...                                           payload=${payload_post}
    Should Be Equal As Strings   ${status_post}   201
    Set Test Variable  ${created_now}   ${TRUE}

Sending put request
    [Documentation]  Used to build a generic REQUEST structure of the endpoint [PUT to update a carrier configuration]
    [Arguments]  ${path}=${configID}/carriers/${carrierID}  ${authorized}=Y   ${what_remove}=${NONE}

    ${path_url}          Create dictionary  None=${path}
    ${config_notes}      Create Dictionary  carrier_name=AutomationPUT      notes=123456
    ${carrier_config}    Create Dictionary  fuel_purchase_carrier=${FALSE}  config_notes=${config_notes}
    ...                                     config_property_name=Test PUT automation
    ${payload}           Create Dictionary  carrier_configuration=${carrier_config}

    IF  ${what_remove}!=${NONE}
        FOR  ${remove}  IN   @{what_remove}
            Remove From Dictionary  ${payload}  ${remove.lower()}
        END
    END

    ${result}   ${status}  Api request   PUT  carrier-configs  ${authorized}  ${path_url}  application=OTR_eMgr
    ...                                  payload=${payload}
    Set Test Variable  ${result}
    Set Test Variable  ${status}
    Set Test Variable  ${payload}

"${operation}" carrier configuration in the DB
    [Documentation]  Use to check if the respective carrier configuration already exists in the database
    IF  ('${operation}'=='Find')
         Command to find carrier configuration in the DB
         IF  ('${DB_carrier_config_count}'<'1')
             Sending Post Request
             Command to find carrier configuration in the DB
             Set Suite Variable  ${carrierID}  ${DB_carrier_config}[0][carrier_id]
             Set Suite Variable  ${configID}   ${DB_carrier_config}[0][id]
         ELSE IF  ('${DB_carrier_config_count}'>='1')
             Set Suite Variable  ${carrierID}  ${DB_carrier_config}[0][carrier_id]
             Set Suite Variable  ${configID}   ${DB_carrier_config}[0][id]
         END
    ELSE IF  ('${operation}'=='Remove') and ('${created_now}'=='${TRUE}')
         ${automation_entity_id}  catenate  ${carrierID}
         Command to find carrier configuration in the DB
         IF  ('${DB_carrier_config_count}'>='1')
             Command to remove carrier configuration
         END
    ELSE IF  ('${operation}'=='Get')
        ${automation_entity_id}  catenate  ${carrierID}
        Command to find carrier configuration in the DB
    END

###################################################### HAPPY PATH #####################################################
Use the PUT endpoint to UPDATE an existent carrier configuration
    [Documentation]  Sending the request to OTR Carrier Service API to update an existent carrier configuration
    Sending put request

The API response should be 200 with the carrier configuration updates displayed
    [Documentation]  Cheking STATUS and carrier configuration fields updated displayed into the API response
    Set Test Variable  ${result_carrierConfig}  ${result}[details][data][carrier_configuration]

    Should Be Equal As Strings  ${status}                             200
    Should Be Equal As Strings  ${result}[name]                       OK
    Should Be Equal As Strings  ${result}[message]                    SUCCESSFUL
    Should Be Equal As Strings  ${result}[details][type]              CarrierConfigurationResponseDTO
    Should Be Equal As Strings  ${result}[details][data][carrier_id]  ${carrierID}
    Should Be Equal As Strings  ${result_carrierConfig}[config_property_name]   ${payload}[carrier_configuration][config_property_name]
    Should Be Equal As Strings  ${result_carrierConfig}[fuel_purchase_carrier]  ${payload}[carrier_configuration][fuel_purchase_carrier]
    Should Be Equal As Strings  ${result_carrierConfig}[config_notes][notes]    ${payload}[carrier_configuration][config_notes][notes]
    Should Be Equal As Strings  ${result_carrierConfig}[config_notes][carrier_name]  ${payload}[carrier_configuration][config_notes][carrier_name]

    ${links_dic}  Convert To Dictionary  ${result}[details][data][links]
    Should Be Equal As Strings   ${links_dic}   {'rel': 'href'}

Compare the carrier configuration updated with the respective data in the database
    [Documentation]  Compare the carrier configuration updated with the respective data in the database
    "Get" carrier configuration in the DB

    Should Be Equal As Numbers  ${DB_carrier_config}[0][id]          ${configID}
    Should Be Equal As Strings  ${DB_carrier_config}[0][carrier_id]  ${carrierID}
    Should Be Equal As Strings  ${DB_carrier_config}[0][updated_by]  ${auto_user_id}
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][config_property_name]   ${result_carrierConfig}[config_property_name]
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][fuel_purchase_carrier]  ${result_carrierConfig}[fuel_purchase_carrier]
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][config_notes][notes]    ${result_carrierConfig}[config_notes][notes]
    Should Be Equal As Strings  ${DB_carrier_config}[0][configuration][config_notes][carrier_name]  ${result_carrierConfig}[config_notes][carrier_name]
    ${DB_updated}  Convert To String  ${DB_carrier_config}[0][updated]
    Should Not Be Empty  ${DB_updated}

################################################### EXPECTED ERRORS ###################################################
ERROR - RESPONSE EXPECTED
    [Documentation]  Use to validade EXPECTED ERRORS of this endpoints (400, 401, 403, 404, 405, 422)
    [Arguments]      ${code}=${NONE}   ${with_body}=${NONE}
    IF  '${code}'=='404'
        Should Be Equal As Strings     ${status}          404
        Should Be Equal As Strings     ${result}[status]  404
        Should Be Equal As Strings     ${result}[path]    /carrier-configs/${configID}/carriers/
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
    ELSE IF  '${code}'=='405'
        Should Be Equal As Strings     ${status}  405
        Should Be Empty                ${result}
    ELSE IF  '${code}'=='422'
        Should Be Equal As Strings     ${status}                422
        Should Be Equal As Strings     ${result}[name]          ENTITY_NOT_FOUND
        Should Be Equal As Strings     ${result}[error_code]    ENTITY_NOT_FOUND
        Should Be Equal As Strings     ${result}[message]       The requested entity could not be found.
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
    ...  UNAUTHORIZED TOKEN
    ...  CONFIG_ID NOT SEND       CONFIG_ID INVALID STRING     CONFIG_ID INTEGER DOES NOT EXIST
    ...  CARRIER_ID NOT SEND      CARRIER_ID NOT ASSIGNED      CARRIER CONFIG EMPTY

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    "Find" carrier configuration in the DB
    FOR  ${error}  IN  @{error_list}
         Add Test Case  (Carrier Config) PUT ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Put Request  authorized=I
    ERROR - RESPONSE EXPECTED   code=401

ERROR - CONFIG_ID ${detail}
    [Documentation]  Testing the request with CONFIG_ID (not send, using an invalid string, or a integer number
    ...     does not exists in the database)
    IF  '${detail}'=='NOT SEND'
        Sending Put Request  path=carriers/${carrierID}
        ERROR - RESPONSE EXPECTED   code=405
    ELSE IF  '${detail}'=='INVALID STRING'
        Sending Put Request  path=INVALID/carriers/${carrierID}
        ERROR - RESPONSE EXPECTED   code=400    with_body=NO
    ELSE IF  '${detail}'=='INTEGER DOES NOT EXIST'
        Sending Put Request  path=9999999/carriers/${carrierID}
        ERROR - RESPONSE EXPECTED   code=422
    END

ERROR - CARRIER_ID ${detail}
    [Documentation]  Testing the request with CARRIER_ID (not send, not assigned to the user)
    IF  '${detail}'=='NOT ASSIGNED'
        Sending Put Request  path=${configID}/carriers/9999999
        ERROR - RESPONSE EXPECTED   code=403
    ELSE IF  '${detail}'=='NOT SEND'
        Sending Put Request  path=${configID}/carriers/
        ERROR - RESPONSE EXPECTED   code=404
    END

ERROR - CARRIER CONFIG EMPTY
    [Documentation]  Testing the request with the key (carrier_configuration) EMPTY
    @{fields_to_remove}   Create List    carrier_configuration
    Sending Put Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED   code=400    with_body=YES