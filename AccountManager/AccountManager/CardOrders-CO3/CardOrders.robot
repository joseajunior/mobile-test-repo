*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH   ${app_ssh_host}
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Variables ***
${carrier}

*** Test Cases ***
EFS Fleet Card Order
    [Tags]  JIRA:BOT-417  JIRA:BOT-1526  JIRA:BOT-2835  qTest:32694669  qTest:32034042  qTest:32034461  Regression  refactor
    [Setup]  Get Carrier to Order a Card  140186  TCH

    Open Account Manager
    Select Customers Tab
    Input ${carrier} as Customer #
    Click on Submit Button
    Click On Searched ${carrier} Carrier
    Click On Card Orders Tab
    Click On Add Button
    Select 'EFS Fleet & Cash' Card Option
    Submit Card Order
    Select 'No Prompts' As Prompt Type
    Click On Continue Button For Order Info
    Click On Continue Button For Unique Card Info
    Complete Shipping Page
    Click On Submit For Shipping Card Order
    Get Order Number
    Click On Continue Button For Summary Detail
    Verify Order Status Is Ready
    Run File To Process The Card Order
    Verify Order Status Is Processing
    Get a New Created Card
    Run Transaction On New Card  ${card}  231010  ULSD

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Sent to Yes And Created To Today
    ...  AND  Set ${card} Card Status to Delete

Shell Fleet Card Order
    [Tags]  JIRA:BOT-417  JIRA:BOT-1527  JIRA:BOT-2835  JIRA:BOT-1529  qTest:32695277  Regression  refactor
    [Setup]  Get Carrier to Order a Card  132846  SHELL

    Open Account Manager
    Select Customers Tab
    Input ${carrier} as Customer #
    Click on Submit Button
    Click On Searched ${carrier} Carrier
    Click On Card Orders Tab
    Click On Add Button
    Select 'Shell Light Fleet' Card Option
    Submit Card Order
    Select 'No Prompts' As Prompt Type
    Click On Continue Button For Order Info
    Click On Continue Button For Unique Card Info
    Complete Shipping Page
    Click On Submit For Shipping Card Order
    Get Order Number
    Click On Continue Button For Summary Detail
    Verify Order Status Is Ready
    Run File To Process The Card Order
    Verify Order Status Is Processing
    Get a New Created Card
    Run Transaction On New Card  ${card}  515614  OIL

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Sent to Yes And Created To Today
    ...  AND  Set ${card} Card Status to Delete

Shell Fleet Card Order With Prompts And Product Restrictions - Shell Fleet Navigator Driver Card Card Option
    [Tags]  JIRA:BOT-915  JIRA:BOT-1528  JIRA:BOT-2835  qTest:32699917  Regression  refactor
    [Documentation]  This test case is responsible for ordering the cards on Account Manager.
    ...     For that you have to login on Acc Manager, under the customer tab, search and select6 the carrier
    ...     Go to the "Card Orders" tab > ADD and Place one order for each of the MasterCard options.
    [Setup]  Set 600000 As Carrier and 319311 As Contract And SHELL As Database For The Test

    Ordering Card on Account Manager  Shell Fleet Navigator Driver Card  Cardholder and Odometer
    Running CardOrder File And Setting Up New Card
    Check UI For New Card Status  ${card}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Status to Delete

Shell Fleet Card Order With Prompts And Product Restrictions - Shell Fleet Navigator Driver Card Fuel Locations Only Card Option
    [Tags]  JIRA:BOT-915  JIRA:BOT-1528  JIRA:BOT-2835  qTest:32699917  Regression  refactor
    [Setup]  Set 600000 As Carrier and 319311 As Contract And SHELL As Database For The Test

    Ordering Card on Account Manager  Shell Fleet Navigator Driver Card Fuel Locations Only  Vehicle # and Odometer
    Running CardOrder File And Setting Up New Card
    Check UI For New Card Status  ${card}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Status to Delete

Shell Fleet Card Order With Prompts And Product Restrictions - Shell Fleet Navigator Vehicle Card Card Option
    [Tags]  JIRA:BOT-915  JIRA:BOT-1528  JIRA:BOT-2835  qTest:32699917  Regression  refactor
    [Setup]  Set 600000 As Carrier and 319311 As Contract And SHELL As Database For The Test

    Ordering Card on Account Manager  Shell Fleet Navigator Vehicle Card  Odometer
    Running CardOrder File And Setting Up New Card
    Check UI For New Card Status  ${card}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Status to Delete

Shell Fleet Card Order With Prompts And Product Restrictions - Shell Fleet Navigator Vehicle Card Fuel Locations Only Card Option
    [Tags]  JIRA:BOT-915  JIRA:BOT-1528  JIRA:BOT-2835  qTest:32699917  Regression  refactor
    [Setup]  Set 600000 As Carrier and 319311 As Contract And SHELL As Database For The Test

    Ordering Card on Account Manager  Shell Fleet Navigator Vehicle Card Fuel Locations Only  No Prompts
    Running CardOrder File And Setting Up New Card
    Check UI For New Card Status  ${card}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Status to Delete

Shell Navigator Card Order With Card Option EVO VEHICLE CARD
    [Tags]  JIRA:FRNT-2067  qTest:12273
    [Setup]  Set 600003 As carrier And 319316 As Contract And SHELL As Database For The Test

    Open Account Manager
    Select Customers Tab
    Input ${carrier} as Customer #
    Click on Submit Button
    Click On Searched ${carrier} Carrier
    Click On CO3 Tab
    Click On CO3 Add Button
    Select CO3 'EVO VEHICLE CARD' Card Option
    Submit CO3 Card Order
    ${promptType}  Get Text  //*[@id="co3OrderInfoActionForm"]//option[@value="2"]
    Select '${promptType}' As Prompt Type
    Click On CO3 Continue Button For Order Info
    Complete Unique Card Info Page
    You Should Not See Any Message On Data Entry Required for CO3
    Click On CO3 Continue Button For Unique Card Info
    Complete Shipping Page
    Click On CO3 Submit For Shipping Card Order
    Get CO3 Order Number
    Click On CO3 Continue Button For Summary Detail
    Verify CO3 Order Status Is Ready
    Run File CPICardFile
    Verify CO3 Order Status Is Processing
    Get a New Created Card

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Sent to Yes And Created To Today
    ...  AND  Set ${card} Card Status to Delete

