*** Settings ***
Test Timeout  5 minutes

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown    Close Browser
Force Tags  eManager

*** Variables ***
${carrier}

*** Test Cases ***
Mastercard Override
    [Tags]    BOT-637  Mastercard  tier:0  refactor
    [Documentation]  Ensure MasterCard overrides are working correctly.
    Set Test Variable  ${expected_mcc}  999999
    Set Test Variable  ${expected_trans_type}  2058
    Set Test Variable  ${override_num}  1
    Set Test Variable  ${card}  5567480000100006

    Get Into DB  TCH
    ${query}  Catenate  SELECT m.member_id,
    ...                        m.passwd,
    ...                        c.card_num
    ...                 FROM cards c
    ...                     INNER JOIN member m ON (c.carrier_id = m.member_id)
    ...                 WHERE c.card_num='${card}'
    ...                 AND c.status = 'A'
    ...                 AND m.carrier_type = 'TCH'
    ...                 LIMIT 1
    ${card_data}  Query And Strip To Dictionary  ${query}
    tch logging  ${card_data}
    ${card_data['card_num']}  Strip String  ${card_data['card_num']}
    ${first_four_card_digits}  Get Substring  ${card_data['card_num']}  0  4
    ${last_four_card_digits}  Get Substring  ${card_data['card_num']}  -4

    Open EManager   ${card_data['member_id']}  ${card_data['passwd']}

#    Navigate To Manager Cards > View/Update Cards
    Mouse Over      id=menubar_1x2
    Mouse Over      id=TCHONLINE_CARDSx2
    Click Element   id=CARDS_MANAGE_CARDSx2

#    Input, Search and Select Card Number
    Input Text  cardSearchTxt  ${card_data['card_num']}
    Click Element  searchCard
    Click Element  //a[contains(@href, 'CardPromptManagement') and contains(text(), '${first_four_card_digits}') and contains(text(), '${last_four_card_digits}')]

#    Navigate do Card Management > Override Card
    Mouse Over  cardMenubar_2x2
    Click Element  cardManagement_1x2

#    Choose Card Override Parameters
    Select From List By Value  name=cardOverride  ${override_num}
    Click Element  name=overrideCard

    TCH LOGGING  card_data.member_id:${card_data['member_id']}

#    Assert Override Action
    ${cardOverride}  Query And Strip  SELECT cardoverride FROM cards WHERE card_num = '${card_data['card_num']}'
    Should Be Equal As Strings  ${override_num}  ${cardOverride}

    Row Count Is Equal To X  SELECT 1 FROM card_time WHERE card_num = '${card_data['card_num']}'  0
    Row Count Is Equal To X  SELECT 1 FROM card_date WHERE card_num = '${card_data['card_num']}'  0

    ${mcc}  Query And Strip  SELECT mcc FROM mcfleet_card_mcc WHERE card_num like '${card_data['card_num']}OVER'
    Should Be Equal As Strings  ${expected_mcc}  ${mcc}

    ${trans_type}  Query And Strip  SELECT mc_trantypes FROM cards WHERE card_num = '${card_data['card_num']}'
    Should Be Equal As Strings  ${expected_trans_type}  ${trans_type}

    [Teardown]  Click Element  name=deleteCardOverride

Override hold for fraud card via card lookup
    [Tags]    JIRA:ATLAS-2273    JIRA:ATLAS-2278    JIRA:BOT-5033    qTest:118438995    PI:15
    [Documentation]    Ensure override icon is displayed and functional for hold for fraud card in card lookup when
    ...    permission Hold For Fraud Card Override is set
    [Setup]    Run Keywords    Setup Carrier with Hold for Fraud Card
    ...    Add Hold For Fraud Card Override Permission to Carrier

    Login Carrier with Hold for Fraud Card to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Override card icon must be displayed
    Click to override card
    Check fraud message and buttons in override
    Click to cancel override
    Verify Not Overriden Card in Database
    Override card icon must be displayed
    Click to override card
    Check fraud message and buttons in override
    Click to submit override
    Check card overriden message and button
    Verify Overriden Card in Database
    Remove card override
    Verify Not Overriden Card in Database

Override icon not displayed for hold for fraud card without permission
    [Tags]    JIRA:ATLAS-2273    JIRA:ATLAS-2278    JIRA:BOT-5033    qTest:118439243    PI:15
    [Documentation]    Ensure override icon is not displayed for hold for fraud card when permission is not set
    [Setup]    Run Keywords    Setup Carrier with Hold for Fraud Card
    ...    Remove Hold For Fraud Card Override Permission from Carrier

    Login Carrier with Hold for Fraud Card to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Override card icon must not be displayed

