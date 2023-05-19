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
Suite Teardown  Close All Browsers
Force Tags  Portal  Application Manager  weekly
Documentation  This is to test if a user can access different menu options in Admin dropdown
...  and if the user can access the results in each menu option

*** Variables ***
${user}  robot

*** Test Cases ***

Admin - Users - Search and access a random user
    [Tags]  JIRA:BOT-1670  qTest:31544012  Regression
    [Documentation]  This is to test if a user can search and access a particular user
    Open Admin Tab
    Select Users Option
    Search and Access a User

Admin - Open one of Account Territories
    [Tags]  JIRA:BOT-1671  qTest:31544028  Regression
    [Documentation]  This is to test if a user can open one of the account territories
    Open Admin Tab
    Select Account Territories Option
    Open One of Account Territories

Admin - Open one of Sales Territories
     [Tags]  JIRA:BOT-1672  qTest:31544030  Regression
    [Documentation]  This is to test if a user can open one of the sales territories
    Open Admin Tab
    Select Sales Territories Option
    Open One of Sales Territories

Admin - Open one of Sales Rep
    [Tags]  JIRA:BOT-1673  qTest:31544031  Regression
    [Documentation]  This is to test if a user can open one of the sales rep in each instance
    Open Admin Tab
    Select Sales Rep Option
    Open One of Sales Rep in Each Instance

Admin - Open one Implementation Managers
    [Tags]  JIRA:BOT-1674  qTest:31544033  Regression
    [Documentation]  This is to test if a user can access an Implementation Manager
    Open Admin Tab
    Select Implementation Managers Option
    Access an Implementation Manager

*** Keywords ***
Setup
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Application Manager

Open one Sales Rep
    [Arguments]  ${instance}
    Wait Until Element is Enabled  //*[@id="salesFolk_content"]//*[@id="abc"]
    Select From List By Value  //*[@id="salesFolk_content"]//*[@id="abc"]  ${instance}
    Sleep  5
    Double Click Element  //*[@id="salesRepList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]/div
    Wait Until Element Is Visible  //*[@id="editsalesRepList_caption"]  timeout=10
    Click Portal Button  Cancel  //*[@id="editsalesRepList_content"]
    Wait Until Element Is Enabled  //*[@id="salesFolk_caption"]  timeout=10

Search and Access a User
    Wait Until Element Is Visible  //*[@id="daUserTable"]  timeout=10
    Double Click Element  //*[@id="daUserTable"]//*[contains(text(),'${user}')]
    Wait Until Element Is Visible  //*[@id="editdaUserTable_content"]  timeout=10
    Click Portal Button  Close  //*[@id="editdaUserTable_content"]
    Wait Until Element Is Enabled  //*[@id="daUserTable"]  timeout=10
    Click Portal Button  Close  //*[@id="deptadmin_content"]

Open One of Account Territories
    Wait Until Element Is Visible  //*[@id="acctTerr_caption"]  timeout=10
    Double Click Element  //*[@id="acctTerrList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]/div
    Wait Until Element Is Visible  //*[@id="editacctTerrList_caption"]  timeout=10
    Click Portal Button  Cancel
    Wait Until Element Is Enabled  //*[@id="acctTerr_caption"]  timeout=10
    Click Portal Button  Close  //*[@id="acctTerr_content"]

Open One of Sales Territories
    Wait Until Element Is Visible  //*[@id="salesTerr_caption"]  timeout=10
    Double Click Element  //*[@id="salesTerrList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]/div
    Wait Until Element Is Visible  //*[@id="editsalesTerrList"]  timeout=12
    Click Portal Button  Cancel  //*[@id="editsalesTerrList_content"]
    Wait Until Element Is Enabled  //*[@id="salesTerr_caption"]  timeout=10
    Click Portal Button  Close  //*[@id="salesTerr_content"]

Open One of Sales Rep in Each Instance
    Wait Until Element is Enabled  //*[@id="salesFolk_caption"]  timeout=10
    Open one Sales Rep  IMPERIAL
    Open one Sales Rep  IRVING
    Open one Sales Rep  SHELL
    Open one Sales Rep  TCH
    Click Portal Button  Close  //*[@id="salesFolk_content"]

Access an Implementation Manager
    Wait Until Element Is Visible  //*[@id="implMgrs_caption"]  timeout=10
    Double Click Element  //*[@id="implMgrList"]/tbody/tr[2]/td[2]/div/table/tbody/tr/td[1]/div
    Wait Until Element Is Visible  //*[@id="editimplMgrList_caption"]  timeout=10
    Click Portal Button  Cancel  //*[@id="editimplMgrList_content"]
    Wait Until Element Is Enabled  //*[@id="implMgrs_caption"]  timeout=10
    Click Portal Button  Close  //*[@id="implMgrs_content"]

Open Admin Tab
    Refresh Page
    Click Element  //*[@class='menu_content']/*/*[contains(text(),'Admin')]

Select Users Option
    Wait Until Element Is Visible  //*[@id="pm_3.0"]  timeout=10
    Click Element  //*[@id="pm_3.0"]

Select Account Territories Option
    Wait Until Element Is Visible  //*[@id="pm_3.1"]  timeout=10
    Click Element  //*[@id="pm_3.1"]

Select Sales Territories Option
    Wait Until Element Is Visible  //*[@id="pm_3.2"]  timeout=10
    Click Element  //*[@id="pm_3.2"]

Select Sales Rep Option
    Wait Until Element Is Visible  //*[@id="pm_3.3"]  timeout=10
    Click Element  //*[@id="pm_3.3"]

Select Implementation Managers Option
    Wait Until Element Is Visible  //*[@id="pm_3.8"]  timeout=10
    Click Element  //*[@id="pm_3.8"]