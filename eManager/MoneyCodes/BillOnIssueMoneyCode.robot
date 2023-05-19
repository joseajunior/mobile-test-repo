*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_robot_lib.ssh.PySSH
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Suite Teardown  Close Browser

Force Tags  eManager


*** Variables ***
${cont}
${log_dir}

*** Test Cases ***

Bill on Issue Money Codes
    [Tags]    JIRA:BOT-147  refactor

    get into DB  tch
    set test variable  ${cont}  3035    #set the contract value
    Initiate Test
    Bill On Issue Test  Y       #set ${bill_on_issue} value as Y

Money Code = N
    [Tags]    JIRA:BOT-147  refactor

    get into db  tch
    set test variable  ${cont}  3035     #set the contract value
    Initiate Test
    Bill On Issue Test  N       #set ${bill_on_issue} value as N

*** Keywords ***

#This keyword has to run before each test case
Initiate Test
   connect ssh  ${sshHost}  ${sshName}  ${sshPass}
   go sudo
   ${date}=  getdatetimenow  %Y%m%d
   ${date}=  get substring  ${date}  2
   ${time}=  getdatetimenow  %H%M%S
   ${month}=  getdatetimenow  %m
   ${log_dir}=  catenate
   ...  /home/qaauto/el_robot/authStrings/rossAuthLogs/temp/${month}
   run command  if [ ! -d ${log_dir} ];then mkdir -p ${log_dir};fi
   run command  find ${log_dir} -type f -name '*' -mtime +365 -exec rm {} \\;
   run command  cd /home/qaauto/el_robot/authStrings

   set global variable  ${log_dir}
   set global variable  ${date}
   set global variable  ${time}


Bill On Issue Test
     [Arguments]  ${bill_on_issue}

    #get ID and PASSWORD based on a contract_id
    ${query}=  catenate
    ...  select member_id, TRIM(passwd) as passwd from member m, contract c
    ...  where c.carrier_id = m.member_id and c.contract_id = ${cont}

    ${cred}=  query and strip to dictionary  ${query}
    log to console  USERNAME : ${cred['member_id']}
    log to console  PASSWORD : ${cred['passwd']}



    #set the value for ${bill_on_issue}
    ${query1}=  catenate
    ...  update contract set mcode_bill_on_issue = '${bill_on_issue}' where contract_id = ${cont}
    execute sql string  ${query1}

    #get contract balance and limits based on the query on RobotKeywords.robot [ctrl+click]
    ${old_contract_balance}=  Get Contract Balance and Limits  ${cont}

    log to console  ${old_contract_balance.check_fee}
    log to console  ${old_contract_balance.credit_bal}

    Print Dictionary  ${old_contract_balance}

    #Login on the application
    log into card management web services  ${cred['member_id']}  ${cred['passwd']}
    #Issue a money code with USD100 as amount.
    ${amount}  Evaluate  round(random.uniform(1, 300), 2)  random,sys
#    ${amount}  Set Variable  1000.00
    log to console  Amount Used > ${amount}
    ${moneyCode}=  issueMoneycode  ${cont}  ${amount}  BOT-122
    set global variable  ${moneyCode}

    ${times}=  evaluate  round(100 / ${old_contract_balance.mcode_tier_amt})
    log to console  ${times}

        #get the new balance after issuing a money code
        ${new_contract_balance}=  Get Contract Balance and Limits  ${cont}

    #set the new value for the credit balance
#    ${old_balance}=  evaluate  ${old_contract_balance.credit_used}+${old_contract_balance.check_fee}+100
    ${amount_plus_fee}  Get Amount Plus Fee  ${amount}  ${old_contract_balance.check_fee}
    ${old_balance}  Evaluate  ${old_contract_balance.credit_bal} + ${amount_plus_fee}

    #IF the argument is Y then the moneycode was issued and the ${old_balance} is equal to ${new_contract_balance.credit_used}
    #IF the argument is N then ${old_contract_balance.credit_used} is equal to ${new_contract_balance.credit_used}
    run keyword if  '${bill_on_issue}'=='Y'    should be equal as Numbers  ${old_balance}  ${new_contract_balance.credit_bal}
    ...  ELSE IF  '${bill_on_issue}'=='N'  should be equal as Numbers  ${old_contract_balance.credit_bal}  ${new_contract_balance.credit_bal}
    ...  ELSE  fail  bill_on_issue can only be set to Y or N

    #Create AM String is order to authorize the money code
    ${string}=  create AM string  TCH  231010  ${moneyCode}  ULSD=10.07  ADD=1.33
    log to console  ${string}

    #Create a log entry so if the transaction fails it's possible to track what caused it
    ${log_dir}=  catenate
    ...  ${log_dir}/AM.log
    run rossAuth  ${string}  ${log_dir}
    ${errors}=  run command  grep -ao 'FAILURE' ${log_dir}
    should not be equal as strings  ${errors.stdout}  FAILURE  Transaction Failed

Get Amount Plus Fee
    [Tags]  qTest:28837361  Regression
    [Arguments]  ${amount}  ${check_fee}
    ${total_fee_value}   Get Total Fee By Amount  ${amount}  ${check_fee}
    log to console  amount ${amount}
    log to console  check_fee ${check_fee}
    ${amount_plus_fee}  Evaluate  ${amount} + ${total_fee_value}
    log to console  amount_plus_fee ${amount_plus_fee}
    [Return]  ${amount_plus_fee}

Get Total Fee By Amount
    [Arguments]  ${amount}  ${check_fee}  ${INCREASE_FEE_VALUE}=50.00  #${MAX_FEE}=20.00
    [Documentation]  On each $50 on amount, the total fee value must be increased by the check fee value. ( amount / 50 )
    ...              The division must be ceiled to be multiplied by the check fee value. ( check fee * ceil( amount / 50 ) )
    ...              If the amount is greater than $200 the max fee value must be used. (???)
    ...              Example:
    ...              amount = 0 -> 50  = $5   |  50 -> 100 = $10   |   100 -> 150 = $15   |  ... or MAX FEE = 20
    ${fee_times}  Evaluate    math.ceil(${amount}/${INCREASE_FEE_VALUE})  math
    ${total_fee}  Evaluate  ${check_fee} * ${fee_times}
#    ${total_fee}  Set Variable If  ${total_fee} > ${MAX_FEE}
#    ...  ${MAX_FEE}  ${total_fee}
    ${total_fee}  convert to number  ${total_fee}  2
    [Return]  ${total_fee}
