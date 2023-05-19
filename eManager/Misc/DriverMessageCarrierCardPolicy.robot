*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  String
Library  DateTime
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Time to Setup
Suite Teardown  Time to Teardown
Force Tags  eManager

*** Variables ***
${DB}    TCH


*** Test Cases ***

Create a Driver Message For a Carrier
    [Tags]  JIRA:BOT-656  JIRA:BOT-1441  JIRA:BOT-1442  JIRA:BOT-1443  JIRA:BOT-1444  qtest:28818331  qTest:28818329  Regression  refactor
    [Documentation]  Creating a driver message for a Carrier
    Navigate to Driver Messaging
    Add New Message To  Carrier
    Fill Message Screen and Save
    Assert message  You have successfully Added new Message
    [Teardown]  End Test

Create a Driver Message For a Policy
    [Tags]  JIRA:BOT-656  qtest:28818331  qTest:28818334  Regression  refactor
    [Documentation]  Creating a driver message for a Policy
    Navigate to Driver Messaging
    Add New Message To  Policy
    Fill Message Screen and Save
    Assert message  You have successfully Added new Message
    [Teardown]  End Test

Create a Driver Message For a Card
    [Tags]  JIRA:BOT-656  qtest:28818331  qTest:28818332  qTest:28818335  Regression  refactor
    [Documentation]  Creating a driver message for a Card
    Navigate to Driver Messaging
    Add New Message To  Card
    Fill Message Screen and Save
    Assert message  You have successfully Added new Message
    [Teardown]  End Test

Create a Driver Message For a CARRIER with invalid date
    [Tags]  JIRA:BOT-1043  qtest:28818328  Regression  refactor
    [Documentation]  Creating a driver message for a Carrier with invalid date
    Navigate to Driver Messaging
    Add New Message To  Carrier
    Fill Message Screen and Save  start_date=aaaaaa  end_date=aaaaaa
    Assert message  must be a valid date
    [Teardown]  End Test

Create a Driver Message For a CARRIER adding a invalid date range
    [Tags]  JIRA:BOT-1043  qtest:28818330  Regression  refactor
    [Documentation]  Creating a driver message for a Carrier with invalid date range
    Navigate to Driver Messaging
    Add New Message To  Carrier
    ${invalid_end_date}  getdatetimenow  %Y-%m-%d  days=-10
    Fill Message Screen and Save  end_date=${invalid_end_date}
    Assert message  End Date cannot be before Start Date
    Assert message  End Date should be in the future
    [Teardown]  End Test

Create a Driver Message For a CARRIER and verify in the driver_msg table
    [Tags]  JIRA:BOT-1445  qtest:28818333  Regression  refactor
    [Documentation]  Creating a driver message for a Carrier and verify in the driver_msg table
    Navigate to Driver Messaging
    Add New Message To  Carrier
    ${driver_message}  catenate  BOT-1445 Testing
    Fill Message Screen and Save  message=${driver_message}
    Row Count Is Equal To X  SELECT * from driver_msg WHERE message='${driver_message}' and carrier_id=${validCard.carrier.member_id}  1
    [Teardown]  End Test


Create a Driver Message For a POLICY with invalid date
    [Tags]  JIRA:BOT-1446  qtest:28818328  Regression  refactor
    [Documentation]  Creating a driver message for a Policy with invalid date
    Navigate to Driver Messaging
    Add New Message To  Policy
    Fill Message Screen and Save  start_date=aaaaaa  end_date=aaaaaa
    Assert message  must be a valid date
    [Teardown]  End Test

Create a Driver Message For a POLICY adding a invalid date range
    [Tags]  JIRA:BOT-1446  qtest:28818330  Regression  refactor
    [Documentation]  Creating a driver message for a Policy with invalid date range
    Navigate to Driver Messaging
    Add New Message To  Policy
    ${invalid_end_date}  getdatetimenow  %Y-%m-%d  days=-10
    Fill Message Screen and Save  end_date=${invalid_end_date}
    Assert message  End Date cannot be before Start Date
    Assert message  End Date should be in the future
    [Teardown]  End Test

Create a Driver Message For a POLICY and verify in the driver_msg table
    [Tags]  JIRA:BOT-1446  qtest:28818333  Regression  refactor
    [Documentation]  Creating a driver message for a Policy and verify in the driver_msg table
    Navigate to Driver Messaging
    Add New Message To  Policy
    ${msg}  Generate Random String  3  [NUMBERS]
    ${driver_message}  catenate  BOT-1445 Testing${msg}
    Fill Message Screen and Save  message=${driver_message}
    Row Count Is Equal To X  SELECT * from driver_msg WHERE message='${driver_message}' AND carrier_id=${validCard.carrier.member_id} AND imsg_policy=1  1
    [Teardown]  End Test


