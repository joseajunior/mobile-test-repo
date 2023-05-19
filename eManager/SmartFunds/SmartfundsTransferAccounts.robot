*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.services.GenericService

Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot


Documentation  This is a test suite for QAT-701\\n
...   This test is to setup smartfunds transfer account through a card
...   and run the related perl script
...   and check the DB for the updated values and status
...   and delete the account info because duplicate account number cannot be given

Suite Setup  time to setup
Suite Teardown  Teardown
Force Tags  eManager


*** Variables ***

${Acc_Num}  44778833
${Bank_Name}  ElRobotBank
${Routing_Num}  062000080
${Owner_Name}  ELRobotBanker
${Nick_Name}  Robo
${ppd_header_id}
${flag}
${myusername}  141526
${password2}
${CardNu}  7083051014152600035
${CardNu_pin}  4321

${ACH_contract}  72081
${amount}  15.80

*** Test Cases ***
ACH setup for ach_verify = Y and credit_limit = credit_bal
    [Tags]  JIRA:BOT-205  JIRA:BOT-190  JIRA:BOT-1929  qTest:30360108  refactor
    Update ach_verify in DB  Y
    ACH setup through card   Y
    Check information in DB  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}
    Verify SmartPay Transfer Accounts
    Check DB after verification
    Set up the condition
    Manual ACH transfer  ${amount}
    Database check for manual ACH transfer

ACH setup for ach_verify = N
    [Tags]  JIRA:BOT-137  refactor
    Update ach_verify in DB  N
    ACH setup through card   N
    Check information in DB  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}
    Run the perl script  achSendValidationAmt.pl

Fail to Allocate to Smart Funds Cards
    [Tags]  JIRA:BOT-201  Denial  Allocation  SmartFunds  Smart Funds Card  credit_limit  refactor
    [Documentation]  Testing if the credit_limit for a contract is set to zero then smart funds allocation should \\n
    ...   give an "Item limit exceeded" message. If it is not exceeded then it should work.

    get into db  tch
    execute sql string  dml=update contract SET credit_limit = 0 WHERE contract_id = 72081;
    Open eManager  ${myusername}  ${password2}
    SmartFund Allocation Test
    element should be visible  xpath=//*[@id="cardSummary"]/tbody/tr/td[8]/font/b  Item limit exceeded
    tch logging  \ncredit_limit = 0 and denies allocation
    execute sql string  dml=update contract SET credit_limit = 10000.00 WHERE contract_id = 72081;
    SmartFund Allocation Test
    element should not be visible  xpath=//*[@id="cardSummary"]/tbody/tr/td[8]/font/b  Item limit exceeded
    tch logging  credit_limit != 0 and ALLOWS allocation
    disconnect from database
    close window

SmartFunds Transfer Account
    [Tags]  JIRA:BOT-1187  qTest:30360107  Regression  qTest:30360108  qTest:30360109  qTest:30360110  qTest:32231892  refactor  tier:0
    [Documentation]  Create a New SmartFunds Transfer Account, Verify SmartFunds Transfer Accounts, Do a EFS SmartFunds ACH Transfer, Delete a bank account

    Open eManager  ${CardNu}  ${CardNu_pin}

    Create a New SmartFunds Transfer Account  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}

    Verify SmartPay Transfer Accounts

    Logout and then back into the SmartFunds account through eManager with  ${CardNu}  ${CardNu_pin}

    Do a transfer with amount  100

    Delete SmartFunds Transfer Account  ${Routing_Num}

    close browser

*** Keywords ***
Time to setup

    ${password2}  get carrier password  ${myusername}
    set global variable  ${password2}

Update ach_verify in DB
    [Arguments]   ${flag}
    get into db   tch
    execute sql string  dml=update member set ach_verify='${flag}' where member_id = 141526
    tch logging   ach_verify is set to ${flag}
    ${cardID}=  query and strip  select card_id from cards where card_num = '${CardNu}'
    set global variable  ${cardID}

ACH setup through card
     [Arguments]  ${flag}
    run keyword if  '${flag}'=='Y'
    ...  run keywords
    ...  open emanager  ${CardNu}  ${CardNu_pin}
    ...  AND  maximize browser window
    ...  AND  go to    url=${emanager}/cards/SmartPayTransferAccounts.action
    run keyword if  '${flag}'=='N'
    ...  run keywords
    ...  open emanager   ${myuserName}  ${password2}
    ...  AND  maximize browser window
    ...  AND  go to  url=${emanager}/cards/SmartPayCardLookup.action?am=SMARTPAY_TRANSFER
    ...  AND  click radio button  NUMBER
    ...  AND  input text  cardSearchTxt  ${CardNu}
    ...  AND  click button  searchCard
    ...  AND  click on  //*[@href="/cards/SmartPayTransferAccounts.action?callTransferAccountsPage=true&cardId=${cardID}"]

    ${status}  Run Keyword and Return Status  Element Should Be Visible  //table[@id='smartPayTransferAccountVar']//td[text()='${Routing_Num}']
    Run Keyword If  '${status}'=='${True}'  Run Keywords
    ...  Click Element  //table[@id='smartPayTransferAccountVar']//td[text()='${Routing_Num}']/parent::tr//input[@name='deleteSmartPayTransferAccount']
    ...  AND  Handle Alert

    Input  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}
    check element exists   text=New SmartFunds transfer account added
    run keyword if  '${flag}'=='N'   run keywords
    ...  Input  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}
    ...  AND   check element exists  text=Duplicate Routing / Account Number not permitted.
    ...  AND  tch logging   Expected error displayed
    ...  AND  close browser
    tch logging   ACH setup through card is done

