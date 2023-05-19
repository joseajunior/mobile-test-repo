*** Settings ***
Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyExcel
Library  String
Library    DateTime
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.ftp.PyFTP.FTPLibrary
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  Reports  Money Code Use Report  eManager

#Suite Setup  Suite Setup
Suite Teardown  Suite Teardown

*** Variables ***
${carrier}  106007
${amount}  10.00
${report_name}    MoneyCodeUseReport
${reason_code_default}    5

*** Test Cases ***
Check Money Code Tier Fee And Check Fee
    [Tags]  JIRA:BOT-122  qTest:34444529  refactor
    [Documentation]
    ...  Create two money code transactions using the same money code and verify
    ...  that the tier fee and check fees add up and that it reflects in the Money Code
    ...  Use Report in eManager.
    [Setup]  Test Setup BOT-122

    Navigate To Money Code Use Report
    Submit Immediate Report  ${report_name}  Excel  ${contract[0]}  ${today}  ${today}  code_id=${code_id}
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${today}  ${today}  code_id=${code_id}
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}
    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Valid Dates
    [Tags]  JIRA:BOT-444  qTest:34444523  Regression  refactor
    [Documentation]  Download a Money Code Use Report using Valid Dates and Assert data with Database.
    [Setup]  Test Setup
    ${today}  getDateTimeNow  %Y-%m-%d

    Navigate To Money Code Use Report
    Submit Immediate Report  ${report_name}  Excel  ${contract[0]}  ${today}  ${today}
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${begin_date}  ${end_date}
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}
    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Different Contracts
    [Tags]  JIRA:BOT-444  qTest:30058503  Regression  refactor
    [Documentation]  Download a Money Code Use Report using Different Contracts and Assert data with Database.
    ${today}  getDateTimeNow  %Y-%m-%d

    FOR  ${i}  IN  @{contract}
      Test Setup
      Navigate To Money Code Use Report
      Submit Immediate Report  ${report_name}  Excel  ${i}  ${today}  ${today}
      Assert if File is Dowloaded  ${report_name}.xls
      Get Money Code Use Report Information  ${filePath}
      Get Money Code Use From Database  ${carrier}  ${i}  ${begin_date}  ${end_date}
      Validate Report With Database  ${report_dictionary}  ${database_dictionary}
      Remove Report File  ${report_name}
      Close Browser
    END

Load a Report Using Different Currencies
    [Tags]  JIRA:BOT-444  qTest:34444524  Regression  refactor
    [Documentation]  Download a Money Code Use Report using Different Currencies and Assert data with Database.
    [Setup]  Test Setup
    ${today}  getDateTimeNow  %Y-%m-%d

    Navigate To Money Code Use Report
    Submit Immediate Report  ${report_name}  Excel  ${contract[0]}  ${today}  ${today}  CAD
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${begin_date}  ${end_date}  CAD
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}
    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Match By Code Id
    [Tags]  JIRA:BOT-444  qTest:34444525  Regression  refactor
    [Documentation]  Download a Money Code Use Report using Match By Code Id and Assert data with Database.
    [Setup]  Test Setup
    ${today}  getDateTimeNow  %Y-%m-%d

    Get Code Id For Test Execution  ${today}
    Navigate To Money Code Use Report
    Submit Immediate Report  ${report_name}  Excel  ${contract[0]}  ${today}  ${today}  code_id=${code_id}
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${today}  ${today}  code_id=${code_id}
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}
    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Match By Check Number
    [Tags]  JIRA:BOT-444  qTest:34444526  Regression  refactor
    [Documentation]  Download a Money Code Use Report using Match By Check Number and Assert data with Database.
    [Setup]  Test Setup
    ${today}  getDateTimeNow  %Y-%m-%d

    Get Check Number For Test Execution  ${today}
    Navigate To Money Code Use Report
    Submit Immediate Report  ${report_name}  Excel  ${contract[0]}  ${today}  ${today}  check_number=${check_number}
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${today}  ${today}  check_number=${check_number}
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}
    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Match By Issued By
    [Tags]  JIRA:BOT-444  qTest:34444527  Regression  refactor
    [Documentation]  Download a Money Code Use Report using Match By Issued By and Assert data with Database.
    [Setup]  Test Setup
    ${today}  getDateTimeNow  %Y-%m-%d

    Get Issued By For Test Execution  ${today}
    Navigate To Money Code Use Report
    Submit Immediate Report  ${report_name}  Excel  ${contract[0]}  ${today}  ${today}  issued_by=${issued_by}
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${today}  ${today}  issued_by=${issued_by}
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}
    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Match By Issued To
    [Tags]  JIRA:BOT-444  qTest:34444528  Regression  refactor
    [Documentation]  Download a Money Code Use Report using Match By Issued To and Assert data with Database.
    [Setup]  Test Setup
    ${today}  getDateTimeNow  %Y-%m-%d

    Get Issued To For Test Execution  ${today}
    Navigate To Money Code Use Report
    Submit Immediate Report  ${report_name}  Excel  ${contract[0]}  ${today}  ${today}  issued_to=${issued_to}
    Assert if File is Dowloaded  ${report_name}.xls
    Get Money Code Use Report Information  ${filePath}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${today}  ${today}  issued_to=${issued_to}
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}
    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Reason Money Code in Report
    [Tags]    JIRA:BOT-4997    JIRA:FRNT-2153    qTest:116611260
    [Documentation]    Ensure reason money code column is displayed in Money Code Use Report and is filled with
    ...    correct data
    [Setup]    Setup Carrier With Used Money Codes With Code Reason Set    ${reason_code_default}

    Log Carrier into eManager with Money Code Use Report permission
    Go to Select Program > Reports/Exports > Money Code Use Report
    Open and Create Money Code Use Report
    Check Reason Code Description in Report

*** Keywords ***
Suite Setup
    Get Into DB  TCH
    Set Suite Variable  ${TEST NAME}  IssueCheck

    ${validCard.carrier.password}    Get Carrier Password  ${carrier}
    Log Into Card Management Web Services  ${carrier}  ${validCard.carrier.password}
    Connect SSH  ${sshConnection}  ${sshName}  ${sshPass}
    Go Sudo

    Get Contracts From Carrier  ${carrier}

    FOR  ${i}  IN  @{contract}
      Issue Check For Test Execution
      Issue Money Code For Test Execution  ${i}
      Authorize a Check  231010  ${checknumber}  ${moneycode}  ${amount}
    END

    Set Suite Variable  ${validCard.carrier.password}

Test Setup
    Open Emanager  ${carrier}  ${validCard.carrier.password}

Test Setup BOT-122
    Open Emanager  ${carrier}  ${validCard.carrier.password}
    ${today}  getDateTimeNow  %Y-%m-%d
    ${location}  Set Variable  231010

    ${money_code}  IssueMoneyCode  ${contract[0]}  100  BOT122
    ${check_one}  CreateCheck
    ${check_two}  CreateCheck

    Authorize a Check  ${location}  ${check_one}  ${money_code}  10
    Authorize a Check  ${location}  ${check_two}  ${money_code}  20

    ${code_id}  Query And Strip  SELECT code_id FROM mon_codes WHERE express_code='${money_code}'

    Set Test Variable  ${today}
    Set Test Variable  ${code_id}

Suite Teardown
    Disconnect From Database
    Close Browser

Navigate To Money Code Use Report
    Go To  ${emanager}/cards/MoneyCodeUseReport.action
    Wait Until Element Is Visible  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Get Text  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Remove From String  ${SPACE}  ${name}
    ${report_name}  Get eManager Report Name  ${name}
    Set Test Variable  ${report_name}

