*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services  refactor

*** Test Cases ***
Check TYPO on the cardNumber
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a typo on cardNumber
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Cash History with 5561280010100004F as card number, ${beg_date} as beginning date, ${end_date} as ending date and A as card status
    Result Should Be Empty

    [Teardown]  Logout

Check TYPO on the begDate
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a typo on begDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${beg_date}F as beginning date, ${end_date} as ending date and A as card status
    You Should See a Error For ${begDate}F Date

    [Teardown]  Logout

Check TYPO on the endDate
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a typo on endDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${beg_date} as beginning date, ${end_date}F as ending date and A as card status
    You Should See a Error For ${endDate}F Date

    [Teardown]  Logout

Check TYPO on the cardStatus
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a typo on cardStatus
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${beg_date} as beginning date, ${end_date} as ending date and AF as card status
    You Should See a Error For Invalid Card Status

    [Teardown]  Logout

Validate EMPTY value on cardNumber
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a getCashHistory using an empty cardNumber.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ${EMPTY} as card number, ${begDate} as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error For a Running Command

    [Teardown]  Logout

Validate EMPTY value on begDate
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a getCashHistory using an empty begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${EMPTY} as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate EMPTY value on endDate
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a getCashHistory using an empty endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${begDate} as beginning date, ${EMPTY} as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate EMPTY value on cardStatus
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a getCashHistory using an empty cardStatus
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${begDate} as beginning date, ${endDate} as ending date and ${EMPTY} as card status
    You Should See a Error For Invalid Card Status

    [Teardown]  Logout

Validate INVALID value on the cardNumber
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a INVALID value on cardNumber
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Cash History with !nv@l1d as card number, ${beg_date} as beginning date, ${end_date} as ending date and A as card status
    Result Should Be Empty

    [Teardown]  Logout

Validate INVALID value on the begDate
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a INVALID value on begDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, !nv@l1D as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate INVALID value on the endDate
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a INVALID value on endDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${begDate} as beginning date, !nv@l1D as ending date and A as card status
    You Should See a Error For Date String Lenght

    [Teardown]  Logout

Validate INVALID value on the cardStatus
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a INVALID value on cardStatus
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get a Error For Cash History with ALL as card number, ${begDate} as beginning date, ${endDate} as ending date and !nv@l1D as card status
    You Should See a Error For Invalid Card Status

    [Teardown]  Logout

Should Not Get Cash History Using cardNumber From Different Carrier
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up Cash History using a cardNumber from different Carrier
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Cash History with 7083050361000607857 As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And A As Card Status
    Result Should Be Empty

    [Teardown]  Logout

Should Not Get Cash History If endDate Was Less Than begDate
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up a cash history with a endDate less than begDate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Cash History with ALL As Card Number, ${endDate} As Beginning Date, ${begDate} As Ending Date And A As Card Status
    Result Should Be Empty

    [Teardown]  Logout

Should Not Get Cash History If Data Range Is Higher Than a Week
    [Tags]  JIRA:BOT-3263  qTest:48728797
    [Documentation]  Validate that you cannot pull up Cash History using an endDate value higher then one week from begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Add 14 days to beginning date
    Get a Error For Cash History with ALL as card number, ${begDate} as beginning date, ${endDate} as ending date and A as card status
    You Should See a Error Saying That Dates Cannot Be More Than a Week Apart

    [Teardown]  Logout

Validate Cash History With Card Status As Active
    [Tags]  JIRA:BOT-3263  qTest:48728796
    [Documentation]  Validate all informations returned from getCashHistoryV2 with all card numbers and card status Activate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Cash History with ALL As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And A As Card Status
    Check Cash History On DB In Range ${begDate} And ${endDate} And A As Card Status
    The Service Results Should Be Present In DB Results

    [Teardown]  Logout

Validate Cash History With Card Status As Inactive
    [Tags]  JIRA:BOT-3263  qTest:48728796
    [Documentation]  Validate all informations returned from getCashHistoryV2 with all card numbers and card status Inactivate
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Cash History with ALL As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And I As Card Status
    Check Cash History On DB In Range ${begDate} And ${endDate} And A As Card Status
    The Service Results Should Be Present In DB Results

    [Teardown]  Logout

Validate Cash History With Card Status As ALL
    [Tags]  JIRA:BOT-3263  qTest:48728796
    [Documentation]  Validate all informations returned from getCashHistoryV2 with all card numbers and card status ALL
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Get Valid Dates With ${validCard.carrier.id} As Carrier And A Card Status

    Get Cash History with ALL As Card Number, ${begDate} As Beginning Date, ${endDate} As Ending Date And I As Card Status
    Check Cash History On DB In Range ${begDate} And ${endDate} And ALL As Card Status
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

Check Cash History On DB In Range ${beg_date} And ${end_date} And ${card_status} As Card Status
    Get Into DB  TCH

    ${query}  Catenate  SELECT ca.cash_adv_id,ca.card_num,ca.amount,ca.balance,ca.id,ca.when,ca.trans_id,ca.ref_num,
    ...  ca.who,ca.parent_id,ca.contract_id,ca.show_on_report,t.invoice
    ...  FROM cash_adv ca join cards c on c.card_num = ca.card_num
    ...  left outer join transaction t on ca.trans_id = t.trans_id
    ...  WHERE (ca.show_on_report != 'N' OR ca.show_on_report is null)
    ...  AND ca.when >= '2016-07-12 00:00'
    ...  AND ca.when <= '2021-07-19 00:00'
    ...  AND c.carrier_id != 103866

    ${query}=  run keyword if  '${card_status}' != 'ALL'
    ...  Catenate  ${query}  and c.status = '${card_status}'
    ...  ELSE  Catenate  ${query}

    ${results}  Query and Strip To Dictionary  ${query}

    Set Test Variable  ${db_results}  ${results}

