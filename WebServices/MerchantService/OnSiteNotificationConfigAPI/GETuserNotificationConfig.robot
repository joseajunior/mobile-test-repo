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

Documentation  This is to test the endpoint [GET notification config for an specific user]
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  T-Check  ditOnly  OnSite_UserNotifConfig

*** Variables ***
${db}  postgresmerchants
${json_invalid}  [{"invalid": "test"}]

*** Test Cases ***
########################## OnSite Notification Config API ###########################
#-----------------------------------------------------------------------------------#
#              Endpoint GET:  /merchants/notification/{user_id}                     #
#-----------------------------------------------------------------------------------#
(OnSite Notification Config API) GET - Testing to find details of [EXISTING - MERCHANT] user notification config
    [Tags]           Q1:2023    Q2:2023   JIRA:O5SA-548   JIRA:O5SA-630   qTest:119300042
    [Documentation]  This is to test (GET endpoint) to find details about an EXISTENT MERCHANT notification config
    ...              The API response should be (200) with notification config displayed
    [Setup]     Create "MERCHANT" User Notification Config
    Use the GET endpoint to see "MERCHANT" notification config for an specific user
    The API response should be "200 - with User Config Notification displayed" by "MERCHANT"
    Compare the "MERCHANT" user config notification returned in the API response with DB records
    [Teardown]  Sending delete request to remove data generated To Request

(OnSite Notification Config API) GET - Testing to find details of [EXISTING - LOCATION] user notification config
    [Tags]           Q1:2023    Q2:2023   JIRA:O5SA-548   JIRA:O5SA-630   qTest:119300042
    [Documentation]  This is to test (GET endpoint) to find details about an EXISTENT LOCATION notification config
    ...              The API response should be (200) with notification config displayed
    [Setup]     Create "LOCATION" User Notification Config
    Use the GET endpoint to see "LOCATION" notification config for an specific user
    The API response should be "200 - with User Config Notification displayed" by "LOCATION"
    Compare the "LOCATION" user config notification returned in the API response with DB records
    [Teardown]  Sending delete request to remove data generated To Request

(OnSite Notification Config API) GET - Testing to find details about an [NONEXISTENTING] user notification config
    [Tags]           Q1:2023    Q2:2023   JIRA:O5SA-548   JIRA:O5SA-630   qTest:119300042
    [Documentation]  This is to test (GET endpoint) to find details about an UNON-EXISTENT notification config
    ...              The API response should be (204) without detail
    Use The GET Endpoint To See "MERCHANT" Notification Config For An Specific User
    The API response should be "204 - without details" by "MERCHANT"

(OnSite Notification Config API) GET ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q1:2023    Q2:2023   JIRA:O5SA-548  JIRA:O5SA-630   qTest:119301989
    [Documentation]  This is to test all EXPECTED ERRORS about [GET notification config for an specific user] endpoint
    [Setup]    Create "MERCHANT" User Notification Config
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Create "${type}" User Notification Config
    [Documentation]    Use to find valid MERCHANT_ID and LOCATION_ID
    ...                Use to ADD "User Notification Config" data to the respective USER selected
    IF  '${type}'=='MERCHANT'
         Query to find a valid "MERCHANT_ID" in the database
         Sending post request  merchant=${merchant_valid}  remove=YES  what_remove=location_id
    ELSE IF  '${type}'=='LOCATION'
         Query to find a valid "LOCATION_ID" in the database
         Sending post request  location=${location_valid}  remove=YES  what_remove=merchant_id
    END

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

Sending post request
    [Documentation]  Used to build a generic endoint REQUEST structure [POST to create notification config]
    [Arguments]      ${boolean_daily}=${true}  ${boolean_file}=${true}  ${merchant}=${NONE}  ${location}=${NONE}
    ...              ${type}=${respective_type}  ${remove}=NO  ${what_remove}=${NONE}

    ${path_url}           create dictionary   None=notification/${auto_user_id}
    @{email_list}         Create List         testGETautomation@test.com
    ${notification_type}  Create Dictionary   daily_summary=${boolean_daily}  file_processing=${boolean_file}
    ${subscription}       Create Dictionary   merchant_id=${merchant}  location_id=${location}  id_type=${type}
    ...                                       notification_types=${notification_type}
    @{subscription_list}  Create List         ${subscription}
    ${payload}       create dictionary   email_list=@{email_list}  subscriptions=@{subscription_list}

    IF  '${remove.upper()}'=='YES'
        Remove From Dictionary  ${payload}            ${what_remove.lower()}
        Remove From Dictionary  ${notification_type}  ${what_remove.lower()}
        Remove From Dictionary  ${subscription}       ${what_remove.lower()}
    END

    ${result_post}   ${status_post}  Api request  POST  merchants  Y  ${path_url}  application=Merchant Manager
    ...                                           payload=${payload}
    Should Be Equal As Strings    ${status_post}  201

