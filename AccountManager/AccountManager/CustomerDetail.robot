*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Documentation  Verifies all information on the Customer Detail tab in Account Manager.
Force Tags  AM  Member Detail

*** Variables ***
&{emptyDict}

*** Test Cases ***
Detail Tab - Current Member Data (TCH)
    [Documentation]  Verifies the following information on the page exists in the DB:\n\n
    ...  * Carrier\n\n
    ...  * Carrier Name and Legal Name\n\n
    ...  * Carrier Address\n\n
    ...  * Carrier Phone Number\n\n
    ...  * Carrier E-mail Address\n\n
    ...  * Carrier Password\n\n
    ...  * Sales Territory\n\n
    ...  * Account Manager\n\n

    [Tags]  TCH Instance  JIRA:BOT-1507  qTest:32853279  Regression  qTest:30864051  refactor
    [Setup]  Open EFS Carrier ${efs_carrier}

    ${original_member}=  Get Member Info  tch  ${efs_carrier}
    ${detail}=  Get AM Detail Info

    Compare Member Data  ${detail}  ${original_member}

    [Teardown]  Close Browser

Detail Tab - Change Member Data (TCH)
    [Documentation]  Temporarily alters the data on the page to verify that changes
    ...  can be saved and committed in the database.

    [Tags]  TCH Instance  JIRA:BOT-1508  qTest:30703667  Regression  refactor
    [Setup]  Run Keywords  Open EFS Carrier ${efs_carrier}
    ...  AND  Save Member Data

    Change Member Data

    ${new_member}=  Get Member Info  tch  ${efs_carrier}
    ${new_detail}=  Get AM Detail Info

    Compare Member Data  ${new_detail}  ${new_member}

    [Teardown]  Run Keywords  Revert Member Data
    ...  AND  Close Browser

Detail Tab - Location Deals By Prod Can Be Pulled
    [Tags]  JIRA:BOT-1399  qTest:30495329  Regression  refactor
    [Documentation]  Make sure Location Deals By Prod Can Be Pulled
    [Setup]  Open EFS Carrier ${userName}

    Set Test Variable  ${DB}  TCH
    ${LocDealsInfo}  Get Location Deals By Prod Level  ${contract}

    Click On  text=Deals
    Click on  text=Submit  exactMatch=False
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Check Element Exists  //*[@name="contractId"]  timeout=30
    Select From List By Value  //*[@name="contractId"]  ${contract}
    Select From List By Value  //*[@name="dealLevel"]  4       #Location Deals Prod Level
    Input Text  companyId  ${LocDealsInfo['location_id']}
    Input Text  effectiveDate  ${LocDealsInfo['eff_dt_search']}
    Input Text  expirationDate  ${LocDealsInfo['eff_dt_search']}
    Click on  text=Submit  exactMatch=False  index=2
    sleep  3
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)

    Page Should Contain  ${LocDealsInfo["contract_id"]}
    Page Should Contain  ${LocDealsInfo["deal_level"]}
    Page Should Contain  ${LocDealsInfo["location_id"]}
    Page Should Contain  ${LocDealsInfo["deal_type"]}
    Page Should Contain  ${LocDealsInfo["retail_minus"]}
    Page Should Contain  ${LocDealsInfo["eff_dt"]}
    Page Should Contain  ${LocDealsInfo["exp_dt"]}
    Page Should Contain  ${LocDealsInfo["created_by"]}
    Page Should Contain  ${LocDealsInfo["created"]}
    Page Should Contain  ${LocDealsInfo["last_updated"]}
    Page Should Contain  ${LocDealsInfo["fuel_type"]}

