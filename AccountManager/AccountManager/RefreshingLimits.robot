*** Settings ***
Documentation  Tests every possible combination of policy and card limits given the limit source.
...  No preauthorization is ran to validate. Rather only database checks verify that the limits
...  updated on the card through Account Manager are correctly saved in the database.

Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM  Card
Suite Setup  Setup and Connect
Suite Teardown  Disconnect

*** Test Cases ***
Assert Refreshing Limits - Product Source CARD
    [Tags]  JIRA:BOT-1346  qTest:32283687  Regression  refactor
    [Setup]  Save Backup

    Start Setup Card  ${validCard.num}
    Setup Card Header  lmtSrc=CARD  velsrc=CARD
    Setup Card Contract  velocity_enabled=Y

    Open Account Manager
    Search For A Card  ${validCard.num}
    Select Product Source  Card
    Go to Refreshing Limits Sub Menu
    Fill Refreshing Limits And Save
    Wait Until Page Contains  text=Add Successful  timeout=60
    ${db_card_refreshing_limits}  Get Card Status And Refreshing Limits From DB  ${validCard.num}
    Assert Refreshing Limits on DB  ${db_card_refreshing_limits}  Card
    Assert Product Source   ${db_card_refreshing_limits}  Card

    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  setCardRefreshingLimits  ${validCard.num}  ${card_lmtsrc}

Assert Refreshing Limits - Product Source POLICY
    [Tags]  JIRA:BOT-1346  qTest:32283687  Regression  qTest:31355138  refactor
    [Setup]  Save Backup

    Start Setup Card  ${validCard.num}
    Setup Card Header  velsrc=CARD
    Setup Card Contract  velocity_enabled=Y

    Open Account Manager
    Search For A Card  ${validCard.num}
    Select Product Source  Policy
    Go to Refreshing Limits Sub Menu
    Fill Refreshing Limits And Save
    Wait Until Page Contains  text=Add Successful  timeout=60
    ${db_card_refreshing_limits}  Get Card Status And Refreshing Limits From DB  ${validCard.num}
    Assert Refreshing Limits on DB  ${db_card_refreshing_limits}  Policy
    Assert Product Source   ${db_card_refreshing_limits}  Policy

    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  setCardRefreshingLimits  ${validCard.num}  ${card_lmtsrc}

Assert Refreshing Limits - Product Source BOTH
    [Tags]  JIRA:BOT-1346  qTest:32286624  Regression  refactor
    [Setup]  Save Backup

    Start Setup Card  ${validCard.card_num}
    Setup Card Header  velsrc=CARD
    Setup Card Contract  velocity_enabled=Y

    Open Emanager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search For A Card  ${validCard.num}
    Select Product Source  Both
    Go to Refreshing Limits Sub Menu
    Fill Refreshing Limits And Save
    Wait Until Page Contains  text=Add Successful  timeout=60
    ${db_card_refreshing_limits}  Get Card Status And Refreshing Limits From DB  ${validCard.num}
    Assert Refreshing Limits on DB  ${db_card_refreshing_limits}  Both
    Assert Product Source   ${db_card_refreshing_limits}  Both

    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  setCardRefreshingLimits  ${validCard.num}  ${card_lmtsrc}

Assert Refreshing Limits - Refreshing Limits Source CARD
    [Tags]  JIRA:BOT-1539  qTest:32555545  Regression  refactor
    [Setup]  Save Backup

    Start Setup Card  ${validCard.num}
    Setup Card Header  velsrc=CARD
    Setup Card Contract  velocity_enabled=Y

    Open Account Manager
    Search For A Card  ${validCard.num}
    Select Refreshing Limits Source  Card
    Go to Refreshing Limits Sub Menu
    Fill Refreshing Limits And Save
    Wait Until Page Contains  text=Add Successful  timeout=60
    ${db_card_refreshing_limits}  Get Card Status And Refreshing Limits From DB  ${validCard.num}
    Assert Refreshing Limits on DB  ${db_card_refreshing_limits}  Card
    Assert Refreshing Limits Source   ${db_card_refreshing_limits}  Card

    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  setCardRefreshingLimits  ${validCard.num}  ${card_lmtsrc}

Assert Refreshing Limits - Refreshing Limits Source POLICY
    [Tags]  JIRA:BOT-1539  qTest:32555553  Regression  refactor
    [Setup]  Run Keywords
    ...      Save Backup
    ...      AND  Setup Policy Refreshing Limits

    Start Setup Card  ${validCard.num}
    Setup Card Header  velsrc=CARD
    Setup Card Contract  velocity_enabled=Y


    Open Account Manager
    Search For A Card  ${validCard.num}
    Select Refreshing Limits Source  Policy
    Go to Refreshing Limits Sub Menu
    Ensure Refreshing Limits Are Not Enabled
    ${db_card_refreshing_limits}  Get Card Status And Refreshing Limits From DB  ${validCard.num}
    Assert Refreshing Limits Source   ${db_card_refreshing_limits}  Policy

    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  setPolicyRefreshingLimits  ${policy}

