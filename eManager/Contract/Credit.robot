*** Settings ***
Documentation  Checks the Emanager Credit Screen\n\n
    ...  All Test cases are interdependent, pay attention on this for future maintence
    ...  Imports: \n\n
    ...    Library    Process\n\n
    ...    \n\n
    ...    Library  otr_model_lib.services.GenericService\n\n
    ...    Library  Collections\n\n
    ...    Library  otr_robot_lib.support.PyLibrary\n\n
    ...    Library  otr_robot_lib.support.PyString\n\n
    ...    Library  otr_robot_lib.ui.web.PySelenium\n\n
    ...    Resource  ../../Variables/validUser.robot\n\n
    ...    Resource  otr_robot_lib/robot/RobotKeywords.robot\n\n
    ...    Resource  otr_robot_lib/robot/eManagerKeywords.robot\n\n
    ...    Resource  otr_robot_lib/robot/AuthKeywords.robot



Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ws.CardManagementWS
#Library  otr_robot_lib.support.pyString
#Library  otr_robot_lib.ssh.pySSH
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.auth.PyAuth.AuthLog
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Suite Setup  Time to Setup
Suite Teardown  Time To Tear Down

Force Tags  eManager

*** Variables ***

${status}
${translimit}
${originallimit}
${credavailable}
${dailyavailable}
${dailylimit}
${totalavailable}
${moncodelimit}
${Name}
${Phone}
${Email}
${card_num}
${transactionAmount}  100
${transactionId}
${location}

*** Test Cases ***

Select Contract on Available Credit
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1115  JIRA:BOT-1639  JIRA:BOT-1640  qTest:28846847  Regression
    [Documentation]  Select a contract on Select Program > Credit Management > Available Credit > Select Contract

    Navigate to Available Credit Screen and Select Contract
    Check if Credit Information Load on Screen

Displayed Contract Information Is Correct
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1116  qTest:28846848  Regression
    [Documentation]  Check if contract credit information is diplayed correctly.
    Check if Contract Information is Correct

Validate Contract Credit Available with DB
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1118  qTest:28846850  Regression
    [Documentation]  Check if contract credit available match with DB information.
    Check Contract Credit Available with DB

Validate Contract Original Amount with DB
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1117  qTest:28846849  Regression    refactor
    [Documentation]  Check if contract original amount match with DB information.
    Check Contract Original Amount with DB
    #Values usually doesnt match

Validate Contract Daily Limit with DB
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1119  qTest:28846851  Regression    refactor
    [Documentation]  Check if contract dailyl limit match with DB information.
    Check Contract Daily Limit with DB
    #Values usually doesnt appear on contract page

Validate Contract Daily Available with DB
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1440  qTest:28846852  Regression
    [Documentation]  Check if contract daily available match with DB information.
    Check Contract Daily Available with DB

Validate Contract Total Available with DB
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1120  qTest:28846853  Regression
    [Documentation]  Check if contract total available match with DB information.
    Check Contract Total Available with DB

Validate Contract Maximum Money Code with DB
    [Tags]  JIRA:BOT-428  JIRA:BOT-783  JIRA:BOT-1121  qTest:28846854  Regression
    [Documentation]  Check if contract maximum money code match with DB information.
    Check Contract Maximum Money Code with DB

Run a Transaction and Check if Information Updates on Contract
    [Tags]  JIRA:BOT-428  JIRA:BOT-1122  qTest:28846855  Regression  Tier:0  refactor
    [Documentation]  Run a transaction to Verify if display info updates on Available Credit.
    Run a Transaction
    Check with DB if Contract Info Will Reflect Informations

Select All Contracts For a Carrier
    [Tags]  JIRA:BOT-1641  qTest:28937063  Regression  refactor
    [Documentation]  Select all contracts of your test carrier that has 2 or more contracts.
    Switch Contracts and Check for Validation
#-------------------------------------------------------TIER:0 TEST CASES---------------------------------------------------------------------------
Issue A Money Code Above The Maximum Money Code Limit
    [Tags]  Tier:0  refactor
    [Documentation]  Test case designed to make sure we're helding to out credit limit.
    ...     It shouldn't be possible to issue a mon code above the maximum mon code limit.

    Get Into DB  TCH

    ${results}  Query And Strip To Dictionary  SELECT TRIM(TO_CHAR(max_money_code,'<<<,<<#,###')) AS MaxMoneyCode, max_money_code FROM contract c, cont_misc cm WHERE c.contract_id = ${card_num.policy.contract.id} AND c.contract_id = cm.contract_id
    ${amount}  Set Variable IF  ${results['max_money_code']} <= 9999  ${results['maxmoneycode']}  9,999

    Open eManager  ${card_num.carrier.id}  ${card_num.carrier.password}  alias=2nd
    Go To  ${emanager}/cards/MoneyCodeManagement.action
    Select From List By Value  moneyCode.contractId  ${card_num.policy.contract.id.__str__()}

    ${MaxMonCode}  Evaluate  ${results['max_money_code']}+100

    Input Text  moneyCode.amount  ${MaxMonCode}
    Input Text  moneyCode.issuedTo  THIS IS
    Input Text  moneyCode.notes  SUPPOSED TO FAIL
    Click Element  submitId

    Page Should Contain  Exceeded maximum money code amount $${amount}
    [Teardown]  Close Browser

