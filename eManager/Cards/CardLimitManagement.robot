*** Settings ***
Test Timeout  5 minutes
Library  Process
Library  Collections
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Time To Setup
Suite Teardown    Close Browser

Force Tags  eManager

*** Variables ***
${wait} =  10
${card}  7083050910386616591
${velocity_card}
${DB}  TCH
${old_results}

*** Test Cases ***

Overriden Velocity Limits
    [Tags]    JIRA:BOT-680
    [Documentation]  It should be possible to add and change Refreshing Limits, commonly known as Velocity Limits.
    ...     Change the test case to grab a card dynamically

    Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
#    KEYWORD FOR OVERRIDING THE CARD WITH LIMIT AND REFRESHING
#    LIMITS PARAMETERS
    Override Card  PHON  50  10  5  10  15  10  30
    Check OVER Cards Velocity Limits  ${velocity_card.num}

    [Teardown]  Remove Override on Card  ${velocity_card.num}

Limits Override
    [Tags]  JIRA:BOT-654

    Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
    Override Card  ULSD  100  0  9999  0  0  0  0
    Validate OVER Card handenter  ${velocity_card.num}  Y
    Validate OVER Card override count  ${velocity_card.num}  2
    ${handenter}=  Query and Strip  SELECT handenter FROM cards WHERE card_num LIKE '${velocity_card.num}OVER'
    Should Be Equal As Strings  ${handenter}  Y

    ${cardoverride}  Query and Strip  SELECT cardoverride FROM cards WHERE card_num = '${velocity_card.num}'
    Should Be Equal As Strings  ${cardoverride}  2

    [Teardown]  Remove Override on Card  ${velocity_card.num}

Ensure Overriden Card Disabled Elements
    [Tags]  JIRA:BOT-654

    Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
    Override Card  ULSD  100  0  9999  0  0  0  0
    Validate Overriden Card Header Disabled
    Validate Overriden Card Limits Disabled
    Validate Overriden Card Prompts Disabled
    Validate Overriden Card Time Restrictions Disabled

    [Teardown]  Remove Override on Card  ${velocity_card.num}

Check Elements are re-enabled after removing Override
    [Tags]  JIRA:BOT-654

    Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
    Override Card  ULSD  100  0  9999  0  0  0  0
    Click Button  deleteCardOverride
    Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
    Validate Card Header re-enabled after deleting override
    Validate Limits re-enabled after deleting override
    Validate Prompts re-enabled after deleting override
    Validate Time Restriction re-enabled after deleting override

    ensure after transaction remaining override is still in place  ${velocity_card.num}  0

    [Teardown]  Remove Override on Card  ${velocity_card.num}

Add Limit
   [Tags]  JIRA:QAT-16  JIRA:QAT-278  JIRA:QAT-259  JIRA:OT-4  qTest:32822016  tier:0

   Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
   Go To Card Limits
   Click Create Limit
   Fill Limit Information  CLTH  123
   validate limit was added to db  ${velocity_card.num}  CLTH

Add Autoroll Limit
    [Tags]  JIRA:QAT-16  JIRA:QAT-278  JIRA:QAT-259  qTest:32822016
    Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
    Go To Card Limits
    Click Create Limit

    Fill Limit Information  TRPP  123  ${True}
    validate limit was added to db  ${velocity_card.num}  TRPP

Edit Trip Permit
    [Tags]  JIRA:QAT-277  qTest:32822125  refactor  tier:0
    [Setup]  setup card limits  TRPP=100

    Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
    Go To Card Limits
    Edit Limit  TRIP PERMIT  321

    ${limit}  Query And Strip  select limit from card_lmt where limit_id = 'TRPP' and card_num = '${velocity_card.num}'
    should be equal as strings  ${limit}  321

Remove new Limits
	[Tags]  qTest:32822167  tier:0
	[Setup]  setup card limits  CLTH=100  TRPP=100
	Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
    Go To Card Limits
    Delete Limit  TRIP PERMIT

    validate limit was deleted from db  ${velocity_card.num}  TRPP

Limit Source Policy
   Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
   Go To Card Limits
   Change Limit Source  POLICY
   Validate Limit Source In DB  ${velocity_card.num}  D

Limit Source Both
   Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
   Go To Card Limits
   Change Limit Source  BOTH
   Validate Limit Source In DB  ${velocity_card.num}  B

Limit Source Card
   Select Card On Card Lookup  ${velocity_card.num}  ${velocity_card.id}
   Go To Card Limits
   Change Limit Source  CARD
   Validate Limit Source In DB  ${velocity_card.num}  C

