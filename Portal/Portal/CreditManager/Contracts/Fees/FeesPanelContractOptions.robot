*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  String
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Force Tags  Portal  Credit Manager
Documentation  Updates the options portion of the fees panel on the credit manager page in DIT and ACPT. Won't run in SIT and STG due to missing data and access issues [STG]

Suite Teardown  close all browsers
Suite Setup  Login
Test Setup  Get Contract and Select Panel
Test Teardown  Return to Portal Home

*** Variables ***


*** Test Cases ***
Checks slash Fee Change :Valid
    [Tags]  JIRA:PORT-386  qTest:46818506
    [Documentation]  Updates change in the Checks/Fee field and changes back to original value
    ${original_value}=  Change Input  chksPerFee
    Save
    Verify Changes and Restore to Default  ${original_value}  chks_per_fee  chksPerFee
    Save

Checks slash Fee Change :Accepted
    [Tags]  JIRA:PORT-386  qTest:46818506
    [Documentation]  Updates change in the Checks/Fee field and changes back to original value
    ${original_value}=  Change Input  chksPerFee
    Save
    Verify Changes and Restore to Default  ${original_value}  chks_per_fee  chksPerFee
    Save

Checks slash Fee Change :Invalid
    [Tags]  JIRA:PORT-417  qTest:47334842
    [Documentation]  Updates change in the Checks/Fee field and changes back to original value
    ${original_value}=  Change Input  chksPerFee
    Save
    Verify Changes and Restore to Default  ${original_value}  chks_per_fee  chksPerFee
    Save

Change Register Check to:Allowed
    [Tags]  JIRA:PORT-386  qTest:46818502
    [Documentation]  Toggles the Register Check checkbox
    ${list_of_values}=  Change Value of Checkbox  regCheckFlag
    Save
    Validate Checkbox Changes and Restore Default  regCheckFlag  reg_check_flag  ${list_of_values}
    Save

Change Register Check to :Not Allowed
    [Tags]  JIRA:PORT-386  qTest:46818507
    [Documentation]  Toggles the Register Check checkbox
    ${list_of_values}=  Change Value of Checkbox  regCheckFlag
    Save
    Validate Checkbox Changes and Restore Default  regCheckFlag  reg_check_flag  ${list_of_values}
    Save

Change ATM Use to :Allowed
    [Tags]  JIRA:PORT-386  qTest:46818511
    [Documentation]  Toggles the ATM Allowed checkbox
    ${list_of_values}=  Change Value of Checkbox  regCheckFlag
    Save
    Validate Checkbox Changes and Restore Default  regCheckFlag  reg_check_flag  ${list_of_values}
    Save

Change ATM Use to :Not Allowed
    [Tags]  JIRA:PORT-386  qTest:46818512
    [Documentation]  Toggles the ATM checkbox
    ${list_of_values}=  Change Value of Checkbox  regCheckFlag
    Save
    Validate Checkbox Changes and Restore Default  regCheckFlag  reg_check_flag  ${list_of_values}
    Save

*** Keywords ***
Login
    Open Browser to portal
    ${status}=  Log Into Portal
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}
    Get Valid Contract  ${ENVIRONMENT}

Get Contract and Select Panel
    Select the Portal Program  Credit Manager
    Search Contract
    wait until done processing
    Select Contract
    Select Fees Panel and Contract Tab

Search Contract
    wait until element is enabled  request.search.contractId  timeout=120
    input text  request.search.contractId  ${contractID}
    wait until element is enabled  request.search.carrierId  timeout=120
    input text  request.search.carrierId  ${carrierID}
    click portal button  Search

Select Contract
    wait until done processing
    wait until page contains element  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is visible  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is enabled  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is enabled  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]  timeout=120
    double click element  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]

Select Fees Panel and Contract Tab
    wait until element is enabled  xpath://*[@id="creditForm"]/div[1]/div[3]/ul/li[3]  timeout=60
    click element  xpath://*[@id="creditForm"]/div[1]/div[3]/ul/li[3]
    wait until element is enabled  xpath://*[@id="fees"]/fieldset/div[1]/ul/li[1]  timeout=60
    click element  xpath://*[@id="fees"]/fieldset/div[1]/ul/li[1]

Select Input Field in Fees Panel
    [Arguments]  ${field}
    wait until element is enabled  request.contract.${field}  timeout=60
    ${current_val}=  get value  request.contract.${field}
    [Return]  ${current_val}

