*** Settings ***
Library  otr_robot_lib.auth.PyAuth.StringBuilder
Library  otr_robot_lib.auth.PyAuth.AuthLog
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  String
Library  DateTime
Resource  otr_robot_lib/robot/PricingKeywords.robot
Resource  otr_robot_lib/robot/CarrierGroupKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Teardown  Teardown

Force Tags  eManager

*** Variables ***

${carrier1}  103866
${card1}  7083050910386616104
${carrier2}  102698
${card2}  7083059810269800679
${carrier3}  146567
${card3}  7083051214656700022
${card4}  7083050910386614554

*** Test Cases ***
Add Policy Prompt
    [Tags]  JIRA:BOT-1121  JIRA:BOT-437  qTest:33066386  tier:0         refactor

    Ensure Carrier has User Permission    ${validCard.carrier.member_id}    MANAGE_POLICIES
    open emanager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    go to  ${emanager}/cards/PolicyPromptManagement.action
    Remove Prompt on Prompt Management Screen if Present  Driver ID
    click element  xpath=//*[@name="createPromptPolicy"]
    click element  xpath=//*[@value="DRID"]
    click element  xpath=//*[@name="validationInformation"]
    click element  xpath=//*[@value="EXACT_MATCH"]
    click element  xpath=//*[@name="processValidationRules"]
    input text  xpath=//*[@name="cardInfo.matchValue"]  14356
    click element  xpath=//*[@name="finishCardPromptBtn"]

    [Teardown]  run keyword if test failed  Add Prompt TearDown

#Validating No Screen Error When Finishing Prompt
#    page should not contain element  xpath=//*[@class="errors"]//*[contains(text(),'The following errors have occurred')]

Validate Prompt in DB
    [Tags]  JIRA:BOT-1121  JIRA:BOT-437  qTest:33066386  tier:0         refactor
    Get Into DB  tch
    ${infoId}=  query and strip  select info_id from def_info where ipolicy = 1 and carrier_id = ${validCard.carrier.member_id} and info_id = 'DRID'
    should be equal as strings  ${infoId}  DRID

Delete DRID Prompt
    [Tags]  JIRA:BOT-1721  JIRA:BOT-437  qTest:33153632  tier:0         refactor

    click element  //table[@id='policy']//td[contains(normalize-space(),'Driver ID')]/parent::tr//input[@name='deletePolicyPrompt']
    handle alert

Validate Delete DRID Prompt
    [Tags]  JIRA:BOT-1721  JIRA:BOT-437  qTest:33153632  tier:0         refactor
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully deleted the prompt of')]
    Get Into DB  tch
    row count is 0  select info_id from def_info where info_id = 'DRID' and carrier_id = ${validCard.carrier.member_id} and ipolicy = '1'

Disallow Hand enter
    [Tags]  JIRA:BOT-437  qTest:33156104         refactor
   select radio button  radioHandEnter  false
   click button  savePolicyInformation

Validate Disallow db
    [Tags]  JIRA:BOT-437  qTest:33156104         refactor
     Get Into DB  tch
    ${handEnter}=  query and strip  select handenter from def_card where ipolicy = 1 and id = ${validCard.carrier.member_id}
    should be equal  ${handEnter}    N

Allow Hand enter
    [Tags]  JIRA:274  JIRA:BOT-437  qTest:33156216         refactor
   select radio button  radioHandEnter  true
   click button  savePolicyInformation

Validate Allow db
    [Tags]  JIRA:274  JIRA:BOT-437  qTest:33156216         refactor
     Get Into DB  tch
    ${handEnter}=  query and strip  select handenter from def_card where ipolicy = 1 and id = ${validCard.carrier.member_id}
    should be equal  ${handEnter}    Y

Managed fuel Checked
    [Tags]  JIRA:BOT-437  qTest:33156165     refactor
   select checkbox   checkBoxDefCardMgdFuel
   click button  savePolicyInformation

Validate Managed Fuel db
    [Tags]  JIRA:BOT-437  qTest:33156165     refactor
     Get Into DB  tch
    ${managed_fuel}=  query and strip  select managed_fuel from def_card where ipolicy = 1 and id = ${validCard.carrier.member_id}
    should be equal  ${managed_fuel}    Y

