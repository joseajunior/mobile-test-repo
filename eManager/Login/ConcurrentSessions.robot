*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup    Run Keywords    Setup Test Carrier    Remove Salesforce Data Capture App Completed
Test Teardown  Run Keywords    Log Out of Emanager    Close Browser    Remove 'MCD' Max Concurrent Attribute
...    Remove 'MC' Max Concurrent Attribute    Ensure Feature Flag FLAG_ATLAS-2113 is off
Suite Teardown    Disconnect From Database

Force Tags  eManager

*** Variables ***
${carrier}
${login_count}
${attribute}    Allow Max Concurrent Logins
${max_conc_val}
${act_conc_val}

*** Test Cases ***
Concurrent session set via management
    [Tags]    JIRA:ATLAS-2113    JIRA:BOT-5055    qTest:119299993    Q1:2023
    [Documentation]  Ensure concurrent session is being exhibited properly when set via Manage Company Defaults and
    ...    Manage Companies
    [Setup]    Run Keywords    Ensure Feature Flag FLAG_ATLAS-2113 is on    Remove 'MCD' Max Concurrent Attribute
    ...    Remove 'MC' Max Concurrent Attribute    Get Login Count from Carrier

    Log Carrier into eManager with Test Carrier
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MCD' Max Concurrent Attribute with login count + random value
    Log Carrier into eManager with Test Carrier Again
    Check concurrent session message
    Change screen and come back
    Check concurrent session message
    Set 'MCD' Max Concurrent Attribute with login count
    Set 'MC' Max Concurrent Attribute with login count + random value
    Log Carrier into eManager with Test Carrier Again
    Check concurrent session message
    Change screen and come back
    Check concurrent session message

Concurrent User Sessions with feature flag off
    [Tags]    JIRA:ATLAS-2113    JIRA:BOT-5055    qTest:119299996    Q1:2023
    [Documentation]  Ensure Concurrent User Sessions feature is not available when the flag is off
    [Setup]    Run Keywords    Ensure Feature Flag FLAG_ATLAS-2113 is off    Get Login Count from Carrier
    ...    Remove 'MCD' Max Concurrent Attribute    Remove 'MC' Max Concurrent Attribute

    Log Carrier into eManager with Test Carrier
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MCD' Max Concurrent Attribute with login count + random value
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MCD' Max Concurrent Attribute with login count
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MC' Max Concurrent Attribute with login count + random value
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MC' Max Concurrent Attribute with login count
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions

Login blocked for concurrent session limit exceeded
    [Tags]    JIRA:ATLAS-2113    JIRA:BOT-5055    qTest:119300000    Q1:2023
    [Documentation]  Ensure login is blocked for user that has exceeded the limit for concurrent user session
    [Setup]    Run Keywords    Ensure Feature Flag FLAG_ATLAS-2113 is on    Remove 'MCD' Max Concurrent Attribute
    ...    Remove 'MC' Max Concurrent Attribute    Get Login Count from Carrier

    Log Carrier into eManager with Test Carrier
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MCD' Max Concurrent Attribute with login count
    Log Carrier into eManager with Test Carrier Expecting Error
    Check concurrent session message limit exceeded error
    Set 'MCD' Max Concurrent Attribute with login count + random value
    Set 'MC' Max Concurrent Attribute with login count
    Log Carrier into eManager with Test Carrier Expecting Error
    Check concurrent session message limit exceeded error

Concurrent User Sessions without feature flag created
    [Tags]    JIRA:ATLAS-2113    JIRA:BOT-5055    qTest:119301904    Q1:2023
    [Documentation]  Ensure Concurrent User Sessions feature is not available when the flag is not in setting table
    [Setup]    Run Keywords    Ensure Feature Flag FLAG_ATLAS-2113 is not created    Get Login Count from Carrier
    ...    Remove 'MCD' Max Concurrent Attribute    Remove 'MC' Max Concurrent Attribute

    Log Carrier into eManager with Test Carrier
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MCD' Max Concurrent Attribute with login count + random value
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MCD' Max Concurrent Attribute with login count
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MC' Max Concurrent Attribute with login count + random value
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions
    Set 'MC' Max Concurrent Attribute with login count
    Log Carrier into eManager with Test Carrier Again
    Check no messages for concurrent sessions
    Change screen and come back
    Check no messages for concurrent sessions

