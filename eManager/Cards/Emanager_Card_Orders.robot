*** Settings ***
#Test Timeout  5 minutes
#Documentation
#...  = Test Setup =
#...  == Create two log directories ==
#...  - Transaction log: /home/qaauto/el_robot/authStrings/rossAuthLogs/NewCards/$ {month}
#...  - Card order log: /home/qaauto/el_robot/cardOrders/${month}
#...  = Test Procedure =
#...  - Open eManager and order any number of cards with/without prompts
#...  - Run cardOrder > Card order log
#...  - Grep each card number with the card order number.
#...  == Expected Results ==
#...  -- The number of created cards in the file equal the number of cards ordered.
#...  - Check the prompts on each card
#...  - Run a transaction with that card. (Not yet used.)
#...  == Expected Results ==
#...  -- Transaction is successful.
#...
#...  = Test Teardown =
#...  - Change the status of each card to 'D' in the cards table so as to not flood the UI with unused cards.
#...  - Close SSH and DB connections and browsers

#Library  SeleniumLibrary
Library  OperatingSystem  WITH NAME  os
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ssh.PySSH
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  Auth  CardOrder  NewCard  eManager  JIRA:BOT-51

Suite Setup    Setup Carrier for Card Orders
*** Variables ***
# STATICALLY-DEFINED VARIABLES (MUST BE DEFINED PER TEST CASE)
${DB}
${type}
${style}
${carrier}

*** Test Cases ***
Shell Flying J Card
    [Tags]  JIRA:BOT-658  SHELL  tier:0  refactor
    set suite variable  ${DB}  SHELL
    set suite variable  ${style}  SHELL HEAVY FLEET
    Setup for carrier  ${DB}  ${style}
    Go To Card Orders
    Set Card Order Type  Shell Heavy Fleet
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Normalize Company Name
    Set Number Of Cards  2
    Set Shipping Details
    Set Second Line  EL  MR
    Set Third Line  ROBOT  ROBOT0
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  FISCardFile.sh  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Processing
    Validate Card Prompts  ${card}  EL  MR  ROBOT  ROBOT0

   [Teardown]  Delete card order  ${orderNumber}  ${DB}

Shell Fleet Card
    [Tags]  JIRA:BOT-658  qTest:32231120  SHELL  tier:0  refactor
    set suite variable  ${DB}  SHELL
    set suite variable  ${style}  SHELL LIGHT FLEET
    Setup for carrier  ${DB}  ${style}
    Go To Card Orders
    Set Card Order Type  Shell Light Fleet
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Normalize Company Name
    Set Number Of Cards  2
    Set Shipping Details
    Set Card Holder Names  EL ROBOT 1  EL ROBOT 2
    Set DRID Values  1234  2345
    Set Vehicle IDs  6489  3478
    Set Vins  5434  8967
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  FISCardFile.sh  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Processing
    Validate Card Prompts  ${card}  EL ROBOT 1  EL ROBOT 2  1234  2345  6489  3478  5434  8967

   [Teardown]  Delete card order  ${orderNumber}  ${DB}

Shell Reskin Card Ordering
    [Tags]  JIRA:FRNT-80  JIRA:FRNT-81  qTest:38689686  RESKIN  refactor  deprecated
    [Documentation]  Just a normal emanager card ordering but using reskin CSS.
    ...  Since I am ordering FIS cards running FISCardFile.sh

    Set Test Variable  ${DB}  SHELL
    set test variable  ${style}  SHELL/FIS DRIVER FUEL ONLY
    Setup for carrier  ${DB}  ${style}
    Go To Card Orders
    Set Card Order Type  Setup for carrier  ${DB}  ${style}
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Normalize Company Name
    Set Number Of Cards  2
    Set Shipping Details
    Set Card Holder Names  EL ROBOT 1  EL ROBOT 2
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  FISCardFile.sh  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Processing
    Validate Card Prompts  ${card}  EL ROBOT 1  EL ROBOT 2

    [Teardown]  Delete card order  ${orderNumber}  ${DB}

