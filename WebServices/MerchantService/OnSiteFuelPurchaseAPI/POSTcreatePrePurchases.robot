*** Settings ***
Library     String
Library     Collections
Library     DateTime
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setting up the environment
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint POST to (create on-site PrePurchase fuel transaction)
...            OTR - Merchant Service API is responsable to manage operations available for merchants
...            URL: (https://merchantservice.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  MerchantServiceAPI  OnSite_FuelPurchase  T-Check  ditOnly  CreatePurchase

*** Variables ***
${db}  postgresmerchants
${error_issue_null}   must not be null
${error_issue_empty}  must not be empty
${fuel_productID}   ${NONE}
${merch_productID}  ${NONE}
${infoID}  ${NONE}

*** Test Cases ***
############################## OnSiteFuelPurchaseAPI ################################
#-----------------------------------------------------------------------------------#
#             Endpoint POST:  /merchants/{merchant_id}/purchases                    #
#-----------------------------------------------------------------------------------#
(OnSite Fuel Purchase API) POST - Testing the Pre-Purchase creation with "all" fields informed
    [Tags]           Q1:2023   Q2:2023   JIRA:O5SA-514   JIRA:O5SA-603   JIRA:O5SA-652   JIRA:O5SA-688   qTest:118992837
    [Documentation]  This is to test [POST Pre-Purchase creation] using "all" fields informed in the request body.
    ...              In that case the values for PROMPTS and PRODUCTS (FUEL|MERCH) will be get from the REDIS CACHE.
    ...              The API response should be 201 with BATCH_ID|PURCHASE_ID created, and data should be stored in DB
    Select PRODUCTS from REDIS using DataCatalog API
    Select PROMPTS from REDIS using DataCatalog API
    Use the POST endpoint to create Pre-Purchase "with all fields informed"
    The API response should be 201 with the BATCH_ID and PRE_PURCHASE_ID created displayed
    Verify BATCH_ID returned with the stored data at [BATCH_HISTORY] table in the database
    Verify "ALL" fields informed with the stored data at [PRE-PURCHASE] table in the database

(OnSite Fuel Purchase API) POST - Testing the Pre-Purchase creation just with "mandatory" fields informed
    [Tags]           Q1:2023   Q2:2023   JIRA:O5SA-514   JIRA:O5SA-603   JIRA:O5SA-652   JIRA:O5SA-688   qTest:118992837
    [Documentation]  This is to test [POST Pre-Purchase creation] using "mandatory" fields informed in the request body.
    ...              The currently mandatories fields are (card_id, pos_date, invoice_number, location_id, total_amount)
    ...              The API response should be 201 with BATCH_ID|PURCHASE_ID created, and data should be stored in DB
    Use the POST endpoint to create Pre-Purchase "using just mandatory fields informed"
    The API response should be 201 with the BATCH_ID and PRE_PURCHASE_ID created displayed
    Verify BATCH_ID returned with the stored data at [BATCH_HISTORY] table in the database
    Verify "MANDATORY" fields informed with the stored data at [PRE-PURCHASE] table in the database

(OnSite Fuel Purchase API) POST ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q1:2023  Q2:2023  JIRA:O5SA-514  JIRA:O5SA-603  JIRA:O5SA-652  JIRA:O5SA-688  qTest:118993276
    [Documentation]  This is to test all EXPECTED ERRORS about the endpoint [POST Pre-Purchase creation]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Query to find merchants available
    [Documentation]  Use to find "merchants" available to use inside the database
    Get into DB  ${db}
    ${query}    Catenate    select merchant_id from on_site_merchants
    ...                     group by merchant_id limit 10;
    ${finding_data}   query to dictionaries   ${query}
    Disconnect from Database

    ${finding_data}     Evaluate        random.choice(${finding_data})
    Set Suite Variable  ${merchantID}   ${finding_data}[merchant_id]

Query to find related card and location
    [Documentation]  Use to find "card_id" and "location_id" releated with the merchant_id selected
    Get into DB  ${db}
    ${query}    Catenate    select card_id, location_id, carrier_id
    ...                     from on_site_merchants
    ...                     where merchant_id = ${merchantID} limit 10;
    ${finding_data2}   query to dictionaries   ${query}
    Disconnect from Database

    ${finding_data2}    Evaluate       random.choice(${finding_data2})
    Set Suite Variable  ${locationID}  ${finding_data2}[location_id]
    Set Suite Variable  ${cardID}      ${finding_data2}[card_id]
    Set Suite Variable  ${carrierID}   ${finding_data2}[carrier_id]

Setting up the environment
    [Documentation]  Setting up the API URL, creating and authorizing the user, selecting the data to execute the request
    ...              (Looking for MERCHANT_ID, CARD_ID and LOCATION_ID valid and releated to use during the request)
    Query to find merchants available
    Query to find related card and location

    Create My User   persona_name=merchant_onsite_fuel_manager  application_name=Merchant Manager
    ...              entity_id=${merchantID}  with_data=N  need_new_user=Y

    Create a random INVOICE_NUMBER to REQUEST BODY's fields
    Create a DATE to REQUEST BODY's fields

Select ${ITEM} from REDIS using DataCatalog API
    [Documentation]  Use to find available PRODUCTS (MERCH|FUEL) and PROMPTS from REDIS CACHE
    ...              NOTES : FUEL_PRODUCTS (isFuel = True) and MERCH_PRODUCTS (isFuel = False)
    IF  '${ITEM}'=='PRODUCTS'
        Sending get "products" request
        ${products}  Set Variable  ${get_response_json}[details][data]

        FOR  ${count}   IN RANGE  0   5
            ${random_product}  Evaluate  random.choice(${products})
            IF  '${random_product}[is_fuel]'=='true'
                 Set Suite Variable  ${fuel_productID}    ${random_product}[product_id]
                 Set Suite Variable  ${fuel_productDESC}  ${random_product}[product_description]
            ELSE IF  '${random_product}[is_fuel]'=='false'
                 Set Suite Variable  ${merch_productID}    ${random_product}[product_id]
                 Set Suite Variable  ${merch_productDESC}  ${random_product}[product_description]
            END
        END
    ELSE IF  '${ITEM}'=='PROMPTS'
        Sending get "prompts" request
        ${prompts}  Set Variable  ${get_response_json}[details][data]

        ${random_prompt}  Evaluate  random.choice(${prompts})
        Set Suite Variable   ${infoID}   ${random_prompt}[prompt_code]
        Set Suite Variable  ${infoVALUE}  TEST
    END

Sending get "${what}" request
    [Documentation]  Generic REQUEST structure of the endpoint (GET products and prompts) from DataCatalog API
    ...              Using this API is necessary because, PRODUCTS and PROMPTS should be search at REDIS CACHE
    Get URL For Suite    ${DataCatalog}
    ${path_url}  Create Dictionary  None=${what}
    ${result}    ${status}   Api request   GET  data-catalogs  AI  ${path_url}
    Should Be Equal As Strings    ${status}  200
    Set Test Variable  ${get_response_json}  ${result}

Create a random INVOICE_NUMBER to REQUEST BODY's fields
    [Documentation]   Use this keyword to create a INTEGER random INVOICE_NUMBER
    ${invoice_random_string}   Generate Random String  length=7  chars=[NUMBERS]
    ${invoice_random}   Convert To Integer  ${invoice_random_string}
    Set Suite Variable  ${invoice_random}

Create a DATE to REQUEST BODY's fields
    [Documentation]  Use to CREATE information of DATE's to use inside (POS_DATE) during the requests
     ${date}   Get Current Date  result_format=%Y-%m-%d
     ${time}   Get Current Date  result_format=%H:%M:%S
     ${today}  Catenate    ${date}T${time}
     Set Suite Variable  ${today}

Sending post request
    [Documentation]  It will be used to build a generic REQUEST structure of the endpoint (POST to create Pre-Purchase)
    ...              MERCHANT_ID, CARD_ID, LOCATION_ID should be related an existents in [on_site_merchants] table
    [Arguments]  ${path}=${merchantID}/purchases
    ...          ${authorized}=Y           ${what_remove}=${NONE}
    ...          ${card_id}=${cardID}      ${location_id}=${locationID}            ${invoice_number}=${invoice_random}
    ...          ${pos_date}=${today}      ${total_amount}=2.00                    ${sales_tax}=${NONE}
    ...          ${info_id}=${NONE}        ${info_value}=${NONE}
    ...          ${quantity}=${NONE}       ${ppu}=${NONE}          ${cost}=${NONE}          ${fuel_product_id}=${NONE}
    ...          ${product_cost}=${NONE}   ${product_id}=${NONE}   ${product_quantity}=${NONE}

    Get URL For Suite  ${MerchantService}
    ${path_url}        create dictionary  None=${path}

    ${prompts}         Create Dictionary  info_id=${info_id}     info_value=${info_value}
    @{prompts_list}          Create List  ${prompts}

    ${fuel_products}   Create Dictionary  quantity=${quantity}  ppu=${ppu}  cost=${cost}  product_id=${fuel_product_id}
    @{fuel_products_list}    Create List  ${fuel_products}

    ${merch_products}  Create Dictionary  product_cost=${product_cost}   product_quantity=${product_quantity}
    ...                                   product_id=${product_id}
    @{merch_products_list}   Create List  ${merch_products}

    ${payload}  Create Dictionary
    ...         card_id=${card_id}         location_id=${location_id}             invoice_number=${invoice_number}
    ...         pos_date=${pos_date}       total_amount=${total_amount}           sales_tax=${sales_tax}
    ...         prompts=@{prompts_list}    fuel_products=@{fuel_products_list}    merch_products=@{merch_products_list}

    IF  ${what_remove}!=${NONE}
        FOR  ${remove}  IN   @{what_remove}
            Remove From Dictionary  ${payload}         ${remove.lower()}
            Remove From Dictionary  ${prompts}         ${remove.lower()}
            Remove From Dictionary  ${fuel_products}   ${remove.lower()}
            Remove From Dictionary  ${merch_products}  ${remove.lower()}
        END
    END

    ${result}   ${status}  Api request   POST  merchants  ${authorized}  ${path_url}  application=Merchant Manager
    ...                                  payload=${payload}

    Set Test Variable  ${result}
    Set Test Variable  ${status}
    Set Test Variable  ${payload}

###################################################### HAPPY PATH #####################################################
Use the POST endpoint to create Pre-Purchase "${detail}"
    [Documentation]  Sending the request to OTR Merchant API to create a Pre-Purchase

    IF  '${detail}'=='with all fields informed'
        IF  ('''${fuel_productID}'''=='''${NONE}''') and ('''${merch_productID}'''=='${NONE}''')
            @{fields_to_remove}   Create List   merch_products  fuel_products
            Sending Post Request
            ...     total_amount=2.00     sales_tax=0.10
            ...     info_id=${infoID}     info_value=${infoVALUE}
            ...     what_remove=@{fields_to_remove}
        ELSE IF  ('''${fuel_productID}'''!='''${NONE}''') and ('''${merch_productID}'''=='${NONE}''')
            @{fields_to_remove}   Create List   merch_products
            Sending Post Request
            ...     total_amount=2.00     sales_tax=0.10
            ...     info_id=${infoID}     info_value=${infoVALUE}
            ...     quantity=1            ppu=1.00                  cost=1.00       fuel_product_id=${fuel_productID}
            ...     what_remove=@{fields_to_remove}
        ELSE IF  ('''${fuel_productID}'''=='''${NONE}''') and ('''${merch_productID}'''!='''${NONE}''')
            @{fields_to_remove}   Create List   fuel_products
            Sending Post Request
            ...     total_amount=2.00     sales_tax=0.10
            ...     info_id=${infoID}     info_value=${infoVALUE}
            ...     product_quantity=1    product_cost=1.0          product_id=${merch_productID}
            ...     what_remove=@{fields_to_remove}
        ELSE
            Sending Post Request
            ...     total_amount=2.00     sales_tax=0.10
            ...     info_id=${infoID}     info_value=${infoVALUE}
            ...     fuel_product_id=${fuel_productID}          quantity=1       ppu=1.00     cost=1.00
            ...     product_quantity=1    product_cost=1.0     product_id=${merch_productID}
        END
    ELSE IF  '${detail}'=='using just mandatory fields informed'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  what_remove=@{fields_to_remove}
    END

The API response should be 201 with the BATCH_ID and PRE_PURCHASE_ID created displayed
    [Documentation]     Cheking STATUS and the fields [BATCH_ID|PRE_PURCHASE_ID] displayed into the API response
    Set Suite Variable  ${batchId_returned}        ${result}[details][data][batch_id]
    Set Suite Variable  ${prePurchaseId_returned}  ${result}[details][data][pre_purchase_id]

    Should Be Equal As Strings  ${status}                                   201
    Should Be Equal As Strings  ${result}[name]                             CREATED
    Should Be Equal As Strings  ${result}[details][type]                    PrePurchaseDTO
    Should Be Equal As Strings  ${result}[details][data][batch_id]          ${batchId_returned}
    Should Be Equal As Strings  ${result}[details][data][pre_purchase_id]   ${prePurchaseId_returned}

    ${links_dic}  Convert To Dictionary  ${result}[details][data][links]
    Should Be Equal As Strings  ${links_dic}  {'rel': 'href'}

Query to find data in "${table}" table
    [Documentation]     Query to find data in those tables (BATCH_HISTORY and PRE_PURCHASE)

    Get into DB  ${db}
    IF  '${table}'=='BATCH_HISTORY'
        ${query}    Catenate    select batch_id, status, merchant_id, manual_entry, cast(date_inserted as varchar)
        ...                     as date_inserted, cast(updated_by as varchar) as updated_by
        ...                     from batch_history where batch_id = '${batchId_returned}'
        ${DB_BathHistory}   Query To Dictionaries  ${query}
        Set Suite Variable  ${DB_BathHistory}
    ELSE IF  '${table}'=='PRE_PURCHASE'
        ${query}    Catenate    select cast(pre_purchase_id as varchar) as pre_purchase_id, batch_id, card_id,
        ...                     cast(pos_date as varchar) as pos_date, pos_offset, invoice_number, sales_tax,
        ...                     pre_auth_id, auth_code, location_id, location_name, total_amount, error_message,
        ...                     error_code, reject_reason, reject_code, prompts, fuel_products, merch_products,
        ...                     correlation_id, update_date, updated_by, carrier_id, carrier_name, pre_purchase_status
        ...                     from pre_purchase
        ...                     where pre_purchase_id = '${prePurchaseId_returned}'
        ${DB_PrePurchase}   Query To Dictionaries  ${query}
        Set Suite Variable  ${DB_PrePurchase}
    END
    Disconnect from Database

Verify BATCH_ID returned with the stored data at [BATCH_HISTORY] table in the database
    [Documentation]     Checking BATCH_ID details, stored in the database
    Query to find data in "BATCH_HISTORY" table

    Should Be Equal As Strings  ${DB_BathHistory}[0][batch_id]       ${batchId_returned}
    Should Be Equal As Strings  ${DB_BathHistory}[0][status]         COMPLETED
    Should Be Equal As Strings  ${DB_BathHistory}[0][merchant_id]    ${merchantID}
    Should Be Equal As Strings  ${DB_BathHistory}[0][manual_entry]   ${True}
    Should Be Equal As Strings  ${DB_BathHistory}[0][updated_by]     ${auto_user_id}
    Should Not Be Empty         ${DB_BathHistory}[0][date_inserted]

Verify "${fields}" fields informed with the stored data at [PRE-PURCHASE] table in the database
    [Documentation]     Checking PRE-PURCHASE CREATION details, stored in the database
    Query to find data in "PRE_PURCHASE" table

    Should Be Equal As Strings  ${DB_PrePurchase}[0][pre_purchase_id]       ${prePurchaseId_returned}
    Should Be Equal As Strings  ${DB_PrePurchase}[0][batch_id]              ${batchId_returned}
    Should Be Equal As Strings  ${DB_PrePurchase}[0][carrier_id]            ${carrierID}
    Should Not Be Empty         ${DB_PrePurchase}[0][carrier_name]
    Should Be Equal As Strings  ${DB_PrePurchase}[0][card_id]               ${payload}[card_id]
    Should Be Equal As Numbers  ${DB_PrePurchase}[0][invoice_number]        ${payload}[invoice_number]
    Should Be Equal As Strings  ${DB_PrePurchase}[0][location_id]           ${payload}[location_id]
    Should Not Be Empty         ${DB_PrePurchase}[0][location_name]
    Should Be Equal As Numbers  ${DB_PrePurchase}[0][total_amount]          ${payload}[total_amount]
    Should Be Equal As Strings  ${DB_PrePurchase}[0][pre_purchase_status]   READY_FOR_PROCESSING
    Should Be Equal As Strings  ${DB_PrePurchase}[0][updated_by]            ${auto_user_id}
    Should Not Be Empty         ${DB_PrePurchase}[0][correlation_id]
    Should Not Be Empty         ${DB_PrePurchase}[0][pos_date]
    ${update_date}  Convert To String  ${DB_PrePurchase}[0][update_date]
    Should Not Be Empty         ${update_date}

    IF  '${fields}'=='ALL'
        Should Be Equal As Numbers  ${DB_PrePurchase}[0][sales_tax]      ${payload}[sales_tax]
        #Checking Prompts list
        IF  '''${DB_PrePurchase}[0][prompts]'''!='''${NONE}'''
            Should Be Equal As Strings  ${DB_PrePurchase}[0][prompts][0][info_id]     ${payload}[prompts][0][info_id]
            Should Be Equal As Strings  ${DB_PrePurchase}[0][prompts][0][info_value]  ${payload}[prompts][0][info_value]
        END
        #Checking Fuel_products list
        IF  '''${DB_PrePurchase}[0][fuel_products]'''!='''${NONE}'''
            Should Be Equal As Numbers  ${DB_PrePurchase}[0][fuel_products][0][quantity]    ${payload}[fuel_products][0][quantity]
            Should Be Equal As Numbers  ${DB_PrePurchase}[0][fuel_products][0][ppu]         ${payload}[fuel_products][0][ppu]
            Should Be Equal As Numbers  ${DB_PrePurchase}[0][fuel_products][0][cost]        ${payload}[fuel_products][0][cost]
            Should Be Equal As Strings  ${DB_PrePurchase}[0][fuel_products][0][product_id]  ${payload}[fuel_products][0][product_id]
        END
        #Cheking Merch_products list
        IF  '''${DB_PrePurchase}[0][merch_products]'''!='''${NONE}'''
            Should Be Equal As Numbers  ${DB_PrePurchase}[0][merch_products][0][product_quantity]  ${payload}[merch_products][0][product_quantity]
            Should Be Equal As Numbers  ${DB_PrePurchase}[0][merch_products][0][product_cost]      ${payload}[merch_products][0][product_cost]
            Should Be Equal As Strings  ${DB_PrePurchase}[0][merch_products][0][product_id]        ${payload}[merch_products][0][product_id]
        END
    ELSE IF  '${fields}'=='MANDATORY'
        Should Be Equal As Strings  ${DB_PrePurchase}[0][pos_offset]      ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][pre_auth_id]     ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][auth_code]       ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][sales_tax]       ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][error_message]   ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][error_code]      ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][reject_reason]   ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][reject_code]     ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][prompts]         ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][fuel_products]   ${NONE}
        Should Be Equal As Strings  ${DB_PrePurchase}[0][merch_products]  ${NONE}
    END

