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
${managed_fuel_info}

*** Test Cases ***
Manage Fuel Driver Action With Valid Input
    [Tags]  JIRA:BOT-1566  qTest:32442942  Regression  run  refactor
    [Documentation]  Insert all parameters and expect a positive response.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    ${status}  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should Be Equal  ${status}  Success

Empty Trip Number
    [Tags]  JIRA:BOT-1566  qTest:32442943  Regression
    [Documentation]  Insert an Empty Trip Number parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    Set To Dictionary  ${managed_fuel_info}  tripnumber=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Trip Sequence
    [Tags]  JIRA:BOT-1566  qTest:32442944  Regression
    [Documentation]  Insert Invalid Trip Sequence parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  tripseq=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should Not Be True  ${status}

Empty Trip Sequence
    [Tags]  JIRA:BOT-1566  qTest:32442945  Regression
    [Documentation]  Insert Empty Trip Sequence parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  tripseq=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Trip Sequence
    [Tags]  JIRA:BOT-1566  qTest:32442946  Regression
    [Documentation]  Insert Typo Trip Sequence parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  tripseq=${managed_fuel_info['tripnumber']}f
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should Not Be True  ${status}

Invalid Driver ID
    [Tags]  JIRA:BOT-1566  qTest:32442947  Regression
    [Documentation]  Insert Invalid Driver ID parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    ${driverID}  Generate Random String  16  [LETTERS]
    Set To Dictionary  ${managed_fuel_info}  driverid=${driverID}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should Not Be True  ${status}

