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
Documentation  Updates the bank portion of the fees panel on the credit manager page in DIT and ACPT. Won't run in SIT and STG due to missing data and access issues [STG]

Suite Teardown  close all browsers
Suite Setup  Login
Test Setup  Get Contract and Select Panel
Test Teardown  Return to Portal Home

*** Variables ***

#TODO when dynamic contract and carrier are implemented testcases may need to be reworked
*** Test Cases ***
Minimum Bank Fee Change :Valid
    [Tags]  JIRA:PORT-386  qTest:46818516
    [Documentation]  Updates change in the Minimum Bank Fee field with valid input and changes back to original value
    ${original_value}=  Change Input  limitFee
    Save
    Verify Changes and Restore to Default  ${original_value}  limit_fee  limitFee
    Save

Minimum Bank Fee Change :Accepted
    [Tags]  JIRA:PORT-386  qTest:46818516
    [Documentation]  Updates change in the Minimum Bank Fee field with Accepted input and changes back to original value
    ${original_value}=  Change Input  limitFee
    Save
    Verify Changes and Restore to Default  ${original_value}  limit_fee  limitFee
    Save

Minimum Fee Amount Change :Invalid
    [Tags]  JIRA:PORT-417  qTest:47334840
    [Documentation]  Updates change in the Minimum Bank Fee field with Invalid input and changes back to original value
    ${original_value}=  Change Input  limitFee
    Save
    Verify Changes and Restore to Default  ${original_value}  limit_fee  limitFee
    Save

Minimum Bank Amount Change :Valid
    [Tags]  JIRA:PORT-386  qTest:46818520
    [Documentation]  Updates change in the Bank Amount field and changes back to original value
    ${original_value}=  Change Input  limitFeeAmt
    Save
    Verify Changes and Restore to Default  ${original_value}  limit_fee_amt  limitFeeAmt
    Save

Minimum Bank Amount Change :Accepted
    [Tags]  JIRA:PORT-386  qTest:46818520
    [Documentation]  Updates change in the Bank Amount field with Accepted input and changes back to original value
    ${original_value}=  Change Input  limitFeeAmt
    Save
    Verify Changes and Restore to Default  ${original_value}  limit_fee_amt  limitFeeAmt
    Save

Minimum Bank Amount Change :Invalid
    [Tags]  JIRA:PORT-417  qTest:47334841
    [Documentation]  Updates change in the Bank Amount field with Invalid input and changes back to original value
    ${original_value}=  Change Input  limitFeeAmt
    Save
    Verify Changes and Restore to Default  ${original_value}  limit_fee_amt  limitFeeAmt
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
    #TODO currently contractid and carrierid are static, need to change that and make them dynamic
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
    ${current_val}=  get value  request.contract.${field}
    clear element text  request.contract.${field}
    IF  '${current_val}'>'10'
        ${new_value}  evaluate  ${value} - 1
    ELSE
        ${new_value}  evaluate  ${value} + 1
    END
    ${new_value_str}=  evaluate  str(${new_value})
    IF  '${value}'=='${current_val}'
        input text  request.contract.${field}  ${new_value_str}
    ELSE
        input text  request.contract.${field}  ${value}
    END

Change Input Field Value Accepted
    [Arguments]  ${value}  ${field}
    wait until element is enabled  request.contract.${field}  timeout=60
    ${current_value}=  get value  request.contract.${field}
    ${letters}=  Generate Random String  length=5  chars=[LETTERS]
    ${special_chars}=  set variable  />:!@#$%^&*
    ${num_string}=  Generate Random String  length=2  chars=[NUMBERS]
    ${num_string}=  Check Random Number  ${num_string}
    strip my string  ${num_string}  left  0
    ${new_value}=  set variable  ${special_chars}${letters}.${num_string}
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
    [Arguments]  ${original_val}  ${field}
    wait until element is enabled  request.contract.${field}  timeout=60
    ${current_val}=  get value  request.contract.${field}
    should not be equal as strings  ${original_val}  ${current_val}

Verify Type Change
    [Arguments]  ${original_value}  ${current_value}
    IF  '${original_value}'=='${current_value}'
        should be equal as strings  ${original_value}  ${current_value}
    ELSE
        should not be equal as strings  ${original_value}  ${current_value}
    END

Validate Bank Fees in DB
    [Arguments]  ${contractID}  ${field}  ${original_value}
    get into db  TCH
    ${query}=  catenate  SELECT ${field}
    ...  FROM contract
    ...  WHERE contract_id=${contractID}
    ${db_value}=  query and strip  ${query}
    ${test_name}=  check test name  ${TEST NAME}
    ${test_type}=  get from list  ${test_name}  1
    IF  '${test_type}'=='Invalid'
        should be equal as strings  ${original_value}  ${db_value}
    ELSE
        should not be equal as strings  ${original_value}  ${db_value}
    END

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
        Fail  broke here ${TEST_NAME}
    END
    [Return]  ${original_value}

Verify Changes and Restore to Default
    [Arguments]  ${original_value}  ${column}  ${field}
    ${the_test}=  Check Test Name  ${TEST_NAME}
    ${test_type}=  get from list  ${the_test}  1
    wait until the changes are saved
    Verify Change on Page  ${original_value}  ${field}
    Validate Bank Fees in DB  ${contractID}  ${column}  ${original_value}
    Select Fees Panel and Contract Tab
    IF  '${test_type}'=='Valid'
        Change Input Field Value Valid  ${original_value}  ${field}
    ELSE IF  '${test_type}'=='Accepted'
        Change Input Field Value Accepted  ${original_value}  ${field}
    ELSE IF  '${test_type}'=='Invalid'
        Change Input Field Value Invalid  ${original_value}  ${field}
    ELSE
        log to console ${test_type}
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

Wait Until the Changes are Saved
    [Arguments]  ${timeout}=60  ${msg}=Processing did not complete within ${timeout} sec
    run keyword and ignore error  wait until element is visible    //*[text()="Please wait while the changes are saved..."]  error="Please wait while the changes are saved..."
    run keyword and ignore error  wait until element is not visible  //*[text()="Please wait while the changes are saved..."]  ${timeout}  ${msg}