*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  DateTime

Force Tags  Web Services

Test Teardown  Teardown WS

*** Test Cases ***

Search Transactions With Valid Date Ranges
    [Tags]  tier:0  JIRA:BOT-1562  qTest:30704363  Regression  refactor
    [Documentation]  Validate you can search for transactions using valid date ranges
    [Setup]  Setup WS

    Set Test Variable  ${beginDate}  2019-03-28
    Set Test Variable  ${endDate}  2019-03-28
    Set Test Variable  ${beginTime}  00:00:00
    Set Test Variable  ${endTime}  00:39:00

#   THE WEBSERVICE RUNS IN GMT, SO IN ORDER TO REQUEST THE INFORMATION YOU HAVE TO GIVE AN HOUR EARLY
#   THAT'S WHY YOU NEED TO ADD +1 HOUR ON THE DB SQL

    Set Test Variable  ${DB_BEGIN_DATE}  2019-03-28 01:00
    Set Test Variable  ${DB_END_DATE}  2019-03-28 01:39

    ${Transactions}  getTransactions  ${beginDate}  ${endDate}  ${beginTime}  ${endTime}

#   I'M REMOVING THESE VALUES BECAUSE I CANT FIND THIS ON DB.
    Remove From Dictionary  ${Transactions}  companyXRef
    Remove From Dictionary  ${Transactions}  locationCurrency

#   CHECKING TRANS_INFO TABLE FOR THE PROMPTS
    ${ws_infos}  Pop From Dictionary  ${Transactions}  infos
    ${db_infos}  Check Trans Info on DB
    ${same_dict}  Compare List Dictionaries As Strings  ${db_infos}  ${ws_infos}
    Should Be True  ${same_dict}

#   CHECKING TRANS_LINE TABLE FOR THE PRODUCTS
    ${ws_LineItems}  Pop From Dictionary  ${Transactions}  lineItems
    ${db_lineItems}  Check Transaction Products on DB
    ${same_dict}  Compare List Dictionaries As Strings  ${db_lineItems}  ${ws_LineItems}
    Should Be True  ${same_dict}

#   CHECKING TRANSACTION TABLE FOR THE TRANSACTION INFO
    ${pos_date}  Format Date to Dic  ${Transactions}  POSDate
    ${trans_date}  Format Date to Dic  ${Transactions}  transactionDate
    Set To Dictionary  ${Transactions}  POSDate=${pos_date}
    Set To Dictionary  ${Transactions}  transactionDate=${trans_date}
    Remove From Dictionary  ${Transactions}  infos
    Remove From Dictionary  ${Transactions}  lineItems
    ${db_transactions}  Check Transactions On DB
    ${same_dict}  Compare List Dictionaries As Strings  ${db_transactions}  ${Transactions}
    Should Be True  ${same_dict}
    Tch Logging  \n ALL DB DATA CHECKS WITH WS DATA.

Search Transactions Using Valid Date Ranges With Dynamic Prompts
    [Tags]  JIRA:ATLAS-2339  qTest:119823211  Q1:2023
    [Documentation]  Using dynamic prompts validate transactions show results for value = DYNAMIC using valid date ranges
    [Setup]  Setup WS For Dynamic Prompt

    Log Into Card Management Web Services  ${carrier}  ${password}
    Get Dynamic Transaction Type and Value
    Validate Dynamic Info With DB


Search Transactions Using Only Begin Date
    [Tags]  JIRA:BOT-1562  qTest:30704364  Regression
    [Setup]  Setup WS
    ${status}  Run Keyword And Return Status  getTransactions  2019-03-24  ${empty}  00:00:00  ${empty}
    Should Not Be True  ${status}

Search Transactions Using Only End Date
    [Tags]  JIRA:BOT-1562  qTest:30704365  Regression
    [Setup]  Setup WS
    ${status}  Run Keyword And Return Status  getTransactions  ${empty}  2019-03-24  ${empty}  00:00:00
    Should Not Be True  ${status}

Search Transactions Using Null Parameters
    [Tags]  JIRA:BOT-1562  qTest:30704372  Regression
    [Setup]  Setup WS
    ${status}  Run Keyword And Return Status  getTransactions  ${empty}  ${empty}  ${empty}  ${empty}
    Should Not Be True  ${status}

