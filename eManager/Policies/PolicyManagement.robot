*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags      eManager  Tier:0
Suite Setup  Start Suite
Suite Teardown  End Suite

*** Variables ***
${modelEFScard}
${imperialCarrier}
${shellCarrier}

*** Test Cases ***

Verify updating limits, prompts and time restrictions no longer removes unauthorized chains on Policy
    [Tags]  JIRA:ROCKET-463  qTest:120562275  API:Y  Q1:2023
    [Documentation]  For policies, verify that after adding and deleting limits, prompts and time restrictions, unauthorized chains are not removed.
    [Setup]  Log into eManager  ${modelEFScard.carrier.id}  ${modelEFScard.carrier.password}

    Get Into DB  TCH
    Navigate to policy screen
    Select policy number  ${modelEFScard.policy.num}
    Sleep  1

    Navigate to Locations screen  policy
    Create Unauthorized Chain in eManager  policy
    Validate unauthorized Chain Was Created

    Navigate to time restriction screen  policy
    Create time restriction on policy  Sunday  12  13  14  15  policy
    Validate time restriction was created  ${modelEFScard.carrier.id}  ${modelEFScard.policy.num}  Sunday  12  13  14  15
    Delete time restriction in eManager  policy
    Validate time restriction was deleted  ${modelEFScard.carrier.id}  ${modelEFScard.policy.num}  policy

    Navigate to prompt screen  policy
    Create Prompt in eManager  policy
    Validate Prompt Was Created
    Delete Prompt In EManager  policy
    Validate prompt was deleted

    Navigate to limits screen  policy
    Create limit in eManager  policy
    Validate Limit Was Created
    Delete Limit In EManager  policy
    Validate limit was deleted

    Validate unauthorized policy chains still exist  ${modelEFScard.carrier.id}

    Navigate to Locations screen  policy
    Delete unauthorized Chain In eManager  policy
    Validate unauthorized Chain Was Deleted
    Validate unathorzed policy chain has been removed  ${modelEFScard.carrier.id}

    [Teardown]  Delete unauthorized Chains from DB  ${modelEFScard.carrier.id}  ${modelEFScard.num}

Verify updating limits, prompts and time restrictions no longer removes unauthorized chains on Card
    [Tags]  JIRA:ROCKET-463  qTest:120562278  API:Y  Q1:2023
    [Documentation]  For cards, verify that after adding and deleting limits, prompts and time restrictions, unauthorized chains are not removed.
    [Setup]  Log into eManager  ${modelEFScard.carrier.id}  ${modelEFScard.carrier.password}
    Set test variable  ${cardnum}  ${modelEFScard.num}
    Set test variable  ${carrier}  ${modelEFScard.carrier.id}

    Get Into DB  TCH
    Go To Card in Emanager
    Sleep  1

    Navigate to Locations screen  card
    Create Unauthorized Chain in eManager  card
    Validate unauthorized Chain Was Created

    Navigate to time restriction screen  card
    Create time restriction on policy  Sunday  12  13  14  15  card
    Delete time restriction in eManager  card
    Validate time restriction was deleted  ${modelEFScard.carrier.id}  ${modelEFScard.policy.num}  card

    Navigate to prompt screen  card
    Create Prompt in eManager  card
    Validate Prompt Was Created
    Delete Prompt In EManager  card
    Validate prompt was deleted

    Navigate to limits screen  card
    Create limit in eManager  card
    Validate Limit Was Created
    Delete Limit In EManager    card
    Validate Limit Was Deleted

    Validate unauthorized card chains still exist  ${modelEFScard.num}

    Navigate to Locations screen  card
    Delete unauthorized Chain In eManager  card
    Validate unauthorized Chain Was Deleted
    Validate unauthorized card chain has been removed  ${modelEFScard.num}

    [Teardown]    Delete unauthorized Chains from DB  ${modelEFScard.carrier.id}  ${modelEFScard.num}

Create New Policy EFS
    [Tags]  JIRA:BOT-543  JIRA:BOT-437  JIRA:ROCKET-445  JIRA:ROCKET-462  qTest:33193912  API:Y  tier:0  Q1:2023
    [Documentation]  Create New Policy for EFS.
    [Setup]  Log into eManager  ${modelEFScard.carrier.id}  ${modelEFScard.carrier.password}

    Get Into DB  TCH
    navigate to policy screen
    Insert iPolicy1 velocity limits and MCC
    Insert iPolicy1 Time Restrictions and Chains
    Get velocity and MCC values from iPolicy 1
    Get Time Restrictions and Unauthorized Chains values from iPolicy 1
    ${ipolicy}  ${policyName}  create new policy in eManager  EFS Test Policy
    validate creation of policy  ${ipolicy}  ${policyName}
    Get velocity and MCC values from new iPolicy  ${iPolicy}
    Get Time Restrictions and Unauthorized Chains values from New iPolicy  ${iPolicy}
    Compare velocity limits. show fuel price, and MCC values  ${iPolicy}
    Compare Time Restrictions and Unauthorized Chains values  ${iPolicy}

    [Teardown]  run keywords  Delete Policy  ${modelEFScard.carrier.id}  ${iPolicy}
    ...  AND  Delete iPolicy MCC
    ...  AND  Delete iPolicy Time Restrictions And Chains
    ...  AND  Log out of eManager

Create New Policy SHELL
    [Tags]  JIRA:BOT-543  JIRA:BOT-437  JIRA:ROCKET-445  JIRA:ROCKET-462  qTest:33194100  API:Y   tier:0  Q1:2023
    [Documentation]  Create New Policy for SHELL.
    [Setup]  Log into eManager  ${intern}  ${internPassword}
    ensure carrier has user permission  ${shellCarrier.id}  MANAGE_POLICIES
    Switch to "${shellCarrier.id}" Carrier

    Get Into DB  SHELL
    navigate to policy screen
    Insert iPolicy1 velocity limits and MCC  ${shellCarrier.id}  SHELL
    Insert iPolicy1 Time Restrictions and Chains  ${shellCarrier.id}  SHELL
    Get velocity and MCC values from iPolicy 1  ${shellCarrier.id}  SHELL
    Get Time Restrictions and Unauthorized Chains values from iPolicy 1   ${shellCarrier.id}  SHELL
    ${ipolicy}  ${policyName}  create new policy in eManager  SHELL Test Policy  SHELL
    validate creation of policy  ${ipolicy}  ${policyName}
    Get velocity and MCC values from new iPolicy  ${iPolicy}  ${shellCarrier.id}  SHELL
    Get Time Restrictions and Unauthorized Chains values from New iPolicy  ${iPolicy}  ${shellCarrier.id}  SHELL
    Compare velocity limits. show fuel price, and MCC values  ${iPolicy}
    Compare Time Restrictions and Unauthorized Chains values  ${iPolicy}

    [Teardown]  run keywords  Delete Policy  ${shellCarrier.id}  ${iPolicy}  SHELL
    ...  AND  Delete iPolicy MCC  ${shellCarrier.id}  SHELL
    ...  AND  Delete iPolicy Time Restrictions And Chains  ${shellCarrier.id}  SHELL
    ...  AND  Log out of eManager  AND  go to  ${emanager}/security/logon.jsp

Create New Policy IRVING
    [Tags]  JIRA:BOT-543  JIRA:BOT-437  JIRA:ROCKET-445  JIRA:ROCKET-462  qTest:33194164  API:Y  tier:0  Q1:2023
    [Documentation]  Create New Policy for IRVING.
    [Setup]  Log into eManager  894727  NDAAN8

    Get Into DB  IRVING
    navigate to policy screen
    Insert iPolicy1 Time Restrictions and Chains  894727  IRVING
    Insert IPolicy1 Velocity Limits And MCC    894727  IRVING
    Get velocity and MCC values from iPolicy 1  894727  IRVING
    Get Time Restrictions and Unauthorized Chains values from iPolicy 1  894727  IRVING
    ${ipolicy}  ${policyName}  create new policy in eManager  IRVING Test Policy  IRVING
    validate creation of policy  ${ipolicy}  ${policyName}
    Get velocity and MCC values from new iPolicy  ${iPolicy}  894727  IRVING
    Get Time Restrictions and Unauthorized Chains values from New iPolicy  ${iPolicy}  894727  IRVING
    Compare velocity limits. show fuel price, and MCC values  ${iPolicy}
    Compare Time Restrictions and Unauthorized Chains values  ${iPolicy}
    Delete iPolicy Time Restrictions And Chains  894727  IRVING

    [Teardown]  run keywords  Delete Policy  894727  ${iPolicy}  IRVING
    ...  AND  Delete iPolicy MCC  894727  IRVING
    ...  AND  Delete iPolicy Time Restrictions And Chains  894727  IRVING
    ...  AND  Log out of eManager

