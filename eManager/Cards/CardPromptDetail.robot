*** Settings ***
Test Timeout  5 minutes
Library  Process

Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  String
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot


Documentation  Card Prompt Detail is intended to test the prompts screen in eManager which can be found by going to Select Program -> Manage Cards -> View/Update Cards and searching for a card.
...
...  This suite goes through all options in the the header section of the prompts screen validating the database. It also performs an override and validates it's created correctly.
...  Finally this suite is expected to test creating and deleteing prompts.



Force Tags  eManager
Test Setup  Go To Card in Emanager

*** Variables ***
${carrier}  145838
${driverID}  1234

*** Test Cases ***
#TODO all test cases refactor check, how we getting data for the test
New Prompts for Ryder Carrier - Card
    [Tags]  JIRA:ROCKET-219  qtest:55360809  PI:13  API:Y   refactor
    [Setup]   Run Keywords      Time To Setup   Find Ryder Card
    Switch to "${ryder_carrier['carrier_id']}" User
    Verify New Prompts - Card

    [Teardown]  close browser

Change card Policy
   [Tags]  JIRA:QAT-592  JIRA:QAT-257  qTest:32790308  tier:0  refactor

   ${newpolicy}  ${original}  Change Policy From Current
   Validate Card Policy in DB  ${validCard.num}  ${newpolicy}

   [Teardown]  Set Card Policy in DB  ${validCard.num}  ${original}

Validate Birthday Prompt
    [Tags]  JIRA:BOT-254  deprecated  refactor
    [Documentation]  Make sure Report Only allows the &, and Exact Match doesn't allow the &.
    ...  Report Only in eManager now removes the &
    [Setup]  run keywords  Delete Card Prompt from DB  ${validCard.num}  BDAY
                        ...  AND  Go To Card in Emanager

    Click Create Prompt
    Select Info Type  BDAY
    Select Validation Type  EXACT_MATCH
    Input Match Value  &
    Finish Prompt

    Validate Error Message On Screen  is not a valid Exact Value

    Back To Validation Type
    Select Validation Type  REPORT_ONLY
    Input Match Value  &
    Finish Prompt

Add Prompt
    [Tags]  JIRA:QAT-592  JIRA:QAT-260  qTest:32790474  tier:0  refactor
    [Documentation]
    [Setup]  Go To Card in Emanager

    Click Create Prompt
    Select Info Type  DRID
    Select Validation Type  EXACT_MATCH
    Finish Prompt
    Validate Error Message On Screen  Exact Value: is a required field
    Input Match Value  1234
    Finish Prompt

    Validate Prompt Value in DB  ${validCard.num}  DRID  V1234

Delete Prompt
    [Tags]  qTest:32820673  tier:0  refactor
    [Setup]  run keywords  Run keyword and ignore error  Insert Exact Match Card Prompt into DB  ${validCard.num}  DRID  V1234
                ...        AND  Go To Card in Emanager

    Delete Prompt  Driver ID
    Validate Prompt Was Deleted  ${validCard.num}  DRID

Override Card  #SubTab on Card Prompt Page
    [Tags]  JIRA:QAT-264  JIRA:QAT-263  JIRA:QAT-262 JIRA:BOT-782  qTest:32825519  qTest:32826515  qTest:32827475  deprecated  refactor
    [Documentation]  JIRA:BOT-782 Tests cards manual entry using the override
    setup card contract  velocity_enabled=Y

    Change Hand Enter  ALLOW
    Go To Card Override Screen
    Select Override Count  5
    Override Locations
    Override Hand Enter
    Override Velocity Limits
    Override Prompts
    Finish Override

    Set Override Limit Option  ULSD
    Input Override Limit Amount  9999
    Finish Limit Override

    Set Override Daily Count And Amount  2  150
    Set Override Weekly Count And Amount  10  300
    Set Override Monthly Count And Amount  25  1000
    Finish Velocity Override

    Validate Hand Enter Overriden  ${validCard.num}
    Validate Remove Override is Visible
    Validate Override Count  ${validCard.num}  5

