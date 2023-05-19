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

Force Tags  Integration  Shifty  Portal

Suite Setup  Open Browser And Login To Portal
Suite Teardown  Close Everything

*** Variables ***

*** Test Cases ***
Credit Manager - Update Credit Available (Limits Tab)
    [Tags]  qTest:33101129  qTest:31794107  refactor
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  ${validCard.carrier.id}  ${validCard.policy.contract.id}

    Wait Until Page Contains Element  //*[@name="request.contract.creditLimit"]  timeout=60
    ${OLD_CreditAvail}  Get Value  //*[@name="request.contract.creditLimit"]
    Set Suite Variable  ${OLD_CreditAvail}
    Input Text  request.contract.creditLimit  1000
    Click Portal Button  Save

    Get Into DB  ${DB}
    ${query}  catenate  SELECT c.credit_limit AS CreditAvail FROM contract c, cont_misc cm
    ...     WHERE c.contract_id=cm.contract_id AND c.contract_id = ${validCard.policy.contract.id}
    ...     AND c.carrier_id=${validCard.carrier.id}
    ${Limits}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Numbers  ${Limits.creditavail}  1000

    [Teardown]  Reset Contract Info  credit_limit  ${OLD_CreditAvail}

Credit Manager - Update Daily Limit (Limits Tab)
    [Tags]  qTest:33630541  qTest:31794505
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  ${validCard.carrier.id}  ${validCard.policy.contract.id}
    Wait Until Page Contains Element  //*[@name="request.contract.creditLimit"]  timeout=60
    ${OLD_DailyLimit}  Get Value  //*[@name="request.contract.dailyLimit"]
    Set Suite Variable  ${OLD_DailyLimit}
    Input Text  request.contract.dailyLimit  2000
    Click Portal Button  Save
    Sleep  2

    Get Into DB  ${DB}
    ${query}  catenate  SELECT c.daily_limit AS DailyLimit
    ...     FROM contract c, cont_misc cm WHERE c.contract_id=cm.contract_id AND c.contract_id = ${validCard.policy.contract.id}
    ...     AND c.carrier_id=${validCard.carrier.id}
    ${Limits}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Numbers  ${Limits.dailylimit}  2000
    tch logging  it checks with DB

    [Teardown]  Reset Contract Info  daily_limit  ${OLD_DailyLimit}

Credit Manager - Update Daily Cash Limit (Limits Tab)
    [Tags]  qTest:33630550  qTest:31798136
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  ${validCard.carrier.id}  ${validCard.policy.contract.id}
    Wait Until Page Contains Element  //*[@name="request.contract.creditLimit"]  timeout=60
    ${OLD_DailyCashLimit}  Get Value  //*[@name="request.contract.dailyCadvLimit"]
    Set Suite Variable  ${OLD_DailyCashLimit}
    Input Text  request.contract.dailyCadvLimit  3000
    Click Portal Button  Save
    Sleep  5

    Get Into DB  ${DB}
    ${query}  catenate  SELECT c.daily_cadv_limit AS DailyCashLimit
    ...     FROM contract c, cont_misc cm WHERE c.contract_id=cm.contract_id AND c.contract_id = ${validCard.policy.contract.id}
    ...     AND c.carrier_id=${validCard.carrier.id}
    ${Limits}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Numbers  ${Limits.dailycashlimit}  3000

    [Teardown]  Reset Contract Info  daily_cadv_limit  ${OLD_DailyCashLimit}

Credit Manager - Update Daily Money Code Limit (Limits Tab)
    [Tags]  qTest:33630556  qTest:31798048
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  ${validCard.carrier.id}  ${validCard.policy.contract.id}
    Wait Until Page Contains Element  //*[@name="request.contract.creditLimit"]  timeout=60
    ${OLD_DailyMCLimit}  Get Value  //*[@name="request.contract.dailyCodeLimit"]
    Set Suite Variable  ${OLD_DailyMCLimit}
    Input Text  request.contract.dailyCodeLimit  9000
    Click Portal Button  Save
    Sleep  5

    Get Into DB  ${DB}
    ${query}  catenate  SELECT c.daily_code_limit AS DailyMCLimit
    ...     FROM contract c, cont_misc cm WHERE c.contract_id=cm.contract_id AND c.contract_id = ${validCard.policy.contract.id}
    ...     AND c.carrier_id=${validCard.carrier.id}
    ${Limits}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Numbers  ${Limits.dailymclimit}  9000

    [Teardown]  Reset Contract Info  daily_code_limit  ${OLD_DailyMCLimit}