Detail Tab - Location Deals Can Be Pulled
    [Tags]  JIRA:BOT-1398  qTest:30493654  Regression  refactor
    [Documentation]  Make sure Location Deals Can Be Pulled
    [Setup]  Open EFS Carrier ${efs_carrier}

    Set Test Variable  ${DB}  TCH
    ${LocDealsInfo}  Get Location Deals  ${contract}

    tch logging  \n RESULTS:${LocDealsInfo}

    Open eManager  ${robot_emanager_username}  ${robot_emanager_password}
    Maximize Browser Window
    Hover Over  text=Select Program
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${userName}
    Click On  text=Submit  exactMatch=False
    Click On  text=${userName}

    Click On  text=Deals
    Click on  text=Submit  exactMatch=False
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Check Element Exists  //*[@name="contractId"]  timeout=30
    Select From List By Value  //*[@name="contractId"]  ${contract}
    Select From List By Value  //*[@name="dealLevel"]  3       #Location Deals
    Input Text  companyId  ${LocDealsInfo["location_id"]}
    Input Text  effectiveDate  ${LocDealsInfo["eff_dt_search"]}
    Input Text  fixedPrice  ${LocDealsInfo["weekly"]}
    Click on  text=Submit  exactMatch=False  index=2
    sleep  3
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)


    Page Should Contain  ${LocDealsInfo["contract_id"]}
    Page Should Contain  ${LocDealsInfo["deal_level"]}
    Page Should Contain  ${LocDealsInfo["location_id"]}
    Page Should Contain  ${LocDealsInfo["deal_type"]}
    Page Should Contain  ${LocDealsInfo["retail_minus"]}
    Page Should Contain  ${LocDealsInfo["eff_dt"]}
    Page Should Contain  ${LocDealsInfo["exp_dt"]}
    Page Should Contain  ${LocDealsInfo["created_by"]}
    Page Should Contain  ${LocDealsInfo["created"]}
    Page Should Contain  ${LocDealsInfo["last_updated"]}

    [Teardown]  Close Browser

Detail Tab - Add a Branded Wholesaler Id
    [Tags]  JIRA:BOT-1398  qTest:30493654  Regression  refactor
    [Documentation]  Make sure you can add a Brandded Wholesaler value to specific customers
    [Setup]  Run Keywords  Get a Branded Wholesaler Id
    ...  AND  Get Customer With The BW Field And No Id Added

    Open EFS Carrier ${customer}
    Input ${mm_value} As ExxonMobil BW ID
    Submit Changes For Customer

    Verify On DB The Changes

    [Teardown]  Run Keywords  Remove ExxonMobil Brandded Id
    ...  AND  Close Browser

Detail Tab - Edit a Branded Wholesaler Id
    [Tags]  JIRA:BOT-1398  qTest:30493654  Regression  refactor
    [Documentation]  Make sure you can add a Brandded Wholesaler value to specific customers
    [Setup]  Run Keywords  Get a Branded Wholesaler Id
    ...  AND  Get Customer With The a BW Id Associated

    Open EFS Carrier ${customer}
    Input ${mm_value} As ExxonMobil BW ID
    Submit Changes For Customer

    Verify On DB The Changes

    [Teardown]  Run Keywords  Change ExxonMobil BW ID Back To Default
    ...  AND  Close Browser

Detail Tab - Delete a Branded Wholesaler Id
    [Tags]  JIRA:BOT-1398  qTest:30493654  Regression  refactor
    [Documentation]  Make sure you can add a Brandded Wholesaler value to specific customers
    [Setup]  Run Keywords  Get a Branded Wholesaler Id
    ...  AND  Get Customer With The a BW Id Associated

    Open EFS Carrier ${customer}
    Remove ExxonMobil Brandded Id

    Verify On DB That You Cannot Find Row

    [Teardown]  Run Keywords  Change ExxonMobil BW ID Back To Default
    ...  AND  Close Browser

Additional Details Tab - Change Rebate Credit Fund Type Dropdown
    [Tags]  JIRA:FRNT-2105  qTest:116045810
    [Documentation]  Test the new Change Rebate Credit Fund Type dropdown on the Additional Details tab.
    ...  It should be AR by default and changeable to AR or AP.  The value can be confirmed in the member_memta table.
    ...  For the value 'AR' no update to the member_meta table will occur.
    [Setup]  Get a Valid TCH Carrier

    Set Test Variable  ${DB}  TCH
    Select Additional Details Tab
    Set Rebate Credit Fund Type= AP
    Verify member_meta.mm_value= Rebate Credit Fund Type
    Set Rebate Credit Fund Type= AR
    Verify member_meta.mm_value= Rebate Credit Fund Type

    [Teardown]  Close Browser

