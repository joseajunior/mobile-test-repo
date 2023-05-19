*** Settings ***
Library  otr_robot_lib.ws.MicroServices
Library  TCHOracleJaxWS
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_robot_lib.support.PyLibrary
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Library  String
Library  DateTime
Resource  ../../Variables/validUser.robot

Suite Setup

Force Tags  Web Services  TCHOracleJaxWS  refactor

*** Variables ***



*** Test Cases ***


Call the TCHOracleJaxWS WSDL
    [Tags]  qTest:46920611
    Verify WSDL returns

Call the getCustomerCreditInfo API endpoint
    [Tags]  qTest:47584779
    Get the Customer Credit Info from the webservice call and the database  0006330890211
    Verify getCustomerCreditInfo returns correct Credit Limit info
    Verify getCustomerCreditInfo returns correct Last Changed By info
    Verify getCustomerCreditInfo returns correct Last Changed Dt info
    Verify getCustomerCreditInfo returns correct Prev Credit Limit info
    Verify getCustomerCreditInfo returns correct Prev Changed By info
    Verify getCustomerCreditInfo returns correct Prev Changed Dt info

Call the getCustomerAchInfo API endpoint
    [Tags]  qTest:48879934
    Get the Customer ACH Info from the webservice call and the database  0006330890211
    Verify getCustomerAchInfo returns the correct bank account number
    Verify getCustomerAchInfo returns the correct email
    Verify getCustomerAchInfo returns the correct fax number
    Verify getCustomerAchInfo returns the correct check digit
    Verify getCustomerAchInfo returns the correct currency code
    Verify getCustomerAchInfo returns the correct country code
    Verify getCustomerAchInfo returns the correct method
    Verify getCustomerAchInfo returns the correct notification method
    Verify getCustomerAchInfo returns the correct ACH payment flag
    Verify getCustomerAchInfo returns the correct routing number

Call getPstDueInvoices API endpoint
    [Tags]  qTest:48879953
    Get the Past Due Invoices from the webservice call and the database  0006330250802

#     **********************This feature requires other interactions that cannot be automated at this time************
#Call customerValidation API endpoint
#
#    Get the Customer Validation from the webservice call and the database  0006330890211

Call getARAging API endpoint
    [Tags]  qTest:48879980
    Verify getARAging API endpoint returns correct data  0006331804611

Call getAppliedPayments API endpoint
    [Tags]  qTest:48879983
    Verify getAppliedPayments API endpoint returns correct data  0006331804611

Call getLookup API endpoint
    [Tags]  qTest:48879984
    Verify getLookup using CUSTOMER name returns correctly
    Verify getLookup using ORG name returns correctly
    Verify getLookup using COLLECTOR name returns correctly
    Verify getLookup using MGR_CODES name returns correctly
#    Get the lookup from the webservice call  TERMS     (These don't seem to work at all in here or postman and won't be fixed)
#    Get Lookup TERMS Y from DB  0006330890211  Y      (These don't seem to work at all in here or postman and won't be fixed)
#    Get Lookup TERMS N from DB  0006330890211  N      (These don't seem to work at all in here or postman and won't be fixed)
#    Verify getLookup using CYCLES name returns correctly  #Webservice returns nothing, but query does



*** Keywords ***

Verify WSDL returns
    ${CurrentWSDL}  call_TCHOracleJaxWS_WSDL
    ${WSDLState}  Check xml string is properly formatted  ${CurrentWSDL}
    should be true  ${WSDLState}  WSDL doesn't look correctly formatted

Get the Customer Credit Info from the webservice call and the database
    [Arguments]  ${arnumber}
    ${creditInfo}  call_getCustomerCreditInfo  ${arnumber}
    set test variable  ${creditInfo}  ${creditInfo}
    Get Customer Credit Info from DB  ${arnumber}

Verify getCustomerCreditInfo returns correct Credit Limit info
    ${Credit_Limit}  convert to integer  ${creditInfo["creditLineAmt"]}
    should be equal  ${Credit_Limit}  ${dbInfo["CREDITLINEAMT"]}  The credit line amount from the
        ...  TCHOraclJaxWS call of ${Credit_Limit} does not match the credit line amount
        ...  from the database of ${dbInfo["CREDITLINEAMT"]}

Verify getCustomerCreditInfo returns correct Last Changed By info
    should be equal  ${creditInfo["creditLineBy"]}  ${dbInfo["CREDITLINEBY"]}  The Last Changed By from the
        ...  TCHOraclJaxWS call of ${creditInfo["creditLineBy"]} does not match the CREDITLINEBY
        ...  from the database of ${dbInfo["CREDITLINEBY"]}

