*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the UserService API to replace the carriers from a user by user id (currently only works in dit because okta service is set up there)
Force Tags     userServiceAPI  API  ditOnly

Suite Setup  Prepare Environment And Data For Testing
Suite Teardown  Teardown

*** Test Cases ***
###################################################### Carriers ########################################################
PUT Replace List of Carriers User Can Manage With Only Valid Carriers
    [Documentation]  Test the PUT request to replace the carriers from a user
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:54766286  userService
    Change The Carriers Of A User
    Validate the Carriers Result  200  OK

PUT Replace List of Carriers User Can Manage With Invalid And Valid Carriers
    [Documentation]  Test the PUT request to replace the carriers from a user
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:54766286  userService
    Change The Carriers Of A User  payload=${with_invalid_carrier}
    Validate the Carriers Result  200  withInvalidCarrier

Try Replace Sending An Invalid Carrier ID
    [Documentation]  Try to replace the carriers of a user using a carrier ID that does not exist
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:56030990  userService
    @{carrier_list}  Create List  888888
    ${body}  Create Dictionary  entity_ids=@{carrier_list}  entity_type=CARRIER
    Change The Carriers Of A User  payload=${body}
    Validate the Carriers Result  200  ERROR

Try Replace Sending Letters As Carrier ID
    [Documentation]  Try to replace the carriers of a user using letters as carrier ID
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:56030990  userService
    @{carrier_list}  Create List  ABCDEF
    ${body}  Create Dictionary  entity_ids=@{carrier_list}  entity_type=CARRIER
    Change The Carriers Of A User  payload=${body}
    Validate the Carriers Result  200  ERROR

Try Replace Sending No Carrier IDs
    [Documentation]  Try to replace the carriers of a user using not sending any Carrier ID
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:56030990  userService
    @{carrier_list}  Create List
    ${body}  Create Dictionary  entity_ids=@{carrier_list}  entity_type=CARRIER
    Change The Carriers Of A User  payload=${body}
    Validate the Carriers Result  400  EMPTY

Try Replace Using An Invalid User ID
    [Documentation]  Try to replace the carriers of a user using a user ID that does not exist
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:56030990  userService
    Change The Carriers Of A User  user_id=an-attempt-invalid-user-id
    Validate the Carriers Result  400  INVALID

Try Replace Sending No User ID
    [Documentation]  Try to replace the carriers of a user using not sending user id
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:56030990  userService
    Change The Carriers Of A User  user_id=${EMPTY}
    Validate the Carriers Result  401


Try Replace Using An Invalid Token
    [Documentation]  Try to replace the carriers of a user using an invalid token
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:56030990  userService
    Get Pkce Token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
    Change The Carriers Of A User  change_secure=N
    Validate the Carriers Result  401

Try Replace Using A User Without Permissions
    [Documentation]  Try to replace the carriers of a user using a token that does not have the permission
    [Tags]           PI:13  JIRA:O5SA-218  JIRA:O5SA-109  qTest:56030990  userService
    Change The Carriers Of A User  username=${test_user_email}  password=${automated_user_password}
    Validate the Carriers Result  403

###################################################### Merchants #######################################################

PUT Replace List of Merchant User Can Manage With Only Valid Merchant
    [Documentation]  Test the PUT request to replace the merchants from a user with only valid merchants
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119822330  userService  API:Y
    Change The Merchants Of A User
    Validate the Merchants Result  200  OK

PUT Replace List of Merchant User Can Manage With Invalid And Valid Merchants
    [Documentation]  Test the PUT request to replace the merchants from a user
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823744  userService  API:Y
    Change The Merchants Of A User  payload=${with_invalid_merchant}
    Validate the Merchants Result  200  withInvalidMerchant

Try Replace Sending An Invalid merchant ID
    [Documentation]  Try to replace the merchants of a user using a merchant ID that does not exist
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823745  userService  API:Y
    @{merchant_list}  Create List  888888
    ${body}  Create Dictionary  entity_ids=@{merchant_list}  entity_type=MERCHANT
    Change The Merchants Of A User  payload=${body}
    Validate the Merchants Result  200  ERROR

Try Replace Sending Letters As Merchant ID
    [Documentation]  Try to replace the merchants of a user using letters as merchant ID
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823748  userService  API:Y
    @{merchant_list}  Create List  ABCDEF
    ${body}  Create Dictionary  entity_ids=@{merchant_list}  entity_type=MERCHANT
    Change The Merchants Of A User  payload=${body}
    Validate the Merchants Result  200  ERROR

