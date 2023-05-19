*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS

*** Test Cases ***

Get Card Information By Driver Id
    [Tags]  JIRA:BOT-1572  qTest:30704746  Regression  refactor  tier:0
    [Documentation]  Make sure you can get the card information using the driver id.

    Set Test Variable  ${DRID}  386616245
    ${cardInformation}  getCardByDriverId  ${DRID}

#   THOSE ARE THE FIELDS I COULDNT FIND ANYWHERE
    Remove From Dictionary  ${cardInformation}  overrideAllLocations
    Remove From Dictionary  ${cardInformation}  locationGroups

    ${WS_CardLmt}  Pop From Dictionary  ${cardInformation}  limits
    ${db_infos}  Check Card Lmt on DB
    ${same_dict}  Compare Dictionaries As Strings  ${db_infos[0]}  ${WS_CardLmt}
    Should Be True  ${same_dict}

    ${WS_CardInfo}  Pop From Dictionary  ${cardInformation}  infos
    ${db_infos}  Check Card Info on DB
    ${same_dict}  Compare Dictionaries As Strings  ${db_infos[0]}  ${WS_CardInfo}
    Should Be True  ${same_dict}

    Remove From Dictionary  ${cardInformation}  infos
    Remove From Dictionary  ${cardInformation}  limits

    ${DB_INFO}  Check Data On DB
    ${same_dict}  Compare List Dictionaries As Strings  ${DB_INFO}  ${cardInformation}
    Should Be True  ${same_dict}

Get Card Information With a Typo On a Driver ID
    [Tags]  JIRA:BOT-1572  qTest:30704975  Regression
    [Documentation]  Make sure you cannot get the card information with a typo driver id.

    ${status}  run keyword and return status  getCardByDriverId  123X
    Should Not Be True  ${status}

Get Card Information With Special Character On a Driver ID
    [Tags]  JIRA:BOT-1572  qTest:30704990  Regression
    [Documentation]  Make sure you cannot get the card information with special character on the driver id.

    ${status}  run keyword and return status  getCardByDriverId  123!@#
    Should Not Be True  ${status}

Get Card Information With an Empty Value On The Driver ID Field
    [Tags]  JIRA:BOT-1572  qTest:30704991  Regression  BOT-1977  refactor
    [Documentation]  Make sure you cannot get the card information with special character on the driver id.

    ${status}  run keyword and return status  getCardByDriverId  ${EMPTY}
    Should Not Be True  ${status}

Get Card Information With a Space on the Driver ID Value Field
    [Tags]  JIRA:BOT-1572  qTest:30705004  Regression
    [Documentation]  Make sure you cannot get the card information with special character on the driver id.

    ${status}  run keyword and return status  getCardByDriverId  ${SPACE}
    Should Not Be True  ${status}


*** Keywords ***

Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Check Data On DB
    ${query}    catenate
    ...    SELECT c.card_num AS cardNumber,
    ...       c.coxref AS companyXRef,
    ...       c.handenter AS handEnter,
    ...       c.infosrc AS infoSource,
    ...       c.lmtsrc AS limitSource,
    ...       c.loc_override AS locationOverride,
    ...       c.locsrc AS locationSource,
#    ...       -- COLUMN AS overrideAllLocations
    ...       c.payr_status AS payrollStatus,
    ...       c.cardoverride AS override,
    ...       c.icardpolicy AS policyNumber,
    ...       DECODE(c.status, 'A', 'ACTIVE', 'INACTIVE') AS status,
    ...       c.timesrc AS timeSource,
    ...       c.last_used AS lastUsedDate,
    ...       c.last_trans AS lastTransaction,
    ...       c.payr_use AS payrollUse,
    ...       DECODE(c.payr_atm, 'N', 'DISALLOW', 'ALLOW') AS payrollAtm,
    ...       DECODE(c.payr_chk, 'N', 'DISALLOW', 'ALLOW') AS payrollChk,
    ...       DECODE(c.payr_ach, 'N', 'DISALLOW', 'ALLOW') AS payrollAch,
    ...       DECODE(c.payr_wire, 'N', 'DISALLOW', 'ALLOW') AS payrollWire,
    ...       DECODE(c.payr_debit, 'N', 'DISALLOW', 'ALLOW') AS payrollDebit,
    ...       ci.info_id AS infoId,
    ...       ci.info_validation AS matchValue,
    ...       cl.hours AS hours,
    ...       cl.limit AS limit,
    ...       cl.limit_id AS limitId,
    ...       cl.minhours AS minHours,