Delete Card Override
	[Tags]  qTest:32822225  deprecated  refactor
	Click Delete Override
	Validate Ovrride Deleted  ${validCard.num}

Put Card on Hold For Fraud
    [Tags]  JIRA:BOT-1706  qTest:29000592  Regression  JIRA:SSIE-78  deprecated  refactor
    [Documentation]  Change card status to Hold for Fraud, this functionality was removed from eManager and is only done in Account Manager
    Search Suitable Carrier and Card
    ${backup_card_status}=  assign string  ${card_num.status}

    Open eManager  ${card_num.carrier.id}  ${card_num.carrier.password}
    Navigate to View/Update Cards
    Edit Card  ${card_num.num}
    Change Card Status  FRAUD
    Validate Card Status Sucess Message  Your card is currently in hold for fraud, please call 1-888-824-7378 for fraud assistance.
    Validate Card Status on DB  ${card_num}  FRAUD

    [Teardown]  Update Card Status  ${card_num.num}  ${backup_card_status}

Limit cards to only 1 Active Card based on Driver ID Anything-EXACT MATCH
    [Tags]  JIRA:FRNT-139  qTest:37330252  deprecated
    [Documentation]  This to test that for a carrier, DRID has to be unique for all the active cards
    ...  This test case is for trying to add same DRID as one active to another active card to be an EXACT MATCH
    ...  and the next test case is for trying to add same DRID as one active to another active card to be an REPORT ONLY
    Setup  ${carrier}
    ${validCard.carrier.password}    Get Carrier Password  ${carrier}  TCH
    Open eManager  ${carrier}  ${validCard.carrier.password}
    Navigate to View/Update Cards
    ${card_num}  Get a suitable card  ${carrier}
    Edit Card  ${card_num}
    Add prompt  DRID  EXACT_MATCH  ${driverID}
    page should contain element  //*[@class='messages']//*[contains(text(),'Unable to assign Driver ID, duplicate Driver ID')]

Limit cards to only 1 Active Card based on Driver ID Anything-REPORT ONLY
    [Tags]  JIRA:FRNT-139  qTest:37428022  deprecated
    Setup  ${carrier}
    ${validCard.carrier.password}    Get Carrier Password  ${carrier}  TCH
    Open eManager  ${carrier}  ${validCard.carrier.password}
    Navigate to View/Update Cards
    ${card_num}  Get a suitable card  ${carrier}
    Edit Card  ${card_num}
    Add prompt  DRID  REPORT_ONLY  ${driverID}
    page should contain element  //*[@class='messages']//*[contains(text(),'Unable to assign Driver ID, duplicate Driver ID')]

Validate Add, Update and verify the edit button of Hubometer and Odometer Prompt to card prompt detail on EFS
    [Tags]      PI:15   JIRA:O5SA-530   qTest:31087392
    [Documentation]     Valididade the card prompt adding a hubometer and odometer, and in the end check if the user is not able to press the edit button on customer info.
    [Setup]     Get Carrier and Card Data To Be Used During Tests
    Verify or Open Account Manager
    Get to Policy Prompt Screen in Account manager
    Add A Hubometer Prompt
    Add A Odometer Prompt
    Enter on Customer info test
    Verifying on customer Info the edit button on the Manage Cards
    Delete the card prompt
    [Teardown]    Close Browser

*** Keywords ***
Time to Setup

    ${originalPolicy}=  assign string  ${validCard.policy.num}
    Open Emanager  ${validCard.carrier.id}  ${validCard.carrier.password}
    get into db  tch

    Start Setup Card  ${validCard.num}
    Clear Card Prompts
    Clear Card Limits

Go To Card in Emanager
   go to   ${emanager}/cards/CardPromptManagement.action?card.cardId=${validCard.id}&card.displayNumber=${validCard.num}&lookupInfoRadio=NUMBER

