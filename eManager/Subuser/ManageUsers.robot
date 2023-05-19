*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager
*** Variables ***
${sub_user}  SubUser  #This user is on DIT and ACPT, to run on others environments is necessary to create it.
${sub_user_password}  testing123
${permission_status}

*** Test Cases ***
Sub-User - Should Not Delete Main User ID
    [Tags]  JIRA:FRNT-1007  qTest:47410607  JIRA:BOT-3219  PI:6
    [Documentation]  This test will check if Sub-User is not able to delete main user ID.
    [Setup]  Setup for FRNT-1007

    Log into eManager with a Sub-User.
    Navigate to Select Program > User Administration > Manage Users.
    Check if You Can Not Delete Main User ID.

    [Teardown]  Run Keywords  Teardown for FRNT-1007
    ...  AND  Close Browser

*** Keywords ***
Setup for FRNT-1007
    [Documentation]  Keyword Setup for FRNT-1007

    Ensure Carrier has User Permission  ${sub_user}  MANAGE_USERS

Teardown for FRNT-1007
    [Documentation]  Keyword Teardown for FRNT-1007

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${sub_user}  MANAGE_USERS

Log into eManager with a Sub-User.
    [Documentation]  Login on Emanager

    Open eManager  ${sub_user}  ${sub_user_password}

Navigate to Select Program > User Administration > Manage Users.
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/security/ManageUsers.action

Check if You Can Not Delete Main User ID.
    [Documentation]  Check if Element is not on screen.

    Element Should not Be Visible  //table[@id='user']//tr[1]//input[@name='DeleteUser']