Card Ordering Schneider Company Cards
    [Tags]  JIRA:BOT-476  qTest:32035799  qTest:32038861  refactor
    [Documentation]  Order Schneider cards and ensure that the format is correct.
    Set Test Variable  ${DB}  tch
    set test variable  ${style}  SCHNEIDER COMPANY
    Setup for carrier  ${DB}  ${style}
    Go To Card Orders
    Set Card Order Type  EFS Fleet & Cash
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Set Shipping Details
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  cardOrder  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Processing
    Validate Card Misc  ${card.card_num}  file_sent=N
    Run script  createCardFiles  ${EMPTY}
    Validate Card Misc  ${card.card_num}  file_sent=Y
    Validate Card Order Status Is Shipped

    [Teardown]  Delete card order  ${orderNumber}  ${DB}

Card Ordering Schneider Owner OPS Cards
    [Tags]  JIRA:BOT-476   refactor
    [Documentation]  Order Schneider cards and ensure that the format is correct.
    Set Test Variable  ${DB}  tch
    set test variable  ${style}  SCHNEIDER OWNER OPS
    Setup for carrier  ${DB}  ${style}
    Go To Card Orders
    Set Card Order Type  EFS Fleet & Cash
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Set Shipping Details
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  cardOrder  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Processing
    Validate Card Misc  ${card.card_num}  file_sent=N
    Run script  createCardFiles  ${EMPTY}
    Validate Card Misc  ${card.card_num}  file_sent=Y
    Validate Card Order Status Is Shipped

    [Teardown]  Delete card order  ${orderNumber}  ${DB}

PNC Card Order
    [Tags]  JIRA:BOT-281  qTest:32229665  qTest:32230190  qTest:32282828  qTest:32338511  PNC  tier:0  refactor
    Set Test Variable  ${DB}  tch
    set test variable  ${style}  PNC OL DRIVER FUEL & MAINT
    Setup for carrier  ${DB}  ${style}
    Go To Card Orders
    Set Card Order Type  PNC OL Driver Card
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Normalize Company Name
    Set Number Of Cards  5
    Set Product Restrictions  Fuel and Other Products
    Set Prompt Type  Cardholder and Odometer
    Set Shipping Details
    Set Card Holder Names  EL ROBOT 1  EL ROBOT 2  EL ROBOT 3  EL ROBOT 4  EL ROBOT 5
    Set DRID Values  1111  2222  3333  4444  5555
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  cardOrder  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Processing
    Validate Card Prompts  ${card}  EL ROBOT 1  EL ROBOT 2  EL ROBOT 3  EL ROBOT 4  EL ROBOT 5  1111  2222  3333  4444  5555

    [Teardown]  Delete card order  ${orderNumber}  ${DB}

FTS Card Order - CP Rail Custom Red Road Plastic - Style 398
    [Tags]  JIRA:FRNT-1003  qTest:47506486  PI:6  tier:0  refactor
    [Documentation]  This is to test CP Rail Red card styles.
    ...  THESE CARD STYLES ARE HARDCODED FOR CARRIER:603478
    Set Test Variable  ${DB}  SHELL
    set test variable  ${carrier}  603478
    set test variable  ${style}  VEHICLE DRIVER-DRIVER CARD FUE
    Setup FTS carrier  ${carrier}  ${style}
    Go To Card Orders
    Set Card Order Type  CP RAIL RED ROAD/VEHICLE DRIVER-DRIVER CARD FUEL ONLY
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Normalize Company Name
    Set Number Of Cards  2
    Set Prompt Type  Cardholder and Odometer
    Set Shipping Details
    Set DRID Values  5634  8978
    Set Card Holder Names  ROBOT  TEST
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  FISCardFile.sh  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Shipped
    Validate Card Prompts  ${card}  ROBOT  TEST  5634  8978

   [Teardown]  Delete card order  ${orderNumber}  ${DB}

