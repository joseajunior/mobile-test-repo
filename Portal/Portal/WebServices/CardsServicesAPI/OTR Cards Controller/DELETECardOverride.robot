*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the DELETECardOverride endpoint in the OTR-Cards controller
...  within the Cards API Services

Force Tags  CardServicesAPI  API
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
DELETE Card Override
    [Documentation]  Test the DELETE Card Override Endpoint with valid data
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55888791  OTR-Cards  refactor
    [Setup]  Generate Data for Request
    Send DELETE API Request for a Card
    Compare DELETE Endpoint Results
    [Teardown]  Remove User if Necessary

DELETE Card Override using Empty Carrier ID
    [Documentation]  Test the DELETE Card Override Endpoint with carrier id set to empty
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Empty Carrier ID
    [Teardown]  Remove User if Necessary

DELETE Card Override using Empty Card ID
    [Documentation]  Test the DELETE Card Override Endpoint with card id set to empty
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Empty Card ID
    [Teardown]  Remove User if Necessary

DELETE Card Override using Characters for Carrier ID
    [Documentation]  Test the DELETE Card Override Endpoint with characters in the carrier id
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Characters for Carrier ID
    [Teardown]  Remove User if Necessary

DELETE Card Override using Characters for Card ID
    [Documentation]  Test the DELETE Card Override Endpoint with characters in the card id
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Characters for Card ID
    [Teardown]  Remove User if Necessary

DELETE Card Override using Card ID for Different User
    [Documentation]  Test the DELETE Card Override Endpoint with card id for a different user
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Card ID for Different User
    [Teardown]  Remove User if Necessary

DELETE Card Override using Invalid Card ID
    [Documentation]  Test the DELETE Card Override Endpoint with invalid card id
    [Tags]      PI:13  JIRA:O5SB-50  JIRA:O5SA-373  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Invalid Card ID
    [Teardown]  Remove User if Necessary

DELETE Card Override using Invalid Carrier ID
    [Documentation]  Test the DELETE Card Override Endpoint with invalid carrier id
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Invalid Carrier ID
    [Teardown]  Remove User if Necessary

DELETE Card Override using Invalid Token
    [Documentation]  Test the DELETE Card Override Endpoint with invalid token
    [Tags]      PI:13  JIRA:O5SB-50  qTest:55890159  OTR-Cards
    [Setup]  Generate Data for Request
    DELETE Card Override Error with Invalid Token
    [Teardown]  Remove User if Necessary

*** Keywords ***
Generate Data for Request
    [Documentation]  gets necessary information to run tests
    [Arguments]  ${reset_user_status}=N
    Getting API URL
    ${api_data_value}  get variable value  $api_data  default
    ${override_value}  get variable value  $override_created  default
    IF  $api_data_value=='default'
        ${my_carrier_id}  Find Carrier in Oracle  A
        Set Suite Variable  ${my_carrier_id}
    END

    Create My User  persona_name=carrier_manager  entity_id=${my_carrier_id}  with_data=N  need_new_user=${reset_user_status}
    ${values}  Find Data to be Used for Requests  ${my_carrier_id}

    Set Suite Variable  ${api_data}  ${values}
    IF  'using' not in $TESTNAME
        ${override_created}  Run Keyword and Return Status  Create Card Override
        Set Suite Variable  ${override_created}  ${override_created}
    END

Getting API URL
    [Documentation]  get url to be used for tests
    Get url for suite    ${cardsservice}

Query to find Override cards
    [Documentation]  Creating a query to find data to be used in the request
    [Arguments]    ${signal}

    Get into DB  TCH
        ${count}  Catenate  select count(*) from contract where carrier_id = ${my_carrier_id}
        ${count_results}  Query and Return Dictionary Rows  ${count}
        ${rand_num}  Evaluate  random.randint(0, (${count_results}[0][1] - 1))  random

        ${tch_query}  Catenate  select skip ${rand_num} carrier_id, card_id, cardoverride, card_num FROM cards
        ...  WHERE card_num not like '%OVER%'
        ...  and cardoverride ${signal} '0'
        ...  and carrier_id = '${my_carrier_id}' LIMIT 1
        ${url_values}  Query and Strip to Dictionary  ${tch_query}
    Disconnect from Database

    Set Suite Variable    ${url_values}     ${url_values}

Find Data to be Used for Requests
    [Documentation]  get the data to be used in the request
    [Arguments]  ${my_carrier_id}
        Query to find Override cards        >

        ## IF CARD IS WITHOUT OVERRIDE, IT SHOULD CREATE A NEW ONE
        IF  '''${url_values}'''=='''&{EMPTY}'''
            Query to find Override cards    =
            Create Card Override    ${url_values}
            Getting API URL
        END

    [Return]  ${url_values}

