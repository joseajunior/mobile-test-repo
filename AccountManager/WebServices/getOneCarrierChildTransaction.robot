*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${parent_carrier}  141996
${child}  156748

*** Test Cases ***
Valid Input With A Single Result
    [Tags]  JIRA:BOT-1895  qTest:  Regression  refactor
    ${db_transactions}  Get DB Transactions  ${parent_carrier}  2018-12-01  2018-12-30
    ${ws_transaction}  getOneCarrierChildTransaction  ${db_transactions[0]['carrier_id']}  2018-12-01  2018-12-30
    ${ws_transactions}  Create List
    Append To List  ${ws_transactions}  ${ws_transaction}

    Format WS Data  ${ws_transactions}
    Format DB Data  ${db_transactions}

#    WORKAROUND
    Removing Not Match Values   ${ws_transactions}   ${db_transactions}

    ${ws_equal_db}  Compare List Dictionaries As Strings  ${ws_transactions}  ${db_transactions}
    Should Be True  ${ws_equal_db}

Valid Input
    [Tags]  JIRA:BOT-1895  qTest:  Regression  refactor
    ${db_transactions}  Get DB Transactions  ${parent_carrier}  2018-11-01  2018-11-07
    ${ws_transactions}  getOneCarrierChildTransaction  ${db_transactions[0]['carrier_id']}  2018-11-01  2018-11-07
    Format WS Data  ${ws_transactions}
    Format DB Data  ${db_transactions}

#    WORKAROUND
    Removing Not Match Values  ${ws_transactions}   ${db_transactions}

    ${ws_equal_db}  Compare List Dictionaries As Strings  ${ws_transactions}  ${db_transactions}
    Should Be True  ${ws_equal_db}

Search One Child Transactions Using Only Begin Date
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-24  ${empty}  00:00:00  ${empty}
    Should Not Be True  ${status}

Search One Child Transactions Using Only End Date
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${empty}  2019-03-24  ${empty}  00:00:00
    Should Not Be True  ${status}

Search One Child Transactions Using Null Parameters
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${empty}  ${empty}  ${empty}  ${empty}
    Should Not Be True  ${status}

Search One Child Transactions Using Date on Future
    [Tags]  JIRA:BOT-1895  qTest:  Regression

    ${beginDate}  GetDateTimeNow  %Y-%m-%d  days=1
    ${endDate}  GetDateTimeNow  %Y-%m-%d  days=2

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}
    Should Not Be True  ${status}

Search One Child Transactions With a Typo On the Date
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    [Documentation]  Validate that's not possible to get transactions searching by when it has a typo.

    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d

#   TYPO ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-2X  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-?!-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  201@-03-25  ${endDate}
    Should Not Be True  ${status}

#   TYPO ON THE END DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  2019-03-2X
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  2019-?!-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  201@-03-25
    Should Not Be True  ${status}

Search One Child Transactions With Extra Character On the Time
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    [Documentation]  Validate that's not possible to get transactions searching by Begin Time when it has a typo. 03 scenarios

    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN TIME
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  000:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:599:00  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:59:599  00:00:00
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END TIME

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:00:00  233:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:00:00  23:599:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:00:00 23:59:599
    Should Not Be True  ${status}

Search One Child Transactions With Extra Character On the Date
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    [Documentation]  Validate that's not possible to get transactions searching using a wrong date format.

    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  20190-03-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-003-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-250  ${endDate}
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  20190-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  2019-003-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  2019-03-250
    Should Not Be True  ${status}

Search One Child Transactions With Invalid Date
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    [Documentation]  Validate that's not possible to get transactions searching by Invalid Begin Date (03 scenarios)

    ${BeginDate}  getDateTimeNow  %Y-%m-%d
    ${EndDate}  getDateTimeNow  %Y-%m-%d

#   INVALID BEGIN DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-65  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-15-26  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  0000-03-10  ${EndDate}
    Should Not Be True  ${status}

#INVALID END DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${BeginDate}  2019-03-65
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${BeginDate}  2019-15-26
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${BeginDate}  00193-03-10
    Should Not Be True  ${status}

Search One Child Transactions With Incomplete Dates
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    [Documentation]  Validate that's not possible to get transactions searching by an incomplete date format (06 scenarios)

#   INCOMPLETE BEGIN DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  201-03-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-3-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-5  2019-03-10
    Should Not Be True  ${status}

#   INCOMPLETE END DATE
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-10  201-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-10  2019-3-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  2019-03-10  2019-03-0
    Should Not Be True  ${status}

Search One Child Transactions With Incomplete Times
    [Tags]  JIRA:BOT-1895  qTest:  Regression
    [Documentation]  Validate that's not possible to get transactions searching by an incomplete date format (06 scenarios)

    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d

#   INCOMPLETE BEGIN TIME
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  2:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  23:5:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  23:59:4  00:00:00
    Should Not Be True  ${status}

