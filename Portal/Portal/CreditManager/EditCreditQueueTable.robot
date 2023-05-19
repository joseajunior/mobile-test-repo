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
Force Tags  Portal  Credit Manager  Queues  weekly Charge Off
Documentation  This is for fetching different queues on Credit Manager Home page


*** Variables ***

*** Test Cases ***

Add Charge Off and Charge Off Date fields to Credit queue settings
    [Tags]  JIRA:PORT-26    qTest:38672818 Regression
    [Documentation]  This test case is to verify if you select the "Charge Off" and "Charge Off Date" options in the settings these fields will be available to view on the credit queue grid.
    Open the "3 DBT" queue
    Open Table Settings
    Select the "Charge Off" and "Charge Off Date" fields to be displayed in the table
    Click "OK"
    Verify "Charge Off" and "Charge Off Date" columns are added


*** Keywords ***
Setup
    Open Browser to portal
    ${status}=  Log Into Portal
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}
    Select Portal Program  Credit Manager
    wait until page contains element  //*[@id='pm_1']  60
    click element  //*[@id='pm_1']
    wait until page contains element  xpath=//*[@id="queues"]//descendant::*[contains(text(),'3 DBT')]

Open the "3 DBT" queue
    double click on  //*[@id="queues"]//descendant::*[contains(text(),'3 DBT')]
    wait until element is visible  xpath=//*[@id="resultsTable"]  timeout=30

Open Table Settings
    click on  //*[@title="Settings"]
    wait until element is visible  xpath=//*[@id="dataGridSettings"]//descendant::*[contains(text(),'Charge Off')]  timeout=30

Select the "Charge Off" and "Charge Off Date" fields to be displayed in the table
    click on  //div[@id="dataGridSettings"]//descendant::div[text()="Charge Off"]
    click on  //div[@id="dataGridSettings"]//descendant::div[text()="Charge Off"]

Click "OK"
    click on  //span[text()="OK"]

Verify "Charge Off" and "Charge Off Date" columns are added
    wait until page contains element  xpath=//div[text()="Charge Off"]  timeout=30
    wait until page contains element  xpath=//div[text()="Charge Off Date"]  timeout=30