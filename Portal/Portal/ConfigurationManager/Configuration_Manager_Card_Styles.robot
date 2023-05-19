*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Set Up Suite
Suite Teardown  Close Browser
Force Tags  Portal  Configuration Manager  weekly
Documentation  This is for the Card Styles creation functionality on Configuration Manager

*** Variables ***
${card_stock}  Portal Card Stock
${verified}  Y
${use_carrier_type}  N

*** Test Cases ***
Create a Card Style And Verify If The Data Is Properly Saved On Database
    [Tags]  JIRA:PORT-346  qTest:30810382  Regression
    ${list_card_items}=  Create a Card Style  1 - EFS Fleet & Cash  Portal Card Style P346
    ${card_order_type}  get from list  ${list_card_items}  0
    ${card_name}  get from list  ${list_card_items}  1
    Validate Card Style Information  ${card_order_type}  ${card_name}
    [Teardown]  Delete Card Style

*** Keywords ***
Create a Card Style
    [Arguments]  ${card_order_type}  ${card_name}
    Click Portal Button  Add
    Wait Until Done Processing
    Fill And Save Card Style Data  ${card_order_type}  ${card_name}
    @{list_card_items}  create list
    append to list  ${list_card_items}  ${card_order_type}  ${card_name}
    [Return]  ${list_card_items}

Fill And Save Card Style Data
   [Arguments]  ${card_order_type}  ${card_name}
   Wait Until Element Is Enabled  request.orderId  timeout=60
   Select From List By Label  request.orderId  ${card_order_type}
   Sleep  2
   Input Text  request.cardStyle.name  ${card_name}
   Input Text  request.cardStyle.cardStock  ${card_stock}
   Select From List By Value  request.cardStyle.verified  ${verified}
   Select From List By Value  request.cardStyle.useCarrierType  ${use_carrier_type}
   Sleep  2
   ${bin}=  Get Value  request.cardStyle.bin
   ${issue_type}=  Get Value  request.cardStyle.issueType
   Set Suite Variable  ${bin}
   Set Suite Variable  ${issue_type}
   Save
   Wait Until Done Processing

Get Card Style ID
    [Arguments]  ${card_name}
    Scroll Element Into View  xpath=//*[@id="cardStylesList"]//descendant::*[contains(text(),'${card_name}')]
    Click Element  xpath=//*[@id="cardStylesList"]//descendant::*[contains(text(),'${card_name}')]
    ${card_style_id}=  Get Text  xpath=//*[@id="cardStylesList"]//descendant::*[contains(text(),'${card_name}')]/parent::td/preceding-sibling::*[1]
    [Return]  ${card_style_id}

Validate Card Style Information
    [Arguments]  ${card_order_type}  ${card_name}
    ${card_style_id}=  Get Card Style ID  ${card_name}
    Validate Card Style Database Information  ${card_style_id}  ${card_name}
    Validate Card Style Options Database Information  ${card_style_id}

Validate Card Style Options Database Information
    [Arguments]  ${card_style_id}
    get into db  TCH
    ${query}  catenate
    ...  SELECT ccb_card_option_id, require_unique_last5_choices,
    ...  shipping_method_choices, cardpress_choices FROM ccb_style_options
    ...  WHERE card_style_id=${card_style_id}
    ${card_options}  Query And Strip To Dictionary  ${query}
    Should Not Be Empty  ${card_options['require_unique_last5_choices']}
    Should Not Be Empty  "${card_options['shipping_method_choices']}"
    Should Not Be Empty  "${card_options['cardpress_choices']}"
    Should Not Be Empty  "${card_options['ccb_card_option_id']}"

Validate Card Style Database Information
    [Arguments]  ${card_style_id}  ${card_name}
    get into db  TCH
    ${query}  catenate
    ...  SELECT card_stock, name, bin, issue_type, verified, use_carrier_type FROM card_styles
    ...  WHERE card_style=${card_style_id}
    ${card_styles}  Query And Strip To Dictionary  ${query}
    Should Be Equal  ${card_styles['card_stock']}  ${card_stock}
    Should Be Equal  ${card_styles['name']}  ${card_name}
    Should Be Equal  ${card_styles['bin']}  ${bin}
    Should Be Equal  ${card_styles['issue_type']}  ${issue_type}
    Should Be Equal  ${card_styles['verified']}  ${verified}
    Should Be Equal  ${card_styles['use_carrier_type']}  ${use_carrier_type}

Delete Card Style
    Click Portal Button  Delete
    Click Portal Button  Yes

Set Up Suite
    Open Browser to Portal
    Log Into Portal
    Select Portal Program  Configuration Manager
    Click Configuration Manager Link  Card Styles

Save
    wait until element is enabled  //*[@id="editcardStylesList_content"]/form/a[1]  timeout=60
    click element  //*[@id="editcardStylesList_content"]/form/a[1]