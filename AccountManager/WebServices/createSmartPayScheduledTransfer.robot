*** Settings ***
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Documentation
...  createSmartPayScheduledTransfer is a Card Management Web Service that allows a carrier to create scheduled
...  transfers for their card holders
...  = body request template =
...  ---
...  | <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:com="http://com.tch.cards.service">
...  | ${space}${space}${space}<soapenv:Header/>
...  | ${space}${space}${space}<soapenv:Body>
...  | ${space}${space}${space}${space}${space}${space}<com:createSmartPayScheduledTransfer>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}<clientId>?</clientId>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}<transferDefinition>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}<transferAccountId>?</transferAccountId>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}<scheduleType>?</scheduleType>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}<scheduleValue>?</scheduleValue>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}<transferType>?</transferType>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}<transferValue>?</transferValue>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}${space}<emailNotification>?</emailNotification>
...  | ${space}${space}${space}${space}${space}${space}${space}${space}</transferDefinition>
...  | ${space}${space}${space}${space}${space}${space}</com:createSmartPayScheduledTransfer>
...  | ${space}${space}${space}</soapenv:Body>
...  | </soapenv:Envelope>
...  ---
...  clientId: is the client Id when you log in${\n}
...  transferAccountId: is the ppdh_header_id from the ach_ppd_header table and is the primary key for linking the ach tables${\n}
...  scheduleType: is a JAVA enum and can be *DAILY*, *DAY_OF_MONTH*, *DAY_OF_WEEK*, or *TRANSFER_ON_LOAD* the database equivilants are DD, MD, WD, TL${\n}
...  scheduleValue:  is used only with *DAY_OF_MONTH* and *DAY_OF_WEEK* essentially it's a binary string representing the days of a week and days of a month$
...  the string cannot be less than 7 digits and the days of month cannot be greater than 28${\n}
...  = example =
...  | scheduleType | Desired Schedule | Represented In the correct format |
...  | DAY_OF_WEEK  | M, W, F | 1010100 |
...  | DAY_OF_WEEK  | M | 1000000 |
...  | DAY_OF_MONTH | 1,3,15 | 1010000000000010000000000000 |
...  | DAY_OF_MONTH | 1 | 1000000000000000000000000000 |
...  transferType: is a JAVA enum and can be *FIXED_AMOUNT* or *PERCENTAGE* the database equivilants are F,P
...  PERCENTAGE can only be used on a TRANSFER_ON_LOAD schedule type${\n}
...  transferValue: is the amount that will be transfer in the case of *FIXED_AMOUNT* it will be a dollar amount
...  *PERCENTAGE* will be a percentage as a decimal .05 == 5%, 1==100%${\n}

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Variables ***
${carrier}  141526
${transferAccountId}
${card_num}
${aas_id}

*** Test Cases ***
SmartPay Scheduled Transfer for DAILY
    [Tags]  JIRA:BOT-1628  qTest:31825788  Regression  refactor
    [Documentation]  Validate that you can create SmartPay Scheduled Transfer

    ${scheduleType}  set variable  DAILY
    ${scheduleValue}  set variable  ${EMPTY}
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    ${status}  Run Keyword And Return Status  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}
    validate inserted into table correctly  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

    [Teardown]  delete scheduled transfer  ${aas_id}

SmartPay Scheduled Transfer for DAY OF MONTH
    [Tags]  JIRA:BOT-1628  qTest:31825820  Regression  refactor
    [Documentation]  Validate that you can create SmartPay Scheduled Transfer

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  make scheduled value for day of month  15  3
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}
    validate inserted into table correctly  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

    [Teardown]  delete scheduled transfer  ${aas_id}

SmartPay Scheduled Transfer for DAY OF WEEK
    [Tags]  JIRA:BOT-1628  qTest:31825823  Regression  refactor
    [Documentation]  Validate that you can create SmartPay Scheduled Transfer

    ${scheduleType}  set variable  DAY_OF_WEEK
    ${scheduleValue}  Make Scheduled Value For Day Of Week  2  5
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  1

    createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}
    validate inserted into table correctly  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

    [Teardown]  delete scheduled transfer  ${aas_id}

SmartPay Scheduled Transfer for TRANSFER ON LOAD FIXED
    [Tags]  JIRA:BOT-1628  qTest:31825824  Regression  refactor
    [Documentation]  Validate that you can create SmartPay Scheduled Transfer

    ${scheduleType}  set variable  TRANSFER_ON_LOAD
    ${scheduleValue}  set variable  ${EMPTY}
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}
    validate inserted into table correctly  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

    [Teardown]  delete scheduled transfer  ${aas_id}

