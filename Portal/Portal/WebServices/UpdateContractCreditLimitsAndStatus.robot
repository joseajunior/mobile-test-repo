*** Settings ***
Documentation
...  This tests the new feature of Credit Monitoring API
...  This test if is possible to Adjust Total Credit Limit for an account,
...  Adjust Money Code for an account, Adjust Cash Limit for an account
...  and Suspend Accounts. Also checks the webservice responses for invalid inputs.

Library  String
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ws.PortalWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/PortalKeywords.robot

Suite Setup  Set Beginning Values
Suite Teardown  Return Prior Values
Force Tags  Portal  Credit Manager  Web Services

*** Variables ***

${carrier}
${contractNumber}
${CUST_ACCT_PROFILE_AMT_ID}
${status}  active
${creditLimit}  50000
${dailyCadvLimit}  60000
${dailyCodeLimit}  70000
${commentText}  Set Variable Credit Limit Updated by Credit Monitoring Webservice

*** Test Cases ***
Check Invalid on the arNumber
    [Tags]  JIRA:PORT-10  qTest:37225613
    [Documentation]  Validate that you cannot Update Contract Credit Limits and Status with an invalid arNumber

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  arnumber=1111111111111
    Send Post Request to Webservice Expecting Fail  ${body}

Check Invalid on the Status
    [Tags]  JIRA:PORT-10  qTest:37227645
    [Documentation]  Validate that you cannot Update Contract Credit Limits and Status with an invalid Status

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  status=suspended
    Send Post Request to Webservice Expecting Fail  ${body}

Request Updating Status With ACTIVE
    [Tags]  JIRA:PORT-10  qTest:37227849
    [Documentation]  Validate that you can Update Status to ACTIVE

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    set test variable  ${carrierData}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  status=active
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Request Updating Status With INACTIVE
    [Tags]  JIRA:PORT-10  qTest:37227949
    [Documentation]  Validate that you can Update Status to INACTIVE

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  status=inactive
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Request Updating Status With CLOSED
    [Tags]  JIRA:PORT-10  qTest:37227951
    [Documentation]  Validate that you can Update Status to CLOSED

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  status=closed
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Request Updating Status With HOLD
    [Tags]  JIRA:PORT-10  qTest:37227953
    [Documentation]  Validate that you can Update Status to HOLD

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  status=hold
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Request Updating creditLimit
    [Tags]  JIRA:PORT-10  qTest:36858956
    [Documentation]  Validate that you can Update creditLimit

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  creditLimit=5000
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Request Updating dailyCadvLimit
    [Tags]  JIRA:PORT-10  qTest:36859473
    [Documentation]  Validate that you can Update dailyCadvLimit

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  dailyCadvLimit=6000
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Request Updating dailyCodeLimit
    [Tags]  JIRA:PORT-10  qTest:36859946
    [Documentation]  Validate that you can Update dailyCodeLimit

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  dailyCodeLimit=7000
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Request Updating commentText
    [Tags]  JIRA:PORT-10  qTest:37252377
    [Documentation]  Validate that you can Update commentText

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  commentText=Updating commentText
    Send Post Request to Webservice  ${body}
    Assert Database Record with Webservice Request  ${carrierData}  ${body}

    [Teardown]  Restore Original Data  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrier}

Check EMPTY on the arNumber
    [Tags]  JIRA:PORT-10
    [Documentation]  Validate that you cannot Update Contract Credit Limits and Status with an EMPTY arNumber

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  arnumber=${EMPTY}
    Send Post Request to Webservice Expecting Fail  ${body}

Check EMPTY on all fields
    [Tags]  JIRA:PORT-10  qTest:37252475
    [Documentation]  Validate that you cannot Update Contract Credit Limits and Status with an EMPTY arNumber

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  status=${EMPTY}
    Set To Dictionary  ${body}  creditlimit=${EMPTY}
    Set To Dictionary  ${body}  dailycadvlimit=${EMPTY}
    Set To Dictionary  ${body}  dailycodelimit=${EMPTY}
    Send Post Request to Webservice Expecting Fail  ${body}

Check TYPO on the Status
    [Tags]  JIRA:PORT-10  qTest:37253489
    [Documentation]   Make sure you cannot Update Contract Status with Typo values

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  status=activef
    Send Post Request to Webservice Expecting Fail  ${body}

