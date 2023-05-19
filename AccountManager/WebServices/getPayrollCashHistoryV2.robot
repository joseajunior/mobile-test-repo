*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
Check TYPO on the begDate
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a date with a TYPO in begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, ${begDate}F as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error For ${begDate}F Date

    [Teardown]  Logout

Check TYPO on the endDate
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a date with a TYPO in endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, ${begDate} as beginning date, ${endDate}F as ending date and A as card status
    You Should See a Error For ${endDate}F Date


    [Teardown]  Logout

Check TYPO on the cardNumber
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a date with a TYPO in cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Payroll Cash History with 5567480040600320F As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And A As Card Status
    Result Should Be Empty

    [Teardown]  Logout

Check TYPO on the cardStatus
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a date with a TYPO in cardStatus.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History With ALL as card number, ${begDate} as beginning date, ${endDate} as ending date and AF as card status
    You Should See a Error For Invalid Card Status

    [Teardown]  Logout

Validate EMPTY value on begDate
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an empty value on begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, ${EMPTY} as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate EMPTY value on endDate
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an empty value on endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, ${begDate} as beginning date, ${EMPTY} as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate EMPTY value on cardNumber
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an empty value on cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ${EMPTY} as card number, ${begDate} as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error For a Running Command

    [Teardown]  Logout

Validate EMPTY value on cardStatus
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an empty value on cardStatus.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, ${begDate} as beginning date, ${endDate} as ending date and ${EMPTY} as card status
    You Should See a Error For Invalid Card Status

    [Teardown]  Logout

Validate INVALID value on begDate
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an invalid value on begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, !nv@l1D as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate INVALID value on endDate
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an invalid value on endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, ${begDate} as beginning date, !nv@l1D as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate INVALID value on cardNumber
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an invalid value on cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Payroll Cash History with !nv@l1D As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And A As Card Status
    Result Should Be Empty

    [Teardown]  Logout

Validate INVALID value on cardStatus
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an invalid value on cardStatus.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Payroll Cash History with ALL as card number, ${begDate} as beginning date, ${endDate} as ending date and !nv@l1D as card status
    You Should See a Error For Invalid Card Status

    [Teardown]  Logout

Should Not Get Payroll Cash History If endDate Was Less Than begDate
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an endDate value less then begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Payroll Cash History with 5567480040600320 As Card Number, ${endDate} As Beginning Date, ${begDate} As Ending Date And A As Card Status
    Result Should Be Empty

    [Teardown]  Logout

Should Not Get Payroll Cash History If Data Range Is Higher Than a Week
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using an endDate value higher then one week from begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Add 14 days to beginning date
    Get a Error For Payroll Cash History with ALL as card number, ${begDate} as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error Saying That Dates Cannot Be More Than a Week Apart

    [Teardown]  Logout

Should Not Get Payroll Cash History Using cardNumber From Different Carrier
    [Tags]  JIRA:BOT-3264  qTest:48544147
    [Documentation]  Validate that you cannot pull up Payroll Cash History using a cardNumber that doesn't belong to the carrier.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Payroll Cash History with 7083059810269800034 As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And A As Card Status
    Result Should Be Empty

    [Teardown]  Logout

Validate Payroll Cash History With Card Status As Active
    [Tags]  JIRA:BOT-3264  qTest:48446409
    [Documentation]  Validate all informations returned from getPayrollCashHistoryV2 with all card numbers and card status Activate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Payroll Cash History with ALL As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And A As Card Status
    Check Payroll Cash History On DB In Range ${begDate} And ${endDate} And A As Card Status
    The Service Results Should Be Present In DB Results

    [Teardown]  Logout

Validate Payroll Cash History With Casd Status As Inactive
    [Tags]  JIRA:BOT-3264  qTest:48446409
    [Documentation]  Validate all informations returned from getPayrollCashHistoryV2 with all card numbers and card status Inactivate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And I Card Status

    Get Payroll Cash History with ALL As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And I As Card Status
    Check Payroll Cash History On DB In Range ${begDate} And ${endDate} And I As Card Status
    The Service Results Should Be Present In DB Results

    [Teardown]  Logout

Validate Payroll Cash History With Casd Status As ALL
    [Tags]  JIRA:BOT-3264  qTest:48446409
    [Documentation]  Validate all informations returned from getPayrollCashHistoryV2 with all card numbers and all card status
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And ALL Card Status

    Get Payroll Cash History with ALL As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And ALL As Card Status
    Check Payroll Cash History On DB In Range ${begDate} And ${endDate} And ALL As Card Status
    The Service Results Should Be Present In DB Results

    [Teardown]  Logout

*** Keywords ***
Adapt ${full_date} To Better Format
    ${year}  ${full_hour}  Split String  ${full_date}  T
    ${hour}  ${timezone}  Split String  ${full_hour}  .

    ${adapt_date}=  convert date  ${year} ${hour}  result_format=%Y-%m-%d %H:%M

    [Return]  ${adapt_date}

Add ${number} days to beginning date
    ${endDate}=  Add Time To Date  ${begDate}  ${number} days  result_format=%Y-%m-%d

    Set Test Variable  ${endDate}

Check Payroll Cash History On DB In Range ${beg_date} And ${end_date} And ${card_status} As Card Status
    Get Into DB  TCH

    ${query}  Catenate
    ...  SELECT
    ...  pca.amount,pca.card_num,pca.cash_adv_id,pca.balance,pca.id,pca.when,pca.trans_id,pca.ref_num,pca.who,pca.parent_id,pca.contract_id, t.invoice
    ...  FROM payr_cash_adv pca join cards c on c.card_num = pca.card_num left outer join transaction t on pca.trans_id = t.trans_id
    ...  WHERE (pca.show_on_report != 'N' OR pca.show_on_report is null)
    ...  and pca.when >= '${beg_date} 00:00'
    ...  and pca.when <= '${end_date} 23:59'
    ...  and c.carrier_id = '${validCard.carrier.id}'

    ${query}=  run keyword if  '${card_status}' != 'ALL'
    ...  Catenate  ${query}  and c.status = '${card_status}'
    ...  ELSE  Catenate  ${query}

    ${results}  Query and Strip To Dictionary  ${query}

    Set Test Variable  ${db_results}  ${results}

