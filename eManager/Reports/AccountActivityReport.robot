*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup    Setup Carrier for Account Activity Report With Data
Test Teardown  Close Browser

Force Tags  eManager  Reports

*** Variables ***
${carrier}
${report_name}    activity-report

*** Test Cases ***
Account Activity Report Pulls data
    [Tags]    JIRA:FRNT-2126  JIRA:BOT-4894  qTest:31247194
    [Documentation]    Ensure Account Activity Report is generating valid file to download with no errors

    Log Carrier into eManager with Account Activity Report permission
    Go to Select Program > Reports/Exports > Account Activity Report
    Setup Report Options
    Download and Check Report File

*** Keywords ***
Setup Carrier for Account Activity Report With Data
    [Documentation]  Keyword Setup for Account Activity Report With Data

    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT DISTINCT member_id
    ...    FROM member m
    ...    INNER JOIN contract c
    ...    ON m.member_id = c.carrier_id
    ...    INNER JOIN contract_journal cj
    ...    ON c.contract_id = cj.contract_id
    ...    WHERE who = 'MoneyCode Transaction'
    ...    AND when > current - 1 units month
    ...    AND m.member_id NOT IN ('701501');
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_member_id}  Get From Dictionary  ${list}  member_id
    ${list_member_id}  Evaluate  ${list_member_id}.__str__().replace('[','(').replace(']',')')
    Get Into DB  MYSQL
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]+$'
    ...    AND user_id IN ${list_member_id}
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_user_id}  Get From Dictionary  ${list}  user_id
    ${list_user_id}  Evaluate  ${list_user_id}.__str__().replace('[','(').replace(']',')')
    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT DISTINCT member_id
    ...    FROM member
    ...    WHERE member_id IN ${list_user_id};
    # Find carrier with given query and set as suite variable
    ${carrier}    Find Carrier Variable    ${query}    member_id
    Set Suite Variable  ${carrier}
    # Ensure carrier has Enhanced Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  ACCOUNT_ACTIVITY_REPORT

Log Carrier into eManager with Account Activity Report permission
    [Documentation]  Log carrier into eManager with Account Activity Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Reports/Exports > Account Activity Report
    [Documentation]  Go to Select Program > Reports/Exports > Account Activity Report

    Go To  ${emanager}/cards/AccountActivityReport.action
    Wait Until Page Contains    Select Schedule or Immediate Report

Get Date By Period
    [Arguments]    ${period}
    [Documentation]  Get date regarding period
    ...    period options: current, daily, weekly, monthly

    ${decrease_time}    Run Keyword If    '${period}'=='current'    Set Variable    0
    ...    ELSE    Run Keyword If    '${period}'=='daily'    Set Variable    1
    ...    ELSE    Run Keyword If    '${period}'=='weekly'    Set Variable    7
    ...    ELSE    Set Variable    30
    ${current_date_time}    Get Current Date    time_zone=UTC
    ${current_date_time}    Subtract Time From Date    ${current_date_time}    ${decrease_time} days    %Y-%m-%d    True
    [Return]    ${current_date_time}

Set Start and End Date
    [Documentation]    Set a range date for the report

    ${start_date}    Get Date By Period    monthly
    Input Text    name=startDate    ${start_date}
    ${end_date}    Get Date By Period    current
    Input Text    name=endDate    ${end_date}

Set Immediate Report
    [Documentation]    Set immediate report radio button

    Click Element    //*[@title="Immediate Report"]

Setup Report Options
    [Documentation]    Setup report options

    Set Immediate Report
    Set Start and End Date

Download and Check Report File
    [Documentation]    Download report and check if it will open with no issues

    Download Report File    ${report_name}    pdf
    Check for Valid PDF File

Check for Valid PDF File
    [Documentation]    Opens and closes the pdf file generated
    ...    filepath is a suite variable from Download Report File

    Open PDF Doc  ${filepath}
    Close PDF