Check TYPO on the dailycadvlimit
    [Tags]  JIRA:PORT-10  qtest:37253498
    [Documentation]   Make sure you cannot Update Contract dailycadvlimit with Typo values

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  dailycadvlimit=2000f
    Send Post Request to Webservice Expecting Fail  ${body}

Check TYPO on the creditLimit
    [Tags]  JIRA:PORT-10  qTest:37253499
    [Documentation]   Make sure you cannot Update Contract creditLimit with Typo values

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  creditlimit=2000f
    Send Post Request to Webservice Expecting Fail  ${body}

Check TYPO on the dailycodelimit
    [Tags]  JIRA:PORT-10  qTest:37253546
    [Documentation]   Make sure you cannot Update Contract dailycodelimit with Typo values

    ${carrierData}  Get Database Data  ${carrier}  ${CUST_ACCT_PROFILE_AMT_ID}
    ${body}  Build Request Body  ${carrierData}
    Set To Dictionary  ${body}  dailycodelimit=2000f
    Send Post Request to Webservice Expecting Fail  ${body}

Max allowed using Batch Request
    [Tags]  JIRA:PORT-10  qTest:
    [Documentation]  Validate that you can send a batch request and get an error when using more items than allowed

    ${originalBatchUpdateMax}  Get Batch Update Max
    Change Batch Update Max to  3
    ${body}  Build Batch Request Body
    ${status}  ${message}  Send Post Batch Request to Webservice  ${body}
    Should Not Be True  ${status}
    Should Contain  ${message}  Max allowed in batch is 3

    [Teardown]  Restore Original Update Max  ${originalBatchUpdateMax}

Batch Request with Unauthorized User
    [Tags]  JIRA:PORT-10  qTest:37264039
    [Documentation]  Validate that you cannot send a batch request with an Unauthorized User
    ${login}  set variable  111reggaerockblues111@efsllc
    ${password}  set variable  111111111
    log into credit monitoring service  ${login}  ${password}
    ${body}  Build Batch Request Body
    Send Post Batch Request to Webservice Expecting Fail  ${body}

*** Keywords ***
Set Beginning Values
    ${carrier}  Find Carrier in Oracle  A
    set suite variable  ${carrier}

    Get Into DB  MYSQL
    ${query}  catenate
    ...  UPDATE jpportal.setting
    ...  SET value = 0
    ...  WHERE category = 'ws.credmon'
    ...  AND   name = 'limits.change.restricted.timeframe';
    Execute Sql String  dml=${query}
    Disconnect From Database

Return Prior Values

    Get Into DB  MYSQL
    ${query}  catenate
    ...  UPDATE jpportal.setting
    ...  SET value = 24
    ...  WHERE category = 'ws.credmon'
    ...  AND   name = 'limits.change.restricted.timeframe';
    Execute Sql String  dml=${query}
    Disconnect From Database


Get Comment on Database
    [Arguments]  ${contractNumber}  ${comment}  ${portalUser}
    Get Into DB  TCH

    ${query}  Catenate
    ...  SELECT comment
    ...  FROM contract_comment
    ...  WHERE created_by = '${portalUser}'
    ...  AND   contract_id = ${contractNumber}
    ...  AND   comment = '${comment}'

    ${result}  Query and Strip  ${query}

    [Return]  ${result}

Get Database Data
    [Arguments]  ${carrierId}  ${CUST_ACCT_PROFILE_AMT_ID}

    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT c.status AS Status,
    ...  cm.orig_limit AS CLimit,
    ...  c.daily_cadv_limit AS DailyCashLimit,
    ...  c.daily_code_limit AS DailyMCLimit,
    ...  TRIM(c.ar_number) AS ARnumber,
    ...  c.carrier_id,
    ...  c.contract_id
    ...  FROM contract c,
    ...  cont_misc cm
    ...  WHERE c.contract_id = cm.contract_id
    ...  AND   carrier_id = ${carrierId}
    ...  LIMIT 1
    ${result}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    ${CUST_ACCT_PROFILE_AMT_ID}  Get CUST_ACCT_PROFILE_AMT_ID  ${result['arnumber']}
    set test variable  ${CUST_ACCT_PROFILE_AMT_ID}

    Get Into DB  ORACLE
    ${query}  Catenate  select hcpa.overall_credit_limit
      ...  from hz_cust_site_uses_all hcsua, HZ_CUST_PROFILE_AMTS hcpa
      ...  where hcsua.location = '${result['arnumber']}'
      ...  and hcpa.overall_credit_limit is not null
      ...  and hcsua.site_use_id = hcpa.site_use_id
      ...  and hcpa.CURRENCY_CODE = 'USD'
