*** Settings ***


Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Suite Setup  Time to Setup
Suite Teardown  Time to Teardown

Force Tags  eManager

*** Variables ***
${Carrier2}=  106007
${carrierPass}=  KBH123
${location}=   231010
${mon_code}

*** Test Cases ***
Test Error Issue to Required
    [Tags]  JIRA:QAT-236  JIRA:QAT-235  JIRA:QAT-234  JIRA:BOT-426  qTest:28837355  Regression
    [Setup]  go to issue money code screen
    wait until element is visible  //table[@id='infoList']//td[contains(text(),'No data available in table')]
    click element  xpath=//*[@name='submit']
    page should contain element  xpath=//*[contains(text(),'Issue To: is a required field')]

Leave Amount At 0.00
    [Tags]  JIRA:BOT-426  qTest:28837352  Regression  refactor
    [Setup]  go to issue money code screen
    wait until element is visible  //table[@id='infoList']//td[contains(text(),'No data available in table')]
    create moneycode  0.00  Hi  Test 0 dollars
    validate amount less than 1 dollar

Test Negative Amount
    [Tags]  JIRA:BOT-426  qTest:28837351  Regression
    [Setup]  go to issue money code screen
    create moneycode  -2.00  Maneee  Test Negative Amount
    validate amount less than 1 dollar

Test Amount > 9999.99
    [Tags]  JIRA:BOT-426  qTest:28837350  Regression
    [Setup]  run keywords  go to issue money code screen  Update max_money_code
    create moneycode  10000.00  Hi  Test Max Field
    validate amount greater than 9999.99

Money Code Issue with Special Character
    [Tags]  JIRA:BOT-273  Moneycodes  Money Codes  deprecated
    [Documentation]  Testing ability for moneycodes to use certain characters in the notes section
    [Setup]  go to issue money code screen
    create moneycode  1  Bob  & ( ) @ # : $ * / . , + - = ~ ' |
    element should be visible  xpath=//*[@class="messages"]  Applied successfully

Money Code Not Allow ; ! % ^ " ` { } [ ] ? < > \
    [Tags]  JIRA:BOT-273  Moneycodes  Money Codes
    [Documentation]  Testing the denial of certain characters in moneycodes
    [Setup]  go to issue money code screen

    @{charList}=  create list   &  ;  !  %  ^  "  `  {  }  [  ]  ?  <  >  \

    FOR  ${character}  IN  @{charList}
      log to console  ${character}
      Money Code Denial Character Test  ${character}
   END

    go to  ${emanager}/cards/MoneyCodeManagement.action

Test Valid Moneycode
    [Tags]  JIRA:QAT-238  qTest:32311821
    [Setup]  go to issue money code screen
    create moneycode  33  Golddigger  Testing
    validate moneycode

Test Void Moneycode
    [Tags]  JIRA:QAT-749  qTest:28837362  Regression  BUGGED: When Voiding A Money Code Through Emanager A Numbered Error Is Presented [ STAGE env]
    [Setup]  go to issue money code screen
    void moneycode
    validate moneycode was voided
    [Teardown]  run keyword if test failed  Selenium Failure

Check Deduct Fee
    [Tags]  JIRA:BOT-426  JIRA:BOT-578  qTest:28837356  qTest:28837357  qTest:28837361  Regression
    [Setup]  go to issue money code screen
    Set Test Variable  ${amount}  50.00
    ${check_fee}  Query And Strip  SELECT check_fee FROM contract WHERE carrier_id=${carrier.id} AND contract_id=${contract_id}
    ${Deduct_Fee}  Evaluate  ${amount} - ${check_fee}