Search Transactions Using Date on Future
    [Tags]  JIRA:BOT-1562  qTest:30704373  Regression
    [Setup]  Setup WS
    ${beginDate}  GetDateTimeNow  %Y-%m-%d  days=1
    ${endDate}  GetDateTimeNow  %Y-%m-%d  days=2

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}
    Should Not Be True  ${status}

Search Transactions With a Typo On the Date
    [Tags]  JIRA:BOT-1562  qTest:30704074  Regression
    [Documentation]  Validate that's not possible to get transactions searching by when it has a typo.
    [Setup]  Setup WS

        ${beginDate}  getDateTimeNow  %Y-%m-%d
        ${endDate}  getDateTimeNow  %Y-%m-%d

#   TYPO ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  getTransactions  2019-03-2X  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-?!-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  201@-03-25  ${endDate}
    Should Not Be True  ${status}

#   TYPO ON THE END DATE
    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  2019-03-2X
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  2019-?!-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  201@-03-25
    Should Not Be True  ${status}

Search Transactions With Extra Character On the Time
    [Tags]  JIRA:BOT-1562  qTest:30704300  Regression
    [Documentation]  Validate that's not possible to get transactions searching by Begin Time when it has a typo. 03 scenarios
    [Setup]  Setup WS

        ${beginDate}  getDateTimeNow  %Y-%m-%d
        ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN TIME
    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  000:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:599:00  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:59:599  00:00:00
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END TIME

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:00:00  233:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:00:00  23:599:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:00:00 23:59:599
    Should Not Be True  ${status}

Search Transactions With Extra Character On the Date
    [Tags]  JIRA:BOT-1562  qTest:30704315  Regression
    [Documentation]  Validate that's not possible to get transactions searching using a wrong date format.
    [Setup]  Setup WS

        ${beginDate}  getDateTimeNow  %Y-%m-%d
        ${endDate}  getDateTimeNow  %Y-%m-%d  days=-1