Run A Money Code Transaction With a TOTL Above The Money Code Value
    [Tags]  Tier:0  refactor

    Get Into DB  TCH
    ${date}  getDateTimeNow  %m%d%H%M%S
    ${MON_CODE}  issueMoneyCode  ${card_num.policy.contract.id}  100.00  ThisShouldFail

    ${AM}  create AM string  TCH  231010  ${MON_CODE}  ULSD=101
    ${filepath}  Create Log File  Credit  CreditTransactionMonCode
    Run RossAuth  ${AM}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  MAX AMOUNT EXCEEDED

Authorize Money Code With Closed Contract
    [Tags]  Tier:0  refactor
    [Documentation]  It shouldnt be possible to authorize a money code when the contract status attached to it is C (CLOSED)

    ${bill_on_issue}  assign string  ${card_num.policy.contract.bill_on_issue}
    execute sql string  dml=update contract SET mcode_bill_on_issue = 'N' WHERE contract_id =${card_num.policy.contract.id}

    ${date}  getDateTimeNow  %m%d%H%M%S
    ${MON_CODE}  issueMoneyCode  ${card_num.policy.contract.id}  100.00  ThisShouldFail

    ${status}  assign string  ${card_num.policy.contract.status}
    execute sql string  dml=update contract SET status = 'C' WHERE contract_id =${card_num.policy.contract.id}

    log to console  Contract Status is: ${card_num.policy.contract.status}
    log to console  Bill On Issue is: ${card_num.policy.contract.bill_on_issue}

    ${AM}  create AM string  TCH  231010  ${MON_CODE}  ULSD=100
    ${filepath}  Create Log File  Credit  CreditTransactionMonCode
    Run RossAuth  ${AM}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Auth Log Should Contain Error  BAD CONTRACT ID

    [Teardown]  Run Keywords  Get Into DB  TCH
    ...  AND  execute sql string  dml=update contract SET status = '${status}',mcode_bill_on_issue='${bill_on_issue}' WHERE contract_id =${card_num.policy.contract.id}

Cannot Authorize A Money Code For Less Than The Full Amount
    [Tags]  Tier:0  refactor
    [Documentation]  It's only possible to authorize the money code for the full amount

    ${date}  getDateTimeNow  %m%d%H%M%S
    ${MON_CODE}  issueMoneyCode  ${card_num.policy.contract.id}  100.00  ThisShouldFail

    ${exactAmt}  Query And Strip  SELECT exact_amt_codes FROM cont_misc WHERE contract_id=${card_num.policy.contract.id}
    execute sql string  dml=update cont_misc SET exact_amt_codes = 'Y' WHERE contract_id=${card_num.policy.contract.id}

    ${AM}  create AM string  TCH  231010  ${MON_CODE}  ULSD=48.00
    ${filepath}  Create Log File  Credit  CreditTransactionMonCode
    Run RossAuth  ${AM}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  MUST BE EXACT AMOUNT

    [Teardown]  Run Keywords  Get Into DB  TCH
    ...     AND  execute sql string  dml=update cont_misc SET exact_amt_codes = '${exactAmt}' WHERE contract_id=${card_num.policy.contract.id}

Cannot Authorize An Inactive Money Code
    [Tags]  Tier:0  refactor
    [Documentation]  It's not possible to authorize an inactive money code

    ${date}  getDateTimeNow  %m%d%H%M%S
    ${InactiveMonCode}  Query And Strip  SELECT express_code FROM mon_codes WHERE status='I' AND voided='N' AND CHAR_LENGTH(TRIM(express_code)) >= 10 ORDER BY created DESC limit 1
    ${AM}  create AM string  TCH  231010  ${InactiveMonCode}  ULSD=5.00
    ${filepath}  Create Log File  Credit  CreditTransactionMonCode
    Run RossAuth  ${AM}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  INACTIVE MONEY CODE