Search Suitable Carrier and Card
    [Arguments]  ${amount}=100
    Get Into DB  TCH
    ${query}  Catenate  SELECT c.card_num
    ...                     FROM cards c
    ...                         INNER JOIN contract co ON (c.carrier_id = co.carrier_id)
    ...                         INNER JOIN member m ON (c.carrier_id = m.member_id)
    ...                     WHERE c.status = 'A'
    ...                     AND c.card_type = 'TCH'
    ...                     AND payr_status = 'A'
    ...                     AND	payr_use = 'B'
    ...                     AND mrcsrc = 'N'
    ...                     AND	payr_mrcsrc = 'Y'
    ...                     AND co.daily_bal < co.daily_limit-${amount}
    ...                     LIMIT 1
    ${card_num}=  find card variable  ${query}
    set suite variable  ${card_num}

Navigate to View/Update Cards
    go to   ${emanager}/cards/CardLookup.action

Edit Card
    [Arguments]  ${card_num}
    Select Radio Button  lookupInfoRadio  NUMBER
    Input Text  xpath=//*[@name='cardSearchTxt']  ${card_num}
    Click Element  xpath=//*[@name='searchCard']
    Click Element  //a[contains(@href,'CardPromptManagement.action') and text()='${card_num}']

Change Card Status
    [Arguments]  ${card_status}
    Select Radio Button  card.header.status  ${card_status}
    click button  saveCardInformation
    wait until page contains element  xpath=//*[@name='card.header.status' and @value='${card_status}' and @checked='checked']  10  Card Status Did not change in 10 seconds

Update Card Status
    [Arguments]  ${card_num}  ${card_status}
    Get Into DB  TCH
    execute sql string  dml=update cards SET status='${card_status}' WHERE card_num = '${card_num}'

Validate Card Status on DB
    [Arguments]  ${card_num}  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='FRAUD'  U  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='ACTIVE'  A  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='INACTIVE'  I  ${card_status}
    ${card_status}  Set Variable If  '${card_status}'=='HOLD'  H  ${card_status}
    Get Into DB  TCH
    Row Count Is Equal To X  SELECT 1 FROM cards WHERE status = '${card_status}' AND card_num = '${card_num}'  1

Validate Card Policy in DB
    [Arguments]  ${card}  ${policy}
   ${db_policy}  query and strip  SELECT icardpolicy from cards where card_num = '${card}'
   Should Be Equal As Numbers    ${db_policy}    ${policy}  msg=db: ${db_policy} does not equal ui:${policy}  values=${False}

Set Card Policy in DB
    [Arguments]  ${card}  ${policy}
    execute sql string  dml=update cards set icardpolicy = ${policy} where card_num = '${card}'

Validate Card Status Sucess Message
    [Arguments]  ${message}
    Page Should Contain Element  //b[text()='${message}']

Change Policy From Current
    ${origpolicy}=  get selected list value  card.header.policyNumber

    select from list by index  card.header.policyNumber  1
    ${policy}=  get selected list value  card.header.policyNumber
    click button  saveCardInformation

    wait until page contains element  xpath=//*[@name='card.header.policyNumber']/option[@value='${policy}' and @selected='selected']  10
    set suite variable  ${origpolicy}

    [Return]  ${policy}  ${origpolicy}

Change Hand Enter
   [Arguments]  ${handEnter}
   select radio button  card.header.handEnter  ${handEnter}
   click button  saveCardInformation
   wait until page contains element  xpath=//*[@name='card.header.handEnter' and @value='${handEnter}' and @checked='checked']  10  HandEnter Did not change to ${handEnter} within 10 seconds

Click Create Prompt
    Click Element   name=createPromptCard

Select Info Type
    [Arguments]  ${infoPrompt}
    Select From List By Value    name=cardInfo.infoId   ${infoPrompt}
    Click Element   name=validationInformation

Select Validation Type
    [Arguments]  ${validationType}
    Select From List By Value    name=cardInfo.validationType    ${validationType}
    Click Element    name=processValidationRules

Input Match Value
    [Arguments]  ${matchValue}
    Input Text    name=cardInfo.matchValue    ${matchValue}

Finish Prompt
    Click Element    name=finishCardPromptBtn

Validate Error Message On Screen
    [Arguments]  ${errormessage}
    page should contain element  //div[@class="errors"]//*[contains(text(),"${errormessage}")]

