*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Suite Setup    Setup Contract Data
Test Teardown    Close Browser

*** Variables ***
${PortalIrvingUsername}    robot_irv@irving
${PortalEFSUsername}    robot_efs@efsllc
${daily_selector}    achVelocity
${weekly_selector}    achWklyVelocity
${monthly_selector}    achMthlyVelocity
${irving_contract}
${irving_ab_contract}
${efs_contract}
${ar_number}

*** Test Cases ***
Payment Weekly and Monthly Irving Velocity Fields
    [Tags]  JIRA:PORT-725  JIRA:BOT-3661  qTest:56020167
    [Documentation]  Ensure the payment tab in contracts has the new velocity fields and works accordingly to the limits

    Open Browser And Login To Portal With Irving Domain
    Open Credit Manager
    Search and Open Contract By Id    ${irving_contract}
    Open Payment Tab
    Check Velocity Fields
    Set Empty Velocity Values and Save
    Do a Payment and Check for Error Pop Up    Tools    False
    Do a Payment and Check for Error Pop Up    History    False
    Set Lower Value for Velocity Fields and Save
    Do a Payment and Check for Error Pop Up    Tools    True
    Do a Payment and Check for Error Pop Up    History    True
    Set Higher Value for Velocity Fields and Save    Irving
    Do a Payment and Check for Error Pop Up    Tools    False
    Do a Payment and Check for Error Pop Up    History    False
    Return To Credit Manager Search Screen
    Search and Open Contract By Id    ${irving_ab_contract}
    Open Payment Tab
    Check Velocity Fields
    Set Empty Velocity Values and Save
    Do a Payment and Check for Error Pop Up    Tools    False
    Do a Payment and Check for Error Pop Up    History    False
    Set Lower Value for Velocity Fields and Save
    Do a Payment and Check for Error Pop Up    Tools    True
    Do a Payment and Check for Error Pop Up    History    True
    Set Higher Value for Velocity Fields and Save
    Do a Payment and Check for Error Pop Up    Tools    False
    Do a Payment and Check for Error Pop Up    History    False

EFS Domain Payment New Velocity Fields
    [Tags]  JIRA:PORT-725  JIRA:BOT-3661  qTest:56032227
    [Documentation]  Ensure the new velocity fields are not displayed in contract's payment tab

    Open Browser And Login To Portal With EFS Domain
    Open Credit Manager
    Search and Open Contract By Id    ${irving_contract}
    Open Payment Tab
    Assert New Velocity Fields are not Displayed
    Return To Credit Manager Search Screen
    Search and Open Contract By Id    ${irving_ab_contract}
    Open Payment Tab
    Assert New Velocity Fields are not Displayed
    Return To Credit Manager Search Screen
    Search and Open Contract By Id    ${efs_contract}
    Open Payment Tab
    Assert New Velocity Fields are not Displayed

*** Keywords ***
Setup Contract Data
    [Documentation]  Setup an irving, irving affiliate billing and efs contracts

    Get Into DB    Irving
    ${irving_contract_query}    Catenate    SELECT distinct c.contract_id
    ...    FROM contract c
    ...    INNER JOIN ach_trans a
    ...    ON c.ar_number = a.ar_number
    ...    WHERE c.status = 'A'
    ...    ORDER BY contract_id DESC
    ...    LIMIT 10;
    ${irving_contract}  Query And Strip  ${irving_contract_query}
    Set Suite Variable    ${irving_contract}
    Get Into DB    TCH
    ${irving_ab_contract_query}    Catenate    SELECT distinct c.contract_id
    ...    FROM contract c
    ...    INNER JOIN ach_trans a
    ...    ON c.ar_number = a.ar_number
    ...    WHERE c.status = 'A'
    ...    AND issuer_id = 194497
    ...    ORDER BY contract_id DESC
    ...    LIMIT 10;
    ${irving_ab_contract}  Query And Strip  ${irving_ab_contract_query}
    Set Suite Variable    ${irving_ab_contract}
    ${efs_contract_query}    Catenate    SELECT distinct c.contract_id
    ...    FROM contract c
    ...    INNER JOIN ach_trans a
    ...    ON c.ar_number = a.ar_number
    ...    WHERE c.status = 'A'
    ...    AND issuer_id != 194497
    ...    AND contract_id NOT IN (1323122, 1322914, 1322905, 1322849, 1312696)
    ...    ORDER BY contract_id DESC
    ...    LIMIT 10;
    ${efs_contract}  Query And Strip  ${efs_contract_query}
    Set Suite Variable    ${efs_contract}

Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}
    [Documentation]  Login to portal and check if home menu is displayed

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=10

