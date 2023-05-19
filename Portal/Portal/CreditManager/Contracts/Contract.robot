*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
#Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Portal  Credit Manager  weekly
Documentation  This file updates the limits on the Credit Manager Home Page > Limits tab

Suite Setup  Open Browser And Login To Portal
Suite Teardown  Close Everything

*** Variables ***

*** Test Cases ***
Credit Manager - Update Credit Available (Limits Tab)
    [Tags]  JIRA:BOT-83  qTest:50373400  Regression  API:Y
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  1000
    set test variable  ${field}  creditLimit
    set test variable  ${column}  credit_limit
    set test variable  ${compare}  Numbers

    Update Value on Portal
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Daily Limit (Limits Tab)
    [Tags]  JIRA:BOT-83  qTest:50373398  Regression  API:Y
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  2000
    set test variable  ${field}  dailyLimit
    set test variable  ${column}  daily_limit
    set test variable  ${compare}  Numbers

    Update Value on Portal
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Daily Cash Limit (Limits Tab)
    [Tags]  JIRA:BOT-83  qTest:50373410  Regression  API:Y
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  3000
    set test variable  ${field}  dailyCadvLimit
    set test variable  ${column}  daily_cadv_limit
    set test variable  ${compare}  Numbers

    Update Value on Portal
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Daily Money Code Limit (Limits Tab)
    [Tags]  JIRA:BOT-83  qTest:50373408  Regression  API:Y
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  9000
    set test variable  ${field}  dailyCodeLimit
    set test variable  ${column}  daily_code_limit
    set test variable  ${compare}  Numbers

    Update Value on Portal
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Transaction Limit (Limits Tab)
    [Tags]  JIRA:BOT-83  qTest:50373407  Regression  API:Y
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  3000
    set test variable  ${field}  transLimit
    set test variable  ${column}  trans_limit
    set test variable  ${compare}  Numbers

    Update Value on Portal
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Credit Limit (Limits Tab)
    [Tags]  JIRA:BOT-83  qTest:33630596  Regression
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]   Go To Credit Manager And Select Contract  A
    Get CUST_ACCT_PROFILE_AMT_ID  ${contract.ar_number}  USD
    Change Credit Limit On DB To  5000
    Update Credit Limit To  5500
    Compare Screen Credit Limit Value With DB
    [Teardown]  Change Credit Limit On DB To  5000

Credit Manager - Update Max Money Code Limit (Limits Tab)
    [Tags]  JIRA:BOT-83  qTest:50373405  Regression  API:Y
    [Documentation]  Make sure you can update limits through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  7000
    set test variable  ${field}  maxMoneyCode
    set test variable  ${column}  max_money_code
    set test variable  ${compare}  Numbers

    Update Value on Portal
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}  cont_misc

Credit Manager - Update Contract Status (Contract Tab)
    [Tags]  JIRA:BOT-83  qTest:50373402  Regression  API:Y
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  I
    set test variable  ${field}  status
    set test variable  ${column}  status
    set test variable  ${compare}  Strings

    Update Value on Portal  List  OK
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}  card=${card}

Credit Manager - Update Contract Language (Contract Tab)
    [Tags]  JIRA:BOT-83  qTest:50373409  Regression  API:Y
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  S
    set test variable  ${field}  language
    set test variable  ${column}  language
    set test variable  ${compare}  Strings

    Update Value on Portal  List
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Contract AccountDescriptor (Contract Tab)
    [Tags]  JIRA:BOT-83  qTest:50373404  Regression  API:Y
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  13RD
    set test variable  ${field}  mgrCode
    set test variable  ${column}  mgr_code
    set test variable  ${compare}  Strings

    Update Value on Portal  List
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}  cont_misc

Credit Manager - Update Contract Limit Method (Contract Tab)
    [Tags]  JIRA:BOT-83  qTest:50373403  Regression  API:Y
    [Setup]  Go To Credit Manager And Select Contract  A
    set test variable  ${LmtMethod}  1
    Setup Contract Limit To  ${LmtMethod}  ${contract.contract_id}

    set test variable  ${New_value}  2
    set test variable  ${field}  limitMethod
    set test variable  ${column}  limit_method
    set test variable  ${compare}  Strings