Verify getCustomerCreditInfo returns correct Last Changed Dt info
    ${datews}=  set variable  ${creditInfo["creditLineDate"].replace("T"," ")}
    ${datews}=  set variable  ${datews[:-6]}
    ${datedb}  convert to string  ${dbInfo["CREDITLINEDATE"]}
    should be equal  ${datews}  ${datedb}  The Last Changed Date from the
        ...  TCHOraclJaxWS call of ${datews} does not match the Credit Line Date
        ...  from the database of ${datedb}

Verify getCustomerCreditInfo returns correct Prev Credit Limit info
    ${PrevCredit_Limit}  convert to integer  ${creditInfo["prevCreditLineAmt"]}
    should be equal  ${PrevCredit_Limit}  ${dbInfo["PREVCREDITLINEAMT"]}  The previous credit line amount from the
        ...  TCHOraclJaxWS call of ${PrevCredit_Limit} does not match the previous credit line amount
        ...  from the database of ${dbInfo["PREVCREDITLINEAMT"]}

Verify getCustomerCreditInfo returns correct Prev Changed By info
    should be equal  ${creditInfo["prevCreditLineBy"]}  ${dbInfo["PREVCREDITLINEBY"]}  The previous changed by from the
        ...  TCHOraclJaxWS call of ${creditInfo["prevCreditLineBy"]} does not match the previous changed by
        ...  from the database of ${dbInfo["PREVCREDITLINEBY"]}

Verify getCustomerCreditInfo returns correct Prev Changed Dt info
    ${prevdatews}=  set variable  ${creditInfo["prevCreditLineDate"].replace("T"," ")}
    ${prevdatews}=  set variable  ${prevdatews[:-6]}
    ${prevdatedb}  convert to string  ${dbInfo["PREVCREDITLINEDATE"]}
    should be equal  ${prevdatews}  ${prevdatedb}  The previous changed date from the
        ...  TCHOraclJaxWS call of ${prevdatews} does not match the previous changed date amount
        ...  from the database of ${prevdatedb}

Get Customer Credit Info from DB
    [Arguments]  ${arnumber}
    Get Into DB  ORACLE
    ${query}  catenate
    ...  select
    ...  hcpa.OVERALL_CREDIT_LIMIT as creditLineAmt,
    ...  TO_DATE(hcpa.attribute1) AS creditLineDate,
    ...  hcpa.attribute2 AS creditLineBy,
    ...  TO_NUMBER(hcpa.attribute3) AS prevCreditLineAmt,
    ...  TO_DATE(hcpa.attribute4) AS prevCreditLineDate,
    ...  hcpa.attribute5 AS prevCreditLineBy
    ...  from hz_cust_profile_amts hcpa, hz_cust_site_uses_all hcsua
    ...  where hcsua.site_use_id = hcpa.site_use_id
    ...  and hcsua.location = '${arnumber}'
    ...  and hcpa.OVERALL_CREDIT_LIMIT is not Null
    ${dbInfo} =  query and strip to dictionary  ${query}
    set test variable  ${dbInfo}  ${dbInfo}

Get the Customer ACH Info from the webservice call and the database
    [Arguments]  ${arnumber}
    ${ACHInfo}  call_getCustomerAchInfo  ${arnumber}
    set test variable  ${ACHInfo}  ${ACHInfo}
    Get Customer ACH Info from DB  ${arnumber}

Get Customer ACH Info from DB
    [Arguments]  ${arnumber}
    Get Into DB  ORACLE
    ${query}  catenate
        ...  SELECT MAX(SUBSTR(b.branch_number, 1, 8)) AS routing_nbr,
        ...         MAX(a.check_digits) AS check_digit,
        ...         MAX(a.bank_account_num) AS account_nbr,
        ...         MAX(DECODE(a.bank_account_type, 'Checking', 'D', 'Savings', 'S', NULL)) AS account_type,
        ...         MAX(b.bank_home_country) AS domicile,
        ...         MAX(a.currency_code) AS currency_code,
        ...         MAX(DECODE(p.debit_advice_delivery_method, 'EMAIL', 1, 'FAX', 2, 'PRINTED', 3, NULL)) AS notify_method,
        ...         MAX(p.debit_advice_email) AS ach_email,
        ...         MAX(NULL) AS ach_email_name,
        ...         MAX(p.debit_advice_fax) AS ach_fax,
        ...         MAX(CASE
        ...             WHEN SYSDATE BETWEEN cm.start_date AND NVL(cm.end_date, SYSDATE + 1)
        ...             THEN 'Y'
        ...             ELSE 'N'
        ...         END) AS pay_flag,
        ...         MAX(m.attribute1) AS method_attr
        ...    FROM hz_cust_acct_sites_all s,
        ...         hz_cust_site_uses_all u,
        ...         iby_external_payers_all p,
        ...         iby_pmt_instr_uses_all i,
        ...         iby_ext_bank_accounts a,
        ...         ce_bank_branches_v b,
        ...         ra_cust_receipt_methods cm,
        ...         ar_receipt_methods m
        ...   WHERE s.orig_system_reference = '${arnumber}'
        ...     AND u.cust_acct_site_id = s.cust_acct_site_id
        ...     AND p.cust_account_id = s.cust_account_id
        ...     AND i.ext_pmt_party_id = p.ext_payer_id
        ...     AND a.ext_bank_account_id = i.instrument_id
        ...     AND b.branch_party_id = a.branch_id
        ...     AND cm.site_use_id = u.site_use_id
        ...     AND m.receipt_method_id = cm.receipt_method_id
        ...   ORDER BY s.orig_system_reference
    ${dbInfo} =  query and strip to dictionary  ${query}
    set test variable  ${dbInfo}  ${dbInfo}