Create Card Override
    [Documentation]  use the json auth wrapper to create a card override to be used for test
    Get URL For Suite    ${JsonAuthAPI}

    [Arguments]               ${api_data}=${api_data}
    ${header}                 Create Dictionary      x-correlation-id=override-javaapi-testing  x-informix-instance=TCH  x-user-id=robot-framework-testing
    ${url_temp}               Create Dictionary      ${api_data}[card_id]=overrides
    ${payload}                Create Dictionary      total_overrides=3    override_type=NETWORK   override_all_locs=true  allow_handenter=true
    ${response}  ${status}    API Request    POST  cards  N  ${url_temp}  header=${header}  payload=${payload}

    Get URL For Suite    ${cardsservice}

Send ${request_type} API Request for a Card
    [Documentation]  send request to endpoint.
    ...  Basically just the send request keyword but more descriptive
    Send Request  ${request_type.upper()}

Send Request
    [Documentation]  send request to endpoint.
    [Arguments]      ${request_type}  ${card_id}=${api_data}[card_id]  ${carrier_id}=${api_data}[carrier_id]  ${secure}=Y
    ${url_stuff}  Create Dictionary  None=${card_id}  carriers=${carrier_id}  overrides=None
    ${response}  ${status}  Api Request    DELETE  otr-cards  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${response}
    Set Test Variable  ${status}

${request_type} Card Override Error with ${error}
    [Documentation]  test endpoint status codes with errors
    IF  '${error.upper()}'=='EMPTY CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=${EMPTY}
        Should be Equal as Strings  ${status}  401
    ELSE IF  '${error.upper()}'=='EMPTY CARD ID'
        Send Request  ${request_type.upper()}  card_id=${EMPTY}
        Should be Equal as Strings  ${status}  401
    ELSE IF  '${error.upper()}'=='CHARACTERS FOR CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=test
        Should be Equal as Strings  ${status}  403
    ELSE IF  '${error.upper()}'=='CHARACTERS FOR CARD ID'
        Send Request  ${request_type.upper()}  card_id=test
        Should be Equal as Strings  ${status}  400
    ELSE IF  '${error.upper()}'=='CARD ID FOR DIFFERENT USER'
        Get into DB  TCH
        ${query}  Catenate  select card_id from cards where carrier_id != '${api_data}[carrier_id]' limit 10
        ${db_results}  Query to Dictionaries  ${query}
        ${card_id}  Evaluate  random.choice(${db_results})  random
        Disconnect from Database
        Send Request  ${request_type.upper()}  card_id=${card_id}[card_id]

        ${result}  Get Dictionary Keys  ${response}
        Should be Equal as Strings  ${status}  422
        Should Be Equal As Strings  ${result}[0]  error_code
        Should Be Equal As Strings  ${result}[1]  message
        Should Be Equal As Strings  ${result}[2]  name
    ELSE IF  '${error.upper()}'=='INVALID CARD ID'
        Send Request  ${request_type.upper()}  card_id=99999999999999

        ${result}  Get Dictionary Keys  ${response}
        Should be Equal as Strings  ${status}  422
        Should Be Equal As Strings  ${result}[0]  error_code
        Should Be Equal As Strings  ${result}[1]  message
        Should Be Equal As Strings  ${result}[2]  name
    ELSE IF  '${error.upper()}'=='INVALID CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=999999
        Should be Equal as Strings  ${status}  403
    ELSE IF  '${error.upper()}'=='INVALID TOKEN'
        Send Request  ${request_type.upper()}  secure=I
        Should be Equal as Strings  ${status}  401
        #TODO implement these after O5SA-330 and 329
#    ELSE IF  '${error.upper()}'=='DIFFERENT USER'
#    ELSE IF  '${error.upper()}'=='DIFFERENT PERMISSION'
    ELSE
        Fail  ${error.upper()} not implemented
    END

Compare ${request_type} Endpoint Results
    [Documentation]  check the results for response with DB
    ${override_info}  Get Override Info
    Should Be Equal As Strings  ${response}[details][data][card_id]             ${api_data}[card_id]

    Should Be Equal As Strings  ${override_info}                      0

Get Override Info
    [Documentation]  Gets information for the card override and the card id for the override.
    ...  This is done after the override request has been made
    ${override}  Catenate  select cardoverride from cards where card_id = '${api_data}[card_id]'
    Get into DB  TCH
    ${db_results_override}  query and strip  ${override}
    Disconnect from Database
    [Return]  ${db_results_override}