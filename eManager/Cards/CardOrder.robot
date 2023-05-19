*** Settings ***
Library  otr_model_lib.Models
Library  otr_robot_lib.ssh.PySSH  ${app_ssh_host}
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

*** Test Cases ***
Parkland Card order changes
    [Tags]    JIRA:ROCKET-267  JIRA:ROCKET-266  qtest:116256427  PI:14  API:Y
    [Setup]    Setup Parkland Carrier with Template
#    Log Carrier into eManager for Parkland
    Go to Select Program > Manage Cards > Card Order
    Select Card Type  143
    Verify Update to make generic for US and CANADA
    [Teardown]    Close Browser

Shell Navigator Card Order With Card Option CANADIAN LINEN DRIVER CARD
    [Tags]    JIRA:ATLAS-2210  qtest:117271565  PI:15
    [Setup]    Setup Shell Linens Hotstamp Carrier for Card Order 'CANADIAN LINEN DRIVER CARD'
    Log Carrier into eManager for Shell
    Go to Select Program > Manage Cards > Card Order
    Select Card Type 'CANADIAN LINEN DRIVER CARD'
    Verify Update to make generic for US and CANADA
    Complete Unique Card Info
    Save Card Order
    Confirm Order Status Is 'READY'
    Run File CPICardFile
    Confirm Order Status Is 'PROCESSING'

    [Teardown]    Close Browser

Shell Navigator Card Order With Card Option CANADIAN LINEN VEHICLE CARD
    [Tags]    JIRA:ATLAS-2210  qtest:117271565  PI:15
    [Setup]    Setup Shell Linens Hotstamp Carrier for Card Order 'CANADIAN LINEN VEHICLE CARD'
    Log Carrier into eManager for Shell
    Go to Select Program > Manage Cards > Card Order
    Select Card Type 'CANADIAN LINEN VEHICLE CARD'
    Verify Update to make generic for US and CANADA
    Complete Unique Card Info
    Save Card Order
    Confirm Order Status Is 'READY'
    Run File CPICardFile
    Confirm Order Status Is 'PROCESSING'

    [Teardown]    Close Browser

Parkland Second Line and Prompt Line change
    [Tags]    JIRA:ROCKET-267  qtest:117035092  PI:15  API:Y
    [Setup]    Setup Parkland Carrier with Template
    Verify V2 locations
    [Teardown]    Close Browser

Parkland Policy Section Moved and Use Infopool
    [Tags]    JIRA:ROCKET-267  qtest:117035259  PI:15  API:Y
    [Setup]    Setup Parkland Carrier with Template
    Order some cards V2
    Verify card order ship to country
    [Teardown]  Basic Teardown

Parkland V2 Policy Select
    [Tags]    JIRA:ROCKET-392 qtest:118993635  PI:15  API:Y
    [Setup]    Setup Parkland Carrier with Template
    Order some cards V2
    Verify card order ship to country
    Verify card order policy
    [Teardown]  Basic Teardown

Parkland Card Order for Canada
    [Tags]    JIRA:ROCKET-267  JIRA:ROCKET-345  qtest:117035363  PI:15  API:Y
    [Setup]    Setup Parkland Carrier with Template
    Order some cards
    Verify card order ship to country
    [Teardown]  Basic Teardown

*** Keywords ***
Setup Parkland Carrier for Card Order
    [Tags]    qtest
    [Documentation]  Use below sql in Mysql to get a list of parkland carriers that has logged into emanager
    ...    SELECT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]+$'
    ...    AND user_id BETWEEN 2500000 AND 2999999
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ...    ------------
    ...    in tch database find an active carrier from the list above sql
    ...    Select member_id from member where member_id in {list from above} and status = 'A'
    ...    ------------
    ...    Choose one of the above carriers and
    ...    Follow TC-4254 to add Card_Order permission to carrier if missing

    Get Into DB  MYSQL
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]+$'
    ...    AND user_id between 2500000 AND 2999999
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_user_id}  Evaluate  ${list["user_id"]}.__str__().replace('[','(').replace(']',')')
    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT DISTINCT member_id
    ...    FROM member
    ...    WHERE member_id IN ${list_user_id}
    ...    AND member_id NOT IN ('2500019', '2500058', '2500052', '2500000', '2500001', '2500381');
    # Find carrier with given query and set as suite variable
    ${carrier}    Find Carrier Variable    ${query}    member_id
    Set Suite Variable  ${carrier}
    # Ensure carrier has View/Update Cards permission
    Ensure Carrier has User Permission  ${carrier.id}  CARD_ORDER
    Get Card Type id  ${carrier.contracts[0].issuer_id}  WEX_NAF

