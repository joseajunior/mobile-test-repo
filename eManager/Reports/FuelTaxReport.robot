*** Settings ***

Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyExcel
Library  String
Library  otr_robot_lib.ftp.pyFTP.FTPLibrary
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  Reports  Fuel Tax Report  eManager

Suite Setup  Suite Setup
Suite Teardown  Suite Teardown

*** Variables ***
${carrier}  103866

*** Test Cases ***
Load a Report Using All Filters
    [Tags]  JIRA:BOI-441  qTest:34646466  Regression  refactor
    [Documentation]  Download a Fuel Tax Report using all Filters and Assert data with Database.
    [Setup]  Test Setup
#    ${date}  getDateTimeNow  %Y-%m-%d  days=-1
    ${date}  set variable  2019-07-24

    Navigate To Money Fuel Tax Report
    Submit Immediate Report
    ...  report_name=${report_name}
    ...  report_type=Excel
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  currency=USD
    ...  country=U
    ...  product=ULSD
    ...  contract=3035
    ...  state_prov=AR
    Assert if File is Dowloaded  ${report_name}.xls
    Get Fuel Tax Report Information  ${filePath}
    Get Fuel Tax From Database  ${carrier}
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  country=U
    ...  product=ULSD
    ...  contract=3035
    ...  state_prov=AR
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}

    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using the Match By State Option
    [Tags]  JIRA:BOI-441  qTest:34646467  Regression  refactor
    [Documentation]  Download a Fuel Tax Report using Using the Match By State Option and Assert data with Database.
    [Setup]  Test Setup
#    ${date}  getDateTimeNow  %Y-%m-%d  days=-1
    ${date}  set variable  2019-07-24

    Navigate To Money Fuel Tax Report
    Submit Immediate Report
    ...  report_name=${report_name}
    ...  report_type=Excel
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  state_prov=AR
    Assert if File is Dowloaded  ${report_name}.xls
    Get Fuel Tax Report Information  ${filePath}
    Get Fuel Tax From Database  ${carrier}
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  state_prov=AR
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}

    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Different Fuel Types
    [Tags]  JIRA:BOI-441  qTest:34646468  Regression  refactor
    [Documentation]  Download a Fuel Tax Report using Different Fuel Types and Assert data with Database.
    [Setup]  Test Setup
#    ${date}  getDateTimeNow  %Y-%m-%d  days=-1
    ${date}  set variable  2019-07-24

    Navigate To Money Fuel Tax Report
    Submit Immediate Report
    ...  report_name=${report_name}
    ...  report_type=Excel
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  product=ULSD
    Assert if File is Dowloaded  ${report_name}.xls
    Get Fuel Tax Report Information  ${filePath}
    Get Fuel Tax From Database  ${carrier}
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  product=ULSD
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}

    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Different Contracts
    [Tags]  JIRA:BOI-441  qTest:34646469  Regression  refactor
    [Documentation]
#    ${date}  getDateTimeNow  %Y-%m-%d  days=-1
    ${date}  set variable  2019-07-24

    FOR  ${i}  IN  @{contract}
      Test Setup
      Navigate To Money Fuel Tax Report
      Submit Immediate Report
      ...  report_name=${report_name}
      ...  report_type=Excel
      ...  begin_date=${date}
      ...  end_date=${date}
      Assert if File is Dowloaded  ${report_name}.xls
      Get Fuel Tax Report Information  ${filePath}
      Get Fuel Tax From Database  ${carrier}
      ...  begin_date=${date}
      ...  end_date=${date}
      Validate Report With Database  ${report_dictionary}  ${database_dictionary}
      Remove Report File  ${report_name}
      Close Browser
    END

    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

Load a Report Using Different Currency and Units of Measurement
    [Tags]  JIRA:BOI-441  qTest:34646470  Regression  refactor
    [Documentation]
    [Setup]  Test Setup
