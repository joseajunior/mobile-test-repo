*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Suite Setup  Setup
Suite Teardown  Run Keywords  Remove Application Using Application ID  ${application_id}
...  AND  Close All Browsers
Force Tags  Portal  Application Manager  weekly  Regression
Documentation  This is to test if a user can create a contract and set contract details & sales data properly

*** Variables ***
${card_type}  4
${contract_name}  TEST CONTRACT
${language}  1
${received_via}  EMAIL
${area_of_travel}  SOME AREA
${num_checks}  3
${num_codes}  5
${num_contracts}  2
${estimated_amount}  10
${estimated_volume}  6
${required_credit_line}  Open Line
${required_credit_amount}  50.69
${required_payment_method}  Wire
${required_payment_frequency}  WEEKLY
${required_terms}  1021
${required_cycle_code}  5004
${credit_line_type}  Draw Down
${credit_line_amount}  239.84
${payment_method}  Check
${payment_frequency}  MONTHLY
${terms}  1080
${cycle_code}  5008
${application_id}
${wrkflw_id}
@{wrkflw_ids}
@{integer_values}  10  15  2  25  85  0  100  85
@{simple_decimal_values}  58.65  79.20  100.87  1.00  234.99  7.57  18.98  821.65
@{multiple_decimal_values}  777.0165  19.552  38.77778  1.014  35.956  801.00915  457.8532  2100.6545
@{contract_info_valid_data}  ABCZ|//?@@@32324  BKDA432434;;;:  LJDAO NJNFSJNFS KFSNLJDK&%%124  KJLKDANDJJB&(1231
...  UT  US  65465  3564863448  2222222222  3333333333  adfadcca@ncancancnas.com  GRND  S
@{contract_info_invalid_data}  ABCZ|//?@@@VCS@ AVDAC32324GR@!$@  BKD+A4 FN@JNA FNKNFAJNFA KJNDJKAN34:
...  LJDAO NJNFSJNFS KFSNLJDK&%%124  KJLKDANDJJB&(1231  PA  US  65465-34956  35568764863448  222227575822
...  33333858886533  adfadcca@ncancancnas.com  OVRN  C

*** Test Cases ***
Application Manager Should Support Multiple Contracts
    [Tags]  JIRA:PORT-381  qTest:  Regression    checked
    [Documentation]  This is to test if we can create and save multiple contracts
    Create Multiple Contracts
    Verify Created Contracts

Each Contract Detail & Sales Field Is Saved Correctly In The Database
    [Tags]  JIRA:PORT-359  qTest:  Regression
    [Documentation]  This is to test if a contract can be filled and saved correctly
    Open Contract
    Fill Contract Detail & Sales
    Verify Contract Data Saved on Database

Master Service Agreement Checklist Can Be Opened and Used
    [Tags]  JIRA:PORT-359  qTest:  Regression
    [Documentation]  This is to test if MSA checkboxes are working properly
    Open MSA By Icon
    Verify MSA Checkboxes

All Checkboxes On Page Are Working
    [Tags]  JIRA:PORT-359  qTest:  Regression
    [Documentation]  This is to test if all checkboxes on Contract Details & Sales tab are working properly
    Open Contract & Sales Tab
    Verify General Checkboxes
    Verify Same As Requested Checkbox

Verify Integrity of Number Inputs
    [Tags]  JIRA:PORT-359  qTest:  Regression
    [Documentation]  This is to test if the properly values are being saved on database even when
    ...  invalid numbers are inputted
    Open Contract & Sales Tab
    Fill Contract Detail & Sales With Invalid Numbers
    Verify Database For Amount Values
    Verify Projected Revenue Box

Verify each input box is properly saved to the database when Save is clicked
    [Tags]  JIRA:PORT-366  qTest:  Regression
    [Documentation]  This is to test if the properly values are being saved on database even when
    ...  integers numbers are inputted
    Open Fees Tab
    Close MSA Checklist
    Fill Fees Tab With Data and Validate on Database  @{integer_values}
    Verify Service Charges Is Disabled

Verify only numbers and one decimal is able to be input into each input box
    [Tags]  JIRA:PORT-366  qTest:  Regression
    [Documentation]  This is to test if the properly values are being saved on database even when
    ...  decimal numbers with two places are inputted
    Open Fees Tab
    Fill Fees Tab With Data and Validate on Database  @{simple_decimal_values}

Verify amount in each input box is saved to the database rounded to the nearest 100ths place
    [Tags]  JIRA:PORT-366  qTest:  Regression
    [Documentation]  This is to test if the properly values are being saved on database even when
    ...  decimal numbers with multiple places are inputted
    Open Fees Tab
    Fill Fees Tab With Data and Validate on Database  @{multiple_decimal_values}

Verify "Service Charges" checkbox is saved properly to the database when checked and "Save" is clicked
    [Tags]  JIRA:PORT-366  qTest:  Regression
    [Documentation]  This is to test if the properly values are being saved on database when Service Chages checkbox
    ...  is checked
    Change Status To Credit Setup
    Open Fees Tab
    Service Charges Can Be Checked
    Verify Service Charges Enabled On Database

Verify "Service Charges" checkbox is saved properly to the database when unchecked and "Save" is clicked
    [Tags]  JIRA:PORT-366  qTest:  Regression
    [Documentation]  This is to test if the properly values are being saved on database when Service Chages checkbox
    ...  is unchecked
    Open Fees Tab
    Service Charges Can Be Unchecked
    Verify Service Charges Disabled On Database

Each Contact Info Field Is Saved Correctly In The Database
    Open Contact Info Tab
    Fill Contact Info Tab With Data  @{contract_info_valid_data}
    Validate Contact Info on Database  @{contract_info_valid_data}

Verify Invalid Values For Contact Info Fields
    Open Contact Info Tab
    Fill Contact Info Tab With Data  @{contract_info_invalid_data}
    Validate Contact Info on Database  @{contract_info_invalid_data}

Use More Than Two Chars to State and Country Fields
    Open Contact Info Tab
    Input More Than Two Chars to State and Country Fields

Verify If Credit Pulled (Need MSA) Checkbox Can Be Checked
    [Setup]  Search And Open Application  ${application_id}
    Open Credit Tab
    Select Credit Pulled Checkbox
    Save Application
    Verify If Credit Pulled Is Checked On Database

Verify If Credit Pulled (Need MSA) Checkbox Can Be Unchecked
    Open Credit Tab
    Unselect Credit Pulled Checkbox
    Save Application
    Verify If Credit Pulled Is Unchecked On Database

*** Keywords ***
Setup
    Open Browser to Portal
    Log Into Portal
    Select Portal Program  Application Manager
    ${application_id}=  Create Application
    Set Suite Variable  ${application_id}

Save Application
    Click Element  //*[@id="credit"]//descendant::*[@class="jimg jsave"]
    Wait Until Done Processing
    Wait Until Element Is Visible  //*[text()="Application ID:"]/parent::*/following-sibling::*[1]

Start a New Contract
    Wait Until Element Is Visible  xpath=//span[contains(text(),"Contracts")]  timeout=120
    Click Element  xpath=//span[contains(text(),"Contracts")]
    Wait Until Element Is Visible  //*[@id="contractListDiv"]//descendant::*[@class="jimg jadd"]  timeout=10
    Click Element  //*[@id="contractListDiv"]//descendant::*[@class="jimg jadd"]
    Wait Until Done Processing
    Sleep  3

Create Multiple Contracts
    FOR  ${i}  IN RANGE  ${num_contracts}
      Start a New Contract
      ${contract_id}=  Fill Contract Detail & Sales
      Append To List  ${wrkflw_ids}  ${contract_id}
      Close MSA Checklist
      Click Element  //*[@id="contractDetailsDiv"]//descendant::*[@class="jimg jprevious"]
    END

Verify Created Contracts
    FOR  ${contract_id}  IN  @{wrkflw_ids}
      ${contract_data}=  Get Contract Information Saved On Database  ${contract_id}
      ${dict_length} =  Get Length  ${contract_data}
      Should Be True  ${dict_length} != 0
    END

Input More Than Two Chars to State and Country Fields
    Input Text  request.contract.billToState  UTACB
    Click Element  request.contract.billToCountry
    Click Element  //*[@id="alert_content"]//descendant::*[@class="jimg jok"]
    Input Text  request.contract.billToCountry  USMNAB
    Click Element  request.contract.billToState
    Click Element  //*[@id="alert_content"]//descendant::*[@class="jimg jok"]
    Save Contract

Service Charges Can Be Checked
    Select Checkbox  __request.contract.serviceCharge

Service Charges Can Be Unchecked
    Unselect Checkbox  __request.contract.serviceCharge

Verify Service Charges Enabled On Database
    Save Contract
    ${fees_data}=  Get Contract Information Saved On Database
    Should Be Equal As Strings  ${fees_data['service_charge']}  Y

Verify Service Charges Disabled On Database
    Save Contract
    ${fees_data}=  Get Contract Information Saved On Database
    Should Be Equal As Strings  ${fees_data['service_charge']}  N

Fill Fees Tab With Data and Validate on Database
    [Arguments]  @{fees_list}
    Fill Fees Tab Information  @{fees_list}
    Save Contract
    ${fees_data}=  Get Contract Information Saved On Database
    ${transaction_fee}=  true round  ${fees_list[0]}  2
    ${combination_fee}=  true round  ${fees_list[1]}  2
    ${cash_advance_fee}=  true round  ${fees_list[2]}  2
    ${terminal_fee}=  true round  ${fees_list[3]}  2
    ${money_code_fee}=  true round  ${fees_list[4]}  2
    ${atm_fee}=  true round  ${fees_list[5]}  2
    ${setup_fee}=  true round  ${fees_list[6]}  2
    ${third_party_fee}=  true round  ${fees_list[7]}  2
    Should Be Equal As Numbers  ${fees_data['transaction_fee']}  ${transaction_fee}
    Should Be Equal As Numbers  ${fees_data['combination_fee']}  ${combination_fee}
    Should Be Equal As Numbers  ${fees_data['cash_advance_fee']}  ${cash_advance_fee}
    Should Be Equal As Numbers  ${fees_data['terminal_fee']}  ${terminal_fee}
    Should Be Equal As Numbers  ${fees_data['money_code_fee']}  ${money_code_fee}
    Should Be Equal As Numbers  ${fees_data['atm_fee']}  ${atm_fee}
    Should Be Equal As Numbers  ${fees_data['setup_fee']}  ${setup_fee}
    Should Be Equal As Numbers  ${fees_data['third_party_fee']}  ${third_party_fee}
    Should Be Equal As Strings  ${fees_data['service_charge']}  N

Fill Contract Detail & Sales
    wait until element is enabled  request.contract.cardType  timeout=60  #ac
    Select From List By Value  request.contract.cardType  ${card_type}
    Input Text  request.contract.contractName  ${contract_name}
    Select From List By Value  request.contract.language  ${language}
    Select From List By Value  request.contract.receivedVia  ${received_via}
    Input Text  request.contract.areaOfTravel  ${area_of_travel}
    Input Text  request.contract.numOfChecks  ${num_checks}
    Input Text  request.contract.numOfCodes  ${num_codes}
    Input Text  request.contract.estimatedAmount  ${estimated_amount}
    Input Text  request.contract.estimatedVolume  ${estimated_volume}
    Select From List By Label  request.contract.reqCreditLineType  ${required_credit_line}
    Input Text  request.contract.reqCreditLineAmt  ${required_credit_amount}
    Select From List By Label  request.contract.reqPaymentMethod  ${required_payment_method}
    Select From List By Value  request.contract.reqPaymentFrequency  ${required_payment_frequency}
    Select From List By Value  request.contract.reqTerms  ${required_terms}
    Select From List By Value  request.contract.reqCycleCode  ${required_cycle_code}
    Select From List By Label  request.contract.creditLineType  ${credit_line_type}
    Input Text  request.contract.creditLineAmt  ${credit_line_amount}
    Select From List By Label  request.contract.paymentMethod  ${payment_method}
    Select From List By Value  request.contract.paymentFrequency  ${payment_frequency}
    Select From List By Value  request.contract.terms  ${terms}
    Select From List By Value  request.contract.cycleCode  ${cycle_code}
    Checkbox Should Be Selected  __stayOpen
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]
    Close MSA Checklist
    Save Contract
    Scroll Element Into View  //*[text()="Workflow ID:"]/parent::*/following-sibling::*[1]
    ${wrkflw_id}=  Get Text  xpath=//div[contains(text(),"Workflow ID:")]/following-sibling::*[1]
    Set Suite Variable  ${wrkflw_id}
    [Return]  ${wrkflw_id}

