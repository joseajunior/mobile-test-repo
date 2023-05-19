*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot

Documentation  This is a test suite for QAT-772\\n
...   This test is to validate if parent carrier can track child carrier
...   by adding and removing funds
...   and validating if DB has same info


Force Tags  eManager
Suite Teardown  Tear Me Down

*** Variables ***


*** Test Cases ***

Child Carrier Tracking
    [Tags]  refactor
    Check ability to track Child Carrier Balances
    Adding Funds and checking with db
    Removing funds and checking with db

*** Keywords ***
Check ability to track Child Carrier Balances
    [Tags]   QAT-772

    get into db  tch
    ${carrier}=  query and strip to dictionary  select parent from carrier_group_xref order by effective_date limit 1
    ${child}=  query and strip  select carrier_id from carrier_group_xref where parent = ${carrier['parent']} limit 1
    ${creds}=   query and strip to dictionary  select member_id, passwd from member where member_id = ${carrier['parent']}
    ${contract}=  query and strip to dictionary  select * from contract where carrier_id = ${child}
    execute sql string  dml=update contract SET write_jrnl_record = "Y" WHERE contract_id = '${contract['contract_id']}'
    set global variable  ${contract}
    set global variable  ${carrier}
    set global variable  ${creds}
    open emanager  ${creds['member_id']}  ${creds['passwd']}
    go to   ${emanager}/cards/CarrierGroupContractXFer.action
    click button   submit
    input text    searchTxt   ${child}
    click button  search


Adding Funds and checking with db
    input text   a_174644_174179    15
    click button  submitAmountContract
    select window   new
    click on  saveAmount
    confirm_action
    select window   main
    wait until element is visible    continueToInputAmount
    get into db   tch
    ${load}=  query and strip  select type from contract_journal where contract_id=${contract['contract_id']} order by when desc limit 1
    should be equal as strings  ${load}  LOAD

Removing funds and checking with db
    click on  continueToInputAmount
    input text   a_174644_174179    -15
    click button  submitAmountContract
    select window   new
    click on  saveAmount
    confirm_action
    get into DB  tch
    ${rmve}=  query and strip  select type from contract_journal where contract_id=${contract['contract_id']} order by when desc limit 1
    should be equal as strings  ${rmve}  RMVE

Tear Me Down
    sleep  3
    run keyword and ignore error  close browser