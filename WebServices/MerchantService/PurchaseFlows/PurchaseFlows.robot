*** Settings ***
Library   otr_model_lib.services.GenericService
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Resource  otr_robot_lib/robot/JSONAuthAPIKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Suite Setup For Testing
Suite Teardown  Suite Teardown After Testing

Documentation  This script will test the state flow scenarios when evaluating a purchase

Force Tags   OnSite_FuelPurchase  T-Check  ditOnly  phoenix

*** Variables ***
#there are 2 TCH databases due to one of the resource keywords needs the ${db} variable
${merchant_db}  postgresmerchants
${carrier_db}  postgrespgcarrierservices
${tch_db}  TCH
${db}  TCH

*** Test Cases ***
Test Scenario of the Purchase State Flow #1
    [Documentation]  Test case that will validate the flow where a purchase is sent, the carrier approval
                ...  configuration turned Off (false), and approved
    [Tags]  JIRA:O5SA-590  Q2:2023  QTEST:119617535
    [Setup]  Create Payload To Make Request
    Set The Carrier Approval Configuration  ${FALSE}
    Make A Request to Create Purchase To Be Approved By the System
    Check If The Purchase Status Is  PURCHASE_APPROVED
    Verify The 'pre_purchase_history' Table For The Statuses  READY_FOR_PROCESSING PURCHASE_APPROVED
    [Teardown]  Verify If Everything Was Left As It Was

Test Scenario of the Purchase State Flow #2
    [Documentation]  Test case that will validate the flow where a purchase is sent and there is the carrier approval
                ...  configuration turned On (true), it should wait for carrier approval, and then it gets approved
    [Tags]  JIRA:O5SA-638  Q2:2023  QTEST:120561166
    [Setup]  Create Payload To Make Request
    Set The Carrier Approval Configuration  ${TRUE}
    Make A Request to Create Purchase To Be Approved By the System
    Check If The Purchase Status Is  READY_FOR_CARRIER_APPROVAL
    Make A Request To Define Carrier Decision As  Approved
    Check If The Purchase Status Is  PURCHASE_APPROVED
    Verify The 'pre_purchase_history' Table For The Statuses  READY_FOR_PROCESSING READY_FOR_CARRIER_APPROVAL CARRIER_APPROVED_PURCHASE PURCHASE_APPROVED
    [Teardown]  Verify If Everything Was Left As It Was

Test Scenario of the Purchase State Flow #3
    [Documentation]  Test case that will validate the flow where a purchase is sent and there is the carrier approval
                ...  configuration turned Off (false), it should be reject by PreAuth, resubmitted, and then approved
    [Tags]  JIRA:O5SA-639  Q2:2023  QTEST:120562841
    [Setup]  Create Payload To Make Request
    Set The Carrier Approval Configuration  ${FALSE}
    Make A Request to Create Purchase To Be Rejected By the PreAuth
    Check If The Purchase Status Is  PURCHASE_REJECTED
    Make A Request to Update Purchase To Be Approved By the System
    Check If The Purchase Status Is  PURCHASE_APPROVED
    Verify The 'pre_purchase_history' Table For The Statuses  READY_FOR_PROCESSING PURCHASE_REJECTED RESUBMITTED PURCHASE_APPROVED
    [Teardown]  Verify If Everything Was Left As It Was

Test Scenario of the Purchase State Flow #4
    [Documentation]  Test case that will validate the flow where a purchase is sent and there is the carrier approval
                ...  configuration turned On (true), it should be reject by PreAuth, resubmitted, approved by carrier
                ...  and then approved
    [Tags]  JIRA:O5SA-640  Q2:2023  QTEST:120534665
    [Setup]  Create Payload To Make Request
    Set The Carrier Approval Configuration  ${TRUE}
    Make A Request to Create Purchase To Be Rejected By the PreAuth
    Check If The Purchase Status Is  PURCHASE_REJECTED
    Make A Request to Update Purchase To Be Approved By the System
    Check If The Purchase Status Is  READY_FOR_CARRIER_APPROVAL
    Make A Request To Define Carrier Decision As  Approved
    Check If The Purchase Status Is  PURCHASE_APPROVED
    Verify The 'pre_purchase_history' Table For The Statuses  READY_FOR_PROCESSING PURCHASE_REJECTED RESUBMITTED READY_FOR_CARRIER_APPROVAL CARRIER_APPROVED_PURCHASE PURCHASE_APPROVED
    [Teardown]  Verify If Everything Was Left As It Was