Fill Contract Detail & Sales With Invalid Numbers
    Input Text  request.contract.reqCreditLineAmt  145.9523
    Input Text  request.contract.creditLineAmt  6464.49935
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]
    Close MSA Checklist
    Save Contract

Change Status To Credit Setup
    Select From List By Label  request.contract.status  Credit
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]
    Close MSA Checklist
    Input Text  request.projectedRevenue.fuelAndCash  5
    Save Contract
    Open MSA By Icon
    Click Element  //*[@id="msachklst"]/div/div/div/div/a
    Select From List By Label  request.contract.status  Credit Setup
    Close MSA Checklist
    Save Contract

Clear Fees Tab
    Clear Element Text  request.contract.transactionFee
    Clear Element Text  request.contract.combinationFee
    Clear Element Text  request.contract.cashAdvanceFee
    Clear Element Text  request.contract.terminalFee
    Clear Element Text  request.contract.moneyCodeFee
    Clear Element Text  request.contract.atmFee
    Clear Element Text  request.contract.setupFee
    Clear Element Text  request.contract.thirdPartyFee

Fill Fees Tab Information
    [Arguments]  @{fees_list}
    Clear Fees Tab
    Input Text  request.contract.transactionFee  ${fees_list[0]}
    Input Text  request.contract.combinationFee  ${fees_list[1]}
    Input Text  request.contract.cashAdvanceFee  ${fees_list[2]}
    Input Text  request.contract.terminalFee  ${fees_list[3]}
    Input Text  request.contract.moneyCodeFee  ${fees_list[4]}
    Input Text  request.contract.atmFee  ${fees_list[5]}
    Input Text  request.contract.setupFee  ${fees_list[6]}
    Input Text  request.contract.thirdPartyFee  ${fees_list[7]}

