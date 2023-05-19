*** Settings ***
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment to START
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint [POST for Admin request like adding an On-site-merchant record]
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  T-Check  ditOnly

*** Variables ***
${db}  postgresmerchants

*** Test Cases ***
(Admin Merchant API) POST - Testing to add an On-Site-Merchant Record
    [Tags]              Q1:2023   JIRA:O5SA-597   qTest:119286118   AdminMerchantAPI
    [Documentation]     This is to test (POST endpoint) to add an On-Site-Merchant record
    ...                 The API response should be 201 with an ID

    Use The POST Endpoint To Find Locations For A Merchant
    Compare the API response with the informations in the response body and the database

(Admin Merchant API) POST - Testing to add an On-Site-Merchant Record EXPECTED ERRORS
    [Tags]              Q1:2023   JIRA:O5SA-597   qTest:119328439    AdminMerchantAPI
    [Documentation]     This is to test all EXPECTED ERRORS about the endpoint [POST On-Site-Merchant record]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Connect to the API URL
    Get URL For Suite    ${MerchantService}

Query to find merchants data
    [Documentation]     Use to find "merchants" data
    Get into DB     TCH
    ${query}    Catenate    select company_id as merchant_id, m.name as merchant_name, location_id,
     ...                           l.name as location_name
     ...                    from location l  join member m  on company_id = member_id
     ...                    where company_id in (select member_id from member where mem_type = 'Y' and status = 'A')
     ...                    and company_id is not null
     ...                    and company_id <> 0
     ...                    order by l.created desc limit 500;

    ${finding_merchant_data}    query to dictionaries   ${query}
    Disconnect from Database

    ${finding_merchant_data}    Evaluate    random.choice(${finding_merchant_data})
    Set Suite Variable          ${finding_merchant_data}

Query to find carrier data
    [Documentation]     Use to find "Carrier" data
    Get into DB     TCH
    ${query}    Catenate    select cc.card_num, c.card_id, c.carrier_id
    ...                     from cards c
    ...                     join mobile_fuel_config cc on (cc.card_num = c.card_num)
    ...                     where c.status = 'A' limit 500;

    ${finding_carrier_data}     query to dictionaries   ${query}
    Disconnect from Database

    ${finding_carrier_data}     Evaluate    random.choice(${finding_carrier_data})
    Set Suite Variable          ${finding_carrier_data}

Authorize the user for selected MERCHANT_ID
    [Documentation]     Use to create and authorize the user

    Create My User      persona_name=merchant_admin  application_name=Merchant Manager  entity_id=${NONE}
    ...                 with_data=N  need_new_user=Y

Select a valid Data to run the request
    [Documentation]     Looking for MERCHANT_ID available to use during the request
    Query to find merchants data
    Query to find carrier data


Setup the environment to START
    Connect to the API URL
    Select a valid Data to run the request
    Authorize the user for selected MERCHANT_ID

Sending Post request
    [Documentation]     Used to build a generic REQUEST structure of the endpoint (POST On-Site-Merchant record)
    [Arguments]         ${path}=on-site-merchants
    ...                 ${authorized}=Y  ${remove}=NO  ${what_remove}=${NONE}
    ...                 ${merchant}=${finding_merchant_data}[merchant_id]
    ...                 ${m_name}=${finding_merchant_data}[merchant_name]
    ...                 ${location}=${finding_merchant_data}[location_id]
    ...                 ${loc_name}=${finding_merchant_data}[location_name]
    ...                 ${card}=${finding_carrier_data}[card_id]
    ...                 ${carrier}=${finding_carrier_data}[carrier_id]
    ...                 ${with_payload}=YES

    ${path_url}         create dictionary   None=${path}

    ${payload}  Create Dictionary   merchant_id=${merchant}
    ...                             merchant_name=${m_name}
    ...                             location_id=${location}
    ...                             location_name=${loc_name}
    ...                             card_id=${card}
    ...                             carrier_id=${carrier}

    IF  '${remove.upper()}'=='YES'
       Remove From Dictionary      ${payload}   ${what_remove.lower()}
    END


    IF      '${with_payload.upper()}'=='YES'
        ${response}   ${status}  Api request   POST  merchants  ${authorized}  ${path_url}  application=Merchant Manager
        ...                                    payload=${payload}
    ELSE IF  '${with_payload.upper()}'=='NO'
        ${response}   ${status}  Api request   POST  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    END

    Set Test Variable       ${payload}
    Set Test Variable       ${response}
    Set Test Variable       ${status}