Managed fuel UnChecked
    [Tags]  JIRA:BOT-437  qTest:33156269        refactor
   unselect checkbox  checkBoxDefCardMgdFuel
   click button  savePolicyInformation

Validate Not Managed Fuel db
    [Tags]  JIRA:BOT-437  qTest:33156269             refactor
     Get Into DB  tch
    ${managed_fuel}=  query and strip  select managed_fuel from def_card where ipolicy = 1 and id = ${validCard.carrier.member_id}
    should be equal  ${managed_fuel}    N

Change Description
    [Tags]  JIRA:BOT-437  qTest:33156354         refactor
    input text  xpath=//*[@name='changeDescription']     Automation Test
    click button  savePolicyInformation

Validate Description Changed db
    [Tags]  JIRA:BOT-437  qTest:33156354         refactor
     Get Into DB  tch
    ${description}=  query and strip  select description from def_card where ipolicy = 1 and id = ${validCard.carrier.member_id}
    should contain  ${description}    Automation Test

Change Description Back
    [Tags]  qTest:33156354           refactor
    input text  xpath=//*[@name='changeDescription']     Test Policy
    click button  savePolicyInformation

Change Policy
   [Tags]  JIRA:BOT-437  qTest:33059346  tier:0         refactor

   ${has_multiple_policies}    Run Keyword And Return Status    Page Should Contain Element    xpath=//*[@name='policy.policyNumber']/option[@value='2']
   Run Keyword If    '${has_multiple_policies}'=='False'    Create New Policy
   click element  xpath=//*[@name='policy.policyNumber']/option[@value='2']
   click element  xpath=//*[@name='policy.policyNumber']/option[@value='1']

Add Numeric Length Prompt
    [Tags]  JIRA:QAT-275  JIRA:BOT-1721  JIRA:BOT-437  qTest:33066480    refactor

    Remove Prompt on Prompt Management Screen if Present  Unit Number
    click element  xpath=//*[@name="createPromptPolicy"]
    click element  xpath=//*[@value="UNIT"]
    click element  xpath=//*[@name="validationInformation"]
    click element  xpath=//*[@value="NUMERIC"]
    click element  xpath=//*[@name="processValidationRules"]
    click element  xpath=//*[@name="checkType"]
    click element  xpath=//*/option[@value="length"]
    click element  xpath=//*[@name="nextToCheckType"]
    input text  xpath=//*[@name="cardInfo.minimum"]  2
    input text  xpath=//*[@name="cardInfo.maximum"]  4
    click element  xpath=//*[@name="finishCardPromptCheckType"]

    [Teardown]  run keyword if test failed  Add Prompt TearDown

Validate Numeric Length Prompt
    [Tags]  JIRA:QAT-275  JIRA:BOT-1721  JIRA:BOT-437  qTest:33066480   refactor
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully created the prompt of')]
    Get Into DB  tch
    ${info_id}=  query and strip  select info_id from def_info where info_id = 'UNIT' and carrier_id = ${validCard.carrier.member_id} and ipolicy = '1'
    should be equal as strings  ${info_id}  UNIT

Delete Numeric Prompt
    [Tags]  JIRA:BOT-1721  JIRA:BOT-437  qTest:33153632     refactor

    click element  //table[@id='policy']//td[contains(normalize-space(),'Unit Number')]/parent::tr//input[@name='deletePolicyPrompt']
    handle alert

Validate Delete Numeric Prompt
    [Tags]  JIRA:BOT-1721  JIRA:BOT-437  qTest:33153632     refactor
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully deleted the prompt of')]
    Get Into DB  tch
    row count is 0  select info_id from def_info where info_id = 'UNIT' and carrier_id = ${validCard.carrier.member_id} and ipolicy = '1'
    close browser

Policy change control When both payr_type are U
    [Tags]  JIRA:BOT-996    refactor
#    The following 4 test cases are to test that we should not be able to change the policy of a card to something which
#    it is not allowed to be on. The applicable policies that are derived from queries is checked against policies
#    from policy dropdown on UI

    Get possible values for policy change  ${carrier1}  ${card1}
    Change the policy in eManager  ${carrier1}  ${card1}

Policy change control When both payr_type are A
    [Tags]  JIRA:BOT-996    refactor
    Get possible values for policy change  ${carrier2}  ${card2}
    Change the policy in eManager  ${carrier2}  ${card2}

