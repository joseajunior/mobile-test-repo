*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.setup.PySetup

Force Tags  Web Services  refactor

Suite Setup  Setup WS
Suite Teardown  Logout WS

*** Test Cases ***

Get The Card Refreshing Limits Info From A VALID Card Number
    [Tags]  JIRA:BOT-1612  qTest:30739021  Regression  BOT-1976
    [Documentation]  Make sure you can fetch refreshing limits information from a valid card

    ${DB_info}  Get Card Refreshing Limits Info  A  ${validCard.card_num}
    ${WS_info}  getCardRefreshingLimits  ${validCard.card_num}

    ${same_dict}  Compare Dictionaries As Strings  ${DB_info[0]}  ${WS_info}
    Should Be True  ${same_dict}

Get The Card Refreshing Limits Info From An INVALID Card Number
    [Tags]  JIRA:BOT-1612  qTest:30739042  Regression
    [Documentation]  Make sure you can't fetch refreshing limits information from an invalid card number

    ${status}  Run Keyword And Return Status  getCardRefreshingLimits  708305
    Should Not Be True  ${status}

Get The Card Refreshing Limits Info From A Card With a TYPO
    [Tags]  JIRA:BOT-1612  qTest:30739050  Regression
    [Documentation]  Make sure you can't fetch refreshing limits information from a card with a typo on the number

    ${status}  Run Keyword And Return Status  getCardRefreshingLimits  70830509103!@?86616443
    Should Not Be True  ${status}

Get The Card Refreshing Limits Info With An EMPTY Card Number
    [Tags]  JIRA:BOT-1612  qTest:30739093  Regression
    [Documentation]  Make sure you can't fetch refreshing limits information using EMPTY as a parameter

    ${status}  Run Keyword And Return Status  getCardRefreshingLimits  ${EMPTY}
    Should Not Be True  ${status}

Get The Card Refreshing Limits Info With A SPACE on a card number
    [Tags]  JIRA:BOT-1612  qTest:30739143  Regression
    [Documentation]  Make sure you can fetch refreshing limits information using EMPTY as a parameter

    ${status}  Run Keyword And Return Status  getCardRefreshingLimits  ${SPACE}
    Should Not Be True  ${status}

Get The Card Refreshing Limits Info From An OVERridden Card
    [Tags]  JIRA:BOT-1612  qTest:30739210  Regression  BOT-1976
    [Documentation]  Make sure you can fetch refreshing limits information from a overriden card

    Start Setup Card  ${validCard.card_num}
    Setup Card Header  status=ACTIVE  override=1

    ${DB_info}  Get Card Refreshing Limits Info  A  ${validCard.card_num}
    ${WS_info}  getCardRefreshingLimits  ${validCard.card_num}

    ${same_dict}  Compare Dictionaries As Strings  ${DB_info[0]}  ${WS_info}
    Should Be True  ${same_dict}

Get The Card Refreshing Limits Of An INACTIVE card
    [Tags]  JIRA:BOT-1612  qTest:30739250  Regression  BOT-1976
    [Documentation]  Make sure you can fetch refreshing limits information from an INACTIVE card.

    ${query}  catenate
    ...     SELECT TRIM(card_num) FROM cards WHERE status='I' AND carrier_id=${validCard.carrier.id} AND cardoverride='0'
    ...     ORDER BY lastupdated DESC limit 1
    ${Card_Number}  Query And Strip  ${query}

    ${DB_info}  Get Card Refreshing Limits Info - INACTIVE/HOLD status  I  ${Card_Number}
    ${WS_info}  getCardRefreshingLimits  ${Card_Number}

    ${same_dict}  Compare Dictionaries As Strings  ${DB_info[0]}  ${WS_info}
    Should Be True  ${same_dict}

Get The Card Refreshing Limits Of A Card On HOLD Status
    [Tags]  JIRA:BOT-1612  qTest:30739259  Regression
    [Documentation]  Make sure you can fetch refreshing limits information from a card with a HOLD status

    ${query}  catenate
    ...     SELECT TRIM(card_num) FROM cards WHERE status='H' AND carrier_id=${validCard.carrier.id} AND cardoverride='0'
    ...     ORDER BY lastupdated DESC limit 1
    ${Card_Number}  Query And Strip  ${query}

    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${contracts_backup}  Get Backup Velocity Enable From Contract  ${validCard.carrier.id}
    Update Velocity Enable for All Carrier Contracts  ${validCard.carrier.id}  Y

    ${DB_info}  Get Card Refreshing Limits Info - INACTIVE/HOLD status  H  ${Card_Number}
    ${WS_info}  getCardRefreshingLimits  ${Card_Number}

    ${same_dict}  Compare Dictionaries As Strings  ${DB_info[0]}  ${WS_info}
    Should Be True  ${same_dict}

