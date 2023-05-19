*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Setup for Transaction Report
Suite Teardown  Suite Teardown for Transaction Report

Force Tags  eManager  Reports  Transaction Report

*** Variables ***
${card}
${card_number}
${carrier}
${db_data}
${excel_data}
${last_transaction_date}
${location_id}
${minus_ten_days_date}
${start_date}
${excelFile}
${match_by_card}
${match_by_location}
${permission_status}
${report_name}  TransactionReport
${report_format}
${report_currency}
${show_entire_card_number}
# DYNAMICALLY DEFINED VARIABLES
${emanager}
${today}
@{filteredItems}
*** Test Cases ***

Transaction Report - EFS Transaction Report
    [Documentation]
    ...  Open eManager and download the Transaction Report for transactions
    ...  Check the data in each row of the report corresponding to a transaction
    ...  and compare the data to the database.
    [Tags]  JIRA:BOT-149  JIRA:BOT-451  qTest:31883102  qTest:29084824  JIRA:BOT-1982

    Log into eManager with a Carrier that have Transaction Report Permission
    Navigate to Select Program > Reports/Exports > Transaction Report
    Select "Card Last Transaction" as Date Range for Transaction Report;
    Select Show Entire Card Number;
    Select USD as Currency;
    Select Match By Card Number and Input Data;
    Select Excel as Report Format;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Get Transaction Report Excel Data;
    Get Transaction Report Data From Database;
    Compare Transaction Report Excel Data With Database

    [Teardown]  Teardown for Transaction Report

Transaction Report - By Date Range
    [Documentation]  View Transaction report by selecting a Date Range. TRS-14100
    [Tags]  JIRA:BOT-528  qTest:27261144  qTest:31883366  Regression  JIRA:BOT-1713  JIRA:BOT-1982  qTest:31605493

    Log into eManager with a Carrier that have Transaction Report Permission
    Navigate to Select Program > Reports/Exports > Transaction Report
    Select "Last Three Days" as Date Range for Transaction Report;
    Select Show Entire Card Number;
    Select USD as Currency;
    Select Match By Card Number and Input Data;
    Select Excel as Report Format;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Get Transaction Report Excel Data;
    Get Transaction Report Data From Database;
    Compare Transaction Report Excel Data With Database

    [Teardown]  Teardown for Transaction Report

Transaction Report - Without Match By Options
   [Documentation]  It should be possible to load a report without match by options.
   [Tags]  JIRA:BOT-1635  qTest:28957252  qTest:35245104  Regression  refactor

    Log into eManager with a Carrier that have Transaction Report Permission
    Navigate to Select Program > Reports/Exports > Transaction Report
    Select "Card Last Transaction" as Date Range for Transaction Report;
    Select Show Entire Card Number;
    Select USD as Currency;
    Select Excel as Report Format;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Get Transaction Report Excel Data;
    Get Transaction Report Data From Database;
    Compare Transaction Report Excel Data With Database

    [Teardown]  Teardown for Transaction Report

Use various Match By options
    [Documentation]  It should be possible to load a report with various match by options.
    [Tags]  JIRA:BOT-1636  qTest:28957253  Regression

    Log into eManager with a Carrier that have Transaction Report Permission
    Navigate to Select Program > Reports/Exports > Transaction Report
    Select "Card Last Transaction" as Date Range for Transaction Report;
    Select Show Entire Card Number;
    Select Match By Card Number and Input Data;
    Select Match By Location Id and Input Data;
    Select USD as Currency;
    Select Excel as Report Format;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Get Transaction Report Excel Data;
    Get Transaction Report Data From Database;
    Compare Transaction Report Excel Data With Database

    [Teardown]  Teardown for Transaction Report

