*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager
Test Teardown  Close Browser


*** Test Cases ***
Successfully Add a New Limit Allow
    [Tags]  JIRA:BOT-437  qTest:33062075  refactor
    [Setup]  open emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    go to  ${emanager}/cards/PolicyLimitManagement.action?policy.policyNumber=1&sitePolicy=false
    click element  xpath=//*[@name="createPolicyLimit"]
    click element  xpath=//*[@value="ULSD"]
    click element  xpath=//*[@name="processCategory"]
    input text  xpath=//*[@name="policyLimit.limit"]  100
    input text  xpath=//*[@name="hours"]  24
    click element  xpath=//*[@name="finishPolicyLimit"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]
    Get Into DB  tch
    ${limitId}=  query and strip  select limit_id from def_lmts where limit_id = 'ULSD' and carrier_id = ${validCard.carrier.member_id} and ipolicy = '1'
    should be equal as strings  ${limitId}  ULSD

Remove New Limit Allow
    [Tags]  JIRA:BOT-437  qTest:33062131  refactor
    [Setup]  open emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    go to  ${emanager}/cards/PolicyLimitManagement.action?policy.policyNumber=1&sitePolicy=false
    Click Element  //input[@name='deletePolicyLimit' and @onclick="return handleMesssage('Are you sure you wish to delete the limit','ULTRA LOW SULFUR DIESEL');"]
    Handle Alert
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]
    Get Into DB  tch
    row count is 0  select limit_id from def_lmts where limit_id = 'ULSD' and carrier_id = ${validCard.carrier.member_id} and ipolicy = '1'

Add and Remove new Autoroll Limits
    [Tags]  JIRA:BOT-437  JIRA:OT-4  qTest:33204531
    [Documentation]  Add two new Policy Limits in eManager for policy 1 with auto-roll enabled every day of the week:
    ...  GAS/100 and DIESEL/200 (category/limit)
    [Setup]  Delete Gas and Deisel  1  ${validCard.carrier.member_id}
    open emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    go to  ${emanager}/cards/PolicyLimitManagement.action?policy.policyNumber=1&sitePolicy=false
    Wait Until Page Contains Element    xpath=//*[@name="createPolicyLimit"]
    Add Limit to Policy  GAS${SPACE}  100  N
    Add Limit to Policy  DSL${SPACE}  200  Y
    Get Into DB  tch
    ${limits}=  query and strip to dictionary  select limit_id from def_lmts where limit_id = 'DSL' and carrier_id = ${validCard.carrier.member_id} and ipolicy = '1' and day_of_week = 127
    should contain  ${limits['limit_id']}  DSL
    ${limits}=  query and strip to dictionary  select limit_id from def_lmts where limit_id = 'GAS' and carrier_id = ${validCard.carrier.member_id} and ipolicy = '1' and day_of_week = 127
    should contain  ${limits['limit_id']}  GAS

    Remove limit from Policy  1  DIESEL
    Verify Prompt was removed from Policy  1  ${validCard.carrier.member_id}  DSL
    Remove limit from Policy  1  GASOLINE
    Verify Prompt was removed from Policy  1  ${validCard.carrier.member_id}  GAS

Add/Edit/Delete a prompt for shell reskin carrier
    [Documentation]  This test case is to check if a carrier can add/edit/delete a limit
    ...  for a reskin shell carrier without any issues
    [Tags]  JIRA:FRNT-67  JIRA:FRNT-68  qTest:37582007  qTest:37582013  reskin  refactor
    [Setup]  Open Browser to eManager
    Get Into DB  SHELL
    execute sql string  dml=delete FROM def_lmts WHERE carrier_id = 600003 AND ipolicy=1 AND limit_id = 'CADV';
    Log into eManager  ${reskin_carrier}  ${reskin_password}
    Go To  ${emanager}/cards/PolicyLimitManagement.action
    Wait Until Page Contains  text=Update Limits  timeout=30
    ${status}  Run Keyword And Return Status  Page Should Contain  text=Update Limits
    Run Keyword IF  '${status}'=='${true}'  Run Keywords  Add a limit  AND  Edit a limit  AND  Delete a limit
    ...  ELSE  Run Keywords  Go To  ${emanager}/cards/PolicyLimitManagement.action  AND  Add a limit  AND  Edit a limit  AND  Delete a limit

