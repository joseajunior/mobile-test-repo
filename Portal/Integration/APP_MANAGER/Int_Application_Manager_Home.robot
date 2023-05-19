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
Force Tags  Integration  Shifty  Portal  run
Test Teardown  Return to application manager

*** Variables ***
@{elements_list}  App ID  Wkfw ID  Acct Org  Card Type  Status  Company  City  S/P  Vehicles  Revenue  Inside Rep  Outside Rep  Last Updated  MSA  Credit Done

*** Test Cases ***

Search And Open An Application With Card Type Filter
    [Tags]  qTest:31182373
    [Documentation]  This is to test if an application can be searched using card type filter
    ...  also once the results are pulled, checking if all the columns are sortable
    ...  Per Ryan Picket on Aug 28th 2020:
    ...  "We will add your request to our upcoming sprint, and someone will reach out to you when we are ready to help out."
    search for an application  cardType=Smart Pay
    Select Labels  cardType  Smart Pay
    Check If Smart Pay Is On The Page
    Check If All The Elements Are Enabled
    Verify Company Info & Sales Information

Search And Open An Application With Status Filter
    [Tags]  qTest:31182579
    [Documentation]  This is to test if an application can be searched using status filter
    search for an application  cardType=All  Status=Complete
    Check If The Search Was Completed
    Verify Company Info & Sales Information

Search And Open An Application With Credit Line Type Filter
    [Tags]  qTest:31182580
    [Documentation]  This is to test if an application can be searched using Credit Line Type filter
    search for an application  Status=All  Limit Type=Open Line (OAC) Request

*** Keywords ***

Check If All The Elements Are Enabled
    :FOR    ${item}     IN      @{elements_list}
     Element Should Be Enabled  //*[@id="resultsTable"]//*[contains(@class,'sort')]/div[contains(string(),'${item}')]
    END

Verify Company Info & Sales Information
    Double Click Element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]
    Wait Until Page Contains  text=Company Info & Sales  timeout=20
    Refresh Page

Select Labels
    [Arguments]  ${option}  ${selection}
    Select From List By Label  ${option}  ${selection}

Apply The Search
    Click Portal Button  Search

Check If Smart Pay Is On The Page
    Wait For Search Results
    Page Should Contain Element  xpath=//*[@id="resultsTable"]//descendant::*[contains(text(),'Smart Pay')]

Check If The Search Was Completed
    Wait For Search Results
    Page Should Contain Element  xpath=//*[@id="resultsTable"]//descendant::*[contains(text(),'Complete')]  timeout=120

Wait For Search Results
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Done Processing

Time To Setup
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Application Manager