Policy change control When payr_type1 = U and payr_type2 = A
    [Tags]  JIRA:BOT-996    refactor
    Get possible values for policy change  ${carrier1}  ${card1}
    Change the policy in eManager  ${carrier1}  ${card1}

Policy change control When one of the payr_type is NULL
    [Tags]  JIRA:BOT-996    refactor
    Get possible values for policy change  ${carrier1}  ${card4}
    Change the policy in eManager  ${carrier1}  ${card4}

Add/Edit/Delete a prompt for shell reskin carrier
    [Documentation]  This test case is to check if a carrier can add/edit/delete a prompt
    ...  for a reskin shell carrier without any issues
    [Tags]  JIRA:FRNT-32  JIRA:FRNT-33  JIRA:FRNT-72  qTest:36859224  reskin  refactor
    get into db  SHELL
    execute sql string  dml=delete FROM def_info WHERE carrier_id = 600003 AND info_id = 'UNIT' AND ipolicy = 1;
    Open Browser to eManager
    Log into eManager  ${reskin_carrier}  ${reskin_password}
    go to  ${emanager}/cards/PolicyPromptManagement.action
    Add a prompt
    Edit a prompt
    Delete a prompt

Parkland Carrier Policy Prompts Limited
    [Tags]  JIRA:ROCKET-26  qTest:52744887  PI:10  API:Y         refactor
    [Setup]  Find Parkland Admin User
    Go to Select Program > Manage Policies > Manage Policies
    Verify Parkland Prompts
    [Teardown]  teardown

Parkland Carrier Site Prompts Limited
    [Tags]  JIRA:ROCKET-26  qTest:52744879  PI:10  API:Y         refactor
    [Setup]  Find Parkland Admin User
    Go to Select Program > Manage Site Policies
    Verify Parkland Site Policy Prompts
    [Teardown]  teardown

Parkland Carrier Card Prompts Limited
    [Tags]  JIRA:ROCKET-26  qTest:52744905  PI:10  API:Y             refactor
    [Setup]  Find Parkland Card
    Go to Select Program > Manage Cards > View/Update Cards
    Verify Parkland Card Prompts
    [Teardown]  teardown

New Prompts for Ryder Carrier - Policy
    [Tags]  JIRA:ROCKET-219  qtest:55360750  PI:13  API:Y   refactor
    [Setup]  Find Ryder Carrier
    Switch to "${ryder_carrier}" User
    Select Program > "Manage Policies" > "Manage Policies"
    Verify New Prompts - Policy
    [Teardown]  teardown

Validate Add, Update and verify the edit button of Hubometer and Odometer Prompt to card prompt detail on EFS
    [Tags]      PI:15   JIRA:O5SA-530   qTest:117838466
    [Documentation]     Valididade the policy prompt adding a hubometer and odometer, and in the end check if the user is not able to press the edit button on customer info.
    [Setup]     Get Carrier and Card Data To Be Used During Tests
    Verify or Open Account Manager
    Get to Policy Prompt Screen in Account manager
    Add A Hubometer Prompt
    Add A Odometer Prompt
    Enter on Customer info test
    Verifying on customer Info the edit button on the Police Prompt detail
    Delete the card prompt
    [Teardown]     Close Browser

*** Keywords ***
Add Prompt TearDown
    go to  ${emanager}/cards/PolicyPromptManagement.action

Change the policy in eManager

    [Arguments]  ${carrier}  ${card}

    get into db  tch
    ${pwd}=  query and strip to dictionary  select passwd from member where member_id = '${carrier}';
    Open eManager  ${carrier}  ${pwd['passwd']}
    go to  ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    input text  cardSearchTxt  ${card}
    click button  searchCard
    click link  ${card}
    @{Policy}=  get list items  card.header.policyNumber
    should be equal  ${Policy}  ${results2['name']}
    click link  Logout
    [Teardown]  close browser

