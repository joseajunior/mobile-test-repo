*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags      eManager

*** Variables ***
${carrier}
${contract}
${invoice}
${last_payment_create}
${last_payment_amount}

*** Test Cases ***
Verify Partner Statements Information Screen
    [Tags]  Jira:ROCKET-197  qTest:54611175  PI:12  API:Y
    [Setup]  Setup Parkland Carrier
    SELECT PROGRAM > "Statements & Payments" > "Statements Info"
    Verify Partner Statements Information
    [Teardown]  close browser

Verify Old Text for non Parkland User
    [Tags]  Jira:ROCKET-169  qTest:54340507  PI:12  API:Y
    [Setup]  Find a Non Parkland carrier
    Open Emanager, Login, and Navigate to Statement Information
    Verify Page has  Payments may not be reflected in this total for up to 24 hours
    [Teardown]  close browser

Verify New Text for Parkland User
    [Tags]  Jira:ROCKET-169  qTest:54340508  PI:12  API:Y
    [Setup]  Find a Parkland carrier
    Open Emanager, Login, and Navigate to Statement Information
    Verify Page has  Payments and balance owing are updated every business day
    [Teardown]  close browser

Verify New Text for french Parkland User
    [Tags]  Jira:ROCKET-169  qTest:54340509  PI:12  API:Y
    [Setup]  Find a Parkland carrier
    Open Emanager, Login, and Navigate to Statement Information  FR
#    Verify Page has  Les paiements récents peuvent prendre jusqu'à 24 h pour être inclus dans ce total
    Verify Page has  Les paiements et le solde dû sont mis à jour chaque jour ouvrable
    [Teardown]  close browser

Verify Partner Statements Information Handle Voids
    [Tags]  Jira:ROCKET-285  qTest:116335436  PI:14  API:Y
    [Setup]  Find a Parkland carrier with Payment Data
    Open eManager  ${intern}  ${internPassword}
    Switch to "${carrier}" user
    Insert a Void Payment
    Go To Select Program > Statements & Payment > Statements Info
    Select The Contract     ${contract}
    Get Last Successful Payment
    Check If Page is Showing Last Successful Payment
    [Teardown]   Remove Void payment and close browser

*** Keywords ***
Open Emanager, Login, and Navigate to Statement Information
    [Tags]  qtest
    [Documentation]  Login to emanager as carrier follow TC-1361
    ...  go to select program > Statements & Payments > Statement Information
    [Arguments]  ${lang}=EN
    Open Browser to eManager
    IF  '${lang}'=='FR'
        click element  //a[contains(text(),'En Français, cliquer ici')]
    END
    Log into eManager  ${carrier.id}  ${carrier.password}  ChangeCompanyHeader=False
    Go To  ${emanager}/cards/StatementsInformation.action

Find a Parkland carrier
    [Tags]  qtest
    [Documentation]  Need to find a parkland carrier and password in TCH database
    ...  select member_id from member where carrier_type = 'PKLN'
    ...  select passwd from member where member_id = <carrier found from invoice_detail table>
    ...  ---------
    ...  Follow TC-4254 to make sure role STATEMENTS_INFORMATION is assigned to carrier
    ${informixmembersql}  catenate  select member_id from member where carrier_type = 'PKLN' and status='A'
    ${carrier}  Find Carrier Variable  ${informixmembersql}  member_id  TCH
    Set Test Variable  ${carrier}
    ${cnt}  query and strip  select count(*) from sec_user where user_id = ${carrier.id}  db_instance=MYSQL
    IF  ${cnt} < 1
        Open Browser to eManager
        Log into eManager  ${carrier.id}  ${carrier.password}  ChangeCompanyHeader=False
        close browser
    END
    Add User Role If Not Exists  ${carrier.id}  STATEMENTS_INFORMATION

Find a Non Parkland carrier
    [Tags]  qtest
    [Documentation]  Need to find a non parkland carrier and password in TCH database
    ...  select member_id from member where carrier_type = 'TCH' and status = 'A' and mem_type = 'C'
    ...  select passwd from member where member_id = <carrier found from invoice_detail table>
    ...  ---------
    ...  Follow TC-4254 to make sure role STATEMENTS_INFORMATION is assigned to carrier
    ${informixmembersql}  catenate  select member_id from member where carrier_type = 'TCH' and status='A' and mem_type = 'C'
    ${carrier}  Find Carrier Variable  ${informixmembersql}    member_id    TCH
    Set Test Variable  ${carrier}
    ${cnt}  query and strip  select count(*) from sec_user where user_id = ${carrier.id}  db_instance=MYSQL
    IF  ${cnt} < 1
        Open Browser to eManager
        Log into eManager  ${carrier.id}  ${carrier.password}  ChangeCompanyHeader=False
        close browser
    END
    Add User Role If Not Exists  ${carrier.id}  STATEMENTS_INFORMATION

