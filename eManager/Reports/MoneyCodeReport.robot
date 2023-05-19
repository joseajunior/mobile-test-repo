*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  String
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_robot_lib.reports.PyExcel
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Setup Carrier for Money Code Report
Test Teardown    Close Browser
Suite Teardown  Disconnect from Database

Force Tags  eManager  Reports  Money Code

*** Variables ***
${carrier}
${express_code}
${code_id}
${mc_reason_desc}
${db_mc_reason_desc}
${scheduled_report_desc}
${report_name}    MoneyCodeReport
${issue_to_default}    test
${reason_code_default}    1

*** Test Cases ***

Open a Money Code Report
    [Tags]  JIRA:BOT-443  JIRA:BOT-1063  JIRA:BOT-1064  JIRA:BOT-1708  qTest:29379690  Regression  qTest:31244720  refactor
    [Documentation]  JIRA:BOT-443  -  EMgr Regression Testing - Money Code Report
    ...              JIRA:BOT-1063 - Open a Money Code Report
    ...              JIRA:BOT-1064 - Immediate Report > Money Code Reference:(money code id or id) >Submit
    ...              JIRA:BOT-1708 - Enter Valid Money Code Reference to look up
    [Setup]  Run Keywords  Remove File  MoneyCodeReport.xls  #  Workaround. It's not possible to remove this type of file after read it inside robot
    ...     AND  Make Sure Carrier Is Active  ${validCard.carrier.member_id}
    ...     AND  Set Test Variable  ${DB}  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Naviate to Money Code Report
    Retrieve Last Money Code From DB  ${validCard.carrier.member_id}
    Submit and Check Report  MoneyCodeReport  Excel  ${mon_code}
    [Teardown]  Run Keywords
    ...  Close Browser
    ...  AND  Remove File  MoneyCodeReport.xls
    ...  AND  Disconnect From Database

Schedule Report
    [Tags]  JIRA:BOT-443  JIRA:BOT-1065  JIRA:BOT-1066  JIRA:BOT-1067  qTest:29379774  Regression  refactor
    [Documentation]  Schedule a report and find it on Scheduled Jobs Screen
    ...              JIRA:BOT-443  -  EMgr Regression Testing - Money Code Report
    ...              JIRA:BOT-1065 - Schedule Report > Money Code Ref: (put in ID) > Submit
    ...              JIRA:BOT-1066 - Schedule Report
    ...              JIRA:BOT-1067 - See previous scheduled reports at Scheduled Reports screen
    [Setup]  Run Keywords  Make Sure Carrier Is Active  ${validCard.carrier.member_id}
    ...     AND  Set Test Variable  ${DB}  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Naviate to Money Code Report
    Retrieve Last Money Code From DB  ${validCard.carrier.member_id}
    Schedule a Report  Excel  ${mon_code}
    Navigate to Scheduled Jobs
    Search Value on Scheduled Jobs Table By  Description  ${schedule_reference}
    Delete A Schedule Job  ${schedule_reference}

    [Teardown]  Run Keywords
    ...  Close Browser
    ...  AND  Disconnect From Database

Edit a Report
    [Tags]  JIRA:BOT-443  JIRA:BOT-1068  qTest:29379798  Regression  refactor
    [Documentation]  Edit a Report
    ...              JIRA:BOT-443  -  EMgr Regression Testing - Money Code Report
    ...              JIRA:BOT-1068 -  Edit a Report
    [Setup]  Run Keywords  Make Sure Carrier Is Active  ${validCard.carrier.member_id}
    ...     AND  Set Test Variable  ${DB}  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Scheduled Jobs
    Edit an Existing Scheduled Jobs
    Validate Scheduled Job Edit
    [Teardown]  Close Browser

