*** Settings ***
Documentation  Tests every possible combination of policy and card limits given the limit source.
...  No preauthorization is ran to validate. Rather only database checks verify that the limits
...  updated on the card through Account Manager are correctly saved in the database.

Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM  Card

*** Test Cases ***
Change Hold for Fraud Status to Active
    [Tags]  JIRA:BOT-1706  qTest:29001597  Regression  qTest:30738307  refactor
    [Documentation]  Navigate to edit card and change the status from Hold For Fraud to Active
    Search For A Card By Status  FRAUD

    Open Emanager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search For A Card  ${card_num}
    Change Card Status  ACTIVE
    Assert Sucess Message  Edit Successful
    Assert Card Status on DB  ${card_num}  ACTIVE

    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  Update Card Status on DB  ${card_num}  FRAUD
    ...         AND  Disconnect From Database

Card Detail - Read Only Fields Are Correct
    [Tags]  JIRA:BOT-1331  qTest:32790198  Regression  refactor
    [Documentation]  Make sure all the read-only information on the Card Details tab are correct.

    Set Test Variable  ${CardNumber}  ${validCard.card_num}

    Open Account Manager
    Click On  text=Cards
    wait until loading spinners are gone
    Check Element Exists  text=Business Partner
    Select From List By Value  //*[@class="cardBusinessPartnerSelect searchFilter" and @name="businessPartnerCode"]  EFS
    wait until loading spinners are gone
    Wait Until Element Is Visible  name=cardNumber  timeout=30
    Input Text  name=cardNumber  ${CardNumber}
    Click On  text=Submit  exactMatch=False
    wait until loading spinners are gone
    Click On  text=${CardNumber}
    wait until loading spinners are gone

    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT TRIM(c.card_num) as card_num,
    ...         TO_CHAR(c.expiredate, '%m/%Y' ) AS expiredate,
    ...         TO_CHAR(c.created,'%m/%d/%Y' ) AS created,
    ...         decode(TO_CHAR(c.renewal_expiredate, '%m/%Y' ), NULL, '', TO_CHAR(c.renewal_expiredate, '%m/%Y' )) AS renewal_expiredate,
    ...         decode(TO_CHAR(c.card_lock_date, '%m/%d/%Y %H:%M' ), NULL, '', TO_CHAR(c.card_lock_date, '%m/%d/%Y %H:%M' )) AS card_lock_date,
    ...         c.carrier_id,
    ...         TRIM(m.name) AS name,
    ...         TO_CHAR(c.last_used, '%m/%d/%Y') AS last_used,
    ...         cp.valid,
    ...         TO_CHAR(cp.set, '%m/%d/%Y') AS set,
    ...         TRIM(c.card_type) AS card_type,
    ...         TRIM(decode(cm.first_line_sub,NULL,'',cm.first_line_sub)) AS first_line_sub,
    ...         TRIM(decode(cm.second_line, NULL,'',cm.second_line)) AS second_line
    ...  FROM cards c
    ...     LEFT JOIN card_pins cp ON c.card_num = cp.card_num
    ...     JOIN card_misc cm ON c.card_num = cm.card_num
    ...     JOIN member m ON c.carrier_id = m.member_id
    ...  WHERE c.card_num = '${CardNumber}'
    ${CardDetails}  Query And Strip To Dictionary  ${query}

    Wait Until Element Is Visible  //*[@class="numberOfcards"]  timeout=30
    ${CardDetails_CardNumber}  Get Text  //*[@class="numberOfcards"]
    ${CardDetails_ExpirationDate}  Get Text  //*[@name="detailRecord.expirationDate"]/following-sibling::*[1]
    ${CardDetails_LastPrintDate}  Get Text  //*[@name="detailRecord.lastPrintDate"]/following-sibling::*[1]
    ${CardDetails_NewExpiration}  Get Text  //*[@name="detailRecord.newExpiration"]
    ${CardDetails_CardLockedDate}  Get Text  //*[contains(text(),'Card Locked Date')]/parent::td/following-sibling::td
    ${CardDetails_Customer}  Get Text  //*[@id="cardActionForm"]//*[contains(text(), '${CardDetails["name"]}')]
    ${CardDetails_LastUsedDate}  Get Text  //*[@id="cardActionForm"]//*[contains(text(),'${CardDetails["last_used"]}')]
    ${CardDetails_CardPINSetDate}  Get Text  //*[@id="cardActionForm"]//*[contains(text(), '${CardDetails["set"]}')]
    ${CardDetails_CardPINStatus}  Get Text  //*[contains(text(),'Card PIN Status')]/parent::td/following-sibling::td[1]
    ${CardDetails_CardStyle}  Get Text  //*[contains(text(),'Card Style')]/parent::td/following-sibling::td[1]
    ${CardDetails_CompNameEmbossing}  Get Text  //*[contains(text(),'Alternate Company Name Embossing')]/parent::td/following-sibling::td[1]
    ${CardDetails_CardHolderUnitEmboss}  Get Text  //*[contains(text(),'Card Holder/Unit Embossing')]/parent::td/following-sibling::td[1]

    ${CardDetails_CardStyle}  Set Variable IF  '${CardDetails_CardStyle}'=='SMART PAY'  SMRT  ${CardDetails_CardStyle}
    ${CardDetails_NewExpiration}  Set Variable IF  '${CardDetails_NewExpiration}'=='${SPACE}'  None  ${CardDetails_NewExpiration}
    ${CardDetails_CardLockedDate}  Set Variable IF  '${CardDetails_CardLockedDate}'=='${SPACE}'  None  ${CardDetails_CardLockedDate}
    ${CardDetails_LastUsedDate}  Set Variable IF  '${CardDetails_LastUsedDate}'=='${SPACE}'  None  ${CardDetails_LastUsedDate}

    ${DB_Customer}  catenate  ${CardDetails["carrier_id"]} ${CardDetails["name"]}

    Should Be Equal As Strings  ${CardDetails["card_num"]}  ${CardDetails_CardNumber}
    Should Be Equal As Strings  ${CardDetails["expiredate"]}  ${CardDetails_ExpirationDate}
    Should Be Equal As Strings  ${CardDetails["created"]}  ${CardDetails_LastPrintDate}
    Should Be Equal As Strings  ${DB_Customer}  ${CardDetails_Customer}
    Should Be Equal As Strings  ${CardDetails["last_used"]}  ${CardDetails_LastUsedDate}
    Should Be Equal As Strings  ${CardDetails["set"]}  ${CardDetails_CardPINSetDate}
    Should Be Equal As Strings  ${CardDetails["valid"]}  ${CardDetails_CardPINStatus}
    Should Be Equal As Strings  ${CardDetails["card_type"]}  ${CardDetails_CardStyle}
    Should Be Equal As Strings  ${CardDetails["first_line_sub"]}  ${CardDetails_CompNameEmbossing}
    Should Be Equal As Strings  ${CardDetails["second_line"]}  ${CardDetails_CardHolderUnitEmboss}
    Should Be Equal As Strings  ${CardDetails["renewal_expiredate"]}  ${CardDetails_NewExpiration}
    Should Contain  ${CardDetails_CardLockedDate}  ${CardDetails["card_lock_date"]}
    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Card Detail - All Fields That Can Be Edited Can Be Saved
    [Tags]  JIRA:BOT-1333  JIRA:BOT-1951  qTest:32822235  qTest:31752059  qTest:31772292  qTest:31780536  qTest:30738307  qTest:30864607  qTest:30864728  qTest:30864733  Regression  refactor

    Set Test Variable  ${CardNumber}  ${UniversalCard.card_num}
    Start Setup Card  ${CardNumber}
    Setup Card Contract  velocity_enabled=Y  # This needs to be 'Y' to display refreshLimitsSource in AM

    Open Account Manager
    Click On  text=Cards
    Check Element Exists  text=Business Partner
    Select From List By Value  //*[@class="cardBusinessPartnerSelect searchFilter" and @name="businessPartnerCode"]  EFS
    Wait Until Element Is Visible  name=cardNumber  timeout=30
    Input Text  name=cardNumber  ${CardNumber}
    Click On  text=Submit  exactMatch=False
    Click On  text=${CardNumber}

    Get Into DB  TCH
    ${query}  catenate  SELECT mrcsrc, payr_use, status, icardpolicy, handenter, infosrc, lmtsrc, timesrc,locsrc,velsrc, managed_fuel,managed_non_fuel FROM cards WHERE card_num='${CardNumber}';
    ${storage}  Query And Strip To Dictionary  ${query}
    Tch Logging  All Original Values Stored!
    tch logging  ORIGINALS:${storage}

    ${updateString}  Assign String  dml=UPDATE cards SET mrcsrc='${storage["mrcsrc"]}', payr_use='${storage["payr_use"]}', status = '${storage["status"]}', icardpolicy = ${storage["icardpolicy"]}, handenter = '${storage["handenter"]}', infosrc = '${storage["infosrc"]}', lmtsrc = '${storage["lmtsrc"]}', timesrc = '${storage["timesrc"]}', locsrc = '${storage["locsrc"]}', velsrc = '${storage["velsrc"]}', managed_fuel = '${storage["managed_fuel"]}', managed_non_fuel = '${storage["managed_non_fuel"]}' WHERE card_num='${CardNumber}'
    Tch Logging  UPDATE:${updateString}

