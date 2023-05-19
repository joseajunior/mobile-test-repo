#TODO Queue probably needs more tests
*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Suite Teardown  close all browsers
Force Tags  Portal  Credit Manager  Queues  weekly
Documentation  This is for fetching different queues on Credit Manager Home page

Suite Setup  Setup

*** Variables ***

*** Test Cases ***

Issuer Group - EFS - Queues
    [Tags]  JIRA:BOT-1691  qTest:30897698  Regression
    [Documentation]  This test case is to verify if a selected queue displays corresponding lists for EFS issuer group
    [Setup]  Test Start
    change issuer group  EFS
    wait until page contains element  xpath=//*[@id="queues"]//descendant::*[contains(text(),'3 DBT')]  timeout=60
    wait until element is visible  xpath=//*[@id="queues"]//descendant::*[contains(text(),'3 DBT')]  timeout=30
    #maybe split this up like the non efs is being done
    double click on  //*[@id="queues"]//descendant::*[contains(text(),'3 DBT')]
    wait until element is visible  xpath=//*[@id="resultsTable"]  timeout=30

Issuer Group - EFS - Lists
    [Tags]  JIRA:BOT-1692  qTest:30897744  Regression
    [Documentation]  This test case is to verify if a selected list displays corresponding contract for EFS issuer group
    double click on  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[3]/div
    wait until element is visible  xpath=//*[@id="accountDetail"]//descendant::*[contains(text(),'Contract')]  timeout=30

Issuer Group Non EFS
    [Tags]  JIRA:BOT-1693  qTest:30897747  Regression
    [Documentation]  This test case is to verify when a new issuer group is selected, a different set of queues are displayed
    [Setup]  Test Start
    Change Issuer Group  Shell Oil
    wait until page contains element  xpath=//*[@id="queues"]//descendant::*[contains(text(),'NSF')]  timeout=60

Issuer Group Non EFS - Queues
    [Tags]  JIRA:BOT-1694  qTest:30897748  Regression
    [Documentation]  This test case is to verify if a selected queue displays corresponding lists for a non EFS issuer group
    double click on  //*[@id="queues"]//descendant::*[contains(text(),'NSF')]
    wait until element is visible  xpath=//*[@id="resultsTable"]  timeout=30

Issuer Group Non EFS - Lists
    [Tags]  JIRA:BOT-1695  qTest:30897814  Regression
    [Documentation]  This test case is to verify if a selected list displays corresponding contract for non EFS issuer group
    double click on  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[3]/div
    wait until element is visible  xpath=//*[@id="accountDetail"]//descendant::*[contains(text(),'Contract')]  timeout=30


*** Keywords ***
Setup
    Open Browser to portal
    ${status}=  Log Into Portal
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}
    Select Portal Program  Credit Manager

Test Start
    wait until page contains element  //*[@id='pm_1']  60
    click element  //*[@id='pm_1']
    wait until queue to be gathered

Change Issuer Group
    [Arguments]  ${group}
    select from list by label  //*[@name='issuerGroupId']  ${group}
    Click Portal Button  Refresh  times=1
    wait until done refreshing

Wait Until Queue to be Gathered
    [Arguments]  ${timeout}=60  ${msg}=Processing did not complete within ${timeout} sec
    ${xpath}=  set variable  //div[contains(text(),"Gathering") and contains(text()," Please wait...")]
    Run Keyword And Ignore Error  Wait Until Element Is Visible    ${xpath}  error="Expected the Gathering"
    Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${xpath}  ${timeout}  ${msg}