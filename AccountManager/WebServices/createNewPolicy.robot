*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Test Teardown  Tear Me Down

*** Test Cases ***

Create A New Valid Policy
    [Tags]  JIRA:BOT-1608  qTest:30783237  Regression  refactor
    [Documentation]  Make sure you can create a new policy for a customer.  Policies group cards together

    ${WS_INFO}  createNewPolicy

    ${query}  catenate
    ...     SELECT ipolicy
    ...     FROM def_card
    ...     WHERE id=${validCard.carrier.id}
    ...     AND  ipolicy='${WS_INFO}'
    ${DB_INFO}  Query And Strip  ${query}

    Should Be Equal As Strings  ${WS_INFO}  ${DB_INFO}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Disconnect From Database
    Logout