Input
     [Arguments]   ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}
     input text   smartPayTransferAccount.bankName    ${Bank_Name}
     input text   smartPayTransferAccount.routingNumber   ${Routing_Num}
     input text   smartPayTransferAccount.accountNumber   ${Acc_Num}
     input text   smartPayTransferAccount.accountOwnerName   ${Owner_Name}
     input text   smartPayTransferAccount.accountNickname   ${Nick_Name}
     click button  Submit

Check information in DB
    [Arguments]  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}
    get into DB  tch
    ${result}=  query and strip to dictionary   select * from ach_ppd_header where dfi_account_number= '${Acc_Num}' order by ppd_header_id desc limit 1
    ${ppd_header_id}=  assign string  ${result.ppd_header_id}
    set global variable   ${ppd_header_id}
    should be equal as strings   ${result.receiving_bank_name.strip()}   ${Bank_Name}
    should be equal as strings   ${result.receiving_dfi_identification}  ${Routing_Num}
    should be equal as strings   ${result.individual_name.strip()}  ${Owner_Name}
    should be equal as strings   ${result.description.strip()}  ${Nick_Name}
    tch logging   Validation in DB is done

Run the perl script

    [Arguments]  ${script}
    tch logging   Running perl script
    connect ssh  ${sshConnection}  ${sshName}  ${sshPass}
    go sudo
    ${run}=  run command  /tch/run/${script}
    tch logging  Perl script successful

Check DB after running perl script
    [Arguments]   ${Acc_Num}
    get into db   tch
    ${results1}=  query and strip to dictionary   select * from ach_ppd_header where dfi_account_number= '${Acc_Num}' order by ppd_header_id desc limit 1
    should not be equal as strings   ${results1.verify_amount_1}  None
    ${amount1}=  assign string  ${results1.verify_amount_1}
    set global variable   ${amount1}
    should not be equal as strings   ${results1.verify_amount_2}  None
    ${amount2}=  assign string  ${results1.verify_amount_2}
    set global variable   ${amount2}
    should be equal as strings   ${results1.verify_try_count}  3
    should be equal as integers   ${results1.batch_header_id}  2

    run keyword if  '${flag}'=='Y'  should be equal as strings  ${results1.created_by.strip()}  ${CardNu}
    run keyword if  '${flag}'=='N'   should be equal as strings  ${results1.created_by.strip()}  ${myusername}

    ${ACHs}=  query and strip  select count(ppd_detail_id) from ach_ppd_detail where ppd_header_id = '${ppd_header_id}'
    should be equal as strings   ${ACHs}  2
    ${detail}=  query and strip to dictionary   select * from ach_ppd_detail where ppd_header_id = '${ppd_header_id}' order by ppd_detail_id asc
    should be equal as strings    ${detail.amount[0]}    ${results1.verify_amount_1}
    should be equal as strings    ${detail.amount[1]}    ${results1.verify_amount_2}
    tch logging   DB check after perl script successful

Verify SmartPay Transfer Accounts

    Run the perl script  achSendValidationAmt.pl
    Check DB after running perl script  ${Acc_Num}

    go to   url=${emanager}/cards/SmartPayVerifyTransferAccounts.action
    click on  //*[@value="${ppd_header_id}"]/following-sibling::input[@name="populateVerifySmartPayTransferAccount"]
    check element exists   text=Verify SmartFunds Transfer Accounts
    input text   verifyAmountOne  ${amount1}
    input text   verifyAmountTwo  ${amount2}
    click button   Verify
    check element exists   text=Account verification successful
    go to   url=${emanager}/cards/SmartPayTransferAccounts.action
    check element exists   //*[contains(text(), "${Bank_Name}")]/ancestor::*[2]/descendant::*[@href]
    tch logging   Smartpay Transfer account verified


Check DB after verification
    get into db   tch
    ${today}=  getdatetimenow  %Y-%m-%d
    ${date}=  query and strip to dictionary  select verify_date from ach_ppd_header where dfi_account_number= '${Acc_Num}' order by ppd_header_id desc limit 1
    ${date}=  convert to string  ${date.verify_date}
    should start with   ${date}  ${today}
    tch logging  DB check after verification done

SmartFund Allocation Test
    go to  ${emanager}/cards/SmartPayAllocation.action?am=SMARTPAY_LOAD_CARDS
    input text  cardSearchTxt  ${CardNu}
    click on  //*[@name="searchCard"]
    input text  //*[@id="cardSummary"]/tbody/tr/td[4]/input  100
    click on  //*[@name="submit"]
    select window  new
    click on  //*[@name="save"]
    Handle Alert
    select window  main

