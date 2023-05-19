*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup    Run Keywords    Setup TCH Carrier with Policies
Test Teardown    Close Browser
Suite Teardown    Disconnect From Database

*** Variables ***
${carrier}

*** Test Cases ***
Policy - Managed Dynamic Pin feature flag not enabled
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509163    PI:15
    [Documentation]    Ensure dynamic pin is not available in policy prompts when the flag is not enabled
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'off'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    # Check Control Number
    Delete prompts available for dynamic pin from db
    Reload Page
    Dynamic pin dropdown must be displayed
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'CNTN' prompt added message
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check Personal ID Number
    Delete prompts available for dynamic pin from db
    Click on 'Cancel'
    Click to add a new prompt
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'PPIN' prompt added message
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check Driver ID
    Delete prompts available for dynamic pin from db
    Click on 'Cancel'
    Click to add a new prompt
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'DRID' prompt added message
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Remove permission and repeat steps
    Remove permission and repeat the steps to check no dynamic validation available

    [Teardown]    Run Keywords    Close Browser    Set Dynamic Feature Flag 'on'

Policy - Carrier with no managed dynamic pin permission
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509164    PI:15
    [Documentation]    Ensure dynamic pin is not available in policy prompts when the permission is not set to the carrier
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Remove Manager Dynamic Pin Permission from Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    # Check for Driver ID
    Delete prompts available for dynamic pin from db
    Set 'dynamic' validation 'DRID' prompt to policy
    Reload Page
    Dynamic pin dropdown must not be displayed
    Dynamic pin 'Driver ID' prompt set must not have edit or delete button
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'CNTN' prompt added message
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check for Control Number
    Delete prompts available for dynamic pin from db
    Set 'dynamic' validation 'CNTN' prompt to policy
    Click on 'Cancel'
    Dynamic pin 'Control Number' prompt set must not have edit or delete button
    Click to add a new prompt
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'PPIN' prompt added message
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check for Personal ID Number
    Delete prompts available for dynamic pin from db
    Set 'dynamic' validation 'PPIN' prompt to policy
    Click on 'Cancel'
    Dynamic pin 'Personal ID Number' prompt set must not have edit or delete button
    Click to add a new prompt
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'DRID' prompt added message
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must not be displayed in the options list

Policy - Setting new dynamic pin in prompts
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509165    PI:15
    [Documentation]    Ensure dynamic pin can be set in policy prompts when the permission is available for the carrier
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Delete prompts available for dynamic pin from db
    Reload Page
    Set Dynamic Pin as 'Active' and save
    # Check for Driver ID
    Click to add a new prompt
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Next'
    Click on 'Finish'
    Assert new 'dynamic' validation 'DRID' added
    Delete prompts available for dynamic pin from db
    Reload Page
    # Check for Personal ID Number
    Click to add a new prompt
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Next'
    Click on 'Finish'
    Assert new 'dynamic' validation 'PPIN' added
    Delete prompts available for dynamic pin from db
    Reload Page
    # Check for Control Number
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Next'
    Click on 'Finish'
    Assert new 'dynamic' validation 'CNTN' added

Policy - Inactive dynamic pin in prompts
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509166    PI:15
    [Documentation]    Ensure dynamic pin can be inactivated in policy prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Delete prompts available for dynamic pin from db
    Reload Page
    Dynamic pin dropdown must be displayed
    # Check for Inactive
    Set Dynamic Pin as 'Inactive' and save
    # Check Control Number, Driver ID and Personal ID Number
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Click on 'Cancel'

Policy - Inactive dynamic pin not available for existing dynamic pin
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509168    PI:15
    [Documentation]    Ensure dynamic pin can not be inactivated when a dynamic pin is already set in policy prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Delete prompts available for dynamic pin from db
    Reload Page
    Set Dynamic Pin as 'Active' and save
    # Check for Driver ID
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'successfully'
    Set Dynamic Pin as 'Inactive' and save
    Assert 'Inactive' not available error message
    Delete 'Driver ID' ('DRID') dynamic validation prompt
    # Check for Control Number
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'successfully'
    Set Dynamic Pin as 'Inactive' and save
    Assert 'Inactive' not available error message
    Delete 'Control Number' ('CNTN') dynamic validation prompt
    # Check for Personal ID Number
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Set Dynamic Pin as 'Inactive' and save
    Assert 'Inactive' not available error message

