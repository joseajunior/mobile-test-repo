*** Settings ***
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections

Force Tags  Web Services

*** Test Cases ***
Check TYPO on the Contract ID
    [Tags]  JIRA:BOT-1767  qTest:30498322  Regression
    [Documentation]  Validate that you cannot pull up credit limits using a contract ID with a TYPO.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getCreditLimits  ${contract}F
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on Contract ID
    [Tags]  JIRA:BOT-1767  qTest:30498323  Regression
    [Documentation]  Validate that you cannot pull up credit limits using an empty contract value.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getCreditLimits  ${EMPTY}
    Should Not Be True  ${status}
    [Teardown]  Logout

Should Not Get Limits On Contract Id From Different Carrier
    [Tags]  JIRA:BOT-1767  qTest:30498554  Regression
    [Documentation]  Validate that you cannot pull up credit limits using a contract ID that doesn't belong to the carrier.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getCreditLimits  ${PNC_contract}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate Contract Limits
    [Tags]  JIRA:BOT-1767  qTest:30498324  Regression  refactor
    [Documentation]  Validate Limits from contract.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${limits}  getCreditLimits  ${contract}
    Check Contracts  ${contract}  ${limits}
    [Teardown]  Logout

Validate All Contracts From Carrier
    [Tags]  JIRA:BOT-1767  qTest:30498325  Regression  refactor
    [Documentation]  Validate Limits from all contract.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${contracts}  getContracts
    ${contracts_size}  get length  ${contracts}
    FOR  ${index}  IN RANGE   0  ${contracts_size}
        ${contract}  Get From List  ${contracts}  ${index}
        ${limits}  getCreditLimits  ${contract['contractId']}
        Check Contracts  ${contract['contractId']}  ${limits}
    END
    [Teardown]  Logout

*** Keywords ***
Check Contracts
    [Arguments]  ${contractId}  ${limits}
    Get Into DB  tch
    ${query}  Catenate
    ...  SELECT TRIM(DECODE(status, 'A','ACTIVE','INACTIVE')) AS status,
    ...             trans_limit,
    ...             cm.orig_limit,
    ...             credit_limit,
    ...             credit_limit - credit_bal AS credit_available,
    ...             daily_limit,
    ...             daily_limit - daily_bal AS daily_available,
    ...             CASE
    ...                 WHEN credit_limit - credit_bal < daily_limit - daily_bal THEN credit_limit - credit_bal
    ...                 ELSE daily_limit - daily_bal
    ...             END AS total_available,
    ...             max_money_code,
    ...             currency
    ...  FROM contract c LEFT JOIN cont_misc cm ON cm.contract_id = c.contract_id
    ...  WHERE c.contract_id = ${contractId}

    ${results}  Query And Strip To Dictionary  ${query}

    Should Be Equal As Strings  ${results["status"]}  ${limits['contractStatus']}
    Should Be Equal As Numbers  ${results["trans_limit"]}  ${limits['transLimit']}
    Should Be Equal As Numbers  ${results["orig_limit"]}  ${limits['origLimit']}
    Should Be Equal As Numbers  ${results["credit_available"]}  ${limits['creditAvailable']}
    Should Be Equal As Numbers  ${results["daily_limit"]}  ${limits['dailyLimit']}
    Should Be Equal As Numbers  ${results["daily_available"]}  ${limits['dailyAvailable']}
    Should Be Equal As Numbers  ${results["total_available"]}  ${limits['totalAvailable']}
    Should Be Equal As Numbers  ${results["max_money_code"]}  ${limits['maxMoneyCode']}
    Should Be Equal As Strings  ${results["currency"]}  ${limits['uom']}