################################################### EXPECTED ERRORS ###################################################
ERROR - RESPONSE EXPECTED
    [Documentation]  Use to validade EXPECTED ERRORS of this endpoints (400, 404, 422)
    [Arguments]      ${code}=${NONE}   ${with_body}=${NONE}  ${name}=${NONE}  ${error_code}=${NONE}  ${message}=${NONE}
    ...              ${field}=${NONE}  ${issue}=${NONE}
    IF  '${code}'=='404'
        Should Be Equal As Strings     ${status}          404
        Should Be Equal As Strings     ${result}[path]    /merchants/purchases
        Should Be Equal As Strings     ${result}[error]   Not Found
        Dictionary Should Contain Key  ${result}          timestamp

        ${timestamp}  Convert To String  ${result}[timestamp]
        Should Not Be Empty              ${timestamp}
    ELSE IF  '${code}'=='422'
        Should Be Equal As Strings  ${status}              422
        Should Be Equal As Strings  ${result}[name]        ${name}
        Should Be Equal As Strings  ${result}[error_code]  ${error_code}
        Should Be Equal As Strings  ${result}[message]     ${message}
    ELSE IF  '${code}'=='400'
        Should Be Equal As Strings  ${status}              400
        IF    '${with_body}'=='YES'
            Should Be Equal As Strings  ${result}[name]               BAD_REQUEST
            Should Be Equal As Strings  ${result}[details][0][field]  ${field}
            Should Be Equal As Strings  ${result}[details][0][issue]  ${issue}
            Should Be Equal As Strings  ${result}[message]            Invalid request input
        ELSE IF    '${with_body}'=='NO'
            Should Be Empty         ${result}
        END
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests
    ${error_list}   Create List
    ...    MERCHANT_ID INVALID          MERCHANT_ID NOT SEND          MERCHANT_ID NOT ASSIGNED TO THE USER
    ...    CARD_ID NOT SEND             CARD_ID INVALID               POS_DATE NOT SEND           POS_DATE INVALID
    ...    INVOICE_NUMBER NOT SEND      INVOICE_NUMBER INVALID        TOTAL_AMOUNT NOT SEND       TOTAL_AMOUNT INVALID
    ...    LOCATION_ID NOT SEND         LOCATION_ID INVALID           LOCATION_ID NOT RELATED WITH CARD INFORMED
    ...    FUEL[PRODUCT_ID] NOT SEND    FUEL[PRODUCT_ID] INVALID      FUEL[QUANTITY] NOT SEND     FUEL[QUANTITY] INVALID
    ...    FUEL[PPU] NOT SEND           FUEL[PPU] INVALID             FUEL[COST] NOT SEND         FUEL[COST] INVALID
    ...    MERCH[PRODUCT_ID] NOT SEND   MERCH[PRODUCT_ID] INVALID     MERCH[PRODUCT_COST] NOT SEND
    ...    MERCH[PRODUCT_COST] INVALID  MERCH[PRODUCT_QTD] NOT SEND   MERCH[PRODUCT_QTD] INVALID
    ...    PROMPTS[INFO_ID] NOT SEND    PROMPTS[INFO_VALUE] NOT SEND  UNAUTHORIZED TOKEN

    ${test_to_run}     Evaluate    dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (OnSite Fuel Purchase API) POST ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - MERCHANT_ID ${error}
    [Documentation]     Testing the request URL with the field MERCHANT_ID (not send or using invalid string)

    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  path=purchases  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=404
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  path=INVALID/purchases  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400   with_body=NO
    ELSE IF  '${error}'=='NOT ASSIGNED TO THE USER'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  path=99999/purchases  what_remove=@{fields_to_remove}
        Should Be Equal As Strings  ${status}  403
    END