Setup Parkland Carrier with Template
    [Tags]  qtest
    [Documentation]  find a carrier with an order template in Canada:
            ...  select o.carrier_id, o.policy, o.template_name
            ...  from ccb_card_orders o
            ...  join contact_audit c ON c.contact_audit_id = o.ship_to_id
            ...  where o.order_status = 'T'
            ...  and c.country = 'CA'
            ...  and o.issuer_id in
            ...  (select issuer_id from issuer_misc where issuer_group_id = 31)
            ...  order by o.created desc limit 1;
    ${sql}  catenate  select o.carrier_id, o.policy, o.ccb_card_order_id
            ...  from ccb_card_orders o
            ...  join contact_audit c ON c.contact_audit_id = o.ship_to_id
            ...  where o.order_status = 'T'
            ...  and c.country = 'CA'
            ...  and o.issuer_id in
            ...  (select issuer_id from issuer_misc where issuer_group_id = 31)
            ...  order by o.created desc limit 1;
    ${template}  query and strip to dictionary  ${sql}  db_instance=tch
    ${carrier_id}  catenate  ${template['carrier_id']}
    set test variable  ${carrier_id}
    set test variable  ${template}
    Ensure Carrier has User Permission  ${carrier_id}  CARD_ORDER_V2
    Add User Role If Not Exists  ${carrier_id}  CARD_ORDER_V2  menu_visible=1
    Open eManager  ${intern}  ${internPassword}
    Switch to "${carrier_id}" Carrier

Complete Unique Card Info
    ${header1}  Run Keyword And Continue On Failure  Get Text  //*/th[1]
    ${header2}  Run Keyword And Continue On Failure  Get Text  //*/th[2]
    IF  '${header1}'=='*Cardholder Name (One name per line)'
        Input Cardholder Name
    ELSE IF  '${header2}'=='*Cardholder Name (One name per line)'
        Input Cardholder Name
    END
    IF  '${header1}'=='*Vehicle ID (One ID per line)'
        Input Vehicle ID
    ELSE IF  '${header2}'=='*Vehicle ID (One ID per line)'
        Input Vehicle ID
    END
    IF  '${header2}'=='*VIN'
        Input VIN
    END
    IF  '${header1}'=='*Driver ID (One ID per line)'
        Input Driver ID
    ELSE IF  '${header2}'=='*Driver ID (One ID per line)'
        Input Driver ID
    END

Confirm Order Status Is '${status}'
    Get Order Status
    Should Be Equal As Strings  ${status}  ${orderStatus}

Get Card Type id
    [Arguments]    ${issuer}  ${card_issue_type}  ${db}=TCH
    ${sql}  catenate  select ccb_card_option_id from card_styles where issue_type = '${card_issue_type}' and card_style !=1008 and card_style in (select card_style from issuer_card_style where issuer_id = ${issuer}) order by card_style desc limit 1;
    ${cardtypeid}  query and strip  ${sql}  db_instance=${db}
    Set Test Variable  ${cardtypeid}

Get Order Status
    ${orderStatus}=  Get Text  //*[@id="row"]/tbody/tr/td[2]
    Set Test Variable  ${orderStatus}

Input Cardholder Name
    Double Click On  //*[@id="cspNameValue"]
    Input Text  //*[@id="cspNameValue"]  elRobot

Input Driver ID
    ${driverId}  Generate Random String  4
    Double Click On  //*[@id="cspDridValue"]
    Input Text  //*[@id="cspDridValue"]  ${driverID}

Input Vehicle ID
    ${vehicleId}  Generate Random String  4
    Double Click On  //*[@id="cspUnitValue"]
    Input Text  //*[@id="cspUnitValue"]  ${vehicleId}

Input VIN
    ${vin}  Generate Random String  9  [NUMBERS]
    Double Click On  //*[@id="cspVinValue"]
    Input Text  //*[@id="cspVinValue"]  ${vin}

Log Carrier into eManager for Shell
    Open eManager  ${carrier}  ${password}  ChangeCompanyHeader=False

Log Carrier into eManager for Parkland
    [Tags]    qtest
    [Documentation]  Login to emanager as carrier follow TC-1361

    Open eManager  ${carrier.id}  ${carrier.password}    ChangeCompanyHeader=False
    Change Company Header    ${carrier.id}    C    parkland_carrier

Go to Select Program > Manage Cards > Card Order
    [Tags]    qtest
    [Documentation]  Go to Select Program > Manage Cards > Card Order
    Go To  ${emanager}/cards/CardOrder.action?outputMode=V1

Run File CPICardFile
    execute command  /tch/run/CPICardFile.sh  sudo=${TRUE}
    Click Element  //*/input[@name='looupCardOrderBtn' and @value='Lookup Existing Card Order']
    Wait Until Element Is Visible  //*[@id="row"]/thead

Run FISCardFile
    execute command  /tch/run/FISCardFile.sh  sudo=${TRUE}
    Click Element  //*/input[@name='looupCardOrderBtn' and @value='Lookup Existing Card Order']
    Wait Until Element Is Visible  //*[@id="row"]/thead

Run PersonixFile
    execute command  /tch/run/PersonixFile.sh  sudo=${TRUE}
    Click Element  //*/input[@name='looupCardOrderBtn' and @value='Lookup Existing Card Order']
    Wait Until Element Is Visible  //*[@id="row"]/thead

