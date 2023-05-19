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
Verify User can navigate into Info Pool Tab for Child carrier
    [Tags]  qTest:116056908  Jira:Rocket-268  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Click on Info Pool tab for the Child carrier
    Get the Prompts
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
    [Tags]
    [Documentation]
    Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    sleep  5s
    Click Button  //*[contains(text(),'${childcarrier}')]

Click on Info Pool tab for the Child carrier
    [Documentation]
    Click Element  //td[@id='childCarrierMenuBar_6x2']

get the prompts
    [Tags]  qtest
    [Documentation]  Add a series of prompts and related values. Verify the changes in the postgres database:
            ...  select * from infopool where carrier_id = <carrier_id>> and pool_type = <pool_type>;
            ...  select * from related_values where pool_id = <pool_id>;
    @{prompt_list}  Get List Items  promptSelect  values=True
    remove from list  ${prompt_list}  0
    ${today}  getDateTimeNow  %d
    set test variable    ${today}
    FOR  ${prompt_id}  IN  @{prompt_list}
        ${value}  Generate Random String  6
        Add "${prompt_id}" prompt with "${value}" value
        Add related values on "${prompt_id}" with "${value}" value
        exit for loop if    '${today}'!='01'
    END

Add related values on "${prompt_id}" with "${value}" value
    click element  redirectToEditInfoPool
    ${value}  get value  value
    wait until element is visible  remainingRelPrompts
    @{related_list}  Get List Items  remainingRelPrompts  values=True
    remove from list  ${related_list}  0
    @{related_values}  create list
    FOR  ${item}  IN  @{related_list}
        ${rvalue}  Generate Random String  6
        Wait Until Element Is Enabled  remainingRelPrompts
        Select From List by Value  remainingRelPrompts  ${item}
        Wait Until Element Is Enabled  newPromptId
        input text  newPromptId  ${rvalue}
        wait until element is not visible  class=loading-img
        Wait Until Element Is Enabled  btnSubmit
        click button  btnSubmit
        wait until element is not visible  class=loading-img
        sleep  1s
        append to list  ${related_values}  ${rvalue}
        Verify "${rvalue}" on "${prompt_id}" with "${value}"
        exit for loop if    '${today}'!='01'
    END

Add "${prompt}" prompt with "${value}" value
    Select From List by Value  promptSelect  ${prompt}
    click button  redirectToAddInfoPool
    wait until element is visible  addInfoPool
    input text  value  ${value}
    click button  addInfoPool
    wait until element is visible  redirectToAddInfoPool

Verify "${item}" on "${prompt_id}" with "${value}"
    ${sql}  catenate  select pool_id from infopool where pool_type = '${prompt_id}' and pool_value = '${value}' and carrier_id = ${childcarrier};
    ${pool_id}  query and strip  ${sql}  db_instance=infopool
    ${sql2}  catenate  select related_value from related_values where pool_id = ${pool_id}
    ${related_values_list}  query and strip to list  ${sql2}  db_instance=infopool
    List Should contain value   ${related_values_list}  ${item}
    ${sql3}  catenate  delete from related_values where pool_id = ${pool_id}
    execute sql string  ${sql3}  db_instance=infopool

Get a non-child carrier
    [Tags]  qtest
    [Documentation]    Look for a carrier id that isn't a child of any parent and is active:
            ...     SELECT FIRST 10 m.member_id FROM member m WHERE m.mem_type = 'C' AND m.status = 'A'
            ...     AND m.member_id not in (select carrier_id from carrier_group_xref UNION select carrier_id from carrier_referral_xref);
            ...     Add the INFOPOOLAPI key and set it to 'Y' for this carrier's member_meta:
            ...     insert into member_meta (member_id,mm_key,mm_value) values (carrier.id,'INFOPOOLAPI', 'Y');
            ...     And add the permission MANAGE_INFOPOOL to this carrier
    ${sql}    catenate  SELECT FIRST 10 m.member_id FROM member m WHERE m.mem_type = 'C' AND m.status = 'A'
    ...     AND m.member_id not in (select carrier_id from carrier_group_xref UNION select carrier_id from carrier_referral_xref)
    ${carrier_list}   query and strip to list  ${sql}  db_instance=tch
    ${carrier.id}  evaluate  random.choice(${carrier_list})
    set test variable    ${carrier.id}
    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_INFOPOOL
    Update Infopools Flag   Y

Update Infopools Flag
    [Tags]  qtest
    [Documentation]    Check if the member_meta table has an INFOPOOLAPI mm_key for the test's carrier and insert/update its flag.
            ...        update member_meta set mm_value = <Y/N> where mm_key = 'INFOPOOLAPI' and member_id = <carrier_id>
            ...        insert into member_meta (member_id,mm_key,mm_value) values (<carrier_id>,'INFOPOOLAPI', <Y/N>);
    [Arguments]    ${value}
    ${select_sql}   catenate    select member_id from member_meta where mm_key = 'INFOPOOLAPI' AND member_id = ${carrier.id}
    ${update_sql}    catenate    update member_meta set mm_value = '${value}' where mm_key = 'INFOPOOLAPI' and member_id = ${carrier.id}
    ${insert_sql}  catenate  insert into member_meta (member_id,mm_key,mm_value) values (${carrier.id},'INFOPOOLAPI', '${value}');

    ${member_id}    query and strip    ${select_sql}    db_instance=tch
    IF  ${member_id}==None
        execute sql string  dml=${insert_sql}  db_instance=tch
    ELSE
        execute sql string  dml=${update_sql}  db_instance=tch
    END
