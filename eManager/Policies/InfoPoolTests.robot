*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  otr_robot_lib.auth.PyAuth.Transactions
Library  otr_robot_lib.setup.PySetup  restore_on_close=False
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Documentation  This script suite is design to test the info pools by adding, deleting, changing related values /n/n
...  The test cases are numbered and orderes as it is on https://jira.efsllc.com/browse/BOT-213/n/n


Force Tags  eManager
Suite Setup  Set Me Up

*** Variables ***
${DB}  TCH
${MANAGE_INFOPOOL_ROLE}  MANAGE_INFOPOOL
${EMPTY_LIST}  []
${anotherCard}
${user}
${pass}
${policy}

*** Test Cases ***
New Prompts for Ryder Carrier - Info Pool
    [Tags]  JIRA:ROCKET-219  qtest:55360813  PI:13  API:Y
    [Setup]  Find Ryder Carrier
    Switch to "${ryder_carrier}" User
    Verify New Prompts - Info Pool

    [Teardown]  close browser


Create an Info Pool Prompt
    [Documentation]  On going
    [Tags]  JIRA:BOT-213
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Clean Policy Prompts and Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Manage Policies Page
    Add "TRLR" Prompt To Policy "${policy}" Using Info Pool Validation
    Ensure "TRLR" Prompt Was Inserted In DB
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Managing Info Pool with Related Value
    [Documentation]  On going
    [Tags]  JIRA:BOT-213  qTest:32331635  Regression
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "DRID" Info Pool Was Inserted In DB
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Managing Info Pool Without Related Value
    [Documentation]  On going
    [Tags]  JIRA:BOT-213
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And Empty Related Value Then Add Item
    Ensure "Policy, prompt, value and Related Value are all required." Error Message
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Managing Info Pool Without Value
    [Documentation]  On going
    [Tags]  JIRA:BOT-213
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add Item Without Info Pool Value, Related Id and Related Value
    Ensure "Policy, prompt, and value are all required." Error Message
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Try add duplicate info pool value
    [Documentation]  On going
    [Tags]  JIRA:BOT-213
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "DRID" Info Pool Was Inserted In DB
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "Prompt already exists" Error Message
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Delete Info Pool Value
    [Documentation]  On going
    [Tags]  JIRA:BOT-213
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "DRID" Info Pool Was Inserted In DB
    Remove "deleteInfoPoolPrompt" Info Pool
    Ensure "DRID" Info Pool Was Deleted From DB
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Edit Info Pool Value Shouldn't Be Allowed
    [Documentation]  On going
    [Tags]  JIRA:BOT-213
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "DRID" Info Pool Was Inserted In DB
    Select Edit Info Pool
    Ensure Info Pool Value Is Not Editable
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Edit Info Pool change delete and insert new Related Id
    [Documentation]  On going
    [Tags]  JIRA:BOT-213
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "DRID" Info Pool Was Inserted In DB
    Select Edit Info Pool
    Delete Info Pool Related Id
    Select new Related Id "UNIT" And Input "5678" as Related Value
    Ensure "DRID" Info Pool With Related Id "UNIT" and Value "5678" Was Updated In DB
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Edit Info Pool Related Value Should Be Allowed
    [Documentation]  On going
    [Tags]  JIRA:BOT-213  Regression
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials and Carrier's Policy Number
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "DRID" Info Pool Was Inserted In DB
    Select Edit Info Pool
    Change Info Pool Related Value To "998877"
    Ensure "DRID" Info Pool With Related Id "LICN", Value "5678" And Related Value "998877" Was Updated In DB
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

Run Transaction With Card Using Info Pool Prompt
    [Documentation]  On going
    [Tags]  JIRA:BOT-213  qTest:32331635  Regression
    [Setup]  Run Keywords
    ...  Define Carrier and it's credentials, Carrier's Card Number and Transaction Input
    ...  AND  Ensure Policy's Card Is Seted To Make The Card Universal
    ...  AND  Update Card "ULSD" Limit to $"100" and Increase Contract Limits to Avoid A Limit Exceed or Out Of Balance Error
    ...  AND  Add "DRID" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    ...  AND  Ensure User Has Info Pool Management Role
    ...  AND  Open eManager  ${user}  ${pass}
    Navigate To Info Pool Management Page
    Select Policy "${policy}", "DRID" Prompt And "100" Add An Info Pool Item
    Add "5678" as Info Pool Value, "LICN" as Related Id And "100" as Related Value Then Add Item
    Ensure "DRID" Info Pool Was Inserted In DB
    Run a $"10" Dollars Transaction For "ULSD" Using "5678" Info Pool Value And Make Sure It Passed
    [Teardown]  Run Keywords
    ...         Restore Policy Prompts and Info Pool Data
    ...         AND  Close Browser