Load a Report Using Different Contract And Currency
    [Tags]  JIRA:BOT-451  qTest:31883102  Regression  refactor
    [Setup]  Run Keywords  Make Sure Carrier Is Active  ${validCard.carrier.id}
    ...  AND  Initiate Test  DB=TCH  ENV=acpt

    ${startDate}  getdatetimenow  %Y-%m-%d
    ${endDate}  getdatetimenow  %Y-%m-%d

    Delete Pre Existent Report Files  TransactionReport

    Open Browser to eManager
    Log into eManager  ${validCard.carrier.id}  ${validCard.carrier.password}
    Go To Transaction Report
    Select Contract  ${validCard.policy.contract.id}
    Select Currency  CAD
    Set Date Range  ${startDate}  ${endDate}
    Select View Format Type  Excel     #EXCEL
    Download Transaction Report  Excel

    @{file}=  os.list directory  ${default_download_path}  *TransactionReport*
    ${downloadpath}=  os.normalize path  ${default_download_path}
    ${filPath}=  assign string  ${downloadpath}${/}${file[0]}
    tch logging  \n FILE:${filPath}  INFO
    Open Excel  ${filPath}
    ${sheets}=  Get Sheet Names
    ${rowCount}=  Get Row Count  ${sheets[0]}
    ${columnCount}=  Get Column Count  ${sheets[0]}
    Tch Logging  \n SHEETS: ${sheets} | COUNT:${rowCount} | COLUMN_COUNT:${columnCount}

    @{Excel_Data}  create list
    FOR  ${i}  IN RANGE  1  ${rowCount}
      ${vals}=  get row values  ${sheets[0]}  ${i}  ${True}
      append to list  ${Excel_Data}  ${vals}
    END

    FOR  ${vals}  IN  @{Excel_Data}
      Should Be Equal As Strings  ${vals[16][1]}  CAD/Liters
    END

    [Teardown]  Close Browser

Reports - Transaction Report By Settlement ID
    [Tags]  JIRA:BOT-607  JIRA:BOT-1714  qTest:27261145  Regression  refactor  #this test case is related to Merchant Reports and should be refactored and moved to another suite
    [Documentation]  View Transaction report by selecting a Settlement ID. TRS-14577
    [Setup]  Run Keywords  Make Sure Carrier Is Active  TPuser
    ...  AND  Initiate Test  DB=TCH  ENV=acpt

#   CONNECTING THE INSTANCES
    Tch Logging   \n - Connecting the instances
    Get Into DB  TCH
    Connect SSH  ${sshconnection}  ${sshname}  ${sshpass}
    Go Sudo
    Delete Pre Existent Report Files  TransactionReport
#   CRETATE VARIABLES FOR EXECUTION
    Tch Logging   - Creating Variables For Test Execution
    ${today}  getdatetimenow
    ${month}  getdatetimenow  %m
    ${startDate}  getdatetimenow  %Y-%m-%d  days=-7
    ${endDate}  getdatetimenow  %Y-%m-%d
    Set Test Variable  ${location}  650001
    ${amount}  Set Variable  10.00

#   MAKE SURE THERE'S GOING TO BE A TRANSSACTION FOR THE NEXT DAY
    Tch Logging   \n - Making sure there's a transaction every night for next day
    ${filepath}  set variable  /home/qaauto/el_robot/authStrings/rossAuthLogs/${month}/rossAuthLog${today}.log
    ${acString}  Create AC String  SHELL  ${location}  ${validCard.card_num}  ULSD=10.00
    run rossAuth  ${acString}  ${filepath}
#    Delete Pre Existent Report Files  TransactionReport
#   OPEN EMANAGER AND DOWNLOAD THE TRANSACTION REPORT
    Tch Logging   \n - Open eManager and Download a Transaction Report
    Open Browser  https://test.efsllc.com/security/merchantLogin.jsp  ${browser}  alias=eManager
    Maximize Browser Window
    Input Text  userId  TPuser
    Input Password  password  test123
    Click Element  logonUser
    Mouse Over  id=menubar_1x2
    Mouse Over  //td[@class="nlsitem" and text()="Merchant Manager"]
    Click Element  //td[@class="nlsitem" and text()="Transaction Report By Settlement ID"]
    Click Element  //a[contains(text(),'${location}')]

    ${settle_id}  get value  //select[@name='settlementIdSelect']/option[1]
    Tch Logging  SETTLE_ID:${settle_id}

    ${inv_query}  catenate  SELECT invoice FROM transaction WHERE location_id=${location}
    ...     AND card_num='${validCard.card_num}' AND trans_date < '${endDate} 00:00'
    ...     AND settle_id=${settle_id} ORDER BY trans_date DESC limit 1
    ${inv_num}  Query And Strip  ${inv_query}
    Tch Logging  \n QUERY:${inv_query}
    Tch Logging  \n RESULT:${inv_num.__str__()}

    Select From List By Value  viewFormat  4    #EXCEL FORMAT
    Select Checkbox  invoiceFilter
    Input Text  invoice  ${inv_num.__str__()}
    sleep  2
    Click Element  submitInSettlementId
    Wait Until Element Is Visible  //a[contains(@href, "SettlementReport.action") and text()="Click here to view the document"]  timeout=30
    Click Element  //a[contains(@href, "SettlementReport.action") and text()="Click here to view the document"]

