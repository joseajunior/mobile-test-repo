*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.services.GenericService
Library  DateTime
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.reports.PyExcel
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Documentation  Bot-182 Performs a Client Account Funds Transfer, Then 100 at the same time, Downloads the CarrierGroupCashLoadReport and validates the data with the

Suite Setup  Start Suite
#Test Teardown  End Test

Force Tags  eManager  Reports

*** Variables ***
${clientAccountCarrier}  141996
${CACPass}  19YI30
${CACCont}  72514
${clientCardCarrier}  142070
${childCarrier}  142014
${childContract}  72535
${cardLoadCarrier}  144220
${amount}  150

*** Test Cases ***
Create Child Carrier
    [Tags]  BOT-1197  qTest:28953346  Regression  JIRA:BOT-1752  checked  refactor
    [Documentation]  Create a Child Carrier to a carrier.
    Search and Seup Carrier Allowed to Create Childs  ${clientAccountCarrier}

    Open eManager  ${carrier}  ${passwd}
    Navigate to Client Carrier Creation
    Fill Child Carrier Form
    Assert Child Carrier on DB

    [Teardown]  Close Browser

Perform Client Account Fund Transfer
    [Tags]  JIRA:BOT-182  BOT-1198  qTest:28953622  Regression  refactor
    [Documentation]  Transfer funds from a parent carrier to a child carrier
    Search and Seup Carrier Allowed to Create Childs  ${clientAccountCarrier}
    Retrieve Original Amount

    Open eManager  ${carrier}  ${passwd}
    Navigate to Carrier Group Funds Transfer
    Select Contract
    Search Child Carrier
    Transfer Funds to Child Carrier  10
    Assert Contract Amount  10

    [Teardown]  Run Keywords
    ...  Reset Carrier  ${carrier}  ${sec_user_backup['status_id']}  ${sec_user_backup['passwd_fail_count']}  ${create_group_inserted}  ${transfer_group_inserted}
    ...  AND  Close Browser

Attempt to Process More than 1 Client Account Fund Transfer
    [Tags]  BOT-1199  qTest:28954506  Regression  refactor
    [Documentation]  Transfer funds from a parent to more than one child carrier
    Search and Seup Carrier Allowed to Create Childs  ${clientAccountCarrier}

    Open eManager  ${carrier}  ${passwd}
    Navigate to Carrier Group Funds Transfer
    Select Contract
    Search Child Carriers By Name  TRUCK%LLC
    Transfer Funds to n Child Carriers  2
    Assert n Contracts Amount  2

    [Teardown]  Run Keywords
    ...  Reset Carrier  ${carrier}  ${sec_user_backup['status_id']}  ${sec_user_backup['passwd_fail_count']}  ${create_group_inserted}  ${transfer_group_inserted}
    ...  AND  Close Browser

Download and Validate Carrier Group Cash Load Report
    [Tags]  JIRA:BOT-182  qTest:31355760  refactor
    ${TODAY}=  getdatetimenow  %Y-%m-%d
    open emanager  ${clientAccountCarrier}  ${CACPass}
    go to  ${eManager}/cards/CarrierGroupCashLoadReport.action
    input text  startDate  ${TODAY}
    input text  endDate  ${TODAY}
    select from list by label  viewFormat  Excel

    click element  viewReport
    open new window  text=Click here to view the document  timeout=180
    #wait for report to download
    sleep  4


    validate report


*** Keywords ***
Start Suite
    Remove Carrier Group Cash Load Reports
    tch logging  Setup Complete  INFO

Remove Carrier Group Cash Load Reports
#    IF ANY MONEY CODE USE REPORT EXIST IN THE DOWNLOADS DIRECTORY, THEN DELETE THEM ALL.
    @{files}=  os.list directory  ${default_download_path}  *CarrierGroupCashLoadReport*
    print list  @{files}
    FOR  ${i}  IN  @{files}
       tch logging  Permanently removing ${default_download_path}/${i}  WARN
       os.remove file  ${default_download_path}/${i}
    END

