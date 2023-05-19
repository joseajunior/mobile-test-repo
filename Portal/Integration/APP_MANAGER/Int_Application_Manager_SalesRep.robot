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

Create A Sales Rep
    [Tags]  qTest:34867283  refactor
    Create Sales Rep
    Check Sales Rep Is Added On DB
    [Teardown]  Refresh Page

Edit A Sales Rep
    [Tags]  qTest:34868101  refactor

    Edit Sales Rep
    Check Sales Rep Is Edited On DB
    [Teardown]  Refresh Page

Delete A Sales Rep
    [Tags]  qTest:34870006  refactor

    Delete Sales Rep
    Check Sales Rep Is Deleted On DB


*** Keywords ***

Time To Setup
    Open Browser to portal
    Log Into Portal
    Go To Application Manager

Go To Application Manager
    Wait Until Element Is Visible  //*[text()[contains(.,"Application Manager")]]  timeout=30
    Select Portal Program  Application Manager

Create Sales Rep
    ${seq}  Generate Random String  5  [NUMBERS]
    Set Suite Variable  ${seq}

    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.3"]
    wait until element is visible  //*[@name="env"]  timeout=120
    Select From List By Value  //*[@name="env"]  TCH
    Wait Until Done Processing
    Click Element  //*[@id="salesFolk_content"]/a[1]/div/span[text()='Add']
    Wait Until Done Processing
    Wait Until Page Contains  text=Sales Quota  timeout=20
    Input Text  //*[@name="request.salesFolk.number"]  ${seq}
    Input Text  //*[@name="request.salesFolk.name"]  ROBOT_BASIC_${seq}
    Click Portal Button  Save
    Wait Until Done Processing

Edit Sales Rep

    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.3"]
    wait until element is visible  //*[@name="env"]  timeout=120
    Select From List By Value  //*[@name="env"]  TCH
    Wait Until Done Processing
    Click Element  //*[contains(text(),'ROBOT_BASIC_${seq}')]
    Click Portal Button  Edit
    Wait Until Done Processing
    Input Text  //*[@name="request.salesFolk.portalUserid"]  ${seq}
    Click Portal Button  Save
    Wait Until Done Processing

Delete Sales Rep
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.3"]
    wait until element is visible  //*[@name="env"]  timeout=120
    Select From List By Value  //*[@name="env"]  TCH
    Wait Until Done Processing
    Click Element  //*[contains(text(),'ROBOT_BASIC_${seq}')]
    Sleep  1
    Click Element  //*[@id="salesFolk_content"]//*[contains(text(),'Delete')]
    Click Portal Button  Yes

Check Sales Rep Is ${status} On DB

    Get Into DB  TCH
    ${query}  catenate  SELECT * FROM sales_folk WHERE name='ROBOT_BASIC_${seq}' AND number=${seq}
    ${INFO}  Query And Strip To Dictionary  ${query}

    Run Keyword IF  '${status}'=='Added'  Row Count Is Equal To X  ${query}  1
    ...  ELSE IF  '${status}'=='Edited'  Should Be Equal As Strings  ${INFO.portal_userid}  ${seq}
    ...  ELSE IF  '${status}'=='Deleted'  Row Count Is 0  SELECT * FROM sales_folk WHERE name='ROBOT_BASIC_${seq}'