*** Settings ***
Test Timeout  5 minutes

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.setup.PySetup
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Suite Setup CardTransfer
Suite Teardown  Close Browser
Force Tags  eManager


*** Variables ***
${ID_REMOVE_AMOUNT}        RMVE
${ID_ADD_AMOUNT}           LOAD
${source_card}
${destination_card}
${orig_dest_sf_balance}
${orig_dest_ca_balance}

*** Test Cases ***
Card Transfer - Transfer card info and money from one card to another
    [Tags]    JIRA:BOT-145  JIRA:BOT-1948  refactor
    [Documentation]  Summary: Transfer card info and money from one card to another.
    ...
    ...              Need 2 card numbers; one with some prompts, cash adv. and smartpay cash
    ...              the second card can have whatever on it.

    Transfer data from one card to another
    Check if the Source card is inactive
    Validate card transfer

*** Keywords ***
Transfer data from one card to another

    go to  ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    Input Text     name=cardSearchTxt  ${source_card.num}
    Click Button   name=searchCard

    wait until element is visible  //a[contains(text(), "${source_card.num}") or (contains(text(), "${source_card.num[:5]}") and contains(text(), "${source_card.num[-4:]}"))]
    log to console  \nSource Card: ${source_card.num} \nTarget Card: ${destination_card.num}

    Click Element   xpath=//table[@id="cardSummary"]//input[@name='transferCard']
    wait until element is visible  //td[contains(text(), "${source_card.num}") or (contains(text(), "${source_card.num[:5]}") and contains(text(), "${source_card.num[-4:]}"))]
    Input Text      name=transferCardNumber  ${destination_card.num}
    Click Element   name=saveTransfer
    Handle Alert
    wait until element is visible  xpath=//*[@class="messages"]//*[contains(text(), 'Information has been successfully transferred from card')]  20  Card Transfer did no complete within 20 seconds

Check if the Source card is inactive
    [Documentation]  Copied card must be inactive.
    Should be equal as Strings  ${source_card.status}  I  [Check if the Source card is inactive] Should be equal as Strings FAILURE.

Compare data between two cards
    Compare Card Information
    log to console  Information OK!

####################### AUX FUNCTIONS #######################

Compare SmartFunds
    ${source_sf_balance}  ${source_sf_amount}  Get SmartFunds  ${source_card.num}
    ${dest_sf_balance}  ${dest_sf_amount}  Get SmartFunds  ${destination_card.num}
    ${calculated_dest_sf_amt}=  evaluate  ${source_sf_amount}+${orig_dest_sf_balance}
    Should Be Equal as numbers   ${calculated_dest_sf_amt}  ${dest_sf_balance}  Smartfunds destination balance does not equal the source amount
    Should Be Equal as numbers   ${source_sf_balance}  0  Smartfunds source balance was not 0

Compare Cash Adv
    ${source_ca_balance}  ${source_ca_amount}  Get Cash Adv  ${source_card.num}
    ${dest_ca_balance}  ${dest_ca_amount}  Get Cash Adv  ${destination_card.num}
    ${calculated_dest_ca_amt}=  evaluate  ${source_ca_amount}+${orig_dest_ca_balance}
    Should Be Equal as numbers  ${calculated_dest_ca_amt}  ${dest_ca_balance}  Cash advance destination balance does not equal the source amount
    Should Be Equal as numbers   ${source_ca_balance}  0  Cash advance source balance was not 0

Compare Card Lmt
    ${source_card_lmt}  Get card lmt  ${source_card.num}
    ${target_card_lmt}  Get card lmt  ${destination_card.num}
    ${source_length}  get length  ${source_card_lmt}
    ${target_length}  get length  ${target_card_lmt}
    should be equal as numbers  ${source_length}  ${target_length}  Source card does not contain the same number of limits as the target card

    ${complete_error}  set variable  ${empty}

    FOR  ${i}  IN RANGE  0  ${source_length}
        ${status}  ${error}  run keyword and ignore error  dictionaries should be equal  ${source_card_lmt[${i}]}  ${target_card_lmt[${i}]}
        ${complete_error}  run keyword if  '${status}' == 'FAIL'  assign string  ${complete_error} ${\n}${error}  ELSE  assign string  ${complete_error}
    END

    run keyword if  '${complete_error}' != ''  fail  ${complete_error}

