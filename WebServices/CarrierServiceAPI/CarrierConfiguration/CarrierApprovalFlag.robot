*** Settings ***
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Suite Setup For Testing
Suite Teardown  Suite Teardown After Testing

Documentation  This script tests the Feature Flag 'onsite_fuel_purchase_requires_carrier_approval'

Force Tags   OnSite_FuelPurchase  T-Check  ditOnly

*** Variables ***
${configId}

*** Test Cases ***
Validate File Upload Endpoint For Legacy Files
    [Documentation]  Test case to validate the normal behavior for a carrier without a flag setup
    [Tags]  JIRA:O5SA-685  Q2:2023  QTEST:120288418
    Make A Rejected Transaction
    Validate The Status Of The Transaction  flag=false
    Carrier Approval Configuration  change  ${TRUE}
    Update A Rejected Transaction
    Validate The Status Of The Transaction  flag=true
    Carrier Approval Configuration  change  ${FALSE}
    Make A Rejected Transaction
    Validate The Status Of The Transaction  flag=false

*** Keywords ***
#Suite Setup And Teardown Keywords
Suite Setup For Testing
    [Documentation]  Keyword to be used during the Suite Setup
    Get URL For Suite  ${MerchantService}
    Gather The A Merchant And Create The User
    Verification Of The Flag

Gather The A Merchant And Create The User
    [Documentation]  Keyword that will look for a sutiable merchant_id with a good card to create a transaction and
                ...  will creates a user using it
    #gets a bunch of card_id that are assigned to merchants
    Get Into DB   postgresmerchants
    ${query}  Catenate  select card_id from on_site_merchants group by card_id limit 1000;
    ${cardIds}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    #filter the card ids that can be used to make a successful transaction
    Get Into DB  TCH
    ${cardIds}  Create List For Query From List  ${cardIds}[card_id]
    ${query}  Catenate  select card_id from cards ca
                   ...  join contract co on (co.carrier_id = ca.carrier_id and co.status ='A')
                   ...  where ca.status = 'A' and ca.infosrc in ('B', 'C', 'D') and co.daily_bal > 2
                   ...  and (((select count(*) from card_inf ci
                   ...         where ci.card_num = ca.card_num and (ci.info_id is not null or ci.info_id <> ' ')) > 0
	                 ...  and (select count(*) from card_inf ci
	                 ...         where ci.card_num = ca.card_num and ci.info_validation like 'P%') = 0
	                 ...  and (select count(*) from card_inf ci
	                 ...         where ci.card_num = ca.card_num
	                 ...            and (ci.info_validation is null or ci.info_validation = ' ')) = 0)
                   ...  or ((select count(*) from card_inf ci
                   ...         where ci.card_num = ca.card_num) = 0)
                   ...  and (select count(*) from def_info di
                   ...         where di.carrier_id = ca.carrier_id and di.ipolicy = ca.icardpolicy
                   ...            and di.info_validation like 'D%') = 0)
                   ...  and co.last_trans > TODAY - 730 and co.trans_limit > '250'
                   ...  and co.daily_bal > 2
                   ...  and ca.handenter = 'Y' and upper(ca.card_num) = lower(ca.card_num)
                   ...  and ca.handenter = 'Y' and ca.card_id in (${cardIds}) limit 1000;
    ${cardIds}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    #return with the list of sutiable card ids and based on that select one merchant id along with its data
    Get Into DB  postgresmerchants
    ${cardIds}  Evaluate  random.choice(${cardIds}[card_id])
    ${query}  Catenate  select * from on_site_merchants where card_id = '${cardIds}' order by random() limit 1;
    ${merchantInfo}  Query And Strip To Dictionary  ${query}
    Set Suite Variable  ${merchantInfo}
    Disconnect From Database

    #get the info of the selected card id from TCH databse
    Get Into DB  TCH
    ${query}  Catenate  select ca.card_id, trim(ca.card_num) as card_num, ca.carrier_id,
                   ...  ca.icardpolicy, co.issuer_id, co.contract_id, co.last_trans from cards ca
                   ...  join contract co on (co.carrier_id = ca.carrier_id and co.status ='A')
                   ...  where co.currency = 'USD' and co.last_trans > TODAY - 730 and co.trans_limit > '250'
                   ...  and ca.card_id = '${merchantInfo}[card_id]'
                   ...  order by co.last_trans desc limit 1;
    ${cardInfo}  Query And Strip To Dictionary    ${query}
    Set Suite Variable  ${cardInfo}

    #change the tran_update if needed
    ${query}  Catenate  select tran_update from member where member_id = '${cardInfo}[carrier_id]';
    ${tranUpdateOriginal}  Query And Strip  ${query}
    Set Suite Variable  ${tranUpdateOriginal}
    IF  ('${tranUpdateOriginal}'=='P') or ('${tranUpdateOriginal}'=='Y') or ('${tranUpdateOriginal}'=='')
        Execute SQL String  dml=update member set tran_update='N' where member_id = '${merchantInfo}[carrier_id]'
    END

    #change sec threshold if needed
    ${query}  Catenate  select sec_threshold from contract where contract_id = ${cardInfo}[contract_id];
    ${secThresholdOriginal}  Query And Strip  ${query}
    Set Suite Variable  ${secThresholdOriginal}
    IF  '${secThresholdOriginal}'!='1'
        Execute SQL String  dml=update contract set sec_threshold = 1 where contract_id = '${cardInfo}[contract_id]';
    END

    #get the card's prompts
    ${query}  Catenate  select info_id, trim(substring(info_validation from 2 for 10)) as info_value
                   ...  from card_inf where card_num='${cardInfo}[card_num]' order by info_id desc;
    ${prompts}  Query To Dictionaries  ${query}
    Set Suite Variable  ${prompts}
    Disconnect From Database

    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=merch
               ...  entity_id=${merchantInfo}[merchant_id]  with_data=N  need_new_user=Y

