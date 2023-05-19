*** Settings ***
Test Timeout  5 minutes
Library  Process

Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

*** Variables ***

*** Test Cases ***
Validate Chain Id filtering
    [Tags]    JIRA:ROCKET-200  qTest:  PI:14
    [Setup]  Find Carrier  N
    Prepare for updating Company Attribute
    Add To Attribute to Company Header by Carrier  ${validCard.carrier.id}  Allowed Chain Ids  1,2,3,5-10
    Add To Attribute to Company Header by Carrier  ${validCard.carrier.id}  Blocked Chain Ids  1,2,3
    Go To Card Chain Management  ${validCard}
    click element  xpath=//*[@value='Unauthorized Chains']
    Verify Correct Chains Display
    Verify Other Chains Dont Display
    Rollback Company Attribute
    [Teardown]  teardown

Add an Unauthorized Chain to a Card
    [Tags]  JIRA:BOT-1133  qTest:28993596  Regression  JIRA:BOT-1943  tier:0
    [Documentation]  Test the functionality of unauthorized locations.
    ...  Retest FLT-1242.
    ...  Add an Unauthorized Chain to a Card
    [Setup]  Find Fleet One Carrier  N
#Add an Unauthorized Chain to a Card
    Go To Card in Emanager and lookup card  ${validfltCard.num}
    Go to card chain management  ${validfltCard}
    Add or Remove an Unauthorized Chain to a Card
    Assert message  Successfully added chain number
    Add or Remove an Unauthorized Chain to a Card
    [Teardown]  teardown

*** Keywords ***
Go to card chain management
    [Arguments]  ${modelCard}
    go to  ${emanager}/cards/CardChainManagement.action?card.cardId=${modelCard.id}&card.displayNumber=${modelCard.num}&card.header.policyNumber=${modelCard.policy.num}
    wait until element is visible  xpath=//form[@action="/cards/CardChainManagement.action"]  timeout=45  error=Location Management Screen did not load within 45 seconds


Find Carrier
    [Arguments]  ${tranUpdate}
    ${sql}  Catenate    select unique(carrier_id), Count(*) from cards where carrier_id in (
    ...  select member_id from member
    ...  where mem_type = 'C'
    ...  and tran_update = '${tranUpdate}'
    ...  and status = 'A'
    ...  and member_id not in (103866))
    ...  and status = 'A'
    ...  group by carrier_id
    ...  having count(*) > 5
    ...  limit 150
    ${memlist}  Query And Strip To Dictionary  ${sql}  db_instance=TCH
    ${memlist}  Get From Dictionary  ${memlist}  carrier_id
    ${memlist}  Evaluate  ${memlist}.__str__().replace('[','(').replace(']',')')
    ${sql}  Catenate  select s.user_id from sec_user s, sec_company c
    ...  where s.company_id = c.company_id
    ...  and s.user_id in ${memlist}
    ...  and c.company_header = 'pnc_carrier'
    ...  limit 1
    ${carrier.id}  Query And Strip  ${sql}  db_instance=mysql
    ${validCard}  Find Card Variable    select * from cards where carrier_id = ${carrier.id} and status = 'A' and card_num not like '%OVER'  instance=tch
    Set test Variable    ${validCard}
    ${locationsql}  Catenate  select location_id from location
    ...  where chain_id not in (select chain_id from def_Chains where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id not in (select location_id from def_locs where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id in (select location_id from issr_loc where issuer_id in (select issuer_id from contract where carrier_id = ${carrier.id}) and location_id > 231000)
    ...  limit 1;
    ${location}  Query And Strip  ${locationsql}  db_instance=tch
    Set test Variable    ${location}
    prepare  ${validCard}

Find Fleet One Carrier
    [Arguments]  ${tranUpdate}
    ${sql}  Catenate  select unique(carrier_id) from cards where carrier_id in (
    ...  select member_id from member
    ...  where mem_type = 'C'
    ...  and tran_update = '${tranUpdate}'
    ...  and status = 'A'
    ...  and carrier_type = 'FLT1')
    ...  and card_num not like '%OVER'
    ...  and status = 'A'
    ...  limit 150
    ${memlist}  Query And Strip To Dictionary  ${sql}  db_instance=TCH
    ${memlist}  Get From Dictionary  ${memlist}  carrier_id
    ${memlist}  Evaluate  ${memlist}.__str__().replace('[','(').replace(']',')')
    ${sql}  Catenate  select user_id from sec_user where user_id in ${memlist} limit 1
    ${carrier.id}  Query And Strip  ${sql}  db_instance=mysql
#    ${sql}  Catenate    select passwd from member where member_id = ${carrier.id}
#    ${carrier.passwd}  Query And Strip  ${sql}  db_instance=tch
    ${validfltCard}  Find Card Variable    select * from cards where carrier_id = ${carrier.id} and status = 'A' and card_num not like '%OVER'  instance=tch
    Set test Variable    ${validfltCard}
#    Set Suite Variable    ${carrier.passwd}
    ${locationsql}  Catenate  select location_id from location
    ...  where chain_id not in (select chain_id from def_Chains where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id not in (select location_id from def_locs where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  limit 1;
    ${fltlocation}  Query And Strip  ${locationsql}  db_instance=tch
    Set test Variable    ${fltlocation}
    Change Company Header  ${carrier.id}  C  fleetone_carrier
    prepare  ${validfltCard}

prepare
    [Arguments]    ${card}
    ensure member is not suspended  ${card.carrier.id}
    start setup card  ${card.num}
    setup card header  locationSource=CARD
    clear card location
    open browser to emanager
    log into emanager  ${card.carrier.id}  ${card.carrier.password}  ${True}  ${False}
    Get Into DB  tch
    ${orignal_tran_update}=  assign string  ${card.carrier.tran_update}
    set test variable  ${orignal_tran_update}
    update tran update  ${card.carrier.id}  N

teardown
    update tran update  ${validCard.carrier.id}  ${orignal_tran_update}
    close browser


update tran update
    [Arguments]  ${member_id}  ${flag}
    execute sql string  dml=update member set tran_update = '${flag}' where member_id = ${member_id}  db_instance=tch

Go To Card in Emanager and lookup card
    [Arguments]  ${cardnum}
    go to   ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    input text  xpath=//*[@name='cardSearchTxt']  ${cardnum}
    click element  xpath=//*[@name='searchCard']
    click link  //*[@id="cardSummary"]//a[contains(text(), '${cardnum}')]

Assert message
    [Arguments]  ${message}=None  ${shoud_not_contain}=None

    run keyword if  '${shoud_not_contain}'=='None'
    ...  Page Should Contain  ${message}
    ...  ELSE
    ...  Page Should Not Contain  ${shoud_not_contain}

Add or Remove an Unauthorized Chain to a Card
    Click Element  createCardUnauthorizeChain
    Click Element  //*[@value='2']
    click button  saveButton

Verify Correct Chains Display
    Page Should Contain    WILCO
    Page Should Contain    SPEEDWAY
    Page Should Contain    QUIK TRIP
    Page Should Contain    KANGAROO / PANTRY
    Page Should Contain    IMPERIAL OIL

Verify Other Chains Dont Display
    Page Should Not Contain    PILOT FLYING J
    Page Should Not Contain    TA/PETRO
    Page Should Not Contain    LOVES