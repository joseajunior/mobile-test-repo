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

Suite Teardown  close browser
Suite Setup  Set Up Suite
Force Tags  Integration  Shifty  Portal

*** Test Cases ***

Create A Card Style
    [Tags]  qTest:31156482

    Click Configuration Manager Link  Card Styles
    Create Card Style
    Check If Card Style Is Added On DB

    [Teardown]  Refresh Page

Delete A Card Style

    Click Configuration Manager Link  Card Styles
    Delete Card Style
    Check If Card Style Is Deleted On DB



*** Keywords ***
Set Up Suite
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Configuration Manager

Create Card Style

    ${seq}  Generate Random String  4  [NUMBERS]
    Set Suite Variable  ${seq}

    Wait Until Done Processing
    Click Portal Button  Add
    Wait Until Done Processing
    Wait Until Page Contains  text=Please select the Order Type First  timeout=20
    Select From List By Value  //*[@name="request.orderId"]  1  #1 - EFS Fleet & Cash
    Input Text  request.cardStyle.name  0001/ROBOT_BASIC_${seq}
    Input Text  request.cardStyle.cardStock  INTEGRATION_TEST
    Select From List By Value  request.cardStyle.verified  Y
    Select From List By Value  request.cardStyle.useCarrierType  Y
    Select Checkbox  request.carrierTypecardStyle.carrierType[0]
    Click Portal Button  Save
    Wait Until Done Processing


Delete Card Style

    Wait Until Done Processing
    Click Element  //*[@id="cardStylesList"]//*[contains(text(),'0001/ROBOT_BASIC_${seq}')]
    Click Portal Button  Delete
    Click Portal Button  Yes
    Sleep  2
    Refresh Page


Check If Card Style Is ${status} On DB

    Get Into DB  TCH
    Run Keyword IF  '${status}'=='Added'  Row Count Is Equal To X  SELECT * FROM card_styles WHERE name='0001/ROBOT_BASIC_${seq}'  1
    ...  ELSE IF  '${status}'=='Deleted'  Row Count Is 0  SELECT * FROM card_styles WHERE name='0001/ROBOT_BASIC_${seq}'