Change Input Field Value Valid
    [Arguments]  ${value}  ${field}
    ${current_value}=  get value  request.contract.${field}
    clear element text  request.contract.${field}
    IF  '${current_value}'>'10'
        ${new_value}  evaluate  ${value} - 1
    ELSE
        ${new_value}  evaluate  ${value} + 1
    END
    ${new_value_str}=  evaluate  str(${new_value})
    IF  '${value}'=='${current_value}'
        input text  request.contract.${field}  ${new_value_str}
    ELSE
        input text  request.contract.${field}  ${value}
    END

Change Input Field Value Accepted
    [Arguments]  ${value}  ${field}
    wait until element is enabled  request.contract.${field}  timeout=60
    ${current_value}=  get value  request.contract.${field}
    ${letters}=  Generate Random String  length=26  chars=[LETTERS]
    ${special_chars}=  set variable  />:!@#$%^&*()_-=+";/?\|]}[{`~>
    ${num_string}=  Generate Random String  length=2  chars=[NUMBERS]
    ${num_string}=  Check Random Number  ${num_string}
    strip my string  ${num_string}  left  0
    ${new_value}=  set variable  ${special_chars}${letters}${num_string}
    clear element text  request.contract.${field}
    IF  '${value}'=='${current_value}'
        input text  request.contract.${field}  ${new_value}
    ELSE
        input text  request.contract.${field}  ${value}
    END

Change Input Field Value Invalid
    [Arguments]  ${value}  ${field}
    wait until element is enabled  request.contract.${field}  timeout=60
    ${current_value}=  get value  request.contract.${field}
    ${num_string}=  Generate Random String  length=26  chars=[NUMBERS]
    strip my string  ${num_string}  left  0
    ${new_value}=  set variable  ${num_string}
    clear element text  request.contract.${field}
    IF  '${value}'=='${current_value}'
        input text  request.contract.${field}  ${new_value}
    ELSE
        input text  request.contract.${field}  ${value}
    END

Verify Change on Page
    [Arguments]  ${original_value}  ${field}  ${test_type}
    wait until element is enabled  request.contract.${field}  timeout=60
    ${current_value}=  get value  request.contract.${field}
    IF  """${original_value}"""=="""${current_value}"""
        should be equal  ${original_value}  ${current_value}
    ELSE
        should not be equal  ${original_value}  ${current_value}
    END

Get Checkbox Value
    [Arguments]  ${field}
    wait until element is enabled  request.contract.${field}  timeout=120
    ${original_checked_value}=  get value  request.contract.${field}
    [Return]  ${original_checked_value}

Change Checkbox
    [Arguments]  ${checked_value}  ${option}  ${field}
    wait until element is enabled  __request.contract.${field}  timeout=60
    pass execution if  '${checked_value}'=='${option}'  wanted ${option} and it was already this, no need to proceed.
    IF  '${checked_value}'!='${option}'
        click element  __request.contract.${field}
    ELSE
        click element  __request.contract.${field}
    END
    ${new_value}=  get value  request.contract.${field}
    [Return]  ${new_value}

Validate Fees in DB
    [Arguments]  ${contractID}  ${field}  ${original_value}
    get into db  TCH
    ${query}=  catenate  SELECT ${field}
    ...  FROM contract
    ...  WHERE contract_id=${contractID}
    ${db_value}=  query and strip  ${query}
    should not be equal  ${original_value}  ${db_value}

Validate Checkboxes in DB
    [Arguments]  ${contractID}  ${field}  ${original_value}
    get into db  TCH
    ${query}=  catenate  SELECT ${field}
    ...  FROM cont_misc
    ...  WHERE contract_id=${contractID}
    ${db_value}=  query and strip  ${query}
    IF  '${original_value}'=='${EMPTY}'
        should not be equal as strings  ${original_value}  ${db_value}
    ELSE
        should not be equal  ${original_value}  ${db_value}
    END

Validate ATM Allowed in DB
    [Arguments]  ${contractID}  ${field}  ${original_value}
    get into db  TCH
    ${query}=  catenate  SELECT ${field}
    ...  FROM contract
    ...  WHERE contract_id=${contractID}
    ${db_value}=  query and strip  ${query}
    should not be equal  ${original_value}  ${db_value}

