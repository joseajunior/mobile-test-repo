*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager
Test Teardown  Close Browser

*** Test Cases ***
Shell Fuel Product VPower93 - Site Policy Limit with product limits flag on
    [Tags]    JIRA:BOT-3610    JIRA:OT-4    qTest:53058314
    [Documentation]    New product VPower93 added for shell in site policy limits

    Setup Carrier with Manage Site Policies Permission and Product Limits 'Enabled'
    Log Carrier into eManager with Manage Site Policies permission
    Go to Select Program > Manage Site Policies
    Delete Existing Limits from DB
    Select Limits > Update Limits on menu
    Click to add a new limit
    Select the 'GAS - GASOLINE' option and proceed
    Add VPower93 as a product limit
    Assert VPower93 limit creation
    Delete VPower93 Site Policy Limit

Shell Fuel Product VPower93 - Site Policy Limit with product limits flag off
    [Tags]    JIRA:BOT-3610    qTest:53058339
    [Documentation]    New product VPower93 added for shell in site policy does not show

    Setup Carrier with Manage Site Policies Permission and Product Limits 'Disabled'
    Log Carrier into eManager with Manage Site Policies permission
    Go to Select Program > Manage Site Policies
    Select Limits > Update Limits on menu
    Click to add a new limit
    Select the 'GAS - GASOLINE' option and proceed
    Check VPower93 not showing

New Prompts for Ryder Carrier - Site Policy
    [Tags]  JIRA:ROCKET-219  qtest:55360819  PI:13  API:Y
    [Setup]  Find Ryder Carrier
    Switch to "${ryder_carrier}" User
    Go To  ${emanager}/cards/PolicyPromptManagement.action?sitePolicy=true
    Verify New Prompts - Site Policy

    [Teardown]  Close Browser

*** Keywords ***
Setup Carrier with Manage Site Policies Permission and Product Limits '${flag}'
    [Documentation]  Keyword Setup for Carrier with Manage Site Policies Permission and Product Limits enabled/disabled

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id BETWEEN 500000 and 649999
    ...    AND surx.role_id='MANAGE_SITEPOLICIES'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND member_id IN ${carrier_list}
    ...  AND member_id NOT IN ('562791')
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id    SHELL
    Set Test Variable  ${carrier}
    #Set product limits flag
    Get Into DB  SHELL
    ${select_query}  Catenate  SELECT mm_value FROM member_meta WHERE mm_key = 'PRODLMTS' AND member_id = '${carrier.id}';
    ${select_query_result}  Query And Strip To Dictionary  ${select_query}
    ${amount}    Get Length    ${select_query_result}
    ${option}    Run Keyword If    '${flag}'=='Enabled'    Set Variable    Y    ELSE    Set Variable    N
    ${insert_query}  Catenate  INSERT INTO member_meta (member_id, mm_key, mm_value) VALUES ('${carrier.id}', 'PRODLMTS', '${option}');
    ${update_query}  Catenate  UPDATE member_meta SET mm_value = '${option}' WHERE mm_key = 'PRODLMTS' AND member_id = '${carrier.id}';
    Run Keyword If    ${amount}==0    Execute SQL String  ${insert_query}    ELSE    Execute SQL String  ${update_query}

Log Carrier into eManager with Manage Site Policies permission
    [Documentation]  Log carrier into eManager with Manage Site Policies permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Manage Site Policies
    [Documentation]  Go to Select Program > Manage Site Policies

    Go To  ${emanager}/cards/PolicyPromptManagement.action?sitePolicy=true
    Wait Until Page Contains    Policy Prompt Detail
    ${site_policy_number}    Get Element Attribute    //select[@name='policy.policyNumber']/option    value
    Set Test Variable    ${site_policy_number}

Select Limits > Update Limits on menu
    [Documentation]  Go to update limits on menu

    Mouse Over    id=cardMenubar_2x2
    Wait Until Element Is Visible    id=cardLimits_1x2
    Click Element    id=cardLimits_1x2
    ${has_gas_limit}    Run Keyword And Return Status    Element Should Be Visible   //input[@name='description' and @value='GASOLINE']/following-sibling::input[@name='deletePolicyLimit']
    Run Keyword If    ${has_gas_limit}    Delete VPower93 Site Policy Limit

Click to add a new limit
    [Documentation]  Clicking to add a new limit

    Wait Until Page Contains    Policy Limit Detail
    Click Button    name=createPolicyLimit

Select the '${product}' option and proceed
    [Documentation]  Selecting a product to set a limit

    Wait Until Element is Visible    name=limitIdChoice
    Select From List By Label    limitIdChoice    ${product}
    Click Button    name=processCategory

Add VPower93 as a product limit
    [Documentation]  Add only VPower93 as a product limit

    Wait Until Element is Visible    name=policyLimit.limit
    Input Text    name=policyLimit.limit    10
    Page Should Contain    VPower93
    @{product_values}    Create List    2  13  20  50  52  53
    FOR    ${value}    IN    @{product_values}
        Unselect Checkbox    //input[@name='policyProdLimitSel' and @value='${value}']
    END
    Checkbox Should Be Selected    //input[@name='policyProdLimitSel' and @value='5']
    Add Autoroll Limits
    Click Button    name=finishPolicyLimit

Add Autoroll Limits
    [Documentation]  Add auto-roll limits for every day of the week

    select radio button    optional    autoRoll
    unselect checkbox    sunday
    unselect checkbox    monday
    unselect checkbox    tuesday
    unselect checkbox    wednesday
    unselect checkbox    thursday
    unselect checkbox    friday
    unselect checkbox    saturday
    select checkbox    All

