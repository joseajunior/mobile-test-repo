*** Settings ***
Test Timeout  5 minutes

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_robot_lib.auth.PyAuth.AuthLog
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.ws.CardManagementWS  WITH NAME  ws
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Suite Up
Test Teardown  Time to Teardown

Force Tags  eManager  test

*** Variables ***

${UNAUTHORIZED_LOCATION_MESSAGE}  INVALID TRUCK STOP FOR CUSTOMER
${INVALID_TRUCKSTOP_FOR_CUSTOMER}   INVALID TRUCK STOP FOR CUSTOMER
${location_id}

*** Test Cases ***
Limits Override (TCH)
    [Tags]    JIRA:BOT-481  JIRA:BOT-576  JIRA:BOT-654  JIRA:BOT-1750  qTest:32827475
    [Documentation]  Test Overrides for Limits, Velocity(Refreshing) Limit, Card Overrides
    ...     Check Allow Hand Enter (BOT-576)
    ...     Check Refreshing Limit Override (BOT-481)
    Override a card and setup overridden card  ${validCard.num}  ULSD=100
    Open eManager  ${validCard.carrier.id}  ${validCard.carrier.password}
    Ensure All Screen Options Are Disabled on Card Management Screen
    ${trans_id}  Run a Transaction Through Location  ${validCard.valid_location.id}  ${validCard.num}  ULSD  10.00
    Check DB After Running The Transaction  ${validCard.num}
    Validate Removed Override in DB  ${validCard.num}
    Ensure All Screen Options Are Enabled on Card Management Screen
    Run a Transaction Expecting an Error Message  ${validCard.invalid_location.id}  ${validCard.num}  ULSD  10.00  ${UNAUTHORIZED_LOCATION_MESSAGE}
    [Teardown]  Close Browser

Card Override Locations Works
    [Tags]  JIRA:BOT-771  qTest:32825519
    [Documentation]  Verify that Card Override Locations works.
    ...  Allows the card to be used even if the card is not Authorized for a given Location.
    set test variable  ${location_id}  ${validCard.valid_location.id}
    Unauthorize Location to Card  ${validCard}  ${location_id}
    Run a Transaction Expecting an Error Message  ${location_id}  ${validCard.num}  ULSD  250.00  ${INVALID_TRUCKSTOP_FOR_CUSTOMER}
    Manage Cards in Emanager
    Search and Edit the Card  ${validCard.num}
    ${message}  Override Selected Card For All Locations  ${validCard.num}
    Confirm Card Override Action  ${validCard.num}  ${message}
    ${trans_id}  Run a Transaction Through Location  ${location_id}  ${validCard.num}  ULSD  100.00
    Remove Override From Card
    Confirm If Card Transaction Go Through For Location  ${trans_id}
    Close Browser
    [Teardown]  Re-Authorize Location to Card  ${validCard.valid_location.id}

*** Keywords ***
Unauthorize Location to Card
    [Arguments]  ${card_num}  ${location_id}
    log to console  Unauthorize Location for Card
    Get Into DB  TCH
    execute sql string  dml=insert INTO card_loc(card_num, location_id) VALUES(${card_num}, ${location_id});

Re-Authorize Location to Card
    [Arguments]  ${card_num}
    log to console  Re-Authorize Location to Card
    execute sql string  dml=delete from card_loc where card_num = '${card_num}';

Run a Transaction Expecting an Error Message
    [Arguments]  ${location_id}  ${card_num}  ${prod}  ${amount}  ${message}
    log to console  \n Run a Transaction Expecting a Error Message \n
    connect ssh  ${sshConnection}  ${sshName}  ${sshPass}
    ${string}  Create AC String  TCH  ${location_id}  ${card_num}  ${prod}=${amount}
    run rossAuth   ${string}  /home/qaauto/el_robot/file.log
    set log file  /home/qaauto/el_robot/file.log
    auth log should contain error  ${message}


Manage Cards in Emanager
    log to console  Manage Cards in Emanager
    Open eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Navigate To Manager Cards > View/Update Cards

Search and Edit the Card
    [Arguments]  ${card_num}
    log to console  Search and Edit the Card
    Search And Select Card  ${card_num}