Changing lmtsrc shouldn't affect Smart Pay and Debit cards
    [Setup]  Remove Override on Card  ${card}
    [Tags]  JIRA:BOT-569  refactor
    [Documentation]  cards.mrcsrc should NEVER change due only to a lmtsrc change nor should any overrides be entered on the card.
    ...  Neither mrcsrc or cardoverride should be changed with changing the lmtsrc
    Get Card Info Before the Updates
    Set card.lmtsrc = 'F'
    Verify neither cards.mrcsrc or cards.cardoverride are changed
    Set card.lmtsrc = 'C'
    Verify neither cards.mrcsrc or cards.cardoverride are changed
    Set card.lmtsrc from 'F' to 'B'
    Verify neither cards.mrcsrc or cards.cardoverride are changed
    Set card.lmtsrc from 'F' to 'D'
    Verify neither cards.mrcsrc or cards.cardoverride are changed

Manage Cards - Irving Fuel Products
    [Tags]  JIRA:BOT-246  ivring  refactor
    [Documentation]  Ensure you cannot add Tax Exempt diesel to an Irving card.
    Open Emanager  ${irvinguserName}  ${irvingpassword}
    Select Card On Card Lookup  70000522024300010
    Click Element   //*[@name="card.header.infoSource" and @value="CARD"]
    Click Button  saveCardInformation
    Go To Card Limits
    Click Create Limit
    Page Should Not Contain  value=MDSL
    Close Browser

*** Keywords ***
Get Card Info Before the Updates
    [Tags]  JIRA:BOT-569

    Get Into DB  TCH
    ${query}=  catenate
    ...  SELECT mrcsrc, cardoverride FROM cards WHERE card_num='${card}'
    ${old_results}=  query and strip to dictionary   ${query}
    should be equal as strings   ${old_results['mrcsrc']}  N
    should be equal as strings   ${old_results['cardoverride']}  0
    tch logging  \n Before the Updates mrcsrc:${old_results['mrcsrc']} and cardoverride:${old_results['cardoverride']}
    set test variable  ${old_results}

Set card.lmtsrc = 'F'
    [Tags]  JIRA:BOT-569

    Get Into DB  TCH
    ${query}  Catenate  UPDATE cards SET lmtsrc='F' where card_num = '${card}'
    Execute Sql String  ${query}
    tch logging  \n cards.lmtsrc to F' SET

Verify neither cards.mrcsrc or cards.cardoverride are changed
    [Tags]  JIRA:BOT-569

    Get Into DB  TCH
    ${query}=  catenate
    ...  SELECT mrcsrc, cardoverride FROM cards WHERE card_num='${card}'
    ${new_results}=  query and strip to dictionary   ${query}
    should be equal as strings   ${new_results['mrcsrc']}  ${old_results['mrcsrc']}
    should be equal as strings   ${new_results['cardoverride']}  ${old_results['cardoverride']}
    tch logging  \n Neither cards.mrcsrc or cards.cardoverride are changed with changing the lmtsrc.

Set card.lmtsrc = 'C'
    [Tags]  JIRA:BOT-569

    Get Into DB  TCH
    ${query}  Catenate  UPDATE cards SET lmtsrc='C' where card_num = '${card}'
    Execute Sql String  ${query}
    tch logging  \n cards.lmtsrc to 'C' SET

Set card.lmtsrc from 'F' to 'B'
    [Tags]  JIRA:BOT-569

    Get Into DB  TCH
    ${queryF}  Catenate  UPDATE cards SET lmtsrc='F' where card_num = '${card}'
    ${queryB}  Catenate  UPDATE cards SET lmtsrc='B' where card_num = '${card}'
    Execute Sql String  ${queryF}
    Execute Sql String  ${queryB}

    tch logging  \n cards.lmtsrc from 'F' to 'B' SET

Set card.lmtsrc from 'F' to 'D'
    [Tags]  JIRA:BOT-569
    Get Into DB  TCH
    ${queryF}  Catenate  UPDATE cards SET lmtsrc='F' where card_num = '${card}'
    ${queryD}  Catenate  UPDATE cards SET lmtsrc='D' where card_num = '${card}'
    Execute Sql String  ${queryF}
    Execute Sql String  ${queryD}
    tch logging  \n cards.lmtsrc from 'F' to 'D' SET

