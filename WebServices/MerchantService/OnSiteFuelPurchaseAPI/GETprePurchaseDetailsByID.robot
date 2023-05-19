*** Settings ***
Library     Collections
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment to START
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint GET to (see on-site PrePurchase details by ID)
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  OnSite_FuelPurchase  T-Check  ditOnly  GetPerchaseDetails

*** Variables ***
${db}  postgresmerchants

*** Test Cases ***
############################ OnSiteFuelPurchaseAPI ###############################
#--------------------------------------------------------------------------------#
#        Endpoint GET:  /merchants/{merchant_id}/purchases/{purchase_id}         #
#--------------------------------------------------------------------------------#
(OnSite Fuel Purchase API) GET - Testing to see Pre-Purchase details
    [Tags]              Q1:2023   Q2:2023   JIRA:O5SA-522   JIRA:O5SA-603   JIRA:O5SA-696   qTest:119066105
    [Documentation]     This is to test (GET endpoint) to see PrePurchase details using Purchase and Merchant IDs
    ...                 The API response should be 200 with PrePurchase details
    Use the GET endpoint to see Pre-Purchase details
    The API response should be 200 with a SUCCESSFULL message
    Compare the API response with the informations in the database

(OnSite Fuel Purchase API) GET ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]              Q1:2023   JIRA:O5SA-522   JIRA:O5SA-603   qTest:119066170
    [Documentation]     This is to test all EXPECTED ERRORS about the endpoint [GET Pre-Purchase details by ID]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Select a valid MERCHANT_ID and PURCHASE_ID to run the request
    [Documentation]  Use to find data of existents MERCHANT_ID and PRE_PURCHASE_ID inside the database
    Get into DB  ${db}
    ${query}    Catenate    select osm.merchant_id, pp.pre_purchase_id
    ...                     from pre_purchase pp
    ...                     inner join batch_history bh on (bh.batch_id = pp.batch_id)
    ...                     inner join on_site_merchants osm on (osm.merchant_id = bh.merchant_id)
    ...                     order by pre_purchase_id desc
    ...                     limit 20;
    ${finding_data}   query to dictionaries   ${query}
    Disconnect from Database

    ${finding_data}       Evaluate            random.choice(${finding_data})
    Set Suite Variable    ${merchant_ID}      ${finding_data}[merchant_id]
    Set Suite Variable    ${prePurchaseID}    ${finding_data}[pre_purchase_id]

Setup the environment to START
    Get URL For Suite    ${MerchantService}
    Select a valid MERCHANT_ID and PURCHASE_ID to run the request
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager  entity_id=${merchant_ID}
    ...             with_data=N  need_new_user=Y

Sending get request
    [Documentation]  Used to build a generic REQUEST structure of the endpoint (GET Pre-Purchase details by ID)
    [Arguments]      ${path}=${merchantID}/purchases/${prePurchaseID}
    ...              ${authorized}=Y  ${what_remove}=${NONE}

    ${path_url}      create dictionary   None=${path}
    ${result}   ${status}  Api request   GET  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    Set Test Variable      ${result}
    Set Test Variable      ${status}

Query to find pre_purchase details
    [Documentation]  Use to find "Pre_purchase details" data inside the database
    Get into DB  ${db}
    ${query}  Catenate  select bh.merchant_id, pp.*
    ...                 from pre_purchase pp
    ...                 inner join batch_history bh on (bh.batch_id = pp.batch_id)
    ...                 where pp.pre_purchase_id = '${prePurchaseID}' and bh.merchant_id = '${merchant_ID}';
    ${DB_PrePurchase}   query to dictionaries   ${query}
    Disconnect from Database
    Set Suite Variable  ${DB_PrePurchase}

###################################################### HAPPY PATH #####################################################
Use the GET endpoint to see Pre-Purchase details
    [Documentation]  Sending the request to OTR Merchant API to see Pre-Purchase details by ID
    Sending Get Request