#   DOWNLOAD THE EXCECL FILE, MOVE IT TO REPORT DIRECTORY AND OPEN IT
    Tch Logging   \n - Download EXCEL, Move to Report Directory and Open EXCEL
    Sleep  5
    ${fileExists}  os.file should exist  ${default_download_path}${/}*TransactionReport*
    ${file}  os.list directory  ${default_download_path}  *TransactionReport*.xls
    ${filePath}  os.normalize path  ${default_download_path}${/}${file[0]}
    open excel  ${filePath}

    ${sheets}=  get sheet names
    tch logging  \n SHEETS: ${sheets}
    ${rowCount}=  get row count  ${sheets[0]}
    tch logging  \n COUNT:${rowCount}
    ${columnCount}=  get column count  ${sheets[0]}
    tch logging  \n COLUMN_COUNT:${columnCount}

    @{Excel_Data}  create list
    :FOR  ${i}  IN RANGE  1  ${rowCount}
    \  ${vals}=  get row values  ${sheets[0]}  ${i}  ${True}
    \  append to list  ${Excel_Data}  ${vals}

    :FOR  ${vals}  IN  @{Excel_Data}
    \  Tch Logging  Checking Excel Row:${vals}
    \  Check Excel Row For Merchant Carrier  ${vals}

    Close Browser

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Disconnect From Database

Transaction Report - Restricted chain displayed for CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747472  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are displayed for CT7 carriers in Transaction Report

	Setup 'a' CT7 Carrier with Transaction Report Permission
	Log Carrier into eManager with Transaction Report permission
	Go to Select Program > Reports/Exports > Transaction Report
	Check the main screen chain id dropdown 'has' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has' CT7 carrier chain id
	Check the search results 'has' CT7 carrier location id

	[Teardown]  Close Browser

Transaction Report - Restricted chain not displayed for non CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747468  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are not displayed for non CT7 carriers in Transaction Report

	Setup 'non' CT7 Carrier with Transaction Report Permission
	Log Carrier into eManager with Transaction Report permission
	Go to Select Program > Reports/Exports > Transaction Report
	Check the main screen chain id dropdown 'has no' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Check the search results 'has no' CT7 carrier location id

	[Teardown]  Close Browser

*** Keywords ***
Initiate Test
    [Arguments]  ${DB}  ${ENV}

#    I LIKE TO PRINT A NEWLINE TO START. NOT NECESSARY.
    log to console  ${empty}

#    OPEN DB CONNECTION
    get into db  ${DB}
    set test variable  ${setup}  ${ENV}
    tch logging  ENVIRONMENT SET TO ${ENV}  ALL
    tch logging  eManager URL: ${emanager}  ALL

#    IF ANY MONEY CODE USE REPORT EXIST IN THE DOWNLOADS DIRECTORY, THEN DELETE THEM ALL.
    @{files}=  os.list directory  ${default_download_path}  *TransactionReport*
    print list  @{files}
    :FOR  ${i}  IN  @{files}
    \   tch logging  Permanently removing ${default_download_path}/${i}  WARN
    \   os.remove file  ${default_download_path}/${i}

#End Test
##    UNPLUG EVERYTHING
#    disconnect from database
#    close all browsers

Get Carrier Credentials With Card
    [Arguments]  ${card}

#    GET MEMBER ID AND PASSWORD FROM CARRIER
    ${query}=  catenate
    ...  select m.member_id, trim(m.passwd) as passwd
    ...  from member m, cards c
    ...  where c.carrier_id = m.member_id
    ...  and c.card_num = '${card}'

    ${member}=  query and strip to dictionary  ${query}

    [Return]  ${member}

Go To Transaction Report

    Go To  ${emanager}/cards/Transaction.action?outputMode=report

Set Date Range
    [Arguments]  ${start_date}  ${end_date}

    input text  transFilter.begDate  ${start_date}
    input text  transFilter.endDate  ${end_date}