Empty Driver ID
    [Tags]  JIRA:BOT-1566  qTest:32442948  Regression
    [Documentation]  Insert Empty Driver ID parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  driverid=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Driver ID
    [Tags]  JIRA:BOT-1566  qTest:32442949  Regression
    [Documentation]  Insert Typo Driver ID parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  driverid=${managed_fuel_info['driverid']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Driver ID 2
    [Tags]  JIRA:BOT-1566  qTest:32442950  Regression
    [Documentation]  Insert Invalid Driver ID 2 parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    ${driverId}  Generate Random String  16  [LETTERS]
    Set To Dictionary  ${managed_fuel_info}  driverid2=${driverId}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00  ${managed_fuel_info['driverid2']}
    Should Not Be True  ${status}

Typo Driver ID 2
    [Tags]  JIRA:BOT-1566  qTest:32442951  Regression
    [Documentation]  Insert Driver ID 2 Sequence parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  driverid2=${managed_fuel_info['driverid']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00  ${managed_fuel_info['driverid2']}
    Should Not Be True  ${status}

Invalid Location Id
    [Tags]  JIRA:BOT-1566  qTest:32442952  Regression
    [Documentation]  Insert Invalid Location Id parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    Set To Dictionary  ${managed_fuel_info}  locationid=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Empty Location Id
    [Tags]  JIRA:BOT-1566  qTest:32442953  Regression
    [Documentation]  Insert Empty Location Id parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  locationid=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Location Id
    [Tags]  JIRA:BOT-1566  qTest:32442954  Regression
    [Documentation]  Insert Typo Location Id parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  locationid=${managed_fuel_info['locationid']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Fuel Type
    [Tags]  JIRA:BOT-1566  qTest:32442955  Regression
    [Documentation]  Insert Invalid Fuel Type parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    Set To Dictionary  ${managed_fuel_info}  fueltype=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Empty Fuel Type
    [Tags]  JIRA:BOT-1566  qTest:32442956  Regression
    [Documentation]  Insert Empty Fuel Type parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  fueltype=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Fuel Type
    [Tags]  JIRA:BOT-1566  qTest:32442957  Regression
    [Documentation]  Insert Typo Fuel Type parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  fueltype=${managed_fuel_info['fueltype']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Fuel Use
    [Tags]  JIRA:BOT-1566  qTest:32442958  Regression
    [Documentation]  Insert Invalid Fuel Use parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    Set To Dictionary  ${managed_fuel_info}  fueluse=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Empty Fuel Use
    [Tags]  JIRA:BOT-1566  qTest:32442959  Regression
    [Documentation]  Insert Empty Fuel Use parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  fueluse=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Fuel Use
    [Tags]  JIRA:BOT-1566  qTest:32442960  Regression
    [Documentation]  Insert Typo Fuel Use parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  fueluse=${managed_fuel_info['fueluse']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Quantity Allowed
    [Tags]  JIRA:BOT-1566  qTest:32442961  Regression
    [Documentation]  Insert Invalid Quantity Allowed parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    Set To Dictionary  ${managed_fuel_info}  qtyallowed=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Empty Quantity Allowed
    [Tags]  JIRA:BOT-1566  qTest:32442962  Regression
    [Documentation]  Insert Empty Quantity Allowed parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  qtyallowed=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Quantity Allowed
    [Tags]  JIRA:BOT-1566  qTest:32442963  Regression
    [Documentation]  Insert Typo Quantity Allowed parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  qtyallowed=${managed_fuel_info['qtyallowed']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Eff Date
    [Tags]  JIRA:BOT-1566  qTest:32442964  Regression
    [Documentation]  Insert Invalid Eff Date parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    Set To Dictionary  ${managed_fuel_info}  effdt=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Empty Eff Date
    [Tags]  JIRA:BOT-1566  qTest:32442965  Regression
    [Documentation]  Insert Empty Eff Date parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  effdt=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Eff Date
    [Tags]  JIRA:BOT-1566  qTest:32442966  Regression
    [Documentation]  Insert Typo Eff Date parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  effdt=${managed_fuel_info['effdt']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Exp Date
    [Tags]  JIRA:BOT-1566  qTest:32442967  Regression
    [Documentation]  Insert Invalid Exp Date parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    Set To Dictionary  ${managed_fuel_info}  expdt=1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Empty Exp Date
    [Tags]  JIRA:BOT-1566  qTest:32442968  Regression
    [Documentation]  Insert Empty Exp Date parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  expdt=${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Typo Exp Date
    [Tags]  JIRA:BOT-1566  qTest:32442969  Regression
    [Documentation]  Insert Typo Exp Date parameter and expect an error.
    Set To Dictionary  ${managed_fuel_info}  expdt=${managed_fuel_info['expdt']}TYPO
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Invalid Action
    [Tags]  JIRA:BOT-1566  qTest:32442970  Regression
    [Documentation]  Insert Invalid Action parameter and expect an error.
    ${managed_fuel_info}  Get Managed Fuel  ${validCard.carrier.id}
    Set Suite Variable  ${managed_fuel_info}
    ${action}  Set Variable  1nv@l1d
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

Empty Action
    [Tags]  JIRA:BOT-1566  qTest:32442971  Regression
    [Documentation]  Insert Empty Action parameter and expect an error.
    ${action}  Set Variable  ${EMPTY}
    ${status}  Run Keyword and Return Status  managedFuelDriverAction  ${managed_fuel_info['tripnumber']}  ${managed_fuel_info['tripseq']}  ${managed_fuel_info['driverid']}  ${managed_fuel_info['locationid']}  ${managed_fuel_info['fueltype']}  ${managed_fuel_info['fueluse']}  ${managed_fuel_info['qtyallowed']}  ${action}  ${managed_fuel_info['effdt']}  ${managed_fuel_info['expdt']}  00:00:00  10:00:00
    Should not Be True  ${status}

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Get Managed Fuel
    [Arguments]  ${carrier}
    ${query}  Catenate
    ...  SELECT mf.trip_seq_num AS tripSeq,
    ...         TRIM(mf.card_num) AS cardNumber,
    ...         mf.location_id AS locationId,
    ...         mf.fuel_type AS fuelType,
    ...         mf.fuel_use AS fuelUse,
    ...         mf.qty_allowed AS qtyAllowed,
    ...         TO_CHAR(TODAY+1, '%Y-%m-%d') AS effDt,
    ...         TO_CHAR(TODAY+1, '%Y-%m-%d') AS expDt
    ...  FROM managed_fuel mf
    ...         JOIN cards c ON mf.card_num = c.card_num
    ...  WHERE c.carrier_id = ${carrier}
    ...  ORDER BY mf.last_updated DESC
    ...  LIMIT 1
    ${output}  Query And Strip To Dictionary  ${query}
    ${tripNum}  Generate Random String  5  [NUMBERS]
    ${tripseq}  Get Last Sequence  ${carrier}  ${tripNum}
    ${driverId}  Get Suitable Driver ID  ${carrier}
    Set To Dictionary  ${output}  tripnumber=${tripNum}
    Set To Dictionary  ${output}  tripseq=${tripseq}
    Set To Dictionary  ${output}  driverid=${driverId}
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

Get Suitable Driver ID
    [Arguments]  ${carrier}
    ${driverId}  Generate Random String  6  [NUMBERS]
    ${query}  Catenate
    ...  SELECT TRIM(c.card_num) AS card_num FROM cards c
    ...  WHERE c.card_num NOT IN (SELECT mf.card_num FROM managed_fuel mf
    ...                            WHERE mf.carrier_id = ${carrier}
    ...                            AND mf.eff_dt != TODAY
    ...                            AND mf.exp_dt != TODAY)
    ...  AND c.carrier_id=${carrier}
    ...  ORDER BY lastupdated DESC LIMIT 1;

    ${card}  Query And Strip  ${query}
    Start Setup Card  ${card}
    Setup Card Header  status=ACTIVE  override=0  infoSource=CARD
    Setup Card Prompts  DRID=V${driverId}

    [Return]  ${driverId}