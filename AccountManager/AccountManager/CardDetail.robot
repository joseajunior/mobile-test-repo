*** Settings ***
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Test Teardown  Close Browser
Suite Teardown  Disconnect From Database

Force Tags  AM

*** Variables ***
${carrier}

*** Test Cases ***
Imperial carrier id with the role "AM Reprint Cardlock Pin"
    [Tags]    JIRA:FRNT-2106  JIRA:BOT-4991  qTest:116336043
    [Documentation]    When imperial carrier id has the role "AM Reprint Cardlock Pin" then
    ...    'REPRINT CARDLOCK PIN' link will be appear
    [Setup]    Setup Imperial Carrier With Cards

    Add AM Reprint Cardlock Pin Permission to Carrier
    Open Account Manager
    Search and Open Customer  IMPERIAL_OIL  ${carrier}
    Search and Open First Card
    Check Reprint Cardlock Pin Link Displayed

Imperial carrier id without the role "AM Reprint Cardlock Pin"
    [Tags]    JIRA:FRNT-2106  JIRA:BOT-4991  qTest:116336044
    [Documentation]     when imperial carrier id who doesn't have the role "AM Reprint Cardlock Pin" then
    ...    'REPRINT CARDLOCK PIN' link will be disappear
    [Setup]    Setup Imperial Carrier With Cards

    Remove AM Reprint Cardlock Pin Permission from Carrier
    Open Account Manager
    Search and Open Customer  IMPERIAL_OIL  ${carrier}
    Search and Open First Card
    Check Reprint Cardlock Pin Link Not Displayed

*** Keywords ***
Setup Imperial Carrier With Cards
    [Documentation]  Get valid imperial carrier for test

    Get Into DB  IMPERIAL
    ${query}  Catenate  SELECT member_id
    ...    FROM member m
    ...    INNER JOIN cards c
    ...    ON c.carrier_id = m.member_id
    ...    WHERE m.status = 'A'
    ...    AND c.status = 'A'
    ...    AND mem_type = 'C'
    ...    AND ((member_id >= 0 AND member_id <= 99999) OR (member_id >= 950000 AND member_id <= 997999))
    ...    ORDER BY c.created DESC;
    ${carrier}  Query And Strip  ${query}
    Set Suite Variable  ${carrier}

Add AM Reprint Cardlock Pin Permission to Carrier
    [Documentation]    Give the carrier the AM Reprint Cardlock Pin permission

    Ensure Carrier has User Permission    ${carrier}    AM_REPRINT_CARDLOCK_PIN

Remove AM Reprint Cardlock Pin Permission from Carrier
    [Documentation]    Remove from carrier the AM Reprint Cardlock Pin permission

    Remove Carrier User Permission    ${carrier}    AM_REPRINT_CARDLOCK_PIN

Search and Open Customer
    [Documentation]    Search customer in account manager and open its detail screen
    [Arguments]    ${business_partner}    ${customer}

    Wait Until Element is Visible    //*[@id='Customer']
    Click Element    //*[@id='Customer']
    Wait Until Element is Visible    name=businessPartnerCode
    Select From List By Value    name=businessPartnerCode    ${business_partner}
    Input Text    //*[@class='center']/input[@name="id"]    ${customer}
    Click Element    //*[@id="customerSearchContainer"]//*[@class="button searchSubmit"]
    Wait Until Element is Visible    //*[@class="id buttonlink" and text()='${customer}']
    Click Element    //*[@class="id buttonlink" and text()='${customer}']
    Wait Until Element is Visible    //div[text()='Customer']/following-sibling::div//*[@id="Detail"]

Search and Open First Card
    [Documentation]    Search for cards and open the first one's detail screen

    Click Element    id=Cards
    Wait Until Element is Visible    //span[text()='RENUMBER']
    Wait Until Element is Visible    //*[@id="customerCardsSearchContainer"]//button[@class="button searchSubmit"]
    Click Element    //*[@id="customerCardsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Element is Visible    (//*[@class="cardNumber buttonlink"])[1]
    Click Element    (//*[@class="cardNumber buttonlink"])[1]

Check Reprint Cardlock Pin Link Displayed
    [Documentation]    The reprint cardlock pin link should be displayed

    Wait Until Element is Visible    //*[@id="cardFormButtons"]//button[@id="submit"]
    Page Should Contain Element    name=reprintCardLockPin

Check Reprint Cardlock Pin Link Not Displayed
    [Documentation]    The reprint cardlock pin link should not be displayed

    Wait Until Element is Visible    //*[@id="cardFormButtons"]//button[@id="submit"]
    Page Should Not Contain Element    name=reprintCardLockPin