Select Display Feature
    [Arguments]  ${feature}

    click radio button  //*[text() = "${feature}"]/../*[@type = "checkbox"]

Select Currency
    [Arguments]  ${value}

    select from list by Value  //*[@name="currency"]  ${value}

Select Contract
    [Arguments]  ${contract}

    run keyword if  '${contract.lower}'=='all'
    ...  run keywords
    ...     click radio button  allContract  AND
    ...     return from keyword

    unclick radio button  allContract
    select from list by value  selectedContract  ${contract}

Select Group By
    [Arguments]  ${group_by}

    select from list by label  groupBy  ${group_by}

Select Sort By
    [Arguments]  ${sort_by}

    select from list by label  sortBy  ${sort_by}

Select View Format Type
    [Arguments]  ${format}

    select from list by label  viewFormat  ${format}

Select Match By
    [Arguments]  ${match_by}  ${value}

    click radio button  //*[text() = "${match_by}"]/../*[@type="checkbox"]
    @{dropdown_items}=  create list
    ...  override
    ...  funding
    ...  country
    ...  state/province
    ...  chain id
    ...  item
    ...  ar number
    run keyword if  '${match_by.lower()}' in @{dropdown_items}
    ...     select from list by label  //*[text() = "${match_by}"]/../../*[2]/*[1]  ${value}
    ...  ELSE
    ...     input text  //*[text() = "${match_by}"]/../../*[2]/*[1]  ${value}

Download Transaction Report
    [Arguments]  ${report_type}

#    DOWNLOAD THE MONEY CODE USE REPORT FOR A DATE RANGE OF TODAY AS A PDF.
    click on  Submit
    open new window  text=Click here to view the document  timeout=60
#    SLEEP TO ALLOW THE FILE TO DOWNLOAD
    ${extension}  Set Variable If  '${report_type}'=='Pdf'  pdf  xls
    os.Wait Until Created  ${default_download_path}${/}*TransactionReport*.${extension}
#    close window
#    select window  main
#    close browser

Create Invoice Number
    [Documentation]  Returns a random number as the invoice. If the transaction is
    ...  an IMPERIAL or HUSKY transaction then the Test Case should truncate the
    ...  returned value to 4 digits.

    ${invoice}=  evaluate  random.randint(100000, 99999999)  random

    [Return]  ${invoice.__str__()}

Check Transaction Report In Excel
    @{file}=  os.list directory  ${default_download_path}  *TransactionReport*
    log to console  ${file[0]}
    ${downloadpath}=  os.normalize path  ${default_download_path}
    ${filPath}=  assign string  ${downloadpath}${/}${file[0]}
    tch logging  \n my file is: ${filPath}  INFO
    open excel  ${filPath}
    ${sheets}=  get sheet names
    tch logging  \n SHEETS: ${sheets}
    ${rowCount}=  get row count  ${sheets[0]}
    tch logging  \n COUNT:${rowCount}
    ${columnCount}=  get column count  ${sheets[0]}
    tch logging  \n COLUMN_COUNT:${columnCount}

    ${today}=  getdatetimenow  %Y-%m-%d
    Set Suite Variable  ${today}

    @{Excel_Data}  create list
    :FOR  ${i}  IN RANGE  1  ${rowCount}
    \  ${vals}=  get row values  ${sheets[0]}  ${i}  ${True}
    \  append to list  ${Excel_Data}  ${vals}

    :FOR  ${vals}  IN  @{Excel_Data}
    \  Check Excel Row  ${vals}
    \  Tch Logging  Checking Excel Row:${vals}