Create New Policy IMPERIAL
    [Tags]  JIRA:BOT-543  JIRA:BOT-437  JIRA:ROCKET-445  JIRA:ROCKET-462  qTest:33194308  API:Y  tier:0  Q1:2023
    [Documentation]  Create New Policy for IMPERIAL.
    [Setup]  Log into eManager  ${intern}  ${internPassword}
    ensure carrier has user permission  ${imperialCarrier.id}  MANAGE_POLICIES
    Switch to "${imperialCarrier.id}" Carrier

    Get Into DB  IMPERIAL
    navigate to policy screen
    Insert iPolicy1 Time Restrictions and Chains  ${imperialCarrier.id}  IMPERIAL
    Insert IPolicy1 Velocity Limits And MCC  ${imperialCarrier.id}  IMPERIAL
    Get velocity and MCC values from iPolicy 1  ${imperialCarrier.id}  IMPERIAL
    Get Time Restrictions and Unauthorized Chains values from iPolicy 1  ${imperialCarrier.id}  IMPERIAL
    ${ipolicy}  ${policyName}  create new policy in eManager  IMPERIAL Test Policy  IMPERIAL
    validate creation of policy  ${ipolicy}  ${policyName}
    Get velocity and MCC values from new iPolicy  ${iPolicy}  ${imperialCarrier.id}  IMPERIAL
    Get Time Restrictions and Unauthorized Chains values from New iPolicy  ${iPolicy}  ${imperialCarrier.id}  IMPERIAL
    Compare velocity limits. show fuel price, and MCC values  ${iPolicy}
    Compare Time Restrictions and Unauthorized Chains values  ${iPolicy}
    Delete iPolicy Time Restrictions And Chains  ${imperialCarrier.id}  IMPERIAL

    [Teardown]  run keywords  Delete Policy  ${imperialCarrier.id}  ${iPolicy}  IMPERIAL
    ...  AND  Delete iPolicy MCC  ${imperialCarrier.id}  IMPERIAL
    ...  AND  Delete iPolicy Time Restrictions And Chains  ${imperialCarrier.id}  IMPERIAL
    ...  AND  go to  ${emanager}/security/logon.jsp

Manage Policies - Add Time Restriction Policy
    [Tags]  JIRA:BOT-537  qTest:31355247  tier:0  refactor
    [Documentation]  Adding a Time Restriction.
    [Setup]  run keywords  delete policy time  ${modelEFScard.policy.num}  ${modelEFScard.carrier.id}
    ...  AND  log into emanager  ${modelEFScard.carrier.id}  ${modelEFScard.carrier.password}

    #Generate Variables For Test Execution
    ${weekDay}  Set Variable  Sunday
    ${beginHour}  Set Variable  00
    ${beginMinute}  Set Variable  01
    ${endHour}  Set Variable  23
    ${endMinute}  Set Variable  59

    #Open eManager, navigate to Manage Policies and Create a Time Restriction Policy
    get into db  TCH
    navigate to policy screen
    select policy number  ${modelEFScard.policy.num}
    navigate to time restriction screen  policy
    create time restriction on policy  ${weekDay}  ${beginHour}  ${beginMinute}  ${endHour}  ${endMinute}
    validate time restriction was created  ${modelEFScard.carrier.id}  ${modelEFScard.policy.num}  ${weekDay}  ${beginHour}  ${beginMinute}  ${endHour}  ${endMinute}

    [Teardown]  Run keywords  log out of emanager  AND  delete policy time  ${modelEFScard.policy.num}  ${modelEFScard.carrier.id}

#TODO:  Create test cases to edit, add and delete policy prompt information. Keywords already exist for this.
#Edit policy  ${iPolicy}
#Add a prompt on a policy
#Add a limit on a policy  ${iPolicy}
Manage Policies - Delete Time Restriction Policy
    [Tags]  tier:0  refactor
    [Setup]  run keywords  log into emanager  ${modelEFScard.carrier.id}  ${modelEFScard.carrier.password}
    ...  AND  delete policy time  ${modelEFScard.policy.num}  ${modelEFScard.carrier.id}  AND  insert policy time  ${modelEFScard.carrier.id}  ${modelEFScard.policy.num}  1  00  15  03  15
    navigate to policy screen
    select policy number  ${modelEFScard.policy.num}
    navigate to time restriction screen
    delete time restriction in eManager  policy
    validate time restriction was deleted  ${modelEFScard.carrier.id}  ${modelEFScard.policy.num}  policy

    [Teardown]  log out of emanager

Ability to change SmartFund cards from one policy to another policy via eManager
    [Tags]  JIRA:BOT-1132  qtest:28957241  Regression  refactor
    [Documentation]  Ability to change SmartFund Only cards from one policy to another policy via eManager
    [Setup]  Time to Setup  ${modelEFScard.carrier.id}  ${modelEFScard.carrier.password}  ${modelEFScard.policy.num}

    set test variable  ${cardnum}  ${modelEFScard.num}
    set test variable  ${carrier}  ${modelEFScard.carrier.id}

    Go To Card in Emanager
    Find policy info via SQL query to the card  ${cardnum}  ${carrier}
    Policies on db should match to the dropdown on the Manage Card Screen
    Inject a new element for the policy dropdown using javascript and save
    Assert message  You do not have access to the cards policy or subfleet

    [Teardown]  Log out of eManager

Search Icon in Policy Management screen
    [Tags]  JIRA:FRNT-47  JIRA:BOT-2398  JIRA:OTREPIC-989  qTest:33665313
    [Documentation]  To test if the search icon is showing correct policies in Manage policies screen
    get into db  TCH
    ${testcarrier}  query and strip  select id from def_card where ipolicy < 500 group by id having count(ipolicy) > 19 limit 1;
    ${pwd}  query and strip  select trim(passwd) from member where member_id = '${testcarrier}'
    set global variable  ${testcarrier}
    set global variable  ${pwd}
    Log into eManager  ${testcarrier}  ${pwd}
    Go To  ${emanager}/cards/PolicyPromptManagement.action
    page should contain element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    Go To  ${emanager}/cards/PolicyLimitManagement.action
    page should contain element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    Go To  ${emanager}/cards/PolicyLocationManagement.action
    page should contain element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    Go To  ${emanager}/cards/PolicyTimeRestrictionManagement.action
    page should contain element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    Go To  ${emanager}/cards/MobilDriverAppSettings.action
    page should contain element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    [Teardown]  Log out of eManager

Search Icon in Card Management screen
    [Tags]  JIRA:FRNT-47  JIRA:BOT-2398  qTest:36807900  refactor
    [Documentation]  To test if the search icon is showing correct policies on Manage cards screen
    Log into eManager  ${testcarrier}  ${pwd}
    Go To  ${emanager}/cards/CardLookup.action
    page should contain element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    click on  //*[@title='close']
    click on  //*[@id="cardSummary"]/tbody/tr[1]/td[1]/a
    wait until page contains element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    click on  //*[@title='close']
    Go to limits tab
    wait until page contains element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    click on  //*[@title='close']
    Go to locations tab
    wait until page contains element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    click on  //*[@title='close']
    go to time restriction screen
    wait until page contains element  search
    Match policies from DB to Search dropdown  ${testcarrier}
    click on  //*[@title='close']
    [Teardown]  Log out of eManager

