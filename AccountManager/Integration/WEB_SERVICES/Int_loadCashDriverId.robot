*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_model_lib.Models

Force Tags  Integration  Shifty  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${amount}  1
${oneTimeCash}  0
${smartfunds}  1

*** Test Cases ***
Valid Parameters For All Fields Adding to Cash
    [Tags]  qTest:31065730
    [Documentation]  Insert all parameters, payroll=0 and expect a positive response.

    ${ref_num}  Generate Random String  6
    ${balance}  Get Card Balance by Card Number  ${validCard.num}
    loadCashDriverId  ${prompt}  ${amount}  ${ref_num}  ${oneTimeCash}
    Validate Cash Addition  ${validCard.num}  ${amount}  ${balance}  ${ref_num}

Valid Parameters For All Fields Adding to Smartfunds
    [Tags]  qTest:31065731
    [Documentation]  Insert all parameters, payroll=1 and expect a positive response.

    ${ref_num}  Generate Random String  6

    ${balance}  Get Card Balance by Card Number  ${validCard.num}  ${smartfunds}
    loadCashDriverId  ${prompt}  ${amount}  ${ref_num}  ${smartfunds}
    Validate Cash Addition  ${validCard.num}  ${amount}  ${balance}  ${ref_num}  ${smartfunds}

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

#   MAKE SURE THE CONTRACT WONT HAVE CASH LOAD/REMOVE FEE as driver Fee.
    ${status}  Run Keyword And Return Status  Row Count Is Equal To X  SELECT * FROM driver_fees WHERE contract_id = ${validCard.policy.contract.id} AND carrier_id=${validCard.carrier.id} AND fee_id = 115  1
    Run Keyword IF  '${status}'=='${true}'  execute sql string   dml=DELETE FROM driver_fees WHERE contract_id = ${validCard.policy.contract.id} AND carrier_id=${validCard.carrier.id} AND fee_id = 115
    ...  ELSE  Tch Logging  THIS CONTRACT DOESNT HAVE CASH LOAD/REMOVE FEE as driver Fee.

   ${prompt}  Generate Random String  4  [NUMBERS]
   Set Suite Variable  ${prompt}

    Start Setup Card  ${validCard.num}
    Setup Card Header  status=ACTIVE
    Setup Card Prompts  UNIT=V${prompt}  DRID=V${prompt}

Teardown WS
    Disconnect From Database
    Logout

Get Card Balance by Card Number
    [Arguments]  ${card_num}  ${table}=cash_adv
    ${table}  Set Variable If  '${table}' != 'cash_adv'  payr_cash_adv  cash_adv
    ${query}  Catenate  SELECT DECODE(balance, NULL, 0, balance) AS balance FROM ${table} WHERE card_num='${card_num}' ORDER BY when DESC limit 1
    ${balance}  Query And Strip  ${query}
    [Return]  ${balance}


Validate Cash Addition
    [Arguments]  ${card_num}  ${amount}  ${balance}  ${ref_num}  ${table}=cash_adv
    ${table}  Set Variable If  '${table}' != 'cash_adv'  payr_cash_adv  cash_adv
    ${id}  Set Variable If  ${amount} < 0  RMVE  LOAD
    ${nem_balance}  Evaluate  ${amount} + ${balance}
    ${normalize_amount}  Evaluate  ${amount} * -1
    ${amount}  Set Variable If  ${amount} < 0  ${normalize_amount}  ${amount}
    Sleep  2  # Waiting to make sure WS load was reflected in DB
    ${query}  Catenate  SELECT amount, DECODE(balance, NULL, 0, balance) AS balance, id, TRIM(ref_num) AS ref_num FROM ${table} WHERE card_num='${card_num}' ORDER BY when DESC limit 1
    ${database}  Query and Strip to Dictionary  ${query}

    Should Be Equal as Numbers  ${amount}  ${database["amount"]}
    Should Be Equal as Numbers  ${nem_balance}  ${database["balance"]}
    Should Be Equal as Strings  ${id}  ${database["id"]}
    Should Be Equal as Strings  ${ref_num}  ${database["ref_num"]}
