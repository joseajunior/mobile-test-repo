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

*** Test Cases ***
Verify User can create and delete recently created card order in the Child carrier Management Page
    [Tags]  qTest:116579755  Jira:Rocket-272  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Click on User Card order tab for the Child carrier
    Click on Card Order Type and select a random option
    Select all necessary requirements for the card order
    Check the db if the new card order had been created
    Delete the card order that had just been created
    [Teardown]  Basic Teardown


Verify Parkland Update template contact info does not change
    [Tags]  qTest:117507345  Jira:Rocket-358  API:Y
    [Setup]  Set Up Parkland Parent  TCH
    Switch to Parent User
    Go to manage card -> Card Order Page
    Click on Card Order Type and select a random option
    Fill in the address information and make them static
    Switch the policy number to see if the address changes
    Switch the product Restrictions to see if address changes
    [Teardown]  Basic Teardown

Verify Ryder Update template contact info does not change
    [Tags]  qTest:117507342  Jira:Rocket-358  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Click on User Card order tab for the Child carrier
    Click on Card Order Type and select a random option V2
    Fill in the address information and make them static
    Click Card Style and select a random value
    [Teardown]  Basic Teardown

Verify Parkland Update template contact info does not change when switched policies
    [Tags]  qTest:118106091  Jira:Rocket-348  API:Y
    [Setup]  Set Up Parkland Parent  TCH
    Switch to Parent User
    Go to manage card -> Card Order Page
    Click on Card Order Type and select a random option
    Ensure the name and address populates for policy
    Query into sec_user_setting to check if name and address excists for user policy
    Switch Policy number and ensure addresses are blank
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

Click on User Card order tab for the Child carrier
    [Tags]  qtest
    [Documentation]  Click the User Card Order tab for child carrier and verify page lands on the same child carrier

    Click Element  //td[@id='childCarrierMenuBar_5x2']
    Element Should Be Visible  //*[text()='${childcarrier}']

Click on Card Order Type and select a random option
    [Tags]  qtest
    [Documentation]  Click on card order type and select any option from the drop down

    Click Element  codeIntSel

    @{list}  Get List Items    codeIntSel  values=${TRUE}
    FOR  ${i}  IN  @{list}
        Select From List By Value    codeIntSel  ${i}
    END

Select all necessary requirements for the card order
    [Tags]  qtest
    [Documentation]  Select a random card style. Fill in name and address of the customer. Finally click the save button
    ...     verify that page displays 'Card order successfully submitted'

    click element  cardStylSel

    @{list}  Get List Items    cardStylSel  values=${TRUE}
    FOR  ${i}  IN  @{list}
        Select From List By Value    cardStylSel  ${i}
        Exit for loop
    END

    Input text  shipToFirst  Automation
    Input text  shipToLast  Robot
    Input text  address1  Automation blvd
    Input text  city  Queens

    @{list}  Get List Items    stateSel  values=${TRUE}
    FOR  ${i}  IN  @{list}
        Select From List By Value    stateSel  ${i}
    END

    Input text  zip  11370

    click element  saveBtn
    click element  //*[text()='OK']

    Element Should Be Visible  //*[text()='Card order successfully submitted']

Delete the card order that had just been created
    [Tags]  qTest
    [Documentation]  Deletes the most recent card order that was created

    click element  deleteCardOrder
    Element should be visible  //*[@aria-describedby='deleteCardOrder-dialog']//*[text()='OK']
    click element  //*[@aria-describedby='deleteCardOrder-dialog']//*[text()='OK']

    Element Should Be Visible  //*[text()='Card order has been deleted']

Check the db if the new card order had been created
    [Tags]  qtest
    [Documentation]  Just running a query select status_msg from
    ...     ccb_card_orders where carrier_id = '${childcarrier}' and
    ...     status_msg = 'New Cards Created' limit 1;

    ${sql}  catenate  select status_msg from ccb_card_orders where carrier_id = '${childcarrier}' and status_msg = 'New Cards Created' limit 1;
    ${db_output}  query and strip  ${sql}  db_instance=TCH
    Should Be Equal As Strings  ${db_output}  New Cards Created

Set Up Parkland Parent
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
    set test variable  ${parent}  2500000
    ${todayDashed}  getDateTimeNow  %Y-%m-%d
    set test variable  ${todayDashed}
    Open eManager  ${intern}  ${internPassword}
    ${sql}  catenate  select param_value from sec_user_role_param where user_id = ${parent} and param_id = 'CHILD_ISSUER';
    ${child_issuer}  query and strip  ${sql}  db_instance=mysql
    ${sql2}  catenate  select carrier_id from carrier_group_xref where parent = ${parent} limit 1;
    ${child_carrier}  query and strip  ${sql2}  db_instance=TCH
    set test variable  ${child_issuer}
    set test variable  ${child_carrier}
    Add the Permission

