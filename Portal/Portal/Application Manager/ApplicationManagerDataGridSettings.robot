*** Settings ***
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Test Teardown    Close Browser

*** Variables ***
${PortalUsername}
${PortalPassword}

*** Test Cases ***
Application Manager data grid settings
    [Tags]    JIRA:ATLAS-2389    JIRA:BOT-5090    qTest:120359409   Q2:2023
    [Documentation]    Ensure data grid settings doesn't throw null pointer in Application Manager

    Open browser and login to Portal
    Select Portal Program  Application Manager
    Perform general search
    Ensure page has no null pointer error
    Change rows per page in settings
    Remove result column
    Add result column

*** Keywords ***
Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=5

Open browser and login to Portal
    [Documentation]  Login to portal with efs domain user

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalUsername}    ${PortalPassword}

Perform general search
    [Documentation]    Search with general criteria to get some results

    Wait Until Element is Visible    name=cardType
    Select From List By Label    name=cardType    Card Type 7
    Wait Until Element is Visible    //span[text()='Search']
    Click Element    //span[text()='Search']
    Wait Until Element is Visible    //*[@id="wait_content"]
    Wait Until Element is Not Visible    //*[@id="wait_content"]

Ensure page has no null pointer error
    [Documentation]    Ensure null pointer error is not shown when settings are changed

    Page Should Not Contain    NullPointerException

Change rows per page in settings
    [Documentation]    Change rows per page in data grid settings

    Open data grid settings
    Wait Until Element is Visible    id=_j_dataGrid_rpp
    Input Text    id=_j_dataGrid_rpp    10
    Click to update settings and wait data loading
    Ensure page has no null pointer error
    Page Should Contain Element    //*[@id="resultsTable"]//tr[10]
    Page Should Not Contain Element    //*[@id="resultsTable"]//tr[11]

Remove result column
    [Documentation]    Remove a column in data grid settings

    Open data grid settings
    Wait Until Element is Visible    //*[@id="_j_dataGrid_fields"]//input[@value='createdDate']
    Unselect Checkbox    //*[@id="_j_dataGrid_fields"]//input[@value='createdDate']
    Click to update settings and wait data loading
    Ensure page has no null pointer error
    Page Should Not Contain Element    //*[@id="resultsTable"]//div[contains(text(), 'Created')]

Add result column
    [Documentation]    Add a column in data grid settings

    Open data grid settings
    Wait Until Element is Visible    //*[@id="_j_dataGrid_fields"]//input[@value='createdDate']
    Select Checkbox    //*[@id="_j_dataGrid_fields"]//input[@value='createdDate']
    Click to update settings and wait data loading
    Ensure page has no null pointer error
    Page Should Contain Element    //*[@id="resultsTable"]//div[contains(text(), 'Created')]

Open data grid settings
    [Documentation]    Open data grid settings in gear icon at the bottom

    Wait Until Element is Visible    //*[@id="resultsTable"]//span[@title='Settings']
    Click Element    //*[@id="resultsTable"]//span[@title='Settings']

Click to update settings and wait data loading
    [Documentation]  Click OK and wait search results to load

    Click Element    //*[@id="dataGridSettings_content"]//span[text()='OK']
    Wait Until Element is Visible    //*[@id="wait_content"]
    Wait Until Element is Not Visible    //*[@id="wait_content"]