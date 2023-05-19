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
Documentation  Updates the autobump portion of the fees panel on the credit manager page in DIT and ACPT. Won't run in SIT and STG due to missing data and access issues [STG]

Suite Teardown  close all browsers
Suite Setup  Login
Test Setup  Get Contract and Select Panel
Test Teardown  Return to Portal Home

*** Variables ***

#TODO when dynamic contract and carrier are implemented testcases may need to be reworked
*** Test Cases ***
Auto Bump Fee Type LIN2 :Valid
    [Tags]  JIRA:PORT-386  qTest:46818524
    [Documentation]  Selects LIN2 and a Threshold type, enters Amount and Threshold, saves and restores.
    ${values}=  Adjust Values  feeType  LIN2  thresholdType  P
    Save
    Verify Change and Restore Default  feeType  fee_type  ${values}
    Save

Auto Bump Fee Type LINC :Valid
    [Tags]  JIRA:PORT-386  qTest:46818527
    [Documentation]  Selects LINC and a Threshold type, enters Amount and Threshold, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  P
    Save
    Verify Change and Restore Default  feeType  fee_type  ${values}
    Save

Changing the Adjust amount Auto Bump :Valid
    [Tags]  JIRA:PORT-386  qTest:46818492
    [Documentation]  Selects specified Types, enters Amount and Threshold, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  P
    Save
    Verify Change and Restore Default  feeType  adjust_amt  ${values}
    Save

Changing the Amount Auto Bump Contract :Accepted
    [Tags]  JIRA:PORT-386  qTest:46818492
    [Documentation]  Enters Amount with Accepted input; valid Threshold, selects Types, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  P
    Save
    Verify Change and Restore Default  adjustAmt  adjust_amt  ${values}
    Save

Auto Bump Threshold Type Percent :Valid
    [Tags]  JIRA:PORT-386  qTest:46818495
    [Documentation]  Selects the Percent from Threshold Type, selects other type, enters Amount and Threshold, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  P
    Save
    Verify Change and Restore Default  thresholdType  threshold_type  ${values}
    Save

Auto Bump Threshold Type Dollar :Valid
    [Tags]  JIRA:PORT-386  qTest:46818497
    [Documentation]  Selects the Dollar from Threshold Type, selects other type, enters Amount and Threshold, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  D
    Save
    Verify Change and Restore Default  thresholdType  threshold_type  ${values}
    Save

Changing the Threshold Auto Bump Contract :Valid
    [Tags]  JIRA:PORT-386  qTest:46818500
    [Documentation]  Enters Threshold and Amount, selects Types, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  P
    Save
    Verify Change and Restore Default  threshold  threshold  ${values}
    Save

Changing the Threshold Auto Bump Contract :Accepted
    [Tags]  JIRA:PORT-386  qTest:46818500
    [Documentation]  Enters Threshold with Accepted input; valid Amount, selects Types, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  P
    Save
    Verify Change and Restore Default  threshold  threshold  ${values}
    Save

Change the Threshold Auto Bump Contract Percentage :Invalid
    [Tags]  JIRA:PORT-417  qTest:47334838
    [Documentation]  Enters Threshold with invalid input; valid Amount, selects Types, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  P
    Save
    Verify Change and Restore Default  threshold  threshold  ${values}
    Save

Change the Amount Auto Bump Contract :Invalid
    [Tags]  JIRA:PORT-417  qTest:47334839
    [Documentation]  Enters Amount with Invalid input; valid Threshold, selects Types, saves and restores.
    ${values}=  Adjust Values  feeType  LINC  thresholdType  D
    Save
    Verify Change and Restore Default  adjustAmt  adjust_amt  ${values}
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
    input text  request.search.contractId  ${contractID}  clear=True
    wait until element is enabled  request.search.carrierId  timeout=120
    input text  request.search.carrierId  ${carrierID}  clear=True
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

Get Value From Drop Down
    [Arguments]  ${dropdown}
    ${val}=  get value  request.contractFees.${dropdown}
    set variable if  '${val}' == '${None}'  ${val}=0
    [Return]  ${val}

Select From Drop Down
    [Arguments]  ${dropdown}  ${desired_value}
    ${original_dropdown}=  get value  request.contractFees.${dropdown}
    wait until element is enabled  request.contractFees.${dropdown}  timeout=60
    select from list by value  request.contractFees.${dropdown}  ${desired_value}
    [Return]  ${original_dropdown}

