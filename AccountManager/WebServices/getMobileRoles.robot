*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Valid Appliction Field
    [Documentation]
    [Tags]  JIRA:BOT-1605  qTest:30918315  Regression
    ${ws_mobile_roles}  getMobileRoles  CARRIER
    Should Not Be Empty  ${ws_mobile_roles}

Empty Appliction Field
    [Documentation]
    [Tags]  JIRA:BOT-1605  qTest:30918317  Regression
    ${ws_mobile_roles}  getMobileRoles  ${EMPTY}
    Should Be Equal  ${ws_mobile_roles}  ${NONE}

Invalid Appliction Field
    [Documentation]
    [Tags]  JIRA:BOT-1605  qTest:30918318  Regression
    ${ws_mobile_roles}  getMobileRoles  inv@l1d_@ppl1c@t10n
    Should Be Equal  ${ws_mobile_roles}  ${NONE}

Typo Appliction Field
    [Documentation]
    [Tags]  JIRA:BOT-1605  qTest:30918316  Regression
    ${ws_mobile_roles}  getMobileRoles  CARRIERf
    Should Be Equal  ${ws_mobile_roles}  ${NONE}


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout