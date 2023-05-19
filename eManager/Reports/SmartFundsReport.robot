*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.ws.CardManagementWS
Library  String
Library  otr_robot_lib.reports.PyExcel
Library  OperatingSystem  WITH NAME  os

Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot



Force Tags  eManager

*** Variables ***

*** Test Cases ***

Check SmartFunds Card Activity
    [Tags]  JIRA:BOT-1177   qTest:29677205  Regression  refactor
    [Documentation]  Click SmartFunds Card Activity Report icon and check Information.

    Initiate Test
    Navigate to SmartFunds Allocation
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Select Card
    Check Card Transfer Permissions
    Check SmartFunds Card Activity Report
    Close Browser

Check SmartFunds Card Activity Immediate Report
    [Tags]  JIRA:BOT-1176   qTest:29677206  Regression  refactor
    [Documentation]  Generate a SmartFunds Card Activity Immediate Report and compare with database.
    [Teardown]  Remove Report File  PayrollCashAdvanceReport.xls

    Initiate Test
    Navigate to SmartFunds Allocation
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Select Card
    Check Card Transfer Permissions
    Check SmartFunds Card Activity Report
    Submit Immediate Report  PayrollCashAdvanceReport  Excel  #2 Scenarios from Submit and Download Report
    Open And Validate Excel File  #8 Scenarios from Excel data validation ${type} ${date} ${driverId} ${driverName} ${referenceId} ${user} ${amount} ${balance}
    Close Browser

SmartFunds Card Activity Scheduled Daily Report
    [Tags]  JIRA:BOT-1178   qTest:29677207  Regression  qTest:29677208  refactor
    [Documentation]  Generete a daily scheduled report for SmartFunds Card Activity.
    [Teardown]  Remove Report File  PayrollCashAdvanceReport.xls

    Initiate Test
    Navigate to SmartFunds Allocation
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Select Card
    Check SmartFunds Card Activity Report
    Navigate to Schedule Report  Excel
    Check Schedule Report Screen
    Schedule a Report
    Navigate to Scheduled Jobs
    Check If Report is on Scheduled Jobs Table
    Check Report Status on Recent Jobs Table  Waiting
    Run a Scheduled Report
    Check Report Status on Recent Jobs Table  Complete
    Download Scheduled Report  Excel
    Open And Validate Excel File
    Delete Scheduled Job
    Close Browser

*** Keywords ***

Initiate Test
    [Documentation]  Log on eManager with carrier and go to SmartFunds screen.

    #Set Suite Variables
    Set Suite Variable  ${carrier}  ${validCard.carrier.member_id}
    Set Suite Variable  ${password}    ${validCard.carrier.password}

    Open eManager  ${carrier}  ${password}

Navigate to SmartFunds Allocation
    [Documentation]  Navigates to SmartFunds Allocation Screen.

    Go To  ${emanager}/cards/SmartPayAllocation.action
    Element Should Be Visible  //input[@name='cardSearchTxt']

Search by All Cards
    Search Card  allCards  allCards

Search by Card
    [Arguments]  ${card}
    Search Card  ${card}

Search by Unit
    [Arguments]  ${unit}
    Search Card  ${unit}  UNIT

Search by Driver ID
    [Arguments]  ${driverId}
    Search Card  ${driverId}  DRIVERID

Search by X-ref
    [Arguments]  ${xref}
    Search Card  ${xref}  XREF

Search by Driver Name
    [Arguments]  ${driverName}
    Search Card  ${driverName}  DRIVERNAME

Search by Policy
    [Arguments]  ${policy}
    Search Card  ${policy}  POLICY

Search Card
    [Arguments]  ${value}  ${searchType}=NUMBER
    Click Radio Button  ${searchType}

    Run Keyword If  '${value}' != 'allCards'
    ...  Input Text  cardSearchTxt   ${value}

    Click Button  searchCard