*** Keywords ***
Setup Feature Flag for ATLAS-2113
    [Arguments]    ${created}=${True}    ${value}=Y
    [Documentation]    Setup the FLAG_ATLAS-2113 feature flag with a value or remove it setting create to false

    Get Into DB    MYSQL
    ${select_query}    Catenate    SELECT *
    ...    FROM setting
    ...    WHERE `partition` = 'shared'
    ...    AND name = 'FLAG_ATLAS-2113';
    ${has_feat_flag}    Run Keyword And Return Status    Row Count Is Equal to X    ${select_query}    1
    Run Keyword And Return If    ${created}==${False} and ${has_feat_flag}==${True}    Delete Feature Flag
    Return From Keyword If    ${created}==${False}
    Run Keyword And Return If    ${has_feat_flag}==${False}    Add Feature Flag as '${value}'
    Update Feature Flag to '${value}'

Delete Feature Flag
    [Documentation]    Remove the FLAG_ATLAS-2113 feature flag

    ${delete_query}    Catenate    DELETE FROM teslsm.setting
    ...    WHERE `partition` = 'shared'
    ...    AND name = 'FLAG_ATLAS-2113';
    Execute SQL String    ${delete_query}

Add Feature Flag as '${value}'
    [Documentation]    Add the FLAG_ATLAS-2113 feature flag with a value

    ${insert_query}    Catenate    INSERT INTO teslsm.setting
    ...    VALUES ('shared', 'FLAG_ATLAS-2113', '${value}');
    Execute SQL String    ${insert_query}

Update Feature Flag to '${value}'
    [Documentation]    Update the FLAG_ATLAS-2113 feature flag with a value

    ${update_query}    Catenate    UPDATE teslsm.setting
    ...    SET value = '${value}'
    ...    WHERE `partition` = 'shared'
    ...    AND name = 'FLAG_ATLAS-2113';
    Execute SQL String    ${update_query}

Ensure Feature Flag FLAG_ATLAS-2113 is not created
    [Documentation]    Ensure Feature Flag FLAG_ATLAS-2113 is not created

    Setup Feature Flag for ATLAS-2113    ${False}

Ensure Feature Flag FLAG_ATLAS-2113 is on
    [Documentation]    Ensure Feature Flag FLAG_ATLAS-2113 is on

    Setup Feature Flag for ATLAS-2113    value=Y

Ensure Feature Flag FLAG_ATLAS-2113 is off
    [Documentation]    Ensure Feature Flag FLAG_ATLAS-2113 is off

    Setup Feature Flag for ATLAS-2113    value=N

Setup Test Carrier
    [Documentation]    Setup test carrier with efs_carrier company header

    Get Carrier ID and Password    type=TCH
    Change Company Header  ${carrier.id}  company_header=efs_carrier

Remove Salesforce Data Capture App Completed
    [Documentation]  Remove app completed value in salesforce_data_capture table

    ${salesforcedc_delete_query}  Catenate  DELETE FROM salesforce_data_capture
    ...    WHERE carrier_id = '${carrier.id}';
    Execute Sql String    ${salesforcedc_delete_query}

Get Login Count from Carrier
    [Documentation]    Get login count from carrier

    Get into DB    MYSQL
    ${select_query}    Catenate    select count(*)
    ...    from teslsm.sec_company sc
    ...    inner join teslsm.sec_user su on sc.company_id = su.company_id
    ...    inner join (select user_id
    ...    from teslsm.sec_fp_event
    ...    where event = 'LOGIN'
    ...    and event_dts >= date_sub(now(), interval 24 hour)
    ...    and api not in ('ws')
    ...    and session not in (select session
    ...    from teslsm.sec_fp_event
    ...    where event = 'LOGOUT'
    ...    and event_dts >= date_sub(now(), interval 24 hour)
    ...    and api not in ('ws'))) sfe on sfe.user_id = su.user_id
    ...    where su.user_id in (${carrier.id});
    ${login_count}    Query And Strip    ${select_query}
    Set Test Variable    ${login_count}

Update Allow Max Concurrent Logins from Manage Company Defaults
    [Arguments]    ${created}=${True}    ${value}=${login_count}    ${company}=EFS Carrier
    [Documentation]    Setup Allow Max Concurrent Logins with a value for company set or remove it setting create to
    ...    false in Manage Company Defaults

    Get Into DB    MYSQL
    ${select_query}    Catenate    select *
    ...    from company_dflt_attrs
    ...    where attribute_type_id in (select id from sec_company_attribute_type where description = '${attribute}')
    ...    and company_dflts_iid in (select company_dflts_iid from company_dflts where description = '${company}');
    ${has_max_conc_attr}    Run Keyword And Return Status    Row Count Is Equal to X    ${select_query}    1
    Run Keyword And Return If    ${created}==${False} and ${has_max_conc_attr}==${True}    Delete MCD Max Concurrent Attribute from '${company}'
    Return From Keyword If    ${created}==${False}
    Run Keyword And Return If    ${has_max_conc_attr}==${False}    Add MCD Max Concurrent Attribute to '${company}' as '${value}'
    Update MCD Max Concurrent Attribute from '${company}' to '${value}'

