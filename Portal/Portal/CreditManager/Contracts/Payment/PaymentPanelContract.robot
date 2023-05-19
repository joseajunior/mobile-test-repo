*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  String
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  ../../../../Keywords/PortalKeywords.robot
Resource  ../../../../../Variables/validUser.robot
Resource  ../../../../Keywords/CreateApplicationKeywords.robot
Force Tags  Portal  Credit Manager
Documentation  Updates the user manipulatable portions of the Payment tab in Credit Manager in the DIT and ACPT environments. Wont' run on SIT or STG due to missing data and access issues [STG]
Suite Teardown  close all browsers
Suite Setup  Get in to Portal
Test Setup  Select Credit Manager and Get Contract
Test Teardown  Return to Portal Home

*** Variables ***
${acpt_contract_id}=  441710
${dit_contract_id}=  448278
${contract_id_search_box}=  xpath://*[@id="tid"]
${search_button}=  xpath://*[@id="searchForm"]/div[1]/a
${payment_tab}=  xpath://*[@id="creditForm"]/div[1]/div[3]/ul/li[4]
${payment_method_dropdown}=  xpath://*[@id="pmtMethod"]
${receiving_bank_dropdown}=  xpath://*[@id="paymentinfo"]/fieldset[1]/div[1]/div[2]/div[2]/select[1]
${payment_app_method_dropdown}=  request.contract.pmtAppMethod
${lockbox_account_dropdown}=  request.contract.lockbox
${payment_credit_hold}=  xpath://*[@id="paymentCreditHold_contract"]
${online_pay_checkbox}=  xpath://*[@id="paymentinfo"]/fieldset[1]/div[3]/input[1]
${hidden_online_pay_checkbox}=  xpath://*[@id="paymentinfo"]/fieldset[1]/div[3]/input[2]
${min_amount_field}=  request.contract.achMinAmt
${max_amount_field}=  request.contract.achMaxAmt
${velocity_field}=  request.contract.achVelocity
${fee_field}=  request.contract.phoneChkFee
${save_button}=  xpath://*[@id="saveContractForm"]
${refresh_button}=  xpath://*[@id="contractview"]/a[1]
${manual}=  Manual ACH
${auto}=  ACH Draft
${wire}=  Wire
${check}=  Check

*** Test Cases ***
Change Contract Payment Method Dropbox to :Auto ACH
    [Tags]  JIRA:PORT-399  qTest:47121023
    [Documentation]  Changes payment method to Auto ACH/PAD if not already selected.
    ${original_value}=  Change Value  ${payment_method_dropdown}  ${auto}
    Save
    Verify Changes and Restore Default  ${original_value}  ${payment_method_dropdown}  payment_method  cont_misc  contract_id
    Save

Change Contract Payment Method Dropbox to :Manual ACH
    [Tags]  JIRA:PORT-399  qTest:47121023
    [Documentation]  Changes payment method to Manual ACH/ETF if not already selected.
    ${original_value}=  Change Value  ${payment_method_dropdown}  ${manual}
    Save
    Verify Changes and Restore Default  ${original_value}  ${payment_method_dropdown}  payment_method  cont_misc  contract_id
    Save

Change Contract Payment Method Dropbox to :Wire
    [Tags]  JIRA:PORT-399  qTest:47121023
    [Documentation]  Changes payment method to Wire if not already selected.
    ${original_value}=  Change Value  ${payment_method_dropdown}  ${wire}
    Save
    Verify Changes and Restore Default  ${original_value}  ${payment_method_dropdown}  payment_method  cont_misc  contract_id
    Save

Change Contract Payment Method Dropbox to :Check
    [Tags]  JIRA:PORT-399  qTest:47121023
    [Documentation]  Changes payment method to Manual Check if not already selected.
    ${original_value}=  Change Value  ${payment_method_dropdown}  ${check}
    Save
    Verify Changes and Restore Default  ${original_value}  ${payment_method_dropdown}  payment_method  cont_misc  contract_id
    Save