Sending get request
    [Documentation]  Used to build a generic REQUEST structure to [GET notification config for an specific user]
    [Arguments]      ${path}=notification/${auto_user_id}  ${authorized}=Y
    ${path_url}      create dictionary   None=${path}
    ${result}   ${status}  Api request   GET  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    Set Test Variable      ${result}
    Set Test Variable      ${status}

Sending delete request to remove data generated To Request
    [Documentation]  Use to REMOVE data to the respective USER selected inside the tables
    ...              [notification_subscriptons] and [notification_config] using the DELETE endpoint
    ${path_url}      create dictionary   None=notification/${auto_user_id}
    ${result_delete}  ${status_delete}  Api request   DELETE  merchants  Y  ${path_url}  application=Merchant Manager
    Should Be Equal As Strings     ${status_delete}   200

###################################################### HAPPY PATH #####################################################
Use the GET endpoint to see "${type}" notification config for an specific user
    [Documentation]  Sending the request to OTR Merchant API to see notification config for an specific user
    Sending Get Request

The API response should be "${response_expected}" by "${field}"
    [Documentation]  Cheking STATUS and User Config Notifications details into the API response

    IF  '${response_expected}'=='200 - with User Config Notification displayed'
        Should Be Equal As Strings  ${status}   200
        Should Be Equal As Strings  ${result}[name]     OK
        Should Be Equal As Strings  ${result}[message]      SUCCESSFUL
        Should Be Equal As Strings  ${result}[details][type]    NotificationConfigDTO
        Should Be Equal As Strings  ${result}[details][data][links][0][rel]     post_user_notification_config
        Should Not Be Empty         ${result}[details][data][links][0][href]

        #   checking keys inside [details]
        ${keys_details}   Get Dictionary Keys  ${result}[details]
        Should Be Equal   ${keys_details}[0]   data
        Should Be Equal   ${keys_details}[1]   type

        #   checking keys inside [data]
        ${keys_data}      Get Dictionary Keys  ${result}[details][data]
        Should Be Equal   ${keys_data}[2]      subscriptions
        Should Be Equal   ${keys_data}[1]      links
        Should Be Equal   ${keys_data}[0]      email_list

        #   checking keys inside [subscriptions]
        ${subscriptions_index_0}   Get From List             ${result}[details][data][subscriptions]  0
        List Should Contain Value  ${subscriptions_index_0}  id_type
        List Should Contain Value  ${subscriptions_index_0}  notification_types
        IF  '${field}'=='MERCHANT'
            List Should Contain Value  ${subscriptions_index_0}  merchant_id
            List Should Contain Value  ${subscriptions_index_0}  merchant_name
        ELSE IF  '${field}'=='LOCATION'
            List Should Contain Value  ${subscriptions_index_0}  location_id
            List Should Contain Value  ${subscriptions_index_0}  location_name
        END

        #   checking keys inside [notification_type]
        ${notification_type_keys}  Get Dictionary Keys  ${result}[details][data][subscriptions][0][notification_types]
        Should Be Equal     ${notification_type_keys}[0]  daily_summary
        Should Be Equal     ${notification_type_keys}[1]  file_processing
    ELSE IF  '${response_expected}'=='204 - without details'
        Should Be Equal As Strings  ${status}  204
    END

Query to find user config notifications
    [Documentation]  Use to find user config notifications in the database
    Get into DB  ${db}
        ${query}  Catenate    select nc.user_id as user_id, nc.email_list as email_list,
        ...                   ns.subscriptions as subscriptions, ns.id_type as id_type
        ...                   from notification_subscriptions ns
        ...                   join notification_config nc on (nc.user_id = ns.user_id)
        ...                   where nc.user_id ='${auto_user_id}';
        ${user_notif_resultDB}  query to dictionaries   ${query}
    Disconnect from Database
    Set Suite Variable  ${user_notif_resultDB}

Query to find respective '${field}' name
    [Documentation]  Use to find more details about MERCHANT and LOCATION name

    IF  '${field}'=='MERCHANT'
        ${columns}  Catenate    merchant_name
        ${id}       Set Variable    ${API_merchant_0}
        ${field}    Catenate    merchant_id
    ELSE IF    '${field}'=='LOCATION'
        ${columns}  Catenate    location_name
        ${id}       Set Variable    ${API_loc_0}
        ${field}    Catenate    location_id
    END

    Get into DB  ${db}
        ${query}  Catenate    select ${columns} as name
        ...                   from on_site_merchants
        ...                   where ${field}='${id}';
        ${names_DB}  query to dictionaries   ${query}
    Disconnect from Database
    ${names_DB}  String.Convert To Upper Case   ${names_DB}[0][name]
    Set Suite Variable  ${names_DB}