Override Card
    [Tags]  JIRA:BOT:654
    [Arguments]  ${limit}  ${amt}  ${day_cnt}  ${day_amt}  ${week_cnt}  ${week_amt}  ${mon_cnt}  ${mon_amt}

    Mouse Over  //*[@class="horz_nlsitem" and text()=" Card Management"]
    Click Element  //*[@class="nlsitem" and text()=" Override Card"]
    Select From List By Value  cardOverride  2
    Click Element  //*[@name="locationOverrideRadio" and @value="ALL"]
    Click Element  handOverride
    Click Element  promptOverride
    Click Element  velocityOverride
    Click Button  overrideCard
    Page Should Contain Element  //*[@class="messages"]/descendant::li[1]  #ALL LOCATIONS
    Page Should Contain Element  //*[@class="messages"]/descendant::li[2]  #HAND ENTRY
    Select From List By Value  limitIdChoice  ${limit}
    Click Element  processCategory
    Input Text  cardLimit.limit  ${amt}
    Click Element  finishCardPromptOverrideBtnId
    Input Text  dayCntLimit  ${day_cnt}
    Input Text  dayAmtLimit  ${day_amt}
    Input Text  weekCntLimit  ${week_cnt}
    Input Text  weekAmtLimit  ${week_amt}
    Input Text  monCntLimit  ${mon_cnt}
    Input Text  monAmtLimit  ${mon_amt}
    Click Button  velocityLimitOverride

    Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'Successfully Edited')]

Time to Setup
    get into db  tch
    ${vc_query}=  catenate  SELECT TRIM(c.card_num) as card_num
    ...     FROM cards c
    ...     left join def_card dc
    ...         on dc.ipolicy = c.icardpolicy
    ...         and dc.id = c.carrier_id
    ...     left join contract ct
    ...         on ct.contract_id = dc.contract_id
    ...     left join cont_misc cm
    ...         on cm.contract_id = ct.contract_id
    ...     WHERE c.card_num LIKE '708305%'
    ...     AND c.status = 'A'
    ...     AND c.card_num NOT LIKE '%OVER'
    ...     AND c.payr_use != 'P'
    ...     AND ct.status = 'A'
    ...     AND ct.velocity_enable = 'Y'

    ${velocity_card}=  find card variable  ${vc_query}
    set suite variable  ${velocity_card}

    Start Setup Card  ${velocity_card.card_num}
    Setup Card Header  infoSource=CARD  limitSource=CARD  locationSource=CARD  status=ACTIVE
    remove override on card  ${velocity_card.num}
    clear card limits
    Add User Role If Not Exists  ${velocity_card.carrier.id}  VELOCITY_LIMITS

    open browser to emanager  alias=velocity
    log into emanager  ${velocity_card.carrier.id}  ${velocity_card.carrier.password}



Remove Override on Card
    [Arguments]  ${card}
    get into db  tch
    ${query}  Catenate  update cards set cardoverride = 0 where card_num = '${card}'
    execute sql string  ${query}

Select Card On Card Lookup
    [Arguments]  ${card_num}  ${card_id}=${None}

#    run keyword if  '${card_id}' != 'None'  run keywords  go to  ${emanager}/cards/CardPromptManagement.action?card.cardId=${card_id}&card.displayNumber=${card_num}&lookupInfoRadio=NUMBER  AND  return from keyword

    Go To  ${emanager}/cards/CardLookup.action
    Select Radio Button  lookupInfoRadio  NUMBER
    Input Text  cardSearchTxt  ${card_num}
    Click Button  searchCard
    Click Element  //table[@id="cardSummary"]//*[contains(text(), '${card_num}')]

Check OVER Cards Velocity Limits
    [Arguments]  ${card_num}
    Get Into DB  TCH
    ${query_1}  catenate
    ...  SELECT day_cnt_limit, day_amt_limit, week_cnt_limit, week_amt_limit, mon_cnt_limit, mon_amt_limit
    ...  FROM cards WHERE card_num like '${card_num}OVER'
    ${RefreshingLimits}  Query And Strip To Dictionary  ${query_1}

    ${RefreshingLimits['day_cnt_limit']}  Convert To String  ${RefreshingLimits['day_cnt_limit']}
    ${RefreshingLimits['day_amt_limit']}  Convert To String  ${RefreshingLimits['day_amt_limit']}
    ${RefreshingLimits['week_cnt_limit']}  Convert To String  ${RefreshingLimits['week_cnt_limit']}
    ${RefreshingLimits['week_amt_limit']}  Convert To String  ${RefreshingLimits['week_amt_limit']}
    ${RefreshingLimits['mon_cnt_limit']}  Convert To String  ${RefreshingLimits['mon_cnt_limit']}
    ${RefreshingLimits['mon_amt_limit']}  Convert To String  ${RefreshingLimits['mon_amt_limit']}

    Should Match  ${RefreshingLimits['day_cnt_limit']}  10
    Should Match  ${RefreshingLimits['day_amt_limit']}  5
    Should Match  ${RefreshingLimits['week_cnt_limit']}  10
    Should Match  ${RefreshingLimits['week_amt_limit']}  15
    Should Match  ${RefreshingLimits['mon_cnt_limit']}  10
    Should Match  ${RefreshingLimits['mon_amt_limit']}  30

    ${hours}  Query And Strip  SELECT hours FROM card_lmt WHERE card_num='${card_num}OVER' AND limit_id = 'PHON' and limit = '50'
    Should Be Equal As Strings  ${hours}  0