Search Icon in Policy Management screen2
    [Tags]  JIRA:FRNT-427  JIRA:BOT-2398  qTest:39726956  refactor
    [Documentation]  To test that the search icon is not showing on site policies screen
    Log into eManager  ${testcarrier}  ${pwd}
    go to  ${emanager}/cards/PolicyPromptManagement.action?sitePolicy=true
    page should not contain element  search
    [Teardown]  Log out of eManager

Create Child Default Policy - Ryder
    [Tags]  JIRA:ROCKET-225  qTest:55375382  PI:13  Tier:1
    [Setup]  Find Ryder Carrier
    Create Child Default Policy
    [Teardown]  Ryder Teardown

Ryder Child can create Policy
    [Tags]  JIRA:ROCKET-335  PI:15  qtest:118096632
    [Setup]  Find Ryder Child
    navigate to policy screen
    ${ipolicy}  ${policyName}  create new policy in eManager  create policy test
    validate creation of policy  ${ipolicy}  ${policyName}

    [Teardown]  run keywords  Delete Policy  ${ryder_child}  ${iPolicy}
    ...  AND  Log out of eManager

*** Keywords ***
Start Suite
    get into db  TCH
    open browser to emanager
    #create model card
    ${sql}=  catenate
     ...  SELECT card_num, c.carrier_id
     ...  FROM cards c
     ...    RIGHT JOIN def_card dc ON dc.ipolicy = c.icardpolicy AND dc.id = c.carrier_id
     ...    left outer join member as m on m.member_id = dc.id
     ...    left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
     ...    left outer join mcfleet_def_mcc as mdm on mdm.carrier_id = dc.id and mdm.ipolicy = dc.ipolicy
     ...    left outer join mcfleet_mcc as mcc on mcc.merchant_code = mdm.mcc
     ...  WHERE mrcsrc = 'Y'
     ...    AND payr_use = 'B'
     ...    AND dc.ipolicy = 1
     #...    AND mdm.ipolicy is not null
     ...    AND card_num NOT LIKE '%OVER%'
     ...    AND c.status = 'A'
     ...    AND dc.payr_contract_id IS NOT NULL
     ...    AND dc.contract_id IS NOT NULL
     ...    AND c.carrier_id != 126965
     ...    AND m.tran_update = 'N'
     ...    AND c.carrier_id NOT IN (select id from def_card where ipolicy < 1);
    ${modelEFScard}  find card variable  ${sql}
    set suite variable  ${modelEFScard}

    ${imperialCarrier}  find carrier variable  select unique(id) from def_card where created > '2017-01-01' and id > 800000  id  imperial
    set suite variable  ${imperialCarrier}
    ${shellCarrier}  find carrier variable  select unique(id) from def_card JOIN contract ON def_card.id=contract.carrier_id JOIN transaction ON contract.carrier_id=transaction.carrier_id where contract.status='A' AND transaction.trans_date > CURRENT - 30 units DAY  id  shell
    set suite variable  ${shellCarrier}

End Suite
    Close Browser

Delete Policy
    [Documentation]
    ...  Delete Policy Through DB
    ...
    ...  ARGS:
    ...  - Carrier: Carrier Id.
    ...  - PolicyNumber. iPolicy Number to Delete.
    ...  - DB: Database instance. TCH, SHELL, IRVING, IMPERIAL.
    ...
    ...  EXAMPLE:
    ...  - Delete Policy  103866  31  TCH

    [Arguments]  ${carrier}  ${policyNumber}  ${db_instance}=TCH

    #Tch Logging  \nDeleting Policy

    #REMOVE POLICY LIMITS
    ${sql}  catenate  DELETE FROM def_lmts WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}
    #Tch Logging  \n${sql}

    #REMOVE POLICY PROMPTS
    ${sql}  catenate  DELETE FROM def_info WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}  db_instance=${db_instance}
    #Tch Logging  \n${sql}

    #REMOVE POLICY LOCATIONS
    ${sql}  catenate  DELETE FROM def_locs WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}  db_instance=${db_instance}
    #Tch Logging  \n${sql}

    #REMOVE POLICY LOCATION GROUPS
    ${sql}  catenate  DELETE FROM def_loc_grp WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}  db_instance=${db_instance}
    #Tch Logging  \n${sql}

    #REMOVE POLICY MCCs
    ${sql}  catenate  DELETE FROM mcfleet_def_mcc WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}  db_instance=${db_instance}
    #Tch Logging  \n${sql}

    #REMOVE POLICY
    ${sql}  catenate  DELETE FROM def_card WHERE id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}  db_instance=${db_instance}
    #Tch Logging  \n${sql}

    #UPDATE CARDS
    ${sql}  catenate  UPDATE cards SET icardpolicy = 1 WHERE icardpolicy = '${policyNumber}' AND carrier_id = '${carrier}'
    Execute SQL String  ${sql}  db_instance=${db_instance}
    #Tch Logging  \n${sql}

    Disconnect From Database

Policies on db should match to the dropdown on the Manage Card Screen
    capture page screenshot
    ${policies}  Get Element Count  //select[@name='card.header.policyNumber']/option
    FOR  ${i}  IN RANGE  1  ${policies}+1
       ${policy_num}  Get Element Attribute  //select[@name='card.header.policyNumber']/option[${i}]  value
       ${policy_num}  Convert To Number  ${policy_num}
       should be equal as numbers  ${policy_num}  ${card_policies[${i}-1]['ipolicy']}  msg=policy list should have matched but did not
    END

Assert message
    [Arguments]  ${message}=None  ${shoud_not_contain}=None

    run keyword if  '${shoud_not_contain}'=='None'
    ...  Page Should Contain  ${message}
    ...  ELSE
    ...  Page Should Not Contain  ${shoud_not_contain}

Inject a new element for the policy dropdown using javascript and save

    ${element}=	Execute Javascript	 document.getElementsByName("card.header.policyNumber")[0].innerHTML=document.getElementsByName("card.header.policyNumber")[0].innerHTML+"<option value='10101010'>10101010 - testing</option>";
    Select From List By Value  name=card.header.policyNumber  10101010
    Click Element  saveCardInformation

Find policy info via SQL query to the card
    [Arguments]  ${cardnum}  ${carrier}

    ${query}  catenate
    ...  SELECT c.card_num, c.status, ct.contract_id, pt.contract_id, cm.member_id, pm.member_id, cm.payr_type, pm.payr_type AS pm_payr_type
    ...  FROM cards c
    ...  LEFT JOIN def_card d ON c.carrier_id = d.id AND c.icardpolicy = d.ipolicy
    ...  LEFT JOIN contract ct ON ct.contract_id = d.contract_id
    ...  LEFT JOIN contract pt ON pt.contract_id = d.payr_contract_id
    ...  LEFT JOIN member cm ON cm.member_id = ct.issuer_id
    ...  LEFT JOIN member pm ON pm.member_id = pt.issuer_id
    ...  WHERE c.card_num = '${cardnum}';
    ${result}  query and strip to dictionary  ${query}


# Take the cm.payr_type, pm.payr_type values from the card and use them in this query:
    ${query}  catenate
    ...  SELECT d.id, d.ipolicy, ct.contract_id, pt.contract_id, cm.member_id, pm.member_id, cm.payr_type, pm.payr_type
    ...  FROM def_card d
    ...  LEFT JOIN contract ct ON ct.contract_id = d.contract_id
    ...  LEFT JOIN contract pt ON pt.contract_id = d.payr_contract_id
    ...  LEFT JOIN member cm ON cm.member_id = ct.issuer_id
    ...  LEFT JOIN member pm ON pm.member_id = pt.issuer_id
    ...  WHERE d.id = ${carrier}
    ...  AND cm.payr_type = '${result['payr_type']}'
    ...  AND pm.payr_type = '${result['pm_payr_type']}'
    ...  ORDER BY d.ipolicy;

    ${result2}  query and return dictionary rows  ${query}

    Set Test Variable  ${card_policies}  ${result2}

Time to Setup
    [Arguments]  ${carrier}  ${validCard.carrier.password}    ${policy}
    Get Into DB  TCH
    start setup policy  ${carrier}  ${policy}  #takes screenshot of policy
    Log into eManager  ${carrier}  ${validCard.carrier.password}


