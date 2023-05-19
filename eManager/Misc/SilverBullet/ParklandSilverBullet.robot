*** Settings ***
Test Timeout  5 minutes
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  Collections
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Library  otr_robot_lib.support.DynamicTesting
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setup

*** Test Cases ***
Basic Silver Bullet
    [Tags]  JIRA:Rocket-192  qTest:55391499  PI:13  API:Y  Tier:0
    [Setup]  Get parkland data for transaction
    Setup user and login
    Select Program > "Management Application" > "EMA Silver Bullet"
    Enter Location ID and Submit  ${location}
    Enter Card Num, Invoice, and Date and Submit  ${card}  ${todayDashed}
    Enter Prompt info
    Enter Quantity, PPU and Click Add Fuel Item  ${items[0]['prodnum']}  ${items[0]['qty4']}  ${items[0]['ppu4']}
    Submit
    Enter Quantity, Amount and Click Add Non Fuel Item  ${items[1]['prodnum']}  ${items[1]['qty4']}  ${items[1]['amt4']}
    Submit
    Enter Transaction Total  ${total}
    Submit
    ${trans_id}  Get text  transId
    Verify Database Trans Line table  ${trans_id}
    [Teardown]  close browser

Basic Silver Bullet with Disc
    [Tags]  JIRA:Rocket-192  qTest:55391503  PI:13  API:Y  Tier:2
    [Setup]  Get parkland data for transaction  Y
    Setup user and login
    Select Program > "Management Application" > "EMA Silver Bullet"
    Enter Location ID and Submit  ${location}
    Enter Card Num, Invoice, and Date and Submit  ${card}  ${todayDashed}
    Enter Prompt info
    Enter Quantity, PPU and Click Add Fuel Item  ${items[0]['prodnum']}  ${items[0]['qty4']}  ${items[0]['ppu4']}
    Submit
    Enter Quantity, Amount and Click Add Non Fuel Item  ${items[1]['prodnum']}  ${items[1]['qty4']}  ${items[1]['amt4']}
    Enter Discount  ${items[1]['disc']}
    Submit
    Enter Transaction Total  ${total}
    Submit
    ${trans_id}  Get text  transId
    Verify Database Trans Line table  ${trans_id}
    [Teardown]  close browser

Basic Silver Bullet with HST
    [Tags]  JIRA:Rocket-192  qTest:55391508  PI:13  API:Y  Tier:2
    [Setup]  Get parkland data for transaction  N  Y
    Setup user and login
    Select Program > "Management Application" > "EMA Silver Bullet"
    Enter Location ID and Submit  ${location}
    Enter Card Num, Invoice, and Date and Submit  ${card}  ${todayDashed}
    Enter Prompt info
    Enter Quantity, PPU and Click Add Fuel Item  ${items[0]['prodnum']}  ${items[0]['qty4']}  ${items[0]['ppu4']}
    Submit
    Enter Quantity, Amount and Click Add Non Fuel Item  ${items[1]['prodnum']}  ${items[1]['qty4']}  ${items[1]['amt4']}
    Enter Hst Gst  ${items[1]['hst']}
    Submit
    Enter Transaction Total  ${total}
    Submit
    ${trans_id}  Get text  transId
    Verify Database Trans Line table  ${trans_id}
    [Teardown]  close browser

Basic Silver Bullet with PST
    [Tags]  JIRA:Rocket-192  qTest:55391509  PI:13  API:Y  Tier:2
    [Setup]  Get parkland data for transaction  N  N  Y
    Setup user and login
    Select Program > "Management Application" > "EMA Silver Bullet"
    Enter Location ID and Submit  ${location}
    Enter Card Num, Invoice, and Date and Submit  ${card}  ${todayDashed}
    Enter Prompt info
    Enter Quantity, PPU and Click Add Fuel Item  ${items[0]['prodnum']}  ${items[0]['qty4']}  ${items[0]['ppu4']}
    Submit
    Enter Quantity, Amount and Click Add Non Fuel Item  ${items[1]['prodnum']}  ${items[1]['qty4']}  ${items[1]['amt4']}
    Enter Pst Qst  ${items[1]['pst']}
    Submit
    Enter Transaction Total  ${total}
    Submit
    ${trans_id}  Get text  transId
    Verify Database Trans Line table  ${trans_id}
    [Teardown]  close browser