Compare the "${field}" user config notification returned in the API response with DB records
    [Documentation]  Comparing the fields returned in the API REPSONSE BODY with the database
    Query to find user config notifications

    #checking and saving variables of API SUBSCRIPTIONS list fields
    ${subscriptions_index_0}  Get From List   ${result}[details][data][subscriptions]  0
    IF  '${field}'=='MERCHANT'
         Set Test Variable  ${API_merchant_0}  ${subscriptions_index_0}[merchant_id]
         ${API_merchant_name_0}  String.Convert To Upper Case  ${subscriptions_index_0}[merchant_name]
         Set Test Variable  ${API_merchant_name_0}
    ELSE IF  '${field}'=='LOCATION'
         Set Test Variable  ${API_loc_0}       ${subscriptions_index_0}[location_id]
         ${API_loc_name_0}  String.Convert To Upper Case  ${subscriptions_index_0}[location_name]
         Set Test Variable  ${API_loc_name_0}
    END
    Set test Variable  ${API_notif_types_0}   ${result}[details][data][subscriptions][0][notification_types]

    #Compare the API fields with the database records
    IF  '''${user_notif_resultDB}[0][email_list]'''!='''${NONE}'''
        Should Be Equal As Strings   ${auto_user_id}                           ${user_notif_resultDB}[0][user_id]
        Should Be Equal As Strings   ${result}[details][data][email_list]      ${user_notif_resultDB}[0][email_list]
        Should Be Equal As Strings   ${result}[details][data][links][0][rel]   post_user_notification_config
    END

    IF  '''${user_notif_resultDB}[0][subscriptions]'''!='''${NONE}'''
        Should Be Equal As Strings  ${subscriptions_index_0}[id_type]  ${user_notif_resultDB}[0][id_type]
        IF  '${field}'=='MERCHANT'
            Query to find respective 'MERCHANT' name
            Should Be Equal As Strings  ${API_merchant_0}       ${user_notif_resultDB}[0][subscriptions][merchant_id]
            Should Not Be Empty    ${API_merchant_name_0}
        ELSE IF  '${field}'=='LOCATION'
            Query to find respective 'LOCATION' name
            Should Be Equal As Strings  ${API_loc_0}       ${user_notif_resultDB}[0][subscriptions][location_id]
            Should Not Be Empty    ${API_loc_name_0}
        END
    END

    #checking fields inside NOTIFICATION_TYPE
    set test variable  ${DB_notif_types}   ${user_notif_resultDB}[0][subscriptions][notification_types]
    Should Be Equal As Strings    ${API_notif_types_0}[daily_summary]     ${DB_notif_types}[daily_summary]
    Should Be Equal As Strings    ${API_notif_types_0}[file_processing]   ${DB_notif_types}[file_processing]

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

ERROR [INTERNAL SERVER ERROR] - RESPONSE EXPECTED [500]-"${msg}"
    [Documentation]  Use to validade ERROR with status 500 [INTERNAL SERVER ERROR]
    IF  '${msg}'=='FAILED SUBSCRIPTIONS'
        ${message}  Catenate   Failed to parse subscriptions.
    ELSE IF   '${msg}'=='FAILED EMAIL LIST'
        ${message}  Catenate   Failed to parse email list.
    END

    Should Be Equal As Strings  ${status}           500
    Should Be Equal As Strings  ${result}[name]     INTERNAL_SERVER_ERROR
    Should Be Equal As Strings  ${result}[message]  ${message}

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests

    ${error_list}  Create List
    ...    USER_ID Not Send      USER_ID Invalid      USER_ID unauthorized      UNAUTHORIZED TOKEN
    ...    PARSE JSON IN THE FIELD "subscriptions"    PARSE JSON IN THE FIELD "email_list"

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (OnSite Notification Config API) GET ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - USER_ID ${error}
    [Documentation]  Testing the request URL with the field USER_ID (not send, using invalid string, or with an USER_ID
    ...              unauthorized)
    IF  '${error}'=='Not Send'
        Sending Get Request  path=notification/
        ERROR 404 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='Invalid'
        Sending Get Request  path=notification/INVALID
        ERROR 400 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='unauthorized'
        Get into DB  ${db}
            ${query}    Catenate    select * from notification_config where user_id <> '${auto_user_id}';
            ${user_unauthorized}    query to dictionaries   ${query}
        Disconnect From Database
        ${user_to_test}    Set Variable    ${user_unauthorized}[0][user_id]

        Sending Get Request  path=notification/${user_to_test}
        ERROR 403 - RESPONSE EXPECTED
    END

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Get Request   authorized=I
    ERROR 401 - RESPONSE EXPECTED

ERROR - PARSE JSON IN THE FIELD "${field}"
    [Documentation]  Testing the request trying to "PARSE" de JSON fields

    Get into DB  ${db}
    IF  '${field}'=='subscriptions'
        Execute sql string  dml=update notification_subscriptions set subscriptions='${json_invalid}' where user_id='${auto_user_id}';
        Sending Get Request
        ERROR [INTERNAL SERVER ERROR] - RESPONSE EXPECTED [500]-"FAILED SUBSCRIPTIONS"
    ELSE IF  '${field}'=='email_list'
        Execute sql string  dml=update notification_config set email_list='${json_invalid}' where user_id='${auto_user_id}';
        Sending Get Request
        ERROR [INTERNAL SERVER ERROR] - RESPONSE EXPECTED [500]-"FAILED EMAIL LIST"
    END
    Disconnect From Database