*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
Check TYPO on the begDate
    [Tags]  JIRA:BOT-1567  qTest:30656359  Regression
    [Documentation]  Validate that you cannot pull up Money Code using a date with a TYPO in begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getMoneyCodes  2019-03-26F  2019-03-26
    Should Not Be True  ${status}
    [Teardown]  Logout

Check TYPO on the endDate
    [Tags]  JIRA:BOT-1567  qTest:30656705  Regression
    [Documentation]  Validate that you cannot pull up Money Code using a date with a TYPO in endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getMoneyCodes  2019-03-26  2019-03-26F
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on begDate
    [Tags]  JIRA:BOT-1567  qTest:30656899  Regression
    [Documentation]  Validate that you cannot pull up Money Code using an empty value on begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getMoneyCodes  ${EMPTY}  2019-03-26
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on endDate
    [Tags]  JIRA:BOT-1567  qTest:30656959  Regression
    [Documentation]  Validate that you cannot pull up Money Code using an empty value on endDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getMoneyCodes  2019-03-26  ${EMPTY}
    Should Not Be True  ${status}
    [Teardown]  Logout

Should not get Money Code if endDate was less than begDate
    [Tags]  JIRA:BOT-1567  qTest:30656996  Regression
    [Documentation]  Validate that you cannot pull up Money Codes using an endDate value less then begDate.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getMoneyCodes  2019-03-26  2019-03-25
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate Money Codes Informations
    [Tags]  JIRA:BOT-1567  qTest:30657010  Regression  refactor
    [Documentation]  Validate all informations returned from getMoneyCodes
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${moneycodes}  getMoneyCodes  2019-03-25  2019-03-25  01:00:00  02:00:00
    FOR  ${moneyID}  IN  @{moneycodes}
        tch logging  \nValidating ${moneyID['id']}:\n${moneyID}
        Check MoneyCode  ${moneyID}
    END
    [Teardown]  Logout

Check if qty returned matches with database
    [Tags]  JIRA:BOT-1567  BUGGED: The numbers doesn't matches cause web service was not filtering by time, only by date
    [Documentation]  Check if the quantity returned from database is the same as returned from webservice
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${begDate}  set variable  2019-03-25 01:00:00
    ${endDate}  set variable  2019-03-25 03:00:00

    ${totaldb}  get total values returned from database  ${begDate}  ${endDate}

    ${moneycodes}  getMoneyCodes  2019-03-25  2019-03-25  01:00:00  03:00:00
    ${totalws}  get length  ${moneycodes}

    Should Be Equal as Numbers  ${totaldb}  ${totalws}

*** Keywords ***
Check MoneyCode
    [Arguments]  ${moneycodes}
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
    ...  WHERE code_id = '${moneycodes['id']}';

    ${results}  Query And Strip To Dictionary  ${query}
    ${activeDate}  Replace String  ${moneycodes['activeDate']}  T  ${SPACE}
    ${activeDate}  Split String  ${activeDate}  .
    Should Be Equal As Strings  ${results["activated_time"]}  ${activeDate[0]}
    Should Be Equal As Numbers  ${results["original_amt"]}  ${moneycodes['amount']}
    Should Be Equal As Numbers  ${results["amt_used"]}  ${moneycodes['amountUsed']}
    Should Be Equal As Numbers  ${results["express_code"]}  ${moneycodes['code']}
    Should Be Equal As Numbers  ${results["contract_id"]}  ${moneycodes['contractId']}

    ${created}  Replace String  ${moneycodes['created']}  T  ${SPACE}
    ${created}  Split String  ${created}  .
    Should Be Equal As Strings  ${results["created"]}  ${created[0]}
    Should Be Equal As Strings  ${results["deduct_fees"]}  ${moneycodes['deductFees']}
    Should Be Equal As Numbers  ${results["fee_amount"]}  ${moneycodes['feeAmount']}
    Should Be Equal As Numbers  ${results["code_id"]}  ${moneycodes['id']}
    Should Be Equal As Strings  ${results["issued_to"]}  ${moneycodes['issuedTo']}
    Should Be Equal As Strings  ${results["status"]}  ${moneycodes['status']}
    Should Be Equal As Strings  ${results["voided"]}  ${moneycodes['voided']}
    Should Be Equal As Strings  ${results["who"]}  ${moneycodes['who']}


Get total values returned from database
    [Arguments]  ${begDate}  ${endDate}
    Get Into DB  tch
    ${query}  Catenate
    ...  SELECT code_id, created, who FROM mon_codes WHERE created >= TO_DATE('${begDate}', '%Y-%m-%d %H:%M:%S') AND created <= TO_DATE('${endDate}', '%Y-%m-%d %H:%M:%S') AND who ='${validCard.carrier.id}';

    ${results}  Query And Strip To Dictionary  ${query}

    ${totaldb}  get length  ${results['created']}

    [Return]  ${totaldb}