Shell Navigator Card Order With Card Option CANADIAN LINEN DRIVER CARD
    [Tags]  JIRA:FRNT-2210  qTest:117271564  PI:15
    [Setup]  Set 600003 As carrier And 319316 As Contract And SHELL As Database For The Test

    Open Account Manager
    Select Customers Tab
    Input ${carrier} as Customer #
    Click on Submit Button
    Click On Searched ${carrier} Carrier
    Click On CO3 Tab
    Click On CO3 Add Button
    Select CO3 'CANADIAN LINEN DRIVER CARD' Card Option
    Submit CO3 Card Order
    ${promptType}  Get Text  //*[@id="co3OrderInfoActionForm"]//option[@value="2"]
    Select '${promptType}' As Prompt Type
    Click On CO3 Continue Button For Order Info
    Complete Unique Card Info Page
    You Should Not See Any Message On Data Entry Required for CO3
    Click On CO3 Continue Button For Unique Card Info
    Complete Shipping Page
    Click On CO3 Submit For Shipping Card Order
    Get CO3 Order Number
    Click On CO3 Continue Button For Summary Detail
    Verify CO3 Order Status Is Ready
    Run File CPICardFile
    Verify CO3 Order Status Is Processing
    Get a New Created Card

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Sent to Yes And Created To Today
    ...  AND  Set ${card} Card Status to Delete

Shell Navigator Card Order With Card Option CANADIAN LINEN VEHICLE CARD
    [Tags]  JIRA:FRNT-2210  qTest:117271564  PI:15
    [Setup]  Set 600003 As carrier And 319316 As Contract And SHELL As Database For The Test

    Open Account Manager
    Select Customers Tab
    Input ${carrier} as Customer #
    Click on Submit Button
    Click On Searched ${carrier} Carrier
    Click On CO3 Tab
    Click On CO3 Add Button
    Select CO3 'CANADIAN LINEN VEHICLE CARD' Card Option
    Submit CO3 Card Order
    ${promptType}  Get Text  //*[@id="co3OrderInfoActionForm"]//option[@value="2"]
    Select '${promptType}' As Prompt Type
    Click On CO3 Continue Button For Order Info
    Complete Unique Card Info Page
    You Should Not See Any Message On Data Entry Required for CO3
    Click On CO3 Continue Button For Unique Card Info
    Complete Shipping Page
    Click On CO3 Submit For Shipping Card Order
    Get CO3 Order Number
    Click On CO3 Continue Button For Summary Detail
    Verify CO3 Order Status Is Ready
    Run File CPICardFile
    Verify CO3 Order Status Is Processing
    Get a New Created Card

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Set ${card} Card Sent to Yes And Created To Today
    ...  AND  Set ${card} Card Status to Delete

DELETE Button Functions On All Tabs Of Card Order Creation
    [Tags]  JIRA:FRNT-2247  qTest:117489481  PI:15
    [Setup]  Set 600003 As carrier And 319316 As Contract And SHELL As Database For The Test

    Open Account Manager
    Select Customers Tab
    Input ${carrier} as Customer #
    Click on Submit Button
    Click On Searched ${carrier} Carrier
    Click On CO3 Tab
    Create Card Order And Cancel On Order Info Tab
    Create Card Order And Cancel On Unique Card Info Tab
    Create Card Order And Cancel On Shipping Tab
    Create Card Order And Cancel On Summary Detail Tab

    [Teardown]  Close Browser

CardOrder Template Changes - AM
    [Tags]  JIRA:ROCKET-340   qTest:117709884   PI:15  API:Y
    [Setup]  Run Keywords    Get a Parkland Carrier

    Open Account Manager
    Select Customers Tab
    Input ${carrier.id} as Customer #
    Input 'Parkland' as Business Partner
    Click on Submit Button
    Click On Searched ${carrier.id} Carrier
    Add Policy With 'PolicyROBOT' As Policy Name And a Random Contract
    Click on CO3 Tab
    Click On CO3 Add Button
    Select CO3 '7 - EFS WEX NAF Fleet & Cash Card' Card Option
    Submit CO3 Card Order
    Select '${iPolicy}' As Policy Value
    Add 'ROBOT TEST' as Second Line Embossing
    Click On CO3 Continue Button For Order Info
    Click On CO3 Continue Button For Unique Card Info
    Complete Shipping Page
    Click On CO3 Submit For Shipping Card Order
    Get CO3 Order Number
    Click On CO3 Save As Template Button For Summary Detail
    Add 'ROBOT TEMPLATE' as Template Name
    Click On Submit For Save As Template

    Click on CO3 Tab
    Click On CO3 Add Button
    Select CO3 '${templateName}' Card Option
    Submit CO3 Card Order
    Verify '${iPolicy}' As Policy Value

    [Teardown]  Run Keywords  Run Keyword And Ignore Error    Delete Created Policy
    ...    AND    Run Keyword And Ignore Error    Delete Created Template
    ...    AND    Close Browser


CardOrder Prompt Type Needs To Be Driver ID and Odometer for Parkland
    [Tags]  JIRA:ROCKET-366   qTest:118109579   PI:15  API:Y
    [Setup]  Run Keywords    Get a Parkland Carrier
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
    Verify Prompt Type As 'Driver ID and Odometer'
    [Teardown]  Run Keywords     Close Browser

