*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  Collections
Library  String
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Force Tags  eManager  ManageChildCarrier

*** Variables ***

*** Test Cases ***
Verify Child Carriers for TCH Parent
    [Tags]  Jira:ROCKET-142  qTest:54565824  API:Y
    [Setup]  Basic Setup  TCH
    Find Parent Carrier in "${db}" Instance with Max "5"
    Add the Permission
    Switch to Parent User
    Open View Children and Download Report
    Verify Downloaded Report "${parent}-AllChildCarriers-" with "xlsx" Format
    [Teardown]  Basic Teardown

Verify Child Carriers for TCH Parent with 501+ children
    [Tags]  Jira:ROCKET-141  qTest:54308478  API:Y
    [Setup]  Basic Setup  TCH
    Find Parent Carrier in "${db}" Instance with Max "501"
    Add the Permission
    Switch to Parent User
    Open View Children and Download Report
    Verify Downloaded Report "${parent}-AllChildCarriers-" and row count
    [Teardown]  Basic Teardown

Verify Child Carriers for SHELL Parent
    [Tags]  Jira:ROCKET-141  qTest:54307928  API:Y
    [Setup]  Basic Setup  SHELL
    Find Parent Carrier in "${db}" Instance with Max "2"
    Add the Permission
    Switch to Parent User
    Open View Children and Download Report
    Verify Downloaded Report "${parent}-AllChildCarriers-" with "xlsx" Format
    [Teardown]  Basic Teardown

Activate and Deactivate Child Contract
    [Tags]  PI:13  JIRA:ROCKET-143  qtest:54974672  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Switch to Parent User
    Open Child Carrier
    Inactivate Child Contract
    Verify Contract status  I
    Activate Child Contract
    Verify Contract status  A
    [Teardown]  Basic Teardown

Activate and Deactivate Child Contract no Permission
    [Tags]  PI:15  JIRA:ROCKET-332  qtest:117366706  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Remove Carrier User Permission  ${parent}  VIEW_EDIT_CHILD_CARRIER_ACTIVATE
    Switch to Parent User
    Open Child Carrier
    Element Should Be Disabled  active
    [Teardown]  Basic Teardown


Cannot Activate and Deactivate Child Contract for non Parent owned
    [Tags]  PI:13  JIRA:ROCKET-143  qtest:54974677  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Switch to Parent User
    Change Child Issuer  123456
    Open Child Carrier
    View Child Carrier
    Change Child Issuer  144496
    [Teardown]  Basic Teardown

Search Alias to Child carrier
    [Tags]  qTest:56127228  JIRA:ROCKET-144  PI:13  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Switch to Parent User
    Go into Manage Child carrier and search for the Alias
    [Teardown]  Basic Teardown

Moneycodes and Active Cards for Child Carrier
    [Tags]  PI:13  JIRA:ROCKET-240  qtest:55892629  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Switch to Parent User
    Open Child Carrier
    Verify Money Code Values
    Verify Active Card Value
    [Teardown]  Basic Teardown

Child Expire Future Date
    [Tags]  PI:14  JIRA:ROCKET-271  qtest:116809065  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Switch to Parent User
    Open Child Carrier
    Set expire date to future
    Verify expire date
    Set expire date back to default
    [Teardown]  Basic Teardown

Child Expire Future Date no permission
    [Tags]  PI:14  JIRA:ROCKET-332  qtest:117366568  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Remove Carrier User Permission  ${parent}  VIEW_EDIT_CHILD_CARRIER_EXPIRE
    Switch to Parent User
    Open Child Carrier
    page should not contain  updateChildExpiry

#    Set expire date to future
#    Verify expire date
#    Set expire date back to default
    [Teardown]  Basic Teardown

Child Expire Past Date Should Give Error
    [Tags]  PI:14  JIRA:ROCKET-271  qtest:116812776  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Switch to Parent User
    Open Child Carrier
    Try expire Past date
    [Teardown]  Basic Teardown