#   EXTRA CHARACTER ON THE BEGIN DATE
    ${status}  Run Keyword And Return Status  getTransactions  20190-03-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-003-25  ${endDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-03-250  ${endDate}
    Should Not Be True  ${status}

#   EXTRA CHARACTER ON THE END DATE
    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  20190-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  2019-003-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  2019-03-250
    Should Not Be True  ${status}

Search Transactions With Invalid Date
    [Tags]  JIRA:BOT-1562  qTest:30704321  Regression
    [Documentation]  Validate that's not possible to get transactions searching by Invalid Begin Date (03 scenarios)
    [Setup]  Setup WS

    ${BeginDate}  getDateTimeNow  %Y-%m-%d
    ${EndDate}  getDateTimeNow  %Y-%m-%d

#   INVALID BEGIN DATE
    ${status}  Run Keyword And Return Status  getTransactions  2019-03-65  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-15-26  ${EndDate}
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  0000-03-10  ${EndDate}
    Should Not Be True  ${status}

#INVALID END DATE
    ${status}  Run Keyword And Return Status  getTransactions  ${BeginDate}  2019-03-65
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${BeginDate}  2019-15-26
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${BeginDate}  00193-03-10
    Should Not Be True  ${status}

Search Transactions With Incomplete Dates
    [Tags]  JIRA:BOT-1562  qTest:30704325  Regression
    [Documentation]  Validate that's not possible to get transactions searching by an incomplete date format (06 scenarios)
    [Setup]  Setup WS

#   INCOMPLETE BEGIN DATE
    ${status}  Run Keyword And Return Status  getTransactions  201-03-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-3-25  2019-03-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-03-5  2019-03-10
    Should Not Be True  ${status}

#   INCOMPLETE END DATE
    ${status}  Run Keyword And Return Status  getTransactions  2019-03-10  201-03-25
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-03-10  2019-3-10
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  2019-03-10  2019-03-0
    Should Not Be True  ${status}

Search Transactions With Incomplete Times
    [Tags]  JIRA:BOT-1562  qTest:30704335  Regression
    [Documentation]  Validate that's not possible to get transactions searching by an incomplete date format (06 scenarios)
    [Setup]  Setup WS

    ${beginDate}  getDateTimeNow  %Y-%m-%d
    ${endDate}  getDateTimeNow  %Y-%m-%d

#   INCOMPLETE BEGIN TIME
    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  2:59:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  23:5:59  00:00:00
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  23:59:4  00:00:00
    Should Not Be True  ${status}

#   INCOMPLETE END TIME
    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:00:00  2:59:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:00:00  23:5:59
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  getTransactions  ${beginDate}  ${endDate}  00:00:00  23:59:0
    Should Not Be True  ${status}


*** Keywords ***
Format Date to Dic
    [Arguments]  ${Transactions}  ${key}
    ${pos_date}  Get From Dictionary  ${Transactions}  ${key}
    ${pos_date}  Get Substring  ${pos_date}  0  -10
    [Return]  ${pos_date}

Setup Test Data
    Get Into DB  TCH
    ${query}  catenate
    ...  SELECT tm.trans_id, tm.trans_meta_type_id, tm.trans_meta_data, t.carrier_id, TRIM(m.passwd) AS passwd,
    ...  t.pos_date, t.card_num, t.trans_date, t.ar_number
    ...  FROM trans_meta tm
    ...  LEFT JOIN transaction t on t.trans_id = tm.trans_id
    ...  INNER JOIN member m on m.member_id = t.carrier_id
    ...  WHERE tm.trans_meta_type_id = 'DYNAMIC_PROMPT'
    ...  AND   (tm.trans_meta_data LIKE 'CNTN%' OR tm.trans_meta_data LIKE 'TRIP%')
    ...  AND   m.status = 'A'
    ...  AND   m.mem_type = 'C'
    ...  order by t.trans_date desc
    ...  LIMIT 1;
    ${dynamicResults}  Query And Strip To Dictionary  ${query}
    ${transMetaData}  Get From Dictionary  ${dynamicResults}  trans_meta_data
    ${transId}  Get From Dictionary  ${dynamicResults}  trans_id
    Set Test Variable  ${transId}
    ${prompt}  ${value}  Split String  ${transMetaData}  =
    Set Test Variable  ${prompt}
    ${carrier}  Get From Dictionary  ${dynamicResults}  carrier_id
    Set Test Variable    ${carrier}
    ${password}  Get From Dictionary  ${dynamicResults}  passwd
    Set Test Variable    ${password}
    ${transDate}  Get From Dictionary  ${dynamicResults}  trans_date
    ${DB_BEGIN_DATE}  Convert Date  ${transDate}  result_format=%Y-%m-%d %H:%M
    Set Test Variable  ${DB_BEGIN_DATE}
    Set Test Variable  ${DB_END_DATE}  ${DB_BEGIN_DATE}
    ${date}  Convert Date  ${transDate}  result_format=%Y-%m-%d
    Set Test Variable    ${date}
    ${time}  Convert Date  ${transDate}  result_format=%H:%M:%S
    Set Test Variable    ${time}
    ${begTime}  Subtract Time From Date  ${transDate}  5 hour  result_format=%H:%M:%S
    Set Test Variable    ${begTime}
    ${endTime}  Add Time To Date  ${transDate}  5 hour  result_format=%H:%M:%S
    Set Test Variable    ${endTime}

Get Dynamic Transaction Type and Value
    ${transactions}  getTransactions  ${date}  ${date}  ${begTime}  ${endTime}
    #   CHECKING TRANS_INFO TABLE FOR THE PROMPTS
    ${ws_infos}  Pop From Dictionary  ${Transactions}  infos
    Set Test Variable  ${ws_infos}
    ${db_infos}  Check Dynamic Trans Info on DB

Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Setup WS For Dynamic Prompt
    Setup Test Data

Teardown WS
    Disconnect From Database
    logout

Check Dynamic Trans Info on DB
    ${cardInf}  catenate
    ...  SELECT ci.info_id, TRIM(ci.info_validation) AS info_validation
    ...  FROM card_inf ci
    ...  INNER JOIN transaction t ON t.card_num = ci.card_num
    ...  WHERE t.carrier_id = ${carrier}
    ...  AND   ci.info_validation = 'D'
    ...  AND   t.trans_id = ${transId};
    ${transInfo_results}  Query And Strip To Dictionary  ${cardInf}
    ${dbPrompt}  Get From Dictionary  ${transInfo_results}  info_id
    Set Test Variable  ${dbPrompt}
    ${dbValue}  Get From Dictionary  ${transInfo_results}  info_validation
    IF  '${prompt}'=='${dbPrompt}'
        IF  '${dbValue}'=='D'
            ${dbValue}  Replace String  D   D  DYNAMIC
        END
    END
    Set Test Variable  ${dbValue}

    [Return]  ${transInfo_results}

Check Transactions On DB

    ${query}  catenate
     ...    SELECT t.ar_batch_num AS ARBatchNumber,
     ...    t.cpnr_delivery_tp AS CPNRDeliveryTP,
     ...    t.op_data_source AS OPDataSource,
     ...    t.acct_type AS accountType,
     ...    t.in_addr AS inAddress,
     ...    t.trans_reported AS transReported,
     ...    t.terminal_id AS terminalId,
     ...    t.terminal_type AS terminalType,
     ...    t.reported_carrier AS reportedCarrier,
     ...    t.message_dlvd AS messageDLVD,
     ...    TO_CHAR(t.supr_fee, '&.&') AS suprFee,
     ...    DECODE(t.mc_multi_curr, NULL, 'false', TO_CHAR(t.mc_multi_curr)) AS MCMultiCurrency,
     ...    TO_CHAR(t.pos_date, '%Y-%m-%dT%H:%M:%S') AS POSDate,
     ...    TRIM(t.ar_number) AS arNumber,
     ...    TRIM(t.auth_code) AS authCode,
     ...    DECODE(t.billing_country, 'U', '85', t.billing_country) AS billingCountry,
     ...    c.currency AS billingCurrency,
     ...    t.card_num AS cardNumber,
     ...    TO_CHAR(t.carr_fee, '&.&') AS carrierFee,
     ...    t.carrier_id AS carrierId,
     ...    t.contract_id AS contractId,
     ...    TO_CHAR(t.conv_rate, '&.&') AS conversionRate,
     ...    DECODE(t.country, 'U', '85',t.country) AS country,
     ...    TO_CHAR(t.disc_amt, '&.&') AS discAmount,
     ...    DECODE(t.disc_type, 'N', '78', t.disc_type) AS discType,
     ...    TO_CHAR(t.funded_total, '&.&') AS fundedTotal,
     ...    DECODE(t.hand_entered, 'N', 'false', t.hand_entered) AS handEntered,
     ...    TRIM(t.invoice) AS invoice,
     ...    TO_CHAR(t.issr_deal, '&.&') AS issuerDeal,
     ...    TO_CHAR(t.issr_fee, '&.&') AS issuerFee,
     ...    t.issuer_id AS issuerId,
     ...    DECODE(t.language, NULL, '0',t.language) AS language,
     ...    TRIM(DECODE(l.src_country, 'USA', '85',l.src_country)) AS locationCountry,
     ...    l.location_id AS locationId,
     ...    TO_CHAR(t.net_total,'&.&') AS netTotal,
     ...    DECODE(t.non_area_fee, NULL, TO_CHAR(0,'&.&'), TO_CHAR(t.non_area_fee,'&.&')) AS nonAreaFee,
     ...    DECODE(t.over_ride, 'N', 'false', 'true') AS override,
     ...    DECODE(t.post_disc_tax, NULL, TO_CHAR(0,'&.&'),TO_CHAR(t.post_disc_tax,'&.&')) AS postDiscTax,
     ...    DECODE(t.pre_disc_tax, NULL, TO_CHAR(0,'&.&'),TO_CHAR(t.pre_disc_tax,'&.&')) AS preDiscTax,
     ...    TO_CHAR(t.pref_total, '&.&') AS prefTotal,
     ...    t.settle_amt AS settleAmount,
     ...    t.settle_id AS settleId,
     ...    DECODE(t.split_billing, NULL, 'false', t.split_billing) AS splitBilling,
     ...    t.stmt_id AS statementId,
     ...    t.supplier_id AS supplierId,
     ...    TO_CHAR(t.tax_exempt_amt, '&.&') AS taxExemptAmount,
     ...    TO_CHAR(t.trans_date, '%Y-%m-%dT%H:%M:%S') AS transactionDate,
     ...    t.trans_id AS transactionId,
     ...    t.tran_type AS transactionType

     ...     FROM TRANSACTION t,
     ...     location l,
     ...     contract c

     ...     WHERE t.location_id = l.location_id
     ...     AND   t.carrier_id = c.carrier_id
     ...     AND   t.carrier_id=${validCard.carrier.id}
     ...     AND   t.contract_id=${contract}
     ...     AND   t.contract_id=c.contract_id
     ...     AND   t.trans_date >= '${DB_BEGIN_DATE}' AND t.trans_date <= '${DB_END_DATE}'
     ...     ORDER BY t.trans_date ASC

    ${results}  Query To Dictionaries  ${query}


    [Return]  ${results}

Check Trans Info on DB

    ${query}  catenate
        ...     SELECT ti.type AS type,
        ...     TRIM(ti.info) AS value
        ...     FROM transaction t, trans_info ti
        ...     WHERE t.trans_id=ti.trans_id
        ...     AND   t.carrier_id=${validCard.carrier.id}
        ...     AND   t.contract_id=${contract}
        ...     AND   t.trans_date >= '${DB_BEGIN_DATE}' AND t.trans_date <= '${DB_END_DATE}'
    ${transInfo_results}  Query To Dictionaries  ${query}

    [Return]  ${transInfo_results}

Check Transaction Products on DB
    ${query}  catenate
        ...     SELECT TO_CHAR(tl.amt, '&&.&') AS amount,
        ...     DECODE(tl.billing_flag, 'N', '0',tl.billing_flag) AS billingFlag,
        ...     TRIM(tl.cat) AS category,
        ...     DECODE(tl.cmpt_amt, NULL, TO_CHAR(0,'&.&'),TO_CHAR(tl.cmpt_amt,'&.&'))  AS cmptAmount,
        ...     DECODE(tl.cmpt_ppu,NULL, TO_CHAR(0,'&.&'),TO_CHAR(tl.cmpt_ppu,'&.&')) AS cmptPPU,
        ...     DECODE(tl.disc_amt,NULL, TO_CHAR(0,'&.&'),TO_CHAR(tl.disc_amt,'&.&')) AS discAmount,
        ...     tl.fuel_type AS fuelType,
        ...     tl.group_cat AS groupCategory,
        ...     TO_CHAR(t.issr_deal, '&.&') AS issuerDeal,
        ...     tl.group_num AS groupNumber,
        ...     TO_CHAR(tl.issuer_deal_ppu, '&.&') AS issuerDealPPU,
        ...     tl.line_id AS lineNumber,
        ...     tl.num AS number,
        ...     TO_CHAR(tl.retail_ppu, '&.&&&') AS retailPPU,
        ...     TO_CHAR(tl.qty, '&.&&') AS quantity,
        ...     tl.prod_cd AS prodCD,
        ...     tl.serv_type AS serviceType,
        ...     tl.use_type AS useType,
        ...     TO_CHAR(tl.ppu, '&.&&&') AS ppu
        ...
        ...     FROM transaction t,
        ...     trans_line tl
        ...
        ...     WHERE t.trans_id=tl.trans_id
        ...     AND  t.contract_id=${contract}
        ...     AND  t.carrier_id=${validCard.carrier.id}
        ...     AND   t.trans_date >= '${DB_BEGIN_DATE}' AND t.trans_date <= '${DB_END_DATE}'
    ${transline_results}  Query To Dictionaries  ${query}
    [Return]  ${transline_results}

Validate Dynamic Info With DB
    FOR  ${index}  IN  @{ws_infos}
        IF  '${index['type']}'=='${prompt}'
            Should Be Equal  ${index['value']}  ${dbValue}
        END
    END