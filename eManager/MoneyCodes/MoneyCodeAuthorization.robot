*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String

Resource  otr_robot_lib/robot/eManagerKeywords.robot
Library  otr_robot_lib.ws.CardManagementWS
#Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Documentation  This is a test suite for QAT-765\\n
...   This test is issuing a money code
...  Authorizing it through home link
...  Validating it in the DB
...  Validating error message with an invalid location
...  Authorizing it using a Non-EFS location

Suite Teardown  Tear Me Down

Force Tags  eManager


*** Variables ***

*** Test Cases ***
Issuing Money Code
    [Documentation]  This is a test case for issuing moneycode using WebServices
    [Tags]   JIRA:QAT-765  JIRA:BOT-1755  tier:0

    log into card management web services  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    ${MC}=  issueMoneyCode  ${validCard.contract.contract_id}  15.00   Automation
    logout
    set global variable  ${MC}
    Tch Logging  \n MONEY CODE:${MC}

Validating check authorization
    [Documentation]  This is a test case for authorizing the money code via home link for an EFS location
    [Tags]   JIRA:QAT-765  JIRA:BOT-1755  refactor  tier:0
        open automation browser  ${emanager}/mgnt/CheckAuthorization.action  ${browser}  download_folder=${default_download_path}  alias=eManager
        ${passed}  Run Keyword And Return Status  Element Should Be Visible  //*[@class="ui-button-icon-primary ui-icon ui-icon-closethick"]
        Run Keyword if  ${passed}
        ...  Click Element  //*[@class="ui-button-icon-primary ui-icon ui-icon-closethick"]
        Maximize Browser Window
        ${CHECK}=  createCheck
        Tch Logging  \n CHECK:${CHECK}
        Input Text   checkNumber  ${CHECK}
        set global variable  ${CHECK}
        Input Text  dollarAmount   10.00
        Click Button    nextToCheckLocationPage
        Wait Until Element Is Visible  //*[@for="locationId"]  timeout=20
        Input Text   locationId  231001
        Input Text  payee  RobotTester
        Input Text  moneyCode  ${MC}
        Click Button  submit
        check element exists  checkAuthorizationVerification.jsp.notes
        Click Button  finish

Validating in DB
    [Documentation]  This is a test case for validating the authorized check in the database
    [Tags]   JIRA:QAT-765  JIRA:BOT-1755  refactor  tier:0
        Get Into DB   TCH
        ${results}=  Query And Strip To List  SELECT express_code,last_check FROM mon_codes ORDER BY created DESC LIMIT 1
        ${results1}=  Query And Strip To List  SELECT code FROM checks WHERE check_num = ${CHECK}

        should be equal as strings  ${results[0]}  ${MC}
        should be equal as strings  ${results[1]}  ${CHECK}
        should be equal as strings  ${MC}  ${results[0]}

Validating with invalid location ID
    [Documentation]  This is a test case for checking error message when given an ivalid location ID
    [Tags]   JIRA:QAT-765  JIRA:BOT-1755  refactor  tier:0
        ${passed}  Run Keyword And Return Status  Element Should Be Visible  //*[@class="ui-button-icon-primary ui-icon ui-icon-closethick"]
        Run Keyword if  ${passed}
        ...  Click Element  //*[@class="ui-button-icon-primary ui-icon ui-icon-closethick"]
        ${CHECK}=  createCheck
        Tch Logging  \n CHECK:${CHECK}
        Wait Until Page Contains Element  //*[@for="checkAuthorization.jsp.legend.title"]  timeout=20
        Input Text   checkNumber  ${CHECK}
        Input Text  dollarAmount   10.00
        Click Button    nextToCheckLocationPage
        Input Text   locationId  999999
        Input Text  payee  RobotTester
        Input Text  moneyCode  ${MC}
        Click Button  submit
        ${error}  Get Text  //*[@class="errors"]//*[contains(text(),'This EFS Location ID is invalid.')]
        Should Be Equal As Strings  ${error}  This EFS Location ID is invalid.

Validating with Non-EFS location
    [Documentation]  This is a test case for authorizing the check using a Non-EFS location
    [Tags]   JIRA:QAT-765  JIRA:BOT-1755  refactor  tier:0
        log into card management web services  ${validCard.carrier.member_id}    ${validCard.carrier.password}
        ${MC}=  issueMoneyCode  3035  15.00   Automation
        logout
        Wait Until Page Contains Element  //*[@name="back"]  timeout=20
        Click Button  back
        ${CHECK}=  createCheck
        Tch Logging  \n CHECK:${CHECK}
        Input Text   checkNumber  ${CHECK}
        Input Text  dollarAmount   10.00
        Click Button  nextToCheckLocationPage
        click radio button  value=NO
        Input Text  businessName  EFS Robot Tester
        Input Text  locationCity  Ogden
        select from list by label  locationState  UT - Utah
        Input Text  locationPhone  999-999-9999
        Input Text  payee  RobotTester
        Input Text  moneyCode  ${MC}
        Click Button  submit
        check element exists  checkAuthorizationVerification.jsp.notes
        Click Button  finish

