*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Test Teardown  Tear Me Down

*** Test Cases ***

Get Location Group Descriptions
    [Tags]  JIRA:BOT-1615  qTest:30852577  Regression  refactor

     ${WS_INFO}  getLocationGroupDescriptions
     Should Not Be Empty  ${WS_INFO}

     ${WS_length}  get length  ${WS_INFO}
    FOR  ${i}  IN RANGE  0  ${WS_length}
        Remove From Dictionary  ${WS_INFO[${i}]}  ruleBased
        Remove From Dictionary  ${WS_INFO[${i}]}  editable
    END

    ${DB_INFO}  Get Location Groups Descriptions On DB

    ${same_dict}  Compare List Dictionaries As Strings  ${DB_INFO}  ${WS_INFO}
    Should Be True  ${same_dict}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Disconnect From Database
    Logout

Get Location Groups Descriptions On DB
    ${query}  catenate
    ...     SELECT grp_id AS grpId,
    ...     DECODE(name, '', NULL, name) AS name
    ...     FROM loc_grp WHERE carrier_id =${userName}
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}