#   CHANGE FIELDS

    Wait Until Page Contains Element  //*[@id="massUpdateCustomerCardSummary.cardStatusCode" and @name="detailRecord.status"]  timeout=30

    Select From List By Value  //*[@id="massUpdateCustomerCardSummary.cardStatusCode" and @name="detailRecord.status"]  INACTIVE
    Select From List By Value  //*[@name="detailRecord.policyId" and @id="massUpdateCustomerCardSummary.policyId"]  3
    Select From List By Value  //*[@name="detailRecord.handEnter"]  ALLOW
    Select From List By Value  //*[@name="detailRecord.promptSource"]  POLICY
    Select From List By Value  //*[@name="detailRecord.productSource"]  POLICY
    Select From List By Value  //*[@name="detailRecord.timeRestrictionsSource"]  POLICY
    Select From List By Value  //*[@name="detailRecord.merchantSource"]  POLICY
    Select From List By Value  //*[@name="detailRecord.refreshLimitsSource"]  POLICY
    Select From List By Value  //*[@name="detailRecord.managedFuel"]  Y
    Select From List By Value  //*[@name="detailRecord.managedNonFuel"]  N
    Select From List By Value  //*[@name="detailRecord.cardConfiguration"]  COMPLETE
    Select From List By Value  //*[@name="detailRecord.productLimitMethod"]  DEBIT_LIMIT_CHECK

    Double Click On  text=Submit  exactMatch=False
    Check Element Exists  text=Edit Successful


    Sleep  5

    ${query}  catenate  SELECT mrcsrc, payr_use, status, icardpolicy, handenter, infosrc,
    ...     lmtsrc, timesrc, locsrc, velsrc, managed_fuel,managed_non_fuel FROM cards WHERE card_num='${CardNumber}';
    ${cardDetails}  Query And Strip To Dictionary  ${query}

    Should Be Equal As Strings  ${cardDetails["status"]}  I
    Should Be Equal As Strings  ${cardDetails["icardpolicy"]}  3
    Should Be Equal As Strings  ${cardDetails["handenter"]}  Y
    Should Be Equal As Strings  ${cardDetails["infosrc"]}  D
    Should Be Equal As Strings  ${cardDetails["lmtsrc"]}  D
    Should Be Equal As Strings  ${cardDetails["timesrc"]}  D
    Should Be Equal As Strings  ${cardDetails["locsrc"]}  D
    Should Be Equal As Strings  ${cardDetails["velsrc"]}  D
    Should Be Equal As Strings  ${cardDetails["managed_fuel"]}  Y
    Should Be Equal As Strings  ${cardDetails["managed_non_fuel"]}  N
    Should Be Equal As Strings  ${cardDetails["payr_use"]}  B
    Should Be Equal As Strings  ${cardDetails["mrcsrc"]}  L

