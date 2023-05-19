*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot


Documentation  Tests Transaction deatil Taxes Tax Exemption column.
...   display Yes if the trans line tax exempt_flag Is Y else No.


Force Tags  AM

*** Test Cases ***
Transaction Detail Tax Exemption - EFS
    [Tags]  JIRA:ROCKET-132  qTest:54400263  Tier:0  API:Y
    [Setup]
    set test variable  ${DB}  TCH
    Find tax transaction in "${DB}" DB
    Open Account Manager
    Open Transaction Search for "EFS" Partner
    Load Carrier Information
    Click the Transaction
    Validate "${transaction['trans_id']}" Taxes Tax Exemption in "${DB}" DB
    [Teardown]  close browser

Transaction Detail Tax Exemption - PNC
    [Tags]  JIRA:ROCKET-132  qTest:54400280  Tier:0  API:Y
    [Setup]
    set test variable  ${DB}  TCH
    Find tax transaction in "${DB}" DB Between "390000" and "399999"
    Open Account Manager
    Open Transaction Search for "PNC" Partner
    Load Carrier Information
    Click the Transaction
    Validate "${transaction['trans_id']}" Taxes Tax Exemption in "${DB}" DB
    [Teardown]  close browser

Transaction Detail Tax Exemption - PARKLAND
    [Tags]  JIRA:ROCKET-132  qTest:54400288  Tier:0  API:Y
    [Setup]
    set test variable  ${DB}  TCH
    Find tax transaction in "${DB}" DB Between "2500000" and "2599999"
    Open Account Manager
    Open Transaction Search for "PARKLAND" Partner
    Load Carrier Information
    Click the Transaction
    Validate "${transaction['trans_id']}" Taxes Tax Exemption in "${DB}" DB
    [Teardown]  close browser

Transaction Detail Tax Exemption - IRVING
    [Tags]  JIRA:ROCKET-132  qTest:54400290  Tier:0  API:Y
    [Setup]
    set test variable  ${DB}  IRVING
    Find tax transaction in "${DB}" DB
    Open Account Manager
    Open Transaction Search for "IRVING_OIL" Partner
    Load Carrier Information
    Click the Transaction
    Validate "${transaction['trans_id']}" Taxes Tax Exemption in "${DB}" DB
    [Teardown]  close browser

Transaction Detail Tax Exemption - IMPERIAL
    [Tags]  JIRA:ROCKET-132  qTest:54400293  Tier:0  API:Y
    [Setup]
    set test variable  ${DB}  IMPERIAL
    Find tax transaction in "${DB}" DB Between "0" and "988000"
    Open Account Manager
    Open Transaction Search for "IMPERIAL_OIL"
    Load Carrier Information
    Click the Transaction
    Validate "${transaction['trans_id']}" Taxes Tax Exemption in "${DB}" DB
    [Teardown]  close browser

Transaction Detail Tax Exemption - Husky
    [Tags]  JIRA:ROCKET-132  qTest:54400295  Tier:0  API:Y
    [Setup]
    set test variable  ${DB}  IMPERIAL
    Find tax transaction in "${DB}" DB Between "998000" and "999999"
    Open Account Manager
    Open Transaction Search for "HUSKY"
    Click the Transaction
    Validate "${transaction['trans_id']}" Taxes Tax Exemption in "${DB}" DB
    [Teardown]  close browser

Verify Tab switching bug not longer removes Filtering
    [Tags]  JIRA:ROCKET-134  qTest:54659421  API:Y
    set test variable  ${DB}  TCH
    Find tax transaction in "${DB}" DB Between "2500000" and "2599999"
    Find second transaction in "${DB}" DB Between "2500000" and "2599999"
    Open Account Manager
    Open Transaction Search for "PARKLAND" Partner
    Click On More Button
    Add Customer Number Filter
    Check Customer Number Values    ${transaction['carrier_id']}
    Select Contracts Tab
    Select Transactions Tab
    Click On More Button
    Add Customer Number Filter
    Check Customer Number Values    ${transaction['carrier_id']}
    [Teardown]  close browser