Verify getCustomerAchInfo returns the correct bank account number
    should be equal as strings  ${ACHInfo["accountNbr"]}  ${dbInfo["ACCOUNT_NBR"]}  The account number from the
        ...  TCHOraclJaxWS call of ${ACHInfo["accountNbr"]} does not match the account number from the
        ...  database of ${dbInfo["ACCOUNT_NBR"]}

Verify getCustomerAchInfo returns the correct email
    should be equal as strings  ${ACHInfo["achEmail"]}  ${dbInfo["ACH_EMAIL"]}  The email address from the
        ...  TCHOraclJaxWS call of ${ACHInfo["achEmail"]} does not match the email address from the
        ...  database of ${dbInfo["ACH_EMAIL"]}

Verify getCustomerAchInfo returns the correct fax number
    should be equal as strings  ${ACHInfo["achFax"]}  ${dbInfo["ACH_FAX"]}  The fax number from the
        ...  TCHOraclJaxWS call of ${ACHInfo["achFax"]} does not match the fax number from the
        ...  database of ${dbInfo["ACH_FAX"]}

Verify getCustomerAchInfo returns the correct check digit
    ${dbInfo["CHECK_DIGIT"]}  run keyword if  '${dbInfo["CHECK_DIGIT"]}' == ' '  set variable  None
    should be equal as strings  ${ACHInfo["checkDigit"]}  ${dbInfo["CHECK_DIGIT"]}  The check digit from the
        ...  TCHOraclJaxWS call of ${ACHInfo["checkDigit"]} does not match the check digit from the
        ...  database of ${dbInfo["CHECK_DIGIT"]}

Verify getCustomerAchInfo returns the correct currency code
    should be equal as strings  ${ACHInfo["currencyCode"]}  ${dbInfo["CURRENCY_CODE"]}  The currency code from the
        ...  TCHOraclJaxWS call of ${ACHInfo["currencyCode"]} does not match the currency code from the
        ...  database of ${dbInfo["CURRENCY_CODE"]}

Verify getCustomerAchInfo returns the correct country code
    should be equal as strings  ${ACHInfo["domicile"]}  ${dbInfo["DOMICILE"]}  The country code from the
        ...  TCHOraclJaxWS call of ${ACHInfo["domicile"]} does not match the country code from the
        ...  database of ${dbInfo["DOMICILE"]}

Verify getCustomerAchInfo returns the correct method
    should be equal as strings  ${ACHInfo["methodAttr"]}  ${dbInfo["METHOD_ATTR"]}  The method from the
        ...  TCHOraclJaxWS call of ${ACHInfo["methodAttr"]} does not match the method from the
        ...  database of ${dbInfo["METHOD_ATTR"]}

Verify getCustomerAchInfo returns the correct notification method
    should be equal as strings  ${ACHInfo["notifyMethod"]}  ${dbInfo["NOTIFY_METHOD"]}  The notification method from the
        ...  TCHOraclJaxWS call of ${ACHInfo["notifyMethod"]} does not match the notification method from the
        ...  database of ${dbInfo["NOTIFY_METHOD"]}

Verify getCustomerAchInfo returns the correct ACH payment flag
    should be equal as strings  ${ACHInfo["payFlag"]}  ${dbInfo["PAY_FLAG"]}  The epayment flag from the
        ...  TCHOraclJaxWS call of ${ACHInfo["payFlag"]} does not match the payment flag from the
        ...  database of ${dbInfo["PAY_FLAG"]}

Verify getCustomerAchInfo returns the correct routing number
    should be equal as strings  ${ACHInfo["routingNbr"]}  ${dbInfo["ROUTING_NBR"]}  The routing number from the
        ...  TCHOraclJaxWS call of ${ACHInfo["routingNbr"]} does not match the routing number from the
        ...  database of ${dbInfo["ROUTING_NBR"]}

