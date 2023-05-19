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
Verify User can navigate into User Defined Tab for Child carrier
    [Tags]  qTest:116056908  Jira: Rocket-269  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Click on User Alias Information tab for the Child carrier
    [Teardown]  Basic Teardown

Verify User can Add/Update/Delete child carrier Alias
    [Tags]  qTest:116805634  Jira: Rocket-248  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Click on User Alias Information tab for the Child carrier
    Enter A Random Alias And Click Submit
    Update Preiously entered Alias
    Delete the alias that had previously been created
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

Click on User Alias Information tab for the Child carrier
    [Tags]  qtest
    [Documentation]  Click the User Alias Information tab for child carrier and verify page lands on the same child carrier

    Click Element  //td[@id='childCarrierMenuBar_4x2']
    Element Should Be Visible  //*[text()='${childcarrier}']

Enter a random Alias and click submit
    [Tags]
    [Documentation]  Input a random alias 'Aut0m4ti0n'

    Wait Until Element Is Visible  newAliasVal
    input text  newAliasVal  Aut0m4ti0n

    Wait Until Element Is Enabled  //*[@name="AddUpdate" and @id='btnSubmit']
    Click Element  //*[@name="AddUpdate" and @id='btnSubmit']

Update Preiously entered Alias
    [Tags]
    [Documentation]  Update previously entered Alias


    Wait Until Element Is Visible  //*[@id="aliasVal_0"]
    input text  //*[@id="aliasVal_0"]  Aut0m
    Wait Until Element Is Visible  //*[@id='updateAliasVal_0' and @name='AddUpdate']
    Click Element  //*[@id='updateAliasVal_0' and @name='AddUpdate']

Delete the alias that had previously been created
    [Tags]
    [Documentation]  Delete the alias we just created. Click the delete button then OK

#    Wait Until Element Is Enabled  //*[@name="delete"]
    Wait Until Element Is Visible  //*[@id='aliasValue_0']//*[@name="delete"]
    sleep  1s
    Click Element  //*[@id='aliasValue_0']//*[@name="delete"]
    Click Element  //*[@type='button' and contains(text(),'Yes')]