Get data from each list|dictionary
    [Documentation]  Use that keyword to "convert list to dictionary" and to take those respectives "Dictionary keys"
    Query to find pre_purchase details

    ${keys}          Get Dictionary Keys    ${result}
    Set Suite Variable   ${keys}
    ${dic_details}   Convert To Dictionary  ${result}[details]
    ${keys_details}  Get Dictionary Keys    ${dic_details}
    Set Suite Variable   ${keys_details}
    ${dic_data}      Convert To Dictionary  ${result}[details][data]
    Set Suite Variable   ${dic_data}

    IF  '''${dic_data}'''!='{}'
        IF  '''${DB_PrePurchase}[0][prompts]'''!='''${NONE}'''
            ${dic_prompts}      Convert To Dictionary  ${result}[details][data][prompts][0]
            Set Suite Variable  ${dic_prompts}
        END
        IF  '''${DB_PrePurchase}[0][fuel_products]'''!='''${NONE}'''
            ${dic_fuel}         Convert To Dictionary  ${result}[details][data][fuel_products][0]
            Set Suite Variable  ${dic_fuel}
        END
        IF  '''${DB_PrePurchase}[0][merch_products]'''!='''${NONE}'''
            ${dic_merch}        Convert To Dictionary  ${result}[details][data][merch_products][0]
            Set Suite Variable  ${dic_merch}
        END
    END

The API response should be 200 with a SUCCESSFULL message
    [Documentation]  Cheking STATUS and DETAILS returned into the API response
    Get data from each list|dictionary

    Should Be Equal As Strings  ${status}                 200
    Should Be Equal             ${keys}[2]                name
    Should Be Equal As Strings  ${result}[name]           OK
    Should Be Equal             ${keys}[1]                message
    Should Be Equal As Strings  ${result}[message]        SUCCESSFUL
    Should Be Equal             ${keys}[0]                details
    Should Be Equal             ${keys_details}[1]        type
    Should Be Equal As Strings  ${result}[details][type]  PrePurchaseDTO
    Should Be Equal             ${keys_details}[0]        data

