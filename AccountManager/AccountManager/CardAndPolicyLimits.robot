*** Settings ***
Documentation  Tests every possible combination of policy and card limits given the limit source.
...  No preauthorization is ran to validate. Rather only database checks verify that the limits
...  updated on the card through Account Manager are correctly saved in the database.

Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot


Suite Setup  Time to Setup
Suite Teardown  Tear Down Limit Testing

Force Tags  AM  Card Detail  refactor

*** Variables ***
${originalProductLevelLimitsFlag}
${policy}

*** Test Cases ***
Set Card Limit Source To Card
    [Tags]  TCH Instance  JIRA:BOT-1530  qTest:32808751  Regression

    Go to Card  ${validCard.num}
    Set Limit Source  Card
    Validate Card Source  ${validCard.num}  Card
    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Set Card Limit Source To BOTH
    [Tags]  TCH Instance  JIRA:BOT-1530  qTest:32808751  Regression

    Go to Card  ${validCard.num}
    Set Limit Source  Both
    Validate Card Source  ${validCard.num}  Both
    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Set Card Limit Source To Policy
    [Tags]  TCH Instance  JIRA:BOT-1530  qTest:32808751  Regression

    Go to Card  ${validCard.num}
    Set Limit Source  Policy
    Validate Card Source  ${validCard.num}  Policy
    [Teardown]  RUN KEYWORDS  Go Back To Carrier  ${validCard.carrier.id}
    ...  AND  setup card header  limitSource=CARD

Add Auto Roll Card Limit
    [Documentation]
    ...  | Set ULSD to Auto Roll on card level.

    [Tags]  TCH Instance  JIRA:BOT-1533  qTest:32038886  Regression  qTest:30739039
    [Setup]  Set Product Level Limits Flag  ${validCard.carrier.id}  N

    Go to Card  ${validCard.num}
    Add Limit  ULSD  refresh  ${True}
    Verify Limit was Added  CARD  ULSD

    [Teardown]  Run keywords  Go Back To Carrier  ${validCard.carrier.id}
    ...         AND  clear card limits

Set Hourly Card Limit
    [Documentation]
    ...  | Set ULSD to Hourly on card level.

    [Tags]  TCH Instance  JIRA:BOT-1532  JIRA:BOT-1534  qTest:32040502  Regression  qTest:30782508
    [Setup]  Set Product Level Limits Flag  ${validCard.carrier.id}  N

    Go to Card  ${validCard.num}
    Add Limit  ULSD  window  ${True}
    Verify Limit was Added  CARD  ULSD

    [Teardown]  Run keywords  Go Back To Carrier  ${validCard.carrier.id}
    ...         AND  clear card limits

Edit Card Auto Roll Limit
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...      AND  setup card limits  ULSD=500

    Go to Card  ${validCard.num}
    ${original}  ${editedTo}  Edit Limit  ULSD
    Verify Limit was Edited  CARD  ULSD  ${editedTo}

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Edit Card Hourly Limit
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...      AND  setup card limits  ULSD=500

    Go to Card  ${validCard.num}
    ${original}  ${editedTo}  Edit Limit  ULSD
    Verify Limit was Edited  CARD  ULSD  ${editedTo}

    [Teardown]  Run keywords  Go Back To Carrier  ${validCard.carrier.id}
    ...         AND  clear card limits

Delete Card Limit
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...      AND  setup card limits  ULSD=500

    Go to Card  ${validCard.num}
    Delete Limit  ULSD
    Verify Limit was Deleted  CARD  ULSD

    [Teardown]  Run keywords  Go Back To Carrier  ${validCard.carrier.id}
    ...         AND  clear card limits