*** Keywords ***
Set Me Up
        ${ac_query}=  catenate  SELECT TRIM(c.card_num) as card_num
    ...    FROM cards c
    ...        JOIN def_card dc ON c.carrier_id = dc.id AND c.icardpolicy = dc.ipolicy
    ...        JOIN contract co ON dc.contract_id = co.contract_id
    ...        JOIN member m ON c.carrier_id = m.member_id
    ...    WHERE c.card_type = 'TCH'
    ...    AND c.card_num NOT LIKE '%OVER'
    ...    AND c.status = 'A'
    ...    AND c.payr_use = 'B'
    ...    AND c.last_used > today - 90
    ...    AND co.status = 'A'
    ...    AND m.status = 'A'
    ${anotherCard}=  find card variable  ${ac_query}
    set suite variable  ${anotherCard}

Define Carrier and it's credentials and Carrier's Policy Number
    Set Test Variable  ${user}  ${anotherCard.carrier_id}
    Set Test Variable  ${pass}  ${anotherCard.carrier.password}
    Set Test Variable  ${policy}  ${anotherCard.icardpolicy.__str__()}
    Set Test Variable  ${contract}  ${anotherCard.contract.contract_id}

Define Carrier and it's credentials, Carrier's Card Number and Transaction Input
    Set Test Variable  ${user}  ${anotherCard.carrier_id}
    Set Test Variable  ${pass}  ${anotherCard.carrier.password}
    Set Test Variable  ${policy}  ${anotherCard.icardpolicy.__str__()}
    Set Test Variable  ${card}  ${anotherCard.card_num}
    Set Test Variable  ${location}  ${anotherCard.valid_location.id}
    Set Test Variable  ${contract}  ${anotherCard.contract.contract_id}
    Set Test Variable  ${transaction_prod}  ULSD

Update Card "${prod}" Limit to $"${value}" and Increase Contract Limits to Avoid A Limit Exceed or Out Of Balance Error
    Start Setup Card  ${card}
    Setup Card Header  infoSource=POLICY
    Setup Card Limits  ${prod}=${value}
    Update Contract Limits by Card  ${card}

Clean Policy Prompts and Info Pool Data
    Start Setup Policy  ${user}  ${policy}
    Clear Policy Prompts
    Backup Info Pool
    Clear Info Pool List

Add "${prompt}" With Info Pool Validation As Policy Prompt and Clear Info Pool Data
    Start Setup Policy  ${user}  ${policy}
    Setup Policy Prompts  ${prompt}=P  UNIT=V1234
    Backup Info Pool
    Clear Info Pool List

Backup Info Pool
    Get Into DB  ${DB}
    ${query}  Catenate  SELECT * FROM info_pool WHERE carrier_id = ${user} AND ipolicy = ${policy}
    ${info_pool_list}  Query To Dictionaries  ${query}
    Set Test Variable  ${info_pool_list}

Clear Info Pool List
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM info_pool WHERE carrier_id = ${user} AND ipolicy = ${policy}

Restore Policy Prompts and Info Pool Data
    ${list_size}  Get Length  ${info_pool_list}
    Run Keyword If  ${list_size} < 1
    ...  Return From Keyword
    Get Into DB  ${DB}
    FOR  ${info_pool}  IN  @{info_pool_list}
      ${related_id}  Set Variable If  ${info_pool['carrier_id']}==${None}  NULL  ${info_pool['carrier_id']}
      ${related_value}  Set Variable If  '${info_pool['related_value']}'=='${None}'  NULL  ${info_pool['related_value']}
      execute sql string  dml=insert INTO info_pool(carrier_id,info_id,value,related_id,related_value,ipolicy) VALUES (${info_pool['carrier_id']}, '${info_pool['info_id']}', '${info_pool['value']}', '${related_id}', '${related_value}', ${info_pool['ipolicy']})
    END
    Restore User Role

Navigate To Manage Policies Page
    Go To  ${emanager}/cards/PolicyPromptManagement.action

Add "${prompt}" Prompt To Policy "${policy}" Using Info Pool Validation
    Select From List By Value    name=policy.policyNumber    ${policy}
    Click Element  name=createPromptPolicy
    Select From List By Value  name=cardInfo.infoId    ${prompt}
    Click Element  name=validationInformation
    Select From List By Value   name=cardInfo.validationType  INFO_POOL
    Click Element  name=processValidationRules
    Click Element  //*[@id="nextToCheckTypeBtnA"]
    Page Should Contain Element  xpath=//ul[@class="messages"]/li[contains(text(), 'You have successfully created the prompt')]