Get Valid Contract
    [Arguments]  ${database}
    ${carrier}  Find Carrier in Oracle  A
    ${query}=  catenate  select contract_id from contract where carrier_id = ${carrier}
    ${contract}=  query and strip  ${query}
    set suite variable  ${carrierID}  ${carrier}
    set suite variable  ${contractID}  ${contract}

Select the Portal Program
    [Arguments]  ${program}=Credit Manager
    wait until page contains element  //*[text()[contains(.,"${program}")]]  timeout=120
    wait until element is visible  //*[text()[contains(.,"${program}")]]  timeout=120
    click element  //*[text()[contains(.,"${program}")]]

Save
    wait until element is enabled  //*[@id="saveContractForm"]  timeout=60
    click element  //*[@id="saveContractForm"]
    wait until element is visible  xpath://*[@id="alert"]  timeout=120
    wait until element is enabled  xpath://*[@id="alert_content"]/div[2]/a  timeout=120
    click element  xpath://*[@id="alert_content"]/div[2]/a

Change Input
    [Arguments]  ${field}
    ${original_value}=  Select Input Field in Fees Panel  ${field}
    ${the_test}=  Check Test Name  ${TEST_NAME}
    ${test_type}=  get from list  ${the_test}  1
    IF  '${test_type}'=='Valid'
        Change Input Field Value Valid  ${original_value}  ${field}
    ELSE IF  '${test_type}'=='Accepted'
        Change Input Field Value Accepted  ${original_value}  ${field}
    ELSE IF  '${test_type}'=='Invalid'
        Change Input Field Value Invalid  ${original_value}  ${field}
    ELSE
        log to console  broke here ${TEST_NAME}
    END
    [Return]  ${original_value}

Verify Changes and Restore to Default
    [Arguments]  ${original_value}  ${column}  ${field}
    ${the_test}=  Check Test Name  ${TEST_NAME}
    ${test_type}=  get from list  ${the_test}  1
    wait until the changes are saved
    Verify Change on Page  ${original_value}  ${field}  ${test_type}
    Validate Fees in DB  ${contractID}  ${column}  ${original_value}
    Select Fees Panel and Contract Tab
    IF  '${test_type}'=='Valid'
        Change Input Field Value Valid  ${original_value}  ${field}
    ELSE IF  '${test_type}'=='Accepted'
        Change Input Field Value Accepted  ${original_value}  ${field}
    ELSE IF  '${test_type}'=='Invalid'
        Change Input Field Value Invalid  ${original_value}  ${field}
    END

Check Test Name
    [Arguments]  ${TEST NAME}
    ${type_list}=  String.split string from right  ${TEST NAME}  :
    [Return]  ${type_list}

Check Random Number
    [Arguments]  ${new_value}
    FOR  ${i}  IN RANGE  0  10
      exit for loop if  '${new_value}'!='00'
      run keyword  Generate Number
    END
    [Return]  ${new_value}

Generate Number
    ${new_value}=  Generate Random String  length=2  chars=[NUMBERS]
    [Return]  ${new_value}

Change Value of Checkbox
    [Arguments]  ${field}
    ${original_value}=  Get Checkbox Value  ${field}
    ${the_test}=  Check Test Name  ${TEST_NAME}
    ${is_allowed}=  get from list  ${the_test}  1
    IF  '${is_allowed}'=='Allowed'
        ${desired_value}=  set variable  Y
    ELSE
        ${desired_value}=  set variable  N
    END
    ${new_value}=  Change Checkbox  ${original_value}  ${desired_value}  ${field}
    ${list_of_values}=  create list  ${original_value}  ${new_value}
    [Return]  ${list_of_values}

Validate Checkbox Changes and Restore Default
    [Arguments]  ${field}  ${column}  ${list_of_values}
    ${original_value}=  get from list  ${list_of_values}  0
    ${current_value}=  get from list  ${list_of_values}  1
    Validate Checkboxes in DB  ${contractID}  reg_check_flag  ${original_value}
    Select Fees Panel and Contract Tab
    Change Checkbox  ${current_value}  ${original_value}  ${field}

Wait Until the Changes are Saved
    [Arguments]  ${timeout}=60  ${msg}=Processing did not complete within ${timeout} sec
    run keyword and ignore error  wait until element is visible    //*[text()="Please wait while the changes are saved..."]  error="Please wait while the changes are saved..."
    run keyword and ignore error  wait until element is not visible  //*[text()="Please wait while the changes are saved..."]  ${timeout}  ${msg}