#   INCOMPLETE END TIME
    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:00:00  2:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:00:00  23:5:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getOneCarrierChildTransaction  ${child}  ${beginDate}  ${endDate}  00:00:00  23:59:0
    Should Not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT member_id, TRIM(passwd) as passwd FROM member WHERE member_id = ${parent_carrier}
    ${output}  Query And Strip To Dictionary  ${query}
    log into card management web services  ${output['member_id']}  ${output['passwd']}

Teardown WS
    Disconnect From Database
    logout

Get DB Transactions
    [Arguments]  ${parent_carrier}  ${begin_date}  ${end_date}
    ${query}  Catenate
    ...  SELECT   ca.carrier_id as carrier_id,
    ...           t.ar_batch_num AS ARBatchNumber,
    ...           t.cpnr_delivery_tp AS CPNRDeliveryTP,
    ...           DECODE(t.mc_multi_curr, NULL, 'false', TO_CHAR(t.mc_multi_curr)) AS MCMultiCurrency,
    ...           t.op_data_source AS OPDataSource,
    ...           TO_CHAR(t.pos_date, '%Y-%m-%dT%H:%M:%S') AS POSDate,
    ...           t.acct_type AS accountType,
    ...           TRIM(t.ar_number) AS arNumber,
    ...           TRIM(t.auth_code) AS authCode,
    ...           DECODE(t.billing_country, 'U', '85', t.billing_country) AS billingCountry,
    ...           c.currency AS billingCurrency,
    ...           t.card_num AS cardNumber,
    ...           TO_CHAR(t.carr_fee, '<&.&') AS carrierFee,
    ...           t.carrier_id AS carrierId,
    ...           decode(ca.coxref,"",NULL,ca.coxref) as companyXRef,
    ...           t.contract_id AS contractId,
    ...           TO_CHAR(t.conv_rate, '<&.&') AS conversionRate,
    ...           DECODE(t.country, 'U', '85',t.country) AS country,
    ...           TO_CHAR(t.disc_amt, '<&.&') AS discAmount,
    ...           DECODE(t.disc_type, 'N', '78', t.disc_type) AS discType,
    ...           TO_CHAR(t.funded_total, '<&.&') AS fundedTotal,
    ...           DECODE(t.hand_entered, 'N', 'false', t.hand_entered) AS handEntered,
    ...           t.in_addr AS inAddress,
    ...           TRIM(t.invoice) AS invoice,
    ...           TO_CHAR(t.issr_deal, '<&.&') AS issuerDeal,
    ...           TO_CHAR(t.issr_fee, '<&.&') AS issuerFee,
    ...           t.issuer_id AS issuerId,
    ...           DECODE(t.language, NULL, '0',t.language) AS language,
    ...           TRIM(DECODE(l.src_country, 'USA', '85',l.src_country)) AS locationCountry,
    ...           decode(1,null,'') AS locationCurrency,
    ...           l.location_id AS locationId,
    ...           t.message_dlvd AS messageDLVD,
    ...           TO_CHAR(t.net_total,'<&.&') AS netTotal,
    ...           DECODE(t.non_area_fee, NULL, TO_CHAR(0,'<&.&'), TO_CHAR(t.non_area_fee,'<&.&')) AS nonAreaFee,
    ...           DECODE(t.over_ride, 'N', 'false', 'true') AS override,
    ...           DECODE(t.post_disc_tax, NULL, TO_CHAR(0,'<&.&'),TO_CHAR(t.post_disc_tax,'<&.&')) AS postDiscTax,
    ...           DECODE(t.pre_disc_tax, NULL, TO_CHAR(0,'<&.&'),TO_CHAR(t.pre_disc_tax,'<&.&')) AS preDiscTax,
    ...           TO_CHAR(t.pref_total, '<&.&') AS prefTotal,
    ...           t.reported_carrier AS reportedCarrier,
    ...           TO_CHAR(t.settle_amt,'<&.&&') AS settleAmount,
    ...           t.settle_id AS settleId,
    ...           DECODE(t.split_billing, NULL, 'false', t.split_billing) AS splitBilling,
    ...           t.stmt_id AS statementId,
    ...           t.supplier_id AS supplierId,
    ...           TO_CHAR(t.supr_fee, '<&.&&') AS suprFee,
    ...           TO_CHAR(t.tax_exempt_amt, '<&.&') AS taxExemptAmount,
    ...           t.terminal_id AS terminalId,
    ...           t.terminal_type AS terminalType,
    ...           t.trans_reported AS transReported,
    ...           TO_CHAR(t.trans_date, '%Y-%m-%dT%H:%M:%S') AS transactionDate,
    ...           t.trans_id AS transactionId,
    ...           t.tran_type AS transactionType
    ...  FROM TRANSACTION t
    ...         INNER JOIN location l ON t.location_id = l.location_id
    ...         inner JOIN contract c ON t.contract_id = c.contract_id
    ...         INNER JOIN carrier_group_xref cgx ON cgx.carrier_id = t.carrier_id
    ...         INNER JOIN cards ca ON ca.card_num = t.card_num
    ...  WHERE cgx.parent = ${parent_carrier}
    ...  AND   cgx.expire_date >= TODAY
    ...  AND   t.trans_date >= TO_DATE('${begin_date}','%Y-%m-%d') AND t.trans_date <= TO_DATE('${end_date}','%Y-%m-%d')
    ...  ORDER BY POSDate
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}