CardOrder Unique Card Info Tab Should Not Accept Invalid Policy
    [Tags]  JIRA:ROCKET-366   qTest:118109568   PI:15  API:Y
    [Setup]  Run Keywords    Get a Parkland Carrier

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
    Click On CO3 Continue Button For Order Info
    Add An Invalid Policy Value
#    Check Error Message
    Try to Continue Order and Expect Error
    [Teardown]   Close Browser

Prompt Value stores correctly after change
    [Tags]  JIRA:ROCKET-374   PI:15  API:Y  qtest:118871486
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
    Click On CO3 Continue Button For Order Info
    ${value}  Input 'drid' Prompt
    Remove 'drid' Prompt
    Click On CO3 Continue Button For Unique Card Info
    Complete Shipping Page
    Click On CO3 Submit For Shipping Card Order
    Get CO3 Order Number
    Click On CO3 Continue Button For Summary Detail
    Verify 'DRID' is not '${value}'

    [Teardown]   Close Browser

Second and third line embossing send to ccb_card_misc
    [Tags]  JIRA:ROCKET-341  qtest:117761974  API:Y  PI:15
    [Setup]  Setup Parkland Carrier with Template
    Start card order for Parkland carrier
    Enter Order Info for Parkland order
    Verify CO3 Order Status Is Ready
    Check embossing lines  ${carrier_id}  test2  test3

    [Teardown]  Close Browser

*** Keywords ***
Activate New Created Card ${card}
    Get Into Db  ${DB}
    Execute SQL String  dml=UPDATE cards SET status = 'A', lmtsrc = 'C' WHERE card_num = '${card}'

Check If ${field} Field Is ${value}
    Check Element Exists  text=${field}
    ${ProductRestrictions.strip()}  Get Text  //label[@for='detailRecord.mcProduct']/parent::td/following-sibling::td
    Should Be Equal As Strings  ${ProductRestrictions.strip()}  ${value}

Check UI For New Card Status
    [Arguments]  ${card}
    Activate New Created Card ${card}
    Click On Cards Tab
    Input ${card} As Card Number
    Click On Submit For Card Search
    You Should See The Searched Card ${card} With Status to Active

Click On Add Button
    Wait Until Element Is Visible  //*[@id="ToolTables_DataTables_Table_0_1"]
    Click Element  //*[@id="ToolTables_DataTables_Table_0_1"]

Click On CO3 Add Button
    Wait Until Element Is Visible  //*[@id="customerCardOrders3SearchContainer"]//span[contains(text(), "ADD")]
    Click On  //*[@id="customerCardOrders3SearchContainer"]//span[contains(text(), "ADD")]

Click On Card Orders Tab
    Click Element  //*[@id="CardOrders2"]

Click on CO3 Tab
    Wait Until Element Is Visible  //*[@id="CardOrders3"]
    Click Element  //*[@id="CardOrders3"]

Click On CO3 CONFIRM Button '${tab}'
    Wait Until Element Is Visible  //*[@id="co3${tab}DeleteDialogContainer"]//*/button[@name="cancel"]
    Click On  //*[@id="co3${tab}DeleteDialogContainer"]//*/button[@name="confirm"]

Click On Cards Tab
    Click Element  //*[@id="Cards"]
    Wait Until Load Screen Icon Disappear From Screen

Click On Continue Button For Order Info
    Wait Until Element Is Visible  //*[@id="co2OrderInfoFormButtons"]/button[@id="submit" and contains(text(), "CONTINUE")]
    Click Element  //*[@id="co2OrderInfoFormButtons"]/button[@id="submit" and contains(text(), "CONTINUE")]

Click On CO3 Continue Button For Order Info
    Wait Until Element Is Visible  //*[@id="orderInfo"]
    Click Button  CONTINUE
    Wait Until Load Screen Icon Disappear From Screen

Click On Continue Button For Summary Detail
    Click Element  //*[@id="co2SummaryFormButtons"]/button[@id="submit" and contains(text(), "CONTINUE")]
    Wait Until Load Screen Icon Disappear From Screen

Click On CO3 Continue Button For Summary Detail
    Wait Until Element Is Visible   //*[@id="summary"]
    Click Element   //*[@id="summary"]
    Wait Until Load Screen Icon Disappear From Screen

Click On CO3 Save As Template Button For Summary Detail
    Wait Until Element Is Visible   //*[@name="saveAsTemplate"]
    Click Element    //*[@name="saveAsTemplate"]
    Wait Until Load Screen Icon Disappear From Screen

Click On Submit For Save As Template
    Wait Until Element Is Visible   //button[@id="submit" and contains(text(), 'Submit')]
    Click Element   //button[@id="submit" and contains(text(), 'Submit')]
    Wait Until Load Screen Icon Disappear From Screen

Complete Unique Card Info Page
    Wait Until Element Is Visible  //*[@id='unit_0']
    ${header1}  Run Keyword And Continue On Failure  Get Text  //*[@id='header1']
    ${header2}  Run Keyword And Continue On Failure  Get Text  //*[@id='header2']
    ${header3}  Run Keyword And Continue On Failure  Get Text  //*[@id='header3']
    IF  '${header1}'=='Cardholder Name'
        Input Cardholder Name
    ELSE IF  '${header2}'=='Cardholder Name'
        Input Cardholder Name
    END
    IF  '${header1}'=='Vehicle ID'
        Input Vehicle ID
    ELSE IF  '${header2}'=='Vehicle ID'
        Input Vehicle ID
    END
    IF  '${header2}'=='VIN'
        Input VIN
    ELSE IF  '${header3}'=='VIN'
        Input VIN
    END