Change Discount Tier
    [Tags]  PI:14  JIRA:ROCKET-271  qtest:116809338  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Switch to Parent User
    Open Child Carrier
    Verify and select available Discount Tier
    Verify discount Tier added to child
    [Teardown]  Basic Teardown

Change Discount Fee Tier
    [Tags]  PI:14  JIRA:ROCKET-271  qtest:116812657  API:Y
    [Setup]  Set up Ryder Parent  TCH
    Add the Permission
    Switch to Parent User
    Open Child Carrier
    Verify and select available Discount Fee Tier
    Verify discount Fee Tier added to child
    [Teardown]  Basic Teardown

Verify User can REMOVE funds from a child carrier from a parent carrier
    [Tags]  qTest:116268813  Jira:Rocket-273  API:Y
    [Setup]  Set up Ryder Parent for test  TCH
    Setup parent and child carrier to reflect proper roles
    Switch to Parent User
    Check the credit balance for the contract for the child carrier and other information
    Go into Manage Child carrier and select a Child carrier
    Remove funds with reference ID of Automation  -100
    [Teardown]  Basic Teardown

Verify User can ADD funds from a child carrier from a parent carrier
    [Tags]  qTest:116268829  Jira:Rocket-273  API:Y
    [Setup]  Set up Ryder Parent for test  TCH
    Setup parent and child carrier to reflect proper roles
    Switch to Parent User
    Check the credit balance for the contract for the child carrier and other information
    Go into Manage Child carrier and select a Child carrier
    Add funds with reference ID of Automation  100
    [Teardown]  Basic Teardown

Verify child cannot use more than allowed funds from a parent carrier
    [Tags]  qTest:116268831  Jira:Rocket-273  API:Y
    [Setup]  Set up Ryder Parent for test  TCH
    Setup parent and child carrier to reflect proper roles
    Switch to Parent User
    Check the credit balance for the contract for the child carrier and other information
    Go into Manage Child carrier and select a Child carrier
    Remove funds with reference ID of Automation  -${child_Bal}
    Remove funds with reference ID of Automation  -1
    Verify Error box is displayed
    [Teardown]  Basic Teardown

*** Keywords ***
Basic Setup
    [Arguments]  ${db}
    set test variable  ${db}
    Open eManager  ${intern}  ${internPassword}

Set Up Ryder Parent
    [Arguments]  ${db}
    [Tags]  qtest
    [Documentation]  Make sure child issuer is set up in mySQL db for ryder parent. Should be found with:
                ...  select param_value from sec_user_role_param where user_id = 197997 and param_id = 'CHILD_ISSUER';
                ...  Find a child carrier with that issuer:
                ...  select x.carrier_id from carrier_group_xref x join contract c ON x.carrier_id = c.carrier_id where c.issuer_id = {child_issuer} and x.parent = 197997 order by x.carrier_id limit 1;
                ...  ----ALIAS----
                ...  Get the alias from the carrier services postgress database
                ...  select * from carrier_alias where carrier_id = '{child_carrier}'
                ...  if one does not exist add one :D

    set test variable  ${db}
    set test variable  ${parent}  197997
    ${todayDashed}  getDateTimeNow  %Y-%m-%d
    set test variable  ${todayDashed}
    Open eManager  ${intern}  ${internPassword}
    ${sql}  catenate  select param_value from sec_user_role_param where user_id = ${parent} and param_id = 'CHILD_ISSUER';
    ${child_issuer}  query and strip  ${sql}  db_instance=mysql
    ${sql2}  catenate  select x.carrier_id from carrier_group_xref x join contract c ON x.carrier_id = c.carrier_id where c.issuer_id = ${child_issuer} and x.parent = ${parent} order by x.carrier_id desc limit 1;
    ${child_carrier}  query and strip  ${sql2}  db_instance=TCH
    set test variable  ${child_issuer}
    set test variable  ${child_carrier}
    ${sql3}  catenate  update contract set status = 'A' where carrier_id = ${child_carrier};
    execute sql string  ${sql3}  db_instance=TCH
    Add the Permission
    ${aliassql}  Catenate  select alias from carrier_alias where carrier_id = '${child_carrier}'
    ${aliascntsql}  Catenate  select count(*) from carrier_alias where carrier_id = '${child_carrier}'
    ${cnt}  query and strip  ${aliascntsql}  db_instance=postgrespgcarrierservices
    IF  ${cnt}>0
        ${alias}  query and strip  ${aliassql}  db_instance=postgrespgcarrierservices
    ELSE
        ${insert}  catenate  INSERT INTO carrier_alias (updated_by,updated_date,carrier_family_natural_id,carrier_id,alias)
        ...  VALUES
        ...  ('carriersvc',DATE '${todayDashed}','RYDER','${child_carrier}','${child_carrier}Alias');
        execute sql string  ${insert}  db_instance=postgrespgcarrierservices
        ${alias}  query and strip  ${aliassql}  db_instance=postgrespgcarrierservices
    END
    Set Test Variable  ${alias}

