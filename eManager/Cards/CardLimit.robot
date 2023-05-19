*** Settings ***
Test Timeout  5 minutes
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Library  otr_robot_lib.support.DynamicTesting
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown  Close Browser

Force Tags  eManager  Card  Card Detail  Regression

*** Variables ***
${carrier}
${card}
${products_list}
${product_name}

*** Test Cases ***
Shell Fuel Product VPower93 - Card Limit with product limits flag on
    [Tags]    JIRA:BOT-3610    qTest:53058307
    [Documentation]    New product VPower93 added for shell in card limits

    Setup Carrier with Manage Cards Permission and Product Limits 'Enabled'
    Log Carrier into eManager with Manage Cards permission
    Go to Select Program > Manage Cards > View/Update Cards
    Select Card Without 'GAS' Limit
    Select Limits > Update Limits on menu
    Click to add a new limit
    Select the 'GAS - GASOLINE' option and proceed
    Add VPower93 as a product limit
    Assert VPower93 limit creation
    Delete VPower93 Card Limit

Shell Fuel Product VPower93 - Card Override Limit with product limits flag on
    [Tags]    JIRA:BOT-3610    qTest:53058268
    [Documentation]    New product VPower93 added for shell in overriden card limits

    Setup Carrier with Manage Cards Permission and Product Limits 'Enabled'
    Log Carrier into eManager with Manage Cards permission
    Go to Select Program > Manage Cards > View/Update Cards
    Select Card Without 'GAS' Limit
    Select Card Management > Override Card on menu
    Select the 'Product/Limit Override' checkbox and proceed
    Select the 'GAS - GASOLINE' option and proceed
    Add VPower93 as a product limit    true
    Assert VPower93 limit creation    true
    Remove Override

Shell Fuel Product VPower93 - Card Limit with product limits flag off
    [Tags]    JIRA:BOT-3610    qTest:53058326
    [Documentation]    New product VPower93 added for shell in card limits does not show

    Setup Carrier with Manage Cards Permission and Product Limits 'Disabled'
    Log Carrier into eManager with Manage Cards permission
    Go to Select Program > Manage Cards > View/Update Cards
    Select Card Without 'GAS' Limit
    Select Limits > Update Limits on menu
    Click to add a new limit
    Select the 'GAS - GASOLINE' option and proceed
    Check VPower93 not showing

Shell Fuel Product VPower93 - Card Override Limit with product limits flag off
    [Tags]    JIRA:BOT-3610    qTest:53058320
    [Documentation]    New product VPower93 added for shell in overriden card limits does not show

    Setup Carrier with Manage Cards Permission and Product Limits 'Disabled'
    Log Carrier into eManager with Manage Cards permission
    Go to Select Program > Manage Cards > View/Update Cards
    Select Card Without 'GAS' Limit
    Select Card Management > Override Card on menu
    Select the 'Product/Limit Override' checkbox and proceed
    Select the 'GAS - GASOLINE' option and proceed
    Check VPower93 not showing

Card Limits - Auto Rollover
    [Documentation]
    [Tags]  JIRA:QAT-16  JIRA:QAT-278  JIRA:QAT-259  qTest:32821749

    Create Dynamic Test Cases
    Navigate to Select Program > Manage Cards > View/Edit Cards > Limits > Update Limits;
    Add Card Limit For  ULSD  Auto Rollover
    Check On DB if Card Limit is Added  ULSD
    Delete Card Limit For  ULSD
    [Teardown]    NONE

*** Keywords ***
Create Dynamic Test Cases

    Setup for FRNT-1093 Card
    Get List of Products
    Log Into eManager With Your Carrier;
#    Navigate to Select Program > Manage Cards > View/Edit Cards;
#    Select a Card on Card Lookup;
#    Navigate to Select Program > Manage Cards > View/Edit Cards > Limits > Update Limits;

    FOR  ${product}  IN  @{products_list}
      Continue For Loop If  '${product}'=='TCHN'  #Skipped due OTREPIC-2081
      Add Test Case  Card Limits - Add/Edit/Delete for ${product}
       ...  Add/Edit/Delete Product:  ${product}
    END
    Add Test Case  Closing Last Test Browser
    ...  Close Browser

Setup for FRNT-1093 Card
    [Documentation]  Keyword Setup for FRNT-1093

    Get Into DB  Mysql

#Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT DISTINCT(mm.member_id) FROM member_meta mm
    ...     JOIN cards c ON c.carrier_id = mm.member_id
    ...     JOIN contract co ON co.carrier_id = mm.member_id
    ...  WHERE mm.mm_key = 'PRODLMTS'
    ...  AND mm_value = 'Y'
    ...  AND co.issuer_id NOT IN (SELECT issuer_id FROM issuer_products)
    ...  AND member_id IN ${list_2}
    ...  AND member_id NOT IN ('303327','146567');    #need to check another table than card_lmt that stores card limits this is causing problems to us.

    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable  ${carrier}

#Get a Card to Use on Test
    ${query}  Catenate  SELECT TRIM(card_num) AS card_num FROM cards
    ...  WHERE carrier_id=${carrier.id}
    ...  AND card_num NOT LIKE '%OVER';

    ${card}  Find Card Variable  ${query}
    Set Suite Variable  ${card}
#    log to console  ${card.num}

    Start Setup Card  ${card.num}
    Setup Card Header  infoSource=CARD  limitSource=CARD  status=ACTIVE  payrollUse=B
    Clear Card Limits

Get List of Products
    [Arguments]  ${instance}=TCH
    [Documentation]

    Get Into DB  ${instance}

    ${query}  Catenate  SELECT DISTINCT(restriction_group) FROM products WHERE fps_partner = '${instance}' AND restriction_group IS NOT NULL;
    ${products_list}  Query And Strip to Dictionary  ${query}

    #log to console  ${products_list.restriction_group}

    Set Suite Variable  ${products_list}  ${products_list['restriction_group']}

Add/Edit/Delete Product:
    [Arguments]  ${product}

    Set Tags  JIRA:QAT-16  JIRA:QAT-278  JIRA:QAT-259  qTest:32822016  qTest:47551357 qTest:32822125  qTest:32822167  qTest:32821749  JIRA:FRNT-1106  PI:6

    Navigate to Select Program > Manage Cards > View/Edit Cards > Limits > Update Limits;
    Add Card Limit For  ${product}
    Edit Card Limit For  ${product}
    Delete Card Limit For  ${product}

Add Card Limit For
    [Arguments]  ${product}  ${autoroll}=N  ${value}=100
    [Documentation]

    Click on Add Prompt Button;
    Click Element  //option[@value='${product}']

    ${product_name}  Get Text  //option[@value='${product}']  #Get Product Name
#    @{product_name}  Get Substring  ${product_name}  7  #Get Product Name Substring/Not working anymore
    @{string}  Split String  ${product_name}  max_split=2  #Get Product Name by Split
    ${product_name}  Set Variable  ${string[2]}

    Click Element  //input[@value='Next']
    Input Text  //input[@name='cardLimit.limit']  ${value}  #limit value defined as 100
    Run Keyword If  '${autoroll}'!='N'  Setup Auto Rollover
    Click Element  //input[@name='finishCardLimit']
    Check On DB if Card Limit is Added  ${product}
    Navigate to Select Program > Manage Cards > View/Edit Cards > Limits > Update Limits;

    Set Suite Variable  ${product_name}

Setup Auto Rollover
    [Documentation]  Keyword to setup auto rollover with all days, this one can be improved.
    Click Element  //input[@value='autoRoll']
    Select Checkbox  //input[@name='sunday']
    Select Checkbox  //input[@name='monday']
    Select Checkbox  //input[@name='tuesday']
    Select Checkbox  //input[@name='wednesday']
    Select Checkbox  //input[@name='thursday']
    Select Checkbox  //input[@name='friday']
    Select Checkbox  //input[@name='saturday']

Edit Card Limit For
    [Arguments]  ${product}  ${value}=200

    Click Element  //*[@value='${product_name}']/following-sibling::input[@alt='Edit Limit']
    Input Text  //input[@name='cardLimit.limit']  ${value}
    Click Element  //input[@name='updateCardLimit']
    Check On DB if Card Limit is Added  ${product}  ${value}
    Navigate to Select Program > Manage Cards > View/Edit Cards > Limits > Update Limits;

Delete Card Limit For
    [Arguments]  ${product}  ${value}=200

    Click Element  //*[@value='${product_name}']/following-sibling::input[@alt='Delete Limit']
    Handle Alert
    Navigate to Select Program > Manage Cards > View/Edit Cards > Limits > Update Limits;
    Sleep  1  #Time to changes be applied on DB
    Check On DB if Card Limit is Deleted  ${product}  ${value}

Log Into eManager With Your Carrier;
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Manage Cards > View/Edit Cards;
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/CardLookup.action