Check Excel Row
    [Arguments]  ${row}
    ${main_query}=  catenate
      ...       SELECT trans_id, trim(RIGHT (t.card_num,5)) AS card_num, TRIM(t.invoice) AS invoice,
      ...       to_char(t.trans_date,'%Y-%m-%d') AS date, to_char(t.trans_date,'%H:%M') AS time,
      ...       trim(l.name) AS NAME, trim(l.city) AS CITY, trim(l.state) AS STATE
      ...       FROM transaction t, location l
      ...       WHERE t.location_id = l.location_id AND t.card_num = '${card}' AND t.invoice='${row[3][1]}'
      ...       AND l.name='${row[7][1]}' AND l.city='${row[8][1]}'
      ...       AND l.state='${row[9][1]}'
      ...       AND t.trans_date >= '${row[1][1]} 00:00' ORDER BY t.trans_date ASC
   ${db_results}  Query And Strip To Dictionary  ${main_query}

    Should Be Equal As Strings  ${db_results.card_num}  ${row[0][1]}
    Should Be Equal As Strings  ${db_results.date}  ${row[1][1]}
    Should Be Equal As Strings  ${db_results.time}  ${row[2][1]}
    Should Be Equal As Strings  ${db_results.invoice}  ${row[3][1]}
    Should Be Equal As Strings  ${db_results.name}  ${row[7][1]}
    Should Be Equal As Strings  ${db_results.city}  ${row[8][1]}
    Should Be Equal As Strings  ${db_results.state}  ${row[9][1]}

    ${trans_line}=  catenate
    ...       SELECT cat AS Product, qty AS Quantity, amt AS Amount FROM trans_line
    ...       WHERE trans_id = ${db_results.trans_id} AND cat='${row[11][1]}' AND qty=${row[12][1]} AND amt=${row[13][1]}
    ${transLine_Result}  Query And Strip To Dictionary  ${trans_line}

    Tch Logging  IT CHECKS WITH THE DB!
    log to console  ${empty}

Check Excel Row For Merchant Carrier
    [Arguments]  ${row}
    ${main_query}=  catenate
      ...       SELECT t.settle_id, l.location_id, to_char(t.trans_date,'%Y-%m-%d %H:%M') AS date,
      ...       TRIM(t.invoice) AS invoice, trim(RIGHT (t.card_num,5)) AS card_num, c.card_type,
      ...       m.name, t.inv_total, t.trans_id
      ...       FROM TRANSACTION t, LOCATION l, CARDS c, member m
      ...       WHERE t.location_id = l.location_id
      ...       AND   t.carrier_id=m.member_id
      ...       AND   c.card_num=t.card_num
      ...       AND   l.location_id=${row[1][1]}
      ...       AND   t.invoice='${row[3][1]}'
      ...       AND   t.settle_id=${row[0][1]}


   ${db_results}  Query And Strip To Dictionary  ${main_query}
   ${db_results.card_type}  Strip String  ${db_results.card_type}


    Should Be Equal As Strings  ${db_results.settle_id}  ${row[0][1]}
    Should Be Equal As Strings  ${db_results.location_id}  ${row[1][1]}
    Should Be Equal As Strings  ${db_results.date}  ${row[2][1]}
    Should Be Equal As Strings  ${db_results.invoice}  ${row[3][1]}
    Should Be Equal As Strings  ${db_results.card_type.__str__()}  ${row[4][1]}
    Should Be Equal As Strings  ${db_results.card_num}  ${row[5][1]}
    Should Be Equal As Strings  ${db_results.name}  ${row[6][1]}
    Should Be Equal As Numbers  ${db_results.inv_total}  ${row[14][1]}

    ${trans_line}=  catenate
    ...       SELECT cat AS Item, amt AS Amount, qty AS Quantity FROM trans_line
    ...       WHERE trans_id = ${db_results.trans_id} AND cat='${row[12][1]}' AND qty=${row[16][1]} AND amt=${row[14][1]}
    ${transLine_Result}  Query And Strip To Dictionary  ${trans_line}

    Tch Logging  IT CHECKS WITH THE DB!
    log to console  ${empty}

#Remove Report File
#    [Arguments]  ${report_name}
#    ${report_name}  Split String  ${report_name}  .
#    ${file}  os.List Directory  ${default_download_path}  *${report_name[0]}*.${report_name[1]}
#    ${files_len}  Get Length  ${file}
#    :FOR  ${index}  IN RANGE  0  ${files_len}
#    \  ${filePath}  os.Normalize Path  ${default_download_path}${/}${file[${index}]}
#    \  os.Get Binary File  ${filePath}
#    \  os.Remove File  ${filePath}

Delete Pre Existent Report Files
    [Arguments]  ${report_name}
    @{files}=  os.list directory  ${default_download_path}  *${report_name}*
    print list  @{files}
    :FOR  ${i}  IN  @{files}
       tch logging  Permanently removing ${default_download_path}/${i}  WARN
       os.remove file  ${default_download_path}/${i}
    END

