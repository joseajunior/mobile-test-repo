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
Basic Queues
    [Tags]  qTest:34476195
   Go To Queues
   The Page Displays All Elements

Create A Queue
    [Tags]
    Create Queue
    Check DB For Added Queue
    [Teardown]  Refresh Page

Delete A Queue
    [Tags]  refactor
    Delete Queue
    Check DB For Deleted Queue


*** Keywords ***
Set Up Suite
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Credit Manager

Go To Queues
    Wait Until Element Is Visible  //*[@id="pm_1"]  timeout=20
    Click On  text=Queues
    Wait Until Element Is Visible  //*[@id="queues"]  timeout=30

The Page Displays All Elements
    Page Should Contain  text=Credit Queues
    Page Should Contain  text=Issuer Group
    Page Should Contain  text=Credit Group
    Page Should Contain  text=Account Descriptor
    Page Should Contain  text=Refresh

Create Queue
    ${seq}  Generate Random String  3  [NUMBERS]
    Set Suite Variable  ${seq}
    Click Portal Button  Configure
    Wait Until Done Processing
    Wait Until Page Contains  text=Issuer Group  timeout=30
    Wait Until Done Processing
    Click Portal Button  Add  //*[@id="creditQueue_content"]
    Sleep  1
    Select From List By Value  //*[@id="issuerGroup" and @name="issuerGroupId"]  10  #EFS
    Input Text  request.creditQueue.description  BASIC_${seq}
    Click Portal Button  Save  //*[@id="creditQueueForm"]
    Sleep  2


Delete Queue
    Wait Until Page Contains  text=Queues  timeout=30
    Wait Until Element Is Visible  //*[@id="queues"]  timeout=30
    Run Keyword And Ignore Error  Wait Until Element Is Visible    //*[text()="Gathering queue data. Plase wait..."]  timeout=20
    Run Keyword And Ignore Error  Wait Until Element Is Not Visible  //*[text()="Gathering queue data. Plase wait..."]  timeout=20
    Wait Until Element Is Visible  //*[@id="queues"]  timeout=60
    Table Should Contain  //*[@id="queues"]  BASIC_${seq}
    Click Portal Button  Configure
    Wait Until Done Processing
    Click Element  //*[@id="creditQueues"]//*[contains(text(),'BASIC_${seq}')]
    Click Portal Button  Delete  //*[@id="creditQueue_content"]
    Click Portal Button  Yes  //*[@id="deleteConfirm_content"]
    Sleep  2

Check DB For ${status} Queue
    Get Into DB  TCH

    Run Keyword IF  '${status}'=='Added'  Row Count Is Equal To X  SELECT * FROM credit_queue WHERE description='BASIC_${seq}'  1
    ...  ELSE IF  '${status}'=='Deleted'  Row Count Is 0  SELECT * FROM credit_queue WHERE description='BASIC_${seq}'