Select a Card on Card Lookup;
    [Documentation]  Search for a card using card number as parameter.

    Select Radio Button  lookupInfoRadio  NUMBER
    Input Text  cardSearchTxt  ${card.num}
    Click Button  searchCard
    Click Element  //table[@id='cardSummary']//td//a[1]

Navigate to Select Program > Manage Cards > View/Edit Cards > Limits > Update Limits;
    Go To  ${emanager}/cards/CardLimitManagement.action?card.cardId=${card.id}&card.displayNumber=${card.num}

Set Limit Source To Card on Card Limit Detail;
    Click Element  //input[@value='CARD' and @type='radio']
    Click Element  //input[@id='saveCardInformationBtn']

Click on Add Prompt Button;
    Click Element  //input[@name='createLimit']

Check On DB if Card Limit is Added
    [Arguments]  ${limit_id}=DSL  ${limit_value}=100
    Sleep    2    #wait to ensure data will be write on DB
    Get Into DB  TCH
    Row Count is Equal to X  SELECT * FROM card_lmt WHERE card_num='${card.num}' AND limit_id='${limit_id}' AND limit='${limit_value}';  1

Check On DB if Card Limit is Deleted
    [Arguments]  ${limit_id}=DSL  ${limit_value}=100
    Get Into DB  TCH
    Row Count is 0  SELECT * FROM card_lmt WHERE card_num='${card.num}' AND limit_id='${limit_id}' AND limit='${limit_value}';

Setup Carrier with Manage Cards Permission and Product Limits '${flag}'
    [Documentation]  Keyword Setup for Carrier with Manage Cards Permission and Product Limits enabled/disabled

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id BETWEEN 500000 and 649999
    ...    AND surx.role_id='MANAGE_CARDS'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND member_id IN ${carrier_list}
    ...  AND member_id NOT IN ('600003')
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id    SHELL
    Set Test Variable  ${carrier}
    #Set product limits flag
    Get Into DB  SHELL
    ${select_query}  Catenate  SELECT mm_value FROM member_meta WHERE mm_key = 'PRODLMTS' AND member_id = '${carrier.id}';
    ${select_query_result}  Query And Strip To Dictionary  ${select_query}
    ${amount}    Get Length    ${select_query_result}
    ${option}    Run Keyword If    '${flag}'=='Enabled'    Set Variable    Y    ELSE    Set Variable    N
    ${insert_query}  Catenate  INSERT INTO member_meta (member_id, mm_key, mm_value) VALUES ('${carrier.id}', 'PRODLMTS', '${option}');
    ${update_query}  Catenate  UPDATE member_meta SET mm_value = '${option}' WHERE mm_key = 'PRODLMTS' AND member_id = '${carrier.id}';
    Run Keyword If    ${amount}==0    Execute SQL String  ${insert_query}    ELSE    Execute SQL String  ${update_query}

Log Carrier into eManager with Manage Cards permission
    [Documentation]  Log carrier into eManager with Manage Cards permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Manage Cards > View/Update Cards
    [Documentation]  Go to Select Program > Manage Cards > View/Update Cards

    Go To  ${emanager}/cards/CardLookup.action
    Wait Until Page Contains    Card Lookup

Select Card Without '${product}' Limit
    [Documentation]  Select a card without given product limit

    Get Into DB  SHELL
    ${cardnum_list_query}  Catenate  SELECT card_num
    ...  FROM cards
    ...  WHERE carrier_id = '${carrier.id}'
    ...  AND status = 'A'
    ...  AND card_num NOT IN (SELECT card_num FROM card_lmt WHERE card_num IN (SELECT card_num FROM cards WHERE carrier_id = '${carrier.id}') AND limit_id = '${product}')
    ...  AND card_num NOT LIKE '%OVER'
    ...  LIMIT 100;
    ${card_num}  Query And Strip  ${cardnum_list_query}
    Set Test Variable    ${card_num}
    Select Radio Button  lookupInfoRadio  NUMBER
    Input Text    name=cardSearchTxt    ${card_num}
    Click Button    name=searchCard
    Click Element    //*[@id="cardSummary"]/tbody/tr/td[1]

