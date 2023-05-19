*** Settings ***
Library     Collections
Library     String
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment to START
Suite Teardown  Setup the environment to FINISH

Documentation  This is to test the endpoint [POST to create a notification config for an specific user]
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  T-Check  ditOnly  OnSite_UserNotifConfig

*** Variables ***
${db}  postgresmerchants
@{email}   POSTtestautomation@wexinc.com
@{email_invalid}    INVALID
@{emails_duplicate}     POSTtestautomation@wexinc.com   POSTtestautomation@wexinc.com
@{emails_more_than_10}  POSTtestautomation01@wexinc.com  POSTtestautomation02@wexinc.com  POSTtestautomation03@wexinc.com
...     POSTtestautomation04@wexinc.com  POSTtestautomation05@wexinc.com  POSTtestautomation06@wexinc.com
...     POSTtestautomation07@wexinc.com  POSTtestautomation08@wexinc.com  POSTtestautomation09@wexinc.com
...     POSTtestautomation10@wexinc.com  POSTtestautomation11@wexinc.com  POSTtestautomation12@wexinc.com

*** Test Cases ***
########################## OnSite Notification Config API ###########################
#-----------------------------------------------------------------------------------#
#              Endpoint POST:  /merchants/notification/{user_id}                    #
#-----------------------------------------------------------------------------------#
(OnSite Notification Config API) POST - Testing [MERCHANT] User notification config creation
    [Tags]           Q1:2023    Q2:2023   JIRA:O5SA-549  JIRA:O5SA-630   qTest:119599269
    [Documentation]  Test [POST to create a new MERCHANT notification config for an specific user]
    ...              The API response should be (201)-Created, and new records should be added to the database
    [Setup]     Select a valid "MERCHANT" to use
    Use the POST endpoint to create a "MERCHANT" user notification config
    The API response should be [201] - with notification config created
    Compare "MERCHANT" notification API request with the data stored in the database
    [Teardown]  Sending delete request to remove data generated To Request

(OnSite Notification Config API) POST - Testing [LOCATION] User notification config creation
    [Tags]           Q1:2023    Q2:2023   JIRA:O5SA-549  JIRA:O5SA-630   qTest:119599269
    [Documentation]  Test [POST to create a new LOCATION notification config for an specific user]
    ...              The API response should be (201)-Created, and new records should be added to the database
    [Setup]     Select a valid "LOCATION" to use
    Use the POST endpoint to create a "LOCATION" user notification config
    The API response should be [201] - with notification config created
    Compare "LOCATION" notification API request with the data stored in the database
    [Teardown]  Sending delete request to remove data generated To Request

(OnSite Notification Config API) POST ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q1:2023   Q2:2023   JIRA:O5SA-549  JIRA:O5SA-630   qTest:119599793
    [Documentation]  This is to test all EXPECTED ERRORS of [POST to create notification config for an specific user]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Setup the environment to START
    [Documentation]  Use to connect with API URL and create a new automation use, to start the test
    Get URL For Suite    ${MerchantService}
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager  entity_id=${EMPTY}
    ...             with_data=N  need_new_user=Y

Setup the environment to FINISH
    [Documentation]  Use remove the user and the respective notification config created before, to finish the test
    Sending delete request to remove data generated To Request
    Remove User if Still exists

Query to find a valid "${field}" in the database
    [Documentation]  To find valid values do use in the fields MERCHANT_ID and LOCATION_ID
    IF  '${field}'=='MERCHANT_ID'
        ${column}  Catenate  merchant_id
    ELSE IF  '${field}'=='LOCATION_ID'
        ${column}  Catenate  location_id
    END

    Get into DB  ${db}
        ${query}    Catenate    select ${column} from on_site_merchants osm
        ...                     order by id desc limit 10;
        ${finding_data}  Query To Dictionaries  ${query}
        ${finding_data}  Evaluate  random.choice(${finding_data})
    Disconnect From Database

    IF  '${field}'=='MERCHANT_ID'
         Set Suite Variable  ${merchant_valid}   ${finding_data}[merchant_id]
         Set Suite Variable  ${respective_type}  MERCHANT
    ELSE IF  '${field}'=='LOCATION_ID'
         Set Suite Variable  ${location_valid}   ${finding_data}[location_id]
         Set Suite Variable  ${respective_type}  LOCATION
    END