Open Browser And Login To Portal With EFS Domain
    [Documentation]  Open browser and login to portal with efs domain, retries 5x until login is successfull

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalEFSUsername}    ${PortalPassword}

Open Browser And Login To Portal With Irving Domain
    [Documentation]  Open browser and login to portal with irving domain, retries 5x until login is successfull

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalIrvingUsername}  ${PortalPassword}

Open Credit Manager
    [Documentation]  Open Credit Manager menu option

    Select Portal Program  Credit Manager
    Wait Until Element is Visible    //*[@id="searchForm"]//span[text()='Search']

Wait While Loading
    [Documentation]  Wait until loading pop up is not visible

    Wait Until Element is not Visible    //*[@id="wait_caption"]/span[text()='PLEASE WAIT']

Search and Open Contract By Id
    [Arguments]    ${contract_id}
    [Documentation]  Search contract by contract id and open it

    Reload Page
    Wait Until Element is Visible    name=request.search.contractId
    Input Text    name=request.search.contractId    ${contract_id}
    Click Element    //*[@id="searchForm"]//span[text()='Search']
    Wait While Loading
    ${ar_number}    Get Text    //*[@id="resultsTable"]//div[text()='${contract_id}']//parent::td/preceding-sibling::td[1]
    Set Test Variable    ${ar_number}
    Double Click On    //*[@id="resultsTable"]//div[text()='${contract_id}']
    Wait Until Page Contains    Contract Information

Open Payment Tab
    [Documentation]  Open payment tab from contract

    Click Element    //*[@id="creditForm"]/div[1]//span[text()='Payment']
    Wait Until Page Contains    Payment Setup

Open History Tab
    [Documentation]  Open history tab from contract

    Click Element    //*[@id="accountDetail"]//span[text()='History']
    Wait Until Page Contains Element    //*[@id="historyview"]//span[text()='Payment']

Check Velocity Fields
    [Documentation]  Check if page contains new velocity fields

    Page Should Contain Element    name=request.contract.${daily_selector}
    Page Should Contain Element    name=request.contract.${weekly_selector}
    Page Should Contain Element    name=request.contract.${monthly_selector}

Set Velocity Fields Value
    [Arguments]    ${daily}=1    ${weekly}=1    ${monthly}=1
    [Documentation]  Input value to new daily, weekly and monthly velocity fields

    Wait Until Element is Visible    name=request.contract.${daily_selector}
    Input Text    name=request.contract.${daily_selector}    ${daily}
    Input Text    name=request.contract.${weekly_selector}    ${weekly}
    Input Text    name=request.contract.${monthly_selector}    ${monthly}

Clear Velocity Fiels
    [Documentation]  Remove any value from new velocity fields

    Wait Until Element is Visible    name=request.contract.${daily_selector}
    Clear Element Text    name=request.contract.${daily_selector}
    Clear Element Text    name=request.contract.${weekly_selector}
    Clear Element Text    name=request.contract.${monthly_selector}

Click to Save Contract
    [Documentation]  Click to save new info from the contract

    Wait Until Element is Visible    //*[@id="saveContractForm"]//span[text()='Save']
    Click Element    //*[@id="saveContractForm"]//span[text()='Save']
    ${status}    Run Keyword and Return Status    Wait Until Element Is Visible    //*[@id="saveConfirm_content"]//span[text()='Yes']    timeout=5
    Run Keyword If    ${status}    Click Element    //*[@id="saveConfirm_content"]//span[text()='Yes']
    Wait While Loading
    Wait Until Element is Visible    //*[@id="alert_caption"]/span[text()='ALERT']
    Click Element    //*[@id="alert_content"]//span[text()='OK']

Set Empty Velocity Values and Save
    [Documentation]  Set new velocity fields as null and save the contract

    Clear Velocity Fiels
    Click to Save Contract

Set Lower Value for Velocity Fields and Save
    [Documentation]  Set values lower than the limits and save the contract

    Set Velocity Fields Value
    Click to Save Contract

Get Submit Date By Period
    [Arguments]    ${period}
    [Documentation]  Get submit date regarding period

    ${decrease_time}    Run Keyword If    '${period}'=='daily'    Set Variable    1
    ...    ELSE    Run Keyword If    '${period}'=='weekly'    Set Variable    7
    ...    ELSE    Set Variable    30
    ${current_date_time}    Get Current Date    time_zone=UTC
    ${current_date_time}    Subtract Time From Date    ${current_date_time}    ${decrease_time} days    %Y-%m-%d    True
    ${current_date_time}    Catenate    ${current_date_time} 15:30:00
    [Return]    ${current_date_time}

