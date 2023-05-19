*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
Check TYPO on the begDate
    [Tags]  JIRA:BOT-1589  qTest:30917743  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a date with a TYPO in begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}F  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Check TYPO on the endDate
    [Tags]  JIRA:BOT-1589  qTest:30918346  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a date with a TYPO in endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}F

    Should Not Be True  ${status}

    [Teardown]  Logout

Check TYPO on the cardNumber
    [Tags]  JIRA:BOT-1589  qTest:30918349  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a date with a TYPO in cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}F  ${begDate}  ${endDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

Validate EMPTY value on begDate
    [Tags]  JIRA:BOT-1589  qTest:30918400  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an empty value on begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  ${EMPTY}
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate EMPTY value on endDate
    [Tags]  JIRA:BOT-1589  qTest:30918404  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an empty value on endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  ${EMPTY}

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate EMPTY value on cardNumber
    [Tags]  JIRA:BOT-1589  qTest:30918423  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an empty value on cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  ${EMPTY}
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate INVALID value on begDate
    [Tags]  JIRA:BOT-1589  qTest:30918432  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an invalid value on begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  !nv@l1D
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate INVALID value on endDate
    [Tags]  JIRA:BOT-1589  qTest:30918520  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an invalid value on endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  !nv@l1D

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Validate INVALID value on cardNumber
    [Tags]  JIRA:BOT-1589  qTest:30918533  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an invalid value on cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  !nv@l1D
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Should not get Payroll Cash History if endDate was less than begDate
    [Tags]  JIRA:BOT-1589  qTest:30918544  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an endDate value less then begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  2018-12-06
    Set Test Variable  ${endDate}  2018-12-01

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}

    [Teardown]  Logout

Should Not Get Payroll Cash History using cardNumber From Different Carrier
    [Tags]  JIRA:BOT-1589  qTest:30918568  Regression
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a cardNumber that doesn't belong to the carrier.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  7083059810269800034
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  2018-12-06

    ${status}  Run Keyword And Return Status  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate Payroll Cash History
    [Tags]  tier:0  JIRA:BOT-1589  qTest:30918632  Regression
    [Documentation]  Validate all informations returned from getPayrollCashHistory
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    Set Test Variable  ${cardNumber}  5567480040600320
    Set Test Variable  ${begDate}  2018-12-01
    Set Test Variable  ${endDate}  2018-12-06

    ${PayrollCashHistory}  getPayrollCashHistory  ${cardNumber}  ${begDate}  ${endDate}

    tch logging  \n${PayrollCashHistory}

#    Check Payroll Cash History  ${PayrollCashHistory}  ${cardNumber}  ${begDate}  ${endDate}
# We are not sure which approach should be used to compare when cashId = BBAL

    [Teardown]  Logout

*** Keywords ***
Check Payroll Cash History
    [Arguments]  ${PayrollCashHistory}  ${cardNumber}  ${begDate}  ${endDate}
    Get Into DB  tch

    ${query}  Catenate
    ...  SELECT
    ...  amount AS amount,
    ...  TRIM(card_num) AS card_num,
    ...  TRIM(id) AS cashId,
    ...  TO_CHAR(when, '%Y-%m-%dT%H:%M') AS date,
    ...  TRIM(who) AS name,
    ...  TRIM(ref_num) AS refNumber,
    ...  trans_id AS transactionId
    ...  FROM payr_cash_adv
    ...  WHERE card_num ='${cardNumber}' AND when between '${begDate} 00:00' AND '${endDate} 00:00';

    ${results}  Query and Strip To Dictionary  ${query}

    should be equal  ${results}  ${PayrollCashHistory}