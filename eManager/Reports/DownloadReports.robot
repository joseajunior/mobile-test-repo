*** Settings ***
Documentation  This test suite ensures that an eManager report will download to the default
...  download directory.


Library  OperatingSystem  WITH NAME  os
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.reports.PyExcel
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Time To Setup

Force Tags  eManager  Reports

*** Variables ***
${days}

*** Test Cases ***

EFS - Validate Reject Transaction Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}
    Delete Pre Existent Report Files  RejectTransactionReport
    Select Report  TranRejectReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    Select From List By Label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Reject Transaction Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}
    Delete Pre Existent Report Files  RejectTransactionReport
    Select Report  TranRejectReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Transaction Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  TransactionReport
    Select Report  Transaction.action?outputMode=report

    ${Year}=  getdatetimenow  %Y
    ${MonthDay}=  getdatetimenow  -%m-%d
    ${year}  Evaluate  ${year}-7
    ${EndDate}  getdatetimenow  %Y-%m-%d
    input text  transFilter.begDate  ${Year}${MonthDay}
    input text  transFilter.endDate  ${EndDate}
    click on  Submit
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Your Start Date is too far in the past.')]

    ${beginDate}=  getdatetimenow  %Y-%m-%d  days=+7
    ${EndDate}=  getdatetimenow  %Y-%m-%d
    input text  transFilter.begDate  ${beginDate}
    input text  transFilter.endDate  ${EndDate}
    click on  Submit

    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'End Date cannot be before Start Date.')]

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Transaction Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  TransactionReport
    Select Report  Transaction.action?outputMode=report

    ${Year}=  getdatetimenow  %Y
    ${MonthDay}=  getdatetimenow  -%m-%d
    ${year}  Evaluate  ${year}-7
    ${EndDate}  getdatetimenow  %Y-%m-%d
    input text  transFilter.begDate  ${Year}${MonthDay}
    input text  transFilter.endDate  ${EndDate}
    click on  Submit
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Your Start Date is too far in the past.')]

    ${beginDate}=  getdatetimenow  %Y-%m-%d  days=+7
    ${EndDate}=  getdatetimenow  %Y-%m-%d
    input text  transFilter.begDate  ${beginDate}
    input text  transFilter.endDate  ${EndDate}
    click on  Submit

    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'End Date cannot be before Start Date.')]

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Card Report
    [Tags]  refactor
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...  AND  Set Test Variable  ${carr_ID}  324878
    ...  AND  Setup And Login  ${carr_ID}  ${DB}

    Delete Pre Existent Report Files  CardReport
    Select Report  CardReport.action
    Sleep  5
    click button  //*[@value="all"]
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Cash Load Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  CashLoadReport
    Select Report  CashLoadReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Cash Load Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  CashLoadReport
    Select Report  CashLoadReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Fuel Detail Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  FuelDetailReport
    Select Report  FuelDetailReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Fuel Detail Report Data Validation (Excel)
    [Tags]  JIRA:BOT-440  qTest:33228398  Regression  refactor
    [Documentation]  ​​Make sure that all data that shows up on the excel file matches the results from DB.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}
    Set Test Variable  ${DB}  TCH