Test Scenario of the Purchase State Flow #5
    [Documentation]  Test case that will validate the flow where a purchase is sent and there is the carrier approval
                ...  configuration turned On (true), the purchase will be rejected by the carrier, resubmitted, and
                ...  then approved
    [Tags]  JIRA:O5SA-641  Q2:2023  QTEST:120503352
    [Setup]  Create Payload To Make Request
    Set The Carrier Approval Configuration  ${TRUE}
    Make A Request to Create Purchase To Be Approved By the System
    Check If The Purchase Status Is  READY_FOR_CARRIER_APPROVAL
    Make A Request To Define Carrier Decision As  Rejected
    Check If The Purchase Status Is  CARRIER_REJECTED
    Make A Request to Update Purchase To Be Approved By the System
    Check If The Purchase Status Is  READY_FOR_CARRIER_APPROVAL
    Make A Request To Define Carrier Decision As  Approved
    Check If The Purchase Status Is  PURCHASE_APPROVED
    Verify The 'pre_purchase_history' Table For The Statuses  READY_FOR_PROCESSING READY_FOR_CARRIER_APPROVAL CARRIER_REJECTED RESUBMITTED READY_FOR_CARRIER_APPROVAL CARRIER_APPROVED_PURCHASE PURCHASE_APPROVED
    [Teardown]  Verify If Everything Was Left As It Was

Test Scenario of the Purchase State Flow #6
    [Documentation]  Test case that will validate the flow where a purchase is sent and there is the carrier approval
                ...  configuration turned Off (false), the purchase will be rejected by the PosAuth, resubmitted, and
                ...  then approved
    [Tags]  JIRA:O5SA-642  Q2:2023  QTEST:120502702
    [Setup]  Create Payload To Make Request
    Set The Carrier Approval Configuration  ${FALSE}
    Make A Request to Create Purchase To Be Rejected By the PosAuth
    Check If The Purchase Status Is  PURCHASE_REJECTED
    Make A Request to Update Purchase To Be Approved By the System
    Check If The Purchase Status Is  PURCHASE_APPROVED
    Verify The 'pre_purchase_history' Table For The Statuses  READY_FOR_PROCESSING PURCHASE_REJECTED RESUBMITTED PURCHASE_APPROVED
    [Teardown]  Verify If Everything Was Left As It Was

Test Scenario of the Purchase State Flow #7
    [Documentation]  Test case that will validate the flow where a purchase is sent and there is the carrier approval
                ...  configuration turned On (true), the purchase will be rejected by the PosAuth, resubmitted, approved
                ...  by carrier, and then approved by the system
    [Tags]  JIRA:O5SA-643  Q2:2023  QTEST:120599353
    [Setup]  Create Payload To Make Request
    Set The Carrier Approval Configuration  ${TRUE}
    Make A Request to Create Purchase To Be Rejected By the PosAuth
    Check If The Purchase Status Is  READY_FOR_CARRIER_APPROVAL
    Make A Request To Define Carrier Decision As  Approved
    Check If The Purchase Status Is  PURCHASE_REJECTED
    Make A Request to Update Purchase To Be Approved By the System
    Check If The Purchase Status Is  READY_FOR_CARRIER_APPROVAL
    Make A Request To Define Carrier Decision As  Approved
    Check If The Purchase Status Is  PURCHASE_APPROVED
    Verify The 'pre_purchase_history' Table For The Statuses  READY_FOR_PROCESSING READY_FOR_CARRIER_APPROVAL CARRIER_APPROVED_PURCHASE PURCHASE_REJECTED RESUBMITTED READY_FOR_CARRIER_APPROVAL CARRIER_APPROVED_PURCHASE PURCHASE_APPROVED
    [Teardown]  Verify If Everything Was Left As It Was