Get possible values for policy change
    [Arguments]  ${carrier}  ${card}
    get into db  tch

    ${card_id}=  query and strip to dictionary  select card_id from cards where card_num = '${card}';

    ${query1}=  catenate
    ...  SELECT c.card_num, c.status, ct.contract_id, pt.contract_id, cm.member_id, pm.member_id,
    ...  NVL(cm.payr_type,'') as payr_type1, NVL(pm.payr_type,'') as payr_type2
    ...  FROM cards c
    ...  LEFT JOIN def_card d ON c.carrier_id = d.id AND c.icardpolicy = d.ipolicy
    ...  LEFT JOIN contract ct ON ct.contract_id = d.contract_id
    ...  LEFT JOIN contract pt ON pt.contract_id = d.payr_contract_id
    ...  LEFT JOIN member cm ON cm.member_id = ct.issuer_id
    ...  LEFT JOIN member pm ON pm.member_id = pt.issuer_id
    ...  WHERE card_id = ${card_id['card_id']};

    ${results1}=  query and strip to dictionary  ${query1}
    ${query2}=  catenate
    ...  SELECT d.id, d.ipolicy||' - '||trim(NVL(d.description,'')) as name, ct.contract_id, pt.contract_id, cm.member_id, pm.member_id, cm.payr_type, pm.payr_type FROM def_card d
    ...  LEFT JOIN contract ct ON ct.contract_id = d.contract_id
    ...  LEFT JOIN contract pt ON pt.contract_id = d.payr_contract_id
    ...  LEFT JOIN member cm ON cm.member_id = ct.issuer_id
    ...  LEFT JOIN member pm ON pm.member_id = pt.issuer_id
    ...  WHERE d.id = ${carrier}
    ...  AND d.ipolicy Not between 500 and 599

    ${query2}=  run keyword if  '${results1['payr_type1']}' == ''  catenate  ${query2}  AND cm.payr_type is NULL AND pm.payr_type ='${results1['payr_type2']}  ELSE  catenate  ${query2}  AND cm.payr_type = '${results1['payr_type1']}'
    ${query2}=  run keyword if  '${results1['payr_type2']}' == ''  catenate  ${query2}  AND cm.payr_type ='${results1['payr_type1']}' AND pm.payr_type is NULL  ELSE  catenate  ${query2}  AND pm.payr_type = '${results1['payr_type2']}';

    ${results2}=  query and strip to dictionary  ${query2}
    set global variable  ${results2}

Remove Prompt on Prompt Management Screen if Present
    [Arguments]  ${prompt}

    ${passed}  Run Keyword And Return Status  Element Should Be Visible  //table[@id='policy']//td[contains(normalize-space(),'${prompt}')]/parent::tr//input[@name='deletePolicyPrompt']
    Run Keyword if  ${passed}  Run Keywords  TCH Logging  Remove ${prompt} Prompt
    ...  AND  Click Element  //table[@id='policy']//td[contains(normalize-space(),'${prompt}')]/parent::tr//input[@name='deletePolicyPrompt']
    ...  AND  Handle Alert

Add a prompt
    click element  xpath=//*[@name="createPromptPolicy"]
    click element  xpath=//*[@value="UNIT"]
    click element  xpath=//*[@name="validationInformation"]
    input text  xpath=//*[@name="cardInfo.reportValue"]  1234
    click element  xpath=//*[@name="finishCardPromptNoValidation"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully created the prompt of')]
    wait until element is visible  xpath=//*[@id="policyPrompts"]//*[contains(text(),"Unit Number")]/following-sibling::*[contains(text(),'Report Only')]/following-sibling::*[contains(text(),'1234')]
    Verify DB  Z1234
    tch logging  Successfully added a prompt

Edit a prompt
    select from list by label  //*[@id="policyPrompts"]//*[contains(text(),"Unit Number")]//following::*[@id='efsDtActions']  Edit
    wait until page contains  text=Edit Prompt
    input text  cardInfo.reportValue  4567
    click button  updateCardPrompt
    wait until element is visible  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully edited the prompt of')]
    wait until element is visible  xpath=//*[@id="policyPrompts"]//*[contains(text(),"Unit Number")]/following-sibling::*[contains(text(),'Report Only')]/following-sibling::*[contains(text(),'4567')]  timeout=10
    Verify DB  Z4567
    tch logging  Successfully edited a prompt

Delete a prompt
    select from list by label  //*[@id="policyPrompts"]//*[contains(text(),"Unit Number")]//following::*[@id='efsDtActions']  Delete
    wait until element is visible  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully deleted the prompt of')]
    wait until element is not visible  xpath=//*[@id="policyPrompts"]//*[contains(text(),"Unit Number")]
    tch logging  Successfully deleted a prompt

