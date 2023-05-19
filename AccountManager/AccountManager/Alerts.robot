*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ssh.PySSH
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM  refactor

*** Variables ***

*** Test Cases ***
Alerts - Adding an Alert With No Expiration Date
    [Tags]  qTest:30858892  Tier:0
    ${member_id}  Get Carrier
    Setup An Alert

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search a carrier in Account Manager  EFS  ${member_id}
    Select Alerts Sub Tab
    Add An Alert  ALERT_${Alert}
    Check The Alert Was Created  ALERT_${Alert}
    Delete created Alert  ${member_id}  ALERT_${Alert}

    [Teardown]  Close Browser


Alerts - Adding an Alert Without Alert Message (Mandatory Fields Validation)
    [Tags]  Tier:0

    ${member_id}  Get Carrier

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search a carrier in Account Manager  EFS  ${member_id}
    Select Alerts Sub Tab
    Add An Alert  ${EMPTY}
    Mandatory Field Alert Validation

    [Teardown]  Close Browser


*** Keywords ***

Navigate To Account Manager
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Get Carrier
    Get Into DB  TCH
    ${member_id}  Query And Strip  SELECT member_id FROM member WHERE mem_type = 'C' AND status='A' LIMIT 1;
    Set Suite Variable  ${member_id}
    [Return]  ${member_id}

Search a carrier in Account Manager
    [Arguments]  ${BusinessPartner}  ${Customer}
    ${current}=  get location
    ${goback}=  evaluate  '/acct-mgmt/RecordSearch.action' not in '${current}'
    run keyword if  ${goback}  Go Back To Record Search
    ${stat}=  run keyword and return status  alert should be present
    run keyword if  ${stat}  run keyword and ignore error  handle alert
    ##click on  text=Customers
    click on  xpath=//span[text()="Customers"]
    wait until element is visible  businessPartnerCode
    select from list by value  businessPartnerCode  ${BusinessPartner}
    input text  id  ${Customer}
    double click on  xpath= //*[@id="customerSearchContainer"]/div[1]/button[1]  ##exactMatch=False
    wait until element is visible   //button[text()="${Customer}"]
    sleep  1
    double click on  xpath=//button[text()="${Customer}"]
    wait until element is visible  xpath=//span[text()="Detail"]
    double click on  xpath=//span[text()="Detail"]
    wait until element is visible  //td[text()="${Customer}"]  timeout=60  error=Customer Did not load within 60 seconds

Select Alerts Sub Tab
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Check Element Exists  //*[@id="Alert"]  timeout=30
    ##Click On  text=Alert
    Click On  xpath=//span[text()="Alert"]

Setup An Alert
    ${alert}  Generate Random String  5  [LETTERS]
    ${alert}  String.Convert To Upper Case  ${alert}
    Set Suite Variable  ${alert}

Add An Alert
    [Arguments]  ${alert}


    Wait Until Page Contains  text=ADD
    Sleep  1
    Click On  xpath=//span[text()="ADD"]
    Input Text  //*[@name="customerDetail.alert"]  ${alert}
    Click Button  //*[@id="customerAlertAddFormButtons"]//*[@id="submit"]

Check The Alert Was Created
    [Arguments]  ${alert}

     Sleep  1
     Page Should Contain  text=${alert}

     Get Into DB  TCH
     Row Count Is Equal To X  SELECT * FROM alert WHERE carrier_id = ${member_id} AND alert='${alert}'  1


Mandatory Field Alert Validation
    Page Should Contain  text=Alert is required

Delete created Alert
    [Arguments]  ${member_id}  ${alert}
    Get Into DB  TCH
    Execute SQL String  dml=DELETE FROM alert WHERE carrier_id = ${member_id} AND alert='${alert}'