#    ...       --loc groups
    ...       c_loc.location_id AS locations

    ...    FROM cards c,
    ...         card_inf ci,
    ...         card_lmt cl,
    ...         card_loc c_loc

    ...     WHERE c.card_num=ci.card_num
    ...     AND   c.card_num=cl.card_num
    ...     AND   c.card_num=c_loc.card_num
    ...     AND   ci.info_validation='V${DRID}'
    ...     AND   c.status='A'
    ...     AND   c.carrier_id=${validCard.carrier.id}
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}

Check Card Lmt on DB
    ${query}    catenate
    ...    SELECT DISTINCT cl.hours AS hours,
    ...       cl.limit AS limit,
    ...       cl.limit_id AS limitId,
    ...       cl.minhours AS minHours
    ...    FROM cards c,
    ...         card_inf ci,
    ...         card_lmt cl
    ...     WHERE c.card_num=cl.card_num
    ...     AND   ci.info_validation='V${DRID}'
    ...     AND   c.status='A'
    ...     AND   c.carrier_id=${validCard.carrier.id}
    ...     AND   c.card_num='7083050910386616245'
    ${results}  Query To Dictionaries  ${query}

    [Return]  ${results}


Check Card Info On DB

        ${query}    catenate

        ...    SELECT TRIM(info_id) as infoId,
        ...       CASE
        ...          WHEN info_validation MATCHES '*;TS*' THEN 'true'
        ...          ELSE TRIM('false')
        ...        END as lengthCheck,
        ...       CASE
        ...          WHEN SUBSTR(info_validation, 0,1) = 'V' THEN TRIM(SUBSTR(info_validation, 2))
        ...          ELSE TRIM('')
        ...         END AS matchValue,
        ...        CASE
        ...          WHEN info_validation MATCHES '*;X*' THEN SUBSTR(info_validation, CHARINDEX(';M',info_validation)+2, (CHARINDEX(';X',info_validation)-CHARINDEX(';M',info_validation)-2))
        ...          ELSE TRIM('0')
        ...       END AS minimum,
        ...        CASE
        ...          WHEN info_validation MATCHES '*;X*' THEN SUBSTR(info_validation, CHARINDEX(';X',info_validation)+2)
        ...          ELSE TRIM('0')
        ...        END AS maximum,
        ...        CASE
        ...          WHEN SUBSTR(info_validation, 0,1) = 'Z' THEN TRIM(SUBSTR(info_validation, 2))
        ...          ELSE NULL
        ...         END AS reportValue,
        ...        CASE
        ...          WHEN SUBSTR(info_validation, 0,1) = 'V' THEN TRIM('EXACT_MATCH')
        ...          WHEN SUBSTR(info_validation, 0,1) = 'N' THEN TRIM('NUMERIC')
        ...          WHEN SUBSTR(info_validation, 0,1) = 'Z' THEN TRIM('REPORT_ONLY')
        ...          WHEN SUBSTR(info_validation, 0,1) = 'B' THEN TRIM('ALPHANUMERIC')
        ...          ELSE NULL
        ...         END AS validationType,
        ...        CASE
        ...          WHEN SUBSTR(info_validation, 0,1) = 'N' AND info_validation NOT MATCHES '*M*' THEN DECODE(SUBSTR(info_validation, 2),'','0',SUBSTR(info_validation, 2))
        ...          ELSE TRIM('0')
        ...         END AS value
        ...      FROM card_inf
        ...      WHERE card_num ='7083050910386616245'
        ...      AND info_id = 'DRID';

    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}