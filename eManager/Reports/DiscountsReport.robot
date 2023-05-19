*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup    Setup Carrier with Discounts Report permission
Test Teardown    Close Browser
Suite Teardown    Disconnect From Database

Force Tags  eManager  Reports

*** Variables ***
${carrier}
${email}

*** Test Cases ***
Discount Report/add a button for more search data
    [Tags]    Q2:2023    JIRA:ATLAS-2351    JIRA:BOT-5087    qTest:120125082
    [Documentation]    After save Discount Report a new row should display with information and this shouldn't take more
    ...    than a 2 seconds and testing More Records button to search for more data

    Log Carrier into eManager with Discounts Report permission
    Go to Select Program > Reports/Exports > Discounts Report
    Add new discount record
    Check for new record
    Check for new record in db
    Show more records
    Check for new record

    [Teardown]    Run Keywords    Delete new record    Close Browser

*** Keywords ***
Setup Carrier with Discounts Report permission
    [Documentation]    Get a carrier with Discounts Report permission

    Get Carrier ID and Password
    Ensure Carrier has User Permission    ${carrier.id}    DISCOUNTS_REPORT

Log Carrier into eManager with Discounts Report permission
    [Documentation]  Log carrier into eManager with Enhanced Transaction Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Reports/Exports > Discounts Report
    [Documentation]  Go to Select Program > Reports/Exports > Discounts Report

    Go To  ${emanager}/cards/DiscountsReport.action
    Wait Until Page Contains    Discounts Report

Add new discount record
    [Documentation]    Add a new discount record

    ${rand}    Generate Random String    5    [NUMBERS]
    ${email}    Catenate    test${rand}@mail.com
    Set Test Variable    ${email}
    Wait Until Element is Visible    name=email
    Input Text    name=email    ${email}
    Input Text    name=confirmEmail    ${email}
    Click Element    name=save
    Wait Until Element is Visible    //*[text()='Added Successfully!']    timeout=2

Check for new record
    [Documentation]    Check new discount record added

    Page Should Contain Element    //td[text()="${email}"]

Check for new record in db
    [Documentation]    Check new discount record in database in discount_report_parms table

    Get Into DB    TCH
    ${query}    Catenate    SELECT email_address
    ...    FROM discount_report_parms
    ...    WHERE carrier_id = '${carrier.id}'
    ...    ORDER BY request_time DESC
    ...    LIMIT 1;
    ${email_db}    Query And Strip    ${query}
    Should Be Equal as Strings    ${email_db}    ${email}

Show more records
    [Documentation]    Click to open more carrier discount records

    Click Element    name=moreRecords
    Wait Until Element is Visible    name=startDate
    Click Element    name=search
    Wait Until Page Contains    Discounts Report Information

Delete new record
    [Documentation]    Remove added discount record and check database

    Wait Until Element is Visible    //td[text()="${email}"]//parent::tr//input[@name="deleteMore"]
    Click Element    //td[text()="${email}"]//parent::tr//input[@name="deleteMore"]
    Handle Alert
    Wait Until Element is Visible    //*[text()='Deleted Successfully!']
    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM discount_report_parms
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND email_address = '${email}';
    Row Count is Equal to X    ${query}    0