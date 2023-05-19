*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
Suite Teardown  Logout

*** Test Cases ***
Valid Data
    [Tags]  JIRA:BOT-1568  qTest:30667690  Regression
    [Documentation]  Input a valid data parameter and expect a list with carrier info.
    ${ws_dictionary}  getCarrierInfo

    #I was not able to link Location Groups with Carrier Info
    Remove From Dictionary  ${ws_dictionary}  locationGroups

    ${db_dictionary}  Get Dictionary Values From Database  ${validCard.carrier.id}
    ${comparison}  Compare Dictionaries As Strings  ${db_dictionary[0]}  ${ws_dictionary}
    Should Be True  ${comparison}

*** Keywords ***
Get Dictionary Values From Database
    [Arguments]  ${validCard.carrier.id}

    Get Into DB  TCH
    ${query}  Catenate  SELECT name, member_id AS carrierId FROM member WHERE member_id='${validCard.carrier.id}'
    ${database}  Query To Dictionaries  ${query}
    [Return]  ${database}