FTS Card Order - CP Rail Custom Red Road Plastic - Style 399
    [Tags]  JIRA:FRNT-1003  qTest:47506485  PI:6  refactor
    [Documentation]  This is to test CP Rail Red card styles.
    ...  THESE CARD STYLES ARE HARDCODED FOR CARRIER:603478
    Set Test Variable  ${DB}  SHELL
    set test variable  ${carrier}  603478
    set test variable  ${style}  VEHICLE VEHICLE-VEHICLE CARD F
    Setup FTS carrier  ${carrier}  ${style}
    Go To Card Orders
    Set Card Order Type  CP RAIL RED ROAD/VEHICLE VEHICLE-VEHICLE CARD FUEL ONLY
    Set Card Style  ${style}
    Set Policy  ${DB}  ${carrier}
    Normalize Company Name
    Set Number Of Cards  2
    Set Prompt Type  Vehicle # and Odometer
    Set Shipping Details
    Set Vehicle IDs  2464  897569876
    Set Vins  4578  634563245
    Save Card Order
    ${orderNumber}  Get Order Number  ${carrier}
    Validate Card Order Status Is Ready
    Run script  FISCardFile.sh  ${orderNumber}
    ${card}  Get New Card Numbers
    Validate Card Order Status Is Shipped
    Validate Card Prompts  ${card}  2464  897569876  4578  634563245

   [Teardown]  Delete card order  ${orderNumber}  ${DB}

Card Order - Max Limit of Cards
    [Tags]  JIRA:FRNT-1689  JIRA:BOT-3561  qTest:51969532  PI:10
    [Documentation]    Test if max card limit on card order works.

    Log into eManager with a Carrier that have Card Order Permission;
    Navigate to Select Program > Manage Cards > Card Order;
    Select a Card Order Type;
    Insert Number of Cards to Order '501'
    Verify if Error Message For Max Number of Cards to Order Appears;

    [Teardown]    Close Browser

Card Order - Min Limit of Cards
    [Tags]  JIRA:FRNT-1689  JIRA:BOT-3561  qTest:51969532  PI:10
    [Documentation]    Test if min card limit on card order works.

    Log into eManager with a Carrier that have Card Order Permission;
    Navigate to Select Program > Manage Cards > Card Order;
    Select a Card Order Type;
    Insert Number of Cards to Order '0'
    Verify if Error Message For Min Number of Cards to Order Appears;

    [Teardown]    Close Browser

Card Order - Company Name Change Option for PNC Carriers
    [Tags]  JIRA:FRNT-1696  JIRA:BOT-3574  qTest:52584959  PI:10
    Log into eManager with a PNC Carrier that have Card Order Permission;
    Navigate to Select Program > Manage Cards > Card Order;
    Select a Card Order Type;
    Check if "Company Name (Printed on Card):" is an editable field
    [Teardown]    Close Browser

Card Order - Company Name should not change for non PNC carriers
    [Tags]  JIRA:FRNT-1696  JIRA:BOT-3574  qTest:52585258  PI:10
    Log into eManager with a non PNC Carrier that have Card Order Permission;
    Navigate to Select Program > Manage Cards > Card Order;
    Select a Card Order Type;
    Check if "Company Name (Printed on Card):" is an non editable field
    [Teardown]    Close Browser

*** Keywords ***

Start Suite
    ${date}=  getdatetimenow  %Y%m%d
    ${date}=  get substring  ${date}  2
    ${time}=  getdatetimenow  %H%M%S
    set global variable  ${date}
    set global variable  ${time}