Verify DB
    [Arguments]  ${value}
    get into db  SHELL
    ${prompt}=  query and strip  select info_validation from def_info where carrier_id = '${reskin_carrier}' and info_id = 'UNIT'
    should be equal as strings  ${prompt.strip()}  ${value}

Teardown

    Close All Browsers


Find Parkland Admin User
    [Tags]  qtest
    [Documentation]  Find a parkland admin user from mysql db:
    ...  select user_id from sec_user where user_id like '25%' and status_id = 'A' and user_lname = 'Admin' and company_id IN (select company_id from sec_company where company_header = 'parkland_carrier');
    Get Into DB  MySQL
    ${sql}  catenate  select user_id from sec_user where user_id regexp '25[0-9]*$' and status_id = 'A' and user_lname = 'Admin' and company_id IN (select company_id from sec_company where company_header = 'parkland_carrier');
    @{carriers}  query and return dictionary rows  ${sql}
    ${carrier_id}  evaluate  random.choice(${carriers})
    #${parkland_carrier_id}  find carrier variable  ${sql}  user_id
    ${parkland_carrier_id}  catenate  ${carrier_id['user_id']}
    set test variable  ${parkland_carrier_id}
    Get Into DB  tch
    ${sql}  catenate  select passwd from member where member_id = ${parkland_carrier_id};
    ${parkland_password}  query and strip  ${sql}
    set test variable  ${parkland_password}
    Close All Browsers
    Open eManager  ${intern}  ${internPassword}
    set test variable  ${db}  tch

Verify Parkland Prompts
    [Tags]  qtest
    [Documentation]  Confirm the following options are the ones that apear in eManager as prompt options:
                ...  Driver ID DRID (exact match)
                ...  Driver Name NAME (report only)
                ...  Odometer ODRD (Numeric, Accrual Check)
                ...  Subfleet (report only)
                ...  Trip TRIP (Numeric, exact match, report only)
                ...  Unit UNIT (Numeric, exact match, report Only)
    click element  xpath=//*[@name="createPromptPolicy"]
    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.infoId"]
    ${parkland_prompts}  create list  Driver ID  Driver Name  Odometer  Subfleet Identifier  Trip Number  Unit Number
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@value="UNIT"]
    click element  xpath=//*[@name="validationInformation"]
    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.validationType"]
    ${parkland_prompts}  create list  Numeric  Exact Match  Report Only
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="TRIP"]
    click element  xpath=//*[@name="validationInformation"]
    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.validationType"]
    ${parkland_prompts}  create list  Numeric  Exact Match  Report Only
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="SSUB"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  REPORT_ONLY
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="ODRD"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  NUMERIC
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="NAME"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  REPORT_ONLY
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="DRID"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  EXACT_MATCH
    click element  xpath=//*[@name="backToPromptInfoId"]

Find Parkland Card
    [Tags]  qtest
    [Documentation]  Find an ative card that belongs to a Parkland carrier: select carrier_id from cards where status = 'A' and carrier_id between 2500000 and 2600000;
    get into db  tch
    ${sql}  catenate   select carrier_id from cards where status = 'A' and carrier_id between 2500000 and 2500053;
    @{carriers}  query and return dictionary rows  ${sql}
    ${carrier_id}  evaluate  random.choice(${carriers})
    ${parkland_carrier_id}  catenate  ${carrier_id['carrier_id']}
    set test variable  ${parkland_carrier_id}
    ${sql}  catenate  select passwd from member where member_id = ${parkland_carrier_id};
    ${parkland_password}  query and strip  ${sql}
    set test variable  ${parkland_password}
    ${sql}  catenate   select card_id, card_num from cards where status = 'A' and carrier_id = ${parkland_carrier_id};
    @{cards}  query and return dictionary rows  ${sql}
    ${parklandCard}  evaluate  random.choice(${cards})
    set test variable  ${parklandCard}
    Open eManager  ${intern}  ${internPassword}
    set test variable  ${db}  tch