Compare the API response with the informations in the database
    [Documentation]  Comparing the fields returned in the API REPSONSE BODY with the database
    Query to find pre_purchase details

    Should Be Equal As Strings   ${DB_PrePurchase}[0][merchant_id]           ${merchant_ID}
    Should Be Equal As Integers  ${DB_PrePurchase}[0][pre_purchase_id]       ${prePurchaseID}
    Should Be Equal As Strings   ${DB_PrePurchase}[0][pre_purchase_status]   ${dic_data}[pre_purchase_status]
    Should Be Equal As Integers  ${DB_PrePurchase}[0][batch_id]              ${dic_data}[batch_id]

    IF  '${DB_PrePurchase}[0][card_id]'!='${NONE}'
        Should Be Equal As Integers  ${DB_PrePurchase}[0][card_id]  ${dic_data}[card_id]
    END
    IF  '${DB_PrePurchase}[0][carrier_id]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][carrier_id]  ${dic_data}[carrier_id]
    END
    IF  '${DB_PrePurchase}[0][carrier_name]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][carrier_name]  ${dic_data}[carrier_name]
    END
    IF  '${DB_PrePurchase}[0][pos_date]'!='${NONE}'
        ${dbDate_string}    Convert To String    ${DB_PrePurchase}[0][pos_date]
        ${apiDate_string}   Convert To String    ${dic_data}[pos_date]
        Should Not Be Empty    ${dbDate_string}
        Should Not Be Empty    ${apiDate_string}
    END
    IF  '${DB_PrePurchase}[0][update_date]'!='${NONE}'
        ${dbuUpdateDate_string}   Convert To String    ${DB_PrePurchase}[0][update_date]
        ${apiUpdateDate_string}   Convert To String    ${dic_data}[update_date]
        Should Not Be Empty    ${dbuUpdateDate_string}
        Should Not Be Empty    ${apiUpdateDate_string}
    END
    IF  '${DB_PrePurchase}[0][updated_by]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][updated_by]  ${dic_data}[updated_by]
        Should Not Be Empty  ${dic_data}[updated_by]
    END
    IF  '${DB_PrePurchase}[0][pos_offset]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][pos_offset]  ${dic_data}[pos_offset]
    END
    IF  '${DB_PrePurchase}[0][invoice_number]'!='${NONE}'
        Should Be Equal As Integers  ${DB_PrePurchase}[0][invoice_number]  ${dic_data}[invoice_number]
    END
    IF  '${DB_PrePurchase}[0][pre_auth_id]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][pre_auth_id]  ${dic_data}[pre_auth_id]
    END
    IF  '${DB_PrePurchase}[0][auth_code]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][auth_code]  ${dic_data}[auth_code]
    END
    IF  '${DB_PrePurchase}[0][location_id]'!='${NONE}'
        Should Be Equal As Integers  ${DB_PrePurchase}[0][location_id]  ${dic_data}[location_id]
    END
    IF  '${DB_PrePurchase}[0][location_name]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][location_name]  ${dic_data}[location_name]
    END
    IF  '${DB_PrePurchase}[0][total_amount]'!='${NONE}'
        Should Be Equal As Numbers  ${DB_PrePurchase}[0][total_amount]  ${dic_data}[total_amount]
    END
    IF  '${DB_PrePurchase}[0][sales_tax]'!='${NONE}'
        Should Be Equal As Numbers  ${DB_PrePurchase}[0][sales_tax]  ${dic_data}[sales_tax]
    END
    IF  '${DB_PrePurchase}[0][error_message]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][error_message]  ${dic_data}[error_message]
    END
    IF  '${DB_PrePurchase}[0][error_code]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][error_code]  ${dic_data}[error_code]
    END
    IF  '${DB_PrePurchase}[0][reject_reason]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][reject_reason]  ${dic_data}[reject_reason]
    END
    IF  '${DB_PrePurchase}[0][reject_code]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][reject_code]  ${dic_data}[reject_code]
    END
    IF  '${DB_PrePurchase}[0][correlation_id]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][correlation_id]  ${dic_data}[correlation_id]
    END
    IF  '${DB_PrePurchase}[0][location_country]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][location_country]  ${dic_data}[location_country]
    END
    IF  '${DB_PrePurchase}[0][policy_number]'!='${NONE}'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][policy_number]  ${dic_data}[policy_number]
    END

    #Checking Prompts list
    IF  '''${DB_PrePurchase}[0][prompts]'''!='''${NONE}'''
        Should Be Equal As Strings  ${DB_PrePurchase}[0][prompts][0][info_id]     ${dic_prompts}[info_id]
        Should Be Equal As Strings  ${DB_PrePurchase}[0][prompts][0][info_value]  ${dic_prompts}[info_value]
        Dictionary Should Contain Key  ${dic_prompts}  key=info_id
        Dictionary Should Contain Key  ${dic_prompts}  key=info_value
    END
    #Checking Fuel_products list
    IF  '''${DB_PrePurchase}[0][fuel_products]'''!='''${NONE}'''
        Should Be Equal As Numbers   ${DB_PrePurchase}[0][fuel_products][0][cost]        ${dic_fuel}[cost]
        Should Be Equal As Integers  ${DB_PrePurchase}[0][fuel_products][0][fuel_type]   ${dic_fuel}[fuel_type]
        Should Be Equal As Integers  ${DB_PrePurchase}[0][fuel_products][0][fuel_use]    ${dic_fuel}[fuel_use]
        Should Be Equal As Numbers   ${DB_PrePurchase}[0][fuel_products][0][ppu]         ${dic_fuel}[ppu]
        Should Be Equal As Numbers   ${DB_PrePurchase}[0][fuel_products][0][quantity]    ${dic_fuel}[quantity]
        Should Be Equal As Strings   ${DB_PrePurchase}[0][fuel_products][0][product_id]  ${dic_fuel}[product_id]
        Should Be Equal As Strings   ${DB_PrePurchase}[0][fuel_products][0][product_description]  ${dic_fuel}[product_description]
        Dictionary Should Contain Key  ${dic_fuel}  key=cost
        Dictionary Should Contain Key  ${dic_fuel}  key=fuel_type
        Dictionary Should Contain Key  ${dic_fuel}  key=fuel_use
        Dictionary Should Contain Key  ${dic_fuel}  key=ppu
        Dictionary Should Contain Key  ${dic_fuel}  key=quantity
        Dictionary Should Contain Key  ${dic_fuel}  key=product_id
        Dictionary Should Contain Key  ${dic_fuel}  key=product_description
    END
    #Checking Merch_products list
    IF  '''${DB_PrePurchase}[0][merch_products]'''!='''${NONE}'''
        Should Be Equal As Strings  ${DB_PrePurchase}[0][merch_products][0][product_id]        ${dic_merch}[product_id]
        Should Be Equal As Numbers  ${DB_PrePurchase}[0][merch_products][0][product_cost]      ${dic_merch}[product_cost]
        Should Be Equal As Numbers  ${DB_PrePurchase}[0][merch_products][0][product_quantity]  ${dic_merch}[product_quantity]
        Dictionary Should Contain Key  ${dic_merch}  key=product_cost
        Dictionary Should Contain Key  ${dic_merch}  key=product_id
        Dictionary Should Contain Key  ${dic_merch}  key=product_quantity
    END

