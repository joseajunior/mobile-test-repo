*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Suite Setup  Set Up Suite
Force Tags  Web Services

*** Variables ***
${policy}  ${validCard.policy.num}
${orderType}
${orderStyle}  1
@{requiredChoices}
@{allChoices}
${choice}
${orderIdNoCards}
${orderIdWithCards}
${shipping_method}
${numberCounter}  1

*** Test Cases ***
Get Card Order Syles
    [Tags]  qTest:30987370  Regression  JIRA:BOT-1892
    ${styles}=  getOrderStyles  ${policy}  ${orderType}
    should not be empty  ${styles}
    ${orderStyle}=  get from dictionary  ${styles[0]}  cardStyle
    set suite variable  ${orderStyle}

Get Card Order Styles With Invalid Policy
    [Tags]  JIRA:FRNT-55
    ${status}  ${ws_error}  Run Keyword And Ignore Error  getOrderStyles  9999  ${orderType}
    Should Be Equal As Strings  FAIL  ${status.upper()}  Order Styles Didn't Fail despite using invalid Policy Number
    should contain  ${ws_error}  Invalid policy number

Attempt To Get Card Order Styles not on Policy
    [Tags]  qTest:30987371  Regression  JIRA:BOT-1892  refactor
    ${styles}=  getOrderStyles  9999  ${orderType}
    should be empty  ${styles}

Get Valid Order Choices
    [Tags]  qTest:30987372  Regression  JIRA:BOT-1893
    @{allChoices}=  getOrderChoices  ${policy}  ${orderType}  ${orderStyle}  en_US  ${False}
    set suite variable  @{allchoices}

Get Order Choices With Invalid Policy Number
    [Tags]  JIRA:FRNT-55
    ${status}  ${ws_error}  Run Keyword And Ignore Error  getOrderChoices  9999  ${orderType}  ${orderStyle}  en_US  ${False}
    Should Be Equal As Strings  FAIL  ${status.upper()}  Order Choices Didn't Fail despite using invalid Policy Number
    should contain  ${ws_error}  Invalid policy number

Get Required Valid Order Choices
    [Tags]  qTest:30987373  Regression  JIRA:BOT-1893
    @{requiredChoices}=  getOrderChoices  ${policy}  ${orderType}  ${orderStyle}  en_US  ${True}
    set suite variable  @{requiredChoices}

Create Card Order
    [Tags]  qTest:30987376  Regression  JIRA:BOT-1903
    ${props}=  create prop dictionary  ${requiredchoices}  numberOfCardsToOrder=5
    ${cards}=  create list
    ${orderIdNoCards}  ${error}  ${stat}=  createOrder  ${policy}  ${orderType}  ${orderStyle}  ${props}  ${cards}
    set suite variable  ${orderIdNoCards}

    should be equal as integers  0  ${error}  The Card Order was not Processed Successfully Error Code is: ${error}  ${False}
    should be true  ${stat}

Create Card Order With an Invalid Policy Number
    [Tags]  JIRA:FRNT-55    qTest:37189869
    ${props}=  create prop dictionary  ${requiredchoices}  numberOfCardsToOrder=5
    ${cards}=  create list
    ${status}  ${ws_error}  Run Keyword And Ignore Error  createOrder  9999  ${orderType}  ${orderStyle}  ${props}  ${cards}
    Should Be Equal As Strings  FAIL  ${status.upper()}
    should contain  ${ws_error}  Invalid policy number

Create Card Order With Card Data
    [Tags]  qTest:30987376  Regression  JIRA:BOT-1903
    ${props}=  create prop dictionary  ${requiredchoices}  numberOfCardsToOrder=5
    ${cards}=  create card list  ${allChoices}  5
    ${orderIdWithCards}  ${error}  ${stat}=  createOrder  ${policy}  ${orderType}  ${orderStyle}  ${props}  ${cards}
    set suite variable  ${orderIdWithCards}

    should be equal as integers  0  ${error}  The Card Order was not Processed Successfully Error Code is: ${error}  ${False}
    should be true  ${stat}