Exceed the Contract Transaction Limit Through A Transaction
    [Tags]  Tier:0  refactor
    [Documentation]  Test case designed to make sure we're helding to out credit limit.
    ...     It shouldn't be possible to run a transaction above the Transaction Limit.
    [Setup]  Setup card limits  OIL=200  WASH=200

    ${date}  getDateTimeNow  %m%d%H%M%S

    Get Into DB  TCH
    ${LIMITS}  Query And Strip To Dictionary  SELECT trans_limit FROM contract WHERE carrier_id=${card_num.carrier.id} AND contract_id = ${card_num.policy.contract.id}
    execute sql string  dml=update contract SET trans_limit=250 WHERE contract_id = ${card_num.policy.contract.id}
    execute sql string  dml=update cont_misc SET credit_buffer=0 WHERE contract_id = ${card_num.policy.contract.id}
    loadCash  ${card_num.num}  820

    ${gallons}=  run keyword if  '${location.src_country}' == 'CAN'  assign string  400  ELSE  assign string  285

    start ac string
    set string location  ${location.id}
    set string card  ${card_num.num}
    use dynamic invoice
    use card's required prompts for string
    add merchandise item to string  OIL  5  140
    add merchandise item to string  CADV  1  210
    add merchandise item to string  WASH  1  100
#    add fuel by abbreviation to string  ULSD  2.50  ${GALLONS}
    calculate string total
    ${string}=  finalize string
    ${filepath}  Create Log File  Credit  CreditTransaction
    Run rossAuth  ${string}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  TRANSACTION LIMIT EXCEEDED


    [Teardown]  Run keywords  execute sql string  dml=update contract SET trans_limit=${LIMITS['trans_limit']} WHERE contract_id = ${card_num.policy.contract.id};
    ...         AND  Setup Card Limits  OIL=400  CADV=400  ULSD=900

Exceed By A Dollar The Non Fuel Item Transaction Amount
    [Tags]  Tier:0  refactor
    [Documentation]   Test case designed to make sure we're helding to out credit limit.
    ...     It shouldn't be possible to run a transaction above the limit set on the card.


    ${date}  getDateTimeNow  %m%d%H%M%S

    Get Into DB  TCH
    ${AC}  Create AC String  TCH  ${location.id}  ${card_num.num}  OIL=401
    ${filepath}  Create Log File  Credit  ExceedNonFuelLimit
    Run rossAuth  ${AC}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  OIL LIMIT EXCEEDED

Exceed The Fuel Item Transaction Amount
    [Tags]  Tier:0  refactor
    [Documentation]   Test case designed to make sure we're helding to out credit limit.
    ...  It shouldn't be possible to run a transaction above the limit set on the card.
    [Setup]  setup card limits  ULSD=500

    ${AC}  String Builder For Fuel  ${card_num.num}  231010  8192  1  1.00  600

    ${filepath}  Create Log File  Credit  CreditTransactionOverTheLimit
    Run rossAuth  ${AC}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  ULSD LIMIT EXCEEDED

    [Teardown]  setup card limits  ULSD=9999

Hit The Limit Buffer For The Transaction
    [Tags]  Tier:0  refactor
    [Documentation]   Test case designed to make sure we're helding to out credit limit.
    ...  It shouldn't be possible to run a transaction above contract.trans_limit AND above the limit set on the card.


    ${date}  getDateTimeNow  %m%d%H%M%S

    Get Into DB  TCH
    ${trans_limit}  Query And Strip  SELECT trans_limit FROM contract WHERE carrier_id=${card_num.carrier.id} AND contract_id = ${card_num.policy.contract.id}
    ${amount}  Evaluate  ${trans_limit}+1000

    ${AC}  Create AC String  TCH  ${location.id}  ${card_num.num}  ULSD=${amount}
    ${filepath}  Create Log File  Credit  CreditTransaction
    Run rossAuth  ${AC}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  FUEL LIMIT BUFFER EXCEEDED

Run A Transaction For An Item Not Allowed
    [Tags]  Tier:0  refactor
    [Documentation]   Test case designed to make sure we're helding to out credit limit.
    ...  It shouldn't be possible to run a transaction using a limit that's not set up on a card

    ${AC}  Create AC String  TCH  ${location.id}  ${card_num.num}  DELI=300
    ${filepath}  Create Log File  Credit  CreditTransaction
    Run rossAuth  ${AC}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error  ITEM NOT ALLOWED

Run A Transaction To Get The Minimum Fuel Purchase Required For CADV
    [Tags]  FIRE  BUGGED: cadv_req_fuel isnt being checked on preauth [OBI-1058]  refactor
    [Documentation]   Test case designed to make sure we're helding to out credit limit.
    ...  It shouldn't be possible to run a transaction for CADV without purchasing a Fuel Item.


    ${date}  getDateTimeNow  %m%d%H%M%S

