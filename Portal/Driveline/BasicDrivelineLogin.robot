*** Settings ***
Documentation
...  This is a basic login test for Driveline

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/DrivelineKeywords.robot

Force Tags  Driveline  refactor
Suite Teardown  close all browsers

*** Variables ***

*** Test Cases ***

Check for Valid Login to Driveline
    [Tags]  JIRA:PORT-132  qTest:39794796
    [Documentation]  Validate a user with valid credentials can login to Driveline

    Open Browser to driveline
    Log Into Driveline  ${drivelineusername}  ${drivelinepassword}
    Check if the user was logged into successfully

Check for Invalid Username in Driveline
    [Tags]  JIRA:PORT-132  qTest:39794796
    [Documentation]  Validate a user with an invalid username cannot login to Driveline

    Open Browser to driveline
    ${status}  ${error}  run keyword and ignore error  Log Into Driveline  1nv@l1d  ${drivelinepassword}
    Check if the user cannot get loggged into Driveline  ${status}

Check for Invalid password in Driveline
    [Tags]  JIRA:PORT-132  qTest:39794796
    [Documentation]  Validate a user with an invalid password cannot login to Driveline

    Open Browser to driveline
    ${status}  ${error}  run keyword and ignore error  Log Into Driveline  ${drivelineusername}  1nv@l1d
    Check if the user cannot get loggged into Driveline  ${status}


*** Keywords ***

Check if the user was logged into successfully
    wait until element is visible  //span/*[contains(text(), "Logged in as: ")]//following-sibling::span[text()="${drivelineusername}"]
    page should contain  Logged in as: ${drivelineusername}

Check if the user cannot get loggged into Driveline
    [Arguments]  ${status}
    Wait Until Page Contains Element  //*[contains(@data-errorqtip,"Username and/or Password is invalid.")]
    ${mainDiv}  get text  //*[@id="mainDiv"]
    ${mainDiv}  convert to string  ${mainDiv}
    Should Contain  ${mainDiv}  Username and/or Password is invalid.
    Should Be Equal  ${status}  FAIL