*** Keywords ***
#Setups and Teardowns
Suite Setup For Testing
    [Documentation]  Keyword that will setup the data and user for testing
    Get URL For Suite  ${MerchantService}
    #Find Card
    Looking for data of "CARD WITH PROMPTS" to use with PRE-AUTH transactions

    #Find or create a Merchant
    ${merchant_query}  Catenate  select * from on_site_merchants where card_id ='${cardID}' order by random() limit 1;
    Get Into DB  ${merchant_db}
    ${query}  Query To Dictionaries  ${merchant_query}
    Disconnect From Database
    IF  ${query}==@{EMPTY}
        #if no entry was found, this will use a endpoint that adds the entry
        Get Into DB  ${tch_db}
        ${query}  Catenate  select company_id as merchant_id, m.name as merchant_name, l.name as location_name
                       ...  from location l
                       ...  join member m  on company_id = member_id
                       ...  where company_id in (select member_id from member where mem_type = 'Y' and status = 'A')
                       ...  and company_id is not null and company_id <> 0 and l.location_id = '${locationID}';
        ${merchANDloc_dictionary}  Query To Dictionaries  ${query}
        Disconnect From Database
        ${url}  Create Dictionary  None=on-site-merchants
        ${merchant_payload}  Create Dictionary  merchant_id=${merchantID}  merchant_name=${merchantNAME}
                                           ...  location_id=${locationID}  location_name=${locationNAME}
                                           ...  card_id=${cardID}  carrier_id=${carrierID}
        Create My User  persona_name=merchant_admin   application_name=Merchant Manager
                   ...  entity_id=${NONE}  with_data=N   need_new_user=Y
        ${response}  ${status}  API Request  POST  merchants  Y  ${url}  application=Merchant Manager  payload=${merchant_payload}
        Should Be Equal As Strings  ${status}  201
        Remove Automation User
        Get Into DB  ${merchant_db}
        ${query}  Query To Dictionaries  ${merchant_query}
        Disconnect From Database
    END
    Set Suite Variable  ${merchant_id}  ${query}[0][merchant_id]
    #Create user with the merchant_id
    Create My User  persona_name=merchant_onsite_fuel_manager   application_name=Merchant Manager
               ...  entity_id=${merchant_id}  with_data=N   need_new_user=Y
    #Setting up the card, there are restore actions in the teardown
    #handenter
    ${query}   Catenate  select card_id, handenter from cards where card_id = '${cardID}';
    Get Into DB  ${tch_db}
    ${entry_mode}  Query To Dictionaries  ${query}
    Set Suite Variable  ${original_enter_mode}  ${entry_mode}[0][handenter]
    IF  '${original_enter_mode}'!='Y'
        ${query}  Catenate  update cards set handenter = 'Y' where card_id = '${cardID}';
        Execute SQL String  ${query}
    END
    #sec_threshold
    ${query}  Catenate  select sec_threshold from contract where contract_id = ${cardsTrans_dictionary}[0][contract_id];
    ${original_sec_threshold}  Query And Strip  ${query}
    Set Suite Variable  ${original_sec_threshold}
    IF  '${original_sec_threshold}'!='1'
        ${query}  Catenate  update contract set sec_threshold = 1
                       ...  where contract_id = '${cardsTrans_dictionary}[0][contract_id]';
        Execute SQL String  ${query}
    END
    Disconnect From Database

    #Turning the flag off and removing the flag card_lock_date in the selected card. This one should always be off in the DB
    Set The Feature Flag "OptionalCardLock" for "AUTH-1545" As "N" on the "TCH" instance
    Delete "CARD_LOCK" Flag On the MEMBER_META table for carrier ID "${carrierID}" In The "${tch_db}" Instance
    Get Into DB  ${tch_db}
    ${query}  Catenate  update cards set card_lock_date = null where card_num='${cardNum}';
    Execute SQL String  ${query}
    Disconnect From Database