#    IF ANY FUEL DETAIL REPORT EXIST IN THE DOWNLOADS DIRECTORY, THEN DELETE THEM ALL.
    Delete Pre Existent Report Files  FuelDetailReport

    ${103866}  Set Member Model  ${validCard.carrier.member_id}
    Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Maximize Browser Window
    Select Report  FuelDetailReport.action
    ${begin}=  GetDateTimeNow  %Y-%m-%d  days=-1
    ${end}=  GetDateTimeNow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    Select From List By Label  viewFormat  Excel
    Click On  Submit
    Open New Window  text=Click here to view the document  timeout=60

    Open and Read The Excel File  ${default_download_path}  FuelDetailReport
    Compare Excel Data  ${Excel_Data}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Fuel Detail Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}
    Delete Pre Existent Report Files  FuelDetailReport
    Select Report  FuelDetailReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Fuel Tax Report (Excel)
    [Tags]  JIRA:BOT-578  qTest:31435890  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  FuelTaxReport
    Select Report  FuelTaxReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Fuel Tax Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  FuelTaxReport
    Select Report  FuelTaxReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Issued Money Codes Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  IssuedMoneyCodesReport
    Select Report  IssuedMoneyCodesReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Issued Money Codes Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  IssuedMoneyCodesReport
    Select Report  IssuedMoneyCodesReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Money Code Remaining Balance Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  MoneyCodeRemainingBalanceReport
    Select Report  MoneyCodeBalanceLeftReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Money Code Remaining Balance Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  MoneyCodeRemainingBalanceReport
    Select Report  MoneyCodeBalanceLeftReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Money Code Use Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  MoneyCodeUseReport
    Select Report  MoneyCodeUseReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Money Code Use Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  MoneyCodeUseReport
    Select Report  MoneyCodeUseReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate One Time Cash Report - All Cards (Excel)
    [Tags]  refactor
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  OneTimeCashAdvanceBalanceReport
    Select Report  OneTimeCashAdvanceBalanceReport.action
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate One Time Cash Report - All Cards (PDF)
    [Tags]  refactor
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}  ${DB}

    Delete Pre Existent Report Files  OneTimeCashAdvanceBalanceReport
    Select Report  OneTimeCashAdvanceBalanceReport.action
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - PDCA Rebate Report Data Validation(Excel)
    [Tags]  JIRA:BOT-447  qTest:31544122  Regression  refactor
    [Documentation]
    [Setup]  Run Keywords  Set Suite Variable  ${specific_carrier}  113940
    ...  AND  Set Test Variable  ${DB}  TCH
    ...  AND  Setup And Login  ${specific_carrier}  ${DB}

    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${begin}  2018-01-01
    Set Test Variable  ${end}  2019-01-01

    Delete Pre Existent Report Files  PDCARebateReport
    Select Report  PDCARebateReport.action
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Click On  Submit
    Open New Window  text=Click here to view the document  timeout=60

    os.Wait Until Created  ${default_download_path}${/}*PDCARebateReport*.xls

    @{file}=  os.List Directory  ${default_download_path}  *PDCARebateReport*
    ${downloadpath}=  os.Normalize Path  ${default_download_path}
    ${filPath}=  Assign String  ${downloadpath}\\${file[0]}
    Tch Logging  \n FILE PATH: ${filPath}  INFO
    Open Excel  ${filPath}
    ${sheets}=  Get Sheet Names
    ${rowCount}=  Get Row Count  ${sheets[0]}

    ${Excel_Data}  create list

    FOR  ${index}  IN RANGE  1  ${rowCount}
        ${row}  Get Row Values  ${sheets[0]}  ${index}  ${True}
        ${row_dict}  Create Dictionary
        Format PDCA Report Header  ${row_dict}  ${row}
        append to list  ${Excel_Data}  ${row_dict}
    END

    ${db_results}  Check DB For PDCA Report  ${specific_carrier}  ${begin}  ${end}
    Compare List Dictionaries As Strings  ${Excel_Data}  ${db_results}
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database


