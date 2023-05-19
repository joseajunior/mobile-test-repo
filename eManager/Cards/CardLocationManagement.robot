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

Suite Setup  Find Carrier  N
Suite Teardown  teardown

Force Tags  eManager

*** Variables ***
${wait} =  10
${orignal_tran_update}

*** Test Cases ***
Validate Chain Id filtering
    [Tags]    JIRA:ROCKET-200  qTest:  PI:14
    [Setup]    Prepare for updating Company Attribute
    Add To Attribute to Company Header by Carrier  ${validCard.carrier.id}  Allowed Chain Ids  1,2,3,5-10
    Add To Attribute to Company Header by Carrier  ${validCard.carrier.id}  Blocked Chain Ids  1,2,3
    Go to card location management  ${validCard}
    click element  xpath=//*[@value='Unauthorize Location']
    Verify Chains are Filtered

    [Teardown]  Rollback Company Attribute

Validate State and Providence on screen
    [Tags]    JIRA:ROCKET-376  qTest:118813761  PI:15
    Go to card location management  ${validCard}
    click element  xpath=//*[@value='Unauthorize Location']
    Page Should Contain    State/Province

Location unAuthorize
    [Tags]  JIRA:QAT-15  JIRA:QAT-280  qTest:32829954  tier:0
    [Setup]  Go to card location management  ${validCard}
    Unauthorize A Location  ${location}
    Verify Location In The Card_Loc Table  ${validCard.num}  ${location}
    [Teardown]  clear card location

Location Authorize
    [Tags]  JIRA:QAT-15  JIRA:QAT-258  qTest:32830341  tier:0
    [Setup]  run keywords  setup card location  ${location}
    ...  AND  Go to card location management  ${validCard}
    Authorize A Location  ${location}
    Verify Location Is Not In Card_Loc Table  ${validCard.num}  ${location}

Authorize via main screen
    [Tags]  JIRA:QAT-15  tier:0
    [Setup]  run keywords  setup card location  ${location}
    ...  AND  Go to card location management  ${validCard}
    Click Authorize Button On Card Location Management  ${location}
    Verify Location Is Not In Card_Loc Table  ${validCard.num}  ${location}

Location Source Policy
   [Tags]  qTest:32829873
   [Setup]  Go to card location management  ${validCard}
   Change Location Status  POLICY
   Validate Location Source  ${validCard}  POLICY

Location Source Card
   [Tags]  qTest:32828755
   [Setup]  Go to card location management  ${validCard}
   Change Location Status  CARD
   Validate Location Source  ${validCard}  CARD
   [Teardown]  Change Location Status  POLICY

Location Source Both
   [Tags]  qTest:32829877
   [Setup]  Go to card location management  ${validCard}
   Change Location Status  BOTH
   Validate Location Source  ${validCard}  BOTH
   [Teardown]  Close Browser

Add an Unauthorized location to a Card
    [Tags]  JIRA:BOT-1133  qTest:28993594  Regression  JIRA:BOT-1943  tier:0
    [Documentation]  Test the functionality of unauthorized locations.
    ...  Retest FLT-1242.
    ...  Add an Unauthorized location to a Card.
    [Setup]  Find Fleet One Carrier  N

    set test variable  ${location}  ${fltlocation}
    start setup card  ${validfltCard.num}
    clear card location

    Go To Card in Emanager and lookup card  ${validfltCard.num}
    Add or Remove Unauthorized location to a Card  ${location}
    Assert message  Successfully removed location
    Assert message  from the list of authorized location

    [Teardown]  clear card location

