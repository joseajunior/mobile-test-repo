*** Settings ***
Test Timeout  5 minutes
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyTimer
Library  otr_robot_lib.setup.PySetup
Library  otr_robot_lib.auth.PyAuth.StringBuilder
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  ../../Variables/validUser.robot


Suite Setup  Time To Setup
Force Tags  eManager

*** Variables ***
${ODRD2}
${unit}  123456

*** Test Cases ***
Verifying Accural checks
    [Tags]  JIRA:BOT-125  qtest:32792918  qTest:34243415  JIRA:BOT-1935  refactor
    [Setup]  Set Up Card
    [Documentation]  This is a test suite for BOT-125\\n
    ...   This script is to test Accrual Check prompt for Odometer
    ...   It first sets the accrual prompt check for a card
    ...   Run two transactions one after the other
    ...   Positive case: Second transaction odometer value should always be greater than first transaction odometer value
    ...   Negative case: Odometer value lower than previous transaction's odometer should be rejected
    ...   After the above tests are done, the prompt is deleted since duplicate prompts cannot be added in the next run
   ${ODRD1}=  Run a transaction
   ${ODRD2}=  Run a transaction


Negative test
   [Tags]  refactor
   [Documentation]  This is to make sure if the user gives an invalid odometer, 1 less than whats is needed, the transaction should fail
   Run a transaction for invalid odometer

*** Keywords ***
Time To Setup
    ${month}=    getdatetimenow  %m
    ${today}=    getdatetimenow  %Y%m%d%H%M
    set global variable  ${month}
    set global variable  ${today}


Set Up Card
    Run Keyword And Ignore Error  Make Sure Carrier Is Active  ${validCard.carrier.id}
    Get Into DB  TCH
    Start Setup Card  ${validCard.num}
    Setup Card Header  status=ACTIVE  infoSource=CARD  limitSource=CARD
    Setup Card Prompts  ODRD=R10  UNIT=V${unit}
    Setup Card Limits  ULSD=1000
    Update Contract Limits by Card  ${validCard.num}

#   TURN OFF THE MANAGED FUEL FLAG FROM THE CARD NUMBER TO PREVENT LIMIT EXCEEDED ERRORS
    ${managed_fuel}  Query And Strip  SELECT managed_fuel FROM cards WHERE card_num='${validCard.num}'
    Run Keyword IF  '${managed_fuel}'!='N'  Execute SQL String  dml=UPDATE cards SET managed_fuel='N' WHERE card_num='${validCard.num}'

Run a transaction
    get into db  TCH

    ${ODRD}=  query and strip  select sum(lm.mileage)+1 from cards c, last_mile lm where c.carrier_id = lm.carrier_id and c.card_num = '${validCard.num}' and unit = '${unit}' and code = 'ODRD';
    #This Means the card hasn't used the odometer reading yet so using a value will set the initial value :)
    ${ODRD}=  run keyword if  ${ODRD} is None  assign string  100  ELSE  assign string  ${ODRD}
    start ac string
    set string location  ${validCard.valid_location.id}
    set string card  ${validCard.num}
    use dynamic invoice
    add info prompt value to string  UNIT  ${unit}
    add info prompt value to string  ODRD  ${ODRD}
    add fuel item to string  8192  1  3.00  2
    ${ACstring}=  finalize string
    ${AuthLog}=  create log file  rossAuth
    run rossAuth   ${ACstring}  ${AuthLog}
    set log file  ${AuthLog}
    log should have a trans id
    tch logging  \n\tUNIT NUMBER: ${unit}  DEBUG
    tch logging  \n\tODRD: ${ODRD.__str__().strip()}  DEBUG

    [Return]  ${ODRD.__str__().strip()}

Run a transaction for invalid odometer

    get into db  TCH
    ${unit}=  query and strip  select right(trim(info_validation), len(info_validation)-1) from card_inf where card_num = '${validCard.num}' and info_id = 'UNIT'
    ${ODRD}=  query and strip  select lm.mileage-1 from cards c, last_mile lm where c.carrier_id = lm.carrier_id and c.card_num = '${validCard.num}' and unit = '${unit}' and code = 'ODRD';
    start ac string
    set string location  ${validCard.valid_location.id}
    set string card  ${validCard.num}
    use dynamic invoice
    add info prompt value to string  UNIT  ${unit}
    add info prompt value to string  ODRD  ${ODRD}
    add fuel item to string  8192  1  3.00  2
    ${ACstring}=  finalize string
    ${AuthLog}=  create log file  rossAuth
    run rossAuth   ${ACstring}  ${AuthLog}
    set log file  ${AuthLog}
    auth log should contain error  INVALID ODOMETER ENTRY