Ensure "${prompt}" Prompt Was Inserted In DB
    Get Into DB  ${DB}
    Row Count Is Equal To X  SELECT info_id FROM def_info WHERE carrier_id = ${user} AND ipolicy = ${policy} AND info_id = '${prompt}' AND info_validation LIKE 'P%'  1

Ensure "${prompt}" Info Pool Was Inserted In DB
    Get Into DB  ${DB}
    ${infoId}  Query And Strip  SELECT info_id FROM info_pool WHERE carrier_id = ${user} and info_id = '${prompt}'
    Should Be Equal As Strings  ${infoId}  ${prompt}

Ensure "${prompt}" Info Pool Was Deleted From DB
    Sleep  2  # Time to changes reflect on DB
    Get Into DB  ${DB}
    Row Count Is 0  SELECT 1 FROM info_pool WHERE carrier_id = ${user} and info_id = '${prompt}' and ipolicy = ${policy}

Navigate To Info Pool Management Page
    go to  ${emanager}/cards/InfoPoolManagement.action

Select Policy "${policy}", "${prompt}" Prompt And "${value}" Add An Info Pool Item
    Click Element  id:policyByNum
    Select From List By Value    //*[@id="policySelect"]    ${policy}
    Select From List By Value    //*[@id="promptSelect"]    ${prompt}
    Input Text  name=filterValue   ${value}
    Click Button  name=redirectToAddInfoPool

Add "${value}" as Info Pool Value, "${related_id}" as Related Id And "${related_value}" as Related Value Then Add Item
    Input Text  name=value  ${value}
    Select From List By Value    name=relatedId    ${related_id}
    Input Text  name=relatedValue  ${related_value}
    Click Button  name=addInfoPool

Add "${value}" as Info Pool Value, "${related_id}" as Related Id And Empty Related Value Then Add Item
    Input Text  name=value  ${value}
    Select From List By Value    name=relatedId    ${related_id}
    Click Button  name=addInfoPool

Add Item Without Info Pool Value, Related Id and Related Value
    Click Button  name=addInfoPool

Run a $"${value}" Dollars Transaction For "${prod}" Using "${info_pool_value}" Info Pool Value And Make Sure It Passed
    ${ac_string}  Create Custom AC String  ${card}  ${location}  ${info_pool_value}  ${prod}  ${value.__str__()}
    ${log}  Create Log File
    Run rossAuth  ${ac_string}  ${log}
    Get Transaction ID From Log File  ${log}

Ensure "${message}" Error Message
    Wait Until Element Is Visible  //div[@class='errors']
    Page Should Contain  ${message}


