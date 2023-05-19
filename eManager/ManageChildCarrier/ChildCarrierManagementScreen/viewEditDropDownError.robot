*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  Collections
Library  String
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot
Resource  ../../../Variables/validUser.robot

Force Tags  eManager  ManageChildCarrier

*** Variables ***

*** Test Cases ***
Verify Carrier Group and Carrier Group Tiers fees dropdowns are visible
    [Tags]  qTest:119715388  Q1:2023  Jira: Rocket-446  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Add the carrier group tiers and carrier group fee tier
    Navigate to Carrier Group Fee Tier and Carrier Group Tiers Assignment pages
    [Teardown]  Teardown

*** Keywords ***
Basic Setup
    [Arguments]  ${db}
    set test variable  ${db}
    Open eManager  ${intern}  ${internPassword}

Set Up Ryder Parent
    [Arguments]  ${db}
    [Tags]  qtest
    [Documentation]  Make sure child issuer is set up in mySQL db for ryder parent. Should be found with:
                ...  select param_value from sec_user_role_param where user_id = 197997 and param_id = 'CHILD_ISSUER';
                ...  Find a child carrier with that issuer:
                ...  select x.carrier_id from carrier_group_xref x join contract c ON x.carrier_id = c.carrier_id where c.issuer_id = {child_issuer} and x.parent = 197997 order by x.carrier_id limit 1;
                ...  ----ALIAS----
                ...  Get the alias from the carrier services postgress database
                ...  select * from carrier_alias where carrier_id = '{child_carrier}'
                ...  if one does not exist add one :D

    set test variable  ${db}
    set test variable  ${parent}  197998
    ${todayDashed}  getDateTimeNow  %Y-%m-%d
    set test variable  ${todayDashed}
    Open eManager  ${intern}  ${internPassword}
    ${sql}  catenate  select param_value from sec_user_role_param where user_id = ${parent} and param_id = 'CHILD_ISSUER';
    ${child_issuer}  query and strip  ${sql}  db_instance=mysql
    ${sql2}  catenate  select carrier_id from carrier_group_xref where parent = ${parent} limit 1;
    ${child_carrier}  query and strip  ${sql2}  db_instance=TCH
    set test variable  ${child_issuer}
    set test variable  ${child_carrier}
    ${sql3}  catenate  update contract set status = 'A' where carrier_id = ${child_carrier};
    execute sql string  ${sql3}  db_instance=TCH
    Add the Permission

Add the Permission
    [Tags]  qTest
    [Documentation]  Add the permission to parent carrier in the mySQL database:
                ...  INSERT INTO sec_user_role_xref values({parent_id},'VIEW_EDIT_CHILD_CARRIERS',1);
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIERS  1
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIER_USER_DEFINED_INFO  1
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIER_ALIAS_INFO  1
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIER_CARD_ORDER  1
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIER_INFO_POOL  1


Switch to Parent User
    [Tags]  qTest
    [Documentation]  Select Program > User Administration > Customer Info Test Search for Parent ID and switch
    Select Program > "User Administration" > "Customer Info Test"
    Select From List By Value  searchType  1
    Input Text  searchValue  ${parent}
    Click Element  SearchCustomers
    Click Element  //*[@id="searchCustomerTable"]/tbody/tr/td[1]/a[text()='${parent}']


Go into Manage Child carrier and select a Child carrier
    [Tags]  qtest
    [Documentation]  Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    ...     wait 5s then click the child carrier

    Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    sleep  5s
    Click Button  //*[contains(text(),'${childcarrier}')]

Click on User Alias Information tab for the Child carrier
    [Tags]  qtest
    [Documentation]  Click the User Alias Information tab for child carrier and verify page lands on the same child carrier

    Click Element  //td[@id='childCarrierMenuBar_4x2']
    Element Should Be Visible  //*[text()='${childcarrier}']

Add the carrier group tiers and carrier group fee tier
    [Tags]  qTest
    [Documentation]  Select Program > "Group Carrier Group Fees" > "Carrier Group Fee Tiers"
    ...     create a new fee tier with whichever name
    ...     Select Program > "Carrier Group Deals" > "Carrier Group Tiers"

    Select Program > "Group Carrier Group Fees" > "Carrier Group Fee Tiers"
    Click Element  creatNew
    Wait Until Element Is Visible  (//input[@type='text'])[1]
    Input Text  (//input[@type='text'])[1]  AutomationTest
    click element  add

    Select Program > "Carrier Group Deals" > "Carrier Group Tiers"
    Click Element  creatNew
    Wait Until Element Is Visible  (//input[@type='text'])[1]
    Input Text  (//input[@type='text'])[1]  AutomationTest
    click element  add

Navigate to Carrier Group Fee Tier and Carrier Group Tiers Assignment pages
    [Tags]  qTest
    [Documentation]  Navigate to Carrier Group Fee Tier and Carrier Group Tiers Assignment pages
    ...     and verify the Deals we have setup are displaying properly

    Hover Over  menubar_1x2
    Click Element    TCHONLINE_CARRIER_GROUP_FEE_TIER_ASSIGNMENTx2
#    Select Program > Carrier Group Fee Tier Assignment
    Click Element  //input[@value='ID']
    Input Text    searchTxt  ${childcarrier}
    Click Element    search

    Click Element    //div[contains(@onclick,'doSelect2')]
    Element Should Be Enabled  //tr[@class='odd']//select[@id='tierIdSelected']
    Click Element  //tr[@class='odd']//select[@id='tierIdSelected']

    Hover Over  menubar_1x2
    Click Element    TCHONLINE_CARRIER_GROUP_TIERS_ASSIGNMENTx2
    Click Element  //input[@value='ID']
    Input Text    searchTxt  ${childcarrier}
    Click Element    search

    Click Element    //div[contains(@onclick,'doSelect2')]
    Element Should Be Enabled  //tr[@class='odd']//select[@id='tierIdSelected']
    Click Element  //tr[@class='odd']//select[@id='tierIdSelected']

Teardown

    Select Program > "Group Carrier Group Fees" > "Carrier Group Fee Tiers"
    Click Element  //*[contains(@onclick,'AutomationTest')]
    Handle Alert

    Select Program > "Carrier Group Deals" > "Carrier Group Tiers"
    Click Element  //*[contains(@onclick,'AutomationTest')]
    Handle Alert

    Close Browser