#   CHANGE THE cadv_req_fuel AND cadv_min_fuel SO THE CARD HAS A MINIMUM FUEL PURCHASE REQUIRED | REMOVE ALL THE CARD BALANCE
    ${MinFuelBackup}  Query And Strip To Dictionary  SELECT cadv_req_fuel,cadv_min_fuel FROM cards WHERE card_num='${card_num.num}'
    Tch Logging  \n MIN FUEL BACKUP:${MinFuelBackup}
    ${req_fuel}  Set Variable IF  '${MinFuelBackup.cadv_req_fuel}'=='None'  NULL  '${MinFuelBackup.cadv_req_fuel}'
    ${cadv_min_fuel}  Set Variable IF  '${MinFuelBackup.cadv_min_fuel}'=='None'  NULL  ${MinFuelBackup.cadv_min_fuel}

    Update Contract Limits By Card  ${card_num.num}
    Setup Card Contract  velocity_enabled=N

    execute sql string  dml=update cards SET cadv_req_fuel='Y', cadv_min_fuel=150 WHERE card_num='${card_num.num}'
    ${MinFuelBackup}  Query And Strip To Dictionary  SELECT cadv_req_fuel, cadv_min_fuel FROM cards WHERE card_num='${card_num.num}'

    ${balance}  Query And Strip  SELECT balance FROM cash_adv WHERE card_num='${card_num.num}' ORDER BY cash_adv_id DESC limit 1
    loadCash  ${card_num.num}  -${balance}

    ${balance}  Query And Strip  SELECT balance FROM cash_adv WHERE card_num='${card_num.num}' ORDER BY cash_adv_id DESC limit 1

#   RUN A TRANSACTION ONLY FOR CADV SO THE LOG SHOWS THAT YOU NEED TO PURCHASE THE MINIMUM FUEL
    ${AC}  String Builder For Non-Fuel  ${card_num.num}  231010  CADV  1  100
    ${filepath}  Create Log File  Credit  CreditTransactionMinimun
    Run rossAuth  ${AC}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error   Minimum Fuel Purchase Required

    [Teardown]  Run Keywords  Get Into DB  TCH
    ...     AND  execute sql string  dml=update cards SET cadv_req_fuel=${req_fuel},cadv_min_fuel=${cadv_min_fuel} WHERE card_num='${card_num.num}'
    ...    AND  loadCash  ${card_num.num}  9999

Run A Transaction For 0 Dollars
    [Tags]  Tier:0  refactor
    [Documentation]   Test case designed to make sure we're helding to out credit limit.
    ...  It shouldn't be possible to run a transaction for 0.00.


    ${date}  getDateTimeNow  %m%d%H%M%S
    ${AC}  Create AC String  TCH  ${location.id}  ${card_num.num}  ULSD=0.00
    ${filepath}  Create Log File  Credit  CreditTransaction
    Run rossAuth  ${AC}  ${filepath}
    Set Log File  ${filepath}  remote=${True}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error   AMOUNT IS INVALID

Hit The Daily Amount For Transactions
    [Tags]  Tier:0  refactor

    ${date}  getDateTimeNow  %m%d%H%M%S
    ${TODAY}=  getdatetimenow  %Y-%m-%d

    ${RefLimits}  Query And Strip To Dictionary  SELECT day_cnt_limit, day_amt_limit,velsrc FROM cards WHERE card_num='${card_num.num}'

    ${RefLimits['day_cnt_limit']}  Set Variable If  ${RefLimits['day_cnt_limit']} is ${None}  null  ${RefLimits['day_cnt_limit']}
    ${RefLimits['day_amt_limit']}  Set Variable If  ${RefLimits['day_amt_limit']} is ${None}  null  ${RefLimits['day_amt_limit']}
#    run keyword if  ${RefLimits['day_amt_limit']} is ${None}  Set Variable  RefLimits['day_amt_limit'] = 'null'

    ${velUsage}  Query And Strip To Dictionary  SELECT day_cnt, last_updated FROM velocity_usage WHERE card_num='${card_num.num}'
    ${velEnable}=  assign string  ${card_num.policy.contract.velocity_enable}

    execute sql string  dml=update cards SET day_cnt_limit=1, velsrc='C', day_amt_limit=100 WHERE card_num='${card_num.num}'
    execute sql string  dml=update velocity_usage SET day_cnt=1,last_updated='${TODAY}' WHERE card_num='${card_num.num}'
    execute sql string  dml=update contract SET velocity_enable='Y' WHERE contract_id='${card_num.policy.contract.id}'

    ${AC}  Create AC String  TCH  ${location.id}  ${card_num.num}  ULSD=200
    ${filepath}  Create Log File  Credit  CreditTransaction
    Run rossAuth  ${AC}  ${filepath}
    Set Log File  ${filepath}
    Log Should Not Have A Trans ID
    Auth Log Should Contain Error   DAILY TRANSACTION LIMIT EXCEEDED

    [Teardown]  Run Keywords  Get Into DB  TCH
    ...  AND  execute sql string  dml=update cards SET day_cnt_limit=${RefLimits['day_cnt_limit']},day_amt_limit=${RefLimits['day_amt_limit']} WHERE card_num='${card_num.num}'
    ...  AND  execute sql string  dml=update velocity_usage SET day_cnt=${velUsage['day_cnt']}, last_updated='${velUsage['last_updated']}' WHERE card_num='${card_num.num}'
    ...  AND  execute sql string  dml=update contract SET velocity_enable='${velEnable}' WHERE contract_id = ${card_num.policy.contract.id}