Adjust Threshold Valid
    [Arguments]  ${value}=0  ${option}=Percent
    ${original_val}=  get value  request.contractFees.threshold
    ${new_value}=  set variable  ${original_val}
    IF  '${option}' == 'Percent' and '${original_val}' >= '100'
        ${new_value}=  evaluate  ${new_value} - ${original_val}
    ELSE IF  '${option}' == 'Dollar' and '${original_val}' >= '100'
        ${new_value}  evaluate  ${new_value} - 1
    ELSE IF  '${option}' == 'Percent' and '${original_val}' < '100'
        ${new_value}  evaluate  ${new_value} + .10
    ELSE IF  '${option}' == 'Dollar' and '${original_val}' > '100'
        ${new_value}  evaluate  ${new_value} - 1
    ELSE IF  '${option}' == 'Dollar' and '${original_val}' < '100'
        ${new_value}  evaluate  ${new_value} + 1
    ELSE
        log to console  ${new_value}
    END
    clear element text  request.contractFees.threshold
    ${new_value_str}=  evaluate  str(${new_value})
    input text  request.contractFees.threshold  ${new_value_str}
    [Return]  ${original_val}

Adjust Amount Valid
    [Arguments]  ${value}=4.20
    ${original_val}=  get value  request.contractFees.adjustAmt
    ${new_value}=  set variable  ${original_val}
    IF  '${new_value}'>'500'
        ${new_value}=  evaluate  ${new_value} - 1
    ELSE IF  '${new_value}'<'500'
        ${new_value}  evaluate  ${new_value} + 1
    ELSE
        log to console  ${new_value}
    END
    clear element text  request.contractFees.adjustAmt
    ${new_value_str}=  evaluate  str(${new_value})
    input text  request.contractFees.adjustAmt  ${new_value_str}
    [Return]  ${original_val}

Adjust Threshold Accepted
    ${original_val}=  get value  request.contractFees.threshold
    ${letters}=  Generate Random String  length=6  chars=[LETTERS]  #was 26
    ${special_chars}=  set variable  />:!@#$%^&*()_-=+"
    ${new_value}=  Generate Random String  length=2  chars=[NUMBERS]
    ${value_str}=  strip my string  ${new_value}  left  0
    clear element text  request.contractFees.threshold
    input text  request.contractFees.threshold  ${letters}${special_chars}.${value_str}
    [Return]  ${original_val}

Adjust Amount Accepted
    ${original_val}=  get value  request.contractFees.adjustAmt
    ${letters}=  Generate Random String  length=6  chars=[LETTERS]
    ${special_chars}=  set variable  />:!@#$%^&*()_-=+"
    ${new_value}=  Generate Random String  length=2  chars=[NUMBERS]
    ${value_str}=  strip my string  ${new_value}  left  0
    clear element text  request.contractFees.adjustAmt
    input text  request.contractFees.adjustAmt  ${letters}${special_chars}.${value_str}
    [Return]  ${original_val}

Adjust Threshold Invalid
    ${original_val}=  get value  request.contractFees.threshold
    ${new_value}=  Generate Random String  length=5  chars=[NUMBERS]
    ${value_str}=  strip my string  ${new_value}  left  0
    clear element text  request.contractFees.threshold
    input text  request.contractFees.threshold  ${value_str}
    [Return]  ${original_val}

Adjust Amount Invalid
    ${original_val}=  get value  request.contractFees.adjustAmt
    ${new_value}=  Generate Random String  length=26  chars=[NUMBERS]
    ${value_str}=  strip my string  ${new_value}  left  0
    clear element text  request.contractFees.adjustAmt
    input text  request.contractFees.adjustAmt  ${value_str}
    [Return]  ${original_val}

Verify Type Change
    [Arguments]  ${original_value}  ${current_value}
    IF  """${original_value}""" == """${current_value}"""
        should be equal  ${original_value}  ${current_value}
    ELSE
        should not be equal  ${original_value}  ${current_value}
    END

Verify Amount Change
    [Arguments]  ${original_value}  ${current_value}
    IF  '${original_value}'=='${current_value}'
        should be equal  ${original_value}  ${current_value}
    ELSE
        should not be equal  ${original_value}  ${current_value}
    END

