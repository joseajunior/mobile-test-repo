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
Click On Issuers
    [Tags]  JIRA:BOT-1823  qTest:31156480  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Issuers
    Validate Correct Module Displays  issuers  issuersList

Click On Card Brands
    [Tags]  JIRA:BOT-1824  qTest:31156481  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Card Brands
    Validate Correct Module Displays  crdbrnd  cardBrands

Click On Card Styles
    [Tags]  JIRA:BOT-1824  qTest:31156482  Regression  JIRA:BOT-1831  JIRA:BOT-2057
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Card Styles
    Validate Correct Module Displays  crdstyle  cardStylesList

Click On Fee Groups
    [Tags]  JIRA:BOT-1825  qTest:31156483  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Fee Groups
    Validate Correct Module Displays  feegrps  feeGroups

Click On Fee Types
    [Tags]  JIRA:BOT-1825  qTest:31156484  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Fee Types
    Validate Correct Module Displays  feetyps  feeTypes

Click On Fee Defaults
    [Tags]  JIRA:BOT-1825  qTest:31156485  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Fee Defaults
    Validate Correct Module Displays  feedefs  feeDefs

Click On Discount Tiers
    [Tags]  JIRA:BOT-1826  qTest:31156486  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Discount Tiers
    Validate Correct Module Displays  disctiers  discTiers

Click On Rebate Tiers
    [Tags]  JIRA:BOT-1826  qTest:31156487  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Rebate Tiers
    Validate Rebate Tiers  rebatetiers

Click On Application Manager Status Matrix
    [Tags]  JIRA:BOT-1827  qTest:31156488  Regression  JIRA:BOT-1831  BUGGED:Application Manager Status Matrix Will not display stating "No table definitions was found" probably is a data issue in ACPT, will need help debugging
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Application Manager Status Matrix
    Validate Correct Module Displays  appmgrstatmtx  appmgrstatmtx

Click On Carrier Types
    [Tags]  JIRA:BOT-1828  qTest:31156489  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Carrier Types
    Validate Correct Module Displays  cartyps  carrierTypes

Click On Credit Queues
    [Tags]  JIRA:BOT-1829  qTest:31156490  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Credit Queues
    Validate Correct Module Displays  creditQueue  creditQueues

Click On Account Descriptors
    [Tags]  JIRA:BOT-1829  qTest:31156491  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Account Descriptors
    Validate Correct Module Displays  accountDescriptors  accountDescriptorsList

Click On Alternate Descriptors
    [Tags]  JIRA:BOT-1829  qTest:31156492  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Alternate Descriptors
    Validate Correct Module Displays  alternateDescriptors  alternateDescriptorsList

Click On Lookup Refresh
    [Tags]  JIRA:BOT-1830  qTest:31156493  Regression  JIRA:BOT-1831
    [Setup]  Refresh Page
    [Teardown]  Run Keyword IF Test Failed  Refresh Page

    Click Configuration Manager Link  Lookup Refresh
    Validate Lookup Refresh Prompt  lookupRefresh

*** Keywords ***
Set Up Suite
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Configuration Manager

Validate Correct Module Displays
    [Arguments]  ${module}  ${editModuleName}

#   CHECKING ALL THE WAYS POSSIBLE IF THE MODULE IS ON SCREEN

    Run Keyword And Ignore Error  Wait Until Element Is Visible  //div[@id="${module}_content"]//tr[@onclick]  timeout=10
    ${count}  Get Element Count  //div[@id="${module}_content"]//tr[@onclick]
    Run Keyword IF  ${count} < 1  Sleep  2
    ${count}  Run Keyword IF  ${count} < 1  Get Element Count  //div[@id="${module}_content"]//tr[@onclick]  ELSE  Set Variable  ${count}
    Run Keyword IF  ${count} < 1  Run Keyword And Ignore Error  Refresh Page
    Run Keyword IF  ${count} < 1  Selenium Failure
    Run Keyword IF  ${count} < 1  FAIL  Could Not Click On Module Content for ${module}. Try Again.

    :FOR  ${i}  IN RANGE  1  ${count}
      wait until element is visible  //div[@id="${module}"]  10  Module ${module} did not display

      ${stat}=  run keyword and return status  Double Click Element  //div[@id="${module}_content"]//tr[@recordindex="${i}"]
      run keyword if  not ${stat}  FAIL  Could Not Click On Module Content for ${module}

      ${status}  Run Keyword And Return Status  wait until element is visible  //div[@id="edit${editModuleName}"]  10  Edit Module for ${module} did not display after clicking row

      Run Keyword IF  '${status}'=='${True}'  Run Keywords
      ...  Click Element  xpath=//div[@id="edit${editModuleName}_caption"]//*[@title="Close"]
      ...  AND  Click Element  xpath=//div[@id="${module}"]//*[@title="Close"]
      ...  AND  Exit For Loop
    END

Validate Lookup Refresh Prompt
    [Arguments]  ${module}
    wait until element is visible  //div[@id="${module}"]  10  Module ${module} did not display
    element should be visible  //div[@id="lookupRefresh"]//form[contains(string(),'Clicking "OK" will force the lookups to refresh on next use.')]  Lookup Refresh Prompt Did Not Display

    click element  xpath=//div[@id="${module}"]//*[@title="Close"]

Validate Rebate Tiers
    [Arguments]  ${module}
    wait until element is visible  //div[@id="${module}"]  10  Module ${module} did not display

    click element  xpath=//div[@id="${module}"]//*[@title="Close"]