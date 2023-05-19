*** Settings ***
Library     RequestsLibrary
Library     Collections
Resource    otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Setup

Documentation  This is to test the endpoint GET for (GET generateDynamicPinWithPromptByCardNumber)
...            URL: (https://cardsservice.{env}.efsllc.com)
Force Tags  cardServiceAPI  API

*** Variable ***
${bearerToken}
${requestEndpoint}

*** Test Cases ***
########################## Dynamic Pin By Card Number ###############################
#-----------------------------------------------------------------------------------#
#              Endpoint POST:  /otr-cards/generate-dynamic-pin/card-number          #
#-----------------------------------------------------------------------------------#
Get DynamicPinResponse 200
    [Documentation]  Test the successful scenario to GET DynamicPinResponse By CardNumber
    [Tags]   Q1:2023  JIRA:ATLAS-2293  JIRA:ATLAS-2365  JIRA:2409  qTest:119424323
    ${response}  Send Request  200
    Check Response  200  ${response}

Get DynamicPinResponse 400
    [Documentation]  Test the error scenario to GET DynamicPinResponse By CardNumber
    ...  When the request is malformed or any user input is invalid
    [Tags]  Q1:2023  JIRA:ATLAS-2293  qTest:119376145
    ${response}  Send Request  400
    Check Response  400  ${response}

Get DynamicPinResponse 401
    [Documentation]  Test the error scenario to GET DynamicPinResponse By CardNumber
    ...  When authentication is required and no token is supplied, or the supplied token is invalid.
    [Tags]  Q1:2023  JIRA:ATLAS-2295  qTest:119376147
    ${response}  Send Request  401
    Check Response  401  ${response}

Get DynamicPinResponse 422 (carrier_id)
    [Documentation]  Test the error scenario to GET DynamicPinResponse By CardNumber
    ...  When the input does not pass validation and is unprocessable.
    [Tags]  Q1:2023  JIRA:ATLAS-2293  qTest:119376148
    ${response}  Send Request  422-1
    Check Response  422-1  ${response}

Get DynamicPinResponse 422 (card_number)
    [Documentation]  Test the error scenario to GET DynamicPinResponse By CardNumber
    ...  When the input does not pass validation and is unprocessable.
    [Tags]   Q1:2023  JIRA:ATLAS-2293  qTest:119376149
    ${response}  Send Request  422-2
    Check Response  422-2  ${response}

*** Keywords ***
Setup
    Get Bearer Token
    ${requestEndpoint}  catenate  ${cardsservice}/otr-cards/generate-dynamic-pin/card-number
    Set Suite Variable  ${requestEndpoint}
    Get Carrier ID and Card Number

Get Bearer Token
    [Documentation]   Gets the token for Ryder for testing the endpoints at DIT
    ${tokenEndpoint}  catenate  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token

    ${data}  Create dictionary  grant_type=client_credentials  client_id=${OTR_DynamicPinTest_clientId}  client_secret=${OTR_DynamicPinTest_secret}  scope=otr-service
    ${response}  POST  ${OAuth2API}/oauth2/aus1trn5zoTQ3XSgh1d7/v1/token  data=${data}

    Should Be Equal As Strings  ${response.reason}  OK
    Dictionary Should Contain Key  ${response.json()}  access_token

    ${bearerToken}  Set Variable  Bearer ${response.json()}[access_token]
    Set Suite Variable   ${bearerToken}

Get Carrier ID and Card Number
    ${personasql}  catenate  select carrier_family_list from persona_client_family_xref where persona_id = 'DynamicPinTest'
    ${personresults}  Query And Strip    ${personasql}  db_instance=postgrespgcarrierservices
    ${personresultslist}  Create List for query  ${personresults}
    ${carriersql}  Catenate    select carrier_id from carrier_family_carrier_xref where carrier_family_natural_id in ${personresultslist}
    ${carriers}  Query And Strip to list    ${carriersql}  db_instance=postgrespgcarrierservices
    ${carrierlist}  Create List for query  ${carriers}
    Get Into DB    TCH
    ${query}    Catenate
    ...    SELECT c.carrier_id,
    ...           TRIM(c.card_num) AS card_num,
    ...           ci.info_id AS card_info_id,
    ...           c.card_id
    ...    FROM cards c, card_inf ci, card_pins cp
    ...    WHERE c.card_num = ci.card_num
    ...    AND   c.card_num = cp.card_num
    ...    AND   c.dynamic_pin_flag = 'Y'
    ...    AND   ci.info_validation = 'D'
    ...    AND   cp.passcode IS NOT NULL
    ...    AND   c.carrier_id IN ${carrierlist}
    ...    AND   LENGTH(c.card_num) = 19
    ...    ORDER BY c.lastupdated
    ...    LIMIT 1;
    ${result}    Query And Strip To Dictionary    ${query}
    ${carrier.id}    convert to string    ${result["carrier_id"]}
    Set Suite Variable    ${carrier.id}
    Set Suite Variable    ${carrier.cardnum}    ${result["card_num"]}
    Set Suite Variable    ${carrier.cardid}    ${result["card_id"]}
    ${cardStart}    Get Substring    ${carrier.cardnum}    0    6
    ${cardEnd}    Get Substring    ${carrier.cardnum}    15
    ${maskedCard}    Catenate    ${cardStart}*********${cardEnd}
    Set Suite Variable    ${maskedCard}

POST Request By Card Number
    [Documentation]  Makes a post request to the endpoint
    [Arguments]  ${data}  ${headers}
    [Return]  ${response}
    ${response}  POST  ${requestEndpoint}  json=${data}  headers=${headers}  expected_status=anything

Send Request
    [Documentation]    Hardcoded values since they must be part of family
    [Arguments]  ${val}
    [Return]  ${response}
    IF  ${val} == 200
      ${data}  Create dictionary  carrier_id=${carrier.id}  card_number=${carrier.cardnum}
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END
    IF  ${val} == 400
      ${data}  Create dictionary  carrier_id=${carrier.id}  card_number=${carrier.cardnum} test=test
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END
    IF  ${val} == 401
      ${data}  Create dictionary  carrier_id=${carrier.id}  card_number=${carrier.cardnum}
      ${headers}  Create Dictionary  Content-Type=application/json
    END
    IF  ${val} == 422-1
      ${data}  Create dictionary  carrier_id=0000  card_number=${carrier.cardnum}
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END
    IF  ${val} == 422-2
      ${data}  Create dictionary  carrier_id=${carrier.id}  card_number=0000000000000000000
      ${headers}  Create Dictionary  Content-Type=application/json  Authorization=${bearerToken}
    END

    ${response}  POST Request By Card Number  ${data}  ${headers}

Check Response
    [Arguments]  ${code}  ${response}
    IF  ${code} == 200
      Should Be Equal As Strings  ${response}  <Response [200]>
      Should Be Equal As Strings  ${response.json()}[name]  OK
      Should Be Equal As Strings  ${response.json()}[message]  SUCCESSFUL
      Should Be Equal As Strings  ${response.json()}[details][type]  DynamicPinResponse
      Should Be Equal As Strings  ${response.json()}[details][data][card_number]  ${maskedCard}
      Should Be Equal As Strings  ${response.json()}[details][data][carrier_id]  ${carrier.id}
      Should Be Equal As Strings  ${response.json()}[details][data][card_id]  ${carrier.cardid}
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

Create List for query
    [Arguments]  ${qlist}
    ${qlist}=  evaluate  str(${qlist})[2:-2]
    ${qlist}  Catenate    ('${qlist}')
    [Return]  ${qlist}

