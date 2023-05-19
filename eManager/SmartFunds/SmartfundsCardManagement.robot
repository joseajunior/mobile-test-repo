*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  String
Library  otr_model_lib.Models

Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Documentation   SmartfundsCardManagement.robot\n\n\
...  Going to the Smartfund Card Management screen and flipping status for universal card\n\n
...  Universal Card Smartfunds Status: Active, Inactive, Hold, Follow Primary and validating in DB\n\n
...  And ATM: Allow, Disallow, Policy for universal AND Smartfund card

Force Tags  eManager

Suite Setup  Set Me Up

*** Variables ***
${status}
${validSFCard}

*** Test Cases ***

Universal Card Status = 'A'

    [Tags]  JIRA:BOT-203  qTest:34324341  refactor
    Set Suite Variable  ${carrier}  ${universalCard.carrier_id}
    Set Suite Variable  ${validCard.carrier.password}    ${universalCard.carrier.password}
    Set Suite Variable  ${card_num}  ${universalCard.card_num}

    Update Card Status
    Update Status  ACTIVE
    Validate Card Status in DB  ${card_num}  payr_status  A

Universal Card Status = 'I'
    [Tags]  JIRA:BOT-203  qTest:34324644  refactor

    Update Status  INACTIVE
    Validate Card Status in DB  ${card_num}  payr_status  I

Universal Card Status = 'H'
    [Tags]  JIRA:BOT-203  qTest:34324923  refactor

    Update Status  HOLD
    Validate Card Status in DB  ${card_num}  payr_status  H

Universal Card Status = 'Follow Primary'
    [Tags]  JIRA:BOT-203  qTest:34326067  refactor

    Update Status  FOLLOWS
    Validate Card Status in DB  ${card_num}  payr_status  F

Universal ATM Status: Allow
    [Tags]  JIRA:BOT-203  qTest:34326554  refactor

    Update Status  ALLOW
    Validate Card Status in DB  ${card_num}  payr_atm  Y

Universal ATM Status: Disallow
    [Tags]  JIRA:BOT-203  qTest:34326638  refactor

    Update Status  DISALLOW
    Validate Card Status in DB  ${card_num}  payr_atm  N

Universal ATM Status: Policy
    [Tags]  JIRA:BOT-203  qTest:34326655  refactor

    Update Status  POLICY
    Validate Card Status in DB  ${card_num}  payr_atm  D

SmartFunds ATM Status: Allow
    [Tags]  JIRA:BOT-203  qTest:34326736  refactor
    Set Suite Variable  ${carrier}  ${validSFCard.carrier_id}
    Set Suite Variable  ${validCard.carrier.password}    ${validSFCard.carrier.password}
    Set Suite Variable  ${card_num}  ${validSFCard.card_num}

    Update Smartfund Card Status
    Update Status  ALLOW
    Validate Card Status in DB  ${card_num}  payr_atm  Y

SmartFunds ATM Status: Disallow
    [Tags]  JIRA:BOT-203  qTest:34326823  refactor

    Update Status  DISALLOW
    Validate Card Status in DB  ${card_num}  payr_atm  N

SmartFunds ATM Status: Policy
    [Tags]  JIRA:BOT-203  qTest:34326849  refactor

    Update Status  POLICY
    Validate Card Status in DB  ${card_num}  payr_atm  D

Smartfunds card management restriction - Carrier Login
    [Tags]  JIRA:FRNT-1011  qTest:47335010  PI:6  refactor
    [Documentation]  This is to test when smartfunds card/policy management is restricted, it is actually restricted - carrier login

    #${sm_carrier}  Setup for card management restriction
    ${carrier}  set carrier variable  ${sm_carrier}
    ${pwd}  set Variable  ${carrier.password}
    Open eManager  ${sm_carrier}  ${pwd}
    Navigate to Smartfunds card management
    Select any card  ${sm_carrier}
    Check if everything is disabled
    set global variable  ${sm_carrier}
    [Teardown]  Teardown for card restriction  ${sm_carrier}

Smartfunds policy management restriction - Carrier Login
    [Tags]  JIRA:FRNT-1011  qTest:47335013  PI:6  refactor
    [Documentation]  This is to test when smartfunds card/policy management is restricted, it is actually restricted - carrier login

    Setup for policy management restriction  ${sm_carrier}
    ${carrier}  set carrier variable  ${sm_carrier}
    ${pwd}  set Variable  ${carrier.password}
    Open eManager  ${sm_carrier}  ${pwd}
    Navigate to policy management
    Check if elements are disabled
    [Teardown]  Teardown for policy restriction  ${sm_carrier}