Basic Silver Bullet with PST,HST, and DISC
    [Tags]  JIRA:Rocket-192  qTest:55391510  PI:13  API:Y  Tier:1
    [Setup]  Get parkland data for transaction  Y  Y  Y
    Setup user and login
    Select Program > "Management Application" > "EMA Silver Bullet"
    Enter Location ID and Submit  ${location}
    Enter Card Num, Invoice, and Date and Submit  ${card}  ${todayDashed}
    Enter Prompt info
    Enter Quantity, PPU and Click Add Fuel Item  ${items[0]['prodnum']}  ${items[0]['qty4']}  ${items[0]['ppu4']}
    Submit
    Enter Quantity, Amount and Click Add Non Fuel Item  ${items[1]['prodnum']}  ${items[1]['qty4']}  ${items[1]['amt4']}
    Enter Pst Qst  ${items[1]['pst']}
    Enter Hst Gst  ${items[1]['hst']}
    Enter Discount  ${items[1]['disc']}
    Submit
    Enter Transaction Total  ${total}
    Submit
    ${trans_id}  Get text  transId
    Verify Database Trans Line table  ${trans_id}
    [Teardown]  close browser

*** Keywords ***
Setup
    ${todayDashed}  getDateTimeNow  %Y-%m-%d
    set suite variable  ${todayDashed}
    ${yesterdayDashed}  getDateTimeNow  %Y-%m-%d  days=-1
    set suite variable  ${yesterdayDashed}
    #turning on all of these flags because they are all connected in aut
    Update dbconditional if not Y for Rocket-176
    Update dbconditional if not Y for Rocket-190
    Update dbconditional if not Y for Rocket-7


Update dbconditional if not Y for ${story}
    ${sql}  catenate  select progcond
    ...  from db_conditional
    ...  where progname = 'precision'
    ...  AND   progval = '${story}'

    ${flag}  query and strip  ${sql}  db_instance=TCH
    IF  '${flag}'!='Y'
        ${updatesql}  catenate  UPDATE db_conditional
        ...  SET progcond = 'Y'
        ...  WHERE progname = 'precision'
        ...  AND   progval = 'ROCKET-176'
        execute sql string  dml=${updatesql}  db_instance=TCH
    END

Setup user and login
    [Tags]  qtest
    [Documentation]  Follow TC-4254 to make sure the following Permissions are on internal user
    ...  SILVER_BULLET_MGNTAPP_FOR_PARKLAND
    ...  SILVER_BULLET_MGNTAPP
    ...  SILVER_BULLET_MGNTAPP_FOR_TCH
    ...  If added roles log out and log in TC-1402 is how to login with Internal user
    ...  Go To Select Program > "Management Application" > "EMA Silver Bullet"
    Open Emanager  ${intern}  ${internPassword}
    ${permissons}  Get User Permissions  ${intern}
    ${cnt}  Get Match count  ${permissons['role_id']}  SILVER_BULLET_MGNT*
    IF  ${cnt}!=3
        Add User Role If Not Exists  ${intern}  SILVER_BULLET_MGNTAPP_FOR_PARKLAND
        Add User Role If Not Exists  ${intern}  SILVER_BULLET_MGNTAPP  1
        Add User Role If Not Exists  ${intern}  SILVER_BULLET_MGNTAPP_FOR_TCH
        Log out of eManager
        Log into eManager  ${intern}  ${internPassword}
    END

Get parkland data for transaction
    [Arguments]  ${disc}=N  ${hst}=N  ${pst}=N
    ${sql}  catenate  select card_num,location_id from transaction
    ...  where carrier_id between 2500000 and 2599999
    ...  and card_num not like '708305%'
    ...  and location_id in (
    ...      select location_id from location
    ...      where src_country is not NULL and supplier_id = 451755)
    ...  order by trans_date desc
    ...  limit 1;

    ${results}  query and strip to dictionary  ${sql}  db_instance=TCH

    Start Setup Card  ${results['card_num']}
    Setup Card Header  infoSource=CARD  limitSource=CARD  locationSource=CARD  status=ACTIVE
    Setup Card Limits  DEF=1000  BEVR=1000
