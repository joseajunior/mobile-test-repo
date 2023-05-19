*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

*** Variables ***
${carrier}
${info_pool}
${permission_status}

*** Test Cases ***
Manage Info Pool - Search Info Pool Using a Related Value on Policy 1
    [Tags]  JIRA:FRNT-984  JIRA:ROCKET-15  JIRA:BOT-3219  qTest:52621380  PI:6  API:Y
    [Documentation]  This test will check if user can do a search using Info Pool Related Value.
    [Setup]  Get Carrier with info pools  1

    Log into eManager with a Carrier That has Manage Info Pool Role
    Navigate to Select Program > Manage Info Pool
    Select a Policy
    Select a Prompt
    Input Related Value on Search Value
    Perform a Search
    Check if Value is Displayed  ${info_pool['value'].strip()}

    [Teardown]  Clean up Search

Manage Info Pool - Search Info Pool Using a Related Value on All Policy
    [Tags]  JIRA:FRNT-984  JIRA:ROCKET-15  JIRA:BOT-3219  qTest:52621384  PI:10  API:Y
    [Documentation]  This test will check if user can do a search using Info Pool Related Value.
    [Setup]  Get Carrier with info pools  0

    Log into eManager with a Carrier That has Manage Info Pool Role
    Navigate to Select Program > Manage Info Pool
    Select a Prompt
    Input Related Value on Search Value
    Perform a Search
    Check if Value is Displayed  ${info_pool['value'].strip()}

    [Teardown]  Clean up Search

Manage Info Pool - Add info pool on Policy 1 with related id
    [Tags]  JIRA:ROCKET-15  qTest:52621385  PI:10  API:Y
    [Documentation]  This test will check if user can do a search using Info Pool Related Value.
    [Setup]  Get Carrier with info pools  1

    Log into eManager with a Carrier That has Manage Info Pool Role
    Navigate to Select Program > Manage Info Pool
    Select a Policy
    Select a Prompt
    Click Add Info Pool Item
    Fill out new prompt  ${random_number}  BLID  ${random_number2}
    Click Add to create new prompt
    Input Related Value on Search Value  ${random_number}
    Perform a Search
    Check if Value is Displayed  ${random_number}
    Check if Value is Displayed  ${random_number2}
    Check if Value is Displayed  BILLING ID

    [Teardown]  Clean up

Manage Info Pool - Add info pool on All Policy with related id
    [Tags]  JIRA:ROCKET-15  qTest:52621386  PI:10  API:Y
    [Documentation]  This test will check if user can do a search using Info Pool Related Value.
    [Setup]  Get Carrier with info pools  0

    Log into eManager with a Carrier That has Manage Info Pool Role
    Navigate to Select Program > Manage Info Pool
    Select a Prompt
    Click Add Info Pool Item
    Fill out new prompt  ${random_number}  BLID  ${random_number2}
    Click Add to create new prompt
    Input Related Value on Search Value  ${random_number}
    Perform a Search
    Check if Value is Displayed  ${random_number}
    Check if Value is Displayed  ${random_number2}
    Check if Value is Displayed  BILLING ID

    [Teardown]  Clean up

Manage Info Pool - Add info pool on Policy 1 without related id
    [Tags]  JIRA:ROCKET-15  qTest:52622098  PI:10  API:Y
    [Documentation]  This test will check if user can do a search using Info Pool Related Value.
    [Setup]  Get Carrier with info pools  1

    Log into eManager with a Carrier That has Manage Info Pool Role
    Navigate to Select Program > Manage Info Pool
    Select a Policy
    Select a Prompt
    Click Add Info Pool Item
    Fill out new prompt  ${random_number}
    Click Add to create new prompt
    Input Related Value on Search Value  ${random_number}
    Perform a Search
    Check if Value is Displayed  ${random_number}

    [Teardown]  Clean up