Policy - Dynamic pin can not be duplicated
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509169    PI:15
    [Documentation]    Ensure another dynamic pin can not be set when there's already one created in policy prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Delete prompts available for dynamic pin from db
    Reload Page
    Set Dynamic Pin as 'Active' and save
    # Check for Driver ID
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'successfully'
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'expecting error'
    Click on 'Cancel'
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'expecting error'
    Click on 'Cancel'
    Delete 'Driver ID' ('DRID') dynamic validation prompt
    # Check for Personal ID Number
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'expecting error'
    Click on 'Cancel'
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'expecting error'
    Click on 'Cancel'
    Delete 'Personal ID Number' ('PPIN') dynamic validation prompt
    # Check for Control Number
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'successfully'
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'expecting error'
    Click on 'Cancel'
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'expecting error'

Policy - Delete dynamic pin set
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509170    PI:15
    [Documentation]    Ensure a dynamic pin can be deleted in policy prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Delete prompts available for dynamic pin from db
    Reload Page
    Set Dynamic Pin as 'Active' and save
    # Check for Driver ID
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'successfully'
    Delete 'Driver ID' ('DRID') dynamic validation prompt
    # Check for Personal ID Number
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Delete 'Personal ID Number' ('PPIN') dynamic validation prompt
    # Check for Control Number
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'successfully'
    Delete 'Control Number' ('CNTN') dynamic validation prompt

Policy - Dynamic option not available for other prompts
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117509171    PI:15
    [Documentation]    Ensure other prompts than Control Number, Driver ID and Personal ID has no dynamic option in
    ...    policy prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Delete prompts available for dynamic pin from db
    Reload Page
    Click to add a new prompt
    Assert no dynamic option for prompts different than Driver ID, Personal ID Number and Control Number

Policy - Edit to dynamic existing prompt
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117707993    PI:15
    [Documentation]    Ensure a prompt could be edit to dynamic if there isn't another dynamic prompt and if the policy
    ...    has another dynamic prompt it could not be updated to dynamic
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Delete prompts available for dynamic pin from db
    Set 'numeric' validation 'DRID' prompt to policy
    Reload Page
    # Check for Driver ID
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new 'dynamic' validation 'DRID' edited
    Add a new 'Numeric' validation 'Control Number' ('CNTN') prompt 'successfully'
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new dynamic pin prompt error message
    Delete prompts available for dynamic pin from db
    Set 'numeric' validation 'CNTN' prompt to policy
    Click on 'Cancel'
    # Check for Control Number
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new 'dynamic' validation 'CNTN' edited
    Add a new 'Numeric' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new dynamic pin prompt error message
    Delete prompts available for dynamic pin from db
    Set 'numeric' validation 'PPIN' prompt to policy
    Click on 'Cancel'
    # Check for Personal ID Number
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new 'dynamic' validation 'PPIN' edited
    Add a new 'Numeric' validation 'Driver ID' ('DRID') prompt 'successfully'
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new dynamic pin prompt error message

Policy - Dynamic pin dropdown only displayed in prompts tab
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117760574    PI:15
    [Documentation]    Ensure dynamic pin dropdown only shows in prompts tab
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    Dynamic pin dropdown must be displayed
    Change to 'Limits' from 'Update Limits' tab
    Dynamic pin dropdown must not be displayed
    Change to 'Locations' from 'Location Group Management' tab
    Dynamic pin dropdown must not be displayed
    Change to 'Time Restrictions' from 'Update Time Restrictions' tab
    Dynamic pin dropdown must not be displayed

*** Keywords ***
Setup TCH Carrier with Policies
    [Documentation]    Get a valid tch carrier and ensure it has TCH company header

    Get Into DB    TCH
    ${query}    Catenate    SELECT m.member_id, passwd
    ...    FROM def_info di
    ...    INNER JOIN member m
    ...    ON m.member_id = di.carrier_id
    ...    WHERE mem_type = 'C'
    ...    AND m.status = 'A'
    ...    AND (member_id BETWEEN 100000 AND 200000
    ...    OR member_id BETWEEN 250000 AND 299999
    ...    OR member_id between 300000 AND 389999)
    ...    AND di.ipolicy BETWEEN 1 AND 500
    ...    LIMIT 1;
    ${carrier_info}    Query And Strip to Dictionary    ${query}
    ${carrier}    Create Dictionary    id=${carrier_info["member_id"]}    password=${carrier_info["passwd"]}
    Set Suite Variable    ${carrier}
    Ensure Carrier has TCH Company Header
    Add Manage Policies Permission to Carrier

