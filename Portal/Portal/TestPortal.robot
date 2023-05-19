*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

*** Test Cases ***
Login Test
    [Tags]  checked
    [Documentation]  Login Test
    Open Browser to Portal
    Log Into Portal
    [Teardown]    Close All Browsers

Open Browser And Login To Portal
    [Documentation]  Login to portal with efs domain user

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalUsername}    ${PortalPassword}
    [Teardown]    Close All Browsers

*** Keywords ***
Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=5
