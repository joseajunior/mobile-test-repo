*** Settings ***
Library  otr_robot_lib.auth.PyAuth.AuthLog
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH   ${app_ssh_host}
Library  String
Library  FakerLibrary  locale=en_CA  WITH NAME  CA
Library  FakerLibrary  locale=en_US  WITH NAME  US
Library  otr_robot_lib.ws.InternalWS
Library  otr_robot_lib.ws.InternalWS.SalesForcePayloadBuilder
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  Contract Provisions

*** Test Cases ***
US - Confirm Retail Maintenance, Retail Fuel and Retail Other Get Entered Into Table
    [Tags]  JIRA:ATLAS-2264  qTest:118438733  PI:15  API:Y
    [Documentation]  Three new fields have been added to provision contract (Retail Maintenance, Retail Fuel and Retail Other).
        ...  Confirm values entered in provision contract payload are entered in the wrkflw_projected_revenue table.
    Create US Billing Data
    Create US Shipping Data
    Create Carrier  0  None  ${EMPTY}  ${companyname} New Values  N  105757
#   the above sets a test varible of ${results} from the api call
#   the above sets app id to ${app_id}
    Run WrkflwDaily Script
    Add Another Contract To Carrier  123  ${app_id}  2  policy2  0  None  ${EMPTY}  ${companyname}_2 New Values  N  105757
    Run WrkflwDaily Script
    Validate Payload Values To Database

*** Keywords ***
Add another contract to carrier
    [Tags]  qTest
    [Documentation]  See TC-12976 for how to add a 2nd contract.
    [Arguments]  ${retail_fuel}  ${app_id}  ${policyNum}  ${policyName}  ${parent}  ${ptype}  ${rtype}  ${name}  ${dontdooracle}=N
    ...  ${issuer}=105757  ${lockbox}=53  ${contract_name}=Electronic Fund Source  ${cashapplytype}="INVOICE MATCH"
    ...  ${card_type}=4  ${user_defined}=None  ${customer_type}=130  ${email}=None  ${setuppolicy}=Y  ${isMaster}=N
    ...  ${credit_line_amt}=1000  ${invoice_close_method}=1
    ${carrier}  Query And Strip  select carrier_id from wrkflw_cardappl where app_id = ${app_id}  db_instance=TCH
#    if you find a carrier already in workflow tables then need to log in with below info
#    log into internal web services  sfProvisionCarrier  1etThem1n
    add second contract values  retail_fuel=${retail_fuel}  application_id=${app_id}  dont_do_oracle=${dontdooracle}
    ...  issuer_id=${issuer}  contract_name=${contract_name}_1  lockbox=${lockbox}  cash_apply_type=${cashapplytype}
    ...  card_type=${card_type}  currency=${currency}  unit_of_measure=${unit_of_measure}  billing_address1=${billingAddress}
    ...  billing_city=${billingcity}  billing_state=${billingstate}  billing_country=${billingcountry}
    ...  billing_zip=${billingZipCode}  billing_phone=${billingphone}  shipping_address1=${shippingAddress}
    ...  shipping_city=${shippingcity}  shipping_state=${shippingstate}  shipToCountry=${shippingcountry}
    ...  shipping_zip=${shippingZipCode}  bill_to_fname=${billingfirstname}  bill_to_lname=${billinglastname}
    ...  ship_to_fname=${shippingfirstname}  ship_to_lname=${shippinglastname}  transacting_country=${transactingcountry}
    ...  shipping_phone=${shippingphone}  is_master=${isMaster}  credit_line_amount=${credit_line_amt}
    ...  invoice_close_method=${invoice_close_method}
    IF  '${setuppolicy}' == 'Y'
        set policy to contract  policyNumber=${policyNum}  description=${policyName}
        add limit to policy
        add infos to policy
        add refresh limits to policy
    END
    add refresh limits to contract
    add driver fees to contract
    ${contract}  finalize add contract payload
    Add Contract to carrier via internal web services  ${contract[0]}  ${carrier}  ${parent}

