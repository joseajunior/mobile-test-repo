*** Settings ***

Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  Integration  Shifty  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${PAYROLL_ISSUER}  192707
#VALID INPUT
${embossedName}  Master Jedi
${shipToFirst}  Luke
${shipToLast}  Skywalker
${shipToAddress1}  1104  Country Hills Drive
${shipToAddress2}  ${EMPTY}
${shipToCity}  Ogden
${shipToState}  UT
${shipToZip}  84403
${shipToCountry}  US
${shippingMethod}  3
${rushProcessing}  Y

*** Test Cases ***
Valid Input
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  0

*** Keywords ***
Setup WS
    Get Into DB  TCH
    ${sql}  Catenate  SELECT card_num FROM cards c
    ...                 JOIN def_card dc ON c.carrier_id = dc.id AND c.icardpolicy = dc.ipolicy
    ...                 JOIN contract co ON dc.contract_id = co.contract_id
    ...               WHERE co.status = 'A'
    ...               AND co.issuer_id = ${PAYROLL_ISSUER}
    ${payr_card}  Find Card Variable  ${sql}
    Start Setup Card  ${payr_card.card_num}
    log into card management web services  ${payr_card.carrier.id}  ${payr_card.carrier.password}

Teardown WS
    Disconnect From Database
    logout
