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
    [Tags]  JIRA:ROCKET-89  qTest:53559685  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Products Tab
    Remove GAS product if exists
    Click On Add Product Button
    Select GAS product from list
    Input 100 As Quanity
    Select WINDOW type from list
    Input 24 As Hours for Window
    Select Gas Groups for Parkland  Plus
    Click On Submit For adding product
    Verify Correct Products are added for Group  Plus
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - Regular
    [Tags]  JIRA:ROCKET-89  qTest:53559685  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Products Tab
    Remove GAS product if exists
    Click On Add Product Button
    Select GAS product from list
    Input 100 As Quanity
    Select WINDOW type from list
    Input 24 As Hours for Window
    Select Gas Groups for Parkland  Regular
    Click On Submit For adding product
    Verify Correct Products are added for Group  Regular
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - Premium/Supreme Group
    [Tags]  JIRA:ROCKET-89  qTest:53559685  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Products Tab
    Remove GAS product if exists
    Click On Add Product Button
    Select GAS product from list
    Input 100 As Quanity
    Select WINDOW type from list
    Input 24 As Hours for Window
    Select Gas Groups for Parkland  Premium/Supreme
    Click On Submit For adding product
    Verify Correct Products are added for Group  Premium/Supreme
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - Supreme Plus (Chevron Only)
    [Tags]  JIRA:ROCKET-89  qTest:53559685  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Products Tab
    Remove GAS product if exists
    Click On Add Product Button
    Select GAS product from list
    Input 100 As Quanity
    Select WINDOW type from list
    Input 24 As Hours for Window
    Select Gas Groups for Parkland  Supreme Plus (Chevron Only)
    Click On Submit For adding product
    Verify Correct Products are added for Group  Supreme Plus (Chevron Only)
    [Teardown]  Parkland Clean up

Parkland - Successfull Add Gas - All Group
    [Tags]  JIRA:ROCKET-89  qTest:53559685  PI:11
    [Setup]  Get Parkland Carrier
    Open Account Manager
    Search For ${parkland_carrier.member_id} And Go to Cards Tab
    Click On Submit For Card Search
    Click On Card ${card.card_num}
    Remove Card Override if exists
    Click On Products Tab
    Remove GAS product if exists
    Click On Add Product Button
    Select GAS product from list
    Input 100 As Quanity
    Select WINDOW type from list
    Input 24 As Hours for Window
    Select Gas Groups for Parkland  Supreme Plus (Chevron Only)
    Select Gas Groups for Parkland  Supreme Plus (Chevron Only)
    Click On Submit For adding product
    Verify Correct Products are added for Group  Premium/Supreme','Plus','Regular','Supreme Plus (Chevron Only)
    [Teardown]  Parkland Clean up

*** Keywords ***
Remove Card Override if exists
    Click On Overrides Tab
    ${cnt}  get element count  xpath=//button[text()="Remove Override"]
    IF  ${cnt}>0
        Click Element  //button[text()="Remove Override"]
    END

Parkland Clean up
    Remove GAS product if exists
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

Remove ${product} product if exists
    Click Element  //*[@id="cardProductsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone
    run keyword and ignore error  Wait Until Element Is Visible    //*[@id='DataTables_Table_0']  timeout=5
    wait until element is enabled  //*[@id="cardProductsSearchContainer"]
    ${cnt}  get element count  xpath=//*[@value="${product}" and @type="checkbox" and @class="id "]
    IF  ${cnt}>0
        click element  xpath=//*[@value="${product}" and @type="checkbox"]
        Click Element  //*[@id="cardProductsSearchContainer"]//span[text()="DELETE"]/parent::*
        Wait Until Element Is Visible  //button[@name="confirm"]
        Click Element  //button[@name="confirm"]
    END

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
    ${cardlimitsql}  catenate  select prod_num from card_lmt_prod where prod_num in (select num from products_gas_grouping_desc) and card_num ='${card.card_num}' order by prod_num desc
    FOR  ${i}  IN RANGE  5
        ${cardlimit}  query and strip to list  ${cardlimitsql}  db_instance=TCH
        exit for loop if  '${cardlimit}'!='None'
        sleep  1
    END
    ${grplimit}  query and strip to list  select num from products_gas_grouping_desc where description in ('${group}') order by num desc  db_instance=TCH
    should be equal  ${cardlimit}  ${grplimit}

Select Gas Groups for Parkland
    [Arguments]  ${group}
    Wait Until Element Is Visible  xpath=//*[@name="selectedProdRestGrp"]
    IF  '${group}' == 'Plus'
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="13,1,3,87,91"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="11,31,33,41,72,88,92"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="71"]
    ELSE IF  '${group}' == 'Premium/Supreme'
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="12,73,89,2"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="11,31,33,41,72,88,92"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="71"]
    ELSE IF  '${group}' == 'Regular'
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="13,1,3,87,91"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="12,73,89,2"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="71"]
    ELSE IF  '${group}' == 'Supreme Plus (Chevron Only)'
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="13,1,3,87,91"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="12,73,89,2"]
      click element  xpath=//*[@name="selectedProdRestGrp" and @value="11,31,33,41,72,88,92"]
    END

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
    Wait Until Element Is Visible  //*[@id="customerSearchContainer"]
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
    Wait Until Element Is Visible  //*[@name="cardNumber"]
    Input Text  //*[@name="cardNumber"]  ${card.card_num}
    Click Element  //*[@id="customerCardsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Card ${num}
    Wait Until Element Is Visible  //button[@class="cardNumber buttonlink" and text()=${num}]
    Click Element  //button[@class="cardNumber buttonlink" and text()=${num}]
    Wait Until Loading Spinners Are Gone

Click On Add Product Button
    Wait Until Element Is Visible  //*[@id="cardProductsSearchContainer"]//span[text()="ADD"]/parent::*
    Click Element  //*[@id="cardProductsSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Loading Spinners Are Gone

Select ${product} product from list
    Wait Until Element Is Visible  //*[@name="productSummary.productCode"]
    Select From List By Value  //select[@name="productSummary.productCode"]  ${product}

Input ${qty} As Quanity
    Wait Until Element Is Visible  //*[@name="productSummary.quantity"]
    Input Text  //*[@name="productSummary.quantity"]  ${qty}

Select ${type} type from list
    Wait Until Element Is Visible  //*[@name="productSummary.type"]
    Select From List By Value  //select[@name="productSummary.type"]  ${type}

Input ${hours} As Hours for Window
    Wait Until Element Is Visible  //*[@name="productSummary.timeWindow"]
    Input Text  //*[@name="productSummary.timeWindow"]  ${hours}

Click On Submit For adding product
    Wait Until Element Is Visible  //*[@id="cardProductsAddUpdateFormButtons"]
    Click Element  //*[@id="cardProductsAddUpdateFormButtons"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone
