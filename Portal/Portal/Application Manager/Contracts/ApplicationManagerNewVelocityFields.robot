*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Test Teardown    Close Browser

*** Variables ***
${PortalIrvingUsername}    robot_irv@irving
${PortalEFSUsername}    robot_efs@efsllc
${daily_selector}    achVelocity
${weekly_selector}    achWklyVelocity
${monthly_selector}    achMthlyVelocity
${daily_column}    ach_velocity
${weekly_column}    ach_wkly_velocity
${monthly_column}    ach_mthly_velocity

*** Test Cases ***
Credit Setup Weekly and Monthly Irving Velocity Fields
    [Tags]  JIRA:PORT-725  JIRA:BOT-3661  qTest:56020143
    [Documentation]  Ensure the new weekly and monthly velocity fields are available and working as expected

    Open Browser And Login To Portal With Irving Domain
    Open Application Manager and Create New App for Irving
    Create Contract For New App
    Get Back to Search Application Screen
    Search and Open Application
    Open Contract From Application
    Check Velocity Fields in Contract

EFS Domain Credit Setup New Velocity Fields
    [Tags]  JIRA:PORT-725  JIRA:BOT-3661  qTest:56032007
    [Documentation]  Ensure the new velocity fields are read only for irving application and is not displayed for other applications

    Open Browser And Login To Portal With EFS Domain
    Open Application Manager and Create New App
    Assert Contract Creation has no New Velocity Fields
    Get Back to Search Application Screen
    Search and Open Irving Application
    Assert Contract Has New Velocity Fields Read Only

*** Keywords ***
Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=5

Open Browser And Login To Portal With EFS Domain
    [Documentation]  Login to portal with efs domain user

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalEFSUsername}    ${PortalPassword}

Open Browser And Login To Portal With Irving Domain
    [Documentation]  Login to portal with irving domain user

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalIrvingUsername}  ${PortalPassword}

Open Application Manager and Create New App
    [Documentation]  Open Application Manager menu option and add new application

     Select Portal Program  Application Manager
     ${application_id}=  Create Application
     Click Element    //*[@id="success_caption"]/div
     Set Test Variable  ${application_id}

Open Application Manager and Create New App for Irving
    [Documentation]  Open Application Manager menu option and add new irving application

     Select Portal Program  Application Manager
     ${application_id}=  Create Application    org_id=Irving Oil Marketing    sales=13 - Sales Fulfillment 3
     Click Element    //*[@id="success_caption"]/div
     Set Test Variable  ${application_id}

Open Contracts Tab
    [Documentation]  Open contracts tab for new application

     Wait Until Element is Visible    //*[@id="application"]//span[text()='Contracts']
     Click Element    //*[@id="application"]//span[text()='Contracts']

Click to Add New Contract
    [Documentation]  Click the Add button to create new contract

    Wait Until Element is Visible    //*[@id="contractListDiv"]//span[text()='Add']
    Click Element    //*[@id="contractListDiv"]//span[text()='Add']

Open Credit Setup Tab
    [Documentation]  Open the credit setup tab in contract creation

    Wait Until Element is Visible    //*[@id="contractForm"]//span[text()='Credit Setup']
    Click Element    //*[@id="contractForm"]//span[text()='Credit Setup']

Set Velocity Fields Value
    [Arguments]    ${daily}=5    ${weekly}=10    ${monthly}=15
    [Documentation]  Input values to the new daily, weekly and monthly velocity fields

    Wait Until Element is Visible    name=request.contract.${daily_selector}
    Input Text    name=request.contract.${daily_selector}    ${daily}
    Input Text    name=request.contract.${weekly_selector}    ${weekly}
    Input Text    name=request.contract.${monthly_selector}    ${monthly}

Click to Save Contract
    [Documentation]  Click the save button to save info on new contract

    Wait Until Element is Visible    //*[@id="saveButton"]//span[text()='Save']
    Click Element    //*[@id="saveButton"]//span[text()='Save']

Get Workflow Id From Contract
    [Documentation]  Get the workflow id generated for new contract

    ${workflow_id}    Get Text    //*[@id="contractForm"]//div[text()='Workflow ID:']/following-sibling::div[1]
    Set Test Variable  ${workflow_id}

Get and Check Velocity Value From DB
    [Arguments]    ${query_result}    ${period_selector}    ${value}
    [Documentation]  Compare the velocity value

    ${db_value}  Get From Dictionary  ${query_result}  ${period_selector}
    Should Be Equal As Numbers    ${db_value}    ${value}

Check Velocities in Database
    [Arguments]    ${daily}=5    ${weekly}=10    ${monthly}=15
    [Documentation]  Check velocity value set in database

    Get Into DB  TCH
    ${query}  Catenate  SELECT ach_velocity, ach_wkly_velocity, ach_mthly_velocity
    ...    FROM wrkflw_contract
    ...    WHERE wrkflw_contract_id = ${workflow_id};
    ${query_result}  Query And Strip To Dictionary  ${query}
    Get and Check Velocity Value From DB    ${query_result}    ${daily_column}    ${daily}
    Get and Check Velocity Value From DB    ${query_result}    ${weekly_column}    ${weekly}
    Get and Check Velocity Value From DB    ${query_result}    ${monthly_column}    ${monthly}

