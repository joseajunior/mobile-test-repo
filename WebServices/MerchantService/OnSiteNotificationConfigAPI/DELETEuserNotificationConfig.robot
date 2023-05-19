*** Settings ***
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setting up the environment
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint [DELETE an user notification config]
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  T-Check  ditOnly  OnSite_UserNotifConfig

*** Variables ***
${db}  postgresmerchants
${aplic}  Merchant Manager

*** Test Cases ***
########################## OnSite Notification Config API ###########################
#-----------------------------------------------------------------------------------#
#               Endpoint DELETE:  /merchants/notification/{user_id}                 #
#-----------------------------------------------------------------------------------#
(OnSite Notification Config API) DELETE - Testing to remove an user notification config
    [Tags]           Q2:2023   JIRA:O5SA-551   qTest:120534402
    [Documentation]  This is to test (DELETE endpoint) to remove an user notification config
    ...              The API response should be (200) with the user notification config removed from the database
    Use the DELETE endpoint to remove an user notification config
    The API response (status) should be 200
    Check if the "notification_config" record was removed from the database
    Check if the "notification_subscriptions" record was removed from the database

(OnSite Notification Config API) DELETE ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q2:2023   JIRA:O5SA-551   qTest:120534714
    [Documentation]  This is to test all EXPECTED ERRORS about [DELETE an user notification config] endpoint
    Create a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Setting up the environment
    [Documentation]  Use to connect with API URL, create a new automation user and create a respective notification
    ...              config by that user. This data will be used to run the tests
    Get URL For Suite    ${MerchantService}
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager  entity_id=${NONE}
    ...             with_data=N  need_new_user=Y
    Sending the POST request to insert a new User Notification Config

Query to find a valid merchant in the database
    [Documentation]  Use to find a valid MERCHANT_ID
    Get into DB  ${db}
        ${query}    Catenate    select merchant_id from on_site_merchants osm
        ...                     order by id desc limit 20;
        ${finding_data}  Query To Dictionaries  ${query}
        ${finding_data}  Evaluate  random.choice(${finding_data})
    Disconnect From Database
    Set Suite Variable  ${merchantID}   ${finding_data}[merchant_id]

Sending the POST request to insert a new User Notification Config
    [Documentation]  Used to build a generic endoint REQUEST structure [POST to create notification config]
    Query to find a valid merchant in the database

    ${path_url}      create dictionary   None=notification/${auto_user_id}
    @{email_list}          Create List   testDELETEautomation@test.com
    ${notific_type}  Create Dictionary   daily_summary=${true}      file_processing=${true}
    ${subscription}  Create Dictionary   merchant_id=${merchantID}  id_type=MERCHANT  notification_types=${notific_type}
    @{subscription_list}   Create List   ${subscription}
    ${payload}       create dictionary   email_list=@{email_list}   subscriptions=@{subscription_list}

    ${resp_P}  ${status_P}  Api request  POST  merchants  Y  ${path_url}  application=${aplic}  payload=${payload}
    Should Be Equal As Strings   ${status_P}  201

Sending delete request
    [Documentation]  Used to build a generic REQUEST structure to [DELETE an user notification config]
    [Arguments]      ${path}=${auto_user_id}  ${authorized}=Y

    ${path_url}      create dictionary   None=notification/${path}
    ${result}   ${status}  Api request   DELETE  merchants  ${authorized}  ${path_url}  application=${aplic}
    Set Test Variable      ${result}
    Set Test Variable      ${status}

###################################################### HAPPY PATH #####################################################
Use the DELETE endpoint to remove an user notification config
    [Documentation]  Sending the request to OTR Merchant API to remove an user notification config
    Sending delete request

The API response (status) should be 200
    [Documentation]  Cheking STATUS and others keys returned in the API response

    Should Be Equal As Strings  ${status}   200
    Should Be Equal As Strings  ${result}[name]  OK
    Should Be Equal As Strings  ${result}[message]  SUCCESSFUL
    Should Be Equal As Strings  ${result}[details][type]  NotificationConfigResponseDTO
    Should Be Equal As Strings  ${result}[details][data][user_id]   ${auto_user_id}
    Should Be Equal As Strings  ${result}[details][data][links][0][rel]   get_user_notification_config
    Should Not Be Empty         ${result}[details][data][links][0][href]

Query to find user notification "${table}" in the database
    [Documentation]  Use this keyword to select the data in the database
    IF  '${table.upper()}'=='CONFIG'
        ${conditional}  Catenate    notification_config
    ELSE IF  '${table.upper()}'=='SUBSCRIPTIONS'
        ${conditional}  Catenate    notification_subscriptions
    ELSE
        Fail    Invalid argument used
    END

    Get into DB  ${db}
        ${query}   Catenate  select * from ${conditional} where user_id = '${auto_user_id}'
        ${DB_user_notif_dicti}  Query To Dictionaries  ${query}
    Disconnect From Database
    Set Suite Variable    ${DB_user_notif_dicti}

Check if the "${table}" record was removed from the database
    [Documentation]  Use this keyword to validade if the USER NOTIFICATION (CONFIG) and (SUBSCRIPTION) was removed
    IF  '${table.upper()}'=='NOTIFICATION_CONFIG'
        Query to find user notification "config" in the database
        Should Be Equal As Strings    ${DB_user_notif_dicti}    []
    ELSE IF  '${table.upper()}'=='NOTIFICATION_SUBSCRIPTIONS'
        Query to find user notification "subscriptions" in the database
        Should Be Equal As Strings    ${DB_user_notif_dicti}    []
    ELSE
        Fail    Invalid argument used
    END

################################################### EXPECTED ERRORS ###################################################
ERROR ${error} - RESPONSE EXPECTED
    [Documentation]  Use to validade ERROR with status 404
    IF  '${error}'=='404'
        Should Be Equal As Strings   ${status}              404
        Should Be Equal As Strings   ${result}[status]      404
        Should Be Equal As Strings   ${result}[error]       Not Found
        Should Be Equal As Strings   ${result}[path]        /merchants/notification/
        Should Not Be Empty          ${result}[timestamp]
    ELSE IF  '${error}'=='400'
        Should Be Equal As Strings  ${status}  400
        Should Be Empty             ${result}
    ELSE IF  '${error}'=='401'
        Should Be Equal As Strings  ${status}  401
        Should Be Empty             ${result}
    ELSE IF  '${error}'=='403'
        Should Be Equal As Strings  ${status}  403
        Should Be Empty             ${result}
    END

Create a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests
    ${error_list}  Create List  USER_ID Not Send    USER_ID Invalid     USER_ID unauthorized    UNAUTHORIZED TOKEN

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (OnSite Notification Config API) DELETE ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - USER_ID ${error}
    [Documentation]  Testing the request URL
    ...              with the field USER_ID (not send, using invalid string, or with an USER_ID unauthorized)
    IF  '${error}'=='Not Send'
        Sending Delete Request  path=
        ERROR 404 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='Invalid'
        Sending Delete Request  path=INVALID
        ERROR 400 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='unauthorized'
        Get into DB  ${db}
            ${query}    Catenate    select * from notification_config where user_id <> '${auto_user_id}';
            ${user_unauthorized}    query to dictionaries   ${query}
        Disconnect From Database
        ${user_to_test}    Set Variable    ${user_unauthorized}[0][user_id]

        Sending Delete Request  path=${user_to_test}
        ERROR 403 - RESPONSE EXPECTED
    END

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Delete Request  authorized=I
    ERROR 401 - RESPONSE EXPECTED