Shell Fuel Product VPower93 - Policy Limit with product limits flag on
    [Tags]    JIRA:BOT-3610    qTest:53058311
    [Documentation]    New product VPower93 added for shell in policy limits

    Setup Carrier with Manage Policies Permission and Product Limits 'Enabled'
    Log Carrier into eManager with Manage Policies permission
    Go to Select Program > Manage Policies > Manage Policies
    Select Limits > Update Limits on menu
    Click to add a new limit
    Select the 'GAS - GASOLINE' option and proceed
    Add VPower93 as a product limit
    Assert VPower93 limit creation
    Delete VPower93 Site Policy Limit

Shell Fuel Product VPower93 - Policy Limit with product limits flag off
    [Tags]    JIRA:BOT-3610    qTest:53058330
    [Documentation]    New product VPower93 added for shell in policy does not show

    Setup Carrier with Manage Policies Permission and Product Limits 'Disabled'
    Log Carrier into eManager with Manage Policies permission
    Go to Select Program > Manage Policies > Manage Policies
    Select Limits > Update Limits on menu
    Click to add a new limit
    Select the 'GAS - GASOLINE' option and proceed
    Check VPower93 not showing

*** Keywords ***
Go Back to Policy Screen
    go to  ${emanager}/cards/PolicyLimitManagement.action?policy.policyNumber=1&sitePolicy=false

Add a limit
    wait until element is enabled  xpath=//*[@name="createPolicyLimit"]
    click element  xpath=//*[@name="createPolicyLimit"]
    select from list by value  limitIdChoice  CADV
    click element  processCategory
    input text  policyLimit.limit  100
    click radio button  autoRoll
    input text  policyLimit.autoRollMax  500
    select checkbox  sunday
    select checkbox  saturday
    click element  finishPolicyLimit
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]
    wait until element is visible  xpath=//*[@id="policyLimits"]//*[contains(text(),"CASH ADVANCE")]/following-sibling::*[contains(text(),'100')]/following-sibling::*[contains(text(),'CAD')]/following-sibling::*[contains(text(),'Su Sa')]
    Verify DB  100
    tch logging  Successfully added a prompt

Edit a limit
    select from list by label  xpath=//*[@id="policyLimits"]//*[contains(text(),"CASH ADVANCE")]//following::*[@id='efsDtActions']  Edit
    wait until page contains  text=Edit Limit
    input text  policyLimit.limit  500
    select radio button  optional  allow
    wait until element is enabled  name=hours
    input text  name=hours  450
    click button  updatePolicyLimit
    wait until element is visible  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]
    wait until element is visible  xpath=//*[@id="policyLimits"]//*[contains(text(),"CASH ADVANCE")]/following-sibling::*[contains(text(),'500')]/following-sibling::*[contains(text(),'CAD')]/following-sibling::*[contains(text(),'450')]  timeout=10
    Verify DB  500
    tch logging  Successfully edited a prompt

Delete a limit
    select from list by label  xpath=//*[@id="policyLimits"]//*[contains(text(),"CASH ADVANCE")]//following::*[@id='efsDtActions']  Delete
    wait until element is visible  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]
    wait until element is not visible  xpath=//*[@id="policyPrompts"]//*[contains(text(),"CASH ADVANCE")]
    tch logging  Successfully deleted a prompt

