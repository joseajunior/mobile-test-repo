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

Documentation  This is to test the endpoint [PUT to update an existent user notification config]
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  T-Check  ditOnly  OnSite_UserNotifConfig

*** Variables ***
${db}  postgresmerchants
@{email}   PUTtestautomation@wexinc.com
@{email_invalid}    INVALID
@{emails_duplicate}     PUTtestautomation@wexinc.com   PUTtestautomation@wexinc.com
@{emails_more_than_10}  PUTtestautomation01@wexinc.com  PUTtestautomation02@wexinc.com  PUTtestautomation03@wexinc.com
...     PUTtestautomation04@wexinc.com  PUTtestautomation05@wexinc.com  PUTtestautomation06@wexinc.com
...     PUTtestautomation07@wexinc.com  PUTtestautomation08@wexinc.com  PUTtestautomation09@wexinc.com
...     PUTtestautomation10@wexinc.com  PUTtestautomation11@wexinc.com  PUTtestautomation12@wexinc.com

*** Test Cases ***
########################## OnSite Notification Config API ###########################
#-----------------------------------------------------------------------------------#
#              Endpoint PUT:  /merchants/notification/{user_id}                     #
#-----------------------------------------------------------------------------------#
(OnSite Notification Config API) PUT - Testing the update of User notification config
    [Tags]           Q1:2023   Q2:2023   JIRA:O5SA-550  qTest:119814648
    [Documentation]  Test [PUT to update an existent user notification config]
    ...              The API response should be (200)-OK, and the current data in the database should be changed
    [Setup]    Use POST endpoint to create an user notification config
    Use PUT endpoint to update an existent user notification config
    The API response should be [200] - with the user notification config updated
    Compare the API request body with the current data in the database
    [Teardown]  Use DELETE endpoint to remove the user notification created

(OnSite Notification Config API) PUT ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q1:2023   Q2:2023   JIRA:O5SA-550  qTest:119815524
    [Documentation]  This is to test all EXPECTED ERRORS of [PUT to update an existent user notification config]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Setup the environment to START
    [Documentation]  Use to connect with API URL, create a new automation use, and select valid data of merchant and
    ...              location to start the test
    Get URL For Suite    ${MerchantService}
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager  entity_id=${EMPTY}
    ...             with_data=N  need_new_user=Y
    Query to find a valid "MERCHANT_ID" in the database
    Query to find a valid "LOCATION_ID" in the database

Setup the environment to FINISH
    [Documentation]  Use remove the user and the respective notification config created before, to finish the test
    Use DELETE endpoint to remove the user notification created
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
    ELSE IF  '${field}'=='LOCATION_ID'
         Set Suite Variable  ${location_valid}   ${finding_data}[location_id]
    END

Use POST endpoint to create an user notification config
    [Documentation]  Used to build a generic REQUEST structure of POST endpoint [to create notification config]
    ...              Sending the request to OTR Merchant API to create a new user notification config
    [Arguments]      ${remove}=NO  ${what_remove}=${NONE}
    ${path_url}           create dictionary   None=notification/${auto_user_id}
    @{email_list}         Create List         testPUTautomation@test.com
    ${notification_type}  Create Dictionary   daily_summary=${true}  file_processing=${false}
    ${subscription}       Create Dictionary   location_id=${location_valid}  id_type=LOCATION
    ...                                       notification_types=${notification_type}
    @{subscription_list}  Create List         ${subscription}
    ${payload}            create dictionary   email_list=@{email_list}  subscriptions=@{subscription_list}

    IF  '${remove.upper()}'=='YES'
        Remove From Dictionary  ${payload}            ${what_remove.lower()}
        Remove From Dictionary  ${notification_type}  ${what_remove.lower()}
        Remove From Dictionary  ${subscription}       ${what_remove.lower()}
    END

    ${result}   ${status}   Api request    POST  merchants  Y  ${path_url}  application=Merchant Manager  payload=${payload}
    Should Be Equal As Strings  ${status}  201

