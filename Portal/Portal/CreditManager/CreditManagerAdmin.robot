*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium

Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Setup
Suite Teardown  close all browsers
Force Tags  Portal  Credit Manager  weekly
Documentation  This is for the search functionality on Credit Manager Home page
#this needs to be converted into keywords later
#this needs to run only weekly
*** Variables ***


*** Test Cases ***

Credit Manager - Admin - Users
    [Tags]  JIRA:BOT-1705  qTest:31801945  Regression
    [Documentation]  ​​This is to test if a user can access a user using Admin menu in Credit manager
    hover over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    click element  //*[@class="menu"]//descendant::*[contains(text(),'Users')]
    wait until element is visible  xpath=//*[@id="deptadmin_content"]  timeout=20
    double click element  //*[@id="daUserTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]/div
    wait until element is visible  xpath=//*[@id="editdaUserTable_content"]  timeout=10
    click portal button  Close  //*[@id="dauserdata"]
    sleep  0.5
    click portal button  Close  //*[@id="dauserlist"]


Credit Manager - Admin - Adjustments
    [Tags]  JIRA:BOT-1705  qTest:31801949  Regression
    [Documentation]  This is to test if a user can administer adjustments using Admin menu in Credit manager
    hover over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    sleep  0.5
    click element  //*[@id="pm_6.2"]
    wait until element is visible  xpath=//*[@id="adminAdjustmentsTable"]  timeout=20
    click portal button  Close  //*[@id="adjustments_content"]

Credit Manager - Admin - Credit Groups
    [Tags]  JIRA:BOT-1705  qTest:31801950  Regression
    [Documentation]  This is to test if a user can access credit groups using Admin menu in Credit manager
    hover over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    click element  //*[@class="menu"]//descendant::*[contains(text(),'Credit Groups')]
    wait until element is visible  xpath=//*[@id="credgrpsList"]  timeout=20
    double click element  //*[@id="credgrpsList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[2]/div
    wait until element is visible  xpath=//*[@id="editcredgrpsList_content"]  timeout=10
    click element  //*[@id="credgrp"]/form/a[2]/div/span[contains(text(),'Cancel')]
    sleep  0.5
    click portal button  Close  //*[@id="credgrps_content"]


Credit Manager - Admin - Credit Managers
    [Tags]  JIRA:BOT-1705  qTest:31801951  Regression  refactor
    [Documentation]  This is to test if a user can access Credit Managers using Admin menu in Credit manager
    hover over  //*[@class='menu_content']/*/*[contains(text(),'Admin')]
    click element  //*[@class="menu"]//descendant::*[contains(text(),'Credit Managers')]
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
