*** Settings ***
Test Timeout  5 minutes
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.Models

Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot

Documentation  This is a test suite for QAT-791\\n
...   This test is to reset the pin of a card through eManager
...   and check the flags in DB
...   and updated it back to 1234


Force Tags  eManager

Suite Setup  Set Me Up
Suite Teardown  Tear Me Down

*** Variables ***
${ach_card}
${ach_card_pin}  1234

*** Keywords ***
Set Me Up
    ${ach_query}=  catenate  SELECT c.card_num FROM cards c
    ...        JOIN ach_ppd_card_xref apcx ON c.card_num = apcx.card_num
    ...        JOIN ach_ppd_header aph ON apcx.ppd_header_id = aph.ppd_header_id
    ...        JOIN def_card dc ON c.carrier_id = dc.id AND c.icardpolicy = dc.ipolicy
    ...        JOIN contract co ON dc.contract_id = co.contract_id
    ...        JOIN member m ON c.carrier_id = m.member_id
    ...    WHERE c.status = 'A'
    ...    AND co.status = 'A'
    ...    AND m.status = 'A'
    ...    AND c.card_num NOT LIKE '%OVER'
    ${ach_card}=  find card variable  ${ach_query}
    set suite variable  ${ach_card}

Tear Me Down
    sleep  3
    run keyword and ignore error  close browser

*** Test Cases ***
Reset pin through eManagaer via Update Limits
    [Tags]  JIRA:QAT-791  qTest:33169108  refactor
    [Setup]  update query
    View/Update cards - Reset Pin  limits  updatelimits
    Validating the updated pin and flag with DB
    [Teardown]  update query

Reset pin through eManagaer via Refreshing Limits
    [Tags]  JIRA:QAT-791  qTest:33638546  refactor
    [Setup]  update query
    View/Update cards - Reset Pin  limits  refreshlimits
    Validating the updated pin and flag with DB
    [Teardown]  update query

Reset pin through eManagaer via Update Prompts
    [Tags]  JIRA:QAT-791  qTest:33638661  refactor
    [Setup]  update query
    View/Update cards - Reset Pin  prompts  updateprompts
    Validating the updated pin and flag with DB
    [Teardown]  update query

Reset pin through eManagaer via Update Location
    [Tags]  JIRA:QAT-791  qTest:33638663  refactor
    [Setup]  update query
    View/Update cards - Reset Pin  location  updatelocation
    Validating the updated pin and flag with DB
    [Teardown]  update query

Reset pin through eManagaer via Update Chain
    [Tags]  JIRA:QAT-791  qTest:33656083  refactor
    [Setup]  update query
    View/Update cards - Reset Pin  location  updatechain
    Validating the updated pin and flag with DB
    [Teardown]  update query

Reset pin through eManagaer via Update Time Restriction
    [Tags]  JIRA:QAT-791  qTest:35990486  refactor
    [Setup]  update query
    View/Update cards - Reset Pin  timerestriction  updatetimerestriction
    Validating the updated pin and flag with DB
    [Teardown]  update query


*** Keywords ***
View/Update cards - Reset Pin
    [Arguments]  ${menu}  ${submenu}
    get into db    tch
    ${last4}=  query and strip  select RIGHT(RTRIM(card_num),4) from card_pins where card_num= '${ACH_card}'
    set global variable  ${last4}
    should not be equal as integers   ${last4}  1234
    open emanager    ${validCard.carrier.member_id}    ${validCard.carrier.password}
    maximize browser window
    go to   ${emanager}/cards/CardLookup.action
    click radio button     NUMBER
    input text   cardSearchTxt  ${ACH_card}
    click button    searchCard
    click link    ${ACH_card}
    run keyword if  '${menu}'=='limits'  mouse over  xpath=//*[@id='cardMenubar_3x2']  #limits
    ...   ELSE IF  '${menu}'=='prompts'  mouse over  xpath=//*[@id='cardMenubar_4x2']  #prompts
    ...   ELSE IF  '${menu}'=='location'  mouse over  xpath=//*[@id='cardMenubar_5x2']  #locaion
    ...   ELSE IF  '${menu}'=='timerestriction'  mouse over  xpath=//*[@id='cardMenubar_5x2']  #timerestriction

    run keyword if  '${submenu}'=='updatelimits'  click element    xpath=//*[@id='cardLimits_1x2']  #updatelimits
    ...   ELSE IF  '${submenu}'=='refreshlimits'  click element    xpath=//*[@id='cardLimits_2x2']  #refreshlimits
    ...   ELSE IF  '${submenu}'=='updateprompts'  click element    xpath=//*[@id='cardPrompts_1x2']  #updateprompts
    ...   ELSE IF  '${submenu}'=='updatelocation'  click element    xpath=//*[@id='cardLocation_1x2']  #updatelocation
    ...   ELSE IF  '${submenu}'=='updatechain'  click element    xpath=//*[@id='cardLocation_2x2']  #updatechain
    ...   ELSE IF  '${submenu}'=='updatetimerestriction'  click element    xpath=//*[@id='cardLocation_1x2']  #updatetimerestriction

    click button    resetPin
    wait until page contains    has been reset
    set global variable  ${ACH_card}
    close browser

Validating the updated pin and flag with DB
    get into db    tch
    ${output}=  query and strip to dictionary  select pin,valid from card_pins where card_num= '${ACH_card}'
    should be equal as strings    ${output.pin.strip()}  ${last4}
    should be equal as strings  ${output.valid}  N

update query
    get into db  tch
    execute sql string  dml=update card_pins SET pin = 1234, valid = 'Y' WHERE card_num = '${ACH_card}'