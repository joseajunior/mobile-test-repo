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

Create An Account Territories
    [Tags]  qTest:34841017
    Go To Application Manager
    Create Account Territory
    Check Account Territory Is Added On DB
    [Teardown]  Refresh Page

Edit An Account Territories
    [Tags]  qTest:34841117

    Edit Account Territory
    Check Account Territory Is Edited On DB
    [Teardown]  Refresh Page

Delete An Account Territories
    [Tags]  qTest:34841075

    Delete Account Territory
    Check Account Territory Is Deleted On DB


*** Keywords ***

Time To Setup
    Open Browser to portal
    Log Into Portal

Go To Application Manager
    Wait Until Element Is Visible  //*[text()[contains(.,"Application Manager")]]  timeout=30
    Select Portal Program  Application Manager

Create Account Territory
    ${seq}  Generate Random String  2  [NUMBERS]
    Set Suite Variable  ${seq}

    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.1"]
    Wait Until Element Is Visible  //*[@id="acctTerr_caption"]  timeout=20
    Click Element  //*[@id="acctTerr_content"]//*[contains(text(),'Add')]
    Sleep  1
    Input Text  //*[@id="acctterr"]//*[@name="request.acctTerritory.code"]  ${seq}
    Input Text  //*[@id="acctterr"]//*[@name="request.acctTerritory.description"]  ROBOT_BASIC_${seq}
    Click Portal Button  Save
    Sleep  2

Edit Account Territory
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.1"]
    Run Keyword And Ignore Error   Wait Until Element Is Visible  //*[@id="acctTerr_caption"]  timeout=10
    Click Element  //*[contains(text(),'ROBOT_BASIC_${seq}')]
    Click Portal Button  Edit
    Sleep  1
    Select From List By Value  //*[@name="request.acctTerritory.territoryType"]  L
    Click Portal Button  Save

Delete Account Territory
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.1"]
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@id="acctTerr_caption"]  timeout=10
    Click Element  //*[contains(text(),'ROBOT_BASIC_${seq}')]
    Sleep  1
    Click Element  //*[@id="acctTerr_content"]//*[contains(text(),'Delete')]
    Click Portal Button  Yes

Check Account Territory Is ${status} On DB

    Get Into DB  TCH
    ${query}  catenate  SELECT * FROM account_territory WHERE description='ROBOT_BASIC_${seq}' AND code='${seq}'
    ${INFO}  Query And Strip To Dictionary  ${query}

    Run Keyword IF  '${status}'=='Added'  Row Count Is Equal To X  ${query}  1
    ...  ELSE IF  '${status}'=='Edited'  Should Be Equal As Strings  ${INFO.territory_type}  L
    ...  ELSE IF  '${status}'=='Deleted'  Row Count Is 0  SELECT * FROM account_territory WHERE description='ROBOT_BASIC_${seq}'