Manage Info Pool - Add info pool on All Policy without related id
    [Tags]  JIRA:ROCKET-15  qTest:52622100  PI:10  API:Y
    [Documentation]  This test will check if user can do a search using Info Pool Related Value.
    [Setup]  Get Carrier with info pools  0

    Log into eManager with a Carrier That has Manage Info Pool Role
    Navigate to Select Program > Manage Info Pool
    Select a Prompt
    Click Add Info Pool Item
    Fill out new prompt  ${random_number}
    Click Add to create new prompt
    Input Related Value on Search Value  ${random_number}
    Perform a Search
    Check if Value is Displayed  ${random_number}

    [Teardown]  Clean up

Add Infopools for Ryder Child
    [Tags]  JIRA:ROCKET-214  qtest:56243205  PI:13  API:Y
    [Setup]  Find a Ryder Child
    Open eManager  ${intern}  ${internPassword}
    Switch to "${carrier.id}" user
    Navigate to Select Program > Manage Info Pool
    Get the Prompts
    Add Back Card Child Prompt

    [Teardown]  Clean up Search

Add Infopools for Non-Child-Carrier
    [Tags]  JIRA:ROCKET-283  qtest:98663705  PI:14  API:Y
    [Setup]  Get a non-child carrier
    Open eManager  ${intern}  ${internPassword}
    Switch to "${carrier.id}" user
    Navigate to Select Program > Manage Info Pool
    Get the Prompts
    Update Infopools Flag   N

    [Teardown]  Clean up Search

*** Keywords ***
Clean up
    [Tags]  qtest
    [Documentation]  If the permission MANAGE_INFOPOOL was added Remove it from the carrier after test
    ...  follow  TC-5253 (Remove Permission from User)
    ...  remove the prompt added by clicking red x
    ...  close browser because you are done!!
    Remove Permission if added
    Delete Info Pool Prompt
    Close Browser

Clean up Search
    [Tags]  qtest
    [Documentation]  If the permission MANAGE_INFOPOOL was added Remove it from the carrier after test
    ...  follow  TC-5253 (Remove Permission from User)
    ...  close browser because you are done!!
    Remove Permission if added
    Close Browser

Get Carrier with info pools
    [Tags]  qtest
    [Documentation]  Find a group of carriers that have logged in to emanager
    ...  in mysql SELECT user_id FROM sec_user_role_xref WHERE user_id REGEXP '^[0-9]+$'
    ...  then use that list to find a carrier with info_values for desired policy
    ...  NOTE: remove 'and i.ipolicy=d.ipolicy' from sql if doing policy 0
    ...  select * from member where member_id in (SELECT DISTINCT i.carrier_id from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.ipolicy=d.ipolicy and i.related_value IS NOT NULL AND i.carrier_id IN {list of carriers from mysql}
    ...  AND i.carrier_id NOT IN ('100025') and i.ipolicy ={policy});
    ...  with a carrier now get the list of info pool options
    ...  -------------------
    ...  Find a carriers info pool Items already setup
    ...  This sql is for policy greater than 0
    ...  SELECT i.* from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.ipolicy=d.ipolicy and i.related_value IS NOT NULL AND i.carrier_id IN ({carrier.id}) AND i.ipolicy = {policy} Limit 1;
    ...  This is for Policy 0
    ...  SELECT i.* from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.related_value IS NOT NULL AND i.carrier_id IN ({carrier.id}) AND i.ipolicy = {policy} Limit 1;
    ...  --------------------
    ...  Verify user has permission MANAGE_INFOPOOL follow TC-4254
    [Arguments]  ${policy}

    Get Into DB  Mysql

