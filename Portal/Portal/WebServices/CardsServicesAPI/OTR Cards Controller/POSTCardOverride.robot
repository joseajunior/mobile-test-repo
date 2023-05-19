*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the POSTCardOverride endpoint in the OTR-Cards controller
...  within the Cards API Services

Force Tags  CardServicesAPI  API
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
POST Card Override
    [Documentation]  Test the POST Card Override Endpoint with valid data
    [Tags]      JIRA:O5SB-54  qTest:55909726  OTR-Cards  refactor
    [Setup]  Generate Data for Request
    Send POST API Request for a Card
    Compare POST Endpoint Results
    [Teardown]  Remove Automation User if Necessary and Delete Override

POST Card Override using Empty Carrier ID
    [Documentation]  Test the POST Card Override Endpoint with carrier id set to empty
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Empty Carrier ID
    [Teardown]  Remove User if Necessary

POST Card Override using Empty Card ID
    [Documentation]  Test the POST Card Override Endpoint with card id set to empty
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Empty Card ID
    [Teardown]  Remove User if Necessary

POST Card Override using Invalid Carrier ID
    [Documentation]  Test the POST Card Override Endpoint with invalid/large carrier id
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Invalid Carrier ID
    [Teardown]  Remove User if Necessary

POST Card Override using Card ID for Different Carrier
    [Documentation]  Test the POST Card Override Endpoint with invalid/large card id
    [Tags]      JIRA:O5SB-54    JIRA:O5SA-373  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Card ID for Different Carrier
    [Teardown]  Remove User if Necessary

POST Card Override using Characters for Card ID
    [Documentation]  Test the POST Card Override Endpoint with characters for card id
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Characters for Card ID
    [Teardown]  Remove User if Necessary

POST Card Override using Characters for Carrier ID
    [Documentation]  Test the POST Card Override Endpoint with characters for carrier id
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Characters for Carrier ID
    [Teardown]  Remove User if Necessary

POST Card Override using Invalid Token
    [Documentation]  Test the POST Card Override Endpoint with an invalid token
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Invalid Token
    [Teardown]  Remove User if Necessary

POST Card Override using Invalid Override Type
    [Documentation]  Test the POST Card Override Endpoint with invalid value for override type
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Invalid Override Type
    [Teardown]  Remove User if Necessary

POST Card Override using Invalid Number of Transactions
    [Documentation]  Test the POST Card Override Endpoint with number of transactions set to empty
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Invalid Number of Transactions
    [Teardown]  Remove User if Necessary

POST Card Override using Zero for Transactions
    [Documentation]  Test the POST Card Override Endpoint with number of transactions set to 0
    [Tags]      JIRA:O5SB-54  qTest:55617810   OTR-Cards
    [Setup]  Generate Data for Request
    POST Card Override with Zero for Transactions
    [Teardown]  Remove User if Necessary

*** Keywords ***
Generate Data for Request
    [Documentation]  gets necessary information to run tests
    [Arguments]  ${reset_user_status}=N
    Getting API URL
    ${api_data_value}  get variable value  $api_data  default
    IF  $api_data_value=='default'
        ${my_carrier_id}  Find Carrier in Oracle  A
        Set Suite Variable  ${my_carrier_id}
    END
    Create My User         persona_name=carrier_manager  entity_id=${my_carrier_id}  with_data=N  need_new_user=${reset_user_status}
    ${values}  Find Data to be Used for Requests  ${my_carrier_id}
    Set Suite Variable  ${api_data}  ${values}

Getting API URL
    [Documentation]  get url to be used for tests
    Get url for suite    ${cardsservice}

Query to find Override cards
    [Documentation]  Creating a query to find data to be used in the request
    [Arguments]    ${details}

    Get into DB  TCH
        ${count}  Catenate  select count(*) from contract where carrier_id = ${my_carrier_id}
        ${count_results}  Query and Return Dictionary Rows  ${count}
        ${rand_num}  Evaluate  random.randint(0, (${count_results}[0][1] - 1))  random

        ${tch_query}  Catenate  select skip ${rand_num} carrier_id, card_id, cardoverride, card_num FROM cards
        ...  WHERE ${details}
        ...  and carrier_id = '${my_carrier_id}' LIMIT 1
        ${url_values}  Query and Strip to Dictionary  ${tch_query}
    Disconnect from Database

    Set Suite Variable    ${url_values}     ${url_values}

Find Data to be Used for Requests
    [Documentation]  get the data to be used in the request
    [Arguments]  ${my_carrier_id}
        Query to find Override cards        card_num not like '%OVER%' and cardoverride > '0'

        ## IF CARD IS WITHOUT OVERRIDE, IT SHOULD CREATE A NEW ONE
        IF  '''${url_values}'''=='''&{EMPTY}'''
            Query to find Override cards    cardoverride = '0'
            Send POST API Request for a Card
        END

    [Return]  ${url_values}

Send ${request_type} API Request for a Card
    [Documentation]  send request with valid data.
    ...  This is basically just send request but with a descriptive name
    Send Request  ${request_type.upper()}