*** Keywords ***
Change ExxonMobil BW ID Back To Default
    Input ${mm_value_bfr} As ExxonMobil BW ID
    Submit Changes For Customer

    Verify On DB The Changes  ${merchant_company}

Change Member Data

    Input TESTING NAME As Name
    Input TESTING STREET As Address
    Input TESTING CITY As City
    Select AL As State
    Input 12345 As Zip Code
    Input 112-233-4455 As Phone
    Input testing@test.com As Email
    Select W1 As Sales Territory
    Select 61 As Account Manager Id
    Submit Changes For Customer

Clear The ExxonMobil BW ID
    Clear Element Text  //*[@name="detailRecord.emBwId"]

Click On Searched ${customer} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customer}"]
    Click Element  //button[@class="id buttonlink" and text()="${customer}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    Sleep  3s
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]

Compare Member Data
    [Arguments]  ${ui_data}  ${db_data}

    should be equal as strings  ${ui_data["id"]}  ${db_data["id"]}
    should be equal as strings  ${ui_data["name"]}  ${db_data["name"]}
    should be equal as strings  ${ui_data["street"]}  ${db_data["street"]}
    should be equal as strings  ${ui_data["city"]}  ${db_data["city"]}
    should be equal as strings  ${ui_data["state"]}  ${db_data["state"]}
    should be equal as strings  ${ui_data["zip"]}  ${db_data["zip"]}
    should be equal as strings  ${ui_data["country"]}  ${db_data["country"]}
    should be equal as strings  ${ui_data["phone"]}  ${db_data["phone"]}
    should be equal as strings  ${ui_data["email"]}  ${db_data["email"]}
    should be equal as strings  ${ui_data["legal_name"]}  ${db_data["legal_name"]}
    should be equal as strings  ${ui_data["password"]}  ${db_data["password"]}
    should be equal as strings  ${ui_data["sales_territory"]}  ${db_data["sales_territory"]}
    should be equal as strings  ${ui_data["acct_mgr"]}  ${db_data["acct_mgr"]}

Get AM Detail Info
    ${detail}=  create dictionary
    ...  id                 ${None}
    ...  name               ${None}
    ...  street             ${None}
    ...  city               ${None}
    ...  state              ${None}
    ...  zip                ${None}
    ...  country            ${None}
    ...  phone              ${None}
    ...  email              ${None}
    ...  legal_name         ${None}
    ...  password           ${None}
    ...  sales_territory    ${None}
    ...  acct_mgr           ${None}

    ${detail.id}=  get text  //*[text() = "Customer #"]/parent::*/following-sibling::*[1]
    ${detail.name}=  get value  //*[@name="detailRecord.name"]
    ${detail.street}=  get value  //*[@name="detailRecord.address1"]
    ${detail.city}=  get value  //*[@name="detailRecord.city"]
    ${detail.state}=  get selected list value  //*[@name="detailRecord.state"]
    ${detail.zip}=  get value  //*[@name="detailRecord.zip"]
    ${detail.country}=  get text  //*[text() = "Country"]/parent::*/following-sibling::*[1]/span
    ${detail.country}=  get first character  ${detail.country}
    ${detail.phone}=  get value  //*[@name="detailRecord.phone"]
    ${detail.email}=  get value  //*[@name="detailRecord.email"]
    ${detail.legal_name}=  get text  //*[text() = "Legal Business Name"]/parent::*/following-sibling::*[1]/span
    ${detail.sales_territory}=  get selected list value  //*[@name="detailRecord.salesTerritory"]
    ${detail.acct_mgr}=  get selected list value  //*[@name="detailRecord.accountManagerId"]
    click on  text=View
    ${detail.password}=  get value  //*[@name="detailRecord.customerPassword"]

    [Return]  ${detail}

