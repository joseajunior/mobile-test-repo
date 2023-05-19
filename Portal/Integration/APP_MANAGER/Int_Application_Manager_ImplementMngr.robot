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

Create An Implement Mngr
    [Tags]  qTest:34874227  refactor
    Create Implement Manager
    Check Implement Manager Is Added On DB
    [Teardown]  Refresh Page


Edit An Implement Mngr
    [Tags]  qTest:  refactor

    Edit Implement Manager
    Check Implement Manager Is Edited On DB

    [Teardown]  Refresh Page

Delete An Implement Mngr
    [Tags]  qTest:  refactor

    Delete Implement Manager
    Check Implement Manager Is Deleted On DB

*** Keywords ***

Time To Setup
    Open Browser to portal
    Log Into Portal
    Go To Application Manager

Go To Application Manager
    Wait Until Element Is Visible  //*[text()[contains(.,"Application Manager")]]  timeout=30
    Select Portal Program  Application Manager

Create Implement Manager
    ${seq}  Generate Random String  5  [NUMBERS]
    Set Suite Variable  ${seq}

    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.8"]
    wait until element is visible  //*[@name="orgId"]  timeout=120
    Select From List By Value  //*[@name="orgId"]  81    #EFS LLC
    Wait Until Done Processing
    Click Element  //*[@id="implMgrs_content"]/a[1]/div/span[text()='Add']
    Wait Until Done Processing
    Wait Until Page Contains  text=Name  timeout=20
    Input Text  //*[@name="request.implMgr.name"]  ROBOT_${seq}
    Input Text  //*[@name="request.implMgr.email"]  robot@efsllc.com
    Click Portal Button  Save
    Wait Until Done Processing

Edit Implement Manager

    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.8"]

    wait until element is visible  //*[@name="orgId"]  timeout=120
    Select From List By Value  //*[@name="orgId"]  81    #EFS LLC
    Wait Until Done Processing
    Click Element  //*[contains(text(),'ROBOT_${seq}')]
    Click Portal Button  Edit
    Wait Until Done Processing
    Input Text  //*[@name="request.implMgr.email"]  robot_edit@efsllc.com
    Click Portal Button  Save
    Wait Until Done Processing

Delete Implement Manager
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Click Element  //*[@id="pm_3.8"]
    wait until element is visible  //*[@name="orgId"]  timeout=120
    Select From List By Value  //*[@name="orgId"]  81    #EFS LLC
    Wait Until Done Processing
    Click Element  //*[contains(text(),'ROBOT_${seq}')]
    Sleep  1
    Click Element  //*[@id="implMgrs_content"]//*[contains(text(),'Delete')]
    Click Portal Button  Yes

Check Implement Manager Is ${status} On DB

    Get Into DB  TCH
    ${query}  catenate  SELECT * FROM impl_mgr WHERE name='ROBOT_${seq}' and org_id=81  #EFS LLC
    ${INFO}  Query And Strip To Dictionary  ${query}

    Run Keyword IF  '${status}'=='Added'  Row Count Is Equal To X  ${query}  1
    ...  ELSE IF  '${status}'=='Edited'  Should Be Equal As Strings  ${INFO.email}  robot_edit@efsllc.com
    ...  ELSE IF  '${status}'=='Deleted'  Row Count Is 0  SELECT * FROM impl_mgr WHERE name='ROBOT_${seq}'