Select a valid "${type}" to use
    [Documentation]    Use to select MERCHANT and LOCATIONS in the request
    IF  '${type}'=='MERCHANT'
         Query to find a valid "MERCHANT_ID" in the database
    ELSE IF  '${type}'=='LOCATION'
         Query to find a valid "LOCATION_ID" in the database
    END

Sending post request
    [Documentation]  Used to build a generic REQUEST structure of [POST to create notification config] endpoint
    [Arguments]      ${path}=notification/${auto_user_id}  ${boolean_daily}=${true}  ${boolean_file}=${false}
    ...              ${merchant}=${merchant_valid}  ${location}=${NONE}  ${type}=MERCHANT
    ...              ${email_list}=@{email}    ${authorized}=Y  ${remove}=NO  ${what_remove}=${NONE}

    ${path_url}      create dictionary   None=${path}
        ${notification_type}  Create Dictionary   daily_summary=${boolean_daily}  file_processing=${boolean_file}
        ${subscription}       Create Dictionary   merchant_id=${merchant}  location_id=${location}  id_type=${type}
        ...                                       notification_types=${notification_type}
        @{subscription_list}  Create List         ${subscription}
    ${payload}       create dictionary   email_list=${email_list}  subscriptions=@{subscription_list}

    IF  '${remove.upper()}'=='YES'
        Remove From Dictionary  ${payload}            ${what_remove.lower()}
        Remove From Dictionary  ${notification_type}  ${what_remove.lower()}
        Remove From Dictionary  ${subscription}       ${what_remove.lower()}
    END

    ${result}   ${status}   Api request   POST  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    ...                                   payload=${payload}
    Set Test Variable  ${result}
    Set Test Variable  ${status}
    Set Test Variable  ${email_list}
    Set Test Variable  ${notification_type}
    Set Test Variable  ${subscription}

Sending delete request to remove data generated To Request
    [Documentation]  Use to REMOVE data to the respective USER selected inside the tables
    ...              [notification_subscriptons] and [notification_config] using the DELETE endpoint
    ${path_url}      create dictionary   None=notification/${auto_user_id}
    ${result_delete}  ${status_delete}  Api request   DELETE  merchants  Y  ${path_url}  application=Merchant Manager
    Should Be Equal As Strings     ${status_delete}   200

###################################################### HAPPY PATH #####################################################
Use the POST endpoint to create a "${option}" user notification config
    [Documentation]  Sending the request to OTR Merchant API to create a new user notification config
    IF  '${option}'=='MERCHANT'
        Sending post request
        ...     merchant=${merchant_valid}  type=${respective_type}  remove=YES  what_remove=location_id
    ELSE IF    '${option}'=='LOCATION'
        Sending post request
        ...     location=${location_valid}  type=${respective_type}  remove=YES  what_remove=merchant_id
    END

The API response should be [201] - with notification config created
    [Documentation]  Cheking STATUS and fields displayed in the API response
    Should Be Equal As Strings    ${status}                 201
    Should Be Equal As Strings    ${result}[name]           CREATED
    Should Be Equal As Strings    ${result}[message]        SUCCESSFUL
    Should Be Equal As Strings    ${result}[details][type]  NotificationConfigResponseDTO
    Should Be Equal As Strings    ${result}[details][data][links][0][rel]     get_user_notification_config
    Should Not Be Empty           ${result}[details][data][links][0][href]

    #   checking keys inside [details]
    ${keys_details}  Get Dictionary Keys  ${result}[details]
    Should Be Equal   ${keys_details}[0]   data
    Should Be Equal   ${keys_details}[1]   type

    #   checking keys inside [data]
    ${keys_data}  Get Dictionary Keys  ${result}[details][data]
    Should Be Equal             ${keys_data}[0]                    links
    Should Be Equal             ${keys_data}[1]                    user_id
    Should Be Equal As Strings  ${result}[details][data][user_id]  ${auto_user_id}

