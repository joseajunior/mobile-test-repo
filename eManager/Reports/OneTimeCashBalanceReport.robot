*** Settings ***
Documentation
...  Intent: This suite covers strictly the Card Status Report in eManager. The report is downloaded and the content
...  is validated in all formats.

Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyExcel
Library  String
Library  otr_robot_lib.ftp.PyFTP.FTPLibrary
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  Reports  One Time Cash  eManager

Suite Setup  Suite Setup
Suite Teardown  Suite Teardown

*** Variables ***

*** Test Cases ***
One Time Cash Balance Report Is Pulling Up
    [Tags]  JIRA:BOI-445  qTest:31438093  Regression  refactor
    [Documentation]
    ${report_name}  Navigate To One Time Cash Report Balance
    Add Card Filter  ${validCard.num}
    ${filePath}  Submit Cash Advance Report  ${report_name}  Excel
    Confirm Downloaded File  ${filePath}
    [Teardown]  Remove Report File  ${report_name}

One Time Cash Balance Report Is Showing Correct Data
    [Tags]  JIRA:BOI-445  qTest:31438093  Regression  refactor
    [Documentation]
    ${report_name}  Navigate To One Time Cash Report Balance
    ${begin_date}  ${end_date}  Add Card Filter  ${validCard.num}
    ${filePath}  Submit Cash Advance Report  ${report_name}  Excel
    ${xls_values}  Get Values From Excel Rows  ${filePath}
    ${db_values}  Get One Time Cash From DB  ${validCard.carrier.id}  ${validCard.num}  ${begin_date}  ${end_date}
    ${list_compare}  Compare List Dictionaries As Strings  ${xls_values}  ${db_values}
    Should Be True  ${list_compare}
    [Teardown]  Remove Report File  ${report_name}

*** Keywords ***
Suite Setup
    Get Into DB  TCH
    Add User Role If Not Exists  ${validCard.carrier.id}  ONE_TIME_CASH_ADVANCE_REPORT
    Open Emanager  ${validCard.carrier.id}  ${validCard.carrier.password}


Suite Teardown
    Disconnect From Database
    Close Browser

Navigate To One Time Cash Report Balance
    Go To  ${emanager}/cards/OneTimeCashAdvanceReport.action
    Wait Until Element Is Visible  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Get Text  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Remove From String  ${SPACE}  ${name}
    ${report_name}  Get eManager Report Name  ${name}
    [Return]  ${report_name}

Add Card Filter
    [Arguments]  ${card_num}
    ${YESTERDAY}  getDateTimeNow  %Y-%m-%d  days=-1
    Click Element  cardShow
    Click Element  lookUpCards
    Input Text  cardSearchTxt  ${card_num}
    Click Element  searchCard
    Wait Until Element Is Visible  //table[@id='cardSummary']//tbody//a[contains(@href,'OneTimeCashAdvanceReport.action')]
    Click Element  //table[@id='cardSummary']//tbody//a[contains(@href,'OneTimeCashAdvanceReport.action')]
    Input Text  startDate  ${YESTERDAY}
    Input Text  endDate  ${YESTERDAY}
    [Return]  ${YESTERDAY}  ${YESTERDAY}

Submit Cash Advance Report
    [Arguments]  ${report_name}  ${extension}  ${timeout}=120  ${createTimeout}=20
    [Documentation]  Clicks on submit, waits for the download button appears and then it makes download
    ...  report_name: can be a piece of the report file name, for example: Card Status Report
    ...  extension: xls, csv, txt, pdf...
    ...  * It returns the file full path
    Select From List By Label  viewFormat  ${extension}
    Click Element  doReport
    ${extension}  Set Variable If  '${extension}'=='Excel'  xls  ${extension}
    ${extension}  Set Variable If  '${extension}'=='Text'  txt  ${extension}
    Remove Report File  ${report_name}
    sleep  1
    Numbered Error On Screen  Could Not Download Report Due to Numbered Error After Clicking Submit
    wait until page does not contain element  //*[contains(text(), "Please wait while your document is loading ...")]  ${timeout}
    click element  //a[contains(text(),'Click here to view the document')]
    sleep  1
    Numbered Error On Screen  Could Not Download Report Due to Numbered Error After Clicking On Download Link

    OperatingSystem.Wait Until Created  ${default_download_path}${/}*${report_name}*.${extension}  timeout=${createTimeout}

    @{file}  OperatingSystem.list directory  ${default_download_path}  *${report_name}*.${extension}
    tch logging  \nReport File Downloaded: ${file[0]}
    ${downloadpath}  OperatingSystem.normalize path  ${default_download_path}
    ${filPath}  assign string  ${downloadpath}${/}${file[0]}

    [Return]  ${filpath}