Format WS Data
    [Arguments]  ${transactions}
    FOR  ${transaction}  IN  @{transactions}
        ${pos_date}  Get Substring  ${transaction['POSDate']}  0  -10
        ${transaction_date}  Get Substring  ${transaction['transactionDate']}  0  -10
        Set To Dictionary  ${transaction}  POSDate  ${pos_date}
        Set To Dictionary  ${transaction}  transactionDate  ${transaction_date}
    END

Format DB Data
    [Arguments]  ${transactions}
    FOR  ${transaction}  IN  @{transactions}
        ${last_number}  Get Substring  ${transaction['settleamount']}  -1
        ${settle_amount}  Run Keyword If  '${last_number}'=='0'
        ...  Get Substring  ${transaction['settleamount']}  0  -1
        ...  ELSE
        ...  Set Variable  ${transaction['settleamount']}
        Set To Dictionary  ${transaction}  settleamount  ${settle_amount}
    END
    Add Sublists To DB Dictionaries  ${transactions}

Add Sublists To DB Dictionaries
    [Arguments]  ${transactions}
    FOR  ${transaction}  IN  @{transactions}
        ${infos}  Get Transaction Info  ${transaction['transactionid']}
        ${qtd_infos}  Get Length  ${infos}
        Run Keyword If  ${qtd_infos} > 0
        ...  Set To Dictionary  ${transaction}  infos  ${infos}
        ${line_items}  Get Transaction Line Items  ${transaction['transactionid']}
        ${qtd_line_itens}  Get Length  ${line_items}
        Run Keyword If  ${qtd_line_itens} > 0
        ...  Set To Dictionary  ${transaction}  lineItems  ${line_items}
    END

Get Transaction Info
    [Arguments]  ${transaction_id}
    ${query}  Catenate
    ...     SELECT ti.type AS type,
    ...            TRIM(ti.info) AS value
    ...     FROM transaction t
    ...         INNER JOIN trans_info ti ON t.trans_id=ti.trans_id
    ...     WHERE t.trans_id = ${transaction_id}
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}

Get Transaction Line Items
    [Arguments]  ${transaction_id}
    ${query}  Catenate
    ...  SELECT TO_CHAR(tl.amt, '<&.&') AS amount,
    ...         DECODE(tl.billing_flag, 'N', '0',tl.billing_flag) AS billingFlag,
    ...         TRIM(tl.cat) AS category,
    ...         DECODE(tl.cmpt_amt, NULL, TO_CHAR(0,'&.&'),TO_CHAR(tl.cmpt_amt,'&.&'))  AS cmptAmount,
    ...         DECODE(tl.cmpt_ppu,NULL, TO_CHAR(0,'&.&'),TO_CHAR(tl.cmpt_ppu,'&.&')) AS cmptPPU,
    ...         DECODE(tl.disc_amt,NULL, TO_CHAR(0,'&.&'),TO_CHAR(tl.disc_amt,'&.&')) AS discAmount,
    ...         tl.fuel_type AS fuelType,
    ...         TRIM(tl.group_cat) AS groupCategory,
    ...         tl.group_num AS groupNumber,
    ...         TO_CHAR(t.issr_deal, '<&.&') AS issuerDeal,
    ...         TO_CHAR(tl.issuer_deal_ppu, '<&.&') AS issuerDealPPU,
    ...         tl.line_id AS lineNumber,
    ...         tl.num AS number,
    ...         TO_CHAR(tl.ppu, '<&.&') AS ppu,
    ...         tl.prod_cd AS prodCD,
    ...         TO_CHAR(tl.qty, '<&.&') AS quantity,
    ...         TO_CHAR(tl.retail_ppu, '<&.&') AS retailPPU,
    ...         tl.serv_type AS serviceType,
    ...         tl.use_type AS useType
    ...  FROM transaction t
    ...        INNER JOIN trans_line tl ON t.trans_id=tl.trans_id
    ...  WHERE t.trans_id = ${transaction_id}
    ${output}  Query And Strip To Dictionary  ${query}
    [Return]  ${output}

Removing Not Match Values
    [Arguments]  ${ws_values}  ${db_values}
    FOR  ${ws}  IN  @{ws_values}
        Remove From Dictionary  ${ws}  suprFee
    END

    FOR  ${db}  IN  @{db_values}
        Remove From Dictionary  ${db}  suprfee
        Remove From Dictionary  ${db}  carrier_id
    END