Refreshing Limits - Update All Fields (Policies)
    [Tags]  JIRA:BOT-1375  qTest:32556331  Regression  refactor

    Open Account Manager
    Search For A Policy
    ${chosen_policy}  Go to Policies Sub Menu
    Click On  text=Refreshing Limits
    Fill Refreshing Limits And Save
    Wait Until Page Contains  text=Edit Successful  timeout=60
    ${db_card_refreshing_limits}  Get Policy Refreshing Limits From DB  ${chosen_policy}

    Should Be Equal As Numbers  ${db_card_refreshing_limits['day_cnt_limit']}  ${daily_count}
    Should Be Equal As Numbers  ${db_card_refreshing_limits['day_amt_limit']}  ${daily_amount}
    Should Be Equal As Numbers  ${db_card_refreshing_limits['week_cnt_limit']}  ${weekly_count}
    Should Be Equal As Numbers  ${db_card_refreshing_limits['week_amt_limit']}  ${weekly_amount}
    Should Be Equal As Numbers  ${db_card_refreshing_limits['mon_cnt_limit']}  ${monthly_count}
    Should Be Equal As Numbers  ${db_card_refreshing_limits['mon_amt_limit']}  ${monthly_amount}

    [Teardown]  Run Keywords  setPolicyRefreshingLimits  ${chosen_policy}
    ...         AND  Close Browser
    ...         AND  Disconnect From Database

Refreshing Limits - All Limits Appears According To Policy Source
    [Tags]  JIRA:BOT-1375  qTest:32556369  Regression  refactor
    start setup card  ${validCard.num}
    setup card contract  velocity_enabled=Y

    Open Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${validCard.carrier.id}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${validCard.carrier.id}
    Click On  text=Policies
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${validCard.policy.num}
    Click On  text=Refreshing Limits

    Wait Until Element Is Visible  //*[@id="policyRefreshLimitsActionForm"]//*[@name="refreshLimits.dailyCount"]  timeout=20
    ${daily_count}  Get Value  //*[@id="policyRefreshLimitsActionForm"]//*[@name="refreshLimits.dailyCount"]
    ${daily_amt}  Get Value  //*[@id="policyRefreshLimitsActionForm"]//*[@name="refreshLimits.dailyAmount"]
    ${weekly_count}  Get Value  //*[@id="policyRefreshLimitsActionForm"]//*[@name="refreshLimits.weeklyCount"]
    ${weekly_amt}  Get Value  //*[@id="policyRefreshLimitsActionForm"]//*[@name="refreshLimits.weeklyAmount"]
    ${monthly_count}  Get Value  //*[@id="policyRefreshLimitsActionForm"]//*[@name="refreshLimits.monthlyCount"]
    ${monthly_amt}  Get Value  //*[@id="policyRefreshLimitsActionForm"]//*[@name="refreshLimits.monthlyAmount"]

    ${db_policy_refreshing_limits}  Get Policy Refreshing Limits From DB  ${validCard.policy.num}

    Should Be Equal As Numbers  ${db_policy_refreshing_limits['day_cnt_limit']}  ${daily_count}
    Should Be Equal As Numbers  ${db_policy_refreshing_limits['day_amt_limit']}  ${daily_amt}
    Should Be Equal As Numbers  ${db_policy_refreshing_limits['week_cnt_limit']}  ${weekly_count}
    Should Be Equal As Numbers  ${db_policy_refreshing_limits['week_amt_limit']}  ${weekly_amt}
    Should Be Equal As Numbers  ${db_policy_refreshing_limits['mon_cnt_limit']}  ${monthly_count}
    Should Be Equal As Numbers  ${db_policy_refreshing_limits['mon_amt_limit']}  ${monthly_amt}

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database


*** Keywords ***
Setup and Connect
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Selenium Timeout  60

Save Backup
    ${card_lmtsrc}  Query And Strip To Dictionary  SELECT lmtsrc FROM cards WHERE card_num = '${validCard.num}'
    Set Test Variable  ${card_lmtsrc}  ${card_lmtsrc}