Basic Teardown
    close browser
    run keyword and ignore error  delete excel

Find Parent Carrier in "${env}" Instance with Max "${count}"
    [Tags]  qTest
    [Documentation]  Find a parnet carrier with multiple children:
                ...  SELECT parent FROM
                    ...  (
                    ...  select parent, count(*) as cnt FROM carrier_group_xref
                    ...  where effective_date <= TODAY and (
                    ...  expire_date >= TODAY OR expire_date is NULL)
                    ...  group by 1
                    ...  UNION ALL
                    ...  select parent_id as parent, count(*) as cnt from carrier_referral_xref
                    ...  where effective_date <= TODAY and (
                    ...  expire_date >= TODAY or expire_date is NULL)
                    ...  group by 1
                    ...  )
                    ...  group by 1
                    ...  having sum(cnt) > arg1 ;
    ${sql}  catenate  SELECT parent FROM
                    ...  (
                    ...  select parent, count(*) as cnt FROM carrier_group_xref
                    ...  where effective_date <= TODAY and (
                    ...  expire_date >= TODAY OR expire_date is NULL)
                    ...  group by 1
                    ...  UNION ALL
                    ...  select parent_id as parent, count(*) as cnt from carrier_referral_xref
                    ...  where effective_date <= TODAY and (
                    ...  expire_date >= TODAY or expire_date is NULL)
                    ...  group by 1
                    ...  )
                    ...  group by 1
                    ...  having sum(cnt) > ${count} limit 1;
    ${parent}  query and strip  query=${sql}  db_instance=${env}
    set test variable  ${parent}

Add the Permission
    [Tags]  qTest
    [Documentation]  Add the permission to parent carrier in the mySQL database:
                ...  INSERT INTO sec_user_role_xref values({parent_id},'VIEW_EDIT_CHILD_CARRIERS',1);
                ...  INSERT INTO sec_user_role_xref values({parent_id},'VIEW_EDIT_CHILD_CARRIER_ACTIVATE',1);
                ...  INSERT INTO sec_user_role_xref values({parent_id},'VIEW_EDIT_CHILD_CARRIER_EXPIRE',1);
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIERS  1
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIER_ACTIVATE  1
    Add User Role If Not Exists  ${parent}  VIEW_EDIT_CHILD_CARRIER_EXPIRE  1

Switch to Parent User
    [Tags]  qTest
    [Documentation]  Select Program > User Administration > Customer Info Test Search for Parent ID and switch
    Select Program > "User Administration" > "Customer Info Test"
    Select From List By Value  searchType  1
    Input Text  searchValue  ${parent}
    Click Element  SearchCustomers
    Click Element  //*[@id="searchCustomerTable"]/tbody/tr/td[1]/a[text()='${parent}']

Open View Children and Download Report
    [Tags]  qTest
    [Documentation]  Select Program > Manage Child Carrier > View Edit Child Carriers
                ...  Click "exportAll", wait for report to load, click "Click here to view the document"
    Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    wait until element is not visible  status-dialog
    click element  exportAll
    wait until element is not visible  loading
    wait until element is visible  clock
    click link  Click here to view the document

