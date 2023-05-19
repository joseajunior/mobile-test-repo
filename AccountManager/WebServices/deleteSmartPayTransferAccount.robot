*** Settings ***
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections

Force Tags  Web Services  refactor
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Test Cases ***
Delete a SmartPay Transfer Account
    [Tags]  JIRA:BOT-1901  qTest:31722754  Regression
    [Documentation]  Validate that you can delete a SmartPay Transfer Account

    ${cardNumber}  set variable  ${validCard.num}

    Create a new SmartPay Transfer Account  ${cardNumber}

    ${SmartPayTransfers}  getSmartPayTransferAccounts  ${cardNumber}
    ${accountId}  set variable  ${SmartPayTransfers[0]['transferAccountId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayTransferAccount  ${accountId}

    Should Be True  ${status}

Check INVALID on the accountId
    [Tags]  JIRA:BOT-1901  qTest:31722975  Regression
    [Documentation]  Validate that you cannot delete a SmartPay Transfer Account with a INVALID data on accountId

    ${accountId}  set variable  1nv@l!d

    ${status}  Run Keyword And Return Status  deleteSmartPayTransferAccount  ${accountId}

    Should Not Be True  ${status}

Check TYPO on the accountId
    [Tags]  JIRA:BOT-1901  qTest:31723568  Regression
    [Documentation]  Validate that you cannot delete a SmartPay Transfer Account with a typo on accountId

    ${cardNumber}  set variable  ${validCard.num}

    Create a new SmartPay Transfer Account  ${cardNumber}

    ${SmartPayTransfers}  getSmartPayTransferAccounts  ${cardNumber}
    ${accountId}  set variable  ${SmartPayTransfers[0]['transferAccountId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayTransferAccount  ${accountId}F

    Should Not Be True  ${status}

Validate EMPTY value on accountId
    [Tags]  JIRA:BOT-1901  qTest:31723589  Regression
    [Documentation]  Validate that you cannot delete a SmartPay Transfer Account with an EMPTY accountId

    ${accountId}  set variable  ${EMPTY}

    ${status}  deleteSmartPayTransferAccount  ${accountId}

    should be equal as strings  ${status}  None

Delete a SmartPay Transfer Account already deleted
    [Tags]  JIRA:BOT-1901  qTest:31724022  Regression
    [Documentation]  Validate that you cannot delete a SmartPay Transfer Account already deleted

    ${cardNumber}  set variable  ${validCard.num}

    Create a new SmartPay Transfer Account  ${cardNumber}

    ${SmartPayTransfers}  getSmartPayTransferAccounts  ${cardNumber}
    ${accountId}  set variable  ${SmartPayTransfers[0]['transferAccountId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayTransferAccount  ${accountId}

    Should Be True  ${status}

    ${status}  deleteSmartPayTransferAccount  ${accountId}

    should be equal as strings  ${status}  None

*** Keywords ***
Create a new SmartPay Transfer Account
    [Arguments]  ${cardNumber}

    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  44778833
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  JustTest Bank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

    Should Be True  ${status}

Setup WS
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Logout