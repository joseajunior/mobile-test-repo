*** Settings ***
Documentation
...  Intent: This suite covers strictly the Card Report in eManager. The report is downloaded and the content
...  is validated in all formats.

Library  otr_model_lib.Models
Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  OperatingSystem  WITH NAME  os
Library  locale
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags    Reports  Payments  eManager

*** Variables ***


*** Test Cases ***
Navigate to Payment History Screen
    [Tags]  JIRA:BOT-1158  refactor

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Payment History
    [Teardown]  Run Keywords
    ...         Close Browser

Submit a Payment History With Some Cutoff Date
    [Tags]  JIRA:BOT-1158  refactor
    [Setup]  Get Into DB  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Payment History
    Submit a Payment History
    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  disconnect from database

Change the Cutoff date to Something Else and Submit Again
    [Setup]  Get Into DB  TCH
    [Tags]  JIRA:BOT-1158  refactor

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Payment History
    Get Last AR Number
    Submit a Payment History  ${ar_number}
    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  disconnect from database

Ensure PDF Download
    [Tags]  JIRA:BOT-1158  refactor
    [Setup]  Get Into DB  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Payment History
    Submit a Payment History
    Download File  PDF
    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  disconnect from database
    ...         AND  os.Remove File  ${filePath}

Ensure Excel Download
    [Tags]  JIRA:BOT-1158  refactor
    [Setup]  Get Into DB  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Payment History
    Submit a Payment History
    Download File  Excel
    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  disconnect from database
    ...         AND  os.Remove File  ${filePath}

Ensure CSV Download
    [Tags]  JIRA:BOT-1158  refactor
    [Setup]  Get Into DB  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Payment History
    Submit a Payment History
    Download File  CSV
    [Teardown]  Run Keywords
    ...         Close Browser
    ...         AND  disconnect from database
    ...         AND  os.Remove File  ${filePath}

Assert PDF Payment Report
    [Tags]  JIRA:BOT-1158  JIRA:BOT-2036  refactor
    [Setup]  Get Into DB  TCH

    Open Emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Navigate to Payment History
    Submit a Payment History
    Download File  PDF
    Assert PDF File
    [Teardown]  Run Keywords
    ...         Disconnect From Database
    ...         AND  Close Browser
    ...         AND  Close pdf
    ...         AND  os.Remove File  ${filePath}


*** Keywords ***
Navigate to Payment History
    Go To  ${emanager}/cards/PaymentHistory.action

Submit a Payment History
    [Arguments]  ${ar_num}=None
    ${number}  Get AR Number With Payments From Carrier  ${validCard.carrier.member_id}
    ${ar_number}  Set Variable If  '${ar_num}'=='None'  ${number}  ${ar_num}
    Select From List By Value  name=arnumber  ${ar_number}
    ${cutoff_date}  Get Payment Date From AR Number  ${ar_number}
    Run Keyword If  '${cutoff_date}'!='None'  Run Keywords
    ...  Input Text  cutoffDate  ${cut_off_date}
    ...  AND  Click Element  submit
    ...  AND  Wait Until Element Is Visible  id=row
    ...  AND  Set Test Variable  ${ar_number}
    ...  AND  Set Test Variable  ${cutoff_date}
    ...  ELSE  Run Keywords
    ...  Click Element  submit
    ...  AND  Wait Until Element Is Visible  //ul[@class='messages']/li[text()='There is no Payment History for this AR Number.']

Get Last AR Number
    ${ar_numbers_count}  Get Element Count  //select[@name='arnumber']/option
    ${ar_number}  Get Element Attribute  //select[@name='arnumber']/option[${ar_numbers_count}]  value
    Set Test Variable  ${ar_number}

Search Payments On DB
    [Arguments]  ${ar_number}  ${cutoff_date}
    ${query}  Catenate
    ...        SELECT DECODE(cp.record_type,
    ...                     'PMT','Payment',
    ...                     'UPY','Under Payment',
    ...                     'XFR','Transfer',
    ...                     'OPY','',
    ...                     'NSF','',
    ...                     'STM','Statement',
    ...                     '') as type,
    ...               cp.oblig_id as invoice,
    ...               cp.invoice_date as invoice_date,
    ...               cp.due_date as due_date,
    ...               cp.applied_date as applied_dat,
    ...               cp.pmt_amt as paid_amount,
    ...               cp.adj_amt as adjustment_amount,
    ...               cp.total_amt as total,
    ...               cp.late_fee as late_fee
    ...        FROM carms_payment cp
    ...             INNER JOIN contract c ON cp.ar_number = c.ar_number
    ...        WHERE c.ar_number = '${ar_number}'
    ...        AND cp.applied_date <= TO_DATE('${cutoff_date}','%Y-%m-%d')
    ...        ORDER BY cp.applied_date desc, cp.record_type
    ...        LIMIT 20;
    ${output}  Query And Strip To Dictionary  ${query}
    [Return]  ${output}