Setup for Transaction Report
    [Documentation]  Keyword Setup for FRNT-710

    Turn OFF Excel Report Flag to xls/xlsx.

    Get Into DB  MySQL

#Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

#    ${query}  Catenate  SELECT c.carrier_id FROM cards c
#    ...  JOIN transaction t ON t.card_num = c.card_num
#    ...  WHERE 1=1
#    ...  AND EXISTS (SELECT 1 FROM contract co WHERE co.carrier_id = c.carrier_id group by co.carrier_id having count(co.carrier_id) > 2)
#    ...  AND EXISTS (SELECT 1 FROM cards c WHERE carrier_id = carrier_id AND card_num NOT LIKE '5%')
#    ...  AND c.carrier_id IN ${list_2};
#
#    ${carrier}  Find Carrier Variable  ${query}  carrier_id

#Get a Card from Selected Carrier Id
    ${query}  Catenate  SELECT card_num
    ...  FROM cards
    ...  WHERE card_num NOT LIKE '%OVER'
    ...  AND card_type='TCH'
    ...  AND last_used > CURRENT - 10 units DAY
    ...  AND last_used < CURRENT - 1 units DAY
    ...  AND carrier_id IN ${list_2}
    ...  AND carrier_id NOT IN ('185643','148697','390056','701501','129698','138851','100025','100032')
    ...  ORDER BY last_trans LIMIT 50;

    ${card}  Find Card Variable  ${query}

    ${carrier}  Set Carrier Variable  ${card.carrier.id}

    Ensure Carrier has User Permission  ${carrier.id}  TRANSACTION_LOG

    ${minus_ten_days_date}  getDateTimeNow  %Y-%m-%d  days=-10
    ${today}  getDateTimeNow  %Y-%m-%d

    Set Suite Variable  ${carrier}
    Set Suite Variable  ${card_number}  ${card.num}
    #log to console  ${card_number}
    Set Suite Variable  ${minus_ten_days_date}

    Get Card Last Transaction

Turn ${value} Excel Report Flag to xls/xlsx.
    [Documentation]  This keyword will change the excel report format to xlsx if flag is ON and xls if flag is OFF.
    ...  This is a measure to deal with reports while we dont have support to xlsx files.

    Get Into DB  MySQL

    ${flag}  Set Variable If  '${value}'=='ON'  Y  N

    ${sql_string}  Catenate  UPDATE setting SET value = '${flag}' WHERE `PARTITION` = 'shared' AND name = 'com.tch.export.xlsx';
    Execute SQL String  ${sql_string}

Get Card Last Transaction
    [Documentation]
    [Arguments]  ${instance}=TCH

    Get Into DB  ${instance}

    ${query}  Catenate  SELECT TO_CHAR(pos_date, '%Y-%m-%d') AS date,
    ...  location_id
    ...  FROM transaction
    ...  WHERE card_num='${card_number}'
    ...  ORDER BY trans_date DESC LIMIT 1;

    ${last_transaction}  Query and Strip to Dictionary  ${query}

    Set Suite Variable  ${last_transaction_date}  ${last_transaction['date']}
    Set Suite Variable  ${location_id}  ${last_transaction['location_id']}

    #log to console  ${last_transaction_date}
    #log to console  ${location_id}

Teardown for Transaction Report
    [Documentation]  Teardown for Transaction Report

    Close Browser
    Remove Report File  ${report_name}

Suite Teardown for Transaction Report
    [Documentation]  Suite Teardown for Transaction Report

    Turn ON Excel Report Flag to xls/xlsx.

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  TRANSACTION_LOG

Log into eManager with a Carrier that have Transaction Report Permission
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Reports/Exports > Transaction Report
    [Documentation]  Go to Desired Page
    Go To  ${emanager}/cards/Transaction.action?outputMode=report

Select Show Entire Card Number;
    [Documentation]

    Select Checkbox  //input[@name='entireCardNumber']

    Set Test Variable  ${show_entire_card_number}  Yes

Select "${date}" as Date Range for Transaction Report;
    [Documentation]  Select date range for Transaction Report
#
    ${start_date}  Set Variable If  '${date}'=='Last Three Days'  ${minus_ten_days_date}  ${last_transaction_date.__str__()}

    Input Text  transFilter.begDate  ${start_date}
    Input Text  transFilter.endDate  ${last_transaction_date.__str__()}

    Set Test Variable  ${start_date}

