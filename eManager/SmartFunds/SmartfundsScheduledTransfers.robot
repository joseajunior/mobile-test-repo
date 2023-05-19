*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_robot_lib.setup.PySetup
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot


Documentation  This test is to schedule a smartfunds transfer for various setups
...   and run the related perl script
...   and check the DB for the updated values and status and various fees

Force Tags  eManager  JIRA:BOT-231  JIRA:BOT-198  JIRA:BOT-1955  SmartFunds

Suite Teardown  Deleting all the scheduled ACH transfers

*** Variables ***

${SCH_type}
${TRS_type}
${TRS_value}
${cash}
${status}
${card}  ${validCard.card_num}
${Tcontract}  ${validCard.contract.contract_id}

*** Test Cases ***

Test Case 1: Schedule SmartFunds ACH percentage transfer on load

    [Documentation]  This test case sets up free uses at contract and card level,driver fee, load/remove fee on the card
    ...  and  schedules an ACH transfer for percentage transfer on load
    ...  and loads the cash on the ACH card
    ...  Runs the required perl script to initiate the scheduled transfer
    ...  and checks in DB whether the records show correct status, amount, preocessed date etc
    [Tags]  refactor  tier:0
      [Setup]  Setup
      Set free uses, driver fee, load/remove fee  1.75  LOAD
      Schedule ACH transfer  TL  P  30%
      Load cash on the card  50.00  1.75
      sleep  10
      Run the perl script  achCreateAcctScheduleLoad.pl
      Checking the data in the DB  TL   P  0.30  50.00  WDRW


Test Case 2: Schedule SmartFunds ACH fixed daily transfer
    [Tags]  refactor
    [Documentation]  This test case schedules an ACH transfer
    ...  for daily fixed amount transfer
    ...  Runs the required perl script to initiate the scheduled transfer
    ...  and checks in DB whether the records show correct status, amount, preocessed date etc
    ...  Also checks driver free since this is not a free use
    [Setup]  Setup
    Schedule ACH transfer  DD  F  10.00
    Run the perl script  achCreateAcctSchedule.pl
    Checking the data in the DB  DD   F  10.00  0  WDRW


Test Case 3: Schedule SmartFunds ACH Fixed trsnsfer without enough money

    [Documentation]  This test case schedules an ACH transfer
    ...  for daily fixed amount transfer
    ...  Removes cash from card to make sure there is not enough money on card
    ...  Runs the required perl script to initiate the scheduled transfer
    ...  and checks in DB whether the records show correct status, amount, preocessed date etc
    [Tags]  refactor
     [Setup]  Setup
     Set free uses, driver fee, load/remove fee  1.46  RMVE
     Schedule ACH transfer   DD   F  1000.00
     Load cash on the card  -10.00  1.46
     Run the perl script  createAchAcctSchedule.pl
     Checking the data in the DB  DD   F  1000.00  -100.00  RMVE




*** Keywords ***

Setup
    get into db  TCH
    start setup card  ${card}
    Update Contract Limits by Card  ${card}
    execute sql string  dml=update cont_misc set ach_allowed = 'Y' where contract_id = '${Tcontract}'
    execute sql string  dml=update cards set payr_ach='Y' where card_num = '${card}'   #making it ach allowed


Schedule ACH transfer
    [Arguments]     ${SCH_type}  ${TRS_type}  ${TRS_value}
       get into db  TCH
       ${carrier}  query and strip  select carrier_id from cards where card_num = '${card}'
       ${pwd}  query and strip  select passwd from member where member_id = '${carrier}'
       open emanager   ${carrier}  ${pwd.strip()}
       maximize browser window
       go to  url=${emanager}/cards/SmartPayScheduledAchTransfer.action
       click button   createNew
       click radio button   value=NUMBER
       input text  cardSearchTxt   ${card}
       click button  searchCard
       click button   nextTab
       click radio button  xpath=//*[@id="fundsDest"]/tbody/tr[1]/td[1]/input
       sleep  10
       ${ID}=  get element attribute  ppdHeaderId  value
       set global variable   ${ID}
       Make sure ach_ppd_card_xref has valid values
       click button    nextTab
       click radio button   //*[@value="Y" and @name="ending"]
       ${today}=  getdatetimenow  %Y-%m-%d
       set global variable   ${today}
       input text    targetEffDt  ${today}
       input text    targetExpDt  2025-12-31
       click radio button   //*[@value="${SCH_type}" and @name="scheduleTypeCode"]
       click radio button   //*[@value="N" and @name="sendEmail"]
       click button  nextTab
       run keyword if   '${TRS_type}'=='P'  run keywords  click radio button  xpath=//*[@name="transferTypeCode" and @value='P']  AND  Select From List By Label  transferPercent  ${TRS_value}
       run keyword if   '${TRS_type}'=='F'  input text  transferAmount   ${TRS_value}
       click button  checkNextTab
       click button  nextTab
       wait until element is visible   createNew
       tch logging   ACH transfer scheduled