Back To Validation Type
    Click Element    name=backToValidationType

Cancel Create Prompt
    Click Element  name=cancel

Validate Prompt Value in DB
    [Arguments]  ${card}  ${prompt_type}  ${value}


    ${row}=  query and strip to dictionary  SELECT info_id,info_validation FROM card_inf WHERE info_id = '${prompt_type}' AND card_num = '${card}'

Delete Card Prompt from DB
    [Arguments]  ${card}  ${prompt_type}

    execute sql string  dml=delete from card_inf where info_id = '${prompt_type}' and card_num = '${CARD}'

Insert Exact Match Card Prompt into DB
    [Arguments]  ${card}  ${prompt_type}  ${value}


    execute sql string  dml=insert into card_inf (card_num,info_id,info_validation) values('${CARD}','${prompt_type}','${value}')

Delete Prompt
    [Arguments]  ${prompt}
    click element  //*[contains(text(),'${prompt}')]/..//*[@name='deleteCardPrompt']
    Handle Alert
    wait until element is not visible  //*[contains(text(),'${prompt}')]/..//*[@name='deleteCardPrompt']  timeout=10  error=${prompt} prompt not deleted within 10 seconds

Validate Prompt Was Deleted
    [Arguments]  ${card}  ${prompt}
    ${status}=  run keyword and return status  row count is 0  Select info_id from card_inf where info_id = '${prompt}' and card_num = '${card}'
    run keyword unless  ${status}  fail  ${prompt} card prompt was not delted from the database

Go To Card Override Screen
    go to  ${emanager}/cards/CardPromptManagement.action?overrideCard=overrideCard&cardOverride=-1&card.cardId=${validCard.id}&card.displayNumber=${validCard.num}

Select Override Count
    [Arguments]  ${over_count}
    Select From List by value  name=cardOverride  ${over_count}

Override Locations
    click element  name=locationOverrideRadio

Override Hand Enter
    click element  name=handOverride

Override Prompts
    click element  name=promptOverride

Override Velocity Limits
    click element  name=velocityOverride

Finish Override
    click button  name=overrideCard

Set Override Limit Option
    [Arguments]  ${limit}
    Select From List by Value  name=limitIdChoice  ${limit}
    click element  name=processCategory

Input Override Limit Amount
    [Arguments]  ${amt}
    input text  name=cardLimit.limit  ${amt}

Save Limit Override And Add Another
    click element  saveAndAddCardPrompt

Finish Limit Override
    click element  id=finishCardPromptOverrideBtnId

Set Override Daily Count And Amount
    [Arguments]  ${count}  ${amount}
    input text  name=dayCntLimit  ${count}
    input text  name=dayAmtLimit  ${amount}

Set Override Weekly Count And Amount
    [Arguments]  ${count}  ${amount}
    input text  name=weekCntLimit  ${count}
    input text  name=weekAmtLimit  ${amount}

Set Override Monthly Count And Amount
    [Arguments]  ${count}  ${amount}
    input text  name=monCntLimit  ${count}
    input text  name=monAmtLimit  ${amount}

Finish Velocity Override
    click element  name=velocityLimitOverride

Validate Hand Enter Overriden
    [Arguments]  ${card}
    ${output2}  Catenate  SELECT handenter FROM cards WHERE card_num = '${card}'
    ${results}  Query And Strip  ${output2}
    should be equal as strings  ${results}  Y

Validate Remove Override is Visible
    page should contain button  name=deleteCardOverride

Validate Override Count
    [Arguments]  ${card}  ${number}
    ${db_count}  query and strip  select cardoverride from cards where card_num = '${card}'
    should be equal as strings  ${db_count}  ${number}

Click Delete Override
    click button  //*[@name="deleteCardOverride" and @value="Remove Override"]

Validate Ovrride Deleted
    [Arguments]  ${card}
    ${cnt}  query and strip  select cardoverride from cards where card_num = '${card}'
    should be equal as strings  ${cnt}  0