Get Limit From DB
    [Arguments]    ${db}    ${period}
    [Documentation]  Get velocity value for period

    ${submit_date}    Get Submit Date By Period    ${period}
    Get Into DB    ${db}
    ${limit_query}    Catenate    SELECT COUNT(*) as velocity
    ...    FROM ach_trans
    ...    WHERE submit_date > '${submit_date}'
    ...    AND ar_number = '${ar_number}'
    ...    AND status IN ('P', 'C');
    ${limit}  Query And Strip  ${limit_query}
    [Return]    ${limit}

Set Higher Value for Velocity Fields and Save
    [Arguments]    ${db}=TCH
    [Documentation]  Set values higher than the limits and save the contract

    ${daily_velocity}    Get Limit From DB    ${db}    daily
    ${weekly_velocity}    Get Limit From DB    ${db}    weekly
    ${monthly_velocity}    Get Limit From DB    ${db}    monthly
    ${daily_velocity}    Evaluate    ${daily_velocity}+10
    ${weekly_velocity}    Evaluate    ${weekly_velocity}+10
    ${monthly_velocity}    Evaluate    ${monthly_velocity}+10
    Set Velocity Fields Value    ${daily_velocity}    ${weekly_velocity}    ${monthly_velocity}
    Click to Save Contract

Close payment popup
    [Documentation]  Close the payment pop up

    Wait Until Element is Visible    //*[@id="mpForm"]//span[text()='Cancel']
    Click Element    //*[@id="mpForm"]//span[text()='Cancel']

Input Value and Save Payment
    [Documentation]  Input value and do a payment

    Wait Until Element is Visible    //*[@id="mpForm"]//span[text()='Save']
    Input Text    name=request.achTransBean.draftAmt    1
    Click Element    //*[@id="mpForm"]//span[text()='Save']
    Click Element    //*[@id="confirmsave_content"]//span[text()='Yes']
    Wait While Loading

Do a Payment Through the Tools
    [Documentation]  Do a payment through tools section

    Click Element    //*[@id="commandMenu"]//span[text()='Payment']
    Input Value and Save Payment

Go back to Contract Tab
    [Documentation]  Return to contract tab

    Click Element    //*[@id="accountDetail"]/div[2]//span[text()='Contract']
    Wait Until Page Contains    Contract Information

Do a Payment Through History
    [Documentation]  Do a payment through history tab

    Click Element    //*[@id="historyview"]//span[text()='Payment']
    Input Value and Save Payment

No error must be displayed
    [Documentation]  Assert no error is displayed

    Element Should Not Be Visible    //*[@id="error_caption"]/span[text()='ERROR']
    Close payment popup

Velocities limit error must be displayed
    [Documentation]  Assert velocity error displayed

    Wait Until Element is Visible    //*[@id="error_caption"]/span[text()='ERROR']
    Page Should Contain    ACH not saved.
    Page Should Contain    -The customer has reached their daily velocity limit.
    Page Should Contain    -The customer has reached their weekly velocity limit.
    Page Should Contain    -The customer has reached their monthly velocity limit.
    Click Element    //*[@id="error_content"]//span[text()='OK']
    Close payment popup

Do a Payment and Check for Error Pop Up
    [Arguments]    ${screen}=Tools    ${error}=True
    [Documentation]  Do a payment through tools or history and check for error displayed or not

    Run Keyword If    '${screen}'=='History'    Open History Tab
    Run Keyword If    '${screen}'=='Tools'    Do a Payment Through the Tools
    ...    ELSE    Do a Payment Through History
    Run Keyword If    '${error}'=='True'    Velocities limit error must be displayed
    ...    ELSE    No error must be displayed
    Run Keyword If    '${screen}'=='History'    Go back to Contract Tab

Return To Credit Manager Search Screen
    [Documentation]  Return to credit manager search screen

    Wait Until Element is Visible    //*[@id="contractview"]//span[text()='Return']
    Click Element    //*[@id="contractview"]//span[text()='Return']
    Wait Until Element is Visible    //*[@id="searchForm"]//span[text()='Search']

Assert New Velocity Fields are not Displayed
    [Documentation]  Check if page does not contain new velocity fields

    Page Should Not Contain Element    name=request.contract.${weekly_selector}
    Page Should Not Contain Element    name=request.contract.${monthly_selector}

Get and Check Velocity Value From DB
    [Arguments]    ${query_result}    ${period_selector}    ${value}
    [Documentation]  Compare the velocity value

    ${db_value}  Get From Dictionary  ${query_result}  ${period_selector}
    Should Be Equal As Numbers    ${db_value}    ${value}