Restore Default
    [Arguments]  ${og_feetype}  ${og_thresholdtype}  ${feetype_type}  ${threshold_type}
    ${og_feetype}=  convert to string  ${og_feetype}
    ${og_threshold_type}=  convert to string  ${og_threshold_type}
    wait until element is enabled  request.contractFees.feeType  timeout=60
    IF  '${og_feetype}' == 'LINC' or '${og_feetype}' == 'LIN2'
        select from list by value  request.contractFees.feeType  ${og_feetype}
    ELSE
        select from list by index  request.contractFees.feeType  0
    END
    wait until element is enabled  request.contractFees.thresholdType  timeout=60
    IF  '${og_thresholdtype}' == 'P' or '${og_thresholdtype}' == 'D'
        select from list by value  request.contractFees.thresholdType  ${og_thresholdtype}
    ELSE
        select from list by index  request.contractFees.thresholdType  0
    END
    wait until element is enabled  request.contractFees.adjustAmt  timeout=60
    clear element text  request.contractFees.adjustAmt
    input text  request.contractFees.adjustAmt  ${feetype_type}  clear=True
    wait until element is enabled  request.contractFees.threshold  timeout=60
    clear element text  request.contractFees.threshold
    input text  request.contractFees.threshold  ${threshold_type}  clear=True

Validate AutoBump in DB
    [Arguments]  ${contractID}  ${field}  ${original_value}
    get into db  TCH
    ${query}=  catenate  SELECT ${field}
    ...  FROM contract_fee
    ...  WHERE contract_id=${contractID}
    ${db_value}=  query and strip  ${query}
    IF  """${original_value}""" == 'P' and '${db_value}' == 'P'
        should be equal  """${original_value}"""  ${db_value}
    ELSE IF  """${original_value}""" == 'D' and '${db_value}' == 'D'
        should be equal  """${original_value}"""  ${db_value}
    ELSE IF  """${original_value}""" == 'LINC' and '${db_value}' == 'LINC'
        should be equal  """${original_value}"""  ${db_value}
    ELSE IF  """${original_value}""" == 'LIN2' and '${db_value}' == 'LIN2'
        should be equal  """${original_value}"""  ${db_value}
    ELSE IF  """${original_value}""" == '${EMPTY}' and '${db_value}' == '${EMPTY}'
        should be equal  """${original_value}"""  ${db_value}
    ELSE
        should not be equal  """${original_value}"""  ${db_value}
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


Adjust Values
    [Arguments]  ${field1}  ${value1}  ${field2}  ${value2}
    ${the_test}=  Check Test Name  ${TEST_NAME}
    ${is_accepted}=  get from list  ${the_test}  1
    ${test_type}=  get from list  ${the_test}  0
    ${contains_threshold}=  evaluate  "Threshold" in """${test_type}"""
    ${contains_amount}=  evaluate  "Amount" in """${test_type}"""
    ${list_of_values}  Create List
    IF  '${is_accepted}' == 'Valid'
        ${list_of_values}  Change Valid Test Values  ${field1}  ${value1}  ${field2}  ${value2}
    ELSE IF  '${is_accepted}' == 'Accepted' and '${contains_threshold}' == '${True}'
        ${list_of_values}  Change Accepted Test Values  ${field1}  ${value1}  ${field2}  ${value2}  T
    ELSE IF  '${is_accepted}' == 'Accepted' and '${contains_amount}' == '${True}'
        ${list_of_values}  Change Accepted Test Values  ${field1}  ${value1}  ${field2}  ${value2}  A
    ELSE IF  '${is_accepted}' == 'Invalid' and '${contains_threshold}' == '${True}'
        ${list_of_values}  Change Invalid Test Values  ${field1}  ${value1}  ${field2}  ${value2}  T
    ELSE IF  '${is_accepted}' == 'Invalid' and '${contains_amount}' == '${True}'
        ${list_of_values}  Change Invalid Test Values  ${field1}  ${value1}  ${field2}  ${value2}  A
    ELSE
        log to console  ${list_of_values}
    END
    [Return]  ${list_of_values}

Check Test Name
    [Arguments]  ${TEST NAME}
    ${type_list}=  String.split string from right  ${TEST NAME}  :
    [Return]  ${type_list}

Change Valid Test Values
    [Arguments]  ${field1}  ${value1}  ${field2}  ${value2}
    ${val_1}=  Select From Drop Down  ${field1}  ${value1}
    ${val_2}=  Select From Drop Down  ${field2}  ${value2}
    ${og_amount}=  Adjust Amount Valid
    ${og_thresh}=  Adjust Threshold Valid
    ${list_values}  create list  ${val_1}  ${val_2}  ${og_amount}  ${og_thresh}
    [Return]  ${list_values}

