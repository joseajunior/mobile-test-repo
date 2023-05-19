*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Force Tags  eManager    Reports

Test Teardown    Run Keywords    Log Out of Emanager    Close Browser    Remove SmartFunds Card Activity Report
Suite Teardown    Disconnect from Database

*** Variables ***
${carrier}
${card_num}
${memo}
${report_name}    PayrollCashAdvanceReport

*** Test Cases ***
Check merchant infos source in report for mastercard
    [Tags]    JIRA:ATLAS-2306    JIRA:BOT-5047    qTest:119068572    PI:15
    [Documentation]    Ensure merchant infos are from iso_memos table and not mcfleet_memos table for mastercard
    [Setup]    Run Keywords    Setup Mastercard Number and Carrier    Setup Memo Data
    ...    Add SmartFunds Card Activity Report Permission to Carrier

    Login to eManager with Carrier
    Go To Select Program > Reports/Exports > SmartFunds Card Activity Report
    Select Immediate Report
    Set the start and end date as the memo date
    Fill in the mastercad number
    Select PDF as report format
    Download SmartFunds Card Activity Report in 'pdf'
    Check iso_memos merchant name and city are in report
    Check mcfleet_memos merchant name and city are not in report
    Check show on report value P

*** Keywords ***
Setup Mastercard Number and Carrier
    [Documentation]    Setup mastercard number and carrier info

    Get Into DB    TCH
    ${query}    Catenate    SELECT TRIM(card_num) as card_num, carrier_id, TRIM(passwd) as passwd
    ...    FROM cards c
    ...    JOIN member m
    ...    ON m.member_id = c.carrier_id
    ...    WHERE c.card_num LIKE '5%'
    ...    AND c.card_num NOT LIKE '%OVER'
    ...    AND c.card_num IN (SELECT card_num
    ...      FROM iso_memos
    ...      WHERE post_date IS NULL
    ...      AND never_cleared_date IS NULL
    ...      AND memo_date IS NOT NULL)
    ...    ORDER BY c.carrier_id
    ...    LIMIT 1;
    ${query_result}    Query And Strip to Dictionary    ${query}
    ${carrier}    Create Dictionary    id=${query_result["carrier_id"]}    password=${query_result["passwd"]}
    Set Test Variable    ${carrier}
    Set Test Variable    ${card_num}    ${query_result["card_num"]}

Setup Memo Data
    [Documentation]    Get memo id and date

    Get Into DB    TCH
    ${query}    Catenate    SELECT memo_id, memo_date
    ...    FROM iso_memos
    ...    WHERE card_num = '${card_num}'
    ...    AND post_date IS NULL
    ...    AND never_cleared_date IS NULL
    ...    AND memo_date IS NOT NULL
    ...    LIMIT 1;
    ${query_result}    Query And Strip to Dictionary    ${query}
    ${memo_date}    Convert Date    ${query_result["memo_date"]}    result_format=%Y-%m-%d
    ${memo}    Create Dictionary    id=${query_result["memo_id"]}    date=${memo_date}
    Set Test Variable    ${memo}
    ${query}    Catenate    SELECT mc.merc_name as merc_name, mc.merc_city as merc_city,
     ...    im.merc_name as exp_merc_name, im.merc_city as exp_merc_city
    ...    FROM iso_memos im
    ...    JOIN mcfleet_memos mc
    ...    ON im.memo_id = mc.memo_id
    ...    WHERE mc.memo_id = '${memo.id}'
    ...    LIMIT 1;
    ${query_result}    Query And Strip to Dictionary    ${query}
    ${merchant_iso_memos}    Create Dictionary    name=${query_result["exp_merc_name"]}
    ...    city=${query_result["exp_merc_city"]}
    ${merchant_mcfleet_memos}    Create Dictionary    name=${query_result["merc_name"]}
    ...    city=${query_result["merc_city"]}
    Set Test Variable    ${merchant_iso_memos}
    Set Test Variable    ${merchant_mcfleet_memos}

Add SmartFunds Card Activity Report Permission to Carrier
    [Documentation]    Give the carrier the SmartFunds Card Activity Report permission

    Ensure Carrier has User Permission    ${carrier.id}    SMART_PAYROLL_CASH_ADVANCE_RPT

Login to eManager with Carrier
    [Documentation]    Login to eManager with carrier set

    Open eManager    ${carrier.id}    ${carrier.password}

Go To Select Program > Reports/Exports > SmartFunds Card Activity Report
    [Documentation]    Go To Select Program > Reports/Exports > SmartFunds Card Activity Report

    Go To    ${emanager}/cards/SmartPayRollCashAdvanceReport.action
    Wait Until Element is Visible    name=submit

Select Immediate Report
    [Documentation]    Select option for immediate report in setup

    Click Element    //*[@name='scheduleImmediateRadio' and @value='IMMEDIATE']

Set the start and end date as the memo date
    [Documentation]    Set the start and end date as the memo date

    Input Text    name=startDate    ${memo.date}
    Input Text    name=endDate    ${memo.date}

Fill in the mastercad number
    [Documentation]    Fill the card number field with the mastercard

    Input Text    name=displayNumber    ${card_num}

Select PDF as report format
    [Documentation]    Select PDF as report format

    Select From List By Label    name=viewFormat    PDF

Click to submit
    [Documentation]    Click to submit report

    Click Element    //*[@name='submit']

Download SmartFunds Card Activity Report in '${format}'
    [Documentation]    Download SmartFunds Card Activity report in given format

    Download Report File    ${report_name}    ${format}

Check iso_memos merchant name and city are in report
    [Documentation]    Check merchant info source is iso_memos table

    Find value in PDF    ${filepath}    ${merchant_iso_memos.name}
    Find value in PDF    ${filepath}    ${merchant_iso_memos.city}

Check mcfleet_memos merchant name and city are not in report
    [Documentation]    Check merchant info source is not mcfleet_memos

    Run Keyword and Expect Error    Could not get length of 'None'.
    ...    Find value in PDF    ${filepath}    ${merchant_mcfleet_memos.name}
    Close PDF
    Run Keyword and Expect Error    Could not get length of 'None'.
    ...    Find value in PDF    ${filepath}    ${merchant_mcfleet_memos.city}
    Close PDF

Check show on report value P
    [Documentation]    Check if there is a record with show_on_report 'P' in payr_cash_adv table

    Get Into DB    TCH
    ${query}    Catenate    SELECT * FROM payr_cash_adv WHERE ref_num = '${memo.id}' AND show_on_report = 'P';
    Row Count Is Equal to X    ${query}    1

Remove SmartFunds Card Activity Report
    [Documentation]    Remove SmartFunds Card Activity Report

    Close PDF
    Remove Report File  ${report_name}