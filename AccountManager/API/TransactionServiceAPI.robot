*** Settings ***
Library             String
Library             DateTime
Library             otr_robot_lib.ws.RestAPI.RestAPIService
Library             otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library             otr_model_lib.services.GenericService
Resource            otr_robot_lib/robot/APIKeywords.robot

Suite Setup         Setup Automation User
Suite Teardown      Automation User Teardown


*** Test Cases ***
Repush Transaction - Success
    [Documentation]    Find a transaction the in transaction table and send it to the
    ...    repush transactions endpoint at /transaction-push/repush
    [Tags]    jira:rocket-390    qtest:119224146    api:y    q1:2023
    Find A Transaction
    Repush Transaction

Enroll a Carrier - Success
    [Documentation]    Send a request to the /carrier-enrollment/enroll endpoint to enroll
    ...    a carrier to a family. Validate the database if it has been created in tcs/trans postgres
    [Tags]    jira:rocket-264    jira:rocket-328    jira:rocket-406    qtest:119224215    api:y    q1:2023
    Call Enrollment Endpoint
    Validate TCS Postgres
    Validate Password Encryption
    Remove TCS Postgres


*** Keywords ***
Setup Automation User
    [Documentation]    Set up log directory and initialize Suite Variables
    ...    Create automation user to be used during the test
    ${todayDashed}    getDateTimeNow    %Y-%m-%d
    set suite variable    ${todayDashed}
    Create My User    integration_support_specialist    OTR_eMgr    ${NONE}    N
    Get url for suite    ${transactionservices}

Automation User Teardown
    [Documentation]    Delete the automation user created
    Remove Automation User

Find a transaction
    [Documentation]    Search for the latest transaction that ran in TCH and grab the information needed for the repush
    ...    endpoint
    ...    select first 1 trans_id, TO_CHAR(trans_date,    '%Y-%m-%d %H:%M:%S'), carrier_id, invoice,auth_code
    ...    from transaction order by trans_date desc
    [Tags]    qtest
    Get Into Db    TCH
    ${sql}    Catenate
    ...    select first 1 trans_id, TO_CHAR(trans_date,
    ...    '%Y-%m-%d %H:%M:%S') as trans_date, carrier_id,
    ...    invoice,auth_code from transaction order by trans_id desc
    ${transaction}    Query And Strip To Dictionary    ${sql}
    ${json_request}    Create List    ${transaction}
    Set Test Variable    ${json_request}

Repush Transaction
    [Documentation]    Call the transaction service /transaction-push/repush endpoint passing the list of dictionaries
    ...    with the trans_id, trans_date, carrier_id, invoice and auth_code. Validate if the response is 200
    ...    Example request:
    ...    [
    ...    {
    ...    "trans_id": 763419080,
    ...    "trans_date": "2023-02-09 08:54:00",
    ...    "carrier_id": 731763,
    ...    "invoice": "6739744",
    ...    "auth_code": "926384"
    ...    }
    ...    ]
    [Tags]    qtest
    ${headers}    Create Dictionary    content-type=application/json
    ${results}    ${status}    Api Request
    ...    POST
    ...    transaction-push/repush
    ...    Y
    ...    ${NONE}
    ...    ${NONE}
    ...    OTR_eMgr
    ...    ${headers}
    ...    payload=${json_request}
    Should Be Equal As Numbers    ${status}    200
    Should Be Equal As Strings    ${results[0]['message']}    Successfully sent transaction to the queue.

Call Enrollment Endpoint
    [Documentation]    Call the transaction service carrier-enrollment/enroll/ endpoint passing the carrier information
    ...    and the information needed to add it to a carrier family along with the customer's endpoint data
    ...    Sample request:
    ...    {
    ...    "carrierId": "12345",
    ...    "carrierName": "Sample Carrier",
    ...    "family": "testFamily2",
    ...    "tokenRequestURL": "ReqURL",
    ...    "postRequestURL": "postReqURL",
    ...    "username": "testUsr",
    ...    "password": "testPass",
    ...    "scope": "testScope",
    ...    "grantType": "testGrantType",
    ...    "isParent": "true",
    ...    "headers": [
    ...    {
    ...    "name": "headerName",
    ...    "value": "headerValue"
    ...    }
    ...    ]
    ...    }
    [Tags]    qtest
    [Arguments]
    ...    ${carrier_id}=12345
    ...    ${carrier_name}=Sample Carrier
    ...    ${family}=ROBOTTEST
    ...    ${token_request_url}=ReqURL
    ...    ${post_request_url}=postReqURL
    ...    ${callback_url}=callbackURL
    ...    ${user_name}=testUser
    ...    ${password}=testPass
    ...    ${scope}=testScope
    ...    ${grant_type}=testGrantType
    ...    ${header_name}=headerName
    ...    ${header_value}=headerValue
    ...    ${is_parent}=true
    ${headers}    Create Dictionary    content-type=application/json
    ${header}    Create Dictionary    name=${header_name}    value=${header_value}
    ${post_headers}    Create List    ${header}
    ${enrollment}    Create Dictionary    carrierId=${carrier_id}    carrierName=${carrier_name}    family=${family}
    ...    tokenRequestURL=${token_request_url}    postRequestURL=${post_request_url}    callbackURL=${callback_url}
    ...    username=${user_name}    password=${password}    scope=${scope}    grantType=${grant_type}
    ...    isParent=${is_parent}    headers=${post_headers}
    ${results}    ${status}    Api Request
    ...    POST
    ...    carrier-enrollment/enroll
    ...    Y
    ...    ${NONE}
    ...    ${NONE}
    ...    OTR_eMgr
    ...    ${headers}
    ...    payload=${enrollment}
    Set Test Variable    ${enrollment}

