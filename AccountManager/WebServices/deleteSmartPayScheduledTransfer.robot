*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  Web Services  refactor
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Test Cases ***

Delete a SmartPay Scheduled Transfer
    [Tags]  JIRA:BOT-1629  qTest:31792014  Regression
    [Documentation]  Validate that you can delete a SmartPay Transfer Scheduled

    ${SmartPayScheduledTransfers}  getSmartPayScheduledTransfers  7083051014152600522
    ${scheduledTransferId}  set variable  ${SmartPayScheduledTransfers[0]['scheduledTransferId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayScheduledTransfer  ${scheduledTransferId}

    Should Be True  ${status}

Check INVALID on the scheduledTransferId
    [Tags]  JIRA:BOT-1629  qTest:31792208  Regression
    [Documentation]  Validate that you cannot delete a SmartPay Scheduled Transfer with a INVALID data on scheduledTransferId

    ${scheduledTransferId}  set variable  1nv@l!d

    ${status}  Run Keyword And Return Status  deleteSmartPayScheduledTransfer  ${scheduledTransferId}

    Should Not Be True  ${status}

Check TYPO on the scheduledTransferId
    [Tags]  JIRA:BOT-1629  qTest:31792228  Regression
    [Documentation]  Validate that you cannot delete a SmartPay Scheduled Transfer with a typo on scheduledTransferId

    ${SmartPayScheduledTransfers}  getSmartPayScheduledTransfers  7083051014152600522
    ${scheduledTransferId}  set variable  ${SmartPayScheduledTransfers[0]['scheduledTransferId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayScheduledTransfer  ${scheduledTransferId}F

    Should Not Be True  ${status}

Validate EMPTY value on scheduledTransferId
    [Tags]  JIRA:BOT-1629  qTest:31792231  Regression
    [Documentation]  Validate that you cannot delete a SmartPay Scheduled Transfer with an EMPTY scheduledTransferId

    ${scheduledTransferId}  set variable  ${EMPTY}

    ${status}  deleteSmartPayScheduledTransfer  ${scheduledTransferId}

    should be equal as strings  ${status}  None

Delete a SmartPay Scheduled Transfer already deleted
    [Tags]  JIRA:BOT-1629  qTest:31792234  Regression  BUGGED:It was supposed to return an error as response but it is returning a successful response.
    [Documentation]  Validate that you cannot delete a SmartPay Scheduled Transfer already deleted

    ${SmartPayScheduledTransfers}  getSmartPayScheduledTransfers  7083051014152600522
    ${scheduledTransferId}  set variable  ${SmartPayScheduledTransfers[0]['scheduledTransferId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayScheduledTransfer  ${scheduledTransferId}

    Should Be True  ${status}

    ${statusDeleted}  Run Keyword And Return Status  deleteSmartPayScheduledTransfer  ${scheduledTransferId}

    Should Not Be True  ${statusDeleted}

Delete a SmartPay Scheduled Transfer from a different carrier
    [Tags]  JIRA:BOT-1629  qTest:31792062  Regression  BUGGED:It was not supposed to delete Scheduled Transfers from others carriers
    [Documentation]  Validate that you cannot delete a SmartPay Transfer Scheduled from a different carrier

    ${SmartPayScheduledTransfers}  getSmartPayScheduledTransfers  7083051014152600522
    ${scheduledTransferId}  set variable  ${SmartPayScheduledTransfers[0]['scheduledTransferId']}
    logout

    log into card management web services  103866  112233
    ${status}  Run Keyword And Return Status  deleteSmartPayScheduledTransfer  ${scheduledTransferId}

    Should Not Be True  ${status}

    [Teardown]  Logout

*** Keywords ***

Setup WS
    Get Into DB  TCH

    ${Carrier}  set variable  141526
    ${Passwd}  Get Carrier Password  ${Carrier}
    ${cardNum}  set variable  7083051014152600522

    log into card management web services  ${Carrier}  ${Passwd}
    Create Smartpay Scheduled Transfer  ${Carrier}  ${Passwd}  ${cardNum}  3

Tear Me Down
    Logout
    close browser

Create Smartpay Scheduled Transfer
    [Arguments]  ${Carrier}  ${Passwd}  ${cardNum}  ${qtdScheduledTransfers}
    Open eManager  ${Carrier}  ${Passwd}

    FOR  ${i}  IN RANGE  ${qtdScheduledTransfers}
        go to  ${emanager}/cards/SmartPayScheduledAchTransfer.action
        wait until element is visible  xpath=//*[@value='Create New Scheduled Transfer']  timeout=30
        click button  createNew
        wait until element is visible  xpath=//td[contains(text(),"${cardNum}")]  timeout=30
        click radio button  ${cardNum}
        click button  Next
        wait until element is visible  xpath=//*[@value='4516']  timeout=30
        click radio button  4516
        click button  Next
        wait until element is visible  xpath=//*[@value='Next']  timeout=30
        click button  Next
        wait until element is visible  xpath=//*[@name='transferAmount']  timeout=30
        input text  transferAmount  100
        click button  Next
        wait until element is visible  xpath=//*[@value='Next']  timeout=30
        click button  Next
        tch logging  created ${i} Scheduled Transfer
    END