Get a Branded Wholesaler Id
    Get Into DB  TCH

    ${query}=  Catenate  SELECT mm_value, member_id FROM member_meta WHERE mm_key = 'EM_BW_ID';
    ${results}=  Query And Return Dictionary Rows  ${query}
    ${row}=  Evaluate  random.choice(${results})  random
    Set Test Variable  ${mm_value}  ${row['mm_value']}
    Set Test Variable  ${member_id}  ${row['member_id']}

    Disconnect From Database

Get a Valid TCH Carrier
    [Tags]  qTest
    [Documentation]  SELECT member_id
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND (member_id between 300000 and 389999 OR member_id between 650000 and 699999)
    ...  LIMIT 1000;
    ...  Use the above query to find a valid Customer #

    Get Into DB  TCH
    ${query}=  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND (member_id between 300000 and 389999 OR member_id between 650000 and 699999)
    ...  LIMIT 1000;
    ${index}  Generate Random String  3  0123456789
    ${results}  Query and Strip to Dictionary  ${query}
    Set Test Variable  ${original_member}  ${results["member_id"]}[${index}]
    Open EFS Carrier ${original_member}

Get Customer With The BW Field And No Id Added
    Get Into DB  TCH

    ${query}=  Catenate  SELECT carrier_id FROM contract WHERE issuer_id = 194153 AND carrier_id NOT IN (SELECT carrier_id FROM merch_company_carrier_restriction_xref);
    ${results}=  Query And Strip To Dictionary  ${query}
    ${carriers}=  Get From Dictionary  ${results}  carrier_id
    ${carrier}=  Evaluate  random.choice(${carriers})  random

    Set Test Variable  ${customer}  ${carrier}

    Disconnect From Database

Get Customer With The a BW Id Associated
    Get Into DB  TCH

    ${query}=  Catenate  SELECT * FROM merch_company_carrier_restriction_xref
    ...  WHERE carrier_id IN (SELECT carrier_id FROM contract WHERE issuer_id = 194153)
    ${results}=  Query And Return Dictionary Rows  ${query}
    ${row}=  Evaluate  random.choice(${results})  random

    Set Test Variable  ${customer}  ${row['carrier_id']}
    Set Test Variable  ${merchant_company}  ${row['merchant_company']}

    ${mm_query}=  Catenate  SELECT mm_value FROM member_meta where mm_key = 'EM_BW_ID' AND member_id = ${merchant_company};
    ${mm_value_bfr}=  Query And Strip  ${mm_query}

    Set Test Variable  ${mm_value_bfr}

    Disconnect From Database

Get Member Info
    [Arguments]  ${instance}  ${carrier_id}
    Get Into DB  ${instance}
    ${query}=  catenate
    ...  select m.member_id, m.name, m.add1, m.city, m.state, m.zip, m.country, m.cont_phone, m.email_addr, m.legal_name,
    ...  m.passwd, m.sales_territory, a.mgr_id
    ...  from member m, acct_mgr_xref a
    ...  where m.member_id = a.carrier_id and m.member_id = ${carrier_id}

    @{results}=  query and strip to list  ${query}
    ${zip}=  remove trailing spaces  @{results}[5]
    ${pass}=  remove trailing spaces  @{results}[10]
    ${am}=  assign string  @{results}[12]
    ${member}=  create dictionary
    ...  id                 @{results}[0]
    ...  name               @{results}[1]
    ...  street             @{results}[2]
    ...  city               @{results}[3]
    ...  state              @{results}[4]
    ...  zip                ${zip}
    ...  country            @{results}[6]
    ...  phone              @{results}[7]
    ...  email              @{results}[8]
    ...  legal_name         @{results}[9]
    ...  password           ${pass}
    ...  sales_territory    @{results}[11]
    ...  acct_mgr           ${am}

     disconnect from database
    [Return]  ${member}

