*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Teardown  close all browsers
Force Tags  Portal  Credit Manager  weekly
Documentation  This is for the search functionality on Credit Manager Home page
#this needs to be converted into keywords later
#this needs to run only weekly

*** Variables ***
${carrier}  324878
${contract}  331752
${arnumber}  1043501900348
${name}  BLIND DUTCHMAN
${card}  7083051932487800006
${address}  4475 CARIBBEAN ISLANDS
${city}  CARRIBEAN ISLANDS
${state}  Rhode Island
${zip}  84444
${company}  EL ROBOT'S COMPANY
${phone}  454-526-3698
${email}  elrobot@wexinc.com
${account}  78451296358
${cardnum}
${address1}

*** Test Cases ***

Search by Carrier ID, AR Number, Contract ID
    [Tags]  JIRA:BOT-1683  qTest:30782852  Regression  JIRA:BOT-1684  qTest:30782939  JIRA:BOT-1685  qTest:30782942  refactor
    [Documentation]  This will check if a carrier can be searched with carrier ID, AR Number, Contract ID in Portal-Credit Manager home page
    Open Browser to portal
    Log Into Portal  ${PortalUsername}  ${PortalPassword}
    Select Portal Program  Credit Manager
    Search by  carrierId  ${carrier}
    Search by  arNumber  ${arnumber}
    Search by  contractId  ${contract}

Search by Company Name
    [Tags]  JIRA:BOT-1686  qTest:30782943  Regression
    [Documentation]  This will check if a carrier can be searched with Company Name in Portal-Credit Manager home page
    input text  request.search.name  BLIND DUTCHMAN
    select from list by label  issuerGroupId  EFS   #this will reduce the time to fetch the results
    click portal button  Search
    wait until element is visible  //*[@id="resultsTable"]  timeout=180
    table cell should contain  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table  1  5  324878
    clear element text  request.search.name
    refresh page


Search value options
    [Tags]  JIRA:BOT-1687  qTest:30783143  Regression  refactor
    [Documentation]
     Select Search Field and Search value  Card Number  Contains  ${cardnum}
     Select Search Field and Search value  Card Number  Equals  ${cardnum}
     Select Search Field and Search value  Card Number  Starts With  ${cardnum}
     Select Search Field and Search value  Card Number  Ends With  ${cardnum}
#     Select Search Field and Search value  Address Line 1  Contains  ${address1}
#     Select Search Field and Search value  Address Line 1  Equals  ${address1}
#     Select Search Field and Search value  Address Line 1  Starts With  ${address1}
#     Select Search Field and Search value  Address Line 1  Ends With  ${address1}
#     Select Search Field and Search value  City  Contains  ${city}
#     Select Search Field and Search value  City  Equals  ${city}
#     Select Search Field and Search value  City  Starts With  ${city}
#     Select Search Field and Search value  City  Ends With  ${city}
#     Select Search Field and Search value  State/Province *  Contains  ${state}
#     Select Search Field and Search value  Zip/Postal Code  Contains  ${zip}
#     Select Search Field and Search value  Zip/Postal Code  Equals  ${zip}
#     Select Search Field and Search value  Zip/Postal Code  Starts With  ${zip}
#     Select Search Field and Search value  Zip/Postal Code  Ends With  ${zip}
#     Select Search Field and Search value  Contact Name  Contains  ${contact}
#     Select Search Field and Search value  Contact Name  Equals  ${contact}
#     Select Search Field and Search value  Contact Name  Starts With  ${contact}
#     Select Search Field and Search value  Contact Name  Ends With  ${contact}
#     Select Search Field and Search value  Phone/Cell/Fax *  Equals  ${phone}
#     Select Search Field and Search value  Email  Contains  ${email}
#     Select Search Field and Search value  Email  Equals  ${email}
#     Select Search Field and Search value  Email  Starts With  ${email}
#     Select Search Field and Search value  Email  Ends With  ${email}
#     Select Search Field and Search value  Account Activity  Contains  ${Account}
#     Select Search Field and Search value  Account Activity  Equals  ${Account}
#     Select Search Field and Search value  Account Activity  Starts With  ${Account}
#     Select Search Field and Search value  Account Activity  Ends With  ${Account}
#     Select Search Field and Search value  Payment Batch *  Contains  ${payment}
#     Select Search Field and Search value  Account Num *  Contains  ${Account}
#     Select Search Field and Search value  Branch Num *  Contains  ${Branch}