Fill Contact Info Tab With Data
    [Arguments]  @{contract_info}
    Input Text  request.contract.billToFname  ${contract_info[0]}
    Input Text  request.contract.billToLname  ${contract_info[1]}
    Input Text  request.contract.billToAddress  ${contract_info[2]}
    Input Text  request.contract.billToCity  ${contract_info[3]}
    Input Text  request.contract.billToState  ${contract_info[4]}
    Input Text  request.contract.billToCountry  ${contract_info[5]}
    Input Text  request.contract.billToZip  ${contract_info[6]}
    Input Text  request.contract.billToPhone  ${contract_info[7]}
    Input Text  request.contract.billToCell  ${contract_info[8]}
    Input Text  request.contract.billToFax  ${contract_info[9]}
    Input Text  request.contract.billToEmail  ${contract_info[10]}
    Input Text  request.contract.shipToFname  ${contract_info[0]}
    Input Text  request.contract.shipToLname  ${contract_info[1]}
    Input Text  request.contract.shipToAddress  ${contract_info[2]}
    Input Text  request.contract.shipToCity  ${contract_info[3]}
    Input Text  request.contract.shipToState  ${contract_info[4]}
    Input Text  request.contract.shipToCountry  ${contract_info[5]}
    Input Text  request.contract.shipToZip  ${contract_info[6]}
    Input Text  request.contract.shipToPhone  ${contract_info[7]}
    Input Text  request.contract.shipToCell  ${contract_info[8]}
    Input Text  request.contract.shipToFax  ${contract_info[9]}
    Input Text  request.contract.shipToEmail  ${contract_info[10]}
    Select From List By Value  request.contract.shippingMethod  ${contract_info[11]}
    Select From List By Value  request.contract.billShippingTo  ${contract_info[12]}
    Save Contract