SmartPay Scheduled Transfer for TRANSFER ON LOAD with Percentage
    [Tags]  JIRA:BOT-1628  qTest:31825825  Regression  refactor
    [Documentation]  Validate that you can create SmartPay Scheduled Transfer

    ${scheduleType}  set variable  TRANSFER_ON_LOAD
    ${scheduleValue}  set variable  ${EMPTY}
    ${transferType}  set variable  PERCENTAGE
    ${transferValue}  set variable  .98
    ${emailNotification}  set variable  0

    createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}
    validate inserted into table correctly  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

    [Teardown]  delete scheduled transfer  ${aas_id}

Check INVALID on the transferAccountId
    [Tags]  JIRA:BOT-1628  qTest:31825871  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a INVALID data on transferAccountId

    ${transferAccountId}  set variable  !nv@l1d
    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *For input string: "${transferAccountId}"*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Check INVALID on the scheduleType
    [Tags]  JIRA:BOT-1628  qTest:31825874  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a INVALID data on scheduleType

    ${scheduleType}  set variable  MD
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *No enum constant*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Check INVALID on the transferType
    [Tags]  JIRA:BOT-1628  qTest:31825877  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a INVALID data on transferType

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *No enum constant*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}fff  ${transferValue}  ${emailNotification}

Check INVALID on the transferValue
    [Tags]  JIRA:BOT-1628  qTest:31825879  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a INVALID data on transferValue

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *For input string: "${transferValue}fff"*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}fff  ${emailNotification}

Check INVALID on the emailNotification
    [Tags]  JIRA:BOT-1628  qTest:31825884  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a INVALID data on emailNotification

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  Y

    run keyword and expect error  *in valid string -${emailNotification} for boolean value*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Check TYPO on the transferAccountId
    [Tags]  JIRA:BOT-1628  qTest:31825885  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a typo on transferAccountId


    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *For input string: "${transferAccountId}fff"*  createSmartPayScheduledTransfer  ${transferAccountId}fff  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Check TYPO on the scheduleType
    [Tags]  JIRA:BOT-1628  qTest:31825888  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a typo on scheduleType


    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *No enum constant*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}fff  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Check TYPO on the transferType
    [Tags]  JIRA:BOT-1628  qTest:31825891  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a typo on transferType


    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *No enum constant*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}fff  ${transferValue}  ${emailNotification}

Check TYPO on the transferValue
    [Tags]  JIRA:BOT-1628  qTest:31825892  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a typo on transferValue


    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *For input string: "${transferValue}fff"*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}fff  ${scheduleValue}  ${transferType}  ${transferValue}fff  ${emailNotification}

Check TYPO on the emailNotification
    [Tags]  JIRA:BOT-1628  qTest:31825894  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with a typo on emailNotification


    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  N

    run keyword and expect error  *in valid string -${emailNotification} for boolean value*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}fff  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Validate EMPTY value on transferAccountId
    [Tags]  JIRA:BOT-1628  qTest:31825898  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with an EMPTY transferAccountId

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *ERROR running command*  createSmartPayScheduledTransfer  ${EMPTY}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Validate EMPTY value on scheduleType
    [Tags]  JIRA:BOT-1628  qTest:31825900  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with an EMPTY scheduleType

    ${scheduleType}  set variable  ${EMPTY}
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *No enum constant*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

Validate EMPTY value on transferType
    [Tags]  JIRA:BOT-1628  qTest:31825903  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with an EMPTY transferType

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  ${EMPTY}
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0

    run keyword and expect error  *No enum constant*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}


Validate EMPTY value on transferValue
    [Tags]  JIRA:BOT-1628  qTest:31825905  Regression
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer with an EMPTY transferValue

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  ${EMPTY}
    ${emailNotification}  set variable  0

    run keyword and expect error  *Infinite or NaN*  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

SmartPay Scheduled Transfer With transferAccountId from different carrier
    [Tags]  JIRA:BOT-1628  qTest:31825907  Regression  BUGGED:A carrier probably shouldn't be able to set up a transfer for a card taht doesn't belong to that carrier.
    [Documentation]  Validate that you cannot create SmartPay Scheduled Transfer using CardNumber from different carrier

    ${scheduleType}  set variable  DAY_OF_MONTH
    ${scheduleValue}  set variable  15
    ${transferType}  set variable  FIXED_AMOUNT
    ${transferValue}  set variable  5.00
    ${emailNotification}  set variable  0
    ${card}  ${transferAccountId}  get transfer account from another carrier  ${carrier}

    run keyword and expect error  *  createSmartPayScheduledTransfer  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

*** Keywords ***
Deleting the last SmartPay Scheduled Transfer created
    [Arguments]  ${cardNumber}
    ${SmartPayTransfers}  getSmartPayScheduledTransfers  ${cardNumber}
    ${accountId}  set variable  ${SmartPayTransfers[0]['transferAccountId']}

    ${status}  Run Keyword And Return Status  deleteSmartPayTransferAccount  ${accountId}

    Should Be True  ${status}