#customize values
    ${3dec}  generate random string  3  123456789
    ${3dec}  convert to number  ${3dec}
    ${4dec}  Create 4 decimal place value  Y
    ${tens}  generate random string  2  12
    ${tens}  convert to number  ${tens}
    ${ppu4}  evaluate  ${4dec} + 1
    ${ppu4}  convert to number  ${ppu4}  precision=4
    ${qty3}  evaluate  ${3dec} * .001 + ${tens}
    ${amt4}  evaluate  ${ppu4} * ${qty3}
    ${amt4}  convert to number  ${amt4}  precision=2
    #20 is def for parkland
    ${fuel}  create dictionary  prodnum=20  qty4=${qty3}  ppu4=${ppu4}  amt4=${amt4}
    ${4dec}  Create 4 decimal place value  Y
    ${ones}  generate random string  1  123456789
    ${amt2}  evaluate  ${ones} + ${4dec}
    ${amt2}  convert to number  ${amt2}  precision=2
    ${discamt}  Create 4 decimal place value  ${disc}
    ${discamt}  Drop to 2 digits decimal  ${discamt}
    ${hstamt}  Create 4 decimal place value  ${hst}
    ${hstamt}  Drop to 2 digits decimal  ${hstamt}
    ${pstamt}  Create 4 decimal place value  ${pst}
    ${pstamt}  Drop to 2 digits decimal  ${pstamt}
    #420 is beverage package for parkland
    ${nonfuel}  create dictionary  prodnum=420  qty4=1.0000  amt4=${amt2}  disc=${discamt}  hst=${hstamt}  pst=${pstamt}
    ${items}  create list  ${fuel}  ${nonfuel}
    ${total}  evaluate  ${items[1]['amt4']} + ${items[0]['amt4']} - ${discamt} + ${hstamt} + ${pstamt}
    ${total}  Drop to 2 digits decimal  ${total}
    set test variable  ${items}
    set test variable  ${total}
    set test variable  ${location}  ${results['location_id']}
    set test variable  ${card}  ${results['card_num']}

Drop to 2 digits decimal
    [Arguments]  ${amt}
    ${amt}  convert to number  ${amt}  precision=3
    ${amt}  convert to number  ${amt}  precision=2
    [Return]  ${amt}

Create 4 decimal place value
    [Arguments]  ${default}
    IF  '${default}'!='N'
        ${4dec}  generate random string  4  123456789
        ${amt}  evaluate  ${4dec} * .0001
        ${amt}  convert to number  ${amt}  precision=4
    ELSE
        ${amt}  evaluate  0 + 0
        ${amt}  convert to number  ${amt}  precision=4
    END
    [Return]  ${amt}

Enter Location ID and Submit
    [Tags]  qtest
    [Arguments]  ${location}
    [Documentation]  select card_num,location_id from transaction
    ...  where carrier_id between 2500000 and 2599999
    ...  and card_num not like '708305%'
    ...  and location_id in (
    ...      select location_id from location
    ...      where src_country is not NULL and supplier_id = 451755)
    ...  order by trans_date desc
    ...  limit 1;
    ...  Enter the location id from the query above
    Input Text  locationId  ${location}
    Submit

Enter Card Num, Invoice, and Date and Submit
    [Tags]  qtest
    [Arguments]  ${card}  ${date}
    [Documentation]  Enter card number from the query in the above steps to find a card and location.
    ...  Put in a random invoice alpha numeric
    ...  Select date in past or leave it as today
    Input Text  data.cardNumber  ${card}
    ${invoice}  generate random string  8  0123456789
    Input Text  data.invoice  ${invoice}
    Input Text  dateField  ${date}
    Submit

Enter Prompt info
    [Tags]  qtest
    [Arguments]  ${db}=TCH
    [Documentation]  select info_id,info_validation from card_inf where card_num = '<card num from query>'
    ...  Enter the Prompt values into needed fields using above query
    ${SQL}  catenate  select info_id
    ...  from card_inf
    ...  where card_num='${card}'
    ...  and info_validation not like 'Z%'
    @{infoid}  query and strip to list  ${sql}  db_instance=${db}
    ${prompts}  create dictionary
    set test variable  ${prompts}
    FOR  ${i}   IN  @{infoid}
        ${sql}  catenate  select info_validation from card_inf where card_num='${card}' and info_id = '${i}';
        ${val}  query and strip  ${sql}  db_instance=${db}
        set to dictionary  ${prompts}  ${i}  ${val}
        Input Text  data.uiPromptValues['info_${i}']  ${val.strip()}[1:]
    END
    Submit

Enter Quantity, PPU and Click Add Fuel Item
    [Tags]  qtest
    [Arguments]  ${ProductNum}  ${qty}  ${price}
    [Documentation]  Enter Quantity with 3 decimal places x.xxx
    ...  Enter PPU with 4 Decimal places x.xxxx
    ...  Select an available Fuel item
    ...  Click on Add Fuel Item Button
    Select From List By Value  fuelItem.fuelType.itemNumber  ${ProductNum}
    Input Text  qty  ${qty}
    Input Text  price  ${price}