Get AR Number With Payments From Carrier
    [Arguments]  ${carrier_id}
    ${query}  Catenate
    ...  SELECT DISTINCT TRIM(c.ar_number)
    ...  FROM carms_payment cp
    ...    INNER JOIN contract c ON c.ar_number = cp.ar_number
    ...  WHERE c.carrier_id = ${carrier_id}
    ...  LIMIT 1;
    ${ar_number}  Query And Strip  ${query}
    [Return]  ${ar_number}

Get Payment Date From AR Number
    [Arguments]  ${ar_number}
    ${query}  Catenate
    ...  SELECT DISTINCT cp.applied_date
    ...  FROM carms_payment cp
    ...    INNER JOIN contract c ON cp.ar_number = c.ar_number
    ...  WHERE c.ar_number = '${ar_number}'
    ...  ORDER BY cp.applied_date
    ...  LIMIT 1;
    ${base_cutoff_date}  Query And Strip  ${query}
    ${base_cutoff_date}  Run Keyword If  '${base_cutoff_date}'!='None'
    ...  Add Time To Date  ${base_cutoff_date.__str__()}  180 days  result_format=%Y-%m-%d
    [Return]  ${base_cutoff_date}

Download File
    [Arguments]  ${file_type}
    Click Element  //span[contains(text(),'${file_type}')]/parent::a
    ${extension}  Set Variable  pdf
    ${extension}  Set Variable If  '${file_type}'=='Excel'  xls  ${extension}
    ${extension}  Set Variable If  '${file_type}'=='CSV'  csv  ${extension}

    os.Wait Until Created  ${default_download_path}${/}*paymentHistory*${extension}
    ${file}  os.list directory  ${default_download_path}  *paymentHistory*.${extension}
    ${filePath}  os.normalize path  ${default_download_path}${/}${file[0]}
    os.File Should Not Be Empty  ${filePath}
    Set Test Variable  ${filePath}

Assert PDF File
    ${payments}  Search Payments On DB  ${ar_number}  ${cutoff_date}
    ${payments_list_size}  Get Length  ${payments['type']}
    Open PDF Doc  ${filePath}
    FOR  ${index}  IN RANGE  0  ${payments_list_size}
      ${invoice_pos}  Find Text Position In Entire PDF  ${payments['invoice'][${index}]}
      ${paid_amount}  Get Clean Amount To Payments Report  ${payments['paid_amount'][${index}]}
      ${adjustment_amount}  Get Clean Amount To Payments Report  ${payments['adjustment_amount'][${index}]}
      ${total}  Get Clean Amount To Payments Report  ${payments['total'][${index}]}
      tch logging  Searching Line ${index}:
      tch logging  | ${payments['type'][${index}]} | ${payments['invoice'][${index}]} | ${payments['invoice_date'][${index}]} | ${payments['due_date'][${index}]} | ${payments['applied_dat'][${index}]} | ${paid_amount} | ${adjustment_amount} | ${payments['late_fee'][${index}]} |
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${payments['type'][${index}]}
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${payments['invoice_date'][${index}]}
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${payments['due_date'][${index}]}
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${payments['applied_dat'][${index}]}
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${paid_amount}
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${adjustment_amount}
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${payments['late_fee'][${index}]}
      Search Value On Pdf By Page And Row  ${invoice_pos}  ${total}
      tch logging  \n
    END
    close pdf

Search Value On Pdf By Page And Row
    [Arguments]  ${invoice_pos}  ${value}
    ${same_line}  Set Variable  None
    ${invoice_pos_size}  Get Length  ${invoice_pos}
    FOR  ${i}  IN RANGE  0  ${invoice_pos_size}
      ${position}  Set Variable  ${invoice_pos[${i}]}
      ${page}  Get From Dictionary  ${position}  page
      ${row}  Get From Dictionary  ${position}  row
      Run Keyword If  '${value}'=='None'  Return From Keyword
      @{text_pos}  Find Text Position In Entire PDF  ${value}
      ${same_line}  Search Value In Position List  ${page}  ${row}  @{text_pos}
      Run Keyword If  '${same_line}'=='${True}'  Exit For Loop
    END

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
    [Return]  ${same_line}

Get Clean Amount To Payments Report
    [Arguments]  ${number}
    ${number}  Convert Number To Currency  ${number}
    ${last_char}  Get Substring  ${number}  -1
    ${number_without_last_char}  Get Substring  ${number}  0  -1
    ${number}  Set Variable If  '${last_char}'=='0'  ${number_without_last_char}  ${number}
    [Return]  ${number}