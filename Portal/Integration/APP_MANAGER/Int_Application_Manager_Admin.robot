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


Force Tags  Integration  Shifty  Portal

*** Variables ***

*** Test Cases ***
Admin - Users - Search and access a random user
    [Tags]  Deprecated
    [Documentation]  This is to test if a user can search and access a particular user
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Application Manager
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    Sleep  1     # ADDING A SLEEP JUST TO GIVE THAT SECOND FOR IT TO SHOW ON THE SCREEN
    Click Element  //div[@class='menu']//*[text()='Users']
    Wait Until Element Is Visible  //*[@id="daUserTable"]  timeout=10
    Double Click Element  //*[@id="daUserTable"]//*[contains(text(),'efsllc')][1]
    Wait Until Element Is Visible  //*[@id="editdaUserTable_content"]  timeout=10
    Click Portal Button  Close  //*[@id="editdaUserTable_content"]
    Wait Until Element Is Enabled  //*[@id="daUserTable"]  timeout=10
    Click Portal Button  Close  //*[@id="deptadmin_content"]

    [Teardown]  Close Browser