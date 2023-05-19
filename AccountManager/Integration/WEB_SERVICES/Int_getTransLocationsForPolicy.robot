*** Settings ***

Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Suite Setup  Starting My Suite

Force Tags  Integration  Shifty  Web Services

*** Test Cases ***

Get Trans Locations For Policy With Valid Policy Number
    [Tags]
    ${status}  Run Keyword And Return Status  getTransLocationsForPolicy  ${validCard.policy.num}
    Tch Logging  ${status}


Get Trans Locations For Policy With Invalid Policy Number
    [Tags]  qTest:37377246
    ${status}  Run Keyword And Return Status  getTransLocationsForPolicy  9999
    Should Not Be True  ${status}

    Should Contain  ${ws_error}  Invalid policy number



*** Keywords ***
Starting My Suite
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}




