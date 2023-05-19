*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Time To Setup
Suite Teardown  close all browsers
Force Tags  Portal  Credit Manager  Shifty
Documentation  This script covers the History Tab Menu, Viewing Statement information and adding, editing and deleting bank accounts

*** Variables ***
${ar_number_list}
${ar_number}
${routing_number}  324377516
${account_number}  1234567890

*** Test Cases ***
View Statement Information
    [Tags]  qTest:34016028  qTest:34265821
    [Documentation]  Validate that the Portal user can view statement information on the History Tab Menu
    [Setup]  Pull Up History Tab Menu  ${ar_number}
    View Invoice Statement

Add Bank Account - Checkings
    [Tags]  qTest:34335409
    [Documentation]  Validate that the Portal user can add a checking account for the specified user
    [Setup]  Pull Up History Tab Menu  ${ar_number}
    Add Checking Account  ${routing_number}  ${account_number}
    Validate Bank Account In DB  ${ar_number}  ${account_number}
    [Teardown]  Remove Bank Account  ${account_number}

*** Keywords ***
Time To Setup
    Open Browser to portal
    Set Valid Carrier
    Log Into Portal

Pull Up History Tab Menu
    [Arguments]  ${ar_num}
    Return to Portal Home
    Select Portal Program  Credit Manager    #Open Credit Manager
    Input Text  request.search.arNumber  ${ar_num}
    Click Portal Button  Search
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  //*[@id="resultsTable"]//*[contains(text(), '${ar_num}')]  timeout=120
    Double Click Element  //*[@id="resultsTable"]//*[contains(text(), '${ar_num}')]
    Wait Until Page Contains Element  //*[@name="request.contract.creditLimit"]  timeout=60
    Click Element  //span[text()="History"]    #Pull up the History Tab
    Wait Until Page Contains Element  //select[@name="display"]  timeout=20

View Invoice Statement
    Wait Until Page Contains Element  //td//div[text()="Invoice"]  timeout=20
    Double Click Element  //td//div[text()="Invoice"]
    Wait Until Element Is Visible  //*[@id="cashapps"]  timeout=20
    Click Element  //span[text()="Close"]

Add Checking Account
    [Arguments]  ${routing_num}  ${acct_num}
    Click Element  //a//div//span[text()="Bank Accounts"]
    Wait Until Element is Visible  //*[@id="bankInfo_caption"]  timeout=30
    Click Element  //td//div//div//a//div//span[text()="Add"]
    Wait Until Element is Visible  //*[@name="request.bankAccount.routingNbr"]
    Input Text  //*[@name="request.bankAccount.routingNbr"]  ${routing_num}
    Input Text  //*[@name="request.bankAccount.accountNbr"]  ${acct_num}
    Input Text  //*[@name="request.bankAccount.verifiedAccountNbr"]  ${acct_num}
    select from list by value  //*[@name="request.bankAccount.accountType"]  CHECKING
    Click Element  //form//a//div//span[text()="Save"]
    Wait Until Element is Visible  //span[text()="Yes"]  timeout=30
    Click Element  //span[text()="Yes"]
    Wait Until Element is Visible  //*[@id="success_content"]  timeout=30
    sleep  3
    Click Element  //a//div//span[text()="Close"]
    Wait Until Element is Visible  //a//div//span[text()="Bank Accounts"]  timeout=30