Create Carrier
    [Tags]  qtest
    [Arguments]  ${parent}  ${ptype}  ${rtype}  ${name}  ${dontdooracle}=N  ${issuer}=105757  ${lockbox}=53
             ...  ${contract_name}=Electronic Fund Source  ${cashapplytype}="INVOICE MATCH"  ${card_type}=4
             ...  ${user_defined}=None  ${customer_type}=130  ${email}=None  ${setuppolicy}=Y  ${isMaster}=N
             ...  ${credit_line_amt}=1000  ${invoice_close_method}=1  ${retail_maintenance}=150  ${retail_fuel}=125  ${retail_other}=160
    [Documentation]  Create a carrier via api or portal TC-9628(API),TC-8995(Child API), or TC-7756(Portal)

    log into internal web services  sfProvisionCarrier  1etThem1n
    set carrier values  original_parent_carrier_id=${parent}  parent_type=${ptype}   relationship_type=${rtype}
                   ...  carrier_name=${name}  mailing_address1=${billingAddress}  mailing_city=${billingcity}
                   ...  mailing_state=${billingstate}  mailing_country=${billingcountry}  mailing_zip=${billingZipCode}
                   ...  phone=${billingphone}  shipping_address1=${shippingAddress}  shipping_city=${shippingcity}
                   ...  shipping_state=${shippingstate}  shipping_country=${shippingcountry}  shipping_zip=${shippingZipCode}
                   ...  contact_name=${billingfirstname} ${billinglastname}  user_defined=${user_defined}
                   ...  customer_type=${customer_type}  email=${email}

    add contract values  dont_do_oracle=${dontdooracle}  issuer_id=${issuer}  contract_name=${contract_name}
                    ...  lockbox=${lockbox}  cash_apply_type=${cashapplytype}  card_type=${card_type}  currency=${currency}
                    ...  unit_of_measure=${unit_of_measure}  billing_address1=${billingAddress}  billing_city=${billingcity}
                    ...  billing_state=${billingstate}  billing_country=${billingcountry}  billing_zip=${billingZipCode}
                    ...  billing_phone=${billingphone}  shipping_address1=${shippingAddress}  shipping_city=${shippingcity}
                    ...  shipping_state=${shippingstate}  shipToCountry=${shippingcountry}  shipping_zip=${shippingZipCode}
                    ...  bill_to_fname=${billingfirstname}  bill_to_lname=${billinglastname}  ship_to_fname=${shippingfirstname}
                    ...  ship_to_lname=${shippinglastname}  transacting_country=${transactingcountry}  shipping_phone=${shippingphone}
                    ...  is_master=${isMaster}  credit_line_amount=${credit_line_amt}  invoice_close_method=${invoice_close_method}
                    ...  retail_maintenance=${retail_maintenance}  retail_fuel=${retail_fuel}  retail_other=${retail_other}
    IF  '${setuppolicy}' == 'Y'
        set policy to contract
        add limit to policy
        add infos to policy
        add refresh limits to policy
    END
    add refresh limits to contract
    add driver fees to contract

    ${carrier}  ${cardorder}  ${contract}  finalize payload
    ${results}  create carrier via internal web services  ${carrier}  ${cardorder}  ${contract}
    Set Test Variable  ${results}
    Set Test Variable  ${app_id}  ${results[1]['wrkflw_cardappl.app_id']}
    Set Test Variable  ${retailMaintenance}
    Set Test Variable  ${retailFuel}
    Set Test Variable  ${retailOther}

Create CA billing data
    [Arguments]  ${currency}=CAD
    ${companyname}  CA.company
    set test variable  ${companyname}
    ${billinglastname}  CA.last name
    set test variable  ${billinglastname}
    ${billingfirstname}  CA.first name
    set test variable  ${billingfirstname}
    ${address}  CA.Address
    ${address}  ${citystzip}  split string  ${address}  \n  1
    ${city}  ${statezip}  split string  ${citystzip}  ,${SPACE}  1
    ${state}  ${zip}  split string  ${statezip}  ${SPACE}  1
    set test variable  ${billingAddress}  ${address}
    set test variable  ${billingcity}  ${city}
    set test variable  ${billingstate}  ${state}
    set test variable  ${billingZipCode}  ${zip}
    ${billingphone}  generate random string  10  123456789
    set test variable  ${billingphone}
    set test variable  ${billingcountry}  CA
    set test variable  ${transactingcountry}  C
    set test variable  ${currency}
    set test variable  ${unit_of_measure}  L

