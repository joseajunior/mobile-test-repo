*** Settings ***
Library  String
Library  Collections
Library  RedisLibrary
Library  RequestsLibrary

Documentation  Tests the GET Prompts Lists endpoint in the OTR Data Catalog Service
Force Tags     ditOnly  DataCatalog  API  OTR-Prompts

*** Variables ***

*** Test Cases ***
(OTR-DataCatalog) GET Prompts
    [Documentation]     Test Perform Get Prompts
    [Tags]      Q1:2023  Q2:2023   JIRA:O5SA-413  qTest:119150078
    Generate Internal service token
    GET Prompts Request
    Getting Redis Data
    Validate Prompts Response

*** Keywords ***
Generate Internal service token
    [Documentation]  This endpoint does not do persona and permission validation.
    ...              Therefore, to run it, it is necessary to generate an "Internal service token"
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token
    ${data}  Create dictionary  grant_type=client_credentials   scope=otr-service
    ...      client_id=${OTR_Automation_Service_Oauth2ClientID}  client_secret=${OTR_Automation_Service_Oauth2ClientSecret}

    ${response}  RequestsLibrary.POST   ${tokenEndpoint}  data=${data}
    Should Be Equal As Strings  ${response.reason}  OK

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}
    Set Suite Variable   ${data}

GET Prompts Request
    [Documentation]  Make request to the endpoint GET Products List
    ${endpoint}  catenate   ${DataCatalog}/data-catalogs/prompts
    ${headers}   Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    ${response}  RequestsLibrary.GET  ${endpoint}  json=${data}  headers=${headers}  expected_status=anything

    Should Be Equal As Strings  ${response}  <Response [200]>
    Set Test Variable  ${response_json}  ${response.json()}

Getting Redis Data
    [Documentation]     Get information from Redis Cache
    ${redis_conn}       Connect To Redis        ${RedisConnection}     6379
    ${redis_data}	    Get From Redis Hash     ${redis_conn}	    prompts:TCH        16
    ${redis_data}       Evaluate        json.loads($redis_data.decode('utf-8'))
    Set Test Variable   ${redis_data}

Validate Prompts Response
    [Documentation]     Validate the status code and response body of Prompts list return
    Should Contain      ${response_json}[details][data]\[prompt_code]         prompt_code': '${redis_data}[prompt_code]
    Should Contain      ${response_json}[details][data]\[prompt_description]  prompt_description': '${redis_data}[prompt_description]

    Should Contain      ${response_json}     links       rel
    Should Be Equal As Strings      ${response_json}[page][number]       0
    Should Be Equal As Strings      ${response_json}[page][size]         10
    Should Contain      ${response_json}     page       totalElements
    Should Contain      ${response_json}     page       totalPages