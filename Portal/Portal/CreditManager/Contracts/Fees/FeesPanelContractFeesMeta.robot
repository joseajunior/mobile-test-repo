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

Suite Setup  Setup
Suite Teardown  Close All Browsers
Force Tags  Portal  Credit Manager
Documentation  Updates the meta values of fees panel on the credit manager page

*** Variables ***
@{valid_values}  6.65  2  3.98  45.55  26  802  2  154  49.50  10  54.54  12.15  65.87  0  78.50
@{invalid_values}  -100.123  32515.2125  -952.24185  5151.5151512  0.0000111  -654.652  1.111111  5.020  -85  321.314
...  45.252  -1.00001  78.223  -25252  989.991

*** Test Cases ***
Meta Inputs Should Accept Proper Values
    [Tags]  JIRA:PORT-387  qTest:
    [Documentation]  Check if the boxes accepts valid values
    [Setup]  Open Fees Tab and Meta Option
    Fill Meta Info With Valid Values

Meta Values Should Be Saved On Database
    [Tags]  JIRA:PORT-387  qTest:
    [Documentation]  Check if the boxes values are saved on database
    Save Meta Values
    Validate Data Saved On Database

Meta Inputs Should Not Accept Incorrect Values
    [Tags]  JIRA:PORT-387  qTest:
    [Documentation]  Check if the boxes accepts invalid values
    [Setup]  Open Fees Tab and Meta Option
    Fill Meta Info With Invalid Values
    Save Meta Values
    Validate Invalid Data

*** Keywords ***
Setup
    Open Browser to portal
    Log Into Portal
    Get Valid Contract  ${ENVIRONMENT}
    Select Portal Program  Credit Manager
    Search Contract  ${contractID}  ${carrierID}
    Select Contract

Open Fees Tab and Meta Option
    Wait Until Page Contains Element  //*[@name="request.contract.stmtCustomerName"]  timeout=60
    Click Element  //*[@class="jimg jfeesetup"]
    Click Element  //*[@id='fees']//descendant::*[contains(text(),'Meta')]

Get Valid Contract
    [Arguments]  ${database}
    ${carrier}  Find Carrier in Oracle  A
    ${query}=  catenate  select contract_id from contract where carrier_id = ${carrier}
    ${contract}=  query and strip  ${query}
    set suite variable  ${carrierID}  ${carrier}
    set suite variable  ${contractID}  ${contract}

Search Contract
    [Arguments]  ${contractID}  ${carrierID}
    Wait Until Element Is Enabled  request.search.contractId  timeout=60
    Input Text  request.search.contractId  ${contractID}
    Wait Until Element Is Enabled  request.search.carrierId  timeout=60
    Input Text  request.search.carrierId  ${carrierID}
    Click Portal Button  Search

Select Contract
    Wait Until Done Processing
    Wait Until Element Is Enabled  xpath://*[@id="resultsTable"]  timeout=120
    Double Click Element  xpath://*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table

Fill Meta Info With Valid Values
    FOR  ${i}  IN RANGE  15
      Input Text  request.meta[${i}].value  ${valid_values[${i}]}
      Select Checkbox  __request.meta[${i}].contractId
    END

Fill Meta Info With Invalid Values
    FOR  ${i}  IN RANGE  15
      Input Text  request.meta[${i}].value  ${invalid_values[${i}]}
    END

Get Info From Database
    Get Into Db  TCH
    ${query}=  Catenate  SELECT m.contract_id, m.contract_meta_id, t.contract_meta_type_id,
    ...  CASE WHEN m.contract_meta_id IS NOT NULL THEN m.value ELSE TRIM(TO_CHAR(w.fee_amount)) END AS value,
    ...  t.contract_meta_type_desc
    ...  FROM mc_wire_fees w JOIN contract_meta_type t ON t.contract_meta_type_code = w.other_fee_id
    ...  AND w.trans_code_type = 'B' LEFT OUTER JOIN contract_meta m ON m.contract_meta_type_id = t.contract_meta_type_id
    ...  AND m.contract_id = ${contractID} ORDER BY t.contract_meta_type_desc
    ${db_value}=  Query and Strip to Dictionary  ${query}
    [Return]  ${db_value}

Validate Data Saved On Database
    ${meta_values}=  Get Info From Database
    FOR  ${i}  IN RANGE  15
      Should Be Equal As Numbers  ${meta_values['value']}[${i}]  ${valid_values[${i}]}
    END

Validate Invalid Data
    Open Fees Tab and Meta Option
    FOR  ${i}  IN RANGE  15
      ${value}  Get Value  request.meta[${i}].value
      ${abs_value}  Evaluate  abs(${invalid_values[${i}]})
      ${abs_value}  Set Variable If  ${abs_value} > 1000  999.99  ${abs_value}
      ${expected_value}=   Evaluate  "%.2f" % ${abs_value}
      Should Be Equal As Numbers  ${value}  ${expected_value}
    END

Save Meta Values
    Click Element  //*[@id="contractview"]//descendant::*[@class="jimg jsave"]
    Sleep  7
    Close Alert

Close Alert
    Wait Until Page Contains Element  //*[@id="alert_content"]//descendant::*[@class="jimg jok"]  timeout=10
    Click Element  //*[@id="alert_content"]//descendant::*[@class="jimg jok"]