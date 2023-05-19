*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup  Time to Setup
Suite Teardown  Tear Me Down

Force Tags  AM  Card Details

*** Variables ***
${balance}
${referenceNumber}

*** Test Cases ***
Load a Cash Advance on Card with Reference # and Notes
    [Tags]  JIRA:BOT-1341  qTest:32785635  Regression  qTest:30782832  refactor
    [Documentation]  Load a cash advance of $50.00 to the card with a Reference # and Notes.
    [Setup]  Test Setup  7083050910386622003
    ${amount}  Set Variable  50.00
    ${notes}  Catenate  BOT-1341 Adding $${amount}

    Open Account Manager
    Search For Card  EFS LLC  ${card}
    Select Cash on Card Detail
    Cash Advance on Cash Menu  ${amount}  ${referenceNumber}  ${notes}  ADD
    Verify Cash Advance Success Message
    Assert Loaded Value on DB  ${card}  ${amount}  ${balance}  ${referenceNumber}  ${notes}

#    [Teardown]  Close Browser

Remove Balance +1 Cash Advance on Card with Reference # and Notes
    [Tags]  JIRA:BOT-1342  qTest:32785636  Regression  refactor
    [Documentation]  Try to Remove cash advance of Balance +1 to the card with Reference # and Notes.
    [Setup]  Test Setup  7083050910386622003
    ${amount}  Evaluate  ${balance}+1
    ${notes}  Catenate  BOT-1342 Removing $${amount}

#    Open Account Manager
#    Search For Card  EFS LLC  ${card}
    Select Cash on Card Detail
    Cash Advance on Cash Menu  ${amount.__str__()}  ${referenceNumber}  ${notes}  REMOVE
    Verify Cash Advance Error Message
    Close One Time Cash Screen

#    [Teardown]  Close Browser

Remove Remaining Cash Advance on Card with Reference # and Notes
    [Tags]  JIRA:BOT-1343  qTest:32785637  Regression  qTest:30782890  refactor
    [Documentation]  Remove all cash advance available for card with Reference # and Notes.
    [Setup]  Test Setup  7083050910386622003
    ${amount}  Set Variable  ${balance.__str__()}
    ${notes}  Catenate  BOT-1343 Removing Remaining Balance

#    Open Account Manager
#    Search For Card  EFS LLC  ${card}
    Select Cash on Card Detail
    Cash Advance on Cash Menu  ${amount}  ${referenceNumber}  ${notes}  REMOVE
    Verify Cash Advance Success Message
    Assert Removed Value on DB  ${card}  ${amount}  ${balance}  ${referenceNumber}  ${notes}

    [Teardown]  Close Browser

All Cash Advance Balances Show Properly
    [Tags]  JIRA:BOT-BOT-1344  qTest:32785638  Regression  refactor
    [Documentation]  All Cash Advance Balance Should be Displayed Properly

    Open Account Manager
    Search For Card  EFS LLC  7083050910386622557
    Select Cash on Card Detail
    Validate if Cash Advance From Card Detail Match with Database

    [Teardown]  Close Browser

*** Keywords ***
Time to Setup
    Get Into DB  TCH

Test Setup
    [Arguments]  ${card}
    Get Card Balance by Card Number  ${card}
    ${referenceNumber}  Generate Random String  12  [NUMBERS]
    Set Test Variable  ${referenceNumber}
    Set Test Variable  ${card}

Get Card Balance by Card Number
    [Arguments]  ${card_num}  ${table}=cash_adv
    ${table}  Set Variable If  '${table}' != 'cash_adv'  payr_cash_adv  cash_adv
    ${query}  Catenate  SELECT balance FROM ${table} WHERE card_num='${card_num}' ORDER BY when DESC limit 1
    ${balance}  Query And Strip  ${query}
    Set Test Variable  ${balance}

Tear Me Down
    Disconnect From Database

Search For Card
    [Arguments]  ${partner}  ${card_num}
    Wait Until Element is Enabled  //a[@id='Card']
    Click on  //a[@id='Card']
    Wait Until Element Is Visible  name=cardNumber
    Refresh Page
    Wait Until Element Is Visible  name=businessPartnerCode
    Select From List By Label  businessPartnerCode  ${partner}
    Wait Until Element is Enabled  //input[@name='cardNumber']  timeout=35
    Input Text  name=cardNumber  ${card_num}
    Double Click On  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0  timeout=35
    Wait Until Element is Visible  //button[text()='${card_num}']  timeout=35
    Set Focus To Element  //button[text()='${card_num}']
    Click On  //button[text()='${card_num}']
    Wait Until Element Is Enabled  id=submit

Select Cash on Card Detail
    Wait Until Element is Enabled  //a[@id='Cash']
    Click on  //a[@id='Cash']