Validate Contact Info on Database
    [Arguments]  @{contract_info}
    ${contract_data}=  Get Contract Information Saved On Database
    ${full_name}=  Get Substring  ${contract_info[0]}  0  30
    ${last_name}=  Get Substring  ${contract_info[1]}  0  30
    ${address}=  Get Substring  ${contract_info[2]}  0  30
    ${city}=  Get Substring  ${contract_info[3]}  0  30
    ${zip}=  Get Substring  ${contract_info[6]}  0  10
    ${phone}=  Get Substring  ${contract_info[7]}  0  10
    ${cell}=  Get Substring  ${contract_info[8]}  0  10
    ${fax}=  Get Substring  ${contract_info[9]}  0  10
    Should Be Equal As Strings  ${contract_data['bill_to_fname']}  ${full_name}
    Should Be Equal As Strings  ${contract_data['bill_to_lname']}  ${last_name}
    Should Be Equal As Strings  ${contract_data['bill_to_address_1']}  ${address}
    Should Be Equal As Strings  ${contract_data['bill_to_city']}  ${city}
    Should Be Equal As Strings  ${contract_data['bill_to_state']}  ${contract_info[4]}
    Should Be Equal As Strings  ${contract_data['bill_to_country']}  ${contract_info[5]}
    Should Be Equal As Strings  ${contract_data['bill_to_zip']}  ${zip}
    Should Be Equal As Strings  ${contract_data['bill_to_phone']}  ${phone}
    Should Be Equal As Strings  ${contract_data['bill_to_cell']}  ${cell}
    Should Be Equal As Strings  ${contract_data['bill_to_fax']}  ${fax}
    Should Be Equal As Strings  ${contract_data['bill_to_email']}  ${contract_info[10]}
    Should Be Equal As Strings  ${contract_data['ship_to_fname']}  ${full_name}
    Should Be Equal As Strings  ${contract_data['ship_to_lname']}  ${last_name}
    Should Be Equal As Strings  ${contract_data['ship_to_address_1']}  ${address}
    Should Be Equal As Strings  ${contract_data['ship_to_city']}  ${city}
    Should Be Equal As Strings  ${contract_data['ship_to_state']}  ${contract_info[4]}
    Should Be Equal As Strings  ${contract_data['ship_to_country']}  ${contract_info[5]}
    Should Be Equal As Strings  ${contract_data['ship_to_zip']}  ${zip}
    Should Be Equal As Strings  ${contract_data['ship_to_phone']}  ${phone}
    Should Be Equal As Strings  ${contract_data['ship_to_cell']}  ${cell}
    Should Be Equal As Strings  ${contract_data['ship_to_fax']}  ${fax}
    Should Be Equal As Strings  ${contract_data['ship_to_email']}  ${contract_info[10]}
    Should Be Equal As Strings  ${contract_data['shipping_method']}  ${contract_info[11]}
    Should Be Equal As Strings  ${contract_data['bill_shipping_to']}  ${contract_info[12]}