Verify Downloaded Report "${report_name}" with "${extension}" Format
    [Tags]  qTest
    [Documentation]  Verify the report downloaded and verify contents
    Check if File is Dowloaded    ${report_name}  ${extension}
    ${content}  Get Values From Excel Rows  ${filepath}
    Verify file contents  ${content}
    Remove Report File  ${report_name}

Verify Downloaded Report "${report_name}" and row count
    [Tags]  qTest
    [Documentation]  Verify the report downloaded and verify contents
    Check if File is Dowloaded    ${report_name}  xlsx
    open excel  ${filepath}
    ${count}  get row count  Sheet0
    #remove header row from count
    ${count}  evaluate  ${count}-1
    ${sql}  catenate  SELECT sum(cnt) FROM(
                    ...  select count(*) as cnt FROM carrier_group_xref x
                    ...  JOIN member m ON m.member_id = x.carrier_id
                    ...  where x.parent = ${parent} and x.effective_date <= TODAY and (
                    ...  x.expire_date >= TODAY OR x.expire_date is NULL)
                    ...  UNION ALL
                    ...  select count(*) as cnt from carrier_referral_xref x
                    ...  JOIN member m ON m.member_id = x.carrier_id
                    ...  where x.parent_id = ${parent} and x.effective_date <= TODAY and (
                    ...  x.expire_date >= TODAY or x.expire_date is NULL));
    ${children}  query and strip  query=${sql}  db_instance=${db}
    should be equal as numbers  ${children}  ${count}  precision=0
    delete excel

Verify file contents
    [Arguments]  ${content}
    ${sql}  catenate  select count(*)
                    ...  from carrier_group_xref x JOIN member m ON m.member_id = x.carrier_id
                    ...  where x.effective_date < current and (x.expire_date is null or x.expire_date >= current)
                    ...  and x.parent = ${parent};
    ${group}  query and strip  query=${sql}  db_instance=${db}
    ${sql}  catenate  select count(*)
                    ...  from carrier_referral_xref x JOIN member m ON m.member_id = x.carrier_id
                    ...  where x.effective_date < current and (x.expire_date is null or x.expire_date >= current)
                    ...  and x.parent_id = ${parent};
    ${referral}  query and strip  query=${sql}  db_instance=${db}
    ${total}  evaluate  ${group}+${referral}
    ${report}  Get Length  ${content}
    should be equal as numbers  ${total}  ${report}
    FOR  ${row}  IN  @{content}
        ${contracts_lst}    Split String    ${row['contract_id']}  separator=,
        ${last_used_lst}    Split String    ${row['last_used_date']}  separator=,
        ${unused_money_codes_lst}    Split String    ${row['unused_moneycodes']}  separator=,
        ${used_money_codes_lst}    Split String    ${row['used_moneycodes']}  separator=,
        ${void_money_codes_lst}    Split String    ${row['voided_moneycodes']}  separator=,
        ${available_bal_lst}    Split String    ${row['moneycode_available_balance']}  separator=,
        ${balance_lst}    Split String    ${row['balance_(non-payroll)']}  separator=,

        ${length}   get length    ${contracts_lst}
        FOR    ${i}    IN RANGE    ${length}
            ${contract_id}  set variable    ${contracts_lst}[${i}]
            Exit For Loop IF    "${contract_id}" == ""
            ${carrier_exl}  set variable    ${row['child_carrier_id']}
            ${last_used_exl}  set variable    ${last_used_lst}[${i}]
            ${active_cards_exl}  set variable    ${row['number_of_active_cards']}
            ${unused_money_codes_exl}  set variable    ${unused_money_codes_lst}[${i}]
            ${used_money_codes_exl}  set variable    ${used_money_codes_lst}[${i}]
            ${void_money_codes_exl}  set variable    ${void_money_codes_lst}[${i}]
            ${available_bal_exl}  set variable    ${available_bal_lst}[${i}]
            ${balance_exl}  set variable    ${balance_lst}[${i}]

            ${sql}  catenate  select NVL(contract.last_trans,'N/A') from contract where contract_id = ${contract_id};
            ${last_used}  query and strip  query=${sql}  db_instance=${db}
            ${sql}  catenate  select count(card_id) from cards where carrier_id = ${carrier_exl} and status = 'A' and card_num not like '%OVER';
            ${active_cards}  query and strip  query=${sql}  db_instance=${db}
            ${sql}  catenate  select count(*) from mon_codes where contract_id = ${contract_id} and created > TODAY - 60 and voided != 'Y' and amt_used = 0;
            ${unused_money_codes}  query and strip  query=${sql}  db_instance=${db}
            ${sql}  catenate  select count(*) from mon_codes where contract_id = ${contract_id} and created > TODAY - 60 and voided != 'Y' and amt_used > 0;
            ${used_money_codes}  query and strip  query=${sql}  db_instance=${db}
            ${sql}  catenate  select count(*) from mon_codes where contract_id = ${contract_id} and voided = 'Y' and created > TODAY - 60;
            ${void_money_codes}  query and strip  query=${sql}  db_instance=${db}
            ${sql}  catenate  select NVL(contract.daily_code_limit,0) - NVL(contract.daily_code_bal,0)  from contract where contract_id = ${contract_id};
            ${available_bal}  query and strip  query=${sql}  db_instance=${db}
            ${sql}  catenate  select NVL(contract.credit_limit,0) - NVL(contract.credit_bal,0) from contract where contract_id = ${contract_id};
            ${balance}  query and strip  query=${sql}  db_instance=${db}

            should be equal as strings  ${last_used}    ${last_used_exl.strip()}
            should be equal as strings  ${active_cards}    ${active_cards_exl.strip()}
            should be equal as strings  ${unused_money_codes}    ${unused_money_codes_exl.strip()}
            should be equal as strings  ${used_money_codes}    ${used_money_codes_exl.strip()}
            should be equal as strings  ${void_money_codes}    ${void_money_codes_exl.strip()}
            should be equal as strings  ${available_bal}    ${available_bal_exl.strip()}
            should be equal as strings  ${balance}    ${balance_exl.strip()}
        END
    END

