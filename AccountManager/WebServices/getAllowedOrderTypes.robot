*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Get Allowed Order Types
    [Tags]  JIRA:BOT-1899  qTest:31777740  Regression
    [Documentation]  Make sure you can fetch information from WS using the getAllowedOrderTypes ws call
    ${WS_INFO}  getAllowedOrderTypes

#    FOR  ${INFO}  IN  @{WS_INFO}
#        Remove From Dictionary  ${INFO}  defCardStyle
#        Remove From Dictionary  ${INFO}  defCardStyleDesc
#    END

    Should Not Be Empty  ${WS_INFO}



*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Get Allowed Order Types On DB
    ${query}  catenate
    ...     SELECT cp.ccb_card_option_id AS orderType,
    ...     cp.description AS orderDesc,
    ...     co.card_style AS defCardStyle,
#    ...     --co.policy AS defPolicy,
#       co.*
    ...     FROM cardpress_style_def csd,
    ...     ccb_card_orders co,
    ...     ccb_card_options cp,
    ...     issuer_card_style ics
    ...     WHERE csd.cardpress_style_def_id = co.cardpress_id
    ...     AND   co.carrier_id = 103866
    ...     AND   co.issuer_id=ics.issuer_id
    ...     ORDER BY cp.ccb_card_option_id ASC LIMIT 100;