#   PUTTING BACK ALL VALUES

    [Teardown]  Run Keywords  Execute SQL String  ${updateString}
    ...     AND  Execute SQL String  commit
    ...     AND  tch logging  update done
    ...     AND  Close Browser
    ...     AND  Disconnect From Database


*** Keywords ***
Search For A Card By Status
    [Arguments]  ${card_status}

    ${card_status}  Set Variable If  '${card_status}'=='FRAUD'  U  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='ACTIVE'  A  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='INACTIVE'  I  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='HOLD'  H  ${card_status}

    Get Into DB  TCH
    ${card_num}  Query And Strip  SELECT TRIM(card_num) AS card_num FROM cards WHERE status='${card_status}' ORDER BY lastupdated DESC LIMIT 1

    Set Test Variable  ${card_num}  ${card_num}

Navigate To Account Manager
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Search For A Card
    [Arguments]  ${card_num}
    Wait Until Element is Enabled  //a[@id='Card']  timeout=30
    Click on  //a[@id='Card']
    Wait Until Element Is Visible  name=cardNumber  timeout=30
    Refresh Page
    Wait Until Element Is Visible  name=businessPartnerCode  timeout=30
    Select From List By Value  businessPartnerCode  EFS
    Wait Until Element is Enabled  //input[@name='cardNumber']  timeout=30
    Input Text  name=cardNumber  ${card_num}
    Double Click On  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0  timeout=30
    Wait Until Element is Visible  //button[text()='${card_num}']  timeout=30
    Set Focus To Element  //button[text()='${card_num}']
    Click On  //button[text()='${card_num}']
    Wait Until Element Is Enabled  id=submit  timeout=30

Change Card Status
    [Arguments]  ${card_status}
    Wait Until Element Is Enabled  detailRecord.status  timeout=20
    Select From List By Value  detailRecord.status  ${card_status}
    Double Click On  id=submit

Assert Sucess Message
    [Arguments]  ${message}
    Wait Until Element Is Visible  //ul[@class='msgSuccess']//li[text()='${message}']  timeout=20

Assert Card Status on DB
    [Arguments]  ${card_num}  ${card_status}

    ${card_status}  Set Variable If  '${card_status}'=='FRAUD'  U  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='ACTIVE'  A  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='INACTIVE'  I  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='HOLD'  H  ${card_status}

    Get Into DB  TCH
    Row Count Is Equal To X  SELECT 1 FROM cards WHERE status = '${card_status}' AND card_num = '${card_num}'  1

Update Card Status on DB
    [Arguments]  ${card_num}  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='FRAUD'  U  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='ACTIVE'  A  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='INACTIVE'  I  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='HOLD'  H  ${card_status}

    Get Into DB  TCH
    Execute SQL String  dml=UPDATE cards SET status='${card_status}' WHERE card_num='${card_num}'