Remove "${value}" Info Pool
    Click Element  (//input[@name='${value}'])[1]
    Handle Alert

Select Edit Info Pool
    Click Element  //input[@name='redirectToEditInfoPool']

Ensure Info Pool Value Is Not Editable
    Wait Until Element Is Visible  //button[@id='updateRelVal_0']
    Wait Until Element Is Visible  //button[@id='btnSubmit']
    Element Should Be Disabled  //button[@id='updateRelVal_0']
    Element Should Be Disabled  //button[@id='btnSubmit']

Delete Info Pool Related Id
    Wait Until Element Is Visible  //button[@name='delete']
    Click Element  //button[@name='delete']
    Wait Until Element Is Visible  //button[normalize-space()='Yes']
    Click Element  //button[normalize-space()='Yes']
    Sleep  5s

Select new Related Id "${related_id}" And Input "${related_value}" as Related Value
    Wait Until Element Is Visible  //select[@id='remainingRelPrompts']
    Select From List By Value  //select[@id='remainingRelPrompts']  ${related_id}
    Wait Until Element Is Visible  //input[@id='newPromptId']
    Input Text  //input[@id='newPromptId']  ${related_value}
    Wait Until Element Is Enabled  //button[@id='btnSubmit']
    Click Element  //button[@id='btnSubmit']

Change Info Pool Related Value To "${related_value}"
    Wait Until Element Is Enabled  //input[@id='relatedVal_0']
    Input Text  //input[@id='relatedVal_0']  ${related_value}
    Click Element  //button[@id='updateRelVal_0']

Ensure "${prompt}" Info Pool With Related Id "${related_id}" and Value "${value}" Was Updated In DB
    Get Into DB  ${DB}
    Row Count Is Greater Than X  SELECT 1 FROM info_pool WHERE carrier_id = ${user} and info_id = '${prompt}' AND related_id = '${related_id}' AND value = '${value}'  0

Ensure "${prompt}" Info Pool With Related Id "${related_id}", Value "${value}" And Related Value "${related_value}" Was Updated In DB
    Get Into DB  ${DB}
    Row Count Is Greater Than X  SELECT 1 FROM info_pool WHERE carrier_id = ${user} and info_id = '${prompt}' AND related_id = '${related_id}' AND value = '${value}' AND related_value = '${related_value}'  0

Ensure User Has Info Pool Management Role
    [Arguments]  ${user}=${user}
    Get Into DB  MySQL
    ${role_inserted}  Run Keyword And Return Status  execute sql string  dml=insert INTO sec_user_role_xref(user_id, role_id, menu_visible) VALUES (${user},'${MANAGE_INFOPOOL_ROLE}',1)
    Set Test Variable  ${role_inserted}

Restore User Role
    Get Into DB  MySQL
    Run Keyword if  '${role_inserted}'=='PASS'
    ...  execute sql string  dml=delete FROM sec_user_role_xref WHERE user_id = '${user}' AND role_id = '${MANAGE_INFOPOOL_ROLE}'

Ensure Policy's Card Is Seted To Make The Card Universal
    Start Setup Policy  ${user}  ${policy}
    Setup Policy Header  payrollContractId=${contract}

Create Custom AC String
    [Arguments]  ${card}  ${location}  ${info_pool_value}  ${prod}  ${value}
    start ac string
    set string location  ${location}
    use dynamic invoice
    set string card  ${card}
    add info prompt value to string  DRID  ${info_pool_value}
    add info prompt value to string  UNIT  1234
    add fuel by abbreviation to string  ${prod}  1.00  ${value}
    calculate string total
    ${string}  finalize string
    [Return]  ${string}

Find Ryder Carrier
    [Tags]  qtest
    [Documentation]  Find a Ryder child carrier:
                    ...  select x.carrier_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A';
    ${sql}  catenate   select x.carrier_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...  order by x.effective_date DESC
                    ...  Limit 1;
    ${ryder_carrier}  query and strip  ${sql}  db_instance=tch
    set test variable  ${ryder_carrier}
    Open eManager  ${intern}  ${internPassword}
    set test variable  ${db}  tch
    Add User Role If Not Exists  ${ryder_carrier}  MANAGE_INFOPOOL  1

Verify New Prompts - Info Pool
    [Tags]  qtest
    [Documentation]  Verify the New Prompts are available:
                ...  LCCD – LOCATION CODE
                ...  PLDS – PRODUCT LINE DESC
                ...  SPLN – SUBPRODUCT LINE CODE
                ...  SLDS – SUBPRODUCT LINE DESC
    ${sql}  catenate  delete from info_pool where info_id in ('LCCD','PLDS','SPLN','SLDS') and carrier_id = ${ryder_carrier};
    execute sql string  ${sql}  db_instance=tch
    go to  ${emanager}/cards/InfoPoolManagement.action
    ${myPrompts}  get list items  prompt
    ${new_prompts}  create list  LOCATION CODE  PRODUCT LINE DESC  SUBPRODUCT LINE CODE  SUBPRODUCT LINE DESC
    list should contain sub list  ${myPrompts}  ${new_prompts}

    click element  xpath=//*[@value="LCCD"]
    wait until element is not visible  status-dialog
    click element  redirectToAddInfoPool
    input text  value  LOCATION CODE
    click element  addInfoPool
    Verify Prompt in DB  ${ryder_carrier}  LCCD  LOCATION C
    wait until element is not visible  status-dialog

    click element  xpath=//*[@value="PLDS"]
    wait until element is not visible  status-dialog
    click element  redirectToAddInfoPool
    input text  value  PRODUCT LINE DESC
    click element  addInfoPool
    Verify Prompt in DB  ${ryder_carrier}  PLDS  PRODUCT LI
    wait until element is not visible  status-dialog


    click element  xpath=//*[@value="SPLN"]
    wait until element is not visible  status-dialog
    click element  redirectToAddInfoPool
    input text  value  SUBPRODUCT
    click element  addInfoPool
    Verify Prompt in DB  ${ryder_carrier}  SPLN  SUBPRODUCT
    wait until element is not visible  status-dialog

    click element  xpath=//*[@value="SLDS"]
    wait until element is not visible  status-dialog
    click element  redirectToAddInfoPool
    input text  value  SUBPRDISCR
    click element  addInfoPool
    Verify Prompt in DB  ${ryder_carrier}  SLDS  SUBPRDISCR

Verify Prompt in DB
    [Tags]  qtest
    [Arguments]  ${carrier_id}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select value from info_pool where carrier_id = {carrier_id} and info_id = '{INFO}';
    ${sql}  catenate  select value from info_pool where carrier_id = ${carrier_id} and info_id = '${info_id}';
    ${db_value}  query and strip  ${sql}  db_instance=${db}
    should be equal as strings  ${db_value}  ${info_validation}