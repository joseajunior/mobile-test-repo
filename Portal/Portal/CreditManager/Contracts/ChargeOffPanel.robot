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
Documentation  This file tests the functionality of the ChargeOff tab in the Credit Manager.

Suite Setup  Open Browser And Login To Portal
Suite Teardown  Close Everything

*** Variables ***
${original_ChargeOffData}
${test_ChargeOffDataOn}  Y;465.43;2019/10/30 10:40:53
${AR_number}

*** Test Cases ***

Charge Off panel - Check if Charge Off Panel is Not Visible
    [Tags]  JIRA:PORT-23  JIRA:PORT-89  qTest:37911125
    [Documentation]  This test verifies you cannot see Charge Off panel when chorge of flag is "N"
    Get the AR Number  283601
    Get OriginalChargeOff Data  ${AR_number}
    Set Charge off Flag  ${AR_number}
    Go To Credit Manager And Select Contract  283601
    Check if Charge Off Panel is Not Visible
    Set Charge Off Flag  ${AR_number}  ${original_ChargeOffData}

Charge Off panel - Charge Off Status
    [Tags]  JIRA:PORT-23  JIRA:PORT-89  qTest:37911125
    [Documentation]  This test is to verify if the user can see Charge Off Status on the charge off panel and also verify if the data that is being displayed matches what is in the database
    Get the AR Number  283601
    Get OriginalChargeOff Data  ${AR_number}
    Set Charge off Flag  ${AR_number}  ${test_ChargeOffDataOn}
    Go To Credit Manager And Select Contract  283601
    Get Charge Off Values from Database  ${AR_number}
    Click on Charge Off Panel and Get Values from Screen
    Should Be Equal  ${ChargeOffStatusDB}  ${ChargeOffStatusScreen}
    Set Charge Off Flag  ${AR_number}  ${original_ChargeOffData}

Charge Off panel - Charge Off Date
    [Tags]  JIRA:PORT-23  JIRA:PORT-89  qTest:37911125
    [Documentation]  This test is to verify if the user can see Charge Off Date on the charge off panel and also verify if the data that is being displayed matches what is in the database
    Get the AR Number  283601
    Get OriginalChargeOff Data  ${AR_number}
    Set Charge off Flag  ${AR_number}  ${test_ChargeOffDataOn}
    Go To Credit Manager And Select Contract  283601
    Click on Charge Off Panel and Get Values from Screen
    Get Charge Off Values from Database    ${AR_number}
    Should Be Equal  ${ChargeOffDateDB}  ${ChargeOffDateScreen}
    Set Charge Off Flag  ${AR_number}  ${original_ChargeOffData}

Charge Off panel - Charge Off Amount
    [Tags]  JIRA:PORT-23  JIRA:PORT-89  qTest:37911125
    [Documentation]  This test is to verify if the user can see Charge Off Amount on the charge off panel and also verify if the data that is being displayed matches what is in the database
    Get the AR Number  283601
    Get OriginalChargeOff Data  ${AR_number}
    Set Charge off Flag  ${AR_number}  ${test_ChargeOffDataOn}
    Go To Credit Manager And Select Contract  283601
    Click on Charge Off Panel and Get Values from Screen
    Get Charge Off Values from Database    ${AR_number}
    Should Be Equal  ${ChargeOffAmountDB}  ${ChargeOffAmountDB}
    Set Charge Off Flag  ${AR_number}  ${original_ChargeOffData}

Charge Off panel - Total Owed
    [Tags]  JIRA:PORT-23  JIRA:PORT-89  qTest:37911125
    [Documentation]  This test is to verify if the user can see Total Owed on the charge off panel and also verify if the data that is being displayed matches what is in the database
    Get the AR Number  283601
    Get OriginalChargeOff Data  ${AR_number}
    Set Charge off Flag  ${AR_number}  ${test_ChargeOffDataOn}
    Go To Credit Manager And Select Contract  283601
    Click on Charge Off Panel and Get Values from Screen
    Get Charge Off Values from Database    ${AR_number}
    should_be_equal_as_numbers  ${ChargeOffAmountOwedDB}  ${TotalOwedScreen}
    Set Charge Off Flag  ${AR_number}  ${original_ChargeOffData}

*** Keywords ***

Check if Charge Off Panel is Not Visible
      Element Should Not be Visible  //ul/li//span[text()='Charge Off']  timeout=20

Set Charge Off Flag
    [Arguments]  ${location}  ${ChargeOffFlag}=''

    Get Into DB  ORACLE

    ${query}  catenate  update HZ_CUST_ACCT_SITES_all HCAS
        ...  set HCAS.attribute1 = '${ChargeOffFlag}'
        ...  where (select cust_acct_site_id from HZ_CUST_SITE_USES_all where location='${location}')
        ...  = hcas.cust_acct_site_id

    Execute Sql String  dml=${query}

Get the AR Number
    [Arguments]  ${contractID}
    get into db  TCH
    ${query}  catenate  select ar_number from contract where contract_id='${contractID}'
    ${AR}  Query And Strip to Dictionary  ${query}
    set test variable  ${ar_num}  ${AR['ar_number']}
    ${ar_num}  strip my string  ${ar_num}
    set suite variable  ${AR_number}  ${ar_num}


Get OriginalChargeOff Data
    [Arguments]  ${location}
    get into db  ORACLE
    ${query}  catenate  select HCAS.attribute1
        ...  from HZ_CUST_ACCT_SITES_all HCAS,
        ...  HZ_CUST_SITE_USES_all HCSU
        ...  where HCSU.cust_acct_site_id = hcas.cust_acct_site_id
        ...  and hcsu.location='${location}'
    ${original_ChargeOffData}  Query And Strip to Dictionary  ${query}

