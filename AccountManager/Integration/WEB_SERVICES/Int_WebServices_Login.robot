*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH       #USED TO BE Library  SSHLibrary
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  ../../Keywords/PortalKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Integration  WebServices  Shifty


*** Variables ***

*** Test Cases ***
Valid Carrier
    [Tags]  qTest:37401931
    ${loggedIn}  Run Keyword And Return Status  Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Should Be True  ${loggedIn}

*** Keywords ***