Go To Card in Emanager
   go to   ${emanager}/cards/CardLookup.action
   #wait until element is visible  lookupInfoRadio  error=radio buttons for card look up in eManager did not load
   select radio button  lookupInfoRadio  NUMBER
   #wait until element is visible  input text  xpath=//*[@name='cardSearchTxt']  error=card search text on page did not load
   input text  xpath=//*[@name='cardSearchTxt']  ${cardnum}
   #wait until element is visible  xpath=//*[@name='searchCard']  error=search card element did not load
   click element  xpath=//*[@name='searchCard']
   wait until element is visible  xpath=//a[contains(text(), "${cardnum[:6]}") and contains(text(), "${cardnum[-4:]}")]  error=card link on card search did not load
   click link  xpath=//a[contains(text(), "${cardnum[:6]}") and contains(text(), "${cardnum[-4:]}")]
   sleep  2


Edit Policy
    [Arguments]  ${policy}
    input text  changeDescription  Changed description
    click button  Save
    reload page
    wait until element is visible  policy.policyNumber  timeout=20  error=policy did not pull up in time
    select from list by value  policy.policyNumber  ${policy}
    wait until element is visible  //*[@name="changeDescription"]  timeout=20  error=could not find description on policy
    ${description}  Get Value  //*[@name="changeDescription"]
    Should be Equal  ${description}  Changed description
    #Tch Logging  Description successfully edited

Add a prompt on a policy
    click button  createPromptPolicy
    select from list by value  cardInfo.infoId  UNIT
    click button  validationInformation
    ${DB}  get current db instance
    run keyword unless  '${DB}'=='SHELL'  run keywords  select from list by value  cardInfo.validationType  REPORT_ONLY
    ...  AND  click button  Next
    input text  xpath=//*[@name="cardInfo.reportValue"]  1234
    click button  Finish
    Element Should Contain  //*[@class="messages"]  You have successfully created the prompt of (UNIT).
    page should contain element  //*[@id='policy']//descendant::*[contains(text(),'Unit Number')]
    page should contain element  //*[@id='policy']//descendant::*[contains(text(),'Report Only')]
    #Tch Logging  Prompt successfully added

Add a limit on a policy
    [Arguments]  ${policy}
    go to  ${emanager}/cards/PolicyLimitManagement.action
    Select From List By Value  policy.policyNumber  ${policy}
    wait until page contains element  createPolicyLimit
    click button  Add New Limit
    select from list by value  limitIdChoice  BDSL
    click button  Next
    input text  policyLimit.limit  100
    click button  Finish
    Element Should Contain  //*[@class="messages"]  You have successfully Added the Description (BIO DIESEL
    page should contain element  //*[@id='policy']//descendant::*[contains(text(),'BIO DIESEL')]
    page should contain element  //*[@id='policy']//descendant::*[contains(text(),'100')]
    #Tch Logging  Limit successfully added

delete policy time
    [Arguments]  ${policy}  ${carrier}

    get into db  TCH

    ${sql}=  catenate  DELETE FROM def_time WHERE carrier_id = ${carrier} and ipolicy = ${policy}
    execute sql string  ${sql}

insert policy time
    [Arguments]  ${carrier}  ${policy}  ${weekDay}  ${beginHour}  ${beginMinute}  ${endHour}  ${endMinute}

    get into db  TCH
    ${sql}=  catenate   INSERT INTO def_time (carrier_id, policy, day_of_week, beg_time, end_time, ipolicy) VALUES (${carrier}, ${policy}, ${weekDay}, '${beginHour}:${beginMinute}', '${endHour}:${endMinute}', ${policy})
    execute sql string  ${sql}

navigate to policy screen
    [Tags]  qTest
    [Documentation]  Select Program > Manage Policies > Manage Policies
    Go To  ${emanager}/cards/PolicyPromptManagement.action
    wait until element is visible  changeDescription  error=Policy page did not load in time

create new policy in eManager
    [Tags]  qTest
    [Arguments]  ${policyName}  ${dbinstance}=tch
    [Documentation]  Hovor over Policy Management and click Create New Policy. Enter description for policy and click Create
    #Generate Variables For Test Execution
    ${randomValue}  Generate Random String  4
    ${policyName}  Set Variable  ${policyName} ${randomValue}

    #Open eManager, navigate to Manage Policies and Create a Policy
    Mouse Over  cardMenubar_1x2
    Click on  policyManagement_1x2
    wait until element is visible  description  timeout=20  error=Policy create screeen did not load in time
    Input Text  description  ${policyName}
    sleep  1
    Click on  createNewPolicy

    #Get iPolicy Number Through DB
    Sleep  1
    ${iPolicy}  Query And Strip  SELECT ipolicy FROM def_card WHERE description = '${policyName}'  db_instance=${dbinstance}
    ${iPolicy}  Convert to String  ${iPolicy}

    #Validate Success Message
    Element Should Contain  //*[@class="messages"]  Successfully created new policy number (${iPolicy}), and description (${policyName}).

    [Return]  ${iPolicy}  ${policyName}

validate creation of policy
    [Tags]  qtest
    [Documentation]  validate new policy was created in def_card table:
                ...  select * from def_card where id = {carrier_id};
    [Arguments]  ${iPolicy}  ${policyName}

    #Confirm if Policy is an Option Under Policy Number Dropdown
    Go To  ${emanager}/cards/PolicyPromptManagement.action
    wait until element is visible  policy.policyNumber
    sleep  1
    Select From List By Value  policy.policyNumber  ${iPolicy}
    wait until element is visible  //*[@name="changeDescription"]  timeout=20  error=Policy did not load in time
    sleep  1
    ${description}  Get Value  //*[@name="changeDescription"]
    Should be Equal  ${description}  ${policyName}


navigate to time restriction screen
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Mouse Over  cardMenubar_5x2
        Click Element  cardTimeRestriction_1x2
    ELSE IF  '${type}'=='card'
        Mouse Over  cardMenubar_6x2
        Click Element  cardTimeRestriction_1x2
    END


create time restriction on policy
    [Arguments]  ${weekDay}  ${beginHour}  ${beginMinute}  ${endHour}  ${endMinute}  ${type}
    IF  '${type}'=='policy'
        Click Element  createPolicyTimeRestriction
        Select From List by Label  day  ${weekDay}
        Click Element  next
        Select From List by Label  beginHour  ${beginHour}
        Select From List by Label  beginMinute  ${beginMinute}
        Select From List by Label  endHour  ${endHour}
        Select From List by Label  endMinute  ${endMinute}
        Click Element  savePolicyCreateTime
    ELSE IF  '${type}'=='card'
        Click Element  createTimeRestriction
        Select From List by Label  day  ${weekDay}
        Click Element  next
        Select From List by Label  beginHour  ${beginHour}
        Select From List by Label  beginMinute  ${beginMinute}
        Select From List by Label  endHour  ${endHour}
        Select From List by Label  endMinute  ${endMinute}
        Click Element  saveCreateTime
    END

validate time restriction was created
    [Arguments]  ${carrier}  ${policy}  ${weekDay}  ${beginHour}  ${beginMinute}  ${endHour}  ${endMinute}
    capture page screenshot
    ${message}  Catenate  You have successfully Added the Time Restriction of Day of Week (${weekDay}),
    ...  Begin Time (${beginHour}:${beginMinute}), End Time (${endHour}:${endMinute}).
    sleep  2
    Element Should Contain  //*[@class="messages"]  ${message}

    #validate db insert
    ${sql}=  catenate  SELECT * FROM def_time WHERE carrier_id = ${carrier} AND ipolicy = ${policy}
    ${results}  query and strip to dictionary  ${sql}
    ${weekdays}  create dictionary  Sunday=0  Monday=1  Tuesday=2  Wednesday=3  Thursday=4  Friday=5  Saturday=6
    should be equal as strings  ${results['day_of_week']}  ${weekdays['${weekDay}']}
    should be equal as strings  ${results['beg_time']}  ${beginHour}:${beginMinute}:00
    should be equal as strings  ${results['end_time']}  ${endHour}:${endMinute}:00

delete time restriction in eManager
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Click Element  deletePolicyTimeRestriction
        Handle Alert  ACCEPT
    Sleep  1
    ELSE IF  '${type}'=='card'
        Click Element  deleteTimeRestriction
        Handle Alert  ACCEPT
    Sleep  1
    END

