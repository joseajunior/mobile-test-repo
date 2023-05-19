*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Teardown  Close Browser
Force Tags  eManager

*** Test Cases ***
URL Get request - Cash ADvance
    [Tags]  JIRA:BOT-148  JIRA:BOT-2424
    Make Sure Carrier Is Active  ${validCard.carrier.id}
    open emanager   ${validCard.carrier.id}  ${validCard.carrier.password}
    Maximize Browser Window
    Go To   url=${emanager}/cards/SmartPayAllocation.action?searchCard=&cardId=20000034455539
    Sleep  3
    Page Should Contain Element   xpath=//*[@class="content1"]//*[contains(text(), 'There was an error processing your request.')]

Card Prompts
    [Tags]  JIRA:BOT-2424
    Go to Manage Cards then View/Update Cards
    Go To  url=${emanager}/cards/CardPromptManagement.action?card.cardId=3002200650934&card.displayNumber=6830505503861234554&lookupInfoRadio=allCards
    Sleep  3
    Page Should Contain Element  xpath=//*[@class="content1"]//*[contains(text(), 'There was an error processing your request.')]

Smartpay Transfer
    [Tags]  JIRA:BOT-2424
    Go to SmartFunds then SmartFunds Card Management
    Go To  url=${emanager}/cards/CardPayrollTransfer.action?linkToCard=smartPayCardLookup&displayNumber=6678548******0080&cardId=3000003890561&dirverId=
    Sleep  3
    Page Should Contain Element  xpath=//*[@class="content1"]//*[contains(text(), 'There was an error processing your request.')]
    should contain any

Smartpay transfer accounts
    [Tags]  JIRA:BOT-2424
    Go to SmartFunds then SmartFunds Card Management
    Go To  url=${emanager}/cards/SmartPayTransferAccounts.action?callTransferAccountsPage=true&cardId=32100078902678
    Sleep  3
    Page Should Contain Element   xpath=//*[@class="errors"]//*[contains(text(), 'There was a problem determining the driver profile associated with this SmartFunds account.')]

Smartpay edit driver profile
    [Tags]  JIRA:BOT-2424
    Go to SmartFunds then SmartFunds Card Management
    Go To  url=${emanager}/cards/SmartPayEditDriverProfile.action?fromSmartPayCardLookup=true&cardId=34500067890280
    Sleep  3
    Page Should Contain Element  xpath=//*[@class="content1"]//*[contains(text(), 'There was an error processing your request.')]

Transaction Details
    [Tags]  JIRA:BOT-2424

    ${FakeTransId}  Generate Random String  9  [NUMBERS]
    ${trans_id}  Get The Last Transaction On The Card  TCH  ${validCard.card_num}
    Go to Manage Cards then View/Update Cards
    Input Text  cardSearchTxtValue  ${validCard.card_num}
    Click Element  searchCard
    Click Element  //*[@id="cardSummary"]//*[contains(text(),'${validCard.card_num}')]
    Click Element  //*[@style="white-space: nowrap"]/self::a[1]
    Click Element  //*[@id="row"]//*[contains(text(),'${trans_id}')]
    Go To  url=${emanager}/cards/TransactionDetail.action?transactionId=${FakeTransId}
    Sleep  3
    Page Should Contain Element   xpath=//*[@class="messages"]//*[contains(text(), 'There are no transaction associated with the transaction id')]

*** Keywords ***
Go to ${menu} then ${menu_item}
    Mouse Over  id=menubar_1x2
    Mouse Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Get The Last Transaction On The Card
    [Arguments]  ${DB}  ${card}

    Get Into DB  ${DB}
    ${trans_id}  Query And Strip  SELECT trans_id FROM transaction WHERE card_num='${card}' ORDER BY trans_id DESC limit 1

    [Return]  ${trans_id}