Credit Manager - Update Transaction Limit (Limits Tab)
    [Tags]  qTest:33630564  qTest:31794579
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  ${validCard.carrier.id}  ${validCard.policy.contract.id}
    Wait Until Page Contains Element  //*[@name="request.contract.creditLimit"]  timeout=60
    ${OLD_TransLimit}  Get Value  //*[@name="request.contract.transLimit"]
    Set Suite Variable  ${OLD_TransLimit}
    Input Text  request.contract.transLimit  3000
    Click Portal Button  Save
    Sleep  5

    Get Into DB  ${DB}
    ${query}  catenate  SELECT c.trans_limit AS TransLimit
    ...     FROM contract c, cont_misc cm WHERE c.contract_id=cm.contract_id AND c.contract_id = ${validCard.policy.contract.id}
    ...     AND c.carrier_id=${validCard.carrier.id}
    ${Limits}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Numbers  ${Limits.translimit}  3000

    [Teardown]  Reset Contract Info  trans_limit  ${OLD_TransLimit}

Credit Manager - Update Credit Limit (Limits Tab)
    [Tags]  qTest:33630596
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Change Credit Limit On DB To  5000
    Go To Credit Manager And Select Contract  ${validCard.carrier.id}  ${validCard.policy.contract.id}
    Update Credit Limit To  5500
    Compare Screen Credit Limit Value With DB
    [Teardown]  Change Credit Limit On DB To  5000

Credit Manager - Update Cash Limit (Limits Tab)
    [Tags]
    [Setup]  Store Original Cash Limit  ${validCard.policy.contract.id}
    Go To Credit Manager And Select Contract  ${validCard.carrier.id}  ${validCard.policy.contract.id}
    Wait Until Page Contains Element  //*[@name="request.contract.cashTransLimit"]  timeout=30
    Input Text  //*[@name="request.contract.cashTransLimit"]  300
    Click Portal Button  Save
    Wait Until Page Contains Element  //div[@id='alert_content']//span[text()='OK']  timeout=120
    Click Element  //div[@id='alert_content']//span[text()='OK']
    Run Keyword And Ignore Error   Click Element   //div[@id='error_content']//span[text()='OK']
    Compare New Cash Limit With DB  300   ${validCard.policy.contract.id}
    [Teardown]  Change Cash Limit On DB To  ${stored_cash_limit}  ${validCard.policy.contract.id}

Credit Manager - Update Contract Status (Contract Tab)
    [Tags]  qTest:33101132
    [Setup]  Run Keywords  Define Carrier and Contract
    ...     AND  Go To Credit Manager And Select Contract  ${card.carrier.id}  ${card.policy.contract.id}
    Wait Until Page Contains Element  //*[@name="request.contract.stmtCustomerName"]  timeout=60
    ${Status}  Get Value  //*[@name="request.contract.status"]

    Set Suite Variable  ${Status}
    Select From List By Value  request.contract.status  I
    Wait Until Page Contains  text=Save  timeout=60
    Click Portal Button  Save

    Get Into DB  ${DB}
    ${query}  catenate  SELECT c.status FROM contract c, cont_misc cm, member m
    ...     WHERE c.carrier_id=${card.carrier.id} AND m.member_id = c.carrier_id AND c.contract_id = ${card.policy.contract.id}
    ...     AND c.contract_id = cm.contract_id
    ${Info}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Strings  ${Info.status}  I

    [Teardown]  Reset Contract Info  status  ${Status}  card=${card}



*** Keywords ***

Close Everything
    Close All Browsers

Open Browser And Login To Portal
    Open Browser to portal
    Log Into Portal  ${PortalUsername}  ${PortalPassword}

Go To Credit Manager And Select Contract
    [Arguments]  ${carrier}  ${contract}

    Set Test Variable  ${DB}  TCH

    Wait Until Page Contains Element  //*[@id="pmd_home"]  timeout=60
    Click Element  //*[@id="pmd_home"]      #GO BACK TO THE HOME PAGE
    Wait Until Element Is Visible  //*[text()[contains(.,"Credit Manager")]]  timeout=60
    Select Portal Program  Credit Manager
    Input Text  request.search.carrierId  ${carrier}
    Click Portal Button  Search
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]  timeout=120
    Double Click Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]

Reset Contract Info
    [Arguments]  ${column}  ${value}  ${table}=contract  ${card}=${validCard}

    Get Into DB  ${DB}
    Execute SQL String  dml=UPDATE ${table} SET ${column}='${value}' WHERE contract_id = ${card.policy.contract.id}
    Execute SQL String  COMMIT
    Tch Logging  \n Contract Info:${column} is back to original value!
    Tch Logging  UPDATE ${table} SET ${column}='${value}' WHERE contract_id = ${card.policy.contract.id}

Change Credit Limit On DB To
    [Arguments]  ${credit_limit}
    Get Into DB  ORACLE
    Get CUST_ACCT_PROFILE_AMT_ID based on AR_NUMBER
    Execute SQL String  dml=UPDATE HZ_CUST_PROFILE_AMTS SET OVERALL_CREDIT_LIMIT = ${credit_limit} WHERE CUST_ACCT_PROFILE_AMT_ID = ${CUST_ACCT_PROFILE_AMT_ID}