Ensure Carrier has TCH Company Header
    [Documentation]    Change carrier header to tch company header

    Change Company Header    ${carrier.id}    company_header=tch_carrier

Set Dynamic Feature Flag '${cond}'
    [Documentation]    Set feature flag on or off

    Get Into DB    MYSQL
    ${flag_value}    Run Keyword If    '${cond}'=='on'    Set Variable    Y
    ...    ELSE    Set Variable    N
    ${query}    Catenate    UPDATE setting
    ...    SET value = '${flag_value}'
    ...    WHERE `partition` = 'shared'
    ...    AND name ='FLAG_OTREPIC-3901';
    Execute SQL String    ${query}

Add Managed Dynamic Pin Permission to Carrier
    [Documentation]    Add managed dynamic pin permission to test carrier

    Ensure Carrier has User Permission    ${carrier.id}    MANAGED_DYNAMIC_PIN_ALLOWED

Add Manage Policies Permission to Carrier
    [Documentation]    Add manage policies permission to test carrier

    Ensure Carrier has User Permission    ${carrier.id}    MANAGE_POLICIES

Remove Manager Dynamic Pin Permission from Carrier
    [Documentation]    Remove managed dynamic pin permission from test carrier

    Remove Carrier User Permission    ${carrier.id}    MANAGED_DYNAMIC_PIN_ALLOWED

Login Carrier with Policies to eManager
    [Documentation]    Login to emanager with test carrier

    Open eManager    ${carrier.id}    ${carrier.password}    ChangeCompanyHeader=False

Go to Select Program > Manage Policies > Manage Policies
    [Documentation]  Go to Select Program > Manage Policies > Manage Policies

    Go To  ${emanager}/cards/PolicyPromptManagement.action
    Wait Until Page Contains Element    name=createPromptPolicy
    ${policy_selected}    Get Element Attribute    //*[@name="policy.policyNumber"]/option[@selected]    value
    Set Test Variable    ${carrier.policy}    ${policy_selected}

Change to '${menu}' from '${option}' tab
    [Documentation]  Move from current tab

    ${id}    Run Keyword If    '${menu}'=='Limits'    Set Variable    cardLimits
    ...    ELSE IF    '${menu}'=='Locations'    Set Variable    cardLocation
    ...    ELSE IF    '${menu}'=='Time Restrictions'    Set Variable    cardTimeRestriction
    ${id}    Get Substring    ${menu}    0    -1
    ${id}    Catenate    card${id}
    ${id}    Evaluate    '${id}'.replace(' ','')
    Mouse Over    //*[contains(@id, 'cardMenubar') and contains(text(), '${menu}')]
    ${opt_xpath}    Set Variable    //*[contains(@id, '${id}') and contains(text(), '${option}')]
    Wait Until Element is Visible    ${opt_xpath}
    Click Element    ${opt_xpath}
    Wait Until Element is Visible    name=savePolicyInformation

Add a new '${validation}' validation '${prompt}' ('${prompt_id}') prompt '${condition}'
    [Documentation]    Add new prompt validation to policy

    Click to add a new prompt
    Select '${prompt}' from prompt list
    Click on 'Next'
    Option '${validation}' must be displayed in the options list
    Select '${validation}' from validation list
    Click on 'Next'
    Run Keyword If    '${validation}'=='Dynamic'    Click on 'Finish'
    ...    ELSE    Click on 'Next'
    ${validation}    String.Convert To Lower Case    ${validation}
    Run Keyword If    '${condition}'=='successfully'    Assert new '${validation}' validation '${prompt_id}' added
    ...    ELSE    Assert new dynamic pin prompt error message

