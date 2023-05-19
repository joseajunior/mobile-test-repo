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

Suite Teardown  Close Browser
Suite Setup  Set Up Suite
Force Tags  Integration  Shifty  Portal

*** Test Cases ***

Online Pay Max Field Should Be Editable
    [Tags]

    Click Configuration Manager Link  Issuers
    Verify Online Pay Max is Editable

*** Keywords ***
Set Up Suite
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Configuration Manager

Verify Online Pay Max is Editable

    Wait Until Done Processing
    Click Portal Button  Add
    Wait Until Page Contains  text=Issuer Information  timeout=10
    Click Element  //*[@id="issuerForm"]//*[contains(text(),'Defaults')]
    Input Text  request.contDef.achMaxAmt  100  #Online Pay Max Field
    Click Portal Button  Cancel