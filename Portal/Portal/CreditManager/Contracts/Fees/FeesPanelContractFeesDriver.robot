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

Suite Setup  Setup
Suite Teardown  Close All Browsers
Force Tags  Portal  Credit Manager
Documentation  Updates the driver values of fees panel on the credit manager page

*** Variables ***
@{valid_values}  6.65  2  3.98  45.55  2  2  2  1  4  Y
@{invalid_values}  -100.123  32515.2125  -952.2414785  5151.5151512  0.0000111

*** Test Cases ***
Driver Inputs Should Accept Proper Values
    [Tags]  JIRA:PORT-388  qTest:
    [Documentation]  Check if the boxes accepts valid values
    [Setup]  Open Fees Tab and Driver Option
    Fill Driver Info With Valid Values

Driver Values Should Be Saved On Database
    [Tags]  JIRA:PORT-388  qTest:
    [Documentation]  Check if the boxes values are saved on database
    Save Driver Values
    Validate Data Saved On Database

Driver Inputs Should Not Accept Incorrect Values
    [Tags]  JIRA:PORT-388  qTest:
    [Documentation]  Check if the boxes accepts invalid values
    [Setup]  Open Fees Tab and Driver Option
    Fill Driver Info With Invalid Values
    Save Driver Values
    Validate Invalid Data

*** Keywords ***
Setup
    Open Browser to portal
    Log Into Portal
    Get Valid Contract  ${ENVIRONMENT}
    Select Portal Program  Credit Manager
    Search Contract  ${contractID}  ${carrierID}
    Select Contract

Open Fees Tab and Driver Option
    Wait Until Page Contains Element  //*[@name="request.contract.stmtCustomerName"]  timeout=60
    Click Element  //*[@class="jimg jfeesetup"]
    Click Element  //*[@id='fees']//descendant::*[contains(text(),'Driver')]

Get Valid Contract
    [Arguments]  ${database}
    pyString.Convert To Lowercase  ${database}
    ${contractID}=  Set Variable If  '${database}'=='acpt' or '${database}'=='dit'  19169
    ${carrierID}=  Set Variable If  '${database}'=='acpt' or '${database}'=='dit'  122033
    ...  ELSE  log to console  ${database}
    Set Suite Variable  ${contractID}  ${contractID}
    Set Suite Variable  ${carrierID}  ${carrierID}

Search Contract
    [Arguments]  ${contractID}  ${carrierID}
    Wait Until Element Is Enabled  request.search.contractId  timeout=60
    Send Text To Element  request.search.contractId  ${contractID}
    Wait Until Element Is Enabled  request.search.carrierId  timeout=60
    Send Text To Element  request.search.carrierId  ${carrierID}
    Click Portal Button  Search

Select Contract
    Wait Until Done Processing
    Wait Until Element Is Enabled  xpath://*[@id="resultsTable"]  timeout=120
    Double Click Element  xpath://*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table

Fill Driver Info With Valid Values
    :FOR  ${i}  IN RANGE  2
    \  Input Text  request.fees[${i}].feeAmt  ${valid_values[0]}
    \  Select From List By Value  request.fees[${i}].feeType  ${valid_values[1]}
    \  Input Text  request.fees[${i}].feeMinAmt  ${valid_values[2]}
    \  Input Text  request.fees[${i}].feeMaxAmt  ${valid_values[3]}
    \  Select From List By Value  request.fees[${i}].feeLevel  ${valid_values[4]}
    \  Input Text  request.fees[${i}].feeMaxTimes  ${valid_values[5]}
    \  Select From List By Value  request.fees[${i}].feeMaxTimesPer  ${valid_values[6]}
    \  Input Text  request.fees[${i}].feeMinStart  ${valid_values[7]}
    \  Select From List By Value  request.fees[${i}].feeMinStartPer  ${valid_values[8]}
    \  Select Checkbox  __request.fees[${i}].excludeFreeUse

Fill Driver Info With Invalid Values
    :FOR  ${i}  IN RANGE  2
    \  Input Text  request.fees[${i}].feeAmt  ${invalid_values[0]}
    \  Input Text  request.fees[${i}].feeMinAmt  ${invalid_values[1]}
    \  Input Text  request.fees[${i}].feeMaxAmt  ${invalid_values[2]}
    \  Input Text  request.fees[${i}].feeMaxTimes  ${invalid_values[3]}
    \  Input Text  request.fees[${i}].feeMinStart  ${invalid_values[4]}

Get Info From Database
    Get Into Db  TCH
    ${query}=  Catenate  SELECT * FROM driver_fees WHERE contract_id=${contractID}
    ${db_value}=  Query and Strip to Dictionary  ${query}
    [Return]  ${db_value}

Validate Data Saved On Database
    ${driver_values}=  Get Info From Database
    :FOR  ${i}  IN RANGE  2
    \  Should Be Equal As Numbers  ${driver_values.fee_amt}[${i}]  ${valid_values[0]}
    \  Should Be Equal As Integers  ${driver_values.fee_type}[${i}]  ${valid_values[1]}
    \  Should Be Equal As Numbers  ${driver_values.fee_min_amt}[${i}]  ${valid_values[2]}
    \  Should Be Equal As Numbers  ${driver_values.fee_max_amt}[${i}]  ${valid_values[3]}
    \  Should Be Equal As Integers  ${driver_values.fee_level}[${i}]  ${valid_values[4]}
    \  Should Be Equal As Integers  ${driver_values.fee_max_times}[${i}]  ${valid_values[5]}
    \  Should Be Equal As Integers  ${driver_values.fee_max_times_per}[${i}]  ${valid_values[6]}
    \  Should Be Equal As Integers  ${driver_values.fee_min_start}[${i}]  ${valid_values[7]}
    \  Should Be Equal As Integers  ${driver_values.fee_min_start_per}[${i}]  ${valid_values[8]}
    \  Should Be Equal As Strings  ${driver_values.exclude_free_use}[${i}]  ${valid_values[9]}

Validate Invalid Data
    Open Fees Tab and Driver Option
    :FOR  ${i}  IN RANGE  2
    \  ${fee_amt}  Get Value  request.fees[${i}].feeAmt
    \  ${fee_min_amt}  Get Value  request.fees[${i}].feeMinAmt
    \  ${fee_max_amt}  Get Value  request.fees[${i}].feeMaxAmt
    \  ${fee_max_times}  Get Value  request.fees[${i}].feeMaxTimes
    \  ${fee_min_start}  Get Value  request.fees[${i}].feeMinStart
    \  Should Be Equal As Numbers  ${fee_amt}  100.123
    \  Should Be Equal As Numbers  ${fee_min_amt}  32515.21
    \  Should Be Equal As Numbers  ${fee_max_amt}  952.24
    \  Should Be Equal As Integers  ${fee_max_times}  0
    \  Should Be Equal As Integers  ${fee_min_start}  111

Save Driver Values
    Click Element  //*[@id="contractview"]//descendant::*[@class="jimg jsave"]
    Sleep  7
    Close Alert

Close Alert
    Wait Until Page Contains Element  //*[@id="alert_content"]//descendant::*[@class="jimg jok"]  timeout=10
    Click Element  //*[@id="alert_content"]//descendant::*[@class="jimg jok"]