*** Keywords ***
Strip Money Text
    [Arguments]  ${moneyString}

   ${moneyString}=  remove from string  USD  ${moneyString}
   ${moneyString}=  remove from string  ,  ${moneyString}
   ${moneyString}=  remove from string  $  ${moneyString}
   ${moneyString}=  remove from string  ${SPACE}  ${moneyString}
   ${moneyString}=  remove trailing spaces  ${moneyString}
   ${moneyString}=  run keyword if  '${moneyString}' == '.00'  assign string  0  ELSE  assign string  ${moneyString}

    [Return]  ${moneyString}

Time to Setup

    ${cardSql}=  catenate  select cd.card_num from cards cd
    ...  left join def_card dc
    ...      on cd.icardpolicy = dc.ipolicy
    ...      and dc.id = cd.carrier_id
    ...  right join contract c
    ...      on c.contract_id = dc.contract_id
    ...  left join cont_misc cm on cm.contract_id = c.contract_id
    ...  where cd.last_used > TODAY - 90
    ...  and cd.status = 'A'
    ...  and length(cd.card_num) >= 16
    ...  and c.limit_method = 3
    ...  and cd.card_num not like '%OVER'
    ...  and cm.max_money_code > 100
    ...  and c.status = 'A'
    ...  and c.carrier_id NOT IN ('185643','101680')    #bad carrier, wrong configuration
    ...  and cd.carrier_id NOT IN ('185643')    #crazy!!! contract carrier is different from card carrier, who knows!!!
    ...  and CAST(c.carrier_id AS VARCHAR(6)) NOT LIKE '14%';
    ...  and cd.carrier_id not in (select mcii.carrier_id as carrier_id from mon_code_issue_info mcii where mcii.reqd_flag = 'Y')

    ${card_num}  find card variable  ${cardSql}
    Set Suite Variable  ${card_num}
    set suite variable  ${location}  ${card_num.valid_location.id}

    Start Setup Card  ${card_num.num}
    Setup Card Header  limitSource=CARD  status=ACTIVE
    Setup Card Prompts  DRID=V1234  UNIT=V1234  ODRD=V1234
    Setup Card Limits  OIL=400  CADV=400  ULSD=900

    Log Into Card Management Web Services  ${card_num.carrier.member_id}  ${card_num.carrier.password}

    Get Into DB  TCH
#    REMOVE THE DIRECT BILL RECORD FOR THIS CARRIER SO THE BASIC TRANSACTIONS DOESNT PASS WHEN ITS SUPPOSED TO FAIL
    ${DIR_BILL}  Query And Strip To Dictionary  SELECT * FROM direct_bills WHERE carrier_id = ${card_num.carrier.id} AND supplier_id = '139855' ORDER BY effective_date DESC
    ${status}  Run Keyword And Return Status  Should Be Empty  ${DIR_BILL}
    Run Keyword IF  '${status}'=='${false}'  execute sql string  dml=delete FROM direct_bills WHERE carrier_id=${card_num.carrier.id} AND contract_id =${card_num.policy.contract.id}
    ...     ELSE  Tch Logging  STARTING UP

    ensure not using secondary contract  ${card_num.policy.contract.id}

    Open eManager  ${card_num.carrier.id}  ${card_num.carrier.password}
    Navigate to Available Credit Screen and Select Contract
    Check if Credit Information Load on Screen

String Builder For Fuel
    [Arguments]  ${card_number}  ${location}  ${fuel_item}  ${fuel_use}  ${ppu}  ${gallons}
    Start AC String
    Use Dynamic Invoice
    Set String Card  ${card_number}
    Set String Location  ${location}
    Use Card's Required Prompts For String
    Add Fuel Item To String  ${fuel_item}  ${fuel_use}  ${ppu}  ${gallons}
#    add fuel by abbreviation to string
    Calculate String Total
    ${AC}  Finalize String
    [Return]  ${AC}