Get the Past Due Invoices from the webservice call and the database
    [Arguments]  ${arnumber}
    ${PastDueInv}  call_getPstDueInvoices  ${arnumber}
    set test variable  ${PastDueInv}   ${PastDueInv}
    Get Past Due Invoices from DB  ${arnumber}
    Verify getPstDueInvoices returns correct information

Get Past Due Invoices from DB
    [Arguments]  ${arnumber}
    Get Into DB  ORACLE
    ${query}  catenate
         ...  SELECT su.location AS ar_number,
         ...        TO_CHAR(ps.trx_date, 'YYYY-MM-DD') AS inv_date,
         ...        TO_CHAR(ps.due_date, 'YYYY-MM-DD') AS inv_due_date,
         ...        ps.trx_number AS inv_id,
         ...        ps.amount_due_original AS invoice_amt,
         ...        (SELECT name FROM ra_terms t WHERE t.term_id = ps.term_id) AS inv_terms
         ...  FROM ar_payment_schedules_all ps,
         ...        ra_customer_trx_all ct,
         ...        hz_cust_site_uses_all su,
         ...        ra_cust_trx_types_all tt
         ...  WHERE su.location = '${arnumber}'
         ...    AND su.site_use_code = 'BILL_TO'
         ...    AND tt.name = 'Consolidated Inv'
         ...    AND ct.bill_to_site_use_id = su.site_use_id
         ...    AND ct.cust_trx_type_id = tt.cust_trx_type_id
         ...    AND ps.customer_trx_id = ct.customer_trx_id
         ...    AND ps.status = 'OP'
         ...    AND ps.class = 'INV'
         ...    AND ps.amount_due_remaining != 0
         ...    AND ps.due_date < TRUNC(SYSDATE)
    ${dbInfo} =  query and strip to dictionary  ${query}
    set test variable  ${dbInfo}  ${dbInfo}

Verify getPstDueInvoices returns correct information
    [Arguments]
    @{list}  set variable  ${PastDueInv}
    FOR    ${keys}    IN    @{list}
        Compare Values of getPstDueInvoices information  "${keys}"
    END

Compare Values of getPstDueInvoices information
    [Arguments]  ${key}
    ${wslist}  set variable  ${PastDueInv[${key}]}
    ${dbkey} =  convert to upper case  ${key}
    ${dblist}  set variable  ${dbInfo[${dbkey}]}
    Lists Should Be Equal  ${wslist}  ${dblist}  The ${key} values from the
        ...  TCHOraclJaxWS call of ${wslist} do not match the ${key} values from the
        ...  database of ${dblist}

#     **********************This feature requires other interactions that cannot be automated at this time************
#Get the Customer Validation from the webservice call and the database
#    [Arguments]  ${arnumber}
#    ${CustVal}  call_customerValidation  ${arnumber}
#    set test variable  ${CustVal}   ${CustVal}
#    Get Customer Validation from DB  ${arnumber}

Verify getARAging API endpoint returns correct data
    [Arguments]  ${arnumber}
    Get the AR Aging from the webservice call and the database  ${arnumber}
    Verify getARAging returns correct information

Get the AR Aging from the webservice call and the database
    [Arguments]  ${arnumber}
    ${todayDate}  getDateTimeNow  %Y-%m-%d
    ${araging}  call_getArAging  ${arnumber}  ${todayDate}
    set test variable  ${araging}   ${araging}
    Get AR Aging from DB  ${arnumber}

Verify getARAging returns correct information
    FOR    ${keys}    IN    @{araging}
        ${wsValue}  get from dictionary  ${araging}  ${keys}
        ${keys}=  convert to upper case  ${keys}
        ${dbValue}  Get From Dictionary  ${dbInfo}  ${keys}

        should be equal as strings  ${wsValue}  ${dbValue}  The ${keys} from the
            ...  TCHOraclJaxWS call of ${wsValue} does not match the ${keys} from the
            ...  database of ${dbValue}
    END