Select Limits > Update Limits on menu
    [Documentation]  Go to update limits on menu

    Wait Until Page Contains    Card Prompt Detail
    Mouse Over    id=cardMenubar_2x2
    ${has_overriden}    Get Text    id=cardManagement_1x2
    Run Keyword If    '${has_overriden}'=='Delete Card Override'    Delete Card Override
    Mouse Over    id=cardMenubar_3x2
    Wait Until Element Is Visible    id=cardLimits_1x2
    Click Element    id=cardLimits_1x2
    ${has_gas_limit}    Run Keyword And Return Status    Element Should Be Visible   //input[@name='description' and @value='GASOLINE']/following-sibling::input[@name='deleteCardLimit']
    Run Keyword If    ${has_gas_limit}    Delete VPower93 Card Limit

Delete Card Override
    [Documentation]  Delete card override setup

    Mouse Over    id=cardMenubar_2x2
    Wait Until Element Is Visible    id=cardManagement_1x2
    Click Element    id=cardManagement_1x2
    Click Element    //*[@id="cardSummary"]/tbody/tr/td[1]
    Wait Until Page Contains    Card Prompt Detail

Select Card Management > Override Card on menu
    [Documentation]  Go to override card on menu

    Wait Until Page Contains    Card Prompt Detail
    Mouse Over    id=cardMenubar_2x2
    Wait Until Element Is Visible    id=cardManagement_1x2
    Click Element    id=cardManagement_1x2

Click to add a new limit
    [Documentation]  Selecting 'BOTH' card and policy and clicking to add a new limit

    Wait Until Page Contains    Card Limit Detail
    Click Element    //*[@name="card.header.limitSource" and @value='BOTH']
    Click Button    name=saveCardInformation
    Click Button    name=createLimit

Select the '${product}' option and proceed
    [Documentation]  Selecting a product to set a limit

    Wait Until Element is Visible    name=limitIdChoice
    Select From List By Label    limitIdChoice    ${product}
    Click Button    name=processCategory

Select the 'Product/Limit Override' checkbox and proceed
    [Documentation]  Select the option to select a product and click the next button

    Wait Until Element is Visible    name=promptOverride
    Select Checkbox    name=promptOverride
    Click Button    name=overrideCard

Add VPower93 as a product limit
    [Arguments]  ${is_override}=false
    [Documentation]  Add only VPower93 as a product limit

    Wait Until Element is Visible    name=cardLimit.limit
    Input Text    name=cardLimit.limit    10
    Page Should Contain    VPower93
    @{product_values}    Create List    2  13  20  50  52  53
    FOR    ${value}    IN    @{product_values}
        Unselect Checkbox    //input[@name='prodLimitSel' and @value='${value}']
    END
    Checkbox Should Be Selected    //input[@name='prodLimitSel' and @value='5']
    Run Keyword If  '${is_override}'=='false'  Click Button    name=finishCardLimit  ELSE  Click Button    id=finishCardPromptOverrideBtnId

Assert VPower93 limit creation
    [Arguments]  ${is_override}=false
    [Documentation]  Assert the limit was created for VPower93

    Wait Until Element is Visible    class=messages
    ${msg}    Get Text    class=messages
    Run Keyword If  '${is_override}'=='false'  Should Be Equal As Strings    ${msg}    You have successfully Added the Description (GASOLINE), Amount (10 LTR), Hours (1), and AutoRoll (None).
    ...    ELSE  Should Start With    ${msg}    You have successfully added GASOLINE to the override limit, with the amount of 10 LTR.
    ${cardnum_query}    Run Keyword If  '${is_override}'=='false'    Set Variable    ${card_num}    ELSE    Set Variable    ${card_num}OVER
    Row Count is Equal to X    SELECT * FROM card_lmt WHERE card_num = '${cardnum_query}' AND limit_id='GAS' AND limit='10';    1

Delete VPower93 Card Limit
    [Documentation]  Delete card limit created with VPower93

    Click Element    //input[@name='description' and @value='GASOLINE']/following-sibling::input[@name='deleteCardLimit']
    Handle Alert
    Wait Until Element is Visible    class=messages
    ${msg}    Get Text    class=messages
    Should Start With    ${msg}    You have successfully deleted the Description (GASOLINE)
    Row Count is 0    SELECT * FROM card_lmt WHERE card_num='${card_num}' AND limit_id='GAS';

Remove Override
    [Documentation]  Remove card override

    Click Button    name=deleteCardOverride
    Wait Until Element is Visible    name=cardSearchTxt

Check VPower93 not showing
    [Documentation]  Check VPower93 not showing with the flag off

    Wait Until Element is Visible    name=cardLimit.limit
    Page Should Not Contain    VPower93
    Page Should Not Contain Element    name=prodLimitSel
    Click Button    name=cancel