String Builder For Non-Fuel
    [Arguments]  ${card_number}  ${location}  ${non_fuel_item}  ${qty}  ${amount}
    Start AC String
    Use Dynamic Invoice
    Set String Card  ${card_number}
    Set String Location  ${location}
    Use Card's Required Prompts For String
    Add Merchandise Item To String  ${non_fuel_item}  ${qty}  ${amount}
    Calculate String Total
    ${AC}  Finalize String
    [Return]  ${AC}

Run a Transaction
    [Documentation]  Keyword That Supports *Run a Transaction and Check if Information Updates on Contract* and Run
    ...  a Transaction for Future Verification.

    #Define log file path and run an AC Transaction
    ${TODAY}  getdatetimenow
    ${filepath}  Create Log File  Credit  CreditTransaction${TODAY}
    ${ac_string}  Create AC String  TCH  231010  ${card_num.num}  ULSD=${transactionAmount}
    Run rossAuth  ${acString}  ${filepath}
    ${transactionId}  Get Transaction ID From Log File  ${filepath}
    Set Suite Variable  ${transactionId}

Check with DB if Contract Info Will Reflect Informations
    [Documentation]  Validate Total Available in Screen and Database.

#   GRAB CARRIER FEE FOR EVALUATION
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT carrier_fee
    ...  FROM contract WHERE contract_id = ${card_num.policy.contract.id}
    ${carrierfee}  query and strip  ${query}

#    GET THE CARRIER FEE FROM THE TRANSACTION TABLE
    ${carr_fee}  Query And Strip  SELECT carr_fee FROM transaction WHERE trans_id=${transactionId}

#   EVALUATE TOTAL AVAILABLE AFTER TRANSACTION
    ${totalafterTransaction}  evaluate  ${totalavailable} - ${transactionAmount} - ${carr_fee}

#   SELECT THE SOURCE OF TOTAL AVAILABLE
    Run Keyword If  ${credavailable} < ${dailyavailable}
    ...  Total Available as Credit Available
    ...  ELSE  Total Available as Daily Available

    Should Be Equal as Numbers  ${newTotalAvailable}  ${totalafterTransaction}

#   GRAB TOTAL AVAILABLE FROM CREDIT AVAILABLE SCREEN
    Navigate to Available Credit Screen and Select Contract
    ${finalTotalAvailable}  get text  //*[@for='credit.jsp.totalAvailable']/parent::td/parent::tr/td[3]/font
    ${finalTotalAvailable}  strip money text  ${finalTotalAvailable}

    Should Be Equal as Numbers  ${newTotalAvailable}  ${finalTotalAvailable}

Time To Tear Down
    Close All Browsers
#    restore secondary contract data  ${card_num.policy.contract.id}

Total Available as Credit Available
    [Documentation]  Keyword support for *Check with DB if Contract Info Will Reflect Informations* Keyword.

    #Set Total Available = Credit Available
    ${query}  Catenate
    ...  SELECT credit_limit - credit_bal AS CreditAvailable
    ...  FROM contract WHERE contract_id = ${card_num.policy.contract.id}
    ${newTotalAvailable}  Query And Strip  ${query}
    Set Suite Variable   ${newTotalAvailable}

Total Available as Daily Available
    [Documentation]  Keyword support for *Check with DB if Contract Info Will Reflect Informations* Keyword.

    #Set Total Available = DailyAvailable
    ${query}  Catenate
    ...  SELECT daily_limit - daily_bal AS DailyAvailable
    ...  FROM contract WHERE contract_id = ${card_num.policy.contract.id}
    ${newTotalAvailable}  Query And Strip  ${query}
    Set Suite Variable   ${newTotalAvailable}

Navigate to Available Credit Screen and Select Contract
    [Documentation]  Navigates to Credit Screen and Select a Contract.

    Go To  ${emanager}/cards/Credit.action
    Select From List By Value  selectContractId  ${card_num.policy.contract.id.__str__()}
    Wait Until Element Is Visible  //*[@for='credit.jsp.totalAvailable']