#    ${date}  getDateTimeNow  %Y-%m-%d  days=-1
    ${date}  set variable  2019-07-24

    Navigate To Money Fuel Tax Report
    Submit Immediate Report
    ...  report_name=${report_name}
    ...  report_type=Excel
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  currency=CAD
    Assert if File is Dowloaded  ${report_name}.xls
    Get Fuel Tax Report Information  ${filePath}
    Get Fuel Tax From Database  ${carrier}
    ...  begin_date=${date}
    ...  end_date=${date}
    ...  currency=CAD
    Validate Report With Database  ${report_dictionary}  ${database_dictionary}

    [Teardown]  Run Keywords  Remove Report File  ${report_name}
    ...  AND  Close Browser

*** Keywords ***
Suite Setup
    Get Into DB  TCH
    ${validCard.carrier.password}    Get Carrier Password  ${carrier}
    Set Suite Variable  ${validCard.carrier.password}
    Get Contracts From Carrier  ${carrier}

Test Setup
    Open Emanager  ${carrier}  ${validCard.carrier.password}

Suite Teardown
    Disconnect From Database


Navigate To Money Fuel Tax Report
    Go To  ${emanager}/cards/FuelTaxReport.action
    Wait Until Element Is Visible  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Get Text  //span[contains(text(),'Logged in as:')]/parent::span/parent::td/preceding-sibling::td/span
    ${name}  Remove From String  ${SPACE}  ${name}
    ${report_name}  Get eManager Report Name  ${name}
    Set Test Variable  ${report_name}

Submit Immediate Report
    [Arguments]  ${report_name}  ${report_type}  ${begin_date}  ${end_date}  ${currency}=USD  ${country}=${empty}  ${product}=${empty}  ${contract}=${empty}  ${state_prov}=${empty}

    Click Element  //input[@title='Immediate Report']

    #Date Selection
    Input Text  startDate  ${begin_date}
    Input Text  endDate  ${end_date}

    #Country Selection
    Run Keyword If  '${country}'!='${empty}'  Select Country  ${country}

    #Currency Selection
    Select From List By Value  currency  ${currency}

    #Product Selection
    Run Keyword If  '${product}'!='${empty}'  Select Product  ${product}

    #Contract Selection
    Run Keyword If  '${contract}'!='${empty}'  Select Contract  ${contract}

    #Match By Filters
    Run Keyword If  '${state_prov}'!='${empty}'  Match By State  ${state_prov}

    #Report Format
    Select From List by Label  viewFormat  ${report_type}

    #Download Report
    Click Element  submit
    Wait Until Element Is Visible  //a[text()='Click here to view the document']  timeout=30
    Click Element  //a[text()='Click here to view the document']
    ${extension}  Set Variable If  '${report_type}'=='Pdf'  pdf  xls
    os.Wait Until Created  ${default_download_path}${/}*${report_name}*${extension}

    Set Test Variable  ${begin_date}
    Set Test Variable  ${end_date}

Select Country
    [Arguments]  ${country}
    [Documentation]  Options are: U for United States and C for Canada
    Select From List By Value  country  ${country.__str__()}

Select Contract
    [Arguments]  ${contract}
    Select From List By Value  contractId  ${contract.__str__()}

Select Product
    [Arguments]  ${product}
    Click Element  groupId
    Click Element  //option[normalize-space(@value)='${product.__str__()}']

Match By State
    [Arguments]  ${state_prov}
    Select Checkbox  stateShow
    Wait Until Element is Enabled  stateProv
    Select From List By Value  stateProv  ${state_prov.__str__()}

Assert if File is Dowloaded
    [Arguments]  ${report_name}
    ${report_name}  Split String  ${report_name}  .
    os.File Should Exist  ${default_download_path}${/}*${report_name[0]}*${report_name[1]}
    ${file}  os.List Directory  ${default_download_path}  *${report_name[0]}*.${report_name[1]}
    ${filePath}  os.Normalize Path  ${default_download_path}${/}${file[0]}
    os.File Should Not Be Empty  ${filePath}
    Set Test Variable  ${filePath}
    #log to console  ${filePath}

