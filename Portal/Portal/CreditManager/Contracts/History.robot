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
Suite Teardown  Delete User and Close All Browsers
Force Tags  Portal  Credit Manager  run
Documentation  Updates the values of history panel on the credit manager page

*** Variables ***
${payment_value}  50
${adjustment_amount}  5400
${trans_code}  1505
${description}  test
${user}  port482
${user_password}  test123
${domain}  @efsllc
${max_iterations}  300
${ar_oracle_group_id}  21
${credit_dept_group_id}  27

*** Test Cases ***
View Button Should Work As Expected
    [Tags]  JIRA:PORT-482  qTest:  Regression
    [Documentation]  This is to test if a user can select and use View button
    [Setup]  Open History Tab
    Search For Invoices
    Select First
    View Button Should Work As Expected

Download Button Should Work As Expected
    [Tags]  JIRA:PORT-482  qTest:  Regression
    [Documentation]  This is to test if a user can select and use Download button
    Select First
    Download Button Should Work As Expected

Approve Button Should Work As Expected
    [Tags]  JIRA:PORT-482  qTest:  Regression
    [Documentation]  This is to test if a user can select and use Approve button
    Search For Adjustments
    Select Pending Adjustment
    Approve Button Should Work As Expected

Cancel Button Should Work As Expected
    [Tags]  JIRA:PORT-482  qTest:  Regression
    [Documentation]  This is to test if a user can select and use Cancel button
    [Setup]  Create Payment
    Search For Payments
    Select First
    Cancel Button Should Work As Expected

Reset Button Should Work As Expected
    [Tags]  JIRA:PORT-482  qTest:  Regression
    [Documentation]  This is to test if a user can select and use Reset button
    Search For Payments
    Select First
    Reset Button Should Work As Expected

*** Keywords ***
Setup
    Create User And Make A Payment
    Open Browser to portal
    Log Into Portal
    Open Contract

Open Contract
    Get Valid Contract  ${ENVIRONMENT}
    Select Portal Program  Credit Manager
    Search Contract  ${contractID}  ${carrierID}
    Select Contract

Get Valid Contract
    [Arguments]  ${database}
    pyString.Convert To Lowercase  ${database}
    ${contractID}=  Set Variable If  '${database}'=='acpt' or '${database}'=='dit'  19169
    ${carrierID}=  Set Variable If  '${database}'=='acpt' or '${database}'=='dit'  122033
    ...  ELSE  log to console  ${database}
    Set Suite Variable  ${contractID}  ${contractID}
    Set Suite Variable  ${carrierID}  ${carrierID}

Search Contract
    [Arguments]  ${contractID}  ${carrierID}
    Wait Until Element Is Enabled  request.search.contractId  timeout=60
    Send Text To Element  request.search.contractId  39480
    Wait Until Element Is Enabled  request.search.carrierId  timeout=60
    Send Text To Element  request.search.carrierId  894726
    Click Portal Button  Search

Select Contract
    Wait Until Done Processing
    Wait Until Element Is Enabled  xpath://*[@id="resultsTable"]  timeout=120
    Double Click Element  xpath://*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table

Open History Tab
    Wait Until Element Is Visible  xpath=//span[contains(text(),'History')]  timeout=320
    Click Element  xpath=//span[contains(text(),'History')]
    Wait Until Element Is Visible  //*[@id="historyview"]//descendant::*[@class="jimg jdown"]  timeout=10

Select First
    Click Element  //*[@id="historyList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[3]/div

View Button Should Work As Expected
    Element Should Be Enabled  //*[@id="historyview"]//descendant::*[@class="jimg jview"]
    Click Element  //*[@id="historyview"]//descendant::*[@class="jimg jview"]
    Page Should Contain Element  //*[@id="cashapps_content"]
    Page Should Contain  Amount
    Page Should Contain  Total
    Page Should Contain  Remaining
    Page Should Contain  Description
    Page Should Contain  Type
    Click Portal Button  Close