Get The Card Refreshing Limits Of A Card On HOLD For Fraud Status
    [Tags]  JIRA:BOT-1612  qTest:30739268  Regression  Deprecated
    [Documentation]  Make sure you can fetch refreshing limits information from a card with a HOLD FOR FRAUD status

    ${query}  catenate
    ...     SELECT TRIM(card_num) FROM cards WHERE status='U' AND carrier_id=${validCard.carrier.id} AND cardoverride='0'
    ...     ORDER BY lastupdated DESC limit 1
    ${Card_Number}  Query And Strip  ${query}

    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${contracts_backup}  Get Backup Velocity Enable From Contract  ${validCard.carrier.id}
    Update Velocity Enable for All Carrier Contracts  ${validCard.carrier.id}  Y

    ${DB_info}  Get Card Refreshing Limitstop Info  U  ${Card_Number}
    ${WS_info}  getCardRefreshingLimits  ${Card_Number}

    ${same_dict}  Compare Dictionaries As Strings  ${DB_info[0]}  ${WS_info}
    Should Be True  ${same_dict}

Get The Card Refreshing Limits Of A Deleted Card
    [Tags]  JIRA:BOT-1612  qTest:30739272  Regression
    [Documentation]  Make sure you can fetch refreshing limits information from a Deleted Card

    ${query}  catenate
    ...     SELECT TRIM(card_num) FROM cards WHERE status='D' AND carrier_id=${validCard.carrier.id} AND cardoverride='0'
    ...     ORDER BY lastupdated DESC limit 1
    ${Card_Number}  Query And Strip  ${query}

    ${status}  Run Keyword And Return Status  getCardRefreshingLimits  ${Card_Number}
    Should Be True  ${status}

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    Start Setup Card  ${validCard.card_num}
    Setup Card Header  status=ACTIVE
    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${contracts_backup}  Get Backup Velocity Enable From Contract  ${validCard.carrier.id}
    Update Velocity Enable for All Carrier Contracts  ${validCard.carrier.id}  Y

    Set Suite Variable  ${contracts_backup}

Get Card Refreshing Limits Info
    [Arguments]  ${status}  ${card_num}

    ${query}  catenate
    ...     SELECT velsrc AS refreshingLimitSource,
    ...     DECODE(TO_CHAR(day_cnt_limit), NULL, '0', TO_CHAR(day_cnt_limit)) AS dayCntLimit,
    ...     DECODE(TO_CHAR(day_amt_limit), NULL, '0', TO_CHAR(day_amt_limit)) AS dayAmtLimit,
    ...     DECODE(TO_CHAR(week_cnt_limit), NULL, '0', TO_CHAR(week_cnt_limit)) AS weekCntLimit,
    ...     DECODE(TO_CHAR(week_amt_limit), NULL, '0', TO_CHAR(week_amt_limit)) AS weekAmtLimit,
    ...     DECODE(TO_CHAR(mon_cnt_limit), NULL, '0', TO_CHAR(mon_cnt_limit)) AS monCntLimit,
    ...     DECODE(TO_CHAR(mon_amt_limit), NULL, '0', TO_CHAR(mon_amt_limit)) AS monAmtLimit
    ...     FROM cards
    ...     WHERE carrier_id='${validCard.carrier.id}' AND status='${status}' AND card_num='${card_num}'
    ...     ORDER BY lastupdated DESC LIMIT 1
    ${Card_Results}  Query To Dictionaries  ${query}

    [Return]  ${Card_Results}

Get Card Refreshing Limits Info - INACTIVE/HOLD status
    [Arguments]  ${status}  ${card_num}
        ${query}  catenate
    ...     SELECT velsrc AS refreshingLimitSource,
    ...     DECODE(TO_CHAR(day_cnt_limit), NULL, '', TO_CHAR(day_cnt_limit)) AS dayCntLimit,
    ...     DECODE(TO_CHAR(day_amt_limit), NULL, '', TO_CHAR(day_amt_limit)) AS dayAmtLimit,
    ...     DECODE(TO_CHAR(week_cnt_limit), NULL, '', TO_CHAR(week_cnt_limit)) AS weekCntLimit,
    ...     DECODE(TO_CHAR(week_amt_limit), NULL, '', TO_CHAR(week_amt_limit)) AS weekAmtLimit,
    ...     DECODE(TO_CHAR(mon_cnt_limit), NULL, '', TO_CHAR(mon_cnt_limit)) AS monCntLimit,
    ...     DECODE(TO_CHAR(mon_amt_limit), NULL, '', TO_CHAR(mon_amt_limit)) AS monAmtLimit
    ...     FROM cards
    ...     WHERE carrier_id='${validCard.carrier.id}' AND status='${status}' AND card_num='${card_num}'
    ...     ORDER BY lastupdated DESC LIMIT 1
    ${Card_Results}  Query To Dictionaries  ${query}

    [Return]  ${Card_Results}

Get Backup Velocity Enable From Contract
    [Arguments]  ${carrier}

    ${query}  Catenate  SELECT contract_id, velocity_enable FROM contract WHERE carrier_id='${carrier}'
    ${contracts_backup}  Query To Dictionaries  ${query}
    [Return]  ${contracts_backup}

Update Velocity Enable for All Carrier Contracts
    [Arguments]  ${carrier_id}  ${flag}
    execute sql string   dml=UPDATE contract SET velocity_enable = '${flag}' WHERE carrier_id = ${carrier_id}

Restore All Contract Velocity Enable
    [Arguments]  ${contracts}
    FOR  ${contract}  IN   @{contracts}
        execute sql string   dml=UPDATE contract SET velocity_enable = '${contract['velocity_enable']}' WHERE contract_id = ${contract['contract_id']}
    END

Logout WS
    Restore All Contract Velocity Enable  ${contracts_backup}
    Disconnect From Database
    Logout