#    Amount is auto populated
#    Input Text  amount  14.00
    Click Element  addFuelItem

Enter Quantity, Amount and Click Add Non Fuel Item
    [Tags]  qtest
    [Arguments]  ${ProductNum}  ${qty}  ${amt}
    [Documentation]  Select an available Non Fuel item
    ...  input quantity x.xxx .... most of the time just 1.000
    ...  input amount x.xxxx
    ...  click on add Non Fuel item
    Select From List By Value  nonFuelItem.itemType.groupId  ${ProductNum}
    Input Text  nonFuelItem.quantity  ${qty}
    Input Text  nonFuelItem.amount  ${amt}
    Click Element  addNonFuelItem

Enter Discount
    [Tags]  qtest
    [Arguments]  ${amt}
    [Documentation]  Enter a discount amt 2-4 decimals x.xx - x.xxxx
    ...  next screen will turn it to x.xx
    Input Text  data.discount  ${amt}

Enter Hst Gst
    [Tags]  qtest
    [Arguments]  ${amt}
    [Documentation]  Enter a HST/GST amt 2-4 decimals x.xx - x.xxxx
    ...  next screen will turn it to x.xx
    Input Text  data.hstGst  ${amt}

Enter Pst Qst
    [Tags]  qtest
    [Arguments]  ${amt}
    [Documentation]  Enter a PST/QST amt 2-4 decimals x.xx - x.xxxx
    ...  next screen will turn it to x.xx
    Input Text  data.pstQst  ${amt}

Enter Transaction Total
    [Tags]  qtest
    [Arguments]  ${grandtotal}
    [Documentation]  Add up all Fuel, non fuel, PST/QST, and HST/GST items
    ...  Subtract and discount
    ...  enter the total in total field
    Input Text  transTotal  ${grandtotal}

Submit
    [Tags]  qtest
    [Documentation]  Click the submit button to move to next page
    Click Element  submitPromptsButton

Verify Database Trans Line table
    [Tags]  qtest
    [Arguments]  ${trans_id}  ${db}=tch
    [Documentation]  Get Trans_id from screen and run query
        ...  select *
        ...  from trans_line
        ...  where trans_id = {trans_id}
        ...  ------------
        ...  Verify that amt4 is populated
        ...  Verify HST,PST,DISC amt are correct
        ...  Verify other transaction data
    ${sql}  catenate  select count(*)
    ...  from trans_line
    ...  where trans_id = ${trans_id}

    ${cnt}  query and strip  ${sql}  db_instance=${db}
    FOR  ${i}  IN RANGE  0  ${cnt}
        ${sql}  catenate  select *
        ...  from trans_line
        ...  where trans_id = ${trans_id}
        ...  and line_id = ${i}
        ${Trans_line}  query and strip to dictionary  ${sql}  db_instance=${db}
        IF  '${Trans_line['cat'].strip()}'=='DISC'
            ${amt}  Drop to 2 digits decimal  ${items[1]['disc']}
            should be equal as numbers  ${Trans_line['amt']}  -${amt}  precision=2
            should be equal as numbers  ${Trans_line['amt4']}  -${items[1]['disc']}  precision=4
        ELSE IF  '${Trans_line['cat'].strip()}'=='GST' or '${Trans_line['cat'].strip()}'=='HST'
            ${amt}  Drop to 2 digits decimal  ${items[1]['hst']}
            should be equal as numbers  ${Trans_line['amt']}  ${amt}  precision=2
            should be equal as numbers  ${Trans_line['amt4']}  ${items[1]['hst']}  precision=4

        ELSE IF  '${Trans_line['cat'].strip()}'=='PST' or '${Trans_line['cat'].strip()}'=='QST'
            ${amt}  Drop to 2 digits decimal  ${items[1]['pst']}
            should be equal as numbers  ${Trans_line['amt']}  ${amt}  precision=2
            should be equal as numbers  ${Trans_line['amt4']}  ${items[1]['pst']}  precision=4
        ELSE
            should be equal as numbers  ${Trans_line['amt4']}  ${items[${i}]['amt4']}  precision=4
            should be equal as numbers  ${Trans_line['num']}  ${items[${i}]['prodnum']}  precision=4
            should be equal as numbers  ${Trans_line['qty4']}  ${items[${i}]['qty4']}  precision=4
        END
    END
