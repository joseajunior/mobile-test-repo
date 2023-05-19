*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  String
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Suite Setup  Setup
Suite Teardown  Close All Browsers
Force Tags  Portal  Credit Manager
Documentation  Updates the values of trends panel on the credit manager page

*** Variables ***
@{trends_elements}  Status  Language  Currency  Terms  Billing Cycle  Limit Method  Allowed Overrides  Credit Limit
...  Daily Limit  Deposit  Past Due Amt  Curr Due Amt  Unbilled Amt  Total Owed  Created  Closed  Last Trans  DBT
...  Next Review  Fuel  Fuel Volume  Merchandise  Cash  Money Codes

*** Test Cases ***
Verify Resolution Dropdown Options Returns The Correct Results
    [Tags]  JIRA:PORT-403  qTest:  Regression
    [Documentation]  This is to test if a user can select and use Resolution dropdown
    [Setup]  Open Trends Tab
    Resolution Dropdown Has The Correct Options
    Resolution Dropdown Returns The Correct Results

Verify Date Range Options Returns The Correct Results
    [Tags]  JIRA:PORT-403  qTest:  Regression
    [Documentation]  This is to test if a user can select and use Date Range options
    Set Values For Date Range
    Date Range Returns The Correct Results

Verify View Level Dropdown Options Returns The Correct Results
    [Tags]  JIRA:PORT-403  qTest:  Regression
    [Documentation]  This is to test if a user can select and use View Level dropdown
    View Level Dropdown Has The Correct Options
    View Level Dropdown Returns The Correct Results

Verify The Buttons At The Bottom Of The Page Work Correctly
    [Tags]  JIRA:PORT-403  qTest:  Regression
    [Documentation]  This is to test if a user can select and use the buttons at the bottom of the page
    Adjustment Button Works Correctly
    Payment Button Works Correctly
    Bank Accounts Button Works Correctly
    Comments Button Works Correctly

*** Keywords ***
Setup
    Open Browser to portal
    Log Into Portal
    Get Valid Contract  ${ENVIRONMENT}
    Select Portal Program  Credit Manager
    Search Contract  ${contractID}  ${carrierID}
    Select Contract

Get Valid Contract
    [Arguments]  ${database}
    ${carrier}  Find Carrier in Oracle  A
    ${query}=  catenate  select contract_id from contract where carrier_id = ${carrier}
    ${contract}=  query and strip  ${query}
    set suite variable  ${carrierID}  ${carrier}
    set suite variable  ${contractID}  ${contract}

Search Contract
    [Arguments]  ${contractID}  ${carrierID}
    Wait Until Element Is Enabled  request.search.contractId  timeout=60
    Input Text  request.search.contractId  ${contractID}
    Wait Until Element Is Enabled  request.search.carrierId  timeout=60
    Input Text  request.search.carrierId  ${carrierID}
    Click Portal Button  Search

Select Contract
    Wait Until Done Processing
    Wait Until Element Is Enabled  xpath://*[@id="resultsTable"]  timeout=120
    Double Click Element  xpath://*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table

Open Trends Tab
    Wait Until Element Is Visible  xpath=//span[contains(text(),'Trends')]  timeout=320
    Click Element  xpath=//span[contains(text(),'Trends')]
    Sleep  10

Adjustment Button Works Correctly
    Execute JavaScript  window.scrollTo(0,5000)
    Page Should Contain Element  xpath=//span[contains(text(),'Adjustment')]
    Click Element  //*[@id="trendsview"]//descendant::*[@class="jimg jcalc"]
    Wait Until Element Is Visible  //*[@id="adjustment_content"]  timeout=5
    Page Should Contain Element  //*[@id="adjustment_content"]
    Click Element  //*[@id="adjustment_content"]//descendant::*[@class="jimg jclose"]

Payment Button Works Correctly
    Page Should Contain Element  xpath=//span[contains(text(),'Payment')]

Bank Accounts Button Works Correctly
    Page Should Contain Element  xpath=//span[contains(text(),'Bank Accounts')]
    Click Element  //*[@id="trendsview"]//descendant::*[@class="jimg jbank"]
    Wait Until Element Is Visible  //*[@id="bankInfo_content"]  timeout=5
    Page Should Contain Element  //*[@id="bankInfo_content"]
    Click Element  //*[@id="bankInfo_content"]//descendant::*[@class="jimg jclose"]

Comments Button Works Correctly
    Page Should Contain Element  xpath=//span[contains(text(),'Comments')]
    Click Element  //*[@id="trendsview"]//descendant::*[@class="jimg jcomment"]
    Wait Until Element Is Visible  //*[@id="comments_content"]  timeout=5
    Page Should Contain Element  //*[@id="comments_content"]
    Click Element  //*[@id="comments_content"]//descendant::*[@class="jimg jclose"]

Resolution Dropdown Has The Correct Options
    ${resolutions}  Get List Items  resolution
    List Should Contain Value  ${resolutions}  Day
    List Should Contain Value  ${resolutions}  Week
    List Should Contain Value  ${resolutions}  Month

View Level Dropdown Has The Correct Options
    ${view_levels}  Get List Items  viewLevel
    List Should Contain Value  ${view_levels}  Contract
    List Should Contain Value  ${view_levels}  Carrier

Resolution Dropdown Returns The Correct Results
    Select From List By Label  resolution  Week
    Submit And Verify If All Elements Are Loaded

View Level Dropdown Returns The Correct Results
    Select From List By Label  viewLevel  Carrier
    Submit And Verify If All Elements Are Loaded

Set Values For Date Range
    ${start_date}  getdatetimenow  %Y-%m-%d  days=-7
    ${end_date}=  getdatetimenow  %Y-%m-%d
    Input Text  //*[@id="trendsStartDate"]  ${start_date}
    Input Text  //*[@id="trendsEndDate"]  ${end_date}

Date Range Returns The Correct Results
    Submit And Verify If All Elements Are Loaded

Submit And Verify If All Elements Are Loaded
    Click Element  //*[@class="jimg jagree"]
    Wait Until Done Processing
    Trends Elements Are Visible

Trends Elements Are Visible
    Page Should Contain Element  //*[@id="trendGraph"]
    FOR  ${element}  IN  @{trends_elements}
      Page Should Contain  ${element}
    END