Submit Immediate Report
    [Arguments]  ${report_name}  ${report_type}  ${contract}  ${begin_date}  ${end_date}  ${currency}=USD  ${code_id}=${empty}  ${check_number}=${empty}  ${issued_by}=${empty}  ${issued_to}=${empty}

    Click Element  //input[@title='Immediate Report']

    #Date Selection
    Input Text  startDate  ${begin_date}
    Input Text  endDate  ${end_date}

    #Currency Selection
    Select From List By Value  currency  ${currency}

    #Contract Selection
    Unselect Checkbox  allContract
    Wait Until Element is Enabled  selectedContract
    Double Click On  //option[@value='${contract.__str__()}']
    #Select From List By Value  selectedContract  ${contract.__str__()}

    #Match By Filters
    Run Keyword If  '${code_id}'!='${empty}'  Match By Code Id  ${code_id.__str__()}
    Run Keyword If  '${check_number}'!='${empty}'  Match By Check Number  ${check_number.__str__()}
    Run Keyword If  '${issued_by}'!='${empty}'  Match By Issued By  ${issued_by.__str__()}
    Run Keyword If  '${issued_to}'!='${empty}'  Match By Issued To  ${issued_to.__str__()}

    #Report Format
    Select From List by Label  viewFormat  ${report_type}

    #Download Report
    Click Element  viewReport
    Wait Until Element Is Visible  //a[text()='Click here to view the document']  timeout=10
    Click Element  //a[text()='Click here to view the document']
    ${extension}  Set Variable If  '${report_type}'=='Pdf'  pdf  xls
    os.Wait Until Created  ${default_download_path}${/}*${report_name}*${extension}

    Set Test Variable  ${begin_date}
    Set Test Variable  ${end_date}

Match By Code Id
    [Arguments]  ${code_id}
    Select Checkbox  idShow
    Wait Until Element is Enabled  codeId
    Input Text  codeId  ${code_id}

Match By Check Number
    [Arguments]  ${check_number}
    Select Checkbox  checkShow
    Wait Until Element is Enabled  checkNumber
    Input Text  checkNumber  ${check_number}

Match By Issued By
    [Arguments]  ${issued_by}
    Select Checkbox  whoShow
    Wait Until Element is Enabled  issuedBy
    Input Text  issuedBy  ${issued_by}

Match By Issued To
    [Arguments]  ${issued_to}
    Select Checkbox  toShow
    Wait Until Element is Enabled  issuedTo
    Input Text  issuedTo  ${issued_to}

