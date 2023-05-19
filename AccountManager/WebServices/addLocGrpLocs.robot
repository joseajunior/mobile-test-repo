*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services  refactor
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Valid Group Id and Location Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30973484  Regression  run
    ${group_id}  Get Valid Group Id
    Delete Location From Group  ${group_id}  231010
    addLocGrpLocs  ${group_id}  231010
    Ensure Location Has Been Added To Group  ${group_id}  231010
    [Teardown]  Delete Location From Group  ${group_id}  231010

Valid Group Id and More Than One Valid Location Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30973502  Regression
    ${group_id}  Get Valid Group Id
    Delete Location From Group  ${group_id}  231010  231011
    addLocGrpLocs  ${group_id}  231010  231011
    Ensure Location Has Been Added To Group  ${group_id}  231010  231011
    [Teardown]  Delete Location From Group  ${group_id}  231010  231011

Group Id From Another Carrier
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30973513  Regression
    ${group_id}  Get Group Id From Another Carrier
    ${message}  Run Keyword And Expect Error  *  addLocGrpLocs  ${group_id}  231010
    Should Start With  ${ws_error}  ERROR running command

Invalid Group Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30973487  Regression
    ${message}  Run Keyword And Expect Error  *  addLocGrpLocs  1nv@l1d_gr0up  231010
    Should Start With  ${ws_error}  For input string: "1nv@l1d_gr0up"

Typo Group Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30973485  Regression
    ${group_id}  Get Valid Group Id
    ${message}  Run Keyword And Expect Error  *  addLocGrpLocs  ${group_id}f  231010
    Should Start With  ${ws_error}  For input string: "${group_id}f"

Empty Group Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30973486  Regression
    ${message}  Run Keyword And Expect Error  *  addLocGrpLocs  ${EMPTY}  231010
    Should Start With  ${ws_error}  ERROR running command

Invalid Location Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30975577  Regression
    ${group_id}  Get Valid Group Id
    ${message}  Run Keyword And Expect Error  *  addLocGrpLocs  ${group_id}  1nv@l1d_l0c@t10n
    Should Start With  ${ws_error}  For input string: "1nv@l1d_l0c@t10n"

Typo Location Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30975578  Regression
    ${group_id}  Get Valid Group Id
    ${message}  Run Keyword And Expect Error  *  addLocGrpLocs  ${group_id}  231010f
    Should Start With  ${ws_error}  For input string: "231010f"

Empty Location Id
    [Documentation]
    [Tags]  JIRA:BOT-1603  qTest:30975579  Regression
    ${group_id}  Get Valid Group Id
    ${message}  Run Keyword And Expect Error  *  addLocGrpLocs  ${group_id}  ${EMPTY}
    Should Start With  ${ws_error}  For input string: "${EMPTY}"

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Get Valid Group Id
    ${query}  Catenate
    ...         SELECT TO_CHAR(lg.grp_id) AS grp_id FROM loc_grp lg
    ...             INNER JOIN loc_grp_exp lge ON lg.grp_id = lge.grp_id
    ...         WHERE lg.carrier_id = ${validCard.carrier.id}
    ${group_id}  Query And Strip  ${query}
    [Return]  ${group_id}

Get Group Id From Another Carrier
    ${query}  Catenate  SELECT TO_CHAR(lg.grp_id) From loc_grp lg
    ...                    INNER JOIN loc_grp_exp lge ON lg.grp_id = lge.grp_id
    ...                 WHERE lg.carrier_id != ${validCard.carrier.id}
    ...                 AND lg.grp_id > 1000
    ...                 LIMIT 1
    ${group_id}  Query And Strip  ${query}
    [Return]  ${group_id}

Delete Location From Group
    [Arguments]  ${group_id}  @{locations}
    ${locations_id}  Set Variable  ${EMPTY}
    FOR  ${loc}  IN  @{locations}
      ${locations_id}  Catenate  ${locations_id}${loc},
    END
    ${locations_id}  Get Substring	 ${locations_id}  0  -1
    ${query}  catenate  dml=DELETE FROM loc_grp_exp WHERE grp_id = ${group_id} and location_id IN (${locations_id})
    Execute SQL String  ${query}

Ensure Location Has Been Added To Group
    [Arguments]  ${group_id}  @{locations}
    ${locations_id}  Set Variable  ${EMPTY}
    FOR  ${loc}  IN  @{locations}
      ${locations_id}  Catenate  ${locations_id}${loc},
    END
    ${locations_id}  Get Substring	 ${locations_id}  0  -1
    ${query}  Catenate
    ...         SELECT lg.grp_id FROM loc_grp lg
    ...             INNER JOIN loc_grp_exp lge ON lg.grp_id = lge.grp_id
    ...         WHERE lg.carrier_id = ${validCard.carrier.id}
    ...         AND lg.grp_id = ${group_id}
    ...         AND lge.location_id IN (${locations_id})
    ${location_count}  Get Length  ${locations}
    Row Count Is Equal To X  ${query}  ${location_count.__str__()}

Search Location in Group
    ${query}  Catenate  SELECT 1 From loc_grp lg
    ...                    INNER JOIN loc_grp_exp lge ON lg.grp_id = lge.grp_id
    ...                 WHERE lg.carrier_id != ${validCard.carrier.id}
    ...                 AND lg.grp_id > 1000
    ...                 LIMIT 1


