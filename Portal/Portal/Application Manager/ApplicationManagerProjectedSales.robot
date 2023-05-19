*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Setup
Suite Teardown  Run Keywords  Remove Application After Tests
...                           Close All Browsers
Force Tags  Portal  Application Manager  Regression
Documentation  This is to test if a user can add amounts to each of the projected sales input boxes, the inputs are
...  saved in the database, and that the "Total Projected" box is a sum of all the "Projected Revenue" amount boxes.

*** Variables ***
@{boxes}  atmLimit  fuelAndCash  fuelTax  moneyCodes  mcFleet  mcMulti  ofm  scales  secureFuel  smartData  smartFunds
...  zcon  integerMarketingFee  wrkflwCardFee  retailFuel  retailMaint  retailOther  factoring  hotels  tires
...  tollServiceFee  tolls
${wrkflw_id}
${application_id}

*** Test Cases ***
ATM Limit Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the ATM Limit input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  atmLimit  1
    Verify Input Saves To The Database  atm_limit  1

Fuel and Cash Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Fuel and Cash input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  fuelAndCash  2
    Verify Input Saves To The Database  fuel_and_cash  2

Fuel Tax Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Fuel Tax input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  fuelTax  3
    Verify Input Saves To The Database  fuel_tax  3

Money Codes Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Money Codes input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  moneyCodes  4
    Verify Input Saves To The Database  money_codes  4

MC Fleet Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the MC Fleet input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  mcFleet  5
    Verify Input Saves To The Database  mc_fleet  5

MC Multi Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the MC Multi input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  mcMulti  6
    Verify Input Saves To The Database  mc_multi  6

OFM Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the OFM input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  ofm  7
    Verify Input Saves To The Database  ofm  7

Scales Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Scales Box input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  scales  8
    Verify Input Saves To The Database  scales  8

Secure Fuel Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Secure Fuel input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  secureFuel  9
    Verify Input Saves To The Database  secure_fuel  9

Smart Data Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Smart Data input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  smartData  10
    Verify Input Saves To The Database  smart_data  10

Smart Funds Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Smart Funds input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  smartFunds  11
    Verify Input Saves To The Database  smart_funds  11

Z-Con Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Z-Con input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  zcon  12
    Verify Input Saves To The Database  zcon  12

Merketing Fee Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Merketing Fee input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  integerMarketingFee  13
    Verify Input Saves To The Database  integer_marketing_fee  13

Card Fee Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Card Fee input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  wrkflwCardFee  14
    Verify Input Saves To The Database  wrkflw_card_fee  14

Retail Fuel Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Retail Fuel input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  retailFuel  15
    Verify Input Saves To The Database  retail_fuel  15

Retail Maintenance Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Retail Maint input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  retailMaint  16
    Verify Input Saves To The Database  retail_maintenance  16

Retail Other Box testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Retail Other input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  retailOther  17
    Verify Input Saves To The Database  retail_other  17

Factoring Box testing
    [Tags]  JIRA:PORT-415  JIRA:PORT-393  qTest:47279540  Regression
    [Documentation]  This is to test if a user can input a whole number in the Factoring input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  factoring  18
    Verify Input Saves To The Database  factoring  18

Hotels Box testing
    [Tags]  JIRA:PORT-415  JIRA:PORT-393  qTest:47279541  Regression
    [Documentation]  This is to test if a user can input a whole number in the Hotels input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  hotels  19
    Verify Input Saves To The Database  hotels  19

Tires Box testing
    [Tags]  JIRA:PORT-415  JIRA:PORT-393  qTest:47279539  Regression
    [Documentation]  This is to test if a user can input a whole number in the Tires input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  tires  20
    Verify Input Saves To The Database  tires  20

Toll Service Fee Box testing
    [Tags]  JIRA:PORT-415  JIRA:PORT-393  qTest:47279542  Regression
    [Documentation]  This is to test if a user can input a whole number in the Toll Service Fee input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  tollServiceFee  21
    Verify Input Saves To The Database  toll_service_fee  21

Tolls Box testing
    [Tags]  JIRA:PORT-415  JIRA:PORT-393  qTest:47279543  Regression
    [Documentation]  This is to test if a user can input a whole number in the Tolls input box
    [Setup]  Clear Input Boxes
    Checkbox Should Be Selected  __stayOpen
    Verify Box Accepts Inputs  tolls  22
    Verify Input Saves To The Database  tolls  22

