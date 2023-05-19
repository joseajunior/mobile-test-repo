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
Verify Buttons Save Reset Delete this Card and Reset Pin is working
    [Tags]  PI:15  qTest:118015517  Jira:Rocket-338  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Close Browser
    Switch to Child user once it is found and select a card
    Select Card
    Select INACTIVE and press save button
    Select Reset and make sure it is clickable
    Check if 'Delete this card' and dismiss the message
    Click Reset Pin button and make sure message displays
    [Teardown]  Basic Teardown

Verify Update buttons work in Card Limit Level
    [Tags]  PI:15  qTest:118015517  Jira:Rocket-338  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and select a Child carrier
    Close Browser
    Switch to Child user once it is found and select a card
    Select Card
    Make the card Active
    Hover Limits and Select Update Limits
    Hover Prompts and Select Update Prompts
    Check if Buttons Save Reset Delete this Card and Reset Pin is working on page
    Hover Time Restrictions and Select Update Time Restrictions
    Check if Buttons Save Reset Delete this Card and Reset Pin is working on page
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

Go to manage card -> Card Order Page
    [Tags]  qtest
    [Documentation]  Select Program > "Manage Cards" > "Card Order"

    Select Program > "Manage Cards" > "Card Order"


Switch to Child user once it is found and select a card
    [Tags]  qTest
    [Documentation]  Select Program > User Administration > Customer Info Test Search for child ID and switch

    Open eManager  ${intern}  ${internPassword}
    Switch To "${childcarrier}" Carrier
    Select Program > "Manage Cards" > "View/Update Cards"

Select a random child carrier card
    [Tags]  qTest
    [Documentation]  select a random child carrrier card with select card_num from cards where carrier_id = '${child_carrier}' limit 1;

    ${sql}  catenate   select card_num from cards where carrier_id = '${child_carrier}' limit 1;
    @{carriers}  query and return dictionary rows  ${sql}
    ${carrier_id}  evaluate  random.choice(${carriers})

Select Card
    [Tags]  qTest
    [Documentation]  Select a card from the carrier's card table with
    ...     select card_num from cards where carrier_id = '${child_carrier}'
    ...     then search and select that cart in Emanager

    ${cardnum_list_query}  Catenate  select card_num from cards where carrier_id = '${child_carrier}';
    ${card_num}  Query And Strip  ${cardnum_list_query}  db_instance=TCH
    Set Test Variable    ${card_num}
    Select Radio Button  lookupInfoRadio  NUMBER
    Input Text    name=cardSearchTxt    ${card_num}
    Click Button    name=searchCard
    Click Element    //*[@id="cardSummary"]/tbody/tr/td[1]

Select INACTIVE and press save button
    [Tags]  qTest
    [Documentation]  Click INACTIVE and click save button

    Wait Until Page Contains    Card Prompt Detail
    Mouse Over    id=cardMenubar_3x2
    Click Element    id=cardLimits_1x2

    Select Radio Button  card.header.status  INACTIVE
    click element  saveCardInformation

Select Reset and make sure it is clickable
    [Tags]  qTest
    [Documentation]  Make sure reset button is clickable

    Select Radio Button  card.header.status  ACTIVE
    Element Should Be Enabled  reset
    click element  reset

Check if 'Delete this card' and dismiss the message
    [Tags]  qTest
    [Documentation]  make sure delete this card button works and is clickable

    Element Should Be Enabled  reset

Click Reset Pin button and make sure message displays
    [Tags]  qtest
    [Documentation]  Make sure reset pin is clickable

    Click Element  resetPin
    Check Element Exists  //*["Pin number for card ${card_num} has been reset"]

Hover Limits and Select Update Limits
    [Tags]  qTest
    [Documentation]  Hover Limits and Select Update Limits

    Mouse Over    cardMenubar_3x2
    Click Element    cardLimits_1x2

Check if Buttons Save Reset Delete this Card and Reset Pin is working on page
    [Tags]  qtest
    [Documentation]  Check if Buttons Save Reset Delete this Card and Reset Pin is working on page

    Element Should Be Enabled  deleteThisCard
    Element Should Be Enabled  resetPin

Hover Prompts and Select Update Prompts
    [Tags]  qtest
    [Documentation]  Hover Prompts and Select Update Prompts

    Mouse Over    cardMenubar_4x2
    Click Element    cardPrompts_1x2

Hover Time Restrictions and Select Update Time Restrictions
    [Tags]  qtest
    [Documentation]  Hover Time Restrictions and Select Update Time Restrictions

    Mouse Over    cardMenubar_6x2
    Click Element    cardTimeRestriction_1x2

Make the card Active
    [Tags]  qTest
    [Documentation]  Click ACTIVE and click save button

    Wait Until Page Contains    Card Prompt Detail
    Mouse Over    id=cardMenubar_3x2
    Click Element    id=cardLimits_1x2

    Select Radio Button  card.header.status  ACTIVE
    click element  saveCardInformation