validate time restriction was deleted
    [Arguments]  ${carrier}  ${policy}  ${type}
    IF  '${type}'=='policy'
        Element Should Contain  //*[@class="messages"]  You have successfully deleted the Time Restriction
        row count is 0  SELECT * FROM def_time WHERE carrier_id = ${carrier} AND ipolicy = ${policy}
    ELSE IF  '${type}'=='card'
        Element Should Contain  //*[@class="messages"]  You have successfully deleted the Time Restriction
    END

select policy number
    [Arguments]  ${policyNumber}
    select from list by value  policy.policyNumber  ${policyNumber}
    wait until element is visible  //select[@name="policy.policyNumber"]//option[@selected and @value="${policyNumber}"]  error=policy change description did not load in time  timeout=20

Match policies from DB to Search dropdown
    [Arguments]  ${testcarrier}
    get into db  TCH
    ${policy}  query and strip to dictionary  select ipolicy from def_card where id = '${testcarrier}' and ipolicy BETWEEN 1 and 500
    ${count}  query and strip  select count(ipolicy) from def_card where id = '${testcarrier}' and ipolicy BETWEEN 1 and 500
    click on  search
    wait until page contains element  policyLookUpTable  timeout=20
    sleep  1
    FOR  ${i}  IN RANGE  ${count}
       page should contain element  //*[@policyvalue='${policy['ipolicy'][${i}]}']
    END

Go to limits tab
    hover over  //*[@id="actmn_cardMenubar"]//following-sibling::*[contains(text(),'Limits')]
    click on  //*[@id="actmn_cardLimits"]//following-sibling::*[contains(text(),'Update Limits')]

Go to locations tab
    hover over  //*[@id="actmn_cardMenubar"]//following-sibling::*[contains(text(),'Locations')]
    click on  //*[@id="actmn_cardLocation"]//following-sibling::*[contains(text(),'Update Locations')]

Go to Override tab
    hover over  //*[@id="actmn_cardMenubar"]//following-sibling::*[contains(text(),'Card Management')]
    click on  //*[@id="actmn_cardManagement"]//following-sibling::*[contains(text(),'Override Card')]

go to time restriction screen
    hover over  //*[@id="actmn_cardMenubar"]//following-sibling::*[contains(text(),'Time Restrictions')]
    click on  //*[@id="actmn_cardTimeRestriction"]//following-sibling::*[contains(text(),'Update Time Restrictions')]

Find Ryder Carrier
    [Tags]  qtest
    [Documentation]  Find a carrier with SITEPOLV2 val of Y that does not have child default policy
        ...  select distinct(m.member_id)
        ...  from member_meta m
        ...           join def_card d ON m.member_id = d.id
        ...  where m.mm_key = 'SITEPOLV2'
        ...    and m.mm_value = 'Y'
        ...    and m.member_id not in (select id from def_card where ipolicy = -1);
    ${sql}  catenate  select distinct(m.member_id)
        ...  from member_meta m
        ...           inner join def_card d ON m.member_id = d.id
        ...           inner join carrier_group_xref x ON x.parent = m.member_id
        ...  where m.mm_key = 'SITEPOLV2'
        ...    and m.mm_value = 'Y'
        ...    and m.member_id not in (345062, 344992)
        ...    and m.member_id in (select id from def_card where policy_type_id = 2)
        ...    and m.member_id not in (select id from def_card where ipolicy = -1)
        ...  ORDER BY m.member_id desc limit 1;
    set test variable  ${db}  tch
    close browser
    ${ryder_carrier}  query and strip  ${sql}  db_instance=${db}
    set test variable  ${ryder_carrier}
    Open eManager  ${intern}  ${internPassword}
    Add User Role If Not Exists  ${ryder_carrier}  CREATE_CHILD_DEFAULTS  1
    Switch to "${ryder_carrier}" User

Ryder Teardown
    [Tags]  qtest
    [Documentation]  remove test policies: DELETE from def_card where ipolicy in (-1,-501) and id = {carrier};
    close browser
    ${sql}  catenate  DELETE from def_card where ipolicy in (-1,-501) and id = ${ryder_carrier};
    execute sql string  ${sql}  db_instance=${db}

Create Child Default Policy
    [Tags]  qtest
    [Documentation]  Go to Select Program > Manage Policies
            ...  hovor over Policy Management, click Create Child Default Policy
            ...  Enter a value for the policy name, and click Create
    navigate to policy screen
    ${randomValue}  Generate Random String  4
    ${policyName}  Set Variable  ${randomValue}
    Mouse Over  cardMenubar_1x2
    click element  policyManagement_2x2
    input text  description  ${policyName}
    click button  createNewDefPolicy
    Verify Child Default Policy  ${policyName}

Verify Child Default Policy
    [Arguments]  ${policyName}
    [Tags]  qtest
    [Documentation]  Verify the child default policy is created in the DB:
            ...  select description from def_card where ipolicy = -1 and id = {carrier};
    ${sql}  catenate  select description from def_card where ipolicy = -1 and id = ${ryder_carrier};
    ${desc}  query and strip  ${sql}  db_instance=${db}
    ${sql2}  catenate  DELETE from def_card where ipolicy = -1 and id = ${ryder_carrier};
    execute sql string  ${sql2}  db_instance=${db}
    should be equal as strings  ${policyName}  ${desc}


Find Ryder Child
    [Tags]  qtest
    [Documentation]  Fins a Ryder child carrier:
                    ...  select c.carrier_id
                    ...  from contract c
                    ...  join carrier_group_xref x ON c.carrier_id = x.carrier_id
                    ...  where c.status = 'A'
                    ...  and x.parent = 197997
                    ...  order by c.lastupdated desc limit 1;
    ${sql}  catenate  select c.carrier_id
                    ...  from contract c
                    ...  join carrier_group_xref x ON c.carrier_id = x.carrier_id
                    ...  where c.status = 'A'
                    ...  and x.parent = 197997
                    ...  order by c.lastupdated desc limit 1;
    ${ryder_child}  query and strip  ${sql}  db_instance=tch
    set test variable  ${ryder_child}
    Open eManager  ${intern}  ${internPassword}
    Switch to "${ryder_child}" Carrier

Get velocity and MCC values from iPolicy 1
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    Get Into DB  TCH
    ${queryPolicy1Velocity}  catenate
        ...  SELECT show_price, day_cnt_limit, day_amt_limit, week_cnt_limit, week_amt_limit,
        ...  mon_cnt_limit, mon_amt_limit FROM def_card
        ...  WHERE ipolicy=1 AND id=${carrierId};
    ${queryPolicy1MCC}  catenate
       ...  SELECT
       ...  dc.id as carrier
       ...  ,m.name as carrier_name
       ...  ,dc.policy_type_id
       ...  ,pt.policy_type_desc
       ...  ,mdm.policy
       ...  ,mdm.mcc
       ...  ,mdm.carrier_id
       ...  ,mcc.description
       ...  ,mcc.description
       ...  ,mcc.*
       ...  from def_card as dc
       ...  left outer join member as m on m.member_id = dc.id
       ...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
       ...  left outer join mcfleet_def_mcc as mdm on mdm.carrier_id = dc.id and mdm.ipolicy = dc.ipolicy
       ...  left outer join mcfleet_mcc as mcc on mcc.merchant_code = mdm.mcc
       ...  where 1=1
       ...   and dc.id = '${carrierId}'
       ...   and mdm.ipolicy = '1'
       ...  order by dc.id, dc.ipolicy, mdm.mcc;
    ${policy1Velocity}  Query And Strip To Dictionary  ${queryPolicy1Velocity}  db_instance=${db_instance}
    ${policy1Velocity}  set test variable  ${policy1Velocity}
    ${policy1MCC}  Query And Strip To Dictionary  ${queryPolicy1MCC}  db_instance=${db_instance}
    ${policy1MCC}  set test variable  ${policy1MCC}


