*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Assert WS Return With DB
    [Documentation]
    [Tags]  JIRA:BOT-1565  refactor
    [Setup]  Activate Contracts
    Search Contracts In DB
    Search Contracts In WS
    Format WS Return
    Compare DB and WS return
    [Teardown]  Restore Contract Status  ${db_contracts}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Search Contracts In DB
    ${db_contracts}  Get Contract Info From DB
    Set Test Variable  ${db_contracts}

Activate Contracts
    ${query}  Catenate
    ...  SELECT TRIM(TO_CHAR(contract_id)) as contractid
    ...  FROM contract
    ...  WHERE carrier_id = ${validCard.carrier.id}
    ${output}  Query To Dictionaries  ${query}

    ${query}  catenate  dml=UPDATE contract SET status = 'A' WHERE contract_id =
    FOR  ${contract}  IN  @{output}
      ${current_query}  Catenate  ${query} ${contract['contractid']}
      Execute SQL String  ${current_query}
    END

Search Contracts In WS
    ${ws_contracts}  getContracts
    Set Test Variable  ${ws_contracts}

Format WS Return
    Format List of Dictionaries  ${ws_contracts}

Compare DB and WS return
    ${db_qual_ws}  Compare List Dictionaries As Strings  ${ws_contracts}  ${db_contracts}
    Should Be True  ${db_qual_ws}

Format List of Dictionaries
    [Arguments]  ${ws_contracts}
    FOR  ${contract}  IN  @{ws_contracts}
      Remove From Dictionary  ${contract}  limitMethod
      ${check}  Evaluate  round(${contract['checkFee']}, 1)
      Set To Dictionary  ${contract}  checkFee=${check}
    END

Get Contract Info From DB
    ${query}  Catenate
    ...  SELECT TRIM(TO_CHAR(contract_id)) as contractid,
    ...         TO_CHAR(check_fee, '&.&') AS checkfee,
    ...         country,
    ...         status,
    ...         currency,
    ...         description,
    ...         TRIM(TO_CHAR(issuer_id)) as issuerid,
#    ...         limit_method as limitmethod,
    ...         decode(master_contract_id, null, 'false','true') as masterContract,
    ...         TRIM(decode(status, 'A', 'ACTIVE','I','INACTIVE',status)) as status
    ...  FROM contract
    ...  WHERE carrier_id = ${validCard.carrier.id}
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output}

Restore Contract Status
    [Arguments]  ${db_contracts}
    FOR  ${contract}  IN  @{db_contracts}
      ${query}  catenate  dml=UPDATE contract SET status = '${contract['status']}' WHERE contract_id = ${contract['contractid']}
      Execute SQL String  ${query}
    END