Override Selected Card For All Locations
    [Arguments]  ${card_num}
    log to console  Override Selected Card
    Mouse Over  id=cardMenubar_2x2
    Click Element  id=cardManagement_1x2
    Click Element  name=locationOverrideRadio
    Click Element  name=overrideCard

Confirm Card Override Action
    [Arguments]  ${card_num}  ${message}
    log to console  Confirm Card Override Action
    element should be visible  xpath=//ul[@class="messages"]/li
    ${message}  Get Text  xpath=//ul[@class="messages"]/li
    Should Be Equal As Strings  ${message}  Card ${card_num} has been overridden for 1 time(s) for all locations.
    Confirm In Database If Card Is Overrided  ${card_num}

Run a Transaction Through Location
    log to console  Run a Transaction through Putty or PowerTerm
    [Arguments]  ${location_id}  ${card_num}  ${prod}  ${amount}
    start ac string
    set string location  ${location_id}
    set string card  ${card_num}
    add fuel by abbreviation to string  ${prod}  1.00  ${amount}
    ${ack}  finalize string

    ${myLog}  create log file  loc_override
    run rossauth  ${ack}  ${myLog}
    set log file  ${log}
    ${transIds}  log should have a trans id
    [Return]  ${transIds[0]}

Remove Override From Card
    log to console  Remove Override From Card
    Click Element  name=deleteCardOverride

Confirm If Card Transaction Go Through For Location
    [Arguments]  ${trans_id}
    log to console  Confirm If Card Transaction Go Through For Location
    Should Not Be Empty  ${trans_id}

Navigate To Manager Cards > View/Update Cards
    Mouse Over      id=menubar_1x2
    Mouse Over      id=TCHONLINE_CARDSx2
    Click Element   id=CARDS_MANAGE_CARDSx2

Search And Select Card
    [Arguments]  ${card_num}
    Click Element   xpath=//input[@value="NUMBER"]
    Input Text      xpath=//input[@name="cardSearchTxt"]  ${card_num}
    Click Element   name=searchCard
    Click Element   //a[contains(@href,'/cards/CardPromptManagement.action') and contains(@href,'${card_num.strip()}')]

Confirm In Database If Card Is Overrided
    [Arguments]  ${card_num}
    ${query}  catenate  SELECT cardoverride FROM cards WHERE card_num = '${card_num}'
    ${override}  query and strip  ${query}
    should not be empty  ${override}

#-----------------------BOT-654 PORTION--------------------------

On eManager Go to Manage Cards then View/Update Cards
    [Arguments]  ${modelCard}
    go to  ${emanager}/cards/CardPromptManagement.action?card.cardId=${modelCard.id}

Go to Card Prompt Detail and Override Card
    Tch Logging   \n OVERRIDING ${CARD}.

#Ensure Card Is Not Overriden
    ${passed}  Run Keyword And Return Status  Element Should Be Visible  deleteCardOverride
    Run Keyword if  ${passed}  Run Keywords  Remove Override From Card
    ...  AND  On eManager Go to Manage Cards then View/Update Cards  ${validCard}

    Go to Card Management then Override Card
    Select From List By Value  cardOverride  2
    Click Element  //*[@name="locationOverrideRadio" and @value="ALL"]
    Click Element  handOverride
    Click Element  promptOverride
    Click Element  velocityOverride
    Click Button  overrideCard
    Page Should Contain Element  //*[@class="messages"]/descendant::li[1]  #ALL LOCATIONS
    Page Should Contain Element  //*[@class="messages"]/descendant::li[2]  #HAND ENTRY
    Select From List By Value  limitIdChoice  ULSD
    Click Element  processCategory
    Input Text  cardLimit.limit  100
#    Click Button  saveAndAddCardPrompt
#    Select From List By Value  limitIdChoice  CLTH
#    Click Element  processCategory
#    Input Text  cardLimit.limit  10
    Click Element  finishCardPromptOverrideBtnId
    Input Text  dayCntLimit  0
    Input Text  dayAmtLimit  9999
    Input Text  weekCntLimit  0
    Input Text  weekAmtLimit  0
    Input Text  monCntLimit  0
    Input Text  monAmtLimit  0
    Click Button  velocityLimitOverride