Get velocity and MCC values from new iPolicy
    [Tags]    qTest
    [Arguments]  ${iPolicy}  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    [Documentation]    Run this query in the database:
    ...  SELECT * FROM def_card WHERE ipolicy={iPolicy} AND id={carrierId};
    ...  SELECT
    ...  dc.id as carrier
    ...  ,m.name as carrier_name
    ...  ,dc.policy_type_id
    ...  ,pt.policy_type_desc
    ...  ,mdm.policy
    ...  ,mdm.mcc
    ...  ,mdm.carrier_id
    ...  ,mcc.description
    ...  ,mcc.*
    ...  from def_card as dc
    ...  left outer join member as m on m.member_id = dc.id
    ...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
    ...  left outer join mcfleet_def_mcc as mdm on mdm.carrier_id = dc.id and mdm.ipolicy = dc.ipolicy
    ...  left outer join mcfleet_mcc as mcc on mcc.merchant_code = mdm.mcc
    ...  where 1=1
    ...   and dc.id = '{carrierId}'
    ...   and mdm.ipolicy = '{iPolicy}'
    ...  order by dc.id, dc.ipolicy, mdm.mcc;

    ${queryNewPolicyVelocity}  catenate  SELECT show_price, day_cnt_limit, day_amt_limit, week_cnt_limit,
    ...  week_amt_limit, mon_cnt_limit, mon_amt_limit FROM def_card WHERE ipolicy=${iPolicy} AND id=${carrierId};
    ${queryNewPolicyMCC}  catenate
   ...  select
   ...  dc.id as carrier
   ...  ,m.name as carrier_name
   ...  ,dc.policy_type_id
   ...  ,pt.policy_type_desc
   ...  ,mdm.policy
   ...  ,mdm.mcc
   ...  ,mdm.carrier_id
   ...  ,mcc.description
   ...  ,mcc.*
   ...  from def_card as dc
   ...  left outer join member as m on m.member_id = dc.id
   ...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
   ...  left outer join mcfleet_def_mcc as mdm on mdm.carrier_id = dc.id and mdm.ipolicy = dc.ipolicy
   ...  left outer join mcfleet_mcc as mcc on mcc.merchant_code = mdm.mcc
   ...  where 1=1
   ...   and dc.id = '${carrierId}'
   ...   and mdm.ipolicy = '${iPolicy}'
   ...  order by dc.id, dc.ipolicy, mdm.mcc;
    ${newPolicyVelocity}  Query And Strip To Dictionary  ${queryNewPolicyVelocity}  db_instance=${db_instance}
    ${newPolicyVelocity}  set test variable  ${newPolicyVelocity}
    ${newPolicyMCC}  Query And Strip To Dictionary  ${queryNewPolicyMCC}  db_instance=${db_instance}
    ${newPolicyMCC}  set test variable  ${newPolicyMCC}

Compare velocity limits. show fuel price, and MCC values
    [Tags]  qTest
    [Documentation]  Using Account Manager, verify Policy 1 and the new policy, have the same values on the Refreshling Limits tab, and MCC tab.
    ...  Using Customer Info Test, open Policy Manager and verify Show Fuel Pricing selection is the same under Mobile Driver App Setup
    [Arguments]  ${iPolicy}
    Tch Logging  \n --------------- Compare Velocity and MCC ---------------
    Tch Logging  Policy 1 Velocity: ${policy1Velocity}
    Tch Logging  Policy ${iPolicy} Velocity: ${newPolicyVelocity} \n
    Tch Logging  Policy 1 MCC: ${policy1MCC}
    Tch Logging  Policy ${iPolicy} MCC: ${newPolicyMCC}
    Should Be Equal  ${policy1Velocity}  ${newPolicyVelocity}
    Should Be Equal  ${policy1MCC}  ${newPolicyMCC}

Get Time Restrictions and Unauthorized Chains values from iPolicy 1
    [Tags]  qTest
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    [Documentation]  Run these two queries in the database:
    ...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dt.day_of_week
	...  ,dt.carrier_id
	...  ,dt.day_of_week
	...  ,dt.beg_time
	...  ,dt.end_time
	...  ,dt.day_of_week
	...  ,dd.carrier_id
	...  ,dd.beg_date
	...  ,dd.end_date
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_time as dt on dt.carrier_id = dc.id and dt.ipolicy = dc.ipolicy
	...  left outer join def_date as dd on dd.carrier_id = dc.id and dd.ipolicy = dc.ipolicy
	...  where 1=1
	...  and dc.id = '$[carrierId]'
	...  and dc.ipolicy = 1
	...  order by dc.id, dt.day_of_week, dd.beg_date;

    ...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.ipolicy as ipolicy
	...  ,dc.description as policy_desc
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dch.chain_id
	...  ,cd.chain_desc
	...  ,dch.*
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_chains as dch on dch.carrier_id = dc.id and dch.ipolicy = dc.ipolicy
	...  left outer join chain_desc as cd on cd.chain_id = dch.chain_id
	...  where 1=1
	...  and dc.id = '$[carrierId]'
	...  and dch.ipolicy = 1
	...  order by dc.id, dc.ipolicy, dch.chain_id;

    Get Into DB  TCH
    ${queryPolicy1TimeRestrictions}  catenate
	...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dt.day_of_week
	...  ,dt.carrier_id
	...  ,dt.day_of_week
	...  ,dt.beg_time
	...  ,dt.end_time
	...  ,dt.day_of_week
	...  ,dd.carrier_id
	...  ,dd.beg_date
	...  ,dd.end_date
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_time as dt on dt.carrier_id = dc.id and dt.ipolicy = dc.ipolicy
	...  left outer join def_date as dd on dd.carrier_id = dc.id and dd.ipolicy = dc.ipolicy
	...  where 1=1
	...  and dc.id = '${carrierId}'
	...  and dc.ipolicy = 1
	...  order by dc.id, dt.day_of_week, dd.beg_date;

    ${queryPolicy1unauthorizedChains}  catenate
	...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.ipolicy as ipolicy
	...  ,dc.description as policy_desc
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dch.chain_id
	...  ,cd.chain_desc
	...  ,dch.*
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_chains as dch on dch.carrier_id = dc.id and dch.ipolicy = dc.ipolicy
	...  left outer join chain_desc as cd on cd.chain_id = dch.chain_id
	...  where 1=1
	...  and dc.id = '${carrierId}'
	...  and dch.ipolicy = 1
	...  order by dc.id, dc.ipolicy, dch.chain_id;

    ${policy1TimeRestrictions}  Query And Strip To Dictionary  ${queryPolicy1TimeRestrictions}  db_instance=${db_instance}
    ${policy1TimeRestrictions}  set test variable  ${policy1TimeRestrictions}
    ${policy1unauthorizedChains}  Query And Strip To Dictionary  ${queryPolicy1unauthorizedChains}  db_instance=${db_instance}
    ${policy1unauthorizedChains}  set test variable  ${policy1unauthorizedChains}

