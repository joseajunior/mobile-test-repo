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
${area}  USA
${locType}  CAFE
${groupId}  2870

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1878  qTest:31798856  Regression  refactor
    setLocGrpRule  ${groupId}  ${area},${locType}
    Row Count Is Equal to X  SELECT * FROM loc_grp_imp WHERE grp_id='${groupId}' AND area='${area}' AND loc_type='${locType}'  1
    [Teardown]  execute sql string   dml=DELETE FROM loc_grp_imp WHERE grp_id='${groupId}' AND area='${area}' AND loc_type='${locType}'

Invalid Group ID
    [Documentation]  Insert Invalid Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798857  Regression
    Run Keyword And Expect Error  *  setLocGrpRule  1nv@l1d  ${area},${locType}

Typo Group ID
    [Documentation]  Insert Typo Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798858  Regression
    Run Keyword And Expect Error  *  setLocGrpRule  ${groupId}f  ${area},${locType}

Empty Group ID
    [Documentation]  Insert an Empty Group ID parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798859  Regression
    Run Keyword And Expect Error  *  setLocGrpRule  ${empty}  ${area},${locType}

Invalid Rule
    [Documentation]  Insert Invalid Rule parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798860  Regression
    Run Keyword And Expect Error  *  setLocGrpRule  ${groupId}  1nv@l1d

Empty Rule
    [Documentation]  Insert Empty Rule Flag parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798861  Regression
    Run Keyword And Expect Error  *  setLocGrpRule  ${groupId}  ${empty}

Invalid Area
    [Documentation]  Insert an Invalid Area parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798862  Regression  BUGGED: Allows to add any value.
    Run Keyword And Expect Error  *  setLocGrpRule  ${groupId}  1nv@l1d,${locType}

Typo Area
    [Documentation]  Insert a Typo Area parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798863  Regression  BUGGED: Allows to add any value.
    Run Keyword And Expect Error  *  setLocGrpRule  ${groupId}  USF,${locType}

Invalid Location Type
    [Documentation]  Insert an Invalid Location Type parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798864  Regression  BUGGED: Allows to add any value.
    Run Keyword And Expect Error  *  setLocGrpRule  ${groupId}  ${area},1nv@l1d

Typo Location Type
    [Documentation]  Insert a Typo Location Type parameter and expect an error.
    [Tags]  JIRA:BOT-1878  qTest:31798865  Regression  BUGGED: Allows to add any value.
    Run Keyword And Expect Error  *  setLocGrpRule  ${groupId}  ${area},${locType}f

*** Keywords ***
Setup WS
    Get Into DB  TCH

    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    execute sql string   dml=DELETE FROM loc_grp_imp WHERE grp_id='${groupId}'
    Disconnect From Database
    Logout