EFS - Validate PDCA Rebate Report (Excel)
    [Tags]  refactor
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...  AND  Setup And Login  ${specific_carrier}  ${DB}

    Delete Pre Existent Report Files  PDCARebateReport
    Select Report  PDCARebateReport.action
    select from list by label  viewFormat  Excel
    Submit and Download Report

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate PDCA Rebate Report (PDF)
    [Tags]  refactor
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...  AND  Setup And Login  ${specific_carrier}  ${DB}

    Delete Pre Existent Report Files  PDCARebateReport
    Select Report  PDCARebateReport.action
    select from list by label  viewFormat  PDF
    Submit and Download Report

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Transaction Export (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...  AND  Setup And Login  ${specific_carrier}  ${DB}

    Delete Pre Existent Report Files  TransactionExport
    Select Report  Transaction.action?outputMode=export

    ${Year}=  getdatetimenow  %Y
    ${MonthDay}=  getdatetimenow  -%m-%d
    ${year}  Evaluate  ${year}-7
    ${EndDate}  getdatetimenow  %Y-%m-%d
    input text  transFilter.begDate  ${Year}${MonthDay}
    input text  transFilter.endDate  ${EndDate}
    click on  Submit
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Your Start Date is too far in the past.')]

    ${beginDate}=  getdatetimenow  %Y-%m-%d  days=+7
    ${EndDate}=  getdatetimenow  %Y-%m-%d
    input text  transFilter.begDate  ${beginDate}
    input text  transFilter.endDate  ${EndDate}
    click on  Submit

    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'End Date cannot be before Start Date.')]

    ${start}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Excel Format
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate View Check Report
    [Tags]  refactor
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...  AND  Setup And Login  ${specific_carrier}  ${DB}

    Delete Pre Existent Report Files  ViewCheck
    Select Report  ViewCheck.action
    click element  //*[@value="Submit"]
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Volume by State/Province Report (Excel)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...  AND  Setup And Login  ${specific_carrier}  ${DB}

    Delete Pre Existent Report Files  StateProvinceVolumeSummaryReport
    Select Report  VolumeStateProvinceReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  Excel
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Validate Volume by State/Province Report (PDF)
    [Tags]  JIRA:BOT-578  refactor
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...  AND  Setup And Login  ${specific_carrier}  ${DB}

    Delete Pre Existent Report Files  StateProvinceVolumeSummaryReport
    Select Report  VolumeStateProvinceReport.action

    Set Date Range For The Past 7Years
    Set Date Range For The Future

    ${begin}=  getdatetimenow  %Y-%m-%d  days=-${days}
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${begin}  ${end}
    select from list by label  viewFormat  PDF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

Reports - Default Currency For Shell
    [Tags]  JIRA:BOT-581  refactor
    [Documentation]  Issuer ids of 125053 and 131824 should default to CAD/Liters on Reports. TRS-13976
    [Setup]  Run Keywords  Set Test Variable  ${DB}  SHELL
    ...  AND  Setup And Login  ${shell_carrier}  ${DB}
#Generate Variables For Test Execution
    ${currency}  Set Variable  CAD/Liters
    @{menuList}  create list  MoneyCodeReport.action  Transaction.action?outputMode=export  Transaction.action?outputMode=report  VolumeStateProvinceReport.action

    FOR  ${menu}  IN  @{menuList}
      Mouse Over  id=menubar_1x2
      Mouse Over  xpath=//td[@class="nlsitem" and text()="Reports/Exports"]
      ${status}  ${message}  Run Keyword and Ignore Error  Click Element  xpath=//td[@class="nlsitem" and text()="${menu}"]
      Run Keyword If  '${status}' == 'FAIL'  Run Keywords
      ...  TCH Logging  \nMenu ${menu} does not exist in this carrier.
      ...  AND  Click Element  //a[contains(text(),'Home')]
      ...  AND  Continue For Loop
      TCH Logging  \nChecking in menu ${menu} for currency.
      ${index}  Execute Javascript  var index = document.getElementsByName("currency")[0].selectedIndex;
      ...  return index+1;
      ${currency_text}  Get Text  //select[@name="currency"]//option[${index}]
      Should Be Equal as Strings  ${currency}  ${currency_text}
    END

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Immediate Report (Comdata)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction reports using Comdata option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Comdata
    Submit and Download Report

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Immediate Report (Comdata FPS)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using Comdata FPS option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}


    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Comdata FPS
    Submit and Download Report

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Validate Immediate Report (Comma Delimited)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using Comma Delimited option
    ...  and check the informations with database results
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    ${start}  getdatetimenow  %Y-%m-%d
    ${end}  getdatetimenow  %Y-%m-%d

#    switch browser  TransExport

    Get Into DB  ${DB}
    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export
#getting the report screen name
    ${name}  get text  //*[@class="content1"]/td/table/tbody/tr/td/center/form/table/tbody/tr[1]/td/fieldset/legend/label
    ${name}  remove spaces  ${name}
    ${report_name}  Get eManager Report Name  ${name}
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Comma Delimited
    Download Report File  ${report_name}  txt
     ${FileContent}  Get Report File Content  ${report_name}