Select ${currency} as Currency;
    [Documentation]

    Select From List by Value  //select[@name='currency']  ${currency}
    ${report_currency}  Get Text  //option[@value='${currency}']

    Set Test Variable  ${report_currency}

Select Match By Card Number and Input Data;
    [Documentation]  Select match by option and input card number

    Select Checkbox  //input[@name='transFilter.card.doFilter']
    Input Text  //input[@name='displayNumber']  ${card_number}

    Set Test Variable  ${match_by_card}  Yes

Select Match By Location Id and Input Data;
    [Documentation]  Select match by option and input card number

    Select Checkbox  //input[@name='transFilter.location.doFilter']
    Input Text  //input[@name='locationId']  ${location_id}

    Set Test Variable  ${match_by_Location}  Yes

Select ${report_format} as Report Format;
    [Documentation]  Options are Excel or PDF

    Select From List By label  viewFormat  ${report_format}

    Set Test Variable  ${report_format}

Download Excel Report File;
    [Documentation]  Keyword to download excel format file

    ${excelFile}  Download Report File  ${Report_Name}  xls

    Set Test Variable  ${excelFile}

Verify if Excel Report is Downloaded;
    [Documentation]  Keyword to check if excel Report is downloaded

    Assert if File is Dowloaded  ${report_name}.xls

Get Transaction Report Excel Data;
#
    ${excel_data}  Get Values From Excel Rows  ${excelFile}

    Set Test Variable  ${excel_data}

Get Transaction Report Data From Database;
    [Documentation]

    Get Into DB  TCH

    ${query}  Catenate  SELECT
    ...  t.trans_id,
    ...  t.card_num,
    ...  TRIM(RIGHT (t.card_num,5)) AS card_num_last_5_digits,
    ...  t.trans_date,
    ...  TO_CHAR(t.trans_date,'%Y-%m-%d') AS tran_date,
    ...  TO_CHAR(t.trans_date,'%H:%M') AS time,
    ...  TRIM(t.invoice) AS invoice,
    ...  t.location_id,
    ...  l.name AS location_name,
    ...  l.city,
    ...  l.state AS state_prov,
    ...  t.carr_fee AS fees,
    ...  TRIM(tl.cat) AS item,
    ...  tl.ppu AS unit_price,
    ...  tl.qty,
    ...  tl.amt,
    ...  tl.billing_flag AS db
    ...  FROM transaction t
    ...      INNER JOIN cards c ON c.card_num = t.card_num
    ...      JOIN location l ON t.location_id = l.location_id
    ...      JOIN trans_line tl ON t.trans_id = tl.trans_id
    ...      AND c.carrier_id = t.carrier_id  WHERE 1=1
    ...      AND t.pos_date BETWEEN '${start_date} 00:00' AND '${last_transaction_date} 23:59'
    ...      AND t.carrier_id = ${carrier.id}

    ${query}  Set Variable If  '${match_by_card}'=='Yes'  ${query} AND c.card_num = '${card_number}'  ${query}
    ${query}  Set Variable If  '${match_by_location}'=='Yes'  ${query} AND t.location_id='${location_id}'  ${query}

    ${query}  Catenate  ${query} ORDER BY t.trans_date, t.trans_id, tl.line_id;

   ${db_data}   Query To Dictionaries  ${query}

   Set Test Variable  ${db_data}

Compare Transaction Report Excel Data With Database

    ${size}  Get List Size  ${db_data}

    FOR  ${i}  IN RANGE  0  ${size}
      #log to console  ${db_data[${i}]} ${excel_data[${i}]}
      Should be Equal as Strings  ${db_data[${i}]['card_num']}  ${excel_data[${i}]['card_#']}
      Should be Equal as Strings  ${db_data[${i}]['tran_date']}  ${excel_data[${i}]['tran_date']}
      Should be Equal as Strings  ${db_data[${i}]['invoice']}  ${excel_data[${i}]['invoice']}
      Should be Equal as Strings  ${db_data[${i}]['location_name']}  ${excel_data[${i}]['location_name']}
      Should be Equal as Strings  ${db_data[${i}]['city']}  ${excel_data[${i}]['city']}
      Should be Equal as Strings  ${db_data[${i}]['state_prov']}  ${excel_data[${i}]['state/_prov']}
      Should be Equal as Numbers  ${db_data[${i}]['fees']}  ${excel_data[${i}]['fees']}
      Should be Equal as Strings  ${db_data[${i}]['item']}  ${excel_data[${i}]['item']}
      Should be Equal as Numbers  ${db_data[${i}]['unit_price']}  ${excel_data[${i}]['unit_price']}
      Should be Equal as Numbers  ${db_data[${i}]['qty']}  ${excel_data[${i}]['qty']}
      Should be Equal as Numbers  ${db_data[${i}]['amt']}  ${excel_data[${i}]['amt']}
      Should be Equal as Strings  ${db_data[${i}]['db']}  ${excel_data[${i}]['db']}
      Should be Equal as Strings  ${report_currency}  ${excel_data[${i}]['currency']}
    END