Create An Submit A Card Order
    [Tags]  qTest:30987379  Regression  JIRA:BOT-1623
    ${props}=  create dictionary
    ${cards}=  create list
    ${orderIdWithCards}  ${error}  ${stat}=  createAndSubmitOrder  ${policy}  ${orderType}  ${orderStyle}  orderQty=5  embossedName=Robot Test  shippingMethod=${shipping_method}  rushProcessing=N  cardCarrier=N  props=${props}  cards=${cards}  shipToFirst=Robot  shipToLast=Tester  shipToAddress1=Here and There  shipToCity=Ogden  shipToState=UT  shipToZip=84403  shipToCountry=US
    set suite variable  ${orderIdWithCards}
    should be equal as integers  0  ${error}  The Card Order was not Processed Successfully Error Code is: ${error}  ${False}
    should be true  ${stat}

Create And Submit A Card Order With an Invalid Policy Number
    [Tags]  qTest:37450533  JIRA:FRNT-55
    ${props}=  create dictionary
    ${cards}=  create list
    ${status}  ${ws_error}  Run Keyword And Ignore Error  createAndSubmitOrder  9999  ${orderType}  ${orderStyle}  orderQty=5  embossedName=Robot Test  shippingMethod=${shipping_method}  rushProcessing=N  cardCarrier=N  props=${props}  cards=${cards}  shipToFirst=Robot  shipToLast=Tester  shipToAddress1=Here and There  shipToCity=Ogden  shipToState=UT  shipToZip=84403  shipToCountry=US
    Should Be Equal As Strings  FAIL  ${status.upper()}
    should contain  ${ws_error}  Invalid policy number

Create An Submit A Card Order Without Required Fields
    [Tags]  qTest:30987380  Regression  JIRA:BOT-1623

    ${props}=  create dictionary
    ${cards}=  create list
    ${orderIdWithCards}  ${error}  ${stat}=  createAndSubmitOrder  ${policy}  ${orderType}  ${orderStyle}  orderQty=5  embossedName=Robot Test  shippingMethod=${shipping_method}  rushProcessing=N  cardCarrier=N  props=${props}  cards=${cards}  shipToFirst=Robot  shipToLast=Tester  shipToAddress1=Here and There  shipToCity=Ogden  shipToState=UT  shipToZip=84403  shipToCountry=US
    should be equal as integers  0  ${error}  The Card Order was not Processed Successfully Error Code is: ${error}  ${False}
    should be true  ${stat}

Get Order Cards For an Order Without Any Card Data
    [Tags]  qTest:30987374  Regression  JIRA:BOT-1894
    ${orderId}  ${myPolicy}  ${myOrderType}  ${myCardStyle}  ${cards}=  getOrderCards  ${orderIdNoCards}
    should be equal as strings  ${orderId}  ${orderIdNoCards}  My Order Ids Did Not Match  ${False}
    should be equal as strings  ${myPolicy}  ${Policy}  My Policy Ids Did Not Match  ${False}
    should be equal as strings  ${myOrderType}  ${orderType}  My Order Types Did Not Match  ${False}
    should be equal as strings  ${myCardStyle}  ${orderStyle}  My Order Styles Did Not Match  ${False}
    should be empty  ${cards}

Get Order Cards For an Order With Card Data, and No Card Selections
    [Tags]  qTest:30987375  Regression  JIRA:BOT-1894
    ${orderId}  ${myPolicy}  ${myOrderType}  ${myCardStyle}  ${cards}=  getOrderCards  ${orderIdWithCards}
    should be equal as strings  ${orderId}  ${orderIdWithCards}  My Order Ids Did Not Match  ${False}
    should be equal as strings  ${myPolicy}  ${Policy}  My Policy Ids Did Not Match  ${False}
    should be equal as strings  ${myOrderType}  ${orderType}  My Order Types Did Not Match  ${False}
    should be equal as strings  ${myCardStyle}  ${orderStyle}  My Order Styles Did Not Match  ${False}
    should be empty  ${cards}

