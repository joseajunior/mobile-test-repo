*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.Models
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Teardown  Close Browser
Force Tags  eManager  Reports

*** Variables ***
${internalUser}    internRobot
${password}    testing123
${cardholder}    5567480010500427
${maskedcardnum}    556748******0427
${carrierid}    184272
${subuserid}    184272mf
${cashAdvanceReportName}    frnt1993 cash advance report
${smartfundsActReportName}    frnt1993 sf card act report
${retailTransReportName}    frnt1993 retail trans report

*** Test Cases ***
Setting Up The Scheduled Report
    [Tags]    JIRA:BOT-599  refactor
    [Documentation]  Scheduling a transaction report.


    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Go To  ${emanager}/cards/Transaction.action?outputMode=report
    Wait Until Page Contains Element  scheduleImmediateRadio  timeout=30
    Click Element  scheduleImmediateRadio
    Select From List By Value  currency  USD
    Click Element  allContract
    Select From List By Value  selectedContract  ${sec_contract}
    Select From List By Value  groupBy  Card Number
    Select From List By Value  sortBy  Card Number
    Select From List By Value  viewFormat  2   #PDF
    Click Element  transFilter.card.doFilter
    Click Button  lookUpCards
    select radio button  lookupInfoRadio  NUMBER
    Input Text  cardSearchTxt  7083050910386614885
    Click Button  searchCard
    Click Element  //table[@id="cardSummary"]//*[contains(text(), '7083050910386614885')]
    Click Button  viewReport
    Click Element  //*[@value="MONTHLY" and @name="jobFrequency"]
    Select From List By Value  startingPointMonthly  10
    ${id}  Generate Random String  3  [NUMBERS]
    Tch Logging  BOT-599_ScheduledReport_${id}
    Input Text  jobDescription   BOT-599_ScheduledReport_${id}
    Set Suite Variable  ${scheduled_report}  BOT-599_ScheduledReport_${id}
    Click Element  emailAddressShow
    Input Text  emailAddress  efswex-efs.testers@wexinc.com
    Click Button  submitScheduledJob

    Page Should Contain Element  //form[@method="post" and @action="/cards/Job.action"]
    ${successfulMsg}  get text  //form[@method="post" and @action="/cards/Job.action"]
    Tch Logging  ${successfulMsg}

    Go To  ${emanager}/cards/JobList.action
    ${status}  Run Keyword And Return Status  Page Should Contain Element  //table[@id="scheduledJob"]//*[contains(text(), '${scheduled_report}')]

    Run Keyword IF  '${status}'=='${false}'  Check Other Pages  scheduledJob
    ...  ELSE  Tch Logging  Page Contains ${scheduled_report}

Edit Scheduled Reports
    [Tags]  JIRA:BOT-620  refactor
    [Documentation]  Verifying that you can edit the scheduled job report.

    Set Test Variable  ${EditMessage}  You have successfully Edited the Name (Transaction Report), Description (${scheduled_report})

    Go To  ${emanager}/cards/JobList.action

    ${status}  Run Keyword And Return Status  Page Should Contain Element  //table[@id="scheduledJob"]//*[contains(text(), '${scheduled_report}')]

    Run Keyword IF  '${status}'=='${false}'  Check Other Pages  scheduledJob
    ...  ELSE  Tch Logging  Editing Scheduled Report ${scheduled_report}

    Click Element  //table[@id="scheduledJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[7]
    Click Element  //*[@value="DAILY" and @name="jobFrequency"]
    Click Button  saveJob
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(),'You have successfully')]
    ${message}  get text  //*[@class="messages"]//*[contains(text(),'You have successfully')]

    Should Start With  ${message}  ${EditMessage}