Add Auto Roll Policy Limit
    [Documentation]
    ...  | Set ULSD to Auto Roll on policy level.

    [Tags]  TCH Instance  JIRA:BOT-1542  qTest:31986785  Regression  qTest:31247315
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...  AND  clear policy limits
    Go to policy  ${policy}
    Add Limit  ulsd  refresh  ${True}
    Verify Limit was Added  POLICY  ULSD

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Add Policy Hourly Limit
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...  AND  clear policy limits
    Go to policy  ${policy}
    Add Limit  ulsd  window  ${True}
    Verify Limit was Added  POLICY  ULSD

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Edit Policy Auto Roll Limit
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...  AND  setup policy limits  ULSD=500

    Go to policy  ${policy}
    ${original}  ${editedTo}  Edit Limit  ULSD
    Verify Limit was Edited  POLICY  ULSD  ${editedTo}

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Edit Policy Hourly Limit
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...  AND  setup policy limits  ULSD=500
    Go to policy  ${policy}
    ${original}  ${editedTo}  Edit Limit  ULSD
    Verify Limit was Edited  POLICY  ULSD  ${editedTo}

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Delete Policy Limit
    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  N
    ...      AND  setup policy limits  ULSD=500
    Go to policy  ${policy}
    Delete Limit  ULSD
    Verify Limit was Deleted  POLICY  ULSD

    [Teardown]  run keywords  Go Back To Carrier  ${validCard.carrier.id}
    ...  AND  clear policy limits

Add Auto Roll Product Level Policy Limit

    [Tags]  TCH Instance  JIRA:BOT-1546  qTest:31997069  Regression
    [Setup]  Set Product Level Limits Flag  ${validCard.carrier.id}  Y
    Go to policy  ${policy}
    Add Limit  GAS  refresh  ${True}
    Verify Limit was Added  POLICY  GAS

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Edit Auto Roll Product Level Policy Limit

    [Tags]  TCH Instance  JIRA:BOT-1547  JIRA:BOT-1545  qTest:31997121  Regression

    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  Y
    ...  AND  setup policy limits  GAS=500
    Go to policy  ${policy}
    ${orig}  ${new}  Edit Limit  GAS
    Verify Limit was Edited  POLICY  GAS  ${new}

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

Delete Product Level Policy Limit

    [Tags]  TCH Instance  JIRA:BOT-1548  qTest:31997130  Regression

    [Setup]  run keywords  Set Product Level Limits Flag  ${validCard.carrier.id}  Y
    ...  AND  setup policy limits  GAS=500
    Go to policy  ${policy}
    Delete Limit  GAS
    Verify Limit was Deleted  POLICY  GAS

    [Teardown]  Go Back To Carrier  ${validCard.carrier.id}

*** Keywords ***
Time to Setup
    ensure member is not suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    set global variable  ${policy}  ${validCard.policy.num}
    ${originalProductLevelLimitsFlag}=  get product level limits flag  ${validCard.carrier.id}
    set suite variable  ${originalProductLevelLimitsFlag}
    start setup card  ${validCard.num}
    clear card limits
    start setup policy  ${validCard.carrier.id}  ${policy}
    clear policy limits

    Open Account Manager

    Search a carrier in Account Manager  EFS  ${validCard.carrier.id}

Tear Down Limit Testing
    run keyword and ignore error  close all browsers

Select Refreshing Days
    [Arguments]  @{days}

    ${len}=  get length  ${days}
    @{days}=  run keyword if  ${len} < 1  create list  SUN  MON  TUE  WED  THU  FRI  SAT  ELSE  create list  @{days}

    FOR  ${i}  IN  @{days}
        select checkbox  //*[@value="${i}"]
    END

Set Limit Source
    [Arguments]  ${source}

    click primary section button (or text that looks like a link that is a button) by text  Reset
    select from list by label  detailRecord.productSource  ${source}
    click primary section submit
    wait until element is visible  //*[@id="primaryTabs"]//*[contains(text(),"Edit Successful")]  timeout=20  error=Limit Source Didn't Save Within 20 Seconds

Set Product Level Limits Flag
    [Arguments]  ${carrier_id}  ${flag}
    Execute SQL String  dml=UPDATE member_meta SET mm_value = '${flag}' WHERE member_id = ${validCard.carrier.id} AND member_meta.mm_key = 'PRODLMTS'

Get Product Level Limits Flag
    [Arguments]  ${carrier_id}
    ${original}=  query and strip  SELECT mm_value FROM member_meta WHERE member_id = ${validCard.carrier.id} AND member_meta.mm_key = 'PRODLMTS'
    [Return]  ${original}

Go to Card
    [Arguments]  ${card}
    ${onCustomer}=  Url Shows  acct-mgmt/Customer.action
    run keyword if  not ${onCustomer}  search a carrier in account manager  EFS  ${validCard.carrier.id}

    Click Secondary Tab By Text  Cards
    wait until loading spinners are gone
    input text  cardNumber  ${card}
    Click Search Section Submit
    wait until loading spinners are gone
    scroll element into view  //*[text()='${card}']
    Click Search Section Button (or text that looks like a link that is a button) by Text  ${card}
    wait until loading spinners are gone

    ${onCardScreen}  Url Shows  /acct-mgmt/Card.action
    run keyword if  not ${onCardScreen}  fail  Policy Screen Did Not Load After Clicking Policy: ${card}