Open Child Carrier
    [Tags]  qtest
    [Documentation]  Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
            ...  Select the child carrier. There should be a button in the bottom right to Activate/Inactivate the contract.
    Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    wait until element is not visible  status-dialog
    select from list by value  searchType  CARRIER_ID
    input text  searchValue  ${child_carrier.__str__()}
    click button  searchChildCarriers
    wait until element is not visible  status-dialog
    Click Button  //*[contains(text(),'${child_carrier.__str__()}')]

Verify Money Code Values
    [Tags]  qtest   expected_results:Database amounts match UI
    [Documentation]  Get the Unused Money Codes count
    ...  select count(*) from mon_codes where carrier_id = {child_carrier} and created > TODAY - 60 and voided != 'Y' and amt_used = 0;
    ...  Get the used Money codes count
    ...  select count(*) from mon_codes where carrier_id = {child_carrier} and created > TODAY - 60 and voided != 'Y' and amt_used > 0;
    ...  Get the Voided Money Codes count
    ...  select count(*) from mon_codes where carrier_id = {child_carrier} and voided = 'Y' and created > TODAY - 60;


    ${sql}  catenate  select count(*) from mon_codes where carrier_id = ${child_carrier.__str__()} and created > TODAY - 60 and voided != 'Y' and amt_used = 0;
    ${unused_money_codes}  query and strip  query=${sql}  db_instance=${db}
    ${sql}  catenate  select count(*) from mon_codes where carrier_id = ${child_carrier.__str__()} and created > TODAY - 60 and voided != 'Y' and amt_used > 0;
    ${used_money_codes}  query and strip  query=${sql}  db_instance=${db}
    ${sql}  catenate  select count(*) from mon_codes where carrier_id = ${child_carrier.__str__()} and voided = 'Y' and created > TODAY - 60;
    ${void_money_codes}  query and strip  query=${sql}  db_instance=${db}
    ${unusedMC}  get text  //*[@id="unusedMC"]
    ${usedMC}  get text  //*[@id="usedMC"]
    ${voidMCcnt}  get text  //*[@id="voidMCcnt"]
    should be equal as numbers  ${unusedMC}  ${unused_money_codes}
    should be equal as numbers  ${usedMC}  ${used_money_codes}
    should be equal as numbers  ${voidMCcnt}  ${void_money_codes}