Smartfunds card management restriction - Cust Info Test
    [Tags]  JIRA:FRNT-1011  qTest:47348473  PI:6  refactor
    [Documentation]  This is to test when smartfunds card/policy management is restricted, it is actually restricted - cust info test
    ${carrier_id}  Setup for card management restriction
    Open eManager  ${intern}  ${internPassword}
    Go to Cust Info Test  ${sm_carrier}
    Navigate to Smartfunds card management
    Select any card  ${sm_carrier}
    Check if everything is disabled
    [Teardown]  Teardown for card restriction  ${sm_carrier}

Smartfunds policy management restriction - Cust Info Test
    [Tags]  JIRA:FRNT-1011  qTest:47348473  PI:6  refactor
    [Documentation]  This is to test when smartfunds card/policy management is restricted, it is actually restricted - cust info test
    Setup for policy management restriction  ${sm_carrier}
    Open eManager  ${intern}  ${internPassword}
    Go to Cust Info Test  ${sm_carrier}
    Navigate to policy management
    Check if elements are disabled
    [Teardown]  Teardown for policy restriction  ${sm_carrier}

*** Keywords ***
Set Me Up

    ${vsfc_query}=  catenate  SELECT TRIM(c.card_num) as card_num
    ...    FROM cards c
    ...        JOIN def_card dc ON c.carrier_id = dc.id AND c.icardpolicy = dc.ipolicy
    ...        JOIN contract co ON dc.contract_id = co.contract_id
    ...        JOIN member m ON c.carrier_id = m.member_id
    ...    WHERE c.card_type = 'TCH'
    ...    AND c.card_num NOT LIKE '%OVER'
    ...    AND co.status = 'A'
    ...    AND m.status = 'A'
    ...    AND c.payr_status = 'A'
    ...    AND c.payr_use = 'P'
    ...    LIMIT 1
    #...    AND c.mrcsrc = 'L'
    ${validSFCard}=  find card variable  ${vsfc_query}
    set suite variable  ${validSFCard}
    Setup for card management restriction

Update Card Status
    Make Sure Carrier Is Active  ${carrier}
    Add User Role If Not Exists  ${carrier}  SMARTPAY_TRANSFER
    Add User Role If Not Exists  ${carrier}  CARD_PAYROLL_TRANS
    Open eManager  ${carrier}  ${validCard.carrier.password}
    Go To  ${emanager}/cards/SmartPayCardLookup.action?am=SMARTPAY_TRANSFER
    Click Radio Button  NUMBER
    Input Text  cardSearchTxt  ${card_num}
    Click Element  searchCard
    Click Link  //*[@id="cardSummary"]/tbody/tr/td[1]/a
    Page Should Contain Element  //*[. = 'Universal Card SmartFunds Status' ]/label   Universal Card Box Missing

Update Smartfund Card Status
    Make Sure Carrier Is Active  ${carrier}
    Add User Role If Not Exists  ${carrier}  SMARTPAY_TRANSFER
    Add User Role If Not Exists  ${carrier}  CARD_PAYROLL_TRANS
    Open eManager  ${carrier}  ${validCard.carrier.password}
    Go To  ${emanager}/cards/SmartPayCardLookup.action?am=SMARTPAY_TRANSFER
    Click Radio Button  NUMBER
    Input Text  cardSearchTxt  ${card_num}
    Click Element  searchCard
    Click Link  //*[@id="cardSummary"]/tbody/tr/td[1]/a

Update Status
    [Arguments]  ${status}

    Click Radio Button  ${status}
    Click Button  Save
    Wait Until Element Is Visible  //ul[@class='messages']/li[text()='You have successfully updated card.']

Validate Card Status in DB

    [Arguments]  ${card}  ${DBcolumn}  ${DBstatus}
    sleep  1
    Get Into DB  TCH
    ${cardStatus}  Query And Strip  SELECT ${DBColumn} FROM cards WHERE card_num = '${card}';
    Should be Equal As Strings  ${cardStatus}  ${DBStatus}

Switch Card

    [Arguments]  ${card}

    Go To  ${emanager}/cards/SmartPayCardLookup.action?am=SMARTPAY_TRANSFER
    Click Element  //input[@name='lookupInfoRadio'][@value='NUMBER']
    Input Text  cardSearchTxt  ${card}
    Click Element  searchCard
    Click Link  //*[@id="cardSummary"]/tbody/tr/td[1]/a
    Page Should Not Contain  //*[. = 'Universal Card SmartFunds Status' ]/label  This box is only for UNIVERSAL cards NOT SF

Grab Password From DB
    [Arguments]  ${DB}  ${carrier_id}

    Get Into DB  ${DB}
    ${passwd}  Query And Strip  SELECT TRIM(passwd) AS passwd FROM member WHERE member_id=${carrier_id}

    [Return]  ${passwd}