Create a Driver Message For a CARD with invalid date
    [Tags]  JIRA:BOT-1447  qtest:28818328  qTest:28818335  Regression  refactor
    [Documentation]  Creating a driver message for a Card with invalid date
    Navigate to Driver Messaging
    Add New Message To  Card
    Fill Message Screen and Save  start_date=aaaaaa  end_date=aaaaaa
    Assert message  must be a valid date
    [Teardown]  End Test

Create a Driver Message For a CARD adding a invalid date range
    [Tags]  JIRA:BOT-1447  qtest:28818330  qTest:28818335  Regression  refactor
    [Documentation]  Creating a driver message for a Card with invalid date range
    Navigate to Driver Messaging
    Add New Message To  Card
    ${invalid_end_date}  getdatetimenow  %Y-%m-%d  days=-10
    Fill Message Screen and Save  end_date=${invalid_end_date}
    Assert message  End Date cannot be before Start Date
    Assert message  End Date should be in the future
    [Teardown]  End Test

Create a Driver Message For a CARD and verify in the driver_msg table
    [Tags]  JIRA:BOT-1447  qtest:28818333  qTest:28818335  Regression  refactor
    [Documentation]  Creating a driver message for a Card
    Navigate to Driver Messaging
    Add New Message To  Card
    ${msg}  Generate Random String  3  [NUMBERS]
    ${driver_message}  catenate  BOT-1445 Testing${msg}
    Fill Message Screen and Save  message=${driver_message}
    Row Count Is Equal To X  SELECT * FROM card_driver_msg cdm INNER JOIN driver_msg dm ON cdm.message_id = dm.message_id WHERE cdm.card_num = '${card_number}' AND dm.message='${driver_message}'  1
    [Teardown]  End Test


Create a Driver Message For a CARD adding a Negative Number to Max sends field
    [Tags]  JIRA:BOT-1042  qtest:28818327  Regression  JIRA:BOT-1754  BUGGED:Should not allow add negative number on sends field.
    [Documentation]  Creating a driver message for a Card with invalid date range
    Navigate to Driver Messaging
    Add New Message To  Card
    Fill Message Screen and Save  maxSends=-10
    Assert message  shoud_not_contain=You have successfully Added new Message
    [Teardown]  End Test

*** Keywords ***
Navigate to Driver Messaging
    go to  ${emanager}/cards/DriverMessage.action

Time to Setup
    Get Into DB  ${DB}

    open browser to emanager  NewBrowser
    switch browser  NewBrowser
    
    Log into eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    maximize browser window



Time to Teardown
    tch logging  Time to Teardown
    Disconnect From Database
    Close Browser

End Test
    ${query}  catenate  DELETE FROM driver_msg WHERE carrier_id = ${validCard.carrier.member_id} and message = '${message}'
    execute sql string  ${query}

Add New Message To
    [Arguments]  ${message_type}
    tch logging  Add New Message To ${message_type}
    Set Test Variable  ${message_type}

    Select From List By Value  name=messageType  ${message_type}
    run keyword if  '${message_type}'=='Card'
    ...  Select Random Card
    ...  ELSE IF  '${message_type}'=='Policy'
    ...  Select From List By Value  name=policyNumber  1

Select Random Card
    Click Button  name=lookUpCards
    ${card_num}  Generate Random String  1  [NUMBERS]
    Input Text  name=cardSearchTxt  ${card_num}
    Click Button  name=searchCard
    ${card_number}  Get Text  (//table[@id="cardSummary"]//td[contains(text(), 'Active')]/parent::tr/td/a)[1]
    Set Test Variable  ${card_number}
    Click Element  xpath=(//table[@id="cardSummary"]//td[contains(text(), 'Active')]/parent::tr/td/a)[1]

Fill Message Screen and Save
    [Arguments]  ${start_date}=None  ${end_date}=None  ${start_hour}=10  ${end_hour}=11  ${message}=BOT-656 May the force be with you  ${maxSends}=None

    ${TODAY}  getdatetimenow  %Y-%m-%d
    ${nextdate}  getdatetimenow  %Y-%m-%d  days=+1

    ${startDate}  Set Variable If  '${startDate}'=='None'  ${TODAY}  ${startDate}
    ${end_date}  Set Variable If  '${end_date}'=='None'  ${nextdate}  ${end_date}

    Set Test Variable  ${message}

    Click Button  addNewMessage
    Input Text  name=startDate  ${start_date}
    Select From List By Value  name=beginHour  ${start_hour}
    Input Text  name=endDate  ${end_date}
    Select From List By Value  name=endHour  ${end_hour}
    Input Text  message  ${message}

    run keyword if  '${maxSends}'!='None'
    ...  Input Text  maxSends  ${maxSends}

    Click Button  save

Assert message
    [Arguments]  ${message}=None  ${shoud_not_contain}=None

    run keyword if  '${shoud_not_contain}'=='None'
    ...  Page Should Contain  ${message}
    ...  ELSE
    ...  Page Should Not Contain  ${shoud_not_contain}
