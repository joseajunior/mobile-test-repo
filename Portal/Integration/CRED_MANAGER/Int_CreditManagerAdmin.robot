*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Suite Setup  Setup
Suite Teardown  Close All Browsers
Force Tags  Portal  Credit Manager  Shifty  Integration

*** Variables ***


*** Test Cases ***

Credit Manager - Admin - Users
    [Tags]  Deprecated
    [Documentation]  This is to test if a user can access a user using Admin menu in Credit manager
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    wait until element is visible  //*[@class="menu"]//descendant::*[contains(text(),'Users')]
    Click Element  //*[@class="menu"]//descendant::*[contains(text(),'Users')]
    Wait Until Element Is Visible  xpath=//*[@id="deptadmin_content"]  timeout=20
    Double Click Element  //*[@id="daUserTable"]//*[contains(text(),'efsllc')]
    Wait Until Element Is Visible  xpath=//*[@id="editdaUserTable_content"]  timeout=10
    Click Portal Button  Close  //*[@id="dauserdata"]
    Sleep  0.5
    Click Portal Button  Close  //*[@id="dauserlist"]


Credit Manager - Admin - Adjustments
    [Tags]  refactor
    [Documentation]  This is to test if a user can administer adjustments using Admin menu in Credit manager
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    wait until element is visible  //*[@id='pm_6.1' and text()='Adjustments']
    Click Element  //*[@id='pm_6.1' and text()='Adjustments']
    Wait Until Element Is Visible  xpath=//*[@id="adminAdjustmentsTable"]  timeout=20
    Click Portal Button  Close  //*[@id="adjustments_content"]

Credit Manager - Admin - Credit Groups
    [Tags]
    [Documentation]  This is to test if a user can access credit groups using Admin menu in Credit manager
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    wait until element is visible  //*[text()='Credit Groups']
    Click Element  //*[ text()='Credit Groups']
    Wait Until Element Is Visible  xpath=//*[@id="credgrpsList"]  timeout=20

    ${instance}  get text  //*[@name="env"]/option[@selected="selected"]
    Double Click Element  //*[@id="credgrpsList"]//*[contains(text(),'@${instance.lower()}')]
    Wait Until Element Is Visible  xpath=//*[@id="editcredgrpsList_content"]  timeout=10
    Click Element  //*[@id="editcredgrpsList_caption"]//*[@class="jdlg_close" and @title="Close"]
    Sleep  0.5
    Click Portal Button  Close  //*[@id="credgrps_content"]


Credit Manager - Admin - Credit Managers
    [Tags]
    [Documentation]  This is to test if a user can access Credit Managers using Admin menu in Credit manager

    hover over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    wait until element is visible  //*[text()='Credit Managers']
    click element  //*[text()='Credit Managers']
    wait until element is visible  xpath=//*[@id="credMgrsList"]  timeout=20
    double click element  //*[@id="credMgrsList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[2]/div
    wait until element is visible  xpath=//*[@id="editcredMgrsList_content"]  timeout=10
    click portal button  Cancel  //*[@id="editcredMgrsList_content"]
    sleep  0.5
    click portal button  Close  //*[@id="credmgrs_content"]

*** Keywords ***
Setup

    Open Browser to portal
    Log Into Portal  ${PortalUsername}  ${PortalPassword}
    Select Portal Program  Credit Manager
    hover over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
