*** Settings ***
Library  Process
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Suite Setup  Time To Setup
Suite Teardown  Close All Browsers
Force Tags  Integration  Shifty  Portal

*** Test Cases ***

Create An External Account
    [Tags]  qTest:  refactor
    Go To External Contracts
    Search External Contracts
    Check External Contract Exists in DB

*** Keywords ***

Time To Setup
    Open Browser to portal
    Log Into Portal

Go To External Contracts
    Wait Until Element Is Visible  //*[text()[contains(.,"Application Manager")]]  timeout=120
    Select Portal Program  Application Manager
    Wait Until Page Contains  text=Application Manager  timeout=120
    Click Element  //*[@id="pm_1"]
    Wait Until Page Contains  text=External Contracts  timeout=120

Search External Contracts
    ${external_contract}  Get Text  //*[@name="request.search.contractType"]/option[2]
    Set Suite Variable  ${external_contract}
    Select From List By Index  request.search.contractType  1
    Click Portal Button  Search
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@id="resultsList"]  timeout=120
    Wait Until Element Is Visible  //*[@id="resultsList"]//*[contains(text(),'${external_contract}')]  timeout=120


Check External Contract Exists in DB
    Get Into DB  TCH
    ${ext_ct}  Query And Strip To Dictionary  SELECT * FROM ext_contract_type WHERE name='${external_contract}'
    Should Be Equal As Strings  ${ext_ct.name}  ${external_contract}