Money Code Secondary Threshold Verification
    [Documentation]  Set up Primary w/ Secondary Contract\n\n
    ...  Issue Money Code from Primary Contract\n\n
    ...  Get Money Code and Fee Amount\n\n
    ...  Verify Primary Contract was deducted\n\n
    ...  Issue Money Code from Primary Contract\n\n
    ...  Get Money Code and Fee Amount\n\n
    ...  Verify Secondary Contract was deducted\n\n
    ...  Set up Secondary Contract 0 credit and Primary Contract 200 credit\n\n
    ...  Verify Issue Money Code Errors
    ...  Reset Setup\n\n

    [Tags]  JIRA:BOT-199  refactor

    Get Into DB  tch
    execute sql string  dml=update contract SET daily_code_bal = 0, daily_bal = 0, credit_bal = 0, credit_limit = 500.00, daily_limit = 500.00, secondary_contract = 11175, sec_threshold = 300, mcode_bill_on_issue = 'Y' WHERE contract_id = ${contract}
    execute sql string  dml=update contract SET daily_code_bal = 0, daily_bal = 0, credit_bal = 0, credit_limit = 1500.00, daily_limit = 1500.00, mcode_bill_on_issue = 'Y' WHERE contract_id = ${sec_contract}
    execute sql string  dml=update cont_misc SET max_money_code = 2000 WHERE contract_id = ${sec_contract}

    ${org_credit1}=  query and strip  SELECT credit_limit FROM contract WHERE contract_id = ${contract}

    log into card management web services  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    ${MC}=  issueMoneyCode  ${contract}  100.00  Automation
    logout

    ${MC_Charge}=  query and strip to list  select fee_amount, original_amt from mon_codes where express_code = ${MC}

    Get Into DB  tch
    ${daily_limit}=  query and strip  select daily_limit from contract where contract_id = ${contract}
    ${MCandFee}=  evaluate  ${org_credit1}-${MC_Charge[1]}-${MC_Charge[0]}
    should not be equal as numbers  ${MCandFee}  ${daily_limit}


    ${org_credit2}=  query and strip  SELECT credit_limit FROM contract WHERE contract_id = ${sec_contract}

    log into card management web services  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    ${MC2}=  issueMoneyCode  ${contract}  500.00  Automation
    logout

    ${MC_Charge2}=  query and strip to list  select fee_amount, original_amt from mon_codes where express_code = ${MC2}

    Get Into DB  tch
    ${daily_limit}=  query and strip  select daily_limit from contract where contract_id = ${sec_contract}
    ${MCandFee2}=  evaluate  ${org_credit2}-${MC_Charge2[1]}-${MC_Charge2[0]}
    should not be equal as numbers  ${MCandFee2}  ${daily_limit}

    execute sql string  dml=update contract SET credit_limit = 0, daily_limit = 0 WHERE contract_id = ${sec_contract}
    execute sql string  dml=update contract SET credit_limit = 200.00, daily_limit = 200.00 WHERE contract_id = ${contract}

    log into card management web services  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    ${STATUS}  ${FAIL}=  run keyword and ignore error  issueMoneyCode  ${contract}  250.00  Automation
    should be equal as strings  ${MC3}  <faultstring>Error: 20 - System error</faultstring>
    logout

#This is to reset back to normal values
    execute sql string  dml=update contract SET credit_limit = 9999999.00, daily_limit = 1000000.00, secondary_contract = '', sec_threshold = '', mcode_bill_on_issue = 'N' WHERE contract_id = ${contract};
    execute sql string  dml=update contract SET credit_limit = 5555555.00, daily_limit = 5555555.00, mcode_bill_on_issue = 'N' WHERE contract_id = ${sec_contract};
    execute sql string  dml=update cont_misc SET max_money_code = 0 WHERE contract_id = ${sec_contract}


Max Money Code
    [Tags]  JIRA:BOT-609  JIRA:BOT-1833  refactor
    [Documentation]  Validate the error message for amount bigger than max money code in Money Codes.

# SET TEST VARIABLES
    set test variable  ${DB}  TCH
    set test variable  ${ENV}  ACPT
    set test variable  ${CARRIER}  103866

# get carrier password
    Get Into DB  ${DB}  ${ENV}
    ${query}  Catenate  SELECT TRIM(passwd) FROM member WHERE member_id = ${CARRIER}
    ${carrier_pass}  Query And Strip  ${query}

# go to Money Codes and then Issue Money Code
    Open eManager  ${CARRIER}  ${carrier_pass}
    Maximize Browser Window
    Go To  ${emanager}/cards/MoneyCodeManagement.action

    ${contract_id}  Get Value  moneyCode.contractId

# getting max_money_code from db
    ${query}  Catenate  SELECT max_money_code FROM cont_misc WHERE contract_id = '${contract_id}';
    ${max_money_code}  Query And Strip  ${query}
    ${max_money_code}  convert to integer  ${max_money_code}

# putting an amount bigger than the max money code in the amount field
    ${max_money_code}=  evaluate  ${max_money_code} + 10

    Input Text  moneyCode.amount  ${max_money_code}
    Input Text  moneyCode.issuedTo  TESTINNG
    Input Text  moneyCode.notes  TEST NOTES
    Click Button  Issue Money Code

    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Exceeded maximum money code amount')]

    [Teardown]  Run Keywords  close browser
    ...  AND  disconnect from database

*** Keywords ***
Tear Me Down
    sleep   3