Setup
    [Arguments]  ${carrier}
    get into db  TCH
    ${query}  query and strip  select * from member_meta where member_id = '${carrier}' and mm_key = 'DRID_ALERT';
    ${id}  query and strip  select max(member_meta_id) from member_meta;
    run keyword if  '${query}'=='None'  execute sql string  dml=insert INTO member_meta (member_meta_id,member_id, mm_key,mm_value) VALUES (${id}+1,${carrier},'DRID_ALERT','Y')
    ${query}  query and strip  select * from member_meta where member_id = '${carrier}' and mm_key = 'DRID_UNIQ';
    ${id}  query and strip  select max(member_meta_id) from member_meta;
    run keyword if  '${query}'=='None'  execute sql string  dml=insert INTO member_meta (member_meta_id,member_id, mm_key,mm_value) VALUES (${id}+1,${carrier},'DRID_UNIQ','Y')


Add prompt
    [Arguments]  ${id}  ${validation}  ${value}
    click element  xpath=//*[@name='createPromptCard']
    click element  xpath=//*[@value='${id}']
    click element  xpath=//*[@name='validationInformation']
    click element  xpath=//*[@value='${validation}']
    click element  xpath=//*[@name='processValidationRules']
    click element  xpath=//*[@name='finishCardPrompt']
    run keyword if  '${validation}'=='EXACT_MATCH'  input text   xpath=//*[@name='cardInfo.matchValue']  ${value}
    run keyword if  '${validation}'=='REPORT_ONLY'  input text   xpath=//*[@name='cardInfo.reportValue']  ${value}
    click element  xpath=//*[@name='finishCardPrompt']

Get a suitable card
    [Arguments]  ${carrier}
    get into db  TCH
    ${query}  catenate  select trim(c.card_num) from cards c
                        ...  where c.carrier_id = '${carrier}'

    ${card_num}  query and strip  ${query}
    start setup card  ${card_num}
    setup card prompts  DRID=V${driverID}
    ${query1}  catenate  select trim(card_num) from cards
    ...  where carrier_id = '${carrier}' and card_num != '${card_num}' and card_num not like '%OVER'
    ${card_num1}  query and strip  ${query1}
    start setup card  ${card_num1}
    clear card prompts
    setup card header  status=ACTIVE  infoSource=BOTH

    [Return]  ${card_num1}

Find Ryder Card
    [Tags]  qtest
    [Documentation]  Find a Ryder child carrier:
                    ...  select x.carrier_id, d.card_num
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...      INNER JOIN cards d
                    ...          ON c.carrier_id = d.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...    and d.status = 'A';
    ${sql}  catenate   select x.carrier_id, d.card_num, d.card_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...      INNER JOIN cards d
                    ...          ON c.carrier_id = d.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...    and d.status = 'A'
                    ...  order by x.effective_date DESC
                    ...  Limit 1;
    close browser
    ${ryder_carrier}  query and strip to dictionary  ${sql}  db_instance=tch
    set test variable  ${ryder_carrier}
    Open eManager  ${intern}  ${internPassword}
    set test variable  ${db}  tch