#getting CARD NUMBERs and Invoice of transactions on Report file
    ${Report_Cards_List}  Get File Data By Column Name  ${FileContent}  Card Number
    ${report_invoice_list}  Get File Data By Column Name  ${FileContent}  Invoice

    ${contracts}  Select active contracts in carrier  ${validCard.carrier.member_id}
    ${db_result}  Select transactions on database where  ${contracts}  ${start}  ${end}

#Validate Report File by Comparing Card Number and Invoice in report file with database results
    Validate Report File by Comparing Card Number and Invoice  ${Report_Cards_List}  ${db_result.card_num}  ${db_result.invoice}  ${Report_Invoice_List}

    [Teardown]  Run Keywords
    ...  Remove Report File  ${report_name}
    ...  AND  disconnect from database
    ...  AND  Close Browser

EFS - Transaction Export - Immediate Report (Extended Comma Delimited with DEF)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using Extended Comma Delimited with DEF option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Extended Comma Delimited with DEF
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Immediate Report (Canadian Comma Delimited)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using Canadian Comma Delimited option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Canadian Comma Delimited
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Immediate Report (Standard Third Party)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using Standard Third Party option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Standard Third Party
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Immediate Report (Comdata EFS)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using Comdata EFS option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Comdata EFS
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Immediate Report (Comma Delimited Plus)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using Comma Delimited Plus option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  Comma Delimited Plus
    Submit and Download Report
    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

EFS - Transaction Export - Immediate Report (PHH Format)
    [Tags]  JIRA:BOT-1124  qTest:29085059  Regression  refactor
    [Documentation]  Export Transaction report using PHH Format option
    [Setup]  Run Keywords  Set Test Variable  ${DB}  TCH
    ...     AND  Setup And Login  ${validCard.carrier.member_id}    ${DB}

    Delete Pre Existent Report Files  transexport
    Select Report  Transaction.action?outputMode=export

    ${start}=  getdatetimenow  %Y-%m-%d
    ${end}=  getdatetimenow  %Y-%m-%d
    Set Date Range  ${start}  ${end}
    select from list by label  exportFormat  PHH Format
    Submit and Download Report

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

*** Keywords ***


Select Report
    [Arguments]  ${report}

    Go To  ${emanager}/cards/${report}
    ${status}  Run Keyword And Return Status  Wait Until Page Contains Element   //*[@for="report.scheduleImmediate.legend"]  timeout=20
    Run Keyword IF  '${status}'=='${true}'  Tch Logging  You're inside the report Screen
    ...  ELSE  Go To  ${emanager}/cards/${report}

Set Date Range
    [Arguments]  ${start_date}  ${end_date}

    sleep  200 ms
    Input Text  //*[@id="immediateDiv"]/table/tbody/tr/td/fieldset/table/tbody/tr[1]/td[2]/input  ${start_date}
    sleep  200 ms
    Input Text  //*[@id="immediateDiv"]/table/tbody/tr/td/fieldset/table/tbody/tr[2]/td[2]/input  ${end_date}

Set Date Range For The Past 7Years
    [Tags]  JIRA:BOT-578
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.

    ${Year}=  getdatetimenow  %Y
    ${MonthDay}=  getdatetimenow  -%m-%d
    ${year}  Evaluate  ${year}-7
    ${EndDate}  getdatetimenow  %Y-%m-%d

    input text  startDate  ${Year}${MonthDay}
    input text  endDate  ${EndDate}
    click on  Submit

    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Your Start Date is too far in the past.')]

Set Date Range For The Future
    [Tags]  JIRA:BOT-578
    [Documentation]  Make sure reports error when you try to search a date seven years or longer in the past and error for searching for a future date.

    ${beginDate}=  getdatetimenow  %Y-%m-%d  days=+7
    ${EndDate}=  getdatetimenow  %Y-%m-%d

    input text  startDate  ${beginDate}
    input text  endDate  ${EndDate}
    click on  Submit

    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'End Date cannot be before Start Date.')]