################################################### EXPECTED ERRORS ###################################################
ERROR 404 - RESPONSE EXPECTED
    [Documentation]   Use to validade ERROR with status 404
    Should Be Equal As Strings   ${status}              404
    Should Be Equal As Strings   ${result}[status]      404
    Should Be Equal As Strings   ${result}[path]        /merchants/purchases/${prePurchaseID}
    Should Be Equal As Strings   ${result}[error]       Not Found
    Should Not Be Empty          ${result}[timestamp]

ERROR 400 - RESPONSE EXPECTED
    [Documentation]     Use to validade ERROR with status 400
    [Arguments]         ${with_body}=YES   ${msg}=Invalid request input   ${field}=${NONE}
    ...                 ${issue}=${NONE}   ${error_name}=BAD_REQUEST
    Should Be Equal As Strings      ${status}      400

    IF    '${with_body}'=='YES'
        Should Be Equal As Strings  ${result}[details][0][field]  ${field}
        Should Be Equal As Strings  ${result}[details][0][issue]  ${issue}
        Should Be Equal As Strings  ${result}[message]            ${msg}
        Should Be Equal As Strings  ${result}[name]               ${error_name}
    ELSE IF    '${with_body}'=='NO'
        Should Be Empty    ${result}
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests

    ${error_list}  Create List
    ...    MERCHANT Not Send        MERCHANT Invalid        MERCHANT Not assigned to the user
    ...    PRE_PURCHASE Not Send    PRE_PURCHASE Invalid    UNAUTHORIZED TOKEN

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    Select a valid MERCHANT_ID and PURCHASE_ID to run the request
    FOR  ${error}  IN  @{error_list}
         Add Test Case  (OnSite Fuel Purchase API) GET ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - MERCHANT ${error}
    [Documentation]  Testing the request URL with the field MERCHANT_ID (not send or using invalid string)
    IF  '${error}'=='Not Send'
        Sending Get Request  path=purchases/${prePurchaseID}
        ERROR 404 - RESPONSE EXPECTED
    ELSE IF  '${error}'=='Invalid'
        Sending Get Request  path=INVALID/purchases/${prePurchaseID}
        ERROR 400 - RESPONSE EXPECTED   with_body=NO
    ELSE IF  '${error}'=='Not assigned to the user'
        Sending Get Request  path=9999999/purchases/${prePurchaseID}
        Should Be Equal As Strings   ${status}  403
    END

ERROR - PRE_PURCHASE ${error}
    [Documentation]  Testing the request URL with the field PRE_PURCHASE_ID (not send or using invalid string)
    IF  '${error}'=='Not Send'
        Sending Get Request  path=${merchantID}/purchases
        Should Be Equal As Strings  ${status}  405
    ELSE IF  '${error}'=='Invalid'
        Sending Get Request  path=${merchantID}/purchases/INVALID
        ERROR 400 - RESPONSE EXPECTED   with_body=NO
    END

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Get Request   authorized=I
    IF    '${status}'=='401'
        Should Be Equal As Strings  ${status}  401
    ELSE
        Fail  TOKEN authorization validation failed
    END