Get Location Deals By Prod Level
    [Arguments]  ${contractID}

    Get Into DB  ${DB}

    ${query}  catenate  SELECT TO_CHAR(ld.location_id) AS location_id,
    ...     TO_CHAR(ld.contract_id) AS contract_id,
    ...     TO_CHAR(ld.deal_level) AS deal_level,
    ...     TO_CHAR(ld.deal_type) AS deal_type,
    ...     TO_CHAR(ld.deal_owner) AS deal_owner,
    ...     TO_CHAR(ld.fuel_type) AS fuel_type,
    ...     TO_CHAR(ld.base_minus,'&') AS base_minus,
    ...     TO_CHAR(ld.retail_minus,'&.&&&') AS retail_minus,
    ...     TRIM(ld.created_by) AS created_by,
    ...     TO_CHAR(ld.eff_dt,'%Y-%m-%d') AS eff_dt,
    ...     DECODE(exp_dt, NULL, TO_CHAR(ld.eff_dt,'%Y-%m-%d')) AS exp_dt,
    ...     TO_CHAR(ld.eff_dt,'%m/%d/%Y') AS eff_dt_search,
    ...     TO_CHAR(ld.exp_dt,'%m/%d/%Y') AS exp_dt_search,
    ...     TO_CHAR(ld.last_updated,'%Y-%m-%d %H:%M:%S.0') AS last_updated,
    ...     TO_CHAR(ld.created,'%Y-%m-%d %H:%M:%S.0') AS created,
    ...     TO_CHAR(ld.cost_plus,'&') AS cost_plus
    ...     FROM location_deals_prod_level ld
    ...     WHERE ld.contract_id = ${contractID}
    ...     ORDER BY last_updated DESC limit 1
    ${results}  Query And Strip To Dictionary  ${query}
    [Return]  ${results}

Get Location Deals
    [Arguments]  ${contractID}

    Get Into DB  TCH
    ${query}  catenate  SELECT TO_CHAR(location_id) AS location_id,
    ...     TO_CHAR(contract_id) AS contract_id,
    ...     TO_CHAR(deal_level) AS deal_level,
    ...     TO_CHAR(deal_type) AS deal_type,
    ...     TO_CHAR(deal_owner) AS deal_owner,
    ...     TO_CHAR(fuel_type) AS fuel_type,
    ...     TO_CHAR(weekly) AS weekly,
    ...     TO_CHAR(base_minus,'&') AS base_minus,
    ...     DECODE(retail_minus, '0', TO_CHAR(retail_minus,'&'), TO_CHAR(retail_minus,'&.&&&') ) AS retail_minus,
    ...     TRIM(created_by) AS created_by,
    ...     TO_CHAR(eff_dt,'%Y-%m-%d') AS eff_dt,
    ...     DECODE(exp_dt, NULL, TO_CHAR(eff_dt,'%Y-%m-%d'), TO_CHAR(exp_dt,'%Y-%m-%d')) AS exp_dt,
    ...     TO_CHAR(eff_dt,'%m/%d/%Y') AS eff_dt_search,
    ...     TO_CHAR(exp_dt,'%m/%d/%Y') AS exp_dt_search,
    ...     TO_CHAR(last_updated,'%Y-%m-%d %H:%M:%S.0') AS last_updated,
    ...     TO_CHAR(created,'%Y-%m-%d %H:%M:%S.0') AS created,
    ...     TO_CHAR(cost_plus,'&') AS cost_plus
    ...     FROM location_deals
    ...     WHERE carrier_id = ${username}
    ...     AND   contract_id = ${contractID}
    ...     AND   deal_level IN (1,5)
    ...     ORDER BY created DESC limit 1
    ${results}  Query And Strip To Dictionary  ${query}
    [Return]  ${results}

Input ${address} As Address
    input text  //*[@name="detailRecord.address1"]  ${address}

Input ${city} As City
    input text  //*[@name="detailRecord.city"]  ${city}

Input ${customer} As Customer #
    Input Text  //*[@name="id"]  ${customer}

Input ${email} As Email
    input text  //*[@name="detailRecord.email"]  ${email}

Input ${bw_id} As ExxonMobil BW ID
    Input Text  //*[@name="detailRecord.emBwId"]  ${bw_id}

Input ${name} As Name
    input text  //*[@name="detailRecord.name"]  ${name}

Input ${phone} As Phone
    input text  //*[@name="detailRecord.phone"]  ${phone}

Input ${zip} As Zip Code
    input text  //*[@name="detailRecord.zip"]  ${zip}

