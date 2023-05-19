*** Settings ***
Documentation       Test the Card ID Lookup endpoint that returns the card ID after entering card number

Library             String
Library             otr_robot_lib.ws.RestAPI.RestAPIService
Library             RequestsLibrary
Library             RedisLibrary
Resource            otr_robot_lib/robot/APIKeywords.robot

Suite Setup         Prepare Environment For Testing
Suite Teardown      Remove User If Still Exists

Force Tags          API  DITONLY  PHOENIX  USERSERVICEAPI


*** Variables ***
${requestEndpoint}
${response}


*** Test Cases ***
Validate Card ID Lookup Endpoint Managed Carriers Scope Successful Response
    [Documentation]  Test to validate the POST CardIDLookup endpoint successful response with the managed carriers scope
    [Tags]  JIRA:O5SA-620  Q1:2023  qTEST:120219879
    [Setup]  Test Setup  managed_carriers
    Send Request  200
    Verify Response  200

Validate Card ID Lookup Endpoint Carrier Family Scope Successful Response
    [Documentation]  Test to validate the POST CardIDLookup endpoint successful response with the carrier family scope
    [Tags]  JIRA:O5SA-620  Q1:2023  qTEST:120219905
    [Setup]  Test Setup  carrier_family
    Send Request  200
    Verify Response  200

Validate Card ID Lookup Endpoint Managed Carriers Scope Error Response 401
    [Documentation]  Test to validate the POST CardIDLookup endpoint error response with the managed carriers scope
    ...  When authentication is required and no token is supplied, or the supplied token is invalid
    [Tags]  JIRA:O5SA-620  Q1:2023  qTEST:120219903
    [Setup]  Test Setup  managed_carriers
    Send Request  401
    Verify Response  401

Validate Card ID Lookup Endpoint Carrier Family Scope Error Response 401
    [Documentation]  Test to validate the POST CardIDLookup endpoint error response with the family scope
    ...  When authentication is required and no token is supplied, or the supplied token is invalid
    [Tags]  JIRA:O5SA-620  Q1:2023  qTEST:120219906
    [Setup]  Test Setup  carrier_family
    Send Request  401
    Verify Response  401


*** Keywords ***
Test Setup
    [Documentation]  Get data for test
    [Arguments]  ${scope}
    Find Data  ${scope}
    Get Bearer Token  ${scope}
    Getting Redis Data

Prepare Environment For Testing
    [Documentation]  Setup the environment to execute the suite
    log variables
    ${requestEndpoint}  Catenate  ${cardsservice}/card-id-lookups/carriers/
    Set Suite Variable  ${requestEndpoint}
    Getting The Environment Variable

Get Bearer Token
    [Documentation]  Gets the token for testing the endpoints
    [Arguments]  ${scope}
    Set Test Variable  ${mypersona}  ${scope}
    ${tokenEndpoint}  Catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token
    ${val}  Get Variable Value  ${bearerToken${scope}}
    IF  '${scope}'=='managed_carriers' and '${val}'=='${none}'
        ${data}  Create Dictionary
        ...  grant_type=client_credentials
        ...  client_id=${OTR_Managed_Carriers_ClientID}
        ...  client_secret=${OTR_Managed_Carriers_Secret}
        ...  scope=otr-service
        ${response}  RequestsLibrary.POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}
        Should Be Equal As Strings  ${response.reason}  OK
        Dictionary Should Contain Key  ${response.json()}  access_token

        ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
        Set Suite Variable  ${bearerToken${scope}}  ${bearertoken}
    ELSE IF  '${scope}'=='carrier_family' and '${val}'=='${none}'
        ${data}  Create Dictionary
        ...  grant_type=client_credentials
        ...  client_id=${OTR_Carrier_Family_ClientID}
        ...  client_secret=${OTR_Carrier_Family_Secret}
        ...  scope=otr-service
        ${response}  RequestsLibrary.POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}
        Should Be Equal As Strings  ${response.reason}  OK
        Dictionary Should Contain Key  ${response.json()}  access_token

        ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
        Set Suite Variable  ${bearerToken${scope}}  ${bearertoken}
    END

Find Data
    [Documentation]  Finds Carrier ID, Card ID, and Card Num
    [Arguments]  ${scope}
    ${val1}  Get Variable Value  ${mc_data}
    ${val2}  Get Variable Value  ${cf_data}
    IF  '${scope}'=='managed_carriers' and '''${val1}'''=='''${NONE}'''
        Get Into DB  postgrespgusers
        ${query}  Catenate
        ...  select carrier_id from api_client_carrier acc
        ...  where acc.carrier_id ~ '^[0-9]' and api_client_id='0oa7avhjplAS6lOzz1d7' limit 200
        ${results}  Query And Strip To List  ${query}
        ${results}  Create List For Query From List  ${results}
        Disconnect From Database

        Get Into DB  TCH
        ${query}  Catenate  select card_id, carrier_id, trim(card_num) as card_num
        ...  from cards
        ...  where card_num not like '%OVER%' and carrier_id in (${results}) and expiredate > TODAY limit 200
        ${results}  Query To Dictionaries  ${query}
        ${results}  Evaluate  random.choice(${results})
        Set Suite Variable  ${mc_data}  ${results}
    ELSE IF  '${scope}'=='carrier_family' and '''${val2}'''=='''${NONE}'''
        Get Into DB  postgrespgcarrierservices
        ${query}  Catenate  select carrier_id from carrier_family_carrier_xref
        ...  where carrier_family_natural_id in ('TCS', 'RYDER', 'O5SA-620TEST') limit 200
        ${results}  Query And Strip To List  ${query}
        ${results}  Create List For Query From List  ${results}

        Disconnect From Database
        Get Into DB  TCH
        ${query}  Catenate  select card_id, carrier_id, trim(card_num) as card_num
        ...  from cards
        ...  where card_num not like '%OVER%' and carrier_id in (${results}) limit 200
        ${results}  Query To Dictionaries  ${query}
        ${results}  Evaluate  random.choice(${results})
        Set Suite Variable  ${cf_data}  ${results}
    END