Submit and Download Report
    ${name}=  get text  //*[@class="content1"]/td/table/tbody/tr/td/center/form/table/tbody/tr[1]/td/fieldset/legend/label
    ${name}=  remove spaces  ${name}
    ${report}=  Get eManager Report Name  ${name}
    Click On  Submit
    Wait Until Page Contains  text=Click here to view the document  timeout=120
    Open New Window  text=Click here to view the document
    sleep  2

    ${file}=  set local file  ${default_download_path}${/}*${report}*
    ${fileExists}=  check local file exists  ${file}
    ${error_message}=  run keyword if  ${file_exists}==${False}  get text  //*[@class="content1"]/td/table/tbody/tr/td/center/table/tbody/tr[1]/th
    close window
    select window  main
    run keyword if  ${fileExists}==${False}  fail  ${report} failed. Error message:\n${error_message}
    Sleep  3

Setup And Login
    [Arguments]  ${carrier_id}  ${DB}

    Make Sure Carrier Is Active  ${carrier_id}
    ${carrier_password}  Get Carrier Credentials  ${carrier_id}  ${DB}
    Open Browser to eManager  MainWindow
    Log into eManager  ${carrier_id}  ${carrier_password}

Time To Setup
    ${days}=  Get Number of Days To Use
    set global variable  ${days}
    log to console  ${days}

Get Number of Days To Use
    #Get Today's Day Number
    ${days1}=  getdatetimenow  %d
    tch logging  Todays Date: ${days1}  INFO
    #By Using Todays Day Number Get the Last Day of Last Month
    ${days2}=  getdatetimenow  %d  days=-${days1}
    tch logging  Days in last month: ${days2}  INFO
    #We want to use the larger to the 2 day numbers that way we either use the last day of last month or we use exactly 1 month ago (matching day number of last month)
    ${days1}=  Assign Int  ${days1}
    ${days3}=  RUN KEYWORD IF  ${days1} > ${days2}  assign string  ${days1}

    ${days3}=  set if null  ${days3}  ${days2}

    [Return]  ${days3}

Select transactions on database where
    [Arguments]  ${contracts}  ${start}  ${end}

    ${end}=  getdatetimenow  %Y-%m-%d  days=+1
    ${query}  catenate
    ...  SELECT t.trans_id, t.card_num, TO_CHAR(t.trans_date,'%R'),TRIM(t.invoice) as invoice
    ...  FROM TRANSACTION t
    ...  inner join trans_line tl on t.trans_id = tl.trans_id
    ...  where  t.trans_date>to_date('${start}','%Y-%m-%d')
    ...  AND t.trans_date<to_date('${end}','%Y-%m-%d')
    ...  AND t.contract_id IN (${contracts})
    ...  ORDER BY trans_date;
    ${db_result}  query and strip to dictionary  ${query}

    [Return]  ${db_result}

Select active contracts in carrier
    [Arguments]  ${carrier}

    ${query_contract}  catenate  select contract_id from contract where carrier_id="${carrier}" and status="A";
    ${contracts}  query and strip to dictionary  ${query_contract}
    ${contracts}  set variable  ${contracts.contract_id.__str__()}
    ${contracts}  Remove From String  [  ${contracts}
    ${contracts}  Remove From String  ]  ${contracts}

    [Return]  ${contracts}

Validate Report File by Comparing Card Number and Invoice
    [Arguments]  ${Cards_List_from_ReportFile}  ${Cards_List_from_DB}  ${Invoice_List_from_DB}  ${Invoice_List_from_ReportFile}
    [Documentation]  Compare values from lists.
    ...  This keyword receives the Invoice and Card Number lists from Report File and from Database and then
    ...  checks if the values from database exist in values from report file

    ${size_cards_report}  get length  ${Cards_List_from_ReportFile}
    set test variable  ${size_cards_report}  ${size_cards_report}
    ${size_cards_db}  get length  ${Cards_List_from_DB}
    set test variable  ${size_cards_db}  ${size_cards_db}

    tch logging  \n Validating Report File with Database...
    FOR  ${index}  IN RANGE  0  ${size_cards_db}
      ${db_line_card_num}  Set Variable  ${Cards_List_from_DB[${index}]}
      ${db_line_invoice}  Set Variable  ${Invoice_List_from_DB[${index}]}