Click On Continue Button For Unique Card Info
    Wait Until Element Is Visible  //*[@id="co2UniqueInfoFormButtons"]/button[@id="submit" and contains(text(), "CONTINUE")]
    Click Element  //*[@id="co2UniqueInfoFormButtons"]/button[@id="submit" and contains(text(), "CONTINUE")]

Click On CO3 Continue Button For Unique Card Info
    Wait Until Element Is Visible  //*[@id="uniqueInfo"]
    Click Button  //*[@id="uniqueInfo"]
    Wait Until Load Screen Icon Disappear From Screen

Click On Delete Button
    Wait Until Element Is Enabled  //span[text()='DELETE']/parent::*
    Click Element  //span[text()='DELETE']/parent::*

Click On CO3 DELETE Button '${tab}'
    Wait Until Element Is Enabled  //*[@id="co3${tab}"]//button[@name="delete"]
    Click Element  //*[@id="co3${tab}"]//button[@name="delete"]

Click On Records To Go Back to Account Manager
    Click Element  //label[text()='Records']

Click On Searched ${number} Carrier
    Click Element  //*[@class="id buttonlink" and contains(text(), '${number}')]

Click On Stop Processing Button
    Wait Until Element Is Enabled  //span[text()='STOP PROCESSING']/parent::*
    Click Element  //span[text()='STOP PROCESSING']/parent::*

Click On Submit Button
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Load Screen Icon Disappear From Screen

Click On Submit For Card Search
    Click Element  //*[@id="customerCardsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Load Screen Icon Disappear From Screen

Click On Submit For Order Search
    Click Element  //*[@id="customerCardOrders2SearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Load Screen Icon Disappear From Screen

Click On CO3 Submit For Order Search
    Click Element  //*/div[1]/button[1]
    Wait Until Load Screen Icon Disappear From Screen

Click On Submit For Shipping Card Order
    Click Element  //*[@id="co2ShippingFormButtons"]/button[@id="submit"]
    Wait Until Load Screen Icon Disappear From Screen

Click On CO3 Submit For Shipping Card Order
    Wait Until Element Is Enabled  //*[@id="shipping"]
    Click Button  Submit
    Wait Until Load Screen Icon Disappear From Screen

Complete Shipping Page
    Input EL As First Name
    Input ROBOT As Last Name
    Input 1104 COUNTRY HILLS DR As Adress
    Input OGDEN As City
    Select United States As Country
    Select UT As State/Province
    Input 84403 As Postal Code

Confirm Card Delete
    Click Element  //*[@id="customerCardOrders2DeleteDialogContainer"]//button[text()="Confirm"]
    You Should See a Delete Successful Message

Confirm Stop Order Processing
    Click Element  //*[@id="customerCardOrders2StopOrderDialogContainer"]//button[text()="Confirm"]
    You Should See a Order Processing Stopped Message

Create Card Order And Cancel On Order Info Tab
    Start Card Order
    Click On CO3 DELETE Button 'OrderInfoFormButtons'
    Click On CO3 CONFIRM Button 'OrderInfo'

Create Card Order And Cancel On Unique Card Info Tab
    Start Card Order
    Click Element  //*[@id="orderInfo"]
    Click On CO3 DELETE Button 'UniqueInfoFormButtons'
    Click On CO3 CONFIRM Button 'UniqueInfo'

Create Card Order And Cancel On Shipping Tab
    Start Card Order
    Click On CO3 Continue Button For Order Info
    Complete Unique Card Info Page
    You Should Not See Any Message On Data Entry Required for CO3
    Click On CO3 Continue Button For Unique Card Info
    Click On CO3 DELETE Button 'ShippingActionForm'
    Click On CO3 CONFIRM Button 'Shipping'

Create Card Order And Cancel On Summary Detail Tab
    Start Card Order
    Click On CO3 Continue Button For Order Info
    Complete Unique Card Info Page
    You Should Not See Any Message On Data Entry Required for CO3
    Click On CO3 Continue Button For Unique Card Info
    Complete Shipping Page
    Click On CO3 Submit For Shipping Card Order
    Click On CO3 DELETE Button 'SummaryActionFormContainer'
    Click On CO3 CONFIRM Button 'Summary'

Create Log Directory If It Doesn't Exist.
    go sudo
    ${date}=  getdatetimenow  %Y%m%d
    ${month}=  getdatetimenow  %m
    ${date}=  get substring  ${date}  2
    ${time}=  getdatetimenow  %H%M%S
    ${authDir}=  catenate
    ...  /home/qaauto/el_robot/authStrings/rossAuthLogs/NewCards/${month}
    run command  if [ ! -d ${authDir} ];then mkdir -p ${authDir};fi
    run command  find ${authDir} -type f -name '*' -mtime +365 -exec rm {} \\;

    ${cardOrderDir}=  catenate
    ...  /home/qaauto/el_robot/cardOrders/${month}
    run command  if [ ! -d ${cardOrderDir} ];then mkdir -p ${cardOrderDir};fi
    run command  find ${cardOrderDir} -type f -name '*' -mtime +365 -exec rm {} \\;

    run command  cd /home/qaauto/el_robot/authStrings

    set test variable  ${cardOrderLog}  ${cardOrderDir}/AccountManager_${TEST NAME.replace(' ', '_')}_${date}${time}
    set test variable  ${authLog}  ${authDir}/newCardTrans_${TEST NAME.replace(' ', '_')}_${date}${time}

Create New Limit For ${card} On DB For Limit ID ${limit_id}
    execute sql string
       ...  insert into card_lmt (card_num, limit_id, limit, hours) values ('${card}', '${limit_id}', 9999, 1)

Delete Possible Old Limit For ${card} On DB For Limit ID ${limit_id}
    Execute SQL String  dml=DELETE from card_lmt where card_num = '${card}' and limit_id = '${limit_id}'

