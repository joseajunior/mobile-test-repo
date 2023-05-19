*** Settings ***
Library   String
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Resource  otr_robot_lib/robot/JSONAuthAPIKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setting up the environment to Start
Suite Teardown  Remove User if Still Exists

Force Tags      API  preAuthRun  MerchantServiceAPI  T-Check  OnSite_FuelPurchase  ditOnly
Documentation   This is to test the endpoint [POST to run a pre-auth for an OnSite fuel purchase using the JsonAuth API
...             as bridge]. OTR - Merchant Service API is responsable to manage operations available for merchants
...             URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

*** Variables ***
${DB_postgree}  postgresmerchants
${DB_informix}  TCH

*** Test Cases ***
############################## OnSiteFuelPurchaseAPI ################################
#-----------------------------------------------------------------------------------#
#         Endpoint POST:  /merchants/{merchant_id}/purchases/pre-auth               #
#-----------------------------------------------------------------------------------#
(OnSiteFuel Purchase API) POST - Testing the Pre-Auth Endpoint Using Mandatories fields in the request
    [Documentation]  Test case to validate the java Pre-Auth endpoint response using just the mandatory fields
    [Tags]           Q2:2023  JIRA:O5SA-525  JIRA:O5SA-686  qTest:118662836
    [Setup]     Make the necessary settings to run a transaction
    Use POST endpoint to execute a pre-auth "With Mandatory Fields"
    Check the data returned in the response of MERCHANT SERVICE API
    Compare the data returned between (MERCHANT API x JSONAUTH API)
    [Teardown]  Restore the settings made to the initial state

(OnSiteFuel Purchase API) POST - Testing the field META [ ] available in the request body of the Pre-Auth Endpoint
    [Documentation]  This is to test PRE-AUTH endpoint with field META [ ] informed in the request body
    ...              The meta [ ] field is someting not relevant, so, this is not required and depends on a feature flag
    ...              PROGVAL = O5SB-243 | PROGNAME = transactionMetaArguments to display informations on the response
    [Tags]           Q2:2023  JIRA:O5SA-525  JIRA:O5SA-661  qTest:120561663
    [Setup]     Make the necessary settings to run a transaction
    Set The Feature Flag "transactionMetaArguments" for "O5SB-243" As "Y" on the "${DB_informix}" instance
    Use POST endpoint to execute a pre-auth "With Mandatory and META [ ] fields"
    Check the data returned in the response of MERCHANT SERVICE API
    Compare the data returned between (MERCHANT API x JSONAUTH API)  meta_informed=${TRUE}
    Set The Feature Flag "transactionMetaArguments" for "O5SB-243" As "N" on the "${DB_informix}" instance
    [Teardown]  Restore the settings made to the initial state

*** Keywords ***
Setup - Turn the flag CARD_LOCK = OFF
    [Documentation]    Turning the FLAG OFF and removing the flag CARD_LOCK by the card's CARRIER selected
    Set The Feature Flag "OptionalCardLock" for "AUTH-1545" As "N" on the "${DB_informix}" instance
    Delete "CARD_LOCK" Flag On the MEMBER_META table for carrier ID "${carrierID}" In The "${DB_informix}" Instance
    Get into DB  ${DB_informix}
        Execute SQL String  dml=update cards set card_lock_date = null where card_num='${cardNum}';
    Disconnect From Database

Setting up the environment to Start
    [Documentation]    Keyword that will find data and setup the environment to execute the test cases
    Looking for data of "CARD WITH PROMPTS" to use with PRE-AUTH transactions

    ${merchant_to_use}  Generate The Merchant_ID
    Set Suite Variable  ${merchant_to_use}

    ${invoice_number}   Generate The Invoice
    Set Suite Variable  ${invoice_number}

    ${today}            Generate The Pos_time
    Set Suite Variable  ${today}

    Create My User  persona_name=merchant_onsite_fuel_manager   application_name=Merchant Manager
    ...             entity_id=${merchant_to_use}  with_data=N   need_new_user=Y

Query to find data on [on_site_merchants] table
    [Documentation]  Use this keyword to execute a query to find data at (on_site_merchants) table
    Get Into Db      ${DB_postgree}
        ${query}   Catenate   select * from on_site_merchants osm where card_id ='${cardID}'
        ${on_site_merchants_count}  Row Count  ${query}  ${DB_postgree}
        ${on_site_merchants_query}  Query To Dictionaries    ${query}
    Disconnect From Database
    Set Suite Variable  ${on_site_merchants_query}
    Set Suite Variable  ${on_site_merchants_count}

Query to find merchant and location details
    [Documentation]  Use this keyword to execute a query to find data to INSERT on (on_site_merchants) table
    Get Into Db      ${DB_informix}
        ${query}     Catenate    select company_id as merchant_id, m.name as merchant_name, l.name as location_name
        ...                      from location l
        ...                      join member m  on company_id = member_id
        ...                      where company_id in (select member_id from member where mem_type = 'Y' and status = 'A')
        ...                      and company_id is not null and company_id <> 0 and l.location_id = '${locationID}';
        ${merchANDloc_dictionary}   query to dictionaries   ${query}
    Disconnect From Database
    Set Suite Variable    ${merchantID}     ${merchANDloc_dictionary}[0][merchant_id]
    Set Suite Variable    ${merchantNAME}   ${merchANDloc_dictionary}[0][merchant_name]
    Set Suite Variable    ${locationNAME}   ${merchANDloc_dictionary}[0][location_name]

Query to preAuth details
    [Documentation]  Use this keyword to execute a query to find data on (preauth_transaction) table
    Get Into Db      ${DB_informix}
        ${query}     Catenate   select * from preauth_transaction
        ...                     where preauth_id = '${response}[details][data][preauth_id]';
        ${db_info}   Query To Dictionaries    ${query}
    Disconnect From Database
    Set Suite Variable  ${db_info}

Query to find card entry mode
    [Documentation]  Use this keyword to execute a query to find the card entry mode on (cards) table
    ${query}     Catenate    select card_id, handenter from cards where card_id = '${card_id}';
    ${entry_mode}  Query To Dictionaries   ${query}
    Set Suite Variable  ${entry_mode_bkp}  ${entry_mode}[0][handenter]

${action} Entry Mode of the selected card
    [Documentation]  Use to change the card entry mode type
    Get Into Db      ${DB_informix}

    IF  '${action.upper()}'=='ACTIVE HAND'
        Query to find card entry mode
        Execute sql string  dml=update cards set handenter = 'Y' where card_id = '${card_id}';
    ELSE IF  '${action.upper()}'=='RESTORE'
        Execute sql string  dml=update cards set handenter = '${entry_mode_bkp}' where card_id = '${card_id}';
    END
    Disconnect From Database

Make the necessary settings to run a transaction
    [Documentation]    Use this keyword to make the necessary settings to run a transaction successfully
    Active Hand Entry Mode of the selected card
    Set contract [sec_threshold] to use "1"
    Setup - Turn the flag CARD_LOCK = OFF

Restore the settings made to the initial state
    [Documentation]    Use this keyword to restore the settings made before to the initial state
    Restore location used in the "CARD NORMAL" to origin value
    Restore Entry Mode of the selected card
    Setup - Turn the flag CARD_LOCK = OFF

Use POST Endpoint to insert data on [on_site_merchants] table
    [Documentation]  Use this keyword to use the POST endpoint to INSERT data on (on_site_merchants) table
    Get URL For Suite  ${merchantservice}

    Create My User  persona_name=merchant_admin  application_name=Merchant Manager  entity_id=${NONE}
    ...              with_data=N  need_new_user=Y
    ${path_url}  Create Dictionary  None=on-site-merchants
    ${payload}   Create Dictionary  merchant_id=${merchantID}  merchant_name=${merchantNAME}  location_id=${locationID}
    ...                             location_name=${locationNAME}  card_id=${cardID}  carrier_id=${carrierID}

    ${result_insert}  ${status_insert}  Api request   POST  merchants  Y  ${path_url}  application=Merchant Manager
    ...                                               payload=${payload}
    Should Be Equal As Strings  ${status_insert}  201
    Remove Automation User