Remove Report File
    [Arguments]  ${report_name}
    [Documentation]  Check if the file exists and then remove the file
    ${fileExists}  run keyword and return status  OperatingSystem.file should exist  ${default_download_path}${/}*${report_name}*
    run keyword if  '${fileExists}'=='${True}'  OperatingSystem.remove files  ${default_download_path}${/}*${report_name}*

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

Get Fuel Tax From Database
    [Arguments]  ${carrier_id}  ${begin_date}  ${end_date}  ${currency}=USD  ${country}=${empty}  ${product}=${empty}  ${contract}=${empty}  ${state_prov}=${empty}
    ${end_date}  Add Time To Date  ${end_date}  1 day  result_format=%Y-%m-%d

    ${country}  Set Variable If  '${country}'=='U'  USA  ${country}
    ${country}  Set Variable If  '${country}'=='C'  CAN  ${country}

    ${query}  Catenate
    ...  SELECT location_name,
    ...         city,
    ...         invoice,
    ...         post_date,
    ...         tran_date,
#    ...         CASE
#    ...           WHEN dst_curr = 'CAD' THEN (total_amount*rate)/liters_volume
#    ...           ELSE ROUND(ppu,2)
#    ...         END AS ppu,
    ...         CASE
    ...           WHEN dst_curr = 'CAD' THEN liters_volume
    ...           ELSE gallons_volume
    ...         END AS volume,
    ...         amount * rate AS amount,
    ...         state_tax * rate AS state_tax,
    ...         federal_tax * rate AS federal_tax,
    ...         stateprovince
    ...             FROM (SELECT l.name AS location_name,
    ...               l.city,
    ...               TRIM(t.invoice) AS invoice,
    ...               TO_CHAR(t.pos_date,'%Y-%m-%d %H:%M') AS post_date,
    ...               TO_CHAR(t.trans_date,'%Y-%m-%d %H:%M') AS tran_date,
    ...               tl.ppu,
    ...               tl.amt AS total_amount,
    ...               tl.amt - state.amount - fed.amount AS amount,
    ...               state.amount AS state_tax,
    ...               fed.amount AS federal_tax,
    ...               l.state AS stateprovince,
    ...               l.state,
    ...               t.trans_date,
    ...               cc.rate,
    ...               cc.dst_curr,
    ...               tl.qty*3.785411784 AS liters_volume,
    ...               tl.qty AS gallons_volume
    ...        FROM TRANSACTION t
    ...          LEFT JOIN trans_line tl ON t.trans_id = tl.trans_id
    ...          JOIN trans_line_tax fed
    ...            ON fed.trans_id = tl.trans_id
    ...           AND fed.line_id = tl.line_id
    ...           AND fed.tax_desc = 'FED'
    ...          JOIN trans_line_tax state
    ...            ON state.trans_id = tl.trans_id
    ...           AND state.line_id = tl.line_id
    ...           AND state.tax_desc = 'SFTX'
    ...          JOIN location l ON t.location_id = l.location_id
    ...          JOIN contract c ON t.contract_id = c.contract_id
    ...          JOIN curr_conv cc  ON cc.src_curr = c.currency
    ...          AND cc.dst_curr = '${currency}'
    ...          AND cc.effect_date = (SELECT MAX(cc2.effect_date) FROM curr_conv cc2 WHERE cc2.src_curr = c.currency AND cc2.dst_curr = '${currency}')
    ...        WHERE t.carrier_id = '${carrier_id}'
    ...        AND t.trans_date >= '${begin_date} 00:00'
    ...        AND t.trans_date < '${end_date} 00:00'

    ${query}  Set Variable If  '${country}'!='${empty}'  ${query} AND l.src_country='${country}'  ${query}
    ${query}  Set Variable If  '${product}'!='${empty}'  ${query} AND TRIM(tl.group_cat)='${product}'  ${query} AND tl.group_cat IN ('DSL','BDSL','ULSD')
    ${query}  Set Variable If  '${contract}'!='${empty}'  ${query} AND t.contract_id='${contract}'  ${query}
    ${query}  Set Variable If  '${state_prov}'!='${empty}'  ${query} AND l.state='${state_prov}'  ${query}
    ${query}  Catenate  ${query} ) AS l ORDER BY l.state, l.trans_date;
    ${database_dictionary}  Query To Dictionaries  ${query}