Verify Active Card Value
    [Tags]  qtest   expected_results:Database amounts match UI
    [Documentation]  Get the Count of Active not override cards
    ...  select count(card_id) from cards where carrier_id = {child_carrier.__str__()} and status = 'A' and card_num not like '%OVER';
    ${sql}  catenate  select count(card_id) from cards where carrier_id = ${child_carrier.__str__()} and status = 'A' and card_num not like '%OVER';
    ${active_cards}  query and strip  query=${sql}  db_instance=${db}
    ${activecrdcnt}  get text  //*[@id="activecrdcnt"]
    should be equal as numbers  ${activecrdcnt}  ${active_cards}

Inactivate Child Contract
    Click Element  inactivate
    Handle Alert

Activate Child Contract
    Click Element  activate
    Handle Alert

Verify Contract status
    [Arguments]  ${status}
    [Tags]  qtest
    [Documentation]  Verify the status of the child contract:
            ...  select status from contract where carrier_id = {child_carrier};
    sleep  5s
    ${sql}  catenate  select status from contract where carrier_id = ${child_carrier};
    ${child_status}  query and strip  ${sql}  db_instance=TCH
    Should be equal as strings  ${child_status}  ${status}

Change Child Issuer
    [Arguments]  ${issuer_id}
    [Tags]  qtest
    [Documentation]  Update child issuer id
            ...  UPDATE contract set issuer_id = arg0 where carrier_id = {child_carrier};
    ${sql}  catenate  UPDATE contract set issuer_id = ${issuer_id} where carrier_id = ${child_carrier};

View Child Carrier
    [Tags]  qtest
    [Documentation]  Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
            ...  Click the button for your child carrier. The button to activate or deactivate the contract should not be visible
    Element Should Not Be Visible  Inactivate
    Element Should Not Be Visible  Activate

Go into Manage Child carrier and search for the Alias
    [Tags]  qtest
    [Documentation]  Select Program > "Manage Child Carrier" > "View Edit Child Carriers" then we select ALIAS
    ...     from the dropdown. After, we put our alias and verify that the carrier id shows up on our list
    Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    select from list by value  searchType  ALIAS
    #todo figure out way to get rid of sleeps
    sleep  5s
    input text  searchValue  ${alias}
    Click Button  searchChildCarriers
    sleep  5s
    Element Should Be Visible  //*[text()='${child_carrier.__str__()}']

Set expire date to future
    [Tags]  qTest
    [Documentation]  Input a future date for child expire date or select from calendar and click save.
                ...  page should display message: You have successfully assigned child Expiry.
    ${twoWeeks}  getDateTimeNow  format=%Y-%m-%d  days=14
    set test variable  ${twoWeeks}
    input text  childExpire  ${twoWeeks}
    click element  updateChildExpiry
    wait until page contains  You have successfully assigned child Expiry.

Try expire Past date
    [Tags]  qTest
    [Documentation]  Input a future date for child expire date or select from calendar and click save.
                ...  page should display message: You have successfully assigned child Expiry.
    ${twoWeeksAgo}  getDateTimeNow  format=%Y-%m-%d  days=-14
    input text  childExpire  ${twoWeeksAgo}
    click element  updateChildExpiry
    wait until page contains  Child Expiry date cannot be in the past.

Verify expire date
    [Tags]  qtest
    [Documentation]  check the database to see expire date updated:
                ...  select to_char(expire_date, '%Y-%m-%d') as expire_date
                ...  from carrier_group_xref
                ...  where parent = 197997
                ...  and carrier_id = {child_carrier};
    ${sql}  catenate  select to_char(expire_date, '%Y-%m-%d') as expire_date
                ...  from carrier_group_xref
                ...  where parent = 197997
                ...  and carrier_id = ${child_carrier.__str__()};
    ${date}  query and strip  ${sql}  db_instance=tch
    should be equal as strings  ${date}  ${twoWeeks}