Try Replace Sending No Merchant IDs
    [Documentation]  Try to replace the merchant of a user using not sending any merchant ID
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823750  userService  API:Y
    @{merchant_list}  Create List
    ${body}  Create Dictionary  entity_ids=@{merchant_list}  entity_type=MERCHANT
    Change The Merchants Of A User  payload=${body}
    Validate the Merchants Result  400  EMPTY

Try Replace Merchant Using An Invalid User ID
    [Documentation]  Try to replace the merchants of a user using a user ID that does not exist
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823751  userService  API:Y
    Change The Merchants Of A User  user_id=an-attempt-invalid-user-id
    Validate the Merchants Result  400  INVALID

Try Replace Merchant Sending No User ID
    [Documentation]  Try to replace the merchants of a user using not sending user id
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823753  userService  API:Y
    Change The Merchants Of A User  user_id=${EMPTY}
    Validate the Merchants Result  401

Try Replace Merchant Using An Invalid Token
    [Documentation]  Try to replace the carriers of a user using an invalid token
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823754  userService  API:Y
    Get Pkce Token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
    Change The Merchants Of A User  change_secure=N
    Validate the Merchants Result  401

Try Replace Merchant Using A User Without Permissions
    [Documentation]  Try to replace the carriers of a user using a token that does not have the permission
    [Tags]           Q1:2023  JIRA:O5SA-599  qtest:119823755  userService  API:Y
    Change The Merchants Of A User  username=${test_user_email}  password=${automated_user_password}
    Validate the Merchants Result  403


*** Keywords ***
Prepare Environment And Data For Testing
    [Tags]  qtest
    [Documentation]  Set the environment, get data, and creates the user
    Check For My Automation User
    Create My User  carrier_manager  with_data=N
    Create Data For Testing

Create Data For Testing
    [Tags]  qtest
    [Documentation]  Gathers the carriers and merchants to be used during the tests
    Create Data User

    ${carrier1}  Find Carrier in Oracle  A  carrierlimit=50  legacy_user=Y
    ${carrier2}  Find Carrier in Oracle  A  carrierlimit=40  legacy_user=Y
    ${carrier3}  Find Carrier in Oracle  A  carrierlimit=30  legacy_user=Y
    ${carrier4}  Find Carrier in Oracle  A  carrierlimit=20  legacy_user=Y
    ${carrier5}  Find Carrier in Oracle  A  carrierlimit=10  legacy_user=Y
    ${carrier6}  Set Variable  888888

    @{nest_carriers}  Create List  ${carrier1}  ${carrier2}  ${carrier3}
    ${carriers}  Create Dictionary  entity_ids=@{nest_carriers}  entity_type=CARRIER
    Set Suite Variable  ${all_good_carriers}  ${carriers}

    @{nest_carriers}  Create List  ${carrier4}  ${carrier5}  ${carrier6}
    ${carriers}  Create Dictionary  entity_ids=@{nest_carriers}  entity_type=CARRIER
    Set Suite Variable  ${with_invalid_carrier}  ${carriers}

    @{nest_carriers}  Create List  ${carrier4}  ${carrier5}
    ${with_invalid_comparison}  Create Dictionary  entity_ids=@{nest_carriers}  entity_type=CARRIER
    Set Suite Variable  ${with_invalid_comparison}

    ############################################################################################

    ${merchant1}  Find random merchant in postgres
    ${merchant2}  Find random merchant in postgres
    ${merchant3}  Find random merchant in postgres
    ${merchant4}  Find random merchant in postgres
    ${merchant5}  Find random merchant in postgres
    ${merchant6}  Set Variable  888888

    @{nest_merchants}  Create List  ${merchant1}  ${merchant2}  ${merchant3}
    ${merchants}  Create Dictionary  entity_ids=@{nest_merchants}  entity_type=MERCHANT
    Set Suite Variable  ${all_good_merchants}  ${merchants}

    @{nest_merchants}  Create List  ${merchant4}  ${merchant5}  ${merchant6}
    ${merchants}  Create Dictionary  entity_ids=@{nest_merchants}  entity_type=MERCHANT
    Set Suite Variable  ${with_invalid_merchant}  ${merchants}

    @{nest_merchants}  Create List  ${merchant4}  ${merchant5}
    ${with_invalid_merchant_comparison}  Create Dictionary  entity_ids=@{nest_merchants}  entity_type=MERCHANT
    Set Suite Variable  ${with_invalid_merchant_comparison}