Suite Teardown After Testing
    [Documentation]  Keyword that will undo some changes done for testing
    Restore location used in the "CARD NORMAL" to origin value
    #restore handenter
    IF  '${original_enter_mode}'!='Y'
        ${query}  Catenate  update cards set handenter = '${original_enter_mode}' where card_id = '${cardID}';
        Get Into DB  ${tch_db}
        Execute SQL String  ${query}
        Disconnect From Database
    END
    #restore threshold
    IF  '${original_sec_threshold}'!='1'
        ${query}  Catenate  update contract set sec_threshold = ${original_sec_threshold}
                       ...  where contract_id = '${cardsTrans_dictionary}[0][contract_id]';
        Execute sql string  ${query}
    END

Verify If Everything Was Left As It Was
    [Documentation]  Keyword that will verify and restore the changes made during the test case
    IF  ${carrier_config}==${TRUE}
        Set The Carrier Approval Configuration  ${FALSE}
    END

#Keywords that will be used to create the payload
Create Payload To Make Request
    [Documentation]  Keyword that will change the data for the current test case
    ${invoice_number}  Generate Random String  10  [NUMBERS]
    ${date}  Get Current Date  result_format=%Y-%m-%dT%H:%M:%SZ

    ${pre_auth}  Pre-Auth To Return The Products That A Card Can Buy  ${cardID}  ${locationID}  ${invoice_number}  ${date}

    ${prompts_temp}  Create List  ${pre_auth}[details][data][prompts][0]
    ${prompts}  Create List
    FOR  ${dict}  IN  @{prompts_temp}
        Keep In Dictionary  ${dict}  info_id  info_value
        Append To List  ${prompts}  ${dict}
    END

    ${payload}  Create Dictionary  card_id  ${cardID}  pos_date  ${date}  invoice_number  ${invoice_number}
                              ...  location_id  ${locationID}  total_amount  2  sales_tax  1
                              ...  prompts  ${prompts}

    IF  'fuel_products' in ${pre_auth}[details][data]
        ${product}  Evaluate  random.choice(${pre_auth}[details][data][fuel_products])
        ${temp}  Create Dictionary  quantity  1  ppu  1  cost  1  product_id  ${product}[product_id]
        ${temp}  Create List  ${temp}
        Set To Dictionary  ${payload}  fuel_products  ${temp}
        ${product_type}  Create List    fuel_products  cost
    ELSE IF  'merch_products' in $pre_auth[details][data]
        ${product}  Evaluate  random.choice(${pre_auth}[details][data][merch_products])
        ${temp}  Create Dictionary  product_quantity  1  product_cost  1  product_id  ${product}[product_id]
        ${temp}  Create List  ${temp}
        Set To Dictionary  ${payload}  merch_products  ${temp}
        ${product_type}  Create List    merch_products  product_cost
    ELSE
        Fail  The selected card does not have any products that can be purchased
    END
    Set Test Variable  ${selected_product}  ${product}
    Set Test Variable  ${product_type}
    Set Test Variable  ${payload}

Pre-Auth To Return The Products That A Card Can Buy
    [Documentation]  Keyword that will make a pre-auth request to return the card's allowed products
    [Arguments]  ${card_id}  ${location_id}  ${invoice_number}  ${date}
    ${payload}  Create Dictionary  card_id=${card_id}  location_id=${location_id}
                              ...  invoice_number=${invoice_number}  pos_time=${date}
    ${url}  Create Dictionary  ${NONE}=${merchant_id}  purchases=pre-auth
    ${response}  ${status}  API Request  POST  merchants  Y  ${url}  application=Merchant Manager  payload=${payload}
    Should Be Equal As Strings  ${status}  200
    [Return]  ${response}