Setup for carrier
    [Arguments]  ${DB}  ${style}
    get into db  ${DB}
    # Make sure certain card style,ccb_card_options has verified flag N, otherwise eManager will not allow card order
    execute sql string  dml=update ccb_card_options set verified='Y' where description = '${style}'
    ${style}  query and strip  select card_style from card_styles where name = '${style}'
    execute sql string  dml=update card_styles set verified='Y' where card_style = '${style}'
    #Pick up a carrier where its issuer is properly linked to the card style
    #Otherwise you wont see this card style in emanager dropdown
    ${query}  catenate  select C.carrier_id from contract C join member M
    ...  on C.carrier_id = M.member_id
    ...  where C.issuer_id in (select issuer_id from issuer_card_style where card_style = '${style}')
    ...  and M.mem_type = 'C'
    ...  and M.status = 'A'
    ...  and (M.expiredate is NULL or M.expiredate > today)
    ...  and C.contract_id >= 100000
    ...  order by last_trans desc limit 1
    ${carrier}  query and strip to dictionary  ${query}
    ${carrier}  assign string  ${carrier['carrier_id']}
    ${carrier_obj}  set carrier variable  ${carrier}
    ${pwd}  Set Variable  ${carrier_obj.password}
    Make Sure Carrier Is Active  ${carrier}
    add user role if not exists  ${carrier}  CARD_ORDER  1
    Open eManager  ${carrier}  ${pwd}
    set suite variable  ${carrier}

Setup FTS carrier
    [Arguments]  ${carrier}  ${style}
     get into db  ${DB}
    # Make sure certain card style,ccb_card_options has verified flag N, otherwise eManager will not allow card order
    execute sql string  dml=update ccb_card_options set verified='Y' where description = '${style}'
    ${style}  query and strip  select card_style from card_styles where name = '${style}'
    execute sql string  dml=update card_styles set verified='Y' where card_style = '${style}'
    #Make sure the carrier's issuer is tied to the card_style
    #Otherwise you wont see this card style in emanager dropdown
    ${query}  catenate  select * from issuer_card_style where card_style in
    ...  (select card_style from card_styles where name = 'VEHICLE DRIVER-DRIVER CARD FUE')
    ...  and issuer_id in (select issuer_id from contract where carrier_id = '603478');
    ${count}  row count  ${query}
    #Hardcoded by choice
    run keyword if  ${count}==0  execute sql string  dml=insert INTO issuer_card_style VALUES (161738,399,'MCFL');
    run keyword if  ${count}==0  execute sql string  dml=insert INTO issuer_card_style VALUES (161738,398,'MCFL');
    Make Sure Carrier Is Active  ${carrier}
    add user role if not exists  ${carrier}  CARD_ORDER  1
    ${carrier}  set carrier variable  ${carrier}  instance=shell
    ${pwd}  Set Variable  ${carrier.password}
    Open eManager  ${carrier}  ${pwd}

Go To Card Orders
    go to  ${emanager}/cards/CardOrder.action

Set Card Order Type
    [Arguments]  ${cardType}
    ${type}=  get value  //*[@*="codeIntSel"]/*[contains(text(), "${cardType}")]
    select from list by value  codeIntSel  ${type}
    check element exists  text=Create Card Order  exactMatch=${False}

Set Card Style
    [Arguments]  ${style}
    select from list by label  cardStylSel  ${style}

Normalize Company Name
    ${name}=  get value  embossedName
    ${name}=  remove special characters  ${name}
    input text  embossedName  ${name}

Set Policy
    [Arguments]  ${DB}  ${carrier}
    get into db  ${DB}
   ${query}  catenate  select ipolicy from def_card where contract_id in
   ...  (select contract_id from contract where carrier_id = '${carrier}')
   ...  and ipolicy between 1 and 500 order by ipolicy asc limit 1;
   ${policy}  query and strip to dictionary  ${query}
   ${policy}  convert to string  ${policy.ipolicy}
   select from list by value  contractPolicySel  ${policy}

Set Number Of Cards
    [Arguments]  ${numOfCards}
    input text  orderQty  ${numOfCards}

Set Product Restrictions
    [Arguments]  ${restriction}
    select from list by label  productRestrictionsSel  ${restriction}

Set Prompt Type
    [Arguments]  ${promptType}
    select from list by label  promptsSel  ${promptType}

Set Shipping Method
    [Arguments]  ${shipMethod}
    ${method}=  get value  //*[@*="shippingMethodId"]/*[contains(text(), "${shipMethod}")]
    select from list by value  shippingMethodId  ${method}