Delete a Report
    [Tags]  JIRA:BOT-443  JIRA:BOT-1069  qTest:29380009  Regression  refactor
    [Documentation]  Delete a report
    ...              JIRA:BOT-443   -  EMgr Regression Testing - Money Code Report
    ...              JIRA:BOT-1069  -  Delete a scheduled report
    [Setup]  Run Keywords  Make Sure Carrier Is Active  ${validCard.carrier.member_id}
    ...     AND  Set Test Variable  ${DB}  TCH

    Open Emanager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Navigate to Scheduled Jobs
    Delete an Existing Scheduled Jobs
    Validate Scheduled Job Exclusion
    [Teardown]  Close Browser

Enter Invalid Money Code Reference
    [Tags]  JIRA:BOT-443  JIRA:BOT-1707  qTest:29380046  Regression  refactor
    [Documentation]  Enter Invalid Money Code Reference (Will bring up a blank report)
    ...              JIRA:BOT-443    -  EMgr Regression Testing - Money Code Report
    ...              JIRA:BOT-1707   -  Enter Invalid Money Code Reference (Will bring up a blank report)
    [Setup]  Run Keywords  Remove File  MoneyCodeReport.xls  #  Workaround. It's not possible to remove this type of file after read it inside robot
    ...     AND  Make Sure Carrier Is Active  ${validCard.carrier.member_id}
    ...     AND  Set Test Variable  ${DB}  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Naviate to Money Code Report
    Retrieve An Invalid Money Code  ${validCard.carrier.member_id}
    Fill Submit Form and Submit  Excel  ${mon_code}
    Assert Error Message  is not a valid Reference Id
#    Create Expected Result Dictionary  G1=Money Code Report  F8=INACTIVE
#    Open And Validate An Excel File
    [Teardown]  Run Keywords
    ...  Close Browser
    ...  AND  Disconnect From Database

Load Same Report Using Different Currency And Assert Amount
    [Tags]  JIRA:BOT-443  JIRA:BOT-1709  qTest:29897433  Regression  refactor
    [Documentation]  Load a report using different currencies and make sure it uses the right conversion rates (Verify in curr_conv table)
    [Setup]  Run Keywords  Make Sure Carrier Is Active  ${validCard.carrier.member_id}
    ...     AND  Set Test Variable  ${DB}  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Issue a Money Code To Export
    Naviate to Money Code Report
    Submit and Check Report  MoneyCodeReport  PDF  ${report_reference}
    Assert PDF Report Amount  ${mon_code_amt}
    os.Remove File  ${filePath}
    Naviate to Money Code Report
    Submit and Check Report  MoneyCodeReport  PDF  ${report_reference}  currency=CAD
    ${cad_amount}  Change Currency  USD  CAD  ${mon_code_amt}
    Assert PDF Report Amount  ${cad_amount}

    [Teardown]  Run Keywords
    ...  close pdf
    ...  AND  os.Remove File  ${filePath}
    ...  AND  Close Browser
    ...  AND  Disconnect From Database

Validate Report Info
    [Tags]  JIRA:BOT-443  JIRA:BOT-1710  qTest:29898176  Regression  qTest:30058500  refactor
    [Documentation]  Verify that the report shows correct info, correct conversion rates, amounts add up properly,
    ...              and the information lines up (Can look at the mon_codes table to verify info)
    [Setup]  Run Keywords  Make Sure Carrier Is Active  ${validCard.carrier.member_id}
    ...     AND  Set Test Variable  ${DB}  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Naviate to Money Code Report
    Retrieve Last Money Code From DB  ${validCard.carrier.member_id}
    Submit and Check Report  MoneyCodeReport  PDF  ${mon_code}
    Assert PDF Report Info
    [Teardown]  Run Keywords
    ...  close pdf
    ...  AND  os.Remove File  ${filePath}
    ...  AND  Close Browser
    ...  AND  Disconnect From Database

Reason Money Code in Report
    [Tags]    JIRA:FRNT-2090    JIRA:FRNT-2089    JIRA:BOT-4981    JIRA:FRNT-2167    JIRA:BOT-4999    qTest:116286998
    [Documentation]  Ensure reason money code column is displayed in Money Code Report and is filled with correct data

    Add Money Code Reason List Permission to Carrier
    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code    ${reason_code_default}
    Check Reason Money Code From Issued Money Code    ${reason_code_default}
    Open and Create Money Code Report
    Check Reason Code Description in Report
    Create Money Code Scheduled Report
    Download Scheduled Report
    Check Reason Code Description in Report