Verify New Prompts - Card
    [Tags]  qtest
    [Documentation]  Verify the New Prompts are available under Card Management:
                ...  LCCD – LOCATION CODE
                ...  PLDS – PRODUCT LINE DESC
                ...  SPLN – SUBPRODUCT LINE CODE
                ...  SLDS – SUBPRODUCT LINE DESC

    ${sql}  catenate  delete from card_inf where info_id in ('LCCD','PLDS','SPLN','SLDS') and card_num = '${ryder_carrier['card_num']}';
    execute sql string  ${sql}  db_instance=tch
    Select Program > "Manage Cards" > "View/Update Cards"
    go to  ${emanager}/cards/CardPromptManagement.action?card.cardId=${ryder_carrier['card_id'].__str__().strip()}&card.displayNumber=${ryder_carrier['card_num'].__str__().strip()}&lookupInfoRadio=NUMBER
    click element  createPromptCard
    ${myPrompts}  get list items  cardInfo.infoId
    ${new_prompts}  create list  Location Code  Product Line Desc  Subproduct Line Code  Subproduct Line Desc
    list should contain sub list  ${myPrompts}  ${new_prompts}
    click element  xpath=//*[@value="LCCD"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  LOCATION CODE
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt for card  ${ryder_carrier['card_num']}  LCCD  ZLOCATION CODE

    click element  createPromptCard
    click element  xpath=//*[@value="PLDS"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  PRODUCT LINE DESC
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt for card  ${ryder_carrier['card_num']}  PLDS  ZPRODUCT LINE DESC

    click element  createPromptCard
    click element  xpath=//*[@value="SPLN"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  SUBPRODUCT LINE CODE
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt for card  ${ryder_carrier['card_num']}  SPLN  ZSUBPRODUCT LINE CODE

    click element  createPromptCard
    click element  xpath=//*[@value="SLDS"]
    click element  xpath=//*[@name="validationInformation"]
    ${type}  get value  xpath=//*[@name="cardInfo.validationType"]
    should be equal as strings  ${type}  REPORT_ONLY
    input text  cardInfo.reportValue  SUBPRODUCT LINE DESC
    click element  finishCardPromptNoValidationBtnA
    Verify Prompt for card  ${ryder_carrier['card_num']}  SLDS  ZSUBPRODUCT LINE DESC

Verify Prompt for card
    [Tags]  qtest
    [Arguments]  ${card_num}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select info_validation from card_inf where card_num = {card_num} and info_id = {INFO};
    ${sql}  catenate  select info_validation from card_inf where card_num = '${card_num}' and info_id = '${info_id}';
    ${db_value}  query and strip  ${sql}  db_instance=${db}
    should be equal as strings  ${db_value}  ${info_validation}

Get Carrier and Card Data To Be Used During Tests
    [Documentation]     Using this to search for a card_number and a carrier_id to make the process, set the variables for the max and minimum value
    ${query}  Catenate  select c.carrier_id, trim(c.card_num) as card_num
                   ...  from cards c
                   ...  join def_card dc  on (dc.id = c.carrier_id and dc.ipolicy = c.icardpolicy)
                   ...  join contract con on (con.contract_id = dc.contract_id)
                   ...  where c.status = 'A' and con.status = 'A' and infosrc = 'C'
                   ...  and upper(c.card_num) = lower(c.card_num)
                   ...  and (select count(*) from card_inf ci where (info_id = 'ODRD' or info_id = 'HBRD') and ci.card_num = c.card_num) = 0
                   ...  and (select count(*) from spec_pol sp where sp.carrier_id = c.carrier_id) > 0
                   ...  limit 250

    Get Into Db    TCH
    ${temp}  Query And Strip To Dictionary    ${query}
    Disconnect From Database
    ${len}  Get Length    ${temp}[card_num]
    ${len}  Evaluate    random.randint(0, $len-1)
    ${efsResult}     Create Dictionary     carrier_id=${temp}[carrier_id][${len}]    card_num=${temp}[card_num][${len}]
    Set Suite Variable  ${efsResult}

    Set Suite Variable      ${carrier_id}   ${efsResult}[carrier_id]
    Set Suite Variable      ${card_num}     ${efsResult}[card_num]

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

#    Switch Browser    1
    Go To  ${emanager}/acct-mgmt/RecordSearch.action
    Wait Until Loading Spinners Are Gone

