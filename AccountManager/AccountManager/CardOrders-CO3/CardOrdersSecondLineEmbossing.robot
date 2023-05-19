*** Settings ***
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM
Test Teardown    Close Browser

*** Variables ***
${carrier}

*** Test Cases ***
Prompt Value stores correctly after change
     [Documentation]  Card Orders second line embossing issue
     [Tags]   JIRA:ATLAS-2346  qtest:119612167  Q1:2023
     [Setup]  Get a Parkland Carrier
     Open Account Manager
     Select Customers Tab
     Input ${carrier.id} as Customer #
     Input 'Parkland' as Business Partner
     Click on Submit Button
     Click On Searched ${carrier.id} Carrier
     Click on CO3 Tab
     Click On CO3 Add Button
     Select CO3 '7 - EFS WEX NAF Fleet & Cash Card' Card Option
     Submit CO3 Card Order
     Add 'ROBOT TEST' as Second Line Embossing
     Add ROBOT TESTING in Line 2
     Click On CO3 Continue Button For Order Info
     Open Unique Info Tab to check Second Line Embossing is Updated

Prompt Value stores correctly after change using PNC
     [Documentation]  Card Orders second line embossing issue
     [Tags]   JIRA:ATLAS-2346  qtest:119612167  Q1:2023
     [Setup]  Get a PNC Carrier
     Open Account Manager
     Select Customers Tab
     Input ${carrier.id} as Customer #
     Get 'PNC' as Business Partner
     Click on Submit Button
     Click On Searched ${carrier.id} Carrier
     Click on CO3 Tab
     Click On CO3 Add Button
     Select CO3 '7 - EFS WEX NAF Fleet & Cash Card' Card Option
     Submit CO3 Card Order
     Add 'ROBOT TEST' as Second Line Embossing
     Add ROBOT TESTING in Line 2
     Click On CO3 Continue Button For Order Info
     Open Unique Info Tab to check Second Line Embossing is Updated


*** Keywords ***
Get a Parkland Carrier
    ${query}  Catenate  select carrier_id from cards  where card_num like '0456%' and carrier_id between 2500000 and 2999999 limit 1;
    ${carrier}    Find Carrier Variable    ${query}    carrier_id
    Set Suite Variable  ${carrier}

Get a PNC Carrier
    ${query}  Catenate  select carrier_id from cards  where card_num like '0456%' and carrier_id between 390000 and 399999 limit 1;
    ${carrier}    Find Carrier Variable    ${query}    carrier_id
    Set Suite Variable  ${carrier}

Select Customers Tab
    click element   //*[@id="Customer"]
    Wait Until Load Screen Icon Disappear From Screen

Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@class="loading-img"]  timeout=10
    Wait Until Element Is Not Visible    //*[@class="loading-img"]  timeout=10

Input ${id} As Customer #
    Input Text  id  ${id}

Input '${business_partner}' as Business Partner
    Wait Until Element Is Visible    //*/th[1]/select[@name="businessPartnerCode"]
    Select From List By Value   //*/th[1]/select[@name="businessPartnerCode"]  PARKLAND

Get '${business_partner}' as Business Partner
    Wait Until Element Is Visible    //*/th[1]/select[@name="businessPartnerCode"]
    Select From List By Value   //*/th[1]/select[@name="businessPartnerCode"]  PNC

Click On Submit Button
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Load Screen Icon Disappear From Screen

Click On Searched ${number} Carrier
    Click Element  //*[@class="id buttonlink" and contains(text(), '${number}')]

Click on CO3 Tab
    Wait Until Element Is Visible  //*[@id="CardOrders3"]
    Click Element  //*[@id="CardOrders3"]

Click On CO3 Add Button
    Wait Until Element Is Visible  //*[@id="customerCardOrders3SearchContainer"]//span[contains(text(), "ADD")]
    Click On  //*[@id="customerCardOrders3SearchContainer"]//span[contains(text(), "ADD")]

Select CO3 '${card_type}' Card Option
    Wait Until Element Is Visible  //*[@id="cardOrder3AddActionForm"]//*/select
    ${card_value}=  get value  //*[@id="cardOrder3AddActionForm"]//*[contains(text(), "${card_type}")]
    Select From List By Value  cardOrder3Detail.ccbCardOptionId  ${card_value}

Submit CO3 Card Order
    Click Element  //*[@id="cardOrder3AddFormButtons"]/button[@id="submit"]
    Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error    Wait Until Load Screen Icon Disappear From Screen

Add '${second_line_embossing}' as Second Line Embossing
    Wait Until Element Is Visible  //*[@name="detailRecord.line3Desc"]
    Input Text      //*[@name="detailRecord.line3Desc"]  ${second_line_embossing}

Add ROBOT TESTING in Line 2
    Wait Until Element Is Visible  //*[@name="detailRecord.line2Desc"]
    Input Text      //*[@name="detailRecord.line2Desc"]  ROBOT TESTING

Click On CO3 Continue Button For Order Info
    Wait Until Element Is Visible  //*[@id="orderInfo"]
    Click Button  CONTINUE
    Wait Until Load Screen Icon Disappear From Screen

Open Unique Info Tab to check Second Line Embossing is Updated
    Wait Until Element Is Visible   //*[@id="header1"]
    Click Element  //*[@id="Order_Info"]