Get Money Code Use From Database
    [Arguments]  ${carrier_id}  ${contract}  ${begin_date}  ${end_date}  ${currency}=USD  ${code_id}=${empty}  ${check_number}=${empty}  ${issued_by}=${empty}  ${issued_to}=${empty}
    ${end_date}  Add Time To Date  ${end_date}  1 day  result_format=%Y-%m-%d
    ${query}  Catenate
    ...  SELECT voided, issued_by, issued_to, issued_date,
    ...    CASE
    ...      WHEN SUBSTR(fee,length(fee),length(fee)) = 0 THEN SUBSTR(fee,0,length(fee)-1)
    ...      ELSE fee
    ...    END AS fee,
    ...    CASE
    ...      WHEN SUBSTR(original_amt,length(original_amt),length(original_amt)) = 0 THEN SUBSTR(original_amt,0,length(original_amt)-1)
    ...      ELSE original_amt
    ...    END AS original_amt,
    ...    check_num, date_used,
    ...    CASE
    ...      WHEN SUBSTR(amount_used,length(amount_used),length(amount_used)) = 0 THEN SUBSTR(amount_used,0,length(amount_used)-1)
    ...      ELSE amount_used
    ...    END AS amount_used,
    ...    DECODE(currency, NULL, '', currency) AS currency,
    ...    one_time_,
    ...        exact_amt,
    ...    DECODE(expire_date, NULL, '', expire_date) AS expire_date,
    ...    DECODE(notes, NULL, '', notes) AS notes,
    ...        contract_id,
    ...        ref
    ...  FROM (SELECT mc.code_id AS ref,
    ...       TRIM(DECODE(mc.voided, 'N', 'No', 'Yes')) AS voided,
    ...       mc.who AS issued_by,
    ...       mc.issued_to AS issued_to,
    ...       TO_CHAR(mc.created,'%Y-%m-%d %H:%M') AS issued_date,
    ...       TO_CHAR(CASE
    ...          WHEN cc.rate IS NULL THEN mc.fee_amount
    ...          ELSE mc.fee_amount * cc.rate
    ...       END,'<<<<<.<<') AS fee,
    ...       TO_CHAR(CASE
    ...          WHEN cc.rate IS NULL THEN mc.original_amt
    ...          ELSE mc.original_amt * cc.rate
    ...       END,'<<<<<.<<') AS original_amt,
    ...       TO_CHAR(ch.check_num,'<<<<<<<<<<<<<<<<<<<<.#') AS check_num,
    ...       TO_CHAR(ch.create_date,'%Y-%m-%d %H:%M') AS date_used,
    ...       TO_CHAR(CASE
    ...          WHEN cc.rate IS NULL THEN ch.amount
    ...          ELSE ch.amount * cc.rate
    ...       END,'<<<<<.<<') AS amount_used,
    ...       cc.dst_curr AS currency,
    ...       TRIM(DECODE(mc.one_time_use, 'N', 'No', 'Yes')) AS one_time_,
    ...       TRIM(DECODE(cm.exact_amt_codes, 'N', 'No', 'Yes')) AS exact_amt,
    ...       TO_CHAR(mc.expire_date,'%Y-%m-%d %H:%M') AS expire_date,
    ...       TRIM(DECODE(mc.notes, NULL,'', mc.notes)) AS notes,
    ...       TO_CHAR(c.contract_id,'<<<<<<<<<<.#') AS contract_id
    ...  FROM mon_codes mc
    ...    JOIN contract c ON c.contract_id = mc.contract_id
    ...    JOIN cont_misc cm ON cm.contract_id = mc.contract_id
    ...    JOIN checks ch ON ch.ref_id = mc.code_id
    ...    LEFT JOIN curr_conv cc ON cc.src_curr = c.currency AND cc.dst_curr = '${currency}' AND effect_date = (SELECT MAX(effect_date) FROM curr_conv cc2 WHERE cc2.src_curr = c.currency AND cc2.dst_curr = '${currency}')
    ...  WHERE mc.carrier_id = '${carrier_id}'
    ...  AND mc.created BETWEEN '${begin_date} 00:00' AND '${end_date} 00:00'
    ...  AND mc.contract_id = '${contract}'
    ...  AND mc.last_use IS NOT NULL

    ${query}  Set Variable If  '${code_id}'!='${empty}'  ${query} AND mc.code_id='${code_id}'  ${query}
    ${query}  Set Variable If  '${check_number}'!='${empty}'  ${query} AND mc.last_check='${check_number}'  ${query}
    ${query}  Set Variable If  '${issued_by}'!='${empty}'  ${query} AND mc.who='${issued_by}'  ${query}
    ${query}  Set Variable If  '${issued_to}'!='${empty}'  ${query} AND mc.issued_to='${issued_to}'  ${query}
    ${query}  Catenate  ${query} ORDER BY mc.created);
    ${database_dictionary}  Query To Dictionaries  ${query}
    #log to console  ${query}
    Set Test Variable  ${database_dictionary}