Download Button Should Work As Expected
    Element Should Be Enabled  //*[@id="historyview"]//descendant::*[@class="jimg jdown"]
    Click Element  //*[@id="historyview"]//descendant::*[@class="jimg jdown"]
    Sleep  3
    ${titles}  Get Window Titles
    Select Window  title=@{titles}[1]
    Close Window
    ${titles}  Get Window Titles
    Select Window  title=@{titles}[0]

Create Payment
    Click Element  //*[@id="historyview"]//descendant::*[@class="jimg jcard"]
    Wait Until Element Is Visible  request.achTransBean.draftAmt  timeout=10
    Input Text  request.achTransBean.draftAmt  ${payment_value}
    Click Element  //*[@id="payment_content"]//descendant::*[@class="jimg jsave"]
    Click Element  //*[@id="confirmsave_content"]//descendant::*[@class="jimg jok"]
    Wait Until Done Processing

Cancel Button Should Work As Expected
    Element Should Be Enabled  //*[@id="historyview"]//descendant::*[@class="jimg jcancel"]
    Click Element  //*[@id="historyview"]//descendant::*[@class="jimg jcancel"]
    Click Element  //*[@id="confirm_content"]//descendant::*[@class="jimg jok"]
    Wait Until Done Processing

Reset Button Should Work As Expected
    Element Should Be Enabled  //*[@id="historyview"]//descendant::*[@class="jimg jreset"]
    Click Element  //*[@id="historyview"]//descendant::*[@class="jimg jreset"]
    Click Element  //*[@id="confirm_content"]//descendant::*[@class="jimg jok"]
    Wait Until Done Processing

Search For Payments
    Select From List By Label  display  Payments
    Set Date For Today
    Click Element  //*[@class="jimg jagree"]
    Wait Until Done Processing

Create An Adjustment
    Click Element  //*[@id="historyview"]//descendant::*[@class="jimg jcalc"]
    Sleep  2
    Input Text  request.openInvoicesAdjustments[0].amount  ${adjustment_amount}
    Select From List By Value  request.openInvoicesAdjustments[0].transCode  ${trans_code}
    Input Text  request.openInvoicesAdjustments[0].description  ${description}
    Select Checkbox  __request.openInvoicesAdjustments[0].selected
    Click Element  //*[@id="adjustment_content"]//descendant::*[@class="jimg jsave"]
    Click Element  //*[@id="confirmsave_content"]//descendant::*[@class="jimg jok"]
    Wait Until Done Processing

Search For Adjustments
    Select From List By Label  display  Adjustments
    Set Date For Today
    Click Element  //*[@class="jimg jagree"]
    Wait Until Done Processing

Search For Invoices
    Select From List By Label  display  Invoices
    Input Text  //*[@id="histStartDate"]  2019-11-01
    Click Element  //*[@class="jimg jagree"]
    Wait Until Done Processing

Approve Button Should Work As Expected
    Element Should Be Enabled  //*[@id="historyview"]//descendant::*[@class="jimg jok"]
    Click Element  //*[@id="historyview"]//descendant::*[contains(text(),'Approve')]
    Click Element  //*[@id="confirm_content"]//descendant::*[@class="jimg jok"]
    Wait Until Done Processing
    Run Keyword And Ignore Error  Click Element  //*[@id="error_content"]//descendant::*[@class="jimg jok"]
    Sleep  2

Set Date For Today
    ${date}=  getdatetimenow  %Y-%m-%d
    Input Text  //*[@id="histStartDate"]  ${date}
    Input Text  //*[@id="histEndDate"]  ${date}

Select Pending Adjustment
    Click Element  //*[@id="historyList"]//descendant::*[contains(text(),'PENDING')]

Create User And Make A Payment
    Open Browser And Login To Portal
    Go To Users Administration
    Create User  ${user}  ${user_password}
    Wait Until Done Processing
    Set Group  ${credit_dept_group_id}
    Set Group  ${ar_oracle_group_id}
    Close Edit Page
    Close Browser
    Login With New User
    Make An Adjustment
    Close Browser