Query to find user config notifications
    [Documentation]  Use to find data stored at tables: [notification_subscriptions and [notification_config] inside DB
    Get into DB  ${db}
        ${query}  Catenate
        ...       select nc.user_id as configuser_id, ns.user_id as subsuser_id, nc.email_list as email_list,
        ...       ns.subscriptions as subscriptions, ns.id_type as id_type
        ...       from notification_subscriptions ns
        ...       join notification_config nc on (nc.user_id = ns.user_id)
        ...       where nc.user_id ='${auto_user_id}';
        ${user_notif_resultDB}  query to dictionaries   ${query}
    Disconnect from Database
    Set Suite Variable  ${user_notif_resultDB}

Compare "${field}" notification API request with the data stored in the database
    [Documentation]  Comparing the fields iformed in the REQUEST BODY, with fields recorded in the database
    Query to find user config notifications

    Should Be Equal As Strings   ${user_notif_resultDB}[0][configuser_id]   ${auto_user_id}
    Should Be Equal As Strings   ${user_notif_resultDB}[0][subsuser_id]     ${auto_user_id}
    Should Be Equal As Strings   ${user_notif_resultDB}[0][email_list]      ${email_list}

    Set Test Variable  ${subscriptionDB}  ${user_notif_resultDB}[0][subscriptions]
    IF  '${field}'=='MERCHANT'
           Should Be Equal As Strings  ${subscriptionDB}[merchant_id]  ${subscription}[merchant_id]
    ELSE IF  '${field}'=='LOCATION'
           Should Be Equal As Strings  ${subscriptionDB}[location_id]  ${subscription}[location_id]
    END

    Should Be Equal As Strings  ${subscriptionDB}[notification_types]  ${notification_type}
    Should Be Equal As Strings  ${subscriptionDB}[id_type]             ${subscription}[id_type]
    Should Be Equal As Strings  ${user_notif_resultDB}[0][id_type]     ${subscription}[id_type]

################################################### EXPECTED ERRORS ###################################################
ERROR 404 - RESPONSE EXPECTED
    [Documentation]  Use to validade ERROR with status 404
    Should Be Equal As Strings   ${status}              404
    Should Be Equal As Strings   ${result}[status]      404
    Should Be Equal As Strings   ${result}[error]       Not Found
    Should Be Equal As Strings   ${result}[path]        /merchants/notification/
    Should Not Be Empty          ${result}[timestamp]

ERROR 422 - RESPONSE EXPECTED
    [Documentation]  Use to validade ERROR with status 422
    [Arguments]  ${remove_issue}=NO  ${name}=${NONE}  ${error_code}=${NONE}  ${field}=${NONE}  ${value}=${NONE}
    ...          ${issue}=${NONE}    ${msg}=${NONE}
    Should Be Equal As Strings  ${status}  422

    ${response}  Get Dictionary Keys   ${result}
    Should Be Equal   ${response}[0]   details
    IF  '${remove_issue}'=='NO'
         Should Be Equal As Strings  ${result}[details][0][field]  ${field}
         Should Be Equal As Strings  ${result}[details][0][issue]  ${issue}
         Should Be Equal As Strings  ${result}[details][0][value]  ${value}
    ELSE IF  '${remove_issue}'=='YES'
         Should Be Equal As Strings  ${result}[details][0][field]  ${field}
         Should Be Equal As Strings  ${result}[details][0][value]  ${value}
    END
    Should Be Equal             ${response}[1]         error_code
    Should Be Equal As Strings  ${result}[error_code]  ${error_code}
    Should Be Equal             ${response}[2]         message
    Should Be Equal As Strings  ${result}[message]     ${msg}
    Should Be Equal             ${response}[3]         name
    Should Be Equal As Strings  ${result}[name]        ${name}

ERROR 400 - RESPONSE EXPECTED
    [Documentation]  Use to validade ERROR with status 400
    [Arguments]  ${with_body}=NO   ${name}=${NONE}  ${error_code}=${NONE}  ${field}=${NONE}  ${value}=${NONE}
    ...          ${issue}=${NONE}  ${msg}=${NONE}   ${remove_issue}=NO  ${remove_value}=NO

    Should Be Equal As Strings  ${status}  400
    IF  '${with_body}'=='YES'
        ${response}   Get Dictionary Keys   ${result}
        Should Be Equal    ${response}[0]   details
        IF  ('${remove_issue}'=='NO') and ('${remove_value}'=='NO')
            Should Be Equal As Strings    ${result}[details][0][field]      ${field}
            Should Be Equal As Strings    ${result}[details][0][value]      ${value}
            Should Be Equal As Strings    ${result}[details][0][issue]      ${issue}
        ELSE IF  '${remove_issue}'=='YES'
            Should Be Equal As Strings    ${result}[details][0][field]      ${field}
            Should Be Equal As Strings    ${result}[details][0][value]      ${value}
        ELSE IF  '${remove_value}'=='YES'
            Should Be Equal As Strings    ${result}[details][0][field]      ${field}
            Should Be Equal As Strings    ${result}[details][0][issue]      ${issue}
        END
        Should Be Equal               ${response}[1]                    error_code
        Should Be Equal As Strings    ${result}[error_code]             ${error_code}
        Should Be Equal               ${response}[2]                    message
        Should Be Equal As Strings    ${result}[message]                ${msg}
        Should Be Equal               ${response}[3]                    name
        Should Be Equal As Strings    ${result}[name]                   ${name}
    ELSE IF  '${with_body}'=='YES - WITHOUT [ERROR_CODE]'
        ${response}   Get Dictionary Keys   ${result}
        Should Be Equal    ${response}[0]   details
        IF  ('${remove_issue}'=='NO') and ('${remove_value}'=='NO')
            Should Be Equal As Strings    ${result}[details][0][field]      ${field}
            Should Be Equal As Strings    ${result}[details][0][value]      ${value}
            Should Be Equal As Strings    ${result}[details][0][issue]      ${issue}
        ELSE IF  '${remove_issue}'=='YES'
            Should Be Equal As Strings    ${result}[details][0][field]      ${field}
            Should Be Equal As Strings    ${result}[details][0][value]      ${value}
        ELSE IF  '${remove_value}'=='YES'
            Should Be Equal As Strings    ${result}[details][0][field]      ${field}
            Should Be Equal As Strings    ${result}[details][0][issue]      ${issue}
        END
        Should Be Equal               ${response}[1]                    message
        Should Be Equal As Strings    ${result}[message]                ${msg}
        Should Be Equal               ${response}[2]                    name
        Should Be Equal As Strings    ${result}[name]                   ${name}
    ELSE IF  '${with_body}'=='NO'
        Should Be Empty    ${result}
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests

    ${error_list}  Create List
    ...  UNAUTHORIZED TOKEN           USER_ID unauthorized       USER_ID not send             USER_ID invalid UUID
    ...  USER_ID already existent     EMAIL_LIST not send        EMAIL_LIST invalid email     EMAIL_LIST duplicated
    ...  EMAIL_LIST more than 10      MERCHANT_ID not send       MERCHANT_ID invalid          LOCATION_ID not send
    ...  LOCATION_ID invalid          ID_TYPE not send           ID_TYPE invalid enum         NOTIFICATION_TYPE not send
    ...  NOTIFICATION_TYPE invalid boolean        NOTIFICATION_TYPE all options false

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    Select a valid "MERCHANT" to use
    FOR  ${error}  IN  @{error_list}
         Add Test Case  (OnSite Notification Config API) POST ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Post Request   authorized=I  merchant=${merchant_valid}  type=MERCHANT  remove=YES  what_remove=location_id
    IF    '${status}'=='401'
        Should Be Equal As Strings  ${status}  401
        Should Be Empty    ${result}
    ELSE
        Fail  TOKEN authorization validation failed
    END

ERROR - USER_ID ${error}
    [Documentation]  Testing the request URL with the field USER_ID (not send, invalid string, unauthorized or with
    ...              an user_id already existent)
    IF  '${error}'=='unauthorized'
        Get into DB  ${db}
            ${query}    Catenate    select * from notification_config where user_id <> '${auto_user_id}';
            ${user_unauthorized}    query to dictionaries   ${query}
        Disconnect From Database
        ${user_to_test}    Set Variable    ${user_unauthorized}[0][user_id]

        Sending Post Request  path=notification/${user_to_test}  remove=YES  what_remove=location_id
        Should Be Equal As Strings   ${status}  403
    ELSE IF  '${error}'=='not send'
        Sending Post Request    path=notification/  remove=YES  what_remove=location_id
        ERROR 404 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='invalid UUID'
        Sending Post Request  path=notification/INVALID  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='already existent'
        Sending Post Request  remove=YES  what_remove=location_id
        Sending Post Request  remove=YES  what_remove=location_id
        ERROR 422 - RESPONSE EXPECTED  remove_issue=YES
        ...     name=USER_ALREADY_EXIST  error_code=USER_ALREADY_EXIST  field=user_id  value=${auto_user_id}
        ...     msg=The user already exists.
#        Remove data generated by the request
    END

ERROR - EMAIL_LIST ${error}
    [Documentation]  Testing the request body, with the list EMAIL_LIST (not send, with invalid email, duplicate email
    ...              and more than 10 emails informed)
    IF  '${error}'=='not send'
        Sending Post Request  remove=YES  what_remove=email_list
        ERROR 400 - RESPONSE EXPECTED  YES - WITHOUT [ERROR_CODE]
        ...     name=BAD_REQUEST   field=emailList   issue=email_list must not be empty.  msg=Invalid request input
        ...     remove_value=YES
    ELSE IF  '${error}'=='invalid email'
        Sending Post Request  email_list=@{email_invalid}  remove=YES  what_remove=location_id
        ERROR 422 - RESPONSE EXPECTED
        ...     name=INVALID_EMAIL  error_code=INVALID_EMAIL  field=email_list  value=INVALID
        ...     issue=This is not a valid email  msg=Informed email is invalid.
    ELSE IF  '${error}'=='duplicated'
        Sending Post Request  email_list=@{emails_duplicate}
        ...     remove=YES  what_remove=location_id
        ERROR 422 - RESPONSE EXPECTED
        ...     name=EMAIL_LIST_NOT_UNIQUE  error_code=EMAIL_LIST_NOT_UNIQUE  field=email_list
        ...     value=POSTtestautomation@wexinc.com  issue=Repeated email  msg=Informed email is duplicated.
    ELSE IF  '${error}'=='more than 10'
        Sending Post Request  email_list=@{emails_more_than_10}
        ...     remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED   YES - WITHOUT [ERROR_CODE]
        ...     name=BAD_REQUEST   field=emailList   issue=size must be between 1 and 10  msg=Invalid request input
        ...     remove_value=YES
    END

ERROR - MERCHANT_ID ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field MERCHANT_ID (not send and
    ...              with an invalid string)
    IF  '${error}'=='not send'
        Sending Post Request  type=MERCHANT  remove=YES  what_remove=merchant_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH    field=merchant_id
        ...     issue=This field should not be null neither invalid since the id_type is 'MERCHANT'.
        ...     msg=Invalid request input.  remove_value=YES
    ELSE IF  '${error}'=='invalid'
        Sending Post Request  type=MERCHANT  merchant=INVALID  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH   field=merchant_id   value=INVALID
        ...     issue=This field should not be null neither invalid since the id_type is 'MERCHANT'.
        ...     msg=Invalid request input.
    END

ERROR - LOCATION_ID ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field LOCATION_ID (not send and
    ...              with an invalid string)
    IF  '${error}'=='not send'
        Sending Post Request  type=LOCATION  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH    field=location_id
        ...     issue=This field should not be null neither invalid since the id_type is 'LOCATION'.
        ...     msg=Invalid request input.  remove_value=YES
    ELSE IF  '${error}'=='invalid'
        Sending Post Request  type=LOCATION  location=INVALID  remove=YES  what_remove=merchant_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH   field=location_id   value=INVALID
        ...     issue=This field should not be null neither invalid since the id_type is 'LOCATION'.
        ...     msg=Invalid request input.
    END

ERROR - ID_TYPE ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field ID_TYPE (not send and
    ...              using an invalid enumerator)
    IF  '${error}'=='not send'
        Sending Post Request  remove=YES  what_remove=id_type
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH         error_code=ID_TYPE_DOES_NOT_MATCH   field=id_type
        ...     issue=This field must not be null.  msg=Invalid request input.          remove_value=YES
    ELSE IF  '${error}'=='invalid enum'
        Sending Post Request  type=INVALID
        ERROR 400 - RESPONSE EXPECTED
    END

ERROR - NOTIFICATION_TYPE ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field NOTIFICATION_TYPE (not send,
    ...              using an invalid boolean option, and with (daily_summary and file_processing as FALSE)
    IF  '${error}'=='not send'
        Sending Post Request  remove=YES  what_remove=notification_types
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=INVALID_NOTIFICATION_TYPE        error_code=INVALID_NOTIFICATION_TYPE   field=notification_types
        ...     issue=This field must not be empty.   msg=notification_types is invalid.     remove_value=YES
    ELSE IF  '${error}'=='all options false'
        Sending Post Request  boolean_daily=${false}  boolean_file=${false}  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=INVALID_NOTIFICATION_TYPE          error_code=INVALID_NOTIFICATION_TYPE
        ...     field=daily_summary or file_processing  issue=At least one field must be true.
        ...     msg=notification_types is invalid.      remove_value=YES
    ELSE IF  '${error}'=='invalid boolean'
        Sending Post Request  boolean_daily=INVALID  boolean_file=INVALID  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED
    END