Create CA shipping data
    ${shippinglastname}  CA.last name
    set test variable  ${shippinglastname}
    ${shippingfirstname}  CA.first name
    set test variable  ${shippingfirstname}
    ${address}  CA.Address
    ${address}  ${citystzip}  split string  ${address}  \n  1
    ${city}  ${statezip}  split string  ${citystzip}  ,${SPACE}  1
    ${state}  ${zip}  split string  ${statezip}  ${SPACE}  1
    set test variable  ${shippingAddress}  ${address}
    set test variable  ${shippingcity}  ${city}
    set test variable  ${shippingstate}  ${state}
    set test variable  ${shippingZipCode}  ${zip}
    ${shippingphone}  generate random string  10  123456789
    set test variable  ${shippingphone}
    set test variable  ${shippingcountry}  CA

Create US billing data
    ${companyname}  US.company
    set test variable  ${companyname}
    ${billinglastname}  US.last name
    set test variable  ${billinglastname}
    ${billingfirstname}  US.first name
    set test variable  ${billingfirstname}
    ${address}  US.address
    ${address}  ${citystzip}  split string  ${address}  \n  1
    ${results}  get lines containing string  ${citystzip}  ,
    IF  '${results}'!=''
        ${city}  ${statezip}  split string  ${citystzip}  ,${SPACE}  1
    ELSE
        ${city}  ${statezip}  split string  ${citystzip}  ${SPACE}  1
    END
    ${state}  ${zip}  split string  ${statezip}  ${SPACE}  1
    set test variable  ${billingAddress}  ${address}
    set test variable  ${billingcity}  ${city}
    set test variable  ${billingstate}  ${state}
    set test variable  ${billingZipCode}  ${zip}
    ${billingphone}  generate random string  10  123456789
    set test variable  ${billingphone}
    set test variable  ${billingcountry}  US
    set test variable  ${transactingcountry}  U
    set test variable  ${currency}  USD
    set test variable  ${unit_of_measure}  G

Create US shipping data
    ${shippinglastname}  US.last name
    set test variable  ${shippinglastname}
    ${shippingfirstname}  US.first name
    set test variable  ${shippingfirstname}
    ${address}  US.address
    ${address}  ${citystzip}  split string  ${address}  \n  1
    ${results}  get lines containing string  ${citystzip}  ,
    IF  '${results}'!=''
        ${city}  ${statezip}  split string  ${citystzip}  ,${SPACE}  1
    ELSE
        ${city}  ${statezip}  split string  ${citystzip}  ${SPACE}  1
    END
    ${state}  ${zip}  split string  ${statezip}  ${SPACE}  1
    set test variable  ${shippingAddress}  ${address}
    set test variable  ${shippingcity}  ${city}
    set test variable  ${shippingstate}  ${state}
    set test variable  ${shippingZipCode}  ${zip}
    set test variable  ${shippingcountry}  US
    ${shippingphone}  generate random string  10  123456789
    set test variable  ${shippingphone}

Run WrkflwDaily Script
    [Arguments]
    [Tags]  qtest  expected_results:carrrier is created and shows in logs /tch/log/TchWorkflow/&ltMM&gt/
    [Documentation]  Run program as root: sudo /tch/run/wrkflwDaily.sh

    Run Command  cd /home/qaauto
    go sudo
    Run Command  /tch/run/wrkflwDaily.sh
    Run Command  cd /home/qaauto

Validate Payload Values To Database
    [Tags]  qTest
    [Documentation]  Get wrkflw_contract_id with this query
    ...  select wrkflw_contract_id from wrkflw_contract where app_id = {app_id};
    ...  After getting the contract ID use the next query to get new field values
    ...  SELECT * FROM wrkflw_projected_revenue WHERE wrkflw_contract_id = {wrkflwContractId};
    ...  Compare values retail maintenance, retail fuel and retail other to database.
    ${wrkflwContractId}  Query And Strip  select wrkflw_contract_id from wrkflw_contract where app_id = ${app_id};  db_instance=TCH
    ${result}  Query And Strip To Dictionary  SELECT * FROM wrkflw_projected_revenue WHERE wrkflw_contract_id = ${wrkflwContractId};  db_instance=TCH
    Should Be Equal  '${result}[retail_maintenance]'  '${retailMaintenance}'
    Should Be Equal  '${result}[retail_fuel]'  '${retailFuel}'
    Should Be Equal  '${result}[retail_other]'  '${retailOther}'
    Disconnect From Database