Verify Parkland Card Prompts
    [Tags]  qtest
    [Documentation]  Confirm the following options are the ones that apear in eManager as card prompt options:
                ...  Driver ID DRID (exact match)
                ...  Driver Name NAME (report only)
                ...  Odometer ODRD (Numeric, Accrual Check)
                ...  Subfleet (report only)
                ...  Trip TRIP (Numeric, exact match, report only)
                ...  Unit UNIT (Numeric, exact match, report Only)
    ${sql}  catenate  delete from card_inf where card_num = '${parklandCard['card_num']}';
    execute sql string  ${sql}
    go to   ${emanager}/cards/CardPromptManagement.action?card.cardId=${parklandCard['card_id']}&card.displayNumber=${parklandCard['card_num']}&lookupInfoRadio=NUMBER
    Click Element   name=createPromptCard

    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.infoId"]
    ${parkland_prompts}  create list  Driver ID  Driver Name  Odometer  Subfleet Identifier  Trip Number  Unit Number
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@value="UNIT"]
    click element  xpath=//*[@name="validationInformation"]
    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.validationType"]
    ${parkland_prompts}  create list  Numeric  Exact Match  Report Only
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="TRIP"]
    click element  xpath=//*[@name="validationInformation"]
    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.validationType"]
    ${parkland_prompts}  create list  Numeric  Exact Match  Report Only
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="SSUB"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  REPORT_ONLY
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="ODRD"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  NUMERIC
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="NAME"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  REPORT_ONLY
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="DRID"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  EXACT_MATCH
    click element  xpath=//*[@name="backToPromptInfoId"]

Verify Parkland Site Policy Prompts
    [Tags]  qtest
    [Documentation]  Confirm the following options are the ones that apear in eManager as site policy prompt options:
                ...  Driver ID DRID (exact match)
                ...  Driver Name NAME (report only)
                ...  Odometer ODRD (Numeric, Accrual Check)
                ...  Subfleet (report only)
                ...  Trip TRIP (Numeric, exact match, report only)
                ...  Unit UNIT (Numeric, exact match, report Only)
    go to   ${emanager}/cards/PolicyPromptManagement.action
    Click Element   name=createPromptPolicy

    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.infoId"]
    ${parkland_prompts}  create list  Driver ID  Driver Name  Odometer  Subfleet Identifier  Trip Number  Unit Number
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@value="UNIT"]
    click element  xpath=//*[@name="validationInformation"]
    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.validationType"]
    ${parkland_prompts}  create list  Numeric  Exact Match  Report Only
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="TRIP"]
    click element  xpath=//*[@name="validationInformation"]
    ${myPrompts}  get list items  xpath=//*[@name="cardInfo.validationType"]
    ${parkland_prompts}  create list  Numeric  Exact Match  Report Only
    lists should be equal  ${myPrompts}  ${parkland_prompts}
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="SSUB"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  REPORT_ONLY
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="ODRD"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  NUMERIC
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="NAME"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  REPORT_ONLY
    click element  xpath=//*[@name="backToPromptInfoId"]

    click element  xpath=//*[@value="DRID"]
    click element  xpath=//*[@name="validationInformation"]
    ${myVal}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal  ${myVal}  EXACT_MATCH
    click element  xpath=//*[@name="backToPromptInfoId"]

Go to Select Program > Manage Policies > Manage Policies
    [Documentation]  Go to Select Program > Manage Policies > Manage Policies
    Switch to "${parkland_carrier_id}" User
    go to  ${emanager}/cards/PolicyPromptManagement.action

Go to Select Program > Manage Site Policies
    [Documentation]  Go to Select Program > Manage Site Policies
    Switch to "${parkland_carrier_id}" User
    go to  ${emanager}/cards/PolicyPromptManagement.action

Go to Select Program > Manage Cards > View/Update Cards
    [Documentation]  Go to Select Program > Manage Cards > View/Update Cards
    Switch to "${parkland_carrier_id}" User
    go to  ${emanager}/cards/PolicyPromptManagement.action

Create New Policy
    [Documentation]  Create new policy from Policy Prompt Detail screen

    Mouse Over    id=cardMenubar_1x2
    Click Element    id=policyManagement_1x2
    ${id}    Generate Random String    5    [NUMBERS]
    Wait Until Element is Visible    name=description
    Input Text    name=description    testing${id}
    Click Element    name=createNewPolicy
    Wait Until Page Contains    Successfully created new policy number
    Go To  ${emanager}/cards/PolicyPromptManagement.action
    Wait Until Page Contains    Policy Prompt Detail

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