Get to Policy Prompt Screen in Account manager
    [Documentation]  Navigation in the account manager until it gets in the add prompt state
    Wait Until Element Is Visible    //th/input[@name='id']  #input the carrier_id in the search field
    Input Text    //th/input[@name='id']   ${carrier_id}

    Wait Until Element Is Visible    //*[@id='customerSearchContainer']//button[contains(text(),'Submit')]  #click the submit button to look for the carrier
    Click Button    //*[@id='customerSearchContainer']//button[contains(text(),'Submit')]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //button[text()='${carrier_id}']  #click the found carrier hyperlink
    Click Button    //button[text()='${carrier_id}']

    Wait Until Element Is Visible    //*[@id='Cards']  #click the cards tab
    Click Element    //*[@id='Cards']

    Wait Until Element Is Visible    //*[@class='dataTables_scrollHead']//input[@name='cardNumber']  #fill the card number in the serach field
    Input Text    //*[@class='dataTables_scrollHead']//input[@name='cardNumber']  ${card_num}

    Wait Until Element Is Visible    //*[@id='customerCardsSearchContainer']//button[contains(text(),'Submit')]  #click the submit button
    Click Button    //*[@id='customerCardsSearchContainer']//button[contains(text(),'Submit')]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //*[@id='customerCardsSearchContainer']//button[contains(text(),'${card_num}')]  #click the found card number hyperlink
    Scroll Element Into View    //*[@id='customerCardsSearchContainer']//button[contains(text(),'${card_num}')]
    Click Button    //*[@id='customerCardsSearchContainer']//button[contains(text(),'${card_num}')]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //*[@id='cardPromptsSearchContainer']//button[@class='button searchSubmit']  #click submit button in the new page to refresh the prompt list
    Click Button    //*[@id='cardPromptsSearchContainer']//button[@class='button searchSubmit']
    Wait Until Loading Spinners Are Gone

Add A ${distanceCounter} Prompt
    [Documentation]     Creating a hudometer and odometer prompt
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

    Wait Until Element Is Visible  //*[@id='cardPromptsAddUpdateFormButtons']//button[@id='submit']  #Click Submit Button of the pop-up
    Click Button    //*[@id='cardPromptsAddUpdateFormButtons']//button[@id='submit']
    Wait Until Loading Spinners Are Gone

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

Enter on Customer info test
    [Documentation]     To enter for the customer info test and go to the manage cards page
    Go To  ${emanager}/security/ManageCustomers.action

    Wait Until Element Is Visible   //input[@name='searchValue']
    Input Text                      //input[@name='searchValue']  ${carrier_id}
    Wait Until Element Is Visible   //*[@name='SearchCustomers']
    Click Button    //*[@name='SearchCustomers']

    Wait Until Element Is Visible      //*[@id="searchCustomerTable"]/tbody//a
    Click Element                     //*[@id="searchCustomerTable"]/tbody//a[contains(.,'${carrier_id}')]

    Go To  ${emanager}/cards/CardLookup.action

    Wait Until Element Is Visible    //input[@onClick='cardSearchTxt.disabled=false']
    Click Radio Button               //input[@onClick='cardSearchTxt.disabled=false']

    Wait Until Element Is Visible    //input[@name="cardSearchTxt"]
    Input Text                       //input[@name="cardSearchTxt"]     ${card_num}

    Wait Until Element Is Visible    //input[@id='doSearchPolicy']
    Click Button                     //input[@id='doSearchPolicy']

    Wait Until Element Is Visible    //*[@id='cardSummary']/tbody//a
    Click Element                   //*[@id='cardSummary']/tbody//a[contains(.,'${card_num}')]

Verifying on customer Info the edit button on the Manage Cards
    [Documentation]     To verify if the hubometer and odometer does not have a Edit button
    Element Should Not Be Visible  //td[contains(text(), 'Odometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[2]/form/input[@name='editInformation']

    Element Should Not Be Visible  //td[contains(text(), 'Hubometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[2]/form/input[@name='editInformation']

Delete the card prompt
    [Documentation]    Delete all the prompt created for this execution
    Wait Until Element Is Visible   //td[contains(text(), 'Odometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deleteCardPrompt']
    Click Element                   //td[contains(text(), 'Odometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deleteCardPrompt']
    Handle Alert                    action=ACCEPT   timeout=None
    Wait Until Page Contains    You have successfully deleted the prompt of

    Wait Until Element Is Visible   //td[contains(text(), 'Hubometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deleteCardPrompt']
    Click Element                   //td[contains(text(), 'Hubometer')]/following-sibling::td[contains(text(),'Accrual Check')]/following-sibling::td[3]/form/input[@name='deleteCardPrompt']
    Handle Alert                    action=ACCEPT   timeout=None
    Wait Until Page Contains    You have successfully deleted the prompt of