*** Keywords ***
Setup Carrier with Hold for Fraud Card
    [Documentation]    Get a valid tch carrier with hold for fraud card available and permission enabled/disabled

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND surx.role_id='ALLOW_CARD_OVERRIDE'
    ...    AND surx.menu_visible=0
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    Get Into DB    TCH
    ${query}    Catenate    SELECT DISTINCT member_id, passwd
    ...    FROM member m
    ...    INNER JOIN cards c
    ...    ON c.carrier_id = m.member_id
    ...    WHERE mem_type = 'C'
    ...    AND m.status = 'A'
    ...    AND c.status = 'A'
    ...    AND c.cardoverride = '0'
    ...    AND member_id IN ${carrier_list}
    ...    LIMIT 1;
    ${carrier_info}    Query And Strip to Dictionary    ${query}
    ${carrier}    Create Dictionary    id=${carrier_info["member_id"]}    password=${carrier_info["passwd"]}
    Set Test Variable    ${carrier}
    Remove Hold For Fraud Card Override Permission from Carrier Company Admin Group
    Get or Set Hold for Fraud Card

Remove Hold For Fraud Card Override Permission from Carrier Company Admin Group
    [Documentation]    Remove Hold For Fraud Card Override permission from carrier Company Admin group

    Get Into DB    MYSQL
    ${query}    Catenate    DELETE FROM sec_role_group_xref
    ...    WHERE role_id = 'HOLD_FOR_FRAUD_CARD_OVERRIDE'
    ...    AND group_id = 'COMPANY_ADMIN'
    ...    AND company_id IN (SELECT company_id FROM sec_user WHERE user_id = '${carrier.id}');
    Execute SQL String    ${query}

Get or Set Hold for Fraud Card
    [Documentation]    Get or set a card with hold for fraud status

    Get Into DB    TCH
    ${query}    Catenate    SELECT TRIM(card_num)
    ...    FROM cards
    ...    WHERE status = 'U'
    ...    AND cardoverride = '0'
    ...    AND card_num NOT LIKE '%OVER'
    ...    AND carrier_id = '${carrier.id}'
    ...    LIMIT 1;
    ${hasHoldForFraudCard}    Run Keyword And Return Status    Row Count is Equal to X  ${query}  1
    ${card_num}    Run Keyword If    '${hasHoldForFraudCard}'=='True'    Query And Strip    ${query}
    ...    ELSE    Add Hold for Fraud Status to Card
    Set Test Variable    ${carrier.cardnum}    ${card_num}

Add Hold for Fraud Status to Card
    [Documentation]    Get an active card from carrier and set its status as hold for fraud

    Get Into DB    TCH
    ${card_num}    Get Active Card from Carrier
    ${query}    Catenate    UPDATE cards
    ...    SET status = 'U'
    ...    WHERE card_num = '${card_num}'
    ...    AND carrier_id = '${carrier.id}';
    Execute SQL String    ${query}

    [Return]    ${card_num}

Get Active Card from Carrier
    [Documentation]    Get an active from carrier

    ${query}    Catenate    SELECT TRIM(card_num)
    ...    FROM cards
    ...    WHERE status = 'A'
    ...    AND cardoverride = '0'
    ...    AND card_num NOT LIKE '%OVER'
    ...    AND carrier_id = '${carrier.id}'
    ...    LIMIT 1;
    ${card_num}    Query And Strip    ${query}

    [Return]    ${card_num}

Add Hold For Fraud Card Override Permission to Carrier
    [Documentation]    Add Hold For Fraud Card Override permission to test carrier

    Ensure Carrier has User Permission    ${carrier.id}    HOLD_FOR_FRAUD_CARD_OVERRIDE

Remove Hold For Fraud Card Override Permission from Carrier
    [Documentation]    Remove Hold For Fraud Card Override permission from test carrier

    Remove Carrier User Permission    ${carrier.id}    HOLD_FOR_FRAUD_CARD_OVERRIDE

Login Carrier with Hold for Fraud Card to eManager
    [Documentation]    Login to emanager with test carrier

    Open eManager    ${carrier.id}    ${carrier.password}    ChangeCompanyHeader=False

Go to Select Program > Manage Cards > View/Update Cards
    [Documentation]  Go to Select Program > Manage Cards > View/Update Cards

    Go To  ${emanager}/cards/CardLookup.action