Verify New Prompts - Policy
    [Tags]  qtest
    [Documentation]  Verify the New Prompts are available:
                ...  LCCD – LOCATION CODE
                ...  PLDS – PRODUCT LINE DESC
                ...  SPLN – SUBPRODUCT LINE CODE
                ...  SLDS – SUBPRODUCT LINE DESC
    #TODO   Trying to click a button does not exist
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
                ...  select info_validation from def_info where carrier_id = arg0 and info_id = 'arg1';
    ${sql}  catenate  select info_validation from def_info where carrier_id = ${carrier_id} and info_id = '${info_id}';
    ${db_value}  query and strip  ${sql}  db_instance=${db}
    should be equal as strings  ${db_value}  ${info_validation}

Get Carrier and Card Data To Be Used During Tests
    [Documentation]     Using this to search for a card_number and a carrier_id to make the process, set the variables for the max and minimum value
    ${query}  Catenate  select dc.id, dc.ipolicy from def_card dc
                   ...  join contract co on (co.carrier_id = dc.id and co.contract_id = dc.contract_id)
                   ...  join member me on (co.carrier_id = me.member_id)
                   ...  where (select count(*) from def_info di where (di.info_id = 'ODRD' or di.info_id = 'HBRD') and di.ipolicy between 1 and 499 and di.carrier_id = co.carrier_id) = 0
                   ...  and dc.description is not null and me.status = 'A' and co.status = 'A' and dc.ipolicy between 1 and 499 limit 200;

    Get Into Db    TCH
    ${temp}  Query And Strip To Dictionary    ${query}
    Disconnect From Database
    ${len}  Get Length    ${temp}[id]
    ${len}  Evaluate    random.randint(0, $len-1)
    &{efsResult}  Create Dictionary  carrier_id=${temp}[id][${len}]    ipolicy=${temp}[ipolicy][${len}]
    Set Suite Variable  ${efsResult}

    Set Suite Variable      ${carrier_id}   ${efsResult}[carrier_id]
    Set Suite Variable      ${ipolicy}      ${efsResult}[ipolicy]

    ${minimum}  Evaluate    random.randint(0, 100)
    ${maximum}  Evaluate    random.randint($minimum+1, $minimum+1000)
    Set Suite Variable    ${minimum}
    Set Suite Variable    ${maximum}

Verify or Open Account Manager
    [Documentation]    Checks if the browser is open and logged into the emanager, if not it logs into it and goes to account manager
    @{browser_ids}  Get Browser Ids
    IF  '@{browser_ids}'=='@{EMPTY}'
        Open eManager  ${intern}  ${internPassword}  ${True}
    END

    Switch Browser    1
    Go To  ${emanager}/acct-mgmt/RecordSearch.action
    Wait Until Loading Spinners Are Gone

Get to Policy Prompt Screen in Account manager
    [Documentation]  Navigation in the account manager until it gets in the add prompt state
    Wait Until Element Is Visible    //th/input[@name='id']  #input the carrier_id in the search field
    Input Text    //th/input[@name='id']  ${carrier_id}

    Wait Until Element Is Visible    //*[@id='customerSearchContainer']//button[contains(text(),'Submit')]  #click the submit button to look for the carrier
    Click Button    //*[@id='customerSearchContainer']//button[contains(text(),'Submit')]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //button[text()='${carrier_id}']  #click the found carrier hyperlink
    Click Button    //button[text()='${carrier_id}']

    Wait Until Element Is Visible    //*[@id='Policies']  #click the policies tab
    Click Element    //*[@id='Policies']

    Wait Until Element Is Visible    //*[@class='dataTables_scrollHead']//input[@name='id']  #fill the policy number in the serach field
    Input Text    //*[@class='dataTables_scrollHead']//input[@name='id']  ${ipolicy}

    Wait Until Element Is Visible    //*[@id='customerPoliciesSearchContainer']//button[contains(text(),'Submit')]  #click the submit button
    Click Button    //*[@id='customerPoliciesSearchContainer']//button[contains(text(),'Submit')]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //*[@id='DataTables_Table_0']//button[text()="${ipolicy}"]  #click the found site policy number hyperlink
    Scroll Element Into View    //*[@id='DataTables_Table_0']//button[text()="${ipolicy}"]
    Click Button    //*[@id='DataTables_Table_0']//button[text()="${ipolicy}"]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //*[@id='policyPromptsSearchContainer']//button[@class='button searchSubmit']  #click submit button in the new page to refresh the prompt list
    Click Button    //*[@id='policyPromptsSearchContainer']//button[@class='button searchSubmit']
    Wait Until Loading Spinners Are Gone