Check if Receiving Bank is Disabled
    [Tags]  JIRA:PORT-399  qTest:47121053
    [Documentation]  Checks to see if the dropdown for Receiving Bank is disabled
    element should be disabled  ${receiving_bank_dropdown}

Change Payment App Method Dropbox to :Invoice Match
    [Tags]  JIRA:PORT-399  qTest:47103958
    [Documentation]  Change to Invoice Match if not already selected
    ${original_value}=  Change Value  ${payment_app_method_dropdown}  INVOICE MATCH
    Save
    Verify Changes and Restore Default  ${original_value}  ${payment_app_method_dropdown}
    Save

Change Payment App Method Dropbox to :Credit Fifo
    [Tags]  JIRA:PORT-399  qTest:47103958
    [Documentation]  Change to Credit Fifo if not already selected
    ${original_value}=  Change Value  ${payment_app_method_dropdown}  CREDIT FIFO
    Save
    Verify Changes and Restore Default  ${original_value}  ${payment_app_method_dropdown}
    Save

Change Lockbox Acct Dropbox to :53
    [Tags]  JIRA:PORT-399  qTest:47104017
    [Documentation]  Change to 53 if not already selected
    ${original_value}=  Change Value  ${lockbox_account_dropdown}  53
    Save
    Verify Changes and Restore Default  ${original_value}  ${lockbox_account_dropdown}
    Save

Change Lockbox Acct Dropbox to :82
    [Tags]  JIRA:PORT-399  qTest:47104017
    [Documentation]  Change to 82 if not already selected
    ${original_value}=  Change Value  ${lockbox_account_dropdown}  82
    Save
    Verify Changes and Restore Default  ${original_value}  ${lockbox_account_dropdown}
    Save

Change On-Line Pay Checkbox to :Allowed
    [Tags]  JIRA:PORT-399  qTest:47104022
    [Documentation]  Checks to see if On-line pay is allowed if it isn't changes it
    ${original_value}=  Change Value  ${online_pay_checkbox}  Y
    Save
    Verify Changes and Restore Default  ${original_value}  ${online_pay_checkbox}  ach_allowed  cont_misc  contract_id
    Save

Change On-Line Pay Checkbox to :Not Allowed
    [Tags]  JIRA:PORT-399  qTest:47121179
    [Documentation]  Checks to see if On-line pay is not allowed if it isn't changes it
    ${original_value}=  Change Value  ${online_pay_checkbox}  N
    Save
    Verify Changes and Restore Default  ${original_value}  ${online_pay_checkbox}  ach_allowed  cont_misc  contract_id
    Save