Get AR Aging from DB
    [Arguments]  ${arnumber}
    ${todayDate}  getDateTimeNow  %Y-%m-%d
    Get Into DB  ORACLE
    ${query}  catenate
	        ...  SELECT SUM(unbilled) AS unbilled,
			...         SUM(current_bal) AS currentBal,
			...         SUM(aging_1) AS aging1,
			...         SUM(aging_2) AS aging2,
			...         SUM(aging_3) AS aging3,
			...         SUM(aging_4) AS aging4,
			...         SUM(aging_5) AS aging5,
			...         SUM(aging_6) AS aging6,
			...         MAX(late_1) AS late1,
			...         MAX(late_2) AS late2,
			...         MAX(late_3) AS late3,
			...         MAX(late_4) AS late4,
			...         MAX(late_5) AS late5,
			...         MAX(late_6) AS late6,
			...         MAX(late_7) AS late7,
			...         MAX(late_8) AS late8,
			...         MAX(late_9) AS late9,
			...         MAX(late_10) AS late10,
			...         MAX(late_11) AS late11,
			...         MAX(late_12) AS late12
			...  FROM (SELECT
			...                 CASE WHEN (t.name = 'Net 180') THEN sch.amount_due_remaining ELSE 0 END AS unbilled,
			...                 CASE WHEN (t.name != 'Net 180') AND (to_date('${todayDate}', 'yyyy-mm-dd')
			...                 < sch.due_date) THEN sch.amount_due_remaining ELSE 0 END AS current_bal,
			...                 CASE WHEN (t.name != 'Net 180') AND (to_date('${todayDate}', 'yyyy-mm-dd')
			...                 - sch.due_date) BETWEEN 1 AND 15 THEN sch.amount_due_remaining ELSE 0 END AS aging_1,
			...                 CASE WHEN (t.name != 'Net 180') AND (to_date('${todayDate}', 'yyyy-mm-dd')
			...                 - sch.due_date) BETWEEN 16 AND 30 THEN sch.amount_due_remaining ELSE 0 END AS aging_2,
			...                 CASE WHEN (t.name != 'Net 180') AND (to_date('${todayDate}', 'yyyy-mm-dd')
			...                 - sch.due_date) BETWEEN 31 AND 45 THEN sch.amount_due_remaining ELSE 0 END AS aging_3,
			...                 CASE WHEN (t.name != 'Net 180') AND (to_date('${todayDate}', 'yyyy-mm-dd')
			...                 - sch.due_date) BETWEEN 46 AND 60 THEN sch.amount_due_remaining ELSE 0 END AS aging_4,
			...                 CASE WHEN (t.name != 'Net 180') AND (to_date('${todayDate}', 'yyyy-mm-dd')
			...                 - sch.due_date) BETWEEN 61 AND 90 THEN sch.amount_due_remaining ELSE 0 END AS aging_5,
			...                 CASE WHEN (t.name != 'Net 180') AND (to_date('${todayDate}', 'yyyy-mm-dd')
			...                 - sch.due_date) >= 91 THEN sch.amount_due_remaining ELSE 0 END AS aging_6,
			...                 NULL AS late_1,
			...                 NULL AS late_2,
			...                 NULL AS late_3,
			...                 NULL AS late_4,
			...                 NULL AS late_5,
			...                 NULL AS late_6,
			...                 NULL AS late_7,
			...                 NULL AS late_8,
			...                 NULL AS late_9,
			...                 NULL AS late_10,
			...                 NULL AS late_11,
			...                 NULL AS late_12
			...            FROM ar_payment_schedules_all sch,
			...                 hz_cust_site_uses_all u,
			...                 hz_cust_acct_sites_all s,
			...                 ra_terms t
			...           WHERE sch.customer_site_use_id = u.site_use_id
			...             AND u.cust_acct_site_id = s.cust_acct_site_id
			...             AND t.term_id = sch.term_id
			...             AND u.site_use_code = 'BILL_TO'
			...             AND s.orig_system_reference = '${arnumber}'
			...             AND sch.status = 'OP'
			...             AND sch.class = 'INV'
			...             AND sch.amount_due_remaining > 0
			...          UNION ALL
			...          SELECT NULL AS unbilled,
			...                 NULL AS current_bal,
			...                 NULL AS aging_1,
			...                 NULL AS aging_2,
			...                 NULL AS aging_3,
			...                 NULL AS aging_4,
			...                 NULL AS aging_5,
			...                 NULL AS aging_6,
			...                 CASE WHEN ord = 1 THEN days_late ELSE NULL END AS late_1,
			...                 CASE WHEN ord = 2 THEN days_late ELSE NULL END AS late_2,
			...                 CASE WHEN ord = 3 THEN days_late ELSE NULL END AS late_3,
			...                 CASE WHEN ord = 4 THEN days_late ELSE NULL END AS late_4,
			...                 CASE WHEN ord = 5 THEN days_late ELSE NULL END AS late_5,
			...                 CASE WHEN ord = 6 THEN days_late ELSE NULL END AS late_6,
			...                 CASE WHEN ord = 7 THEN days_late ELSE NULL END AS late_7,
			...                 CASE WHEN ord = 8 THEN days_late ELSE NULL END AS late_8,
			...                 CASE WHEN ord = 9 THEN days_late ELSE NULL END AS late_9,
			...                 CASE WHEN ord = 10 THEN days_late ELSE NULL END AS late_10,
			...                 CASE WHEN ord = 11 THEN days_late ELSE NULL END AS late_11,
			...                 CASE WHEN ord = 12 THEN days_late ELSE NULL END AS late_12
			...            FROM (SELECT s.orig_system_reference,
			...                         cr.deposit_date,
			...                         sch.due_date,
			...                         CASE WHEN (cr.deposit_date - sch.due_date) < 0 THEN 0 ELSE cr.deposit_date - sch.due_date END AS days_late,
			...                         RANK() OVER(ORDER BY cr.deposit_date DESC) AS ord
			...                    FROM ar_payment_schedules_all sch,
			...                         ar_cash_receipts_all cr,
			...                         hz_cust_site_uses_all u,
			...                         hz_cust_acct_sites_all s
			...                   WHERE sch.customer_site_use_id = u.site_use_id
			...                     AND cr.customer_site_use_id = u.site_use_id
			...                     AND u.cust_acct_site_id = s.cust_acct_site_id
			...                     AND cr.cash_receipt_id = sch.cash_receipt_id
			...                     AND u.site_use_code = 'BILL_TO'
			...                     AND s.orig_system_reference = '${arnumber}') b
			...           WHERE b.ord <= 12) c
    ${dbInfo} =  query and strip to dictionary  ${query}
    set test variable  ${dbInfo}  ${dbInfo}