Submit SmartFunds Allocation

    Get Card Balance From Screen
    Backup Card Balance
    Run Keyword If  ${cardBalancelist[0]} == 0 and ${amount} <= 0
    ...  Run Keywords  Click Button  Submit
    ...  AND  Handle Pop-Up
    ...  AND  Element Should Be Visible  submit
    ...  ELSE  Run Keywords  Click Button  Submit
    ...  AND  Select Window   NEW
    ...  AND  Check SmartFunds Summary Information
    ...  AND  Click Button  Save
    ...  AND  Handle Alert
    ...  AND  Select Window   MAIN
    ...  AND  Check Element Exists  text=SmartFunds Funds Allocation Report
    ...  AND  Check SmartFunds Funds Allocation Report
    ...  AND  Click Button  backFromReport

Input Alocation Amount
    [Arguments]  ${card}  ${amount}

    Input Text  //table[@id="cardSummary"]//a[text()='${card}']/parent::td/parent::tr//input[contains(@title,'Allocation')]  ${amount}
    Set Test Variable  ${amount}

Check SmartFunds Summary Information

    FOR  ${card}  IN  @{cards}
      ${allocationInfo}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Allocation']/parent::th/preceding-sibling::th)+1]
      ${leaveOnCardInfo}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Leave On Card']/parent::th/preceding-sibling::th)+1]
      ${referenceIdInfo}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Reference ID']/parent::th/preceding-sibling::th)+1]
      Should Be Equal  ${amount}  ${allocationInfo}
      Run Keyword If  '${leaveOnCardInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${leaveOnCardInfo}  ${leaveOnCard}
      Run Keyword If  '${referenceIdInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${referenceIdInfo}  ${referenceId}
    END

Check SmartFunds Funds Allocation Report

    ${newBalance}  Create List
    ${i}  Set Variable  0
    FOR  ${card}  IN  @{cards}
      ${status}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Status']/parent::th/preceding-sibling::th)+1]
      ${reportCardBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]
      ${allocation}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Allocation']/parent::th/preceding-sibling::th)+1]
      ${reportNewBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='New Balance']/parent::th/preceding-sibling::th)+1]
      ${leaveOnCardInfo}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Leave On Card']/parent::th/preceding-sibling::th)+1]
      ${referenceIdInfo}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Reference ID']/parent::th/preceding-sibling::th)+1]
      ${reportCardBalance}  Strip String  ${reportCardBalance}  characters=$
      ${reportNewBalance}  Strip String  ${reportNewBalance}  characters=$
      ${sum}  Evaluate  ${cardBalanceList[${i}]} + ${amount}
      Append To List  ${newBalance}  ${sum}
      Should Be Equal  ${status}  Successful
      Should Be Equal  ${cardBalanceList[${i}]}  ${reportCardBalance}
      Should Be Equal  ${amount}  ${allocation}
      Should Be Equal as Numbers  ${reportNewBalance}  ${newBalance[${i}]}
      Run Keyword If  '${leaveOnCardInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${leaveOnCardInfo}  ${leaveOnCard}
      Run Keyword If  '${referenceIdInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${referenceIdInfo}  ${referenceId}
      ${i}  Evaluate  ${i}+1
    END
    Set Test Variable  ${newBalance}

Get Card Balance From Screen

    @{cardBalanceList}  Create List
    FOR  ${card}  IN  @{cards}
      ${cardBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]
      ${cardBalance}  Strip String  ${cardBalance}  characters=$
      Append to List  ${cardBalanceList}  ${cardBalance}
    END
    Set Test Variable  ${cardBalanceList}

Compare Card Balance After Allocation

    Run Keyword If  '${amount}' < '0'
    ...  Normalize Amount  ${amount}

    ${i}  Set Variable  0
    FOR  ${card}  IN  @{cards}
      Wait Until Element is Visible  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]
      ${finalCardBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]
      ${finalCardBalance}  Strip String  ${finalCardBalance}  characters=$
      Should Be Equal as Numbers  ${finalCardBalance}  ${newBalance[${i}]}
      Get Into DB  TCH
      ${query}  Catenate  select * from payr_cash_adv
      ...  where cash_adv_id = (select max(cash_adv_id)
      ...  from payr_cash_adv
      ...  where card_num='${card}'
      ...  and amount='${amount}'
      ...  and balance='${finalCardBalance}');
      Row Count is Equal to X  ${query}  1
      ${i}  Evaluate  ${i}+1
    END