*** Keywords ***
Go to card location management
    [Arguments]  ${modelCard}
    go to  ${emanager}/cards/CardLocationManagement.action?card.cardId=${modelCard.id}&card.displayNumber=${modelCard.num}&card.header.policyNumber=${modelCard.policy.num}
    wait until element is visible  xpath=//form[@action="/cards/CardLocationManagement.action"]  timeout=45  error=Location Management Screen did not load within 45 seconds

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
    ${validCard}  Find Card Variable    select * from cards where carrier_id = ${carrier.id} and status = 'A' and card_num not like '%OVER' limit 1  instance=tch
    Set Suite Variable    ${validCard}
    ${locationsql}  Catenate  select location_id from location
    ...  where chain_id not in (select chain_id from def_Chains where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id not in (select location_id from def_locs where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id in (select location_id from issr_loc where issuer_id in (select issuer_id from contract where carrier_id = ${carrier.id}) and location_id > 231000)
    ...  limit 1;
    ${location}  Query And Strip  ${locationsql}  db_instance=tch
    Set Suite Variable    ${location}
    prepare  ${validCard}

Find Fleet One Carrier
    [Arguments]  ${tranUpdate}
    ${sql}  Catenate  select unique(carrier_id) from cards where carrier_id in (
    ...  select member_id from member
    ...  where mem_type = 'C'
    ...  and tran_update = '${tranUpdate}'
    ...  and status = 'A'
    ...  and carrier_type = 'FLT1')
    ...  and status = 'A'
    ...  and card_num not like '%OVER'
    ...  limit 150
    ${memlist}  Query And Strip To Dictionary  ${sql}  db_instance=TCH
    ${memlist}  Get From Dictionary  ${memlist}  carrier_id
    ${memlist}  Evaluate  ${memlist}.__str__().replace('[','(').replace(']',')')
    ${sql}  Catenate  select user_id from sec_user where user_id in ${memlist} limit 1
    ${carrier.id}  Query And Strip  ${sql}  db_instance=mysql
#    ${sql}  Catenate    select passwd from member where member_id = ${carrier.id}
#    ${carrier.passwd}  Query And Strip  ${sql}  db_instance=tch
    ${validfltCard}  Find Card Variable    select * from cards where carrier_id = ${carrier.id} and status = 'A' and card_num not like '%OVER'  instance=tch
    Set Suite Variable    ${validfltCard}
#    Set Suite Variable    ${carrier.passwd}
    ${locationsql}  Catenate  select location_id from location
    ...  where chain_id not in (select chain_id from def_Chains where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  and location_id not in (select location_id from def_locs where carrier_id = ${carrier.id} and ipolicy = 1)
    ...  limit 1;
    ${fltlocation}  Query And Strip  ${locationsql}  db_instance=tch
    Set Suite Variable    ${fltlocation}
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
    IF  '${orignal_tran_update}'==''
        ${orignal_tran_update}=  assign string  ${card.carrier.tran_update}
        set suite variable  ${orignal_tran_update}
    ELSE
        ${orignal_flt_tran_update}=  assign string  ${card.carrier.tran_update}
        set suite variable  ${orignal_flt_tran_update}
    END
    update tran update  ${card.carrier.id}  N

teardown
    run keyword and ignore error  update tran update  ${validfltCard.carrier.id}  ${orignal_flt_tran_update}
    run keyword and ignore error  update tran update  ${validCard.carrier.id}  ${orignal_tran_update}
    Close Browser


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

Add or Remove Unauthorized location to a Card
    [Arguments]  ${location}

    Mouse Over  //*[@class="horz_nlsitem" and text()=" Locations"]
    Click Element  //*[@class="nlsitem" and text()=" Update Locations"]
    Click Element  doCreateUnauthorize
    Input Text  name=id  ${location}
    Click Element  searchLocation

    ${authorized}  Run Keyword And Return Status  Element Should Be Visible  //*[@name="authorizeIds" and @value="${location}"]
    Run Keyword If  ${authorized}  Run Keywords
    ...  Click Element  //*[@name="authorizeIds" and @value="${location}"]
    ...  AND  Click Element  saveUnauthorizedLocations
    ...  ELSE  Run Keywords
    ...  Click Element  //*[@name="unAuthorizeIds" and @value="${location}"]
    ...  AND  Click Element  removeUnauthorizedLocations

Add or Remove an Unauthorized Chain to a Card

    Mouse Over  //*[@id="cardMenubar_5x2" and text()=" Locations"]
    Click Element  //*[@id="cardLocation_2x2" and text()=" Update Chains"]
    Click Element  createCardUnauthorizeChain
    Click Element  //*[@value='2']
    click button  saveButton

Unauthorize A Location
    [Arguments]  ${location_id}
    click element  xpath=//*[@value='Unauthorize Location']
    wait until element is visible  xpath=//*[@name='id']  timeout=45  error=Could not display Location Authorize Screen
    input text  xpath=//*[@name='id' and @type="text"]     ${location_id}
    click button     xpath=//*[@name='searchLocation']
    select checkbox      xpath=//*[@value='${location_id}' and @name='authorizeIds']
    click element    xpath=//*[@name='saveUnauthorizedLocations']
    sleep  1.5
    assert message  Successfully removed location
    assert message  from the list of authorized

Authorize A Location
    [Arguments]  ${location_id}
    click element  xpath=//*[@value='Unauthorize Location']
    wait until element is visible  xpath=//*[@name='id']  timeout=45  error=Could not display Location Authorize Screen
    input text  xpath=//*[@name='id' and @type="text"]     ${location_id}
    click button     xpath=//*[@name='searchLocation']
    select checkbox      xpath=//*[@value='${location}' and @name='unAuthorizeIds']
    click element    xpath=//*[@name='removeUnauthorizedLocations']
    sleep  1.5
    assert message  Successfully removed location
    assert message  from the list of unauthorized

Verify Location In The Card_Loc Table
    [Arguments]  ${card_num}  ${location_id}
    Get Into DB  tch
    ${DBlocation}=  query and strip  select location_id from card_loc where card_num = '${card_num}' and location_id = '${location_id}'
    should be equal as strings  ${DBlocation}  ${location}  msg=Location ${location_id} was not in the card_loc table

Verify Location Is Not In Card_Loc Table
    [Arguments]  ${card_num}  ${location_id}
    Get Into DB  tch
    ${status}  run keyword and return status  row count is 0  select location_id from card_loc where card_num = '${card_num}' and location_id = '${location_id}'
    run keyword unless  ${status}  Location ${location_id} is still in the card_loc table

Click Authorize Button On Card Location Management
    [Arguments]  ${location_id}
    click element  xpath=//*[@value='${location_id}']/following-sibling::input[@name='authorizeLocation']
    Handle Alert
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]

Change Location Status
    [Arguments]  ${source}
    wait until element is visible  xpath=//*[@name='card.header.locationSource' and @value='${source}']
    select radio button  card.header.locationSource  ${source}
    wait until element is visible  xpath=//*[@name='saveCardInformation']   ${wait}
    click button  saveCardInformation
    wait until page contains element  xpath=//*[@name='card.header.locationSource' and @value='${source}' and @checked='checked']  ${wait}
    IF  '${source}'=='POLICY'
        Wait Until Page Contains    To add new Location to this card
    ELSE
        Wait Until Page Does Not Contain    To add new Location to this card
    END

Validate Location Source
    [Arguments]  ${modelCard}  ${expected}
    ${expected}  run keyword if  '${expected}' == 'POLICY'  assign string  D  ELSE  assign string  ${expected}
    ${sql}  catenate  select locsrc from cards where card_num = '${modelCard.num}'
    ${locsrc}  Query And Strip  ${sql}  db_instance=tch
    should be equal as strings  ${locsrc}  ${expected[0]}

Verify Chains are Filtered
    ${list}  Get List Items    chainId  values=${TRUE}
    Should Be Equal As Strings    ${list}  ['none', '5', '6', '7', '8', '9', '10']