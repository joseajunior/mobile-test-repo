*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services  refactor

Suite Setup  Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}
Suite Teardown  Logout
Test Setup  Setup Card

*** Variables ***
${shipToFirst}  Anakin
${shipToLast}  Skywalker
${shipToAddress1}  Wall St
${shipToAddress2}  ${EMPTY}
${shipToCity}  Ogden
${shipToState}  UT
${shipToZip}  84403
${shipToCountry}  US
${shipToMethod}  3
${rushProcessing}  Y
${reason}  BOT-1881


*** Test Cases ***
Replace Lost Or Stolen Card With Valid Input
    [Tags]  JIRA:BOT-1881  qTest:32298758  Regression  JIRA:BOT-1970
    [Documentation]  If the current card is not working anymore, use "Search Card to Replace" keyword to find a new suitable card.
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Be True  ${status}

Replace Lost Or Stolen Card With Invalid Card Number
    [Tags]  JIRA:BOT-1881  qTest:32298898  Regression
    [Documentation]
    ${card_num}  Set Variable  1nv@l1d
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Card Number
    [Tags]  JIRA:BOT-1881  qTest:32298943  Regression
    [Documentation]
    ${card_num}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With TYPO Card Number
    [Tags]  JIRA:BOT-1881  qTest:32298944  Regression
    [Documentation]
    ${card_num}  Set Variable  ${card_num}f
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Ship To First
    [Tags]  JIRA:BOT-1881  qTest:32298993  Regression  BUGGED: First Name Should Not Be Null.
    [Documentation]
    ${shipToFirst}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Ship To Last
    [Tags]  JIRA:BOT-1881  qTest:32298995  Regression  BUGGED: Last Name Should Not Be Null.
    [Documentation]
    ${shipToLast}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Ship To Address 1
    [Tags]  JIRA:BOT-1881  qTest:32298996  Regression  BUGGED: Address 1 Should Not Be Null.
    [Documentation]
    ${shipToAddress1}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Ship To City
    [Tags]  JIRA:BOT-1881  qTest:32299029  Regression  BUGGED: City Should Not Be Null.
    [Documentation]
    ${shipToCity}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Ship To State
    [Tags]  JIRA:BOT-1881  qTest:32299030  Regression  BUGGED: State Should Not Be Null.
    [Documentation]
    ${shipToState}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Ship To Zip
    [Tags]  JIRA:BOT-1881  qTest:32299032  Regression  BUGGED: Zip Should Not Be Null.
    [Documentation]
    ${shipToZip}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Ship To Country
    [Tags]  JIRA:BOT-1881  qTest:32299033  Regression  BUGGED: Country Should Not Be Null.
    [Documentation]
    ${shipToCountry}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With Invalid Shipping Method
    [Tags]  JIRA:BOT-1881  qTest:32299034  Regression
    [Documentation]
    ${shipToMethod}  Set Variable  1nv@l1d
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With EMPTY Shipping Method
    [Tags]  JIRA:BOT-1881  qTest:32299035  Regression
    [Documentation]
    ${shipToMethod}  Set Variable  ${EMPTY}
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}

Replace Lost Or Stolen Card With TYPO Shipping Method
    [Tags]  JIRA:BOT-1881  qTest:32299037  Regression
    [Documentation]
    ${shipToMethod}  Set Variable  ${shipToMethod}f
    ${status}  Run Keyword And Return Status  replaceLostOrStolenCard  ${card_num}  ${shipToFirst}  ${shipToLast}  ${shipToAddress1}  ${shipToAddress2}  ${shipToCity}  ${shipToState}  ${shipToZip}  ${shipToCountry}  ${shipToMethod}  ${rushProcessing}  ${reason}
    Should Not Be True  ${status}


*** Keywords ***
Setup Card
    ${card_num}  ${backup_status}  Search Card and Status to Replace
    Set Test Variable  ${card_num}
    Start Setup Card  ${card_num}

Teardown WS
    Disconnect From Database
    logout

Search Card and Status to Replace
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT TRIM(c.card_num) AS card_num,
    ...         c.status
    ...  FROM ccb_cards cc
    ...     INNER JOIN ccb_card_orders cco ON cco.ccb_card_order_id = cc.ccb_card_order_id
    ...     INNER JOIN cards c ON c.card_id = cc.card_id
    ...  WHERE cco.carrier_id = ${validCard.carrier.id}
    ...  AND cc.card_id IS NOT NULL
    ...  AND template IS NULL
    ...  AND c.status NOT IN ('D','A')
    ...  ORDER BY cco.ccb_card_order_id DESC
    ...  LIMIT 1
    tch logging  ${query}
    ${output}  Query And Strip To Dictionary  ${query}
    tch logging  ${output}
    [Return]  ${output['card_num']}  ${output['status']}