Total Projected Box testing
    [Tags]  JIRA:PORT-415  JIRA:PORT-393  qTest:44982312  Regression
    [Documentation]  This is to test if a user can input a whole number in the Total Projected input box
    [Setup]  Clear Input Boxes
    Close MSA Checklist
    Checkbox Should Be Selected  __stayOpen
    Fill All Fields And Save  10
    Verify Input Saves To The Database  total_revenue  220
    Close MSA Checklist
    Verify Total Projected Value

Special Characters Box Testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test a user can input a whole number with special characters in the input boxes
    [Setup]  Clear Input Boxes
    Check If The Box Is Filtering Characters  retailFuel  &%12**-+=/  12
    Check If The Box Is Filtering Characters  retailOther  %65*-)(=/  65
    Check If The Box Is Filtering Characters  retailMaint  **()*#$*116__-  116
    Check If The Box Is Filtering Characters  factoring  !@$#*%901#$$$@#  901
    Check If The Box Is Filtering Characters  hotels  ()()125$%%  125
    Check If The Box Is Filtering Characters  tires  219-*/*  219
    Check If The Box Is Filtering Characters  tollServiceFee  &%26**-+=/  26
    Check If The Box Is Filtering Characters  tolls  =+-&70(*&&##@$  70

Regular Characters Box Testing
    [Tags]  JIRA:PORT-327  qTest:44982312  Regression
    [Documentation]  This is to test a user can input a whole number with characters in the input boxes
    [Setup]  Clear Input Boxes
    Check If The Box Is Filtering Characters  retailOther  abcde345fgkl6  3456
    Check If The Box Is Filtering Characters  retailOther  knldnNAJND541LLL  541
    Check If The Box Is Filtering Characters  retailMaint  97MmadsADF  97
    Check If The Box Is Filtering Characters  factoring  87qwerty1  871
    Check If The Box Is Filtering Characters  hotels  isanewword111ofof  111
    Check If The Box Is Filtering Characters  tires  betwe455en  455
    Check If The Box Is Filtering Characters  tollServiceFee  vcsnv66  66
    Check If The Box Is Filtering Characters  tolls  0mafjdanJNDAS  0

*** Keywords ***
Verify Box Accepts Inputs
    [Arguments]  ${input_box}  ${input_amount}
    Input Text  ${input_box}  ${input_amount}
    Close MSA Checklist
    Click Element  xpath=//div[@id='saveButton']/a/div/span
    Wait Until Changes Are Saved
    Wait Until Done Processing
    Wait Until Page Does Not Contain Element  //*[text()="Please wait"]
    Sleep  5
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]

Fill All Fields And Save
    [Arguments]  ${value}
    FOR  ${box}  IN  @{boxes}
        Input Text  ${box}  ${value}
    END
    Click Element  xpath=//div[@id='saveButton']/a/div/span
    Wait Until Changes Are Saved
    Wait Until Done Processing
    Wait Until Page Does Not Contain Element  //*[text()="Please wait"]
    Sleep  5
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]

Verify Total Projected Value
    ${total_projected}=  Get Value  request.projectedRevenue.totalRevenue
    Should Be Equal As Numbers  ${total_projected}  220

Verify Input Saves To The Database
    [Arguments]  ${input_box}  ${input_amount}
    get into db  TCH
    ${query}  catenate  select ${input_box} FROM wrkflw_projected_revenue WHERE wrkflw_contract_id = ${wrkflw_id};
    ${db_amount}  Query And Strip  ${query}
    should be equal as numbers  ${db_amount}  ${input_amount}  We expected wrkflw_projected_revenue.${input_box} value
    ...  of ${db_amount} to equal ${input_amount}.

Clear Input Boxes
    FOR  ${box}  IN  @{boxes}
        Clear Element Text  ${box}
    END

Setup
    Open Browser And Login To Portal
    Select Portal Program  Application Manager
    Create Application
    Search For Application
    Open Contract

Open Browser And Login To Portal
    Open Browser to portal
    Log Into Portal

Create Application
    Click Portal Button  Add
    Wait Until Done Processing
    wait until element is enabled  //*[@id="compName"]  timeout=120
    Fill in Company Info
    Click Element  skipChk
    Click Portal Button  Save
    Wait Until Done Processing
    Wait Until Element Is Visible  //*[text()="Application ID:"]/parent::*/following-sibling::*[1]
    Scroll Element Into View  //*[text()="Application ID:"]/parent::*/following-sibling::*[1]
    ${application_id}=  Get Text  xpath=//div[contains(text(),"Application ID:")]/following-sibling::*[1]
    Set Suite Variable  ${application_id}
    Wait Until Element Is Visible  xpath=//span[contains(text(),"Contracts")]  timeout=30
    Click Element  xpath=//span[contains(text(),"Contracts")]
    Wait Until Element Is Visible  //*[@id="contractListDiv"]//descendant::*[@class="jimg jadd"]  timeout=120
    Click Element  //*[@id="contractListDiv"]//descendant::*[@class="jimg jadd"]
    Wait Until Done Processing
    Select From List By Label  request.contract.cardType  TCH Fleet Fuel
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]
    Close MSA Checklist
    Click Element  xpath=//div[@id='saveButton']/a/div/span
    Wait Until Done Processing

