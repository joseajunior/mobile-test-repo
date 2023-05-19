*** Settings ***
Test Timeout  5 minutes
Library  otr_robot_lib.support.PyLibrary

Library  otr_robot_lib.support.PyString
Library  otr_model_lib.Models
Library  OperatingSystem  WITH NAME  os
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setting Up
Suite Teardown  Tear Me Down
Force Tags    eManager

*** Variables ***
${csvPath}  ${ROBOTROOT}\\Assets\\cashAdvanceLoad.csv
${cardOne}  ${validCard.card_num}
${cardTwo}  ${universalCard.card_num}
${CASH_ADV_LOAD_REMOVE_FEE_NAME}  CASH LOAD/REMOVE FEES
${note_254}  Hey! It's time again for regression testing and guess what I'm doing right now! You'll never guess!
...   Yep I'm doing regression testing on Cash Advances One Time Cash.
...  Yep and it's that time again to test the note and see if the counter is working
...  and if it will accept this message or refuse it because it's too long...

*** Test Cases ***

Search by card
    [Tags]  JIRA:BOT-424  JIRA:BOT-1410  qTest:28116445  Regression
    [Documentation]  The following are from regression testing document for eManager
    ...  to check mulitple things on CashAdvance screen.
    ...  This test case searches a card by card number
    [Setup]  Setup Cash Advance  ${cardOne}
    Wait Until Element Is Visible  name=processCashAdvance

Search by X-ref
    [Tags]  JIRA:BOT-676  JIRA:BOT-1411  qTest:28116468  Regression  refactor    #no card with x-ref
    [Documentation]   This test case searches card by x-ref, tries to do a cash advance without entering amount
     ...  and does a cash advcance after entering amount
    [Setup]  Navigate to Cash Adv Screen
    Search by X-ref  ${validCard.coxref}
    Wait Until Element Is Visible  name=processCashAdvance

Add an Amount > $9,999.99
    [Tags]  JIRA:BOT-424  JIRA:BOT-1412  qTest:28272720  Regression  tier:0
    [Documentation]  The following are from regression testing document for eManager
    ...  to check mulitple things on CashAdvance screen.
    ...  This test case searches a card by card number
    ...  Process a cash advance using a number greater than $9.999.99
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  999999
    Validate Error Message  Cannot process one time cash greater than the amount available of $9,999.

Add a Valid Amount
    [Tags]  JIRA:BOT-604  JIRA:BOT-1413  qTest:28272721  Regression  tier:0
    [Documentation]  When adding a valid amount you should receive a success message
    ...  and the amount should be loaded to the card.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10
    Validate Message  Successfully added $10 to card
    Validate Table By Column and Reference Number  Amount  $10.00  ${reference}
    Validate Loaded Value on DB  ${cardOne}  10.00

New Amount Displays in History
    [Tags]  JIRA:BOT-1414  qTest:28272722  Regression
    [Documentation]  When adding a valid amount you should see the new amount on
    ...  history table in cash advance screen
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10
    Validate Message  Successfully added $10 to card
    Validate Table By Column and Reference Number  Amount  $10.00  ${reference}
    Validate Loaded Value on DB  ${cardOne}  10.00

Add 0.00 As The Amount
    [Tags]  JIRA:BOT-1416  qTest:28272723  Regression  refactor
    [Documentation]  When adding an amount equal to $0 we should be given an error
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  0.00
    Validate Error Message  Amount cannot be zero.

Enter Reference an Alpha Numeric Number
    [Tags]  JIRA:BOT-1417  qTest:28272724  Regression
    [Documentation]  When entering a Reference Number you should receive a success message and reference should be assigned to cash advance.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10  R3f3r3nc3@
    Validate Message  Successfully added $10 to card
    Validate Table By Column and Reference Number  Amount  $10.00  ${reference}
    Validate Loaded Value on DB  ${cardOne}  10.00