###################################################### HAPPY PATH #####################################################
Use the POST endpoint to find locations for a merchant
    [Documentation]     Sending the request to OTR Merchant API

    Sending Post Request

Query to validate the information entered in the database
    [Documentation]     Use to find locations available for a merchant in the database
    Get into DB     ${db}
    ${query}        Catenate  select id , merchant_name, card_id, location_id, carrier_id, merchant_id, location_name
    ...                       from on_site_merchants
    ...                       where id=${response}[details][data][id];

    ${on_site_merchants}      query to dictionaries     ${query}
    Disconnect from Database

    Set Test Variable         ${on_site_merchants}

Compare the API response with the informations in the response body and the database
    [Documentation]  Comparing the fields returned in the API REPSONSE BODY and the information entered in the database

    Query to validate the information entered in the database

    Should Be Equal As Strings          ${status}                            201
    Should Be Equal As Strings          ${response}[name]                    CREATED
    Should Be Equal As Strings          ${response}[message]                 SUCCESSFUL
    Should Be Equal As Strings          ${response}[details][type]           OnSiteMerchantsResponseDTO
    Should Be Equal As Strings          ${response}[details][data][id]       ${on_site_merchants}[0][id]

    Should Be Equal As Strings          ${payload}[merchant_id]              ${on_site_merchants}[0][merchant_id]
    Should Be Equal As Strings          ${payload}[merchant_name]            ${on_site_merchants}[0][merchant_name]
    Should Be Equal As Strings          ${payload}[location_id]              ${on_site_merchants}[0][location_id]
    Should Be Equal As Strings          ${payload}[location_name]            ${on_site_merchants}[0][location_name]
    Should Be Equal As Strings          ${payload}[card_id]                  ${on_site_merchants}[0][card_id]
    Should Be Equal As Strings          ${payload}[carrier_id]               ${on_site_merchants}[0][carrier_id]

################################################### EXPECTED ERRORS ###################################################
ERROR 400 - RESPONSE EXPECTED
    [Documentation]     Use to validade ERROR with status 400
    [Arguments]         ${with_body}=YES   ${msg}=${NONE}   ${field}=${NONE}
    ...                 ${issue}=${NONE}   ${error_name}=${NONE}
    Should Be Equal As Strings       ${status}      400

    IF    '${with_body}'=='YES'
        ${result}   Get Dictionary Keys   ${response}

        Should Be Equal As Strings          ${response}[name]                    ${error_name}
        Should Be Equal As Strings          ${response}[details][0][field]       ${field}
        Should Be Equal As Strings          ${response}[details][0][issue]       ${issue}
        Should Be Equal As Strings          ${response}[message]                 ${msg}
    ELSE IF    '${with_body}'=='NO'
        Pass Execution    Without body details
    END

ERROR 409 - RESPONSE EXPECTED
    [Documentation]     Use to validade ERROR with status 409
    [Arguments]         ${with_body}=YES   ${error_name}=${NONE}    ${error_cod}=${NONE}
    ...                  ${msg}=${NONE}

    Should Be Equal As Strings       ${status}      409

    IF    '${with_body}'=='YES'
        ${result}   Get Dictionary Keys   ${response}

        Should Be Equal As Strings          ${response}[name]                    ${error_name}
        Should Be Equal As Strings          ${response}[error_code]              ${error_cod}
        Should Be Equal As Strings          ${response}[message]                 ${msg}
    ELSE IF    '${with_body}'=='NO'
        Pass Execution    Without body details
    END