Backup Card Balance

    Set Test Variable  ${backupBalance}  ${cardBalanceList}

Compare Information
    [Arguments]  ${prompt}=F  ${value}=F

    Count Results on eManager
    Run Keyword If  '${prompt}'=='F' and '${value}'=='F'
    ...  Count Cards on DB
    ...  ELSE IF  '${prompt}'=='X-ref'
    ...  Count Cards on DB With X-ref  ${value}
    ...  ELSE IF  '${prompt}'=='Policy'
    ...  Count Cards on DB With Policy  ${value}
    ...  ELSE IF  '${prompt}'=='F' and '${value}'!='F'
    ...  Count Cards on DB With Card #  ${value}
    ...  ELSE  Count Cards on DB With Prompts  ${prompt}  ${value}
    TCH Logging   ${prompt}-database:${cardsOnDb} emanager:${cardsOnEmanager}
    Should be Equal  ${cardsOnDb}  ${cardsOnEmanager}

Insert Leave on Card Option
    Set Focus to Element  submit
    Click Element  //*[@id="cardSummary"]/tbody/tr[1]/descendant::input[2]
    Set Test Variable  ${leaveOnCard}  Yes

Insert Reference ID
    Set Focus to Element  submit
    ${referenceId}  Generate Random String  6
    Input Text  //*[@id="cardSummary"]/tbody/tr[1]/descendant::input[3]  ${referenceId}
    Set Test Variable  ${referenceId}

Handle Pop-Up

    ${message}  Handle Alert
    Set Test Variable  ${message}

Validate Pop-Up for Zero as Amount

    Should Be Equal  ${message}  Please enter a valid amount.

Validate Pop-Up for Negative Amount

    Should Contain  ${message}  Amount removed (${amount}) may not exceed card balance ${cardBalanceList[0]}.

Input Card For Execution
    [Arguments]  @{cardsList}

    @{cards}  Create List  @{cardsList}
    Set Test Variable  @{cards}

Normalize Amount
    [Arguments]  ${amount}

    ${amount}  Strip String  ${amount}  characters=-
    Set Test Variable  ${amount}

Select Card

    Click Element  //table[@id='cardSummary']//tbody//td[count(//table[@id='cardSummary']//th/a[text()='Card #']/parent::th/preceding-sibling::th)+1]

Check Card Transfer Permissions

    Get Into DB  TCH
    ${query}  Catenate  SELECT TRIM(DECODE(payr_atm, 'Y', 'ALLOW', 'N', 'DISALLOW', 'POLICY')) AS payr_atm,
    ...  TRIM(DECODE(payr_chk, 'Y', 'ALLOW', 'N', 'DISALLOW', 'POLICY')) AS payr_chk,
    ...  TRIM(DECODE(payr_ach, 'Y', 'ALLOW', 'N', 'DISALLOW', 'POLICY')) AS payr_ach,
    ...  TRIM(DECODE(payr_wire, 'Y', 'ALLOW', 'N', 'DISALLOW', 'POLICY')) AS payr_wire,
    ...  TRIM(DECODE(payr_debit, 'Y', 'ALLOW', 'N', 'DISALLOW', 'POLICY')) AS payr_debit
    ...  FROM cards
    ...  WHERE card_num='${cards[0]}';
    ${permissions}  Query and Strip to Dictionary  ${query}

    ${query}  Catenate  SELECT balance
    ...  FROM payr_cash_adv
    ...  WHERE cash_adv_id=(select max(cash_adv_id) FROM payr_cash_adv WHERE card_num='${cards[0]}');
    ${permissionsBalance}  Query and Strip  ${query}

    ${balance}  Get Text  //label[@for='smartPay.balance']/following::*[1]
    ${balance}  Remove String  ${balance}  ,

    Should Be Equal  ${balance}  $${permissionsBalance}
    Check Element Exists  text=Card Transfer Permissions
    Check Element Exists  //input[@name='card.header.payrollAtm' and @value='${permissions.payr_atm}' and @checked='checked']
    Check Element Exists  //input[@name='card.header.payrollChk' and @value='${permissions.payr_chk}' and @checked='checked']
    Check Element Exists  //input[@name='card.header.payrollAch' and @value='${permissions.payr_ach}' and @checked='checked']
    Check Element Exists  //input[@name='card.header.payrollWire' and @value='${permissions.payr_wire}' and @checked='checked']
    Check Element Exists  //input[@name='card.header.payrollDebit' and @value='${permissions.payr_debit}' and @checked='checked']

