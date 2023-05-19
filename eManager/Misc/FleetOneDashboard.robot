*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.support.PyString
Library  Process
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager
Suite Setup  Get FleetOne Test Data
Test Teardown  Close Browser

*** Variables ***
${carrierId}
${password}
${url}

*** Test Cases ***
Check Announcement Links 'Video Turorials' and 'Order Fuel Cards'
    [Tags]  JIRA:2107   qTest:116563003  PI:14
    [Documentation]  On the eManager Home Screen confirm the Announcements link for Video Tutorials links to the URL shown in
    ...  listed in the following:
    ...  SELECT *
    ...  FROM setting
    ...  WHERE name = 'VIDEO_TUTORIALS_URL';
    ...  Also confirm the Announcements link for Order Fuel Cards connects to the card order form page

    Log Into eManager With FleetOne Carrier ${carrierId} ${password}
    Check 'Video Tutorials' Link
    Check 'Order Fuel Cards' Link

Check Help Link
    [Tags]  JIRA:2107   qTest:116563035  PI:14
    [Documentation]  On the eManager Home Screen confirm the Help links to the URL shown in
    ...  listed in the following:
    ...  SELECT *
    ...  FROM setting
    ...  WHERE name = 'VIDEO_TUTORIALS_URL';

    Log Into eManager With FleetOne Carrier ${carrierId} ${password}
    Check 'Help' Link

*** Keywords ***
Check 'Help' Link
    Click Element  //*/td[3]/table/tbody/tr/td[3]/a
    Switch Window  NEW
    Wait Until URL Contains  ${url}
    Switch Window  MAIN

Check 'Order Fuel Cards' Link
    Select Frame    //*[@id="f1extf"]
    Click Element  //*[contains(text(),"Order Fuel Cards")]
    Switch Window  NEW
    Wait Until Page Contains  Continue
    Switch Window  MAIN

Check 'Video Tutorials' Link
    Select Frame    //*[@id="f1extf"]
    Click Element    //*[contains(text(),"Video Tutorials")]
    Unselect Frame
    Switch Window  NEW
    Wait Until URL Contains  ${url}
    Switch Window  MAIN

Get FleetOne Test Data
    get into db  TCH
    ${query}  catenate
    ...  SELECT *
    ...  FROM member
    ...  WHERE member_id BETWEEN 700000 AND 800000
    ...  AND   status = 'A'
    ...  AND   carrier_type = 'FLT1'
    ...  AND   first_trans_date IS NOT NULL
    ...  LIMIT 100;
    ${carrierId}  Find Random Row From Query  ${query}  column=member_id
    Set Suite Variable  ${carrierId}
    Get Password ${carrierId}
    Get URL

Get Password ${carrierId}
    ${query}  catenate
    ...  SELECT *
    ...  FROM member
    ...  WHERE member_id = ${carrierId}
    ...  AND   status = 'A';
    ${result}  query and strip to dictionary  ${query}
    Set Suite Variable  ${password}  ${result["passwd"]}

Get URL
    ${query}  catenate
    ...  SELECT *
    ...  FROM setting
    ...  WHERE name = 'VIDEO_TUTORIALS_URL';
    ${result}  query and strip to dictionary  ${query}  MySQL
    Set Suite Variable  ${url}  ${result["value"]}

Log Into eManager With FleetOne Carrier ${carrierId} ${password}
    Change Company Header  Fleet One Carrier
    Open eManager  ${carrierId}  ${password}  True  ChangeCompanyHeader=False
    Wait Until Page Contains  Select Program
