*** Settings ***
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Variables ***
${validAccountNumber}    44778833
${carrier}  141526

*** Test Cases ***
Creating a SmartPay Transfer Account
    [Tags]  JIRA:BOT-1627  qTest:31780580  Regression  refactor
    [Documentation]  Validate that you can create SmartPay Transfer Account

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

    Should Be True  ${status}

    Deleting the last SmartPay Transfer Account created  ${cardNumber}

Check if the transferAccountId has been returned after creation
    [Tags]  JIRA:BOT-1627  qTest:31780613  Regression  BUGGED:It was supposed to return the transferAccountId
    [Documentation]  Validate that you can get the transferAccountId as response

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  TestBank

    ${transferAccountId}  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

    ${SmartPayTransfers}  getSmartPayTransferAccounts  ${cardNumber}
    ${accountId}  set variable  ${SmartPayTransfers[0]['transferAccountId']}

    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    should be equal as strings  ${transferAccountId}  ${accountId}

Check duplicate routingNumber
    [Tags]  JIRA:BOT-1627  qTest:31780790  Regression  BUGGED:It is not supposed to accept duplicate routingNumber
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a duplicate routingNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  TestBank

    ${createStatus}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${createStatus}

Check duplicate accountNumber
    [Tags]  JIRA:BOT-1627  qTest:31780796  Regression  BUGGED:It is not supposed to accept duplicate accountNumber
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a duplicate accountNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  324377516
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Create SmartPay Transfer Account With CardNumber from different carrier
    [Tags]  JIRA:BOT-1627  qTest:31780805  Regression
    [Documentation]  Validate that you cannot create SmartPay Transfer Account using CardNumber from different carrier

    ${cardNumber}  set variable  5567488820200369
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  TestBank

    run keyword and expect error  *  run keyword and continue on failure  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

Check INVALID on the cardNumber
    [Tags]  JIRA:BOT-1627  qTest:31780829  Regression  BUGGED:It is not supposed to accept INVALID data on the cardNumber
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a INVALID data on cardNumber

    ${cardNumber}  set variable  1nv@l!d
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  JustTest Bank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}


    Should Not Be True  ${status}

Check INVALID on the routingNumber
    [Tags]  JIRA:BOT-1627  qTest:31780842  Regression  BUGGED:It is supposed to return false but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a INVALID data on routingNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  1nv@l!d
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Check INVALID on the accountNumber
    [Tags]  JIRA:BOT-1627  qTest:31780848  Regression  BUGGED:It is supposed to return false but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a INVALID data on accountNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  1nv@l!d
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Check INVALID on the accountType
    [Tags]  JIRA:BOT-1627  qTest:31780856  Regression
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a INVALID data on accountType

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  1nv@l!d
    ${accountNickname}  set variable  JustTest Bank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}


    Should Not Be True  ${status}

Check TYPO on the cardNumber
    [Tags]  JIRA:BOT-1627  qTest:31780859  Regression  BUGGED:It is supposed to accept an TYPO in cardNumber field
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a typo on cardNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  JustTest Bank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}FFF  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

    Should Not Be True  ${status}

Check TYPO on the routingNumber
    [Tags]  JIRA:BOT-1627  qTest:31780863  Regression  BUGGED:It is supposed to return false but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a typo on routingNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  06200TYPO_0080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Check TYPO on the accountType
    [Tags]  JIRA:BOT-1627  qTest:31780869  Regression
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with a typo on accountType

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  JustTest Bank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}FFF  ${accountNickname}


    Should Not Be True  ${status}

