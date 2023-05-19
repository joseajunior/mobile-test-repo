*** Settings ***
Documentation
...  Intent: This suite covers strictly the Card Status Report in eManager. The report is downloaded and the content
...  is validated in all formats.

Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
#Library  otr_robot_lib.reports.pyExcel
Library  String
#Library  otr_robot_lib.ftp.PyFTP.FTPLibrary
Library  otr_model_lib.Models
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot
Resource  ../../Variables/validUser.robot


Suite Setup  Start Suite
Suite Teardown  Turn ON Excel Report Flag to xls/xlsx

Force Tags    Reports  Card Status Report  eManager

*** Variables ***
${excelFile}
${card}
${carrier}
${child_card}
${child_carrier}
${card_status}
${permission_status}
${jobDescription}
${report_name}  CardStatusReport
${report_format}
${ftp_report}

*** Test Cases ***

Load Report (Immediate) Without Match By Options (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538250  Regression  qTest:31327637  tier:0
    [Documentation]  Load Card Status Report Without Match By Options (Excel) - File download validation only

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Report Format  Excel
    Download Excel Report File;
    Verify if Excel Report is Downloaded;

    [Teardown]  Teardown for BOT-1074

Load Report (Immediate) Without Match By Options (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538257  Regression
    [Documentation]  Load Card Status Report Without Match By Options (PDF) - File download validation only

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Report Format  PDF
    Download PDF Report File;
    Verify if PDF Report is Downloaded;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Active (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538261  Regression
    [Documentation]  Load and validade Report Using Match By Active (Excel)
    [Setup]  Change Card Status To  Active

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Active
    Select Report Format  Excel
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Inactive (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538261  Regression
    [Documentation]  Load and validade Report Using Match By Inactive (Excel)
    [Setup]  Change Card Status To  Inactive

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Inactive
    Select Report Format  Excel
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Hold (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538261  qTest:32172040  Regression
    [Documentation]  Load and validade Report Using Match By Hold (Excel)
    [Setup]  Change Card Status To  Hold

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Hold
    Select Report Format  Excel
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Deleted (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538261  Regression
    [Documentation]  Load and validade Report Using Match By Deleted (Excel)
    [Setup]  Change Card Status To  Deleted

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Deleted
    Select Report Format  Excel
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Follows (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538261  Regression
    [Documentation]  Load and validade Report Using Match By Follows (Excel)
    [Setup]  Change Card Status To  Follows

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Follows
    Select Report Format  Excel
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Hold For Fraud (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538261  Regression
    [Documentation]  Load and validade Report Using Match By Hold For Fraud (Excel)
    [Setup]  Change Card Status To  U  #Hold For Fraud

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Hold For Fraud
    Select Report Format  Excel
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Active (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538266  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Active (PDF)

    set test variable  ${CARRIER}  303274
    switch browser  StatusReport


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Active
    Select From List By label  viewFormat  PDF

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CARRIER}  A

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Inactive (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538266  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Inactive (PDF)

    set test variable  ${CARRIER}  303274
    switch browser  StatusReport

    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Inactive
    Select From List By label  viewFormat  PDF

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CARRIER}  I

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Hold (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538266  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Hold (PDF)

    set test variable  ${CARRIER}  303274
    switch browser  StatusReport

    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold
    Select From List By label  viewFormat  PDF

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CARRIER}  H

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Deleted (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538266  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Deleted (PDF)

    set test variable  ${CARRIER}  303274
    switch browser  StatusReport

    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Deleted
    Select From List By label  viewFormat  PDF

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CARRIER}  D

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Follows (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538266  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Follows (PDF)

    set test variable  ${CARRIER}  303274
    switch browser  StatusReport

    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Follows
    Select From List By label  viewFormat  PDF

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CARRIER}  F

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Hold For Fraud (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538266  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Hold For Fraud (PDF)

    set test variable  ${CARRIER}  303274
    switch browser  StatusReport

    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold For Fraud
    Select From List By label  viewFormat  PDF

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CARRIER}  U

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}


Load and Validate Report (Immediate) Match By Active - ALL Child carriers (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538272  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Active and ALL child option (Excel)
    [Setup]  Change Child Card Status To  Active

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Active
    Select Report Format  Excel
    Select Filter All Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For All Childs Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Inactive - ALL Child carriers (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538272  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Inactive and ALL child option (Excel)
    [Setup]  Change Child Card Status To  Inactive

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Inactive
    Select Report Format  Excel
    Select Filter All Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For All Childs Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Hold - ALL Child carriers (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538272  Regression  refactor
    [Documentation]  Load and validade Report Using Match By HOLD and ALL child option (Excel)
    [Setup]  Change Child Card Status To  Hold

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Hold
    Select Report Format  Excel
    Select Filter All Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For All Childs Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Deleted - ALL Child carriers (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538272  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Deleted and ALL child option (Excel)
    [Setup]  Change Child Card Status To  Deleted

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Deleted
    Select Report Format  Excel
    Select Filter All Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For All Childs Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Follows - ALL Child carriers (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538272  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Follows and ALL child option (Excel)
    [Setup]  Change Child Card Status To  Follows

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Follows
    Select Report Format  Excel
    Select Filter All Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For All Childs Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Hold For Fraud - ALL Child carriers (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538272  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Hold For Fraud and ALL child option (Excel)
    [Setup]  Change Child Card Status To  U  #Hold for Fraud

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Hold For Fraud
    Select Report Format  Excel
    Select Filter All Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For All Childs Option;

    [Teardown]  Teardown for BOT-1074


Load and Validate Report (Immediate) Match By Active - ALL Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538276  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Active and ALL child option (PDF)

    set test variable  ${CARRIER}  303268
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Active
    Select From List By label  viewFormat  PDF
    Select Checkbox  parentCarrierIdDoFilter

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a parent with status  ${CARRIER}  A

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Inactive - ALL Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538276  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Inactive and ALL child option (PDF)

    set test variable  ${CARRIER}  303268
    switch browser  StatusReportALLChild

    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Inactive
    Select From List By label  viewFormat  PDF
    Select Checkbox  parentCarrierIdDoFilter

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a parent with status  ${CARRIER}  I

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Hold - ALL Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538276  Regression  refactor
    [Documentation]  Load and validade Report Using Match By HOLD and ALL child option (PDF)

    set test variable  ${CARRIER}  303268
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold
    Select From List By label  viewFormat  PDF
    Select Checkbox  parentCarrierIdDoFilter

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a parent with status  ${CARRIER}  H

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Deleted - ALL Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538276  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Deleted and ALL child option (PDF)

    set test variable  ${CARRIER}  303268
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Deleted
    Select From List By label  viewFormat  PDF
    Select Checkbox  parentCarrierIdDoFilter

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a parent with status  ${CARRIER}  D

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Follows - ALL Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538276  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Follows and ALL child option (PDF)

    set test variable  ${CARRIER}  303268
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Follows
    Select From List By label  viewFormat  PDF
    Select Checkbox  parentCarrierIdDoFilter

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a parent with status  ${CARRIER}  F

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Hold For Fraud - ALL Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538276  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Hold For Fraud and ALL child option (PDF)

    set test variable  ${CARRIER}  303268
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold For Fraud
    Select From List By label  viewFormat  PDF
    Select Checkbox  parentCarrierIdDoFilter

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a parent with status  ${CARRIER}  U

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}


Load and Validate Report (Immediate) Match By Active - One Child (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538279  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Active and One child option (Excel)
    [Setup]  Change Child Card Status To  Active

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Active
    Select Report Format  Excel
    Select Filter and Input Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Inactive - One Child (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538279  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Inactive and One child option (Excel)
    [Setup]  Change Child Card Status To  Inactive

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Inactive
    Select Report Format  Excel
    Select Filter and Input Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Hold - One Child (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538279  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Hold and One child option (Excel)
    [Setup]  Change Child Card Status To  Hold

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Hold
    Select Report Format  Excel
    Select Filter and Input Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Deleted - One Child (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538279  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Deleted and One child option (Excel)
    [Setup]  Change Child Card Status To  Deleted

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Deleted
    Select Report Format  Excel
    Select Filter and Input Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Follows - One Child (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538279  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Follows and One child option (Excel)
    [Setup]  Change Child Card Status To  Follows

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Follows
    Select Report Format  Excel
    Select Filter and Input Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1074

Load and Validate Report (Immediate) Match By Hold For Fraud - One Child (Excel)
    [Tags]  JIRA:BOT-1074  qTest:29538279  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Hold For Fraud and One child option (Excel)
    [Setup]  Change Child Card Status To  U  #Hold For Fraud

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select Immediate Report;
    Select Match by Card Status Hold For Fraud
    Select Report Format  Excel
    Select Filter and Input Child Carrier;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Compare Excel File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1074


Load and Validate Report (Immediate) Match By Active - One Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538282  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Active and One child option (PDF)

    set test variable  ${CARRIER}  303268
    set test variable  ${CHILD_CARRIER}  303274
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Active
    Select From List By label  viewFormat  PDF
    Select Checkbox  childCarrierDoFilter
    input text  childCarrier  ${CHILD_CARRIER}

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CHILD_CARRIER}  A

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Inactive - One Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538282  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Inactive and One child option (PDF)

    set test variable  ${CARRIER}  303268
    set test variable  ${CHILD_CARRIER}  303274
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Inactive
    Select From List By label  viewFormat  PDF
    Select Checkbox  childCarrierDoFilter
    input text  childCarrier  ${CHILD_CARRIER}

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CHILD_CARRIER}  I

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Hold - One Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538282  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Hold and One child option (PDF)

    set test variable  ${CARRIER}  303268
    set test variable  ${CHILD_CARRIER}  303274
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold
    Select From List By label  viewFormat  PDF
    Select Checkbox  childCarrierDoFilter
    input text  childCarrier  ${CHILD_CARRIER}

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CHILD_CARRIER}  H

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Deleted - One Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538282  Regression  refactor
    [Documentation]  Load and validade Report Using Match By Deleted and One child option (PDF)

    set test variable  ${CARRIER}  303268
    set test variable  ${CHILD_CARRIER}  303274
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Deleted
    Select From List By label  viewFormat  PDF
    Select Checkbox  childCarrierDoFilter
    input text  childCarrier  ${CHILD_CARRIER}

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CHILD_CARRIER}  D

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Follows - One Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538282  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Follows and One child option (PDF)

    set test variable  ${CARRIER}  303268
    set test variable  ${CHILD_CARRIER}  303274
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Follows
    Select From List By label  viewFormat  PDF
    Select Checkbox  childCarrierDoFilter
    input text  childCarrier  ${CHILD_CARRIER}

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CHILD_CARRIER}  F

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}

Load and Validate Report (Immediate) Match By Hold For Fraud - One Child carriers (PDF)
    [Tags]  JIRA:BOT-1074  qTest:29538282  Regression  BUGGED:It is not possible to generate the report  refactor
    [Documentation]  Load and validade Report Using Match By Hold For Fraud and One child option (PDF)

    set test variable  ${CARRIER}  303268
    set test variable  ${CHILD_CARRIER}  303274
    switch browser  StatusReportALLChild


    go to  ${emanager}/cards/CardStatusReport.action

    #getting the report screen name
    ${name}  get text  //*[@for="cardStatusReport.jsp.title.legend"]
    ${name}  remove spaces  ${name}
    ${Report_Name}  Get eManager Report Name  ${name}
    tch logging  \nReport Name: ${Report_Name}

    Remove Report File  ${Report_Name}

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold For Fraud
    Select From List By label  viewFormat  PDF
    Select Checkbox  childCarrierDoFilter
    input text  childCarrier  ${CHILD_CARRIER}

    ${pdfFile}  Download Report File  ${Report_Name}  pdf

    ${DB_Cards}  Get all cards from database for a carrier with status  ${CHILD_CARRIER}  U

    Check if all Cards in DB results exists in PDF Report File  ${DB_Cards}  ${pdfFile}

    [Teardown]  run keywords
    ...  Disconnect From Database
    ...  AND  Remove Report File  ${Report_Name}


Load and Validate Report (FTP) Match By Active - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using FTP with Match By Active and One Child carrier options
    [Setup]  Change Child Card Status To  Active

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup FTP Report;
    Select Match by Card Status Active
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download FTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075  FTP

Load and Validate Report (FTP) Match By Inactive - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using FTP with Match By Inactive and One Child carrier options
    [Setup]  Change Child Card Status To  Inactive

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup FTP Report;
    Select Match by Card Status Inactive
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download FTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075  FTP

Load and Validate Report (FTP) Match By Hold - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using FTP with Match By Hold and One Child carrier options
    [Setup]  Change Child Card Status To  Hold

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup FTP Report;
    Select Match by Card Status Hold
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download FTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075  FTP

Load and Validate Report (FTP) Match By Deleted - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using FTP with Match By Deleted and One Child carrier options
    [Setup]  Change Child Card Status To  Deleted

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup FTP Report;
    Select Match by Card Status Deleted
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download FTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075  FTP

Load and Validate Report (FTP) Match By Follows - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using FTP with Match By Follows and One Child carrier options
    [Setup]  Change Child Card Status To  Follows

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup FTP Report;
    Select Match by Card Status Follows
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download FTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075  FTP

Load and Validate Report (FTP) Match By Hold For Fraud - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using FTP with Match By Hold For Fraud and One Child carrier options
    [Setup]  Change Child Card Status To  U  #Hold for Fraud

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup FTP Report;
    Select Match by Card Status Hold For Fraud
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download FTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075  FTP


Load and Validate Report (SFTP) Match By Active - All Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Active and ALL Child carrier options
    [Setup]  Change Child Card Status To  Active

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Active
    Select Filter All Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare SFTP Report File Data with Database For All Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Inactive - All Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Inactive and ALL Child carrier options
    [Setup]  Change Child Card Status To  Inactive

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Inactive
    Select Filter All Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare SFTP Report File Data with Database For All Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Hold - All Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Hold and ALL Child carrier options
    [Setup]  Change Child Card Status To  Hold

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Hold
    Select Filter All Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare SFTP Report File Data with Database For All Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Deleted - All Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Deleted and ALL Child carrier options
    [Setup]  Change Child Card Status To  Deleted

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Deleted
    Select Filter All Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare SFTP Report File Data with Database For All Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Follows - All Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Follows and ALL Child carrier options
    [Setup]  Change Child Card Status To  Follows

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Follows
    Select Filter All Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare SFTP Report File Data with Database For All Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Hold For Fraud - All Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Hold For Fraud and ALL Child carrier options
    [Setup]  Change Child Card Status To  U  #Hold for Fraud

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Hold For Fraud
    Select Filter All Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare SFTP Report File Data with Database For All Child Option;

    [Teardown]  Teardown for BOT-1075


Load and Validate Report (SFTP) Match By Active - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Active and One Child carrier options
    [Setup]  Change Child Card Status To  Active

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Active
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Inactive - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Inactive and One Child carrier options
    [Setup]  Change Child Card Status To  Inactive

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Inactive
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Hold - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Hold and One Child carrier options
    [Setup]  Change Child Card Status To  Hold

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Hold
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Deleted - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Deleted and One Child carrier options
    [Setup]  Change Child Card Status To  Deleted

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Deleted
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Follows - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Follows and One Child carrier options
    [Setup]  Change Child Card Status To  Follows

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Inactive
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075

Load and Validate Report (SFTP) Match By Hold For Fraud - One Child Carrier
    [Tags]  JIRA:BOT-1075  refactor
    [Documentation]  Load and validade Report Using SFTP with Match By Hold For Fraud and One Child carrier options
    [Setup]  Change Child Card Status To  U  #Hold for Fraud

    Log Into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Card Status Report;
    Select and Setup SFTP Report;
    Select Match by Card Status Hold For Fraud
    Select Filter and Input Child Carrier;
    Click on Submit Button;
    Wait FTP file to be Generated;
    Download SFTP Report File;
    Compare Report File Data with Database For One Child Option;

    [Teardown]  Teardown for BOT-1075

New expire date column for immediate report
    [Tags]  JIRA:BOT-3635  qTest:53597692
    [Documentation]  Ensure new expire date column shows in the immediate report when the flag is on

    Log Carrier into eManager with Card Status Report permission and Expire Date Flag 'Enabled'
    Go to Select Program > Reports/Exports > Card Status Report
    Select Immediate Excel Report
    Download the generated report
    Assert the report 'has' new expire date column and rows count

    [Teardown]  Teardown for BOT-1074

New expire date column for FTP report
    [Tags]  JIRA:BOT-3635  qTest:53597724
    [Documentation]  Ensure new expire date column shows in the FTP report when the flag is on

    Log Carrier into eManager with Card Status Report permission and Expire Date Flag 'Enabled'
    Go to Select Program > Reports/Exports > Card Status Report
    Select FTP Excel Report
    Download the generated FTP report
    Assert the report 'has' new expire date column and rows count

    [Teardown]  Teardown for BOT-1074

No expire date on immediate report for flag off
    [Tags]  JIRA:BOT-3635  qTest:53597751
    [Documentation]  Ensure new expire date column does not show in the immediate report when the flag is off

    Log Carrier into eManager with Card Status Report permission and Expire Date Flag 'Disabled'
    Go to Select Program > Reports/Exports > Card Status Report
    Select Immediate Excel Report
    Download the generated report
    Assert the report 'has not' new expire date column and rows count

    [Teardown]  Teardown for BOT-1074

No expire date on FTP report for flag off
    [Tags]  JIRA:BOT-3635  qTest:53597782
    [Documentation]  Ensure new expire date column does not show in the FTP report when the flag is off

    Log Carrier into eManager with Card Status Report permission and Expire Date Flag 'Disabled'
    Go to Select Program > Reports/Exports > Card Status Report
    Select FTP Excel Report
    Download the generated FTP report
    Assert the report 'has not' new expire date column and rows count

    [Teardown]  Teardown for BOT-1074

Excel report correctly formatted
    [Tags]  JIRA:BOT-3635  qTest:53984531
    [Documentation]  Ensure an excel report generated it's correctly formatted regarding the rows.

    Log Carrier into eManager with Card Status Report permission and Expire Date Flag 'Enabled'
    Go to Select Program > Reports/Exports > Card Status Report
    Select Immediate Excel Report
    Download the generated report
    Assert the rows count

    [Teardown]  Teardown for BOT-1074

*** Keywords ***

Get all cards from database for a carrier with status
    [Arguments]  ${carrier}  ${status}
    get into db  TCH
    ${query}  catenate  SELECT TRIM(card_num) as card_num FROM cards WHERE carrier_id='${carrier}' AND card_num NOT LIKE '%OVER%' AND status='${status}';
    ${result}  query and strip to dictionary  ${query}
    [Return]  ${result.card_num}

Get all cards from database for a parent with status
    [Arguments]  ${carrier}  ${status}
    get into db  TCH
    ${query}  catenate  SELECT TRIM(card_num) as card_num from cards where carrier_id IN (select carrier_id from carrier_group_xref where parent = '${carrier}') AND status='${status}';
    ${result}  query and strip to dictionary  ${query}
    [Return]  ${result.card_num}

Compare report file with database results
    [Arguments]  ${card_num}  ${result.card_num}

    ${qtd_lines}  get length  ${card_num}
    set test variable  ${qty_cards_report_file}  ${qtd_lines}
    tch logging  \nQuantity Cards in Report File: ${qtd_lines}

    ${sum_list}  create list

    FOR  ${index}  IN RANGE  0  ${qtd_lines}
      ${card_report}  set variable  ${card_num[${index}]}
      ${found}  Find card in DB results  ${card_report}  ${result.card_num}  ${qtd_lines}
      run keyword if  '${found[0]}' == '1'
      ...  append to list  ${sum_list}  ${found[0]}
    END

    ${total_found}  get length  ${sum_list}
    set test variable  ${total_found}
    tch logging  \nTotal Cards matched: ${total_found}

    Should be equal  ${qty_cards_report_file}  ${total_found}

Find card in DB results
    [Arguments]  ${card_num_report}  ${cards_db}  ${qtd_lines}
    ${found}  create list
    ${return}  catenate  1
    FOR  ${i}  IN RANGE  0  ${qtd_lines}
      ${card_num_db}  set variable  ${cards_db[${i}].strip()}
      ${status}  run keyword and return status  should contain  ${card_num_report}  ${card_num_db}
      run keyword if  '${status}' == '${True}'  run keywords
      ...  Append To List  ${found}  ${return}
      ...  AND  exit for loop
    END

    [Return]  ${found}

Check if all Cards in DB results exists in PDF Report File
    [Arguments]  ${cards_db}  ${pdfFile}

    ${isList}=  evaluate  isinstance(${cards_db},list)
    ${status}  run keyword and return status  should be true  ${isList}

    run keyword if  '${status}' == '${True}'
    ...  Verify All Cards in List  ${cards_db}  ${pdfFile}
    ...  ELSE
    ...  Verify One card  ${cards_db}  ${pdfFile}

Verify One card
    [Arguments]  ${cards_db}  ${pdfFile}

    ${found}  Find value in PDF  ${pdfFile}  ${cards_db}
    ${status}  run keyword and return status  should be true  ${found}
    run keyword if  '${status}' == '${False}'
    ...  fail  Card Number ${cards_db} was not found!
    ...  ELSE
    ...  log to console  Informations in Report File matches with Database!

Verify All Cards in List
    [Arguments]  ${cards_db}  ${pdfFile}
    ${qtd_lines}  get length  ${cards_db}
    FOR  ${i}  IN RANGE  0  ${qtd_lines}
      ${card_num_db}  set variable  ${cards_db[${i}].strip()}
      ${found}  Find value in PDF  ${pdfFile}  ${card_num_db.__str__()}
      ${status}  run keyword and return status  should be true  ${found}
      run keyword if  '${status}' != '${True}'  run keywords
      ...  fail  Card Number ${cards_db[${i}].strip()} was not found!
    END

    tch logging  \nInformations in Report File matches with Database!

Start Suite
    [Documentation]  Keyword for Start all variables that will be used on this suite.

    Get Into DB  Mysql

    Turn OFF Excel Report Flag to xls/xlsx  #this should be temporary and will be remove in a near future, I hope so!

#Get user_id from the last 200 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 200;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

#Get Main Carrier for Test Execution
    ${query}  Catenate  SELECT DISTINCT(m.member_id) FROM member m
    ...     JOIN carrier_group_xref cgx ON cgx.parent = m.member_id
    ...  WHERE m.mem_type = 'C'
    ...  AND m.status = 'A'
    ...  AND EXISTS (SELECT 1 FROM cards c WHERE c.carrier_id = m.member_id)
    ...  AND EXISTS (SELECT 1 FROM cards c WHERE c.carrier_id = cgx.carrier_id)
    ...  AND member_id IN ${list_2}
    ...  AND member_id NOT IN ('141996','103866','174846','106007','144360','183811');  #Bad Carriers

    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable  ${carrier}

    Ensure Carrier has User Permission  ${carrier.id}  CARD_STATUS_REPORT
#    log to console  carrier: ${carrier.id}

#Get Main Carrier Card to Ensure at least one card with desired status
    ${query}  Catenate  SELECT TRIM(card_num) AS card_num FROM cards
    ...  WHERE carrier_id=${carrier.id}
    ...  AND card_num NOT LIKE '%OVER';

    ${card}  Find Card Variable  ${query}
    Set Suite Variable  ${card}
#    log to console  carrier card: ${card.num}

    Start Setup Card  ${card.num}

#Get Child Carrier for Test Execution
    ${query}  Catenate  SELECT DISTINCT(cgx.carrier_id) FROM carrier_group_xref cgx
    ...     JOIN cards c ON c.carrier_id = cgx.carrier_id
    ...  WHERE parent = '${carrier.id}'
    ...  AND parent NOT IN ('141996')

    ${child_carrier}  Find Carrier Variable  ${query}  carrier_id

    Set Suite Variable  ${child_carrier}
#    Log To Console  child: ${child_carrier.id}

#Get Child Carrier Card to Ensure at least one card with desired status
    ${query}  Catenate  SELECT TRIM(card_num) AS card_num FROM cards
    ...  WHERE carrier_id=${child_carrier.id}
    ...  AND card_num NOT LIKE '%OVER';

    ${child_card}  Find Card Variable  ${query}
    Set Suite Variable  ${child_card}
#    log to console  child card: ${child_card.num}

    Start Setup Card  ${child_card.num}

    Set Suite Variable  ${jobDescription}  Card Status

Turn ${value} Excel Report Flag to xls/xlsx
    [Documentation]  This keyword will change the excel report format to xlsx if flag is ON and xls if flag is OFF.
    ...  This is a measure to deal with reports while we dont have support to xlsx files.

    Get Into DB  MySQL

    ${flag}  Set Variable If  '${value}'=='ON'  Y  N

    Execute SQL String  dml=update setting SET value = '${flag}' WHERE `PARTITION` = 'shared' AND name = 'com.tch.export.xlsx';

Change Card Status To
    [Arguments]  ${status}
    [Documentation]

    Start Setup Card  ${card.num}
    Setup Card Header  status=${status}
#    Get Card Status  ${card.num}

Change Child Card Status To
    [Arguments]  ${status}
    [Documentation]

    Start Setup Card  ${child_card.num}
    Setup Card Header  ${child_card.num}  status=${status}
#    Get Card Status  ${child_card.num}

Get Card Status
    [Arguments]  ${card}
#
    Get Into DB  TCH
    ${query}  Catenate  SELECT status FROM cards WHERE card_num='${card}';
    ${status}  Query and Strip  ${query}
    log to console  card status = ${status}

Select Immediate Report;
    [Documentation]  Select Report Type
    Click Element  //input[@value='IMMEDIATE']

Select Match by Card Status Active
    [Documentation]  Select Match By Active

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Active

    Set Test Variable  ${card_status}  A

Select Match by Card Status Inactive
    [Documentation]  Select Match By Inactive

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Inactive

    Set Test Variable  ${card_status}  I

Select Match by Card Status Hold
    [Documentation]  Select Match By Hold

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold

    Set Test Variable  ${card_status}  H

Select Match by Card Status Deleted
    [Documentation]  Select Match By Deleted

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Deleted

    Set Test Variable  ${card_status}  D

Select Match by Card Status Follows
    [Documentation]  Select Match By Follows

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Follows

    Set Test Variable  ${card_status}  F

Select Match by Card Status Hold For Fraud
    [Documentation]  Select Match By Follows

    Select Checkbox  statusShow
    Select From List By label  name=cardStatus  Hold For Fraud

    Set Test Variable  ${card_status}  U

Select Report Format
    [Arguments]  ${report_format}
    [Documentation]  Options are Excel or PDF

    Select From List By label  viewFormat  ${report_format}
    Set Test Variable  ${report_format}

Select Filter All Child Carrier;
    [Documentation]  Select All Child filter and input child carrier for test.

    Select Checkbox  parentCarrierIdDoFilter

Select Filter and Input Child Carrier;
    [Documentation]  Select Child filter and input child carrier for test.

    Select Checkbox  childCarrierDoFilter
    Input Text  childCarrier  ${child_carrier.id}

Download Excel Report File;
    [Documentation]  Keyword to download excel format file

    ${excelFile}  Download Report File  ${Report_Name}  xls

    Set Test Variable  ${excelFile}

Verify if Excel Report is Downloaded;
    [Documentation]  Keyword to check if excel Report is downloaded

    Assert if File is Dowloaded  ${report_name}.xls

Download PDF Report File;
    [Documentation]  Keyword to download PDF format file

    Download Report File  ${Report_Name}  pdf

Verify if PDF Report is Downloaded;
    [Documentation]  Keyword to check if PDF Report is downloaded

    Assert if File is Dowloaded  ${report_name}.pdf

Compare Excel File Data with Database;
    [Documentation]
#
    ${Report_Cards}  Get Number of Cards on Excel Report  ${excelFile}  0
    ${DB_Cards}  Get Number of Cards on DB by Status  ${carrier.id}  ${card_status}
    Should Be Equal as Integers  ${Report_Cards}  ${DB_Cards}
    #Compare report file with database results  ${Report_Cards}  ${DB_Cards}

Compare Excel File Data with Database For All Childs Option;
    [Documentation]
#
    ${Report_Cards}  Get Number of Cards on Excel Report  ${excelFile}  0
    ${DB_Cards}  Get Number of Cards Using Parent on DB by Status  ${carrier.id}  ${card_status}
    Should Be Equal as Integers  ${Report_Cards}  ${DB_Cards}
    #Compare report file with database results  ${Report_Cards}  ${DB_Cards}

Compare Excel File Data with Database For One Child Option;
    [Documentation]
#
    ${Report_Cards}  Get Number of Cards on Excel Report  ${excelFile}  0
    ${DB_Cards}  Get Number of Cards on DB by Status  ${child_carrier.id}  ${card_status}
    Should Be Equal as Integers  ${Report_Cards}  ${DB_Cards}
    #Compare report file with database results  ${Report_Cards}  ${DB_Cards}

Compare SFTP Report File Data with Database;
    [Documentation]
#
    ${report_cards}  Get Number of Cards on CSV Report
    ${DB_Cards}  Get Number of Cards on DB by Status  ${carrier.id}  ${card_status}
    Should Be Equal as Integers  ${report_cards}  ${DB_Cards}
    #Compare report file with database results  ${Report_Cards}  ${DB_Cards

Compare SFTP Report File Data with Database For All Child Option;
    [Documentation]
#
    ${Report_Cards}  Get Number of Cards on CSV Report
    ${DB_Cards}  Get Number of Cards Using Parent on DB by Status  ${carrier.id}  ${card_status}
    Should Be Equal as Integers  ${Report_Cards}  ${DB_Cards}
    #Compare report file with database results  ${Report_Cards}  ${DB_Cards}

Compare Report File Data with Database For One Child Option;
    [Documentation]
#
    ${Report_Cards}  Get Number of Cards on CSV Report
    ${DB_Cards}  Get Number of Cards on DB by Status  ${child_carrier.id}  ${card_status}
    Should Be Equal as Integers  ${Report_Cards}  ${DB_Cards}
    #Compare report file with database results  ${Report_Cards}  ${DB_Cards}

Get Number of Cards on Excel Report
    [Arguments]  ${fullPath}  ${column_number}
    [Documentation]  Get some data from excel file by column_number

    Open Excel  ${fullPath}
    ${sheets}  get sheet names
    ${qtd_lines}  get row count  ${sheets[0]}
#    log to console  ${qtd_lines-1}
    [Return]  ${qtd_lines-1}

Get Number of Cards on CSV Report
    [Documentation]
#
    ${csv_file}  os.Get File  ${default_download_path}\\${report_name}.csv
    @{list}  Split to lines  ${csv_file}
    ${number_of_lines}  Get List Size  ${list}
    ${number_of_lines}  Evaluate  ${number_of_lines}-1
#    log to console  ${number_of_lines}
    [Return]  ${number_of_lines}

Get Number of Cards on DB by Status
    [Arguments]  ${carrier}  ${status}

    Get Into DB  TCH
    ${query}  Catenate  SELECT COUNT(card_num) FROM cards WHERE carrier_id='${carrier}' AND card_num NOT LIKE '%OVER%' AND status='${status}';
    ${number_of_cards}  Query And Strip  ${query}
#    log to console  ${number_of_cards.__int__()}
    [Return]  ${number_of_cards.__int__()}

Get Number of Cards Using Parent on DB by Status
    [Arguments]  ${carrier}  ${status}

    Get Into DB  TCH
    ${query}  Catenate  SELECT COUNT(card_num) AS card_num FROM cards WHERE carrier_id IN (SELECT carrier_id FROM carrier_group_xref WHERE parent = '${carrier}') AND status='${status}';
    ${number_of_cards}  Query And Strip  ${query}
#    log to console  ${number_of_cards.__int__()}
    [Return]  ${number_of_cards.__int__()}

Teardown for BOT-1074
    [Documentation]  Keyword Teardown for BOT-1074

    Remove Report File  ${Report_Name}
    Close Browser

Teardown for BOT-1075
    [Documentation]  Keyword Teardown for BOT-1075
    [Arguments]  ${flag}=SFTP

#Remove Report File
    Remove Report File  ${Report_Name}

#Delete Scheduled Job to clear data
    Delete Scheduled Job

#Delete File from FTP server to clear data
    Run Keyword If  '${flag}'=='SFTP'  pyFTP.FTPLibrary.Remove File  /sftptester/FRNT/${report_name}.csv
    ...  ELSE  pyFTP.FTPLibrary.Remove File  /FRNT/${report_name}.csv

    Close Browser

Log Into eManager With Your Carrier;
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Reports/Exports > Card Status Report;
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/CardStatusReport.action

Select and Setup FTP Report;
    Click Element  //input[@value='FTPSCHEDULED']

#Setup FTP
    Select From List by Value  //select[@id='frequency']  DAILY
    Input Text  //input[@id='user']  efstester
    Input Text  //input[@id='password']  ivniHoc,
    Input Text  //input[@id='server']  ftp-acpt.efs.local
    Input Text  //input[@id='fileName']  ${report_name}
    Input Text  //input[@name='directory']  FRNT
#    Click Element  //input[@name='appendTimestamp']

Select and Setup SFTP Report;
    Click Element  //input[@value='FTPSCHEDULED']

#Setup SFTP
    Select From List by Value  //select[@id='frequency']  DAILY
    Input Text  //input[@id='user']  sftptester
    Input Text  //input[@id='password']  ivniHoc
    Input Text  //input[@id='server']  ftp-acpt.efs.local
    Input Text  //input[@id='fileName']  ${report_name}
    Input Text  //input[@name='directory']  FRNT
#    Click Element  //input[@name='appendTimestamp']
    Click Element  //input[@name='sftp']

Select Additional Prompts;
    Click Element  //input[@name='additionalFields']
    Click Element  //input[@name='selectAll']

Click on Submit Button;
    Click Element  //input[@value='Submit']

Download FTP Report File;
    [Documentation]

    Set FTP Host  ftp-acpt.efs.local
    FTP Login  efstester  ivniHoc,  FTP

    pyFTP.FTPLibrary.Download File  /FRNT/${report_name}.csv  ${default_download_path}\\${report_name}.csv

    Set Test Variable  ${ftp_report}  ${default_download_path}\\${report_name}.csv

Download SFTP Report File;
    [Documentation]

    Set FTP Host  ftp-acpt.efs.local
    FTP Login  sftptester  ivniHoc  SFTP

    pyFTP.FTPLibrary.Download File  /sftptester/FRNT/${report_name}.csv  ${default_download_path}\\${report_name}.csv

    Set Test Variable  ${ftp_report}  ${default_download_path}\\${report_name}.csv

Wait FTP file to be Generated;
    [Documentation]  Keyword for verification if report is completed

    Wait Until Keyword Succeeds  300 sec  30 sec  Check Scheduled Job Status on eManager

Check Scheduled Job Status on eManager
    [Documentation]  Keyword to Check Job Status

    Click Element  refresh
    Check Report Status on Recent Jobs Table  Complete

Check Report Status on Recent Jobs Table
    [Arguments]  ${status}

    Find Report Page on  Recent Jobs Table
    ${jobStatus}  Get Text  //table[@id='recentJob']//td[text()='${jobDescription}']/parent::tr//td[4]

    Should Be Equal  ${jobStatus}  ${status}

Check If Report is on Scheduled Jobs Table

    Find Report Page on  Scheduled Jobs Table

Delete Scheduled Job

    Find Report Page on  Scheduled Jobs Table
    Click Element  //table[@id='scheduledJob']//td[text()='${jobDescription}']/parent::tr//input[@name='deleteJob']
    Handle Alert
#    Element Should Not be Visible  //table[@id='scheduledJob']//td[text()='${jobDescription}']/parent::tr//input[@name='deleteJob']

Find Report Page on
    [Arguments]  ${table}

    ${jobTable}  Set Variable If  '${table}'=='Recent Jobs Table'  recentJob  scheduledJob
    ${elementPosition}  Set Variable If  '${table}'=='Recent Jobs Table'  2  1
    ${elementCount}  Get Element Count  //img[contains(@src,"nextPage")]
    ${element}  Set Variable If  '${elementCount}'=='2'  (//img[contains(@src,"nextPage")])[${elementPosition}]  //img[contains(@src,"nextPage")]

    FOR  ${i}  IN RANGE  1  100
      ${status}  Run Keyword and Return Status  Element Should Be Visible  //table[@id='${jobTable}']//td[text()='${jobDescription}']
      Run Keyword If  '${status}'!='${true}'
      ...  Click Element  ${element}
      ...  ELSE  Exit For Loop
    END

Log Carrier into eManager with Card Status Report permission and Expire Date Flag '${flag}'
    [Documentation]  Log carrier into eManager with Card Status Report permission and flag setup

    Setup Card Expire Date Flag    ${flag}
    Log Into eManager With Your Carrier;

Setup Card Expire Date Flag
    [Documentation]  Setup card expire date flag
    [Arguments]  ${flag}=Enabled

    ${option}    Run Keyword If    '${flag}'=='Enabled'    Set Variable    Y    ELSE    Set Variable    N
    Get Into DB  MySQL
    ${update_query}  Catenate  UPDATE setting SET value = '${option}' WHERE `PARTITION` = 'shared' AND name = 'FLAG_FRNT-1786';
    Execute SQL String  ${update_query}

Go to Select Program > Reports/Exports > Card Status Report
    [Documentation]  Go to Select Program > Reports/Exports > Card Status Report

    Navigate to Select Program > Reports/Exports > Card Status Report;

Select Immediate Excel Report
    [Documentation]  Select immediate excel report and submit

    Select Immediate Report;
    Select Report Format  Excel

Select FTP Excel Report
    [Documentation]  Select ftp excel report and submit

    Select and Setup SFTP Report
    Wait FTP file to be Generated

Select and Setup SFTP Report
    Click Element  //input[@value='FTPSCHEDULED']
    Click Button    //input[@type='submit']
    #Setup SFTP
    ${rand_num}    Generate Random String    5    [NUMBERS]
    ${report_random_name}    Set Variable    ${report_name}${rand_num}
    Set Test Variable    ${report_random_name}
    ${ftp_info}    Create Dictionary    frequency=DAILY    user=sftptester    password=ivniHoc    server=ftp-acpt.efs.local    directory=FRNT
    Select From List by Value  //select[@id='frequency']  ${ftp_info['frequency']}
    Input Text  //input[@id='user']  ${ftp_info['user']}
    Input Text  //input[@id='password']  ${ftp_info['password']}
    Input Text  //input[@id='server']  ${ftp_info['server']}
    Input Text  //input[@id='fileName']  ${report_random_name}
    Input Text  //input[@name='directory']  ${ftp_info['directory']}
    Click Element  //input[@name='appendTimestamp']
    Click Element  //input[@name='sftp']
    Input Text  //input[@id='jobDescription']  ${report_random_name}
    Click Button    //input[@type='submit']

Wait FTP file to be Generated
    [Documentation]  Keyword for verification if ftp report is completed

    Go To  ${emanager}/cards/JobList.action
    Click Element    name=recentJobsButton
    Wait Until Keyword Succeeds  300 sec  30 sec  Check Scheduled Job Status on eManager Recent Jobs Screen

Check Scheduled Job Status on eManager Recent Jobs Screen
    [Documentation]  Keyword to check job status completed in the new recent jobs screen

    Click Element  name=refreshRecentJob
    Check Report Status on Recent Jobs Screen  Complete

Check Report Status on Recent Jobs Screen
    [Arguments]  ${status}

    Wait Until Page Contains    Recent Jobs
    ${multiple_pages}    Run Keyword And Return Status    Page Should Contain Element   idSearchTxt2
    Run Keyword If    '${multiple_pages}'=='True'    Input Text    name=idSearchTxt2    ${report_random_name}
    ${jobStatus}  Get Text  //table[@id='recentJob']//td[text()='${report_random_name}']/parent::tr//td[4]

    Should Be Equal  ${jobStatus}  ${status}

Download the generated report
    [Documentation]  Download the generated report and check it

    Download Excel Report File;
    Verify if Excel Report is Downloaded;

Download the generated FTP report
    [Documentation]  Download the generated FTP report and check it

    Download FTP Excel Report File
    Verify if Excel Report is Downloaded;

Download FTP Excel Report File
    [Documentation]  Keyword to download ftp excel format file from schedule reports screen

    Wait Until Element Is Visible    //table[@id='recentJob']//td[text()='${report_random_name}']/parent::tr//td[6]
    Click Element    //table[@id='recentJob']//td[text()='${report_random_name}']/parent::tr//td[6]
    Wait Until Keyword Succeeds  100 sec  10 sec  Check if File is Dowloaded   ${report_name}  xls
    Set Test Variable    ${excelFile}    ${filepath}

Assert the report '${flag}' new expire date column and rows count
    [Documentation]  Check if the report has/has not the new expire date column and the correct amount of rows

    Compare Excel File Data with Database
    ${condition}    Run Keyword If    '${flag}' == 'has'    Set Variable    true    ELSE    Set Variable    false
    Check New Expire Date Column    ${condition}

Compare Excel File Data with Database
    [Documentation]  Compare if the reports rows amount matches the database rows amount

    ${Report_Cards}  Get Number of Cards on Excel Report  ${excelFile}  0
    ${DB_Cards}  Get Number of Cards on DB  ${carrier.id}
    Should Be Equal as Integers  ${Report_Cards}  ${DB_Cards}

Get Number of Cards on DB
    [Arguments]  ${carrier}

    Get Into DB  TCH
    ${query}  Catenate  SELECT COUNT(card_num) FROM cards WHERE carrier_id='${carrier}' AND card_num NOT LIKE '%OVER%';
    ${number_of_cards}  Query And Strip  ${query}
    [Return]  ${number_of_cards.__int__()}

Assert the rows count
    [Documentation]  Check the correct amount of rows

    Compare Excel File Data with Database

Check New Expire Date Column
    [Documentation]  Check if the report has the new expire date column
    [Arguments]  ${has_new_column}=true

    ${header}  Get Header Values From Excel Report  ${excelFile}
    ${header_list}    Evaluate    [list(x) for x in ${header}]
    ${label_list}    Create List
    FOR  ${item}  IN  @{header_list}
        Append To List  ${label_list}  ${item[1]}
    END
    Run Keyword If    '${has_new_column}' == 'true'    List Should Contain Value    ${label_list}    Expire Date    ELSE    List Should Not Contain Value    ${label_list}    Expire Date