Get a New Created Card
    ${today}=  getDateTimeNow  %Y-%m-%d
    Get Into Db  ${DB}
    ${query}=  Catenate  SELECT * FROM cards WHERE carrier_id = ${carrier} AND TO_CHAR(created, '%Y-%m-%d') = '${today}' ORDER BY card_num desc LIMIT 1;
    ${data}=  Query And Strip To Dictionary  ${query}

    Set Test Variable  ${card}  ${data["card_num"].strip()}

Get Carrier to Order a Card
    [Arguments]  ${issuer}  ${DB}=TCH
    Get Into DB  ${DB}
    ${query}  Catenate
    ...  SELECT
    ...     member_id AS carrier,
    ...     c.contract_id AS contract
    ...  FROM member m
    ...     INNER JOIN contract c ON (c.carrier_id=m.member_id)
    ...  WHERE c.status='A'
    ...  AND m.status='A'
    ...  AND c.issuer_id='${issuer}'
    ...  LIMIT 1
    ${return}  Query and Strip to Dictionary  ${query}

    Set Test Variable  ${carrier}  ${return["carrier"]}
    Set Test Variable  ${contract}  ${return["contract"].__str__()}
    Set Test Variable  ${DB}
    Update Contract Limits  ${contract}
    Disconnect From Database

Get a Parkland Carrier
    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT distinct m.member_id
       ...    FROM member m
       ...    INNER JOIN cards c
       ...    ON c.carrier_id = m.member_id
       ...    INNER JOIN member_meta meta
       ...    ON meta.member_id = m.member_id
       ...    WHERE mem_type = 'C'
       ...    AND m.status = 'A'
       ...    AND m.member_id BETWEEN 2500000 AND 2999999
       ...    AND meta.mm_key = 'NAF_ORG_ID';
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_member_id}  Get From Dictionary  ${list}  member_id
    ${list_member_id}  Evaluate  ${list_member_id}.__str__().replace('[','(').replace(']',')')
    Get Into DB  MYSQL
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]+$'
    ...    AND user_id IN ${list_member_id}
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_user_id}  Get From Dictionary  ${list}  user_id
    ${list_user_id}  Evaluate  ${list_user_id}.__str__().replace('[','(').replace(']',')')
    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT DISTINCT member_id
    ...    FROM member
    ...    WHERE member_id IN ${list_user_id}
    ...    AND member_id NOT IN ('2500019', '2500058', '2500052', '2500000', '2500001');
    # Find carrier with given query and set as suite variable
    ${carrier}    Find Carrier Variable    ${query}    member_id
    Set Suite Variable  ${carrier}

Get Order Number
    ${orderNumber}=  Get Text  //*[@id="co2SummaryActionForm"]//*[text() = "Order #"]/parent::*[1]/following-sibling::*[1]
    Set Test Variable  ${orderNumber}

Get CO3 Order Number
    ${orderNumber}=  Get Text  //*[@id="co3SummaryActionForm"]/table/tbody/tr[2]/td/table[3]/tbody/tr[1]/td[2]
    Set Test Variable  ${orderNumber}

Get Order Status
    ${orderStatus}=  Get Text  //*[text()="${orderNumber}"]/parent::*/following-sibling::*[3]
    Set Test Variable  ${orderStatus}

Input ${adress} As Adress
    Input Text  //*[@id="address1"]  ${adress}

Input ${cardNumber} As Card Number
    Input Text  //*[@name="cardNumber"]  ${cardNumber}

Input ${city} As City
    Input Text  //*[@id="city"]  ${city}

Input ${id} As Customer #
    Input Text  id  ${id}

Input '${business_partner}' as Business Partner
    Wait Until Element Is Visible    //thead/tr[3]/th[1]/select[1]
    Select From List By Label  //thead/tr[3]/th[1]/select[1]   ${business_partner}

Input ${firstName} As First Name
    Wait Until Element Is Visible  //*[@id="firstName"]
    Input Text  //*[@id="firstName"]  ${firstName}

Input ${lastName} As Last Name
    Input Text  //*[@id="lastName"]  ${lastName}

Input ${orderNumber} As Order #
    Input Text  ccbCardOrderId  ${orderNumber}

Input ${postalCode} As Postal Code
    Input Text  //*[@id="postalCode"]  ${postalCode}

Input ${value} As Vehicle ID Field
    Input Text  //*/tbody/tr[2]/td/fieldset/div/div[1]/div/div/div/table/tbody/tr/td[2]  ${value}

Input ${vin} As Unique VIN Field
    Input Text  //*[@id="co2UniHG"]/div[1]/div/div/div/table/tbody/tr/td[3]  ${vin}

Input a Random Number As Unique Cardholder Name Field
    Wait Until Element Is Visible  //*[@id="co2UniHG"]/div[1]/div/div/div/table/tbody/tr/td[2]  timeout=10
    ${prompt}  Generate Random String  4  [NUMBERS]
    Input Text  //*[@id="co2UniHG"]/div[1]/div/div/div/table/tbody/tr/td[2]  ${prompt}

Input Cardholder Name
    Double Click On  //*[@id='name_0']
    Input Text  //*[@id='co3ugrid']/div[5]/textarea  elRobot

Input Vehicle ID
    ${vehicleId}  Generate Random String  4
    Double Click On  //*[@id='unit_0']
    Input Text  //*[@id="co3ugrid"]/div[5]/textarea  ${vehicleId}

Input VIN
    ${vin}  Generate Random String  9  [NUMBERS]
    Double Click On  //*[@id="vin_0"]
    Input Text  //*[@id="co3ugrid"]/div[5]/textarea  ${vin}

Input '${prompt}' Prompt
    Wait Until Element Is Visible  //*[@id="${prompt}_0"]
    ${rdm}  Generate Random String  5  [NUMBERS]
    Double Click On  //*[@id="${prompt}_0"]
    Input Text  //*[@id="co3ugrid"]/div[5]/textarea  ${rdm}
    [Return]    ${rdm}

