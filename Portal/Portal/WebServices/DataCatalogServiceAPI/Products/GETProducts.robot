*** Settings ***
Library  String
Library  Collections
Library  RedisLibrary
Library  RequestsLibrary

Documentation  Tests the GETProductLists endpoint in the OTR Data Catalog Service
Force Tags     ditOnly  DataCatalog  API  OTR-Products

*** Variables ***

*** Test Cases ***

(OTR-DataCatalog) GET Products
    [Documentation]  Test Perform Get Products
    [Tags]           PI:15  Q2:2023  JIRA:O5SA-410  qTest:117204101
    Generate Internal service token
    GET Products Request
    Getting the environment variable
    Getting Redis Data
    Validate Products Response

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

GET Products Request
    [Documentation]  Make request to the endpoint GET Products List
    ${endpoint}  catenate   ${DataCatalog}/data-catalogs/products
    ${headers}   Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    ${response}  RequestsLibrary.GET  ${endpoint}  json=${data}  headers=${headers}  expected_status=anything

    Should Be Equal As Strings  ${response}  <Response [200]>
    Set Test Variable  ${response_json}  ${response.json()}

Getting the environment variable
   [Documentation]  get enviroment information
    ${envi}     Split String     ${ENVIRONMENT}  -
    Set Test Variable    ${envi}

Getting Redis Data
   [Documentation]  get information from Redis Cache
   [Arguments]      ${env}=${envi}[1]

    ${redis_conn}  Connect To Redis     auth-${env}-common-data.m0hmzv.ng.0001.usw2.cache.amazonaws.com     6379
    ${redis_data}  Get From Redis Hash  ${redis_conn}	    products:TCH        68
    ${redis_data}  Evaluate  json.loads($redis_data.decode('utf-8'))

    Set Test Variable    ${redis_data}

Validate Products Response
    [Documentation]  Validate the status code and response body of Product list return

    Should Be Equal     ${response_json}[details][data][0][product_number]       ${redis_data}[product_number]
    Should Be Equal     ${response_json}[details][data][0][product_description]  ${redis_data}[product_description]
    Should Be Equal     ${response_json}[details][data][0][product_id]           ${redis_data}[product_id]
    Should Be Equal     ${response_json}[details][data][0][fuel_type]            ${redis_data}[fuel_type]
    Should Be Equal     ${response_json}[details][data][0][fuel_type_use]        ${redis_data}[fuel_type_use]
    Should Be Equal     ${response_json}[details][data][0][group_id]             ${redis_data}[group_id]
    Should Be Equal     ${response_json}[details][data][0][group_number]         ${redis_data}[group_number]
    Should Be Equal     ${response_json}[details][data][0][is_fuel]              ${redis_data}[is_fuel]
    Should Be Equal     ${response_json}[details][data][0][phrase_id]            ${redis_data}[phrase_id]
    Should Be Equal     ${response_json}[details][data][0][tax_group]            ${redis_data}[tax_group]

    Should Contain      ${response_json}     links       rel

    Should Be Equal As Strings   ${response_json}[page][number]  0
    Should Be Equal As Strings   ${response_json}[page][size]    10
    Should Contain      ${response_json}     page       totalElements
    Should Contain      ${response_json}     page       totalPages