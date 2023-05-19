*** Settings ***
Resource  ../../Variables/validUser.robot
#Library  otr_robot_lib.support.PyString
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
Check TYPO on the alphaCode
    [Tags]  JIRA:BOT-1564  qTest:30617951  Regression
    [Documentation]  Validate that you cannot pull up Money Code using a alphaCode with a TYPO.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${alphacode}  set variable  575857770
    ${status}  Run Keyword And Return Status  getMoneyCode  ${alphacode}F
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on alphaCode
    [Tags]  JIRA:BOT-1564  qTest:30618067  Regression
    [Documentation]  Validate that you cannot pull up Money Code using an empty alphaCode value.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getMoneyCode  ${EMPTY}
    Should Not Be True  ${status}
    [Teardown]  Logout

Should Not Get Money Code using alphaCode From Different Carrier
    [Tags]  JIRA:BOT-1564  qTest:30618465  Regression
    [Documentation]  Validate that you cannot pull up Money Code using a alphaCode that doesn't belong to the carrier.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${alphacode}  set variable  106357081
    ${status}  Run Keyword And Return Status  getMoneyCode  ${alphacode}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate Money Code Informations
    [Tags]  JIRA:BOT-1564  qTest:30618267  Regression  refactor
    [Documentation]  Validate Limits from contract.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${alphacode}  set variable  575857770
    ${moneycodeDetails}  getMoneyCode  ${alphacode}
    Check MoneyCode  ${alphacode}  ${moneycodeDetails}
    [Teardown]  Logout


*** Keywords ***
Check MoneyCode
    [Arguments]  ${code_id}  ${moneycodeDetails}
    Get Into DB  tch
    ${query}  Catenate
    ...  SELECT activated_time,
    ...         original_amt,
    ...         amt_used,
    ...         express_code,
    ...         contract_id,
    ...         created,
    ...         TRIM(DECODE (deduct_fees,'N','false','true')) AS deduct_fees,
    ...         fee_amount,
    ...         code_id,
    ...         issued_to,
    ...         DECODE (num_uses,null,0,num_uses) AS num_uses,
    ...         TRIM(DECODE (status,'A','ACTIVE','INACTIVE')) AS status,
    ...         TRIM(DECODE (voided, 'N','false','true')) AS voided,
    ...         who
    ...  FROM mon_codes
    ...  WHERE code_id = '${code_id}';

    ${results}  Query And Strip To Dictionary  ${query}

    ${activeDate}  Replace String  ${moneycodeDetails['activeDate']}  T  ${SPACE}
    ${activeDate}  Split String  ${activeDate}  .
    Should Be Equal As Strings  ${results["activated_time"]}  ${activeDate[0]}
    Should Be Equal As Numbers  ${results["original_amt"]}  ${moneycodeDetails['amount']}
    Should Be Equal As Numbers  ${results["amt_used"]}  ${moneycodeDetails['amountUsed']}
    Should Be Equal As Numbers  ${results["express_code"]}  ${moneycodeDetails['code']}
    Should Be Equal As Numbers  ${results["contract_id"]}  ${moneycodeDetails['contractId']}

    ${created}  Replace String  ${moneycodeDetails['created']}  T  ${SPACE}
    ${created}  Split String  ${created}  .
    Should Be Equal As Strings  ${results["created"]}  ${created[0]}
    Should Be Equal As Strings  ${results["deduct_fees"]}  ${moneycodeDetails['deductFees']}
    Should Be Equal As Numbers  ${results["fee_amount"]}  ${moneycodeDetails['feeAmount']}
    Should Be Equal As Numbers  ${results["code_id"]}  ${moneycodeDetails['id']}
    Should Be Equal As Strings  ${results["issued_to"]}  ${moneycodeDetails['issuedTo']}
    Should Be Equal As Numbers  ${results["num_uses"]}  ${moneycodeDetails['numUses']}
    Should Be Equal As Strings  ${results["status"]}  ${moneycodeDetails['status']}
    Should Be Equal As Strings  ${results["voided"]}  ${moneycodeDetails['voided']}
    Should Be Equal As Strings  ${results["who"]}  ${moneycodeDetails['who']}