validate report
    @{file}=  os.list directory  ${default_download_path}  *CarrierGroupCashLoadReport*
    log to console  ${file[0]}
    ${downloadpath}=  os.normalize path  ${default_download_path}
    ${filPath}=  assign string  ${downloadpath}\\${file[0]}
    tch logging  my file is: ${filPath}  INFO
    open excel  ${filPath}
    ${sheets}=  get sheet names
    tch logging  sheets: ${sheets}
    ${rowCount}=  get row count  ${sheets[0]}
    tch logging  count:${rowCount}
    ${columnCount}=  get column count  ${sheets[0]}
    tch logging  count:${columnCount}

    ${today}=  getdatetimenow  %Y-%m-%d
    ${sql}=  catenate
    ...  select cgx.carrier_id, mc.name, child.contract_id, cx.ref_num, cx.card_num, nvl(cgfee.total_fees,0.0) as Fee, nvl(ca.id,'LOAD') as typeId, TO_CHAR(cx.xfer_date,'%Y-%m-%d %H:%M') as xfer_date, cx.amount, cx.who
    ...  from (Select * from carrier_group_xref where (effective_date IS NULL OR effective_date <= current) and (expire_date IS NULL OR expire_date > current)) cgx
    ...  inner join contract child
    ...  on child.carrier_id = cgx.carrier_id
    ...  inner join member mc
    ...  on mc.member_id = child.carrier_id
    ...  left outer join carrier_group_xfer cx
    ...  on cx.parent_contract_id = ${CACCont}
    ...  and cx.child_contract_id = child.contract_id
    ...  left outer join cash_adv ca
    ...  on ca.cash_adv_id = cx.cash_adv_id
    ...  left outer join payr_cash_adv pca
    ...  on pca.cash_adv_id = cx.payr_cash_adv_id
    ...  left outer join (
    ...  select cg_xfer_id, sum(amount) as total_fees
    ...  from other_fees
    ...  group by cg_xfer_id
    ...  ) cgfee on cgfee.cg_xfer_id = cx.cg_xfer_id
    ...  where cgx.parent = ${clientAccountCarrier}
    ...  and cx.xfer_date is not null and cx.xfer_date >= '${today} 00:00'
    ...  and cx.xfer_date <= '${today} 23:59'
    ...  order by child.carrier_id, mc.name, child.contract_id, nvl(cx.card_num, ''), cx.xfer_date desc;

    get into db  tch
    tch logging  My SQL is ${sql}  INFO
    ${data}=  query  ${sql}  db_instance=tch
    ${data}=  strip DB Query to list  ${data}
    set global variable  ${data}

    FOR  ${i}  IN RANGE  0  ${rowCount}
      ${vals}=  get row values  ${sheets[0]}  ${i}  ${True}
      check row  ${vals}  ${i}  ${columnCount}
    END

check row
    [Arguments]  ${row}  ${rowNum}  ${columnCount}

    tch logging  examining row ${rowNum}: ${row}  INFO
#    ${dbRow}=  evaluate  ${rowNum}-1
#    tch logging  db row equivalent ${data[${dbRow}]}
    FOR  ${i}  IN RANGE  0  ${columnCount}
      run keyword if  ${rowNum}!=0  myColumn  ${row[${i}][1]}  ${i}  ${rowNum}
   END


myColumn
    [Arguments]  ${colVal}  ${colNum}  ${rowNum}
    #Make sure numbers are numbers
    ${colVal}=  run keyword if  ${colNum}==0 or ${colNum}==2 or ${colNum}==5 or ${colNum}==9  convert to number  ${colVal}
                ...  ELSE  Set Variable  ${colVal}

    #The Row in the DB is 1 less than the row in the excel spreadsheet (excel has a header)
    ${rowNum}=  evaluate  ${rowNum}-1

    #Make sure DB Nulls are treated as empty strings
    ${dbVal}=  run keyword if  '${data[${rowNum}][${colNum}]}' is 'None'  Set Variable  ${Empty}
                ...  ELSE  Set Variable  ${data[${rowNum}][${colNum}]}

    #remove spaces from db value string
    ${dbVal}=  run keyword if  ${colNum}==1 or ${colNum}==3 or ${colNum}==4 or ${colNum}==6 or ${colNum}==7  remove trailing spaces  ${dbVal}
                ...  ELSE  Set Variable  ${dbVal}

