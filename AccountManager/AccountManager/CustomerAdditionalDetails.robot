*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Test Teardown    Close Browser

Force Tags  AM

*** Variables ***
${carrier}
${business_partner_xpath}    //*[@class="dataTables_scrollHead"]//select[@class="customerBusinessPartnerSelect
...    searchFilter" and @name="businessPartnerCode"]
${submit_search_customer_xpath}    //*[@id="customerSearchContainer"]//*[contains(text(),'Submit')]
${expected_naforgid}

*** Test Cases ***
Detail Record Naf Org Id field for issuer id 198790 customers
    [Tags]    qTest:118179814    JIRA:BOT-5032    JIRA:ATLAS-2193    JIRA:BOT-5038    JIRA:ATLAS-2290    PI:15
    [Documentation]    Ensure customers under issuer id 198790 has Detail Record Naf Org Id info in additionals
    ...    details tab from customer detail screen in Account Manager
    [Setup]    Setup Issuer Id 198790 Carrier with Naf Org Id

    Open Account Manager
    Search for Customer
    Open Customer from search result table
    Open Additional Details tab
    Verify Naf Org Id value
    Edit Naf Org Id with random value
    Check new value in database

*** Keywords ***
Setup Issuer Id 198790 Carrier with Naf Org Id
    [Documentation]    Setup issuer id 198790 carrier with Naf Org Id
    [Arguments]  ${DB}=TCH

    Get Into DB  ${DB}
    ${carrier_query}  Catenate    SELECT member_id, mm_value
    ...    FROM member_meta
    ...    WHERE mm_key = 'NAF_ORG_ID'
    ...    AND member_id IN (SELECT carrier_id
    ...    FROM contract
    ...    WHERE issuer_id = 198790)
    ...    LIMIT 1;
    ${carrier_list}    Query and Strip to Dictionary    ${carrier_query}
    ${carrier_id}    Get From Dictionary    ${carrier_list}    member_id
    ${naf_org_id}    Get From Dictionary    ${carrier_list}    mm_value
    ${carrier}    Create Dictionary    id=${carrier_id}    naforgid=${naf_org_id}
    Set Test Variable    ${carrier}

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

Open Additional Details tab
    [Documentation]    Open additional details tab from customer detail screen

    Wait Until Element is Visible    //*[@id="AdditionalDetails"]
    Click Element    //*[@id="AdditionalDetails"]
    Wait Until Element is Visible    //*[@id="customerAdditionalDetailsFormButtons"]//*[@id="submit"]

Verify Naf Org Id value
    [Documentation]    Check Naf Org Id value in additional details screen

    Page Should Contain    Detail Record Naf Org Id
    ${naf_org_id_value}    Get Element Attribute    name=detailRecord.nafOrgId    value
    Should Be Equal as Strings    ${naf_org_id_value}    ${carrier.naforgid}

Edit Naf Org Id value
    [Documentation]    Edit naf org id field
    [Arguments]    ${new_val}

    Input Text    name=detailRecord.nafOrgId    ${new_val}
    Click Element   //*[@id="customerAdditionalDetailsFormButtons"]//*[@id="submit"]
    Wait Until Page Contains    Edit Successful

Edit Naf Org Id with random value
    [Documentation]    Edit naf org id field with random value generated

    ${randvalue}    Generate Random String    14    [NUMBERS][LETTERS]
    Set Test Variable    ${expected_naforgid}    ${randvalue}
    Edit Naf Org Id value    ${randvalue}

Check new value in database
    [Documentation]    Ensure new value for Nag Org Id is updated in database
    [Arguments]  ${DB}=TCH

    Get Into DB  ${DB}
    ${naforgid_query}  Catenate    SELECT mm_value
    ...    FROM member_meta
    ...    WHERE mm_key = 'NAF_ORG_ID'
    ...    AND member_id = '${carrier.id}';
    ${naforgid}    Query and Strip    ${naforgid_query}
    Should Be Equal as Strings    ${expected_naforgid}    ${naforgid}