Empty Reason Money Code in Report
    [Tags]    JIRA:FRNT-2090    JIRA:FRNT-2089    JIRA:BOT-4981    JIRA:FRNT-2167    JIRA:BOT-4999    qTest:116288526
    [Documentation]  Ensure reason money code column is displayed in Money Code Report and has empty reason money code

    Remove Money Code Reason List Permission from Carrier
    Log Carrier into eManager with Issue Money permission
    Go to Select Program > Money Codes > Issue Money Code
    Issue Money Code    ${reason_code_default}
    Open and Create Money Code Report
    Check No Reason Code Description in Report
    Create Money Code Scheduled Report
    Download Scheduled Report
    Check No Reason Code Description in Report

*** Keywords ***
Naviate to Money Code Report
    Go to  ${emanager}/cards/MoneyCodeReport.action

Navigate to Scheduled Jobs
    Go to  ${emanager}/cards/JobList.action

Retrieve Last Money Code From DB
    [Arguments]  ${carrier}
    Get Into DB  TCH
    ${query}  Catenate  SELECT code_id,
    ...                        original_amt,
    ...                        to_char(created, '%Y-%m-%d') as bill_date,
    ...                        to_char(created, '%H.%M') as bill_hour,
    ...                        notes,
    ...                        carrier_id,
    ...                        sub_contract
    ...  FROM mon_codes
    ...  WHERE carrier_id = ${carrier}
    ...  AND status = 'A'
    ...  ORDER BY created DESC
    ...  LIMIT 1
    ${output}  Query And Strip To Dictionary  ${query}

    Set Test Variable  ${mon_code}  ${output['code_id'].__str__()}
    Set Test Variable  ${original_amt}  ${output['original_amt'].__str__()}
    Set Test Variable  ${bill_date}  ${output['bill_date'].__str__()}
    Set Test Variable  ${bill_hour}  ${output['bill_hour'].__str__()}
    Set Test Variable  ${notes}  ${output['notes'].__str__()}
    Set Test Variable  ${carrier_id}  ${output['carrier_id'].__str__()}
    Set Test Variable  ${sub_contract}  ${output['sub_contract'].__str__()}

Retrieve An Invalid Money Code
    [Arguments]  ${carrier}
    ${random_mon_code}  Generate Random String  8  [LETTERS]
    Set Test Variable  ${mon_code}  ${random_mon_code}

Fill Submit Form and Submit
    [Arguments]  ${report_type}  ${report_reference}  ${currency}=USD
    Input Text  referenceId  ${report_reference}
    select from list by value  currency  ${currency}
    select from list by label  viewFormat  ${report_type}
    Click Element  viewMoneyCodeReport

Submit and Check Report
    [Arguments]  ${report_name}  ${report_type}  ${report_reference}  ${currency}=USD
    Fill Submit Form and Submit  ${report_type}  ${report_reference}  ${currency}
    Wait Until Element Is Visible  //a[text()='Click here to view the document']  timeout=10
    Click Element  //a[text()='Click here to view the document']
    ${extension}  Set Variable If  '${report_type}'=='PDF'  pdf  xls
    os.Wait Until Created  ${default_download_path}${/}*${report_name}*${extension}
    Assert File  ${report_name}.${extension}

Assert File
    [Arguments]  ${report_name}
    ${report_name}  Split String  ${report_name}  .
    os.file should exist  ${default_download_path}${/}*${report_name[0]}*${report_name[1]}
    ${file}  os.list directory  ${default_download_path}  *${report_name[0]}*.${report_name[1]}
    ${filePath}  os.normalize path  ${default_download_path}${/}${file[0]}
    os.File Should Not Be Empty  ${filePath}
    Set Test Variable  ${filePath}