Setup WS
    ${pass}=  get carrier password  ${carrier}
    log into card management web services  ${carrier}  ${pass}
    ${sql}=  catenate  select aph.ppd_header_id as ppd_header_id,card_num from
    ...  ach_ppd_header aph
    ...  left join ach_ppd_carrier_xref apcx
    ...      on apcx.ppd_header_id = aph.ppd_header_id
    ...  left join ach_ppd_card_xref aprx
    ...      on aprx.ppd_header_id = aph.ppd_header_id
    ...  where carrier_id = 141526
    ...  and verify_date is not null
    ...  and verify_amount_1 is not null
    ...  and expire_date > TODAY
    ${results}  query and return dictionary rows  ${sql}
    ${randomRow}  evaluate  random.choice(${results})  random

    ${card_num}=  set variable  ${randomRow['card_num']}
    set suite variable  ${card_num}
    ${transferAccountId}=  set variable  ${randomRow['ppd_header_id']}
    set suite variable  ${transferAccountId}

    execute sql string   dml=DELETE from ach_acct_schedule where eff_date > TODAY and ppd_header_id in (select ppd_header_id from ach_ppd_carrier_xref where carrier_id = ${carrier})

Tear Me Down
    Logout

Make Scheduled Value For Day Of Week
    [Arguments]  @{days}
    
    ${scheduled_value}=  assign string  ${EMPTY}
    
    FOR  ${DAY}  IN RANGE  1  8
        ${isTrue}  run keyword and return status  should contain  ${days}  ${DAY.__str__()}
        ${scheduled_value}=  run keyword if  ${isTrue}  assign string  ${scheduled_value}1  ELSE  assign string  ${scheduled_value}0
    END
    
    [Return]  ${scheduled_value}

Make Scheduled VAlue For Day Of Month
    [Arguments]  @{days}
    
    ${scheduled_value}=  assign string  ${EMPTY}
    
    FOR  ${DAY}  IN RANGE  1  29
        ${isTrue}  run keyword and return status  should contain  ${days}  ${DAY.__str__()}
        ${scheduled_value}=  run keyword if  ${isTrue}  assign string  ${scheduled_value}1  ELSE  assign string  ${scheduled_value}0
    END

    [Return]  ${scheduled_value}

Delete Scheduled Transfer
    [Arguments]  ${ach_acct_scheduled_id}

    run keyword and ignore error  execute sql string   dml=DELETE from ach_acct_schedule where aas_id = ${ach_acct_scheduled_id}

Validate Inserted Into Table Correctly
    [Arguments]  ${transferAccountId}  ${scheduleType}  ${scheduleValue}  ${transferType}  ${transferValue}  ${emailNotification}

    ${sql}=  catenate  select * from ach_acct_schedule aas left join ach_ppd_carrier_xref apcs on apcs.ppd_header_id = aas.ppd_header_id where carrier_id= ${carrier} and eff_date > TODAY order by eff_date desc
    ${results}=  query and return dictionary rows  ${sql}  0
    ${aas_id}=  set variable  ${results.aas_id}
    set test variable  ${aas_id}

    ${transferType}=  run keyword if  '${transferType}'=='FIXED_AMOUNT'  assign string  F  ELSE  assign string  P
    &{switchDOM}=  create dictionary  DAILY=DD  DAY_OF_MONTH=MD  DAY_OF_WEEK=WD  TRANSFER_ON_LOAD=TL
    ${emailNotification}=  run keyword if  ${emailNotification}==0  assign string  N  ELSE  assign string  Y

    should be equal as strings  ${results.ppd_header_id}  ${transferAccountId}
    should be equal as strings  ${results.schedule_type}  ${switchDOM['${scheduleType}']}
    should be equal as strings  ${results.schedule_value}  ${scheduleValue}
    should be equal as strings  ${results.transfer_type}  ${transferType}
    should be equal as numbers  ${results.transfer_value}  ${transferVAlue}
    should be equal as strings  ${results.email_notification}  ${emailNotification}

Get Transfer Account From Another Carrier
    [Arguments]  ${car}
    ${sql}=  catenate  select card_num,aph.ppd_header_id
    ...  from ach_ppd_header aph
    ...  left join ach_ppd_carrier_xref apcx
    ...      on apcx.ppd_header_id = aph.ppd_header_id
    ...  left join ach_ppd_card_xref aprx
    ...      on aprx.ppd_header_id = aph.ppd_header_id
    ...  where carrier_id != ${car}
    ...  and verify_date is not null
    ...  and verify_amount_1 is not null
    ...  and expire_date > TODAY

    ${results}=  query and return dictionary rows  ${sql}
    ${row}=  evaluate  random.choice(${results})  random

    [Return]  ${row['card_num']}  ${row['ppd_header_id']}