Sending PUT request
    [Documentation]  Used to build a generic REQUEST structure of PUT endpoint [to update and existent notification config]
    [Arguments]      ${path}=notification/${auto_user_id}  ${boolean_daily}=${true}  ${boolean_file}=${false}
    ...              ${merchant}=${merchant_valid}  ${location}=${location_valid}   ${type}=MERCHANT
    ...              ${email_list}=@{email}  ${authorized}=Y  ${remove}=NO  ${what_remove}=${NONE}
    ${path_url}           create dictionary   None=${path}
    ${notification_type}  Create Dictionary   daily_summary=${boolean_daily}  file_processing=${boolean_file}
    ${subscription}       Create Dictionary   merchant_id=${merchant}   location_id=${location}  id_type=${type}
    ...                                       notification_types=${notification_type}
    @{subscription_list}  Create List         ${subscription}
    ${payload}            create dictionary   email_list=${email_list}  subscriptions=@{subscription_list}

    IF  '${remove.upper()}'=='YES'
        Remove From Dictionary  ${payload}            ${what_remove.lower()}
        Remove From Dictionary  ${notification_type}  ${what_remove.lower()}
        Remove From Dictionary  ${subscription}       ${what_remove.lower()}
    END

    ${result}   ${status}   Api request   PUT  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    ...                                   payload=${payload}
    Set Test Variable  ${result}
    Set Test Variable  ${status}
    Set Test Variable  ${email_list}
    Set Test Variable  ${notification_type}
    Set Test Variable  ${subscription}

Use DELETE endpoint to remove the user notification created
    [Documentation]  Use to REMOVE data to the respective USER selected inside the tables
    ...              [notification_subscriptons] and [notification_config] using the DELETE endpoint
    ${path_url}      create dictionary   None=notification/${auto_user_id}
    ${result_delete}  ${status_delete}  Api request   DELETE  merchants  Y  ${path_url}  application=Merchant Manager
    Should Be Equal As Strings     ${status_delete}   200

###################################################### HAPPY PATH #####################################################
Use PUT endpoint to update an existent user notification config
    [Documentation]  Sending the request to OTR Merchant API to update an existent user notification config
    Sending PUT Request  merchant=${merchant_valid}  type=MERCHANT  remove=YES  what_remove=location_id

The API response should be [200] - with the user notification config updated
    [Documentation]  Cheking STATUS and fields displayed in the API response
    Should Be Equal As Strings    ${status}                 200
    Should Be Equal As Strings    ${result}[name]           OK
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

Compare the API request body with the current data in the database
    [Documentation]  Comparing the fields iformed in the REQUEST BODY, with fields recorded in the database
    Query to find user config notifications

    Should Be Equal As Strings  ${user_notif_resultDB}[0][configuser_id]  ${auto_user_id}
    Should Be Equal As Strings  ${user_notif_resultDB}[0][subsuser_id]    ${auto_user_id}
    Should Be Equal As Strings  ${user_notif_resultDB}[0][email_list]     ${email_list}

    Set Test Variable  ${subscriptionDB}  ${user_notif_resultDB}[0][subscriptions]
    Should Be Equal As Strings  ${subscriptionDB}[merchant_id]  ${subscription}[merchant_id]

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
    ...  UNAUTHORIZED TOKEN            USER_ID unauthorized     USER_ID not send             USER_ID invalid UUID
    ...  USER_ID already existent      EMAIL_LIST not send      EMAIL_LIST invalid email     EMAIL_LIST duplicated
    ...  EMAIL_LIST more than 10       MERCHANT_ID not send     MERCHANT_ID invalid          LOCATION_ID not send
    ...  LOCATION_ID invalid           ID_TYPE not send         ID_TYPE invalid enum         NOTIFICATION_TYPE not send
    ...  NOTIFICATION_TYPE invalid boolean    NOTIFICATION_TYPE all options false    USER_ID UUID does not exists in DB

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    Use POST endpoint to create an user notification config
    FOR  ${error}  IN  @{error_list}
         Add Test Case  (OnSite Notification Config API) PUT ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending PUT Request   authorized=I  merchant=${merchant_valid}  type=MERCHANT  remove=YES  what_remove=location_id
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

        Sending PUT Request  path=notification/${user_to_test}  remove=YES  what_remove=location_id
        Should Be Equal As Strings   ${status}  403
        Should Be Empty    ${result}
    ELSE IF  '${error}'=='not send'
        Sending PUT Request    path=notification/
        ERROR 404 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='invalid UUID'
        Sending PUT Request  path=notification/INVALID  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='UUID does not exists in DB'
        Use DELETE endpoint to remove the user notification created
        Sending PUT Request  remove=YES  what_remove=location_id
        ERROR 422 - RESPONSE EXPECTED  remove_issue=YES
        ...     name=NOT_FOUND_OTR_USER  error_code=NOT_FOUND_OTR_USER  field=user_id  value=${auto_user_id}
        ...     msg=OTR User does not exist
    END