Suite Teardown After Testing
    [Documentation]  Keyword that will rollback the possible changes made during the suite setup and remove the user
    Get Into DB  TCH
    IF  ('${tranUpdateOriginal}'=='P') or ('${tranUpdateOriginal}'=='Y') or ('${tranUpdateOriginal}'=='')
        ${query}  Catenate  update member set tran_update='${tranUpdateOriginal}'
                       ...  where member_id = '${merchantInfo}[carrier_id]';
        Execute sql string  dml=${query}
        IF  '${tranUpdateOriginal}'=='P'
            ${query}  Catenate  select * from card_loc where card_num = '${cardInfo}[card_num]'
                           ...  and location_id = '${merchantInfo}[location_id]';
            ${rowCount}  Row Count  ${query}  TCH
            IF  '${rowCount}'<'1'
                ${query}  Catenate  insert into card_loc (card_num, location_id)
                               ...  values ('${cardInfo}[card_num]','${merchantInfo}[location_id]');
                Execute sql string  dml=${query}
            END

            ${query}  Catenate  select * from def_locs where carrier_id = '${cardInfo}[carrier_id]'
                           ...  and location_id ='${merchantInfo}[location_id]' and ipolicy='${cardInfo}[icardpolicy]';
            ${rowCount}  Row Count  ${query}  TCH
            IF  '${rowCount}'<'1'
                ${query}  Catenate  insert into def_locs (carrier_id, policy, location_id, ipolicy)
                               ...  values ('${cardInfo}[carrier_id]', null,
                               ...          '${merchantInfo}[location_id]', '${cardInfo}[icardpolicy]');
                Execute sql string  dml=${query}
            END
        END
    END

    IF  '${secThresholdOriginal}'!='1'
        ${query}  Catenate  update contract set sec_threshold = ${secThresholdOriginal}
                       ...  where contract_id = '${cardInfo}[contract_id]';
        Execute sql string  dml=${query}
    END
    Disconnect From Database

    Remove User If Still Exists

Verification Of The Flag
    [Documentation]  Keyword that will check if the flag exists, and if it existis, it should be 'False'.
                ...  If it doesnt exists, it will be created as 'False'.
    Get Into DB  postgrespgcarrierservices
    ${query}  Catenate  select id, carrier_id, *,
                   ...  jsonb_extract_path_text(configuration,
                   ...                          'onsite_fuel_purchase_requires_carrier_approval') as carrier_approval
                   ...  from carrier_configuration where carrier_id = '${merchantInfo}[carrier_id]';
    ${result}  Query And Strip To Dictionary  ${query}
    IF  &{result}==&{EMPTY}
        Carrier Approval Configuration  create
    ELSE IF  '${result}[carrier_approval]'=='true'
        Carrier Approval Configuration  change  config_id=${result}[id]
    END
    ${result}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    Set Suite Variable    ${configId}  ${result}[id]