Find random merchant in postgres
    [Tags]  qtest
    [Documentation]  Run the query select merchant_id from on_site_merchants order by random() limit 1; to get a random merchant
    get into db  postgresmerchants
    ${result}  query and strip  select merchant_id from on_site_merchants order by random() limit 1;
    disconnect from database
    [Return]  ${result}

Create Data User
    [Tags]  qtest
    [Documentation]  Create an user to be object in the test
    ${rand_string}  Generate Random String  10  [NUMBERS]
    ${test_user_email}  Catenate  robot+automationuser_otr_tester_two${rand_string}@wexinc.com
    Set Suite Variable  ${test_user_email}

    ${test_carrier}  Find Carrier in Oracle  A
    ${carrier_dict}  Create Dictionary    ${test_carrier}  Carrier Name

    ${payload}  Create Dictionary  first_name=robot  last_name=robot  email=${test_user_email}  cell_number=555555555
                                ...  persona_name=otr_tester_two  application_name=OTR_eMgr  password=T3stU$er
                                ...  entity_type=CARRIER  entity_id_name_map=${carrier_dict}

    ${result}  Create Automation User  payload=${payload}

    Set Suite Variable  ${test_user_id}  ${result}[details][data][id]

Change The Merchants Of A User
    [Tags]  qtest  expected_results:API should return a status code and a response body
    [Documentation]  Make a API request using the created User ID, and the applicable configuration of payload and body
    [Arguments]  ${user_id}=${test_user_id}  ${payload}=${all_good_merchants}  ${merchants}=${NONE}  ${app}=emgr  ${entity}=MERCHANT
            ...  ${change_secure}=Y  ${username}=${NONE}  ${password}=${NONE}
    ${application}  Find Application Information    ${app}
    ${application}  Set Variable    ${application}[0][app_name]
    ${status_code}  ${response_body}  Replace Entity From User    ${user_id}  ${merchants}  ${entity}  ${change_secure}
                                                           ...    ${username}  ${password}  ${application}  payload=${payload}

    Set Test Variable  ${status_code}
    Set Test Variable  ${response_body}

Change The Carriers Of A User
    [Documentation]  Make the request sending the User ID, the body request and make available the response body and status code
    [Arguments]  ${user_id}=${test_user_id}  ${payload}=${all_good_carriers}  ${carriers}=${NONE}  ${app}=emgr  ${entity}=CARRIER
            ...  ${change_secure}=Y  ${username}=${NONE}  ${password}=${NONE}
    ${application}  Find Application Information    ${app}
    ${application}  Set Variable    ${application}[0][app_name]
    ${status_code}  ${response_body}  Replace Entity From User    ${user_id}  ${carriers}  ${entity}  ${change_secure}
                                                           ...    ${username}  ${password}  ${application}  payload=${payload}

    Set Test Variable  ${status_code}
    Set Test Variable  ${response_body}

Validate the Carriers Result
    [Documentation]  Find the carriers of a User and compares with the list
    [Arguments]  ${status}  ${type}=${EMPTY}
    ${type}  String.Convert To Uppercase  ${type}

    IF  '${status}'=='200'
        ${pg_query}  Catenate  select entity_id from user_can_manage_entities_xref
                          ...  where entity_type = 'CARRIER'
                          ...  and user_id = '${test_user_id}';
        Get Into DB  postgrespgusers
        ${query_results}  Query And Return Dictionary Rows  ${pg_query}
        Disconnect From Database
        ${query_results}  Evaluate  [int(d['entity_id']) for d in ${query_results}]

        Should Be Equal As Strings  ${status_code}  200
        IF  '${type}'=='OK'
            Should Contain  ${response_body}[details][data]  acceptEntityIdList
            Should Not Contain  ${response_body}[details][data]  rejectEntityIdList
            Lists Should Be Equal  ${query_results}  ${all_good_carriers}[entity_ids]
        ELSE IF  '${type}'=='WITHINVALIDCARRIER'
            Should Contain  ${response_body}[details][data]  rejectEntityIdList
            Should Contain  ${response_body}[details][data]  acceptEntityIdList
            Lists Should Be Equal  ${query_results}  ${with_invalid_comparison}[entity_ids]
        ELSE IF  '${type}'=='ERROR'
            Should Contain  ${response_body}[details][data]  rejectEntityIdList
            Should Not Contain  ${response_body}[details][data]  acceptEntityIdList
        ELSE
            Fail  ${type} not implemented for status code 200
        END
    ELSE IF  '${status}'=='400'
        Should Be Equal As Strings  ${status_code}  400
        IF  '${type}'=='INVALID'
            Should Be Equal  ${response_body}[name]  NOT_FOUND_USER
            Should Be Equal  ${response_body}[error_code]  NOT_FOUND_USER
            Should Be Equal  ${response_body}[message]  User does not exist
        ELSE IF  '${type}'=='EMPTY'
            Should Be Equal  ${response_body}[name]  BAD_REQUEST
            Should Be Equal  ${response_body}[details][0][field]  entityIds
            Should Be Equal  ${response_body}[details][0][value]  []
            Should Be Equal  ${response_body}[details][0][issue]  entityIds are required
            Should Be Equal  ${response_body}[message]  Invalid request input
        ELSE
            Fail  ${type}  not implemented for status code 400
        END
    ELSE IF  '${status}'=='401'
        Should Be Equal As Strings  ${status_code}  401
        Should Be Empty  ${response_body}
    ELSE IF  '${status}'=='403'
        Should Be Equal As Strings  ${status_code}  403
        Should Be Empty  ${response_body}
    ELSE
        Fail  ${status} status code not implemented
    END

