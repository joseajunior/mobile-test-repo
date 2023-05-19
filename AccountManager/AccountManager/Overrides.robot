*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.auth.PyAuth.Transactions
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Teardown  Tear Me Down
Force Tags  AM  Card Detail  refactor

*** Variables ***
${policy}  1
${card_override}  5567480060700422
*** Test Cases ***
Add override with multiple swipes and all options checked (mm_value=N)
    [Tags]  JIRA:BOT-BOT-1378  qTest:32590625  Regression  qTest:30783002
    [Documentation]  Make sure that Card override is set properly and refreshing limits is set in cards table
    ...  Card limits are properly overridden in card_lmt table

    Get Into DB  TCH
    ${query}  catenate
    ...     SELECT mm_value, member_meta_id FROM member_meta WHERE member_id = ${efs_carrier} AND member_meta.mm_key = 'PRODLMTS'
    ${storage}  Query And Strip To Dictionary  ${query}

    Execute SQL String  dml=UPDATE member_meta SET mm_value = 'N' WHERE member_meta_id = ${storage["member_meta_id"]}

    Open Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${efs_carrier}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${efs_carrier}
    Click On  text=Policies
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${policy}
    Click On  text=Cards
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${card_override}
    Click On  text=Overrides

    Wait Until Element Is Visible  //*[@name="overridesSummary.cardSwipes"]  timeout=20
    Select From List By Value  overridesSummary.cardSwipes  9
    Click On  //*[@name="overridesSummary.overrideAllMerchants" and @type="checkbox"]
    Click On  //*[@name="overridesSummary.allowHandEntry" and @type="checkbox"]
    Check Element Exists  //*[@name="overridesSummary.allowProductLimitOverride" and @checked="checked"]
    Click On  //*[@id="btnEditProductLimits"]
    Click On  //*[@data-product-code="GAS " and @type="checkbox"]
    Check Element Exists  text=Product Restrictions Override  timeout=20
    Wait Until Element Is Not Visible  //*[@id="restrictionGrpTable"]//*[contains(text(),'GASOHOL')]  timeout=20
    Click On  text=Submit  exactMatch=False  index=4
    Sleep  1
    Click On  text=Submit  exactMatch=False  index=3
    Click On  //*[@name="overridesSummary.refreshingLimitsOverride" and @type="checkbox"]

    Input Text  //*[@name="overridesSummary.dailyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.weeklyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.weeklyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.weeklyAmountOverride"]  0
    Input Text  //*[@name="overridesSummary.monthlyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.monthlyAmountOverride"]  0

    Click On  text=Submit  exactMatch=False  index=3

    Select From List By Value  //*[@name="overridesSummary.productSource"]  POLICY
    Click On  text=Submit  exactMatch=False  index=2

    Get Into DB  TCH
    ${query}  catenate  SELECT cardoverride, day_cnt_limit, day_amt_limit, week_cnt_limit, week_amt_limit,
    ...     mon_cnt_limit, mon_amt_limit FROM cards WHERE card_num='${card_override}'
    ${results}  Query And Strip To Dictionary  ${query}

    Should Be Equal As Numbers  ${results["cardoverride"]}  9
    Should Be Equal As Numbers  ${results["day_cnt_limit"]}  0
    Should Be Equal As Numbers  ${results["day_amt_limit"]}  0
    Should Be Equal As Numbers  ${results["week_cnt_limit"]}  0
    Should Be Equal As Numbers  ${results["week_amt_limit"]}  0
    Should Be Equal As Numbers  ${results["mon_cnt_limit"]}  0
    Should Be Equal As Numbers  ${results["mon_amt_limit"]}  0

    [Teardown]  Run Keywords  Execute SQL String  dml=UPDATE member_meta SET mm_value = '${storage["mm_value"]}' WHERE member_meta_id = ${storage["member_meta_id"]}
    ...   AND  Close Browser
    ...   AND  Disconnect From Database

Remove The Override From Card (mm_value=N)
    [Tags]  JIRA:BOT-1379  qTest:32590700  Regression
    [Documentation]  Make sure you can remove an override from a card

    Get Into DB  TCH
    ${query}  catenate
    ...     SELECT mm_value, member_meta_id FROM member_meta WHERE member_id = ${efs_carrier} AND member_meta.mm_key = 'PRODLMTS'
    ${storage}  Query And Strip To Dictionary  ${query}

    Execute SQL String  dml=UPDATE member_meta SET mm_value = 'N' WHERE member_meta_id = ${storage["member_meta_id"]}

    Open Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${efs_carrier}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${efs_carrier}
    Click On  text=Policies
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${policy}
    Click On  text=Cards
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${card_override}
    Click On  text=Overrides
    Click On  text=Remove Override

    Get Into DB  TCH
    ${query}  catenate  SELECT cardoverride FROM cards WHERE card_num='${card_override}'
    ${results}  Query And Strip  ${query}

    Should Be Equal As Numbers  ${results}  0

    [Teardown]  Run Keywords  Execute SQL String  dml=UPDATE member_meta SET mm_value = '${storage["mm_value"]}' WHERE member_meta_id = ${storage["member_meta_id"]}
    ...   AND  Close Browser
    ...   AND  Disconnect From Database