#    log to console  '${colVal}' '${dbVal}'
    run keyword if  ${colNum}==0  should be equal as numbers  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==1  should be equal as strings  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==2  should be equal as numbers  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==3  should be equal as strings  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==4  should be equal as strings  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==5  should be equal as numbers  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==6  should be equal as strings  ${colVal}  ${dbVal}
    #Excel Date Format isn't the same as a normal date use a keyword to convert it to a date string
    ...  ELSE IF  ${colNum}==7  check Excel Date  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==8  should be equal as numbers  ${colVal}  ${dbVal}
    ...  ELSE IF  ${colNum}==9  should be equal as numbers  ${colVal}  ${dbVal}


check Excel Date
    [Arguments]  ${colVal}  ${dbVal}
    #convert to a date string then check it
    ${colVal}=  excel date to string  ${colVal}
    should be equal as strings  ${colVal}  ${dbVal}

Search and Seup Carrier Allowed to Create Childs
    [Arguments]  ${selected_carrier}=None
    Get Into DB  TCH
    ${query}  Catenate  SELECT m.member_id, m.passwd, c.contract_id FROM member m
    ...                      INNER JOIN contract c ON m.member_id = c.carrier_id
    ...                 WHERE EXISTS (SELECT 1 FROM carrier_group_xref cgx WHERE cgx.parent = m.member_id)
    ...                 AND c.status = 'A'

    ${query_condition}  Run Keyword If  '${selected_carrier}'!='None'
    ...  Catenate  AND m.member_id = ${selected_carrier}
    ...  ELSE
    ...  Catenate  AND c.credit_bal > 100 LIMIT 1
    ${query}  Catenate  ${query}  ${query_condition}

    ${output}  Query And Strip To Dictionary  ${query}

    Set Test Variable  ${carrier}  ${output['member_id']}
    Set Test Variable  ${passwd}  ${output['passwd']}
    Set Test Variable  ${contract}  ${output['contract_id']}

    Get Into DB  MySQL
    ${sec_user_backup}  Query And Strip To Dictionary  SELECT status_id, passwd_fail_count FROM sec_user WHERE user_id = '${carrier}'
    execute sql string  dml=update sec_user SET status_id = 'A', passwd_fail_count = 0 WHERE user_id = '${carrier}'

    Set Test Variable  ${sec_user_backup}  ${sec_user_backup}

    ${create_child_carrier_group}  Set Variable  CLIENT_CARRIER_CREATE
    ${transfer_contract_funds}     Set Variable  CARRIER_GROUP_CONTRACT_XFER

    ${query}  Catenate  SELECT 1 FROM sec_user_role_xref
    ...                 WHERE user_id = '${carrier}'
    ...                 AND role_id =

    ${carrier_can_create}    Row Count  ${query}'${create_child_carrier_group}'
    ${carrier_can_transfer}  Row Count  ${query}'${transfer_contract_funds}'

    Set Test Variable  ${create_group_inserted}  None
    Run Keyword If  '${carrier_can_create}'=='0'  Run Keywords
    ...  Set Test Variable  ${create_group_inserted}  ${TRUE}
    ...  AND  execute sql string  dml=insert INTO sec_user_role_xref(user_id, role_id, menu_visible) VALUES (${carrier},'${create_child_carrier_group}',true)

    Set Test Variable  ${transfer_group_inserted}  None
    Run Keyword If  '${carrier_can_transfer}'=='0'  Run Keywords
    ...  Set Test Variable  ${transfer_group_inserted}  ${TRUE}
    ...  AND  execute sql string  dml=insert INTO sec_user_role_xref(user_id, role_id, menu_visible) VALUES (${carrier},'${transfer_contract_funds}',true)

Reset Carrier
    [Arguments]  ${carrier}  ${status_id}  ${passwd_fail_count}  ${create_group_inserted}  ${transfer_group_inserted}
    Get Into DB  MySQL
    execute sql string  dml=update sec_user SET status_id = '${status_id}', passwd_fail_count = ${passwd_fail_count} WHERE user_id = '${carrier}'

     Run Keyword If  '${create_group_inserted}'!='None'
     ...  execute sql string  dml=delete FROM sec_user_role_xref WHERE user_id = '${carrier}' AND role_id = 'CLIENT_CARRIER_CREATE'

     Run Keyword If  '${transfer_group_inserted}'!='None'
     ...  execute sql string  dml=delete FROM sec_user_role_xref WHERE user_id = '${carrier}' AND role_id = 'CARRIER_GROUP_CONTRACT_XFER'

