*** Settings ***
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Documentation   PCI (L6) Portal: Client-Side Inactivity Timeout Not Implemented

Test Teardown    Close Browser

*** Variables ***
${PortalUsername}
${PortalPassword}

*** Test Cases ***
Check session out and click on logout button
    [Tags]    JIRA:PORT-745    JIRA:BOT-5027    qTest:117296452   PI:15
    [Documentation]    Verify logout button from logout message when is displayed after 15 minutes

    Open browser and login to Portal
    Wait until logout message is displayed
    Click to logout in logout message
    Wait until login button is displayed
    Check not logged in message

Check session out without clicking logout button
    [Tags]    JIRA:PORT-745    JIRA:BOT-5027    qTest:117296452   PI:15
    [Documentation]    Verify logout automatically after 3 minutes when logout message is displayed after 15 minutes

    Open browser and login to Portal
    Wait until logout message is displayed
    Wait until logged out automatically
    Check not logged in message

Check session out and click on continue button
    [Tags]    JIRA:PORT-745    JIRA:BOT-5027    qTest:117296452   PI:15
    [Documentation]    Verify continue button from logout message when is displayed after 15 minutes

    Open browser and login to Portal
    Wait until logout message is displayed
    Click to continue in logout message
    Check home page applications still displayed
    
*** Keywords ***
Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=5

Open browser and login to Portal
    [Documentation]  Login to portal with efs domain user

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalUsername}    ${PortalPassword}

Wait until logout message is displayed
    [Documentation]    Wait until logout message is displayed after 15 minutes

    Wait Until Element is Visible   //a[@class='jbtn']/div/span[contains(text(),'Logout')]   905

Click to logout in logout message
    [Documentation]    Click logout button from logout message and wait for logout message not visible anymore

    Click Element  //a[@class='jbtn']/div/span[contains(text(),'Logout')]
    Wait Until Element is not Visible    //a[@class='jbtn']/div/span[contains(text(),'Logout')]

Wait until login button is displayed
    [Documentation]    Wait until login button is displayed after logout
    [Arguments]    ${timeout}=0

    Run Keyword If    '${timeout}'=='0'    Wait Until Element is Visible    //*[@id="pmd_login" and text()='Log In']
    ...    ELSE    Wait Until Element is Visible    //*[@id="pmd_login" and text()='Log In']     ${timeout}

Check not logged in message
    [Documentation]    Verify not logged in message after logout

    Page Should Contain    You are not currently logged in.

Wait until logged out automatically
    [Documentation]    Wait 3 minutes to logout automatically after logout message pops up

    Wait until login button is displayed    185

Click to continue in logout message
    [Documentation]    Click continue button from logout message and wait for logout message not visible anymore

    Click Element  //a[@class='jbtn']/div/span[contains(text(),'Continue')]
    Wait Until Element is not Visible    //a[@class='jbtn']/div/span[contains(text(),'Logout')]

Check home page applications still displayed
    [Documentation]    Verify if home page is still showing

    Wait Until Element is Visible    //*[@id="pmd_home" and contains(text(), 'Home')]
    Page Should Contain    Available Application Desktops