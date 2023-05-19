*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Test Setup  Setup Carrier for Money Code Remaining Balance Report
Test Teardown  Close Browser
Suite Teardown    Disconnect From Database

Force Tags  eManager

*** Variables ***
${carrier}
${express_code}
${code_id}
${db_mc_reason_desc}
${scheduled_report_desc}
${report_name}    MoneyCodeBalanceLeftReport
${issue_to_default}    test
${reason_code_default}    1

*** Test Cases ***
Reason Money Code in Report
    [Tags]    JIRA:FRNT-2089    JIRA:BOT-4981    JIRA:FRNT-2167    JIRA:BOT-4999    qTest:116286991
    [Documentation]  Ensure reason money code column is displayed in Money Code Remaining Balance Report and is filled
     ...    with correct data

    Log Carrier into eManager with Money Code Remaining Balance Report permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code    ${reason_code_default}
    Check Reason Money Code From Issued Money Code
    Go to Select Program > Reports/Exports > Money Code Remaining Balance Report
    Open and Create Money Code Remaining Balance Report
    Check Reason Code Description in Report
    Create Money Code Remaining Balance Scheduled Report
    Download Scheduled Report
    Check Reason Code Description in Report    True

*** Keywords ***
Setup Carrier for Money Code Remaining Balance Report
    [Documentation]  Keyword Setup Carrier for Money Code Remaining Balance Report

    Get Into DB  MySQL
    # Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]{6}$'
    ...    AND surx.role_id='MONEY_CODES'
    ...    AND surx.menu_visible=1
    ...    AND su.user_id NOT LIKE '134%'
    ...    AND su.user_id NOT LIKE '132%'
    ...    AND su.user_id NOT LIKE '600%'
    ...    AND su.user_id NOT IN ('100211', '103278')
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...    FROM member m
    ...    INNER JOIN contract c
    ...    ON m.member_id = c.carrier_id
    ...    INNER JOIN carrier_type_xref ctx
    ...    ON ctx.carrier_id = c.carrier_id
    ...    WHERE m.status = 'A'
    ...    AND c.status = 'A'
    ...    AND m.mem_type = 'C'
    ...    AND c.credit_limit > 0
    ...    AND c.daily_limit > 0
    ...    AND member_id IN ${carrier_list}
    ...    ORDER BY c.lastupdated DESC;
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}
    Add Money Code Remaining Balance Report Permission to Carrier
    Add Money Code Reason List Permission to Carrier

Add Money Code Remaining Balance Report Permission to Carrier
    [Documentation]    Give the carrier the money code remaining balance report permission

    Ensure Carrier has User Permission    ${carrier.id}    MONEYCODE_BALLEFE_REPORT

Add Money Code Reason List Permission to Carrier
    [Documentation]    Give the carrier the money code reason list permission

    Ensure Carrier has User Permission    ${carrier.id}    MON_CODE_REASON

Log Carrier into eManager with Money Code Remaining Balance Report permission
    [Documentation]  Log carrier into eManager with Money Code Remaining Balance Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Money Codes > Issue Money Code
    [Documentation]  Go to Select Program > Money Codes > Issue Money Code

    Go To  ${emanager}/cards/MoneyCodeManagement.action
    Wait Until Page Contains    Money Code Information

Go to Select Program > Reports/Exports > Money Code Remaining Balance Report
    [Documentation]  Go to Select Program > Money Codes > Money Code Remaining Balance Report

    Go To  ${emanager}/cards/MoneyCodeBalanceLeftReport.action
    Wait Until Page Contains    Select Schedule or Immediate Report

Go to Scheduled Recent Jobs
    [Documentation]  Go to recent jobs in Scheduled Jobs screen

    Go To  ${emanager}/cards/JobList.action
    Wait Until Page Contains Element    name=recentJobsButton
    Click Button    name=recentJobsButton

Issue Money Code
    [Documentation]  Issue a money code
    [Arguments]    ${reason_code}=1    ${amount}=5    ${info}=${issue_to_default}

    Wait Until Page Does Not Contain    Loading...
    Input Text    moneyCode.amount    ${amount}
    Input Text    moneyCode.issuedTo    ${info}
    Input Text    moneyCode.notes    ${info}
    Check and Input Text    infoValCLCD    ${info}
    Check and Input Text    infoValDMLC    ${info}
    Check and Input Text    infoValPDLN    ${info}
    Check and Input Text    infoValVHNB    ${info}
    Check and Input Text    infoValDRID    ${info}
    Check and Select Value    name=reasonCodeSel    ${reason_code}
    Click Button    submitId
    Wait Until Element is Visible    //*[@class="messages"]
    ${express_code}    Get Text    //*[@class="messages"]/li/b[1]
    ${code_id}    Get Text    //*[@class="messages"]/li/b[2]
    Set Test Variable    ${express_code}
    Set Test Variable    ${code_id}

Check and Input Text
    [Documentation]  Verify screen has the element and if it does it fills the text box with the value
    [Arguments]    ${path}    ${value}

    ${status}    Run Keyword and Return Status    Page Should Contain Element    ${path}
    Run Keyword If    '${status}'=='True'    Input Text    ${path}    ${value}

Check and Select Value
    [Documentation]  Verify screen has the element and if it does it selects the value
    [Arguments]    ${path}    ${value}

    ${status}    Run Keyword and Return Status    Page Should Contain Element    ${path}
    Run Keyword If    '${status}'=='True'    Select From List By Value    ${path}    ${value}