Remove '${prompt}' Prompt
    Double Click On  //*[@id="${prompt}_0"]
    Input Text  //*[@id="co3ugrid"]/div[5]/textarea  ${EMPTY}

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Ordering Card on Account Manager
    [Arguments]  ${cardOption}  ${promptType}
    Open Account Manager
    Select Customers Tab
    Input ${carrier} as Customer #
    Click on Submit Button
    Click On Searched ${carrier} Carrier
    Click On Card Orders Tab
    Click On Add Button
    Select '${cardOption}' Card Option
    Submit Card Order
    Select '${promptType}' As Prompt Type
    Click On Continue Button For Order Info
    Input a Random Number As Unique Cardholder Name Field
    Input 1234 As Vehicle ID Field
    You Should Not See Any Message On Data Entry Required
    Click On Continue Button For Unique Card Info
    Complete Shipping Page
    Click On Submit For Shipping Card Order
    Get Order Number
    Click On Continue Button For Summary Detail
    Verify Order Status Is Ready

Run File CPICardFile
    execute command  /tch/run/CPICardFile.sh  sudo=${TRUE}

Run FISCardFile
    execute command  /tch/run/FISCardFile.sh  sudo=${TRUE}

Run PersonixFile
    execute command  /tch/run/PersonixFile.sh  sudo=${TRUE}

Run Transaction On New Card
    [Arguments]  ${card}  ${location}  @{products}
    Get Into DB  ${DB}

    Create Log Directory If It Doesn't Exist.

    ${transProducts}=  create list
    Activate New Created Card ${card}
    Update Limit  ${carrier}
    FOR  ${product}  IN  @{products}
        Delete Possible Old Limit For ${card} On DB For Limit ID ${product}
        Create New Limit For ${card} On DB For Limit ID ${product}
        append to list  ${transProducts}  ${product}=50.00
    END
    ${ac}=  Create AC String  ${DB}  ${location}  ${card}  @{transProducts}
    run rossAuth  ${ac}  ${authLog}
    ${transId}=  get transaction id from log file  ${authLog}
    run keyword if  '${transId}'=='${empty}'  fail  Transaction unsuccessful.

Running CardOrder File And Setting Up New Card
    Run File To Process The Card Order
    Verify If Order Status Is Processing Or Shipped
    Get a New Created Card
    Set ${card} Card Sent to Yes And Created To Today

Select '${prompt_type}' As Prompt Type
    Wait Until Element Is Visible    //select[@name="detailRecord.promptCode"]
    Select From List By Label  detailRecord.promptCode  ${prompt_type}

Select ${state} As State/Province
    Select From List By Value  //*[@id="stateSelect"]  ${state}

Select '${card_type}' Card Option
    ${card_value}=  get value  //*[@*="cardOrder2Detail.ccbCardOptionId"]/*[contains(text(), "${card_type}")]
    Select From List By Value  cardOrder2Detail.ccbCardOptionId  ${card_value}

Select CO3 '${card_type}' Card Option
    Wait Until Element Is Visible  //*[@id="cardOrder3AddActionForm"]//*/select
    ${card_value}=  get value  //*[@id="cardOrder3AddActionForm"]//*[contains(text(), "${card_type}")]
    Select From List By Value  cardOrder3Detail.ccbCardOptionId  ${card_value}

Select '${policy}' As Policy Value
    Wait Until Element Is Visible  //*[@name="detailRecord.policy"]
    Select From List By Value  detailRecord.policy   ${policy}

Select Card Order
    Click Element  //input[@type="checkbox" and @value="${orderNumber}"]

Select Customers Tab
    click element  //*[@id="Customer"]
    Wait Until Load Screen Icon Disappear From Screen

Select EFS Fleet with Smart Funds Card Option
    Select From List By Value  cardOrder2Detail.ccbCardOptionId  2

Select United States As Country
    Select From List By Value  //*[@id="countrySelect"]   US
    Wait Until Page Contains    AK Alaska

Set ${carrier} As Carrier And ${contract} As Contract And ${DB} As Database For The Test
    Set Test Variable    ${carrier}
    Set Test Variable    ${contract}
    Set Test Variable    ${DB}

    Get Into DB  ${db}
    ${query}  Catenate
    ...  SELECT mm_value, member_meta_id
    ...  FROM member_meta
    ...  WHERE member_id = ${carrier} AND member_meta.mm_key = 'PRODLMTS'
    ${storage}  Query And Strip To Dictionary  ${query}

    Execute SQL String  dml=UPDATE member_meta SET mm_value = 'Y' WHERE member_meta_id = ${storage["member_meta_id"]}

    ${query}  Catenate
    ...  SELECT mm_value, member_meta_id
    ...  FROM member_meta
    ...  WHERE member_id = ${carrier} AND member_meta.mm_key = 'PRODLMTS'
    ${storage}  Query And Strip To Dictionary  ${query}

    Set Test Variable    ${storage}

Set ${card} Card Sent to Yes And Created To Today
    Get Into Db  ${db}
    ${today}=  getdatetimenow  %Y%m%d
    ${query}=  catenate  UPDATE card_misc SET file_sent = 'Y' WHERE card_num = '${card}' AND created = ${today}
    Execute SQL String  dml=${query}

Set ${card} Card Status to Delete
    Get Into Db  ${db}
    Execute SQL String  dml=UPDATE cards SET status = 'D' WHERE card_num = '${card}'
    Disconnect From Database

Start Card Order
    Click On CO3 Add Button
    Select CO3 'CANADIAN LINEN DRIVER CARD' Card Option
    Submit CO3 Card Order
    ${promptType}  Get Text  //*[@id="co3OrderInfoActionForm"]//option[@value="2"]
    Select '${promptType}' As Prompt Type

