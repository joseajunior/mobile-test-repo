*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${action}  ADD

*** Test Cases ***
Manage Fuel Action With Valid Input
    [Tags]  JIRA:BOT-1887  qTest:32267358  Regression  refactor
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    ${ws_response}  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    tch logging  ${ws_response}

Empty Trip Number
    [Tags]  JIRA:BOT-1887  qTest:32267888  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  tripnumber=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Invalid Trip Sequence
    [Tags]  JIRA:BOT-1887  qTest:32267921  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  tripseq=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Trip Sequence
    [Tags]  JIRA:BOT-1887  qTest:32267960  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  tripseq=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Trip Sequence
    [Tags]  JIRA:BOT-1887  qTest:32267982  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  tripseq=${managed_fuel_info['tripnumber']}f
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Card Number
    [Tags]  JIRA:BOT-1887  qTest:32268027  Regression  BUGGED:Card Number Field shouldn't be invalid.
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    ${cardNumber}  Generate Random String  16  [LETTERS]
    Set To Dictionary  ${managed_fuel_info}  cardnumber=${cardNumber}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Card Number
    [Tags]  JIRA:BOT-1887  qTest:32268060  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  cardnumber=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Card Number
    [Tags]  JIRA:BOT-1887  qTest:32268086  Regression  BUGGED:Card Number Field shouldn't be invalid.
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  cardnumber=${managed_fuel_info['cardnumber']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Card Number 2
    [Tags]  JIRA:BOT-1887  qTest:32268476  Regression  BUGGED:Card Number Field shouldn't be invalid.
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    ${cardNumber}  Generate Random String  16  [LETTERS]
    Set To Dictionary  ${managed_fuel_info}  cardnumber2=${cardNumber}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}  ${managed_fuel_info['cardnumber2']}
    Should Not Be True  ${status}

Typo Card Number 2
    [Tags]  JIRA:BOT-1887  qTest:32268494  Regression  BUGGED:Card Number Field shouldn't be invalid.
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  cardnumber2=${managed_fuel_info['cardnumber']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}  ${managed_fuel_info['cardnumber2']}
    Should Not Be True  ${status}

Invalid Location Id
    [Tags]  JIRA:BOT-1887  qTest:32268505  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  locationid=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Location Id
    [Tags]  JIRA:BOT-1887  qTest:32268532  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  locationid=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Location Id
    [Tags]  JIRA:BOT-1887  qTest:32268647  Regression  refactor
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  locationid=${managed_fuel_info['locationid']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Fuel Type
    [Tags]  JIRA:BOT-1887  qTest:32268661  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  fueltype=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Fuel Type
    [Tags]  JIRA:BOT-1887  qTest:32268694  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  fueltype=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Fuel Type
    [Tags]  JIRA:BOT-1887  qTest:32268713  Regression  refactor
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  fueltype=${managed_fuel_info['fueltype']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Fuel Use
    [Tags]  JIRA:BOT-1887  qTest:32268741  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  fueluse=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Fuel Use
    [Tags]  JIRA:BOT-1887  qTest:32268760  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  fueluse=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Fuel Use
    [Tags]  JIRA:BOT-1887  qTest:32268777  Regression  refactor
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  fueluse=${managed_fuel_info['fueluse']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Quantity Allowed
    [Tags]  JIRA:BOT-1887  qTest:32268797  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  qtyallowed=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Quantity Allowed
    [Tags]  JIRA:BOT-1887  qTest:32268992  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  qtyallowed=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Quantity Allowed
    [Tags]  JIRA:BOT-1887  qTest:32269019  Regression  refactor
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  qtyallowed=${managed_fuel_info['qtyallowed']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Eff Date
    [Tags]  JIRA:BOT-1887  qTest:32269032  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  effdt=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Eff Date
    [Tags]  JIRA:BOT-1887  qTest:32269066  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  effdt=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Eff Date
    [Tags]  JIRA:BOT-1887  qTest:32269079  Regression  refactor
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  effdt=${managed_fuel_info['effdt']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Exp Date
    [Tags]  JIRA:BOT-1887  qTest:32269089  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  expdt=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Exp Date
    [Tags]  JIRA:BOT-1887  qTest:32269101  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  expdt=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

Typo Exp Date
    [Tags]  JIRA:BOT-1887  qTest:32269117  Regression  refactor
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set To Dictionary  ${managed_fuel_info}  expdt=${managed_fuel_info['expdt']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Invalid Action
    [Tags]  JIRA:BOT-1887  qTest:32269218  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    ${action}  Set Variable  1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should Not Be True  ${status}

Empty Action
    [Tags]  JIRA:BOT-1887  qTest:32269239  Regression
    [Documentation]
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    ${action}  Set Variable  ${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['cardnumber']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  ${action}
    Should not Be True  ${status}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Get Managed Fuel
    [Arguments]  ${carrier}
    ${query}  Catenate
    ...  SELECT mf.trip_seq_num AS tripSeq,
    ...         TRIM(mf.card_num) AS cardNumber,
    ...         mf.location_id AS locationId,
    ...         mf.fuel_type AS fuelType,
    ...         mf.fuel_use AS fuelUse,
    ...         mf.qty_allowed AS qtyAllowed,
    ...         TO_CHAR(TODAY+1, '%Y-%m-%dT%H:%M:%S') AS effDt,
    ...         TO_CHAR(TODAY+1, '%Y-%m-%dT%H:%M:%S') AS expDt
    ...  FROM managed_fuel mf
    ...         JOIN cards c ON mf.card_num = c.card_num
    ...  WHERE c.carrier_id = ${carrier}
    ...  ORDER BY mf.last_updated DESC
    ...  LIMIT 1
    ${output}  Query And Strip To Dictionary  ${query}
    ${tripNum}  Generate Random String  5  [NUMBERS]
    ${tripseq}  Get Last Sequence  ${carrier}  ${tripNum}
    ${cardnum}  Get Suitable Card Num  ${carrier}
    Set To Dictionary  ${output}  tripnumber=${tripNum}
    Set To Dictionary  ${output}  tripseq=${tripseq}
    Set To Dictionary  ${output}  cardnumber=${cardnum}
    [Return]  ${output}

Get Last Sequence
    [Arguments]  ${carrier_id}  ${trip_number}
    ${query}  Catenate
    ...  SELECT mf.trip_seq_num AS tripSeq
    ...  FROM managed_fuel mf
    ...           JOIN cards c ON mf.card_num = c.card_num
    ...  WHERE c.carrier_id = ${carrier_id}
    ...  AND  mf.trip_num = '${trip_number}'
    ...  ORDER BY mf.last_updated DESC
    ${output}  Query And Strip  ${query}
    ${tripseq}  Run Keyword If  '${output}'!='None'
    ...  Evaluate  ${output}+1
    ...  ELSE
    ...  Set Variable  1
    [Return]  ${tripseq}

Get Suitable Card Num
    [Arguments]  ${carrier}
    ${query}  Catenate
    ...  SELECT TRIM(c.card_num) as card_num FROM cards c
    ...  WHERE c.carrier_id = ${carrier}
    ...  AND c.status = 'A'
    ...  AND c.cardoverride = '0'
    ...  AND c.card_num NOT IN (SELECT mf.card_num FROM managed_fuel mf WHERE mf.carrier_id = 103866 AND mf.eff_dt != TODAY AND mf.exp_dt != TODAY)
    ...  LIMIT 1
    ${cardnum}  Query And Strip  ${query}
    [Return]  ${cardnum}