Leave Reference Number Blank
    [Tags]  JIRA:BOT-1418  qTest:28272725  Regression
    [Documentation]  When leaving a Reference Number blank you should receive a success message.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10  ${EMPTY}
    Validate Message  Successfully added $10 to card
    Validate Table By Column and Reference Number  Amount  $10.00  ${reference}
    Validate Loaded Value on DB  ${cardOne}  10.00

Remove More Than Available
    [Tags]  JIRA:BOT-1090  qTest:28272726  Regression  tier:0
    [Documentation]  When removing an amount greater than balance we should get an error message.
    [Setup]  Setup Cash Advance  ${cardOne}
    Remove an Amount Greater Than The Balance  ${cardOne}
    Validate Error Message  Amount exceeds current One Time Cash.

Remove 0.00 as The Amount
    [Tags]  JIRA:BOT-1091  qTest:28272727  Regression
    [Documentation]  When remove an amount equal to $0 we should be given an error
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  0.00  operation=REMOVE
    Validate Error Message  Amount cannot be zero.

Remove Valid Amount
    [Tags]  JIRA:BOT-1419  qTest:28816490  Regression  tier:0
    [Documentation]   When removing a valid amount you should receive a success message and the amount should be removed from the card.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10  operation=REMOVE
    Validate Message  Successfully removed $-10
    Validate Table By Column and Reference Number  Amount  $10.00  ${reference}
    Validate Removed Value on DB  ${cardOne}  10.00

Amount Removed Displays in History
    [Tags]  JIRA:BOT-1420  qTest:28816719  Regression
    [Documentation]   When removing a valid amount you should receive a success message and the amount should be removed from the card.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10  operation=REMOVE
    Validate Message  Successfully removed $-10
    Validate Table By Column and Reference Number  Amount  $10.00  ${reference}
    Validate Removed Value on DB  ${cardOne}  10.00

Add Cash Advance With a Non-Digit in Amount Field
    [Tags]  JIRA:BOT-617  qTest:28817973  Regression
    [Documentation]  Add Cash Advance to a card with the Alphanumeric value.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  1nv4l1d 4m0unt
    Validate Error Message  The value (1nv4l1d 4m0unt) entered in field Amount must be a valid number

Remove Decimal Amount
    [Tags]  JIRA:BOT-  qTest:28818160  Regression
    [Documentation]   When removing a decimal amount you should receive a success message and the amount should be removed from the card.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10.75  operation=REMOVE
    Validate Message  Successfully removed $-10.75
    Validate Table By Column and Reference Number  Amount  $10.75  ${reference}
    Validate Removed Value on DB  ${cardOne}  10.75

Add Decimal Amount
    [Tags]  BOT-642
    [Documentation]  Add an amount to a card with a decimal value.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10.76
    Validate Message  Successfully added $10.76 to card
    Validate Table By Column and Reference Number  Amount  $10.76  ${reference}
    Validate Loaded Value on DB  ${cardOne}  10.76

New Balance Includes Recent Add
    [Tags]  JIRA:BOT-1415  qTest:28818360  Regression  refactor
    [Documentation]  When adding a valid amount you should receive a success message and the amount should be loaded to the card.
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  11
    Validate Message  Successfully added $11 to card
    Assert Entire Table History  Reference #  ${reference}
    Validate Loaded Value on DB  ${cardOne}  11.00
    Assert Cash Advance Balance  ${cardOne}

New Balance Deducted Amount Removed
    [Tags]  JIRA:BOT-1421  qTest:28818862  Regression  refactor
    [Documentation]  ​​When removing a valid amount you should see a decrease of total cash and one-time cash field at available cash table
    [Setup]  Setup Cash Advance  ${cardOne}
    Perform a cash advance  10  operation=REMOVE
    Validate Message  Successfully removed $-10
    Assert Entire Table History  Reference #  ${reference}
    Validate Removed Value on DB  ${cardOne}  10.00
    Assert Cash Advance Balance  ${cardOne}