Set '${validation}' validation '${prompt_id}' prompt to policy
    [Documentation]    Set new prompt validation to policy via db
    ...    note: it can be dynamic (D) or numeric (N)

    ${val}    Run Keyword If    '${validation}'=='dynamic'    Set Variable    D
    ...    ELSE IF    '${validation}'=='numeric'    Set Variable    N
    Get Into DB    TCH
    ${update_query}    Catenate    UPDATE def_info
    ...    SET info_validation = '${val}'
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND ipolicy = '${carrier.policy}'
    ...    AND info_id = '${prompt_id}';
    ${insert_query}    Catenate    INSERT INTO def_info
    ...    VALUES ('${carrier.id}', '', '${prompt_id}', '${val}', '${carrier.policy}');
    ${select_query}    Catenate    SELECT info_validation
    ...    FROM def_info
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND ipolicy = '${carrier.policy}'
    ...    AND info_id = '${prompt_id}';
    ${value}    Query And Strip    ${select_query}
    Run Keyword If    '${value}'=='None'    Execute SQL String    ${insert_query}
    ...    ELSE IF    '${value}'!='${val}'    Execute SQL String    ${update_query}

Delete prompt
    [Documentation]    Delete policy prompt via details screen
    [Arguments]    ${xpath}

    Click Element    ${xpath}
    Handle Alert

Delete '${prompt}' ('${prompt_id}') dynamic validation prompt
    [Documentation]    Delete dynamic validation prompt from policy via details screen

    ${prompt_del_xpath}    Set Variable    //*[contains(text(), '${prompt}')]//parent::tr//input[@name="deletePolicyPrompt"]
    Wait Until Page Contains Element    ${prompt_del_xpath}
    Delete prompt    ${prompt_del_xpath}
    Wait Until Page Does Not Contain Element    ${prompt_del_xpath}
    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM def_info
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND ipolicy = '${carrier.policy}'
    ...    AND info_id = '${prompt_id}'
    ...    AND info_validation = 'D';
    Row Count Is Equal To X    ${query}    0

Delete prompt from db
    [Documentation]    Delete validation prompt from policy via db
    [Arguments]    ${prompt_id}

    Get into DB    TCH
    ${query}    Catenate    DELETE FROM def_info
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND ipolicy = '${carrier.policy}'
    ...    AND info_id = '${prompt_id}';
    Execute SQL String    ${query}

Delete prompts available for dynamic pin from db
    [Documentation]    Delete dynamic validation prompts from policy via db

    Delete prompt from db    DRID
    Delete prompt from db    PPIN
    Delete prompt from db    CNTN

Set Dynamic Pin as '${status}' and save
    [Documentation]    Set dynamic pin dropdown to Active or Inactive in policy details screen

    Select From List By Label    name=dynamicPinFlag    ${status}
    Click Button    name=savePolicyInformation
    Wait Until Element is Visible    name=createPromptPolicy

Click to add a new prompt
    [Documentation]    Click to add a new prompt via details screen

    Click Element    name=createPromptPolicy
    Wait Until Element is Visible    name=validationInformation

Select '${prompt}' from prompt list
    [Documentation]    Select prompt from list

    Select From List By Label    name=cardInfo.infoId    ${prompt}

Click on '${button}'
    [Documentation]    Click button by its value

    Wait Until Element is Visible    //input[@value='${button}']
    Click Button    //input[@value='${button}']

Option '${validation}' must be displayed in the options list
    [Documentation]    Validation must be displayed in list

    ${validation}    String.Convert To Upper Case    ${validation}
    Wait Until Element is Visible    //input[@value='Cancel']
    Page Should Contain Element    //select[@name="cardInfo.validationType"]/*[@value='${validation}']

Option '${validation}' must not be displayed in the options list
    [Documentation]    Validation must not be displayed in list

    ${validation}    String.Convert To Upper Case    ${validation}
    Wait Until Element is Visible    //input[@value='Cancel']
    Page Should Not Contain Element    //select[@name="cardInfo.validationType"]/*[@value='${validation}']

Dynamic pin dropdown must not be displayed
    [Documentation]    Dynamic pin must not be shown in details screen

    Page Should Not Contain    Dynamic PIN:
    Page Should Not Contain Element    name=dynamicPinFlag

Dynamic pin dropdown must be displayed
    [Documentation]    Dynamic pin must be shown in details screen

    Page Should Contain    Dynamic PIN:
    Page Should Contain Element    name=dynamicPinFlag

Select '${option}' from validation list
    [Documentation]    Select validation from list

    Select From List By Label    name=cardInfo.validationType    ${option}