Go to policy
    [Arguments]  ${policy}

    ${onCustomer}=  Url Shows  acct-mgmt/Customer.action
    run keyword if  not ${onCustomer}  search a carrier in account manager  ${validCard.carrier.id}

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

get limit details
    [Arguments]  ${src}  ${limit}
    ${cardLimitSql}=  assign string  select limit,hours,minhours,day_of_week,hour_of_day,day_of_month,daily_max from card_lmt where card_num = '${validCard.num}' and limit_id = '${limit}'
    ${polLimitSql}=  assign string  select limit,hours,minhours,day_of_week,hour_of_day,day_of_month,daily_max from def_lmts where carrier_id = ${validCard.carrier.id} and ipolicy = ${policy} and limit_id = '${limit}'

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

Verify Limit was Edited
    [Arguments]  ${src}  ${limit}  ${newLimitAmt}

    ${limits}  get limit details  ${src}  ${limit}

    should be equal as numbers  ${limits[0].limit}  ${newLimitAmt}  msg=Limit did not show what we expected the limit to change to  values=${False}

Validate Card Source
    [Arguments]  ${card_num}  ${source}

    ${src}=  query and strip  select lmtsrc from cards where card_num = '${card_num}'

    ${source}=  run keyword if  '${source.lower()}' == 'policy'  assign string  D  ELSE  assign string  ${source}
    should be equal as strings  ${src}  ${source[0]}

Edit Limit
    [Arguments]  ${limitId}

    Click On Products
    Click Search Section Submit

    click element  xpath=//input[@type="checkbox" and (@value="${limitId}" or @productcode="${limitId}")]/../..//button[contains(@class,"productsEdit")]
    wait until element is visible  xpath=//*[@name="productSummary.quantity"]  timeout=30  error=Product Edit Screen Didn't show within 30 secs
    ${originalLimit}=  get value  productSummary.quantity
    ${editedLimit}=  evaluate  ${originalLimit} - 10
    input text  productSummary.quantity  ${editedLimit}
    click element  //*[contains(@id,"ProductsAddUpdateFormButtons")]//*[contains(text(),"Submit")]

#    wait until element is not visible  //div[contains(@id,"ProductsDeleteDialogContainer")]  timeout=60  error=Product Didn't Successully Edit within 60 Secs
    wait until loading spinners are gone
    Check Edit Successful

    [Return]  ${originalLimit}  ${editedLimit}


Delete Limit
    [Arguments]  ${limitId}

    Click On Products
    Click Search Section Submit

    select checkbox  //input[@type="checkbox" and (@value="${limitId}" or @productcode="${limitId}")]
    click search section button (or text that looks like a link that is a button) by text  DELETE  span
    click element  //div[contains(@id,"ProductsDeleteDialogContainer")]//button[contains(text(),'Confirm')]

    wait until element is not visible  //div[contains(@id,"ProductsDeleteDialogContainer")]  timeout=60  error=Product Didn't Successully Delete within 60 Secs
    wait until loading spinners are gone
    Check Delete Successful

Go Back To Carrier
    [Arguments]  ${carrier}
    ${stat}  run keyword and return status  click element  //button[contains(text(),'${carrier}']
    run keyword unless  ${stat}  search a carrier in account manager  EFS  ${validCard.carrier.id}

Check Delete Successful
    wait until element is visible  //ul[contains(@class,"msgSuccess")]//li[contains(text(),"Delete Successful")]  timeout=25  error=Delete Successful message did not show within 25 secs

Check Add Successful
    wait until element is visible  //ul[contains(@class,"msgSuccess")]//li[contains(text(),"Add Successful")]  timeout=25  error=Add Successful message did not show within 25 secs

Check Edit Successful
    wait until element is visible  //ul[contains(@class,"msgSuccess")]//li[contains(text(),"Edit Successful")]  timeout=25  error=Edit Successful message did not show within 25 secs

Delete Policy Limits
    Execute SQL String  dml=DELETE from def_lmts where carrier_id = ${validCard.carrier.id} and ipolicy = ${policy}