ERROR 422 - RESPONSE EXPECTED
    [Documentation]     Use to validade ERROR with status 422
    [Arguments]         ${with_body}=YES   ${error_name}=${NONE}    ${error_cod}=${NONE}
    ...                  ${msg}=${NONE}

    Should Be Equal As Strings       ${status}      422

    IF    '${with_body}'=='YES'
        ${result}   Get Dictionary Keys   ${response}

        Should Be Equal As Strings          ${response}[name]                    ${error_name}
        Should Be Equal As Strings          ${response}[error_code]              ${error_cod}
        Should Be Equal As Strings          ${response}[message]                 ${msg}
    ELSE IF    '${with_body}'=='NO'
        Pass Execution    Without body details
    END

ERROR 500 - RESPONSE EXPECTED
    [Documentation]     Use to validade ERROR with status 500
    [Arguments]         ${with_body}=YES   ${error_name}=${NONE}    ${error_cod}=${NONE}    ${issue}=${NONE}
    ...                  ${msg}=${NONE}

    Should Be Equal As Strings       ${status}      500

    IF    '${with_body}'=='YES'
        ${result}   Get Dictionary Keys   ${response}

        Should Be Equal As Strings          ${response}[name]                    ${error_name}
        Should Be Equal As Strings          ${response}[error_code]              ${error_cod}
        Should Be Equal As Strings          ${response}[details][0][issue]       ${issue}
        Should Be Equal As Strings          ${response}[message]                 ${msg}
    ELSE IF    '${with_body}'=='NO'
        Pass Execution    Without body details
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests

    ${error_list}  Create List
    ...    Carrier_ID Not Send      Carrier_ID Invalid      Card_ID Not Send        CARD_ID Invalid
    ...    Location_ID Not Send     Location_ID Invalid     Merchant_Id Not Send    Merchant_Id Invalid
    ...    Request With No Body     UNAUTHORIZED TOKEN      Merchant_Id Already Exists
    ...    Card_id Does Not Belong to carrier_ID            Value Too Long For Type Character Varying

    ${test_to_run}     Evaluate    dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (POST on-site-merchant) POST ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - Merchant_Id ${error}
    [Documentation]     Testing the request URL with the field MERCHANT_ID (not send or using invalid string)

    IF  '${error}'=='Not Send'
        Sending Post Request  remove=YES    what_remove=merchant_id
        ERROR 400 - RESPONSE EXPECTED   with_body=NO
    ELSE IF  '${error}'=='Invalid'
        Sending Post Request  merchant=9001706      location=521667
        ERROR 422 - RESPONSE EXPECTED   with_body=YES   error_name=INVALID_MERCHANT_ID  error_cod=INVALID_MERCHANT_ID
        ...                                             msg=Merchant Id is invalid.
    END

ERROR - CARD_ID ${error}
    [Documentation]     Testing the request BODY with the field CARD_ID (not send or using invalid string)
    IF  '${error}'=='Not Send'
        Sending Post Request  remove=YES    what_remove=card_id
        ERROR 400 - RESPONSE EXPECTED   with_body=NO
    ELSE IF  '${error}'=='Invalid'
        Sending Post Request   card=10000000029560
        ERROR 422 - RESPONSE EXPECTED   with_body=YES   error_name=INVALID_CARD_ID  error_cod=INVALID_CARD_ID
        ...                                             msg=Invalid card id
    END