#    \  tch logging  Searching card num: ${db_line_card_num} and invoice ${db_line_invoice}
      ${find}  Compare Lines  ${Cards_List_from_ReportFile}  ${Invoice_List_from_ReportFile}  ${db_line_card_num}  ${db_line_invoice}
      run keyword if  '${find}'=='0'  fail  We got ${db_line_card_num} and ${db_line_invoice} in DB but NOT in Report File
    END

Compare Lines
    [Arguments]  ${card_num_list}  ${invoice_list}  ${card_num}  ${invoice}
    [Documentation]

    ${first_five_db}  Get Substring  ${card_num.__str__()}  0  5
    ${last_four_db}  Get Substring  ${card_num.__str__()}  -4
    ${fake_card_num_db}  Catenate  ${first_five_db}${last_four_db}
    ${find}  Evaluate  0
    ${card_num_list_len}  get length  ${card_num_list}
    FOR  ${index}  IN RANGE  0  ${card_num_list_len}
      ${sheet_card}  Set Variable  ${card_num_list[${index}]}
      ${sheet_invoice}  Set Variable  ${invoice_list[${index}]}
      ${first_five_sheet}  Get Substring  ${sheet_card.__str__()}  0  5
      ${last_four_sheet}  Get Substring  ${sheet_card.__str__()}  -4
      ${fake_card_sheet}  Catenate  ${first_five_sheet}${last_four_sheet}
      ${find}  set variable if  '${fake_card_sheet}'=='${fake_card_num_db}'  and  '${sheet_invoice}'=='${invoice}'  1  ${find}
      run keyword if  '${find}'=='1'  exit for loop
    END

    [Return]  ${find}

#    -------------------------------------------- FUEL DETAIL REPORT DB VALIDATION -----------------------------------------------
Check Excel Row Fuel Detail Report
    ${begin}  getdatetimenow  %Y-%m-%d  days=-1
    ${end}  getdatetimenow  %Y-%m-%d
    Get Into DB  ${DB}

    ${main_query}=  catenate
      ...       SELECT t.card_num,
      ...              l.state,
      ...              TO_CHAR(ROUND((SUM(tl.qty)*3.78541), 2)) AS liters,
      ...               TO_CHAR(SUM(tl.qty)) AS gallons
      ...       FROM TRANSACTION t
      ...       LEFT JOIN location l ON l.location_id = t.location_id
      ...       LEFT JOIN trans_line tl ON tl.trans_id = t.trans_id
      ...       WHERE carrier_id = ${validCard.carrier.member_id}
      ...       AND trans_date >= '${begin} 00:00'
      ...       AND trans_date < '${end} 00:00'
      ...       GROUP BY t.card_num, l.state ORDER BY t.card_num, l.state
   ${db_results}  Query To Dictionaries  ${main_query}
    Tch Logging  ${db_results}
    [Return]  ${db_results}

Put Row in Dictionary
    [Arguments]  ${excelTable}  ${row}

    Set To Dictionary  ${excelTable}  card_num=${row[0][1]}
    Set To Dictionary  ${excelTable}  state=${row[1][1]}
    Set To Dictionary  ${excelTable}  liters=${row[2][1]}
    Set To Dictionary  ${excelTable}  gallons=${row[3][1]}

Format Dictionary
    [Arguments]  ${Excel_Data}
    Format Data  ${Excel_Data}
    [Return]  ${Excel_Data}

Format Data
    [Arguments]  ${Excel_Data}

    FOR  ${i}  IN  @{Excel_Data}
      ${gallons}  Get From Dictionary  ${i}  gallons
      ${gallons}  Convert To Integer  ${gallons}
      Set To Dictionary  ${i}  gallons=${gallons.__str__()}
      ${liters}  Get From Dictionary  ${i}  liters
      ${liters}  Convert To Integer  ${liters}
      Set To Dictionary  ${i}  liters=${liters.__str__()}
    END

    [Return]  ${Excel_Data}