#Keywords to be used in the Test Cases
Set The Carrier Approval Configuration
    [Documentation]  Keyword that will setup the carrier Approval Configuration
    [Arguments]  ${value}
    Get URL For Suite  ${CarrierServiceAPI}

    ${query}  Catenate  select id, configuration
	                 ...  from carrier_configuration where carrier_id = '${carrierID}';
    Get Into DB  ${carrier_db}
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    IF  ${query}==&{EMPTY}
        ${carrier_configuration}  Create Dictionary  onsite_fuel_purchase_requires_carrier_approval  ${value}
        ${config_payload}  Create Dictionary  carrier_configuration  ${carrier_configuration}
        ${type}  Set Variable  POST
        ${url}  Create Dictionary  carriers  ${carrierID}
        ${expected}  Set Variable  201
    ELSE IF  ${query}!=&{EMPTY}
        ${carrier_configuration}  Set Variable  ${query}[configuration]
        Set To Dictionary  ${carrier_configuration}  onsite_fuel_purchase_requires_carrier_approval  ${value}
        ${config_payload}  Create Dictionary  carrier_configuration  ${carrier_configuration}
        ${type}  Set Variable  PUT
        ${url}  Create Dictionary  ${NONE}  ${query}[id]  carriers  ${carrierID}
        ${expected}  Set Variable  200
    END
    Set Test Variable  ${carrier_config}  ${value}

    ${response}  ${status}  API request   ${type}  carrier-configs  AI  ${url}  payload=${config_payload}
    Should Be Equal As Strings  ${status}  ${expected}

    Get URL For Suite  ${MerchantService}

Make A Request to ${action} Purchase To Be ${decision} by the ${service}
    [Documentation]  Keyword that edit the payload to craete or update a purchase, so it can be rejected or approved
    #depending on the action, create or update a purchase according on what is needed
    IF  '${decision.lower()}'=='rejected'
        IF  '${service.lower()}'=='preauth'
            Set To Dictionary  ${payload}[${product_type[0]}][0]  ${product_type[1]}  10
            Set To Dictionary  ${payload}  total_amount  2
        ELSE IF  '${service.lower()}'=='posauth'
            Set To Dictionary  ${payload}[${product_type[0]}][0]  ${product_type[1]}  1
            Set To Dictionary  ${payload}  total_amount  999999
        END
    ELSE IF  '${decision.lower()}'=='approved'
        Set To Dictionary  ${payload}[${product_type[0]}][0]  ${product_type[1]}  1
        Set To Dictionary  ${payload}  total_amount  2
    END
    Set Test Variable  ${payload}

    IF  '${action.lower()}'=='create'
        ${type}  Set Variable  POST
        ${url}  Create Dictionary  ${merchant_id}  purchases
        ${expected}  Set Variable  201
        ${request_body}  Set Variable  ${payload}
    ELSE IF  '${action.lower()}'=='update'
        ${type}  Set Variable  PATCH
        ${url}  Create Dictionary  ${NONE}  ${merchant_id}  purchases  ${pre_purchase_id}
        ${expected}  Set Variable  200
        ${request_body}  Set Variable  ${payload}
        Remove From Dictionary  ${request_body}  card_id  pos_date  invoice_number  location_id
        IF  'fuel_products' in ${request_body}
            Set To Dictionary  ${request_body}[fuel_products][0]  fuel_type  ${selected_product}[fuel_type]
            Set To Dictionary  ${request_body}[fuel_products][0]  fuel_use  ${selected_product}[fuel_use]
        END
    END
    #WARNING: if a fail happens due to invalid product, it may be due the REDIS cache not be updated, the product is
    #selected randomly from the pre-auth response. (see keyword "Create Payload To Make Request")
    ${response}  ${status}  API request  ${type}  merchants  Y  ${url}  application=Merchant Manager  payload=${request_body}
    Should Be Equal As Strings  ${status}  ${expected}
    Set Test Variable  ${pre_purchase_id}  ${response}[details][data][pre_purchase_id]

