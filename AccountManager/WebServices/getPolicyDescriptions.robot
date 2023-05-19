*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***

Validate Policy Descriptions
    [Tags]  JIRA:BOT-1574  qTest:30740624  Regression
    [Documentation]  Validate all informations returned from getPolicyDescriptions
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${policydescriptions}  getPolicyDescriptions
    Check Policy Descriptions  ${policydescriptions}  ${validCard.carrier.id}
    [Teardown]  Logout

*** Keywords ***
Check Policy Descriptions
    [Arguments]  ${policydescriptions}  ${UserName}
    Get Into DB  tch
    ${query}  Catenate
    ...  SELECT contract_id AS contractId,
    ...  TRIM(description) AS description,
    ...  ipolicy AS policyNumber
    ...  FROM def_card
    ...  WHERE id='${UserName}'
    ...  AND ipolicy BETWEEN 1 AND 500;

    ${results}  Query To Dictionaries  ${query}

    ${dict_match}  compare_dictionaries_as_strings  ${results[0]}  ${policydescriptions[0]}
    should be true  ${dict_match}