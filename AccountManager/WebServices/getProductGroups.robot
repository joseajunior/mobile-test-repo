*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***

Validate Product Groups Informations
    [Tags]  JIRA:BOT-1583  qTest:30842178  Regression
    [Documentation]  Validate all informations returned from getProductGroups
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${productGroups}  getProductGroups
    Check Product Groups  ${productGroups}
    [Teardown]  Logout

*** Keywords ***
Check Product Groups
    [Arguments]  ${productGroups}
    Get Into DB  tch

    ${query}  Catenate
    ...  SELECT TRIM(description) AS description,
    ...  TRIM(group_id) AS groupId,
    ...  num AS groupNumber,
    ...  TRIM(DECODE(is_fuel,'Y','true','false')) AS isFuel
    ...  FROM groups;

    ${results}  Query To Dictionaries  ${query}

    ${dict_match}  compare list dictionaries as strings  ${results}  ${productGroups}
    should be true  ${dict_match}