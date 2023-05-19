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

Create A Sales Territories
    [Tags]  qTest:34841396
    Go To Application Manager
    Create Sales Territory
    Check Sales Territory Is Added On DB
    [Teardown]  Refresh Page

Edit A Sales Territories
    [Tags]  qTest:34867162  refactor

    Edit Sales Territory
    Check Sales Territory Is Edited On DB
    [Teardown]  Refresh Page

Delete A Sales Territories
    [Tags]  qTest:34865393

    Delete Sales Territory
    Check Sales Territory Is Deleted On DB


*** Keywords ***

Time To Setup
    Open Browser to portal
    Log Into Portal

Go To Application Manager
    Wait Until Element Is Visible  //*[text()[contains(.,"Application Manager")]]  timeout=120
    Select Portal Program  Application Manager

Create Sales Territory
    ${seq}  Generate Random String  2  [LETTERS]
    Set Suite Variable  ${seq}

    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.2"]
    Wait Until Element Is Visible  //*[@id="salesTerr_caption"]  timeout=120
    Select From List By Value  //*[@name="env"]  TCH
    Wait Until Done Processing
    Click Element  //*[@id="salesTerr_content"]//*[contains(text(),'Add')]
    Sleep  1
    Input Text  //*[@name="request.salesTerritory.code"]  ${seq.upper()}
    Input Text  //*[@name="request.salesTerritory.description"]  ROBOT_BASIC_${seq.upper()}
    Click Portal Button  Save

Edit Sales Territory
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.2"]
    Wait Until Element Is Visible  //*[@id="salesTerr_caption"]  timeout=120
    Select From List By Value  //*[@name="env"]  TCH
    Wait Until Done Processing
    Click Element  //*[contains(text(),'ROBOT_BASIC_${seq.upper()}')]
    Click Portal Button  Edit
    Sleep  1
    Select From List By Value  //*[@name="request.salesTerritory.territoryType"]  L
    Click Portal Button  Save

Delete Sales Territory
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.2"]
    Wait Until Element Is Visible  //*[@id="salesTerr_caption"]  timeout=120
    Select From List By Value  //*[@name="env"]  TCH
    Wait Until Done Processing
    Click Element  //*[contains(text(),'ROBOT_BASIC_${seq.upper()}')]
    Sleep  1
    Click Element  //*[@id="salesTerr_content"]//*[contains(text(),'Delete')]
    Click Portal Button  Yes

Check Sales Territory Is ${status} On DB

    Get Into DB  TCH
    ${query}  catenate  SELECT * FROM sales_territory WHERE description='ROBOT_BASIC_${seq.upper()}' AND code='${seq.upper()}'
    ${INFO}  Query And Strip To Dictionary  ${query}

    Run Keyword IF  '${status}'=='Added'  Row Count Is Equal To X  ${query}  1
    ...  ELSE IF  '${status}'=='Edited'  Should Be Equal As Strings  ${INFO.territory_type}  L
    ...  ELSE IF  '${status}'=='Deleted'  Row Count Is 0  SELECT * FROM sales_territory WHERE description='ROBOT_BASIC_${seq}'