Retrieve Original Amount
    Get Into DB  TCH
    ${child_carrier}  Query And Strip  SELECT carrier_id FROM carrier_group_xref WHERE parent = ${carrier}
    Set Test Variable  ${child_carrier}  ${child_carrier}

    ${child_contract}  Query And Strip  SELECT contract_id from contract where carrier_id = ${child_carrier}
    Set Test Variable  ${child_contract}  ${child_contract}

    ${child_original_amount}  Query And Strip  SELECT balance FROM contract_journal WHERE contract_id = ${child_contract} order by journal_id desc limit 1;
    Set Test Variable  ${child_original_amount}  ${child_original_amount}

Navigate to Carrier Group Funds Transfer
    Go to  ${emanager}/cards/CarrierGroupContractXFer.action

Navigate to Client Carrier Creation
    Go to  ${emanager}/cards/CarrierCreate.action

Fill Child Carrier Form
    Input Text  carrierDefinition.legalName  Kakarotto
    Input Text  carrierDefinition.mailingAddress  Piccolo St, 123
    Input Text  carrierDefinition.mailingCity  Namek
    Select From List By Value  carrierDefinition.mailingState  UT
    Input Text  carrierDefinition.mailingZip  4217
    Input Text  carrierDefinition.contactName  Chi-Chi
    Input Text  carrierDefinition.contactPhone  111-111-1111
    Input Text  carrierDefinition.email  efs.testers@efsllc.com
    Input Text  confirmEmail  efs.testers@efsllc.com
    Select From List By Value  carrierDefinition.numberOfCards  1
    Click Button  submitBtnId

    Wait Until Element Is Visible  //*[@class='messages']  timeout=20
    ${carrier_id}  Get Text  //ul[@class='messages']/li/b[1]
    Set Test Variable  ${carrier_id}  ${carrier_id}

Assert Child Carrier on DB
    Get Into DB  TCH
    Row Count Is Equal To X  SELECT 1 FROM member WHERE member_id = ${carrier_id}  1

Select Contract
#    Select From List By Value  name=selectContractId  ${contract.__str__()}
    Click Button  submit

Search Child Carrier
    Get Into DB  TCH
    Input Text  searchTxt  ${child_carrier}
    Click Button  search

Search Child Carriers By Name
    [Arguments]  ${name}=TRUCK%LLC
    Select Radio Button  lookupCarrierRadio  NAME
    input text  searchTxt  ${name}
    Click Button  search

Search All Child Carriers
    Click On  lookupCarrierRadio
    Click Button  search

Transfer Funds to Child Carrier
    [Arguments]  ${amount}
    Input Text  //input[@title='The Transfer Amount field cannot be empty!']  ${amount}
    Input Text  //input[@title='The Transfer Amount field cannot be empty!']/following::input  Transfer Fund Test
    Click Button  submitAmountContract
    Switch Window  NEW
    Click Button  saveAmount
    Handle Alert
    Switch Window  MAIN
    Wait Until Element Is Visible  xpath=//h3[contains(text(),'Client Account Fund Transfer Report')]
    Click Button  continueToInputAmount

