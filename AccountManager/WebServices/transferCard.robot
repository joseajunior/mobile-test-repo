*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  Collections
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services  refactor
Suite Setup  Setup WS

*** Variables ***

${SCR_INFORMATION_CARD}    C
${SCR_INFORMATION_POLICY}  D
${SCR_INFORMATION_BOTH}    B
${ID_REMOVE_AMOUNT}        RMVE
${ID_ADD_AMOUNT}           LOAD
${CARD_INACTIVE_STATUS}    I

${source_card_info}
${target_card_info}

*** Test Cases ***

Transfer Information From One Valid Card To Another
    [Tags]  JIRA:BOT-1618  qTest:30860715  Regression
    [Documentation]  Make sure you can transfer one valid card information to another using the ws call transferCard


    Set a proper card to copy
    Set a destination card
    log to console  source card: ${source_card_info["card_num"]}
    log to console  target card: ${target_card_info["card_num"]}
    transferCard  ${source_card_info["card_num"]}  ${target_card_info["card_num"]}
    Check if the copied card is inactive
    Tch Logging  \n Check if the copied card is inactive
    Compare data between two cards

Transfer Information From One Card To Another With An Empty Card Number
    [Tags]  JIRA:BOT-1618  qTest:30860723  Regression
    [Documentation]  Make sure you can't transfer information from one card to another card with empty card number

    ${error}  Run Keyword And Expect Error  *  transferCard  5567488850400962  ${EMPTY}
    Should Start With  ${ws_error}  ERROR running command

    ${error}  Run Keyword And Expect Error  *  transferCard  ${EMPTY}  5567488850400962
    Should Start With  ${ws_error}  ERROR running command

Transfer Information From One Card To Another With An SPACE on the Card Number
    [Tags]  JIRA:BOT-1618  qTest:30860830  Regression
    [Documentation]  Make sure you can't tranfer information from one card another when it has a space on the card number


    ${error}  Run Keyword And Expect Error  *  transferCard  5567488850400962  55674888${SPACE}400962
    Should Start With  ${ws_error}  ERROR running command

    ${error}  Run Keyword And Expect Error  *  transferCard  55674888${SPACE}400962  5567488850400962
    Should Start With  ${ws_error}  ERROR running command


Transfer Information From One Card To Another Using An Invalid Card
    [Tags]  JIRA:BOT-1618  qTest:30860987  Regression
    [Documentation]  Make sure you can't transfer one card information to another when you hve an invalid card number

    ${error}  Run Keyword And Expect Error  *  transferCard  5567488850400962  1nv@l1dC@r&
    Should Start With  ${ws_error}  ERROR running command

    ${error}  Run Keyword And Expect Error  *  transferCard  1nv@l1dC@r&  5567488850400962
    Should Start With  ${ws_error}  ERROR running command



*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Set a proper card to copy
    [Documentation]  Search a card wich has Prompts, Cash Adv and SmartPay Cash* info.
    ...              * Not included in database search
    # Dynamic card number
    ${source_card_info}  Search Card to Copy
    should not be empty  ${source_card_info}  No suitable source card found.
    set global variable  ${source_card_info}

Set a destination card
    [Documentation]  Search a valid random card.
    # Dynamic card number
    ${target_card_info}  Search a Destination Card
    should not be empty  ${target_card_info}  No suitable target card found.
    set global variable  ${target_card_info}

Check if the copied card is inactive
    [Documentation]  Copied card must be inactive.
    ${status_source_card}  Get Status From Card
    Should be equal as Strings  ${status_source_card}  ${CARD_INACTIVE_STATUS}  [Check if the copied card is inactive] Should be equal as Strings FAILURE.

Compare data between two cards
    Compare Card Information
    log to console  Information OK!

Compare Card Information
    ${source_card_information}  Get Complete Information  ${source_card_info['card_num']}  ${source_card_info['carrier_id']}  ${source_card_info['icardpolicy']}
    Tch Logging  \n getting complete info from the source card: ${source_card_information}
    ${target_card_information}  Get Complete Information  ${target_card_info['card_num']}  ${target_card_info['carrier_id']}  ${target_card_info['icardpolicy']}
    Tch Logging  \n getting complete info from the target card: ${target_card_information}
    Should Be Equal As Strings  ${source_card_information[0]}  ${target_card_information[0]}

Get Complete Information
    [Arguments]  ${card_num}  ${carrier_id}  ${ipolicy}  ${infosrc}=${SCR_INFORMATION_BOTH}
    ${card_information}  Run Keyword If  '${infosrc}'!='${SCR_INFORMATION_POLICY}'
    ...  Get Card Information  ${card_num}
    ...  ELSE
    ...  Tch Logging  Could Not Get Card Information
    [Return]  ${card_information}

Search Card to Copy
    [Documentation]  Search a card wich has Prompts, Cash Adv and SmartPay Cash* info.
    ...              * Not included
    ${query}  Catenate
    ...               SELECT TRIM(c.card_num) AS card_num,
    ...                      c.carrier_id,
    ...                      c.icardpolicy,
    ...                      c.infosrc
    ...               FROM cards c
    ...               WHERE EXISTS (SELECT 1 FROM card_inf ci WHERE ci.card_num = c.card_num)
    ...               AND EXISTS (SELECT 1 FROM def_info di WHERE di.carrier_id = c.carrier_id AND di.ipolicy = c.icardpolicy)
    ...               AND EXISTS (SELECT 1 FROM payr_cash_adv pca WHERE pca.card_num = c.card_num AND pca.id = '${ID_ADD_AMOUNT}')
    ...               AND EXISTS (SELECT 1 FROM cash_adv ca WHERE ca.card_num = c.card_num AND ca.amount > 0 AND ca.id = '${ID_ADD_AMOUNT}')
    ...               AND EXISTS (SELECT 1 FROM card_misc cm WHERE cm.card_num = c.card_num)
    ...               AND c.status != '${CARD_INACTIVE_STATUS}'
    ...               AND c.carrier_id = ${username}
    ...               limit 1
    ${card_info}  Query And Strip to Dictionary  ${query}
    [Return]  ${card_info}

Search A Destination Card
    [Documentation]  Search a valid random card.
    ...              *Workaround:  It is needed to get only rows with a numeric card number. (EFS error message)
    ...                            Not elegant way to do it.
    ${query}  Catenate
    ...               SELECT TRIM(c.card_num) AS card_num,
    ...                      c.carrier_id,
    ...                      c.icardpolicy,
    ...                      c.infosrc
    ...               FROM cards c
    ...               WHERE c.status != '${CARD_INACTIVE_STATUS}'
    ...               AND c.card_num != '${source_card_info["card_num"]}'
    ...               AND c.carrier_id = ${username}
    ...               AND c.icardpolicy = ${source_card_info["icardpolicy"]}
    ...               AND UPPER(c.card_num) = LOWER(c.card_num)
    ...               limit 1
    ${card_info}  Query And Strip to Dictionary  ${query}
    [Return]  ${card_info}

Get Status From Card
    ${status_source_card}  query and strip  SELECT status FROM cards WHERE card_num = '${source_card_info["card_num"]}'
    [Return]  ${status_source_card}

Get Card Information
    [Arguments]  ${card_num}
    [Documentation]  Get Card information.
    ${card_information}  query and strip to list  SELECT info_id, TRIM(info_validation) as info_validation FROM card_inf WHERE card_num ='${card_num}'
    [Return]  ${card_information}