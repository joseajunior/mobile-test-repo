*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Library  DateTime
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  AM

*** Test Cases ***
ExxonMobil Branded Wholesaler With Correct Roles
    [Tags]  JIRA:BOT-3238  qTest:42335314  refactor
    [Setup]  Get a Merchant ID With Allow Discounts And Customer Info To It

    Navigate To Merchant Manager -> Manage Deals
    Set Deal Level to Company
    Select a Random 'Carrier Name - Carrier Id' And Click On Next
    Wait For 'Carrier Contract' section
    Click On Next Button
    Set Deal Type to Retail Minus
    You Should See That Deal Type Has Only 'Retail Minus', 'Better of Cost Plus / Retail Minus' And 'Cost Plus' Types
    Set Effective Date For 1 Hour From Now
    Set Expired Date For 1 Hour and 5 Minutes From Now
    Input a Random Value As Retail Minus
    Click On Create Button
    You Should See a 'Deal Created' Message On Screen
    You Should See The Created Deal On 'Existing Deals' Table

    [Teardown]  Close Browser

ExxonMobil Branded Wholesaler Without Allowed Discounts roles
    [Tags]  JIRA:BOT-3238  qTest:42335319  refactor
    [Setup]  Get a Merchant ID With Only Manage Deals And Customer Info To It

    Navigate To Merchant Manager -> Manage Deals
    Set Deal Level to Company
    Select a Random 'Carrier Name - Carrier Id' And Click On Next
    Wait For 'Carrier Contract' section
    Click On Next Button
    You Should See That Deal Type Has No Items On Dropdown

    [Teardown]  Close Browser

Non ExxonMobil Branded Wholesaler Available Discounts
    [Tags]  JIRA:BOT-3238  qTest:42335322  refactor
    [Setup]  Get a Non ExxonMobil Carrier Merchant ID And Customer Info To It

    Navigate To Merchant Manager -> Manage Deals
    Set Deal Level to Company
    Input ${username} As User ID
    Click On Next Button
    Wait For 'Carrier Contract' section
    Click On Next Button
    Set Deal Type to Retail Minus
    You Should See That Deal Type Has All 6 Types
    Set Effective Date For 1 Hour From Now
    Set Expired Date For 1 Hour and 5 Minutes From Now
    Input a Random Value As Retail Minus
    Click On Create Button
    You Should See a 'Deal Created' Message On Screen
    You Should See The Created Deal On 'Existing Deals' Table

    [Teardown]  Close Browser

*** Keywords ***
Click On Create Button
    Click Element  //*[@id="chkInsertDeal"]

Click On Find User
    Click Element  //*[@name="SearchCustomers"]
    Wait Until Element Is Visible  //*[@class="messages"]/li[starts-with(text(), 'found')]

Click On Next Button
    Click Element  //*[@id="updateTabCarrier"]

Click On Searched User ID ${carrier}
    Click Element  //a[contains(@href, "${carrier}") and text()="${carrier}"]
    Wait Until Element Is Visible  //a[@href="/security/ManageCustomers.action"]  timeout=10

Get a Merchant ID With Only Manage Deals And Customer Info To It
    Get a Merchant ID On DB With Only Manage Deals Role

    Open eManager  ${intern}  ${internPassword}
    Navigate To User Administration -> Customer Info Test
    Input ${merchantId} As Search Value
    Click On Find User
    Click On Searched User ID ${merchantId}

Get a Merchant ID With Allow Discounts And Customer Info To It
    Get a Merchant ID On DB With Only Manage Deals And Allow Discounts Role

    Open eManager  ${intern}  ${internPassword}
    Navigate To User Administration -> Customer Info Test
    Input ${merchantId} As Search Value
    Click On Find User
    Click On Searched User ID ${merchantId}

Get a Merchant ID On DB With Only Manage Deals Role
    ${query}=  Catenate  SELECT DISTINCT x.user_id FROM sec_role r, sec_user_role_xref x WHERE x.role_id = r.role_id AND r.role_id = 'MERCH_MANAGE_DEALS'
    ...  AND x.user_id NOT IN (SELECT user_id FROM sec_role r, sec_user_role_xref x WHERE x.role_id = r.role_id AND r.role_id <> 'MERCH_MANAGE_DEALS')
    ...  AND x.user_id LIKE 'MERCH%' AND x.user_id NOT LIKE '%admin'
    ...  AND x.user_id IN (SELECT user_id FROM sec_user WHERE company_id IN (select company_id from sec_company where company_header = 'exxonMobil_carrier' AND type_id = 'Y'));

    Get User ID From Query  ${query}

Get a Merchant ID On DB With Only Manage Deals And Allow Discounts Role
    ${query}=  Catenate  SELECT DISTINCT x.user_id FROM sec_role r, sec_user_role_xref x WHERE x.role_id = r.role_id AND r.role_id = 'MERCH_MANAGE_DEALS'
    ...  AND x.user_id IN (SELECT user_id FROM sec_role r, sec_user_role_xref x WHERE x.role_id = r.role_id AND r.role_id = 'ALLOW_DISCOUNTS')
    ...  AND x.user_id NOT IN (SELECT user_id FROM sec_role r, sec_user_role_xref x WHERE x.role_id = r.role_id AND r.role_id <> 'MERCH_MANAGE_DEALS' AND r.role_id <> 'ALLOW_DISCOUNTS')
    ...  AND x.user_id LIKE 'MERCH%' AND x.user_id NOT LIKE '%admin'
    ...  AND x.user_id IN (SELECT user_id FROM sec_user WHERE company_id IN (select company_id from sec_company where company_header = 'exxonMobil_carrier' AND type_id = 'Y'));

    Get User ID From Query  ${query}