#todo make sure this Charge text works
    Update Value on Portal  List  Charge
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Contract Terms (Contract Tab)
    [Tags]  JIRA:BOT-83  qTest:50373401  Regression  API:Y
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  1021
    set test variable  ${field}  terms
    set test variable  ${column}  terms
    set test variable  ${compare}  Numbers

    Update Value on Portal  List
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Credit Manager - Update Contract Statement Cycle (Contract Tab)
    [Tags]  JIRA:BOT-83  qTest:50373397  Regression  API:Y
    [Setup]  Go To Credit Manager And Select Contract  A

    set test variable  ${New_value}  5003
    set test variable  ${field}  oracleCycle
    set test variable  ${column}  cycle_code
    set test variable  ${compare}  Numbers

    Update Value on Portal  List
    Verify Value Changed in Database

    [Teardown]  Reset Contract Info  ${column}  ${OLD_Value}

Collections Descriptor Changes Should Be On Contract Comments
    [Tags]  JIRA:PORT-22  qTest:37228280
    [Documentation]  This test is to verify changes to the Collections Descriptor in the contracts using Credit Manager
    [Setup]  Go To Credit Manager And Select Contract  A

    Set Test Variable  ${contractId}  ${contract.contract.id}
    Save Current Collection Descriptor  ${contractId}
    Change Collections Descriptor And Reset ChargeOFF date  ${EMPTY}

    Change Collections Descriptor And Reset ChargeOFF date  Early Escalate
    ${comment}  Get Last Comment
    Assert Collection Descriptor  ${comment}  Early Escalate

    Change Collections Descriptor And Reset ChargeOFF date  Settlement
    ${comment}  Get Last Comment
    Assert Collection Descriptor  ${comment}  Changed from Early Escalate to Settlement
    Assert Datetime  ${comment}

    [Teardown]  Change Collections Descriptor And Reset ChargeOFF date  ${originalDescriptor}

Collections Descriptor Changes Should Be On Contract Logs
    [Tags]  JIRA:PORT-24  JIRA:PORT-55  qTest:37383427  refactor
    [Documentation]  This test is to verify if we can see the changes on log when we change the collection descriptor
    [Setup]  Go To Credit Manager And Select Contract  A
    Set Test Variable  ${contractId}  ${contract.contract_id}
    Save Current Collection Descriptor  ${contractId}
    Change Collections Descriptor And Reset ChargeOFF date  Settlement
    Change Collections Descriptor And Reset ChargeOFF date  BSFS Important Account

    ${old_value}  ${new_value}  Get Last Log

    Assert Collection Descriptor Log  ${old_value}  Settlement
    Assert Collection Descriptor Log  ${new_value}  BSFS Important Account

    [Teardown]  Change Collections Descriptor And Reset ChargeOFF date  ${originalDescriptor}

Collection Descriptor - Read Only Mode - Settlement
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    [Setup]  Go To Credit Manager And Select Contract  A
    Set Suite Variable  ${contractId}  ${contract.contract_id}
    Save Current Collection Descriptor  ${contractId}
    Change Collections Descriptor And Reset ChargeOFF date  ${EMPTY}
    Change Collections Descriptor to  Settlement
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - 1099C issued
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  1099C issued
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Attorney Retained
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Attorney Retained
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Crdt Hold Returned Pmt
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Crdt Hold Returned Pmt
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Credit Hold
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Credit Hold
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Dont Sell
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Don't Sell
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Early GGR
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Early GGR
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - GGR
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  GGR
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Important Acct Hold Past Due
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Important Acct-Hold Past Due
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Pending 3rd Party Sale
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Pending 3rd Party Sale
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Seasonal
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Seasonal
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - Sold 3rd Party Sale
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  Sold 3rd Party Sale
    Assert Read Only on Collection Descriptor Box
    [Teardown]  Reset Charge OFF date  ${contractId}