Check Reason Money Code From Issued Money Code
    [Documentation]    Assertion on reason money code list and gets its description to compare later
    [Arguments]    ${mon_code_reason}=1

    Get Into DB  TCH
    ${query}  Catenate  SELECT mon_code_reason_id
    ...    FROM mon_codes
    ...    WHERE code_id = '${code_id}'
    ...    AND express_code = '${express_code}';
    ${mon_code_reason_id}  Query And Strip    ${query}
    Should Be Equal as Numbers    ${mon_code_reason_id}    ${mon_code_reason}
    Get Reason Money Code Description from Database    ${mon_code_reason}

Get Reason Money Code Description from Database
    [Documentation]    Gets reason money code description from database
    [Arguments]    ${mon_code_reason}=1

    Get Into DB  TCH
    ${query}  Catenate  SELECT reason_desc
    ...    FROM mon_code_reason_list
    ...    WHERE reason_code = '${mon_code_reason}';
    ${db_mc_reason_desc}  Query And Strip    ${query}
    Set Test Variable    ${db_mc_reason_desc}

Open and Create Money Code Remaining Balance Report
    [Documentation]  Opens money code remaining balance report with the recent issued money code and create a report

    ${start_end_date}    Get Current Date    result_format=%Y-%m-%d
    Input Text    name=startDate    ${start_end_date}
    Input Text    name=endDate    ${start_end_date}
    Select From List By Label    name=viewFormat    PDF
    ${curr_date}    Get Report Date
    ${report_name}    Catenate    ${report_name}-${curr_date}
    Set Test Variable    ${report_name}
    Download Report File    ${report_name}    pdf

Get Report Date
    [Documentation]  Gets the date time for report name

    ${current_date_time}    Get Current Date    time_zone=UTC
    ${current_date_time}    Subtract Time From Date    ${current_date_time}    5 hours    %Y%m%d%H
    ${current_date_time}    Get Substring    ${current_date_time}    2
    [Return]    ${current_date_time}

Check Reason Code Description in Report
    [Arguments]    ${isScheduled}=False
    [Documentation]  Check the report has reason code info

    Find value in PDF    ${filepath}    Money Code
    Find value in PDF    ${filepath}    Reason
    Run Keyword If    '${isScheduled}'=='False'    Find value in PDF    ${filepath}    ${db_mc_reason_desc}
    Remove Report File    ${report_name}

Create Money Code Remaining Balance Scheduled Report
    [Documentation]  Create money code remaining balance scheduled report for issued money code and update its scheduled
     ...    time
    [Arguments]    ${format}=PDF    ${frequency}=YEARLY    ${sort}=Days Opened    ${currency}=USD/Gallons

    ${id}    Generate Random String    4
    Go to Select Program > Reports/Exports > Money Code Remaining Balance Report
    Click Element    //*[@value="SCHEDULED"]
    Select from list by label    name=currency    ${currency}
    Select from list by label    name=sortBy    ${sort}
    Select from list by label    name=viewFormat    ${format}
    Click Element    name=viewReport
    Wait Until Element is Visible    name=jobDescription
    Set Test Variable    ${scheduled_report_desc}    ${id}-${format}-${frequency}-${sort}
    ${scheduled_report_desc}    Get Substring    ${scheduled_report_desc}    0    29
    Input Text    name=jobDescription    ${scheduled_report_desc}
    Click Element    //*[@value="${frequency}"]
    Click Element    name=submitScheduledJob
    Wait Until Page Contains    You may also go to 'Scheduled Reports' from your menu to see the status of your report
    Go To  ${emanager}/cards/JobList.action
    Click Button    name=recentJobsButton
    ${status}    Run Keyword And Return Status    Page Should Contain Element    name=idSearchTxt2
    Run Keyword If    '${status}'=='True'    Input Text    name=idSearchTxt2    ${scheduled_report_desc}
    Wait Until Page Contains Element    //td[text()='${scheduled_report_desc}']
    ${job_id}    Get Value    //td[text()='${scheduled_report_desc}']/parent::tr//input[@name="jobId"]
    Update Job DateTime    ${job_id}

Update Job DateTime
    [Documentation]  Update scheduled report prop_value to current date to get it in the next routine run
    [Arguments]    ${job_id}

    Get Into DB  MySQL
    ${dt}    Get Current Date    result_format=%Y-%m-%d
    ${query1}  Catenate  update job_prop
    ...    set prop_value = '${dt} 00:00'
    ...    where job_id = '${job_id}'
    ...    and prop_name = 'nextRunDate:value';
    Execute SQL String    ${query1}
    ${query2}  Catenate  update job set scheduled_time = (
    ...    select prop_value
    ...    from job_prop where job_id = '${job_id}'
    ...    and prop_name = 'nextRunDate:value')
    ...    where job_id = '${job_id}';
    Execute SQL String    ${query2}

Download Scheduled Report
    [Documentation]  Download scheduled report from issued money code

    Go to Scheduled Recent Jobs
    Wait Until Keyword Succeeds    12x    22s
    ...    Refresh Jobs Page Until Download Is Available    ${scheduled_report_desc}
    Click Element    //td[text()='${scheduled_report_desc}']/parent::tr//img
    Wait Until Keyword Succeeds    3x    5s    Check if File is Dowloaded    ${report_name}    pdf

Refresh Jobs Page Until Download Is Available
    [Documentation]  Keeps refreshing the page until the schedule report is ready
    [Arguments]    ${job_desc}

    Click Element    name=refreshRecentJob
    ${status}    Run Keyword And Return Status    Page Should Contain Element    name=idSearchTxt2
    Run Keyword If    '${status}'=='True'    Input Text    name=idSearchTxt2    ${job_desc}
    Wait Until Page Contains Element    //td[text()='${job_desc}']
    Wait Until Element Is Visible    //td[text()='${job_desc}']/parent::tr//img    timeout=8