Add override with multiple swipes and all options checked (mm_value=Y)
    [Tags]  JIRA:BOT-BOT-1378  qTest:32593632  Regression
    [Documentation]  Make sure that Card override is set properly and refreshing limits is set in cards table
    ...  Card limits are properly overridden in card_lmt table

    Get Into DB  TCH
    ${query}  catenate
    ...     SELECT mm_value, member_meta_id FROM member_meta WHERE member_id = ${efs_carrier} AND member_meta.mm_key = 'PRODLMTS'
    ${storage}  Query And Strip To Dictionary  ${query}

    Execute SQL String  dml=UPDATE member_meta SET mm_value = 'Y' WHERE member_meta_id = ${storage['member_meta_id']}

    Open Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${efs_carrier}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${efs_carrier}
    Click On  text=Policies
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${policy}
    Click On  text=Cards
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${card_override}
    Click On  text=Overrides
    Wait Until Element Is Visible  //*[@name="overridesSummary.cardSwipes"]  timeout=20
    Select From List By Value  overridesSummary.cardSwipes  9
    Click On  //*[@name="overridesSummary.overrideAllMerchants" and @type="checkbox"]
    Click On  //*[@name="overridesSummary.allowHandEntry" and @type="checkbox"]

    Click On  //*[@id="btnEditProductLimits"]
    Click On  //*[@data-product-code="GAS " and @type="checkbox"]

    Check Element Exists  text=Product Restrictions Override  timeout=20
    Check Element Exists  //*[@id="restrictionGrpTable"]//*[contains(text(),'UNLEADED REGULAR')]  timeout=20
    Check Element Exists  //*[@id="restrictionGrpTable"]//*[contains(text(),'UNLEADED PLUS')]  timeout=20
    Check Element Exists  //*[@id="restrictionGrpTable"]//*[contains(text(),'UNLEADED PREMIUM')]  timeout=20
    Check Element Exists  //*[@id="restrictionGrpTable"]//*[contains(text(),'GASOHOL')]  timeout=20
    Check Element Exists  //*[@id="restrictionGrpTable"]//*[contains(text(),'UNLEADED CARD LOCK GAS')]  timeout=20
    Check Element Exists  //*[@id="restrictionGrpTable"]//*[contains(text(),'ETHANOL UNLEADED')]  timeout=20

    Click On  text=Submit  exactMatch=False  index=4
    Sleep  1
    Click On  text=Submit  exactMatch=False  index=3

    Click On  //*[@name="overridesSummary.refreshingLimitsOverride" and @type="checkbox"]

    Input Text  //*[@name="overridesSummary.dailyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.weeklyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.weeklyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.weeklyAmountOverride"]  0
    Input Text  //*[@name="overridesSummary.monthlyCountOverride"]  0
    Input Text  //*[@name="overridesSummary.monthlyAmountOverride"]  0

    Click On  text=Submit  exactMatch=False  index=3

    Select From List By Value  //*[@name="overridesSummary.productSource"]  POLICY
    Click On  text=Submit  exactMatch=False  index=2

    Get Into DB  TCH
    ${query}  catenate  SELECT cardoverride, day_cnt_limit, day_amt_limit, week_cnt_limit, week_amt_limit,
    ...     mon_cnt_limit, mon_amt_limit FROM cards WHERE card_num='${card_override}'
    ${results}  Query And Strip To Dictionary  ${query}

    Should Be Equal As Numbers  ${results["cardoverride"]}  9
    Should Be Equal As Numbers  ${results["day_cnt_limit"]}  0
    Should Be Equal As Numbers  ${results["day_amt_limit"]}  0
    Should Be Equal As Numbers  ${results["week_cnt_limit"]}  0
    Should Be Equal As Numbers  ${results["week_amt_limit"]}  0
    Should Be Equal As Numbers  ${results["mon_cnt_limit"]}  0
    Should Be Equal As Numbers  ${results["mon_amt_limit"]}  0

    [Teardown]  Run Keywords  Execute SQL String  dml=UPDATE member_meta SET mm_value = '${storage['mm_value']}' WHERE member_meta_id = ${storage['member_meta_id']}
    ...   AND  Close Browser
    ...   AND  Disconnect From DataBase