Amounts Added show in cash_adv Table
    [Tags]  JIRA:BOT-1422  qTest:28818947  Regression  tier:0  refactor
    [Documentation]  Perform 3 adds in One Time Cash to a card.
    [Setup]  Setup Cash Advance  ${cardOne}
    FOR  ${i}  IN RANGE  0  3
      ${amount}  Generate Random String  3  [NUMBERS]
      ${reference}  Generate Random String  10  [LETTERS]
      Perform a cash advance  ${amount}  reference=${reference}
      Assert Cash_Adv Table  ${cardOne}  ${amount}.00  LOAD  ${reference}
    END

Amounts Removed show in cash_adv Table
    [Tags]  JIRA:BOT-1423  qTest:28820136  Regression  refactor  tier:0
    [Documentation]  Perform 3 adds in One Time Cash to a card.
    [Setup]  Setup Cash Advance  ${cardOne}
    FOR  ${i}  IN RANGE  0  3
      ${amount}  Generate Random String  3  [NUMBERS]
      ${reference}  Generate Random String  10  [LETTERS]
      Perform a cash advance  ${amount}  operation=REMOVE  reference=${reference}
      Assert Cash_Adv Table  ${cardOne}  ${amount}.00  RMVE  ${reference}
    END

Saved Amount and Current Amount Should Be Equal
    [Tags]  JIRA:BOT-183  Cash Advance  Load File  eManager  File  refactor
    [Documentation]  To make sure that Cash Advance Funds can be loaded onto a card from a load file. This test uses the
    ...  cash_adv table to check to make sure that those funds got loaded correctly.
    [Setup]  Setup Cards To Cash Advance Use  ${cardOne}  ${cardTwo}
    ${fee_backup1}  Clear Cash Advance Fee To Card Number  ${cardOne}
    ${fee_backup2}  Clear Cash Advance Fee To Card Number  ${cardTwo}
    Setup Card to Cash Advance Use  ${cardTwo}
    Save Balance Before Load Cash Advance Amount  ${cardOne}  ${cardTwo}
    Load Cash Advance Amount
    Saved Amount and Current Amount Should Be Equal  ${cardOne}  ${cardTwo}
    [Teardown]  Run Keywords
    ...     Restore Driver Fee By Fee Info  ${fee_backup1}
    ...     AND  Restore Driver Fee By Fee Info  ${fee_backup2}

Add Note to Cash Advance with 254++ Characters
    [Tags]  JIRA:BOT-532  JIRA:BOT-509  JIRA:BOT-604  refactor
    [Documentation]  BOT-532 Remove Cash Advance from a card for an amount more than what is available and then remove the amount auto populated.
    ...     BOT-509  Adding notes to Cash Advances
    ...     BOT-604  Add Cash Advance to a card
    [Setup]  Setup Cash Advance  ${cardOne}
    Input Text  name=amount  25
    Input Text  name=note  ${note_254}
    get alert message  dismiss alert

*** Keywords ***
Setting Up
    Get Into DB  TCH
    Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}

Navigate to Cash Adv Screen
    go to  ${emanager}/cards/CardLookup.action?returnPage=/CashAdvanceManagement.action&returnPageParamPrefix=card.

Search by card
    [Arguments]  ${card}
    Search Card  ${card}

Search by X-ref
    [Arguments]  ${xref}
    Search Card  ${xref}  XREF

Search Card
    [Arguments]  ${value}  ${searchType}=NUMBER
    click radio button  //fieldset//input[@value="${searchType}"]
    input text  cardSearchTxt   ${value}
    click button  searchCard
    click link  //*[contains(@href,"cardId")]