Get Money Code Use Report Information
    [Arguments]  ${filePath}
    ${report_dictionary}  Get Values From Excel Rows  ${filePath}
    FOR  ${i}  IN  @{report_dictionary}
      Remove From Dictionary  ${i}  hubometer
      Remove From Dictionary  ${i}  reefer_hours
      Remove From Dictionary  ${i}  license_state
      Remove From Dictionary  ${i}  license_number
      Remove From Dictionary  ${i}  odometer
      Remove From Dictionary  ${i}  po_number
      Remove From Dictionary  ${i}  trip_number
      Remove From Dictionary  ${i}  trailer_number
      Remove From Dictionary  ${i}  unit_number
      Remove From Dictionary  ${i}  control_number
      Remove From Dictionary  ${i}  birthday
      Remove From Dictionary  ${i}  reefer_tempatur
      Remove From Dictionary  ${i}  pin_number
      Remove From Dictionary  ${i}  subfleet
      Remove From Dictionary  ${i}  billing_id
      Remove From Dictionary  ${i}  first_inital
      Remove From Dictionary  ${i}  last_name
      Remove From Dictionary  ${i}  driver_name
      Remove From Dictionary  ${i}  ssn
      Remove From Dictionary  ${i}  issue_type
      Remove From Dictionary  ${i}  bill_date
      Remove From Dictionary  ${i}  name
      Remove From Dictionary  ${i}  city
      Remove From Dictionary  ${i}  state
      Remove From Dictionary  ${i}  phone
      Remove From Dictionary  ${i}  sub_contract
      Remove From Dictionary  ${i}  driver_state
      Remove From Dictionary  ${i}  driver_id
      Remove From Dictionary  ${i}  driver_license
      ${ref_num}  Pop From Dictionary  ${i}  ref#
      Set To Dictionary  ${i}  ref=${ref_num}
      ${issued_date}  Get From Dictionary  ${i}  issued_date
      ${issued_date}  Excel Date To String  ${issued_date}  %Y-%m-%d %H:%M
      Set To Dictionary  ${i}  issued_date=${issued_date}
      ${fee}  Get From Dictionary  ${i}  fee
      ${fee}  Convert To Number  ${fee}  2
      Set To Dictionary  ${i}  fee=${fee}
      ${original_amt}  Get From Dictionary  ${i}  original_amt
      ${original_amt}  Convert To Number  ${original_amt}  2
      Set To Dictionary  ${i}  original_amt=${original_amt}
      ${date_used}  Get From Dictionary  ${i}  date_used
      ${date_used}  Excel Date To String  ${date_used}  %Y-%m-%d %H:%M
      Set To Dictionary  ${i}  date_used=${date_used}
      ${amount_used}  Get From Dictionary  ${i}  amount_used
      ${amount_used}  Convert To Number  ${amount_used}  2
      Set To Dictionary  ${i}  amount_used=${amount_used}
      ${expire_date}  Get From Dictionary  ${i}  expire_date
      Run Keyword If  '${expire_date}'!='${empty}'  Run Keywords
      ...  Dictionary Excel Date To String  ${expire_date}
      ...  AND  Set To Dictionary  ${i}  expire_date=${expire_date}
    END
    Set Test Variable  ${report_dictionary}

Dictionary Excel Date To String
    [Arguments]  ${expire_date}

    ${expire_date}  Excel Date To String  ${expire_date}  %Y-%m-%d %H:%M
    Set Test Variable  ${expire_date}

Validate Report With Database
    [Arguments]  ${report_dictionary}  ${database_dictionary}
    ${list_compare}  Compare List Dictionaries As Strings  ${report_dictionary}  ${database_dictionary}
    #log to console  Report:${report_dictionary[0]}
    #log to console  Database:${database_dictionary[0]}
    Should Be True  ${list_compare}

Issue Check For Test Execution

    ${checknumber}  CreateCheck
    Set Suite Variable  ${checknumber}

Issue Money Code For Test Execution
    [Arguments]  ${contract}
    ${moneycode}  IssueMoneyCode  ${contract}  ${amount}  BOT444
    Set Suite Variable  ${moneycode}

Authorize a Check
    [Arguments]  ${location}  ${check}  ${code}  ${amount}

    #Creating Log File
    ${filepath}  Create Log File  CheckAuthorization

    #Creating AM String
    ${amString}  Catenate  0180|AM|${location}|01.00|01|SSVR:PILOT|CODE:${code}//ER/${amount}/${check}/1/${amount}|INVN:BOT1846|MERC:CADV:1,${amount}|TOTL:${amount}
    Run Command  echo -n '${amString}' > CheckAuthorization

    #Running Transaction Using Putty
    ${screen}  Run Command  /home/qaauto/el_robot/authStrings/feed_rossAuth.pl CheckAuthorization 2>&1 | tee ${filepath}

Get Contracts From Carrier
    [Arguments]  ${carrier}

    ${query}  Catenate  SELECT contract_id FROM contract WHERE carrier_id='${carrier}'
    ${contract}  Query and Strip to Dictionary  ${query}
    ${contract}  Get From Dictionary  ${contract}  contract_id
    Set Suite Variable  ${contract}