Save Card Order
    Click Button  //*[@id='saveBtn']
    Wait Until Element Is Visible  //*[@id="ok"]
    Click Button  //*[@id="ok"]
    Wait Until Element Is Visible  //*[@id="CARDORDER"]

Select Card Type
    [Arguments]  ${cardtypeid}=${cardtypeid}
    [Tags]    qtest
    [Documentation]    Click on Card Type Dropdown and Select Desired Card Type
    Select From List By Value  codeIntSel  ${cardtypeid}
    Wait Until Page Contains  Create Card Order

Select Card Type '${cardType}'
    Select From List By Value  codeIntSel  ${cardTypeId}
    Wait Until Page Contains  Create Card Order

Setup Shell Linens Hotstamp Carrier for Card Order '${cardTypeName}'
    Get Into DB  SHELL
    ${query}  Catenate
    ...    SELECT *
    ...    FROM card_styles
    ...    WHERE name = '${cardTypeName}';
    ${result}  Query And Strip To Dictionary  ${query}
    Set Test Variable  ${member}  ${result["carrier_id"]}
    Set Test Variable  ${cardTypeId}  ${result["ccb_card_option_id"]}
    ${query}  Catenate
    ...    SELECT *
    ...    FROM member
    ...    WHERE member_id = ${member};
    ${list}  Query And Strip To Dictionary  ${query}
    Set Suite Variable  ${carrier}  ${list["member_id"]}
    Set Suite Variable  ${password}  ${list["passwd"]}

Verify Update to make generic for US and CANADA
    [Tags]    qtest
    [Documentation]    Look over page and verify US Postal Service does not appear but instead just Postal Service
    ...  should have State/Provice instead of just State
    Page Should Contain    State/Province:
    Page Should Contain    Zip/Postal Code:
    Page Should Contain    via Postal Service
    Page Should Not Contain    US Postal Service

Verify card order ship to country
    [Tags]  qTest
    [Documentation]  verify the country is listed as CA for the order:
                ...  select c.country
                ...  from contact_audit c
                ...  join ccb_card_orders o ON c.contact_audit_id = o.ship_to_id
                ...  where o.carrier_id = {carrier_id}
                ...  order by o.created desc limit 1;
    ${sql}  catenate  select c.country
                ...  from contact_audit c
                ...  join ccb_card_orders o ON c.contact_audit_id = o.ship_to_id
                ...  where o.carrier_id = ${carrier_id}
                ...  order by o.created desc limit 1;
    ${ship_to_country}  query and strip  ${sql}  db_instance=tch
    should be equal  ${ship_to_country}  CA

Verify card order policy
    [Tags]  qTest
    [Documentation]  verify the policy listed for the order:
                ...  select c.icardpolicy from ccb_cards c join ccb_card_orders o
                ...  ON c.ccb_card_order_id = o.ccb_card_order_id
                ...  where o.carrier_id = {carrier_id} order by o.created desc limit 1;
    ${sql}  catenate  select c.icardpolicy from ccb_cards c join ccb_card_orders o
                ...  ON c.ccb_card_order_id = o.ccb_card_order_id
                ...  where o.carrier_id = ${carrier_id} order by o.created desc limit 1;
    ${orderPolicy}  query and strip  ${sql}  db_instance=tch
    should be equal as numbers  ${orderPolicy}  ${template['policy']}

Order some cards
    [Tags]  qtest
    [Documentation]  Select Card Oder and choose a template. Enter any desired changes and click save.
    go to  ${emanager}/cards/CardOrder.action?outputMode=V1
    select from list by value  codeIntSel  ${template['ccb_card_order_id']}
    click button  saveBtn
    click button  ok
    wait until page contains  Card order successfully submitted

Order some cards V2
    [Tags]  qtest
    [Documentation]  Select Card Oder V2. Select Policy. Select card type or tempate. Verify use info pool
        ...  is checked by default.
    go to  ${emanager}/cards/CardOrder.action?outputMode=V2
    wait until element is enabled  contractPolicySel
    select from list by value  contractPolicySel  ${template['policy']}
    select from list by value  codeIntSel  ${template['ccb_card_order_id']}
    Checkbox Should Be Selected  infoPoolValue
    click button  saveBtn
    click button  ok
    wait until page contains  Card order successfully submitted

Verify V2 locations
    [Tags]  qtest
    [Documentation]  Select Card Oder V2. Select Policy. Select card type or tempate. Verify use info pool
        ...  is checked by default.
    go to  ${emanager}/cards/CardOrder.action?outputMode=V2
    wait until element is enabled  contractPolicySel
    select from list by value  contractPolicySel  ${template['policy']}
    select from list by value  codeIntSel  ${template['ccb_card_order_id']}
    Checkbox Should Be Selected  infoPoolValue
    click button  saveBtn
    click button  ok
    wait until page contains  Card order successfully submitted

Basic Teardown
    close browser