Compare Card Information
    ${source_card_information}  Get Complete Information  ${source_card.num}  ${source_card.carrier.id}  ${source_card.policy.num}
    ${target_card_information}  Get Complete Information  ${destination_card.num}  ${destination_card.carrier.id}  ${destination_card.policy.num}
    Dictionary Should Contain Sub Dictionary  ${target_card_information}  ${source_card_information}  Compare Card Information FAIL

Get Complete Information
    [Arguments]  ${card_num}  ${carrier_id}  ${ipolicy}  ${infosrc}=B
    ${card_information}  Run Keyword If  '${infosrc}'!='D'
    ...  Get Card Information  ${card_num}
    ...  ELSE
    ...  Create List
    ${information_dictionary}  Convert List With Pairs In a Dictionary  ${card_information}
    [Return]  ${information_dictionary}

Convert List With Pairs In a Dictionary
    [Arguments]  ${list}
    ${dictionary}  create dictionary

    ${key}    Get From List  ${list}  0
    ${value}  Get From List  ${list}  1
    Set To Dictionary  ${dictionary}  ${key}  ${value}
    [Return]  ${dictionary}

####################### DATABASE ACCESS KEYWORDS #######################

Get SmartFunds
    [Arguments]  ${card_num}
    ${query}  catenate  SELECT * FROM payr_cash_adv WHERE card_num = '${card_num}' ORDER BY when DESC
    ${smart_funds}  query and return dictionary rows  ${query}
    ${row_count}=  get length  ${smart_funds}
    return from keyword if  ${row_count}==0  0  0
    [Return]  ${smart_funds[0]['balance']}  ${smart_funds[0]['amount']}

Get Cash Adv
    [Arguments]  ${card_num}
    ${query}  catenate  SELECT * FROM cash_adv WHERE card_num = '${card_num}' ORDER BY when DESC
    ${cash_advance}  query and return dictionary rows  ${query}
    ${row_count}=  get length  ${cash_advance}
    return from keyword if  ${row_count}==0  0  0
    [Return]  ${cash_advance[0]['balance']}  ${cash_advance[0]['amount']}

Get Card Lmt
    [Arguments]  ${card_num}
    ${card_lmts}  query and return dictionary rows  SELECT limit_id,limit,hours,minhours,hour_of_day,day_of_month,daily_max,effect_date FROM card_lmt WHERE card_num='${card_num}' ORDER BY limit_id
    [Return]  ${card_lmts}

Get Card Information
    [Arguments]  ${card_num}
    [Documentation]  Get Card information.
    ${card_information}  query and strip to list  SELECT info_id, TRIM(info_validation) as info_validation FROM card_inf WHERE card_num ='${card_num}'
    [Return]  ${card_information}