Generate The ${value}
    [Documentation]    Keyword to generate or select random values for (invoice, quantity, ppu, pos_time, merchant_id)
    IF    '${value.upper()}'=='INVOICE'
        ${random_invoice}  Generate Random String    length=6  chars=[NUMBERS]
        ${return}  Convert To Integer  ${random_invoice}
    ELSE IF    '${value.upper()}'=='QUANTITY'
        ${return}  Evaluate    round(random.uniform(1, 10), 0)
    ELSE IF    '${value.upper()}'=='PPU'
        ${return}  Evaluate    round(random.uniform(0.5, 7.5), 3)
    ELSE IF    '${value.upper()}'=='POS_TIME'
        ${date}    Get Current Date  result_format=%Y-%m-%d
        ${time}    Get Current Date  result_format=%H:%M:%S
        ${return}  Catenate    ${date}T${time}Z
    ELSE IF    '${value.upper()}'=='MERCHANT_ID'
        Query to find data on [on_site_merchants] table
        IF  '${on_site_merchants_count}'=='0'
            Query to find merchant and location details
            Use POST Endpoint to insert data on [on_site_merchants] table
            Query to find data on [on_site_merchants] table
            ${return}  Catenate  ${on_site_merchants_query}[0][merchant_id]
        ELSE
            ${return}  Catenate  ${on_site_merchants_query}[0][merchant_id]
        END
    ELSE IF  '${value.upper()}'=='X_USER_ID'
        ${return}  Evaluate  str(uuid.uuid4())[:-6]  uuid
    ELSE IF  '${value.upper()}'=='X_CORRELATION_ID'
        ${return}  Evaluate  str(uuid.uuid4())[:-6]  uuid
    ELSE
        Fail  There is no '${value}' option to generate a value
    END
    [Return]    ${return}

Sending post pre-auth for an OnSite Fuel purchase
    [Documentation]    Keyword that makes generic request to run a pre-auth for an OnSite Fuel Purchase
    [Arguments]        ${card}=${cardID}  ${location}=${locationID}  ${invoice}=${invoice_number}  ${postime}=${today}
    ...                ${meta}=${NONE}    ${what_remove}=${NONE}
    Get URL For Suite  ${merchantservice}

    ${endpoint}      Create Dictionary   None=${merchant_to_use}/purchases/pre-auth
    ${request_body}  Create Dictionary
    ...         card_id=${card}  location_id=${location}  invoice_number=${invoice}  pos_time=${postime}  meta=${meta}

    ${response}  ${status}  API Request  POST  merchants  Y  ${endpoint}  application=Merchant Manager  payload=${request_body}

    IF  ${what_remove}!=${NONE}
        FOR  ${remove}  IN   @{what_remove}
            Remove From Dictionary  ${request_body}  ${remove.lower()}
        END
    END

    Set Suite Variable    ${response}
    Set Suite Variable    ${status}
    Set Suite Variable    ${request_body}

Use POST endpoint to execute a pre-auth "${size}"
    [Documentation]  This keyword send the request body based in the argument informed
    ...              With that, we can send the request with different fields
    IF  '${size.upper()}'=='WITH MANDATORY FIELDS'
        @{fields_to_remove}   Create List  meta
        Sending post pre-auth for an OnSite Fuel purchase  what_remove=@{fields_to_remove}
    ELSE IF  '${size.upper()}'=='WITH MANDATORY AND META [ ] FIELDS'
        @{meta_list}    Create List    policy
        Sending post pre-auth for an OnSite Fuel purchase  meta=@{meta_list}
    ELSE
        Fail    Not a valid option
    END

Use POST Endpoint To Run A Pre-Auth using the JSONAUTH Request
    [Documentation]    Keyword that makes generic request to run a pre-auth using the JSONAUTH API
    ...                and set the response and status as suite variables

    ${correlation_id}  Generate The X_CORRELATION_ID
    ${user_id}         Generate The X_USER_ID
    ${header}          Create Dictionary    x-correlation-id=${correlation_id}  x-user-id=${user_id}
    ${url_stuff}       Create Dictionary    None=pre-auth

    Get URL For Suite    ${JsonAuthAPI}
    ${jsonResponse}  ${jsonStatus}  API Request  POST  transactions  N  ${url_stuff}  header=${header}
    ...                                          payload=${request_body}
    Set Suite Variable    ${jsonResponse}
    Set Suite Variable    ${jsonStatus}
    Should Be Equal As Strings  ${jsonStatus}    200

