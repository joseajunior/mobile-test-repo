*** Settings ***
Documentation  Tests every possible combination of policy and card limits given the limit source.
...  No preauthorization is ran to validate. Rather only database checks verify that the limits
...  updated on the card through Account Manager are correctly saved in the database.

Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  DateTime
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM  Card
Suite Setup  Setup and Connect
Suite Teardown  Disconnect

*** Test Cases ***
Ready Only Fields - Header
    [Tags]  JIRA:BOT-1363  qTest:32716047  qTest:31156782  refactor
    ${policy}  Search Policy From Carrier  ${validCard.carrier.id}
    Open Account Manager
    Searh Customer  ${validCard.carrier.id}
    Go to Policies Sub Menu
    Search And Select Policy  ${policy}
    ${db_policy_header}  Search Policy Header Values On DB  ${validCard.carrier.id}  ${policy}
    Confirm Header Values  ${db_policy_header}
    [Teardown]  Close Browser

Ready Only Fields - Prompts
    [Tags]  JIRA:BOT-1363  qTest:32539067  refactor
    ${policy}  Search Policy With Prompts on DB  ${validCard.carrier.id}
    Open Account Manager
    Searh Customer  ${validCard.carrier.id}
    Go to Policies Sub Menu
    Search And Select Policy  ${policy}
    Go To Prompts Sub Menu
    Search Prompts
    Match Prompts With DB  ${userName}  ${policy}
    [Teardown]  Close Browser

Ready Only Fields - Time Restriction
    [Tags]  JIRA:BOT-1363  qTest:32716108  refactor
    ${policy}  Search Policy And Setup Time Restrinction
    Open Account Manager
    Searh Customer  ${validCard.carrier.id}
    Go to Policies Sub Menu
    Search And Select Policy  ${policy}
    Go To Time Restriction Sub Menu
    Search Time Restrictions
    Handle Alert
    Match Time Restriction  ${begin_time}  ${end_time}
    [Teardown]  Close Browser

*** Keywords ***
Setup and Connect
    Get Into DB  TCH
    Set Selenium Timeout  60

Save Backup
    ${query}  Catenate  SELECT lmtsrc FROM cards WHERE card_num = '${validCard.card_num}'
    ${card_lmtsrc}  Query And Strip  ${query}
    Set Test Variable  ${card_lmtsrc}  ${card_lmtsrc}

Disconnect
    Disconnect From Database

Navigate To Account Manager
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Searh Customer
    [Arguments]  ${carrier}
    Wait Until Element is Enabled  //a[@id='Customer']
    Click on  //a[@id='Customer']
    Wait Until Element Is Visible  name=id
    refresh page
    Wait Until Element Is Visible  name=businessPartnerCode
    Select From List By Value  businessPartnerCode  EFS
    Wait Until Element is Enabled  //input[@name='id']
    Input Text  name=id  ${carrier}
    double click on  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0
    Wait Until Element is Visible  //button[text()='${carrier}']
    Set Focus To Element  //button[text()='${carrier}']
    click on  //button[text()='${carrier}']
    Wait Until Element Is Enabled  id=submit
    Go to Policies Sub Menu

Go to Policies Sub Menu
    Click Element  //span[text()='Policies']
    Wait Until Element is Visible  //div[@id='customerPoliciesSearchContainer']//button[@class='button searchSubmit']

Search And Select Policy
    [Arguments]  ${policy}
    Wait Until Element Is Visible  name=id
    Wait Until Element Is Enabled  name=id
    Input Text  name=id  ${policy}
    Click Element  //div[@id='customerPoliciesSearchContainer']//button[@class='button searchSubmit']
    Wait Until Element is Visible  //table[@id='DataTables_Table_0']//tr[1]//button
    ${policy}  Get Text   //table[@id='DataTables_Table_0']//tr[1]//button
    Set Focus To Element  //table[@id='DataTables_Table_0']//tr[1]//button
    click on  //table[@id='DataTables_Table_0']//tr[1]//button

Assert Sucess Message
    [Arguments]  ${message}
    Wait Until Element Is Visible  //ul[@class='msgSuccess']//li[text()='${message}']

Search Policy With Prompts on DB
    [Arguments]  ${carrier}
    ${query}  Catenate  SELECT ipolicy FROM def_info di WHERE carrier_id = ${carrier} LIMIT 1
    ${policy}  Query And Strip  ${query}
    [Return]  ${policy}