Get Code Id For Test Execution
    [Arguments]  ${date}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${date}  ${date}
    ${code_id}  Get From Dictionary  ${database_dictionary[0]}  ref
    Set Test Variable  ${code_id}

Get Check Number For Test Execution
    [Arguments]  ${date}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${date}  ${date}
    ${check_number}  Get From Dictionary  ${database_dictionary[0]}  check_num
    ${check_number}  Remove String  ${check_number}  .0
    Set Test Variable  ${check_number}

Get Issued By For Test Execution
    [Arguments]  ${date}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${date}  ${date}
    ${issued_by}  Get From Dictionary  ${database_dictionary[0]}  issued_by
    Set Test Variable  ${issued_by}

Get Issued To For Test Execution
    [Arguments]  ${date}
    Get Money Code Use From Database  ${carrier}  ${contract[0]}  ${date}  ${date}
    ${issued_to}  Get From Dictionary  ${database_dictionary[0]}  issued_to
    Set Test Variable  ${issued_to}

Setup Carrier With Used Money Codes With Code Reason Set
    [Documentation]    Setup test carrier with used money codes and money code reason set
    ...    mc_code_reason: receives any valid reason code or not a specific one if is set as any
    [Arguments]    ${mc_code_reason}=any

    ${mc_reason_condition}    Run Keyword If    '${mc_code_reason}'=='any'    Catenate    AND mon_code_reason_id > 0
    ...    ELSE    Catenate    AND mon_code_reason_id = ${mc_code_reason}
    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT member_id, last_use, passwd, mon_code_reason_id
    ...    FROM member m
    ...    INNER JOIN mon_codes mc
    ...    ON mc.carrier_id = m.member_id
    ...    WHERE amt_used > 0
    ...    AND mc.status = 'A'
    ...    ${mc_reason_condition}
    ...    ORDER BY last_use DESC
    ...    LIMIT 1;
    ${list}  Query And Strip To Dictionary  ${query}
    ${member_id}  Get From Dictionary  ${list}  member_id
    Set Test Variable    ${member_id}
    ${passwd}  Get From Dictionary  ${list}  passwd
    Set Test Variable    ${passwd}
    ${last_use}  Get From Dictionary  ${list}  last_use
    Set Test Variable    ${last_use}
    ${reason_code}  Get From Dictionary  ${list}  mon_code_reason_id
    ${db_mc_reason_desc}    Get Reason Desc From DB    ${reason_code}
    Set Test Variable    ${db_mc_reason_desc}
    # Ensure carrier has the permission
    Add Money Code Use Report Permission to Carrier

Get Reason Desc From DB
    [Documentation]    Get money code reason description from database
    [Arguments]    ${reason_code}

    Get Into DB    TCH
    ${query}  Catenate  SELECT reason_desc
    ...    FROM mon_code_reason_list
    ...    WHERE reason_code = '${reason_code}';
    ${reason_desc}  Query And Strip    ${query}
    [return]    ${reason_desc}

Add Money Code Use Report Permission to Carrier
    [Documentation]    Give the carrier the money code use report permission

    Ensure Carrier has User Permission    ${member_id}    MONEYCODEUSE_REPORT

Log Carrier into eManager with Money Code Use Report permission
    [Documentation]  Log carrier into eManager with Money Code Use Report permission

    Open eManager  ${member_id}  ${passwd}

Go to Select Program > Reports/Exports > Money Code Use Report
    [Documentation]  Go to Select Program > Reports/Exports > Money Code Use Report

    Go To  ${emanager}/cards/MoneyCodeUseReport.action
    Wait Until Page Contains    Select Schedule or Immediate Report

Open and Create Money Code Use Report
    [Documentation]  Opens Money Code Use Report and create a report

    Input Text    name=startDate    ${last_use}
    Input Text    name=endDate    ${last_use}
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
    [Documentation]  Check the report has reason money code column

    Find value in PDF    ${filepath}    Money Code
    Find value in PDF    ${filepath}    Reason
    Find value in PDF    ${filepath}    ${db_mc_reason_desc}
    Remove Report File    ${report_name}