Open And Validate An Excel File
    ${excel_dictionary}  Put Excel to Dictionary  ${filePath}
    FOR  ${expected_key}  IN  @{expected_results}
      ${expected_value}  Get From Dictionary  ${expected_results}  ${expected_key}
      ${excel_value}  Get From Dictionary  ${excel_dictionary}  ${expected_key}
      Should Be Equal As Strings  ${expected_value}  ${excel_value}
    END

Remove File
    [Arguments]  ${report_name}
    ${report_name}  Split String  ${report_name}  .
    ${file}  os.list directory  ${default_download_path}  *${report_name[0]}*.${report_name[1]}
    ${files_len}  get length  ${file}
    FOR  ${index}  IN RANGE  0  ${files_len}
      ${filePath}  os.normalize path  ${default_download_path}${/}${file[${index}]}
      os.get binary file  ${filePath}
      os.Remove File  ${filePath}
    END

Put Excel to Dictionary
    [Arguments]  ${filePath}  ${sheetIndex}=0
    os.file should exist  ${filePath}
    tch logging  opening: ${filePath}
    open excel  ${filePath}
    ${sheets}  Get Sheet Names
    ${excelTable}  Create Dictionary
    ${row_count}  Get Row Count  ${sheets[${sheetIndex}]}
    FOR  ${index}  IN RANGE  0  ${row_count}
        ${row}  Get Row Values  ${sheets[${sheetIndex}]}  ${index}
        Put Row in Dictionary  ${excelTable}  ${row}
    END
    tch logging  deleting: ${filePath}
    Delete Excel
    [Return]  ${excelTable}

Put Row in Dictionary
    [Arguments]  ${excelTable}  ${row}
    FOR  ${position}  IN  @{row}
       Set To Dictionary  ${excelTable}  ${position[0]}=${position[1]}
    END

Create Expected Result Dictionary
    [Arguments]  @{expected}
    [Documentation]  Method whick requires a dictionary. Excel_position=value Eg.: G1=Money Code Report
    ${expected_results}  Create Dictionary
    FOR  ${i}  IN  @{expected}
          ${i}  Split String  ${i}  =
          set to dictionary  ${expected_results}  ${i[0]}=${i[1]}
    END
    Set Test Variable  ${expected_Results}  ${expected_Results}
    [Return]  ${expected_Results}