Search Policy From Carrier
    [Arguments]  ${carrier}
    ${query}  Catenate  SELECT icardpolicy FROM cards c WHERE c.carrier_id = ${carrier} LIMIT 1
    ${policy}  Query And Strip  ${query}
    [Return]  ${policy}

Go To Prompts Sub Menu
    Wait Until Element is Visible  detailRecord.contractId
    Wait Until Element is Visible  //a[@id='Prompts']
    Click Element  //a[@id='Prompts']

Go To Time Restriction Sub Menu
    Wait Until Element is Visible  detailRecord.contractId
    Wait Until Element is Visible  //a[@id='TimeRestrictions']
    Click Element  //a[@id='TimeRestrictions']

Search Prompts
    Click Submit Second Table

Search Time Restrictions
    Click Submit Second Table

Click Submit Second Table
    double click on  text=Submit  exactMatch=False  index=2

Match Prompts With DB
    [Arguments]  ${carrier}  ${policy}
    ${prompts}  Search Prompts On DB  ${carrier}  ${policy}
    ${prompt_column}  Set Variable  Prompt
    ${validation_column}  Set Variable  Value

    ${rows}  Get Element Count  //table[@id='DataTables_Table_1']//tbody/tr
    FOR  ${i}  IN RANGE  1  ${rows}+1
        ${prompt}  Get Text  //table[@id='DataTables_Table_1']//tbody//tr[${i}]//td[count(//th[text()='${prompt_column}']/preceding-sibling::th)+1]
        ${value}  Get Text  //table[@id='DataTables_Table_1']//tbody//tr[${i}]//td[count(//th[text()='${validation_column}']/preceding-sibling::th)+1]
        Search Prompt On Prompts List  ${prompts}  ${prompt}  ${value}
    END

Search Prompts On DB
    [Arguments]  ${carrier}  ${policy}
    ${query}  Catenate  SELECT di.info_id,
    ...                         TRIM(ir.description) as description,
    ...                         TRIM(SUBSTR(di.info_validation,2,LENGTH(di.info_validation))) AS info_validation
    ...                 FROM def_info di
    ...                     JOIN infos ir ON di.info_id = ir.code
    ...                 WHERE di.carrier_id = ${carrier}
    ...                 AND di.ipolicy = ${policy}
    ${prompts}  Query To Dictionaries  ${query}
    [Return]  ${prompts}

Search Policy Header Values On DB
    [Arguments]  ${carrier}  ${policy}
    ${query}  Catenate  SELECT dc.ipolicy AS policy,
    ...                        m.member_id AS customer,
    ...                        m.city||', '|| m.state AS city,
    ...                        c.contract_id||'-'||c.description AS contract,
    ...                        DECODE(c.status,'A','ACTIVE',c.status) AS contract_status,
    ...                        dc.description AS name,
    ...                        m.name AS customer_name,
    ...                        DECODE(c.currency,'USD','US Dollar', c.currency) AS currency,
    ...                        DECODE(m.country,'U','United States of America',m.country) AS country,
    ...                        DECODE(dc.handenter,'Y','Allowed','Not Allowed') AS hand_enter,
    ...                        DECODE(dc.managed_fuel,'Y','Allowed','Not Allowed') AS managed_fuel,
    ...                        DECODE(dc.managed_non_fuel,'Y','Allowed','Not Allowed') AS managed_non_fuel,
    ...                        DECODE(dc.payr_wire,'Y','Allowed','Not Allowed') AS wire_transfer,
    ...                        DECODE(dc.payr_debit,'Y','Allowed','Not Allowed') AS debit_netword,
    ...                        DECODE(dc.payr_ach,'Y','Allowed','Not Allowed') AS ach_transfer
    ...                 FROM def_card dc
    ...                        JOIN contract c ON dc.contract_id = c.contract_id AND dc.id = c.carrier_id
    ...                        JOIN member m ON m.member_id = dc.id
    ...                 WHERE m.member_id = ${carrier}
    ...                 AND dc.ipolicy = ${policy}
    ${output}  Query And Strip To Dictionary  ${query}
    [Return]  ${output}

Search Prompt On Prompts List
    [Arguments]  ${prompts}  ${screen_prompt}  ${screen_value}
    ${find}  Set Variable  ${False}
    FOR  ${prompt}  IN  @{prompts}
        ${db_prompt}  Remove From String  ${SPACE}  ${prompt['description']}
        ${screen_prompt}  Remove From String  ${SPACE}  ${screen_prompt}
        ${find}  Set Variable If  '${screen_prompt.upper()}'=='${db_prompt.upper()}' and '${screen_value.upper()}'=='${prompt['info_validation'].upper()}'  ${True}  ${find}
        Exit For Loop If  ${find}==${True}
    END
    Should Be True  ${find}