Set expire date back to default
    [Tags]  qTest
    [Documentation]  set expire date back to default:
                ...  UPDATE carrier_group_xref
                ...  set expire_date = '4000-01-01 00:00'
                ...  where parent = 197997
                ...  and carrier_id = {child_carrier};
    ${sql}  catenate  UPDATE carrier_group_xref
            ...     set expire_date = '4000-01-01 00:00'
            ...     where parent = 197997
            ...     and carrier_id = ${child_carrier.__str__()};
    execute sql string  ${sql}  db_instance=tch

Verify and select available Discount Tier
    [Tags]  qtest
    [Documentation]  select an option for discount tier and click save. Page should display:
                ...  You have successfully assigned discount tiers.
    @{values}  Get List Items  tierIdSelected  values=True
    ${sql}  catenate  select to_char(tier_id) from carrier_group_deal_tiers where parent_id = 197997;
    @{tiers}  query and strip to list  ${sql}  db_instance=tch
    list should contain sub list  ${values}  ${tiers}
    ${myTier}  evaluate  random.choice(${tiers})
    set test variable  ${myTier}
    select from list by value  tierIdSelected  ${myTier}
    click element  saveDiscountTiers
    wait until page contains  You have successfully assigned discount tiers.

Verify discount Tier added to child
    [Tags]  qtest
    [Documentation]  Verify the discount tier changed in the database:
                ...  select tier_id
                ...  from carrier_group_deal_tier_assignment
                ...  where parent_id = 197997
                ...  and child_carrier_id = {child_carrier};
    ${sql}  catenate  select tier_id
                ...  from carrier_group_deal_tier_assignment
                ...  where parent_id = 197997
                ...  and child_carrier_id = ${child_carrier.__str__()};
    ${tier}  query and strip  ${sql}  db_instance=tch
    should be equal as strings  ${tier}  ${myTier}

Verify and select available Discount Fee Tier
    [Tags]  qtest
    [Documentation]  select an option for discount fee tier and click save. Page should display:
                ...  You have successfully assigned discount fee tiers.
    @{values}  Get List Items  feeTierIdSelect  values=True
    ${sql}  catenate  select to_char(tier_id) from carrier_group_fee_tiers where parent_id = 197997;
    @{tiers}  query and strip to list  ${sql}  db_instance=tch
    list should contain sub list  ${values}  ${tiers}
    ${myTier}  evaluate  random.choice(${tiers})
    set test variable  ${myTier}
    select from list by value  feeTierIdSelect  ${myTier}
    click element  saveDiscountFeeTiers
    wait until page contains  You have successfully assigned discount fee tiers.

Verify discount Fee Tier added to child
    [Tags]  qtest
    [Documentation]  Verify the discount fee tier changed in the database:
                ...  select tier_id
                ...  from carrier_group_fee_tier_assignment
                ...  where child_carrier_id = {child_carrier};
    ${sql}  catenate  select tier_id
                ...  from carrier_group_fee_tier_assignment
                ...  where child_carrier_id = ${child_carrier.__str__()};
    ${tier}  query and strip  ${sql}  db_instance=tch
    should be equal as strings  ${tier}  ${myTier}