Ensure All Screen Options Are Disabled on Card Management Screen
    On eManager Go to Manage Cards then View/Update Cards  ${validCard}
    Go to Limits then Update Limits
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]

    Go to Limits then Refreshing Limits
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]

    Go to Prompts then Update Prompts
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="createPromptCard" and @disabled="disabled"]

    Go to Time Restrictions then Update Time Restrictions
    Element Should Be Disabled  //*[@name="card.header.policyNumber" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.companyXRef" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.status" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="card.header.handEnter" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="saveCardInformation" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="reset" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="deleteThisCard" and @disabled="disabled"]
    Element Should Be Disabled  //*[@name="resetPin" and @disabled="disabled"]
    Tch Logging  \n ALL SCREEN OPTIONS ARE DISABLED.

Go to ${menu} then ${menu_item}
    Mouse Over  //*[@class="horz_nlsitem" and text()=" ${menu}"]
    Click Element  //*[@class="nlsitem" and text()=" ${menu_item}"]

Check DB After Running The Transaction
    [Arguments]  ${card}
    Get Into DB  tch
    ${query}=  Catenate
    ...  SELECT cardoverride FROM cards WHERE card_num = '${card}'
    ${results}=  Query and Strip  ${query}
    Should Be Equal As Strings  ${results}  0
    Tch Logging  \n AFTER RUNNING THE TRANSACTION, OVERRIDE NUMBER IS ${results}.

Validate Removed Override in DB
    [Arguments]  ${card}
    Get Into DB  tch
    ${query}=  Catenate
    ...  SELECT cardoverride FROM cards WHERE card_num = '${card}'
    ${results}=  Query and Strip  ${query}
    Should Be Equal As Strings  ${results}  0

Ensure All Screen Options Are Enabled on Card Management Screen

    On eManager Go to Manage Cards then View/Update Cards  ${validCard}
    Go to Limits then Update Limits
    Click Element  //*[@name="card.header.status" and @value="INACTIVE"]
    Element Should Be Enabled  //*[@name="card.header.policyNumber"]
    Element Should Be Enabled  //*[@name="card.header.companyXRef"]
    Element Should Be Enabled  //*[@name="card.header.status"]
    Element Should Be Enabled  //*[@name="card.header.handEnter"]
    Element Should Be Enabled  //*[@name="saveCardInformation"]
    Element Should Be Enabled  //*[@name="reset"]
    Element Should Be Enabled  //*[@name="deleteThisCard"]
    Element Should Be Enabled  //*[@name="resetPin"]

    Go to Limits then Refreshing Limits
    Click Element  //*[@name="card.header.status" and @value="INACTIVE"]
    Element Should Be Enabled  //*[@name="card.header.policyNumber"]
    Element Should Be Enabled  //*[@name="card.header.companyXRef"]
    Element Should Be Enabled  //*[@name="card.header.status"]
    Element Should Be Enabled  //*[@name="card.header.handEnter"]
    Element Should Be Enabled  //*[@name="saveCardInformation"]
    Element Should Be Enabled  //*[@name="reset"]
    Element Should Be Enabled  //*[@name="deleteThisCard"]
    Element Should Be Enabled  //*[@name="resetPin"]

    Go to Prompts then Update Prompts
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

    Go to Time Restrictions then Update Time Restrictions
    Click Element  //*[@name="card.header.status" and @value="INACTIVE"]
    Element Should Be Enabled  //*[@name="card.header.policyNumber"]
    Element Should Be Enabled  //*[@name="card.header.companyXRef"]
    Element Should Be Enabled  //*[@name="card.header.status"]
    Element Should Be Enabled  //*[@name="card.header.handEnter"]
    Element Should Be Enabled  // *[@name="saveCardInformation"]
    Element Should Be Enabled  //*[@name="reset"]
    Element Should Be Enabled  //*[@name="deleteThisCard"]
    Element Should Be Enabled  //*[@name="resetPin"]
    Tch Logging  ALL OPTIONS ARE ENABLED.

Time to Teardown


Override a card and setup overridden card
    [Arguments]  ${card}  ${limit}
    start setup card  ${card}
    setup card header  override=1

    start setup card  ${card}OVER
    setup card header  handEnter=CARD  infoSource=CARD  overrideAllLocations=1
    setup card limits  ULSD=100

Suite Up
    start setup card  ${validCard.num}
    setup card header  status=ACTIVE
    setup card contract  velocity_enabled=Y