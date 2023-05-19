*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Empty Policy Number
    [Documentation]
    [Tags]  JIRA:BOT-1563  Regression
    Set Test Variable  ${policy}  ${EMPTY}
    Run Keyword And Expect Error  *  getPolicy  ${policy}

Invalid Policy Number
    [Documentation]
    [Tags]  qtest:37192025  JIRA:BOT-1563  Regression  JIRA:FRNT-55

    ${status}  ${ws_error}  Run Keyword And Ignore Error  getPolicy  9999
    Should Be Equal As Strings    FAIL    ${status.upper()}
    should contain  ${ws_error}  Invalid policy number

Typo Policy Number
    [Documentation]
    [Tags]  JIRA:BOT-1563  Regression
    Set Test Variable  ${policy}  ${validCard.policy.num}f
    Run Keyword And Expect Error  *  getPolicy  ${policy}

Compare Policy Header With DB
    [Documentation]
    [Tags]  tier:0  JIRA:BOT-1563  Regression  refactor
    Set Test Variable  ${policy}  ${validCard.policy.num}
    ${policy_header}  getPolicyHeader  ${policy}
    Assert Policy Header  ${policy_header}

Compare Policy Limits With DB
    [Documentation]
    [Tags]  tier:0  JIRA:BOT-1563  Regression  refactor
    Set Test Variable  ${policy}  ${validCard.policy.num}
    ${policy_limits}  getPolicyLimits  ${policy}
    Assert Policy Limits  ${policy_limits}

Compare Policy Prompts With DB
    [Documentation]
    [Tags]  tier:0  JIRA:BOT-1563  Regression  JIRA:BOT-1994
    Set Test Variable  ${policy}  ${validCard.policy.num}
    ${policy_info}  getPolicyInfos  ${policy}
    Assert Policy Prompts  ${policy_info}

Compare Policy Locations With DB
    [Documentation]
    [Tags]  tier:0  JIRA:BOT-1563  Regression  JIRA:BOT-1994  refactor
    Set Test Variable  ${policy}  ${validCard.policy.num}
    ${policy_locations}  getPolicyLocations  ${policy}
    Assert Policy Locations  ${policy_locations}

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Assert Policy Header
    [Arguments]  ${ws_header}
    ${db_header}  Get Policy Header From DB  ${policy}
    ${db_ws_match}  Compare Dictionaries As Strings  ${ws_header[0]}  ${db_header[0]}
    Should Be True  ${db_ws_match}

Assert Policy Limits
    [Arguments]  ${ws_limits}
    ${db_limits}  Get Policy Limits From DB  ${policy}
    ${db_ws_match}  Compare List Dictionaries As Strings  ${ws_limits}  ${db_limits}
    Should Be True  ${db_ws_match}

Assert Policy Prompts
    [Arguments]  ${ws_prompts}
    ${db_prompts}  Get Policy Prompts From DB  ${policy}
    ${db_ws_match}  Compare List Dictionaries As Strings  ${ws_prompts}  ${db_prompts}
    Should Be True  ${db_ws_match}

Assert Policy Locations
    [Arguments]  ${ws_locations}
    ${db_locations}  Get Policy Locations From DB  ${policy}
    Should Be Equal  ${ws_locations}  ${db_locations}

Get Policy Prompts From DB
    [Arguments]  ${policy}
    ${query}  Catenate
    ...  select TRIM(info_id) as infoId,
    ...    CASE
    ...      WHEN info_validation MATCHES '*;TS*' THEN 'true'
    ...      ELSE TRIM('false')
    ...    END as lengthCheck,
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
    ...      WHEN SUBSTR (info_validation,0,1) = 'P' THEN TRIM('INFO_POOL')
    ...      ELSE NULL
    ...     END AS validationType,
    ...     CASE
    ...      WHEN SUBSTR(info_validation, 0,1) = 'N' AND info_validation NOT MATCHES '*M*' THEN DECODE(SUBSTR(info_validation, 2),'','0',SUBSTR(info_validation, 2))
    ...      ELSE TRIM('0')
    ...     END AS value
    ...  FROM def_info
    ...  WHERE carrier_id = ${validCard.carrier.id}
    ...  AND ipolicy = ${policy}
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}

Get Policy Limits From DB
    [Arguments]  ${policy}
    ${query}  Catenate
    ...  select TRIM(limit_id) as limitId,
    ...         TO_CHAR(limit) AS limit,
    ...         TO_CHAR(hours) AS hours,
    ...         TO_CHAR(minhours) as minhours,
    ...         TO_CHAR(day_of_week) as autoRollMap,
    ...         TO_CHAR(daily_max) as autoRollMax
    ...  from def_lmts where carrier_id = ${validCard.carrier.id}
    ...  and ipolicy = ${policy}
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}

Get Policy Locations From DB
    [Arguments]  ${policy}
    ${query}  Catenate
    ...  select TO_CHAR(location_id) AS location_id From def_locs where carrier_id = ${validCard.carrier.id} and ipolicy = ${policy}
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}

Get Policy Header From DB
    [Arguments]  ${policy}
    ${query}  Catenate
    ...  SELECT TRIM(TO_CHAR(contract_id)) as contractId,
    ...         TRIM(description) AS description,
    ...         TRIM(DECODE(handenter,'Y','true','false')) AS handEnter,
    ...         DECODE(payr_contract_id, null, TRIM('0'), TRIM(TO_CHAR(payr_contract_id))) AS payrollContractId,
    ...         TRIM(DECODE(payr_atm, 'N', 'false', 'true')) AS payrollAtm,
    ...         TRIM(DECODE(payr_chk, 'N', 'false', 'true')) AS payrollChk,
    ...         TRIM(DECODE(payr_ach, 'N', 'false', 'true')) AS payrollAch,
    ...         TRIM(DECODE(payr_wire, 'N', 'false', 'true')) AS payrollWire,
    ...         TRIM(DECODE(payr_debit, 'N', 'false', 'true')) AS payrollDebit
    ...  FROM def_card
    ...  WHERE id = ${validCard.carrier.id}
    ...  AND ipolicy = ${policy}
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}