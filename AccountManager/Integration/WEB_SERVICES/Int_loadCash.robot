*** Settings ***

Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Force Tags  Integration  Shifty  Web Services

*** Test Cases ***

Loading a Cash
    [Tags]  qTest:30782144
    [Setup]  Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Set Test Variable  ${amount}  10
    Set Test Variable  ${refNumber}  Hey
    Set Test Variable  ${payroll}  ${EMPTY}

    Start Setup Card  ${validCard.num}
    Setup Card Header  status=ACTIVE
    Setup Card Contract  status=A
    Update Contract Limits by Card  ${validCard.num}

    ${status}  Run Keyword And Return Status  loadCash  ${validCard.num}  ${amount}  ${refNumber}  ${payroll}
    Should Be True  ${status}

    [Teardown]  Logout

*** Keywords ***