Create Contract For New App
    [Documentation]  Create a contract inside the recently added application setting velocity fields

    Open Contracts Tab
    Click to Add New Contract
    Wait Until Done Processing
    Select From List By Label    name=request.contract.cardType    Irving Heavy Fleet
    Open Credit Setup Tab
    Set Velocity Fields Value
    Click to Save Contract
    Wait Until Done Processing
    Get Workflow Id From Contract
    Check Velocities in Database

Return To Contracts List
    [Documentation]  Return to contracts list screen from the application

    Wait Until Element is Visible    //*[@id="contractForm"]//span[text()='Return']
    Click Element    //*[@id="contractForm"]//span[text()='Return']

Return To Search Application
    [Documentation]  Return to search application screen

    Wait Until Element is Visible    //*[@id="contractListDiv"]//span[text()='Return']
    Click Element    //*[@id="contractListDiv"]//span[text()='Return']
    Wait Until Element is Visible    //*[@id="searchForm"]//span[text()='Search']

Confirm Return Discarding Changes
    [Documentation]  Confirm discarding changes

    Click Element    //*[@id="confirm_content"]//span[text()='Yes']

Get Back to Search Application Screen
    [Documentation]  Go back to search application screen

    ${status}    Run Keyword and Return Status    Page Should Contain Element    //*[@id="msacl"]//span
    Run Keyword If    ${status}    Click Element    //*[@id="msacl"]//span
    Element Should Not Be Visible    //*[@id="msacl"]//span
    Return To Contracts List
    ${status}    Run Keyword and Return Status    Page Should Contain Element    //*[@id="confirm_content"]//span[text()='Yes']
    Run Keyword If    ${status}    Confirm Return Discarding Changes
    Return To Search Application

New Velocity Fields Not Displayed
    [Documentation]  Assert page does not contain new velocity fields

    Page Should Not Contain Element    name=request.contract.${daily_selector}
    Page Should Not Contain Element    name=request.contract.${weekly_selector}
    Page Should Not Contain Element    name=request.contract.${monthly_selector}

Assert Contract Creation has no New Velocity Fields
    [Documentation]  Check if new velocity fields are not displayed in credit setup tab

    Open Contracts Tab
    Click to Add New Contract
    Wait Until Done Processing
    Open Credit Setup Tab
    New Velocity Fields Not Displayed

Select From Table
    [Arguments]    ${path}
    [Documentation]  Select element from table with double click

    Wait Until Element is Visible    ${path}
    Double Click On    ${path}

Open Contract By Workflow Id
    [Documentation]    Opens contract by workflow id set as test variable

    Select From Table    //*[@id="contractList"]//div[text()='${workflow_id}']

Open Application By App Id
    [Documentation]    Opens contract by app id set as test variable

    Select From Table    //*[@id="resultsTable"]//*[text()='${application_id}']

Search Application by Id
    [Documentation]  Search application by app id

    Select From List By Label    name=searchField    Application ID*
    Select From List By Label    name=searchCondition    Equals
    Input Text    name=searchValue    ${application_id}
    Click Element    //*[@id="searchForm"]//span[text()='Search']
    Wait Until Done Processing

Search and Open Application
    [Documentation]  Do a search by app id and open the application from result

    Search Application by Id
    Open Application By App Id
    Wait Until Done Processing

Search and Open Irving Application
    [Documentation]  Do a search by irving app and open the irving application from result

    Select From List By Label    name=cardType    Irving Heavy Fleet
    Click Element    //*[@id="searchForm"]//span[text()='Search']
    Wait Until Done Processing
    Select From Table    //*[@id="resultsTable"]/tbody/tr[2]//tr[1]

New Velocity Fields Read Only
    [Documentation]  Check if page contains velocity fields as read only

    Page Should Contain Element    //*[@name='request.contract.${daily_selector}' and @readonly]
    Page Should Contain Element    //*[@name='request.contract.${weekly_selector}' and @readonly]
    Page Should Contain Element    //*[@name='request.contract.${monthly_selector}' and @readonly]

Open Credit Setup and Check New Velocity Fields
    [Documentation]  Assert the new velocity fields are read only

    Wait Until Done Processing
    Open Credit Setup Tab
    New Velocity Fields Read Only

Assert Contract Has New Velocity Fields Read Only
    [Documentation]  Check if new velocity fields are read only in credit setup for irving application

    Open Contracts Tab
    Select From Table    //*[@id="contractList"]/tbody/tr[2]//tr
    Open Credit Setup and Check New Velocity Fields
    Return To Contracts List
    Click to Add New Contract
    Open Credit Setup and Check New Velocity Fields

Open Contract From Application
    [Documentation]  Open contract by workflow id from application

    Open Contracts Tab
    Open Contract By Workflow Id

Get and Check Velocity Value
    [Arguments]    ${period_selector}    ${value}
    [Documentation]  Check velocity field value from screen

    ${velocity}    Get Value    name=${period_selector}
    Should Be Equal As Numbers    ${velocity}    ${value}

Check Velocity Fields in Contract
    [Documentation]  Assert velocity fields values set

    Open Credit Setup Tab
    Get and Check Velocity Value    request.contract.${daily_selector}    5
    Get and Check Velocity Value    request.contract.${weekly_selector}    10
    Get and Check Velocity Value    request.contract.${monthly_selector}    15