Get Order Cards For an Order With Card Data, and Card Selections
    [Tags]  qTest:30987376  Regression  JIRA:BOT-1894
    ${orderId}  ${myPolicy}  ${myOrderType}  ${myCardStyle}  ${cards}=  getOrderCards  ${orderIdWithCards}  1,2,3
    should be equal as strings  ${orderId}  ${orderIdWithCards}  My Order Ids Did Not Match  ${False}
    should be equal as strings  ${myPolicy}  ${Policy}  My Policy Ids Did Not Match  ${False}
    should be equal as strings  ${myOrderType}  ${orderType}  My Order Types Did Not Match  ${False}
    should be equal as strings  ${myCardStyle}  ${orderStyle}  My Order Styles Did Not Match  ${False}
    length should be  ${cards}  3  Expected 3 Cards in the return but recieved ${cards}

Delete Card Order
    [Tags]  qTest:30987377  Regression  JIRA:BOT-1902
    deleteOrder  ${orderIdNoCards}
    get into db  tch
    row count is 0  select * from ccb_card_orders where ccb_card_order_id = '${orderIdNoCards}'

Delete a Card Order From Another Carrier
    [Tags]  qTest:30987378  Regression  JIRA:BOT-1902

    get into db  tch
    ${orderId}=  query and strip  select ccb_card_order_id from ccb_card_orders where carrier_id <> ${validCard.carrier.id} limit 1
    deleteOrder  ${orderId}
    row count is equal to x  select * from ccb_card_orders where ccb_card_order_id = ${orderId}  1

Stop An Order With A Valid Order ID
    [Tags]  JIRA:BOT-1875  qTest:31725096  Regression
    [Documentation]  Make sure you can stop and Order with a valid order ID
#    GET ORDER TYPES
    @{orderTypes}  getOrderTypes  ${policy}
    ${orderType}  get from dictionary  ${orderTypes[0]}  orderType
    Tch Logging  \n MY ORDER TYPE:${orderType}
    set suite variable  ${orderType}

#    GET ORDER STYLES
    ${styles}  getOrderStyles  ${policy}  ${orderType}
    tch logging  styles:${styles}
    should not be empty  ${styles}
    ${orderStyle}  get from dictionary  ${styles[0]}  cardStyle
    Tch Logging  \n MY ORDER STYLE:${orderStyle}
    set suite variable  ${orderStyle}

#    CREATE ORDER
    @{requiredChoices}  getOrderChoices  ${policy}  ${orderType}  ${orderStyle}  en_US  ${True}
    Tch Logging  \n MY REQUIRED CHOICES:@{requiredChoices}
    set suite variable  @{requiredChoices}
    ${props}  create prop dictionary  ${requiredchoices}  numberOfCardsToOrder=1
    ${cards}  create card list  ${allChoices}  1
    Tch Logging  CARD LIST:${cards}
    ${orderId}  ${error}  ${stat}  createOrder  ${policy}  ${orderType}  ${orderStyle}  ${props}  ${cards}
    tch logging  STATUS:${stat}
    submitOrder  ${orderId}
    stopOrder    ${orderId}

#    CHECK ORDER STATUS IN DB
    ${query}  catenate
    ...     SELECT order_status FROM ccb_card_orders WHERE carrier_id = ${validCard.carrier.id} AND ccb_card_order_id = ${orderId}
    ${status}  Query And Strip  ${query}
    Should Be Equal As Strings  ${status}  E

Stop An Order With An Empty Order ID
    [Tags]  JIRA:BOT-1875  qTest:31725170  Regression
    [Documentation]  Make sure you can't stop an order with no order ID number

    ${status}  stopOrder  ${EMPTY}
    Should Be Equal As Strings  ${status['description']}  ERROR - unable to stop order