Validate EMPTY value on bankName
    [Tags]  JIRA:BOT-1627  qTest:31780893  Regression  BUGGED:It is supposed to return false or an error but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with an EMPTY bankName

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ${EMPTY}
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Validate EMPTY value on routingNumber
    [Tags]  JIRA:BOT-1627  qTest:31780875  Regression  BUGGED:It is supposed to return false or an error but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with an EMPTY routingNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  ${EMPTY}
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Validate EMPTY value on accountNumber
    [Tags]  JIRA:BOT-1627  qTest:31780876  Regression  BUGGED:It is supposed to return false or an error but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with an EMPTY accountNumber

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${EMPTY}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  32
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Validate EMPTY value on accountOwnerName
    [Tags]  JIRA:BOT-1627  qTest:31780872  Regression  BUGGED:It is supposed to return false or an error but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with an EMPTY accountOwnerName

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ${EMPTY}
    ${accountType}  set variable  32
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Validate EMPTY value on accountType
    [Tags]  JIRA:BOT-1627  qTest:31780877  Regression
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with an EMPTY accountType

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  ${EMPTY}
    ${accountNickname}  set variable  JustTest Bank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

    Should Not Be True  ${status}

Validate EMPTY value on accountNickname
    [Tags]  JIRA:BOT-1627  qTest:31780895  Regression  BUGGED:It is supposed to return false or an error but we are getting a successful response.
    [Documentation]  Validate that you cannot create SmartPay Transfer Account with an EMPTY accountNickname

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  TestBank

    ${status}  Run Keyword And Return Status  createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

#the SmartPayTransferAccount it was not supposed to be created, so this delete is just while the bug persists, when it got fixed, this delete can be removed
    Deleting the last SmartPay Transfer Account created  ${cardNumber}

    Should Not Be True  ${status}

Validate createPayTransferAccount Informations
    [Tags]  JIRA:BOT-1627  qTest:31780904  Regression
    [Documentation]  Validate TransLocations Informations

    ${cardNumber}  set variable  7083051014152600035
    ${bankName}  set variable  ElRobotBank
    ${routingNumber}  set variable  062000080
    ${accountNumber}  set variable  ${validAccountNumber}
    ${accountOwnerName}  set variable  ELRobotBanker
    ${accountType}  set variable  22
    ${accountNickname}  set variable  TestBankInfos

    createSmartPayTransferAccount  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

# The webservice method createPayTransferAccount should return the account ID, but it is not happening so get the account ID from database is needed to validate the informations
    get into db  TCH
    ${query}  Catenate
    ...  SELECT ppd_header_id FROM ach_ppd_header WHERE description='${accountNickname}' ORDER BY ppd_header_id DESC limit 1;
    ${results}  Query and Strip to Dictionary  ${query}

    ${accountId}  set variable  ${results["ppd_header_id"]} 

    Check createPayTransferAccount  ${accountId}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}

    Deleting the last SmartPay Transfer Account created  ${cardNumber}

*** Keywords ***
Check createPayTransferAccount
    [Arguments]  ${accountId}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}
    Get Into DB  tch

    ${query}  Catenate
    ...  SELECT TRIM(receiving_dfi_identification) AS routingNumber,
    ...  transaction_code AS accountType,
    ...  TRIM(dfi_account_number) AS accountNumber,
    ...  TRIM(individual_name) AS accountOwnerName,
    ...  TRIM(receiving_bank_name) AS bankName,
    ...  TRIM(description) AS accountNickname
    ...  FROM ach_ppd_header WHERE ppd_header_id='${accountId}';

    ${results}  Query and Strip to Dictionary  ${query}

    Should Be Equal As Strings  ${results["bankname"]}  ${bankName}
    Should Be Equal As Strings  ${results["routingnumber"]}  ${routingNumber}
    Should Be Equal As Strings  ${results["accountnumber"]}  ${accountNumber}
    Should Be Equal As Strings  ${results["accountownername"]}  ${accountOwnerName}
    Should Be Equal As Strings  ${results["accounttype"]}  ${accountType}
    Should Be Equal As Strings  ${results["accountnickname"]}  ${accountNickname}

Deleting the last SmartPay Transfer Account created
    [Arguments]  ${cardNumber}
    ${SmartPayTransfers}  getSmartPayTransferAccounts  ${cardNumber}
    ${accountId}  set variable  ${SmartPayTransfers[0]['transferAccountId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayTransferAccount  ${accountId}

    Should Be True  ${status}

Setup WS
    ${pass}  get carrier password  ${carrier}
    log into card management web services  ${carrier}  ${pass}
    run keyword and ignore error  deleteSmartPayTransferAccount  ${validAccountNumber}

Tear Me Down
    Logout