Get Charge Off Values from Database
    [Arguments]  ${AR_number}
    Set Test Variable  ${location}  ${AR_number}      #1043501900356
    Set Test Variable  ${orgId}  81

    Get Into DB  ORACLE

    ${query}  catenate  SELECT substr(HCAS.attribute1,1,1) chargeOffFlag,
    ...  trunc(To_date(substr(HCAS.attribute1,instr(HCAS.attribute1,';',1,2)+1),'YYYY/MM/DD HH24:MI:SS')) chargeOffDate,
    ...  substr(HCAS.attribute1,3,(LENGTH (HCAS.attribute1)-(LENGTH (substr(HCAS.attribute1,instr(HCAS.attribute1,';',1,2)+1))+2))-1) chargeOffAmount,
    ...  (select sum(aps.AMOUNT_DUE_remaining)
    ...       FROM ar_payment_schedules_all aps
    ...       WHERE 1=1
    ...       AND aps.CUSTOMER_SITE_USE_ID=HCSU.SITE_USE_ID
    ...   ) amountOwed
    ...  FROM HZ_PARTIES HP,
    ...       HZ_PARTY_SITES HPS,
    ...       HZ_CUST_ACCOUNTS HCA,
    ...       HZ_CUST_ACCT_SITES_all HCAS,
    ...       HZ_CUST_SITE_USES_all HCSU,
    ...       HZ_CUSTOMER_PROFILES HCP
    ...  WHERE 1=1
    ...  AND HCP.CUST_ACCOUNT_ID = HCAS.CUST_ACCOUNT_ID
    ...  AND HCP.CUST_ACCOUNT_ID = HCA.CUST_ACCOUNT_ID
    ...  AND HCSU.SITE_USE_CODE = 'BILL_TO'
    ...  AND HCSU.CUST_ACCT_SITE_ID = HCAS.CUST_ACCT_SITE_ID
    ...  AND HCSU.SITE_USE_ID = HCP.SITE_USE_ID
    ...  AND HCSU.location='${location}'
    ...  AND HCSU.org_id='${orgId}'
    ...  AND HCAS.STATUS='A'
    ...  AND HCAS.PARTY_SITE_ID  = HPS.PARTY_SITE_ID
    ...  AND HCA.PARTY_ID = HP.PARTY_ID
    ...  AND HPS.PARTY_ID = HP.PARTY_ID

    ${ChargeOffInformation}  Query And Strip to Dictionary  ${query}
    ${ChargeOffStatusDB}  Set Variable If  '${ChargeOffInformation['chargeoffflag']}'=='Y'  YES  ${ChargeOffInformation['chargeoffflag']}
    ${ChargeOffDateDB}  Convert to String  ${ChargeOffInformation['chargeoffdate']}
    ${ChargeOffDateDB}  Split String  ${ChargeOffDateDB}  ${SPACE}
    ${ChargeOffDateDB}  Set Variable  ${ChargeOffDateDB[0]}
    ${ChargeOffAmountDB}  Set Variable  ${ChargeOffInformation['chargeoffamount']}
    ${ChargeOffAmountOwedDB}  Set Variable  ${ChargeOffInformation['amountowed']}
    ${ChargeOffAmountOwedDB}  convert to string  ${ChargeOffAmountOwedDB}
    ${ChargeOffAmountOwedDB}  remove string  ${ChargeOffAmountOwedDB}  -
    Set Test Variable  ${ChargeOffStatusDB}
    Set Test Variable  ${ChargeOffAmountDB}
    Set Test Variable  ${ChargeOffDateDB}
    Set Test Variable  ${ChargeOffAmountOwedDB}

Click on Charge Off Panel and Get Values from Screen
    Wait Until Element Is Visible  //ul/li//span[text()='Charge Off']  timeout=60
    click element  //ul/li//span[text()='Charge Off']
    ${ChargeOff}  Get Text  //div[@id='chargeoff']
    ${ChargeOff}  Split String  ${ChargeOff}  \n
    ${ChargeOffStatusScreen}  set variable  ${ChargeOff[5]}
    ${TotalOwedScreen}  remove string  ${ChargeOff[6]}  $  (  )
    ${ChargeOffAmountScreen}  remove string  ${ChargeOff[8]}  $
    Set Test Variable  ${ChargeOffStatusScreen}
    Set Test Variable  ${TotalOwedScreen}
    Set Test Variable  ${ChargeOffDateScreen}  ${ChargeOff[7]}
    Set Test Variable  ${ChargeOffAmountScreen}

Reset Charge OFF date
    [Arguments]  ${contractId}
    ${date}  getDateTimeNow  %Y-%m-%d  days=-2  tzinfo=US/Mountain
    Get Into DB  TCH
    Execute SQL String  dml=UPDATE contract_collector SET charge_off_date = "${date}" WHERE contract_id = ${contractId}
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
    [Arguments]  ${contract}

    Set Test Variable  ${DB}  TCH

    Wait Until Page Contains Element  //*[@id="pmd_home"]  timeout=60
    Click Element  //*[@id="pmd_home"]      #GO BACK TO THE HOME PAGE
    Wait Until Element Is Visible  //*[text()[contains(.,"Credit Manager")]]  timeout=60
    Select Portal Program  Credit Manager
    Input Text  request.search.contractId  ${contract}
    Click Portal Button  Search
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]  timeout=120
    Double Click Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]