Check SmartFunds Card Activity Report

    Click Element  //a[text()='SmartFunds Card Activity Report']
    Check Element Exists  text=SmartFunds Card Activity Report
    Check Element Exists  //input[@name='displayNumber' and @value='${cards[0]}' and @type='text']

Submit Immediate Report
    [Arguments]  ${report_name}  ${report_type}

    ${today}  getDateTimeNow  %Y-%m-%d
    Click Element  //input[@title='Immediate Report']
    Input Text  startDate  ${today}
    Input Text  endDate  ${today}
    Select From List by Label  viewFormat  ${report_type}
    Click Element  submit
    Wait Until Element Is Visible  //a[text()='Click here to view the document']  timeout=10
    Click Element  //a[text()='Click here to view the document']
    ${extension}  Set Variable If  '${report_type}'=='Pdf'  pdf  xls
    os.Wait Until Created  ${default_download_path}${/}*${report_name}*${extension}
    Assert File  ${report_name}.${extension}

Assert File
    [Arguments]  ${report_name}
    ${report_name}  Split String  ${report_name}  .
    os.File Should Exist  ${default_download_path}${/}*${report_name[0]}*${report_name[1]}
    ${file}  os.List Directory  ${default_download_path}  *${report_name[0]}*.${report_name[1]}
    ${filePath}  os.Normalize Path  ${default_download_path}${/}${file[0]}
    os.File Should Not Be Empty  ${filePath}
    Set Test Variable  ${filePath}

Open And Validate Excel File
    [Arguments]  ${sheetIndex}=0

    Open Excel  ${filePath}
    ${sheets}  Get Sheet Names
    ${excelTable}  Create Dictionary
    ${row_count}  Get Row Count  ${sheets[${sheetIndex}]}
    FOR  ${index}  IN RANGE  0  ${row_count}
        ${row}  Get Row Values  ${sheets[${sheetIndex}]}  ${index}
        Put Row in Dictionary  ${excelTable}  ${row}
    END

    FOR  ${index}  IN RANGE  3  ${row_count}
      ${type}  Get From Dictionary  ${excelTable}  A${index}
      ${date}  Get From Dictionary  ${excelTable}  B${index}
      ${date}  Convert to Number  ${date}
      ${date}  Excel Date to String  ${date}
      ${driverId}  Get From Dictionary  ${excelTable}  C${index}
      ${driverName}  Get From Dictionary  ${excelTable}  D${index}
      ${referenceId}  Get From Dictionary  ${excelTable}  H${index}
      ${user}  Get From Dictionary  ${excelTable}  I${index}
      ${user}  Strip String  ${user}
      ${amount}  Get From Dictionary  ${excelTable}  L${index}
      ${balance}  Get From Dictionary  ${excelTable}  M${index}
      Check Excel Report on Database  ${type}  ${date}  ${driverId}  ${driverName}  ${referenceId}  ${user}  ${amount}  ${balance}
    END

Put Row in Dictionary
    [Arguments]  ${excelTable}  ${row}
    FOR  ${position}  IN  @{row}
      Set To Dictionary  ${excelTable}  ${position[0]}=${position[1]}
    END