Validate OVER Card handenter
    [Arguments]  ${card_num}  ${flag}
    ${handenter}=  Query and Strip  SELECT handenter FROM cards WHERE card_num LIKE '${card_num}OVER'
    Should Be Equal As Strings  ${handenter}  ${flag}

Validate OVER Card override count
    [Arguments]  ${card_num}  ${cnt}
    ${cardoverride}  Query and Strip  SELECT cardoverride FROM cards WHERE card_num = '${card_num}'
    Should Be Equal As Strings  ${cardoverride}  ${cnt}

Validate Overriden Card Header Disabled
    Mouse Over  //*[@class="horz_nlsitem" and text()=" Limits"]
    Click Element  //*[@class="nlsitem" and text()=" Update Limits"]
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]

Validate Overriden Card Limits Disabled
    Mouse Over  //*[@class="horz_nlsitem" and text()=" Limits"]
    Click Element  //*[@class="nlsitem" and text()=" Refreshing Limits"]
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]

Validate Overriden Card Prompts Disabled
    Mouse Over  //*[@class="horz_nlsitem" and text()=" Prompts"]
    Click Element  //*[@class="nlsitem" and text()=" Update Prompts"]
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="createPromptCard" and @disabled="disabled"]

Validate Overriden Card Time Restrictions Disabled
    Mouse Over  //*[@class="horz_nlsitem" and text()=" Time Restrictions"]
    Click Element  //*[@class="nlsitem" and text()=" Update Time Restrictions"]
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]

Validate Card Header re-enabled after deleting override
     Mouse Over  //*[@class="horz_nlsitem" and text()=" Limits"]
     Click Element  //*[@class="nlsitem" and text()=" Update Limits"]
     Click Element  //*[@name="card.header.status" and @value="INACTIVE"]
     Element Should Be Enabled  //*[@name="card.header.policyNumber"]
     Element Should Be Enabled  //*[@name="card.header.companyXRef"]
     Element Should Be Enabled  //*[@name="card.header.status"]
     Element Should Be Enabled  //*[@name="card.header.handEnter"]
     Element Should Be Enabled  //*[@name="saveCardInformation"]
     Element Should Be Enabled  //*[@name="reset"]
     Element Should Be Enabled  //*[@name="deleteThisCard"]
     Element Should Be Enabled  //*[@name="resetPin"]

Validate Limits re-enabled after deleting override
     Mouse Over  //*[@class="horz_nlsitem" and text()=" Limits"]
     Click Element  //*[@class="nlsitem" and text()=" Refreshing Limits"]
     Click Element  //*[@name="card.header.status" and @value="INACTIVE"]
     Element Should Be Enabled  //*[@name="card.header.policyNumber"]
     Element Should Be Enabled  //*[@name="card.header.companyXRef"]
     Element Should Be Enabled  //*[@name="card.header.status"]
     Element Should Be Enabled  //*[@name="card.header.handEnter"]
     Element Should Be Enabled  //*[@name="saveCardInformation"]
     Element Should Be Enabled  //*[@name="reset"]
     Element Should Be Enabled  //*[@name="deleteThisCard"]
     Element Should Be Enabled  //*[@name="resetPin"]

Validate Prompts re-enabled after deleting override
     Mouse Over  //*[@class="horz_nlsitem" and text()=" Prompts"]
     Click Element  //*[@class="nlsitem" and text()=" Update Prompts"]
     Click Element  //*[@name="card.header.status" and @value="INACTIVE"]
     Element Should Be Enabled  //*[@name="card.header.policyNumber"]
     Element Should Be Enabled  //*[@name="card.header.companyXRef"]
     Element Should Be Enabled  //*[@name="card.header.status"]
     Element Should Be Enabled  //*[@name="card.header.handEnter"]
     Element Should Be Enabled  //*[@name="saveCardInformation"]
     Element Should Be Enabled  //*[@name="reset"]
     Element Should Be Enabled  //*[@name="deleteThisCard"]
     Element Should Be Enabled  //*[@name="resetPin"]
     Element Should Be Enabled  //*[@name="createPromptCard"]