Search For Application
    Click Element  //*[@id="pm_0"]
    Wait Until Element Is Visible  searchField
    Select From List By Label  searchField  Application ID*
    Input Text  searchValue  ${application_id}
    Click Portal Button  Search
    wait until done processing
    wait until element is enabled  //*[@id="resultsTable"]  timeout=120
    Page Should Contain Element  xpath=//*[@id="resultsTable"]//descendant::*[contains(text(),'Sales')]
    Wait Until Element Is Enabled  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]  timeout=30
    Double Click Element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]
    Wait Until Page Contains  text=Company Info & Sales  timeout=30

Open Contract
    Wait Until Element Is Visible  xpath=//*[@id="application"]//descendant::*[contains(text(),'Contracts')]  timeout=30
    Click Element  xpath=//*[@id="application"]//descendant::*[contains(text(),'Contracts')]
    Wait Until Element Is Visible  //*[@id="contractListDiv"]  timeout=30
    Page Should Contain Element  xpath=//*[@id="contractListDiv"]
    ${wrkflw_id}  Get Text  //*[@id="contractList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]/div
    Set Suite Variable  ${wrkflw_id}
    Double Click Element  //*[@id="contractList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]
    Wait Until Page Contains  text=Contract Detail & Sales  timeout=30
    Click Element  xpath=//span[contains(text(),'Projected Revenue')]

Delete Contract
    Wait Until Element Is Visible  xpath=//*[@id="application"]//descendant::*[contains(text(),'Contracts')]  timeout=30
    Click Element  xpath=//*[@id="application"]//descendant::*[contains(text(),'Contracts')]
    Wait Until Element Is Visible  //*[@id="contractListDiv"]  timeout=30
    Page Should Contain Element  xpath=//*[@id="contractListDiv"]
    Click Element  //*[@id="contractList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]
    Wait Until Element Is Visible  //*[@id="contractListDiv"]//descendant::*[@class="jimg jdelete"]  timeout=30
    Click Element  //*[@id="contractListDiv"]//descendant::*[@class="jimg jdelete"]
    Wait Until Element Is Visible  //*[@id="confirmDelete_content"]//descendant::*[@class="jimg jok"]  timeout=30
    Click Element  //*[@id="confirmDelete_content"]//descendant::*[@class="jimg jok"]
    Wait Until Page Contains  text=Company Info & Sales  timeout=30

Close MSA Checklist
    Scroll Element Into View  xpath=//div[@id='msacl']//descendant::*[@class="jimg jclose"]
    Run Keyword And Ignore Error  Click Element  xpath=//div[@id='msacl']//descendant::*[@class="jimg jclose"]

Remove Application After Tests
    Search For Application
    Delete Contract
    Click Element  //*[@id="contractListDiv"]//descendant::*[@class="jimg jprevious"]
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=30
    Page Should Contain Element  xpath=//*[@id="resultsTable"]//descendant::*[contains(text(),'Sales')]
    Click Portal Button  Delete
    wait until element is visible  xpath=//*[@id="delapp"]  timeout=30
    wait until element is enabled  xpath=//*[@id="delapp_content"]/div[2]/a[1]  timeout=30
    click element  //*[@id="delapp_content"]/div[2]/a[1]
    Wait Until Done Processing

Check If The Box Is Filtering Characters
    [Arguments]  ${box}  ${input_value}  ${expected_value}
    Input Text  ${box}  ${input_value}
    ${char_box}=  Get Value  ${box}
    Should Be Equal As Numbers  ${char_box}  ${expected_value}