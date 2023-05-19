*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***

Getting the server time
    [Tags]  JIRA:BOT-1586  qTest:30921086  Regression
    [Documentation]  Validate if it is possible to get the server time
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    ${servertime}  serverTime
    tch logging  \n${servertime}

    should not be empty  ${servertime}


    [Teardown]  Logout

# should be revisited
# we are not sure wich database table we can find the server time
*** Keywords ***
