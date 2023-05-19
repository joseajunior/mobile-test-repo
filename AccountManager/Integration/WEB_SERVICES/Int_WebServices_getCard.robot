*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH       #USED TO BE Library  SSHLibrary
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../Keywords/PortalKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Integration  WebServices  Shifty

Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***

*** Test Cases ***
Compare Card Header With DB
    [Tags]  qTest:30782649  refactor
    Set Test Variable  ${card}  ${validCard.card_num}
    ${card_header}  getCardHeader  ${card}
    Assert Card Header  ${card_header}

Compare Card Limits With DB
    [Tags]  qTest:30782650
    Set Test Variable  ${card}  ${validCard.card_num}
    ${card_limits}  getCardLimitsWS  ${card}
    Assert Card Limits  ${card_limits}

Compare Card Prompts With DB
    [Tags]  qTest:30782651
    Set Test Variable  ${card}  ${validCard.card_num}
    ${card_info}  getCardInfos  ${card}
    Assert Card Prompts  ${card_info}

Compare Card Locations With DB
    [Tags]  qTest:30782652
    Set Test Variable  ${card}  ${validCard.card_num}
    ${card_locations}  getCardLocations  ${card}
    Assert Card Locations  ${card_locations}

*** Keywords ***
Setup WS
    Get Into DB  TCH

    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    Start Setup Card  ${validCard.card_num}
    Setup Card Header  status=ACTIVE

Teardown WS
    Disconnect From Database
    logout

Assert Card Header
    [Arguments]  ${ws_header}
    ${db_header}  Get Policy Header From DB  ${card}

    ${last_used_date}  Format Date to Dictionary  ${ws_header[0]}  lastUsedDate
    Set To Dictionary  ${ws_header[0]}  lastUsedDate=${last_used_date}
    Remove From Dictionary  ${ws_header[0]}  overrideAllLocations
    Remove From Dictionary  ${ws_header[0]}  originalStatus

    ${db_ws_match}  Compare Dictionaries As Strings  ${ws_header[0]}  ${db_header[0]}
    Should Be True  ${db_ws_match}

Assert Card Limits
    [Arguments]  ${ws_limits}
    ${db_limits}  Get Card Limits From DB  ${card}
    ${db_ws_match}  Compare List Dictionaries As Strings  ${ws_limits}  ${db_limits}
    Should Be True  ${db_ws_match}

Assert Card Prompts
    [Arguments]  ${ws_prompts}
    ${db_prompts}  Get Card Prompts From DB  ${card}
    ${db_ws_match}  Compare List Dictionaries As Strings  ${ws_prompts}  ${db_prompts}
    Should Be True  ${db_ws_match}

Assert Card Locations
    [Arguments]  ${ws_locations}
    ${db_locations}  Get Card Locations From DB  ${card}
    ${db_ws_match}  Compare List Dictionaries As Strings  ${ws_locations}  ${db_locations}
    Should Be True  ${db_ws_match}

Assert Card Locations Groups
    [Arguments]  ${ws_locations}
    ${db_locations}  Get Card Locations Groups From DB  ${card}
    ${db_ws_match}  Compare List Dictionaries As Strings  ${ws_locations}  ${db_locations}
    Should Be True  ${db_ws_match}
    getCardLocationGroups

Get Card Prompts From DB
    [Arguments]  ${card}
    ${query}  Catenate
    ...  SELECT TRIM(info_id) AS infoId,
    ...    CASE
    ...      WHEN info_validation MATCHES '*;TS*' THEN 'true'
    ...      ELSE TRIM('false')
    ...    END AS lengthCheck,
    ...    CASE
    ...      WHEN SUBSTR(info_validation, 0,1) = 'V' THEN TRIM(SUBSTR(info_validation, 2))
    ...      ELSE TRIM('')
    ...     END AS matchValue,
    ...    CASE
    ...      WHEN info_validation MATCHES '*;X*' THEN SUBSTR(info_validation, CHARINDEX(';M',info_validation)+2, (CHARINDEX(';X',info_validation)-CHARINDEX(';M',info_validation)-2))
    ...      ELSE TRIM('0')
    ...    END AS minimum,
    ...    CASE
    ...      WHEN info_validation MATCHES '*;X*' THEN SUBSTR(info_validation, CHARINDEX(';X',info_validation)+2)
    ...      ELSE TRIM('0')
    ...    END AS maximum,
    ...    CASE
    ...      WHEN SUBSTR(info_validation, 0,1) = 'Z' THEN TRIM(SUBSTR(info_validation, 2))
    ...      ELSE TRIM('')
    ...     END AS reportValue,
    ...    CASE
    ...      WHEN SUBSTR(info_validation, 0,1) = 'V' THEN TRIM('EXACT_MATCH')
    ...      WHEN SUBSTR(info_validation, 0,1) = 'N' THEN TRIM('NUMERIC')
    ...      WHEN SUBSTR(info_validation, 0,1) = 'Z' THEN TRIM('REPORT_ONLY')
    ...      WHEN SUBSTR(info_validation, 0,1) = 'B' THEN TRIM('ALPHANUMERIC')
    ...      WHEN SUBSTR(info_validation, 0,1) = 'R' THEN TRIM('ACCRUAL_CHECK')
    ...      WHEN SUBSTR(info_validation, 0,1) = 'P' THEN TRIM('INFO_POOL')
    ...      ELSE NULL
    ...     END AS validationType,
    ...     CASE
    ...      WHEN SUBSTR(info_validation, 0,1) = 'N' AND info_validation NOT MATCHES '*M*' THEN DECODE(SUBSTR(info_validation, 2),'','0',SUBSTR(info_validation, 2))
    ...      WHEN SUBSTR(info_validation, 0,1) = 'R' THEN right(trim(info_validation), len(trim(info_validation)) -1)

    ...      ELSE TRIM('0')
    ...     END AS value
    ...  FROM card_inf
    ...  WHERE card_num='${card}'
    ${database}  Query To Dictionaries  ${query}
    [Return]  ${database}