Cash Advance on Cash Menu
    [Arguments]  ${amount}  ${referenceNumber}  ${notes}  ${operation}
    [Documentation]  Operation can be defined to remove or add cash,
    ...              If you want to remove cash use: REMOVE as Operation
    ...              If you want to add cash use: ADD as Operation

    Wait Until Element Is Visible  detailRecord.promptSource  timeout=35
    ${operation}  Set Variable If  '${operation}'=='ADD'  LOAD  RMVE
    Wait Until Element is Enabled  //a[@id='ToolTables_DataTables_Table_1_1']  timeout=35
    Click on  //a[@id='ToolTables_DataTables_Table_1_1']

    Wait Until Element Is Enabled  cashSummary.activityType  timeout=35
    Select From List By Value  cashSummary.activityType  ${operation}
    Input Text  cashSummary.amount  ${amount}
    Input Text  cashSummary.referenceNumber  ${referenceNumber}
    Input Text  cashSummary.notes  ${notes}
    Click Element  //td[@id='addCardCashFormButtons']//button[@id='submit']

Verify Cash Advance Success Message
    Wait Until Element is Enabled  //ul[@class='msgSuccess']//li[contains(text(),'Add Successful')]  timeout=35

Verify Cash Advance Error Message
    Wait Until Element is Visible  //ul[@class='msgError']//li[contains(text(),'Add Unsuccessful.')]  timeout=35

Assert Loaded Value on DB
    [Arguments]  ${card_number}  ${amount}  ${balance}  ${referenceNumber}  ${notes}
    ${newBalance}  Evaluate  ${balance}+${amount}
    Assert Value on DB  ${card_number}  ${amount}  ${newBalance}  LOAD  ${referenceNumber}  ${notes}

Assert Removed Value on DB
    [Arguments]  ${card_number}  ${amount}  ${balance}  ${referenceNumber}  ${notes}
    ${newBalance}  Evaluate  ${balance}-${amount}
    Assert Value on DB  ${card_number}  ${amount}  ${newBalance}  RMVE  ${referenceNumber}  ${notes}

Assert Value on DB
    [Arguments]  ${card_number}  ${amount}  ${balance}  ${operation}  ${referenceNumber}  ${notes}
    Sleep  2
    ${query}  Catenate  SELECT * FROM cash_adv ca
    ...  LEFT JOIN cash_adv_notes can ON ca.cash_adv_id = can.cash_adv_id
    ...  WHERE ca.card_num='${card_number}'
    ...  AND ca.amount='${amount}'
    ...  AND ca.balance='${balance}'
    ...  AND ca.id='${operation}'
    ...  AND ca.ref_num='${referenceNumber}'
    ...  AND can.notes='${notes}'
    ...     AND ca.when = (SELECT MAX(ca2.when)
    ...                     FROM cash_adv ca2
    ...                     INNER JOIN cash_adv_notes can2 ON ca2.cash_adv_id = can2.cash_adv_id
    ...                     WHERE ca2.card_num = ca.card_num
    ...                     AND ca2.amount = ca.amount
    ...                     AND ca2.balance=ca.balance
    ...                     AND ca2.id = ca.id
    ...                     AND ca2.ref_num = ca.ref_num
    ...                     AND can2.notes = can2.notes);
    Row Count Is Equal to X  ${query}  1

Get Cash Advance Amounts From Card Detail
    Wait Until Element Is Visible  //div[@id='cardCashSearchContainer']//td[@class='policyCard']  timeout=35
    ${policyCard}  Get Text  //div[@id='cardCashSearchContainer']//td[@class='policyCard']
    ${contractLimit}  Get Text  //div[@id='cardCashSearchContainer']//td[@class='contractLimit']
    ${oneTime}  Get Text  //div[@id='cardCashSearchContainer']//td[@class='oneTime']
    ${total}  Get Text  //div[@id='cardCashSearchContainer']//td[@class='total']
    ${availableAmount}  Get Text  //div[@id='cardCashSearchContainer']//td[@class='availableAmount']

    Set Test Variable  ${policyCard}
    Set Test Variable  ${contractLimit}
    Set Test Variable  ${oneTime}
    Set Test Variable  ${total}
    Set Test Variable  ${availableAmount}

Get Cash Advance Amounts For Comparison
    Log Into Card Management Web Services  ${username}  ${password}
    ${cash}  getCurrentCashAllAmounts  7083050910386622557
    ${wsTotal}  Evaluate  ${cash['oneTimeCash']} + ${cash['recurringCash']}

    Set Test Variable  ${cash}
    Set Test Variable  ${wsTotal}

Validate if Cash Advance From Card Detail Match with Database
    Get Cash Advance Amounts From Card Detail
    Get Cash Advance Amounts For Comparison

    Should Be Equal as Numbers  ${cash['recurringCash']}  ${policyCard}  #recurringCash
    Should Be Equal as Numbers  ${cash['contractLimit']}  ${contractLimit}  #contractLimit
    Should Be Equal as Numbers  ${cash['oneTimeCash']}  ${oneTime}  #oneTimeCash
    Should Be Equal as Numbers  ${wsTotal}  ${total}  #oneTimeCash + recurringCash
    Should Be Equal as Numbers  ${cash['cashAvailable']}  ${availableAmount}  #if total > contractLimit  availableAmount=contractLimit

Close One Time Cash Screen
    Click Element  //td[@id='addCardCashFormButtons']//button[@name='cancel']