#    Go To  ${emanager}/cards/MoneyCodeManagement.action
    ${contID}  Convert To String  ${contract_id}
    Sleep  2
    Select From List By Value  //*[@name="moneyCode.contractId"]  ${contID}
    Input Text  moneyCode.amount  ${amount}
    Input Text  moneyCode.issuedTo  Meowdy
    Input Text  moneyCode.notes  PurrFeect
    Click Element  name=moneyCode.deductFees
    Click Button  submit
    Wait Until Element Is Visible  //*[contains(text(),'Money Transfer code')]/*[1]
    ${mon_code}  Get Text  //*[contains(text(),'Money Transfer code')]/*[1]
    ${AvailableAmount}  Get Text  //*[contains(text(), '${Deduct_Fee}')]
    Should Not Be Empty  ${AvailableAmount}
    Set Suite Variable  ${mon_code}
    validate deduct fee

Authorize Money Code with Deduct Fee
    [Tags]  qTest:2883736110  refactor
    [Documentation]  Make sure that the amount used is equal to the amount authorized + the fee amount.
    ...     The fee_amount should be added to the amount_used per use.

    Set Test Variable  ${DB}  TCH

#    Connect SSH  ${sshHost}  ${sshName}  ${sshPass}
    Go Sudo
    ${date}  getdatetimenow  %Y%m%d%H%M%S
    ${MONTH}  getdatetimenow  %m
    ${log_dir}  catenate
    ...  /home/qaauto/el_robot/authStrings/rossAuthLogs/rossAuth/${MONTH}
    Run Command  if [ ! -d ${log_dir} ];then mkdir -p ${log_dir};fi
    Run Command  find ${log_dir} -type f -name '*' -mtime +365 -exec rm {} \\;
    Set Test Variable  ${logfile}  ${log_dir}/${SUITE NAME.replace(' ','_')}_${TEST NAME.replace(' ', '_')}_${date}
    Set Suite Variable  ${logfile}

    ${AM}  Create AM String  ${DB}  ${location}  ${mon_code}  ULSD=40
    run rossAuth  ${AM}  ${logfile}.log

    ${MonCodeInfo}  Query And Strip To Dictionary  SELECT fee_amount, original_amt, amt_used FROM mon_codes where express_code=${mon_code}

    ${FinalAmount}  Evaluate  40 + ${MonCodeInfo['fee_amount']}
    Should Be Equal As Numbers  ${FinalAmount}  ${MonCodeInfo['amt_used']}

Deduct_fees flag in mon_codes should not change after use
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  If you issue a moneycode with the deduct fees, before it is used it will show in the mon_codes table
    ...  "Y", which is correct. But after you use part of the moneycode and get an auth, if you go back to the mon_codes
    ...  table it will say "N" for deduct_fees...which is incorrect. It should still have a "Y" for the deduct_fees.
    ...  After authorizing the money code the fee should be deducted from the code amount.
    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${amount}  20.00

    ${contract_info}   catenate  SELECT credit_limit, contract_id FROM contract WHERE carrier_id=${Carrier2}
    ${InfoResults}  Query And Strip To Dictionary  ${contract_info}

    Set Suite Variable  ${InfoResults['credit_limit'][0]}
    Set Suite Variable  ${InfoResults['contract_id'][0]}

    execute sql string  dml=update contract SET credit_limit = 150 WHERE contract_id = ${InfoResults['contract_id'][0]}

    #CONNECT EVERYTHING
#    connect ssh  ${sshHost}  ${sshName}  ${sshPass}
    Get Into DB  ${DB}
    go sudo
    ${logfile}  Create Log File
    Set Test Variable  ${logfile}

    tch logging  RUN A TRANSACTION FOR MONEY CODE ${mon_code}

    ${AM}=  Create AM String  ${DB}  ${location}  ${mon_code}  ULSD=${amount}
    run rossAuth  ${AM}  ${logfile}.log

    ${query}=  catenate
    ...     row count is equal to x  SELECT * FROM checks WHERE code = ${mon_code}  1
    Tch Logging  TRANSACTION SUCCESSFUL!
    ${flag}=  query and strip  select deduct_fees from mon_codes where express_code = ${mon_code}
    should be equal as strings  ${flag}  Y
    Tch Logging  DEDUCT_FEES IS ${flag}

    [Teardown]  Run Keywords  Get Into DB  TCH
    ...     AND   execute sql string  dml=update contract SET credit_limit = ${InfoResults['credit_limit'][0]} WHERE contract_id = ${InfoResults['contract_id'][0]}
    ...     AND   Disconnect From Database
    ...     AND   Tch Logging  TEARDOWN SUCCESSFUL!