Change Accepted Test Values
    [Arguments]  ${field1}  ${value1}  ${field2}  ${value2}  ${optional}
    ${val_1}=  Select From Drop Down  ${field1}  ${value1}  #amount
    ${val_2}=  Select From Drop Down  ${field2}  ${value2}  #threshold
    ${list_of_values}  create list
    IF  '${optional}'=='A'
        ${list_of_values}  Change Accepted Amount
    ELSE IF  '${optional}'=='T'
        ${list_of_values}  Change Accepted Threshold
    ELSE
        log to console  ${list_of_values}
    END
    insert into list  ${list_of_values}  0  ${val_1}
    insert into list  ${list_of_values}  1  ${val_2}
    [Return]  ${list_of_values}

Change Invalid Test Values
    [Arguments]  ${field1}  ${value1}  ${field2}  ${value2}  ${optional}
    ${val_1}=  Select From Drop Down  ${field1}  ${value1}  #amount
    ${val_2}=  Select From Drop Down  ${field2}  ${value2}  #threshold
    ${list_of_values}  create list
    IF  '${optional}'=='A'
        ${list_of_values}  Change Invalid Amount
    ELSE IF  '${optional}'=='T'
        ${list_of_values}  Change Invalid Threshold
    ELSE
        log to console  ${list_of_values}
    END
    insert into list  ${list_of_values}  0  ${val_1}
    insert into list  ${list_of_values}  1  ${val_2}
    [Return]  ${list_of_values}

Change Accepted Amount
    ${og_amount}=  Adjust Amount Accepted
    ${og_threshold}=  Adjust Threshold Valid
    ${list_accepted_amount}=  create list  ${og_amount}  ${og_threshold}
    [Return]  ${list_accepted_amount}

Change Accepted Threshold
    ${og_amount}=  Adjust Amount Valid
    ${og_threshold}=  Adjust Threshold Accepted
    ${list_accepted_threshold}=  create list  ${og_amount}  ${og_threshold}
    [Return]  ${list_accepted_threshold}

Change Invalid Amount
    ${og_amount}=  Adjust Amount Invalid
    ${og_threshold}=  Adjust Threshold Valid
    ${list_invalid_amount}=  create list  ${og_amount}  ${og_threshold}
    [Return]  ${list_invalid_amount}

Change Invalid Threshold
    ${og_amount}=  Adjust Amount Valid
    ${og_threshold}=  Adjust Threshold Invalid
    ${list_invalid_threshold}=  create list  ${og_amount}  ${og_threshold}
    [Return]  ${list_invalid_threshold}

Verify Change and Restore Default
    [Arguments]  ${field}  ${column}  ${values}
    wait until element is enabled  request.contractFees.${field}  timeout=60
    wait until the changes are saved
    ${test_name}=  check test name  ${TEST NAME}
    ${is_valid}=  get from list  ${test_name}  1
    ${current_value}=  get value  request.contractFees.${field}
    ${original_feetype}=  get from list  ${values}  0
    ${original_thresholdtype}=  get from list  ${values}  1
    ${original_amount}=  get from list  ${values}  2
    ${original_threshold}=  get from list  ${values}  3
    ${original_value}=  set variable if  '${field}'=='feeType'  '${original_feetype}'
    ...  '${field}'=='thresholdType'  '${original_thresholdtype}'
    ...  '${field}'=='adjustAmt'  '${original_amount}'
    ...  '${field}'=='threshold'  '${original_threshold}'
    Verify Type Change  ${original_value}  ${current_value}
    IF  '${is_valid}'!='Invalid'
        Validate AutoBump in DB  ${contractID}  ${column}  ${original_value}
    ELSE
        Validate AutoBump Invalid in DB  ${contractID}  ${column}  ${original_value}
    END
    Select Fees Panel and Contract Tab
    Restore Default  ${original_feetype}  ${original_thresholdtype}  ${original_amount}  ${original_threshold}

Validate AutoBump Invalid in DB
    [Arguments]  ${contractID}  ${column}  ${original_value}
    get into db  TCH
    ${query}=  catenate  SELECT ${column}
    ...  FROM contract_fee
    ...  WHERE contract_id=${contractID}
    ${db_value}=  query and strip  ${query}
    should not be equal  """${original_value}"""  ${db_value}

Wait Until the Changes are Saved
    [Arguments]  ${timeout}=60  ${msg}=Processing did not complete within ${timeout} sec
    run keyword and ignore error  wait until element is visible    //*[text()="Please wait while the changes are saved..."]  error="Please wait while the changes are saved..."
    run keyword and ignore error  wait until element is not visible  //*[text()="Please wait while the changes are saved..."]  ${timeout}  ${msg}