${action} A Rejected Transaction
    [Documentation]  Keyword that will make a POST request in the Create a Pre Purchase endpoint to create a transaction
                ...  to be rejected making the sales tax different from the total amount
    IF  '${action.lower()}'=='make'
        ${type}  Set Variable  POST
        ${url}  Create Dictionary  ${automation_entity_id}  purchases
        ${posDate}  Get Current Date  result_format=%Y-%m-%dT%H:%M:%S.000Z  increment=-25 hours
        ${invoice}  Generate Random String  7  [NUMBERS]
        ${payload}  Create Dictionary  card_id  ${merchantInfo}[card_id]  invoice_number  ${invoice}
                                  ...  location_id  ${merchantInfo}[location_id]  total_amount  2.00
                                  ...  prompts  ${prompts}  pos_date  ${posDate}  sales_tax  1.00
        IF  @{prompts}==@{EMPTY}
            Remove From Dictionary  ${payload}  prompts
        END
        ${expected}  Set Variable  201
    ELSE IF  '${action.lower()}'=='update'
        ${type}  Set Variable  PATCH
        ${url}  Create Dictionary  ${NONE}  ${automation_entity_id}  purchases  ${prePurchaseId}
        ${payload}  Set Variable  ${prePurchasePayload}
        ${key}  Get From Dictionary  ${payload}  total_amount
        ${key}  Evaluate  float($key)+1
        Set To Dictionary  ${payload}  total_amount  ${key}
        ${expected}  Set Variable  200
    END

    ${response}  ${status}  API request  ${type}  merchants  Y  ${url}  application=Merchant Manager  payload=${payload}
    Should Be Equal As Strings  ${status}  ${expected}
    Set Test Variable  ${prePurchasePayload}  ${payload}
    Set Test Variable  ${prePurchaseId}  ${response}[details][data][pre_purchase_id]

Validate The Status Of The Transaction
    [Documentation]  Keyword that will check the 'pre_purchase_status'.
                ...  If the flag is Off, after processed, it should show as 'PURCHASE_REJECTED'
                ...  If the flag is On, after processed, it should show as 'READY_FOR_CARRIER_APPROVAL'
    [Arguments]  ${flag}  ${id}=${prePurchaseId}
    Get Into DB  postgresmerchants
    IF  '${flag.lower()}'=='false'
        ${result}  Wait Until Keyword Succeeds  15x  5 sec
                                           ...  Check Status Of The Purchase  ${id}  PURCHASE_REJECTED
    ELSE IF  '${flag.lower()}'=='true'
        ${result}  Wait Until Keyword Succeeds  15x  5 sec
                                           ...  Check Status Of The Purchase  ${id}  READY_FOR_CARRIER_APPROVAL
    END
    Disconnect From Database

Check Status Of The Purchase
    [Documentation]  Keyword that will query the database and check if the status is one of the expected
    [Arguments]    ${id}  ${expectedStatus}
    ${query}  Catenate  select count(*) from pre_purchase where pre_purchase_id = '${id}'
                   ...  and pre_purchase_status::TEXT ilike '${expectedStatus}';
    ${query}  Query And Strip To Dictionary    ${query}
    IF  '${query}[count]'!='0'
        Return From Keyword
    ELSE
        Fail  Pre Purchase Status is not the expected
    END

Carrier Approval Configuration
    [Documentation]  Keyword that will create or change a carrier approval configuration
    [Arguments]  ${action}  ${setStatus}=${FALSE}  ${carrier_id}=${merchantInfo}[carrier_id]  ${config_id}=${configId}
    Get URL For Suite  ${CarrierServiceAPI}

    ${carrier_configuration}  Create Dictionary  onsite_fuel_purchase_requires_carrier_approval  ${setStatus}
    ${payload}  Create Dictionary  carrier_configuration  ${carrier_configuration}

    IF  '${action.lower()}'=='create'
        ${type}  Set Variable  POST
        ${url}  Create Dictionary  carriers  ${carrier_id}
        ${expected}  Set Variable  201
    ELSE IF  '${action.lower()}'=='change'
        ${type}  Set Variable  PUT
        ${url}  Create Dictionary  ${NONE}  ${config_id}  carriers  ${carrier_id}
        ${expected}  Set Variable  200
    END

    ${response}  ${status}  API request   ${type}  carrier-configs  AI  ${url}  payload=${payload}
    Should Be Equal As Strings  ${status}  ${expected}

    Get URL For Suite  ${MerchantService}