Verify getLookup using CUSTOMER name returns correctly
    Get the lookup from the webservice call  CUSTOMER  0006330890211
    Get Lookup CUSTOMER from DB  0006330890211
    Verify Lookup returns correct information

Verify getLookup using ORG name returns correctly
    Get the lookup from the webservice call  ORG  0006330890211
    Get Lookup ORG from DB
    Verify Lookup returns correct information

Verify getLookup using COLLECTOR name returns correctly
    Get the Lookup from the webservice call  COLLECTOR  0006330890211
    Get Lookup COLLECTOR from DB
    Verify Lookup returns correct information

Verify getLookup using MGR_CODES name returns correctly
    Get the lookup from the webservice call  MGR_CODES  0006330890211
    Get Lookup MGR_CODES from DB
    Verify Lookup returns correct information

Verify getLookup using CYCLES name returns correctly
#    ******************** The webservice through the API returns nothing, but the query does. ***********************
    Get the lookup from the webservice call  CYCLES  0006330890211
    Get Lookup CYCLES from DB
    Verify Lookup returns correct information

Get Lookup CUSTOMER from DB
    [Arguments]  ${arnumber}
    Get Into DB  ORACLE
    ${query}  catenate
        ...  SELECT DECODE(lev, 1, 'CARRIER_ID',
        ...                     2, 'TERMS',
        ...                     3, 'CYCLE',
        ...                     4, 'COLLECTOR',
        ...                     5, 'CURRENCY',
        ...                     6, 'RECEIPT_METHOD_ATTR',
        ...                     7, 'REC_TYPE',
        ...                     8, 'LOCKBOX',
        ...                     9, 'NOTIFY_METHOD', NULL) AS key,
        ...         DECODE(lev, 1, carrier_id,
        ...                     2, terms,
        ...                     3, oracle_cycle,
        ...                     4, collector,
        ...                     5, currency,
        ...                     6, receipt_method_attr,
        ...                     7, rec_type,
        ...                     8, lockbox,
        ...                     9, notify_method, NULL) AS value
        ...    FROM (SELECT a.orig_system_reference AS carrier_id,
        ...                 (SELECT TRIM(SUBSTR(name, 4))
        ...                    FROM ra_terms
        ...                   WHERE term_id = p.standard_terms) AS terms,
        ...                 (SELECT name
        ...                    FROM ar_statement_cycles
        ...                   WHERE status = 'A'
        ...                     AND statement_cycle_id = p.statement_cycle_id) AS oracle_cycle,
        ...                 p.statement_cycle_id,
        ...                 (SELECT name
        ...                    FROM ar_collectors
        ...                   WHERE collector_id = p.collector_id) AS collector,
        ...                 ps.attribute13 AS currency,
        ...                 m.attribute1 AS receipt_method_attr,
        ...                 SUBSTR(pty.party_type, 1, 1) AS rec_type,
        ...                 ps.attribute4 AS lockbox,
        ...                 DECODE(ps.attribute11, 'E-Mail Notification', 1, 'Fax Notification', 2, 0) AS notify_method,
        ...                 l.lev
        ...            FROM hz_cust_site_uses_all u,
        ...                 hz_cust_acct_sites_all s,
        ...                 hz_cust_accounts a,
        ...                 hz_customer_profiles p,
        ...                 hz_party_sites ps,
        ...                 hz_parties pty,
        ...                 ar_receipt_methods m,
        ...                 (SELECT * FROM ra_cust_receipt_methods
        ...                   WHERE SYSDATE BETWEEN start_date AND NVL(end_date, SYSDATE)) r,
        ...                 (SELECT LEVEL AS lev FROM dual CONNECT BY LEVEL <= 9) l
        ...           WHERE u.location = '${arnumber}'
        ...             AND u.site_use_code = 'BILL_TO'
        ...             AND s.cust_acct_site_id = u.cust_acct_site_id
        ...             AND p.site_use_id = u.site_use_id
        ...             AND ps.party_site_id = s.party_site_id
        ...             AND pty.party_id = ps.party_id
        ...             AND a.cust_account_id = s.cust_account_id
        ...             AND m.receipt_method_id (+) = r.receipt_method_id
        ...             AND r.site_use_id (+) = u.site_use_id)
    ${dbInfo} =  query and strip to dictionary  ${query}
    set test variable  ${dbInfo}  ${dbInfo}

