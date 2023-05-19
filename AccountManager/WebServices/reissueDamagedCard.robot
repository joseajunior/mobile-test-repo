*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

*** Test Cases ***
Reissue a Damaged Card
    [Tags]  JIRA:BOT-1883  qTest:31825092  Regression  JIRA:BOT-1971
    [Documentation]  Make sure you can reissue a damaged card. Reissues a damaged payroll card (card type 5.5).
    [Setup]  Setup BOT-1883  5307570350000882

    ${order_id}  reissueDamagedCard  ${card}  ShipToFirst  ShipToLast  ShipToAdd1  ShipToAdd2  Ogden  UT  84403  USA  3  N  BOT-1883
    Tch Logging  ORDER_ID:${order_id}

    Row Count Is Equal To X  SELECT * FROM ccb_card_orders WHERE ccb_card_order_id = ${order_id}  1

*** Keywords ***
Setup BOT-1883
    [Arguments]  ${card}
    Get Into DB  TCH
    ${carrier}  ${password}  Get Carrier Info From Card  ${card}
    Start Setup Card  ${card}
    Setup Card Header  status=DELETED
    Log Into Card Management Web Services  ${carrier}  ${password}
    Set Test Variable  ${card}