Setup Policy Refreshing Limits
    ${daily_count}  ${daily_amount}  Generate Refreshing Limits Count and Amount
    ${weekly_count}  ${weekly_amount}  Generate Refreshing Limits Count and Amount
    ${monthly_count}  ${monthly_amount}  Generate Refreshing Limits Count and Amount
    ${policy}  Query And Strip  SELECT icardpolicy FROM cards WHERE card_num = '${validCard.num}'
    setPolicyRefreshingLimits  ${policy}  ${daily_count}  ${daily_amount}  ${weekly_count}  ${weekly_amount}  ${monthly_count}  ${monthly_amount}
    Set Test Variable  ${policy}  ${policy}
    Set Test Variable  ${daily_count}  ${daily_count}
    Set Test Variable  ${daily_amount}  ${daily_amount}
    Set Test Variable  ${weekly_count}  ${weekly_count}
    Set Test Variable  ${weekly_amount}  ${weekly_amount}
    Set Test Variable  ${monthly_count}  ${monthly_count}
    Set Test Variable  ${monthly_amount}  ${monthly_amount}

Disconnect
    Disconnect From Database
    logout

Navigate To Account Manager
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Search For A Card
    [Arguments]  ${card_num}
    Wait Until Element is Enabled  //a[@id='Card']
    Click on  //a[@id='Card']
    Wait Until Element Is Visible  name=cardNumber
    refresh page
    Wait Until Element Is Visible  name=businessPartnerCode
    Select From List By Value  businessPartnerCode  EFS
    Wait Until Element is Enabled  //input[@name='cardNumber']
    Input Text  name=cardNumber  ${card_num}
    double click on  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0
    Wait Until Element is Visible  //button[text()='${card_num}']
    Set Focus To Element  //button[text()='${card_num}']
    click on  //button[text()='${card_num}']
    Wait Until Element Is Enabled  id=submit

Search For A Policy
    Wait Until Element is Enabled  //a[@id='Customer']
    Click on  //a[@id='Customer']
    Wait Until Element Is Visible  name=id
    refresh page
    Wait Until Element Is Visible  name=businessPartnerCode
    Select From List By Value  businessPartnerCode  EFS
    Wait Until Element is Enabled  //input[@name='id']
    Input Text  name=id  ${validCard.carrier.id}
    double click on  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0
    Wait Until Element is Visible  //button[text()='${validCard.carrier.id}']
    Set Focus To Element  //button[text()='${validCard.carrier.id}']
    click on  //button[text()='${validCard.carrier.id}']
    Wait Until Element Is Enabled  id=submit

Select Product Source
    [Arguments]  ${prod_src}
    Wait Until Element is Visible  detailRecord.productSource
    Select From List By Value  detailRecord.productSource  ${prod_src.upper()}
    Click Element  submit

Select Refreshing Limits Source
    [Arguments]  ${prod_src}
    Wait Until Element is Visible  detailRecord.refreshLimitsSource
    Select From List By Value  detailRecord.refreshLimitsSource  ${prod_src.upper()}
    Click Element  submit

Go to Refreshing Limits Sub Menu
    Wait Until Element is Visible  detailRecord.productSource
    Wait Until Element is Visible  //a[@id='RefreshLimits']
    Click Element  //a[@id='RefreshLimits']
    Execute JavaScript  window.scrollTo(2000,0)

Go to Policies Sub Menu
    Click Element  //span[text()='Policies']
    Wait Until Element is Visible  //div[@id='customerPoliciesSearchContainer']//button[@class='button searchSubmit']
    Click Element  //div[@id='customerPoliciesSearchContainer']//button[@class='button searchSubmit']
    wait until loading spinners are gone
    Wait Until Element is Visible  //table[@id='DataTables_Table_0']//tr[1]//button
    ${policy}  Get Text   //table[@id='DataTables_Table_0']//tr[1]//button
    Set Focus To Element  //table[@id='DataTables_Table_0']//tr[1]//button
    click on  //table[@id='DataTables_Table_0']//tr[1]//button
    [Return]  ${policy}

Ensure Refreshing Limits Are Not Enabled
    Sleep  10
    Wait Until Element Is Visible  refreshLimits.dailyCount
    Element Should Be Disabled  refreshLimits.dailyCount
    Element Should Be Disabled  refreshLimits.dailyAmount
    Element Should Be Disabled  refreshLimits.weeklyCount
    Element Should Be Disabled  refreshLimits.weeklyAmount
    Element Should Be Disabled  refreshLimits.monthlyCount
    Element Should Be Disabled  refreshLimits.monthlyAmount