Go To Users Administration
    Wait Until Element Is Visible  //*[@id="pm_0"]  timeout=60
    Click Element  //*[@id="pm_0"]//following-sibling::*[1]
    Click Element  //*[@id="pm_1.0"]
    Wait Until Element Is Visible  //*[@id="userListTable"]  timeout=60

Create User
    [Arguments]  ${user}  ${password}
    Click Portal Button  Add
    Wait Until Done Processing
    Wait Until Element Is Visible  request.user.userid  timeout=60
    Input Text  request.user.userid  ${user}
    Input Text  request.user.name  Portal Test User
    Input Text  passwordNew  ${password}
    Input Text  _password  ${password}
    Save

Close Edit Page
    Wait Until Element Is Visible  xpath=//*[@id="usergroups"]//descendant::*[contains(text(),'Close')]  timeout=30
    Click Element  xpath=//*[@id="usergroups"]//descendant::*[contains(text(),'Close')]

Save
    Wait Until Element Is Enabled  xpath=//*[@id="userdata"]/form/a[1]  timeout=60
    Click Element  xpath=//*[@id="userdata"]/form/a[1]

Login With New User
    Open Browser And Login To Portal  ${user}${domain}  ${user_password}

Make An Adjustment
    Open Contract
    Open History Tab
    Create An Adjustment
    Sleep  2
    Close Browser

Open Browser And Login To Portal
    [Arguments]  ${user}=${PortalUsername}  ${password}=${PortalPassword}
    Open Browser to portal
    ${status}=  Log Into Portal  ${user}  ${password}
    wait until keyword succeeds  30s  5s  Log In Bandage  ${status}  ${user}  ${password}
    #TODO: remove Log In Bandage once 408 fix is implemented

Set Group
    [Arguments]  ${group_id}
    Wait Until Element Is Visible  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    Wait Until Element Is Enabled  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    Click Element  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]
    Wait Until Element Is Enabled  requestScope.userGroups[0].userid  timeout=120
    :FOR  ${i}  IN RANGE  0  ${max_iterations}
        ${status}  Run Keyword And Return Status  Page Should Contain Element  request.userGroups[${i}].groupId
        Run Keyword If  '${status}'=='${False}'  Exit For Loop
        wait until page contains element  request.userGroups[${i}].groupId  timeout=120
        ${value}=  Get Value  request.userGroups[${i}].groupId
        Run Keyword If  '${value}'=='${group_id}'  Run Keywords
        ...  Scroll Element Into View  requestScope.userGroups[${i}].userid
        ...  AND  wait until element is visible  requestScope.userGroups[${i}].userid  timeout=30
        ...  AND  wait until element is enabled  requestScope.userGroups[${i}].userid  timeout=120
        ...  AND  Click Element  requestScope.userGroups[${i}].userid
        ...  AND  Exit For Loop
    END
    Click Element  xpath=//*[@id="usergroups"]//descendant::*[contains(text(),'Save')]
    #TODO: Use Wait Until Changes are Saved keyword instead this Sleep
    Sleep  5

Delete User and Close All Browsers
    Click Element  //*[@id="pmd_home"]
    Go To Users Administration
    Delete User  ${user}
    Close All Browsers

Delete User
    [Arguments]  ${user}
    Scroll Element Into View  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]
    wait until element is visible  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=120
    wait until element is enabled  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=120
    Click Element  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]
    Wait Until Element Is Enabled  //*[@id="userlist"]/a[3]  timeout=120
    Click Element  //*[@id="userlist"]/a[3]
    Wait Until Element Is Enabled  //*[@id="deleteConfirm_content"]/div[2]/a[1]  timeout=30
    Click Element  //*[@id="deleteConfirm_content"]/div[2]/a[1]
    Wait Until Page Does Not Contain  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=30
    Sleep  3