Open EFS Carrier ${carrier}
    [Documentation]  Using ${carrier} in Account Manager.

    [Tags]  TCH Instance

    Open Account Manager
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #

Remove ExxonMobil Brandded Id
    Clear The ExxonMobil BW ID
    Submit Changes For Customer

Revert Member Data
    Input ${member_data["name"]} As Name
    Input ${member_data["street"]} As Address
    Input ${member_data["city"]} As City
    Select ${member_data["state"]} As State
    Input ${member_data["zip"]} As Zip Code
    Input ${member_data["phone"]} As Phone
    Input ${member_data["email"]} As Email
    Select ${member_data["sales_territory"]} As Sales Territory
    Select ${member_data["acct_mgr"]} As Account Manager Id
    Submit Changes For Customer

Save Member Data
    ${member_data}=  Get Member Info  tch  ${efs_carrier}
    Set Test Variable  ${member_data}

Select Additional Details Tab
    [Tags]  qTest
    [Documentation]  Select Additional Details tab
    Wait Until Element Is Visible  Detail
    Click On  //*[@id="AdditionalDetails"]/span
    Wait Until Loading Spinners Are Gone  #Rebate Credit Fund Type

Select ${am_id} As Account Manager Id
    select from list by value  //*[@name="detailRecord.accountManagerId"]  ${am_id}

Select ${sl} As Sales Territory
    select from list by value  //*[@name="detailRecord.salesTerritory"]  ${sl}

Select ${uf} As State
    select from list by value  //*[@name="detailRecord.state"]  ${uf}

Set Rebate Credit Fund Type= ${flag}
    [Tags]  qTest
    [Documentation]  Set Rebate Credit Fund Type to Appropriate Type (AR, AP)

    Select From List By Value  //*[@name="detailRecord.rebateCreditType"]   ${flag}
    Click Button  //*/div[2]/div//*[@id="submit"]
    Wait Until Element Is Visible  //*[@id="customerAdditionalDetailsMessages"]/ul[2]/li
    Wait Until Element Is Not Visible  //*[@id="customerAdditionalDetailsMessages"]/ul[2]/li
    ${flag}  Get Value  //*[@name="detailRecord.rebateCreditType"]
    Set Test Variable  ${flag1}  ${flag}

Submit Changes For Customer
    Click On  //*[@id="customerFormButtons"]/button[@id="submit"]
    You Should See Successful 'Edit Successful' Message On The Screen

Verify member_meta.mm_value= Rebate Credit Fund Type
    [Tags]  qTest
    [Documentation]  Confirm Flag value in member_meta table
    ...  SELECT *
    ...  FROM member_meta
    ...  WHERE mm_key = 'RBTFLAG'
    ...  AND member_id = {member_id};

    ${query}=  Catenate
    ...  SELECT *
    ...  FROM member_meta
    ...  WHERE mm_key = 'RBTFLAG'
    ...  AND member_id = ${original_member};
    ${results}  Query And Strip To Dictionary  ${query}
    Run Keyword If  '${flag1}'=='AR'  Return From Keyword If  '${results}'=='&{emptyDict}'
    Set Test Variable  ${flag2}  ${results["mm_value"]}
    Should Be Equal As Strings  ${flag1}  ${flag2}

Verify On DB That You Cannot Find Row
    Sleep  3s
    Get Into Db  TCH

    ${query}=  Catenate  SELECT * FROM merch_company_carrier_restriction_xref WHERE carrier_id = ${customer};
    Row Count Is 0  ${query}

    Disconnect From Database

Verify On DB The Changes
    [Arguments]  ${member}=${member_id}
    Sleep  3s
    Get Into Db  TCH

    ${query}=  Catenate  SELECT * FROM merch_company_carrier_restriction_xref WHERE carrier_id = ${customer};
    ${result}=  Query And Strip To Dictionary  ${query}

    Disconnect From Database

    Should Be Equal As Strings  ${result['merchant_company']}  ${member}

You Should See Successful '${message}' Message On The Screen
    Wait Until Element Is Visible  //*[@id="customerActionFormContainer"]//ul[@class="msgSuccess"]/li[text()='${message}']  timeout=10