*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
One Valid Card
    [Documentation]
    [Tags]  JIRA:BOT-1575
    ${card_num}  Set Variable  7083050910386613929
    ${ws_cash_all_amounts}  getCurrentCashAllAmounts  ${card_num}
    ${db_cash_all_amounts}  Get Cash Value On DB  ${card_num}
    Should Be Equal As Strings  ${ws_cash_all_amounts['cardNumber']}  ${db_cash_all_amounts['cardnumber']}
    Should Be Equal As Numbers  ${ws_cash_all_amounts['oneTimeCash']}  ${db_cash_all_amounts['onetimecash']}
    Should Be Equal As Numbers  ${ws_cash_all_amounts['recurringCash']}  ${db_cash_all_amounts['recurringcash']}
    Should Be Equal As Numbers  ${ws_cash_all_amounts['contractLimit']}  ${db_cash_all_amounts['contractlimit']}
    Should Be Equal As Numbers  ${ws_cash_all_amounts['cashAvailable']}  ${db_cash_all_amounts['cashavailable']}

List Of Valid Cards
    [Documentation]
    [Tags]  JIRA:BOT-1575
    ${card_num}  Set Variable  7083050910386613929  7083050910386614554
    ${ws_cash_all_amounts}  getCurrentCashAllAmounts  @{card_num}
    FOR  ${cash}  IN  @{ws_cash_all_amounts}
        ${db_cash_all_amounts}  Get Cash Value On DB  ${cash['cardNumber']}
        Should Be Equal As Strings  ${cash['cardNumber']}  ${db_cash_all_amounts['cardnumber']}
        Should Be Equal As Numbers  ${cash['oneTimeCash']}  ${db_cash_all_amounts['onetimecash']}
        Should Be Equal As Numbers  ${cash['recurringCash']}  ${db_cash_all_amounts['recurringcash']}
        Should Be Equal As Numbers  ${cash['contractLimit']}  ${db_cash_all_amounts['contractlimit']}
        Should Be Equal As Numbers  ${cash['cashAvailable']}  ${db_cash_all_amounts['cashavailable']}
    END

Empty Card
    [Documentation]
    [Tags]  JIRA:BOT-1575
    ${ws_error}  Run Keyword And Expect Error  *  getCurrentCashAllAmounts
    Should Contain  ${ws_error}  ERROR running command

Invalid Card
    [Documentation]
    [Tags]  JIRA:BOT-1575
    ${card_num}  Set Variable  1nv@l1d_c@rd
    ${ws_error}  Run Keyword And Expect Error  *  getCurrentCashAllAmounts  ${card_num}
    Should Contain  ${ws_error}  ERROR running command

TYPO Card
    [Documentation]
    [Tags]  JIRA:BOT-1575
    ${card_num}  Set Variable  7083050910386613929f
    ${ws_error}  Run Keyword And Expect Error  *  getCurrentCashAllAmounts  ${card_num}
    Should Contain  ${ws_error}  ERROR running command

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Get Cash Value On DB
    [Arguments]  ${card_num}
    ${query}  Catenate
    ...  SELECT cardNumber,
    ...         oneTimeCash,
    ...         recurringCash,
    ...         contractLimit,
    ...         CASE
    ...           WHEN recurringCash IS NULL THEN oneTimeCash
    ...           WHEN oneTimeCash + recurringCash > contractLimit THEN contractLimit
    ...           ELSE oneTimeCash + recurringCash
    ...         END AS cashAvailable
    ...  FROM(
    ...       SELECT cardNumber,
    ...              oneTimeCash,
    ...              decode(recurringCash, NULL, 0, recurringCash) as recurringCash,
    ...              contractLimit as contractLimit
    ...       FROM(
    ...            SELECT TRIM(cd.card_num) as cardNumber,
    ...                   ca.balance as oneTimeCash,
    ...                   CASE
    ...                     WHEN cd.lmtsrc = 'C' THEN cl.limit
    ...                     WHEN cd.lmtsrc = 'D' THEN dl.limit
    ...                     WHEN cd.lmtsrc = 'B' AND cl.limit IS NOT NULL THEN cl.limit
    ...                     WHEN cd.lmtsrc = 'B' AND cl.limit IS NULL THEN dl.limit
    ...                   END as recurringCash,
    ...                   c.cash_trans_limit as contractLimit
    ...            FROM cash_adv ca
    ...                INNER JOIN contract c on ca.contract_id = c.contract_id
    ...                INNER JOIN cards cd on cd.card_num = ca.card_num
    ...                LEFT JOIN def_lmts dl on dl.carrier_id = c.carrier_id and dl.ipolicy = cd.icardpolicy and dl.limit_id = 'CADV'
    ...                LEFT JOIN card_lmt cl on cl.card_num = cd.card_num and cl.limit_id = 'CADV'
    ...                WHERE ca.card_num = '${card_num}'
    ...                ORDER BY ca.when desc)
    ...       )
    ...       LIMIT 1;
    ${output}  Query And Strip To Dictionary  ${query}
    [Return]  ${output}