Check the data returned in the response of MERCHANT SERVICE API
    [Documentation]  This keyword will validate the java API response using the JsonAuth response and information
    ...              from the database
    Query to preAuth details

    Should Be Equal As Strings    ${status}                                      200
    Should Be Equal As Strings    ${response}[name]                              OK
    Should Be Equal As Strings    ${response}[message]                           SUCCESSFUL
    Should Be Equal As Strings    ${response}[details][type]                     AuthResponseDTO
    Should Be Equal As Strings    ${response}[details][data][preauth_id]         ${db_info}[0][preauth_id]
    Should Be Equal As Strings    ${response}[details][data][invoice_number]     ${invoice_number}
    Should Be Equal As Strings    ${response}[details][data][auth_code]          ${db_info}[0][auth_code]

    ${location_offset_seconds}    Convert To String    ${response}[details][data][location_offset_seconds]
    Should Not Be Empty           ${location_offset_seconds}
    Should Be Equal As Strings    ${response}[details][data][location_id]        ${locationID}
    Should Not Be Empty           ${response}[details][data][pos_time_utc]

    Should Be Equal As Strings    ${response}[details][data][links][0][rel]   purchase_pre_auth
    Should Not Be Empty           ${response}[details][data][links][0][href]

Compare the data returned between (MERCHANT API x JSONAUTH API)
    [Documentation]  This keyword will validate the data returned in (MERCHANT API x JSONAUTH API)
    [Arguments]    ${meta_informed}=${FALSE}
    Use POST Endpoint To Run A Pre-Auth using the JSONAUTH Request

    IF  '''${jsonResponse}[prompts]'''!='@{EMPTY}'
        FOR  ${dict}  IN  @{jsonResponse}[prompts]
            Remove From Dictionary    ${dict}  is_suppressed
            Remove From Dictionary    ${dict}  is_extended
        END
        Lists Should Be Equal    ${jsonResponse}[prompts]  ${response}[details][data][prompts]
    END

    IF  '''${jsonResponse}[fuel_products]'''!='@{EMPTY}'
        ${status0}  Run Keyword And Return Status    Dictionary Should Contain Value    ${response}[details][data][fuel_products][0]  ${8192}
        IF  ${status0}
            Should Be Equal As Strings    ${response}[details][data][fuel_products][0][fuel_type]  8192
        END
        ${status0}  Run Keyword And Return Status    Dictionary Should Contain Value    ${response}[details][data][fuel_products][0]  ${4194304}
        ${status1}  Run Keyword And Return Status    Dictionary Should Contain Value    ${response}[details][data][fuel_products][1]  ${4194304}
        IF  ${status0} or ${status1}
            ${position}  Evaluate  next((index for (index, d) in enumerate($response['details']['data']['fuel_products']) if d["fuel_type"] == "4194304"), None)
            Should Contain Any    ${position}  0  1
        END
        FOR  ${dict}  IN  @{response}[details][data][fuel_products]
            Remove From Dictionary    ${dict}  priority
        END
        @{javaList}  Evaluate  sorted($response['details']['data']['fuel_products'], key=lambda d: d['fuel_type'])
        @{jsonList}  Evaluate  sorted($jsonResponse['fuel_products'], key=lambda d: d['fuel_type'])
        Lists Should Be Equal    ${javaList}  ${jsonList}
    END

    IF  '''${jsonResponse}[merch_products]'''!='@{EMPTY}'
        Lists Should Be Equal    ${jsonResponse}[merch_products]  ${response}[details][data][merch_products]
    END

    IF  '''${jsonResponse}[transaction_limit]'''!='@{EMPTY}'
        Should Be Equal As Strings    ${response}[details][data][transaction_limit]  ${jsonResponse}[transaction_limit]
    END

    IF  '''${jsonResponse}[location_country]'''!='@{EMPTY}'
        Should Be Equal As Strings    ${response}[details][data][location_country]  ${jsonResponse}[location_country]
    END

    IF  ${meta_informed}!=${FALSE}
        IF  '''${jsonResponse}[meta]'''!='@{EMPTY}'
            Lists Should Be Equal    ${jsonResponse}[meta]  ${response}[details][data][meta]
        END
    END