Change Minimum Amount to Valid Value :Minimum Amount
    [Tags]  JIRA:PORT-399  qTest:47104023
    [Documentation]  Change value in Minimum Amount field to Valid value
    ${original_value}=  Change Value  ${min_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${min_amount_field}  ach_min_amt  cont_misc  contract_id
    Save

Change Minimum Amount to Accepted Value with Characters :Minimum Amount
    [Tags]  JIRA:PORT-399  qTest:47307848
    [Documentation]  Change value in Minimum Amount field to Accepted value
    ${original_value}=  Change Value  ${min_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${min_amount_field}  ach_min_amt  cont_misc  contract_id
    Save

Change Minimum Amount to Accepted Value BIG Number :Minimum Amount
    [Tags]  JIRA:PORT-399  qTest:47307848
    [Documentation]  Change value in Minimum Amount field to Accepted value
    ${original_value}=  Change Value  ${min_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${min_amount_field}  ach_min_amt  cont_misc  contract_id
    Save

Change Minimum Amount to Invalid Value BIG Number :Minimum Amount
    [Tags]  JIRA:PORT-399  qTest:47121249
    [Documentation]  Change value in Minimum Amount field to Accepted value
    ${original_value}=  Change Value  ${min_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${min_amount_field}  ach_min_amt  cont_misc  contract_id
    Save

Change Maximum Amount to Accepted Value :Maximum Amount
    [Tags]  JIRA:PORT-399  qTest:47104024
    [Documentation]  Change value in Maximum Amount field to valid value
    ${original_value}=  Change Value  ${max_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${max_amount_field}  ach_max_amt  cont_misc  contract_id
    Save

Change Maximum Amount to Accepted Value with Characters :Maximum Amount
    [Tags]  JIRA:PORT-399  qTest:47307849
    [Documentation]  Change value in Maximum Amount field to Accepted value
    ${original_value}=  Change Value  ${max_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${max_amount_field}  ach_max_amt  cont_misc  contract_id
    Save

Change Maximum Amount to Accepted Value BIG Number :Maximum Amount
    [Tags]  JIRA:PORT-399  qTest:47307849
    [Documentation]  Change value in Maximum Amount field to Accepted value
    ${original_value}=  Change Value  ${max_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${max_amount_field}  ach_max_amt  cont_misc  contract_id
    Save

Change Maximum Amount to Invalid Value BIG Number :Maximum Amount
    [Tags]  JIRA:PORT-399  qTest:47121248
    [Documentation]  Change value in Maximum Amount field to Accepted value
    ${original_value}=  Change Value  ${max_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${max_amount_field}  ach_max_amt  cont_misc  contract_id
    Save

Change Velocity to Valid Value: Velocity
    [Tags]  JIRA:PORT-399  qTest:47104025
    [Documentation]  Change value in Velocity field to Valid value
    ${original_value}=  Change Value  ${max_amount_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${max_amount_field}  ach_max_amt  cont_misc  contract_id
    Save

Change Velocity to Accepted Value with Characters :Velocity
    [Tags]  JIRA:PORT-399  qTest:47307850
    [Documentation]  Change value in Velocity field to Accepted value
    ${original_value}=  Change Value  ${velocity_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${velocity_field}  ach_velocity  cont_misc  contract_id
    Save

Change Velocity to Accepted Value BIG Number :Velocity
    [Tags]  JIRA:PORT-399  qTest:47307850
    [Documentation]  Change value in Velocity field to Accepted value
    ${original_value}=  Change Value  ${velocity_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${velocity_field}  ach_velocity  cont_misc  contract_id
    Save

Change Velocity to Invalid Value BIG Number :Velocity
    [Tags]  JIRA:PORT-399  qTest:47121247
    [Documentation]  Change value in Velocity field to Accepted value
    ${original_value}=  Change Value  ${velocity_field}
    Save
    Verify Changes and Restore Default  ${original_value}  ${velocity_field}  ach_velocity  cont_misc  contract_id
    Save

Check if Fees Field is Read Only
    [Tags]  JIRA:PORT-399  qTest:47121245
    [Documentation]  Checks to see if the Fee field is read only
    ${attribute}=  Check Field Attribute  ${fee_field}  class
    pass execution if  '${attribute}'==' jreadonly'  element is not set strictly to readable

##Payment credit hold section########################
Checks Payment Credit Hold Disabled
    [Tags]  JIRA:PORT-399  qTest:47121170
    [Documentation]  Checks to see if the dropdown for Payment Credit Hold is disabled
    element should be disabled  ${payment_credit_hold}

*** Keywords ***
Get in to Portal
    Open Browser to portal
    ${status}=  Log Into Portal
    Select Contract ID
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}

Select Contract ID
    #TODO make dynamic
    ${contract_id}=  set variable if  '${ENVIRONMENT}'=='acpt'  ${acpt_contract_id}
    ...  ${dit_contract_id}
    set suite variable  ${contract_id}

Search for a Contract
    wait until element is enabled  ${contract_id_search_box}  timeout=120
    input text  ${contract_id_search_box}  ${contract_id}
    click element  ${search_button}

Select Contract
    wait until done processing
    wait until page contains element  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is enabled  xpath://*[@id="resultsTable"]  timeout=120
    ${ar_number}=  get text  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${contract_id}')]/.././preceding-sibling::node()[position() < 2][self::td]
    set suite variable  ${ar_number}  ${ar_number}
    double click element  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${contract_id}')]

Select Payment Tab
    wait until element is enabled  ${payment_tab}  timeout=60
    click element  ${payment_tab}

Select Credit Manager and Get Contract
    Select Portal Program  Credit Manager
    Search for a Contract
    Select Contract
    Select Payment Tab

Check Dropdown Current Value
    [Arguments]  ${expected_value}  ${field}
    wait until element is enabled  ${field}  timeout=60
    ${current_value}=  get selected list value   ${field}
    ${expected_value}=  set variable if  '${expected_value}'=='${manual}'  None
    ...  ${expected_value}
    ${status}=  run keyword and return status  should not be equal as strings  ${expected_value}  ${current_value}
    @{value_list}  create list  ${status}  ${current_value}
    [Return]  ${value_list}

Change Dropdown Value
    [Arguments]  ${value}  ${field}
    ${value}=  set variable if  '${value}'=='${manual}'  None
    ...  ${value}
    wait until element is enabled  ${field}  timeout=60
    ${new_value}=  select from list by value  ${field}  ${value}
    [Return]  ${new_value}

Restore Dropdowns to Default
    [Arguments]  ${field}  ${original_value}
    select from list by value  ${field}  ${original_value}

Verify Change on Page
    [Arguments]  ${original_value}  ${current_value}
    should not be equal  ${original_value}  ${current_value}

Verify Change in DB
    [Arguments]  ${current_value}  ${column}  ${table}  ${filter_column}
    get into db  TCH
    ${query}=  catenate  SELECT ${column}
    ...  FROM ${table}
    ...  WHERE ${filter_column}=${contract_id}
    ${db_value}=  query and strip  ${query}
    ${my_current_value}=  Modify Value For Comparison with DB Value  ${current_value}
    run keyword if  '${column}'=='ach_min_amt' or '${column}'=='ach_max_amt' or '${column}'=='ach_velocity'  should be equal as strings  ${db_value}  ${my_current_value}
    ...  ELSE  should be equal  ${db_value}  ${my_current_value}

Verify Change in DB Lockbox
    [Arguments]  ${current_value}
    get into db  ORACLE
    ${query}=  catenate  SELECT attribute4 FROM hz_party_sites WHERE party_site_number='${ar_number}'
    ${db_value}=  query and strip  ${query}
    should be equal  ${db_value}  ${current_value}

Verify Change in DB Payment App
    [Arguments]  ${current_value}
    get into db  ORACLE
    ${query}=  catenate  SELECT attribute6 FROM hz_customer_profiles WHERE site_use_id =
    ...  (SELECT site_use_id FROM hz_cust_site_uses_all WHERE location='${ar_number}')
    ${db_value}=  query and strip  ${query}
    should be equal  ${db_value}  ${current_value}

Modify Value For Comparison with DB Value
    [Arguments]  ${value}
    ${the_test}=  check test name  ${TEST NAME}
    ${field}=  get from list  ${the_test}  1
    ${return_value}=  set variable if  '${value}'=='${wire}' and '${field}'=='Wire'  W
    ...  '${value}'=='${check}' and '${field}'=='Check'  C
    ...  '${value}'=='${None}' and '${field}'=='Manual ACH'  N
    ...  '${value}'=='${auto}' and '${field}'=='Auto ACH'  A
    ...  '${value}'=='${EMPTY}' and '${field}'=='Maximum Amount'  '${None}'  #empty strings show up as none in db for this field
    ...  '${value}'=='${EMPTY}' and '${field}'=='Minimum Amount'  '${None}'  #empty strings show up as none in db for this field
    ...  '${value}'=='${EMPTY}' and '${field}'=='Velocity'  '${None}'  #empty strings show up as none in db for this field
    ...  '${value}'=='Y' and '${field}'=='Allowed'  Y
    ...  '${value}'=='N' and '${field}'=='Not Allowed'  N
    ...  '${value}'
    ${return_value}=  run keyword  strip my string  '${return_value}'  both  '
    [Return]  ${return_value}

Check Test Name
    [Arguments]  ${TEST NAME}
    ${type_list}=  String.split string from right  ${TEST NAME}  :
    [Return]  ${type_list}

Check Checkbox Value
    [Arguments]  ${field}  ${expected_value}
    wait until element is enabled  ${field}
    ${is_checked}=  get value  ${field}
    ${status}=  run keyword and return status  should not be equal  ${is_checked}  ${expected_value}
    @{list_values}  create list  ${status}  ${is_checked}
    [Return]  ${list_values}

Change Checkbox Value
    [Arguments]  ${field}
    wait until element is enabled  ${field}  timeout=60
    click element  ${field}
    Save
    wait until element is enabled  ${field}  timeout=60
    ${current_value}=  get value  ${field}
    [Return]  ${current_value}

Restore Checkbox to Default
    [Arguments]  ${field}  ${original_value}
    click element  ${field}

Get Current Value
    [Arguments]  ${field}
    wait until element is enabled  ${field}  timeout=60
    ${current_value}=  get value  ${field}
    [Return]  ${current_value}

Change Value Valid and Update Field
    [Arguments]  ${field}  ${original_value}
    wait until element is enabled  ${field}  timeout=60
    ${new_value}=  run keyword if  '${original_value}'<='1'  evaluate  ${original_value} + 1
    ...  ELSE IF  '${original_value}'>='4'  evaluate  ${original_value} - 1
    ...  ELSE  evaluate  ${original_value} + 1
    clear element text  ${field}
    input text  ${field}  ${new_value}
    [Return]  ${new_value}

Change Value Accepted with Characters and Update Field
    [Arguments]  ${field}
    wait until element is enabled  ${field}  timeout=60
    ${letters}=  Generate Random String  length=5  chars=[LETTERS]
    ${special_chars}=  set variable  />:!@#$%
    ${new_num_value}=  Generate Random String  2  chars=[NUMBERS]
    ${new_num_value}=  strip my string  ${new_num_value}  left  0
    clear element text  ${field}
    ${new_value}=  set variable  ${letters}${special_chars}${new_num_value}
    input text  ${field}  ${new_value}
    [Return]  ${new_value}

Input Accepted Values with Characters and Update Individually
    [Arguments]  ${field}
    wait until element is enabled  ${field}  timeout=60
    ${letters}=  Generate Random String  length=5  chars=[LETTERS]
    ${special_chars}=  set variable  />:!@#$%
    ${new_num_value}=  Generate Random String  2  chars=[NUMBERS]
    ${new_num_value}=  strip my string  ${new_num_value}  left  0
    clear element text  ${field}
    input text  ${field}  ${letters}
    sleep  2s
    input text  ${field}  ${special_chars}
    sleep  2s
    input text  ${field}  ${new_num_value}
    ${new_value}=  get value  ${field}
    [Return]  ${new_value}

Change Value Accepted and Update Field
    [Arguments]  ${field}
    ${new_value}=  Generate Random String  6  [NUMBERS]
    ${new_value}=  strip my string  ${new_value}  left  0
    wait until element is enabled  ${field}  timeout=60
    clear element text  ${field}
    input text  ${field}  ${new_value}
    [Return]  ${new_value}

Change to Invalid Value
    [Arguments]  ${field}
    ${new_value}=  Generate Random String  26  [NUMBERS]
    wait until element is enabled  ${field}  timeout=60
    clear element text  ${field}
    input text  ${field}  ${new_value}
    [Return]  ${new_value}

Restore Field to Default
    [Arguments]  ${field}  ${original_value}
    input text  ${field}  ${original_value}

Check Field Attribute
    [Arguments]  ${field}  ${attribute}
    wait until element is visible  ${field}  timeout=60
    ${attr}=  get element attribute  ${field}  ${attribute}
    ${attr}=  strip my string  ${attr}
    [Return]  ${attr}

Save
    wait until element is enabled  ${save_button}  timeout=60
    click element  ${save_button}
Wait Until the Changes are Saved
    [Arguments]  ${timeout}=60  ${msg}=Processing did not complete within ${timeout} sec
    run keyword and ignore error  wait until element is visible    //*[text()="Please wait while the changes are saved..."]  error="Please wait while the changes are saved..."
    run keyword and ignore error  wait until element is not visible  //*[text()="Please wait while the changes are saved..."]  ${timeout}  ${msg}

Back To Contract if Necessary
    ${results_table_status}=  run keyword and return status  page should not contain element  xpath://*[@id="resultsTable"]
    run keyword if  '${results_table_status}'=='${False}'  select contract
    ...  ELSE  select payment tab

Wait for Change
    [Arguments]  ${original_value}  ${field}
    ${current_value}=  get value  ${field}
    Verify Change on Page  ${original_value}  ${current_value}

Change Value
    [Arguments]  ${field}  @{option}
    ${length}=  get length  ${option}
    ${x}=  set variable  ${length}
    FOR  ${option}  IN  @{option}
      run keyword if  '${x}'=='0'  exit for loop
      set test variable  ${desired_value${x}}  ${option}
      ${x}=  evaluate  ${x} - 1
    END
    ${the_test}=  check test name  ${TEST NAME}
    ${name}=  get from list  ${the_test}  0
    ${contains_dropbox}=  evaluate  "Dropbox" in """${name}"""
    ${contains_checkbox}=  evaluate  "Checkbox" in """${name}"""
    ${contains_value}=  evaluate  "Value" in """${name}"""
    ${is_valid}=  evaluate  "Valid" in """${name}"""
    ${is_invalid}=  evaluate  "Invalid" in """${name}"""
    ${return_value}=  run keyword if   '${contains_dropbox}'=='${TRUE}'  Change Dropbox Value and Check Value  ${desired_value1}  ${field}
    ...  ELSE IF  '${contains_checkbox}'=='${TRUE}'  Change Checkbox Value and Check Value  ${desired_value1}  ${field}
    ...  ELSE IF  '${contains_value}'=='${TRUE}'  Change Textbox Value  ${field}  ${name}
    ...  ELSE  log to console  ${the_test}
    set suite variable  ${og_value}  ${return_value}
    [Return]  ${return_value}

Change Dropbox Value and Check Value
    [Arguments]  ${desired_value}  ${field}
    ${list_values}=  Check Dropdown Current Value  ${desired_value}  ${field}
    ${status}=  get from list  ${list_values}  0
    ${original_value}=  get from list  ${list_values}  1
    #false means user already selected value for testcase
    pass execution if  '${status}'=='${False}'  expected ${desired_value} to be selected in dropdown and it was.
    Change Dropdown Value  ${desired_value}  ${field}
    [Return]  ${original_value}

Change Checkbox Value and Check Value
    [Arguments]  ${desired_value}  ${field}
    ${list_values}=  Check Checkbox Value  ${field}  ${desired_value}
    ${status}=  get from list  ${list_values}  0
    ${original_value}=  get from list  ${list_values}  1
    pass execution if  '${status}'=='${False}'  expected checkbox to be checked and it was.
    Change Checkbox Value  ${field}
    [Return]  ${original_value}

Change Textbox Value
    [Arguments]  ${field}  ${name}
    ${original_value}=  Get Current Value  ${field}
    ${with_characters}=  evaluate  "Characters" in """${name}"""
    ${with_big_number}=  evaluate  "BIG" in """${name}"""
    ${is_invalid}=  evaluate  "Invalid" in """${name}"""
    ${new_value}=  run keyword if  '${with_characters}'=='${True}' and '${original_value}'!=''  Change Value Accepted with Characters and Update Field  ${field}
    ...  ELSE IF  '${with_characters}'=='${True}' and '${original_value}'==''  Input Accepted Values with Characters and Update Individually  ${field}
    ...  ELSE IF  '${with_big_number}'=='${True}' and '${is_invalid}'=='${False}'  Change Value Accepted and Update Field  ${field}
    ...  ELSE IF  '${with_big_number}'=='${True}' and '${is_invalid}'=='${True}'  Change to Invalid Value  ${field}
    ...  ELSE  Change Value Valid and Update Field  ${field}  ${original_value}
    [Return]  ${original_value}

Verify Changes and Restore Default
    [Arguments]  ${original_value}  ${field}  @{option}
    ${length}  get length  ${option}
    ${x}=  set variable  ${length}
    FOR  ${option}  IN  @{option}
      run keyword if  '${x}'=='0'  exit for loop
      set test variable  ${opt${x}}  ${option}
      ${x}=  evaluate  ${x} - 1
    END
    ${the_test}=  check test name  ${TEST NAME}
    ${name}=  get from list  ${the_test}  0
    ${contains_dropbox}=  evaluate  "Dropbox" in """${name}"""
    ${is_lockbox}=  evaluate  "Lockbox" in """${name}"""
    ${is_payment_app_method}=  evaluate  "Payment App Method" in """${name}"""
    ${contains_checkbox}=  evaluate  "Checkbox" in """${name}"""
    ${contains_value}=  evaluate  "Value" in """${name}"""
    ${return_value}=  run keyword if  ${contains_dropbox}==${TRUE} and ${is_lockbox}==${FALSE} and ${is_payment_app_method}==${FALSE}  Verify Dropdown Change in DB and Restore Default  ${original_value}  ${field}  ${opt3}  ${opt2}  ${opt1}
    ...  ELSE IF  ${contains_dropbox}==${TRUE} and ${is_lockbox}==${TRUE}  Verify Lockbox Change in DB and Restore Default  ${original_value}  ${field}
    ...  ELSE IF  ${contains_dropbox}==${TRUE} and ${is_payment_app_method}==${TRUE}  Verify Payment App Method Change in DB and Restore Default  ${original_value}  ${field}
    ...  ELSE IF  ${contains_value}==${TRUE}  Verify Textbox Change in DB and Restore Default  ${original_value}  ${field}  ${opt3}  ${opt2}  ${opt1}
    ...  ELSE IF  ${contains_checkbox}==${TRUE}  Verify Checkbox Change in DB and Restore Default  ${original_value}  ${field}  ${opt3}  ${opt2}  ${opt1}
    ...  ELSE  log to console  ${the_test}

Verify Dropdown Change in DB and Restore Default
    [Arguments]  ${original_value}  ${field}  ${column}  ${table}  ${filter}
    wait until the changes are saved
    wait until element is enabled  ${field}  timeout=60
    ${current_value}=  get selected list value  ${field}
    Verify Change on Page  ${original_value}  ${current_value}
    sleep  5s
    Verify Change in DB  ${current_value}  ${column}  ${table}  ${filter}
    Restore Dropdowns to Default  ${field}  ${original_value}

Verify Lockbox Change in DB and Restore Default
    [Arguments]  ${original_value}  ${field}
    wait until the changes are saved
    wait until element is enabled  ${field}  timeout=60
    ${current_value}=  get selected list value  ${field}
    Verify Change on Page  ${original_value}  ${current_value}
    sleep  5s
    Verify Change in DB Lockbox  ${current_value}
    Restore Dropdowns to Default  ${field}  ${original_value}

Verify Payment App Method Change in DB and Restore Default
    [Arguments]  ${original_value}  ${field}
    wait until the changes are saved
    wait until element is enabled  ${field}  timeout=60
    ${current_value}=  get selected list value  ${field}
    Verify Change on Page  ${original_value}  ${current_value}
    sleep  5s
    Verify Change in DB Payment App  ${current_value}
    Restore Dropdowns to Default  ${field}  ${original_value}

Verify Checkbox Change in DB and Restore Default
    [Arguments]  ${original_value}  ${field}  ${column}  ${table}  ${filter}
    wait until the changes are saved
    wait until keyword succeeds  60s  5s  Wait for Change  ${original_value}  ${field}
    ${current_value}=  get value  ${online_pay_checkbox}
    sleep  5s
    Verify Change on Page  ${original_value}  ${current_value}
    Verify Change in DB  ${current_value}  ${column}  ${table}  ${filter}
    Restore Checkbox to Default  ${field}  ${current_value}

Verify Textbox Change in DB and Restore Default
    [Arguments]  ${original_value}  ${field}  ${column}  ${table}  ${filter}
    wait until the changes are saved
    ${current_value}=  Get Current Value  ${field}
    ${test_name}=  check test name  ${TEST NAME}
    ${name}=  get from list  ${test_name}  0
    ${is_valid}=  evaluate  "Invalid" in """${name}"""
    run keyword if  '${is_valid}'=='${False}'  Verify Change on Page  ${original_value}  ${current_value}
    ...  ELSE  Verify Change on Page Invalid  ${original_value}  ${current_value}
    sleep  5s
    run keyword if  '${is_valid}'=='${False}'  Verify Change in DB  ${current_value}  ${column}  ${table}  ${filter}
    ...  ELSE  Verify Change in DB Invalid  ${current_value}  ${column}  ${table}  ${filter}  ${original_value}
    Restore Field to Default  ${field}  ${original_value}

Verify Change on Page Invalid
    [Arguments]  ${original_value}  ${current_value}
    run keyword if  '${original_value}'=='${EMPTY}' and '${current_value}'!='${EMPTY}'  should not be equal  ${original_value}  ${current_value}
    ...  ELSE IF  '${original_value}'=='${EMPTY}' and '${current_value}'=='${EMPTY}'  should be equal  ${original_value}  ${current_value}
    ...  ELSE  should not be equal  ${original_value}  ${current_value}

Verify Change in DB Invalid
    [Arguments]  ${current_value}  ${column}  ${table}  ${filter_column}  ${original_value}
    get into db  TCH
    ${query}=  catenate  SELECT ${column}
    ...  FROM ${table}
    ...  WHERE ${filter_column}=${contract_id}
    ${db_value}=  query and strip  ${query}
    ${my_current_value}=  Modify Value For Comparison with DB Value  ${current_value}
    ${db_value}=  set variable if  '${db_value}'=='${None}'  None
    convert to string  ${db_value}
    convert to string  ${my_current_value}
    run keyword if  '${original_value}'=='${EMPTY}' and '${current_value}'=='${EMPTY}' and '${db_value}'!='${NONE}'  should be equal  ${db_value}  ${my_current_value}
    ...  ELSE IF  '${current_value}'=='${EMPTY}' and '${db_value}'=='${NONE}'  should be equal  ${db_value}  ${my_current_value}
    ...  ELSE IF  '${original_value}'=='${EMPTY}' and '${current_value}'!='${EMPTY}' and '${db_value}'!='${NONE}'  should not be equal  ${db_value}  ${my_current_value}
    ...  ELSE IF  '${original_value}'!='${EMPTY}' and '${current_value}'=='${EMPTY}' and '${db_value}'!='${NONE}'  should not be equal  ${db_value}  ${my_current_value}
    ...  ELSE  should not be equal  ${db_value}  ${my_current_value}
