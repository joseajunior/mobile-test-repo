*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setup Carrier for Create Sub Carriers
Test Teardown  Close All Browsers

Force Tags  eManager

*** Variables ***
${DB}  TCH
${carrier}
${client_carr}
${carrier_id}
${cont_fname}
${new_password}

*** Test Cases ***
Create Sub Carriers
    [Tags]  JIRA:BOT-179  JIRA:BOT-1753  JIRA:BOT-3581

     Log Carrier into eManager with Carrier Create permission
     Go to Select Program > Manage Child Carrier > Client Carrier Creation
     Fill Carrier Data and Submit
     Assert Carrier Creation and Get Id
     Assert Carrier Data on DB
     Log into eManager with New Carrier

*** Keywords ***
Setup Carrier for Create Sub Carriers
    [Documentation]  Keyword Setup for Create Sub Carriers

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND surx.role_id='CLIENT_CARRIER_CREATE'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id FROM member m
    ...    INNER JOIN carrier_group_xref cgx ON m.member_id=cgx.parent
    ...    WHERE status='A'
    ...    AND member_id IN ${carrierList}
    ...    AND member_id NOT IN ('151691', '183568', '106007', '162104', '144135', '183570', '143363')
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Log Carrier into eManager with Carrier Create permission
    [Documentation]  Log carrier into eManager with Carrier Create permission

    Open eManager  ${carrier.id}  ${carrier.password}

Log into eManager with New Carrier
    [Documentation]  Log carrier into eManager with Carrier Create permission

    Close Browser
    Get Into Db  ${DB}
    ${new_password}=  Query and Strip  SELECT trim(passwd) FROM member where member_id=${client_carr}
    Open eManager  ${client_carr}  ${new_password}  False

Go to Select Program > Manage Child Carrier > Client Carrier Creation
    [Documentation]  Go to Select Program > Manage Child Carrier > Client Carrier Creation

     Go To  ${emanager}/cards/CarrierCreate.action

Fill Carrier Data and Submit
    [Arguments]  ${name}=Severino's job    ${address}=some address    ${city}=Salvador    ${country}=CAN    ${state}=AZ    ${zip}=40000000
    ...    ${contact_name}=Severino Chico da    ${contact_phone}=071-990-9999    ${email}=efs@efsllc.com    ${number_of_cards}=1    ${language}=fr_CA
    ...    ${currency}=USD    ${alias}=Sivirin    ${physical_address}=some address    ${physical_city}=Salvador    ${physical_country}=CAN
    ...    ${physical_state}=AZ    ${physical_zip}=401000000
    [Documentation]  Fill data to create a sub carrier and submit

     Input Text    name=carrierDefinition.legalName  ${name}
     Input Text    name=carrierDefinition.mailingAddress    ${address}
     Input Text    name=carrierDefinition.mailingCity    ${city}
     Select From List By Value    name=carrierDefinition.mailingCountry    ${country}
     Select From List By Value    name=carrierDefinition.mailingState    ${state}
     Input Text    name=carrierDefinition.mailingZip    ${zip}
     Input Text    name=carrierDefinition.contactName    ${contact_name}
     Input Text    name=carrierDefinition.contactPhone    ${contact_phone}
     Input Text    name=carrierDefinition.email    ${email}
     Input Text    name=confirmEmail    ${email}
     Select From List By Value    name=carrierDefinition.numberOfCards    ${number_of_cards}
     Select From List By Value    name=carrierDefinition.language    ${language}
     Select From List By Value    name=currency    ${currency}
     Input Text    name=carrierDefinition.alias    ${alias}
     Input Text    name=carrierDefinition.physicalAddress    ${physical_address}
     Input Text    name=carrierDefinition.physicalCity    ${physical_city}
     Select From List By Value    name=carrierDefinition.physicalCountry    ${physical_country}
     Select From List By Value    name=carrierDefinition.physicalState    ${physical_state}
     Input Text    name=carrierDefinition.physicalZip    ${physical_zip}
     Click Element  name=submitBtn

Assert Carrier Creation and Get Id
    [Documentation]  Check carrier creation and get its id

     Wait Until Page Contains Element  //*[@class="messages"]  timeout=20
     Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'You have successfully created client carrier ')]
     ${client_carr}=  Get Text  //*[@class="messages"]//parent::li//descendant::*[1]
     Set Suite Variable  ${client_carr}

Assert Carrier Data on DB
    [Arguments]  ${expected_name}=SEVERINOS JOB    ${expected_address}=SOME ADDRESS    ${expected_city}=SALVADOR    ${expected_country}=C    ${expected_state}=AZ
    ...    ${expected_zip}=40000000    ${expected_contact_name}=SEVERINO CHICO    ${expected_contact_phone}=071-990-9999    ${expected_email}=efs@efsllc.com
    ...    ${expected_number_of_cards}=1    ${expected_alias}=SIVIRIN    ${expected_physical_address}=SOME ADDRESS    ${expected_physical_city}=SALVADOR
    ...    ${expected_physical_country}=CAN    ${expected_physical_state}=AZ    ${expected_physical_zip}=401000000   ${expected_language}=E
    [Documentation]  Check carrier data on database

    Get Into Db  ${DB}
    #Check carrier id
    ${carrier_id}  Query and Strip  SELECT carrier_id FROM carrier_group_xref where carrier_id = ${client_carr} ORDER BY effective_date desc
    Should be Equal as Strings  ${carrier_id}  ${client_carr}
    #Check carrier data input
    ${carrier_query}  Query and Strip to Dictionary  SELECT * FROM member where member_id=${client_carr};
    ${carrier_physical_data_query}  Query and Strip to Dictionary  SELECT * FROM contacts where carrier_id=${client_carr} and type='SHIP_TO';
    ${carrier_contract_query}  Query and Strip to Dictionary  SELECT * FROM contract where carrier_id=${client_carr} and status='A';
    Should be Equal as Strings  C  ${carrier_query['mem_type'].strip()}
    Should be Equal as Strings  ${expected_name}  ${carrier_query['name']}
    Should be Equal as Strings  ${expected_address}  ${carrier_query['add1']}
    Should be Equal as Strings  ${expected_city}  ${carrier_query['city']}
    Should be Equal as Strings  ${expected_country}  ${carrier_query['country']}
    Should be Equal as Strings  ${expected_state}  ${carrier_query['state']}
    Should be Equal as Strings  ${expected_zip}  ${carrier_query['zip'].strip()}
    Should be Equal as Strings  ${expected_contact_name}  ${carrier_query['cont_fname']}
    Should be Equal as Strings  ${expected_contact_phone}  ${carrier_query['cont_phone']}
    Should be Equal as Strings  ${expected_email}  ${carrier_query['email_addr']}
    Should be Equal as Strings  ${expected_alias}  ${carrier_query['alias_name']}
    Should be Equal as Strings  ${expected_physical_address}  ${carrier_physical_data_query['address_1']}
    Should be Equal as Strings  ${expected_physical_city}  ${carrier_physical_data_query['city'].strip()}
    Should be Equal as Strings  ${expected_physical_country}  ${carrier_physical_data_query['country']}
    Should be Equal as Strings  ${expected_physical_state}  ${carrier_physical_data_query['state']}
    Should be Equal as Strings  ${expected_physical_zip}  ${carrier_physical_data_query['zip'].strip()}
    Should be Equal as Strings  ${expected_language}  ${carrier_contract_query['language']}
    Row Count is Equal to X  SELECT * FROM cards WHERE carrier_id= ${client_carr}  ${expected_number_of_cards}