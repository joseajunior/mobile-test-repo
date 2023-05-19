*** Settings ***
Library     RequestsLibrary
Library     Collections
Library     otr_robot_lib.ui.web.PySelenium
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib.support.PyString
Library     String
Resource    otr_robot_lib/robot/RobotKeywords.robot
Resource    otr_robot_lib/robot/eManagerKeywords.robot
Resource    otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup    SUITE:Setup
Suite Teardown    SUITE:Teardown

Force Tags  AccountManager  Contracts

*** Variables ***

*** Test Cases ***
AM Contract Limits - Verify Balance Owing Field for Parkland
    [Documentation]   Ensure balance owing field appears for Parkland carriers
    [Tags]   Q1:2023  JIRA:ROCKET-421  qtest:119713422  API:Y

    Open Account Manager
    Search A Carrier In AM    PARKLAND    ${carrier_id}
    Click Secondary Tab By Text    Contracts
    Select the Contract    ${contract_id}
    Click Secondary Tab By Text    Contract Limits
    Check Balance Owing Value    ${balance_owing}

*** Keywords ***
SUITE:Setup
    [Documentation]    Test Setup to get a valid Parkland carrier
    Get a Parkland Carrier Info

SUITE:Teardown
    [Documentation]    Test Teardown
    Close Browser

Get a Parkland Carrier Info
    [Tags]  qtest
    [Documentation]    Get a valid Parkland carrier, its contract and balance owing value:
        ...  SELECT carrier_id, balance_owing, contract_id FROM open_ar limit 1;
    ${query}  Catenate  SELECT carrier_id, balance_owing, contract_id
    ...  FROM open_ar
    ...  limit 1;
    ${ParklandCarrier}  Query And Strip To Dictionary  ${query}   db_instance=postgrespgpricing
    Set Suite Variable  ${carrier_id}  ${ParklandCarrier['carrier_id']}
    Set Suite Variable  ${balance_owing}  ${ParklandCarrier['balance_owing']}
    Set Suite Variable  ${contract_id}  ${ParklandCarrier['contract_id']}

Search A Carrier In AM
    [Tags]  qtest
    [Documentation]    Search the carrier in Account Manager
    [Arguments]  ${BusinessPartner}  ${Customer}
    ${current}=  get location
    ${goback}=  evaluate  '/acct-mgmt/RecordSearch.action' not in '${current}'
    run keyword if  ${goback}  Go Back To Record Search
    ${stat}=  run keyword and return status  alert should be present
    run keyword if  ${stat}  run keyword and ignore error  handle alert
    click on    //*[@id="Customer"]/span
    wait until element is visible  businessPartnerCode
    select from list by value  businessPartnerCode  ${BusinessPartner}
    input text  id  ${Customer}
    Click Search Section Submit
    wait until element is visible   //button[text()="${Customer}"]
    sleep  1
    double click on  xpath=//button[text()="${Customer}"]
    wait until element is visible  xpath=//span[text()="Detail"]
    double click on  xpath=//span[text()="Detail"]
    wait until element is visible  //td[text()="${Customer}"]  timeout=60  error=Customer Did not load within 60 seconds

Open Account Manager
    [Tags]  qtest
    [Documentation]    Open Account Manager
    Open eManager   ${intern}   ${internPassword}
    Go to   ${emanager}/acct-mgmt/RecordSearch.action
    Wait until loading spinners are gone

Select the Contract
    [Documentation]    Select The Contract
    [Arguments]    ${contract_id}
    Wait Until Element is Visible    //*[@id="DataTables_Table_0_wrapper"]//*/button[contains(text(),"${contract_id}")]
    Click Element    //*[@id="DataTables_Table_0_wrapper"]//*/button[contains(text(),"${contract_id}")]

Check Balance Owing Value
    [Tags]  qtest
    [Documentation]    Check if Balance Owing field is appearing correctly for Parkland users
    [Arguments]   ${balance_owing}
    Page Should Contain Element    //*[@id="balanceOwing"]
    Page Should Contain Element    //*[@id="balanceCurrency"]
    ${balance_owing_currency}=  Get Text   //*[@id="balanceCurrency"]
    Should Be Equal As Strings  ${balance_owing}   ${balance_owing_currency}