Getting Source and Destination Cards

    FOR  ${i}  IN RANGE  0  999999
        ${sql_src}=  catenate  SELECT TRIM(c.card_num) AS card_num
        ...  FROM cards c
        ...    JOIN def_card dc
        ...      ON c.carrier_id = dc.id
        ...     AND c.icardpolicy = dc.ipolicy
        ...    JOIN contract co ON (dc.contract_id = co.contract_id)
        ...    INNER JOIN member m ON (c.carrier_id = m.member_id)
        ...  WHERE c.status = 'A'
        ...  AND   co.status = 'A'
        ...  AND   c.cardoverride != 'Y'
        ...  AND   payr_use IN ('Y','B')
        ...  AND   mrcsrc IN ('B','N')
        ...  AND   c.last_used > TODAY - 100
        ...  AND   c.card_num NOT LIKE '%OVER%'
        ...  AND   c.card_num NOT LIKE '%TRIP%'
        ...  AND   c.card_num NOT LIKE '%UNIT%'
        #${row_count}  row count is greater than x  ${sql}  1

        ${row_count_src}  row count  ${sql_src}

        ${source_card}  find card variable  ${sql_src}
        #${destination_card}  set variable  ${source_card.carrier.find_card("card_num != '${source_card.num}'", "status = 'A'", "payr_use IN ('Y','B')", "mrcsrc IN ('B','N')", "card_num NOT LIKE '%TRIP%'", "card_num NOT LIKE '%OVER%'","card_num NOT LIKE '%UNIT%'", "icardpolicy = '${source_card.policy.num}'")}

        ${sql_dest}=  catenate  SELECT TRIM(c.card_num) AS card_num
        ...  FROM cards c
        ...    JOIN def_card dc
        ...      ON c.carrier_id = dc.id
        ...     AND c.icardpolicy = dc.ipolicy
        ...    JOIN contract co ON (dc.contract_id = co.contract_id)
        ...    INNER JOIN member m ON (c.carrier_id = m.member_id)
        ...  WHERE c.status = 'A'
        ...  AND   co.status = 'A'
        ...  AND   c.cardoverride != 'Y'
        ...  AND   payr_use IN ('Y','B')
        ...  AND   mrcsrc IN ('B','N')
        ...  AND   c.last_used > TODAY - 100
        ...  AND   c.card_num NOT LIKE '%OVER%'
        ...  AND   c.card_num NOT LIKE '%TRIP%'
        ...  AND   c.card_num NOT LIKE '%UNIT%'
        ...  AND   c.carrier_id = ${source_card.carrier.id}
        ...  AND   c.icardpolicy = ${source_card.policy.num}
        ...  AND   c.card_num != '${source_card.num}'

        ${row_count_dest}  row count  ${sql_dest}

        exit for loop if  ((${row_count_src} > 1) & (${row_count_dest} > 0))
    END


    ${destination_card}  find card variable  ${sql_dest}

    set suite variable  ${source_card}
    set suite variable  ${destination_card}

Source Card Setup
    Start Setup Card  ${source_card.num}
    setup card header  payrollStatus=ACTIVE
    Setup Card Limits  ULSD=131
    Setup Card Prompts  ODRD=R10  UNIT=V123456
    log into card management web services  ${source_card.carrier.id}  ${source_card.carrier.password}
    loadCash  ${source_card.num}  201  Card Transfer Src  0
    loadCash  ${source_card.num}  201  Card Transfer Src  1


Destination Card Setup
    Start Setup Card  ${destination_card.num}
    setup card header  payrollStatus=ACTIVE
    Setup Card Limits  ULSD=500
    Setup Card Prompts  UNIT=V1234
    loadCash  ${destination_card.num}  201  Card Transfer Dest  0
    loadCash  ${destination_card.num}  201  Card Transfer Dest  1
    #get original balance before it is changed
    ${orig_dest_ca_balance}  ${orig_dest_ca_amount}  get cash adv  ${destination_card.num}
    ${orig_dest_sf_balance}  ${orig_dest_sf_amount}  get smartfunds  ${destination_card.num}
    set suite variable  ${orig_dest_ca_balance}
    set suite variable  ${orig_dest_ca_amount}
    set suite variable  ${orig_dest_sf_balance}
    set suite variable  ${orig_dest_sf_amount}

Suite Setup CardTransfer
    Get into db  TCH
    Getting Source and Destination Cards
    Source Card Setup
    Destination Card Setup
    open emanager  ${source_card.carrier.id}  ${source_card.carrier.password}

Validate card transfer
    ${complete_error}  set variable  ${empty}
    ${status}  ${error_msg}  run keyword and ignore error  Compare data between two cards
    ${complete_error}  run keyword if  '${status}' == 'FAIL'  assign string  ${complete_error}\n${error_msg}  ELSE  assign string  ${complete_error}
    ${status}  ${error_msg}  run keyword and ignore error  Compare Card Lmt
    ${complete_error}  run keyword if  '${status}' == 'FAIL'  assign string  ${complete_error}\n${error_msg}  ELSE  assign string  ${complete_error}
    ${status}  ${error_msg}  run keyword and ignore error  Compare Cash Adv
    ${complete_error}  run keyword if  '${status}' == 'FAIL'  assign string  ${complete_error}\n${error_msg}  ELSE  assign string  ${complete_error}
    ${status}  ${error_msg}  run keyword and ignore error  Compare SmartFunds
    ${complete_error}  run keyword if  '${status}' == 'FAIL'  assign string  ${complete_error}\n${error_msg}  ELSE  assign string  ${complete_error}
    run keyword if  '${complete_error}' != ''  fail  ${complete_error}


