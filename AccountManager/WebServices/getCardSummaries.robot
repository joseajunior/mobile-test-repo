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
${payrUse}

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050446  Regression  refactor
    ${return}  getCardSummaries  NUMBER  ${validCard.card_num}  ${payrUse}
    Should Not Be Empty  ${return}

Search Using Client ID Only
    [Documentation]  Insert only Client ID and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050447  Regression
    ${return}  getCardSummaries
    Should Not Be Empty  ${return}

Search Using Valid XREF
    [Documentation]  Insert Valid XREF parameter and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050448  Regression  refactor
    ${return}  getCardSummaries  XREF  COXREF NAME
    Should Not Be Empty  ${return}

Search Using Valid UNIT
    [Documentation]  Insert Valid UNITparameter and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050449  Regression  refactor
    ${return}  getCardSummaries  UNIT  22801
    Should Not Be Empty  ${return}

Search Using Valid DRIVERID
    [Documentation]  Insert Valid DRIVERID parameter and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050450  Regression  refactor
    ${return}  getCardSummaries  DRIVERID  39101
    Should Not Be Empty  ${return}

Search Using Valid DRIVERNAME
    [Documentation]  Insert Valid DRIVERNAME parameter and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050451  Regression  refactor
    ${return}  getCardSummaries  DRIVERNAME  LAME DUCK
    Should Not Be Empty  ${return}

Search Using Valid POLICY
    [Documentation]  Insert Valid POLICYparameter and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050452  Regression  refactor
    ${return}  getCardSummaries  POLICY  5
    Should Not Be Empty  ${return}

Search Using Valid GPSID
    [Documentation]  Insert Valid GPSID parameter and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050453  Regression  refactor
    ${return}  getCardSummaries  GPSID  5328237
    Should Not Be Empty  ${return}

Search Using Valid VIN
    [Documentation]  Insert Valid VIN parameter and expect a positive response.
    [Tags]  tier:0  JIRA:BOT-1592  qTest:31050454  Regression  refactor
    ${return}  getCardSummaries  VIN  1XP4D49XXCD133454
    Should Not Be Empty  ${return}

Search Using Invalid XREF
    [Documentation]  Insert Invalid XREF parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050455  Regression
    ${return}  getCardSummaries  XREF  1nv@l1d
    Should Be Equal as Strings  ${return}  None

Search Using Invalid UNIT
    [Documentation]  Insert Invalid UNIT parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050456  Regression
    ${return}  getCardSummaries  UNIT  1nv@l1d
    Should Be Equal as Strings  ${return}  None

Search Using Invalid DRIVERID
    [Documentation]  Insert Invalid DRIVERID parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050457  Regression
    ${return}  getCardSummaries  DRIVERID  1nv@l1d
    Should Be Equal as Strings  ${return}  None

Search Using Invalid DRIVERNAME
    [Documentation]  Insert Invalid DRIVERNAME parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050458  Regression
    ${return}  getCardSummaries  DRIVERNAME  1nv@l1d
    Should Be Equal as Strings  ${return}  None

Search Using Invalid POLICY
    [Documentation]  Insert Invalid POLICY parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050459  Regression
    Run Keyword And Expect Error  *  getCardSummaries  POLICY  1nv@l1d

Search Using Invalid GPSID
    [Documentation]  Insert Invalid GPSID parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050460  Regression
    ${return}  getCardSummaries  GPSID  1nv@l1d
    Should Be Equal as Strings  ${return}  None

Search Using Invalid VIN
    [Documentation]  Insert Invalid VIN parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050461  Regression
    ${return}  getCardSummaries  VIN  1nv@l1d
    Should Be Equal as Strings  ${return}  None

Search Using payrUse B
    [Documentation]  Insert payrUse B as parameter and expect a positive response.
    [Tags]  JIRA:BOT-1592  qTest:31050462  Regression  refactor
    ${return}  getCardSummaries  payrUse=B
    Should Not Be Empty  ${return}

Search Using payrUse P
    [Documentation]  Insert payrUse P as parameter and expect a positive response.
    [Tags]  JIRA:BOT-1592  qTest:31050463  Regression  refactor
    ${return}  getCardSummaries  payrUse=P
    Should Not Be Empty  ${return}

Search Using payrUse N
    [Documentation]  Insert payrUse N as parameter and expect a positive response.
    [Tags]  JIRA:BOT-1592  qTest:31050464  Regression
    ${return}  getCardSummaries  payrUse=N
    Should Not Be Empty  ${return}

Search Using Invalid payrUse
    [Documentation]  Insert Invalid payrUse parameter and expect an empty list.
    [Tags]  JIRA:BOT-1592  qTest:31050465  Regression
    ${return}  getCardSummaries  payrUse=1nv@l1d
    Should Be Equal as Strings  ${return}  None

*** Keywords ***
Setup WS
    Get Into DB  TCH
    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Start Setup Card  ${validCard.card_num}
    Setup Card Header  status=ACTIVE

    ${query}  Catenate  SELECT payr_use from cards WHERE card_num='${validCard.card_num}'
    ${payrUse}  Query And Strip  ${query}
    Set Suite Variable  ${payrUse}

Teardown WS
    Disconnect From Database
    Logout