Search card number
    [Documentation]    Search card number from test carrier

    Select Radio Button    lookupInfoRadio    NUMBER
    Input Text    name=cardSearchTxt    ${carrier.cardnum}
    Click Button    name=searchCard
    Wait Until Element is Visible    //*[@id="cardSummary"]//a[text()='${carrier.cardnum}']

Override card icon must not be displayed
    [Documentation]    Override card icon must not be displayed in card lookup

    Page Should Not Contain Element    //input[@value='${carrier.cardnum}']//following-sibling::input[@type='image' and @name='overrideCard']

Override card icon must be displayed
    [Documentation]    Override card icon must be displayed in card lookup

    Page Should Contain Element    //input[@value='${carrier.cardnum}']//following-sibling::input[@type='image' and @name='overrideCard']

Click to override card
    [Documentation]    Click in override icon from card lookup

    Click Element    //input[@value='${carrier.cardnum}']//following-sibling::input[@type='image' and @name='overrideCard']

Check fraud message and buttons in override
    [Documentation]    Fraud message must be displayed correctly with submit and cancel buttons

    Page Should Contain    Your card is currently in hold for fraud, please call 1-888-824-7378 for fraud assistance.
    ${fraud_text}    Catenate    Disclaimer: You are overriding a card that has been flagged for fraudulent activity
    ...    - you will be responsible for any fraudulent activity on the card while in override. A new card should be
    ...    issued to this driver immediately. If you need to order a new card from WEX, please contact customer service
    ...    or your account manager.
    Page Should Contain    ${fraud_text}
    Page Should Contain Element    //input[@name="overrideFraudCard"]
    Page Should Contain Element    //input[@name="cancelVelocityOverride"]

Click to cancel override
    [Documentation]    Click to cancel override in fraud message screen

    Click Element    //input[@name="cancelVelocityOverride"]
    Wait Until Element is Visible    //*[@id="cardSummary"]//a[text()='${carrier.cardnum}']

Click to submit override
    [Documentation]    Click to submit override in fraud message screen

    Click Element    //input[@name="overrideFraudCard"]
    Wait Until Element is Visible    //input[@name="deleteCardOverride" and @value='Remove Override']

Check card overriden message and button
    [Documentation]    Override message must be displayed correctly with remove override button

    Page Should Contain    Your card is currently in hold for fraud, please call 1-888-824-7378 for fraud assistance.
    Page Should Contain    The currently selected card is in override mode.
    Page Should Contain    Please remove the current override before making any changes.
    Page Should Contain Element    //input[@name="deleteCardOverride" and @value='Remove Override']

Remove card override
    [Documentation]    Click to remove override

    Click Element    //input[@name="deleteCardOverride" and @value='Remove Override']
    Wait Until Element is Visible    //*[@id="cardSummary"]//a[text()='${carrier.cardnum}']

Verify Card Override in Database
    [Documentation]    Check if card is overriden or not in cards and audit tables from database
    [Arguments]    ${isOverride}=False

    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM cards
    ...    WHERE card_num = '${carrier.cardnum}OVER';
    Run Keyword If    '${isOverride}'=='True'    Row Count is Equal to X  ${query}  1
    ${override_value}    Run Keyword If    '${isOverride}'=='False'    Set Variable    0
    ...    ELSE    Set Variable    1
    ${query}    Catenate    SELECT status, cardoverride
    ...    FROM cards
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND carrier_id = '${carrier.id}';
    ${card_info}    Query And Strip to Dictionary    ${query}
    Should Be Equal as Strings    ${card_info["status"]}    U
    Should Be Equal as Numbers    ${card_info["cardoverride"]}    ${override_value}
    ${query}    Catenate    SELECT cardoverride
    ...    FROM audit_cards
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND carrier_id = '${carrier.id}'
    ...    ORDER BY audit_id DESC;
    ${no_change_status}    Run Keyword and Return Status    Row Count is Equal to X  ${query}  0
    ${cardoverride}    Query And Strip    ${query}
    Run Keyword If    '${no_change_status}'=='False'
    ...    Should Be Equal as Numbers    ${override_value}    ${cardoverride}

Verify Overriden Card in Database
    [Documentation]    Check if card is overriden in database

    Verify Card Override in Database    True

Verify Not Overriden Card in Database
    [Documentation]    Check if card is not overriden in database

    Verify Card Override in Database