Stop Processing Card
    Select Card Order
    Click On Stop Processing Button
    Confirm Stop Order Processing

Submit Card Order
    Click Element  //*[@id="cardOrder2AddFormButtons"]/button[@id="submit"]
    Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error    Wait Until Load Screen Icon Disappear From Screen

Submit CO3 Card Order
    Click Element  //*[@id="cardOrder3AddFormButtons"]/button[@id="submit"]
    Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error    Wait Until Load Screen Icon Disappear From Screen

Verify If Order Status Is ${status1} Or ${status2}
    ${status}=  Run Keyword And Return Status  Verify Order Status Is ${status1}
    Run Keyword If  ${status}==False  Verify Order Status Is ${status2}

Verify Order Status Is ${status}
    Run Keyword And Ignore Error    Wait Until Load Screen Icon Disappear From Screen
    Input ${orderNumber} As Order #
    Click On Submit For Order Search
    Get Order Status
    Should Be Equal As Strings  ${status}  ${orderStatus}

Verify CO3 Order Status Is ${status}
    Run Keyword And Ignore Error    Wait Until Load Screen Icon Disappear From Screen
    Input ${orderNumber} As Order #
    Click On CO3 Submit For Order Search
    Get Order Status
    Should Be Equal As Strings  ${status}  ${orderStatus}

Verify '${prompt}' is not '${value}'
    [Tags]  qtest
    [Documentation]  verify the prompts: select info_validation from ccb_card_inf where info_id = '{prompt}' and ccb_card_id in
            ...  (select ccb_card_id from ccb_cards where ccb_card_order_id = {orderNumber});
    ${sql}  catenate  select info_validation from ccb_card_inf where info_id = '${prompt}' and ccb_card_id in
            ...  (select ccb_card_id from ccb_cards where ccb_card_order_id = ${orderNumber});
    ${orderPrompt}  query and strip  ${sql}  db_instance=tch
    should not be equal  ${value}  ${orderPrompt}


Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@class="loading-img"]  timeout=10
    Wait Until Element Is Not Visible    //*[@class="loading-img"]  timeout=10

You Should See a Delete Successful Message
    Wait Until Element Is Visible  //*[@class="msgSuccess"]/li[text()="Delete Successful"]  timeout=10

You Should See a Order Processing Stopped Message
    Wait Until Element Is Visible  //*[@class="msgSuccess"]/li[text()="Order Processing for selected orders"]  timeout=10

You Should See The Card Order For ${orderNumber} Order Number
    Page Should Contain Element  //*[@class="orderIdEdit buttonlink" and @orderid="${orderNumber}"]

You Should See The Searched Card ${card} With Status to Active
    Page Should Contain Element  //button[@class="cardNumber buttonlink" and text()="${card}"]
    ${cardStatus}=  Get Text  //button[@class="cardNumber buttonlink" and text()="${card}"]/parent::*/following-sibling::*[4]
    Should Be Equal As Strings  ACTIVE  ${cardStatus}

You Should Not See Any Message On Data Entry Required
    Click Element  //*[@id="co2UniHG"]/div[1]/div/div/div/table/tbody/tr/td[4]
    ${error}=  Get Text  //*[@id="co2UniHG"]/div[1]/div/div/div/table/tbody/tr/td[4]
    Should Be Empty  ${error}

You Should Not See Any Message On Data Entry Required for CO3
    Click Element  //*[@id="errMsg_0"]
    ${error}=  Get Text  //*[@id="errMsg_0"]
    Should Be Empty  ${error}

Add '${templateName}' as Template Name
    ${randomValue}  Generate Random String  3  [NUMBERS]
    ${templateName}  Catenate   SEPARATOR=   ${templateName}   ${randomValue}
    Set Test Variable      ${templateName}
    Wait Until Element Is Visible  //*[@name="detailRecord.templateName"]
    Input Text      //*[@name="detailRecord.templateName"]  ${template_name}

Add '${second_line_embossing}' as Second Line Embossing
    Wait Until Element Is Visible  //*[@name="detailRecord.line2Desc"]
    Input Text      //*[@name="detailRecord.line2Desc"]  ${second_line_embossing}

Verify '${policy}' As Policy Value
    Wait Until Element Is Visible  //*[@name="detailRecord.policy"]
    ${selected_policy}    Get Selected List Value    detailRecord.policy
    Should Be Equal As Strings    ${policy}    ${selected_policy}

Add Policy With '${policyName}' As Policy Name And a Random Contract
    Click on Policies Tab
    Click On Policies Add Button
    Input ${policyName} As Policy Name
    Select a Random Prompt Contract
    Click On Submit For Add Customer Policy
    You Should See a Add Successful Message On Screen

    Set Test Variable      ${policyName}

    #Get iPolicy Number Through DB
    Sleep  1
#    Get Into DB  ${db}
    ${query}    Catenate    SELECT ipolicy FROM def_card WHERE description = '${policyName}'
    ${iPolicy}  Query And Strip  ${query}   db_instance=tch
    ${iPolicy}  Convert to String  ${iPolicy}
    Set Test Variable      ${iPolicy}

Click On Policies Add Button
    Wait Until Element Is Visible  //*[@id="customerPoliciesSearchContainer"]//span[text()="ADD"]/parent::*
    Click Element  //*[@id="customerPoliciesSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20
    Wait Until Page Contains    Add Customer Policy

Input ${text} As Policy Name
    Wait Until Page Contains    Add Customer Policy
    Input Text  //input[@name="policyDetail.name"]  ${text}

Select a Random Prompt Contract
    ${value}=  get value  //*[@name="policyDetail.contractId"]/option[2]
    Select From List By Value  //select[@name="policyDetail.contractId"]  ${value}

