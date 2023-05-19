*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Starting My Suite

Force Tags  Web Services  refactor

*** Test Cases ***
Get Trans Locations For Policy With Invalid Policy Number
    [Tags]  qTest:37377246  JIRA:FRNT-55
    ${status}  run keyword and return status  getTransLocationsForPolicy  9999
    should not be true  ${status}

    should contain  ${ws_error}  Invalid policy number


*** Keywords ***
Starting My Suite
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}




