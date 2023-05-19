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
${permission_status}
${rebate_id}

*** Test Cases ***
Direct Carrier Pricing - Mobile Only Checkbox Verification
    [Tags]  JIRA:FRNT-716  qTest:44253008  JIRA:BOT-2489
    [Documentation]  This test will check if Direct Carrier Pricing has Mobile Only Checkbox feature.
    [Setup]  Setup for FRNT-716

    Log into eManager with a Carrier that has Direct Carrier Price.
    Navigate to Select Program > Direct Carrier Pricing.
    Check if Show Mobile Only Checkbox is on Screen.

    [Teardown]  Run Keywords  Teardown for FRNT-716
    ...  AND  Close Browser

Direct Carrier Pricing - Mobile Only Flag On
    [Tags]  JIRA:FRNT-716  qTest:44253407  JIRA:BOT-2489
    [Documentation]  This test will check if Direct Carrier Pricing can add Mobile Only flag feature On.
    [Setup]  Setup for FRNT-716

    Log into eManager with a Carrier that has Direct Carrier Price.
    Navigate to Select Program > Direct Carrier Pricing.
    Add a Direct Carrier Pricing with Show Mobile Only  Checked
    Check if new Direct Price has the Correct Show Mobile Only Flag on Database and Screen.

    [Teardown]  Run Keywords  Teardown for FRNT-716
    ...  AND  Expire Carrier Direct Price  ${rebate_id}
    ...  AND  Close Browser

Direct Carrier Pricing - Mobile Only Flag Off
    [Tags]  JIRA:FRNT-716  qTest:44254077  JIRA:BOT-2489
    [Documentation]  This test will check if Direct Carrier Pricing can add Mobile Only flag feature Off.
    [Setup]  Setup for FRNT-716

    Log into eManager with a Carrier that has Direct Carrier Price.
    Navigate to Select Program > Direct Carrier Pricing.
    Add a Direct Carrier Pricing with Show Mobile Only  Unchecked
    Check if new Direct Price has the Correct Show Mobile Only Flag on Database and Screen.

    [Teardown]  Run Keywords  Teardown for FRNT-716
    ...  AND  Expire Carrier Direct Price  ${rebate_id}
    ...  AND  Close Browser

*** Keywords ***
Setup for FRNT-716
    [Documentation]  Keyword Setup for FRNT-716

    Ensure Carrier has User Permission  ${validCard.carrier.id}  DIRECT_CARRIER_PRICE

Teardown for FRNT-716
    [Documentation]  Keyword Teardown for FRNT-716

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${validCard.carrier.id}  DIRECT_CARRIER_PRICE

Log into eManager with a Carrier that has Direct Carrier Price.
    [Documentation]  Login on Emanager

    Open eManager  ${validCard.carrier.id}  ${validCard.carrier.password}

Navigate to Select Program > Direct Carrier Pricing.
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/DirectCarrierPricing.action?outputModel=DCP

Check if Show Mobile Only Checkbox is on Screen.
    [Documentation]  Check if Element is on screen.

    Element Should Be Visible  //input[@id='showMobileOnly']

Set Tomorrow Variable for Checked

    ${tomorrow}  getDateTimeNow  %Y-%m-%d %H:%M  days=1
    Set Test Variable   ${tomorrow}

Set Tomorrow Variable for Unchecked

    ${tomorrow}  getDateTimeNow  %Y-%m-%d %H:%M  days=1  mins=1
    Set Test Variable   ${tomorrow}

Add a Direct Carrier Pricing with Show Mobile Only
    [Arguments]  ${flag}

    #If effective date and expiration date was the same as an existent Direct Carrier Pricing the pricing will say
    #that was added but no new value will be added.

    Run Keyword If  '${flag}'=='Checked'
    ...  Set Tomorrow Variable for Checked
    ...  ELSE  Set Tomorrow Variable for Unchecked

    Run Keyword If  '${flag}'=='Checked'
    ...  Select Checkbox  //input[@id='showMobileOnly']
    ...  ELSE  Unselect Checkbox  //input[@id='showMobileOnly']

    Input Text  //input[@id='effectiveDate']  ${tomorrow}
    Click Element  //input[@id='submitBtn']

    Click Element  //button[contains(text(),'Submit')]

Check if new Direct Price has the Correct Show Mobile Only Flag on Database and Screen.

    Get Into DB  TCH
    ${query}  Catenate  SELECT rebate_id, show_mobile_only
    ...  FROM carr_disc_rebate
    ...  WHERE carrier_id = ${validCard.carrier.id}
    ...  ORDER BY rebate_id DESC Limit 1;

    ${db}  Query and Strip to Dictionary  ${query}

    ${rebate_id}  Get Table Value  0  Rebate ID
    ${show_mobile_only}  Get Table Value  0  Show Mobile Only

    Should Be Equal as Strings  ${rebate_id}  ${db['rebate_id']}
    Should Be Equal as Strings  ${show_mobile_only}  ${db['show_mobile_only']}

    Set Test Variable  ${rebate_id}

Get Table Value
    [Arguments]  ${row}  ${column}

    ${table_value}  Get Text  //table[@id='row']//tr[${row}+1]/td[count(//table[@id='row']//th[text()='${column}']/preceding-sibling::th)+1]

    [Return]  ${table_value}

Expire Carrier Direct Price
    [Documentation]  Keyword to Expire Carrier Direct Price
    [Arguments]  ${id}

    Select Checkbox  //input[@id='rebateIdsSel' and @value=${id}]
    Click Element  //input[@id='expireButton']
    Click Element  //button[contains(text(),'OK')]
    Wait Until Element Is Visible  //li[contains(text(),'Successfully Expired')]  timeout=10