Get Lookup ORG from DB
    Get Into DB  ORACLE
    ${query}  catenate
        ...  SELECT organization_id AS key, name AS value
        ...     FROM hr_all_organization_units
        ...     WHERE location_id IS NOT NULL
    ${dbInfo} =  query and strip to dictionary  ${query}
    @{dblist}  set variable  ${dbInfo["KEY"]}
    FOR    ${keys}    IN    @{dblist}
        ${stringkeys}  convert to string  ${keys}
        ${index}  set variable  ${dbInfo["KEY"].index(${keys})}
        set list value  ${dbInfo["KEY"]}  ${index}  ${stringkeys}
    END
    set test variable  ${dbInfo}  ${dbInfo}

Get Lookup COLLECTOR from DB
    Get Into DB  ORACLE
    ${query}  catenate
        ...  SELECT collector_id AS key, name AS value
        ...       FROM ar_collectors
        ...       WHERE status = 'A'
        ...        AND collector_id > 1
        ...      ORDER BY name
    ${dbInfo} =  query and strip to dictionary  ${query}
    @{dblist}  set variable  ${dbInfo["KEY"]}
    FOR    ${keys}    IN    @{dblist}
        ${stringkeys}  convert to string  ${keys}
        ${index}  set variable  ${dbInfo["KEY"].index(${keys})}
        set list value  ${dbInfo["KEY"]}  ${index}  ${stringkeys}
    END
    set test variable  ${dbInfo}  ${dbInfo}

Get Lookup MGR_CODES from DB
    Get Into DB  ORACLE
    ${query}  catenate
        ...  SELECT lookup_code AS key, description AS value
        ...       FROM fnd_lookup_values
        ...      WHERE lookup_type = 'CREDIT_RATING'
        ...        AND enabled_flag = 'Y'
        ...        AND SYSDATE BETWEEN start_date_active AND NVL(end_date_active, SYSDATE + 1)
        ...        AND language = 'US'
        ...      ORDER BY lookup_code
    ${dbInfo} =  query and strip to dictionary  ${query}
    @{dblist}  set variable  ${dbInfo["KEY"]}
    FOR    ${keys}    IN    @{dblist}
        ${stringkeys}  convert to string  ${keys}
        ${index}  set variable  ${dbInfo["KEY"].index('${keys}')}
        set list value  ${dbInfo["KEY"]}  ${index}  ${stringkeys}
    END
    set test variable  ${dbInfo}  ${dbInfo}

   #********This feature does not work and will never work.******************
#Get Lookup TERMS from DB
#    [Arguments]  ${arnumber}
#    Get Into DB  ORACLE
#    ${query}  catenate
#        ...  SELECT term_id, name
#        ...       FROM (SELECT term_id, name,
#        ...                    LPAD(REGEXP_REPLACE(SUBSTR(name, 4, 3), '[[:alpha:]|-| ]', ''), 2, '0') AS cycle,
#        ...                    LPAD(REGEXP_REPLACE(SUBSTR(name, -3), '[[:alpha:]|-| ]', ''), 3, '0') AS terms
#        ...               FROM ra_terms
#        ...              WHERE SYSDATE BETWEEN start_date_active AND NVL(end_date_active, SYSDATE + 1)
#        ...                AND (( '${arnumber}'  = 'Y' AND SUBSTR(name, 1, 3) = 'BFB')
#        ...                 OR  ( '${arnumber}' = 'N' AND SUBSTR(name, 1, 3) != 'BFB'))) a
#        ...      ORDER BY terms, DECODE(SUBSTR(name, 1, 3), 'BFB', cycle, NULL) NULLS FIRST
#    ${dbInfo} =  query and strip to dictionary  ${query}
#    set test variable  ${dbInfo}  ${dbInfo}

Get Lookup CYCLES from DB
    Get Into DB  ORACLE
    ${query}  catenate
        ...  SELECT statement_cycle_id AS key, name AS value
        ...       FROM ar_statement_cycles
        ...       WHERE status = 'A'
    ${dbInfo} =  query and strip to dictionary  ${query}
     @{dblist}  set variable  ${dbInfo["KEY"]}
    FOR    ${keys}    IN    @{dblist}
        ${stringkeys}  convert to string  ${keys}
        ${index}  set variable  ${dbInfo["KEY"].index('${keys}')}
        set list value  ${dbInfo["KEY"]}  ${index}  ${stringkeys}
    END
    set test variable  ${dbInfo}  ${dbInfo}