Transfer Funds to n Child Carriers
    [Arguments]  ${child_carrier_number}
    ${carrier_contract}  Create Dictionary
    ${original_carrier_amount}  Create Dictionary
    ${carrier_added_amount}  Create Dictionary
    FOR  ${i}  IN RANGE  1  ${child_carrier_number}+1
      Click Element  //table[@id='row']//tr[${i}]/td[count(//table[@id='row']//th[text()='Client Balance']/preceding-sibling::th)+1]/a
      Wait Until Element is Not Visible  //tr[${i}]/td/a[text()='???']
      ${child_carrier}  Get Text  //table[@id='row']//tr[${i}]/td[count(//table[@id='row']//th[text()='Client ID']/preceding-sibling::th)+1]
      ${child_contract}  Get Text  //table[@id='row']//tr[${i}]/td[count(//table[@id='row']//a[text()='Contract ID']/parent::th/preceding-sibling::th)+1]
      ${child_balance}  Get Text  //table[@id='row']//tr[${i}]/td[count(//table[@id='row']//th[text()='Client Balance']/preceding-sibling::th)+1]
      Set To Dictionary  ${carrier_contract}  ${child_carrier}  ${child_contract}
      Set To Dictionary  ${original_carrier_amount}  ${child_carrier}  ${child_balance}
      ${value}  Evaluate  13
      ${ref}  Generate Random String  2  [LETTERS]
      Set To Dictionary  ${carrier_added_amount}  ${child_carrier}  ${value}
      Input Text  //table[@id='row']//tr[${i}]//input[@title='The Transfer Amount field cannot be empty!']  ${value}
      Input Text  //table[@id='row']//tr[${i}]//input[@title='The Transfer Amount field cannot be empty!']/following::input[1]  ${ref}
    END
    Set Test Variable  ${carrier_contract}  ${carrier_contract}
    Set Test Variable  ${original_carrier_amount}  ${original_carrier_amount}
    Set Test Variable  ${carrier_added_amount}  ${carrier_added_amount}
    Click Button  submitAmountContract
    Switch Window  NEW
    Click Button  saveAmount
    Handle Alert
    Switch Window  MAIN
    Wait Until Element Is Visible  xpath=//h3[contains(text(),'Client Account Fund Transfer Report')]
    Click Button  continueToInputAmount

Assert n Contracts Amount
    [Arguments]  ${transfers}=1
    Get Into DB  TCH
    FOR  ${i}  IN RANGE  1  ${transfers}+1
      ${child_carrier}  Get Text  //table[@id='row']//tr[${i}]/td[count(//table[@id='row']//th[text()='Client ID']/preceding-sibling::th)+1]
      ${child_contract}  Get From Dictionary  ${carrier_contract}  ${child_carrier}
      ${child_original_amount}  Get From Dictionary  ${original_carrier_amount}  ${child_carrier}
      ${inserted_value}  Get From Dictionary  ${carrier_added_amount}  ${child_carrier}
      ${ui_child_balance}  Get Text  //table[@id='row']//tr[${i}]/td[count(//table[@id='row']//th[text()='Client Balance']/preceding-sibling::th)+1]
      ${ui_child_balance}  Remove String  ${ui_child_balance}  $
      ${ui_child_balance}  Remove String  ${ui_child_balance}  ,
      ${child_original_amount}  Remove String  ${child_original_amount}  $
      ${child_original_amount}  Remove String  ${child_original_amount}  ,
      tch logging  SELECT balance FROM contract_journal WHERE contract_id = ${child_contract.__str__()} and type = 'LOAD' ORDER BY journal_id DESC LIMIT 1
      ${child_balance}  Query And Strip  SELECT balance FROM contract_journal WHERE contract_id = ${child_contract} and type = 'LOAD' ORDER BY journal_id DESC LIMIT 1
      ${compare2}  Evaluate  ${child_original_amount} + ${inserted_value}
      Should Be Equal As Numbers  ${compare2}  ${child_balance}
      Should Be Equal As Numbers  ${compare2}  ${ui_child_balance}
    END

Assert Contract Amount
    [Arguments]  ${amount}
    ${ui_child_balance}  Get Text  //table[@id='row']//tr[1]/td[count(//table[@id='row']//th[text()='Client Balance']/preceding-sibling::th)+1]
    ${ui_child_balance}  Remove String  ${ui_child_balance}  $
    ${ui_child_balance}  Remove String  ${ui_child_balance}  ,
    tch logging  SELECT balance FROM contract_journal WHERE contract_id = ${child_contract.__str__()} and type = 'LOAD' ORDER BY journal_id DESC LIMIT 1
    ${child_balance}  Query And Strip  SELECT balance FROM contract_journal WHERE contract_id = ${child_contract} and type = 'LOAD' ORDER BY journal_id DESC LIMIT 1
    ${compare2}  Evaluate  ${child_original_amount} + ${amount}
    Should Be Equal As Numbers  ${compare2}  ${child_balance}
    Should Be Equal As Numbers  ${compare2}  ${ui_child_balance}