Click On Submit For Add Customer Policy
    Click Element  //*[@id="customerPolicyAddActionForm"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click on Policies Tab
    Wait Until Element Is Visible  //*[@id="Policies"]
    Click Element  //*[@id="Policies"]

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="customerPoliciesMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

Delete Created Policy
    Get Into DB  TCH
    Execute SQL String  dml=DELETE FROM def_card WHERE id = '${carrier.id}' AND description = '${policyName}';
    Disconnect From Database

Delete Created Template
    Click on Card Order Template Tab
    Click On Card Order Template Submit Button
    Select Template Order
    Click on Card Order Template DELETE Button
    Confirm Template Delete

Click on Card Order Template Tab
    Wait Until Element Is Visible  //*[@id="CardOrderTemplate"]
    Click Element  //*[@id="CardOrderTemplate"]
    Wait Until Load Screen Icon Disappear From Screen

Click On Card Order Template Submit Button
    Wait Until Element Is Visible  //*/div[1]/button[1]
    Click Element  //*/div[1]/button[1]
    Wait Until Load Screen Icon Disappear From Screen

Select Template Order
    #Get Template Order# Through DB
    ${query}    Catenate        SELECT ccb_card_order_id
    ...    FROM ccb_card_orders
    ...    WHERE carrier_id=${carrier.id}
    ...         AND order_status = 'T'
    ...         AND template_name='${templateName}';
    ${templateOrder}  Query And Strip  ${query}   db_instance=tch
    ${templateOrder}  Convert to String  ${templateOrder}
    Set Test Variable      ${templateOrder}

    Wait Until Element Is Visible  //input[@value="${templateOrder}"]
    Click Element  //input[@value="${templateOrder}"]

Click on Card Order Template DELETE Button
    Click Element    //*[@id="ToolTables_DataTables_Table_2_1"]//span[contains(text(), "DELETE")]

Confirm Template Delete
    Wait Until Element Is Visible    //button[contains(text(),'Confirm')]
    Click Element    //button[contains(text(),'Confirm')]
    Wait Until Load Screen Icon Disappear From Screen
    Page Should Contain    Delete Successful

Check embossing lines
    [Tags]  qTest
    [Arguments]  ${carrier_id}=${carrier_id}  ${second_line}=${second_line}  ${third_line}=${third_line}
    [Documentation]  Verify the second and third line embossing in the ccb_card_misc table:
                ...  select m.first_line_sub, m.second_line
                ...  from ccb_Card_misc m
                ...  JOIN ccb_cards c on m.ccb_card_id = c.ccb_card_id
                ...  JOIN ccb_card_orders o on o.ccb_card_order_id = c.ccb_card_order_id
                ...  where o.carrier_id = {carrier_id}
                ...  and c.template is null
                ...  order by o.created desc limit 1;
    ${sql}  catenate  select m.first_line_sub, m.second_line
                ...  from ccb_Card_misc m
                ...  JOIN ccb_cards c on m.ccb_card_id = c.ccb_card_id
                ...  JOIN ccb_card_orders o on o.ccb_card_order_id = c.ccb_card_order_id
                ...  where o.carrier_id = ${carrier_id}
                ...  and c.template is null
                ...  order by o.created desc limit 1;
    ${embossing}  query and strip to dictionary  ${sql}  db_instance=tch
    should be equal as strings  ${second_line}  ${embossing['first_line_sub'].__str__().strip()}
    should be equal as strings  ${third_line}  ${embossing['second_line'].__str__().strip()}

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

Start card order for Parkland carrier
    [Tags]  qTest
    [Documentation]  Open Account Manager and search the carrier. Click on CO3 tab and select CT7 option.
    Open Account Manager
    Select Customers Tab
    Input ${carrier_id} as Customer #
    select from list by value  businessPartnerCode  PARKLAND
    Click on Submit Button
    Click On Searched ${carrier_id} Carrier
    Click On CO3 Tab
    Click On CO3 Add Button
    Select CO3 'EFS WEX NAF Fleet & Cash Card' Card Option
    Submit CO3 Card Order

Enter Order Info for Parkland order
    [Tags]  qTest
    [Documentation]  enter a value for second line and third line embossing. These will be verified in ccb_card_misc.
    input text  detailRecord.line2Desc  test2
    input text  detailRecord.line3Desc  test3
    Click On CO3 Continue Button For Order Info
    Click On CO3 Continue Button For Unique Card Info
    Complete Shipping Page
    Click On CO3 Submit For Shipping Card Order
    Get CO3 Order Number
    Click On CO3 Continue Button For Summary Detail

Verify Prompt Type As '${promptTypeValue}'
    Wait Until Element Is Visible   //label[@for='detailRecord.promptCode']/parent::*[1]/following-sibling::*[1]
    ${promptType}   Get Text    //label[@for='detailRecord.promptCode']/parent::*[1]/following-sibling::*[1]
    Should Be Equal As Strings  ${promptType}   ${promptTypeValue}

Add An Invalid Policy Value
    Wait Until Element Is Visible  //*[@id="icardpolicy_0"]
    ${invalidPolicy}  Generate Random String  5  [NUMBERS]
    Press Keys     //*[@id="icardpolicy_0"]      ${invalidPolicy}
    Press Keys     //*[@id="icardpolicy_0"]    RETURN
    Click Element  //*[@id="errMsg_0"]
    ${error}=  Get Text  //*[@id="errMsg_0"]
    Should Be Equal As Strings  ${error}   Invalid policy

Check Error Message
    ${message}    Handle Alert
    Should Be Equal As Strings  ${message}   Please resolve errors to continue

Try to Continue Order and Expect Error
    ${status}    Run Keyword And Return Status    Click On CO3 Continue Button For Unique Card Info
    Should Be True    '${status}' == 'True'