Fill Refreshing Limits And Save
    Sleep  10
    ${daily_count}  ${daily_amount}  Fill Reshing Input  refreshLimits.dailyCount  refreshLimits.dailyAmount
    ${weekly_count}  ${weekly_amount}  Fill Reshing Input  refreshLimits.weeklyCount  refreshLimits.weeklyAmount
    ${monthly_count}  ${monthly_amount}  Fill Reshing Input  refreshLimits.monthlyCount  refreshLimits.monthlyAmount
    Click Element  //input[@name='refreshLimits.dailyCount']/parent::td/parent::tr/parent::tbody/parent::table/parent::td/parent::tr/parent::tbody//button[@id='submit']
    Set Test Variable  ${daily_count}  ${daily_count}
    Set Test Variable  ${daily_amount}  ${daily_amount}
    Set Test Variable  ${weekly_count}  ${weekly_count}
    Set Test Variable  ${weekly_amount}  ${weekly_amount}
    Set Test Variable  ${monthly_count}  ${monthly_count}
    Set Test Variable  ${monthly_amount}  ${monthly_amount}


    Sleep  10

Fill Reshing Input
    [Arguments]  ${count_locator}  ${amount_locator}
    ${count}  ${amount}  Generate Refreshing Limits Count and Amount
#    tch logging  ${count_locator}:${count}
#    tch logging  ${amount_locator}:${amount}
    Wait Until Element is Enabled  ${count_locator}
    Input Text  ${count_locator}  ${count}
    Input Text  ${amount_locator}  ${amount}
    [Return]  ${count}  ${amount}

Generate Refreshing Limits Count and Amount
#   I'M USING 123456789 BECAUSE WHEN SETTING JUST [NUMBERS] SOMETIMES IT WAS GENERATING 00 AND ACCT MNGR DOESNT ACCEPT THAT FOR REFRESHING LIMITS

    ${count}  Generate Random String  2  123456789
    ${amount}  Generate Random String  2  123456789

    [Return]  ${count}  ${amount}

Assert Sucess Message
    [Arguments]  ${message}
    Wait Until Element Is Visible  //ul[@class='msgSuccess']//li[text()='${message}']

Assert Refreshing Limits on DB
    [Arguments]  ${card_refreshing_limits}  ${prod_src}
    ${prod_src}  Get DB Flag  ${prod_src}
    Should Be Equal As Numbers  ${card_refreshing_limits['day_cnt_limit']}  ${daily_count}
    Should Be Equal As Numbers  ${card_refreshing_limits['day_amt_limit']}  ${daily_amount}
    Should Be Equal As Numbers  ${card_refreshing_limits['week_cnt_limit']}  ${weekly_count}
    Should Be Equal As Numbers  ${card_refreshing_limits['week_amt_limit']}  ${weekly_amount}
    Should Be Equal As Numbers  ${card_refreshing_limits['mon_cnt_limit']}  ${monthly_count}
    Should Be Equal As Numbers  ${card_refreshing_limits['mon_amt_limit']}  ${monthly_amount}

Assert Product Source
    [Arguments]  ${card_refreshing_limits}  ${prod_src}
    ${prod_src}  Get DB Flag  ${prod_src}
    Should Be Equal As Strings  ${card_refreshing_limits['lmtsrc']}  ${prod_src}

Assert Refreshing Limits Source
    [Arguments]  ${card_refreshing_limits}  ${prod_src}
    ${prod_src}  Get DB Flag  ${prod_src}
    Should Be Equal As Strings  ${card_refreshing_limits['velsrc']}  ${prod_src}

Get DB Flag
    [Arguments]  ${src}
    ${src}  Set Variable If  '${src}'=='Card'  C  ${src}
    ${src}  Set Variable If  '${src}'=='Policy'  D  ${src}
    ${src}  Set Variable If  '${src}'=='Both'  B  ${src}
    [Return]  ${src}

Get Card Status And Refreshing Limits From DB
    [Arguments]  ${card_num}
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT  c.day_cnt_limit,
    ...          c.day_amt_limit,
    ...          c.week_cnt_limit,
    ...          c.week_amt_limit,
    ...          c.mon_cnt_limit,
    ...          c.mon_amt_limit,
    ...          c.lmtsrc,
    ...          c.velsrc
    ...  FROM cards c
    ...  WHERE c.card_num = '${card_num}'
    ${output}  Query And Strip To Dictionary   ${query}
    [Return]  ${output}

Get Policy Refreshing Limits From DB
    [Arguments]  ${policy}
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT dc.day_cnt_limit,
    ...         dc.day_amt_limit,
    ...         dc.week_cnt_limit,
    ...         dc.week_amt_limit,
    ...         dc.mon_cnt_limit,
    ...         dc.mon_amt_limit
    ...  FROM def_card dc
    ...  WHERE dc.id = ${validCard.carrier.id}
    ...  AND ipolicy = ${policy}
    ${output}  Query And Strip To Dictionary   ${query}
    [Return]  ${output}