Search Value on Scheduled Jobs Table By
    [Arguments]  ${search_column}  ${search_value}
    Sleep  10

    Set Test Variable  ${table}  Scheduled Jobs
    ${elementPosition}  Set Variable If  '${table}'=='Scheduled Jobs'  1
    ${elementCount}  Get Element Count  //img[contains(@src,"nextPage")]
    ${element}  Set Variable If  '${elementCount}'=='2'  (//img[contains(@src,"nextPage")])[${elementPosition}]

    ${i}  Set Variable  1
    FOR  ${i}  IN RANGE  1  100
      ${status}  Run Keyword and Return Status  Page Should Contain Element  //table[@id='scheduledJob']//tr//td[count(//table[@id='scheduledJob']//th/a[text()='${search_column}']/parent::th/preceding-sibling::th)+1 and text()='${search_value}']
      Run Keyword If  '${status}'!='${true}'
        ...  Click Element  ${element}
        ...  ELSE  Exit For Loop
    END




Schedule a Report
    [Arguments]  ${report_type}  ${mon_code}  ${currency}=USD
    Click Element  scheduleImmediateRadio
    Input Text  referenceId  ${mon_code}
    Select From List By Value  currency  ${currency}
    Select From List By Label  viewFormat  ${report_type}
    Click Element  viewMoneyCodeReport
    Wait Until Element Is Visible  jobDescription
    ${schedule_reference}  Generate Random String  8  [NUMBERS]
    Input Text  jobDescription  ${schedule_reference}
    Set Test Variable  ${schedule_reference}  ${schedule_reference}
    Click Element  submitScheduledJob


Delete an Existing Scheduled Jobs
     ${total_lines}  Get Element Count  //table[@id='scheduledJob']//tbody//tr
     ${random_scheduled_job}  evaluate  random.randint(1, ${total_lines})  random
     Click Element  //table[@id='scheduledJob']//tr[${random_scheduled_job}]//td[count(//table[@id='scheduledJob']//th[text()='Delete']/preceding-sibling::th)+1]
     handle alert

Delete A Schedule Job
     [Arguments]   ${referenceID}
     Click Element  //*[@id='scheduledJob']//*[@onclick="return handleMesssage('Are you sure you wish to delete this','${referenceID}')"]
     handle alert

Validate Scheduled Job Exclusion
    wait until element is visible  //ul[@class='messages']
    ${message}  Get Text  //ul[@class='messages']/li
    should be equal as strings  ${message}  Job Successfully Deleted.

Edit an Existing Scheduled Jobs
    ${total_lines}  Get Element Count  //table[@id='scheduledJob']//tbody//tr
    ${random_scheduled_job}  evaluate  random.randint(1, ${total_lines})  random
    ${description}  Get Text  //table[@id='scheduledJob']//tr[${random_scheduled_job}]//td[count(//table[@id='scheduledJob']//th[text()='Description']/preceding-sibling::th)+1]
    Click Element  //table[@id='scheduledJob']//tr[${random_scheduled_job}]//td[count(//table[@id='scheduledJob']//th[text()='Edit']/preceding-sibling::th)+1]
    wait until element is visible  saveJob
    ${random_monthly}  evaluate  random.randint(1, 20)  random
    select from list by value  startingPointMonthly  ${random_monthly.__str__()}
    Click Element  jobFrequency
    Set Test Variable  ${description}  ${description}
    Set Test Variable  ${new_monthly_value}  ${random_monthly}

Validate Scheduled Job Edit
    ${total_lines}  Get Element Count  //table[@id='scheduledJob']//td[text()='${description}']/parent::tr/td[text()='${new_monthly_value}']/parent::tr
    run keyword if  '${total_lines}'=='1'  fail  Line doesn't exist in table

Save Report Info
    ${excel_dictionary}  Put Excel to Dictionary  ${filePath}
#    Remove File  ${filePath}
    [Return]  ${excel_dictionary}

Assert PDF Report Info
    Close PDF
    open pdf doc  ${filePath}
    Search Value By Label Position   Reference ID:  ${mon_code}
    Search Value By Label Position   Notes:  ${notes}
    Search Value By Label Position   Issued By:  ${carrier_id}
    Search Values By Label Position  Bill Date:  ${bill_date}  ${bill_hour}
    Search Value By Label Position   Original Amount:  ${original_amt}
    Search Value By Label Position   Sub Contract:  ${sub_contract}
    close pdf

Assert PDF Report Amount
    [Arguments]  ${amount}
    Close PDF
    open pdf doc  ${filePath}
    Search Value By Label Position   Original Amount:  ${amount}
    close pdf

Change Currency
    [Arguments]  ${src_amount}  ${dst_amount}  ${amount}
    Get Into DB  TCH
    ${query}  Catenate  SELECT rate FROM curr_conv cc
    ...                 WHERE cc.src_curr = '${src_amount}'
    ...                 AND cc.dst_curr = '${dst_amount}'
    ...                 AND effect_Date = (SELECT MAX(effect_Date) FROM curr_conv WHERE src_curr = '${src_amount}' AND dst_curr = '${dst_amount}')
    ${rate}  Query And Strip  ${query}
    ${dst_currency_amt}  Evaluate  ${amount}*${rate}
    ${dst_currency_amt}  Convert to Number  ${dst_currency_amt.__str__()}  2
    [Return]  ${dst_currency_amt.__str__()}

Assert Error Message
    [Arguments]  ${expected_message}
    ${message}  Get Text  //div[@class='errors']//li
    should be equal as strings  ${message}  ${mon_code} ${expected_message}

Issue a Money Code To Export
    Go To  ${emanager}/cards/MoneyCodeManagement.action
    ${value}  Generate Random String  2  [NUMBERS]
    ${issue_to_index}    Generate Random String  5  [LETTERS]
    ${notes_index}    Generate Random String  5  [LETTERS]
    Input Text  moneyCode.amount  ${value}
    Input Text  moneyCode.issuedTo  ${issue_to_index}
    Input Text  moneyCode.notes  ${TEST NAME}_${issue_to_index}
    Click Element  submitId
    Wait Until Element Is Visible  //ul[@class='messages']/li
    ${mon_code}  Get Text  //ul[@class='messages']/li/b[1]
    ${report_reference}  Get Text  //ul[@class='messages']/li/b[2]
    ${mon_code_amt}  Get Text  //ul[@class='messages']/li/b[3]
    Set Test Variable  ${mon_code}  ${mon_code}
    Set Test Variable  ${report_reference}  ${report_reference}
    Set Test Variable  ${mon_code_amt}  ${mon_code_amt}

Convert Amount
    [Arguments]  ${value}  ${source_curr}  ${dest_curr}
    ${query}  Catenate  SELECT rate FROM curr_conv
    ...                 where src_curr = '${source_curr}'
    ...                 AND dst_curr = '${dest_curr}'
    ...                 ORDER BY effect_date desc
    ...                 LIMIT 1
    ${used_rate}  Query And Strip  ${query}
    ${converted_amt}  Evaluate  ${value}* ${used_rate}
    Set Test Variable  ${converted_amt}  ${converted_amt}
    [Return]  ${converted_amt}

Get Value From Excel Cell
    [Arguments]  ${dictionary}  ${cell}
    ${value}  Get From Dictionary  ${dictionary}  ${cell}
    [Return]  ${value}

Compare Amount Conversion
    [Arguments]  ${uds_excel_dictionary}  ${cad_excel_dictionary}  ${cell}  ${src_curr}=USD  ${dst_cutt}=CAD
    ${src_amt}  Get Value From Excel Cell   ${uds_excel_dictionary}  ${cell}
    Convert Amount  ${src_curr}  ${dst_cutt}  ${usd_amt}
    ${dst_amt}  Get Value From Excel Cell   ${cad_excel_dictionary}  ${cell}

Search Values By Label Position
    [Arguments]  ${label_text}  @{search_text}
    FOR  ${value}  IN  @{search_text}
       Search Value By Label Position  ${label_text}  ${value}

    END

Search Value By Label Position
    [Arguments]  ${label_text}  ${search_text}
    ${label_text_pos}  find_text_position_in_entire_pdf  ${label_text}
    ${label_exists}  Get Length  ${label_text_pos}

    Run Keyword If  ${label_exists} < 1  fail  Text '${label_text}' does not exists in PDF File.

    ${label_page}  get from dictionary  ${label_text_pos[0]}  page
    ${label_row}  get from dictionary  ${label_text_pos[0]}  row

    @{search_text_pos}  find_text_position_in_entire_pdf  ${search_text.__str__()}
    Search Value In Position List  ${label_page}  ${label_row}  @{search_text_pos}

Search Value In Position List
    [Arguments]  ${label_page}  ${label_row}  @{search_text_pos}
    ${same_line}  Set Variable  None
    FOR  ${pos}  IN  @{search_text_pos}
      ${value_page}  get from dictionary  ${pos}  page
      ${find_page}  Set Variable If  '${label_page}'=='${value_page}'  ${True}  ${False}
      ${value_row}  get from dictionary  ${pos}  row
      ${same_line}  Set Variable If  '${label_row}'=='${value_row}' and '${find_page}'=='${True}'   ${True}  ${False}
      Run Keyword If  '${same_line}'=='${True}'  Exit For Loop
    END
    Should Be True  ${same_line}

Get Carrier Password From DB
    [Arguments]  ${DB}  ${carrier_id}
    Get Into DB  ${DB}
    ${passwd}  Query And Strip  SELECT TRIM(passwd) AS passwd FROM member WHERE member_id= ${carrier_id}
    [Return]  ${passwd}

Setup Carrier for Money Code Report
    [Documentation]  Keyword Setup Carrier for Money Code Report

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
    Add Money Code Report Permission to Carrier

Add Money Code Report Permission to Carrier
    [Documentation]    Give the carrier the money code report permission

    Ensure Carrier has User Permission    ${carrier.id}    MONEYCODE_REPORT

Add Money Code Reason List Permission to Carrier
    [Documentation]    Give the carrier the money code reason list permission

    Ensure Carrier has User Permission    ${carrier.id}    MON_CODE_REASON

Remove Money Code Reason List Permission from Carrier
    [Documentation]    Remove from carrier the money code reason list permission

    Remove Carrier User Permission    ${carrier.id}    MON_CODE_REASON

Log Carrier into eManager with Issue Money permission
    [Documentation]  Log carrier into eManager with Issue Money permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Money Codes > Issue Money Code
    [Documentation]  Go to Select Program > Money Codes > Issue Money Code

    Go To  ${emanager}/cards/MoneyCodeManagement.action
    Wait Until Page Contains    Money Code Information

Go to Select Program > Reports/Exports > Money Code Report
    [Documentation]  Go to Select Program > Money Codes > Money Code Report

    Go To  ${emanager}/cards/MoneyCodeReport.action
    Wait Until Page Contains    Select Schedule or Immediate Report

Go to Money Code History
    [Documentation]  Go to Money Code History screen from Issue Money Code

    Click Element    name=history
    Wait Until Page Contains    Money Codes History

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

Search in Money Codes History
    [Documentation]  Search in Money Codes History with only date or some other search key such as reference, money code
    ...    or issue to
    [Arguments]    ${onlyDate}=True    ${checkbox}=referenceChecked    ${key}=reference    ${value}=${code_id}

    Go to Money Code History
    Run Keyword If    '${onlyDate}'=='False'    Input Search Data    ${checkbox}    ${key}    ${value}
    Click Element    name=lookupHistory
    Wait Until Element is Visible    id=moneyCode

Input Search Data
    [Documentation]  Select the search checkbox and fills the text box with the value
    [Arguments]    ${check_path}    ${txtbox_path}    ${value}

    Select Checkbox    ${check_path}
    Input Text    ${txtbox_path}    ${value}

Open and Create Money Code Report
    [Documentation]  Opens money code report with the recent issued money code and create a report

    Search in Money Codes History
    Click Element    //a[text()='${code_id}']
    Wait Until Page Contains    Select Schedule or Immediate Report
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
    [Documentation]  Check the report has reason code info

    Open PDF Doc  ${filePath}
    Search Value By Label Position   Reason Code:  ${db_mc_reason_desc}
    Close PDF
    Remove Report File    ${report_name}

Check No Reason Code Description in Report
    [Documentation]  Check the report has no reason code info

    Open PDF Doc  ${filePath}
    Search Value By Label Position   Reason Code:  ${EMPTY}
    Close PDF
    Remove Report File    ${report_name}

Create Money Code Scheduled Report
    [Documentation]  Create money code scheduled report for issued money code and update its scheduled time
    [Arguments]    ${format}=PDF    ${frequency}=DAILY

    Go to Select Program > Reports/Exports > Money Code Report
    Input Text    name=referenceId    ${code_id}
    Click Element    //*[@value="SCHEDULED"]
    Select From List By Label    name=viewFormat    ${format}
    Click Element    name=viewMoneyCodeReport
    Wait Until Element Is Visible    name=jobDescription
    Set Test Variable    ${scheduled_report_desc}    ${code_id}${format}${frequency}
    Input Text    name=jobDescription    ${scheduled_report_desc}
    Click Element    //*[@value="${frequency}"]
    Click Element    name=submitScheduledJob
    Wait Until Page Contains    You may also go to 'Scheduled Reports' from your menu to see the status of your report
    Go to Scheduled Recent Jobs
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