#    log to console  ${query}

    FOR  ${i}  IN  @{database_dictionary}
#    \  ${ppu}  Get From Dictionary  ${i}  ppu
#    \  ${ppu}  Convert To Number  ${ppu}  2
#    \  Set To Dictionary  ${i}  ppu=${ppu}
      ${volume}  Get From Dictionary  ${i}  volume
      ${volume}  Convert To Number  ${volume}  2
      Set To Dictionary  ${i}  volume=${volume}
      ${amount}  Get From Dictionary  ${i}  amount
      ${amount}  Convert To Number  ${amount}  2
      Set To Dictionary  ${i}  amount=${amount}
      ${state_tax}  Get From Dictionary  ${i}  state_tax
      ${state_tax}  Convert To Number  ${state_tax}  2
      Set To Dictionary  ${i}  state_tax=${state_tax}
      ${federal_tax}  Get From Dictionary  ${i}  federal_tax
      ${federal_tax}  Convert To Number  ${federal_tax}  2
      Set To Dictionary  ${i}  federal_tax=${federal_tax}
    END
    Set Test Variable  ${database_dictionary}

Get Fuel Tax Report Information
    [Arguments]  ${filePath}
    ${report_dictionary}  Get Values From Excel Rows  ${filePath}
    FOR  ${i}  IN  @{report_dictionary}
      Remove From Dictionary  ${i}  ppu
      Remove From Dictionary  ${i}  unit
      ${stateprovince}  Pop From Dictionary  ${i}  state/province
      Set To Dictionary  ${i}  stateprovince=${stateprovince}
      ${post_date}  Get From Dictionary  ${i}  post_date
      ${post_date}  Excel Date To String  ${post_date}  %Y-%m-%d %H:%M
      Set To Dictionary  ${i}  post_date=${post_date}
      ${tran_date}  Get From Dictionary  ${i}  tran_date
      ${tran_date}  Excel Date To String  ${tran_date}  %Y-%m-%d %H:%M
      Set To Dictionary  ${i}  tran_date=${tran_date}
#    \  ${ppu}  Get From Dictionary  ${i}  ppu
#    \  ${ppu}  Convert To Number  ${ppu}  2
#    \  Set To Dictionary  ${i}  ppu=${ppu}
      ${amount}  Get From Dictionary  ${i}  amount
      ${amount}  Convert To Number  ${amount}  2
      Set To Dictionary  ${i}  amount=${amount}
      ${volume}  Get From Dictionary  ${i}  volume
      ${volume}  Convert To Number  ${volume}  2
      Set To Dictionary  ${i}  volume=${volume}
      ${state_tax}  Get From Dictionary  ${i}  state_tax
      ${state_tax}  Convert To Number  ${state_tax}  2
      Set To Dictionary  ${i}  state_tax=${state_tax}
      ${federal_tax}  Get From Dictionary  ${i}  federal_tax
      ${federal_tax}  Convert To Number  ${federal_tax}  2
      Set To Dictionary  ${i}  federal_tax=${federal_tax}
    END
    Set Test Variable  ${report_dictionary}

Validate Report With Database
    [Arguments]  ${report_dictionary}  ${database_dictionary}
    ${list_compare}  Compare List Dictionaries As Strings  ${report_dictionary}  ${database_dictionary}
    log to console  WhiteSpace
    ${report}  Get Length  ${report_dictionary}
    ${database}  Get Length  ${database_dictionary}
    #log to console  R:${report} ${report_dictionary}
    #log to console  D:${database} ${database_dictionary}
    Should Be True  ${list_compare}

Get Contracts From Carrier
    [Arguments]  ${carrier}

    ${query}  Catenate  SELECT contract_id FROM contract WHERE carrier_id='${carrier}'
    ${contract}  Query and Strip to Dictionary  ${query}
    ${contract}  Get From Dictionary  ${contract}  contract_id
    Set Suite Variable  ${contract}