*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Documentation  Create a front end for the card locking feature.
Force Tags  AM  Member Detail

Test Teardown    Close Browser
Suite Teardown    Disconnect from Database

*** Variables ***
${carrier}
# xpaths
${business_partner}    //*[@class="dataTables_scrollHeadInner"]//select[@name="businessPartnerCode"]
${customer}    //*[@class="dataTables_scrollHeadInner"]//input[@name='id']
${submit}    //*[@class="searchInputContainer"]//button[contains(text(), 'Submit')]
${submit_details}    //*[@id="customerFormButtons"]//button[@id="submit"]

*** Test Cases ***
Detail Tab - Current Member Data (TCH)
    [Tags]  JIRA:ATLAS-2387    JIRA:BOT-5089    qTest:120204427    Q2:2023
    [Documentation]    Create a front end for the card locking feature.
    [Setup]    Get Carrier ID and Password

    Open Account Manager
    Select Customers Tab
    Select 'EFS' business partner
    Input carrier id and submit
    Open customer details page
    Check for new Card Locking Status dropdown
    Update Card Locking Status to 'On'
    Check new 'On' card locking status in db
    Update Card Locking Status to 'Off'
    Check new 'Off' card locking status in db

*** Keywords ***
Select Customers Tab
    Click Element   //*[@id="Customer"]

Select '${bp}' business partner
    Wait Until Element is Visible    ${business_partner}
    Select From List By Value    ${business_partner}    ${bp}

Input carrier id and submit
    Wait Until Element is Visible    ${customer}
    Input Text    ${customer}    ${carrier.id}
    Wait Until Element is Enabled    ${submit}
    Click Element    ${submit}
    Wait Until Loading Spinners Are Gone

Open customer details page
    Wait Until Element is Visible    //*[@id="DataTables_Table_0"]//button[text()="${carrier.id}"]
    Click Element    //*[@id="DataTables_Table_0"]//button[text()="${carrier.id}"]
    Wait Until Loading Spinners Are Gone

Check for new Card Locking Status dropdown
    Page Should Contain    Card Locking Status
    Page Should Contain Element    name=detailRecord.cardLockSetUp

Update Card Locking Status to '${value}'
    Wait Until Element is Enabled    name=detailRecord.cardLockSetUp
    Select From List by Label   name=detailRecord.cardLockSetUp    ${value}
    Wait Until Element is Enabled    ${submit_details}
    Click Element    ${submit_details}
    Wait Until Element is Visible    //li[text()="Edit Successful"]
    Wait Until Element is Not Visible    //li[text()="Edit Successful"]

Check new '${value}' card locking status in db
    Get into DB    TCH
    ${query}    Catenate    SELECT mm_value
    ...    FROM member_meta
    ...    WHERE member_id  ='${carrier.id}'
    ...    AND mm_key = 'CARD_LOCK';
    ${mm_value}    Query And Strip    ${query}
    Run Keyword If    '${value}'=='On'    Should Be Equal as Strings    ${mm_value}    Y
    ...    ELSE    Should Be Equal as Strings    ${mm_value}    N