Check Excel Report on Database
    [Arguments]  ${type}  ${date}  ${driverId}  ${driverName}  ${referenceId}  ${user}   ${amount}  ${balance}

    Get Into DB  TCH
    ${query}  Catenate  select 1 from payr_cash_adv p
    ...  inner join card_inf c ON p.card_num=c.card_num
    ...  where p.card_num='${cards[0]}'
    ...  and (c.info_id ='DRID' or c.info_id ='NAME')
    ...  and p.id='${type}'
    ...  and p.when=to_date('${date}','%Y-%m-%d %H:%M')
    ...  and (c.info_validation LIKE '%${driverId}' or c.info_validation LIKE '%${driverName}')
    ...  and p.who = '${user}'
    ...  and p.amount = '${amount}'
    ...  and p.balance = '${balance}'
    ${end_query}  Set Variable if  '${referenceId}'=='${EMPTY}'  and p.ref_num is null  and p.ref_num = '${referenceId}'
    ${query}  Catenate  ${query} ${end_query}
    Row Count is Equal to X  ${query}  2

Navigate to Schedule Report
    [Arguments]  ${report_type}
    Click Element  //input[@title='Schedule Report']
    Select From List By Label  viewFormat  ${report_type}
    Click Element  submit

Check Schedule Report Screen

    Check Element Exists  text=Schedule Job

Schedule a Report
    Click Element  //input[@value='DAILY']
    ${random}  Generate Random String  4
    ${jobDescription}  Set Variable  BOT-1177-${random}
    Input Text  jobDescription  ${jobDescription}
    Select Checkbox  emailAddressShow
    Input Text  emailAddress  WEXEFS-El-Robot@wexinc.com
    Click Element  submitScheduledJob
    Check Element Exists  text=Schedule Job Submitted

    Set Test Variable  ${jobDescription}

Navigate to Scheduled Jobs
    Go to  ${emanager}/cards/JobList.action

Remove Report File
    [Arguments]  ${report_name}
    ${report_name}  Split String  ${report_name}  .
    ${file}  os.List Directory  ${default_download_path}  *${report_name[0]}*.${report_name[1]}
    ${files_len}  Get Length  ${file}
    FOR  ${index}  IN RANGE  0  ${files_len}
      ${filePath}  os.Normalize Path  ${default_download_path}${/}${file[${index}]}
      os.Get Binary File  ${filePath}
      os.Remove File  ${filePath}
    END

Run a Scheduled Report

    ${scheduledJob}  Get Value  //table[@id='scheduledJob']//td[text()='${jobDescription}']/parent::tr//input[@name='editJob']/parent::form/input[@name='jobId']
    TCH Logging  Scheduled Job ID:${scheduledJob}

    Get Into DB  MySQL

    ${query}  Catenate  UPDATE job_prop
    ...  SET prop_value = now()
    ...  WHERE job_id = '${scheduledJob}'
    ...  AND prop_name = 'nextRunDate:value';
    TCH Logging  ${query}
    Execute SQL String   ${query}

    ${query2}  Catenate  UPDATE job
    ...  SET scheduled_time = (SELECT prop_value
	...  FROM job_prop
    ...  where job_id = '${scheduledJob}'
	...  AND prop_name = 'nextRunDate:value')
    ...  WHERE job_id = '${scheduledJob}';
    TCH Logging   ${query2}
    Execute SQL String   ${query2}

    Wait Until Keyword Succeeds  180 sec  10 sec  Check Scheduled Job Status on Database  ${scheduledJob}
    Click Element  refresh

Check Scheduled Job Status on Database
    [Arguments]  ${scheduledJob}

    Get Into DB  MySQL
    ${query}  Catenate  SELECT status
    ...  FROM job
    ...  WHERE job_id = '${scheduledJob}'
    ${status}  Query and Strip  ${query}
    Should be Equal  ${status}  COMPLETE

Download Scheduled Report
    [Arguments]  ${report_type}

    ${report_name}  Set Variable  PayrollCashAdvanceReport
    Find Report Page on  Recent Jobs Table
    Check Report Status on Recent Jobs Table  Complete
    Click Element  //table[@id='recentJob']//td[text()='${jobDescription}']/parent::tr//a
    ${extension}  Set Variable If  '${report_type}'=='Pdf'  pdf  xls
    os.Wait Until Created  ${default_download_path}${/}*${report_name}*${extension}
    Assert File  ${report_name}.${extension}

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
    Element Should Not be Visible  //table[@id='scheduledJob']//td[text()='${jobDescription}']/parent::tr//input[@name='deleteJob']