Click to edit new '${prompt}' prompt
    [Documentation]    Click to edit a prompt

    ${edit_xpath}    Set Variable    //*[contains(text(), '${prompt}')]//parent::tr//input[@name="editInformation"]
    Wait Until Element is Visible    ${edit_xpath}
    Click Element    ${edit_xpath}

Dynamic pin '${prompt}' prompt set must not have edit or delete button
    [Documentation]    Dynamic pin prompt must no have edit or delete button displayed

    ${prompt_xpath}    Set Variable    //*[contains(text(), '${prompt}')]//parent::tr
    Page Should Not Contain Element    ${prompt_xpath}//input[@name="editInformation"]
    Page Should Not Contain Element    ${prompt_xpath}//input[@name="deletePolicyPrompt"]

Assert '${status}' not available error message
    [Documentation]    Ensure status is not set when there is already a dynamic prompt added

    Page Should Contain    That policy has one Dynamic Validation added. Remove it first to inactive Dynamic PIN.

Assert new '${prompt_id}' prompt added message
    [Documentation]    Check creation message

    Wait Until Page Contains    You have successfully created the prompt of (${prompt_id}).

Assert new '${prompt_id}' prompt edited message
    [Documentation]    Check edition message

    Wait Until Page Contains    You have successfully edited the prompt of (${prompt_id}).

Assert new prompt added in db
    [Documentation]    Check new prompt added via db
    [Arguments]    ${prompt_id}    ${expected_value}

    Get into DB    TCH
    ${query}    Catenate    SELECT info_validation
    ...    FROM def_info
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND ipolicy = '${carrier.policy}'
    ...    AND info_id = '${prompt_id}';
    ${value}    Query And Strip    ${query}
    Should be Equal as Strings    ${value}    ${expected_value}

Assert new '${validation}' validation '${prompt}' added
    [Documentation]    Check new prompt added

    ${value}    Run Keyword If    '${validation}'=='dynamic'    Set Variable    D
    ...    ELSE IF    '${validation}'=='numeric'    Set Variable    N
    Assert new '${prompt}' prompt added message
    Assert new prompt added in db    ${prompt}    ${value}

Assert new '${validation}' validation '${prompt}' edited
    [Documentation]    Check new prompt edited

    ${value}    Run Keyword If    '${validation}'=='dynamic'    Set Variable    D
    ...    ELSE IF    '${validation}'=='numeric'    Set Variable    N
    Assert new '${prompt}' prompt edited message
    Assert new prompt added in db    ${prompt}    ${value}

Assert new dynamic pin prompt error message
    [Documentation]    Check dynamic validation duplicate not available message

    Page Should Contain    That policy already has another dynamic validation recorded

Remove permission and repeat the steps to check no dynamic validation available
    [Documentation]    Repeat validations for no permission when feature flag is off

    Close Browser
    Remove Manager Dynamic Pin Permission from Carrier
    Login Carrier with Policies to eManager
    Go to Select Program > Manage Policies > Manage Policies
    # Check CNTN
    Delete prompts available for dynamic pin from db
    Reload Page
    Dynamic pin dropdown must not be displayed
    Check no dynamic validation available for 'Control Number' ('CNTN')
    # Check DRID
    Delete prompts available for dynamic pin from db
    Click on 'Cancel'
    Check no dynamic validation available for 'Driver ID' ('DRID')
    # Check PPIN
    Delete prompts available for dynamic pin from db
    Click on 'Cancel'
    Check no dynamic validation available for 'Personal ID Number' ('PPIN')

Check no dynamic validation available for '${prompt}' ('${prompt_id}')
    [Documentation]    Check dynamic validation not available for prompts in adition or edition

    Click to add a new prompt
    Select '${prompt}' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new '${prompt_id}' prompt added message
    Click to edit new '${prompt}' prompt
    Option 'Dynamic' must not be displayed in the options list

Assert no dynamic option for prompts different than Driver ID, Personal ID Number and Control Number
    [Documentation]    Ensure dynamic validation is not an option from prompts where it should not be available

    ${list}    Get List Items    name=cardInfo.infoId
    Remove Values From List    ${list}    Driver ID    Personal ID Number    Control Number
    FOR    ${option}    IN    @{list}
        Select '${option}' from prompt list
        Click on 'Next'
        Option 'Dynamic' must not be displayed in the options list
        Click on 'Back'
    END