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

Force Tags  eManager  ManageChildCarrier

*** Variables ***

*** Test Cases ***
Verify User can navigate into User Defined Tab for Child carrier
    [Tags]  qTest:116056908  Jira: Rocket-269  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Click on User Defined Tab for the Child carrier
    [Teardown]  Basic Teardown

Verify Edit User Defined Keys
    [Tags]  qTest:116878280  Jira: Rocket-270  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Set up User Defined 5
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Click on User Defined Tab for the Child carrier
    Verify Edit Key button
    Verify Key change in DB
    [Teardown]  Basic Teardown

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
    set test variable  ${parent}  197997
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

Basic Teardown
    close browser

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

Click on User Defined Tab for the Child carrier
    [Tags]  qtest
    [Documentation]  Click the User Defined tab for child carrier and verify page lands on the same child carrier

    Click Element  //td[@id='childCarrierMenuBar_3x2']
    Element Should Be Visible  //*[text()='${childcarrier}']

Verify Edit Key button
    [Tags]  qtest
    [Documentation]  click the Edit user defined key button. Update the text on one or more of the keys. Click update.
    wait until element is enabled  editUserDefinedKeys
    click button  editUserDefinedKeys
    wait until element is enabled  //*[@id="parentKey_0"]
    ${key_label}  Generate Random String  6
    set test variable  ${key_label}
    input text  parentKey_4  ${key_label}
    click button  updateParentKey_4
    sleep  3s
    click button  loadUserDefinedInfo
    wait until page contains  ${key_label}

Verify Key change in DB
    [Tags]  qtest
    [Documentation]  Check member_meta table for the new changes:
                ...  select *
                ...  from member_meta
                ...  where member_id = 197997
                ...  and mm_key in ('FIELD_1_DESC', 'FIELD_2_DESC', 'FIELD_3_DESC', 'FIELD_4_DESC', 'FIELD_5_DESC');
    ${sql}  catenate  select mm_value
                ...  from member_meta
                ...  where member_id = 197997
                ...  and mm_key in ('FIELD_1_DESC', 'FIELD_2_DESC', 'FIELD_3_DESC', 'FIELD_4_DESC', 'FIELD_5_DESC');
    ${field_keys}  query and strip to list  ${sql}  db_instance=tch
    list should contain value  ${field_keys}  ${key_label}

Set up User Defined 5
    ${sql}  catenate  delete from member_meta where member_id = ${childcarrier} and mm_key = 'FIELD_5';
    execute sql string  ${sql}  db_instance=tch
    ${sql2}  catenate  INSERT into member_meta (member_id, mm_key, mm_value) values(${childcarrier}, 'FIELD_5','funRobotStuff');
    execute sql string  ${sql2}  db_instance=tch


