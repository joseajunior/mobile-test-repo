*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.Models
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  Integration  Shifty
Suite Setup  Time to Setup
Suite Teardown  Close Browser

*** Test Cases ***
Add Auto Roll Card Limit
    [Documentation]
    ...  | Set ULSD to Auto Roll on card level.

    [Tags]  TCH Instance  JIRA:BOT-1533  qTest:32038886  Regression  qTest:30739039
    [Setup]  Set Product Level Limits Flag  ${efs_fleet_card.carrier.id}  N

    Go to Card  ${efs_fleet_card.num}
    Add Limit  ULSD  refresh  ${True}
    Verify Limit was Added  CARD  ULSD

    [Teardown]  Run keywords  Go Back To Carrier  ${efs_fleet_card.carrier.id}
    ...         AND  Clear Card Limits

Delete Card Limit
    [Tags]  run
    [Setup]  Run Keywords  Set Product Level Limits Flag  ${efs_fleet_card.carrier.id}  N
    ...      AND  Start Setup Card  ${efs_fleet_card.num}
    ...      AND  Setup Card Header  status=ACTIVE  infoSource=CARD  limitSource=CARD
    ...      AND  Setup Card Limits  ULSD=500
    ...      AND  Sleep  5

    Go to Card  ${efs_fleet_card.num}
    Delete Limit  ULSD
    Verify Limit was Deleted  CARD  ULSD

    [Teardown]  Run keywords  Go Back To Carrier  ${efs_fleet_card.carrier.id}
    ...         AND  Clear Card Limits

Add Auto Roll Policy Limit
    [Documentation]
    ...  | Set ULSD to Auto Roll on policy level.

    [Tags]  TCH Instance  JIRA:BOT-1542  qTest:31986785  Regression  qTest:31247315
    [Setup]  run keywords  Set Product Level Limits Flag  ${efs_fleet_card.carrier.id}  N
    ...  AND  Clear Policy Limits
    Go to policy  ${policy}
    Add Limit  ULSD  refresh  ${True}
    Verify Limit was Added  POLICY  ULSD

    [Teardown]  Go Back To Carrier  ${efs_fleet_card.carrier.id}

Delete Policy Limit
    [Tags]  refactor
    [Setup]  run keywords  Set Product Level Limits Flag  ${efs_fleet_card.carrier.id}  N
    ...      AND  setup policy limits  ULSD=500
    Go to policy  ${policy}
    Delete Limit  ULSD
    Verify Limit was Deleted  POLICY  ULSD

    [Teardown]  run keywords  Go Back To Carrier  ${efs_fleet_card.carrier.id}
    ...  AND  clear policy limits

#
#Add A Prompt
#Delete A Prompt
*** Keywords ***
Time to Setup

    Get Into DB  TCH
    Set Global Variable  ${policy}  ${efs_fleet_card.policy.num}
    ${originalProductLevelLimitsFlag}=  Get Product Level Limits Flag  ${efs_fleet_card.carrier.id}
    Set Suite Variable  ${originalProductLevelLimitsFlag}

    Start Setup Card  ${efs_fleet_card.num}
    Clear Card Limits
    Start Setup Policy  ${efs_fleet_card.carrier.id}  ${policy}
    Clear Policy Limits

    Open Account Manager
    Search a carrier in Account Manager  EFS  ${efs_fleet_card.carrier.id}

Get Product Level Limits Flag
    [Arguments]  ${carrier_id}
    ${original}=  query and strip  SELECT mm_value FROM member_meta WHERE member_id = ${efs_fleet_card.carrier.id} AND member_meta.mm_key = 'PRODLMTS'
    [Return]  ${original}

Select Refreshing Days
    [Arguments]  @{days}

    ${len}=  get length  ${days}
    @{days}=  run keyword if  ${len} < 1  create list  SUN  MON  TUE  WED  THU  FRI  SAT  ELSE  create list  @{days}

    FOR  ${i}  IN  @{days}
        select checkbox  //*[@value="${i}"]
    END

Set Product Level Limits Flag
    [Arguments]  ${carrier_id}  ${flag}
    execute sql string   dml=UPDATE member_meta SET mm_value = '${flag}' WHERE member_id = ${efs_fleet_card.carrier.id} AND member_meta.mm_key = 'PRODLMTS'


Go to Card
    [Arguments]  ${card}
    ${onCustomer}=  Url Shows  acct-mgmt/Customer.action
    run keyword if  not ${onCustomer}  search a carrier in account manager  EFS  ${efs_fleet_card.carrier.id}

    Click Secondary Tab By Text  Cards
    Wait Until Loading Spinners Are Gone
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep  1
    Input Text  cardNumber  ${card}
    Click Search Section Submit
    Wait Until Loading Spinners Are Gone
    Scroll Element Into View  //*[text()='${card}']
    Click Search Section Button (or text that looks like a link that is a button) by Text  ${card}
    Wait Until Loading Spinners Are Gone

    ${onCardScreen}  Url Shows  /acct-mgmt/Card.action
    Run Keyword If  not ${onCardScreen}  fail  Policy Screen Did Not Load After Clicking Policy: ${card}