Verify Page has
    [Tags]  qtest
    [Documentation]  arg0
    [Arguments]  ${message}
    page should contain  ${message}

Starting My Suite
    ${today}  getdatetimenow  %Y-%m-%d
    set suite variable  ${today}

Setup Parkland Carrier
    [Tags]  qTest
    [Documentation]  find a parkland carrier set up for payments in the postgres db:
                ...  select p.carrier_id from payment_detail p join open_ar o ON p.carrier_id = o.carrier_id where p.carrier_id >= 2500000 order by o.created_at limit 1;
    ${sql}  catenate  select p.carrier_id from payment_detail p join open_ar o ON p.carrier_id = o.carrier_id where p.carrier_id >= 2500000 order by o.created_at limit 1;
    ${carrier_id}  query and strip  ${sql}  db_instance=postgrespgpricing
    set test variable  ${carrier_id}
    ${sql2}  catenate  select * from contract where carrier_id = ${carrier_id}
    ${contract}  query and strip to dictionary  ${sql2}  db_instance=TCH
    set test variable  ${contract}
    Add User Role If Not Exists  ${carrier_id}  PARTNER_STATEMENTS_INFORMATION  menu_visible=1
    Remove Carrier User Permission  ${carrier_id}  STATEMENTS_INFORMATION
    Open eManager  ${intern}  ${internPassword}
    Select Program > "User Administration" > "Customer Info Test"
    Select From List By Value  searchType  1
    Input Text  searchValue  ${carrier_id}
    Click Element  SearchCustomers
    Click Element  //*[@id="searchCustomerTable"]/tbody/tr/td[1]/a[text()='${carrier_id}']

Verify Partner Statements Information
    [Tags]  qTest
    [Documentation]  verify the information displayed against the database. For Available Balance, check if
                ...  contract.limit_method = 2, then balance is contract.daily_limit - contract.credit_bal
                ...  Otherwise, balance is contract.credit_limit - contract.credit_bal
                ...  query postgres DB for the other fields:
                ...  select op.credit_limit,op.balance_owing,pd.payment_amount,TO_CHAR(pd.payment_create, 'YYYY-MM-DD') as payment_create
                ...  from payment_detail pd, open_ar op
                ...  where pd.carrier_id = op.carrier_id
                ...  and pd.contract_id = op.contract_id
                ...  and pd.contract_id = 'contract['contract_id']'
                ...  and pd.carrier_id =  '{carrier_id}' ORDER BY payment_create desc limit 1;
    ${Available_bal}  calculate balance
    ${availableBalance}  get text  availableBalance
    ${availableBalance}  remove string  ${availableBalance}  $  ,
    ${creditLimit}  get text  creditLimit
    ${creditLimit}  remove string  ${creditLimit}  $  ,
    ${balanceOwing}  get text  balanceOwing
    ${balanceOwing}  remove string  ${balanceOwing}  $  ,
    ${dateOfLastPayment}  get text  dateOfLastPayment
    ${amountOfLastPayment}  get text  amountOfLastPayment
    ${amountOfLastPayment}  remove string  ${amountOfLastPayment}  $  ,
    ${notes}  get text  notes

    ${sql}  catenate  select op.credit_limit,op.balance_owing,pd.payment_amount,TO_CHAR(pd.payment_create, 'YYYY-MM-DD') as payment_create
                ...  from payment_detail pd, open_ar op
                ...  where pd.carrier_id = op.carrier_id
                ...  and pd.contract_id = op.contract_id
                ...  and pd.contract_id = '${contract['contract_id']}'
                ...  and pd.carrier_id =  '${carrier_id}' ORDER BY payment_create desc limit 1;
    ${payments}  query and strip to dictionary  ${sql}  db_instance=postgrespgpricing
    ${sql2}  catenate  select orig_limit from cont_misc where contract_id = '${contract['contract_id']}';
    ${orig_limit}  query and strip  ${sql2}  db_instance=tch
    should be equal as numbers  ${availableBalance}  ${Available_bal}  precision=2
    should be equal as numbers  ${creditLimit}  ${orig_limit}  precision=0
    should be equal as numbers  ${balanceOwing}  ${payments['balance_owing']}  precision=2
    should be equal as numbers  ${amountOfLastPayment}  ${payments['payment_amount']}
    should be equal as strings  ${dateOfLastPayment}  ${payments['payment_create']}

Calculate Balance
    IF  ${contract['limit_method']}==2
        ${Available_bal}  evaluate  ${contract['daily_limit']} - ${contract['credit_bal']}
    ELSE
        ${Available_bal}  evaluate  ${contract['credit_limit']}- ${contract['credit_bal']}
    END
    [Return]  ${Available_bal}

Go To Select Program > Statements & Payment > Statements Info
    [Tags]  qTest
    [Documentation]  Go To Select Program > Statements & Payment > Statements Info
    Go To    ${emanager}/cards/PartnerStatementsInformation.action
    Wait Until Page Contains    Statements Information

