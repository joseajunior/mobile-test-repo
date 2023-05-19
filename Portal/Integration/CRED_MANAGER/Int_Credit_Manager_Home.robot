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
Credit Manager Home - Basic
    [Tags]  qTest:34015499  refactor
    The Page Displays All Elements
    Search For A Card  ${validCard.num}  ${validCard.carrier.id}


*** Keywords ***
Set Up Suite
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Credit Manager
    Wait Until Page Contains  text=Credit Manager  timeout=30

Search For A Card
    [Arguments]  ${cardNum}  ${carrierID}

    Input Text  searchValue  ${cardNum}
    Click Portal Button  Search
    Run Keyword And Ignore Error  Wait Until Element Is Visible    //*[text()="Please wait while your search is processed..."]
    Run Keyword And Ignore Error  Wait Until Element Is Not Visible  //*[text()="Please wait while your search is processed..."]  timeout=60
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=30
    Page Should Contain Element  //*[@id="resultsTable"]//*[contains(text(),'${carrierID}')]

The Page Displays All Elements

    Page Should Contain  text=Carrier ID
    Page Should Contain  text=AR Number
    Page Should Contain  text=Contract ID
    Page Should Contain  text=Name
    Page Should Contain  text=Issuer Group
    Page Should Contain  text=Search Field
    Page Should Contain  text=Condition
    Page Should Contain  text=Search Value
    Page Should Contain  text=Authenticate Caller
    Page Should Contain  text=Accessed

