*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services  refactor

*** Test Cases ***
Getting a Money Code Use
    [Tags]  JIRA:BOT-1569  qTest:31026577  Regression
    [Documentation]  Validate that you can pull up Money Code Use.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}
    Should Be True  ${status}
    [Teardown]  Logout
    
Check INVALID value on the begDate
    [Tags]  JIRA:BOT-1569  qTest:31026633  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using INVALID value in begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  1nv@l1d
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}
    
    Should Not Be True  ${status}

    [Teardown]  Logout

Check INVALID value on the endDate
    [Tags]  JIRA:BOT-1569  qTest:31030917  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using INVALID value in endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  1nv@l1d
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Check INVALID value on the contractId
    [Tags]  JIRA:BOT-1569  qTest:31030953  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using INVALID value in contractId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  1nv@l1d
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  1nv@l1d
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Check INVALID value on the masterContractId
    [Tags]  JIRA:BOT-1569  qTest:31030970  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using INVALID value in masterContractId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  1nv@l1d
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Check INVALID value on the issued
    [Tags]  JIRA:BOT-1569  qTest:31030981  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using INVALID value in issued.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  1nv@l1d

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout


Check TYPO on the begDate
    [Tags]  JIRA:BOT-1569  qTest:31031469  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using a date with a TYPO in begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}F  ${endDate}
    Should Not Be True  ${status}
    [Teardown]  Logout

Check TYPO on the endDate
    [Tags]  JIRA:BOT-1569  qTest:31031483  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using a date with a TYPO in endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}F
    [Teardown]  Logout

Check TYPO on the contractId
    [Tags]  JIRA:BOT-1569  qTest:31031486  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using a date with a TYPO in contractId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}F  ${masterContractId}  ${issued}  ${begDate}  ${endDate}
    [Teardown]  Logout

Check TYPO on the masterContractId
    [Tags]  JIRA:BOT-1569  qTest:31031488  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using a date with a TYPO in masterContractId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}F  ${issued}  ${begDate}  ${endDate}
    [Teardown]  Logout

Check TYPO on the issued
    [Tags]  JIRA:BOT-1569  qTest:31031495  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using a date with a TYPO in issued.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}F  ${begDate}  ${endDate}
    [Teardown]  Logout

Validate EMPTY value on begDate
    [Tags]  JIRA:BOT-1569  qTest:31031497  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using an empty value on begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  ${EMPTY}
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on endDate
    [Tags]  JIRA:BOT-1569  qTest:31031510  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using an empty value on endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  ${EMPTY}
    set test variable  ${issued}  true

    ${status}  Run Keyword And Return Status  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on contractId
    [Tags]  JIRA:BOT-1569  qTest:31031519  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using an empty value on contractId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  ${EMPTY}
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${return}  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}

    should be equal  ${return}  ${None}

    [Teardown]  Logout

Validate EMPTY value on masterContractId
    [Tags]  JIRA:BOT-1569  qTest:31031605  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using an empty value on masterContractId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  ${EMPTY}
    set test variable  ${begDate}  2019-04-09
    set test variable  ${endDate}  2019-04-10
    set test variable  ${issued}  true

    ${return}  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}

    should be equal  ${return}  ${None}

    [Teardown]  Logout

Should not get Money Code Use if endDate was less than begDate
    [Tags]  JIRA:BOT-1569  qTest:31031540  Regression
    [Documentation]  Validate that you cannot pull up Money Code Use using an endDate value less then begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    set test variable  ${contractId}  3035
    set test variable  ${masterContractId}  -1
    set test variable  ${begDate}  2019-04-10
    set test variable  ${endDate}  2019-04-09
    set test variable  ${issued}  true

    ${return}  getMoneyCodeUse  ${contractId}  ${masterContractId}  ${issued}  ${begDate}  ${endDate}

    should be equal  ${return}  ${None}

    [Teardown]  Logout

*** Keywords ***