Remove The Override From Card (mm_value=Y)
    [Tags]  JIRA:BOT-1379  qTest:32593699  Regression
    [Documentation]  Make sure you can remove an override from a card

    Get Into DB  TCH
    ${query}  catenate
    ...     SELECT mm_value, member_meta_id FROM member_meta WHERE member_id = ${efs_carrier} AND member_meta.mm_key = 'PRODLMTS'
    ${storage}  Query And Strip To Dictionary  ${query}

    Execute SQL String  dml=UPDATE member_meta SET mm_value = 'Y' WHERE member_meta_id = ${storage['member_meta_id']}

    Open Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${efs_carrier}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${efs_carrier}
    Click On  text=Policies
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${policy}
    Click On  text=Cards
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${card_override}
    Click On  text=Overrides
    Click On  //*[@id="btnEditProductLimits"]
    Check Element Exists  text=GAS  timeout=20
    Click On  text=CANCEL
    Click On  text=Remove Override

    Get Into DB  TCH
    ${query}  catenate  SELECT cardoverride FROM cards WHERE card_num='${card_override}'
    ${results}  Query And Strip  ${query}

    Should Be Equal As Numbers  ${results}  0

    [Teardown]  Run Keywords  Execute SQL String  dml=UPDATE member_meta SET mm_value = '${storage["mm_value"]}' WHERE member_meta_id = ${storage["member_meta_id"]}
    ...   AND  Close Browser
    ...   AND  Disconnect From DataBase

Override Card With Multiple Swipes and All Options Checked.
    [Tags]  JIRA:BOT-1348  JIRA:BOT-1349   qTest:32778701  qTest:30783091  Regression
    [Documentation]  Override Card With Multiple Swipes and All Options Checked, Validate on Database then Remove Override.
    [Setup]  Get Into DB  TCH
    #Test Variables
    ${card}  Set Variable  7083050910386622557
    ${swipesAmount}  Generate Random String  1  [NUMBERS]
    ${product}  Set Variable  AMDS
    ${productLimit}  Generate Random String  3  [NUMBERS]
    ${overrideRefreshingLimitAmount}  Generate Random String  2  [NUMBERS]
    ${productSource}  Set Variable  Both  #Could be Card, Policy or Both

    #Test Steps
    Open Account Manager
    Search For Card  EFS LLC  ${card}
    Select Overrides on Card Detail
    Select Card Swipes Amount For Card Override  ${swipesAmount}
    Select Override All Merchants For Card Override
    Select Hand Entry For Card Override
    Select Product/Limit for Card Override  ${product}  ${productLimit}
    Select Refreshing Limits for Card Override  ${overrideRefreshingLimitAmount}
    Select Product Source for Card Override  ${productSource}
    Submit Form for Card Override
    Validate if Card is Overridden  ${card}  ${swipesAmount}
    Compare Card Product Limits for Override Card  ${card}  ${product}  ${productLimit}
    Compare Card Refreshing Limits Info for Override Card  ${card}  ${overrideRefreshingLimitAmount}  ${productSource}
    Remove Card Override From Card Detail

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Remove Card Override  ${card}

*** Keywords ***
Tear Me Down
    Disconnect From Database

Search For Card
    [Arguments]  ${partner}  ${card_num}
    Wait Until Element is Enabled  //a[@id='Card']
    Click on  //a[@id='Card']
    Wait Until Element Is Visible  name=cardNumber
    Refresh Page
    Wait Until Element Is Visible  name=businessPartnerCode
    Select From List By Label  businessPartnerCode  ${partner}
    Wait Until Element is Enabled  //input[@name='cardNumber']  timeout=35
    Input Text  name=cardNumber  ${card_num}
    double click on  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0  timeout=35
    Wait Until Element is Visible  //button[text()='${card_num}']  timeout=35
    Set Focus To Element  //button[text()='${card_num}']
    click on  //button[text()='${card_num}']
    Wait Until Element Is Enabled  id=submit  timeout=35

Select Overrides on Card Detail
    Wait Until Element is Enabled  //a[@id='Overrides']
    Click on  //a[@id='Overrides']

Validate if Card is Overridden
    [Arguments]  ${card}  ${overrideAmount}

    Wait Until Element is Enabled  //button[text()='Remove Override']  timeout=35
    ${query}  Catenate  SELECT * FROM cards WHERE card_num='${card}' AND cardoverride='${overrideAmount}'
    Row Count is Equal to X  ${query}  1

Compare Card Product Limits for Override Card
    [Arguments]  ${card}  ${product}  ${productLimit}

    ${query}  Catenate  SELECT * FROM card_lmt
    ...  WHERE card_num='${card}OVER'
    ...  AND limit_id='${product}'
    ...  AND limit='${productLimit}'
    Row Count is Equal to X  ${query}  1

