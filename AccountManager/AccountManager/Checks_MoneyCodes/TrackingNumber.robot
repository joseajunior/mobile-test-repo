*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Test Teardown    Close Browser

Force Tags  AM

*** Variables ***
${carrier}
${tracking_number}
${business_partner_xpath}    //*[@class="dataTables_scrollHead"]//select[@class="customerBusinessPartnerSelect
...    searchFilter" and @name="businessPartnerCode"]
${submit_xpath}    //*[@id="customerCardOrders2SearchContainer"]//button[contains(text(), 'Submit')]
${submit_search_customer_xpath}    //*[@id="customerSearchContainer"]//*[contains(text(),'Submit')]

*** Test Cases ***
Tracking number from card order meta displayed in AM
    [Tags]  qTest:118040503    JIRA:BOT-5029    JIRA:ATLAS-2211    PI:15
    [Documentation]    Update account management to show tracking number from card order meta
    [Setup]    Run Keywords    Setup Carrier with Order Tracking Number    Setup Tracking Number

     Open Account Manager
     Search for Customer
     Open Customer from search result table
     Search for Tracking Number
     Check Shipped Card Order Status with Tracking Number

*** Keywords ***
Setup Carrier with Order Tracking Number
    [Documentation]    Setup carrier with order tracking number available
    [Arguments]  ${DB}=TCH

    Get Into DB  ${DB}
    ${carrier_query}  Catenate    SELECT DISTINCT carrier_id, TRIM(passwd) as passwd
    ...    FROM ccb_card_orders o
    ...    INNER JOIN ccb_card_order_meta om
    ...    ON o.ccb_card_order_id = om.ccb_card_order_id
    ...    INNER JOIN member m
    ...    ON m.member_id = o.carrier_id
    ...    WHERE o.order_status = 'Y'
    ...    AND om.feature_code = 'tracking_number'
    ...    LIMIT 1;
    ${carrier_list}    Query and Strip to Dictionary    ${carrier_query}
    ${carrier_id}    Get From Dictionary    ${carrier_list}    carrier_id
    ${password}    Get From Dictionary    ${carrier_list}    passwd
    ${carrier}    Create Dictionary    id=${carrier_id}    password=${password}
    Set Test Variable    ${carrier}

Setup Tracking Number
    [Documentation]    Setup available tracking number
    [Arguments]  ${DB}=TCH

    Get Into DB  ${DB}
    ${tracking_number_query}    Catenate    SELECT value
    ...    FROM ccb_card_orders o
    ...    INNER JOIN ccb_card_order_meta om
    ...    ON o.ccb_card_order_id = om.ccb_card_order_id
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND o.order_status = 'Y'
    ...    AND om.feature_code = 'tracking_number'
    ...    LIMIT 1;
    ${tracking_number}    Query and Strip    ${tracking_number_query}
    Set Test Variable    ${tracking_number}

Search for Customer
    [Documentation]    Search in customers tab by carrier id

    Wait Until Element is Visible    ${business_partner_xpath}
    Select From List By Value    ${business_partner_xpath}    EFS
    Input Text    name=id    ${carrier.id}
    Click Element  ${submit_search_customer_xpath}

Open Customer from search result table
    [Documentation]    Open customer details screen

    Wait Until Element is Visible    //*[@class="id buttonlink" and text()='${carrier.id}']
    Click Element    //*[@class="id buttonlink" and text()='${carrier.id}']
    Page Should Contain     ${carrier.id}

Search for Tracking Number
    [Documentation]    Search card order using tracking number

    Wait Until Element is Visible    name=trackingNumber
    Input Text    name=trackingNumber    ${tracking_number}
    Click Element    ${submit_xpath}

Check Card Order Status with Tracking Number
    [Documentation]    Compare card order status with tracking number with expected one
    [Arguments]    ${expected_status}

    Wait Until Element is Visible    //*[@id="DataTables_Table_0"]//td[text()='${tracking_number}']/parent::tr/td[6]
    ${tn_status}    Get Text    //*[@id="DataTables_Table_0"]//td[text()='${tracking_number}']/parent::tr/td[6]
    Should Be Equal as Strings    ${expected_status}    ${tn_status}

Check Shipped Card Order Status with Tracking Number
    [Documentation]    Ensure shipped status is displayed in tracking number from card order

    Check Card Order Status with Tracking Number    Shipped