Verify Same As Requested Checkbox
    Select Checkbox  //label[text()='Same as Requested']/preceding-sibling::*[1]
    ${actual_credit_line}=  Get Value  request.contract.creditLineType
    ${actual_credit_amount}=  Get Value  request.contract.creditLineAmt
    ${actual_payment_method}=  Get Value  request.contract.paymentMethod
    ${actual_payment_frequency}=  Get Value  request.contract.paymentFrequency
    ${actual_terms}=  Get Value  request.contract.terms
    ${actual_cycle_code}=  Get Value  request.contract.cycleCode
    Should Be Equal As Strings  ${actual_credit_line}  ${required_credit_line}
    Should Be Equal As Numbers  ${actual_credit_amount}  ${required_credit_amount}
    Should Be Equal As Strings  ${actual_payment_method}  ${required_payment_method}
    Should Be Equal As Strings  ${actual_payment_frequency}  ${required_payment_frequency}
    Should Be Equal As Integers  ${actual_terms}  ${required_terms}
    Should Be Equal As Integers  ${actual_cycle_code}  ${required_cycle_code}
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]
    Save Contract

Verify Projected Revenue Box
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]
    Close MSA Checklist
    Input Text  request.projectedRevenue.fuelAndCash  5
    Input Text  request.projectedRevenue.secureFuel  16
    Input Text  request.projectedRevenue.zcon  3
    Save Contract
    Open Contract & Sales Tab
    ${revenue_box}=  Get Text  request.contract.monthlyRevenue
    Get Into Db  TCH
    ${query}  catenate  SELECT total_revenue FROM wrkflw_projected_revenue WHERE wrkflw_contract_id = ${wrkflw_id};
    ${total_revenue}  Query And Strip  ${query}
    Should Be Equal As Numbers  ${total_revenue}  24