Add A ${distanceCounter} Prompt
    [Documentation]     Creating a hudometer and odometer prompt for policy
    Wait Until Element Is Visible   //a[@id='ToolTables_DataTables_Table_0_1']  #click the Add button
    Click Element    //a[@id='ToolTables_DataTables_Table_0_1']

    Wait Until Load Icon Disappear
    Wait Until Element Is Visible   //select[@name='promptSummary.promptId']  #select the prompt (hubometer or odometer)
    IF  '${distanceCounter.upper()}'=='HUBOMETER'
        Wait Until Element Is Visible  //select[@name='promptSummary.promptId']/option[text()='Hubometer']
        Select From List By Label   //select[@name='promptSummary.promptId']  Hubometer  #select hubometer
    ELSE IF    '${distanceCounter.upper()}'=='ODOMETER'
        Wait Until Element Is Visible  //select[@name='promptSummary.promptId']/option[text()='Odometer']
        Select From List By Label   //select[@name='promptSummary.promptId']  Odometer  #select odometer
    END

    Wait Until Load Icon Disappear
    Wait Until Element Is Visible   //select[@name='promptSummary.validationCode']/option[text()='Accrual Check']  #select accrual check
    Select From List By Label   //select[@name='promptSummary.validationCode']  Accrual Check

    Wait Until Load Icon Disappear
    Wait Until Element Is Visible   //select[@name='promptSummary.methodCode']/option[text()='Value']  #select method value if needed
    ${selected}  Get Selected List Label  //select[@name='promptSummary.methodCode']
    IF  '${selected.upper()}'!='VALUE'
        Select From List By Label    //select[@name='promptSummary.methodCode']  Value
    END

    Wait Until Element Is Visible  //input[@name='promptSummary.minimum']  #fill up the minimum field
    Input Text    //input[@name='promptSummary.minimum']  ${minimum}

    Wait Until Element Is Visible  //input[@name='promptSummary.maximum']  #fill up the maximum field
    Input Text    //input[@name='promptSummary.maximum']  ${maximum}

    Wait Until Element Is Visible       //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']      #Click Submit Button of the pop-up
    Click Button        //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']
    Wait Until Loading Spinners Are Gone

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

Enter on Customer info test
    [Documentation]     Enter on customer info test to validate, using all the data above
    Go To  ${emanager}/security/ManageCustomers.action

    Wait Until Element Is Visible   //input[@name='searchValue']
    Input Text                      //input[@name='searchValue']  ${carrier_id}
    Wait Until Element Is Visible   //*[@name='SearchCustomers']
    Click Button    //*[@name='SearchCustomers']

    Wait Until Element Is Visible      //*[@id="searchCustomerTable"]/tbody//a
    Click Element                     //*[@id="searchCustomerTable"]/tbody//a[contains(.,'${carrier_id}')]

    Go To  ${emanager}/cards/PolicyPromptManagement.action

Verifying on customer Info the edit button on the Police Prompt detail
    [Documentation]     To verify if the hubometer and odometer does not have a Edit button.

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible       //select[@name='policy.policyNumber']
    Select From List By Value           //select[@name='policy.policyNumber']       ${ipolicy}

    Wait Until Element Is Visible    //td[contains(text(), 'Hubometer')]/following-sibling::td[contains(text(),'Accrual Check')]
    Element Should Not Be Visible    //td[contains(text(), 'Odometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[2]/form/input[@name='editInformation']
    Element Should Not Be Visible    //td[contains(text(), 'Hubometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[2]/form/input[@name='editInformation']

Delete the card prompt
    [Documentation]    Delete all the prompt created for this execution
    Wait Until Element Is Visible   //td[contains(text(), 'Odometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deletePolicyPrompt']
    Click Element                   //td[contains(text(), 'Odometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deletePolicyPrompt']
    Handle Alert                    action=ACCEPT   timeout=None
    Wait Until Page Contains    You have successfully deleted the prompt of

    Wait Until Element Is Visible   //td[contains(text(), 'Hubometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deletePolicyPrompt']
    Click Element                   //td[contains(text(), 'Hubometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deletePolicyPrompt']
    Handle Alert                    action=ACCEPT   timeout=None
    Wait Until Page Contains    You have successfully deleted the prompt of