Set Shipping Details
    input text  shipToFirst  EL
    input text  shipToLast  ROBOT
    input text  address1  1104 COUNTRY HILLS DRIVE
    input text  address2  ADDRESS 2
    input text  city  OGDEN
    select from list by value  stateSel  UT
    input text  zip  84403

Set Second Line
    [Arguments]  @{values}
    input text  cspSecondLineValue  ${\\n.join(${values})}

Set Third Line
    [Arguments]  @{values}
    input text  cspThirdLineValue  ${\\n.join(${values})}

Set Card Holder Names
    [Arguments]  @{names}
    input text  cspNameValue  ${\\n.join(${names})}

Set DRID Values
    [Arguments]  @{DRIDs}
    input text  cspDridValue  ${\\n.join(${DRIDs})}

Set Vehicle IDs
    [Arguments]  @{vehIDs}
    input text  cspUnitValue  ${\\n.join(${vehIDs})}

Set Vins
    [Arguments]  @{VINs}
    input text  cspVinValue  ${\\n.join(${VINs})}

Save Card Order
    click on  Save
    click on  text=OK

Get Order Number
    [Arguments]  ${carrier}
    ${query}=  catenate
    ...  select ccb_card_order_id
    ...  from ccb_card_orders
    ...  where carrier_id = ${carrier}
    ...  order by created desc
    ...  limit 1

    ${orderNumber}=  query and strip  ${query}
    tch logging  ORDER NUMBER IS: ${orderNumber}  ALL
    set test variable  ${orderNumber}
    [Return]  ${orderNumber}

Validate Card Order Status Is ${status}
    Go To Card Orders
    click on  Lookup Existing Card Order
    element should be visible
    ...  //*[contains(@title, "order ${orderNumber}")]/../../descendant::*[contains(text(), "${status}")]
    ...  The status of the card order is not ${status}.

Run script
    [Arguments]  ${script}  ${ordernum}
    go sudo
    ${cardOrderLog}  Create Log File
    run command  /tch/run/${script} ${ordernum} 2>${cardOrderLog}
    Run Command  grep -aPo 'Updated Card Order ${ordernum}' ${cardOrderLog}
    set suite variable  ${cardOrderLog}

Check each row to confirm data masked
    set delimited file  /home/qaauto/el_robot/tchrunlogs/simonsPathwayDailyTrans.out  |  ${true}
    start parsing delimited file
    ${row_count}  get delimited content row count
    FOR  ${i}  IN RANGE  1  ${row_count}
        ${line}  get next line
        ${part1}  get substring  ${line[0]}  68  100
        ${part2}  get substring  ${line[0]}  115  121
        ${part3}  get substring  ${line[0]}  128  149
        should be empty  ${part1.strip()}
        should be empty  ${part2.strip()}
        should be empty  ${part3.strip()}

    END

    ${INFORMIXSERVER}=  run command  echo $${DB.upper()}_DB | cut -d "@" -f 2
    tch logging  INFORMIXSERVER=${INFORMIXSERVER.stdout}  ALL
    run command  export INFORMIXSERVER=${INFORMIXSERVER.stdout}
    run command  cardOrder 2> ${cardOrderLog}
    ${grep}=  run command  grep -ao '${orderNumber}' ${cardOrderLog} | head -1
    tch logging  ORDER NUMBER IN LOG: ${grep.stdout}  ALL
    run keyword if  '${grep.stdout}'!='${orderNumber}'  run keywords
    ...  tch logging  Card order number ${orderNumber} not found in log. Log:nt${cardOrderLog}  ERROR  AND
    ...  fail  Could not find card order in log.

