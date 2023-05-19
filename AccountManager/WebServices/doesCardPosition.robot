*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
doesCardPosition for a customer that uses secure fuel
    [Tags]  JIRA:BOT-1580  qTest:30782883  Regression  refactor
    [Documentation]  Validate that the is possible to check if the customer uses secure fuel
    [Setup]  log into card management web services  100025  112233

    ${status}  doesCardPosition
    should be equal as strings  ${status}  true

    [Teardown]  Logout

doesCardPosition for a customer that do not uses secure fuel
    [Tags]  JIRA:BOT-1580  qTest:30782956  Regression  refactor
    [Documentation]  Validate that the is possible to check if the customer don't uses secure fuel
    [Setup]  log into card management web services  146567  123123

    ${status}  doesCardPosition
    should be equal as strings  ${status}  false

    [Teardown]  Logout

*** Keywords ***