ERROR - CARD_ID ${error}
    [Documentation]     Testing the request BODY with the field CARD_ID (not send or using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  card_id  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=cardId  issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  card_id=INVALID  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400   with_body=NO
    END

ERROR - POS_DATE ${error}
    [Documentation]     Testing the request BODY with the field POS_DATE (not send or using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  pos_date  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=posDate  issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  pos_date=INVALID  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400   with_body=NO
    END

ERROR - INVOICE_NUMBER ${error}
    [Documentation]     Testing the request BODY with the field INVOICE_NUMBER (not send, or using an invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  invoice_number  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=invoiceNumber   issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  invoice_number=INVALID  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400  with_body=NO
    END

ERROR - TOTAL_AMOUNT ${error}
    [Documentation]     Testing the request BODY with the field TOTAL_AMOUNT (not send and using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  total_amount  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=totalAmount   issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  total_amount=INVALID  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400  with_body=NO
    END

ERROR - LOCATION_ID ${error}
    [Documentation]     Testing the request BODY with the field LOCATION_ID (not send, invalid string or a integer
    ...                 number not related with the CARD_ID informed)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  location_id  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=locationId   issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  location_id=INVALID  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400   with_body=NO
    ELSE IF  '${error}'=='NOT RELATED WITH CARD INFORMED'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products  merch_products
        Sending Post Request  location_id=9999999  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=422
        ...     name=FAILED_CARD_LOCATION_VALIDATION  error_code=FAILED_CARD_LOCATION_VALIDATION
        ...     message=Card and Location relation does not exist
    END

ERROR - PROMPTS[INFO_ID] ${error}
    [Documentation]     Testing the request BODY with the field INFO_ID at PROMPTS list (not send)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  info_id  sales_tax  fuel_products  merch_products
        Sending Post Request  info_value=testVALUE  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=prompts[0].infoId   issue=${error_issue_empty}
    END

ERROR - PROMPTS[INFO_VALUE] ${error}
    [Documentation]     Testing the request BODY with the field INFO_VALUE at PROMPTS list (not send)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  info_value  sales_tax  fuel_products  merch_products
        Sending Post Request  info_id=testID  what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=prompts[0].infoValue   issue=${error_issue_empty}
    END

ERROR - FUEL[PRODUCT_ID] ${error}
    [Documentation]     Testing the request BODY FUEL_PRODUCTS list
    ...                 with the field PRODUCT_ID (not send or using invalid one)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  sales_tax  prompts  merch_products
        Sending Post Request  quantity=1   ppu=1.00  cost=1.00
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=fuelProducts[0].productId  issue=${error_issue_empty}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  merch_products
        Sending Post Request  fuel_product_id=INVALID  quantity=1   ppu=1.00  cost=1.00
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=422
        ...     name=INVALID_PRODUCT  error_code=INVALID_PRODUCT  message=Invalid Product.
    END

ERROR - FUEL[QUANTITY] ${error}
    [Documentation]     Testing the request BODY FUEL_PRODUCTS list
    ...                 with the field QUANTITY (not send or using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  sales_tax  prompts  merch_products
        Sending Post Request  ppu=1.00  cost=1.00   fuel_product_id=GASO
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=fuelProducts[0].quantity  issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  merch_products
        Sending Post Request  quantity=INVALID  ppu=1.00  cost=1.00   fuel_product_id=GASO
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400  with_body=NO
    END

ERROR - FUEL[PPU] ${error}
    [Documentation]     Testing the request BODY FUEL_PRODUCTS list
    ...                 with the field PPU (not send or using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  sales_tax  prompts  merch_products
        Sending Post Request  quantity=1  cost=1.00  fuel_product_id=GASO
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=fuelProducts[0].ppu  issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  merch_products
        Sending Post Request  ppu=INVALID  quantity=1  cost=1.00  fuel_product_id=GASO
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400  with_body=NO
    END

ERROR - FUEL[COST] ${error}
    [Documentation]     Testing the request BODY FUEL_PRODUCTS list
    ...                 with the field COST (not send or using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  sales_tax  prompts  merch_products
        Sending Post Request  quantity=1  ppu=1.00  fuel_product_id=GASO
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED   code=400
        ...     with_body=YES  field=fuelProducts[0].cost  issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List   sales_tax  prompts  merch_products
        Sending Post Request  cost=INVALID  quantity=1   ppu=1.00  fuel_product_id=GASO
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400  with_body=NO
    END

ERROR - MERCH[PRODUCT_ID] ${error}
    [Documentation]     Testing the request BODY MERCH_PRODUCTS list, with the field PRODUCT_ID (not send)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}     Create List   sales_tax  prompts  fuel_products
        Sending Post Request    product_cost=1   product_quantity=1
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=merchProducts[0].productId  issue=${error_issue_empty}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}     Create List   sales_tax  prompts  fuel_products
        Sending Post Request    product_cost=1   product_quantity=1   product_id=INVALID
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=422
        ...     name=INVALID_PRODUCT  error_code=INVALID_PRODUCT  message=Invalid Product.
    END

ERROR - MERCH[PRODUCT_COST] ${error}
    [Documentation]     Testing the request BODY MERCH_PRODUCTS list
    ...                 with the field PRODUCT_COST (not send or using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products
        Sending Post Request  product_id=CADV   product_quantity=1
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=merchProducts[0].productCost  issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products
        Sending Post Request  product_id=CADV  product_cost=INVALID  product_quantity=1
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400  with_body=NO
    END

ERROR - MERCH[PRODUCT_QTD] ${error}
    [Documentation]     Testing the request BODY MERCH_PRODUCTS list
    ...                 with the field PRODUCT_QUANTITY (not send or using invalid string)
    IF  '${error}'=='NOT SEND'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products
        Sending Post Request  product_id=CADV  product_cost=1
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400
        ...     with_body=YES  field=merchProducts[0].productQuantity  issue=${error_issue_null}
    ELSE IF  '${error}'=='INVALID'
        @{fields_to_remove}   Create List  sales_tax  prompts  fuel_products
        Sending Post Request  product_id=CADV  product_quantity=INVALID  product_cost=1
        ...     what_remove=@{fields_to_remove}
        ERROR - RESPONSE EXPECTED  code=400  with_body=NO
    END

ERROR - UNAUTHORIZED TOKEN
    [Documentation]     Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    @{fields_to_remove}   Create List   sales_tax  prompts  fuel_products  merch_products
    Sending Post Request  authorized=I  what_remove=@{fields_to_remove}
    IF    '${status}'=='401'
        Should Be Equal As Strings  ${status}  401
    ELSE
        Fail  TOKEN authorization validation failed
    END