Search with different issuer groups
    [Tags]  JIRA:BOT-1688  qTest:30783159  Regression
    [Documentation]  This will check if results can be fetched using different issuer groups
     ...  in Portal-Credit Manager home page

    Search with issuer group by label  EFS  carrierId  324878
    Search with issuer group by label  EFS (Imperial/Husky)  contractId  2550
    Search with issuer group by label  EFS (MIG)  arNumber  2408901514565
#   Search with issuer group by value  26  carrierId  700049   #no idea why Robot wouldnt recognize just this one lable/value
    Search with issuer group by label  Pilot RV  contractId  87083
    Search with issuer group by label  Imperial Oil  arNumber  0012612624556
    Search with issuer group by label  Irving Oil  carrierId  893381
    Search with issuer group by label  Shell Oil  contractId  168983
    Search with issuer group by label  Shell Mastercard  arNumber  0007171700075
    Search with issuer group by label  Shell Flying J  carrierId  400719


Authenticate Caller
    [Tags]  JIRA:BOT-1689  qTest:30783194  Regression  refactor
    [Documentation]  This will authenticate the user that is logged in as the carrier you are trying to be
    ...  by providing carrier ID and password
    click portal button  Authenticate Caller
    wait until element is visible  xpath=//*[@id="authCall_CarrierId"]
    input text  request.authenticateCaller.carrierId  103866
    click portal button  OK
    wait until element is visible  xpath=//*[@id="simpleauth__password"]
    input text  request.authenticateCaller.password  112233
    click portal button  Authenticate
    wait until element is visible  xpath=//*[@id="authCall_displayMessage"]
    page should contain element  xpath=//*[contains(text(),'Call in User is Authenticated')]

*** Keywords ***
Search by
    [Arguments]  ${field}  ${fieldvalue}
    input text  request.search.${field}  ${fieldvalue}
    click portal button  Search
    wait until element is visible  //*[@id="resultsTable"]  timeout=20
    page should contain element  xpath=//*[@id="resultsTable"]//*[contains(text(),'${fieldvalue}')]
    clear element text  request.search.carrierId
    refresh page


Select Search Field and Search value
    [Arguments]  ${searchoption}  ${Condition}  ${searchvalue}
    select from list by label  searchField  ${searchoption}
    select from list by label  searchCondition  ${Condition}
    run keyword if  '${searchoption}'=='Card Number'  Get Cardvalue  ${Condition}
    run keyword if  '${searchoption}'=='Address Line 1'  Get Addressvalue  ${Condition}
    click portal button  Search
    wait until element is visible  //*[@id="resultsTable"]  timeout=30
    table cell should contain  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table  1  5  324878
    clear element text  searchValue
    refresh page

Get Cardvalue
    [Arguments]  ${arg}
#    set global variable  ${cardnum}
    ${cardnum}=  Run Keyword If  '${arg}'=='Contains'  get substring  ${card}  0  18
    ...	ELSE IF	'${arg}'=='Starts With'  get substring  ${card}  0  17
    ...	ELSE IF	'${arg}'=='Ends With'  get substring  ${card}  -14
    ...	ELSE  append to string  ${cardnum}  ${card}
    input text  searchValue  ${cardnum}

Get Addressvalue
    [Arguments]  ${arg}
#    set global variable  ${address1}
    ${address1}=  run keyword if  '${arg}'=='Contains'  get substring  ${address}  0  26
    ...	ELSE IF	'${arg}'=='Starts With'  get substring  ${address}  0  25
    ...	ELSE IF	'${arg}'=='Ends With'  get substring  ${address}  -23
    ...	ELSE  append to string  ${address1}  ${address}
    input text  searchValue  ${address1}


Search with issuer group by label
    [Arguments]  ${issuergroup}  ${option}  ${value}

    select from list by label  issuerGroupId  ${issuergroup}
    input text  request.search.${option}  ${value}
    click portal button  Search
    wait until element is visible  //*[@id="resultsTable"]  timeout=20
    page should contain element  xpath=//*[@id="resultsTable"]//*[contains(text(),'${value}')]
    clear element text  request.search.${option}
    refresh page

Search with issuer group by value
    [Arguments]  ${issuergroup}  ${option}  ${value}

    select from list by value  issuerGroupId  ${issuergroup}
    input text  request.search.${option}  ${value}
    click portal button  Search
    wait until element is visible  //*[@id="resultsTable"]  timeout=20
    page should contain element  xpath=//*[@id="resultsTable"]//*[contains(text(),'${value}')]
    clear element text  request.search.${option}
    refresh page

