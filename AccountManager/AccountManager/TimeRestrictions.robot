*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup  Time to Setup
Suite Teardown  Tear Me Down

Force Tags  AM  Card Details

*** Variables ***

*** Test Cases ***
Add Time Restriction on Card Details Screen
    [Tags]  JIRA:BOT-1353  JIRA:BOT-1354  qTest:32780979  qTest:32780980  Regression  qTest:30887805  refactor
    [Documentation]  Add Time Restriction for a Card on Card Details and Then Delete It.
    ${card}  Set Variable  7083050910386622557
    Generate Random Day and Time for Test Execution
    Open Account Manager
    Search For Card  EFS LLC  ${card}
    Select Time Restrictions on Card Detail
    Add Time Restriction for a Card on Card Details  ${day}  ${startTime}  ${endTime}
    Assert Time Restriction on Database  ${card}  ${dayIndex}  ${startTime}  ${endTime}  ADD
    Delete Time Restriction   ${day}  ${startTime}  ${endTime}
    Assert Time Restriction on Database  ${card}  ${dayIndex}  ${startTime}  ${endTime}  REMOVE

    [Teardown]  Close Browser

Add Time Restriction on Card Details Screen (MasterCard)
    [Tags]  JIRA:BOT-1353  qTest:32780979   Regression  refactor
    [Documentation]  Add Time Restriction for a Card on Card Details and Then Delete It.
    ${card}  Set Variable  5567480002020509
    Generate Random Day and Time for Test Execution
    Open Account Manager
    Search For Card  EFS LLC  ${card}
    Select Time Restrictions on Card Detail
    Add Time Restriction for a Card on Card Details  ${day}  ${startTime}  ${endTime}
    Assert Time Restriction on Database  ${card}  ${dayIndex}  ${startTime}  ${endTime}  ADD
    Delete Time Restriction   ${day}  ${startTime}  ${endTime}
    Assert Time Restriction on Database  ${card}  ${dayIndex}  ${startTime}  ${endTime}  REMOVE

    [Teardown]  Close Browser

*** Keywords ***
Time to Setup
    Get Into DB  TCH

Generate Random Day and Time for Test Execution

    @{week}  Create List  Sunday  Monday  Tuesday  Wednesday  Thursday  Friday  Saturday
    ${day}  Evaluate  random.choice(${week})  random
    ${dayIndex}  Get Index From List  ${week}  ${day}
    ${startTime}  getDateTimeNow  %H:%M
    ${endTime}  getDateTimeNow  %H:%M  hours=1

    Set Test Variable  ${day}
    Set Test Variable  ${dayIndex}
    Set Test Variable  ${startTime}
    Set Test Variable  ${endTime}

Tear Me Down
    Disconnect From Database

Search For Card
    [Arguments]  ${partner}  ${card_num}
    Wait Until Element is Enabled  //a[@id='Card']
    Click on  //a[@id='Card']
    Wait Until Element Is Visible  name=cardNumber
    Refresh Page
    Wait Until Element Is Visible  name=businessPartnerCode  timeout=35
    Select From List By Label  businessPartnerCode  ${partner}
    Wait Until Element is Enabled  //input[@name='cardNumber']  timeout=35
    Input Text  name=cardNumber  ${card_num}
    double click on  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0  timeout=35
    Wait Until Element is Visible  //button[text()='${card_num}']  timeout=35
    Set Focus To Element  //button[text()='${card_num}']
    click on  //button[text()='${card_num}']
    Wait Until Element Is Enabled  id=submit

Select Time Restrictions on Card Detail
    Wait Until Element is Enabled  //a[@id='TimeRestrictions']
    Click on  //a[@id='TimeRestrictions']

Add Time Restriction for a Card on Card Details
    [Arguments]  ${day}  ${startTime}  ${endTime}
    Wait Until Element Is Visible  detailRecord.promptSource  timeout=35
    Wait Until Element is Enabled  //a[@id='ToolTables_DataTables_Table_1_1']  timeout=35
    Click on  //a[@id='ToolTables_DataTables_Table_1_1']
    Wait Until Element is Enabled  timeRestrictionSummary.id  timeout=35
    Select From List by Label  timeRestrictionSummary.id  ${day}
    Input Text  timeRestrictionSummary.startTime  ${startTime}
    Input Text  timeRestrictionSummary.endTime  ${endTime}
    Click Element  //td[@id='cardTimeRestrictionsAddUpdateFormButtons']//button[@id='submit']
    Handle Alert  timeout=35

Assert Time Restriction on Database
    [Arguments]  ${card_number}  ${dayOfWeek}  ${begTime}  ${endTime}  ${action}
    [Documentation]  Assert Time Restriction on Database Based on Action. ADD/REMOVE.
    ${query}  Catenate  SELECT * FROM card_time
    ...  WHERE card_num='${card_number}'
    ...  AND day_of_week='${dayOfWeek}'
    ...  AND beg_time=TO_DATE("${begTime}:00","%H:%M:%S")
    ...  AND end_time=TO_DATE("${endTime}:00","%H:%M:%S")

    Run Keyword If  '${action}'=='ADD'
    ...  Row Count Is Equal to X  ${query}  1
    ...  ELSE  Run Keywords  Verify Time Restriction Delete Success Message
    ...  AND  Row Count Is Equal to X  ${query}  0

Delete Time Restriction
    [Arguments]  ${day}  ${startTime}  ${endTime}
    [Documentation]  Delete Time Restriction on Card Detail in Account Manager, based on Restriction, Start Time and End Time Columns

    Click On  //table[@id='DataTables_Table_1']//tbody//tr//td[count(//th[text()='Restriction']/preceding-sibling::th)+1]/button[text()='${day}']/parent::td/parent::tr//td[count(//th[text()='Start Time']/preceding-sibling::th)+1][text()='${startTime}']/parent::tr//td[count(//th[text()='End Time']/preceding-sibling::th)+1][text()='${endTime}']/parent::tr//input
    Click Element  ToolTables_DataTables_Table_1_2
    Wait Until Element is Enabled  //div[@class='dialogButtons']//button[@name='confirm']  timeout=35
    Click Element  //div[@class='dialogButtons']//button[@name='confirm']

Verify Time Restriction Delete Success Message
    Wait Until Element is Enabled  //ul[@class='msgSuccess']//li[contains(text(),'Delete Successful')]  timeout=35