#    ${query}  Catenate  SELECT OVERALL_CREDIT_LIMIT FROM HZ_CUST_PROFILE_AMTS WHERE CUST_ACCT_PROFILE_AMT_ID = ${CUST_ACCT_PROFILE_AMT_ID}
    ${databaseCreditLimit}  Query And Strip  ${query}
    Set To Dictionary  ${result}  creditlimit=${databaseCreditLimit}
    Disconnect From Database

    [Return]  ${result}

Restore Original Data
   [Arguments]  ${carrierData}  ${CUST_ACCT_PROFILE_AMT_ID}  ${carrierId}

    Get Into DB  TCH
    Execute SQL String  dml=UPDATE contract SET status='${carrierData['status']}' WHERE contract_id=${carrierData['contract_id']} AND carrier_id=${carrierId};commit;
    Execute SQL String  dml=UPDATE contract SET daily_cadv_limit='${carrierData['dailycashlimit']}' WHERE contract_id=${carrierData['contract_id']} AND carrier_id=${carrierId};commit;
    Execute SQL String  dml=UPDATE contract SET daily_code_limit='${carrierData['dailymclimit']}' WHERE contract_id=${carrierData['contract_id']} AND carrier_id=${carrierId};commit;
    Execute SQL String  dml=UPDATE cont_misc SET orig_limit='${carrierData['climit']}' WHERE contract_id=${carrierData['contract_id']};commit;

    ${query}  Catenate  SELECT contract_comment_id
    ...  FROM contract_comment
    ...  WHERE created_by = '${portalWSUser}'
    ...  AND   contract_id = ${carrierData['contract_id']}
    ...  AND   COMMENT = '${uniqueCommentText}';
    ${commentId}  Query And Strip  ${query}

    Execute SQL String  dml=DELETE FROM contract_comment WHERE contract_comment_id='${commentId}';
    Disconnect From Database

    Get Into DB  ORACLE
    Execute SQL String  dml=UPDATE HZ_CUST_PROFILE_AMTS SET OVERALL_CREDIT_LIMIT = '${carrierData['creditlimit']}' WHERE CUST_ACCT_PROFILE_AMT_ID = ${CUST_ACCT_PROFILE_AMT_ID}
    Disconnect From Database

Build Request Body
    [Arguments]  ${carrierData}

    ${arNumber}  set variable  ${carrierData['arnumber']}

    ${randomString}  Generate Random String  7  [LETTERS]
    ${uniqueCommentText}  catenate  ${commentText} ${randomString}
    Set Test Variable  ${uniqueCommentText}

    ${body}  Create Dictionary
    ...  arnumber=${arNumber}
    ...  status=${status}
    ...  creditlimit=${creditLimit}
    ...  dailycadvlimit=${dailyCadvLimit}
    ...  dailycodelimit=${dailyCodeLimit}
    ...  commenttext=${uniqueCommentText}
    [Return]  ${body}

Send Post Request to Webservice
    [Arguments]  ${body}

    ${status}  ${message}  ${data}  UpdateContractCreditLimitsAndStatus  ${body['arnumber']}  ${body['status']}  ${body['creditlimit']}  ${body['dailycadvlimit']}  ${body['dailycodelimit']}   ${body['commenttext']}
    Should Be True  ${status}

Send Post Request to Webservice Expecting Fail
    [Arguments]  ${body}

    ${status}  run keyword and expect error  *  UpdateContractCreditLimitsAndStatus  ${body['arnumber']}  ${body['status']}  ${body['creditlimit']}  ${body['dailycadvlimit']}  ${body['dailycodelimit']}   ${body['commenttext']}

