*** Settings ***
Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.reports.PyExcel
Library  String
Library  OperatingSystem  WITH NAME  os
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot
Resource  ../../Variables/validUser.robot

Test Teardown    Close Browser
Suite Teardown    Disconnect From Database

Force Tags  eManager

*** Variables ***
${contract_id}
${carrier}
${express_code}
${code_id}
${db_mc_reason_desc}
${scheduled_report_desc}
${report_name}    IssuedMoneyCodesReport
${issue_to_default}    test
${reason_code_default}    1

*** Test Cases ***
Check Unused Voided Money Codes
    [Tags]  JIRA:BOT-146  JIRA:BOT-1758  JIRA:BOT-1990  refactor
    [Documentation]  Ensure that you can view voided unused money codes.
    [Setup]  Setup Variables and Start Connections

    Issue Money Codes to  R2D2
    Navigate to Money Code History
    Void Money Codes Issued To  R2D2
    Navigate To Issued Money Codes Report
    Generate Report Using Voided Money Codes
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Validate Report With Issued Money Codes  ${report_dictionary}  ${moneyCodes}

    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Reason Money Code in Report
    [Tags]  JIRA:BOT-4981    JIRA:FRNT-2089    JIRA:FRNT-2167    JIRA:BOT-4999    qTest:116286874
    [Documentation]  Ensure reason money code column is displayed in Issued Money Codes Report and is filled with
    ...    correct data

    Setup Carrier for Issued Money Codes Report
    Log Carrier into eManager with Issued Money Codes Report permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code    ${reason_code_default}
    Check Reason Money Code From Issued Money Code
    Go to Select Program > Reports/Exports > Issued Money Codes Report
    Open and Create Issued Money Codes Report
    Check Reason Code Description in Report
    Create Money Code Remaining Balance Scheduled Report
    Download Scheduled Report
    Check Reason Code Description in Report    True

*** Keywords ***
Setup Variables and Start Connections
    Get Into DB  TCH
#   CONTRACT ID IS ALL YOU NEED FROM THE CARRIER.
    Set Test Variable  ${contract_id}  3035
    ${carrier_id}  ${passwd}  Get Carrier Credentials With Contract
    Set Test Variable  ${carrier_id}
    Set Test Variable  ${passwd}

#   USE WEB SERVICE CALLS TO CREATE A MONEYCODE.
    Log Into Card Management Web Services  ${carrier_id}  ${passwd}
    Open eManager  ${carrier_id}  ${passwd}

Get Carrier Credentials With Contract
#    GET MEMBER ID AND PASSWORD FROM CARRIER
    ${query}  Catenate
    ...  select m.member_id, trim(m.passwd) as passwd
    ...  from member m, contract c
    ...  where c.carrier_id = m.member_id
    ...  and c.contract_id = ${contract_id}
    ${member}  Query And Strip to Dictionary  ${query}

    [Return]  ${member.member_id}  ${member.passwd}

Issue Money Codes to
    [Arguments]  ${issued_to}
    tch logging  Issue Money Codes
    @{moneyCodes}  Create List
    FOR  ${i}  IN RANGE  0  3
      ${mc}  Issue Money Code To  ${contract_id}  ${issued_to}
      ${moneyCode}  Create Dictionary  transfer_code=${mc}
      Append To List  ${moneyCodes}  ${moneyCode}
    END

    Set Test Variable  ${moneyCodes}

Issue Money Code To
    [Arguments]  ${contract_id}  ${issued_to}  ${amount}=0
    ${mc_amount}  Evaluate  random.randint(100,200)  modules=random
    ${amount}  set variable if  '${amount}'=='0'  ${mc_amount}
    ${mc}  issueMoneycode  ${contract_id}  ${amount}  ${issued_to}
    tch logging  Money Code ${mc} with value ${amount} Issued to ${issued_to}
    [Return]  ${mc}

Void Money Codes Issued To
    [Arguments]  ${issued_to}
    tch logging  Void Issued Money Codes
    ${today}  getdatetimenow  %Y-%m-%d
    ${Count}  Get Element Count  //table[@id="moneyCode"]//td[text()='${issued_to}']/parent::tr/td//input[@name="removeCard"]
    FOR  ${i}  IN RANGE  1  ${count}+1
#    After void a money code the screen is refreshed, because of this, we always will get the first item from the xpath pattern list
      Click Element  //table[@id="moneyCode"]//td[text()='${issued_to}']/parent::tr/td//input[@name="removeCard"][1]
      Click Element  voidMoneyCode
      Wait Until Element is Visible  startDate
      Input Text  name=startDate  ${today}
      Input Text  name=endDate  ${today}
      Click Element  lookupHistory
    END

Navigate to Money Code History
    go to  ${eManager}/cards/MoneyCodeManagement.action
    Click Element  history
    ${today}  getdatetimenow  %Y-%m-%d
    Wait Until Element is Visible  startDate
    Input Text  name=startDate  ${today}
    Input Text  name=endDate  ${today}
    Click Element  lookupHistory