Perform a cash advance
    [Arguments]  ${amount}  ${reference}=None  ${note}=Rob12345678  ${operation}=LOAD
    ${new_reference}  Generate Random String  10  [LETTERS]
    ${reference}  Set Variable If  '${reference}'=='None'  ${new_reference}  ${reference}
    Set Test Variable  ${reference}  ${reference}
    input text  amount  ${amount}
    input text  reference  ${reference}
    input text  note  ${note}
    Run Keyword If  '${operation}'=='LOAD'
    ...  Click Button  processCashAdvance
    ...  ELSE
    ...  Click Button  processCashRemove

Remove an Amount Greater Than The Balance
    [Arguments]  ${card_number}
    ${query}  Catenate  SELECT balance FROM cash_Adv WHERE card_num = '${card_number}' ORDER BY when DESC LIMIT 1
    ${balance}  Query And Strip  ${query}
    ${balance}  Evaluate  (${balance}+1)*-1
    Perform a cash advance  ${balance.__str__()}

Remove an Amount Equal To The Balance
    ${removeCadv}=  get text  //*[@for="cashAdvance.jsp.one.time.cash"]/parent::td/parent::tr/td[2]
    ${removeCadv}=  remove from string  $  ${removeCadv}
    log to console  ${removeCadv}

    Run Keyword If  '${removeCadv}'!='0.00'  run keywords
    ...  Input Text  name=amount  ${removeCadv}  AND
    ...  Click Button  processCashRemove
    ...  ELSE
    ...  tch logging  No Need to remove One Time Cash

Validate Error Message
    [Arguments]  ${expected_message}
    wait until element is visible  //div[@class='errors']//li  timeout=15  error=Cold not find error message
    ${error_message}  Get Text  //div[@class='errors']//li
    Should Contain  ${error_message}  ${expected_message}

Validate Message
    [Arguments]  ${expected_message}
    ${message}  Get Text  //ul[@class='messages']/li
    Should Contain  ${message}  ${expected_message}

Validate Table By Column and Reference Number
    [Arguments]  ${column_name_1}  ${expected_value_1}  ${expected_refecence_number}
    ${reference_number_header}  Set Variable  Reference #
    ${reference_text}  Set Variable if  '${expected_refecence_number}'=='${EMPTY}'  [not(text())]  [text()='${expected_refecence_number}']
    ${data_line}  Catenate  //table[@id='cashRecord']//td[count(//table[@id='cashRecord']//th[text()='${column_name_1}']/preceding-sibling::th)+1][text()='${expected_value_1}']/parent::tr//td[count(//table[@id='cashRecord']//th/a[text()='${reference_number_header}']/parent::th/preceding-sibling::th)+1]${reference_text}/parent::tr
    Page Should Contain Element  ${data_line}

Assert Entire Table History
    [Arguments]  ${column_name}  ${expected_value}
    ${count}  Get Element Count  //table[@id='cashRecord']//tbody/tr
    ${find}  Set Variable  ${False}
    FOR  ${row}  IN RANGE  1  ${count}
        ${table_value}  Get Text  //table[@id='cashRecord']//tr[${row}]/td[count(//table[@id='cashRecord']//th/a[text()='${column_name}']/parent::th/preceding-sibling::th)+1]
        ${find}  Set Variable If  '${table_value}'=='${expected_value}'  ${True}  ${find}
        Run Keyword If  ${find}==${True}  Exit For Loop
    END
    Should Be Equal  ${find}  ${True}

Validate Loaded Value on DB
    [Arguments]  ${card_number}  ${amount}
    Assert Value on DB  ${card_number}  ${amount}  LOAD

Validate Removed Value on DB
    [Arguments]  ${card_number}  ${amount}
    Assert Value on DB  ${card_number}  ${amount}  RMVE

Assert Value on DB
    [Arguments]  ${card_number}  ${amount}  ${operation}
    ${query}  Catenate  SELECT id,amount FROM cash_adv WHERE card_num='${card_number}' ORDER BY when DESC LIMIT 1
    ${output}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Strings  ${output['id']}  ${operation}
    Should Be Equal As Strings  ${output['amount']}  ${amount}

