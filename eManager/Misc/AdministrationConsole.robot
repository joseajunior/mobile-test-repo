*** Settings ***

Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Administration Console  eManager

*** Variables ***

*** Test Cases ***
Administration Console - Page Should Not Load
    [Documentation]  Administration Console Page Should not be available for any user.
    [Tags]  JIRA:FRNT-1178  qTest:48498851  JIRA:BOT-3267

    Open Red Hat JBoss Enterprise Application Platform;
    Click On Administration Console Link;
    Administration Console Page Should not Load;

    [Teardown]  Close Browser

*** Keywords ***
Open Red Hat JBoss Enterprise Application Platform;
    Open Automation Browser  ${emanager}/index.html  ${browser}  download_folder=${default_download_path}  alias=eManager

Click On Administration Console Link;
    Click Element  //a[@href='/console']

Administration Console Page Should not Load;
    Element Should Not Be Visible  //*[text()='Administration Console']