Check if Credit Information Load on Screen
    [Documentation]  Grabs All the Information on The Credit Screen to Validate that it's

    Wait Until Element Is Visible  //*[@for='credit.jsp.status']/parent::td/parent::tr
    ${status}=  get text  //*[@for='credit.jsp.status']/parent::td/parent::tr/td[2]
    ${translimit}=  get text  //*[@for='transLimit']/parent::td/parent::tr/td[3]
    ${originallimit}=  get text  //*[@for='creditLimits.origLimit']/parent::td/parent::tr/td[3]
    ${credavailable}=  get text  //*[@for='credit.jsp.creditAvailable']/parent::td/parent::tr/td[3]
    #${dailylimit}=  get text  //*[@for='creditLimits.dailyLimit']/parent::td/parent::tr/td[3]
    ${dailyavailable}=  get text  //*[@for='credit.jsp.dailyAvailable']/parent::td/parent::tr/td[3]
    ${totalavailable}=  get text  //*[@for='credit.jsp.totalAvailable']/parent::td/parent::tr/td[3]/font
    ${moncodelimit}=  get text  //*[@for='creditLimits.maxMoneyCode']/parent::td/parent::tr/td[3]

    ${Name}=  get text  //*[@for="creditLimits.mgrName"]/parent::td/parent::tr/td[2]
    ${Phone}=  get text  //*[@for="creditLimits.mgrPhone"]/parent::td/parent::tr/td[2]
    ${Email}=  get text  //*[@for="creditLimits.mgrEmail"]/parent::td/parent::tr/td[2]

    ${status}=  get first character  ${status}
    ${translimit}=  strip money text  ${translimit}
    ${translimit}=  remove from string  .00  ${translimit}
    ${originallimit}=  strip money text  ${originallimit}
    ${credavailable}=  strip money text  ${credavailable}
    ${dailylimit}=  strip money text  ${dailylimit}
    ${dailyavailable}=  strip money text  ${dailyavailable}
    ${totalavailable}=  strip money text  ${totalavailable}
    ${moncodelimit}=  strip money text  ${moncodelimit}
    ${moncodelimit}=  remove from string  .00   ${moncodelimit}

    tch logging  ${SPACE}
    tch logging  Status:${status}  INFO
    tch logging  Trans Limit:${translimit}  INFO
    tch logging  Original Limit:${originallimit}  INFO
    tch logging  Credit Avail:${credavailable}  INFO
    tch logging  Daily Limit:${dailylimit}  INFO
    tch logging  Daily Avail:${dailyavailable}  INFO
    tch logging  Total Available:${totalavailable}  INFO
    tch logging  Maximum Money Code:${moncodelimit}  INFO
    tch logging  Name:${Name}  INFO
    tch logging  Phone:${Phone}  INFO
    tch logging  Email:${Email}  INFO

    Set Suite Variable  ${status}
    Set Suite Variable  ${translimit}
    Set Suite Variable  ${originallimit}
    Set Suite Variable  ${credavailable}
    Set Suite Variable  ${dailylimit}
    Set Suite Variable  ${dailyavailable}
    Set Suite Variable  ${totalavailable}
    Set Suite Variable  ${moncodelimit}
    Set Suite Variable  ${Name}
    Set Suite Variable  ${Phone}
    Set Suite Variable  ${Email}

Check if Contract Information is Correct
    [Documentation]  Check If All the Information on The Credit Screen is Correct.

    Get Into DB  TCH
    ${query}  catenate
    ...  SELECT c.status,  c.trans_limit,  cm.orig_limit,  c.credit_limit - credit_bal AS CreditAvailable,  c.daily_limit,
    ...  daily_limit - daily_bal AS DailyAvailable, cm.max_money_code
    ...  FROM contract c, cont_misc cm WHERE c.contract_id = ${card_num.policy.contract.id} AND c.contract_id = cm.contract_id

    ${output}  Query And Strip To Dictionary  ${query}
    Set Suite Variable  ${output}

    ${ManagInfoName_query}=  catenate
    ...  SELECT cmg.name FROM crd_mgr_codes cmc, contract c, cont_misc cm, credit_mgrs cmg
    ...  WHERE cmg.mgr_id = cmc.mgr_id AND cmc.mgr_code = cm.mgr_code AND
    ...  cm.contract_id = c.contract_id AND c.contract_id = ${card_num.policy.contract.id}
    ${NameResult}=  query and strip  ${ManagInfoName_query}
    Should Be Equal As Strings  ${NameResult.strip()}  ${Name}

    ${ManagInfoPhone_query}=  catenate
    ...  SELECT cmg.off_phone FROM crd_mgr_codes cmc, contract c, cont_misc cm, credit_mgrs cmg
    ...  WHERE cmg.mgr_id = cmc.mgr_id AND cmc.mgr_code = cm.mgr_code AND
    ...  cm.contract_id = c.contract_id AND c.contract_id = ${card_num.policy.contract.id}
    ${PhoneResult}=  query and strip  ${ManagInfoPhone_query}
    Should Be Equal As Strings  ${PhoneResult.strip()}  ${Phone}

    ${ManagInfoEmail_query}=  catenate
    ...  SELECT cmg.email_addr FROM crd_mgr_codes cmc, contract c, cont_misc cm, credit_mgrs cmg
    ...  WHERE cmg.mgr_id = cmc.mgr_id AND cmc.mgr_code = cm.mgr_code AND
    ...  cm.contract_id = c.contract_id AND c.contract_id = ${card_num.policy.contract.id}
    ${EmailResult}=  query and strip  ${ManagInfoEmail_query}
    Should Be Equal As Strings  ${EmailResult.strip()}  ${Email}

    Run Keyword If  ${credavailable} < ${dailyavailable}
    ...  Set Suite Variable  ${output['totalavailable']}  ${credavailable}
    ...  ELSE  Set Suite Variable  ${output['totalavailable']}  ${dailyavailable}

    Set Suite Variable  ${output}

    tch logging  ${SPACE}
    tch logging  status: ${status} ${output['status']}  INFO
    tch logging  trans limit: ${translimit} ${output['trans_limit']}  INFO
    tch logging  original limit: ${originallimit} ${output['orig_limit']}  INFO
    tch logging  credit available: ${credavailable} ${output['creditavailable']}  INFO
    tch logging  daily limit: ${dailylimit} ${output['daily_limit']}  INFO
    tch logging  daily available: ${dailyavailable} ${output['dailyavailable']}  INFO
    tch logging  total available: ${totalavailable} ${output['totalavailable']}  INFO
    tch logging  moncode limit: ${moncodelimit} ${output['max_money_code']}  INFO
    tch logging  name: ${Name} ${NameResult.strip()}  INFO
    tch logging  phone: ${Phone} ${PhoneResult.strip()}  INFO
    tch logging  email: ${Email} ${EmailResult.strip()}  INFO

    Should Be Equal As Strings  ${status}  ${output['status']}
    Should Be Equal As Strings  ${translimit}  ${output['trans_limit']}