Delete MCD Max Concurrent Attribute from '${company}'
    [Documentation]    Remove Allow Max Concurrent Logins attribute from Manage Company Defaults

    ${delete_query}    Catenate    delete from company_dflt_attrs
    ...    where attribute_type_id in (select id from sec_company_attribute_type where description = '${attribute}')
    ...    and company_dflts_iid in (select company_dflts_iid from company_dflts where description = '${company}');
    Execute SQL String    ${delete_query}

Add MCD Max Concurrent Attribute to '${company}' as '${value}'
    [Documentation]    Add Allow Max Concurrent Logins attribute with a value in Manage Company Defaults

    ${select_query}    Catenate    select company_dflts_iid
    ...    from company_dflts where description = '${company}';
    ${company_id}    Query And Strip    ${select_query}
    ${select_query}    Catenate    select id from sec_company_attribute_type
    ...    where description = '${attribute}';
    ${attr_type_id}    Query And Strip    ${select_query}
    ${insert_query}    Catenate    insert into company_dflt_attrs
    ...    (company_dflts_iid, attribute_type_id, def_value)
    ...    values ('${company_id}', ${attr_type_id}, '${value}');
    Execute SQL String    ${insert_query}

Update MCD Max Concurrent Attribute from '${company}' to '${value}'
    [Documentation]    Update Allow Max Concurrent Logins attribute with a value in Manage Company Defaults

    ${update_query}    Catenate    update company_dflt_attrs set def_value = '${value}'
    ...    where attribute_type_id in (select id from sec_company_attribute_type where description = '${attribute}')
    ...    and company_dflts_iid in (select company_dflts_iid from company_dflts where description = '${company}');
    Execute SQL String    ${update_query}

Update Allow Max Concurrent Logins from Manage Companies
    [Arguments]    ${created}=${True}    ${value}=${login_count}
    [Documentation]    Setup Allow Max Concurrent Logins with a value for carrier set or remove it setting create to
    ...    false in Manage Companies

    Get Into DB    MYSQL
    ${select_query}    Catenate    select *
    ...    from sec_company_attribute
    ...    where type_id in (select id from sec_company_attribute_type where description = '${attribute}')
    ...    and company_id in (select company_id from sec_user where user_id = '${carrier.id}');
    ${has_max_conc_attr}    Run Keyword And Return Status    Row Count Is Equal to X    ${select_query}    1
    Run Keyword And Return If    ${created}==${False} and ${has_max_conc_attr}==${True}    Delete MC Max Concurrent Attribute
    Return From Keyword If    ${created}==${False}
    Run Keyword And Return If    ${has_max_conc_attr}==${False}    Add MC Max Concurrent Attribute as '${value}'
    Update MC Max Concurrent Attribute to '${value}'

Delete MC Max Concurrent Attribute
    [Documentation]    Remove Allow Max Concurrent Logins attribute from Manage Companies

    ${delete_query}    Catenate    delete from sec_company_attribute
    ...    where type_id in (select id from sec_company_attribute_type where description = '${attribute}')
    ...    and company_id in (select company_id from sec_user where user_id = '${carrier.id}');
    Execute SQL String    ${delete_query}

Add MC Max Concurrent Attribute as '${value}'
    [Documentation]    Add Allow Max Concurrent Logins attribute with a value in Manage Companies

    ${select_query}    Catenate    select company_id from sec_user where user_id = '${carrier.id}';
    ${company_id}    Query And Strip    ${select_query}
    ${select_query}    Catenate    select id from sec_company_attribute_type
    ...    where description = '${attribute}';
    ${attr_type_id}    Query And Strip    ${select_query}
    ${insert_query}    Catenate    insert into sec_company_attribute
    ...    (type_id, company_id, value)
    ...    values (${attr_type_id}, '${company_id}', '${value}');
    Execute SQL String    ${insert_query}

Update MC Max Concurrent Attribute to '${value}'
    [Documentation]    Update Allow Max Concurrent Logins attribute with a value in Manage Companies

    ${update_query}    Catenate    update sec_company_attribute set value = '${value}'
    ...    where type_id in (select id from sec_company_attribute_type where description = '${attribute}')
    ...    and company_id in (select company_id from sec_user where user_id = '${carrier.id}');
    Execute SQL String    ${update_query}