Stop An Order With A Typo On The Order ID
    [Tags]  JIRA:BOT-1875  qTest:31725183  Regression
    [Documentation]  Make sure you can't stop an order when you have a typo on the order number.

    ${status}  Run Keyword And Return Status  stopOrder  482AD58
    Should Not Be True  ${status}

Stop An Order With An Invalid Order ID
    [Tags]  JIRA:BOT-1875  qTest:31725298  Regression
    [Documentation]  Make sure you can't stop an order when you have an invalid order number

    ${status}  Run Keyword And Return Status  stopOrder  1nv4L!@
    Should Not Be True  ${status}

Stop An Order With A Space on the Order ID
    [Tags]  JIRA:BOT-1875  qTest:31725333  Regression

    ${status}  Run Keyword And Return Status  stopOrder  428${SPACE}85
    Should Not Be True  ${status}

Update A Valid Order
    [Tags]  JIRA:BOT-1873  qTest:31794576  Regression
    [Documentation]  Make sure you can update an order

#    GET ORDER TYPES
    @{orderTypes}  getOrderTypes  ${policy}
    ${orderType}  get from dictionary  ${orderTypes[0]}  orderType
    set suite variable  ${orderType}

#    GET ORDER STYLES
    ${styles}  getOrderStyles  ${policy}  ${orderType}
    should not be empty  ${styles}
    ${orderStyle}  get from dictionary  ${styles[0]}  cardStyle
    set suite variable  ${orderStyle}

#    CREATE ORDER
    @{requiredChoices}  getOrderChoices  ${policy}  ${orderType}  ${orderStyle}  en_US  ${True}
    set suite variable  @{requiredChoices}
    ${props}  create prop dictionary  ${requiredchoices}  numberOfCardsToOrder=1
    ${cards}  Create Card List  ${allChoices}  1
    ${orderId}  ${error}  ${stat}  createOrder  ${policy}  ${orderType}  ${orderStyle}  ${props}  ${cards}
    Tch Logging  ORDER_ID:${orderId}

    ${props1}  Create Dictionary  langCode=false
    ${WS_INFO}  updateOrder  ${orderId}  ${props1}
    ${query}  catenate  SELECT lang_code FROM ccb_card_orders WHERE ccb_card_order_id=${orderId}
    ${langCode}  Query And Strip  ${query}
    Should Be Equal As Strings  ${langCode}  f

Update An Order With Typo On Parameters
    [Tags]  JIRA:BOT-1873  qTest:31794930  Regression
    [Documentation]  Make sure you can't update an order when you have a typo on the parameters

    ${props1}  Create Dictionary  langCode=false
    ${WS_INFO}  Run Keyword And Return Status  updateOrder  4A29D75  ${props1}
    Should Not Be True  ${WS_INFO}

    ${props1}  Create Dictionary  langABCDCode=false
    ${WS_INFO}  Run Keyword And Return Status  42975  ${props1}
    Should Not Be True  ${WS_INFO}

    ${props1}  Create Dictionary  langCode=faARETlse
    ${WS_INFO}  Run Keyword And Return Status  42975   ${props1}
    Should Not Be True  ${WS_INFO}

Update An Order With Invalid Parameters
    [Tags]  JIRA:BOT-1873  qTest:31794961  Regression
    [Documentation]  Make sure you can't update an order when you have invalid parameters

    ${props1}  Create Dictionary  langCode=false
    ${WS_INFO}  Run Keyword And Return Status  updateOrder  4@!675  ${props1}
    Should Not Be True  ${WS_INFO}

    ${props1}  Create Dictionary  lang@#$Code=false
    ${WS_INFO}  Run Keyword And Return Status  42975  ${props1}
    Should Not Be True  ${WS_INFO}

    ${props1}  Create Dictionary  langCode=fa#$#@lse
    ${WS_INFO}  Run Keyword And Return Status  42975   ${props1}
    Should Not Be True  ${WS_INFO}