Verify Database For Amount Values
    ${contract_data}=  Get Contract Information Saved On Database
    Should Be Equal As Numbers  ${contract_data['req_credit_line_amt']}  145.95
    Should Be Equal As Numbers  ${contract_data['credit_line_amt']}  6464.50

Open Contract
    Double Click Element  //*[@id="contractList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]
    Wait Until Done Processing
    Sleep  3

Open Contract & Sales Tab
    Click Element  xpath=//span[contains(text(),'Contract Detail & Sales')]

Open Fees Tab
    Close MSA Checklist
    Click Element  xpath=//span[contains(text(),'Fees')]

Open Contact Info Tab
    Close MSA Checklist
    Click Element  xpath=//span[contains(text(),'Contact Info')]

Open Credit Tab
    Click Element  xpath=//span[contains(text(),'Credit')]

Verify Service Charges Is Disabled
    Element Should Be Disabled  __request.contract.serviceCharge

Get Contract Information Saved On Database
    [Arguments]  ${id}=${wrkflw_id}
    get into db  TCH
    ${query}  catenate  SELECT * FROM wrkflw_contract WHERE wrkflw_contract_id = ${id};
    ${contract_data}  Query And Strip To Dictionary  ${query}
    [Return]  ${contract_data}

Select Credit Pulled Checkbox
    Checkbox Should Not Be Selected  __request.cardApp.creditSetupDone
    Select Checkbox  __request.cardApp.creditSetupDone
    Checkbox Should Be Selected  __request.cardApp.creditSetupDone

Unselect Credit Pulled Checkbox
    Unselect Checkbox  __request.cardApp.creditSetupDone
    Checkbox Should Not Be Selected  __request.cardApp.creditSetupDone

Verify If Credit Pulled Is Checked On Database
    ${credit_pulled}=  Get Credit Pulled Info From Database
    Should Be Equal As Strings  ${credit_pulled}  Y

Verify If Credit Pulled Is Unchecked On Database
    ${credit_pulled}=  Get Credit Pulled Info From Database
    Should Be Equal As Strings  ${credit_pulled}  N