Check If The Purchase Status Is
    [Documentation]  Keyword that will check a purchase status
    [Arguments]  ${expectedStatus}
    Get Into DB  postgresmerchants
    ${result}  Wait Until Keyword Succeeds  25x  5 sec
                                       ...  Check Status Of The Purchase  ${pre_purchase_id}  ${expectedStatus.upper()}
    Disconnect From Database

Check Status Of The Purchase
    [Documentation]  Keyword that will query the database and check if the status is one of the expected
    [Arguments]  ${id}  ${expectedStatus}
    ${query}  Catenate  select count(*) from pre_purchase where pre_purchase_id = '${id}'
                   ...  and pre_purchase_status::TEXT like '${expectedStatus}';
    ${query}  Query And Strip To Dictionary    ${query}
    IF  '${query}[count]'!='0'
        Return From Keyword
    ELSE
        Fail  Pre Purchase Status is not the expected
    END

Make A Request To Define Carrier Decision As
    [Documentation]  Keyword that will make request to approve o reject a purchase by the carrier
    [Arguments]  ${evalution}
    #changing the user's persona and replacing the entity so it can make the approval or rejection of the request
    Create My User  persona_name=carrier_onsite_fuel_manager   application_name=OTR_eMgr
               ...  entity_id=${carrierID}  with_data=N   need_new_user=Y

    IF  '${evalution.lower()}'=='approved'
        ${decision_payload}  Create Dictionary  pre_purchase_id=${pre_purchase_id}
    ELSE IF  '${evalution.lower()}'=='rejected'
        ${reject_info}  Get Rejection Info
        ${decision_payload}  Create Dictionary  pre_purchase_id=${pre_purchase_id}
                                           ...  reject_code=${reject_info}[name]
                                           ...  reject_message=${reject_info}[description]
    END
    @{decision_payload}  Create List  ${decision_payload}
    ${decision_payload}  Create Dictionary  purchase_approve_list=@{decision_payload}

    ${url}  Create Dictionary    carriers  ${carrierID}

    ${response}  ${status}  Api Request  POST  carrier-purchase-approvals  Y  ${url}  payload=${decision_payload}
    Should Be Equal As Strings  ${status}  200

    #changing back to original state
    Create My User  persona_name=merchant_onsite_fuel_manager   application_name=Merchant Manager
               ...  entity_id=${merchant_id}  with_data=N   need_new_user=Y

Get Rejection Info
    [Documentation]  keyword that will use the Get Rejection and select a random one to be returned
    ${url}  Create Dictionary  ${NONE}  reject-reasons
    ${response}  ${status}  API Request  GET  purchases  Y  ${url}
    Should Be Equal As Strings  200  ${status}
    ${reject_info}  Evaluate  random.choice(${response}[details][data][reject_reasons])
    [Return]  ${reject_info}

Verify The 'pre_purchase_history' Table For The Statuses
    [Documentation]  Keyword that will check if there is a row for each status that should have happened during the flow
    [Arguments]  ${statuses_list}
    ${query}  Catenate  select jsonb_extract_path_text(pre_purchase, 'prePurchaseStatus') as pre_purchase_status
                   ...  from pre_purchase_history where pre_purchase_id = ${pre_purchase_id} order by history_id asc;
    Get Into DB  ${merchant_db}
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    ${database_list}  Evaluate  [x.upper().replace(' ', '_') for x in ${query}[pre_purchase_status]]

    @{statuses_list}  Split String  ${statusesList}  ${SPACE}
    Lists Should Be Equal    ${statusesList}  ${database_list}