Update An Order With Empty Parameters
    [Tags]  JIRA:BOT-1873  qTest:31795052  Regression
    [Documentation]  Make sure you can't update an order when you have empty parameters

    ${props1}  Create Dictionary  langCode=false
    ${WS_INFO}  updateOrder  ${EMPTY}  ${props1}
    Should Not Be True  ${WS_INFO[1]}

    ${props1}  Create Dictionary  ${EMPTY}=false
    ${WS_INFO}  Run Keyword And Return Status  42975  ${props1}
    Should Not Be True  ${WS_INFO}

    ${props1}  Create Dictionary  langCode=${EMPTY}
    ${WS_INFO}  Run Keyword And Return Status  42975   ${props1}
    Should Not Be True  ${WS_INFO}

Update An Order With Space On Parameters
    [Tags]  JIRA:BOT-1873  qTest:31795298  Regression
    [Documentation]  Make sure you can't update an order when you have a space on the parameters

    ${props1}  Create Dictionary  langCode=false
    ${WS_INFO}  Run Keyword And Return Status  updateOrder  429${SPACE}75  ${props1}
    Should Not Be True  ${WS_INFO}

    ${props1}  Create Dictionary  lan${SPACE}ode=false
    ${WS_INFO}  Run Keyword And Return Status  42975  ${props1}
    Should Not Be True  ${WS_INFO}

    ${props1}  Create Dictionary  langCode=fa${SPACE}se
    ${WS_INFO}  Run Keyword And Return Status  42975   ${props1}
    Should Not Be True  ${WS_INFO}

Try To Update An Order From Another Carrier
    [Tags]  JIRA:BOT-1873  qTest:31798161  Regression  refactor
    [Documentation]  Make sure you can't update an order from another carrier.

    log into card management web services  146567  123123
    Set Test Variable  ${mypolicy}  1

    @{orderTypes}=  getOrderTypes  ${mypolicy}
    ${orderType}=  get from dictionary  ${orderTypes[0]}  orderType
    set suite variable  ${orderType}
    get into db  tch
    ${shipping_method}=  query and strip  select shipping_method_id from shipping_methods where description = 'Standard Shipping'
    set suite variable  ${shipping_method}

#    GET ORDER TYPES
    @{orderTypes}  getOrderTypes  ${mypolicy}
    ${orderType}  get from dictionary  ${orderTypes[0]}  orderType
    set suite variable  ${orderType}

#    GET ORDER STYLES
    ${styles}  getOrderStyles  ${mypolicy}  ${orderType}
    should not be empty  ${styles}
    ${orderStyle}  get from dictionary  ${styles[0]}  cardStyle
    set suite variable  ${orderStyle}

#    CREATE ORDER
    @{requiredChoices}  getOrderChoices  ${mypolicy}  ${orderType}  ${orderStyle}  en_US  ${True}
    set suite variable  @{requiredChoices}
    ${props}  create prop dictionary  ${requiredchoices}  numberOfCardsToOrder=1
    ${cards}  Create Card List  ${allChoices}  1
    ${orderId}  ${error}  ${stat}  createOrder  ${mypolicy}  ${orderType}  ${orderStyle}  ${props}  ${cards}
    Tch Logging  ORDER_ID:${orderId}
    logout

    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${props1}  Create Dictionary  langCode=false
    ${WS_INFO}  updateOrder  ${orderId}  ${props1}
    Should Not Be True  ${WS_INFO[1]}

Update Order Card With Valid Data
    [Tags]  JIRA:BOT-1872  qTest:32230864  Regression  refactor
    [Documentation]  Make sure you can update a card order using the updateOrderCards ws call.