Set Up Ryder Parent for test
    [Arguments]  ${db}
    [Tags]  qtest
    [Documentation]  Make sure child issuer is set up in mySQL db for ryder parent. Should be found with:
                ...  select param_value from sec_user_role_param where user_id = 197997 and param_id = 'CHILD_ISSUER';
                ...  Find a child carrier with that issuer:
                ...  select x.carrier_id from carrier_group_xref x join contract c ON x.carrier_id = c.carrier_id where c.issuer_id = {child_issuer} and x.parent = 197997 order by x.carrier_id limit 1;
                ...  ----ALIAS----
                ...  Get the alias from the carrier services postgress database
                ...  select * from carrier_alias where carrier_id = '{child_carrier}'
                ...  if one does not exist add one :D

    set test variable  ${db}
    set test variable  ${parent}  197997
    ${todayDashed}  getDateTimeNow  %Y-%m-%d
    set test variable  ${todayDashed}
    Open eManager  ${intern}  ${internPassword}
    ${sql}  catenate  select param_value from sec_user_role_param where user_id = ${parent} and param_id = 'CHILD_ISSUER';
    ${child_issuer}  query and strip  ${sql}  db_instance=mysql
    ${sql2}  catenate  select carrier_id from carrier_group_xref where parent = ${parent} limit 1;
    ${child_carrier}  query and strip  ${sql2}  db_instance=TCH
    set test variable  ${child_issuer}
    set test variable  ${child_carrier}
    ${sql3}  catenate  update contract set status = 'A' where carrier_id = ${child_carrier};
    execute sql string  ${sql3}  db_instance=TCH
    Add the Permission

Go into Manage Child carrier and select a Child carrier
    [Tags]  qtest
    [Documentation]  Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    ...     wait 5s then click the child carrier

    Select Program > "Manage Child Carrier" > "View Edit Child Carriers"
    wait until element is visible  //*[contains(text(),'${childcarrier}')]
    Click Button  //*[contains(text(),'${childcarrier}')]
    Element Should Be Visible  //*[text()='${childcarrier}']

Check the credit balance for the contract for the child carrier and other information
    [Tags]  qtest
    [Documentation]  select credit_bal from contract where carrier_id = ${childcarrier}
    ...     Get child contract to memory and update child contract balance to equal -9000

    ${child_contract_query}  catenate  select contract_id from contract where carrier_id = ${childcarrier};
    ${child_contract}  query and strip  ${child_contract_query}  db_instance=TCH
    set suite variable  ${child_contract}

    execute sql string  dml=UPDATE contract SET credit_bal = '-9000' WHERE contract_id = ${child_contract}  db_instance=TCH

    ${child_Query}  catenate  select ABS(credit_bal) from contract where carrier_id = ${childcarrier};
    ${child_Bal}  query and strip  ${child_Query}  db_instance=TCH
    set suite variable  ${child_Bal}

Add funds with reference ID of Automation
    [Tags]  qTest
    [Documentation]  Takes an argument of negative and positive number. Negative will add to the balance, positive will
    ...     subtract from the balance
    [Arguments]  ${fund_amt}

    Input Text  fundAmt_1  ${fund_amt}
    input text  refNum_1  Automation

    click button  addFundsTemp

    Click Button  //*[contains(text(),'YES')]

Remove funds with reference ID of Automation
    [Tags]  qTest
    [Documentation]  Takes an argument of negative and positive number. Negative will add to the balance, positive will
    ...     subtract from the balance
    [Arguments]  ${fund_amt}

    Input Text  fundAmt_1  ${fund_amt}
    input text  refNum_1  Automation

    click button  addFundsTemp

    Click Button  //*[contains(text(),'YES')]


Setup parent and child carrier to reflect proper roles
    [Tags]  qTest
    [Documentation]  Setup parent role to 1 and child role to 2

    ${issuer_parent_query}  catenate  select issuer_id from contract where carrier_id = ${parent};
    ${parent_issuer}  query and strip  ${issuer_parent_query}  db_instance=TCH

    ${issuer_child_query}  catenate  select issuer_id from contract where carrier_id = ${childcarrier};
    ${child_issuer}  query and strip  ${issuer_child_query}  db_instance=TCH

    execute sql string  dml=UPDATE carrier_group_issuer SET role = 1 WHERE issuer_id = ${parent_issuer}  db_instance=TCH
    execute sql string  dml=UPDATE carrier_group_issuer SET role = 2 WHERE issuer_id = ${child_issuer}  db_instance=TCH

Verify Error box is displayed
    [Tags]  qtest
    [Documentation]  Error box displays on top noting that the user had used up all its funds

    Element Should Be Visible  //*[@class="errors"]