Setup '${condition}' CT7 Carrier with Transaction Report Permission
    [Documentation]  Setup for a/non CT7 carrier with Transaction Report permission

    Get Into DB  Mysql
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 150;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')
    # Build query to get a/non CT7 carrier
    ${CT7Carrier}  Run Keyword If    '${condition}' == 'non'    Set Variable    not in    ELSE    Set Variable    in
    ${query}  Catenate  SELECT member_id FROM member m
    ...  JOIN contract c
    ...  ON m.member_id = c.carrier_id
    ...  WHERE m.mem_type='C'
    ...  AND m.status='A'
    ...  AND m.member_id ${CT7Carrier} (SELECT carrier_id FROM contract WHERE issuer_id in (194148, 194149))
    ...  AND m.member_id IN ${list_2}
    ...  AND m.member_id NOT IN ('381776');
    # Find carrier with given query and set as suite variable
    ${carrier}  Find Carrier Variable  ${query}  member_id
    Set Suite Variable  ${carrier}
    # Ensure carrier has Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  TRANS_REPORT

Log Carrier into eManager with Transaction Report permission
    [Documentation]  Log carrier into eManager with Transaction Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Reports/Exports > Transaction Report
    [Documentation]  Go to Select Program > Reports/Exports > Transaction Report

    Go To  ${emanager}/cards/Transaction.action?outputMode=report
    Wait Until Page Contains    Match By (Optional):

Select the Location ID
    Click Element    //input[@name="transFilter.location.doFilter"]

Click Look Up Location button
    Click Button    name=lookUpLocation

Select the Location ID and click the 'Look Up Location' button
    Select the Location ID
    Click Look Up Location button
    Wait Until Page Contains  Search Location Type

Check the CT7 carrier chain id
    [Arguments]    ${condition}    ${chainIds}
    Run Keyword If    '${condition}' == 'has'    List Should Contain Value    ${chainIds}    101 - WEX NAF C STORES
    ...  ELSE    List Should Not Contain Value    ${chainIds}    101 - WEX NAF C STORES

Check the main screen chain id dropdown '${condition}' CT7 carrier chain id
    ${chainIds}    Get List Items    //select[@name="transFilter.chainId.value"]
    Check the CT7 carrier chain id    ${condition}    ${chainIds}

Check the chain id dropdown '${condition}' CT7 carrier chain id
    ${chainIds}    Get List Items    //select[@name='chainId']
    Check the CT7 carrier chain id    ${condition}    ${chainIds}

Check the search results '${condition}' CT7 carrier location id
    Get Into DB  TCH
    # Get chaind id 101 location id
    ${nonCT7query}  Catenate  SELECT location_id FROM location WHERE chain_id = '101';
    ${CT7query}  Catenate  SELECT il.location_id
    ...    FROM issr_loc il
    ...    INNER JOIN contract c
    ...    ON il.issuer_id = c.issuer_id
    ...    WHERE c.carrier_id = '${carrier.id}'
    ...    AND il.location_id
    ...    IN (SELECT location_id FROM location WHERE chain_id = '101')
    ...    ORDER BY location_id DESC;
    ${locationId}    Run Keyword If    '${condition}'=='has'    Query And Strip    ${CT7query}
    ...    ELSE    Query And Strip    ${nonCT7query}
    Input Text    name=id    ${locationId}
    Click Button    name=searchLocation
    Run Keyword If    '${condition}'=='has'    Wait Until Element is Visible    //td/a[contains(text(), '${locationId}')]
    ...    ELSE    Wait Until Page Contains    Search Location could not find data.