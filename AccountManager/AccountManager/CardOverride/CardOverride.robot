*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot


Force Tags  Account Manager

*** Test Cases ***
Parkland - Successfull Add Gas - Plus
    [Tags]  JIRA:ROCKET-89  qTest:53565392  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Overrides Tab
    Select Number of overrides 1
    Select All Merchants
    Select GAS Product for override
    Select Gas Groups for Parkland  Plus
    Input 100 for GAS for override
    Click on Submit for Product override
    Click on Submit to complete override
    Verify Correct Products are added for Group  Plus
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - Regular
    [Tags]  JIRA:ROCKET-89  qTest:53565392  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Overrides Tab
    Select Number of overrides 1
    Select All Merchants
    Select GAS Product for override
    Select Gas Groups for Parkland  Regular
    Input 100 for GAS for override
    Click on Submit for Product override
    Click on Submit to complete override
    Verify Correct Products are added for Group  Regular
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - Premium/Supreme Group
    [Tags]  JIRA:ROCKET-89  qTest:53565392  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Overrides Tab
    Select Number of overrides 1
    Select All Merchants
    Select GAS Product for override
    Select Gas Groups for Parkland  Premium/Supreme
    Input 100 for GAS for override
    Click on Submit for Product override
    Click on Submit to complete override
    Verify Correct Products are added for Group  Premium/Supreme
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - Supreme Plus (Chevron Only)
    [Tags]  JIRA:ROCKET-89  qTest:53565392  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Overrides Tab
    Select Number of overrides 1
    Select All Merchants
    Select GAS Product for override
    Select Gas Groups for Parkland  Supreme Plus (Chevron Only)
    Input 100 for GAS for override
    Click on Submit for Product override
    Click on Submit to complete override
    Verify Correct Products are added for Group  Supreme Plus (Chevron Only)
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - All Group
    [Tags]  JIRA:ROCKET-89  qTest:53565392  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Overrides Tab
    Select Number of overrides 1
    Select All Merchants
    Select GAS Product for override
    Click Submit for Product Group
    Input 100 for GAS for override
    Click on Submit for Product override
    Click on Submit to complete override
    Verify Correct Products are added for Group  Premium/Supreme','Plus','Regular','Supreme Plus (Chevron Only)
    [Teardown]  Parkland Clean up

*** Keywords ***
Input ${amt} for ${product} for override
    Wait Until Element Is Visible  //tr[@data-product-code="${product}"]
    input text  //tr[@data-product-code="${product}"]//input[@type="text"]  ${amt}  ${FALSE}

Select Number of overrides ${num}
    select from list by value  //select[@name="overridesSummary.cardSwipes"]  ${num}

Select All Merchants
    click element  xpath=//*[@name="overridesSummary.overrideAllMerchants"]

Select ${product} Product for override
    Click Element  //button[@id="btnEditProductLimits" and text()="View Limits"]
    click element  //input[@data-product-code="${product}"]

Click on Submit for Product override
    click element  //*[@id="overrideProductLimitsFormButtons"]//button[@id="submit"]

Click on Submit to complete override
    Wait Until Element Is Visible  //*[@id="overridesFormButtons"]//button[@id="submit"]
    click element  //*[@id="overridesFormButtons"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone
    wait until element is visible  xpath=//button[text()="Remove Override"]

Remove Card Override if exists
    Click On Overrides Tab
    ${cnt}  get element count  xpath=//button[text()="Remove Override"]
    IF  ${cnt}>0
        Click Element  //button[text()="Remove Override"]
    END

Parkland Clean up
    Remove Card Override if exists
    IF  '${changed}'=='added'
      ${sql}  catenate  DELETE FROM member_meta
      ...  where  member_id =${parkland_carrier.member_id} and  mm_key = 'PRODLMTS'
      execute sql string  ${sql}  db_instance=TCH
    ELSE IF  '${changed}'=='updated'
      ${sql}  catenate  UPDATE member_meta
        ...  SET mm_value = 'N'
        ...  where  member_id =${parkland_carrier.member_id} and  mm_key = 'PRODLMTS'
        execute sql string  ${sql}  db_instance=TCH
    END
    close browser

Get Parkland Carrier
    set test variable  ${changed}  NONE
    ${carriersql}  Catenate    Select * from def_card where id in(
    ...  select carrier_id from cards
    ...  where lmtsrc!='D' and status = 'A'
    ...  and carrier_id between 2500000 and 2599999
    ...  and card_num not in
    ...    (select card_num from card_lmt
    ...     where limit_id = 'GAS'))
    ${parkland_carrier}  find carrier variable  ${carriersql}  id
    set test variable  ${parkland_carrier}
    ${cnt}  query and strip  select count(*) from member_meta where member_id = ${parkland_carrier.member_id} and mm_key = 'PRODLMTS'  db_instance=TCH
    IF  ${cnt}<1
        ${sql}  catenate  INSERT INTO member_meta (member_id,mm_key,mm_value)
        ...  VALUES
        ...  (${parkland_carrier.member_id},'PRODLMTS','Y')
        execute sql string  ${sql}  db_instance=TCH
        set test variable  ${changed}  added
    END
    ${value}  query and strip  select mm_value from member_meta where member_id =${parkland_carrier.member_id} and mm_key = 'PRODLMTS'  db_instance=TCH
    IF  '${value}'=='N'
        ${sql}  catenate  UPDATE member_meta
        ...  SET mm_value = 'Y'
        ...  where  member_id =${parkland_carrier.member_id} and  mm_key = 'PRODLMTS'
        execute sql string  ${sql}  db_instance=TCH
        set test variable  ${changed}  updated
    END
    ${card}  find card variable  select * from cards where card_num NOT LIKE '%OVER' and lmtsrc!='D' and carrier_id = ${parkland_carrier.member_id} and card_num not in (select card_num from card_lmt where limit_id = 'GAS')
    set test variable  ${card}

Verify Correct Products are added for Group
    [Arguments]  ${group}
    ${cardlimitsql}  catenate  select prod_num from card_lmt_prod where prod_num in (select num from products_gas_grouping_desc) and card_num ='${card.card_num}OVER' order by prod_num desc
    FOR  ${i}  IN RANGE  5
        ${cardlimit}  query and strip to list  ${cardlimitsql}  db_instance=TCH
        exit for loop if  '${cardlimit}'!='None'
        sleep  1
    END

    ${grplimit}  query and strip to list  select num from products_gas_grouping_desc where description in ('${group}') order by num desc  db_instance=TCH
    should be equal  ${cardlimit}  ${grplimit}

Select Gas Groups for Parkland
    [Arguments]  ${group}
    Wait Until Element Is Visible  xpath=//*[@restriction-data-desc="Premium/Supreme"]
    IF  '${group}' == 'Plus'
      click element  xpath=//*[@restriction-data-desc="Premium/Supreme" and @value="13,1,3,87,91"]
      click element  xpath=//*[@restriction-data-desc="Regular" and @value="11,31,33,41,72,88,92"]
      click element  xpath=//*[@restriction-data-desc="Supreme Plus (Chevron Only)" and @value="71"]
    ELSE IF  '${group}' == 'Premium/Supreme'
      click element  xpath=//*[@restriction-data-desc="Plus" and @value="12,73,89,2"]
      click element  xpath=//*[@restriction-data-desc="Regular" and @value="11,31,33,41,72,88,92"]
      click element  xpath=//*[@restriction-data-desc="Supreme Plus (Chevron Only)" and @value="71"]
    ELSE IF  '${group}' == 'Regular'
      click element  xpath=//*[@restriction-data-desc="Premium/Supreme" and @value="13,1,3,87,91"]
      click element  xpath=//*[@restriction-data-desc="Plus" and @value="12,73,89,2"]
      click element  xpath=//*[@restriction-data-desc="Supreme Plus (Chevron Only)" and @value="71"]
    ELSE IF  '${group}' == 'Supreme Plus (Chevron Only)'
      click element  xpath=//*[@restriction-data-desc="Premium/Supreme" and @value="13,1,3,87,91"]
      click element  xpath=//*[@restriction-data-desc="Plus" and @value="12,73,89,2"]
      click element  xpath=//*[@restriction-data-desc="Regular" and @value="11,31,33,41,72,88,92"]
    END
    Click Submit for Product Group

Click Submit for Product Group
    Wait Until Element Is Visible  xpath=//*[@restriction-data-desc="Premium/Supreme"]
    click element  //*[@id="overrideProductGroupFormButtons"]//button[@id="submit"]

Search For ${carrier} And Go to ${tab} Tab
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Wait Until Loading Spinners Are Gone
    Click On ${tab} Tab

Input ${customer_id} As Customer #
    Wait Until Element Is Visible  //*[@name="id"]
    Input Text  //*[@name="id"]  ${customer_id}

Click On Submit For Customer Search
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Searched ${customerId} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customerId}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customerId}"]
    Wait Until Loading Spinners Are Gone

Click On ${tab} Tab
    Wait Until Element Is Visible  //*[@id="${tab.replace(' ', '')}"]
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Card Search
    Input Text  //*[@name="cardNumber"]  ${card.card_num}
    Click Element  //*[@id="customerCardsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Card ${num}
    Wait Until Element Is Visible  //button[@class="cardNumber buttonlink" and text()=${num}]
    Click Element  //button[@class="cardNumber buttonlink" and text()=${num}]
    Wait Until Loading Spinners Are Gone