Collection Descriptor - Read Only Mode - 92 App Fraud
    [Tags]  JIRA:PORT-59  JIRA:PORT-61  JIRA:PORT-118  qTest:38827469  refactor
    [Documentation]  This test is to verify if Collection Descriptor box will be on Read Only when a Charge Off selection takes place
    Change Collections Descriptor to  92 App Fraud
    Assert Read Only on Collection Descriptor Box
    Reset Charge OFF date  ${contractId}

   [Teardown]  Change Collections Descriptor And Reset ChargeOFF date  ${originalDescriptor}

*** Keywords ***

Reset Charge OFF date
    [Arguments]  ${contractId}
    ${date}  getDateTimeNow  %Y-%m-%d  days=-2  tzinfo=US/Mountain
    Get Into DB  TCH
    Execute SQL String  dml=UPDATE contract_collector SET charge_off_date = '${date}' WHERE contract_id = ${contractId}
    Wait Until Element Is Visible  //a/*/*[text()="Refresh"]
    Click Portal Button  Refresh
    ${status}  run keyword and return status  Wait Until Element Is Visible  //*[@id="refreshConfirm_content"]  timeout=30
    Run Keyword If  ${status}==${True}  Run Keywords
    ...  Click Portal Button  Yes
    ...  AND  Wait Until Page Contains Element  //*[@name="request.contractCollectorBean.collectionDescriptor"]  timeout=100

Close Everything
    Close All Browsers

Open Browser And Login To Portal
    Open Browser to portal
    Log Into Portal  ${PortalUsername}  ${PortalPassword}

Go To Credit Manager And Select Contract
    [Tags]  qtest
    [Arguments]  ${status}
    [Documentation]  Login to Portal follow TC-3250(Basic - Login to Portal)
    ...  Click on Credit Manager
    ...  Enter in carrier_id in Carrier_id text box
    ...  Click Search Button
    ...  Double Click on a contract

    Find Carrrier in Oracle  ${status}  105757
    set test variable  ${contract}
    Set Test Variable  ${DB}  TCH

    Wait Until Page Contains Element  //*[@id="pmd_home"]  timeout=60
    Click Element  //*[@id="pmd_home"]      #GO BACK TO THE HOME PAGE
    Wait Until Element Is Visible  //*[text()[contains(.,"Credit Manager")]]  timeout=60
    Select Portal Program  Credit Manager
    Input Text  request.search.carrierId  ${contract.carrier_id}
    Click Portal Button  Search
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  //*[@id="resultsTable"]//*[contains(text(), '${contract.contract_id}')]  timeout=120
    Double Click Element  //*[@id="resultsTable"]//*[contains(text(), '${contract.contract_id}')]

Reset Contract Info
    [Arguments]  ${column}  ${value}  ${table}=contract
    [Documentation]

    Get Into DB  ${DB}
    Execute SQL String  dml=UPDATE ${table} SET ${column}='${value}' WHERE contract_id = ${contract.contract_id}
    Execute SQL String  COMMIT
    Tch Logging  \n Contract Info:${column} is back to original value!
    Tch Logging  UPDATE ${table} SET ${column}='${value}' WHERE contract_id = ${contract.contract_id}

Change Collections Descriptor And Reset ChargeOFF date
    [Arguments]  ${descriptor}
    Reset Charge OFF date  ${contractId}
    Wait Until Element Is Not Visible  //div[contains(text(),'Please wait while the selected contract is loaded')]  timeout=100
    Wait Until Page Contains Element  //*[@name="request.contractCollectorBean.collectionDescriptor"]  timeout=100
    ${selected_descriptor}  Get Selected List Label  request.contractCollectorBean.collectionDescriptor

    Run Keyword If  '${selected_descriptor}'=='${descriptor}'  Run Keywords
    ...  tch logging  \n${selected_descriptor}
    ...  AND  Return From Keyword
    Select From List by Label  request.contractCollectorBean.collectionDescriptor  ${descriptor}
    Click Portal Button  Save
    Wait Until Element Is Visible  //div[contains(text(),'The account was successfully saved')]  timeout=100
    Click Portal Button  OK
    Reset Charge OFF date  ${contractId}
    Wait Until Element Is Not Visible  //div[contains(text(),'Please wait while the selected contract is loaded')]  timeout=100
    Wait Until Page Contains Element  //*[@name="request.contractCollectorBean.collectionDescriptor"]  timeout=100