Set '${manage_type}' Max Concurrent Attribute with login count + random value
    [Documentation]    Setting Allow Max Concurrent Logins attribute with login count + random value
    ...    MCD for Manage Company Defaults and MC for Manage Companies

    ${rand_val}    Generate Random String    2    [NUMBERS]
    ${rand_val}    Convert To Integer    ${rand_val}
    ${rand_val}    Evaluate    ${rand_val}+1
    ${act_conc_val}    Evaluate    ${rand_val}-1
    Set Test Variable    ${act_conc_val}
    ${rand_val}    Evaluate    ${rand_val}+${login_count}
    Set Test Variable    ${max_conc_val}    ${rand_val}
    Run Keyword If    '${manage_type}'=='MCD'    Update Allow Max Concurrent Logins from Manage Company Defaults    value=${rand_val}
    Run Keyword If    '${manage_type}'=='MC'    Update Allow Max Concurrent Logins from Manage Companies    value=${rand_val}

Set '${manage_type}' Max Concurrent Attribute with login count
    [Documentation]    Setting Allow Max Concurrent Logins attribute with login count
    ...    MCD for Manage Company Defaults and MC for Manage Companies

    Run Keyword If    '${manage_type}'=='MCD'    Update Allow Max Concurrent Logins from Manage Company Defaults
    Run Keyword If    '${manage_type}'=='MC'    Update Allow Max Concurrent Logins from Manage Companies

Set '${manage_type}' Max Concurrent Attribute empty
    [Documentation]    Setting Allow Max Concurrent Logins attribute empty
    ...    MCD for Manage Company Defaults and MC for Manage Companies

    Run Keyword If    '${manage_type}'=='MCD'    Update Allow Max Concurrent Logins from Manage Company Defaults    value=${EMPTY}
    Run Keyword If    '${manage_type}'=='MC'    Update Allow Max Concurrent Logins from Manage Companies    value=${EMPTY}

Remove '${manage_type}' Max Concurrent Attribute
    [Documentation]    Deleting Allow Max Concurrent Logins attribute
    ...    MCD for Manage Company Defaults and MC for Manage Companies

    Run Keyword If    '${manage_type}'=='MCD'    Update Allow Max Concurrent Logins from Manage Company Defaults    ${False}
    Run Keyword If    '${manage_type}'=='MC'    Update Allow Max Concurrent Logins from Manage Companies    ${False}

Log Carrier into eManager with Test Carrier
    [Documentation]  Log Carrier into eManager with Test Carrier

    Open eManager    ${carrier.id}    ${carrier.password}    ChangeCompanyHeader=${False}

Log Carrier into eManager with Test Carrier Again
    [Documentation]  Log Carrier into eManager with Test Carrier Again

    Log Out of Emanager
    Close Browser
    Open eManager    ${carrier.id}    ${carrier.password}    ChangeCompanyHeader=${False}

Log Carrier into eManager with Test Carrier Expecting Error
    [Documentation]  Log Carrier into eManager with Test Carrier Expecting Error

    Close Browser
    Run Keyword And Ignore Error    Open eManager    ${carrier.id}    ${carrier.password}    ChangeCompanyHeader=${False}

Check no messages for concurrent sessions
    [Documentation]    Check no messages for concurrent sessions

    Wait Until Page Contains    ${carrier.id}
    Page Should Not Contain Element     //*[@class='messages']/li

Check concurrent session message
    [Documentation]    Check concurrent session message as 'You currently have (value) concurrent logins, with (value)
    ...    more to go.'

    Wait Until Page Contains    ${carrier.id}
    ${message}    Get Text    //*[@class='messages']/li
    Should Be Equal as Strings    ${message}    You currently have (${max_conc_val}) concurrent logins, with (${act_conc_val}) more to go.

Check concurrent session message limit exceeded error
    [Documentation]    Check concurrent session message limit exceeded error as 'Your user login exceeded the number of
    ...    the max concurrent login.'

    Wait Until Element is Visible    //*[@class='errors']
    Page Should Contain    Your user login exceeded the number of the max concurrent login.

Change screen and come back
    [Documentation]    Go to another screen and come back to do the message check

    Click Element    //*[contains(text(), "Profile")]
    Wait Until Page Contains    Edit User Profile
    Click Element    //*[contains(text(), "Home")]
    Wait Until Page Contains    ${carrier.id}