#Get user_id with desired permission to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user_role_xref WHERE user_id REGEXP '^[0-9]+$' LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    IF  ${policy} != 0
    ${query}  Catenate  select * from member where member_id in (SELECT DISTINCT i.carrier_id from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.ipolicy=d.ipolicy and i.related_value IS NOT NULL AND i.carrier_id IN ${list_2}
    ...    AND i.carrier_id NOT IN ('100025') and i.ipolicy =${policy});
    ELSE
    ${query}  Catenate  select * from member where member_id in (SELECT DISTINCT carrier_id FROM info_pool WHERE related_value IS NOT NULL AND carrier_id IN ${list_2}
    ...    AND carrier_id NOT IN ('100025') and ipolicy =${policy})
    END

    ${carrier}  Find Carrier Variable  ${query}  member_id
    set test variable  ${policy}

    Set Test Variable  ${carrier}

    ${random_number}  Generate random string    4    0123456789
    ${random_number2}  Generate random string    6    0123456789
    set test variable  ${random_number}
    set test variable  ${random_number2}
    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_INFOPOOL

    Get Carrier Info Pool Data

Remove Permission if added
    [Tags]  qtest
    [Documentation]  If the permission MANAGE_INFOPOOL was added Remove it from the carrier after test

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  MANAGE_INFOPOOL

Add Back Card Child Prompt
    [Tags]  qtest
    [Documentation]    Add back the PARENT_POLICY_CARD_PROMPT to the Ryder parent
    Ensure Carrier has User Permission  197997  PARENT_POLICY_CARD_PROMPT


Get Carrier Info Pool Data
    [Tags]  qtest
    [Documentation]  Find a carriers info pool Items already setup
    ...  This sql is for policy greater than 0
    ...  SELECT i.* from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.ipolicy=d.ipolicy and i.related_value IS NOT NULL AND i.carrier_id IN ({carrier.id}) AND i.ipolicy = {policy} Limit 1;
    ...  This is for Policy 0
    ...  SELECT i.* from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.related_value IS NOT NULL AND i.carrier_id IN ({carrier.id}) AND i.ipolicy = {policy} Limit 1;

    Get Into DB  TCH
    IF  ${policy}!=0
      ${query}  Catenate  SELECT i.* from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.ipolicy=d.ipolicy and i.related_value IS NOT NULL AND i.carrier_id IN (${carrier.id}) AND i.ipolicy = ${policy} Limit 1;
    ELSE
      ${query}  Catenate  SELECT i.* from info_pool i, def_info d where i.carrier_id = d.carrier_id and i.info_id = d.info_id and i.related_value IS NOT NULL AND i.carrier_id IN (${carrier.id}) AND i.ipolicy = ${policy} Limit 1;
    END
    ${info_pool}  Query And Strip to Dictionary  ${query}

    Set Test Variable  ${info_pool}

Log into eManager with a Carrier That has Manage Info Pool Role
    [Tags]  qtest
    [Documentation]  Login on Emanager Follow TC-5602 (Basic - Login to E-Manager with TCH Carrier and Secure Entry/Token)

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Manage Info Pool
    [Tags]  qtest
    [Documentation]  Go to Select Program > Manage info pool to get to see info pool

    Go To  ${emanager}/cards/InfoPoolManagement.action

Select a Policy
    [Tags]  qtest
    [Documentation]  Click on the radio button for Policy
    ...  Then select desired policy from the policy dropdown
    Select Radio Button  infoPoolPolicyChoice  BY_POLICY
    Select From List by Value  //select[@name='ipolicyV2']  ${info_pool['ipolicy'].__str__()}

Select a Prompt
    [Tags]  qtest
    [Documentation]  Select a Prompt from the Prompt dropdown

    Select From List by Value  //select[@name='prompt']  ${info_pool['info_id'].__str__()}

Input Related Value on Search Value
    [Arguments]  ${value}=${info_pool['related_value'].__str__().strip()}
    [Tags]  qtest
    [Documentation]  Input Related Value on Search Value Text box.

    Input Text  //input[@name='filterValue']  ${value}

Fill out new prompt
    [Tags]  qtest
    [Documentation]  In the Value text box put in desired values
    ...  OPTIONAL: Open the drop down for related id and select option
    ...  OPTIONAL: In the Related Value text box put in desired values
    [Arguments]  ${value}  ${Related_id}=SKIP  ${related_value}=1234
    Input Text  //input[@name='value']  ${value}
    IF  '${Related_id}'!='SKIP'
      Select From List by Value  //select[@name='relatedId']  ${Related_id}
      Input Text  //input[@name='relatedValue']  ${related_value}
    END