Validate Bank Account in DB
    [Arguments]  ${ar_num}  ${acct_num}
    Get Into Db  ORACLE
    ${query}  catenate  SELECT a.bank_account_num AS account_nbr
     ...  FROM hz_cust_acct_sites_all s,
     ...  hz_cust_site_uses_all u,
     ...  iby_external_payers_all p,
     ...  iby_pmt_instr_uses_all i,
     ...  iby_ext_bank_accounts a,
     ...  ce_bank_branches_v b,
     ...  iby_account_owners o,
     ...  hz_party_sites h
     ...  WHERE s.orig_system_reference IN ('${ar_num}')
     ...  AND p.acct_site_use_id = u.site_use_id
     ...  AND u.cust_acct_site_id = s.cust_acct_site_id
     ...  AND p.cust_account_id = s.cust_account_id
     ...  AND i.ext_pmt_party_id = p.ext_payer_id
     ...  AND a.ext_bank_account_id = i.instrument_id
     ...  AND h.party_site_id = s.party_site_id
     ...  AND o.account_owner_party_id = h.party_id
     ...  AND b.branch_party_id = a.branch_id
     ...  AND o.ext_bank_account_id = a.ext_bank_account_id
     ...  AND SYSDATE BETWEEN i.start_date AND NVL(i.end_date, SYSDATE + 1)
     ...  AND a.bank_account_num = '${acct_num}'
     ...  ORDER BY s.orig_system_reference
     ${db_acct}  query and strip  ${query}
     Should Be Equal As Strings   ${db_acct}  ${acct_num}  Account number was not as expected. Expected value was ${acct_num}, actual value was ${db_acct}

Remove Bank Account
    [Arguments]  ${acct_num}
    Click Element  //a//div//span[text()="Bank Accounts"]
    Wait Until Element is Visible  //*[@id="bankInfo_caption"]  timeout=30
    Click Element  //td//div[text()="${acct_num}"]
    Click Element  //td//div//div//a//div//span[text()="Delete"]
    Wait Until Element is Visible  //*[@id="deleteConfirm_content"]  timeout=30
    Click Element  //*[@id="deleteConfirm_content"]//*[text()="Yes"]
    Wait Until Element is Visible  //*[@id="bankInfo_caption"]  timeout=30
    Sleep  2
    Click Element  //a//div//span[text()="Close"]
    Wait Until Element is Visible  //a//div//span[text()="Bank Accounts"]  timeout=30