*** Keywords ***
Open Transaction Search for "${partner}" Partner
    [Tags]  qtest
    [Documentation]  Click on Transaction TAB, select arg0 as partner
    Select Transactions Tab
    Select From List By Value  //*[@class="txBusinessPartnerSelect" and @name="businessPartner"]  ${partner}
    Select From List By Value  //*[@class="txTransTypeSelect" and @name="transactionType"]  COMPLETED
    sleep  5s
    Input Text    //input[@id="transDateFrom"]   ${transaction['trans_date']}
    Input Text   //*[@id="transDateTo"]    ${transaction['trans_date']}
    Click on Submit Button
    Wait Until Load Screen Icon Disappear From Screen

Open Transaction Search for "${partner}"
    [Tags]  qtest
    [Documentation]  Click on Transaction TAB, select arg0 as partner
    Select Transactions Tab
    Select From List By Value  //*[@class="txBusinessPartnerSelect" and @name="businessPartner"]  ${partner}
    Select From List By Value  //*[@class="txTransTypeSelect" and @name="transactionType"]  COMPLETED
    sleep  5s
    Input Text    //*[@name="transactionDateFrom"]   ${transaction['trans_date']}
    Input Text   //*[@name="transactionDateTo"]    ${transaction['trans_date']}
    Click on Submit Button
    Wait Until Load Screen Icon Disappear From Screen

Select Transactions Tab
    click element  //*[@id="Transaction"]
    Wait Until Load Screen Icon Disappear From Screen
    Select Business Partner Value

Select Business Partner Value
    Wait Until Element Is Visible        //*[@id="bPartner"]
    Click Element      //*[@id="bPartner"]
    Select From List by Value     //*[@id="bPartner"]     EFS

Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@class="loading-img"]  timeout=25
    Wait Until Element Is Not Visible    //*[@class="loading-img"]  timeout=25

Click On Submit Button
    [Tags]  qtest
    [Documentation]  Click On Submit Button
    Click Element  //*[@id="transactionSearchContainer"]/div[1]/button[1]
    Wait Until Load Screen Icon Disappear From Screen

Get ExemptionField
    [Tags]  qtest
    [Documentation]  Verify Tax Exempt field displays
    ${ExemptionField}  Get Text  xpath=//*[@id="taxes"]/div/table/tbody/tr[1]/td[3]
    Set Test Variable  ${ExemptionField}

Click On Records To Go Back to Account Manager
    Click Element  //label[text()='Records']

Validate "${TransId}" Taxes Tax Exemption in "${DB}" DB
    [Tags]  qtest
    [Documentation]  Validate against the database: SELECT exempt_flag from trans_line_tax where trans_id = '{TransId}'
    Get Into DB  ${DB}
    ${db_exemptFlag}  query and strip  SELECT exempt_flag from trans_line_tax where trans_id = '${TransId}'
    IF  '${db_exemptFlag}' == 'Y'
        Should Be Equal As Strings  ${ExemptionField}  YES
    ELSE
        Should Be Equal As Strings   ${ExemptionField}   NO
    END

Find tax transaction in "${DB}" DB
    [Tags]  qtest
    [Documentation]  find transaction from arg0 database:
                ...  select t.carrier_id, t.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from transaction t inner join trans_line_tax x
                ...  ON t.trans_id = x.trans_id
                ...  where t.trans_date > current - 1 units month
                ...  order by trans_id limit 1;
    ${sql}  catenate  select t.carrier_id, t.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from transaction t inner join trans_line_tax x
                ...  ON t.trans_id = x.trans_id
                ...  where t.trans_date > current - 1 units month
                ...  order by trans_id limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=${DB}
    set test variable  ${transaction}

Find tax transaction in "${DB}" DB Between "${a}" and "${b}"
    [Tags]  qtest
    [Documentation]  find transaction from arg0 database:
                ...  select t.carrier_id, t.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from transaction t inner join trans_line_tax x
                ...  ON t.trans_id = x.trans_id
                ...  where t.trans_date > current - 1 units month
                ...  order by trans_id limit 1;
    ${sql}  catenate  select t.carrier_id, t.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date, TO_CHAR(t.trans_date, '%Y-%m-%d') as date
                ...  from transaction t inner join trans_line_tax x
                ...  ON t.trans_id = x.trans_id
                ...  where t.trans_date > current - 1 units month
                ...  AND t.carrier_id between ${a} and ${b}
                ...  order by trans_id limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=${DB}
    set test variable  ${transaction}

