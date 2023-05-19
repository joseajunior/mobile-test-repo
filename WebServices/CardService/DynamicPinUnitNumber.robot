*** Settings ***
Library     RequestsLibrary
Library     Collections

Suite Setup  Setup

Documentation  This is to test the endpoint GET for (GET generateDynamicPinWithPromptByUnitNumber)
...            URL: (https://cardsservice.{env}.efsllc.com)
Force Tags  cardServiceAPI  API

*** Variable ***
${bearerToken}
${requestEndpoint}

*** Test Cases ***
########################## Dynamic Pin By Unit Number ###############################
#-----------------------------------------------------------------------------------#
#              Endpoint POST:  /otr-cards/generate-dynamic-pin/unit                 #
#-----------------------------------------------------------------------------------#
Get DynamicPinResponse 200
    [Documentation]  Test the successful scenario to GET DynamicPinResponse By UnitNumber
    [Tags]   Q1:2023  JIRA:ATLAS-2295  JIRA:ATLAS-2365  JIRA:2409  qTest:119426428
    ${response}  Send Request  200
    Check Response  200  ${response}

Get DynamicPinResponse 400
    [Documentation]  Test the error scenario to GET DynamicPinResponse By UnitNumber
    ...  When the request is malformed or any user input is invalid
    [Tags]  Q1:2023  JIRA:ATLAS-2295  qTest:119376145
    ${response}  Send Request  400
    Check Response  400  ${response}

Get DynamicPinResponse 401
    [Documentation]  Test the error scenario to GET DynamicPinResponse By UnitNumber
    ...  When authentication is required and no token is supplied, or the supplied token is invalid.
    [Tags]  Q1:2023  JIRA:ATLAS-2295  qTest:119376147
    ${response}  Send Request  401
    Check Response  401  ${response}

Get DynamicPinResponse 422 (carrier_id)
    [Documentation]  Test the error scenario to GET DynamicPinResponse By UnitNumber
    ...  When the input does not pass validation and is unprocessable.
    [Tags]  Q1:2023  JIRA:ATLAS-2295  qTest:119376148
    ${response}  Send Request  422-1
    Check Response  422-1  ${response}

Get DynamicPinResponse 422 (card_number)
    [Documentation]  Test the error scenario to GET DynamicPinResponse By UnitNumber
    ...  When the input does not pass validation and is unprocessable.
    [Tags]   Q1:2023  JIRA:ATLAS-2295  qTest:119376149
    ${response}  Send Request  422-2
    Check Response  422-2  ${response}

*** Keywords ***
Setup
    Get Bearer Token
    ${requestEndpoint}  catenate  ${cardsservice}/otr-cards/generate-dynamic-pin/unit
    Set Suite Variable  ${requestEndpoint}

Get Bearer Token
    [Documentation]   Gets the token for Ryder for testing the endpoints at DIT
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token

    ${data}  Create dictionary  grant_type=client_credentials  client_id=${OTR_DynamicPinTest_clientId}  client_secret=${OTR_DynamicPinTest_secret}  scope=otr-service
    ${response}  POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}

    Should Be Equal As Strings  ${response.reason}  OK
    Dictionary Should Contain Key  ${response.json()}  access_token

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}

POST Request By Unit Number
    [Documentation]  Makes a post request to the endpoint
    [Arguments]  ${data}  ${headers}
    [Return]  ${response}
    ${response}  POST  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything

Send Request
    [Documentation]    Hardcoded values since they must be part of family
    [Arguments]  ${val}
    [Return]  ${response}
    IF  ${val} == 200
      ${data}  Create dictionary  carrier_id=100004  driver_or_unit_id=7070707
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END
    IF  ${val} == 400
      ${data}  Create dictionary  carrier_id=100004  driver_or_unit_id=131321 test=test
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END
    IF  ${val} == 401
      ${data}  Create dictionary  carrier_id=100004  driver_or_unit_id=131317
      ${headers}  Create Dictionary  Content-Type=application/json
    END
    IF  ${val} == 422-1
      ${data}  Create dictionary  carrier_id=0000  driver_or_unit_id=131317
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END
    IF  ${val} == 422-2
      ${data}  Create dictionary  carrier_id=100004  driver_or_unit_id=000000
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END

    ${response}  POST Request By Unit Number  ${data}  ${headers}

Check Response
    [Arguments]  ${code}  ${response}
    IF  ${code} == 200
      Should Be Equal As Strings  ${response}  <Response [200]>
      Should Be Equal As Strings  ${response.json()}[name]  OK
      Should Be Equal As Strings  ${response.json()}[message]  SUCCESSFUL
      Should Be Equal As Strings  ${response.json()}[details][type]  DynamicPinResponse
      Should Be Equal As Strings  ${response.json()}[details][data][card_number]  708305*********6810
      Should Be Equal As Strings  ${response.json()}[details][data][carrier_id]  100004
      Should Be Equal As Strings  ${response.json()}[details][data][card_id]  1000002057892
      Should Be Equal As Strings  ${response.json()}[details][data][dynamic_prompt][unit]  MINUTES
      Should Be Equal As Strings  ${response.json()}[details][data][dynamic_prompt][time]  30
    END
    IF  ${code} == 400
      Should Be Equal As Strings  ${response}  <Response [400]>
      Should Be Equal As Strings  ${response.json()}[name]  BAD_REQUEST
    END
    IF  ${code} == 401
      Should Be Equal As Strings  ${response}  <Response [401]>
    END
    IF  ${code} == 422-1
      Should Be Equal As Strings  ${response}  <Response [422]>
    END
    IF  ${code} == 422-2
      Should Be Equal As Strings  ${response}  <Response [422]>
    END
