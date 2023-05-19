*** Settings ***
Test Timeout  5 minutes
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  otr_model_lib.Models
Library  String
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  eManager

*** Variables ***

*** Test Cases ***
Run Transaction With a Product Restriction
    [Documentation]  When a carrier has a product restriction for a particular unit,
    ...              then that product is unavailable for purchase.
    [Tags]  BOT-166  refactor
    [Setup]  Run Keywords  Define Basic Test Varibles to Card  ${validCard}
    ...     AND  Setup Basic Card Prompts To Run a Transaction And Add U$"100" Limit to "ULSD" for The Card "${card_num}"
    ...     AND  Allow Product Limits Feature to carrier "${carrier}" Adding "PRODLIMTS" to member_meta.mm_key
    Make Sure Carrier "${carrier}" Has an "ULSD" Restriction
    Run a U$"20.00" "ULSD" Transaction Using Card ${card_num} In Location ${location}
    Make Sure The Transaction Failed With Message "ULSD LIMIT EXCEEDED"
    [Teardown]  Restore Original Product Restrictions("PRODLIMTS") Setup to Carrier "${carrier}"

Run Transaction Without a Product Restriction
    [Documentation]  When a carrier has a product restriction for a particular unit,
    ...              then that product is unavailable for purchase.
    [Tags]  BOT-166  refactor
    [Setup]  Run Keywords  Define Basic Test Varibles to Card  ${validCard}
    ...     AND  Setup Basic Card Prompts To Run a Transaction And Add U$"100" Limit to "ULSD" for The Card "${card_num}"
    ...     AND  Allow Product Limits Feature to carrier "${carrier}" Adding "PRODLIMTS" to member_meta.mm_key
    Make Sure Carrier "${carrier}" Has no Restriction to "ULSD" Product
    Run a U$"20.00" "ULSD" Transaction Using Card ${card_num} In Location ${location}
    Make Sure The Transaction Succeed
    [Teardown]  Restore Original Product Restrictions("PRODLIMTS") Setup to Carrier "${carrier}"

*** Keywords ***
Define Basic Test Varibles to Card
    [Arguments]  ${card}
    tch logging  \nDefine Card and Location
    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${card_num}  ${card.card_num}
    Set Test Variable  ${location}  ${card.valid_location}
    Set Test Variable  ${carrier}  ${card.carrier.id}

Setup Basic Card Prompts To Run a Transaction And Add U$"${limit}" Limit to "${prod}" for The Card "${card_num}"
    tch logging  Setup Basic Card Prompts To Run a Transaction And Add U$"${limit}" Limit to "${prod}" for The Card "${card_num}"
    Set Test Variable  ${prompt}  UNIT
    Set Test Variable  ${prompt_value}  1234
    Set Test Variable  ${prod}

    Start Setup Card  ${card_num}
    Setup Card Header  status=ACTIVE  infoSource=CARD  limitSource=CARD  locationOverride=0  override=0
    Setup Card Prompts  ${prompt}=V${prompt_value}
    Setup Card Limits  ${prod}=${limit}
    Update Contract Limits by Card  ${card_num}

Allow Product Limits Feature to carrier "${carrier}" Adding "${mm_key}" to member_meta.mm_key
    tch logging  Allow Product Limits Feature to carrier "${carrier}" Adding "${mm_key}" to member_meta.mm_key
    Get Into DB  ${DB}
    Run Keyword And Ignore Error  execute sql string  dml=insert INTO member_meta(member_id,mm_key,mm_value) VALUES (${carrier},'${mm_key}','Y')

Make Sure Carrier "${carrier}" Has an "${prod}" Restriction
    tch logging  Make Sure Card "${card_num}" Has an "${prod}" Restriction
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM prod_restriction WHERE carrier_id=${carrier} AND info_id='${prompt}' AND info_value='${prompt_value}' AND group_id='${prod}'
    execute sql string  dml=insert INTO prod_restriction VALUES (${carrier}, '${prompt}', '${prompt_value}', '${prod}', 'AUTOMATION')

Make Sure Carrier "${carrier}" Has no Restriction to "${prod}" Product
    tch logging  Make Sure Carrier "${carrier}" Has no Restriction to "${prod}" Product
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM prod_restriction WHERE carrier_id=${carrier} AND info_id='${prompt}' AND info_value='${prompt_value}' AND group_id='${prod}'

Run a U$"${total}" "${prod}" Transaction Using Card ${card_num} In Location ${location}
    tch logging  Run a U$"${total}" "${prod}" Transaction Using Card ${card_num} In Location ${location}
    Get Into DB  ${DB}
    Start AC String
    Set String Location  ${location}
    Set String Card  ${card_num}
    Use Dynamic Invoice
    Add Info Prompt Value To String  ${prompt}  ${prompt_value}
    Add Fuel By Abbreviation To String  ${prod}  1.00  ${total}
    Calculate String Total
    ${ACstring}  Finalize String
    ${logfile}  Create Log File
    Run RossAuth  ${ACstring}  ${logfile}
    Set Test Variable  ${logfile}

Make Sure The Transaction Failed With Message "${message}"
    tch logging  Make Sure The Transaction Failed With Message "${message}"
    Set Log File  ${logfile}
    Auth log Should Contain Error  ${message}

Make Sure The Transaction Succeed
    tch logging  Make Sure The Transaction Succeed
    Set Log File  ${logfile}
    ${trans_id}  Log Should Have a Trans Id

Restore Original Product Restrictions("${mm_key}") Setup to Carrier "${carrier}"
    tch logging  Restore Original Product Restrictions("${mm_key}") Setup to Carrier "${carrier}"
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM prod_restriction WHERE carrier_id=${carrier} AND info_id='${prompt}' AND info_value='${prompt_value}' AND group_id='${prod}'
    execute sql string  dml=delete FROM member_meta WHERE member_id=${carrier} AND mm_key='${mm_key}' AND mm_value='Y'