Generate Report Using Voided Money Codes
    [Arguments]  ${report_type}=Excel
    tch logging  Generate Report Using Voided Money Codes
    ${today}  getdatetimenow  %Y-%m-%d
    Wait Until Element is Visible  startDate
    Input Text  name=startDate  ${today}
    Input Text  name=endDate  ${today}
    Select From List By Value  name=moneyCodeCategory  voidedOnly

    #Report Format
    Select From List by Label  viewFormat  ${report_type}

    #Download Report
    Click Element  viewReport
    Wait Until Element Is Visible  //a[text()='Click here to view the document']  timeout=40
    Click Element  //a[text()='Click here to view the document']
    ${extension}  Set Variable If  '${report_type}'=='Pdf'  pdf  xls
    os.Wait Until Created  ${default_download_path}${/}*${report_name}*${extension}

Navigate To Issued Money Codes Report
    go to  ${eManager}/cards/IssuedMoneyCodesReport.action
    Wait Until Element Is Visible  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Get Text  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Remove From String  ${SPACE}  ${name}
    ${report_name}  Get eManager Report Name  ${name}
    Set Test Variable  ${report_name}

Get Money Code Use Report Information
    [Arguments]  ${filePath}
    ${report_dictionary}  Get Values From Excel Rows  ${filePath}

#For now it is getting only Money Code Number, could be improved to validate more fields, I'm doing a simple patch maintaining same logic.
    FOR  ${i}  IN  @{report_dictionary}
      Remove From Dictionary  ${i}  id
      Remove From Dictionary  ${i}  unit_number
      Remove From Dictionary  ${i}  control_number
      Remove From Dictionary  ${i}  birthday
      Remove From Dictionary  ${i}  reefer_tempature
      Remove From Dictionary  ${i}  pin_number
      Remove From Dictionary  ${i}  subfleet
      Remove From Dictionary  ${i}  billing_id
      Remove From Dictionary  ${i}  first_inital
      Remove From Dictionary  ${i}  last_name
      Remove From Dictionary  ${i}  driver_name
      Remove From Dictionary  ${i}  ssn
      Remove From Dictionary  ${i}  original_amount
      Remove From Dictionary  ${i}  amount_used
      Remove From Dictionary  ${i}  remaining_balance
      Remove From Dictionary  ${i}  fee
      Remove From Dictionary  ${i}  currency
      Remove From Dictionary  ${i}  issued_to
      Remove From Dictionary  ${i}  issued_by
      Remove From Dictionary  ${i}  issue_type
      Remove From Dictionary  ${i}  issued_date
      Remove From Dictionary  ${i}  use_time
      Remove From Dictionary  ${i}  notes
      Remove From Dictionary  ${i}  contract_id
      Remove From Dictionary  ${i}  sub_contract
      Remove From Dictionary  ${i}  driver_license
      Remove From Dictionary  ${i}  driver_state
      Remove From Dictionary  ${i}  driver_id
      Remove From Dictionary  ${i}  hubometer
      Remove From Dictionary  ${i}  reefer_hours
      Remove From Dictionary  ${i}  license_state
      Remove From Dictionary  ${i}  license_number
      Remove From Dictionary  ${i}  odometer
      Remove From Dictionary  ${i}  po_number
      Remove From Dictionary  ${i}  trip_number
      Remove From Dictionary  ${i}  issue_type
      Remove From Dictionary  ${i}  trailer_numbe
    END

    Set Test Variable  ${report_dictionary}

Validate Report With Issued Money Codes
    [Arguments]  ${report_dictionary}  ${issued_dictionary}
    ${list_compare}  Compare List Dictionaries As Strings  ${issued_dictionary}  ${report_dictionary}
#    log to console  Report:${report_dictionary}
#    log to console  Issued:${issued_dictionary}
    Should Be True  ${list_compare}

Setup Carrier for Issued Money Codes Report
    [Documentation]  Keyword Setup Carrier for Issued Money Codes Report

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
    Add Issued Money Codes Report Permission to Carrier
    Add Money Code Reason List Permission to Carrier

Add Issued Money Codes Report Permission to Carrier
    [Documentation]    Give the carrier the Issued Money Codes Report permission

    Ensure Carrier has User Permission    ${carrier.id}    ISSUEDMONEYCODES_REPORT

Add Money Code Reason List Permission to Carrier
    [Documentation]    Give the carrier the money code reason list permission

    Ensure Carrier has User Permission    ${carrier.id}    MON_CODE_REASON

Log Carrier into eManager with Issued Money Codes Report permission
    [Documentation]  Log carrier into eManager with Issued Money Codes Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Money Codes > Issue Money Code
    [Documentation]  Go to Select Program > Money Codes > Issue Money Code

    Go To  ${emanager}/cards/MoneyCodeManagement.action
    Wait Until Page Contains    Money Code Information

Go to Select Program > Reports/Exports > Issued Money Codes Report
    [Documentation]  Go to Select Program > Money Codes > Issued Money Codes Report

    Go To  ${emanager}/cards/IssuedMoneyCodesReport.action
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

Open and Create Issued Money Codes Report
    [Documentation]  Opens Issued Money Codes Report with the recent issued money code and create a report

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
    [Arguments]    ${format}=PDF    ${frequency}=YEARLY    ${sort}=Code

    ${id}    Generate Random String    4
    Go to Select Program > Reports/Exports > Issued Money Codes Report
    Click Element    //*[@value="SCHEDULED"]
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