Assert Cash_Adv Table
    [Arguments]  ${card_number}  ${amount}  ${operation}  ${reference}
    Row Count Is Equal To X  SELECT 1 FROM cash_adv WHERE card_num='${card_number}' AND ref_num='${reference}' AND id='${operation}' AND amount=${amount}  1

Assert Cash Advance Balance
    [Arguments]  ${card}
    ${db_policy_card_cash}  Query And Strip  SELECT limit FROM card_lmt WHERE card_num = '${card}' AND limit_id = 'CADV'
    ${db_policy_card_cash}  Set Variable If  '${db_policy_card_cash}'=='None'  0  ${db_policy_card_cash}
    ${db_one_time_cash}     Query And Strip  SELECT balance FROM cash_adv WHERE card_num = '${card}' ORDER BY when DESC LIMIT 1
    ${db_one_time_cash}     Set Variable If  '${db_one_time_cash}'=='None'  0  ${db_one_time_cash}
    ${db_total_cash}  Evaluate  ${db_policy_card_cash} + ${db_one_time_cash}

    ${ui_policy_card_cash}  Get Text  //label[@for='cashAdvance.jsp.policy.cash']/following::td[1]
    ${ui_one_time_cash}     Get Text  //label[@for='cashAdvance.jsp.one.time.cash']/following::td[1]
    ${ui_total_cash}        Get Text  //label[@for='cashAdvance.jsp.total.cash']/following::td[1]

    ${ui_policy_card_cash}  Remove From String  $  ${ui_policy_card_cash}
    ${ui_policy_card_cash}  Remove From String  ,  ${ui_policy_card_cash}
    ${ui_one_time_cash}     Remove From String  $  ${ui_one_time_cash}
    ${ui_one_time_cash}     Remove From String  ,  ${ui_one_time_cash}
    ${ui_total_cash}        Remove From String  $  ${ui_total_cash}
    ${ui_total_cash}        Remove From String  ,  ${ui_total_cash}

    Should Be Equal As Numbers  ${db_policy_card_cash}  ${ui_policy_card_cash}
    Should Be Equal As Numbers  ${db_one_time_cash}  ${ui_one_time_cash}
    Should Be Equal As Numbers  ${db_total_cash}  ${ui_total_cash}

Setup Cards To Cash Advance Use
    [Arguments]  ${card_num1}  ${card_num2}
    Start Setup Card  ${card_num1}
    Setup Card Header  status=ACTIVE  payrollStatus=ACTIVE
    Start Setup Card  ${card_num2}
    Setup Card Header  status=ACTIVE  payrollStatus=ACTIVE

Setup Card to Cash Advance Use
    [Arguments]  ${card_num}  ${DB}=TCH
    Clear Cash Advance Fee To Card Number  ${card_num}  ${DB}
    Start Setup Card  ${card_num}
    Setup Card Header  status=ACTIVE  payrollStatus=ACTIVE

Clear Cash Advance Fee To Card Number
    [Arguments]  ${card_num}  ${DB}=TCH
    Set Test Variable  ${fee_backup}  ${None}
    ${fee_info}  Get Card Num Fees  ${card_num}  ${DB}
    ${qtd_fees}  Get List Size  ${fee_info}
    Run Keyword If  ${qtd_fees} > 0  Run Keywords
    ...  Update Driver Fee  ${fee_info}  0  ${DB}
    ...  AND  Set Test Variable  ${fee_backup}  ${fee_info}
    [Return]  ${fee_backup}