Assert Collection Descriptor
    [Arguments]  ${comment}  ${descriptor}
    ${comment}  Split String  ${comment}  \n
    Should Contain  ${comment[2]}  ${descriptor}

Assert Datetime
    [Arguments]  ${comment}
    ${comment}  Split String  ${comment}  \n
    ${date}  getdatetimenow  %Y-%m-%d
    should match regexp  ${comment[0]}  ${date} \\d{2}:\\d{2}:\\d{2}

Get Last Comment
    Click Portal Button  Comments
    Wait Until Page Contains Element  //*[@class="jimg jrefresh"]  timeout=60
    Wait Until Element Is Visible  //div[@id='comments']//div[@id='cmtlst']
    ${comment}  Get Text  //div[@id='comments']//div[@id='cmtlst']/div[1]
    Click Portal Button  Close
    [Return]  ${comment}

Save Current Collection Descriptor
    [Arguments]  ${contractId}
    Reset Charge OFF date  ${contractId}
    ${descriptor}  Get Selected List Label  request.contractCollectorBean.collectionDescriptor
    Set Suite Variable  ${originalDescriptor}  ${descriptor}

Get Last Log
    Click Element  //div[@id='commandMenu']//span[contains(text(), 'Change Log')]
    Wait Until Element Is Visible  //*[@id="changeLog_caption"]  timeout=60

    ${datetime}  getdatetimenow  %Y-%m-%d %H:%M:%S  mins=-10
    log to console   ${datetime}
    Input Text  //div[@id='changeLog_content']//form[1]//input[@name='fromDate']   ${datetime}
    Click Element  //div[@id='changeLog_content']//form[1]//a[1]/div/span
    Wait Until Element Is Not Visible  //div[contains(text(),'Please wait while your request is processed...')]  timeout=100
    ${old_value}  Get Text  //table[@class='jtbl']//tbody/tr[@class='even']//td//div[contains(text(),'COLLECTION_DESCRIPTO')]//parent::td/following-sibling::td[1]
    ${new_value}  Get Text  //table[@class='jtbl']//tbody/tr[@class='even']//td//div[contains(text(),'COLLECTION_DESCRIPTO')]//parent::td/following-sibling::td[2]

    Click Portal Button  Close

    [Return]  ${old_value}  ${new_value}

Assert Collection Descriptor Log
    [Arguments]  ${comment}  ${descriptor}
    Should Be Equal As Strings  ${comment}  ${descriptor}

Change Collections Descriptor to
    [Arguments]  ${descriptor}


    Reset Charge OFF date  ${contractId}
    Wait Until Element Is Not Visible  //div[contains(text(),'Please wait while the selected contract is loaded')]  timeout=100
    Wait Until Page Contains Element  request.contractCollectorBean.collectionDescriptor  timeout=100

    Select From List by Label  request.contractCollectorBean.collectionDescriptor  ${descriptor}
    Click Portal Button  Save
    Wait Until Element Is Visible  //div[contains(text(),'The account was successfully saved')]  timeout=100
    Click Portal Button  OK
    Wait Until Element Is Visible  //a/*/*[text()="Refresh"]
    Click Portal Button  Refresh

    ${status}  run keyword and return status  Wait Until Element Is Visible  //*[@id="refreshConfirm_content"]  timeout=30
    Run Keyword If  ${status}==${True}
    ...  Click Portal Button  Yes

    Wait Until Element Is Not Visible  //div[contains(text(),'Please wait while the selected contract is loaded')]  timeout=100

Assert Read Only on Collection Descriptor Box
    Wait Until Page Contains Element  //select[contains(@disabled,'disabled') and contains(@id,'collectDesc')]  timeout=100

Setup Contract Limit To
    [Tags]  qtest
    [Arguments]  ${limit}  ${contract_id}
    [Documentation]  Update limit method to ${LmtMethod} for your contract
    ...  UPDATE contract SET limit_method='&ltlimit&gt' WHERE contract_id = &ltcontract_id&gt
    Get Into DB  ${DB}
    Execute SQL String  dml=UPDATE contract SET limit_method='${limit}' WHERE contract_id = ${contract_id}
    Execute SQL String  COMMIT