Get Credit Pulled Info From Database
    Get Into Db  TCH
    ${query}  catenate  SELECT credit_setup_done FROM wrkflw_cardappl WHERE app_id = ${application_id};
    ${credit_pulled}  Query And Strip  ${query}
    [Return]  ${credit_pulled}

Verify Contract Data Saved on Database
    ${contract_data}=  Get Contract Information Saved On Database
    Should Be Equal As Integers  ${contract_data['card_type']}  ${card_type}
    Should Be Equal As Strings  ${contract_data['contract_name']}  ${contract_name}
    Should Be Equal As Integers  ${contract_data['language']}  ${language}
    Should Be Equal As Strings  ${contract_data['received_via']}  ${received_via}
    Should Be Equal As Strings   ${contract_data['area_of_travel']}  ${area_of_travel}
    Should Be Equal As Integers  ${contract_data['num_of_checks']}  ${num_checks}
    Should Be Equal As Integers  ${contract_data['num_of_codes']}  ${num_codes}
    Should Be Equal As Integers  ${contract_data['estimated_amount']}  ${estimated_amount}
    Should Be Equal As Integers  ${contract_data['estimated_volume']}  ${estimated_volume}
    Should Be Equal As Strings  ${contract_data['req_credit_line_type']}  ${required_credit_line}
    Should Be Equal As Numbers  ${contract_data['req_credit_line_amt']}  ${required_credit_amount}
    Should Be Equal As Strings  ${contract_data['req_payment_method']}  ${required_payment_method}
    Should Be Equal As Strings  ${contract_data['req_payment_frequency']}  ${required_payment_frequency}
    Should Be Equal As Integers  ${contract_data['req_terms']}  ${required_terms}
    Should Be Equal As Integers  ${contract_data['req_cycle_code']}  ${required_cycle_code}
    Should Be Equal As Strings  ${contract_data['credit_line_type']}  ${credit_line_type}
    Should Be Equal As Numbers  ${contract_data['credit_line_amt']}  ${credit_line_amount}
    Should Be Equal As Strings  ${contract_data['payment_method']}  ${payment_method}
    Should Be Equal As Strings  ${contract_data['payment_frequency']}  ${payment_frequency}
    Should Be Equal As Integers  ${contract_data['terms']}  ${terms}
    Should Be Equal As Integers  ${contract_data['cycle_code']}  ${cycle_code}

Verify General Checkboxes
    Select Checkbox  __request.contract.directBill
    Unselect Checkbox  __request.contract.directBill
    Select Checkbox  __request.contract.dontDoOracle
    Unselect Checkbox  __request.contract.dontDoOracle
    Select Checkbox  __request.contract.mmda
    Unselect Checkbox  __request.contract.mmda
    Select Checkbox  //*[@id="declineReasonList_optgroup_0"]
    Unselect Checkbox  //*[@id="declineReasonList_optgroup_0"]
    Unselect Checkbox  __stayOpen
    Select Checkbox  __stayOpen

Verify MSA Checkboxes
    Click Element  //*[@id="msachklst"]/div/div/div/div/a
    @{checkboxes}=  Get WebElements  //input[@type='checkbox']
    FOR  ${element}  IN  @{checkboxes}
      ${visible}=  Run Keyword And Return Status  Element Should Be Visible   ${element}
      Run Keyword If  ${visible}  Run Keyword And Ignore Error  Click Element  ${element}
    END
    FOR  ${element}  IN  @{checkboxes}
      ${visible}=  Run Keyword And Return Status  Element Should Be Visible   ${element}
      Run Keyword If  ${visible}  Run Keyword And Ignore Error  Click Element  ${element}
    END
    Close MSA Checklist

Open MSA By Icon
    Close MSA Checklist
    Click Element  xpath=//*[@class="jimg jnotebook"]