Set Valid Carrier
    ${TODAY}=  getdatetimenow  %Y-%m-%d
    get into db  ORACLE
    ${query}  catenate
    ...  SELECT distinct(AR_NUMBER) AS AR_NUMBER FROM
    ...      (SELECT csu.location AS ar_number,
    ...             CASE WHEN ctt.name = 'A-Consolidated Inv' THEN 'Invoice'
    ...                  WHEN ctt.name = 'A-Consolidated CM' THEN 'Invoice'
    ...                  WHEN ctt.name LIKE '%Summary%' THEN 'Summary'
    ...                  ELSE 'Adjustment' END AS row_type,
    ...             ct.customer_trx_id AS trx_id,
    ...             ps.invoice_currency_code
    ...      FROM ar_payment_schedules_all ps,
    ...           ra_cust_trx_types_all ctt,
    ...           ra_batch_sources_all bs,
    ...           ra_customer_trx_all ct,
    ...           hz_cust_site_uses_all csu,
    ...           hz_cust_acct_sites_all cas
    ...      WHERE ps.class IN ('INV', 'DM', 'CM')
    ...        AND ps.customer_trx_id = ct.customer_trx_id
    ...        AND ps.org_id = ct.org_id
    ...        AND bs.org_id = ct.org_id
    ...        AND ctt.cust_trx_type_id = ps.cust_trx_type_id
    ...        AND ctt.org_id = ps.org_id
    ...        AND ctt.cust_trx_type_id = ct.cust_trx_type_id
    ...        AND ctt.org_id = ct.org_id
    ...        AND bs.batch_source_id (+) = ct.batch_source_id
    ...        AND ctt.name NOT LIKE 'Cons Offset%' AND (ctt.attribute1 = 'CONSOLIDATE_NO' OR  ps.amount_due_remaining != 0) AND ct.trx_date >= TO_DATE('2020-08-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND ct.trx_date < TO_DATE('${TODAY} 00:00:00', 'YYYY-MM-DD HH24:MI:SS') + 1 AND ctt.name IN ('A-Consolidated Inv', 'A-Consolidated CM')
    ...        AND ct.bill_to_site_use_id = csu.site_use_id
    ...        AND csu.cust_acct_site_id = cas.cust_acct_site_id
    ...        AND csu.site_use_code = 'BILL_TO'
    ...      UNION ALL
    ...      SELECT csu.location AS ar_number,
    ...             'Payment' AS row_type,
    ...             cr.cash_receipt_id AS trx_id,
    ...             ps.invoice_currency_code
    ...      FROM ar_cash_receipts_all cr,
    ...           ar_payment_schedules_all ps,
    ...           hz_cust_site_uses_all csu,
    ...           ar_receipt_methods rm,
    ...           iby_fndcpt_tx_extensions ext,
    ...           iby_pmt_instr_uses_all piu,
    ...           iby_ext_bank_accounts eba,
    ...           ce_bank_branches_v bb
    ...      WHERE ps.cash_receipt_id = cr.cash_receipt_id
    ...        AND cr.customer_site_use_id = csu.site_use_id
    ...        AND rm.receipt_method_id = cr.receipt_method_id
    ...        AND ext.trxn_extension_id (+) = cr.payment_trxn_extension_id
    ...        AND piu.instrument_payment_use_id (+) = ext.instr_assignment_id
    ...        AND eba.ext_bank_account_id (+) = piu.instrument_id
    ...        AND bb.branch_party_id (+) = eba.branch_id
    ...        AND 1 = 0
    ...      UNION ALL
    ...      SELECT i.customer_number AS ar_number,
    ...             'Payment' AS row_type,
    ...             TO_NUMBER(source_trx_id) AS trx_id,
    ...             b.currency_code AS invoice_currency_code
    ...      FROM xxtch.xxtch_ar_cash_receipts_iface i
    ...         , hz_cust_site_uses_all csu
    ...         , ar_receipt_methods rm
    ...         ,(SELECT ROWNUM AS row_num,
    ...                  b.*,
    ...                  b.routing_nbr || '-' || b.account_nbr AS bankaccount
    ...           FROM (SELECT b.branch_number AS routing_nbr,
    ...                        a.bank_account_num AS account_nbr,
    ...                        i.order_of_preference,
    ...                        b.bank_home_country AS domicile,
    ...                        b.bank_name,
    ...                        NVL(a.currency_code, b.bank_home_country || 'D') AS currency_code
    ...                 FROM hz_cust_acct_sites_all s,
    ...                      hz_cust_site_uses_all u,
    ...                      iby_external_payers_all p,
    ...                      iby_pmt_instr_uses_all i,
    ...                      iby_ext_bank_accounts a,
    ...                      ce_bank_branches_v b,
    ...                      iby_account_owners o,
    ...                      hz_party_sites h
    ...                   WHERE p.acct_site_use_id = u.site_use_id
    ...                   AND u.cust_acct_site_id = s.cust_acct_site_id
    ...                   AND p.cust_account_id = s.cust_account_id
    ...                   AND i.ext_pmt_party_id = p.ext_payer_id
    ...                   AND i.instrument_id = a.ext_bank_account_id
    ...                   AND i.instrument_type = 'BANKACCOUNT'
    ...                   AND h.party_site_id = s.party_site_id
    ...                   AND o.account_owner_party_id = h.party_id
    ...                   AND b.branch_party_id = a.branch_id
    ...                   AND o.ext_bank_account_id = a.ext_bank_account_id
    ...                 ORDER BY i.order_of_preference) b) b
    ...        WHERE i.status IN ('PENDING', 'ERROR', 'CANCELLED')
    ...        AND b.bankaccount (+) = NVL(i.customer_bank_account_num, 'DEFAULT')
    ...        AND csu.location = i.customer_number
    ...        AND rm.name (+) = i.payment_method
    ...        AND 1 = 0
    ...      UNION ALL
    ...      SELECT i.customer_number AS ar_number,
    ...             'Payment' AS row_type,
    ...             NULL AS trx_id,
    ...             l.attribute10 AS invoice_currency_code
    ...      FROM xxtch.xxtch_ar_payment_interface i,
    ...          ar_lockboxes_all l
    ...         , ar_receipt_methods m
    ...         , hz_cust_site_uses_all csu
    ...        WHERE i.status IN ('PENDING', 'ERROR', 'CANCELLED')
    ...        AND l.lockbox_number = i.lockbox_code
    ...        AND m.receipt_method_id = l.receipt_method_id
    ...        AND m.start_date < i.creation_date
    ...        AND NVL(m.end_date, i.creation_date + 1) > i.creation_date
    ...        AND csu.location = i.customer_number
    ...        AND 1 = 0
    ...      UNION ALL
    ...      SELECT csu.location AS ar_number,
    ...             'Invoice' AS row_type,
    ...             sih.AR_SMT_INV_HDR_INFO_ID AS trx_id,
    ...             NVL(ps.attribute13, (SELECT country || 'D' FROM hz_locations WHERE location_id = ps.location_id)) AS invoice_currency_code
    ...      FROM xxtch.xxtch_ar_smt_inv_hdr_info sih,
    ...           hz_cust_site_uses_all csu,
    ...           hz_cust_acct_sites_all cas,
    ...           hz_party_sites ps
    ...      WHERE sih.current_charges_amt = 0
    ...        AND sih.status = 'P'
    ...        AND NOT EXISTS (SELECT 1 FROM ra_customer_trx_all WHERE bill_to_site_use_id = csu.site_use_id AND trx_number = sih.trx_number)
    ...        AND EXISTS (SELECT 1
    ...                    FROM ra_cust_trx_types_all rtt1,
    ...                         xxtch.xxtch_ar_cust_trx_hdr xcth,
    ...                         ra_cust_trx_types_all rtt,
    ...                         xxtch.xxtch_ar_cust_trx_line xctl,
    ...                         xxtch.xxtch_ar_smt_header_info shi,
    ...                         xxtch.xxtch_ar_smt_line_info sli
    ...                    WHERE xcth.bill_to_site_use_id = csu.site_use_id
    ...                      AND xcth.org_id = csu.org_id
    ...                      AND xcth.creation_date >= sih.inv_begin_date + 0.4
    ...                      AND xcth.creation_date < sih.inv_end_date + 1.4
    ...                      AND rtt1.cust_trx_type_id = xcth.cust_trx_type_id
    ...                      AND rtt.cust_trx_type_id = xcth.cust_trx_type_id
    ...                      AND xcth.source_method = 'TR'
    ...                      AND xcth.link_to_cons_trx is NULL
    ...                      AND xctl.xxtch_ar_cust_trx_hdr_seq_id = xcth.xxtch_ar_cust_trx_hdr_seq_id
    ...                      AND shi.transaction_id = xctl.interface_line_attribute1
    ...                      AND shi.org_id = xctl.org_id
    ...                      AND rtt1.org_id = xctl.org_id
    ...                      AND xctl.org_id = xcth.org_id
    ...                      AND sli.smt_header_info_seq_id = shi.smt_header_info_seq_id
    ...                      AND sli.line_number = xctl.interface_line_attribute2
    ...                      AND NOT xctl.description in ('CARRIER FEE', 'CHECK FEE','CARRIER FEE TAX','SALES TAX', 'TAXE DE VENTE')
    ...                      AND NOT sli.category IN ('GST', 'HST','STAX'))
    ...        AND sih.inv_end_date >= TO_DATE('2020-08-25 00:00:00', 'YYYY-MM-DD HH24:MI:SS') AND sih.inv_end_date < TO_DATE('${TODAY} 00:00:00', 'YYYY-MM-DD HH24:MI:SS') + 1
    ...        AND sih.cust_acct_site_id = cas.cust_acct_site_id
    ...        AND csu.cust_acct_site_id = cas.cust_acct_site_id
    ...        AND ps.party_site_id = cas.party_site_id
    ...        AND csu.site_use_code = 'BILL_TO')
    ...      WHERE ar_number NOT LIKE '000717%'
    ...      AND invoice_currency_code = 'USD'

    ${ar_number_list}  Query And Strip To Dictionary  ${query}
    ${ar_number}  Evaluate  random.choice(${ar_number_list["AR_NUMBER"]})  random
    get into db  TCH
    Set suite variable  ${ar_number}