Change Credit Limit On DB To
    [Arguments]  ${credit_limit}
    Get Into DB  ORACLE
    Execute SQL String  dml=UPDATE HZ_CUST_PROFILE_AMTS SET OVERALL_CREDIT_LIMIT = ${credit_limit} WHERE CUST_ACCT_PROFILE_AMT_ID = ${custacctprofileamtid}

Update Credit Limit To
    [Arguments]  ${credit_limit}
    Wait Until Page Contains Element  request.contract.origLimit  timeout=60
    Input Text  request.contract.origLimit  ${credit_limit}
    run keyword and ignore error  Click Portal Button  Yes  #parent=//div[@id='confirmCreditLimitChg_content']
    Click Portal Button  Save
    Wait Until Page Contains Element  //div[@id='limitRsn_content']//span[text()='OK']  timeout=120
    Click Element  //div[@id='limitRsn_content']//span[text()='OK']
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
    ${limit}  Get Credit Limit From DB By CUST_ACCT_PROFILE_AMT_ID  ${custacctprofileamtid}
    Should Be Equal As Numbers  ${limit}  5500

Define Carrier and Contract
    [Tags]  qtest
    [Documentation]  Get carrier, contract and card number
    ...  SELECT c.card_num,c.carrier_id,co.contract_id
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

Update Value on Portal
    [Tags]  qtest
    [Documentation]  Copy down value in ${field}
    ...  replace value in ${field} with ${New_value}
    ...  if confirm box appears confirm changes
    ...  Click Save
    [Arguments]  ${list}=No  ${text}=${EMPTY}
    Wait Until Page Contains Element  //*[@name="request.contract.creditLimit"]  timeout=60
    ${OLD_Value}  Get Value  //*[@name="request.contract.${field}"]
    Set Test Variable  ${OLD_Value}
    run keyword if  '${list}'=='No'  Input Text  request.contract.${field}  ${New_value}
    run keyword if  '${list}'=='List'  Select From List By Value  request.contract.${field}  ${New_value}
    run keyword if  '${list}'=='List'  Wait Until Page Contains  text=Save
    Click Portal Button  Save
    run keyword if  '${text}'!='${EMPTY}'  Wait Until Page Contains  text=${text}  timeout=120
    run keyword if  '${text}'!='${EMPTY}'  Click On  text=${text}
    run keyword if  '${text}'!='${EMPTY}'  Sleep  2

Verify Value Changed in Database
    [Documentation]  Run sql
    ...  SELECT * FROM contract c, cont_misc cm
    ...  WHERE c.contract_id=cm.contract_id AND c.contract_id = &ltcontract.id&gt
    ...  AND c.carrier_id=&ltcarrier_id&gt
    [Tags]  qtest  expected_results: database column ${column} matches what you changed it too ${New_Value}
    Get Into DB  ${DB}
    ${query}  catenate  SELECT * FROM contract c, cont_misc cm
    ...     WHERE c.contract_id=cm.contract_id AND c.contract_id = ${contract.contract_id}
    ...     AND c.carrier_id=${contract.carrier_id}
    ${results}  Query And Strip To Dictionary  ${query}
    run keyword if  '${compare}' == 'Numbers'  Should Be Equal As Numbers  ${results.${column}}  ${New_Value}
    ...  ELSE  Should Be Equal As Strings  ${results.${column}.strip()}  ${New_Value}

Get CUST_ACCT_PROFILE_AMT_ID
    [Arguments]  ${ar_number}  ${currency}
    ${oraclesql}  catenate  select site_use_id
    ...  from hz_cust_site_uses_all
    ...  where location = '${ar_number.strip()}'
    get into db  Oracle
    ${siteid}  query and strip  ${oraclesql}
    ${oraclesql}  catenate  select CUST_ACCT_PROFILE_AMT_ID
    ...  from hz_cust_profile_amts
    ...  where site_use_id = '${siteid}'
    ...  and CURRENCY_CODE= '${currency}'
    get into db  Oracle
    ${custacctprofileamtid}  query and strip  ${oraclesql}
    set test variable  ${custacctprofileamtid}