Get a Merchant ID On DB That Is Not a ExxonMobil Carrier
    ${query}=  Catenate  SELECT DISTINCT x.user_id FROM sec_role r, sec_user_role_xref x WHERE x.user_id IN (SELECT x.user_id FROM sec_role r, sec_user_role_xref x WHERE x.role_id = r.role_id AND r.role_id = 'MERCH_MANAGE_DEALS')
    ...  AND x.user_id IN (SELECT user_id FROM sec_user WHERE company_id IN (select company_id from sec_company where company_header = 'merchant' AND type_id = 'Y'))
    ...  AND x.user_id LIKE 'MERCH%' AND x.user_id NOT LIKE '%admin';

    Get User ID From Query  ${query}

Get a Non ExxonMobil Carrier Merchant ID And Customer Info To It
    Get a Merchant ID On DB That Is Not a ExxonMobil Carrier

    Open eManager  ${intern}  ${internPassword}
    Navigate To User Administration -> Customer Info Test
    Input ${merchantId} As Search Value
    Click On Find User
    Click On Searched User ID ${merchantId}

Get User ID From Query
    [Arguments]  ${query}
    Get Into DB  mysql
    ${data}=  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    ${userIds}=  Get From Dictionary  ${data}  user_id
    ${str}=  Run Keyword And Return Status  Should Be String  ${userIds}
    ${userId}=  Run Keyword If  ${str}  Catenate  ${userIds}
    ...  ELSE  Evaluate  random.choice(${userIds})  random

    Set Test Variable  ${merchantId}  ${userId}

Input ${carrier} As Search Value
    Input Text  searchValue  ${carrier}

Input ${value} As User ID
    Input Text  carrierId  ${value}

Input a Random Value As Retail Minus
    ${value}=  Evaluate  '0.{0:03d}'.format(random.choice(range(1, 151)))  random
    Input Text  selectedDeal.retailMinus  ${value}

    set test variable  ${retail_minus}  ${value}

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Select a Random 'Carrier Name - Carrier Id' And Click On Next
    ${lenght}=  Get Length  //*[@id="carrierId"]/option
    ${number}=  Evaluate  random.choice(range(1, ${lenght}))  random
    ${value}=  Get Value  //*[@id="carrierId"]/option[${number}]
    Select From List By Value  //*[@id="carrierId"]  ${value}

    Click On Next Button
    ${status}=  Run Keyword And Return Status  Wait For 'Carrier Contract' section
    Run Keyword Unless  ${status}  Select a Random 'Carrier Name - Carrier Id' And Click On Next

Set Deal Level to Company
    Select From List By Value  dealLevel  Y

Set Deal Type to Retail Minus
    Select From List By Value  selectedDeal.dealType  C
    Select From List By Value  selectedDeal.dealType  D

Set Effective Date For 1 Hour From Now
    ${now}=  getdatetimenow  %Y-%m-%d %H:%M  hours=1  tzinfo=CST6CDT
    Input Text  targetEffDts  ${now}

    set test variable  ${effective_date}  ${now}

Set Expired Date For 1 Hour and 5 Minutes From Now
    ${tomorrow}=  getdatetimenow  %Y-%m-%d %H:%M  hours=1  mins=5  tzinfo=CST6CDT
    Input Text  targetExpDts  ${tomorrow}

    set test variable  ${expire_date}  ${tomorrow}

Wait For 'Carrier Contract' section
    Wait Until Element Is Visible  //*[@id="chooseContract"]  timeout=5

You Should See a 'Deal Created' Message On Screen
    wait until page contains element  //*[@class='messages']/li[contains(text(), 'Deal Created')]  timeout=10

You Should See That Deal Type Has All 6 Types
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Retail Minus') and @value='D']
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Better of Cost Plus / Retail Minus') and @value='B']
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Cost Plus') and @value='C']
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Fixed Price') and @value='W']
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Absolute Fixed Price') and @value='w']
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Base Price Minus') and @value='I']

You Should See That Deal Type Has Only 'Retail Minus', 'Better of Cost Plus / Retail Minus' And 'Cost Plus' Types
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Retail Minus') and @value='D']
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Better of Cost Plus / Retail Minus') and @value='B']
    page should contain element  //*[@id="cbxDealType"]/option[contains(text(), 'Cost Plus') and @value='C']
    page should not contain element  //*[@id="cbxDealType"]/option[@value='W' or @value='w' or @value='I']

You Should See That Deal Type Has No Items On Dropdown
    page should contain element  //*[@id="cbxDealType"]
    page should not contain  //*[@id="cbxDealType"]/option

You Should See The Created Deal On 'Existing Deals' Table
    wait until page contains element  //*[@id="r"]/td[contains(text(), '${effective_date}')]
    wait until page contains element  //*[@id="r"]/td[contains(text(), '${expire_date}')]
    wait until page contains element  //*[@id="r"]/td[contains(text(), '${retail_minus}')]