Get Time Restrictions and Unauthorized Chains values from New iPolicy
    [Tags]  qTest
    [Arguments]  ${iPolicy}  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    [Documentation]    Get Time Restrictions And Unauthorized Chains Values From New IPolicy
    ...     Run these two quries in the database
    ...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dt.day_of_week
	...  ,dt.carrier_id
	...  ,dt.day_of_week
	...  ,dt.beg_time
	...  ,dt.end_time
	...  ,dt.day_of_week
	...  ,dd.carrier_id
	...  ,dd.beg_date
	...  ,dd.end_date
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_time as dt on dt.carrier_id = dc.id and dt.ipolicy = dc.ipolicy
	...  left outer join def_date as dd on dd.carrier_id = dc.id and dd.ipolicy = dc.ipolicy
	...  where 1=1
	...  and dc.id = '$[carrierId]'
	...  and dc.ipolicy = $[iPolicy]
	...  order by dc.id, dt.day_of_week, dd.beg_date;

    ...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.ipolicy as ipolicy
	...  ,dc.description as policy_desc
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dch.chain_id
	...  ,cd.chain_desc
	...  ,dch.*
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_chains as dch on dch.carrier_id = dc.id and dch.ipolicy = dc.ipolicy
	...  left outer join chain_desc as cd on cd.chain_id = dch.chain_id
	...  where 1=1
	...  and dc.id = '$[carrierId]'
	...  and dch.ipolicy = $[iPolicy]
	...  order by dc.id, dc.ipolicy, dch.chain_id;

    Get Into DB  TCH
    ${queryNewPolicyTimeRestrictions}  catenate
	...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dt.day_of_week
	...  ,dt.carrier_id
	...  ,dt.day_of_week
	...  ,dt.beg_time
	...  ,dt.end_time
	...  ,dt.day_of_week
	...  ,dd.carrier_id
	...  ,dd.beg_date
	...  ,dd.end_date
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_time as dt on dt.carrier_id = dc.id and dt.ipolicy = dc.ipolicy
	...  left outer join def_date as dd on dd.carrier_id = dc.id and dd.ipolicy = dc.ipolicy
	...  where 1=1
	...  and dc.id = '${carrierId}'
	...  and dc.ipolicy = ${iPolicy}
	...  order by dc.id, dt.day_of_week, dd.beg_date;

    ${queryNewPolicyunauthorizedChains}  catenate
	...  select
	...  dc.id as carrier
	...  ,m.name as carrier_name
	...  ,dc.ipolicy as ipolicy
	...  ,dc.description as policy_desc
	...  ,dc.policy_type_id
	...  ,pt.policy_type_desc
	...  ,dch.chain_id
	...  ,cd.chain_desc
	...  ,dch.*
	...  from def_card as dc
	...  left outer join member as m on m.member_id = dc.id
	...  left outer join policy_type as pt on pt.policy_type_id = dc.policy_type_id
	...  left outer join def_chains as dch on dch.carrier_id = dc.id and dch.ipolicy = dc.ipolicy
	...  left outer join chain_desc as cd on cd.chain_id = dch.chain_id
	...  where 1=1
	...  and dc.id = '${carrierId}'
	...  and dch.ipolicy = ${iPolicy}
	...  order by dc.id, dc.ipolicy, dch.chain_id;

    ${newPolicyTimeRestrictions}  Query And Strip To Dictionary  ${queryNewPolicyTimeRestrictions}  db_instance=${db_instance}
    ${newPolicyTimeRestrictions}  set test variable  ${newPolicyTimeRestrictions}
    ${newPolicyunauthorizedChains}  Query And Strip To Dictionary  ${queryNewPolicyunauthorizedChains}  db_instance=${db_instance}
    ${newPolicyunauthorizedChains}  set test variable  ${newPolicyunauthorizedChains}

Compare Time Restrictions and Unauthorized Chains values
    [Tags]  qTest
    [Documentation]    Compare Time Restrictions and Unauthorized Chains values
    ...  iPolicy 1 and new iPolicy Time Restrictions and unauthorized Chains are equal
    [Arguments]  ${iPolicy}
    Tch Logging    \n --------------- Compare Time Restrictions and Unauthorized Chains ---------------
    Tch Logging    Policy 1 Time Restrictions: ${policy1TimeRestrictions}
    Tch Logging    Policy ${iPolicy} Time Restrictions: ${newPolicyTimeRestrictions} \n
    Tch Logging    Policy 1 Unauthorized Chains: ${policy1unauthorizedChains}
    Tch Logging    Policy ${iPolicy} Unauthorized Chains: ${newPolicyunauthorizedChains}
    #Should Be Equal  ${policy1TimeRestrictions}  ${newPolciyTimeRestrictions}
    #Should Be Equal  ${policy1unauthorizedChains}  ${newPolicyunauthorizedChains}

Insert iPolicy1 Time Restrictions and Chains
    [Tags]  qTest
    [Documentation]    Update iPolicy1 Time Restrictions and Unauthorized Chains
    ...  Run this query in the database:
    ...  INSERT INTO def_time (carrier_id, day_of_week, beg_time, end_time, ipolicy)
    ...  VALUES ('$[carrierId]', 6, '2025-07-11 12:12'::datetime year TO minute, '2026-07-11 13:13'::datetime year TO minute, 1);
    ...  INSERT INTO def_date (carrier_id, beg_date, end_date, ipolicy)
    ...  VALUES ('$[carrierId]', '2025-07-11 01:02'::datetime year TO minute, '2026-07-11 03:04'::datetime year TO minute, 1);
    ...  INSERT INTO def_chains (carrier_id, chain_id, ipolicy)
    ...  VALUES ('$[carrierId]', 1, 8);
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    Get Into DB  TCH
    ${queryUpdatePolicyTimeRestrictions}  catenate
	...  INSERT INTO def_time (carrier_id, day_of_week, beg_time, end_time, ipolicy)
	...  VALUES ('${carrierId}', 6, '2025-07-11 12:12'::datetime year TO minute, '2026-07-11 13:13'::datetime year TO minute, 1);

    ${queryUpdatePolicyDateRestrictions}  catenate
	...  INSERT INTO def_date (carrier_id, beg_date, end_date, ipolicy)
	...  VALUES ('${carrierId}', '2025-07-11 01:02'::datetime year TO minute, '2026-07-11 03:04'::datetime year TO minute, 1);

    ${queryUpdatePolicyunauthorizedChains}  catenate
	...  INSERT INTO def_chains (carrier_id, ipolicy, chain_id)
	...  VALUES ('${carrierId}', 1, 8);

	Execute Sql String  ${queryUpdatePolicyTimeRestrictions}  db_instance=${db_instance}
    Execute Sql String  ${queryUpdatePolicyDateRestrictions}  db_instance=${db_instance}
    Execute Sql String  ${queryUpdatePolicyunauthorizedChains}  db_instance=${db_instance}

Insert iPolicy1 velocity limits and MCC
    [Tags]  qTest
    [Documentation]    Update iPolicy1 velocity limits and MCC
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    Get Into DB  TCH
    ${queryUpdatePolicyVelocityLimits}  catenate
    ...  UPDATE def_card
    ...  SET day_cnt_limit = 1111,
    ...  day_amt_limit = 1122,
    ...  week_cnt_limit = 2222,
    ...  week_amt_limit = 2233,
    ...  mon_cnt_limit = 3333,
    ...  mon_amt_limit = 3344
    ...  WHERE id = ${carrierId}
    ...  AND   ipolicy = 1;
    ${queryUpdatePolicyDateRestrictions}  catenate
    ...  INSERT INTO mcfleet_def_mcc (carrier_id, mcc, ipolicy)
    ...  VALUES ('${carrierId}', 6010, 1);

    Execute Sql String  ${queryUpdatePolicyVelocityLimits}  db_instance=${db_instance}
    Execute Sql String  ${queryUpdatePolicyDateRestrictions}  db_instance=${db_instance}

Delete iPolicy MCC
    [Tags]  qTest
    [Documentation]    Delete iPolicy1 MCC
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    Get Into DB  TCH
    ${queryDeletePolicyMCC}  catenate
    ...  DELETE FROM mcfleet_def_mcc
    ...  WHERE carrier_id = '${carrier_id}'
    ...  AND ipolicy = 1
    ...  AND mcc = 6010
    Execute Sql String  ${queryDeletePolicyMCC}  db_instance=${db_instance}

Delete iPolicy Time Restrictions and Chains
    [Tags]  qTest
    [Documentation]    Delete iPolicy Time Restrictions and Chaibns
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    Get Into DB  TCH
    ${queryDeletePolicyTimeRestrictions}  catenate
    ...  DELETE FROM def_time
    ...  WHERE carrier_id = '${carrierId}'
    ...  AND ipolicy = 1
    ...  AND day_of_week = 6;

    ${queryDeletePolicyDateRestrictions}  catenate
    ...  DELETE FROM def_date
    ...  WHERE carrier_id = '${carrierId}'
    ...  AND ipolicy = 1
    ...  AND beg_date = '2025-07-11 01:02'::datetime year TO minute;

    ${queryDeletePolicyunauthorizedChains}  catenate
    ...  DELETE FROM def_chains
    ...  WHERE carrier_id = '${carrierId}'
    ...  AND ipolicy = 1
    ...  AND chain_id = 8;

    Execute Sql String  ${queryDeletePolicyTimeRestrictions}  db_instance=${db_instance}
    Execute Sql String  ${queryDeletePolicyunauthorizedChains}  db_instance=${db_instance}
    Execute Sql String  ${queryDeletePolicyDateRestrictions}  db_instance=${db_instance}