Go to policy
    [Arguments]  ${policy}

    ${onCustomer}=  Url Shows  acct-mgmt/Customer.action
    run keyword if  not ${onCustomer}  search a carrier in account manager  ${efs_fleet_card.carrier.id}

    Click Secondary Tab By Text  Policies
    Click Search Section Submit
    scroll element into view  //button[text()='${policy}']
    Click Search Section Button (or text that looks like a link that is a button) by Text  ${policy}
    wait until loading spinners are gone
    ${onPolicyScreen}  Url Shows  /acct-mgmt/Policy.action

    run keyword if  not ${onPolicyScreen}  fail  Policy Screen Did Not Load After Clicking Policy: ${policy}

Click On Products
    click element  xpath=//*[text()="Products"]
    wait until loading spinners are gone

Add Limit
    [Arguments]  ${LIMIT}  ${type}  ${new}=${False}  @{days}
    Click On Products
    Click Search Section Submit

    run keyword if  ${new}  click search section button (or text that looks like a link that is a button) by text  ADD  span
    run keyword if  ${new}  wait until loading spinners are gone
    run keyword if  ${new}  Wait Until Mini Loading Spinners Are Gone
    run keyword if  ${new}  select from list by value  productSummary.productCode  ${LIMIT.upper()}
    ${desc}=  run keyword unless  ${new}  query and strip  select description from products where fps_partner = 'TCH' and abbrev = '${LIMIT.upper()}'
    run keyword unless  ${new}  click search section button (or text that looks like a link that is a button) by text  ${description.upper()}
    run keyword unless  ${new}  wait until loading spinners are gone

    wait until element is enabled  productSummary.quantity  30
    input text  productSummary.quantity  500
    wait until element is enabled  productSummary.type  30
    select from list by value  productSummary.type  ${type.upper()}

    run keyword if  '${type.lower()}'=='window'  input text  productSummary.timeWindow  24
    ...  ELSE  Select Refreshing Days  @{days}
    click element  //div[contains(@id,"ProductsAddUpdateActionFormContainer")]//*[contains(text(),"Submit")]
    wait until element is not visible  //div[contains(@id,"ProductsAddUpdateActionFormContainer")]  timeout=60  error=Product Didn't Successully Add within 60 Secs
    wait until loading spinners are gone
    Check Add Successful

Get Limit Details
    [Arguments]  ${src}  ${limit}
    ${cardLimitSql}=  assign string  select limit,hours,minhours,day_of_week,hour_of_day,day_of_month,daily_max from card_lmt where card_num = '${efs_fleet_card.num}' and limit_id = '${limit}'
    ${polLimitSql}=  assign string  select limit,hours,minhours,day_of_week,hour_of_day,day_of_month,daily_max from def_lmts where carrier_id = ${efs_fleet_card.carrier.id} and ipolicy = ${policy} and limit_id = '${limit}'

    ${ispolicy}=  evaluate  '${src}' == 'POLICY'
    ${limits}=  run keyword if  ${ispolicy}  query and return dictionary rows  ${polLimitSql}  ELSE  query and return dictionary rows  ${cardLimitSql}
#    tch logging  ${src} limits: ${limits}

    [Return]  ${limits}

Verify Limit was Added
    [Arguments]  ${src}  ${limit}

    ${limits}  get limit details  ${src}  ${limit}

    ${rowCount}  get length  ${limits}
    should be equal as numbers  ${rowCount}  1  msg=Limit row was not inserted into ${src}  values=${False}

Verify Limit was Deleted
    [Arguments]  ${src}  ${limit}

    ${limits}  get limit details  ${src}  ${limit}

    ${rowCount}  get length  ${limits}
    should be equal as numbers  ${rowCount}  0  msg=Limit row was not removed from ${src}  values=${False}

Delete Limit
    [Arguments]  ${limitId}

    Click On Products
    Click Search Section Submit
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Select Checkbox  //input[@type="checkbox" and (@value="${limitId}" or @productcode="${limitId}")]
    click search section button (or text that looks like a link that is a button) by text  DELETE  span
    click element  //div[contains(@id,"ProductsDeleteDialogContainer")]//button[contains(text(),'Confirm')]

    wait until element is not visible  //div[contains(@id,"ProductsDeleteDialogContainer")]  timeout=60  error=Product Didn't Successully Delete within 60 Secs
    wait until loading spinners are gone
    Check Delete Successful

Go Back To Carrier
    [Arguments]  ${carrier}
    ${stat}  Run Keyword And Return Status  click element  //button[contains(text(),'${carrier}']
    Run Keyword Unless  ${stat}  search a carrier in account manager  EFS  ${efs_fleet_card.carrier.id}

Check Delete Successful
    Wait Until Element Is Visible  //ul[contains(@class,"msgSuccess")]//li[contains(text(),"Delete Successful")]  timeout=25  error=Delete Successful message did not show within 25 secs

Check Add Successful
    Wait Until Element Is Visible  //ul[contains(@class,"msgSuccess")]//li[contains(text(),"Add Successful")]  timeout=25  error=Add Successful message did not show within 25 secs