Newly Created Codes will show under View Money Code History
    [Documentation]  Make sure that newly created money codes will show up at the Money Code History Screen
    [Tags]  JIRA:BOT-1437  qTest:28837362  Regression
    [Setup]  go to issue money code screen
    Go To  ${emanager}/cards/MoneyCodesHistory.action?roleState=VIEWMONEYCODEHISTORY
    Click Button  lookupHistory
    Page Should Contain Element  //*[contains(text(),'Money codes History Information')]
    Page Should Contain Element  //*[contains(text(),'${mon_code}')]

Leave Deduct Fee Unchecked
    [Tags]  JIRA:BOT-426  qTest:28837358  Regression
    [Setup]  go to issue money code screen
    create moneycode  50.00  Hi  Testing Fee
    validate moneycode
    validate fee not in DB

Money Codes Notes 30 Character Max
    [Tags]  JIRA:BOT-558  qTest:28837359  Regression  qTest:28837360
    [Documentation]  Validate that the notes edit box will only contain 30 characters
    [Setup]  go to issue money code screen
    #OPENING EMANAGER AND ISSUING MONEY CODE
    Go To  ${emanager}/cards/MoneyCodeManagement.action
    ${notes}  Generate Random String  31  [NUMBERS]
    create moneycode  100  MaxNoteMonCode  ${notes}
    #GETTING INFO FROM THE SCREEN
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'Money Transfer code ')]
    ${mon_code}   get text  //*[@class="messages"]//parent::li//descendant::*[1]
    ${reference}  get text  //*[@class="messages"]//parent::li//descendant::*[3]
    ${monCodeNotes}  get text  //*[@class="messages"]//parent::li//descendant::*[9]

    Tch Logging  MONEY CODE:${mon_code}
    Tch Logging  REFERENCE#:${reference}
    Tch Logging  NOTES:${monCodeNotes}

    #GETTING INTO DB TO CHECK IF THE MONEY CODE RECORD IS THERE
    ${moncode_query}  catenate  SELECT express_code, notes FROM mon_codes WHERE code_id=${reference}
    ${moncode_result}  Query And Strip To Dictionary  ${moncode_query}
    Should Be Equal As Strings  ${moncode_result['express_code']}  ${mon_code}
    Should Be Equal As Strings  ${moncode_result['notes']}  ${monCodeNotes}

Issue Moneycode with Prompt
    [Tags]  BOT:1428  qTest:28837353  Regression  qTest:28837354
    [Documentation]  It should be possible to issue a money code with prompt.
    [Setup]  go to issue money code screen
    ${DRID}  Generate Random String  4  [NUMBERS]

    wait until element is visible  //table[@id='infoList']//td[contains(text(),'No data available in table')]
    Input Text    moneyCode.amount  100
    Input Text    moneyCode.issuedTo  Automation
    Input Text    moneyCode.notes  In A Nutshell
    Click Button  addInfoBtn
    Select From List By Value  infoSelect  DRID
    Click Button  OK
    Input Text  infoValDRID  ${DRID}
    Click Button  submitId
    ${mon_code}=  get text  //*[contains(text(),'Money Transfer code')]/*[1]
    Get Into DB  TCH
    ${query}  catenate  SELECT mi.info_id as info_id, mi.code_validation as code_validation FROM mon_codes mc, mon_codes_info mi WHERE mc.code_id=mi.money_code_id AND mc.express_code=${mon_code};
    ${PromptValues}  Query And Strip To Dictionary  ${query}

    Should Be Equal As Strings  ${PromptValues['info_id']}  DRID
    Should Be Equal As Strings  ${PromptValues['code_validation']}  Z${DRID}

    [Teardown]  Close Browser


