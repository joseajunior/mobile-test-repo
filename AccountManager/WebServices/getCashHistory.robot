*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
Getting a cash history
    [Tags]  tier:0  JIRA:BOT-1582  qTest:30842225  Regression
    [Documentation]  Validate that you can pull up a cash history
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Be True  ${status}

    [Teardown]  Logout


Check INVALID value on the cardNumber
    [Tags]  JIRA:BOT-1582  qTest:31050059  Regression
    [Documentation]  Validate that you cannot pull up a cash history with a INVALID value on cardNumber
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  !nv@l1d
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Check INVALID value on the begDate
    [Tags]  JIRA:BOT-1582  qTest:31050084  Regression
    [Documentation]  Validate that you cannot pull up a cash history with a INVALID value on begDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  !nv@l1d
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Check INVALID value on the endDate
    [Tags]  JIRA:BOT-1582  qTest:31050140  Regression
    [Documentation]  Validate that you cannot pull up a cash history with a INVALID value on endDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  !nv@l1d

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Check TYPO on the cardNumber
    [Tags]  JIRA:BOT-1582  qTest:30842260  Regression
    [Documentation]  Validate that you cannot pull up a cash history with a typo on cardNumber
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}AAA  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Check TYPO on the begDate
    [Tags]  JIRA:BOT-1582  qTest:30842294  Regression
    [Documentation]  Validate that you cannot pull up a cash history with a typo on begDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}AAA  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Check TYPO on the endDate
    [Tags]  JIRA:BOT-1582  qTest:30842295  Regression
    [Documentation]  Validate that you cannot pull up a cash history with a typo on endDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}AAA
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate EMPTY value on cardNumber
    [Tags]  JIRA:BOT-1582  qTest:30842296  Regression
    [Documentation]  Validate that you cannot pull up a getCashHistory using an empty cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  ${EMPTY}
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  2019-04-04

    run keyword and expect error  *  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}

    [Teardown]  Logout

Validate EMPTY value on begDate
    [Tags]  JIRA:BOT-1582  qTest:30842298  Regression
    [Documentation]  Validate that you cannot pull up a getCashHistory using an empty begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  ${EMPTY}
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate EMPTY value on endDate
    [Tags]  JIRA:BOT-1582  qTest:30842300  Regression
    [Documentation]  Validate that you cannot pull up a getCashHistory using an empty endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  ${EMPTY}

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Check if cannot pull up getCashHistory using a carNum from different Carrier
    [Tags]  JIRA:BOT-1582  qTest:30842301  Regression
    [Documentation]  Validate that you cannot pull up getCashHistory using a carNum from different Carrier
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050361000607857
    Set Test Variable  ${begDate}  2019-04-03
    Set Test Variable  ${endDate}  2019-04-04

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Should not Cash History if endDate was less than begDate
    [Tags]  JIRA:BOT-1582  qTest:31050242  Regression
    [Documentation]  Validate that you cannot pull up a cash history with a endDate less than begDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050910386614158
    Set Test Variable  ${begDate}  2019-04-04
    Set Test Variable  ${endDate}  2019-04-03

    ${status}  Run Keyword And Return Status  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate Cash History
    [Tags]  JIRA:BOT-1582  qTest:31080821  Regression  tier:0
    [Documentation]  Validate all informations returned from getCashHistory
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083050361000607857
    Set Test Variable  ${begDate}  2019-01-02
    Set Test Variable  ${endDate}  2019-04-05

    ${CashHistory}  getCashHistory  ${cardNumber}  ${begDate}  ${endDate}

    Check Cash History  ${CashHistory}  ${cardNumber}  ${begDate}  ${endDate}

    [Teardown]  Logout

*** Keywords ***

Check Cash History
    [Arguments]  ${CashHistory}  ${cardNumber}  ${begDate}  ${endDate}
    Get Into DB  tch

    ${query}  Catenate
    ...  SELECT
    ...  amount AS amount,
    ...  card_num as cardNumber,
    ...  TRIM(id) AS cashId,
    ...  TRIM(who) AS name,
    ...  TRIM(ref_num) AS refNumber,
    ...  trans_id AS transactionId
    ...  FROM cash_adv
    ...  WHERE card_num ='${cardNumber}'
    ...  AND when BETWEEN '${begDate} 00:00' AND '${endDate} 00:00';

    ${results}  Query To Dictionaries  ${query}

    compare list dictionaries  ${results}  ${CashHistory}