Go to manage card -> Card Order Page
    [Tags]  qtest
    [Documentation]  Select Program > "Manage Cards" > "Card Order"

    Select Program > "Manage Cards" > "Card Order"

Fill in the address information and make them static
    [Arguments]  ${firstName}=firstName  ${lastName}=lastName  ${address1}=456 Wex ave  ${address2}=123 Wex blvd  ${city}=Queens  ${zip}=11370
    [Tags]  qtest
    [Documentation]  Fill in the address information and make them static. Fill out all the address requirements that we will use for the test

    input text  shipToFirst  ${firstName}
    Set Test Variable  ${firstName}

    Input Text  shipToLast  ${lastName}
    Set Test Variable  ${lastName}

    input text  address1  ${address1}
    Set Test Variable  ${address1}

    input text  address2  ${address2}
    Set Test Variable  ${address2}

    Input Text  city  ${city}
    Set Test Variable  ${city}

    Element Should Be Visible  stateSel

    input text  zip  ${zip}
    set test variable  ${zip}

Switch the policy number to see if the address changes
    [Tags]  qtest
    [Documentation]  Switch the policy number to see if the address changes

    @{list}  Get List Items    contractPolicySel  values=${TRUE}
    FOR  ${i}  IN  @{list}
        Select From List By Value    contractPolicySel  ${i}
    END

    Textfield Value Should Be  shipToFirst  ${firstName}
    Textfield Value Should Be  shipToLast  ${lastName}
    Textfield Value Should Be  address1  ${address1}
    Textfield Value Should Be  address2  ${address2}
    Textfield Value Should Be  city  ${city}
    Textfield Value Should Be  zip  ${zip}

Switch the product Restrictions to see if address changes
    [Tags]  qtest
    [Documentation]  Switch The Product Restrictions To See If Address Changes

    @{list}  Get List Items    productRestrictionsSel  values=${TRUE}
    FOR  ${i}  IN  @{list}
        Select From List By Value    productRestrictionsSel  ${i}
    END

    Textfield Value Should Be  shipToFirst  ${firstName}
    Textfield Value Should Be  shipToLast  ${lastName}
    Textfield Value Should Be  address1  ${address1}
    Textfield Value Should Be  address2  ${address2}
    Textfield Value Should Be  city  ${city}
    Textfield Value Should Be  zip  ${zip}

Click on Card Order Type and select a random option V2
    [Tags]  qtest
    [Documentation]  Click on card order type and select any option from the drop down

    Click Element  codeIntSel

    @{list}  Get List Items    codeIntSel  values=${TRUE}
    FOR  ${i}  IN  @{list}

        Select From List By Value    codeIntSel  ${i}

    END

Click Card Style and select a random value
    [Tags]  qtest
    [Documentation]  Click the card style and select a random value to see if the address remains the same

    click element  cardStylSel

    @{list}  Get List Items    cardStylSel  values=${TRUE}
    FOR  ${i}  IN  @{list}

        Select From List By Value    cardStylSel  ${i}

        Textfield Value Should Be  shipToFirst  ${firstName}
        Textfield Value Should Be  shipToLast  ${lastName}
        Textfield Value Should Be  address1  ${address1}
        Textfield Value Should Be  address2  ${address2}
        Textfield Value Should Be  city  ${city}
        Textfield Value Should Be  zip  ${zip}

    END

Ensure the name and address populates for policy
    [Tags]  qTest
    [Documentation]  Ensure policy 1 reflects name and address according to the db

    Element Text Should Not Be  shipToFirst  NULL
    Element Text Should Not Be  shipToLast  NULL
    Element Text Should Not Be  address1  NULL
    Element Text Should Not Be  city  NULL
    Element Text Should Not Be  zip  NULL

Switch Policy number and ensure addresses are blank
    [Tags]  qTest
    [Documentation]  Based on the the query determine which policy the address and name is defaulted for
    ...     check if the the name and address populates.

    @{list}  Get List Items    contractPolicySel  values=${TRUE}
    FOR  ${i}  IN  @{list}
        Select From List By Value    contractPolicySel  ${i}
    END

    Element Should Not Contain  shipToFirst  ABC123
    Element Should Not Contain  shipToLast  ABC123
    Element Should Not Contain  address1  ABC123
    Element Should Not Contain  city  ABC123
    Element Should Not Contain  zip  ABC123

Query into sec_user_setting to check if name and address excists for user policy
    [Tags]  qtest
    [Documentation]  Query Into Sec_user_setting To Check If Name And Address Excists For User Policy
    ...     select COUNT(iid) from sec_user_setting where code = 'DEF_SHIP_TO_ID' and user_id like '%${parent}%';

    ${sqlquery}  catenate  select COUNT(iid) from sec_user_setting where code = 'DEF_SHIP_TO_ID' and user_id like '%${parent}%';
    ${sec_user}  Query And Strip  ${sqlquery}  db_instance=mysql

    Should Be Equal As Numbers  1  ${sec_user}
