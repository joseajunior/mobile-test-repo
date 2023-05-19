*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS
*** Test Cases ***
Get Current Payroll Cash Amounts From a List of Valid Cards
    [Tags]  JIRA:BOT-1570  qTest:30918575  Regression  refactor
    [Documentation]  Make sure you can fetch information from getCurrentPayrollCashAmounts ws request
    [Setup]  Ensure Card is a Payroll Card

    ${WS_INFO}  getCurrentPayrollCashAmounts  ${validCard.card_num}  ${card_1}

    ${first_card_balance}  Get Current Payroll Cash Amounts On DB  ${validCard.card_num}
    ${second_card_balance}  Get Current Payroll Cash Amounts On DB  ${card_1}

    Should Be Equal As Numbers  ${WS_INFO[0]}  ${first_card_balance}
    Should Be Equal As Numbers  ${WS_INFO[1]}  ${second_card_balance}

Get Current Payroll Cash Amounts Using an Empty Card Number As Parameter
    [Tags]  JIRA:BOT-1570  qTest:30918892  Regression
    [Documentation]  Make sure you can't fetch information from getCurrentPayrollCashAmounts ws request
    ...     when you have empty card numbers as parameters
    [Setup]  Ensure Card is a Payroll Card

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  ${EMPTY}  ${validCard.card_num}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  5567480040600320  ${EMPTY}
    Should Not Be True  ${status}

Get Current Payroll Cash Amounts Using a Card Number with Space
    [Tags]  JIRA:BOT-1570  qTest:30919296  Regression
    [Documentation]  Make sure you can't fetch information from getCurrentPayrollCashAmounts ws request
    ...     when you have card numbers with spaces
    [Setup]  Ensure Card is a Payroll Card

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  556748${SPACE}  ${validCard.card_num}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  5567480040600320  70830509${SPACE}386614158
    Should Not Be True  ${status}

Get Current Payroll Cash Amounts Using an Invalid
    [Tags]  JIRA:BOT-1570  qTest:30919360  Regression
    [Documentation]  Make sure you can't fetch information from getCurrentPayrollCashAmounts ws request
    ...      when you have invalid card numbers
    [Setup]  Ensure Card is a Payroll Card

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  556748A1nv@l140040600320  ${validCard.card_num}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  5567480040600320  70830509A1nv@l14386614158
    Should Not Be True  ${status}

Get Current Payroll Cash Amounts With Typo on the Card Numbers
    [Tags]  JIRA:BOT-1570  qTest:30919414  Regression
    [Documentation]  Make sure you can't fetch information from getCurrentPayrollCashAmounts ws request
    ...     when you have typo on the card numbers
    [Setup]  Ensure Card is a Payroll Card

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  556748AAA0040600320  ${validCard.card_num}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getCurrentPayrollCashAmounts  5567480040600320  70830509ABC10386614158
    Should Not Be True  ${status}


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Ensure Card is a Payroll Card
    Set Test Variable  ${card_1}  5567480040600320
    Start Setup Card  ${validCard.card_num}
    Setup Card Header  payrollUse=B
    Start Setup Card  ${card_1}
    Setup Card Header  payrollUse=B

Get Current Payroll Cash Amounts On DB
    [Arguments]  ${card}

    ${query}  catenate
    ...     SELECT DECODE(TO_CHAR(balance), NULL, '0.0', TO_CHAR(balance)) AS balance
    ...     FROM payr_cash_adv
    ...     WHERE card_num ='${card}'
    ...     ORDER BY when DESC limit 1
    ${result}  Query And Strip  ${query}
    [Return]  ${result}