Get Card Limits From DB
    [Arguments]  ${card}
    ${query}  Catenate
    ...     SELECT DECODE(TO_CHAR(hours), NULL, '0',TO_CHAR(hours)) AS hours,
    ...       TO_CHAR(limit) AS limit,
    ...       TRIM(limit_id) AS limitId,
    ...       DECODE(TO_CHAR(minhours), NULL, '0', TO_CHAR(minhours)) AS minHours
    ...     FROM card_lmt WHERE card_num='${card}'
    ${database}  Query To Dictionaries  ${query}
    [Return]  ${database}

Get Card Locations From DB
    [Arguments]  ${card}
    ${query}  Catenate
    ...  SELECT TO_CHAR(location_id) AS location_id FROM card_loc WHERE card_num='${card}'
    ${database}  Query And Strip To Dictionary  ${query}
    [Return]  ${database}


Get Policy Header From DB
    [Arguments]  ${card}
    ${query}  Catenate
    ...  SELECT TRIM(DECODE(coxref, NULL, '', coxref)) AS companyXRef,
    ...         TRIM(DECODE(handenter,'Y', 'ALLOW', 'N', 'DISALLOW', 'POLICY')) AS handEnter,
    ...         TRIM(DECODE(infosrc, 'B', 'BOTH', 'C', 'CARD', 'POLICY')) AS infoSource,
    ...         TRIM(DECODE(lmtsrc, 'B', 'BOTH', 'C', 'CARD', 'POLICY')) AS limitSource,
    ...         DECODE(TO_CHAR(loc_override), NULL, '0',  TO_CHAR(loc_override)) AS locationOverride,
    ...         TRIM(DECODE(locsrc, 'B', 'BOTH', 'C', 'CARD', 'POLICY')) AS locationSource,
    ...         TRIM(DECODE(payr_status, 'A', 'ACTIVE', 'D', 'DELETED', 'H', 'HOLD', 'I', 'INACTIVE', 'FOLLOWS')) AS payrollStatus,
    ...         cardoverride AS override,
    ...         icardpolicy AS policyNumber,
    ...         TRIM(DECODE(status, 'A', 'ACTIVE', 'D', 'DELETED', 'H', 'HOLD', 'U', 'FRAUD', 'INACTIVE')) AS status,
    ...         TO_CHAR(last_used,"%Y-%m-%dT%H:%M:%S") AS lastUsedDate,
    ...         TRIM(DECODE(timesrc, 'B', 'BOTH', 'C', 'CARD', 'POLICY')) AS timeSource,
    ...         last_trans AS lastTransaction,
    ...         TRIM(payr_use) AS payrollUse,
    ...         TRIM(DECODE(payr_atm, 'B', 'BOTH', 'C', 'CARD', 'Y', 'ALLOW', 'D', 'POLICY', '', 'POLICY', ' ', 'POLICY', 'DISALLOW')) AS payrollAtm,
    ...         TRIM(DECODE(payr_chk, 'B', 'BOTH', 'C', 'CARD', 'Y', 'ALLOW', 'D', 'POLICY', '', 'POLICY', ' ', 'POLICY', 'DISALLOW')) AS payrollChk,
    ...         TRIM(DECODE(payr_ach, 'B', 'BOTH', 'C', 'CARD', 'Y', 'ALLOW', 'D', 'POLICY', '', 'POLICY', ' ', 'POLICY', 'DISALLOW')) AS payrollAch,
    ...         TRIM(DECODE(payr_wire, 'B', 'BOTH', 'C', 'CARD', 'Y', 'ALLOW', 'D', 'POLICY', '', 'POLICY', ' ', 'POLICY', 'DISALLOW')) AS payrollWire,
    ...         TRIM(DECODE(payr_debit, 'B', 'BOTH', 'C', 'CARD', 'Y', 'ALLOW', 'D', 'POLICY', '', 'POLICY', ' ', 'POLICY', 'DISALLOW')) AS payrollDebit
    ...  FROM cards
    ...  WHERE card_num = '${card}';
    ${database}  Query To Dictionaries  ${query}
    [Return]  ${database}

Format Date to Dictionary
    [Arguments]  ${dictionary}  ${key}
    ${pos_date}  Get From Dictionary  ${dictionary}  ${key}
    ${pos_date}  Get Substring  ${pos_date}  0  -10
    [Return]  ${pos_date}