Load cash on the card
         [Arguments]   ${cash}  ${fee}
         go to   ${emanager}/cards/SmartPayAllocation.action?am=SMARTPAY_LOAD_CARDS
         click radio button  value=NUMBER
         input text  cardSearchTxt  ${card}
         click button   searchCard
         input text     xpath=//*[@id="cardSummary"]//descendant::*[@title='Allocation field must contain Currency.']  ${cash}
         click button   submit
         select window   new
         click button   save
         Handle Alert
         select window  main
         wait until element is visible  backFromReport
         page should contain element  xpath=//*[@id='cardSummary']//descendant::*[contains(text(),"Successful")]
         sleep  1
         click button  backFromReport
         tch logging   Loaded cash on the card
         get into db  tch
        ${free_uses}=  query and strip  select free_uses from cards where card_num = '${card}'
        set global variable   ${free_uses}
        run keyword if  '${cash}'>'0'  run keywords  should be equal as integers  ${free_uses}  1  AND  tch logging  Free uses for card is now 1
        ${other_fees}=  query and strip to dictionary  select * from other_fees where contract_id='${Tcontract}' order by id desc limit 1
        ${load_fee}=  query and strip to dictionary  select * from payr_cash_adv where card_num ='${card}' order by cash_adv_id desc limit 1
        run keyword if  '${cash}'>'0'
        ...  run keywords
        ...  should be equal as strings  ${load_fee.id}  DLRF
        ...  should be equal as strings  ${load_fee.amount}  ${fee}
        ...  AND  tch logging  DLRF is in payr_cash_adv table
        run keyword if  '${cash}'<'0'
        ...  run keywords  should be equal as strings  ${other_fees.other_fee_id}  CLRF
        ...  should be equal as strings  ${other_fees.amount}  -${fee}
        ...  AND  tch logging  CLRF is in other_fees table

Run the perl script
    [Arguments]  ${script}
    tch logging   Running perl script
    connect ssh  ${sshConnection}  ${sshName}  ${sshPass}
    go sudo
    get into db  TCH
    ${run}=  run command  /tch/run/${script}  2>ACH.log
    run keyword if  '${run.rc}'=='0'  tch logging  Perl script unsucessful
    ...  ELSE  tch logging  Perl script successful


Checking the data in the DB
        [Arguments]   ${SCH_type}  ${TRS_type}  ${TRS_value}  ${cash}  ${status}
        get into db   tch
        ${today}=  getdatetimenow  %Y-%m-%d
        ${today}=  convert to string  ${today}
        ${query}=  catenate
        ...  select * from ach_acct_schedule where ppd_header_id = '${ID}' order by aas_id desc limit 1
        ${results}=  query and strip to dictionary   ${query}
        should be equal as strings  ${results.schedule_type}  ${SCH_type}
        should be equal as strings  ${results.transfer_type}  ${TRS_type}
        should be equal as strings  ${results.transfer_value}  ${TRS_value}
        ${results.processed_date}=  convert to string  ${results.processed_date}
        run keyword if  ${cash}>=0  should start with  ${results.processed_date}   ${today}
        run keyword if  ${cash}<0   should be equal as strings   ${results.processed_date}    None
        ${results2}=  query and strip to dictionary  select * from payr_cash_adv where card_num= '${card}' order by when desc limit 3
        run keyword if  '${SCH_type}'=='DD' and '${cash}'>='0'
        ...  run keywords
        ...  should be equal as strings   ${results2.id[1]}  ${status}
        ...  AND  should be equal as strings  ${results2.id[0]}  DACT
        ...  AND  tch logging  There is a driver fee on this transaction: ${results2.amount[0]}
        run keyword if  '${SCH_type}'=='TL' and '${cash}'>'0'
        ...  run keywords
        ...  should be equal as strings   ${results2.id[2]}  LOAD
        ...  AND  should be equal as strings  ${results2.id[0]}  ${status}
        run keyword if  '${SCH_type}'=='DD' and '${cash}'<'0'  should be equal as strings  ${results2.id[0]}  RMVE
        ${results3}=  query and strip to dictionary  select ppd_header_id,notes from ach_schedule_log where ppd_header_id = ${ID} order by log_id desc limit 1
        should be equal as strings   ${results3.ppd_header_id}  ${ID}
        run keyword if  ${cash}>=0  should start with   ${results3.notes}  ACH Successful
        run keyword if  ${cash}<0  should start with    ${results3.notes}  ACH Failed
        tch logging  DB check for Transfer on load and percentage transfer successful

