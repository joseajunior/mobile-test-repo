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
Input Invalid Policy Number
    [Tags]  JIRA:BOT-1634  qTest:37428223  Regression  JIRA:FRNT-55  refactor
    [Documentation]  Input a TYPO parameter and return a bad response from web serivce.
    ${typo}  Run Keyword And Return Status  getOrderTypes  9999
    Should Not Be True  ${typo}
    should contain  ${ws_error}  Invalid policy number

Exceed Parameter Field Limit
    [Tags]  JIRA:BOT-1634  qTest:30563706  Regression
    [Documentation]  Input a parameter with more characters than supported, a bad response from web serivce is expected.
    ${exceed}  Run Keyword And Return Status  getOrderTypes  9999999999
    Should Not Be True  ${exceed}

Valid Data for WS
    [Tags]  JIRA:BOT-1634  qTest:30563707  Regression
    [Documentation]  Input a valid data parameter and expect a list with all possible order types for carrier from web serivce.
    ${policy}  Set Variable  3
    ${ws_dictionary}  getOrderTypes  ${policy}
    ${database_dictionary}  Get Dictionary Values From Database  ${validCard.carrier.id}  ${policy}
    ${valid}  Compare List Dictionaries As Strings  ${ws_dictionary}  ${database_dictionary}
    Should Be True  ${valid}

Null Parameter
    [Tags]  JIRA:BOT-1634  qTest:30563708  Regression  refactor
    [Documentation]  Input policy as null parameter, return should be a bad response from web serivce.
    ${null}  getOrderTypes  ${empty}
    Should Be Empty  ${null}

*** Keywords ***
Get Dictionary Values From Database
    [Arguments]  ${userName}  ${policy}

    Get Into DB  TCH
    ${query}  Catenate  SELECT DISTINCT
    ...  ccop.ccb_card_option_id as orderType,
    ...  ccop.description as description
    ...  FROM def_card dc
    ...  INNER JOIN contract c ON c.contract_id = dc.contract_id
    ...  INNER JOIN issuer_card_style ics ON ics.issuer_id = c.issuer_id
    ...  INNER JOIN ccb_style_options cso ON cso.card_style_id = ics.card_style
    ...  INNER JOIN ccb_card_options ccop ON cso.ccb_card_option_id = ccop.ccb_card_option_id
    ...  INNER JOIN card_styles cs ON cs.card_style = ics.card_style
    ...  WHERE dc.id = ${validCard.carrier.id}
    ...  AND dc.ipolicy = ${policy}
    ...  AND ccop.deleted IS NULL
    ...  AND ccop.verified != 'N'
    ...  AND cs.verified != 'N';
    ${database}  Query To Dictionaries  ${query}
    [Return]  ${database}