Delete Info Pool Prompt
    [Tags]  qtest
    [Documentation]  Click the red X to remove the prompt you added
    click element  //table[@id='infoPoolItem']//td[contains(text(),'${random_number}')]/parent::tr//input[@name='deleteInfoPoolPrompt']
    handle alert

Perform a Search
    [Tags]  qtest
    [Documentation]  Click the Refresh button.

    Click Element  //input[@name='submitFilterValue']

Click Add info pool Item
    [Tags]  qtest
    [Documentation]  Click button.

    Click Element  //input[@name='redirectToAddInfoPool']

Click Add to create new prompt
    [Tags]  qtest
    [Documentation]  save the new prompt.

    Click Element  //input[@name='addInfoPool']

Check if Value is Displayed
    [Tags]  qtest
    [Documentation]  Verify on the page that the values selected appear in the table generated
    [Arguments]  ${value}

    Element Should be Visible  //table[@id='infoPoolItem']//tr//td[contains(text(),'${value}')]

Find a Ryder Child
    [Tags]  qtest
    [Documentation]  Find valid list of children for the Ryder Parent 197997:
            ...  select x.carrier_id
            ...  from carrier_group_xref x
            ...     INNER JOIN member m ON m.member_id = x.carrier_id
            ...  where parent = 197997
            ...    and effective_date < current
            ...    and expire_date > current;
    ${db}  catenate  tch
    set test variable  ${db}
    ${sql}  catenate  select x.carrier_id
            ...  from carrier_group_xref x
            ...     INNER JOIN member m ON m.member_id = x.carrier_id
            ...  where parent = 197997
            ...    and effective_date < current
            ...    and expire_date > current;
    ${ryder_children}  query and strip to list  ${sql}  db_instance=${db}
    set test variable  ${ryder_children}
    ${list}  catenate  ${ryder_children}
    ${list}  replace string  ${list}  ]  ${EMPTY}
    ${list}  replace string  ${list}  [  ${EMPTY}
    ${sql2}  catenate  select user_id from sec_user where user_id IN (${list});
    ${users}  query and strip to list  ${sql2}  db_instance=mysql
    ${carrier.id}  evaluate  random.choice(${users})
    set test variable  ${carrier.id}
    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_INFOPOOL
    Remove Carrier User Permission  197997  PARENT_POLICY_CARD_PROMPT

get the prompts
    [Tags]  qtest
    [Documentation]  Add a series of prompts and related values. Verify the changes in the postgres database:
            ...  select * from infopool where carrier_id = <carrier_id>> and pool_type = <pool_type>;
            ...  select * from related_values where pool_id = <pool_id>;
    @{prompt_list}  Get List Items  promptSelect  values=True
    remove from list  ${prompt_list}  0

    ${today}  getDateTimeNow  %d
    set test variable    ${today}

    FOR  ${prompt_id}  IN  @{prompt_list}
        ${value}  Generate Random String  6
        Add "${prompt_id}" prompt with "${value}" value
        Add related values on "${prompt_id}" with "${value}" value
        click element  //table[@id='infoPoolItem']//td[contains(text(),'${value}')]/parent::tr//input[@name='deleteInfoPoolPrompt']
        handle alert
        exit for loop if    '${today}'!='01'
    END

Add related values on "${prompt_id}" with "${value}" value
    click element  redirectToEditInfoPool
    ${value}  get value  value
    wait until element is visible  remainingRelPrompts
    @{related_list}  Get List Items  remainingRelPrompts  values=True
    remove from list  ${related_list}  0
    @{related_values}  create list
    FOR  ${item}  IN  @{related_list}
        ${rvalue}  Generate Random String  6
        Wait Until Element Is Enabled  remainingRelPrompts
        Select From List by Value  remainingRelPrompts  ${item}
        Wait Until Element Is Enabled  newPromptId
        input text  newPromptId  ${rvalue}
        wait until element is not visible  class=loading-img
        Wait Until Element Is Enabled  btnSubmit
        click button  btnSubmit
        wait until element is not visible  class=loading-img
        sleep  1s
        append to list  ${related_values}  ${rvalue}
        Verify "${rvalue}" on "${prompt_id}" with "${value}"
        exit for loop if    '${today}'!='01'
    END
    click button  back
    wait until element is visible  deleteInfoPoolPrompt

Add "${prompt}" prompt with "${value}" value
    Select From List by Value  promptSelect  ${prompt}
    click button  redirectToAddInfoPool
    wait until element is visible  addInfoPool
    input text  value  ${value}
    click button  addInfoPool
    wait until element is visible  redirectToAddInfoPool

Verify "${item}" on "${prompt_id}" with "${value}"
    ${sql}  catenate  select pool_id from infopool where pool_type = '${prompt_id}' and pool_value = '${value}';
    ${pool_id}  query and strip  ${sql}  db_instance=infopool
    ${sql2}  catenate  select related_value from related_values where pool_id = ${pool_id}
    ${related_values_list}  query and strip to list  ${sql2}  db_instance=infopool
    List Should contain value   ${related_values_list}  ${item}
    ${sql3}  catenate  delete from related_values where pool_id = ${pool_id}
    execute sql string  ${sql3}  db_instance=infopool

Get a non-child carrier
    [Tags]  qtest
    [Documentation]    Look for a carrier id that isn't a child of any parent and is active:
            ...     SELECT FIRST 10 m.member_id FROM member m WHERE m.mem_type = 'C' AND m.status = 'A'
            ...     AND m.member_id not in (select carrier_id from carrier_group_xref UNION select carrier_id from carrier_referral_xref);
            ...     Add the INFOPOOLAPI key and set it to 'Y' for this carrier's member_meta:
            ...     insert into member_meta (member_id,mm_key,mm_value) values (carrier.id,'INFOPOOLAPI', 'Y');
            ...     And add the permission MANAGE_INFOPOOL to this carrier
    ${sql}    catenate  SELECT FIRST 10 m.member_id FROM member m WHERE m.mem_type = 'C' AND m.status = 'A'
    ...     AND m.member_id not in (select carrier_id from carrier_group_xref UNION select carrier_id from carrier_referral_xref)
    ${carrier_list}   query and strip to list  ${sql}  db_instance=tch
    ${carrier.id}  evaluate  random.choice(${carrier_list})
    set test variable    ${carrier.id}
    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_INFOPOOL
    Update Infopools Flag   Y

Update Infopools Flag
    [Tags]  qtest
    [Documentation]    Check if the member_meta table has an INFOPOOLAPI mm_key for the test's carrier and insert/update its flag.
            ...        update member_meta set mm_value = <Y/N> where mm_key = 'INFOPOOLAPI' and member_id = <carrier_id>
            ...        insert into member_meta (member_id,mm_key,mm_value) values (<carrier_id>,'INFOPOOLAPI', <Y/N>);
    [Arguments]    ${value}
    ${select_sql}   catenate    select member_id from member_meta where mm_key = 'INFOPOOLAPI' AND member_id = ${carrier.id}
    ${update_sql}    catenate    update member_meta set mm_value = '${value}' where mm_key = 'INFOPOOLAPI' and member_id = ${carrier.id}
    ${insert_sql}  catenate  insert into member_meta (member_id,mm_key,mm_value) values (${carrier.id},'INFOPOOLAPI', '${value}');

    ${member_id}    query and strip    ${select_sql}    db_instance=tch
    IF  ${member_id}==None
        execute sql string  dml=${insert_sql}  db_instance=tch
    ELSE
        execute sql string  dml=${update_sql}  db_instance=tch
    END