ERROR - Carrier_ID ${error}
    [Documentation]     Testing the request BODY with the field Carrier_ID (not send or using invalid string)
    IF  '${error}'=='Not Send'
        Sending Post Request  remove=YES    what_remove=carrier_id
        ERROR 400 - RESPONSE EXPECTED   with_body=YES       with_body=YES   error_name=BAD_REQUEST      field=carrierId
        ...        issue=must not be empty  msg=Invalid request input
    ELSE IF  '${error}'=='Invalid'
        Sending Post Request  carrier=10000045      card=1000000002956
        ERROR 422 - RESPONSE EXPECTED   with_body=YES   error_name=INVALID_CARRIER_ID
        ...        error_cod=INVALID_CARRIER_ID  msg=The provided carrier_id is invalid.
    END

ERROR - LOCATION_ID ${error}
    [Documentation]     Testing the request BODY with the field LOCATION_ID (not send or using invalid string)
    IF  '${error}'=='Not Send'
        Sending Post Request  remove=YES    what_remove=location_id
        ERROR 400 - RESPONSE EXPECTED   with_body=NO
    ELSE IF  '${error}'=='Invalid'
        Sending Post Request  location=521667
        ERROR 422 - RESPONSE EXPECTED   with_body=YES   error_name=NOT_FOUND_LOCATION_OR_MERCHANT
        ...     error_cod=NOT_FOUND_LOCATION_OR_MERCHANT    msg=No location found for that location id and merchant id
    END

ERROR - Request With No Body
    [Documentation]     Testing the request WITHOUT Body
    Sending Post Request  with_payload=NO

    IF    '${status}'=='400'
          ERROR 400 - RESPONSE EXPECTED   with_body=NO
    ELSE
        Fail  Request With No Body validation failed
    END

ERROR - UNAUTHORIZED TOKEN
    [Documentation]     Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE

    Sending Post Request  authorized=I

    IF    '${status}'=='401'
        Should Be Equal As Strings  ${status}  401
        Pass Execution  Unauthorized
    ELSE
        Fail  TOKEN authorization validation failed
    END

ERROR - Card_id Does Not Belong to carrier_ID
    [Documentation]     Testing the request With a card that not belong to carrier
    Sending Post Request  carrier=100045  card=1000000328838

    IF    '${status}'=='422'
        Should Be Equal As Strings  ${status}  422
        ERROR 422 - RESPONSE EXPECTED   with_body=YES   error_name=CARD_AND_CARRIER_MISMATCH
        ...                          error_cod=CARD_AND_CARRIER_MISMATCH     msg=Card id does not belong to carrier id
    ELSE
        Fail  Card_id Does Not Belong to carrier_ID validation failed
    END

ERROR - Value Too Long For Type Character Varying
    [Documentation]     Testing the request with a value too long (more than 100 characters) on Merchant Name
    Sending Post Request
 ...    m_name=rafael_test1teteteteteteteteteteteteeteteteteteteteteteteteteteteteetetetetetetetetetetetetetetetetetetee

  IF    '${status}'=='500'
        Should Be Equal As Strings  ${status}  500
        ERROR 500 - RESPONSE EXPECTED   with_body=YES   error_name=ONSITE_MERCHANT_SAVE_FAILED
        ...    error_cod=ONSITE_MERCHANT_SAVE_FAILED    issue=ERROR: value too long for type character varying(100)
        ...     msg=Failed to save on-site merchant record
  ELSE
        Fail  Value Too Long For Type Character Varying validation failed
  END

ERROR - Merchant_Id Already Exists
    [Documentation]     Testing the request try to send the same information that is already exist in the
    ...                 On-Site Merchants table.

  Sending Post Request  carrier=100045    merchant=901706     location=521669    card=1000000002956
  ...     loc_name=ESSO RED DEER     m_name=random name rafael_test1

  IF    '${status}'=='409'
        Should Be Equal As Strings  ${status}  409
        ERROR 409 - RESPONSE EXPECTED   with_body=YES   error_name=ON_SITE_RECORD_EXISTS
        ...                             error_cod=ON_SITE_RECORD_EXISTS    msg=On-Site Merchant already exists
  ELSE
        Fail  Merchant_Id Already Exists validation failed
  END