Remove Report File
    [Arguments]  ${report_name}
    [Documentation]  Check if the file exists and then remove the file
    ${fileExists}  run keyword and return status  OperatingSystem.file should exist  ${default_download_path}${/}*${report_name}*
    run keyword if  '${fileExists}'=='${True}'  OperatingSystem.remove files  ${default_download_path}${/}*${report_name}*

Confirm Downloaded File
    [Arguments]  ${filePath}
    Should Not Be Empty  ${filePath}

Get Values From Excel Rows
    [Arguments]  ${fullPath}
    [Documentation]  Get some data from excel file by column_number

    Open Excel  ${fullPath}
    ${sheets}  Get Sheet Names
    ${qtd_lines}  Get Row Count  ${sheets[0]}
    ${result_list}  Create List
    ${header}  Get Row Values  ${sheets[0]}  0
    FOR  ${index}  IN RANGE  1  ${qtd_lines}
       ${row}  Get Row Values  ${sheets[0]}  ${index}
       ${clean_row}  Create Clean Excel Row  ${row}  ${header}
       ${clean_row_size}  Get Length  ${clean_row}
       Run Keyword If  ${clean_row_size} > 0
       ...  Append To List  ${result_list}  ${clean_row}
    END
    [Return]  ${result_list}

Create Clean Excel Row
    [Arguments]  ${list_columns}  ${header}
    ${clean_row}  Create Dictionary
    ${qtd_column}  Get Length  ${list_columns}
    FOR  ${column_index}  IN RANGE  0  ${qtd_column}
       ${header_value}  Set Variable  ${header[${column_index}]}
       ${value}  Set Variable  ${list_columns[${column_index}]}
       ${clean_header}  Replace String  ${header_value[1]}  ${SPACE}  _
       Run Keyword If  '${header_value[1]}'!='${value[1]}' and '${header_value[1]}'!='${EMPTY}'
       ...  Set To Dictionary  ${clean_row}  ${clean_header.lower()}=${value[1]}
    END
    [Return]  ${clean_row}

Get One Time Cash From DB
    [Arguments]  ${carrier_id}  ${card_num}  ${begin_date}  ${end_date}
    ${end_date}  Add Time To Date  ${end_date}  1 day  result_format=%Y-%m-%d
    ${query}  Catenate
    ...  SELECT TO_CHAR(ca.when,'%Y-%m-%d') AS date,
    ...         TO_CHAR(ca.when,'%H:%M') AS time,
    ...         ca.id AS type,
    ...         TRIM(TO_CHAR(ca.trans_id)) AS trans_id,
    ...         TRIM(ca.card_num) as card_number,
    ...         DECODE(SUBSTR(ci.info_validation,2,LENGTH(ci.info_validation)), NULL, '', SUBSTR(ci.info_validation,2,LENGTH(ci.info_validation))) AS driver_name,
    ...         TO_CHAR(CASE
    ...            WHEN ca.id='LOAD' THEN ca.balance-ca.amount
    ...            WHEN ca.id='WDRW' OR ca.id='RMVE' THEN ca.balance+ca.amount
    ...         END) AS prev,
    ...         TRIM(TO_CHAR(CASE
    ...            WHEN ca.id='WDRW' OR ca.id='RMVE' THEN (ca.amount)*-1
    ...            ELSE ca.amount
    ...         END, '-<<<<.<<')) AS amount,
    ...         TO_CHAR(ca.balance) AS balance
    ...  FROM cash_adv ca
    ...      JOIN cards c ON c.card_num = ca.card_num
    ...      LEFT JOIN card_inf ci ON c.card_num = ci.card_num AND ci.info_id = 'NAME'
    ...  WHERE c.carrier_id = ${carrier_id}
    ...  AND when BETWEEN '${begin_date} 00:00' AND '${end_date} 00:00'
    ...  AND ca.card_num = '${card_num}'
    ...  ORDER BY ca.when
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}