Check Cash History
    [Arguments]  ${CashHistory}  ${cardNumber}  ${begDate}  ${endDate}
    Get Into DB  tch

    ${query}  Catenate
    ...  SELECT
    ...  amount AS amount,
    ...  card_num as cardNumber,
    ...  TRIM(id) AS cashId,
    ...  TRIM(who) AS name,
    ...  TRIM(ref_num) AS refNumber,
    ...  trans_id AS transactionId
    ...  FROM cash_adv
    ...  WHERE card_num ='${cardNumber}'
    ...  AND when BETWEEN '${begDate} 00:00' AND '${endDate} 00:00';

    ${results}  Query To Dictionaries  ${query}

    compare list dictionaries  ${results}  ${CashHistory}

Get a Error For Cash History with ${card_number} as card number, ${beg_date} as beginning date, ${end_date} as ending date and ${card_status} as card status
    ${status}  Run Keyword And Ignore Error  getCashHistoryV2  ${card_number}  ${beg_date}  ${end_date}  ${card_status}

    Set Test Variable  ${error_message}  ${status}[1]

Get Cash History with ${card_number} As Card Number, ${beg_date} As Beginning Date, ${end_date} As Ending Date And ${card_status} As Card Status
    ${status}=  getCashHistoryV2  ${card_number}  ${beg_date}  ${end_date}  ${card_status}
    # Remove first index of the list to remove the BBAL value result
    ${empty_status}=  run keyword and return status  should be empty  ${status}
    run keyword unless  ${empty_status}  Remove From List  ${status}  0

    Set Test Variable  ${service_results}  ${status}

Get Query With ${user} As Carrier And ${card_status} Card Status
    Get Into DB  TCH
    ${query}  Catenate  SELECT ca.cash_adv_id,ca.card_num,ca.amount,ca.balance,ca.id,ca.when,ca.trans_id,ca.ref_num,
    ...  ca.who,ca.parent_id,ca.contract_id,ca.show_on_report,t.invoice
    ...  FROM cash_adv ca join cards c on c.card_num = ca.card_num
    ...  left outer join transaction t on ca.trans_id = t.trans_id
    ...  WHERE (ca.show_on_report != 'N' OR ca.show_on_report is null)
    ...  AND ca.when >= '2016-01-01 00:00'
    ...  AND ca.when <= '2021-12-31 00:00'
    ...  AND c.status = '${card_status}'
    ...  AND c.carrier_id = '${user}'
    ...  ORDER BY ca.when DESC

    Set Test Variable  ${query}

Get Query With No Card Status For ${user}
    Get Into DB  TCH
    ${query}  Catenate  SELECT ca.cash_adv_id,ca.card_num,ca.amount,ca.balance,ca.id,ca.when,ca.trans_id,ca.ref_num,
    ...  ca.who,ca.parent_id,ca.contract_id,ca.show_on_report,t.invoice
    ...  FROM cash_adv ca join cards c on c.card_num = ca.card_num
    ...  left outer join transaction t on ca.trans_id = t.trans_id
    ...  WHERE (ca.show_on_report != 'N' OR ca.show_on_report is null)
    ...  AND ca.when >= '2016-01-01 00:00'
    ...  AND ca.when <= '2021-12-31 00:00'
    ...  AND c.carrier_id = '${user}'
    ...  ORDER BY ca.when DESC

    Set Test Variable  ${query}

Get Valid Dates With ${user} As Carrier And ${card_status} Card Status
    Run Keyword If  '${card_status}'=='ALL'  Get Query With No Card Status For ${user}
    ...  ELSE  Get Query With ${user} As Carrier And ${card_status} Card Status

    ${list}  Query And Strip To Dictionary  ${query}
    ${when}  Get From Dictionary  ${list}  when
    ${date}  Convert Date  ${when}[0]  result_format=%Y-%m-%d

    ${endDate}  Add Time To Date  ${date}  1 day  result_format=%Y-%m-%d
    ${begDate}  Subtract Time From Date  ${date}  5 days  result_format=%Y-%m-%d

    Set Test Variable  ${begDate}
    Set Test Variable  ${endDate}

Result Should Be Empty
    should be empty  ${service_results}

The Service Results Should Be Present In DB Results
    FOR  ${result}  IN  @{service_results}
        ${date}=  Adapt ${result.get('date')} To Better Format
        ${query}  Catenate
        ...  SELECT
        ...  ca.amount,ca.card_num,ca.cash_adv_id,ca.balance,ca.id,ca.when,ca.trans_id,ca.ref_num,ca.who,ca.parent_id,ca.contract_id, t.invoice
        ...  FROM cash_adv ca join cards c on c.card_num = ca.card_num left outer join transaction t on ca.trans_id = t.trans_id
        ...  WHERE (ca.show_on_report != 'N' OR ca.show_on_report is null)
        ...  and ca.amount = '${result.get('amount')}'
        ...  and ca.card_num = '${result.get('cardNumber')}'
        ...  and ca.id = '${result.get('cashId')}'
        ...  and ca.trans_id = '${result.get('transactionId')}'
        ...  and ca.cash_adv_id = '${result.get('cashAdvId')}'
        ...  and ca.when = '${date}'

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