*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  otr_robot_lib.ws.CardManagementWS
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

*** Variables ***
${carrier}
${element}
${group_name}
${group_status}
${location_status}
${permission_status}
${card}

*** Test Cases ***
Manage System Logs - Invalid Validation
    [Tags]  JIRA:FRNT-712  qTest:44740860  JIRA:BOT-2484
    [Setup]  Setup for FRNT-712

	Log into eManager with your card's carrier number;
	Navigate to Select Program > View/Update Cards;
	Insert card number and perform a search;
	Log out from eManager;
	Log into eManager with an Internal User;
	Navigate to Select Program > Manage System Logs;
	Search for “Invalid Validation” error in Manage System Logs for card's carrier;
	Click on green arrow to see detailed log.
    The log description should be the detailed version.

    [Teardown]  Teardown for FRNT-712

*** Keywords ***
Setup for FRNT-712
    [Documentation]  Keyword Setup for FRNT-712

    ${query}  Catenate   SELECT card_num FROM cards WHERE card_num IN (SELECT card_num FROM card_inf WHERE info_validation IS null) AND LEN(card_num) > 15
    ${card}  Find Card Variable  ${query}  card_num

    Ensure Carrier has User Permission  ${card.carrier.id}  MANAGE_CARDS
    Set Test Variable  ${card}

Teardown for FRNT-712
    [Documentation]  Keyword Teardown for FRNT-712

    Close Browser

Log into eManager with your card's carrier number;
    [Documentation]  Login on Emanager

    Open eManager  ${card.carrier.id}  ${card.carrier.password}

Navigate to Select Program > View/Update Cards;
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/CardLookup.action

Insert card number and perform a search;

    Search by Card  ${card.num}
    Click Element  //table[@id='cardSummary']//td//a[1]

Search by Card
    [Arguments]  ${card}
    Search Card  ${card}

Search Card
    [Arguments]  ${value}  ${searchType}=NUMBER
    Click Element  //input[@value='${searchType}']

    Run Keyword If  '${value}' != 'allCards'
    ...  Input Text  cardSearchTxt   ${value}

    Click Button  searchCard

Log out from eManager;
    Log out of eManager

Log into eManager with an Internal User;
    Log into eManager  ${intern}  ${internPassword}

Navigate to Select Program > Manage System Logs;
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/security/Log.action

Search for “Invalid Validation” error in Manage System Logs for card's carrier;
    Input Text  //input[@name='filterDescription']  Invalid Validation
    Click Element  //input[@name='searchLogs']

Click on Green Arrow to See Detailed Log.
    [Documentation]  Go to Log Page
    ${id}  Get Text  //table[@id='errorLog']//td//span[contains(text(),'ERROR')]/parent::td/preceding-sibling::td[1]
    Go To  ${emanager}/security/Log.action?viewLog=&errorLog.id=${id}&print=true

The log description should be the detailed version.
    Element Should be Visible  //pre[contains(text(),'Invalid validation for cardId:')]
