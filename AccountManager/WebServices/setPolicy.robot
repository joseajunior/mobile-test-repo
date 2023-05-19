*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.setup.PySetup

Force Tags  Web Services  tier:0
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Set Policy With Valid Info
    [Tags]  tier:0  JIRA:BOT-1588  qTest:31154622  Regression  refactor
    [Documentation]  Make sure you can set the policy info.

    Set Test Variable  ${policy}  ${validCard.policy.id}

    Start Setup Policy  ${validCard.carrier.id}  ${policy}

    Setup Policy Header  11175  PolicyTraining  true  0  true  true  true  true  true
    Setup Policy Prompts  DRID=V1234
    Setup Policy Limits  ADD=999
    Setup Policy Time Restrictions  0  2019-04-10  2019-04-30
    setPolicyLocationGroups  26  ${false}  1  2816

    ${WS_PolicyHeader}  getPolicyHeader  ${policy}
    ${WS_PolicyInfos}  getPolicyInfos  ${policy}
    ${WS_PolicyLimits}  getPolicyLimits  ${policy}
    ${WS_PolicyTimeRestrictions}  getPolicyTimeRestrictions  ${policy}
    ${WS_PolicyLocationGroups}  getPolicyLocationGroups  ${policy}
    Tch logging  a${WS_PolicyLocationGroups}


    Assert Policy Header   ${WS_PolicyHeader}
    Assert Policy Prompts  ${WS_PolicyInfos}
    Assert Policy Limits   ${WS_PolicyLimits}
    Assert Policy Location Groups  ${WS_PolicyLocationGroups}

Set Policy With Empty Parameters
    [Tags]  JIRA:BOT-1588  qTest:31154877  Regression
    [Documentation]  Make sure you can't set policy with empty values.

    ${error_message}  Run Keyword And Return Status  setPolicyInfos  26  ${EMPTY}  false  1234  0  0  EXACT_MATCH  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyInfos  26  DRID  ${EMPTY}  1234  0  0  EXACT_MATCH  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyInfos  26  DRID  false  ${EMPTY}  0  0  EXACT_MATCH  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyInfos  26  DRID  false  1234  ${EMPTY}  0  EXACT_MATCH  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyInfos  26  DRID  false  1234  0  ${EMPTY}  EXACT_MATCH  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyInfos  26  DRID  false  1234  0  0  EXACT_MATCH  ${EMPTY}
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyLimits  26  ${EMPTY}  9999  1  0  0  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyLimits  26  1  ${EMPTY}  1  F  0  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  0  ${EMPTY}  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  0  0  ${EMPTY}
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  ${EMPTY}  0  0
    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  Setup Policy Time Restrictions   0  ${EMPTY}  2019-04-30
    Should Not Be True  ${error_message}

#    ${error_message}  Run Keyword And Return Status  Setup Policy Time Restrictions  ${EMPTY}  2019-04-10  2019-04-30
#    Should Not Be True  ${error_message}

    ${error_message}  Run Keyword And Return Status  Setup Policy Time Restrictions  0  2019-04-10  ${EMPTY}
    Should Not Be True  ${error_message}

Set Policy With Invalid Parameters
    [Tags]  JIRA:BOT-1588  qTest:31154896  Regression
    [Documentation]  Make sure you can't set policy with invalid values.

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11!@175  PolicyTraining  true  0  true  true  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  tr!@ueFA  0  true  true  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  @A  true  true  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  0  true  !!@#  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  0  true  TRUE  !@#  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  0  true  TRUE  true  !@#  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR@!D  false  1234  0  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DRID  fa1!@#se  1234  0  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  123!@#4  0  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  @!#$  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  0  !@#  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  0  0  EXAC1!@#TCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  0  0  EXACT_MATCH  !@#
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1!@#$  9999  1  0  0  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1  99!@#  1  F  0  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  0  @#$  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  0  0  @
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  !  0  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  Setup Policy Time Restrictions  0  @#$!@%#  2019-04-30
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  Setup Policy Time Restrictions  !@#$  2019-04-10  2019-04-30
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  Setup Policy Time Restrictions  0  2019-04-10  !@#$
    Should Not Be True  ${status}

Set Policy With Typo on The Parameters
    [Tags]  JIRA:BOT-1588  qTest:31154910  Regression
    [Documentation]  Make sure you can't set policy with typo on the parameters.

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11A175  PolicyTraining  true  0  true  true  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  trueFA  0  true  true  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  BGA  true  true  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  0  true  FTRAS  true  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  0  true  TRUE  FTRAS  true  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyHeader  26  11175  PolicyTraining  true  0  true  TRUE  true  FTRAS  true
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  0  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DRID  fa123lse  1234  0  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  123a4  0  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  f  0  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  0  g  EXACT_MATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  0  0  EXAC12ATCH  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyInfos  26  DR1D  false  1234  0  0  EXACT_MATCH  a
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1DA  9999  1  0  0  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  F  0  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1  9999  1  0  F  0
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setPolicyLimits  26  1  999  1  0  0  ASD
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  Setup Policy Time Restrictions  0  2019A4-10  2019-04-30
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  Setup Policy Time Restrictions  A  2019-04-10  2019-04-30
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  Setup Policy Time Restrictions  0  2019-04-10  2019B-30
    Should Not Be True  ${status}

Set Policy Using Invalid Policy
    [Tags]  qTest:37426612  JIRA:FRNT-55

    ${ws_error}  Run Keyword And Expect Error  *  setPolicyHeader  9999  description=Testing It Broke
    should contain  ${ws_error}  Invalid policy number


*** Keywords ***
Setup WS
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
    Should Be Equal  ${ws_locations}  ${db_locations['location_id']}

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
    ${output}  Query And Strip To Dictionary  ${query}
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

Get Policy Location Groups From DB
    [Arguments]  ${policy}

    ${query}    catenate
    ...     SELECT TO_CHAR(grp_id) AS grp_id FROM def_loc_grp WHERE carrier_id=${validCard.carrier.id} and ipolicy=${policy}
    ${loc_grp}  Query And Strip To Dictionary  ${query}
    Tch Logging  ${loc_grp['grp_id']}
    [Return]  ${loc_grp['grp_id']}

Assert Policy Location Groups
    [Arguments]  ${ws_LocGrps}
    ${db_LocGrps}  Get Policy Location Groups From DB  ${policy}
    Lists Should Be Equal  ${ws_LocGrps}  ${db_LocGrps}