Setup for card management restriction
    get into db  mysql
    ${carrier}  query and strip to dictionary  select user_id,param_value from sec_user_role_param WHERE role_id = 'SMARTPAY_TRANSFER' and param_id = 'RESTRICTED' and user_id REGEXP '^[0-9]*$' limit 1;
    ${insert}  catenate  INSERT INTO sec_user_role_param (user_id,role_id,param_id,param_value) VALUES ('102698','MANAGE_POLICIES','RESTRICTED','ON');
    ${update}  catenate  UPDATE sec_user_role_param set param_value = 'ON' where user_id = '${carrier['user_id']}' and  role_id = 'SMARTPAY_TRANSFER' and param_id = 'RESTRICTED'
    run keyword if  "${carrier['user_id']}"=="{}"  execute sql string  ${insert}
    run keyword if  '${carrier['param_value']}'=='OFF'  execute sql string  ${update}
    ${carrier}  query and strip to dictionary  select user_id from sec_user_role_param WHERE role_id = 'SMARTPAY_TRANSFER' and param_id = 'RESTRICTED' and param_value = 'ON' and user_id REGEXP '^[0-9]*$' limit 1;
    ${sm_carrier}  assign string  ${carrier['user_id']}
    set Suite variable  ${sm_carrier}

Setup for policy management restriction
    [Arguments]  ${carrier}

    get into db  mysql
    ${company}  query and strip to dictionary  select company_id from sec_user where user_id = '${carrier}'
    ${value}  query and strip to dictionary  select param_value from sec_group_role_param where company_id = '${company['company_id']}' and group_id = 'COMPANY_ADMIN' and role_id = 'MANAGE_POLICIES' and param_id = 'RESTRICTED'
    ${insert}  catenate  INSERT INTO sec_group_role_param VALUES
    ...  ('${company['company_id']}','COMPANY_ADMIN','MANAGE_POLICIES','RESTRICTED','ON');
    ${update}  catenate  update sec_group_role_param set param_value = 'ON'
    ...  where company_id = '${company['company_id']}' and group_id = 'COMPANY_ADMIN'
    ...  and role_id = 'MANAGE_POLICIES' and param_id = 'RESTRICTED'
    run keyword if  "${value}"=="{}"  execute sql string  ${insert}
    run keyword if  '${value['param_value']}'=='OFF'  execute sql string  ${update}


Teardown for card restriction
    [Arguments]  ${carrier_id}
    get into db  mysql
    execute sql string  dml=update sec_user_role_param set param_value = 'OFF' WHERE user_id ='${carrier_id}' and role_id = 'SMARTPAY_TRANSFER' and param_id = 'RESTRICTED';
    close browser
    disconnect from database

Teardown for policy restriction
    [Arguments]  ${carrier_id}
    get into db  mysql
    ${company_id}  query and strip to dictionary  select company_id from sec_user where user_id = '${carrier_id}';
    execute sql string  dml=update sec_group_role_param set param_value='OFF' where company_id = '${company_id['company_id']}' and role_id = 'MANAGE_POLICIES' and param_id = 'RESTRICTED';
    close browser
    disconnect from database

Navigate to Smartfunds card management
    go to  ${emanager}/cards/SmartPayCardLookup.action?am=SMARTPAY_TRANSFER

Select any card
    [Arguments]  ${carrier}
    get into db  TCH

    ${card}  query and strip to dictionary  select card_num from cards where carrier_id = '${carrier}' and card_num not like 'OVER%' and status!= 'D' and (payr_status = 'A' or payr_use = 'P') limit 1;
    input text  cardSearchTxt  ${card['card_num'].strip()}
    click button  searchCard
    click link  //*[@id="cardSummary"]//*[contains(text(), '${card['card_num'].strip()}')]

Check if everything is disabled
    element should be disabled  card.header.payrollAtm
    element should be disabled  card.header.payrollChk
    element should be disabled  card.header.payrollAch
    element should be disabled  card.header.payrollWire
    element should be disabled  card.header.payrollDebit

Navigate to policy management
    go to  ${emanager}/cards/PolicyPromptManagement.action

Check if elements are disabled
    element should be disabled  radioHandEnter
    element should be disabled  policy.header.contractId
    element should not be visible  createPromptPolicy

Go to Cust Info Test
     [Arguments]  ${carrier}
    Go To  ${emanager}/security/ManageCustomers.action
    Select From List By Label  name=searchType  User Id
    Input Text  name=searchValue  ${carrier}
    Click Element  name=SearchCustomers
    Click Element  //td[count(//th/a[text()='User ID'])]/a[text()='${carrier}']
    Page Should Contain Element  //a[@href="/security/ManageCustomers.action" and text()='Customer Info']