Set free uses, driver fee, load/remove fee
    [Documentation]   This keyword sets up free uses per load at contract
    ...  and  free uses at card level
    ...  set up driver fee for ACH card

    [Arguments]  ${fee_amt}  ${key}
    get into db   tch
    execute sql string  dml=update contract set free_uses_per_load = 1 where contract_id = '${Tcontract}'
    execute sql string  dml=update cards set free_uses = 0 where card_num = '${card}'
    ${count}=  query and strip  select count(*) from driver_fees where contract_id = '${Tcontract}' and fee_id = 115
    run keyword if  '${count}'=='0'  run keywords
    ...  tch logging  Setting up Load/Remove fees on the contract.
    ...  AND  execute sql string  dml=insert INTO driver_fees VALUES (115, ${validCard.carrier.member_id}, ${Tcontract}, 0.50, 2, 1, 0.33, 0.99,0,0,0,0,'Y');
    ...  ELSE  execute sql string  dml=update driver_fees set fee_amt='0.50',fee_level= '2',fee_type='1',fee_min_amt= '0.33' where carrier_id ='${validCard.carrier.member_id}' and contract_id = '${Tcontract}' and fee_id = 115;
    ${count}=  query and strip  select count(*) from driver_fees where contract_id = '${Tcontract}' and fee_id = 101
    run keyword if  '${count}'=='0'  run keywords
    ...  tch logging  Setting up Driver fees on the contract.
    ...  AND  execute sql string  dml=insert INTO driver_fees VALUES (101, ${validCard.carrier.member_id}, ${Tcontract}, 0.30, 1, 1, 0.33, 0.99,0,0,0,0,'Y');
    ...  ELSE  execute sql string  dml=update driver_fees set fee_amt='0.30',fee_level= '1',fee_type='1',fee_min_amt= '0.33' where carrier_id ='${validCard.carrier.member_id}' and contract_id = '${Tcontract}' and fee_id = 101;
    run keyword if  '${key}'=='LOAD'
    ...  run keywords
    ...  execute sql string  dml=update driver_fees set fee_level = 1, exclude_free_use = "Y",fee_amt= '${fee_amt}' where contract_id = '${Tcontract}' and fee_id = 115
    ...  AND  tch logging  Load/Remove fees is set on card
    run keyword if  '${key}'=='RMVE'
    ...  run keywords
    ...  execute sql string  dml=update driver_fees set fee_level = 2, exclude_free_use = "Y", fee_amt= '${fee_amt}' where contract_id = '${Tcontract}' and fee_id = 115
    ...  AND  tch logging  Load/Remove fees is set on contract
    ${driver_fee}=  query and strip to dictionary  select * from driver_fees where contract_id = ${Tcontract} and fee_id = 101 and fee_level =1 and fee_type =1
    tch logging  Driver fee is set to ${driver_fee.fee_amt}
    ${driver_fee}=  assign string  ${driver_fee.fee_amt}
    set global variable  ${driver_fee}

Make sure ach_ppd_card_xref has valid values
    get into db  TCH
    ${value}  query and strip  select count(*) from ach_ppd_card_xref where ppd_header_id = '${ID}' and card_num ='${card}'
    run keyword if  '${value}'=='0'  execute sql string  dml=insert into ach_ppd_card_xref values ('${ID}','${card}')
    ${cxref}  query and strip  select count(*) from ach_ppd_contract_xref where ppd_header_id = '${ID}' and contract_id ='${Tcontract}'
    run keyword if  '${value}'!='0'  execute sql string  dml=delete from ach_ppd_contract_xref where ppd_header_id='${ID}' and contract_id ='${Tcontract}'

Deleting all the scheduled ACH transfers
       get into db  TCH
       ${today}  getdatetimenow  %Y-%m-%d 00:00
       ${now}  getDateTimeNow  %Y-%m-%d %H:%M
       execute sql string  dml=update ach_acct_schedule set exp_date='${now}' where eff_date = '${today}'
       execute sql string  dml=delete from driver_fees where fee_id in ('101','115','114');