Looking at the Scheduled Reports
    [Tags]  JIRA:BOT-641  refactor
    [Documentation]  It must be possible to download a completed Scheduled Report.

    Go To  ${emanager}/cards/JobList.action

    ${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@id="scheduledJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[7]/form/input[6]
    Run Keyword IF  '${status}'=='${false}'  Check Other Pages  scheduledJob
    ...  ELSE  Tch Logging  Get Job Id Value

    ${job_id}  Get Value  //*[@id="scheduledJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[7]/form/input[6]
    Set Suite Variable  ${job_id}
    Tch Logging  \n JOB_ID:${job_id}
    Tch Logging  Updating tables on MYSQL

    Get Into DB  MYSQL
    execute sql string  dml=update job_prop SET prop_value = now() WHERE job_id = '${job_id}' AND prop_name = 'nextRunDate:value';
    execute sql string  dml=update job SET scheduled_time = (SELECT prop_value FROM job_prop where job_id = '${job_id}' AND prop_name = 'nextRunDate:value') WHERE job_id = '${job_id}';

    Wait Until Keyword Succeeds  300 sec  10 sec  Check Scheduled Job Status on Database  ${job_id}
    Click Element  refresh
    Execute JavaScript  window.scrollTo(0,5000)

    ${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@id="recentJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[6]

    Run Keyword IF  '${status}'=='${false}'  Check Other Pages  recentJob
    ...  ELSE  Tch Logging  Download the report

    Click Element  //*[@id="recentJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[6]
    Tch Logging  File Downloaded

Delete Scheduled Reports
    [Tags]  JIRA:BOT-477  refactor
    [Documentation]  Being able to delete the scheduled report.
    ...  OTR-439 - Scheduled Jobs being deleted by the deletion of Recent Jobs
    ...  If a user deletes a Recent Job, which is also saved as a Scheduled Job, the Scheduled Job is also deleted.
    ...  To fix, we need to remove the 'Delete' option under Recent Jobs

    Go To  ${emanager}/cards/JobList.action

    ${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@id="recentJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[8]

    Run Keyword IF  '${status}'=='${false}'  Check Other Pages  recentJob
    ...  ELSE  Tch Logging  Deleting Scheduled Report ${scheduled_report}

#    NOW IN ORDER TO DELETE A COMPLETE SCHEDULED REPORT YOU HAVE TO RE-RUN IT SO IT GOES BACK TO THE SCHEDULED JOBS TABLE AND THEN YOU CAN DELETE IT
    Click Element  //*[@id="recentJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[7]     #CLICKING ON RE-RUN
    ${status}  Run Keyword And Return Status  Page Should Contain Element  //table[@id="scheduledJob"]//*[contains(text(), '${scheduled_report}')]

    Run Keyword IF  '${status}'=='${false}'  Check Other Pages  scheduledJob
    ...  ELSE  Tch Logging  Page Contains ${scheduled_report}

    Click Element  //table[@id="scheduledJob"]//*[contains(text(), '${scheduled_report}')]/parent::tr/td[8]
    Handle Alert
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(),'Job Successfully Deleted.')]

    [Teardown]  Close Browser

Mastercard number not fully displayed as submitter
    [Tags]  JIRA:BOT-3656  JIRA:FRNT-1993  qTest:55533871
    [Documentation]  Ensure mastercard number is not displayed entirely in schedule report submitter column
    [Setup]    Setup for FRNT-1993    Enabled

    Login to eManager with the cardholder
    Go to Cash Advance Report
    Create Cash Advance Report
    Go to Retail Transaction Report
    Create Retail Transaction Report
    Go to SmartFunds Card Activity Report
    Create SmartFunds Card Activity Report
    Assert Reports Created with Masked Card Number Submitter
    Login to eManager with the carrier
    Assert Reports Created with Masked Card Number Submitter
    Login to eManager with the subuser
    Assert Reports Created with Masked Card Number Submitter

    [Teardown]    Clean Up Scheduled Reports Data Created

Mastercard number fully displayed as submitter for flag off
    [Tags]  JIRA:BOT-3656  JIRA:FRNT-1993  qTest:55638901
    [Documentation]  Ensure mastercard number is displayed entirely in schedule report submitter column when feature flag is off
    [Setup]    Setup for FRNT-1993    Disabled

    Login to eManager with the cardholder
    Go to Cash Advance Report
    Create Cash Advance Report
    Go to Retail Transaction Report
    Create Retail Transaction Report
    Go to SmartFunds Card Activity Report
    Create SmartFunds Card Activity Report
    Assert Reports Created with Masked Card Number Submitter    False
    Login to eManager with the carrier
    Assert Reports Created with Masked Card Number Submitter    False
    Login to eManager with the subuser
    Assert Reports Created with Masked Card Number Submitter    False

    [Teardown]    Clean Up Scheduled Reports Data Created    False

*** Keywords ***
Check Other Pages
    [Arguments]  ${table}

    FOR  ${i}  IN RANGE  2  20
       Page Should Contain Element  //*[@id="${table}"]
       Click Element  //table[@id="${table}"]//preceding::*[@title="Go to page ${i}"][1]
       ${status}  Run Keyword And Return Status  Page Should Contain Element  //*[@id="${table}"]//*[contains(text(),"${scheduled_report}")]
       Run Keyword IF  '${status}'=='${True}'  Exit For Loop
    END

Check Scheduled Job Status on Database
    [Arguments]  ${job_id}

    Get Into DB  MySQL
    ${query}  Catenate  SELECT status
    ...  FROM job
    ...  WHERE job_id = '${job_id}'
    ${status}  Query and Strip  ${query}
    Should be Equal  ${status}  COMPLETE

Setup for FRNT-1993 Flag
    [Arguments]    ${flag}
    [Documentation]  Ensure the feature flag is set for FRNT-1993

    Get Into DB    MYSQL
    ${select_query}  Catenate  SELECT * FROM teslsm.setting WHERE `partition` IN ('shared') AND name IN ('FLAG_OTREPIC-3575_1993');
    ${select_query_result}  Query And Strip To Dictionary  ${select_query}
    ${amount}    Get Length    ${select_query_result}
    ${option}    Run Keyword If    '${flag}'=='Enabled'    Set Variable    Y    ELSE    Set Variable    N
    ${insert_query}  Catenate  INSERT INTO setting (`partition`,`name`,`value`) VALUES ('shared','FLAG_OTREPIC-3575_1993','${option}');
    ${update_query}  Catenate  UPDATE setting SET value = '${option}' WHERE `PARTITION` = 'shared' AND name = 'FLAG_OTREPIC-3575_1993';
    Run Keyword If    ${amount}==0    Execute SQL String  ${insert_query}    ELSE    Execute SQL String  ${update_query}

Setup for FRNT-1993
    [Arguments]    ${flag}=Enabled

    Setup for FRNT-1993 Flag    ${flag}
    Open eManager    ${internalUser}    ${password}

Login to eManager with the cardholder
    [Documentation]  Login to eManager with the cardholder set

    Search and Work as User    ${cardholder}

Login to eManager with the carrier
    [Documentation]  Login to eManager with the carrier set

    Search and Work as User    ${carrierid}

Login to eManager with the subuser
    [Documentation]  Login to eManager with the subuser set

    Search and Work as User    ${subuserid}

Search and Work as User
    [Documentation]  Using Customer Info Test login to eManager with the target user
    [Arguments]    ${user}

    Go to Customer Info Test
    Run Keyword And Ignore Error    Click Element    name=ClearCustomers
    Wait Until Page Contains Element    name=searchValue
    Input Text    name=searchValue    ${user}
    Click Element    name=SearchCustomers
    Wait Until Page Contains Element    //table[@id="searchCustomerTable"]//a[text()='${user}']
    Click Element    //table[@id="searchCustomerTable"]//a[text()='${user}']
    Wait Until Page Contains    Working as:

Go to Target Screen
    [Documentation]  General keyword to go to a given screen and check if it has loaded with an element from it
    [Arguments]    ${path}    ${element}

    Go To  ${emanager}${path}
    Wait Until Page Contains Element    ${element}

Go to Customer Info Test
    [Documentation]  Go to Select Program > Customer Info Test

    Go to Target Screen    /security/ManageCustomers.action    name=SearchCustomers

Go to Schedule Reports
    [Documentation]  Go to Select Program > Schedule Reports

    Go to Target Screen    /cards/JobList.action    name=refresh

Go to Cash Advance Report
    [Documentation]  Go to Select Program > Reports/Exports > Cash Advance Report

    Go to Target Screen    /cards/CashAdvanceReport.action    name=viewReport

Go to Retail Transaction Report
    [Documentation]  Go to Select Program > Reports/Exports > Retail Transaction Report

    Go to Target Screen    /cards/TransactionRetail.action?outputMode=report    name=viewReport

Go to SmartFunds Card Activity Report
    [Documentation]  Go to Select Program > Smartfunds > SmartFunds Card Activity Report

    Go to Target Screen    /cards/SmartPayRollCashAdvanceReport.action?am=SMARTPAY_ACTIVITY_REPORT    name=submit

Create Cash Advance Report
    [Documentation]  Create a scheduled Cash Advance Report with its own card number

    Click Element    name=scheduleImmediateRadio
    Input Text    name=displayNumber    ${cardholder}
    Click Element    name=viewReport
    Wait Until Element is Visible    name=jobDescription
    Input Text    name=jobDescription    ${cashAdvanceReportName}
    Click Element    name=submitScheduledJob
    Wait Until Page Contains    You may also go to 'Scheduled Reports' from your menu to see the status of your report

Create Retail Transaction Report
    [Documentation]  Create a scheduled Retail Transaction report

    Click Element    name=scheduleImmediateRadio
    Click Element    name=viewReport
    Wait Until Element is Visible    name=jobDescription
    Input Text    name=jobDescription    ${retailTransReportName}
    Click Element    name=submitScheduledJob
    Wait Until Page Contains    You may also go to 'Scheduled Reports' from your menu to see the status of your report

Create SmartFunds Card Activity Report
    [Documentation]  Create a scheduled SmartFunds Card Activity report with its own card number

    Click Element    name=scheduleImmediateRadio
    Click Element    name=submit
    Wait Until Element is Visible    name=jobDescription
    Input Text    name=jobDescription    ${smartfundsActReportName}
    Click Element    name=submitScheduledJob
    Wait Until Page Contains    You may also go to 'Scheduled Reports' from your menu to see the status of your report

Filter Report by Name
    [Documentation]  Filter the report with its name
    [Arguments]    ${reportname}    ${filterpath}    ${xpath}

    Input Text    ${filterpath}    ${reportname}
    Wait Until Page Contains Element    ${xpath}

Search Report
    [Documentation]  Search for a given report name considering if it's scheduled jobs or recent jobs screen
    [Arguments]    ${reportname}    ${xpath}    ${isScheduleJobs}=True

    ${filterpath}    Run Keyword If    '${isScheduleJobs}'=='True'    Set Variable    id=idSearchTxt1    ELSE    Set Variable    id=idSearchTxt2
    ${hasFilter}    Run Keyword and Return Status    Page Should Contain Element    ${filterpath}
    Run Keyword If    '${hasFilter}'=='True'    Filter Report by Name    ${reportname}    ${filterpath}    ${xpath}

Assert Submitter in Schedule Reports for Report
    [Documentation]  Check if the report has the mastercard cardholder submitter masked
    [Arguments]    ${reportname}    ${isFlagEnabled}    ${isScheduleJobs}=True

    ${cardnum}    Run Keyword If    '${isFlagEnabled}'=='True'    Set Variable    ${maskedcardnum}    ELSE    Set Variable    ${cardholder}
    ${xpath}    Run Keyword If    '${isScheduleJobs}'=='True'    Set Variable    //table[@id="scheduledJob"]//label[contains(text(),"${reportname}")]/parent::td/following-sibling::td/label[contains(text(), '${cardnum}')]
    ...    ELSE    Set Variable    //table[@id="recentJob"]//td[contains(text(),"${reportname}")]/parent::tr//td[contains(text(), '${cardnum}')]
    Run Keyword If    '${isScheduleJobs}'=='True'    Wait Until Page Contains Element    name=refresh    ELSE    Wait Until Page Contains Element    name=refreshRecentJob
    Search Report    ${reportname}    ${xpath}    ${isScheduleJobs}
    Page Should Contain Element    ${xpath}

Assert Reports Created with Masked Card Number Submitter
    [Arguments]    ${isFlagEnabled}=True
    [Documentation]  Check the masked card number as submitter for mastercard cardholder reports in Scheduled Jobs and Recent Jobs screen

    Go to Schedule Reports
    Assert Submitter in Schedule Reports for Report    ${retailTransReportName}    ${isFlagEnabled}
    Assert Submitter in Schedule Reports for Report    ${cashAdvanceReportName}    ${isFlagEnabled}
    Assert Submitter in Schedule Reports for Report    ${smartfundsActReportName}    ${isFlagEnabled}
    Click Element    name=recentJobsButton
    Assert Submitter in Schedule Reports for Report    ${retailTransReportName}     ${isFlagEnabled}    False
    Assert Submitter in Schedule Reports for Report    ${cashAdvanceReportName}     ${isFlagEnabled}    False
    Assert Submitter in Schedule Reports for Report    ${smartfundsActReportName}     ${isFlagEnabled}    False

Delete Schedule Report
    [Documentation]  Delete an scheduled report by its name
    [Arguments]    ${reportname}    ${isFlagEnabled}

    ${cardnum}    Run Keyword If    '${isFlagEnabled}'=='True'    Set Variable    ${maskedcardnum}    ELSE    Set Variable    ${cardholder}
    ${xpath}    Set Variable    //table[@id="scheduledJob"]//label[contains(text(),"${reportname}")]/parent::td/following-sibling::td/label[contains(text(), '${cardnum}')]
    Search Report    ${reportname}    ${xpath}
    Wait Until Page Contains Element    ${xpath}
    Click Element    //table[@id="scheduledJob"]//label[contains(text(),"${reportname}")]/parent::td/parent::tr//input[@name="deleteJob"]
    Handle Alert
    Wait Until Page Does Not Contain Element    ${xpath}
    Page Should Contain    Job Successfully Deleted.

Clean Up Scheduled Reports Data Created
    [Arguments]    ${isFlagEnabled}=True
    [Documentation]  Clean up reports data created

    Go to Schedule Reports
    Delete Schedule Report    ${retailTransReportName}    ${isFlagEnabled}
    Delete Schedule Report    ${cashAdvanceReportName}    ${isFlagEnabled}
    Delete Schedule Report    ${smartfundsActReportName}    ${isFlagEnabled}
    Close Browser