Update Credit Limit To
    [Arguments]  ${credit_limit}
    Wait Until Page Contains Element  request.contract.origLimit  timeout=60
    Input Text  request.contract.origLimit  ${credit_limit}
    Sleep  1
    Click Portal Button  Yes  parent=//div[@id='confirmCreditLimitChg_content']
    Click Portal Button  Save
    Run Keyword And Ignore Error  Wait Until Page Contains Element  //div[@id='limitRsn_content']//span[text()='OK']  timeout=20
    Run Keyword And Ignore Error  Click Element  //div[@id='limitRsn_content']//span[text()='OK']
    Wait Until Page Contains Element  //div[@id='alert_content']//span[text()='OK']  timeout=120
    Click Element  //div[@id='alert_content']//span[text()='OK']

Get Credit Limit From DB By CUST_ACCT_PROFILE_AMT_ID
    [Arguments]  ${CUST_ACCT_PROFILE_AMT_ID}
    Sleep  3
    Get Into DB  ORACLE
    ${query}  catenate  SELECT OVERALL_CREDIT_LIMIT FROM HZ_CUST_PROFILE_AMTS WHERE CUST_ACCT_PROFILE_AMT_ID = ${CUST_ACCT_PROFILE_AMT_ID}
    ${Limits}  Query And Strip  ${query}
    ${query}  catenate  SELECT * FROM HZ_CUST_PROFILE_AMTS WHERE CUST_ACCT_PROFILE_AMT_ID = ${CUST_ACCT_PROFILE_AMT_ID}
    ${Limits2}  query and strip to dictionary  ${query}
    tch logging  ${Limits2}
    [Return]  ${Limits}

Compare Screen Credit Limit Value With DB
    ${limit}  Get Credit Limit From DB By CUST_ACCT_PROFILE_AMT_ID  ${CUST_ACCT_PROFILE_AMT_ID}
    Should Be Equal As Numbers  ${limit}  5500

Define Carrier and Contract
    ${sql}  Catenate
    ...  SELECT c.card_num
    ...  FROM cards c
    ...     JOIN ach_profile_card_xref apcx ON apcx.card_num = c.card_num
    ...     JOIN member m ON m.member_id = c.carrier_id
    ...     JOIN def_card dc ON c.carrier_id = dc.id AND c.icardpolicy = dc.ipolicy
    ...     JOIN contract co ON dc.contract_id = co.contract_id
    ...  WHERE c.card_type = 'TCH'
    ...  AND c.payr_use = 'B'
    ...  AND c.mrcsrc = 'N'
    ...  AND m.status = 'A'
    ...  AND NOT EXISTS (SELECT 1 FROM direct_bills db WHERE db.carrier_id = m.member_id AND dc.contract_id = co.contract_id)
    ${card}  Find Card Variable  ${sql}
    Set Test Variable  ${card}

Get CUST_ACCT_PROFILE_AMT_ID based on AR_NUMBER

    Get Into DB  TCH
    ${AR_NUMBER}  Query And Strip  SELECT ar_number FROM contract WHERE contract_id = ${validCard.policy.contract.id}

    Get Into DB  ORACLE
    ${query}  catenate  SELECT a.CUST_ACCT_PROFILE_AMT_ID
    ...     FROM hz_cust_site_uses_all u,
    ...     hz_customer_profiles p,
    ...     hz_cust_profile_amts a,
    ...     hz_party_sites h
    ...     WHERE p.site_use_id = u.site_use_id
    ...     and a.cust_account_profile_id=p.cust_account_profile_id
    ...     and u.location=h.party_site_number
    ...     and h.attribute13=a.currency_code
    ...     AND u.location = '${AR_NUMBER.strip()}'
    ${CUST_ACCT_PROFILE_AMT_ID}  Query And Strip  ${query}

    Set Suite Variable  ${CUST_ACCT_PROFILE_AMT_ID}

Store Original Cash Limit
    [Arguments]  ${contractID}
    Get Into DB  TCH
    ${stored_cash_limit}  Query And Strip  SELECT cash_trans_limit FROM contract WHERE contract_id=${contractID}
    Set Suite Variable  ${stored_cash_limit}

Compare New Cash Limit With DB
    [Arguments]  ${new_amount}  ${contractID}
    Get Into DB  TCH
    ${new_cash_limit}  Query And Strip  SELECT cash_trans_limit FROM contract WHERE contract_id=${contractID}
    Should Be Equal As Numbers  ${new_cash_limit}  ${new_amount}

Change Cash Limit On DB To
    [Arguments]  ${old_amt}  ${contract_id}

    Get Into DB  TCH
    Execute SQL String  dml=UPDATE contract SET cash_trans_limit=${old_amt} WHERE contract_id=${contract_id}