Load Carrier Information
    Click Element  //*[contains(text(),'${transaction['carrier_id']}')]
    Wait Until Load Screen Icon Disappear From Screen
    Click Element  //*[contains(text(),'Records')]
    Wait Until Load Screen Icon Disappear From Screen
    Click on Submit Button
    Wait Until Load Screen Icon Disappear From Screen

Click the Transaction
    [Tags]  qtest
    [Documentation]  click on the selected transaction inside date range
    Click Element  //*[contains(text(),'${transaction['trans_id']}')]
    Wait Until Load Screen Icon Disappear From Screen
    Get ExemptionField
    Wait Until Load Screen Icon Disappear From Screen

Click On More Button
    [Tags]  qTest
    [Documentation]  Click the More button
    Wait Until Element Is Enabled    //*[@name="viewMore"]
    Click Element   //*[@name="viewMore"]

Add Customer Number Filter
    [Tags]  qTest
    [Documentation]  Add te carrier_id to the filter and click submit. Transactions should now be filtered
    Set Focus To Element   //input[@id='theCustomerNumberReg']
    Wait Until Element Is Visible    //input[@id='theCustomerNumberReg']
    Input Text    //input[@id='theCustomerNumberReg']    ${transaction['carrier_id']}
    Click Element    //td[@id='moreCriteriaSearchesFormButtons']//button[@id='submit']

Check Customer Number Values
    [Tags]  qTest
    [Documentation]  carrier_id from filter should be present. Other carrier_id should not be present
    [Arguments]     ${CUSTOMER_NUMBER}
    Wait Until Load Screen Icon Disappear From Screen
    ${rowCount}=    Get Element Count    //table[@id='DataTables_Table_0']/tbody/tr
    FOR   ${rowIndex}     IN RANGE     1      ${rowCount} + 1
        ${customerNumber}      Get Text     //table[@id='DataTables_Table_0']/tbody/tr[${rowIndex}]/td[3]
        Should Contain    ${customerNumber}   ${CUSTOMER_NUMBER}
        should not contain  ${customerNumber}  '${another_transaction['carrier_id']}'
    END

Select Contracts Tab
    click element  //*[@id="Contract"]
    Wait Until Load Screen Icon Disappear From Screen
    Click Element    //*[@id="contractSearchContainer"]/div[1]/button[1]

Get A Valid Carrier
    [Arguments]  ${DB}  ${begin_range}  ${end_range}
    Get Into DB  ${DB}
    ${CUSTOMER_NUMBER}  Query And Strip  SELECT member_id FROM member WHERE status='A' AND member_id BETWEEN ${begin_range} AND ${end_range} order by lastupdated DESC LIMIT 1
    Set Suite Variable    ${CUSTOMER_NUMBER}
    [Return]  ${CUSTOMER_NUMBER}

Find second transaction in "${DB}" DB Between "${a}" and "${b}"
    [Tags]  qtest
    [Documentation]  find a second transaction from arg0 database with different carrier:
                ...  select carrier_id, trans_id, TO_CHAR(trans_date, '%m/%d/%Y') as trans_date
                ...  from transaction
                ...  where trans_date between '{transaction['date']} 00:00' AND '{transaction['date']} 23:59'
                ...  AND carrier_id between {a} and {b}
                ...  AND carrier_id != {transaction['carrier_id']}
                ...  order by trans_id limit 1;
    ${sql}  catenate  select carrier_id, trans_id, TO_CHAR(trans_date, '%m/%d/%Y') as trans_date
                ...  from transaction
                ...  where trans_date between '${transaction['date']} 00:00' AND '${transaction['date']} 23:59'
                ...  AND carrier_id between ${a} and ${b}
                ...  AND carrier_id != ${transaction['carrier_id']}
                ...  order by trans_id limit 1;
    ${another_transaction}  query and strip to dictionary  ${sql}  db_instance=${DB}
    set test variable  ${another_transaction}