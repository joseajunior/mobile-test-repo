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
${carrier}  141526
${card}  7083051014152600035
${account}  5382
${amount}  1

*** Test Cases ***
Cancel A Valid Pending Transfer
        [Tags]  JITA:BOT-1626  qTest:31778652  Regression  refactor
        [Documentation]  Make sure you can cancel a pending SmartFunds ACH or wire transfer

        ${transfer_id}  doSmartPayAchTransfer  ${account}  ${card}  ${amount}
        cancelPendingTransfer  ${transfer_id}

        ${query}  catenate  SELECT status FROM ach_ppd_detail WHERE ppd_detail_id=${transfer_id}
        ${TransferStatus}  Query And Strip  ${query}

        Should Be Equal As Strings  ${TransferStatus}  C

Cancel A Pending Transfer With An Empty ppdDetailId
        [Tags]  JITA:BOT-1626  qTest:31778666  Regression
        [Documentation]  Make sure you can't cancel a pending SmartFunds ACH or wire transfer when you have no ppdDetailId

        ${status}  Run Keyword And Return Status  cancelPendingTransfer  ${EMPTY}
        Should Not Be True  ${status}

Cancel A Pending Transfer With An Invalid ppdDetailId
        [Tags]  JITA:BOT-1626  qTest:31778693  Regression
        [Documentation]  Make sure you can't cancel a pending SmartFunds ACH or wire transfer when you have an invalid ppdDetailId

        ${status}  Run Keyword And Return Status  cancelPendingTransfer  26!@#31
        Should Not Be True  ${status}

Cancel A Pending Transfer With A Typo on ppdDetailId
        [Tags]  JITA:BOT-1626  qTest:31778717  Regression
        [Documentation]  Make sure you can't cancel a pending SmartFunds ACH or wire transfer whn you have a typo on the ppdDetailId

        ${status}  Run Keyword And Return Status  cancelPendingTransfer  26A331
        Should Not Be True  ${status}

Cancel A Pending Transfer With A Space on ppdDetailId
        [Tags]  JITA:BOT-1626  qTest:31778733  Regression
        [Documentation]  Make sure you can't cancel a pending SmartFunds ACH or wire transfer when you have a space on the ppdDetailId

        ${status}  Run Keyword And Return Status  cancelPendingTransfer  26${SPACE}332
        Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    ${password}  Get Carrier Password  ${carrier}
    log into card management web services  ${carrier}  ${password}

Teardown WS
    Disconnect From Database
    Logout