#    GET ORDER TYPES
    @{orderTypes}  getOrderTypes  ${policy}
    ${orderType}  get from dictionary  ${orderTypes[0]}  orderType
    set suite variable  ${orderType}

#    GET ORDER STYLES
    ${styles}  getOrderStyles  ${policy}  ${orderType}
    should not be empty  ${styles}
    ${orderStyle}  get from dictionary  ${styles[0]}  cardStyle
    set suite variable  ${orderStyle}

#    CREATE ORDER
    @{requiredChoices}  getOrderChoices  ${policy}  ${orderType}  ${orderStyle}  en_US  ${True}
    set suite variable  @{requiredChoices}

    ${props}  create prop dictionary  ${requiredchoices}  numberOfCardsToOrder=1
    ${cards}  create card list  ${allChoices}  1
    ${orderId}  ${error}  ${stat}  createOrder  ${policy}  ${orderType}  ${orderStyle}  ${props}  ${cards}
    tch logging  ORDER ID:${orderId}

    ${props_}  Create Dictionary  key=icardpolicy  value=23
    ${card_}  Create Dictionary  idx=0  props=${props_}

    ${WS_INFO}  updateOrderCards  ${orderId}  ${card_}

    ${query}  catenate  SELECT icardpolicy FROM ccb_cards cc
    ...     LEFT JOIN ccb_card_misc ccm ON ccm.ccb_card_id = cc.card_id
    ...     WHERE ccb_card_order_id = ${orderId} AND order_line_no=0
    ${langCode}  Query And Strip  ${query}
    Should Be Equal As Numbers  ${langCode}  23

Update Order Card With Special Characters
    [Tags]  JIRA:BOT-1872  qTest:32231072  Regression
    [Documentation]  Make sure you can't update a card order when you have data with special characters

    ${props_}  Create Dictionary  key=icardpolicy  value=23
    ${card_}  Create Dictionary  idx=0  props=${props_}
    ${status}  Run Keyword And Return Status  updateOrderCards  43!@#$794  ${card_}
    Should Not Be True  ${status}

Update Order Card With EMPTY Data
    [Tags]  JIRA:BOT-1872  qTest:32231110  Regression  refactor
    [Documentation]  Make sure you can't update a card order when you have empty data

    ${props_}  Create Dictionary  key=icardpolicy  value=23
    ${card_}  Create Dictionary  idx=0  props=${props_}
    ${status}  updateOrderCards  ${EMPTY}  ${card_}
    Should Start With  ${status[1]}  ERROR java.lang.RuntimeException: ERROR running command

Update Order Card With SPACES on the Data
    [Tags]  JIRA:BOT-1872  qTest:32231295  Regression
    [Documentation]  Make sure you can't update a card order when you have empty data

    ${props_}  Create Dictionary  key=icardpolicy  value=23
    ${card_}  Create Dictionary  idx=0  props=${props_}
    ${status}  Run Keyword And Return Status  updateOrderCards  ${SPACE}  ${card_}
    Should Not Be True  ${status}



*** Keywords ***
Set Up Suite
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    @{orderTypes}=  getOrderTypes  ${policy}
    ${orderType}=  get from dictionary  ${orderTypes[0]}  orderType
    set suite variable  ${orderType}
    get into db  tch
    ${shipping_method}=  query and strip  select shipping_method_id from shipping_methods where description = 'Standard Shipping'
    set suite variable  ${shipping_method}

Create Prop Dictionary
    [Arguments]  ${choices}  ${cardLevel}=${False}  ${requiredOnly}=${True}  ${numberOfCardsToOrder}=5

    ${prop}  create dictionary
    FOR  ${choice}  IN  @{choices}
        run keyword if  not ${cardLevel} and '${choice['cardscope']}' == 'false'  Set Prop Value To Dictionary  ${prop}  ${choice}  ${requiredOnly}  ${numberOfCardsToOrder}
        run keyword if  ${cardLevel} and '${choice['cardscope']}' == 'true'  Set Prop Value To Dictionary  ${prop}  ${choice}  ${requiredOnly}  ${numberOfCardsToOrder}
    END
    [Return]  ${prop}