*** Keywords ***
Time to Setup
    get into db  TCH

    ${query}  Catenate  SELECT distinct(contract_id) AS contract_id
    ...  FROM mon_codes WHERE contract_id != 0
    ...  AND created > TODAY - 60
    ...  AND issuer_id NOT IN ('185007','140186','100000','140187','118897')  # Need to Know what makes a contract to be able to issue money codes.
    ...  LIMIT 100

    ${myList}  Query And Strip To Dictionary  ${query}
    ${contract_id}  Evaluate  random.choice(${myList['contract_id']})  random
    Set Suite Variable  ${contract_id}
    ${carrier}  Query And Strip  SELECT carrier_id FROM contract WHERE contract_id = ${contract_id}
    ${carrier}  Set Carrier Variable  ${carrier}
    Set Suite Variable  ${carrier}
    Add User Role If Not Exists  ${carrier.id}  ALLOW_MONEY_CODE_DEDUCTFEES
    Open eManager  ${carrier.id}  ${carrier.password}

Time to Teardown

    Disconnect From Database

Money Code Denial Character Test
    [Arguments]  ${character}
    go to  ${emanager}/cards/MoneyCodeManagement.action
    input text  xpath=//*[@name='moneyCode.amount']  1
    input text  xpath=//*[@name='moneyCode.issuedTo']  Bob
    input text  xpath=//*[@name='moneyCode.notes']  ${character}
    sleep  1
    ${status}=  run keyword and return status  Element Should Be Visible  xpath=//*[@id="legAlerts_popup_ok"]
    run keyword if  '${status}'=='${True}'
    ...  click element  xpath=//*[@id="legAlerts_popup_ok"]
    ...  ELSE  click element  xpath=//*[@name='submit']

go to issue money code screen
    go to  ${emanager}/cards/MoneyCodeManagement.action

Run selenium Failure and close browser
    Selenium Failure
    close browser

Update max_money_code
    execute sql string  dml=update cont_misc SET max_money_code = 9999 WHERE contract_id = ${contract_id};

Create Moneycode
    [Arguments]  ${amount}  ${issuedTo}  ${notes}
    input text  xpath=//*[@name='moneyCode.amount']  ${amount}
    input text  xpath=//*[@name='moneyCode.issuedTo']  ${issuedTo}
    input text  xpath=//*[@name='moneyCode.notes']  ${notes}
    click element  xpath=//*[@name='submit']

validate moneycode
    wait until element is visible  //*[contains(text(),'Money Transfer code')]/*[1]
    ${mon_code}=  get text  //*[contains(text(),'Money Transfer code')]/*[1]
    set global variable  ${monCode}
    get into db  TCH
    row count is greater than x  select express_code from mon_codes where express_code = ${monCode}  0

Void Moneycode
    click element  history
    click element  mcChecked
    input text  moneyCode  ${monCode}
    click element  lookupHistory
    click button  removeCard
    sleep  2
    click element  voidMoneyCode

Validate Moneycode was Voided
    ${voided} =  query and strip  select voided from mon_codes where express_code = ${monCode}
    should be equal as strings  ${voided}  Y

Validate Amount Less Than 1 Dollar
    wait until element is visible  xpath=//*[contains(text(),'Funded Amount: must be no less than 1')]  10  Could not find message "Funded Amount: must be no less than 1"
    page should contain element  xpath=//*[contains(text(),'Funded Amount: must be no less than 1')]

Validate Amount Greater Than 9999.99
    wait until element is visible  xpath=//*[contains(text(),'Exceeded maximum money code amount $9,999')]
    page should contain element  xpath=//*[contains(text(),'Exceeded maximum money code amount $9,999')]

Validate Deduct Fee
    ${flag}=  query and strip  select deduct_fees from mon_codes where express_code = ${mon_code}
    should be equal as strings  ${flag}  Y

Validate Fee Not In DB
    ${flag}=  query and strip  select deduct_fees from mon_codes where express_code = ${mon_code}
    should be equal as strings  ${flag}  N