Check Contract Credit Available with DB
    [Documentation]  Check Contract Credit Available with DB
    Should Be Equal As Strings  ${credavailable}  ${output['creditavailable']}

Check Contract Original Amount with DB
    [Documentation]  Check Contract Original Amount with DB
    Should Be Equal As Numbers  ${originallimit}  ${output['orig_limit']}

Check Contract Daily Limit with DB
    [Documentation]  Check Contract Daily Limit with DB
    Should Be Equal As Strings  ${dailylimit}  ${output['daily_limit']}

Check Contract Daily Available with DB
    [Documentation]  Check Contract Daily Available with DB
    Should Be Equal As Strings  ${dailyavailable}  ${output['dailyavailable']}

Check Contract Total Available with DB
    [Documentation]  Check Contract Total Available with DB
    Should Be Equal As Strings  ${totalavailable}  ${output['totalavailable']}

Check Contract Maximum Money Code with DB
    [Documentation]  Check Contract Maximum Money Code with DB
    Should Be Equal As Strings  ${moncodelimit}  ${output['max_money_code']}

Switch Contracts and Check for Validation
    [Documentation]  Grab all contracts for a carrier from database and check if all information are ok.

    #Get Contract List from Carrier
    Get Into DB  TCH
    ${contracts}  Query And Strip To Dictionary  SELECT contract_id FROM contract WHERE carrier_id=${card_num.carrier.id}

    #For each contract present into carrier validate screen info with database.
    FOR  ${contract_id}  IN  @{contracts['contract_id']}
      Set Suite Variable  ${contract}  ${contract_id.__str__()}
      TCH Logging  \nChecking Contract:${contract}
      Navigate to Available Credit Screen and Select Contract
      Check if Credit Information Load on Screen
      Check if Contract Information is Correct
      Check Contract Credit Available with DB
      Check Contract Original Amount with DB
      Check Contract Daily Limit with DB
      Check Contract Daily Available with DB
      Check Contract Total Available with DB
      Check Contract Maximum Money Code with DB
    END

Ensure Not Using Secondary Contract
    [Arguments]  ${contract_id}

    ${query}=  assign string  select secondary_contract,sec_threshold,secondary_threshold from contract where contract_id = ${contract_id}
    ${secondary_settings}=  query and strip to dictionary  ${query}
    set suite variable  ${secondary_settings}
    Set Secondary Contract Settings  ${contract_id}  null  null  null

Set Secondary Contract Settings
    [Arguments]  ${Contract}  ${Secondary_Contract_Id}  ${Sec_Threshold}  ${Secondary_Threshold}

    ${Secondary_Contract_Id}  set if null  ${Secondary_Contract_Id}  null
    ${Sec_Threshold}  set if null  ${Sec_Threshold}  null
    ${Secondary_Threshold}  set if null  ${Secondary_Threshold}  null


    ${query}=  assign string  update contract set secondary_contract = ${Secondary_Contract_id}, sec_threshold = ${Sec_Threshold}, secondary_threshold = ${Secondary_Threshold} where contract_id = ${Contract}
    execute sql string  ${query}

Restore Secondary Contract Data
    [Arguments]  ${contract_id}

    Set Secondary Contract Settings  ${contract_id}  ${secondary_settings['secondary_contract']}  ${secondary_settings['sec_threshold']}  ${secondary_settings['secondary_threshold']}