Getting The Environment Variable
    [Documentation]  get enviroment information

    ${envi}  Split String  ${ENVIRONMENT}  -
    Set Suite Variable  ${envi}

Card Id String
    [Documentation]  Converts card id to string
    IF  '${mypersona}'=='managed_carriers'
        ${String}  Convert To String  card:${mc_data}[card_id]
    ELSE IF  '${mypersona}'=='carrier_family'
        ${String}  Convert To String  card:${cf_data}[card_id]
    END
    Set Test Variable  ${String}

Getting Redis Data
    [Documentation]  get information from Redis Cache
    [Arguments]  ${env}=${envi}[1]

    Card Id String

    ${redis_conn}  Connect To Redis  redisproxy-${env}-common-data.m0hmzv.ng.0001.usw2.cache.amazonaws.com  6379

    ${redis_data1}  Get From Redis Hash  ${redis_conn}  ${String}  card_id
    ${redis_data2}  Get From Redis Hash  ${redis_conn}  ${String}  carrier_id
    ${redis_data3}  Get From Redis Hash  ${redis_conn}  ${String}  card_last_4

    ${redis_data1}  Evaluate  $redis_data1.decode('utf-8')
    ${redis_data2}  Evaluate  $redis_data2.decode('utf-8')
    ${redis_data3}  Evaluate  $redis_data3.decode('utf-8')
    Set Test Variable  ${redis_data1}
    Set Test Variable  ${redis_data2}
    Set Test Variable  ${redis_data3}

Verify Response
    [Documentation]  Compares response body with redis if applicable
    [Arguments]  ${status}
    IF  '${status}' == '200'
        Should Be Equal As Strings  ${statuscode}  200
        Should Be Equal As Strings  ${responsebody}[name]  OK
        Should Be Equal As Strings  ${responsebody}[message]  SUCCESSFUL
        Should Be Equal As Strings  ${responsebody}[details][type]  CardIDLookupResults
        Should Be Equal As Strings  ${responsebody}[details][data][results][0][card_id]  ${redis_data1}
        Should Contain  ${responsebody}[details][data][results][0][masked_card_number]  ${redis_data3.__str__()}
        Should Contain  ${responsebody}[details][data][results][0][masked_card_number]  *
    ELSE IF  '${status}' == '401'
        Should Be Equal As Strings  ${statuscode}  401
    END

Send Request
    [Documentation]  Sends request to endpoint
    [Arguments]  ${statuscode}
    IF  '${statuscode}'=='200' and '${mypersona}'=='managed_carriers'
        ${payload}  Create Dictionary  card_number=${mc_data}[card_num]
        ${payload}  Create List  ${payload}
        ${payload}  Create Dictionary  data=${payload}
        ${payload}  Evaluate  json.dumps(${payload})
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken${mypersona}}
        ${response}  Requestslibrary.Post
        ...  ${requestEndpoint}${mc_data}[carrier_id]
        ...  data=${payload}
        ...  headers=${headers}
        Set Test Variable  ${statuscode}  ${response.status_code}
        Set Test Variable  ${responsebody}  ${response.json()}
    ELSE IF  '${statuscode}'=='200' and '${mypersona}'=='carrier_family'
        ${payload}  Create Dictionary  card_number=${cf_data}[card_num]
        ${payload}  Create List  ${payload}
        ${payload}  Create Dictionary  data=${payload}
        ${payload}  Evaluate  json.dumps(${payload})
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken${mypersona}}
        ${response}  Requestslibrary.Post
        ...  ${requestEndpoint}${cf_data}[carrier_id]
        ...  data=${payload}
        ...  headers=${headers}
        Set Test Variable  ${statuscode}  ${response.status_code}
        Set Test Variable  ${responsebody}  ${response.json()}
    ELSE IF  '${statuscode}'=='401' and '${mypersona}'=='managed_carriers'
        ${payload}  Create Dictionary  card_number=${mc_data}[card_num]
        ${payload}  Create List  ${payload}
        ${payload}  Create Dictionary  data=${payload}
        ${payload}  Evaluate  json.dumps(${payload})
        ${invalidtoken}  Catenate  ${bearerToken${mypersona}}a
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${invalidtoken}
        ${response}  Requestslibrary.Post
        ...  ${requestEndpoint}${mc_data}[carrier_id]
        ...  data=${payload}
        ...  expected_status=401
        ...  headers=${headers}
        Set Test Variable  ${statuscode}  ${response.status_code}
    ELSE IF  '${statuscode}'=='401' and '${mypersona}'=='carrier_family'
        ${payload}  Create Dictionary  card_number=${cf_data}[card_num]
        ${payload}  Create List  ${payload}
        ${payload}  Create Dictionary  data=${payload}
        ${payload}  Evaluate  json.dumps(${payload})
        ${invalidtoken}  Catenate  ${bearerToken${mypersona}}a
        ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${invalidtoken}
        ${response}  Requestslibrary.Post
        ...  ${requestEndpoint}${cf_data}[carrier_id]
        ...  data=${payload}
        ...  expected_status=401
        ...  headers=${headers}
        Set Test Variable  ${statuscode}  ${response.status_code}
    ELSE
        TCH Logging  other case
    END
    [Return]  ${response}