Set up the condition

    get into db  tch
    ${contract}=  query and strip to dictionary  select * from contract where contract_id = '${ACH_contract}'
    ${old_credit_bal}=  assign int  ${contract.credit_bal}
    set global variable  ${old_credit_bal}
    execute sql string  dml=update contract set credit_bal = credit_limit where contract_id = '${ACH_contract}'
    ${new_credit_bal}=  query and strip  select credit_bal from contract where contract_id = '${ACH_contract}'
    ${new_credit_bal}=  convert to string  ${new_credit_bal}
    set global variable  ${new_credit_bal}
    tch logging  Credit_limit = Credit_bal

Manual ACH transfer
    [Arguments]  ${amount}
    open emanager  ${myuserName}  ${password2}
    maximize browser window
    go to  ${emanager}/cards/SmartPayCardLookup.action?am=SMARTPAY_TRANSFER
    select radio button  lookupInfoRadio  NUMBER
    input text  name=cardSearchTxt  ${CardNu}
    click button  searchCard
    click link  //*[@href="/cards/SmartPayAchTransfer.action?cardId=${cardID}"]
    Wait Until Element Is Visible  xpath=//*[@id='addTransfer']
    input text  amount  ${amount}
    click button  addTransfer
    page should contain  text=Successfully Added Transfer with Amount
    Run the perl script  AchCreateFile.sh
    reload page
#    textarea_should_contain  //*[@id="row"]/tbody/tr[1]/td[6]  Sent
    tch logging  ACH sent
    close browser

Database check for manual ACH transfer
    get into db  tch
    ${TODAY}=  getDateTimeNow  %Y-%m-%d
    ${ppd_detail}=  query and strip to dictionary  select * from ach_ppd_detail where created_by='${myusername}' order by ppd_detail_id desc limit 1;
    should be equal as strings  ${ppd_detail.amount}  ${amount}
    ${payr_cash_adv}=  query and strip to dictionary  select * from payr_cash_adv where card_num='${CardNu}' order by cash_adv_id desc limit 1
    should be equal as strings  ${payr_cash_adv.id.strip()}  WDRW
    should be equal as strings  ${payr_cash_adv.amount}  ${amount}
#    row count is 0  select * from cash_adv  where contract_id = '${ACH_contract}' and id = "RMVE" and amount= "${amount}" and when >= '${TODAY} 00:00'
    ${contract}=  query and strip to dictionary  select * from contract where contract_id = '${ACH_contract}'
    should be equal as strings  ${contract.credit_bal}  ${new_credit_bal}
    tch logging  Credit_bal did not change
    execute sql string  dml=update contract set credit_bal = '${old_credit_bal}' where contract_id = '${ACH_contract}'
    tch logging  Credit_bal set to old credit_bal

Create a New SmartFunds Transfer Account
    [Arguments]  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}

    Update ach_verify in DB  Y

    go to  ${emanager}/cards/SmartPayTransferAccounts.action

    ${status}  Run Keyword and Return Status  Element Should Be Visible  //table[@id='smartPayTransferAccountVar']//td[text()='${Routing_Num}']

    Run Keyword If  '${status}'=='${True}'  Run Keywords
    ...  Click Element  //table[@id='smartPayTransferAccountVar']//td[text()='${Routing_Num}']/parent::tr//input[@name='deleteSmartPayTransferAccount']
    ...  AND  Handle Alert

    Input  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}

    check element exists   text=New SmartFunds transfer account added

    Check information in DB  ${Bank_Name}  ${Routing_Num}  ${Acc_Num}  ${Owner_Name}  ${Nick_Name}

Delete SmartFunds Transfer Account
    [Arguments]  ${Routing_Num}

    go to  ${emanager}/cards/SmartPayTransferAccounts.action

    ${status}  Run Keyword and Return Status  Element Should Be Visible  //table[@id='smartPayTransferAccountVar']//td[text()='${Routing_Num}']

    Run Keyword If  '${status}'=='${True}'  Run Keywords
    ...  Click Element  //table[@id='smartPayTransferAccountVar']//td[text()='${Routing_Num}']/parent::tr//input[@name='deleteSmartPayTransferAccount']
    ...  AND  Handle Alert


Do a transfer with amount
    [Arguments]  ${amount}

    go to  ${emanager}/cards/SmartPayAchTransfer.action?cardId=${cardID}
    Wait Until Element Is Visible  xpath=//*[@id='addTransfer']
    input text  amount  ${amount}
    click button  addTransfer
    page should contain  text=Successfully Added Transfer with Amount
    Run the perl script  AchCreateFile.sh
    reload page
    tch logging  ACH sent

Logout and then back into the SmartFunds account through eManager with
    [Arguments]  ${CardNu}  ${CardNu_pin}

    Log out of eManager
    Log into eManager  ${CardNu}  ${CardNu_pin}

Teardown

    Open eManager  ${CardNu}  ${CardNu_pin}
    Delete SmartFunds Transfer Account  ${Routing_Num}