Verify DB
    [Arguments]  ${value}
    get into db  SHELL
    ${limit}=  query and strip  select limit from def_lmts where carrier_id = '${reskin_carrier}' and limit_id = 'CADV' and ipolicy= 1
    should be equal as strings  ${limit}  ${value}

Setup Carrier with Manage Policies Permission and Product Limits '${flag}'
    [Documentation]  Keyword Setup for Carrier with Manage Policies Permission and Product Limits enabled/disabled

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id BETWEEN 500000 and 649999
    ...    AND surx.role_id='MANAGE_POLICIES'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND member_id IN ${carrier_list}
    ...  AND member_id NOT IN ('600212', '600001')
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

Log Carrier into eManager with Manage Policies permission
    [Documentation]  Log carrier into eManager with Manage Policies permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Manage Policies > Manage Policies
    [Documentation]  Go to Select Program > Manage Policies > Manage Policies

    Go To  ${emanager}/cards/PolicyPromptManagement.action
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
    Click Button    name=finishPolicyLimit

Assert VPower93 limit creation
    [Documentation]  Assert the limit was created for VPower93

    Wait Until Element is Visible    class=messages
    ${msg}    Get Text    class=messages
    Should Start With    ${msg}    You have successfully Added the Description (GASOLINE)
    Row Count is Equal to X    SELECT * FROM def_lmts WHERE carrier_id = '${carrier.id}' AND ipolicy = '${site_policy_number}' AND limit_id = 'GAS' AND limit = '10';    1

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

Add Limit to Policy
    [Arguments]    ${product}    ${limit}    ${allflag}=N
    click element  xpath=//*[@name="createPolicyLimit"]
    click element  xpath=//*[@value="${product}"]
    click element  xpath=//*[@name="processCategory"]
    input text  xpath=//*[@name="policyLimit.limit"]  ${limit}
    select radio button  optional  autoRoll
    IF  '${allflag}'=='Y'
        unselect checkbox  sunday
        unselect checkbox  monday
        unselect checkbox  tuesday
        unselect checkbox  wednesday
        unselect checkbox  thursday
        unselect checkbox  friday
        unselect checkbox  saturday
        select checkbox  All
    ELSE
        select checkbox  sunday
        select checkbox  monday
        select checkbox  tuesday
        select checkbox  wednesday
        select checkbox  thursday
        select checkbox  friday
        select checkbox  saturday
    END

    click element  xpath=//*[@name="finishPolicyLimit"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]

Delete Gas and Deisel
    [Arguments]    ${policy}  ${carrier}
    [Documentation]  Remove any existing Policy Limits in the TCH DB for policy 1:
    ...  DELETE FROM def_lmts WHERE limit_id in ('DSL', 'GAS') AND carrier_id = <TEST MEMBER ID> AND ipolicy = '1'
    ${sql}  catenate  DELETE FROM def_lmts WHERE limit_id in ('DSL', 'GAS') AND carrier_id = ${carrier}
    ...    AND ipolicy = '${policy}'
    execute sql string  ${sql}  db_instance=TCH

Remove limit from Policy
    [Arguments]    ${policy}  ${fullprompt}
    go to  ${emanager}/cards/PolicyLimitManagement.action?policy.policyNumber=${policy}&sitePolicy=false
    Wait Until Page Contains Element    xpath=//*[@name="createPolicyLimit"]
    Click element  //input[@name='deletePolicyLimit' and @onclick="return handleMesssage('Are you sure you wish to delete the limit','${fullprompt}');"]
    Handle Alert
#    Sleep  3
    Wait Until Page Contains  text=You have successfully  timeout=30
    Page Should Contain   text=You have successfully

Verify Prompt was removed from Policy
    [Arguments]    ${policy}  ${carrier}  ${abbrevprompt}
    Get Into DB  TCH
    Row Count Is 0  SELECT limit_id FROM def_lmts WHERE limit_id in ('${abbrevprompt}') AND carrier_id = ${carrier} AND ipolicy = '${policy}'
