*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services
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

Issue With Invalid Embossed Name
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${embossedName}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Embossed Name
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${embossedName}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Invalid Ship To First
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToFirst}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Ship To First
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToLast}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Invalid Ship To Last
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToLast}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Ship To Last
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToFirst}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Invalid Address 1
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToAddress1}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Address 1
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToAddress1}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Invalid Address 2
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToAddress2}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Address 2
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToAddress2}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  0

Issue With Invalid Ship To City
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToCity}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Ship To City
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToCity}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Invalid Ship To State
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToState}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Ship To State
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToState}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Invalid Ship To Zip
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToZip}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Empty Ship To Zip
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToZip}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  -1

Issue With Invalid Ship To Country
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToCountry}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  0

Issue With Empty Ship To Country
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${shipToCountry}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  0

Issue With Invalid Shipping Method
    [Tags]  BOT-1889  qTest:  Regression  run
    [Documentation]
    ${shippingMethod}  Set Variable  1nv@l1d
    ${status}  run keyword and return status  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should not be true  ${status}

Issue With Empty Shipping Method
    [Tags]  BOT-1889  qTest:  Regression  run
    [Documentation]
    ${shipToCountry}  Set Variable  ${EMPTY}
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  0

Issue With Invalid Rush Processing
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${rushProcessing}  Set Variable  1nv@l1d
    ${ws_return}  issueNewPersonalizedPayrollCard  ${embossedName}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shippingMethod}  ${rushProcessing}
    should be equal as strings  ${ws_return['errorCode']}  0

Issue With Empty Rush Processing
    [Tags]  BOT-1889  qTest:  Regression
    [Documentation]
    ${rushProcessing}  Set Variable  ${EMPTY}
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