Set Prop Value To Dictionary
    [Arguments]  ${dictionary}  ${choice}  ${requiredOnly}  ${numOfCards}=5

    return from keyword if  ${requiredOnly} and '${choice['required']}' == 'false'

    ${propName}=  get from dictionary  ${choice}  prop

    ${propsToSkip}=  create list  cardNum  icardpolicy  promptCode  coxref
    return from keyword if  '${propName}' in ${propsToSkip}

    ${useAllowed}=  evaluate  len(${choice['allowed']}) > 0

    ${isPromptType}=  evaluate  '${propName}' == 'shipToCountry'
    run keyword if  ${isPromptType}  set to dictionary  ${dictionary}  ${choice['prop']}=US
    return from keyword if  ${isPromptType}

    ${allLen}=  run keyword if  ${useAllowed}  get length  ${choice['allowed']}
    ${allIndex}=  run keyword if  ${useAllowed}  evaluate  random.randint(0,${allLen}-1)  modules=random
    ${allowed}=  run keyword if  ${useAllowed}  get from list  ${choice['allowed']}  ${allIndex}
    ${allowed}=  run keyword if  ${useAllowed}  evaluate  list(${allowed}.keys())[0]
    run keyword if  ${useAllowed}  set to dictionary  ${dictionary}  ${choice['prop']}=${allowed}
    return from keyword if  ${useAllowed}

    ${validation}=  get from dictionary  ${choice}  validationtype

    ${isQty}=  evaluate  '${propName}' == 'orderQty'
    run keyword if  ${isQty}  set to dictionary  ${dictionary}  ${choice['prop']}=${numOfCards}
    return from keyword if  ${isQty}

    ${isPromptType}=  evaluate  '${propName}' == 'promptCode'
    run keyword if  ${isPromptType}  set to dictionary  ${dictionary}  ${choice['prop']}=5
    return from keyword if  ${isPromptType}

    ${isPromptType}=  evaluate  '${propName}' == 'shipToCountry'
    run keyword if  ${isPromptType}  set to dictionary  ${dictionary}  ${choice['prop']}=US
    return from keyword if  ${isPromptType}

    run keyword if  '${validation}' == 'numericInteger'  set to dictionary  ${dictionary}  ${choice['prop']}=123456
    run keyword if  '${validation}' == 'email'  set to dictionary  ${dictionary}  ${choice['prop']}=WEXEFS-El-Robot@wexinc.com
    run keyword if  '${validation}' == 'stateProv'  set to dictionary  ${dictionary}  ${choice['prop']}=UT
    run keyword if  '${validation}' == 'alphaNumericSpecial'  set to dictionary  ${dictionary}  ${choice['prop']}=TestOrderData${numberCounter}
    run keyword if  '${validation}' == 'postalCode'  set to dictionary  ${dictionary}  ${choice['prop']}=84403
    run keyword if  '${validation}' == 'phone'  set to dictionary  ${dictionary}  ${choice['prop']}=555-555-5555
    run keyword if  '${validation}' == 'lettersOnly'  set to dictionary  ${dictionary}  ${choice['prop']}=TestOrderDataLetters
    run keyword if  '${validation}' == 'None'  set to dictionary  ${dictionary}  ${choice['prop']}=TestOrderDataNoValidation${numberCounter}
    ${numberCounter}=  evaluate  ${numberCounter}+1
    set suite variable  ${numberCounter}

Create Card List
    [Arguments]  ${choices}  ${qtyOfCards}

    ${cardList}=  create list

    FOR  ${card}  IN RANGE  0  ${qtyOfCards}
        ${cardProps}=  create prop dictionary  ${choices}  ${True}  ${False}
        append to list  ${cardList}  ${cardProps}
    END

    [Return]  ${cardList}