Search Policy And Setup Time Restrinction
    ${policy}  Search Policy From Carrier  ${validCard.carrier.id}
    ${begin_date}  getDateTimeNow  %Y-%m-%d
    ${begin_time}  getDateTimeNow  %H:%M:%S
    ${end_date}  getDateTimeNow  %Y-%m-%d
    ${end_time}  getDateTimeNow  %H:%M:%S
    ${day}  Set Variable  1
    Set Test Variable  ${begin_time}  ${begin_time}
    Set Test Variable  ${end_time}  ${end_time}
    Start Setup Policy  ${validCard.carrier.id}  ${policy}
    Setup Policy Time Restrictions  ${begin_date}  ${begin_time}  ${day}  ${end_date}  ${end_time}
    [Return]  ${policy}

Confirm Header Values
    [Arguments]  ${db_policy_header}
    Confirm Label Value  Policy #  ${db_policy_header['policy']}
    Confirm Label Value  City, ST/PROV  ${db_policy_header['city']}
    Confirm Combo Value  Contract  ${db_policy_header['contract']}
    Confirm Label Value  Contract Status  ${db_policy_header['contract_status']}
    Confirm Text Value  Name  ${db_policy_header['name']}
    Confirm Label Value  Customer Name  ${db_policy_header['customer_name']}
    Confirm Label Value  Currency  ${db_policy_header['currency']}
    Confirm Label Value  Country  ${db_policy_header['country']}
    Confirm Combo Value  Hand Enter  ${db_policy_header['hand_enter']}
    Confirm Combo Value  Managed Fuel  ${db_policy_header['managed_fuel']}
    Confirm Combo Value  Managed Non-Fuel  ${db_policy_header['managed_non_fuel']}
    Confirm Combo Value  Wire Transfer  ${db_policy_header['wire_transfer']}
    Confirm Combo Value  Debit Network  ${db_policy_header['debit_netword']}
    Confirm Combo Value  ACH Transfer  ${db_policy_header['ach_transfer']}

Confirm Label Value
    [Arguments]  ${label}  ${expected_value}
    Confirm Value  ${label}  ${expected_value}

Confirm Text Value
    [Arguments]  ${label}  ${expected_value}
    Confirm Value  ${label}  ${expected_value}  component=TEXT

Confirm Combo Value
    [Arguments]  ${label}  ${expected_value}
    Confirm Value  ${label}  ${expected_value}  component=COMBO

Confirm Value
    [Arguments]  ${label}  ${expected_value}  ${component}=LABEL
    Wait Until Element Is Visible  submit
    ${screen_value}  Run Keyword If  '${component}'=='LABEL'
    ...  Get Text  (//label[text()='${label}']/parent::td/following-sibling::td)[1]
    ...  ELSE IF  '${component}'=='TEXT'
    ...  Get Element Attribute  (//label[text()='${label}']/parent::td/following-sibling::td)[1]/input  value
    ...  ELSE
    ...  Get Text  (//label[text()='${label}']/parent::td/following-sibling::td)[1]/select/option[@selected='selected']
    ${screen_value}  Remove From String  ${SPACE}  ${screen_value.__str__()}
    ${expected_value}  Remove From String  ${SPACE}  ${expected_value.__str__()}
#    tch logging  ${screen_value} - ${expected_value}
    Should Be Equal As Strings  ${screen_value}  ${expected_value}

Match Time Restriction
    [Arguments]  ${begin_time}  ${end_time}
    ${begin_time}  Add Time To Date  ${begin_time}  1 hour  result_format=%H:%M  date_format=%H:%M:%S
    ${end_time}  Add Time To Date  ${end_time}  1 hour  result_format=%H:%M  date_format=%H:%M:%S
    Match Table Column Value  Start Time  ${begin_time}
    Match Table Column Value  End Time  ${end_time}

Match Table Column Value
    [Arguments]  ${column_name}  ${expected_value}
    ${value}  Get Text  //table[@id='DataTables_Table_1']//tbody/tr/td[count(//th[text()='${column_name}']/preceding-sibling::th)+1]
    Should Be Equal As Strings  ${value}  ${expected_value}