Assert Database Record with Webservice Request
    [Arguments]  ${carrierData}  ${body}

    ${dbComment}  Get Comment on Database  ${carrierData['contract_id']}  ${uniqueCommentText}  ${portalWSUser}
    Should be equal  ${dbComment}  ${uniqueCommentText}

    ${newCarrierDataAfterRequest}  Get Database Data  ${carrierData['carrier_id']}  ${CUST_ACCT_PROFILE_AMT_ID}

    should be equal as integers  ${newCarrierDataAfterRequest['dailycashlimit']}  ${body['dailycadvlimit']}
    should be equal as integers  ${newCarrierDataAfterRequest['dailymclimit']}  ${body['dailycodelimit']}
    should be equal as integers  ${newCarrierDataAfterRequest['creditlimit']}  ${body['creditlimit']}
    ${card_status}  set variable  active
    ${card_status}  Set Variable If  '${newCarrierDataAfterRequest['status']}'=='A'  active  ${card_status}
    ${card_status}  Set Variable If  '${newCarrierDataAfterRequest['status']}'=='I'  inactive  ${card_status}
    ${card_status}  Set Variable If  '${newCarrierDataAfterRequest['status']}'=='C'  closed  ${card_status}
    ${card_status}  Set Variable If  '${newCarrierDataAfterRequest['status']}'=='H'  hold  ${card_status}
    Should Be Equal As Strings  ${card_status}  ${body['status']}

Send Post Batch Request to Webservice
    [Arguments]  ${body}
    ${status}  ${message}  UpdateContractCreditLimitsAndStatusBatch  ${body}
    [Return]  ${status}  ${message}

Build Batch Request Body

    ${item1}  Create Dictionary
    ...  arnumber=1111111111
    ...  status=active
    ...  creditlimit=1000
    ...  dailycadvlimit=1000
    ...  dailycodelimit=1000
    ${item2}  Create Dictionary
    ...  arnumber=22222222222
    ...  status=${status}
    ${item3}  Create Dictionary
    ...  arnumber=3333333333333
    ...  status=active
    ...  dailycodelimit=1000
    ${item4}  Create Dictionary
    ...  arnumber=44444444444444
    ...  status=active
    ...  creditlimit=1000
    ...  dailycadvlimit=1000
    ${item5}  Create Dictionary
    ...  arnumber=5555555555555
    ...  creditlimit=1000
    ${body}  create list
    append to list  ${body}  ${item1}
    append to list  ${body}  ${item2}
    append to list  ${body}  ${item3}
    append to list  ${body}  ${item4}
    append to list  ${body}  ${item5}

    [Return]  ${body}

Restore Original Update Max
    [Arguments]  ${originalBatchUpdateMax}
    Get Into DB  MYSQL
    ${query}  catenate
    ...  UPDATE jpportal.setting
    ...  SET value = '${originalBatchUpdateMax}'
    ...  WHERE category = 'ws.credmon'
    ...  AND   name = 'batch.update.max';
    Execute Sql String  dml=${query}
    Disconnect From Database

Get Batch Update Max
    Get Into DB  MYSQL
    ${query}  catenate
    ...  SELECT value FROM jpportal.setting
    ...  WHERE category = 'ws.credmon'
    ...  AND name = 'batch.update.max';
    ${originalBatchUpdateMax}  query and strip  ${query}
    Disconnect From Database
    [Return]  ${originalBatchUpdateMax}

Change Batch Update Max to
    [Arguments]  ${batchUpdateMax}
    Get Into DB  MYSQL
    ${query}  catenate
    ...  UPDATE jpportal.setting
    ...  SET value = '${batchUpdateMax}'
    ...  WHERE category = 'ws.credmon'
    ...  AND   name = 'batch.update.max';
    Execute Sql String  dml=${query}
    Disconnect From Database

Send Post Batch Request to Webservice Expecting Fail
    [Arguments]  ${body}

    ${status}  run keyword and expect error  *  UpdateContractCreditLimitsAndStatusBatch  ${body}

Get CUST_ACCT_PROFILE_AMT_ID
    [Arguments]  ${ar_number}
    ${oraclesql}  catenate  select site_use_id
    ...  from hz_cust_site_uses_all
    ...  where location = '${ar_number.strip()}'
    get into db  Oracle
    ${siteid}  query and strip  ${oraclesql}
    ${oraclesql}  catenate  select CUST_ACCT_PROFILE_AMT_ID
    ...  from hz_cust_profile_amts
    ...  where site_use_id = '${siteid}'
    get into db  Oracle
    ${CUST_ACCT_PROFILE_AMT_ID}  query and strip  ${oraclesql}
    Disconnect From Database
    [return]  ${CUST_ACCT_PROFILE_AMT_ID}





