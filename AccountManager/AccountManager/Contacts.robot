*** Settings ***


Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.auth.PyAuth.AuthLog
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Variables ***

*** Test Cases ***
Contacts - Adding a Contact
    [Tags]  qTest:30858892  Tier:0  refactor
    [Setup]  Run Keywords  Get Carrier
    ...  AND  Setup Contact Information

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search a carrier in Account Manager  EFS  ${member_id}
    Select Contacts Sub Tab
    Add A Contact - First And Last Name  TIER0_${first_name}  TIER0_${last_name}
    Check The Recently Created Contact Is Dislpayed

    [Teardown]  Delete Recent Created Contact  ${member_id}  TIER0_${first_name}  TIER0_${last_name}



Contacts - Adding a contact (Mandatory Fields Validation)
    [Tags]  Tier:0  refactor
    [Setup]  Get Carrier

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search a carrier in Account Manager  EFS  ${member_id}
    Select Contacts Sub Tab
    Add A Contact - First And Last Name  ${EMPTY}  ${EMPTY}
    Contact Should Not Be Added

    [Teardown]  Close Browser


*** Keywords ***

Navigate To Account Manager
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Get Carrier
    Get Into DB  TCH
    ${member_id}  Query And Strip  SELECT member_id FROM member WHERE mem_type = 'C' AND status='A' LIMIT 1;
    Set Test Variable  ${member_id}

Search a carrier in Account Manager
    [Arguments]  ${BusinessPartner}  ${Customer}
    ${current}=  get location
    ${goback}=  evaluate  '/acct-mgmt/RecordSearch.action' not in '${current}'
    run keyword if  ${goback}  Go Back To Record Search
    ${stat}=  run keyword and return status  alert should be present
    run keyword if  ${stat}  run keyword and ignore error  handle alert
    click on  text=Customers
    wait until element is visible  businessPartnerCode
    select from list by value  businessPartnerCode  ${BusinessPartner}
    input text  id  ${Customer}
    double click on  text=Submit  exactMatch=False
    wait until element is visible   //button[text()="${Customer}"]
    sleep  1
    double click on  xpath=//button[text()="${Customer}"]
    wait until element is visible  xpath=//span[text()="Detail"]
    double click on  xpath=//span[text()="Detail"]
    wait until element is visible  //td[text()="${Customer}"]  timeout=60  error=Customer Did not load within 60 seconds

Select Contacts Sub Tab
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Check Element Exists  //*[@id="Contacts"]  timeout=30
    Click On  text=Contacts

Setup Contact Information
    ${first_name}  Generate Random String  5  [LETTERS]
    ${last_name}  Generate Random String  5  [LETTERS]
    ${first_name}  pyString.Convert To Uppercase  ${first_name}
    ${last_name}  pyString.Convert To Uppercase  ${last_name}

    Set Suite Variable  ${first_name}
    Set Suite Variable  ${last_name}

Add A Contact - First And Last Name
    [Arguments]  ${first_name}  ${last_name}

    Wait Until Page Contains  text=ADD
    Click On  //*[@id="customerContactsSearchContainer"]//span[text()="ADD"]/parent::*
    select From List By Value  //*[@name="contactDetail.type"]  CONTACT
    Input Text  //*[@name="contactDetail.firstName"]  ${first_name}
    Input Text  //*[@name="contactDetail.lastName"]  ${last_name}
    Click Button  //*[@id="contactAddUpdateFormButtons"]//*[@id="submit"]

Check The Recently Created Contact Is Dislpayed

    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Check Element Exists  text=TIER0_${first_name}
    Check Element Exists  text=TIER0_${last_name}

    Get Into DB  TCH
    Row Count Is Equal To X  SELECT * FROM contacts WHERE carrier_id=${member_id} AND type='CONTACT' AND fname='TIER0_${first_name}' AND lname='TIER0_${last_name}'  1


Contact Should Not Be Added
    Page Should Contain  text=This field is required

Delete Recent Created Contact
    [Arguments]  ${member_id}  ${first_name}  ${last_name}
    Get Into DB  TCH
    Execute SQL String  dml=DELETE FROM contacts WHERE carrier_id = ${member_id} AND type='CONTACT' AND fname='${first_name}' AND lname='${first_name}'
    Disconnect From Database
    Close Browser