Get New Card Numbers

    ${cardID}  query and strip to dictionary  select card_id from ccb_cards where ccb_card_order_id='${orderNumber}' and card_id is not null
    ${cardID}  pop from dictionary  ${cardID}  card_id
    ${cardID}  strip my string  ${cardID}  right  ]
    ${cardID}  strip my string  ${cardID}  left  [
    ${card}  query and strip to dictionary  select card_num from cards where card_id in (${cardID})
    [Return]  ${card}


Validate Card Prompts
    [Arguments]  ${newCards}  @{promptvalues}
    ${newCards}  pop from dictionary  ${newCards}  card_num
    ${newCards}  strip my string  ${newCards}  right  ]
    ${newCards}  strip my string  ${newCards}  left  [
    ${query}  catenate  select info_validation from card_inf where card_num in (${newCards}) and info_validation != 'N'
    ${prompts}  query and strip to dictionary  ${query}
    ${count}  row count  ${query}
    FOR  ${i}  IN RANGE  0  ${count}
        ${promptval}  Remove First Char  ${prompts.info_validation[${i}].strip()}
        list should contain value  ${promptvalues}  ${promptval}
    END

Run Transaction On New Card
    [Arguments]  ${card}  ${location}  @{products}

#    SET UP CARD TO TRANSACT ON A PRODUCT
    ${transProducts}=  create list
    execute sql string  dml=update cards set status = 'A', lmtsrc = 'C' where card_num = '${newCard}'
    FOR  ${product}  IN  @{products}
       execute sql string  dml=delete from card_lmt where card_num = '${newCard}' and limit_id = '${product}'
       execute sql string
       ...  insert into card_lmt (card_num, limit_id, limit, hours, day_of_week) values ('${newCard}', '${product}', 9999, 1, 0)
       append to list  ${transProducts}  ${product}=50.00
    END
    tch logging  RUNNING TRANSACTION FOR: ${SPACE + " , ".join(${transProducts})}  ALL
    ${ac}=  create ac string  ${DB}  ${location}  ${newCard}  @{transProducts}
    run rossAuth  ${ac}  ${authLog}
    ${transId}=  get transaction id from log file  ${authLog}
    run keyword if  '${transId}'=='${empty}'  fail  Transaction unsuccessful.
    tch logging  tTransaction successful!  ALL

Run CreateCardFiles
    ${INFORMIXSERVER}=  run command  echo $${DB.upper()}_DB | cut -d "@" -f 2
    tch logging  INFORMIXSERVER=${INFORMIXSERVER.stdout}  ALL
    run command  export INFORMIXSERVER=${INFORMIXSERVER.stdout}
    run command  createCardFiles

Validate Card Misc
    [Arguments]  ${card}  ${file_sent}

    FOR  ${card}  IN  ${card}
       ${query}=  catenate
       ...  SELECT *
       ...  FROM card_misc
       ...  WHERE card_num = '${card}'
       ${card_misc}=  query and strip to dictionary  ${query}
       should be equal as strings  ${card_misc.file_sent.strip()}  ${file_sent}
    END

Delete card order
    [Arguments]  ${ordernum}  ${DB}
    get into db  ${DB}
    execute sql string  dml=delete from ccb_card_order_meta where ccb_card_order_id = '${ordernum}';
    execute sql string  dml=delete from ccb_card_misc where ccb_card_id in (select ccb_card_id from ccb_cards where ccb_card_order_id= '${ordernum}');
    execute sql string  dml=delete from ccb_card_meta where ccb_card_id in (select ccb_card_id from ccb_cards where ccb_card_order_id= '${ordernum}');
    execute sql string  dml=delete from ccb_card_inf where ccb_card_id in (select ccb_card_id from ccb_cards where ccb_card_order_id= '${ordernum}');
    execute sql string  dml=delete from ccb_card_lmt where ccb_card_id in (select ccb_card_id from ccb_cards where ccb_card_order_id= '${ordernum}');
    execute sql string  dml=delete from ccb_cards where ccb_card_order_id= '${ordernum}';
    execute sql string  dml=delete from ccb_card_orders where ccb_card_order_id= '${ordernum}';
    execute sql string  dml=delete from card_inf where card_num in (select card_num from cards where card_id in (select card_id from ccb_cards where ccb_card_order_id = '${ordernum}'));
    execute sql string  dml=delete from card_lmt where card_num in (select card_num from cards where card_id in (select card_id from ccb_cards where ccb_card_order_id = '${ordernum}'));
    execute sql string  dml=delete from card_misc where card_num in (select card_num from cards where card_id in (select card_id from ccb_cards where ccb_card_order_id = '${ordernum}')) ;
    execute sql string  dml=delete from cards where card_num in (select card_num from cards where card_id in (select card_id from ccb_cards where ccb_card_order_id = '${ordernum}')) ;


    disconnect from database
    close browser

End Test
    disconnect from database

Setup Carrier for Card Orders
    [Documentation]  Keyword Setup for Parent Carrier Report

    Get Into DB  MySQL

#Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND surx.role_id='CARD_ORDER'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT member_id FROM member WHERE status='A' AND member_id IN ${list_2}
    ...  AND member_id NOT IN ('103866','600117','345026','345040','600212','566049')  #Bad Carrier for this test

    ${carrier}  Find Carrier Variable  ${query}    member_id

    Set Suite Variable  ${carrier}

Log into eManager with a Carrier that have Card Order Permission;
    [Documentation]  Login on Emanager
    Open eManager  ${carrier.id}  ${carrier.password}

Log into eManager with a PNC Carrier that have Card Order Permission;
    [Documentation]  Login on Emanager
    Setup PNC Carrier
    Open eManager  ${carrier.id}  ${carrier.password}

Log into eManager with a non PNC Carrier that have Card Order Permission;
    [Documentation]  Login on Emanager
    Setup non PNC Carrier
    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Manage Cards > Card Order;
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/CardOrder.action

Select a Card Order Type;
    [Documentation]

    Select From List By Index  codeIntSel  1

Insert Number of Cards to Order '${number_of_cards}'

    Input Text  orderQty  ${number_of_cards}

Click on Save Button;

    Click Element  saveBtn

Verify if Error Message For Max Number of Cards to Order Appears;

    Click on Save Button;
    Element Should be Visible    //label[@id='orderQty-error' and text()='Cards should be less than or equal to 500']

Verify if Error Message For Min Number of Cards to Order Appears;

    Click on Save Button;
    Element Should be Visible    //label[@id='orderQty-error' and text()='Please enter a value greater than or equal to 1.']

Check if "Company Name (Printed on Card):" is an editable field
    Page Should Contain Element     //input[@id='embossedName']

Check if "Company Name (Printed on Card):" is an non editable field
    Page Should Not Contain Element     //input[@id='embossedName']

Setup PNC Carrier
    [Documentation]  Keyword Setup for PNC Carrier

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    JOIN sec_company sc on su.company_id = sc.company_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND sc.company_header='pnc_carrier'
    ...    AND surx.role_id='CARD_ORDER'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;

    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')

    ${carrier_query}  Catenate  SELECT member_id FROM member m
    ...    INNER JOIN contract c ON m.member_id=c.carrier_id
    ...    WHERE m.status='A'
    ...    AND c.issuer_id IN (100176,105757)  # PNC Issuers
    ...    AND member_id IN ${carrier_list}
    ...    AND (SELECT count(contract_id) FROM contract WHERE carrier_id=m.member_id)=1
    ...    AND member_id NOT IN ('106007', '103715');    #Bad Carriers

    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Setup non PNC Carrier
    [Documentation]  Keyword Setup for non PNC Carrier

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    JOIN sec_company sc on su.company_id = sc.company_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND sc.company_header NOT IN ('pnc_carrier')
    ...    AND surx.role_id='CARD_ORDER'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;

    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')

    ${carrier_query}  Catenate  SELECT member_id FROM member m
    ...    INNER JOIN contract c ON m.member_id=c.carrier_id
    ...    WHERE m.status='A'
    ...    AND c.issuer_id NOT IN (100176,105757)  # PNC Issuers
#    ...    AND c.issuer_id IN  (194149)  # WNAF Issuer
    ...    AND member_id IN ${carrier_list}
    ...    AND (SELECT count(contract_id) FROM contract WHERE carrier_id=m.member_id)=1
    ...    AND member_id NOT IN ('106007', '146666', '345026');    #Bad Carriers

    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}