*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the GETCardOverride endpoint in the OTR-Cards controller
...  within the Cards API Services

Force Tags  CardServicesAPI  API
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
GET Card Override
    [Documentation]  Test the GET Card Override Endpoint with valid data
    [Tags]  JIRA:O5SB-51  qTest:55617810  OTR-Cards
    [Setup]  Generate Data for Request
    Send GET API Request for a Card
    Compare GET Endpoint Results
    [Teardown]  Remove Automation User if Necessary and Delete Override

GET Card Override using Empty Carrier ID
    [Documentation]  Test the GET Card Override Endpoint with carrier id set to empty
    [Tags]  JIRA:O5SB-51  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Empty Carrier ID
    [Teardown]  Remove User if Necessary

GET Card Override using Empty Card ID
    [Documentation]  Test the GET Card Override Endpoint with card id set to empty
    [Tags]  JIRA:O5SB-51  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Empty Card ID
    [Teardown]  Remove User if Necessary

GET Card Override using Invalid Carrier ID
    [Documentation]  Test the GET Card Override Endpoint with invalid/long carrier id
    [Tags]  JIRA:O5SB-51  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Invalid Carrier ID
    [Teardown]  Remove User if Necessary

GET Card Override using Invalid Card ID
    [Documentation]  Test the GET Card Override Endpoint with invalid/big card id
    [Tags]  JIRA:O5SB-51  JIRA:O5SA-373  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Invalid Card ID
    [Teardown]  Remove User if Necessary

GET Card Override using Card ID for Different Carrier
    [Documentation]  Test the GET Card Override Endpoint with card id not for carrier
    [Tags]  JIRA:O5SB-51  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Card ID for Different Carrier
    [Teardown]  Remove User if Necessary

GET Card Override using Characters in Card ID
    [Documentation]  Test the GET Card Override Endpoint with characters in card id
    [Tags]  JIRA:O5SB-51  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Characters in Card ID
    [Teardown]  Remove User if Necessary

GET Card Override using Characters in Carrier ID
    [Documentation]  Test the GET Card Override Endpoint with characters in carrier id
    [Tags]  JIRA:O5SB-51  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Characters in Carrier ID
    [Teardown]  Remove User if Necessary

GET Card Override using Invalid Token
    [Documentation]  Test the GET Card Override Endpoint with invalid token
    [Tags]  JIRA:O5SB-51  qTest:55918139  OTR-Cards
    [Setup]  Generate Data for Request
    GET Card Override Error with Invalid Token
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
    ${response}  ${status}    API Request            POST  cards  N  ${url_temp}  application=OTR_eMgr  header=${header}
    ...                                              payload=${payload}

    Get URL For Suite    ${cardsservice}

Send ${request_type} API Request for a Card
    [Documentation]  send the request to the endpoint.
    ...  Basically is the send request endpoint but with a more descriptive name.
    Send Request  ${request_type.upper()}

Send Request
    [Documentation]  send the request to the endpoint
    [Arguments]      ${request_type}  ${card_id}=${api_data}[card_id]  ${carrier_id}=${api_data}[carrier_id]  ${override_type}=NETWORK  ${num_of_transactions}=5  ${secure}=Y
    ${url_stuff}            Create Dictionary      None=${card_id}  carriers=${carrier_id}  overrides=None
    ${response}  ${status}  API Request  GET  otr-cards  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${response}
    Set Test Variable  ${status}

Compare ${response_type} Endpoint Results
    [Documentation]  compares the results from the endpoint
    ${stripped_card_num}            Set Variable                                            ${api_data['card_num'].strip()}
    ${card_db_info_ov}              Set Variable            ${stripped_card_num}OVER
    ${override_info}                Get Override Info       ${card_db_info_ov}

    Should Be Equal As Strings  ${status}                                                   200
    Should Be Equal As Strings  ${response}[details][data][card_id]                         ${api_data}[card_id]
    Should Be Equal As Strings  ${response}[details][data][remaining_transactions]          ${override_info}[cardoverride]
    Should Be Equal As Strings  ${response}[details][data][overrides][0][override_card_id]  ${override_info}[card_id]
    Should Be Equal As Strings  ${response}[details][data][overrides][0][type]              NETWORK OVERRIDE   strip_spaces=true
    Should Be Equal As Strings  ${response}[details][data][in_card_override]                True

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

${request_type} Card Override Error with ${error}
    [Documentation]  check the response status for different errors
    IF  '${error.upper()}'=='EMPTY CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=${EMPTY}
        Should be Equal as Strings  ${status}  500
    ELSE IF  '${error.upper()}'=='EMPTY CARD ID'
        Send Request  ${request_type.upper()}  card_id=${EMPTY}
        Should be Equal as Strings  ${status}  500
    ELSE IF  '${error.upper()}'=='INVALID CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=999999
        Should be Equal as Strings  ${status}  403
    ELSE IF  '${error.upper()}'=='INVALID CARD ID'
        Send Request  ${request_type.upper()}  card_id=99999999999999

        ${result}  Get Dictionary Keys  ${response}
        Should be Equal as Strings  ${status}  422
        Should Be Equal As Strings  ${result}[0]  error_code
        Should Be Equal As Strings  ${result}[1]  message
        Should Be Equal As Strings  ${result}[2]  name
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
    ELSE IF  '${error.upper()}'=='CHARACTERS IN CARD ID'
        Send Request  ${request_type.upper()}  card_id=test
        Should be Equal as Strings  ${status}  400
    ELSE IF  '${error.upper()}'=='CHARACTERS IN CARRIER ID'
        Send Request  ${request_type.upper()}  carrier_id=test
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
    Set Suite Variable  ${override_created_status}  default
    Remove User if Necessary