Validate the Merchants Result
    [Tags]  qtest  expected_results:status from API should be 200
    [Documentation]  Validate fields returned by the API
    [Arguments]  ${status}  ${type}=${EMPTY}
    ${type}  String.Convert To Uppercase  ${type}

    IF  '${status}'=='200'
        ${pg_query}  Catenate  select entity_id from user_can_manage_entities_xref
                          ...  where entity_type = 'MERCHANT'
                          ...  and user_id = '${test_user_id}';
        Get Into DB  postgrespgusers
        ${query_results}  Query And Return Dictionary Rows  ${pg_query}
        Disconnect From Database
        ${query_results}  Evaluate  [int(d['entity_id']) for d in ${query_results}]

        Should Be Equal As Strings  ${status_code}  200
        IF  '${type}'=='OK'
            Should Contain  ${response_body}[details][data]  acceptEntityIdList
            Should Not Contain  ${response_body}[details][data]  rejectEntityIdList
            Lists Should Be Equal  ${query_results}  ${all_good_merchants}[entity_ids]
        ELSE IF  '${type}'=='WITHINVALIDMERCHANT'
            Should Contain  ${response_body}[details][data]  rejectEntityIdList
            Should Contain  ${response_body}[details][data]  acceptEntityIdList
            Lists Should Be Equal  ${query_results}  ${with_invalid_merchant_comparison}[entity_ids]
        ELSE IF  '${type}'=='ERROR'
            Should Contain  ${response_body}[details][data]  rejectEntityIdList
            Should Not Contain  ${response_body}[details][data]  acceptEntityIdList
        ELSE
            Fail  ${type} not implemented for status code 200
        END
    ELSE IF  '${status}'=='400'
        Should Be Equal As Strings  ${status_code}  400
        IF  '${type}'=='INVALID'
            Should Be Equal  ${response_body}[name]  NOT_FOUND_USER
            Should Be Equal  ${response_body}[error_code]  NOT_FOUND_USER
            Should Be Equal  ${response_body}[message]  User does not exist
        ELSE IF  '${type}'=='EMPTY'
            Should Be Equal  ${response_body}[name]  BAD_REQUEST
            Should Be Equal  ${response_body}[details][0][field]  entityIds
            Should Be Equal  ${response_body}[details][0][value]  []
            Should Be Equal  ${response_body}[details][0][issue]  entityIds are required
            Should Be Equal  ${response_body}[message]  Invalid request input
        ELSE
            Fail  ${type}  not implemented for status code 400
        END
    ELSE IF  '${status}'=='401'
        Should Be Equal As Strings  ${status_code}  401
        Should Be Empty  ${response_body}
    ELSE IF  '${status}'=='403'
        Should Be Equal As Strings  ${status_code}  403
        Should Be Empty  ${response_body}
    ELSE
        Fail  ${status} status code not implemented
    END

Remove Created Users
    [Tags]  qtest
    [Documentation]  Remove the Users created for the test if the suite is finished
    ${test_user_exist}  Get Variable Value  $test_user_id  default
    IF  $test_user_exist!='default'
        Delete Automation User  ${test_user_id}
    END
    Remove User if Still Exists

Teardown
    Remove Created Users
    Disconnect from database