Get Card Num Fees
    [Arguments]  ${card_num}  ${DB}=TCH
    #Get Into DB  ${DB}
    ${query}  Catenate
    ...  SELECT co.contract_id,
    ...         c.carrier_id,
    ...         ft.fee_id,
    ...         df.fee_amt
    ...     FROM cards c
    ...     JOIN def_card dc ON c.carrier_id = dc.id AND dc.ipolicy = c.icardpolicy
    ...     JOIN contract co ON dc.contract_id = co.contract_id
    ...     JOIN driver_fees df ON df.carrier_id = c.carrier_id AND df.contract_id = co.contract_id
    ...     JOIN fee_types ft ON ft.fee_id = df.fee_id
    ...  WHERE c.card_num = '${card_num}'
    ...  AND ft.fee_desc = '${CASH_ADV_LOAD_REMOVE_FEE_NAME}'
    ${fee_info}  Query And Strip To Dictionary  ${query}
    [Return]  ${fee_info}

Restore Driver Fee
    [Arguments]  ${DB}=TCH
    Run Keyword If  "${fee_backup}"!="${None}"
    ...  Update Driver Fee  ${fee_backup}  ${fee_backup['fee_amt']}  ${DB}

Restore Driver Fee By Fee Info
    [Arguments]  ${fee_info}  ${DB}=TCH
    Run Keyword If  "${fee_info}"!="${None}"
    ...  Update Driver Fee  ${fee_info}  ${fee_info['fee_amt']}  ${DB}

Update Driver Fee
    [Arguments]  ${fee_info}  ${value}  ${DB}=TCH
    Get Into DB  ${DB}
    ${query}  Catenate
    ...  SELECT 1 FROM driver_fees
    ...  WHERE fee_id = ${fee_info['fee_id']}
    ...  AND carrier_id = ${fee_info['carrier_id']}
    ...  AND contract_id = ${fee_info['contract_id']}
    ${count}  Query And Strip  ${query}
    ${query}  Catenate
    ...  UPDATE driver_fees SET fee_amt = ${value}
    ...  WHERE fee_id = ${fee_info['fee_id']}
    ...  AND carrier_id = ${fee_info['carrier_id']}
    ...  AND contract_id = ${fee_info['contract_id']}
    Run Keyword If  '${count}'=='1'
    ...  Execute SQL String  ${query}

Save Balance Before Load Cash Advance Amount
    [Arguments]  ${card_num1}  ${card_num2}  ${DB}=TCH
    Get Into DB  ${DB}
    ${before_bal_card_1}  Get Balance From Card  ${card_num1}  ${DB}
    ${before_bal_card_2}  Get Balance From Card  ${card_num2}  ${DB}
    Set Test Variable  ${before_bal_card_1}
    Set Test Variable  ${before_bal_card_2}

Get Balance From Card
    [Arguments]  ${card_num}  ${DB}=TCH
    Get Into DB  ${DB}
    ${card_bal}  Query And Strip  SELECT balance FROM cash_adv WHERE card_num = '${card_num}' ORDER BY when DESC LIMIT 1;
    [Return]  ${card_bal}

Load Cash Advance Amount
    go to  ${emanager}/cards/CashLoadImport.action
    click on  newFile
    ${file}=  os.Normalize Path  ${csvPath}
    choose file  newFile  ${file}
    click on  importFile
    sleep  1
    click on  loadAmts
    sleep  1
    wait until element is visible  xpath=//*[@class="messages"]  timeout=15  error=Error when loading cash amount
    element should be visible  xpath=//*[@class="messages"]  2 cards were loaded.

Saved Amount and Current Amount Should Be Equal
    [Arguments]  ${card_num1}  ${card_num2}  ${DB}=TCH
    Get Into DB  ${DB}
    ${afterBal1}  Get Balance From Card  ${card_num1}  ${DB}
    ${afterBal2}  Get Balance From Card  ${card_num2}  ${DB}
    Should Not Be Equal  ${before_bal_card_1}  ${afterBal1}
    Should Not Be Equal  ${before_bal_card_2}  ${afterBal2}

Setup Cash Advance
    [Arguments]  ${cadv_card}
    Setup Card to Cash Advance Use  ${cadv_card}
    Navigate to Cash Adv Screen
    Search by card  ${cadv_card}

Tear Me Down
    Disconnect From Database