Select The Contract
    [Tags]  qTest
    [Documentation]  Select The Contract under Statements Info screen
    [Arguments]     ${contract}
    Select From List By Value    //*[@name="contractIdSel"]     ${contract}

Check If Page is Showing Last Successful Payment
    [Tags]  qTest
    [Documentation]  Verify the amount of the last payment on the screen.
    ${amount_of_last_payment}    Get Text    //td[@id="amountOfLastPayment"]
    ${date_of_last_payment}      Get Text    //td[@id="dateOfLastPayment"]
    ${amount_of_last_payment}    Fetch From Right   ${amount_of_last_payment}   $
    ${amount_of_last_payment}    Replace String    ${amount_of_last_payment}   ,    ${EMPTY}
    Should Be Equal    ${amount_of_last_payment}     ${last_payment_amount}

Find a Parkland carrier with Payment Data
    [Tags]  qtest
    [Documentation]  Find a parkland carrier with payment data: SELECT p.contract_id, p.carrier_id, p.invoice, p.payment_amount
                ...         FROM payment_detail p
                ...         JOIN open_ar a ON p.contract_id = a.contract_id
                ...         JOIN invoice_detail i ON a.contract_id = i.contract_id
                ...         ORDER BY payment_create desc
                ...         LIMIT 1;
    ${query}    Catenate   SELECT p.contract_id, p.carrier_id, p.invoice, p.payment_amount
    ...         FROM payment_detail p
    ...         JOIN open_ar a ON p.contract_id = a.contract_id
    ...         JOIN invoice_detail i ON a.contract_id = i.contract_id
    ...         ORDER BY payment_create desc
    ...         LIMIT 1;
    ${sql}    Query And Strip to Dictionary    ${query}    db_instance=postgrespgpricing
    ${carrier}    Catenate    ${sql['carrier_id']}
    ${contract}   Catenate    ${sql['contract_id']}
    ${invoice}    Catenate    ${sql['invoice']}
    ${payment_amount}   Catenate    ${sql['payment_amount']}
    Set Test Variable   ${carrier}
    Set Test Variable   ${contract}
    Set Test Variable   ${invoice}
    Set Test Variable   ${payment_amount}

Insert a Void Payment
    [Tags]  qTest
    [Documentation]  Insert a void payment for the most recent payment:
            ...     INSERT INTO payment_detail (carrier_id, contract_id, batched, batch_date, invoice, payment_amount, payment_create, payment_complete, currency, comments, payment_type)
            ...     VALUES({carrier}, {contract}, 'Y', '{current_date_time}', '{invoice}V', -{payment_amount}, '{current_date_time}', '{current_date_time}', 'CAD', 'Void Payment Test','vod');
    ${current_date_time}    Get Current Date    result_format=datetime	 exclude_millis=yes
    ${query}      Catenate    INSERT INTO payment_detail (carrier_id, contract_id, batched, batch_date, invoice, payment_amount, payment_create, payment_complete, currency, comments, payment_type)
    ...     VALUES(${carrier}, ${contract}, 'Y', '${current_date_time}', '${invoice}V', -${payment_amount}, '${current_date_time}', '${current_date_time}', 'CAD', 'Void Payment Test','vod');
    execute sql string  ${query}  db_instance=postgrespgpricing

Get Last Successful Payment
    [Tags]  qTest
    [Documentation]  Get the payment amount of the new most recent payment: SELECT  payment_create, payment_amount  FROM payment_detail
            ...     WHERE contract_id = {contract}
            ...     AND invoice NOT IN ('{invoice}', '{invoice}V')
            ...     ORDER BY payment_create desc
            ...     LIMIT 1;
    ${query}      Catenate    SELECT  payment_create, payment_amount  FROM payment_detail
    ...     WHERE contract_id = ${contract}
    ...     AND invoice NOT IN ('${invoice}', '${invoice}V')
    ...     ORDER BY payment_create desc
    ...     LIMIT 1;
    ${sql}    Query And Strip to Dictionary    ${query}    db_instance=postgrespgpricing
    ${last_payment_create}   Catenate    ${sql['payment_create']}
    ${last_payment_amount}   Catenate    ${sql['payment_amount']}
    Set Test Variable   ${last_payment_create}
    Set Test Variable   ${last_payment_amount}

Delete Void Payment
    [Tags]  qtest
    [Documentation]  Delete the void payment added: DELETE FROM payment_detail WHERE invoice = '{invoice}V';
    [Arguments]     ${invoice}
    ${query}      Catenate    DELETE FROM payment_detail
    ...     WHERE invoice = '${invoice}V'
    Execute SQL String  ${query}  db_instance=postgrespgpricing

Remove Void payment and close browser
    Delete Void Payment    ${invoice}
    Close Browser