ERROR - EMAIL_LIST ${error}
    [Documentation]  Testing the request body, with the list EMAIL_LIST (not send, with invalid email, duplicate email
    ...              and more than 10 emails informed)
    IF  '${error}'=='not send'
        Sending PUT Request  remove=YES  what_remove=email_list
        ERROR 400 - RESPONSE EXPECTED  YES - WITHOUT [ERROR_CODE]
        ...     name=BAD_REQUEST   field=emailList   issue=email_list must not be empty.  msg=Invalid request input
        ...     remove_value=YES
    ELSE IF  '${error}'=='invalid email'
        Sending PUT Request  email_list=@{email_invalid}  remove=YES  what_remove=location_id
        ERROR 422 - RESPONSE EXPECTED
        ...     name=INVALID_EMAIL  error_code=INVALID_EMAIL  field=email_list  value=INVALID
        ...     issue=This is not a valid email  msg=Informed email is invalid.
    ELSE IF  '${error}'=='duplicated'
        Sending PUT Request  email_list=@{emails_duplicate}
        ...     remove=YES  what_remove=location_id
        ERROR 422 - RESPONSE EXPECTED
        ...     name=EMAIL_LIST_NOT_UNIQUE  error_code=EMAIL_LIST_NOT_UNIQUE  field=email_list
        ...     value=PUTtestautomation@wexinc.com  issue=Repeated email  msg=Informed email is duplicated.
    ELSE IF  '${error}'=='more than 10'
        Sending PUT Request  email_list=@{emails_more_than_10}
        ...     remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED   YES - WITHOUT [ERROR_CODE]
        ...     name=BAD_REQUEST   field=emailList   issue=size must be between 1 and 10  msg=Invalid request input
        ...     remove_value=YES
    END

ERROR - MERCHANT_ID ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field MERCHANT_ID (not send and
    ...              with an invalid string)
    IF  '${error}'=='not send'
        Sending PUT Request  type=MERCHANT  remove=YES  what_remove=merchant_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH    field=merchant_id
        ...     issue=This field should not be null neither invalid since the id_type is 'MERCHANT'.
        ...     msg=Invalid request input.  remove_value=YES
    ELSE IF  '${error}'=='invalid'
        Sending PUT Request  type=MERCHANT  merchant=INVALID  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH   field=merchant_id   value=INVALID
        ...     issue=This field should not be null neither invalid since the id_type is 'MERCHANT'.
        ...     msg=Invalid request input.
    END

ERROR - LOCATION_ID ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field LOCATION_ID (not send and
    ...              with an invalid string)
    IF  '${error}'=='not send'
        Sending PUT Request  type=LOCATION  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH    field=location_id
        ...     issue=This field should not be null neither invalid since the id_type is 'LOCATION'.
        ...     msg=Invalid request input.  remove_value=YES
    ELSE IF  '${error}'=='invalid'
        Sending PUT Request  type=LOCATION  location=INVALID  remove=YES  what_remove=merchant_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH     error_code=ID_TYPE_DOES_NOT_MATCH   field=location_id   value=INVALID
        ...     issue=This field should not be null neither invalid since the id_type is 'LOCATION'.
        ...     msg=Invalid request input.
    END

ERROR - ID_TYPE ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field ID_TYPE (not send and
    ...              using an invalid enumerator)
    IF  '${error}'=='not send'
        Sending PUT Request  remove=YES  what_remove=id_type
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=ID_TYPE_DOES_NOT_MATCH         error_code=ID_TYPE_DOES_NOT_MATCH   field=id_type
        ...     issue=This field must not be null.  msg=Invalid request input.          remove_value=YES
    ELSE IF  '${error}'=='invalid enum'
        Sending PUT Request  type=INVALID
        ERROR 400 - RESPONSE EXPECTED
    END

ERROR - NOTIFICATION_TYPE ${error}
    [Documentation]  Testing the request body, checking SUBSCRIPTIONS_LIST, using the field NOTIFICATION_TYPE (not send,
    ...              using an invalid boolean option, and with (daily_summary and file_processing as FALSE)
    IF  '${error}'=='not send'
        Sending PUT Request  remove=YES  what_remove=notification_types
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=INVALID_NOTIFICATION_TYPE        error_code=INVALID_NOTIFICATION_TYPE   field=notification_types
        ...     issue=This field must not be empty.   msg=notification_types is invalid.     remove_value=YES
    ELSE IF  '${error}'=='all options false'
        Sending PUT Request  boolean_daily=${false}  boolean_file=${false}  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED  with_body=YES
        ...     name=INVALID_NOTIFICATION_TYPE          error_code=INVALID_NOTIFICATION_TYPE
        ...     field=daily_summary or file_processing  issue=At least one field must be true.
        ...     msg=notification_types is invalid.      remove_value=YES
    ELSE IF  '${error}'=='invalid boolean'
        Sending PUT Request  boolean_daily=INVALID  boolean_file=INVALID  remove=YES  what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED
    END