Get a Error For Payroll Cash History with ${card_number} as card number, ${beg_date} as beginning date, ${end_date} as ending date and ${card_status} as card status
    ${status}  Run Keyword And Ignore Error  getPayrollCashHistoryV2  ${card_number}  ${beg_date}  ${end_date}  ${card_status}

    Set Test Variable  ${error_message}  ${status}[1]

Get Query With ${user} As Carrier And ${card_status} Card Status
    Get Into DB  TCH
    ${query}  Catenate  SELECT m.member_id AS carrier_id, m.passwd, trim(c.card_num) AS card_num, pca.when AS when
    ...  FROM payr_cash_adv pca
    ...  JOIN cards c ON c.card_num = pca.card_num
    ...  LEFT OUTER JOIN member m ON m.member_id = c.carrier_id
    ...  LEFT OUTER JOIN TRANSACTION t ON pca.trans_id = t.trans_id
    ...  WHERE 1=1
    ...  AND (pca.show_on_report != 'N' OR pca.show_on_report IS NULL)
    ...  AND pca.when >= '2020-01-01 00:00'
    ...  AND pca.when <= '2021-12-31 00:00'
    ...  AND c.status = '${card_status}'
    ...  AND m.member_id = '${user}'
    ...  ORDER BY pca.when DESC

    Set Test Variable  ${query}

Get Query With No Card Status For ${user}
    Get Into DB  TCH
    ${query}  Catenate  SELECT m.member_id AS carrier_id, m.passwd, trim(c.card_num) AS card_num, pca.when AS when
    ...  FROM payr_cash_adv pca
    ...  JOIN cards c ON c.card_num = pca.card_num
    ...  LEFT OUTER JOIN member m ON m.member_id = c.carrier_id
    ...  LEFT OUTER JOIN TRANSACTION t ON pca.trans_id = t.trans_id
    ...  WHERE 1=1
    ...  AND (pca.show_on_report != 'N' OR pca.show_on_report IS NULL)
    ...  AND pca.when >= '2020-07-11 00:00'
    ...  AND pca.when <= '2021-07-11 00:00'
    ...  AND m.member_id = '${user}'
    ...  ORDER BY pca.when DESC

    Set Test Variable  ${query}

Get Payroll Cash History with ${card_number} As Card Number, ${beg_date} As Beginning Date, ${end_date} As Ending Date And ${card_status} As Card Status
    ${status}=  getPayrollCashHistoryV2  ${card_number}  ${beg_date}  ${end_date}  ${card_status}
    # Remove first index of the list to remove the BBAL value result
    ${empty_status}=  run keyword and return status  should be empty  ${status}
    run keyword unless  ${empty_status}  Remove From List  ${status}  0

    Set Test Variable  ${service_results}  ${status}

Get Valid Dates With ${user} As Carrier And ${card_status} Card Status
    Run Keyword If  '${card_status}'=='ALL'  Get Query With No Card Status For ${user}
    ...  ELSE  Get Query With ${user} As Carrier And ${card_status} Card Status

    ${list}  Query And Strip To Dictionary  ${query}
    ${when}  Get From Dictionary  ${list}  when
    ${date}  Convert Date  ${when}[0]  result_format=%Y-%m-%d

    ${endDate}  Add Time To Date  ${date}  1 day  result_format=%Y-%m-%d
    ${begDate}  Subtract Time From Date  ${date}  6 days  result_format=%Y-%m-%d

    Set Test Variable  ${begDate}
    Set Test Variable  ${endDate}

Result Should Be Empty
    should be empty  ${service_results}

The Service Results Should Be Present In DB Results
    FOR  ${result}  IN  @{service_results}
        ${date}=  Adapt ${result.get('date')} To Better Format
        ${query}  Catenate
        ...  SELECT
        ...  pca.amount,pca.card_num,pca.cash_adv_id,pca.balance,pca.id,pca.when,pca.trans_id,pca.ref_num,pca.who,pca.parent_id,pca.contract_id, t.invoice
        ...  FROM payr_cash_adv pca join cards c on c.card_num = pca.card_num left outer join transaction t on pca.trans_id = t.trans_id
        ...  WHERE (pca.show_on_report != 'N' OR pca.show_on_report is null)
        ...  and pca.amount = '${result.get('amount')}'
        ...  and pca.card_num = '${result.get('cardNumber')}'
        ...  and pca.id = '${result.get('cashId')}'
        ...  and pca.trans_id = '${result.get('transactionId')}'
        ...  and pca.cash_adv_id = '${result.get('cashAdvId')}'
        ...  and pca.when = '${date}'

        ${find}=  Query and Strip To Dictionary  ${query}
        Should Not Be Empty  ${find}
    END

You Should See a Error For ${date} date
    should contain  ${error_message}  invalid date format (${date}

You Should See a Error For Date String Lenght
    should contain  ${error_message}  date string can not be less than 19 charactors

You Should See a Error For a Running Command
    should contain  ${error_message}  ERROR running command

You Should See a Error For Invalid Card Status
    should contain  ${error_message}  Invalid Card Status

You Should See a Error Saying That Dates Cannot Be More Than a Week Apart
    should contain  ${error_message}  Begin Date and End Date cannot be more than a week apart