Validate Time Restriction re-enabled after deleting override
     go to  ${emanager}/cards/CardTimeRestrictionManagement.action?card.cardId=${velocity_card.id}&card.displayNumber=${velocity_card.num}
     Click Element  //*[@name="card.header.status" and @value="INACTIVE"]
     Element Should Be Enabled  //*[@name="card.header.policyNumber"]
     Element Should Be Enabled  //*[@name="card.header.companyXRef"]
     Element Should Be Enabled  //*[@name="card.header.status"]
     Element Should Be Enabled  //*[@name="card.header.handEnter"]
     Element Should Be Enabled  // *[@name="saveCardInformation"]
     Element Should Be Enabled  //*[@name="reset"]
     Element Should Be Enabled  //*[@name="deleteThisCard"]
     Element Should Be Enabled  //*[@name="resetPin"]

Ensure after transaction remaining override is still in place
     [Arguments]  ${card_num}  ${num_overrides_remain}
     ${cardoverride}  Query And Strip  SELECT cardoverride FROM cards WHERE card_num = '${card_num}'
     Should Be Equal As Strings  ${cardoverride}  ${num_overrides_remain}

Go To Card Limits
   Mouse Over  //*[@class="horz_nlsitem" and text()=" Limits"]
   Click Element  //*[@class="nlsitem" and text()=" Update Limits"]

Click Create Limit
    scroll element into view  xpath=//*[@name='createLimit']
    click element  xpath=//*[@name='createLimit']

All The Autorolls
   select radio button  optional  autoRoll
   select checkbox  sunday
   select checkbox  monday
   select checkbox  tuesday
   select checkbox  wednesday
   select checkbox  thursday
   select checkbox  friday
   select checkbox  saturday

Autorolls All Box
   select radio button  optional  autoRoll
   unselect checkbox  sunday
   unselect checkbox  monday
   unselect checkbox  tuesday
   unselect checkbox  wednesday
   unselect checkbox  thursday
   unselect checkbox  friday
   unselect checkbox  saturday
   select checkbox  CheckAll

Fill Limit Information
    [Arguments]  ${product}  ${limit}  ${autoRoll}=${False}

    Select From List By Value  limitIdChoice  ${product}
    click button     xpath=//*[@name='processCategory']
    input text       xpath=//*[@name='cardLimit.limit']  ${limit}
    run keyword if  ${autoRoll}  All The Autorolls
    run keyword if  ${autoRoll}  Autorolls All Box

    click button     xpath=//*[@name='finishCardLimit']
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]

validate limit was added to db
    [Arguments]  ${card_num}  ${product}
    row count is equal to x  select limit_id from card_lmt where limit_id = '${product}' and card_num = '${card_num}'  1

Edit Limit
    [Arguments]  ${product}  ${new_amt}

    scroll element into view  xpath=//*[@value='TRIP PERMIT']/following-sibling::input[@alt='Edit Limit']
    click element   xpath=//*[@value='TRIP PERMIT']/following-sibling::input[@alt='Edit Limit']
    input text       xpath=//*[@name='cardLimit.limit']      321
    click button     xpath=//*[@name='updateCardLimit']

Delete Limit
    [Arguments]  ${product}
    click element  xpath=//*[@value='${product}']/following-sibling::input[@alt='Delete Limit']
    sleep  2
    Handle Alert
    wait until element is visible  xpath=//*[contains(text(), 'deleted')]/../b[2][contains(text(),'${product}')]

Validate Limit was deleted from db
    [Arguments]  ${card_num}  ${product}
    ${stat}  run keyword and return status  row count is 0  SELECT limit_id FROM card_lmt WHERE limit_id = '${product}' AND card_num = '${card_num}'
    run keyword unless  ${stat}  fail  ${product} was not deleted

Change Limit Source
    [Arguments]  ${source}

   Select Radio Button  card.header.limitSource  ${source}
   Click Button  saveCardInformation
   Wait Until Page Contains Element  xpath=//*[@name='card.header.limitSource' and @value='${source}' and @checked='checked']  ${wait}  The Card's Limit Source Did Not Change to ${source} within ${wait} seconds

Validate Limit Source In DB
    [Arguments]  ${card_num}  ${src}
    Get Into DB  ${DB}
    ${lmtsrc}  Query And Strip  SELECT lmtsrc from cards where card_num = '${card_num}'
    Should Be Equal As Strings  ${lmtsrc}  ${src}