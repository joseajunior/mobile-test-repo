*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
Getting Rejected Transactions
    [Tags]  tier:0  JIRA:BOT-1578  qTest:30808243  Regression
    [Documentation]  Validate that you can pull up getTranRejects
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357

    ${status}  Run Keyword And Return Status  getTranRejects  ${cardNum}  ${invoice}  ${locationId}  ${startDate}  ${endDate}

    Should Be True  ${status}

    [Teardown]  Logout

Check TYPO on the startDate
    [Tags]  JIRA:BOT-1578  qTest:30808342  Regression
    [Documentation]  Validate that you can not pull up getTranRejects with a typo on startDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357

    ${status}  Run Keyword And Return Status  getTranRejects  ${cardNum}  ${invoice}  ${locationId}  ${startDate}AAA  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Check TYPO on the endDate
    [Tags]  JIRA:BOT-1578  qTest:30808376  Regression
    [Documentation]  Validate that you can not pull up getTranRejects with a typo on endDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357

    ${status}  Run Keyword And Return Status  getTranRejects  ${cardNum}  ${invoice}  ${locationId}  ${startDate}  ${endDate}AAA

    Should Not Be True  ${status}

    [Teardown]  Logout

Check TYPO on the cardNum
    [Tags]  JIRA:BOT-1578  qTest:30808394  Regression
    [Documentation]  Validate that you can not pull up getTranRejects with a typo on cardNum
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357
    ${result}  getTranRejects  ${cardNum}AAA  ${invoice}  ${locationId}  ${startDate}  ${endDate}

    should be empty  ${result}

    [Teardown]  Logout

Check TYPO on the invoice
    [Tags]  JIRA:BOT-1578  qTest:30808423  Regression
    [Documentation]  Validate that you can not pull up getTranRejects with a typo on invoice
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357
    ${result}  getTranRejects  ${cardNum}  ${invoice}AAA  ${locationId}  ${startDate}  ${endDate}

    should be empty  ${result}

    [Teardown]  Logout

Check TYPO on the locationId
    [Tags]  JIRA:BOT-1578  qTest:30808436  Regression
    [Documentation]  Validate that you can not pull up getTranRejects with a typo on locationId
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357

    ${status}  Run Keyword And Return Status  getTranRejects  ${cardNum}  ${invoice}  ${locationId}AAA  ${startDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Validate EMPTY value on startDate
    [Tags]  JIRA:BOT-1578  qTest:30808450  Regression
    [Documentation]  Validate that you cannot pull up getTranRejects using an empty startDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}


    Set Test Variable  ${startDate}  ${EMPTY}
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357

    ${status}  Run Keyword And Return Status  getTranRejects  ${cardNum}  ${invoice}  ${locationId}  ${startDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Validate EMPTY value on endDate
    [Tags]  JIRA:BOT-1578  qTest:30808468  Regression
    [Documentation]  Validate that you cannot pull up getTranRejects using an empty endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}


    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  ${EMPTY}
    Set Test Variable  ${cardNum}  7083050910386614158
    Set Test Variable  ${invoice}  1033320
    Set Test Variable  ${locationId}  501357

    ${status}  Run Keyword And Return Status  getTranRejects  ${cardNum}  ${invoice}  ${locationId}  ${startDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Check if cannot pull up getTranRejects using a carNum from different Carrier
    [Tags]  JIRA:BOT-1578  qTest:30808486  Regression
    [Documentation]  Validate that you cannot pull up getTranRejects using an empty endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}


    Set Test Variable  ${startDate}  2019-04-02
    Set Test Variable  ${endDate}  2019-04-04
    Set Test Variable  ${cardNum}  7083050361000607857
    Set Test Variable  ${invoice}  ${EMPTY}
    Set Test Variable  ${locationId}  ${EMPTY}

    ${result}  getTranRejects  ${cardNum}  ${invoice}  ${locationId}  ${startDate}  ${endDate}

    should be empty  ${result}

    [Teardown]  Logout

*** Keywords ***