Get the Lookup from the webservice call
    [Arguments]  ${name}  ${arnumber}
    ${lookups}  call_getLookup  ${name}  ${arnumber}
    set test variable  ${lookups}   ${lookups}

Verify Lookup returns correct information
    [Arguments]
    @{list}  set variable  ${lookups["KEY"]}
    FOR    ${keys}    IN    @{list}
        Compare Values of dictionary information  "${keys}"
    END

Compare Values of dictionary information
    [Arguments]  ${key}
    ${index}  set variable  ${lookups["KEY"].index(${key})}
    ${wsCarrier_ID}  set variable  ${lookups["VALUE"][${index}]}
    ${index}  set variable  ${dbInfo["KEY"].index(${key})}
    ${dbCarrier_ID}  set variable  ${dbInfo["VALUE"][${index}]}
    should be equal as strings  ${wsCarrier_ID}  ${dbCarrier_ID}  The ${key} from the
        ...  TCHOraclJaxWS call of ${wsCarrier_ID} does not match the ${key} from the
        ...  database of ${dbCarrier_ID}

Verify getAppliedPayments API endpoint returns correct data
    [Arguments]  ${arnumber}
    Get the Applied Payments from the webservice call and the database  ${arnumber}

Get the Applied Payments from the webservice call and the database
    [Arguments]  ${arnumber}
    ${AppldPmts}  call_getAppliedPayments  ${arnumber}
    set test variable  ${AppldPmts}   ${AppldPmts}
    Get Applied Payments from DB  ${arnumber}
    Verify getAppliedPayments returns correct information

Verify getAppliedPayments returns correct information
    [Arguments]
    @{list}  set variable  ${AppldPmts}
    FOR    ${keys}    IN    @{list}
        Compare Values of getAppliedPayments information  "${keys}"
    END

Compare Values of getAppliedPayments information
    [Arguments]  ${key}
    ${wslist}  set variable  ${AppldPmts[${key}]}
    ${dbkey} =  convert to upper case  ${key}
    ${dblist}  set variable  ${dbInfo[${dbkey}]}
    FOR   ${value}    IN    @{AppldPmts[${key}]}
        ${message}  set variable  The value of ${value} from the getAppliedPayments webservice call
            ...  for ${key} is not found in the database list for ${key}.
         should contain  ${dblist}  ${value}  ${message}
    END


Get Applied Payments from DB
    [Arguments]  ${arnumber}
        Get Into DB  ORACLE
    ${query}  catenate
        ...  SELECT TO_CHAR(ps.trx_date, 'YYYY-MM-DD') AS invoiceDate,
		...	       ps.class AS recordType,
		...	       inv.trx_number AS obligId,
		...	       cr.receipt_number AS pmtId,
		...	       TO_CHAR(ps.due_date, 'YYYY-MM-DD') AS dueDate,
		...	       TO_CHAR(ra.apply_date, 'YYYY-MM-DD') AS appliedDate,
		...	       TO_CHAR(cr.amount) AS pmtAmt,
		...	       TO_CHAR(inv.amount_due_original) AS totalAmt,
		...	       TO_CHAR(inv.amount_due_remaining) AS totalAmtDue,
		...	       RANK() OVER(ORDER BY ra.apply_date DESC) AS ord
		...	  FROM ar_receivable_applications_all ra,
		...	       ar_payment_schedules_all ps,
		...	       ar_payment_schedules_all inv,
		...	       ar_cash_receipts_all cr,
		...	       hz_cust_site_uses_all u,
		...	       hz_cust_acct_sites_all s
		...	 WHERE ra.payment_schedule_id = ps.payment_schedule_id
		...	   AND ps.customer_site_use_id = u.site_use_id
		...	   AND inv.customer_site_use_id = u.site_use_id
		...	   AND u.cust_acct_site_id = s.cust_acct_site_id
		...	   AND cr.customer_site_use_id = u.site_use_id
		...	   AND cr.cash_receipt_id = ps.cash_receipt_id
		...	   AND ra.application_type = 'CASH'
		...	   AND u.site_use_code = 'BILL_TO'
		...	   AND s.orig_system_reference = '${arnumber}'
		...	   AND ps.class = 'PMT'
		...	   AND inv.class = 'INV'
		...	   AND inv.customer_trx_id = ra.applied_customer_trx_id
		...	   AND ra.status = 'APP'
	    ...    ORDER BY inv.trx_number DESC
    ${dbInfo} =  query and strip to dictionary  ${query}
    set test variable  ${dbInfo}  ${dbInfo}