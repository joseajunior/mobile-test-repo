*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${groupId}  1271

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1599  qTest:31031445  Regression
    ${locationsWS}  getLocGrpLocs  ${groupId}
    Should Not Be Empty  ${locationsWS}
    ${locationsDB}  Get Locations Group Locations from Database  ${groupId}
    Validate Locations Group Locations  ${locationsWS}   ${locationsDB}

Invalid Group ID
    [Documentation]  Insert Invalid Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1599  qTest:31031446  Regression
    Run Keyword And Expect Error  *  getLocGrpLocs  1nv@l1d

Typo Group ID
    [Documentation]  Insert Typo Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1599  qTest:31031447  Regression
    Run Keyword And Expect Error  *  getLocGrpLocs  ${groupId}f

Empty Group ID
    [Documentation]  Insert an Empty Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1599  qTest:31031448  Regression
    Run Keyword And Expect Error  *  getLocGrpLocs  ${empty}

*** Keywords ***
Setup WS
    Get Into DB  TCH

    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Get Locations Group Locations from Database
    [Arguments]  ${groupId}
    ${query}  Catenate  SELECT TO_CHAR(location_id) as location_id FROM loc_grp_exp WHERE grp_id='${groupId}';
    ${locations}  Query and Strip to Dictionary  ${query}
    ${locations}  Get From Dictionary  ${locations}  location_id
    [Return]  ${locations}

Validate Locations Group Locations
    [Arguments]  ${ws}  ${db}
    Sort List  ${ws}
    Sort List  ${db}
    Lists Should be Equal  ${ws}  ${db}