Validate TCS Postgres
    [Documentation]    Query the trans/tcs service postgres database and validate that the information has been stored
    ...    correctly.
    ...    SELECT token_request_id FROM token_request WHERE url='tokenRequestURL' AND username='username'
    ...    AND grant_type='grantType' AND scope='scope'
    ...    Use the ID from above to find the classifier:
    ...    SELECT classifier_id FROM classifier_config WHERE classifier_name='family'
    ...    AND post_url='postRequestURL' AND token_request_id = previous_query_id
    ...    Use the classifier id to find the custom header information:
    ...    SELECT custom_header_id FROM custom_header where classifier_id = 'classifier_id'
    ...    AND header_name='header name' AND header_value='header value'
    ...    Check the carrier service postgres if the carrier got added to the new family
    ...    SELECT id FROM carrier_family_carrier_xref where carrier_id = 'carrierId'
    ...    AND family = 'family'
    [Tags]    qtest
    ${sql}    Catenate    SELECT token_request_id FROM token_request WHERE url='${enrollment['tokenRequestURL']}'
    ...    AND username='${enrollment['username']}' AND grant_type='${enrollment['grantType']}'
    ...    AND scope='${enrollment['scope']}'
    ${token_request_id}    Query And Strip    ${sql}    db_instance=postgrespgtransservice
    Should Not Be Empty    ${token_request_id.__str__()}
    Set Test Variable    ${token_request_id}
    ${sql}    Catenate    SELECT classifier_id FROM classifier_config WHERE classifier_name='${enrollment['family']}'
    ...    AND post_url='${enrollment['postRequestURL']}' AND token_request_id = ${token_request_id}
    ...    AND callback_url='${enrollment['callbackURL']}'
    ${classifier_id}    Query And Strip    ${sql}    db_instance=postgrespgtransservice
    Should Not Be Empty    ${classifier_id.__str__()}
    Set Test Variable    ${classifier_id}
    ${sql}    Catenate    SELECT custom_header_id FROM custom_header where classifier_id = ${classifier_id}
    ...    AND header_name='${enrollment['headers'][0]['name']}'
    ...    AND header_value='${enrollment['headers'][0]['value']}'
    ${custom_header_id}    Query And Strip    ${sql}    db_instance=postgrespgtransservice
    Should Not Be Empty    ${custom_header_id.__str__()}
    Set Test Variable    ${custom_header_id}
    ${sql}    Catenate    SELECT id FROM carrier_family_carrier_xref where carrier_id = '${enrollment['carrierId']}'
    ...    AND carrier_family_natural_id = '${enrollment['family']}'
    ${family_id}    Query And Strip    ${sql}    db_instance=postgrespgcarrierservices
    Should Not Be Empty    ${family_id.__str__()}
    Set Test Variable    ${family_id}

Remove TCS Postgres
    [Documentation]    Clean the database from test data:
    ...    delete from custom_header where custom_header_id = custom_header_id
    ...    delete from token_request where token_request_id = token_request_id
    ...    delete from classifier_config where classifier_id = classifier_id
    [Tags]    qtest
    ${sql}    Catenate    delete from custom_header where custom_header_id = ${custom_header_id}
    Execute Sql String    ${sql}    db_instance=postgrespgtransservice
    ${sql}    Catenate    delete from classifier_config where classifier_id = ${classifier_id}
    Execute Sql String    ${sql}    db_instance=postgrespgtransservice
    ${sql}    Catenate    delete from token_request where token_request_id = ${token_request_id}
    Execute Sql String    ${sql}    db_instance=postgrespgtransservice
    ${sql}    Catenate    delete from carrier_family_carrier_xref where id = '${family_id}'
    Execute Sql String    ${sql}    db_instance=postgrespgcarrierservices

Validate Password Encryption
    [Documentation]    Check if the password is not stored unecrypted in the postgres database
    ...    Then call the GET endpoint for carriers enrolled to validate that
    ...    the password is being returned correctly and unecrypted
    [Tags]    qtest
    ${sql}    Catenate    select password from token_request where token_request_id = ${token_request_id}
    ${password}    query and strip    ${sql}    db_instance=postgrespgtransservice
    Should Not Be Equal As Strings    ${password}    ${enrollment['password']}
    ${headers}    Create Dictionary    content-type=application/json
    ${results}    ${status}    Api Request
    ...    GET
    ...    carrier-enrollment/enroll/${enrollment['family']}
    ...    Y
    ...    ${NONE}
    ...    ${NONE}
    ...    OTR_eMgr
    ...    ${headers}
    Should Be Equal As Strings    ${results['password']}    ${enrollment['password']}