Get Carrier Credentials
    [Arguments]  ${carrier_id}  ${DB}
    Get Into DB  ${DB}
    ${passwd}  Query And Strip  SELECT TRIM(passwd) AS passwd FROM member WHERE member_id=${carrier_id}
    [Return]  ${passwd}

Delete Pre Existent Report Files
    [Arguments]  ${report_name}
    @{files}=  os.list directory  ${default_download_path}  *${report_name}*
    print list  @{files}
    FOR  ${i}  IN  @{files}
       tch logging  Permanently removing ${default_download_path}/${i}  WARN
       os.remove file  ${default_download_path}/${i}
    END

Open and Read The Excel File
    [Arguments]    ${default_download_path}  ${report_name}

    os.Wait Until Created  ${default_download_path}${/}*${report_name}*.xls

    @{file}=  os.List Directory  ${default_download_path}  *${report_name}*
    ${downloadpath}=  os.Normalize Path  ${default_download_path}
    ${filPath}=  Assign String  ${downloadpath}\\${file[0]}
    Tch Logging  \n FILE PATH: ${filPath}  INFO
    Sleep  3
    Open Excel  ${filPath}
    ${sheets}=  Get Sheet Names
    ${rowCount}=  Get Row Count  ${sheets[0]}
    ${columnCount}=  Get Column Count  ${sheets[0]}
    tch logging  \n |SHEETS: ${sheets}|COUNT:${rowCount}|COLUMN_COUNT:${columnCount}

    ${Excel_Data}  create list
    FOR  ${index}  IN RANGE  1  ${rowCount}
        ${row}  Get Row Values  ${sheets[0]}  ${index}  ${True}
        ${row_dict}  Create Dictionary
        Put Row in Dictionary  ${row_dict}  ${row}
        Append To list  ${Excel_Data}  ${row_dict}
    END

    Set Suite Variable  ${Excel_Data}
    ${Excel_Data}  Format Dictionary  ${Excel_Data}
    Tch Logging  EXCEL DATA:${Excel_Data}

Compare Excel Data
    [Arguments]  ${excel_Data}

    ${db_results}  Check Excel Row Fuel Detail Report
    Compare List Dictionaries As Strings  ${excel_Data}  ${db_results}

#    ---------------------------------------PDCA REPORT VALIDATION -------------------------------------

Check DB For PDCA Report
    [Arguments]  ${carrier}  ${begin}  ${end}
    Get Into DB  ${DB}
    ${query}  catenate
    ...     SELECT c.card_num,
    ...     TRIM(pr.category) AS type,
    ...     SUM(pr.purchase_amt) AS totalpurchase,
    ...     SUM(pr.purchase_qty) AS quantity
    ...     FROM pdca_rebate pr,
    ...     cards c,
    ...     member m,
    ...     OUTER card_inf ci
    ...     WHERE pr.card_num = c.card_num
    ...     AND m.member_id = c.carrier_id
    ...     AND c.card_num = ci.card_num
    ...     AND ci.info_id = 'UNIT'
    ...     AND c.carrier_id = ${carrier}
    ...     AND pr.rebate_date >= '${begin}'
    ...     AND pr.rebate_date <= '${end}'
    ...     GROUP BY  c.card_num, type
    ${db_results}  Query To Dictionaries  ${query}

    [Return]  ${db_results}

Format PDCA Report Header
    [Arguments]  ${excelTable}  ${row}

    set to dictionary  ${excelTable}  card_num=${row[0][1]}
    set to dictionary  ${excelTable}  type=${row[1][1]}
    set to dictionary  ${excelTable}  amount=${row[2][1]}
    set to dictionary  ${excelTable}  TotalPurchase=${row[3][1]}
    set to dictionary  ${excelTable}  quantity=${row[4][1]}
    set to dictionary  ${excelTable}  uom=${row[5][1]}
