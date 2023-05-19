*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Test Cases ***
Create a Location Group
    [Tags]  JIRA:BOT-1631  qTest:30775149  Regression
    [Documentation]  Make sure you can create a new location group for the customer

    ${name}  Generate Random String  4  [NUMBERS]
    Set Test Variable  ${LocGrpName}  TESTING_WS_${name}

    ${WS_INFO}  createLocGrp  ${LocGrpName}  1
    ${DB_INFO}  Get Location Group Info  ${LocGrpName}

    Should Be Equal As Numbers   ${WS_INFO}  ${DB_INFO}

Create a Location Group With EMPTY Parameters
    [Tags]  JIRA:BOT-1631  qTest:30775182  Regression
    [Documentation]  Make sure you can create a new location group with EMPTY parameters for the customer

    Set Test Variable  ${LocGrpName}  ${EMPTY}

    ${WS_INFO}  createLocGrp  ${EMPTY}  ${EMPTY}
    ${DB_INFO}  Get Location Group Info  ${LocGrpName}

   Should Be Equal As Numbers   ${WS_INFO}  ${DB_INFO}

Create a Location Group With Special Character
    [Tags]  JIRA:BOT-1631  qTest:30775200  Regression
    [Documentation]  Make sure you cannot create a new location group with special characters as
    ...     ruleBased parameter for the customer but you can create as a name parameter
    Set Test Variable   ${LocGrpName}  AyePapa!!!

    ${status}  Run Keyword And Return Status  createLocGrp  RandomSmth  !@#$
    Should Not Be True  ${status}

    ${WS_INFO}  createLocGrp  AyePapa!!!  1
    ${DB_INFO}  Get Location Group Info  ${LocGrpName}

    Should Be Equal As Numbers   ${WS_INFO}  ${DB_INFO}

Create a Location Group With No Boolean Value For ruleBased
    [Tags]  JIRA:BOT-1631  qTest:30775217  Regression
    [Documentation]  Make sure you can create a new location group with special characters as ruleBased parameter for the customer

    ${status}  Run Keyword And Return Status  createLocGrp  RandomSmth  3
    Should Not Be True  ${status}


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Get Location Group Info
    [Arguments]  ${name}

    ${query}  catenate
    ...     SELECT grp_id
    ...     FROM loc_grp
    ...     WHERE name='${LocGrpName}'
    ...     ORDER BY grp_id DESC LIMIT 1
    ${results}  Query And Strip  ${query}

    [Return]  ${results}

Tear Me Down
    Disconnect From Database
    Logout