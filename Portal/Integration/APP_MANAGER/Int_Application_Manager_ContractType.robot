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

Create A Contract Type
    [Tags]  qTest:31652879  refactor

    Create Contract Type
    Check Contract Type Is Added On DB

    [Teardown]  Refresh Page

Delete A Contract Type
    [Tags]  qTest:31652882  refactor
    Delete Contract Type
    Check Contract Type Is Deleted On DB


*** Keywords ***

Time To Setup
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Application Manager
    Click Element  //*[@id="pm_1"]
    Wait Until Element Is Visible  id=searchForm

Create Contract Type
    ${contract_type}  Generate Random String  3  [NUMBERS]
    Set Suite Variable  ${contract_type}

    Click Portal Button  Contract Types
    Wait Until Element Is Visible  xpath=//*[@id="extContTypes_content"]
    Click Portal Button  Add  //*[@id="extContTypes_content"]
    Wait Until Element Is Enabled  //*[@name="request.type.name"]
    Input Text  request.type.name  ROBOT_TEST_${contract_type}
    Click Portal Button  Save
    Wait Until Element Is Enabled  xpath=//*[@id="extContTypes_content"]  timeout=10
    Sleep  1
    Click Portal Button  Close
    Refresh Page
    Wait Until Element Is Enabled  xpath=//*[@name="request.search.contractType"]
    ${list}  Get List Items   request.search.contractType
    List Should Contain Value  ${list}  ROBOT_TEST_${contract_type}

Delete Contract Type

    Click Portal Button  Contract Types
    Wait Until Element Is Visible  xpath=//*[@id="extContTypes_content"]
    Click Element  //*[@id="typeList"]//descendant::*[contains(text(),'ROBOT_TEST_${contract_type}')]
    Click Portal Button  Delete  //*[@id="extContTypes_content"]
    Click Portal Button  Yes
    Wait Until Element Is Enabled  xpath=//*[@id="extContTypes_content"]  timeout=10
    Sleep  1
    Click Portal Button  Close
    Refresh Page
    Wait Until Element Is Enabled  xpath=//*[@name="request.search.contractType"]
    ${list}=  Get List Items  request.search.contractType
    List Should Not Contain Value  ${list}  ROBOT_TEST_${contract_type}


Check Contract Type Is ${status} On DB

    Get Into DB  TCH
    ${query}  catenate  SELECT * FROM ext_contract_type WHERE name='ROBOT_TEST_${contract_type}'
    ${INFO}  Query And Strip To Dictionary  ${query}

    Run Keyword IF  '${status}'=='Added'  Row Count Is Equal To X  ${query}  1
    ...  ELSE IF  '${status}'=='Deleted'  Row Count Is 0  SELECT * FROM ext_contract_type WHERE name='ROBOT_TEST_${contract_type}'
