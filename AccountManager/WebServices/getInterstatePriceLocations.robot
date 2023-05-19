*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${card}  7083050910386613762
${interstate}  I-75
${state}  GA

*** Test Cases ***

Valid Parameters For All Fields with taxFlag=0
    [Documentation]  Insert all parameters, taxFlag=0 and expect a positive response.
    [Tags]  JIRA:BOT-1598  qTest:31064398  Regression  refactor
    ${return}  getInterstatePriceLocations  ${card}  ${interstate}  ${state}  0
    Should Not Be Empty  ${return}

Valid Parameters For All Fields with taxFlag=1
    [Documentation]  Insert all parameters, taxFlag=1 and expect a positive response.
    [Tags]  JIRA:BOT-1598  qTest:31064399  Regression  refactor
    ${return}  getInterstatePriceLocations  ${card}  ${interstate}  ${state}  1
    Should Not Be Empty  ${return}

Invalid Card Number
    [Documentation]  Insert Invalid Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064400  Regression
    ${return}  getInterstatePriceLocations  1nv@l1d_c4rd  ${interstate}  ${state}
    Should Be Empty  ${return}

Typo Card Number
    [Documentation]  Insert Typo Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064401  Regression
    ${return}  getInterstatePriceLocations  ${card}f  ${interstate}  ${state}
    Should Be Empty  ${return}

Empty Card Number
    [Documentation]  Insert an Empty Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064402  Regression
    ${return}  getInterstatePriceLocations  ${empty}  ${interstate}  ${state}
    Should Be Empty  ${return}

Invalid Interstate
    [Documentation]  Insert Invalid Interstate parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064403  Regression
    ${return}  getInterstatePriceLocations  ${card}  1nv@l1d   ${state}
    Should Be Empty  ${return}

Typo Interstate
    [Documentation]  Insert Typo Interstate parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064404  Regression
    ${return}  getInterstatePriceLocations  ${card}  ${interstate}f  ${state}
    Should Be Empty  ${return}

Empty Interstate
    [Documentation]  Insert an Empty Interstate parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064405  Regression  refactor
    ${return}  getInterstatePriceLocations  ${card}  ${empty}  ${state}
    Should Not Be Empty  ${return}

Invalid State
    [Documentation]  Insert Invalid State parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064406  Regression
    ${return}  getInterstatePriceLocations  ${card}  ${interstate}  1nv@l1d
    Should Be Empty  ${return}

Typo State
    [Documentation]  Insert Typo State parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064407  Regression
    ${return}  getInterstatePriceLocations  ${card}  ${interstate}  ZZ
    Should Be Empty  ${return}

Empty State
    [Documentation]  Insert an Empty State parameter and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064408  Regression  refactor
    ${return}  getInterstatePriceLocations  ${card}  ${interstate}  ${empty}
    Should Not Be Empty  ${return}

Invalid taxFlag
    [Documentation]  Insert Invalid taxFlag and expect an error.
    [Tags]  JIRA:BOT-1598  qTest:31064409  Regression
    Run Keyword And Expect Error  *  getInterstatePriceLocations  ${card}  ${interstate}  ${state}  A


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout
