*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Variables ***

${transferAccountId}  6382
${cardNumber}  7083051014152600035
${bankName}  ElRobotBankqqq
${routingNumber}  062000080
${accountNumber}  44778833
${accountOwnerName}  ELRobotBankaaaaa
${accountType}  22
${accountNickname}  JustTest Bank
${effectiveDate}  2019-04-26T17:43:00.000-05:00
${batchHeaderId}  2
${createdBy}  not specified
${verifyDate}  2019-04-26T17:43:00.000-05:00
${verifyAmountOne}  0.0
${verifyAmountTwo}  0.0
${verifyTryCount}  0
${expireDate}  2019-04-26T17:43:00.000-05:00

*** Test Cases ***
Set SmartPay Transfer Account updating bankName
    [Tags]  JIRA:BOT-1876  qTest:32149452
    [Documentation]  Validate that you can set SmartPay Transfer Account updating bankName

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${database_return}  Check updated data  receiving_bank_name  ${transferAccountId}  ${bankName}

    Should be equal   ${database_return}  ${bankName}

Set SmartPay Transfer Account updating routingNumber
    [Tags]  JIRA:BOT-1876  qTest:32149613
    [Documentation]  Validate that you can set SmartPay Transfer Account updating routingNumber

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${database_return}  Check updated data  receiving_dfi_identification  ${transferAccountId}  ${routingNumber}

    Should be equal   ${database_return}  ${routingNumber}

Set SmartPay Transfer Account updating accountNumber
    [Tags]  JIRA:BOT-1876  qTest:32149614
    [Documentation]  Validate that you can set SmartPay Transfer Account updating accountNumber

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${database_return}  Check updated data  dfi_account_number  ${transferAccountId}  ${accountNumber}

    Should be equal   ${database_return}  ${accountNumber}

Set SmartPay Transfer Account updating accountOwnerName
    [Tags]  JIRA:BOT-1876  qTest:32149615
    [Documentation]  Validate that you can set SmartPay Transfer Account updating accountOwnerName

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${database_return}  Check updated data  individual_name  ${transferAccountId}  ${accountOwnerName}

    Should be equal   ${database_return}  ${accountOwnerName}

Set SmartPay Transfer Account updating accountType
    [Tags]  JIRA:BOT-1876  qTest:32149618
    [Documentation]  Validate that you can set SmartPay Transfer Account updating accountType

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${database_return}  Check updated data  transaction_code  ${transferAccountId}  ${accountType}

    Should be equal   ${database_return}  ${accountType}

Set SmartPay Transfer Account updating effectiveDate
    [Tags]  JIRA:BOT-1876  qTest:32149619
    [Documentation]  Validate that you can set SmartPay Transfer Account updating effectiveDate

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${effectiveDate}  Replace String  ${effectiveDate}  T  ${SPACE}
    ${effectiveDate}  Split String  ${effectiveDate}  :00

    ${database_return}  Check updated data  effective_date  ${transferAccountId}  ${effectiveDate[0]}

    ${database_return}  Split String  ${database_return}  :00

    Should be equal   ${database_return[0]}  ${effectiveDate[0]}

Set SmartPay Transfer Account updating createdBy
    [Tags]  JIRA:BOT-1876  qTest:32149621
    [Documentation]  Validate that you can set SmartPay Transfer Account updating createdBy

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${database_return}  Check updated data  created_by  ${transferAccountId}  ${createdBy}

    Should be equal   ${database_return}  ${createdBy}

Set SmartPay Transfer Account updating verifyDate
    [Tags]  JIRA:BOT-1876  qTest:32149623
    [Documentation]  Validate that you can set SmartPay Transfer Account updating verifyDate

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${verifyDate}  Replace String  ${verifyDate}  T  ${SPACE}
    ${verifyDate}  Split String  ${verifyDate}  :00

    ${database_return}  Check updated data  verify_date  ${transferAccountId}  ${verifyDate[0]}

    ${database_return}  Split String  ${database_return}  :00

    Should be equal   ${database_return[0]}  ${verifyDate[0]}

Set SmartPay Transfer Account updating verifyTryCount
    [Tags]  JIRA:BOT-1876  qTest:32149625
    [Documentation]  Validate that you can set SmartPay Transfer Account updating verifyTryCount

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${database_return}  Check updated data  verify_try_count  ${transferAccountId}  ${verifyTryCount}

    Should be equal   ${database_return}  ${verifyTryCount}

Set SmartPay Transfer Account updating expireDate
    [Tags]  JIRA:BOT-1876  qTest:32149628
    [Documentation]  Validate that you can set SmartPay Transfer Account updating expireDate

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Be True  ${status}

    ${expireDate}  Replace String  ${expireDate}  T  ${SPACE}
    ${expireDate}  Split String  ${expireDate}  :00

    ${database_return}  Check updated data  expire_date  ${transferAccountId}  ${expireDate[0]}

    ${database_return}  Split String  ${database_return}  :00

    Should be equal   ${database_return[0]}  ${expireDate[0]}

Check INVALID on the cardNumber
    [Tags]  JIRA:BOT-1876  qTest:32149689  BUGGED: It was not supposed to accept INVALID data on cardNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on cardNumber

    ${cardNumber}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check INVALID on the routingNumber
    [Tags]  JIRA:BOT-1876  qTest:32149695  BUGGED: It was not supposed to accept INVALID data on routingNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on routingNumber

    ${routingNumber}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check INVALID on the accountNumber
    [Tags]  JIRA:BOT-1876  qTest:32149697  BUGGED: It was not supposed to accept INVALID data on accountNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on accountNumber

    ${accountNumber}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check INVALID on the effectiveDate
    [Tags]  JIRA:BOT-1876  qTest:32149698
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on effectiveDate

    ${effectiveDate}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check INVALID on the verifyDate
    [Tags]  JIRA:BOT-1876  qTest:32149699
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on verifyDate

    ${verifyDate}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check INVALID on the verifyAmountOne
    [Tags]  JIRA:BOT-1876  qTest:32149701
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on verifyAmountOne

    ${verifyAmountOne}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Check INVALID on the verifyAmountTwo
    [Tags]  JIRA:BOT-1876  qTest:32149702
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on verifyAmountTwo

    ${verifyAmountTwo}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check INVALID on the verifyTryCount
    [Tags]  JIRA:BOT-1876  qTest:32149704
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on verifyTryCount

    ${verifyTryCount}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check INVALID on the expireDate
    [Tags]  JIRA:BOT-1876  qTest:32149706
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a INVALID data on expireDate

    ${expireDate}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Validate EMPTY value on transferAccountId
    [Tags]  JIRA:BOT-1876  qTest:32149748  BUGGED: It was not supposed to accept EMPTY transferAccountId
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY transferAccountId

    ${transferAccountId}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Validate EMPTY value on cardNumber
    [Tags]  JIRA:BOT-1876  qTest:32149762  BUGGED: It was not supposed to accept EMPTY cardNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY cardNumber

    ${cardNumber}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on bankName
    [Tags]  JIRA:BOT-1876  qTest:32149763  BUGGED: It was not supposed to accept EMPTY bankName
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY bankName

    ${bankName}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on routingNumber
    [Tags]  JIRA:BOT-1876  qTest:32149764  BUGGED: It was not supposed to accept EMPTY routingNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY routingNumber

    ${routingNumber}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on accountNumber
    [Tags]  JIRA:BOT-1876  qTest:32149766  BUGGED: It was not supposed to accept EMPTY accountNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY accountNumber

    ${accountNumber}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on accountOwnerName
    [Tags]  JIRA:BOT-1876  qTest:32149767  BUGGED: It was not supposed to accept EMPTY accountOwnerName
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY accountOwnerName

    ${accountOwnerName}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on accountType
    [Tags]  JIRA:BOT-1876  qTest:32149768
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY accountType

    ${accountType}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Validate EMPTY value on accountNickname
    [Tags]  JIRA:BOT-1876  qTest:32149776  BUGGED: It was not supposed to accept EMPTY accountNickname
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY accountNickname

    ${accountNickname}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Validate EMPTY value on effectiveDate
    [Tags]  JIRA:BOT-1876  qTest:32149777
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY effectiveDate

    ${effectiveDate}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on batchHeaderId
    [Tags]  JIRA:BOT-1876  qTest:32149778
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY batchHeaderId

    ${batchHeaderId}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on createdBy
    [Tags]  JIRA:BOT-1876  qTest:32149803  BUGGED: It was not supposed to accept EMPTY createdBy
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY createdBy

    ${createdBy}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on verifyAmountOne
    [Tags]  JIRA:BOT-1876  qTest:32149804
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY verifyAmountOne

    ${verifyAmountOne}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on verifyAmountTwo
    [Tags]  JIRA:BOT-1876  qTest:32149829
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY verifyAmountTwo

    ${verifyAmountTwo}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}
    
Validate EMPTY value on verifyTryCount
    [Tags]  JIRA:BOT-1876  qTest:32149830
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with an EMPTY verifyTryCount

    ${verifyTryCount}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the transferAccountId
    [Tags]  JIRA:BOT-1876  qTest:32150023
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on transferAccountId

    ${transferAccountId}  set variable  6382FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the cardNumber
    [Tags]  JIRA:BOT-1876  qTest:32150073  BUGGED: It was not supposed to accept TYPO cardNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on cardNumber

    ${cardNumber}  set variable  7083051014152600035FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the routingNumber
    [Tags]  JIRA:BOT-1876  qTest:32150074  BUGGED: It was not supposed to accept TYPO routingNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on routingNumber

    ${routingNumber}  set variable  062000080FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the accountNumber
    [Tags]  JIRA:BOT-1876  qTest:32150075  BUGGED: It was not supposed to accept TYPO accountNumber
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on accountNumber

    ${accountNumber}  set variable  44778833FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the accountType
    [Tags]  JIRA:BOT-1876  qTest:32150076
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on accountType

    ${accountType}  set variable  22FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the effectiveDate
    [Tags]  JIRA:BOT-1876  qTest:32150089  BUGGED: It was not supposed to accept TYPO effectiveDate
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on effectiveDate

    ${effectiveDate}  set variable  2019-04-26T17:43:00.000-05:00FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the batchHeaderId
    [Tags]  JIRA:BOT-1876  qTest:32150091
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on batchHeaderId

    ${batchHeaderId}  set variable  2FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the verifyDate
    [Tags]  JIRA:BOT-1876  qTest:32150092  BUGGED: It was not supposed to accept TYPO verifyDate
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on verifyDate

    ${verifyDate}  set variable  2019-04-26T17:43:00.000-05:00FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the verifyAmountOne
    [Tags]  JIRA:BOT-1876  qTest:32150095
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on verifyAmountOne

    ${verifyAmountOne}  set variable  0.0FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the verifyAmountTwo
    [Tags]  JIRA:BOT-1876  qTest:32150096
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on verifyAmountTwo

    ${verifyAmountTwo}  set variable  0.0FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the verifyTryCount
    [Tags]  JIRA:BOT-1876  qTest:32150209
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on verifyTryCount

    ${verifyTryCount}  set variable  0FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

Check TYPO on the expireDate
    [Tags]  JIRA:BOT-1876  qTest:32150210  BUGGED: It was not supposed to accept TYPO expireDate
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account with a typo on expireDate

    ${expireDate}  set variable  2019-04-26T17:43:00.000-05:00FF

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

SmartPay Transfer Account With transferAccountId from different carrier
    [Tags]  JIRA:BOT-1876  qTest:32150262  BUGGED:It was not supposed to accept setSmartPayTransferAccount from other carriers
    [Documentation]  Validate that you cannot Set SmartPay Transfer Account using CardNumber from different carrier

    ${SmartPayTransferAccount}  getSmartPayTransferAccounts  ${cardNumber}
    ${transferAccountId}  set variable  ${SmartPayTransferAccount[0]['transferAccountId']}

    logout
    log into card management web services  103866  112233

    ${status}  Run Keyword And Return Status  setSmartPayTransferAccount  ${transferAccountId}  ${cardNumber}  ${bankName}  ${routingNumber}  ${accountNumber}  ${accountOwnerName}  ${accountType}  ${accountNickname}  ${effectiveDate}  ${batchHeaderId}  ${createdBy}  ${verifyDate}  ${verifyAmountOne}  ${verifyAmountTwo}  ${verifyTryCount}  ${expireDate}

    Should Not Be True  ${status}

    [Teardown]  Logout

*** Keywords ***
Check updated data
    [Arguments]  ${column}  ${transferAccountId}  ${data}
    Get Into DB  tch

    ${query}  Catenate
    ...  select TRIM(TO_CHAR(${column})) from ach_ppd_header where ppd_header_id='${transferAccountId}' AND ${column}='${data}';
    ${result}  Query and Strip  ${query}

    [Return]  ${result}

Setup WS
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Logout