Delete Existing Limits from DB
    [Documentation]  Remove any existing Site Policy Limits for gas in the SHELL DB:
    ...  DELETE FROM def_lmts WHERE carrier_id = {TEST MEMBER ID} AND ipolicy = {TEST POLICY ID} AND limit_id = 'GAS'
    ...  DELETE FROM def_lmts_prod WHERE carrier_id = {TEST MEMBER ID} AND ipolicy = {TEST POLICY ID} AND prod_num in (2,5,13,20,50,52,53)

    ${sql}  catenate  DELETE FROM def_lmts WHERE carrier_id = '${carrier.id}' AND ipolicy = '${site_policy_number}' AND limit_id = 'GAS'
    execute sql string  ${sql}  db_instance=SHELL
    ${sql}  catenate  DELETE FROM def_lmts_prod WHERE carrier_id = '${carrier.id}' AND ipolicy = '${site_policy_number}' AND prod_num in (2,5,13,20,50,52,53)
    execute sql string  ${sql}  db_instance=SHELL

Assert VPower93 limit creation
    [Documentation]  Assert the limit was created for VPower93

    Wait Until Element is Visible    class=messages
    ${msg}    Get Text    class=messages
    Should Start With    ${msg}    You have successfully Added the Description (GASOLINE)
    Row Count is Equal to X    SELECT * FROM def_lmts WHERE carrier_id = '${carrier.id}' AND ipolicy = '${site_policy_number}' AND limit_id = 'GAS' AND limit = '10' AND day_of_week = 127;    1

Delete VPower93 Site Policy Limit
    [Documentation]  Delete site policy limit created with VPower93

    Click Element    //input[@name='description' and @value='GASOLINE']/following-sibling::input[@name='deletePolicyLimit']
    Handle Alert
    Wait Until Element is Visible    class=messages
    ${msg}    Get Text    class=messages
    Should Start With    ${msg}    You have successfully deleted the Description (GASOLINE)
    Row Count is 0    SELECT * FROM def_lmts WHERE carrier_id = '${carrier.id}' AND ipolicy = '${site_policy_number}' AND limit_id = 'GAS';

Check VPower93 not showing
    [Documentation]  Check VPower93 not showing with the flag off

    Wait Until Element is Visible    name=policyLimit.limit
    Page Should Not Contain    VPower93
    Page Should Not Contain Element    name=policyProdLimitSel
    Click Button    name=cancel

Find Ryder Carrier
    [Tags]  qtest
    [Documentation]  Find a Ryder child carrier with a site policy:
                    ...  select x.carrier_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...      INNER JOIN def_card p
                    ...          ON p.id = c.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...    and p.ipolicy = 501;
    ${sql}  catenate   select x.carrier_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...      INNER JOIN def_card p
                    ...          ON p.id = c.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...    and p.ipolicy = 501
                    ...  order by x.effective_date DESC
                    ...  limit 1;
    ${ryder_carrier}  query and strip  ${sql}  db_instance=tch
    set test variable  ${ryder_carrier}
    Open eManager  ${intern}  ${internPassword}
    set test variable  ${db}  tch
    Add User Role If Not Exists  ${ryder_carrier}  MANAGE_SITEPOLICIES  1

Verify New Prompts - Site Policy
    [Tags]  qtest
    [Documentation]  Verify the New Prompts are available:
                ...  LCCD – LOCATION CODE
                ...  PLDS – PRODUCT LINE DESC
                ...  SPLN – SUBPRODUCT LINE CODE
                ...  SLDS – SUBPRODUCT LINE DESC
    ${sql}  catenate  delete from def_info where info_id in ('LCCD','PLDS','SPLN','SLDS') and carrier_id = ${ryder_carrier};
    execute sql string  ${sql}  db_instance=tch

    click element  createPromptPolicy
    ${myPrompts}  get list items  cardInfo.infoId
    ${new_prompts}  create list  Location Code  Product Line Desc  Subproduct Line Code  Subproduct Line Desc
    list should contain sub list  ${myPrompts}  ${new_prompts}
    click element  xpath=//*[@value="LCCD"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  LOCATION CODE
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt in DB  ${ryder_carrier}  LCCD  ZLOCATION CODE

    click element  createPromptPolicy
    click element  xpath=//*[@value="PLDS"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  PRODUCT LINE DESC
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt in DB  ${ryder_carrier}  PLDS  ZPRODUCT LINE DESC

    click element  createPromptPolicy
    click element  xpath=//*[@value="SPLN"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  SUBPRODUCT LINE CODE
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt in DB  ${ryder_carrier}  SPLN  ZSUBPRODUCT LINE CODE

    click element  createPromptPolicy
    click element  xpath=//*[@value="SLDS"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  SUBPRODUCT LINE DESC
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt in DB  ${ryder_carrier}  SLDS  ZSUBPRODUCT LINE DESC

Verify Prompt in DB
    [Tags]  qtest
    [Arguments]  ${carrier_id}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select info_validation from def_info where carrier_id = {carrier_id} and info_id = '{INFO}';
    ${sql}  catenate  select info_validation from def_info where carrier_id = ${carrier_id} and info_id = '${info_id}';
    ${db_value}  query and strip  ${sql}  db_instance=${db}
    should be equal as strings  ${db_value}  ${info_validation}