Navigate to prompt screen
    [Tags]    qTest
    [Documentation]    Navigate to prompt screen
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Mouse Over  cardMenubar_3x2
        Click Element  cardPrompts_1x2
    ELSE IF  '${type}'=='card'
        Mouse Over  cardMenubar_4x2
        Click Element    cardPrompts_1x2
    END

Create Prompt in eManager
    [Tags]    qTest
    [Documentation]    Create prompt for CUSTOMER NUMBER on policy
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Click Element  createPromptPolicy
        Select From List by Label  cardInfo.infoId  Customer Number
        Click Element  validationInformation
        Input Text    cardInfo.reportValue  12345
        Click Element  finishCardPromptNoValidationBtn
    ELSE IF    '${type}'=='card'
        Click Element    createPromptCard
        Select From List by Label  cardInfo.infoId  Customer Number
        Click Element  validationInformation
        Input Text    cardInfo.reportValue  12345
        Click Element  finishCardPromptNoValidationBtn
    END

Validate prompt was created
    [Tags]    qTest
    [Documentation]    Validate prompt was created
    capture page screenshot
    ${message}  Catenate  You have successfully created the prompt of (CUNB).
    sleep  1
    Element Should Contain  //*[@class="messages"]  ${message}

Delete prompt in eManager
    [Tags]    qTest
    [Documentation]    Delete prompt in eManager
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Click Element  deletePolicyPrompt
        Handle Alert  ACCEPT
        Sleep  1
    ELSE IF    '${type}'=='card'
        Click Element  (//input[@name="deleteCardPrompt"])[last()]
        Handle Alert  ACCEPT
        Sleep  1
    END

Validate prompt was deleted
    [Tags]    qTest
    [Documentation]    Validate prompt was deleted
    Element Should Contain  //*[@class="messages"]  You have successfully deleted the prompt of (CUNB).

Navigate to limits screen
    [Tags]    qTest
    [Documentation]    Navigate to limits screen
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Mouse Over  cardMenubar_2x2
        Click Element  cardLimits_1x2
    ELSE IF  '${type}'=='card'
        Mouse Over  cardMenubar_3x2
        Click Element  cardLimits_1x2
    END

Create limit in eManager
    [Tags]    qTest
    [Documentation]    Create limit on policy or card
    [Arguments]   ${type}
    IF  '${type}'=='policy'
        Click Element  createPolicyLimit
        Sleep  1
        Select From List by Label  limitIdChoice  ACCE - ACCESSORIAL
        Click Element  processCategory
        Input Text    policyLimit.limit  12345
        Click Element  finishPolicyLimit
    ELSE IF  '${type}'=='card'
        Click Element    createLimit
        Sleep  1
        Select From List by Label  limitIdChoice  ACCE - ACCESSORIAL
        Click Element   processCategory
        Input Text    cardLimit.limit  12345
    Click Element  finishCardLimit
    END

Validate limit was created
    [Tags]    qTest
    [Documentation]    Validate limit was created
    capture page screenshot
    ${message}  Catenate  You have successfully Added the Description (ACCESSORIAL), Amount (12345 USD), Hours (1), and AutoRoll (None).
    sleep  1
    Element Should Contain  //*[@class="messages"]  ${message}

Delete Limit in eManager
    [Tags]    qTest
    [Documentation]    Delete limit in eManager
    [Arguments]   ${type}
    IF  '${type}'=='policy'
        Click Element  deletePolicyLimit
        Handle Alert  ACCEPT
        Sleep  1
    ELSE IF  '${type}'=='card'
        Click Element  deleteCardLimit
        Handle Alert  ACCEPT
        Sleep  1
    END

Validate Limit Was Deleted
    [Tags]    qTest
    [Documentation]    Validate limit was deleted
    Element Should Contain  //*[@class="messages"]  You have successfully deleted the Description (ACCESSORIAL), Amount (12345 USD), Hours (1), and AutoRoll (None).

Navigate to Locations screen
    [Tags]    qTest
    [Documentation]    Navigate to Locations screen
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Mouse Over  cardMenubar_4x2
        Click Element  cardLocation_2x2
    ELSE IF  '${type}'=='card'
        Mouse Over  cardMenubar_5x2
        Click Element  cardLocation_2x2
    END

Create Unauthorized Chain in eManager
    [Tags]    qTest
    [Documentation]    Create unauthorized chain on policy
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Click Element  createPolicyUnauthorizeChain
        Click Element    //input[@value="8"]
        Click Element  saveButton
    ELSE IF  '${type}'=='card'
        Click Element  card.header.locationSource
        Click Element  saveCardInformation
        Click Element  createCardUnauthorizeChain
        Click Element  //input[@value="8"]
        Click Element  saveBtnId
    END

Validate unauthorized chain was created
    [Tags]    qTest
    [Documentation]    Validate unauthorized chain was created
    capture page screenshot
    ${message}  Catenate  Successfully added chain number(s)(8).
    sleep  1
    Element Should Contain  //*[@class="messages"]  ${message}

Delete unauthorized chain in eManager
    [Tags]    qTest
    [Documentation]    Delete unauthorized chain in eManager
    [Arguments]    ${type}
    IF  '${type}'=='policy'
        Click Element  createPolicyUnauthorizeChain
        Click Element    //input[@value="8"]
        Click Element  saveButton
    ELSE IF  '${type}'=='card'
        Click Element  createCardUnauthorizeChain
        Click Element    //input[@value="8"]
        Click Element  saveButton
    END

Validate unauthorized chain was deleted
    [Tags]    qTest
    [Documentation]    Validate unauthorized chain was deleted
    Element Should Contain  //*[@class="messages"]  No chain to be saved

Validate unauthorized policy chains still exist
    [Tags]    qTest
    [Documentation]    Validate unauthorized chains still exist
    ...  get into db  TCH and run
    ...  SELECT * FROM def_chains WHERE carrier_id = '$[carrier_id]' AND ipolicy = '1' AND chain_id = '8';
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    Row Count is Equal to X    SELECT * FROM def_chains WHERE carrier_id = '${carrierId}' AND ipolicy = '1' AND chain_id = '8';  1

Validate unauthorized card chains still exist
    [Tags]    qTest
    [Documentation]    Validate unauthorized card chains still exist
    [Arguments]  ${cardnum}=${modelEFScard.num}  ${db_instance}=TCH
    Row Count Is Equal To X    SELECT * FROM card_chain WHERE card_num = '${cardnum}' AND chain_id = '8';  1

Validate unathorzed policy chain has been removed
    [Tags]    qTest
    [Documentation]    Validate unathorzed policy chain has been removed
    [Arguments]  ${carrierId}=${modelEFScard.carrier.id}  ${db_instance}=TCH
    Row Count Is 0   SELECT * FROM def_chains WHERE carrier_id = '${carrierId}' AND ipolicy = '1' AND chain_id = '8';

Validate unauthorized card chain has been removed
    [Tags]    qTest
    [Documentation]    Validate unauthorized card chain has been removed
    [Arguments]  ${cardnum}=${modelEFScard.num}  ${db_instance}=TCH
    Row Count Is 0   SELECT * FROM card_chain WHERE card_num = '${cardnum}' AND chain_id = '8';

Delete unauthorized Chains from DB
    [Tags]    qTest
    [Documentation]    Delete unauthorized chains from DB
    [Arguments]    ${carrierId}=${modelEFScard.carrier.id}  ${cardnum}=${modelEFScard.num}
    ${removePolicyChain}  catenate  DELETE FROM def_chains WHERE carrier_id = '${carrierId}' AND ipolicy = '1' AND chain_id = '8';
    Execute Sql String    ${removePolicyChain}    TCH
    ${removeCardChain}  catenate  DELETE FROM card_chain WHERE card_num = '${cardnum}' AND chain_id = '8';
    Execute Sql String    ${removeCardChain}    TCH
    Tch Logging    \n Carrier: ${carrierId} \n Card: ${cardnum}