Compare Card Refreshing Limits Info for Override Card
    [Arguments]  ${card}  ${overrideRefreshingLimitAmount}  ${productSource}

    ${productSource}  Set Variable if  '${productSource}'=='Both'  B  ${productSource}
    ${productSource}  Set Variable if  '${productSource}'=='Card'  C  ${productSource}
    ${productSource}  Set Variable if  '${productSource}'=='Policy'  D  ${productSource}

    ${query}  Catenate  SELECT *
    ...  FROM cards
    ...  WHERE card_num='${card}OVER'
    ...  AND  handenter='Y'
    ...  AND  lmtsrc='${productSource}'
    ...  AND  day_cnt_limit='${overrideRefreshingLimitAmount}'
    ...  AND  day_amt_limit='${overrideRefreshingLimitAmount}'
    ...  AND  week_cnt_limit='${overrideRefreshingLimitAmount}'
    ...  AND  week_amt_limit='${overrideRefreshingLimitAmount}'
    ...  AND  mon_cnt_limit='${overrideRefreshingLimitAmount}'
    ...  AND  mon_amt_limit='${overrideRefreshingLimitAmount}'
    Row Count is Equal to X  ${query}  1

Remove Card Override From Card Detail
    Wait Until Element is Enabled  //button[text()='Remove Override']  timeout=35
    Click Element  //button[text()='Remove Override']

Select Card Swipes Amount For Card Override
    [Arguments]  ${swipesAmount}
    Wait Until Element Is Visible  detailRecord.promptSource  timeout=35
    Wait Until Element Is Enabled  overridesSummary.cardSwipes  timeout=35
    Select From List By Value  overridesSummary.cardSwipes  ${swipesAmount}

Select Override All Merchants For Card Override
    Select Checkbox  overridesSummary.overrideAllMerchants

Select Hand Entry For Card Override
    Select Checkbox  overridesSummary.allowHandEntry

Select Product/Limit for Card Override
    [Arguments]  ${product}  ${productLimit}
    Select Checkbox  overridesSummary.allowProductLimitOverride
    Click Element  btnEditProductLimits
    Wait Until Element Is Enabled  tblProductLimits  timeout=35
    Select Checkbox  //table[@id='tblProductLimits']//input[@data-product-code='${product}']
    Sleep  2
    Run Keyword And Return Status  Click Element  //td[@id='overrideProductGroupFormButtons']//button[@id='submit']
    ${product_locator_input}  Set Variable  //input[@data-product-code='${product}']/parent::td/parent::tr/td/input[@type='text']
    Execute Javascript  document.evaluate("${product_locator_input}", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue.value = ${productLimit};
    Click Element  //td[@id='overrideProductLimitsFormButtons']//button[@id='submit']

Select Refreshing Limits for Card Override
    [Arguments]  ${overrideRefreshingLimitAmount}
    Wait Until Element is Visible  overridesSummary.refreshingLimitsOverride  timeout=35
    Select Checkbox  overridesSummary.refreshingLimitsOverride
    Wait Until Element is Visible  overridesSummary.dailyCountOverride  timeout=35
    Input Text  overridesSummary.dailyCountOverride  ${overrideRefreshingLimitAmount}
    Input Text  overridesSummary.dailyAmountOverride  ${overrideRefreshingLimitAmount}
    Input Text  overridesSummary.weeklyCountOverride  ${overrideRefreshingLimitAmount}
    Input Text  overridesSummary.weeklyAmountOverride  ${overrideRefreshingLimitAmount}
    Input Text  overridesSummary.monthlyCountOverride  ${overrideRefreshingLimitAmount}
    Input Text  overridesSummary.monthlyAmountOverride  ${overrideRefreshingLimitAmount}
    Click Element  //td[@id='overrideRefreshingLimitsFormButtons']//button[@id='submit']

Select Product Source for Card Override
    [Arguments]  ${productSource}
    [Documentation]  Product Source options are Card, Policy and Both.
    Wait Until Element is Visible  overridesSummary.productSource  timeout=35
    Select From List By Label  overridesSummary.productSource  ${productSource}

Submit Form for Card Override
    Click Element  //td[@id='overridesFormButtons']//button[@id='submit']

Remove Card Override
    [Arguments]  ${card}
    ${query}  Catenate  SELECT cardoverride FROM cards WHERE card_num='${card}'
    ${overrideCount}  Query and Strip  ${query}
    Run Keyword if  '${overrideCount}'!='0'
    ...  Execute SQL String  dml=UPDATE cards SET cardoverride='0' WHERE card_num='${card}'