${request_type} Card Override with ${error}
    [Documentation]  Send request based on error to check for appropriate status code
    IF  '${error.upper()}'=='EMPTY CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=${EMPTY}
        Should be Equal as Strings  ${status}  401
        Should be Equal  ${response}  ${EMPTY}
    ELSE IF  '${error.upper()}'=='EMPTY CARD ID'
        Send Request  ${request_type.upper()}  card_id=${EMPTY}
        Should be Equal as Strings  ${status}  401
        Should be Equal  ${response}  ${EMPTY}
    ELSE IF  '${error.upper()}'=='INVALID CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=999999
        Should be Equal as Strings  ${status}  403
    ELSE IF  '${error.upper()}'=='INVALID CARRIER ID'
        Send Request  ${request_type.upper()}  card_id=99999999999999
        Should be Equal as Strings  ${status}  403
    ELSE IF  '${error.upper()}'=='CARD ID FOR DIFFERENT CARRIER'
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
    ELSE IF  '${error.upper()}'=='CHARACTERS FOR CARD ID'
        Send Request  ${request_type.upper()}  card_id=card_id
        Should be Equal as Strings  ${status}  400
    ELSE IF  '${error.upper()}'=='CHARACTERS FOR CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=carrier_id
        Should be Equal as Strings  ${status}  403
    ELSE IF  '${error.upper()}'=='INVALID TOKEN'
        Send Request  ${request_type.upper()}  secure=I
        Should be Equal as Strings  ${status}  401
    ELSE IF  '${error.upper()}'=='INVALID OVERRIDE TYPE'
        Send Request  ${request_type.upper()}  override_type=TEST
        Should be Equal as Strings  ${status}  400
    ELSE IF  '${error.upper()}'=='INVALID NUMBER OF TRANSACTIONS'
        Send Request  ${request_type.upper()}  num_of_transactions=${EMPTY}
        Should be Equal as Strings  ${status}  400
    ELSE IF  '${error.upper()}'=='ZERO FOR TRANSACTIONS'
        Send Request  ${request_type.upper()}  num_of_transactions=0
        Should be Equal as Strings  ${status}  400
    #TODO implement these after O5SA-330 and 329
#    ELSE IF  '${error.upper()}'=='DIFFERENT USER'
#    ELSE IF  '${error.upper()}'=='DIFFERENT PERMISSION'
    ELSE
        Fail  ${error.upper()} not implemented
    END

Send Request
    [Documentation]  send the request to the POST Card Override endpoint
    [Arguments]      ${request_type}  ${card_id}=${api_data}[card_id]  ${carrier_id}=${api_data}[carrier_id]  ${override_type}=NETWORK  ${num_of_transactions}=5  ${secure}=Y

    ${payload}    Create Dictionary   num_of_transactions=${num_of_transactions}   override_type=${override_type}
    ${url_stuff}  Create Dictionary   None=${card_id}  carriers=${carrier_id}  overrides=None

    ${response}  ${status}  Api Request  POST  otr-cards  ${secure}  ${url_stuff}  application=OTR_eMgr
    ...                                  payload=${payload}

    Set Test Variable  ${response}
    Set Test Variable  ${status}

Compare POST Endpoint Results
    [Documentation]  Compares the endpoint results with DB for valid data
    ${stripped_card_num}   Set Variable   ${api_data['card_num'].strip()}
    ${card_db_info_ov}     Set Variable   ${stripped_card_num}OVER
    ${override_info}  Get Override Info   ${card_db_info_ov}

    Should be Equal as Strings      ${status}  200
    Should Be Equal As Strings      ${response}[details][data][card_id]              ${api_data}[card_id]
    Should Be Equal As Strings      ${response}[details][data][remaining_overrides]  ${override_info}[cardoverride]
    Should Be Equal As Strings      ${response}[details][data][override_card_id]     ${override_info}[card_id]
    Should Be Equal As Strings      ${response}[details][data][override_type]        NETWORK
    Should Be Equal As Strings      ${response}[details][data][override_all_locs]    True
    Should Be Equal As Strings      ${response}[details][data][allow_hand_enter]     False

Get Override Info
    [Documentation]  Gets information for the card override and the card id for the override.
    ...  This is done after the override request has been made
    [Arguments]  ${override_num}  ${card_id}=${api_data}[card_id]
    ${override}  Catenate  select cardoverride from cards where card_id = '${card_id}'
    ${card_id}  Catenate  select card_id from cards where card_num='${override_num}'
    Get into DB  TCH
    ${db_results_override}  query and strip  ${override}
    ${db_results_card_id}  query and strip  ${card_id}
    ${db_results}  Create Dictionary  cardoverride=${db_results_override}  card_id=${db_results_card_id}
    Disconnect from Database
    [Return]  ${db_results}

Delete Card Override Wrapper
    [Documentation]     Use the json auth api to delete created transactions
    [Arguments]         ${card_id}

    Get Url For Suite    ${JsonAuthAPI}

    ${header}                  Create Dictionary      x-correlation-id=override-javaapi-testing  x-informix-instance=TCH  x-user-id=robot-framework-testing
    ${url_stuff}               Create Dictionary      ${card_id}=overrides
    ${response}  ${status}     API Request            DELETE  cards  N  ${url_stuff}  header=${header}
    Should be Equal as Strings  ${status}  200

Remove Automation User if Necessary and Delete Override
    [Documentation]  Deletes automation user for test and deletes the created override
    Delete Card Override Wrapper    ${api_data}[card_id]
    Remove User if Necessary