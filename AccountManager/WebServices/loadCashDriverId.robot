*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${driverId}  BOT1600
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

Valid Parameters For All Fields Removing from Cash
    [Documentation]  Insert all parameters, payroll=0 and expect a positive response.
    [Tags]  JIRA:BOT-1600  qTest:31065732  Regression

    ${ref_num}  Generate Random String  6
    ${balance}  Get Card Balance by Card Number  ${validCard.num}
    loadCashDriverId  ${prompt}  -${amount}  ${ref_num}  ${oneTimeCash}
    Validate Cash Addition  ${validCard.num}   -${amount}  ${balance}  ${ref_num}

Valid Parameters For All Fields Removing from Smartfunds
    [Documentation]  Insert all parameters, payroll=1 and expect a positive response.
    [Tags]  JIRA:BOT-1600  qTest:31065733  Regression
    ${ref_num}  Generate Random String  6
    ${balance}  Get Card Balance by Card Number  ${validCard.num}  ${smartfunds}
    loadCashDriverId  ${prompt}  -${amount}  ${ref_num}  ${smartfunds}
    Validate Cash Addition  ${validCard.num}  -${amount}  ${balance}  ${ref_num}  ${smartfunds}

Zero as Amount
    [Documentation]  Insert all parameters, Zero as Amount and expect a positive response.
    [Tags]  JIRA:BOT-1600  qTest:31065734  Regression

    ${ref_num}  Generate Random String  6
    ${balance}  Get Card Balance by Card Number  ${validCard.num}
    loadCashDriverId  ${prompt}  0  ${ref_num}  ${oneTimeCash}
    Validate Cash Addition  ${validCard.num}   0  ${balance}  ${ref_num}

Invalid Driver ID
    [Documentation]  Insert Invalid Driver ID parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065735  Regression
    Run Keyword And Expect Error  *  loadCashDriverId  1nv@l1d  ${amount}

Typo Driver ID
    [Documentation]  Insert Typo Driver ID parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065736  Regression
    Run Keyword And Expect Error  *  loadCashDriverId   ${prompt}f  ${amount}

Empty Driver ID
    [Documentation]  Insert an Empty Driver ID parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065737  Regression
    Run Keyword And Expect Error  *  loadCashDriverId  ${empty}  ${amount}

Invalid Amount
    [Documentation]  Insert Invalid Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065738  Regression
    Run Keyword And Expect Error  *  loadCashDriverId  ${prompt}  1nv@l1d

Typo Amount
    [Documentation]  Insert Typo Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065739  Regression
    Run Keyword And Expect Error  *  loadCashDriverId  ${prompt}  *

Empty Amount
    [Documentation]  Insert an Empty Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065740  Regression
    Run Keyword And Expect Error  *  loadCashDriverId  ${prompt}  ${empty}

Invalid Payroll
    [Documentation]  Insert Invalid Payroll parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065741  Regression
    Run Keyword And Expect Error  *  loadCashDriverId  ${prompt}  ${amount}  payroll=1nv@l1d

Typo Payroll
    [Documentation]  Insert Typo Payroll parameter and expect an error.
    [Tags]  JIRA:BOT-1600  qTest:31065742  Regression
    Run Keyword And Expect Error  *  loadCashDriverId  ${prompt}  ${amount}  payroll=1f

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

#   MAKE SURE THE CONTRACT WONT HAVE CASH LOAD/REMOVE FEE as driver Fee.
    ${status}  Run Keyword And Return Status  Row Count Is Equal To X  SELECT * FROM driver_fees WHERE contract_id = ${validCard.policy.contract.id} AND carrier_id=${validCard.carrier.id} AND fee_id = 115  1
    Run Keyword IF  '${status}'=='${true}'  execute sql string   dml=DELETE FROM driver_fees WHERE contract_id = ${validCard.policy.contract.id} AND carrier_id=${validCard.carrier.id} AND fee_id = 115
    ...  ELSE  Tch Logging  THIS CONTRACT DOESNT HAVE CASH LOAD/REMOVE FEE as driver Fee.

   ${prompt}  Generate Random String  6  [NUMBERS]
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
    ${query}  Catenate  SELECT balance FROM ${table} WHERE card_num='${card_num}' ORDER BY when DESC limit 1
    ${balance}  Query And Strip  ${query}
    [Return]  ${balance}

Validate Cash Addition
    [Arguments]  ${card_num}  ${amount}  ${balance}  ${ref_num}  ${table}=cash_adv
    ${table}  Set Variable If  '${table}' != 'cash_adv'  payr_cash_adv  cash_adv
    ${id}  Set Variable If  ${amount} < 0  RMVE  LOAD
    ${nem_balance}  Evaluate  ${amount} + ${balance}
    ${normalize_amount}  Evaluate  ${amount} * -1
    ${amount}  Set Variable If  ${amount} < 0  ${normalize_amount}  ${amount}
    ${query}  Catenate  SELECT amount, balance, id, TRIM(ref_num) AS ref_num FROM ${table} WHERE card_num='${card_num}' ORDER BY when DESC limit 1
    ${database}  Query and Strip to Dictionary  ${query}

    Should Be Equal as Numbers  ${amount}  ${database["amount"]}
    Should Be Equal as Numbers  ${nem_balance}  ${database["balance"]}
    Should Be Equal as Strings  ${id}  ${database["id"]}
    Should Be Equal as Strings  ${ref_num}  ${database["ref_num"]}
