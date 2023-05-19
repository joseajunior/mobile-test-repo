*** Settings ***
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Test Teardown    Close Browser

*** Test Cases ***
Oracle Staging - Loading Rules Source
    [Tags]    JIRA:ATLAS-2467    qTest:120609450    Q2:2023
    [Documentation]    In Oracle Staging go to Rules in the menu bar and select the Source 'Other Fees' from the dropdown
    ...    box without errors

    Open Browser And Login To Portal
    Select Portal Program    Oracle Staging
    Select Rules From Menu Bar
    Select 'Other Fees' From Source Dropdown Box

*** Keywords ***
Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=5

Open Browser And Login To Portal
    [Documentation]  Login to portal with efs domain user

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalUsername}    ${PortalPassword}

Select ${source} From Source Dropdown Box
    Wait Until Element Is Visible    id=source
    # this structure will allow testing of all Sources if needed.  At the time of this initial automation 'Other Fees'
    # is the only source being tested.
    IF    ${source}=='Auto Settle'
        Select From List By Value    id=source    AS
        Wait Until Page Contains    Fee Amount 1
    ELSE IF    ${source}=='Other Fees'
        Select From List By Value    id=source    OF
        Wait Until Page Contains    Fee Amount 1
    END

Select Rules From Menu Bar
    Wait Until Element Is Visible    id=pm_6
    Click Element    //*[@id="pm_6"]
