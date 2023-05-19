*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

Suite Setup  Starting My Suite

*** Variables ***

*** Test Cases ***
Process successful silver bullet for Parkland carrier and location
    [Tags]  Jira:ROCKET-136  qTest:54658123  API:Y
    [Setup]  Set up Parkland Carrier
    #USE admin user
    SELECT PROGRAM > "Management Application" > "EMA Silver Bullet"
    Enter Parkland Location
    Enter Transaction info
    #Verify fuel Products
    Enter Fuel Product
    Enter Non Fuel Product
    Verify Summary Page
    [Teardown]  close browser

#Will be implemented in a different Jira
#Verify Parkland products are pulled
#select * from products where fps_partner = 'PARKLAND';


*** Keywords ***
Starting My Suite
    ${today}  getdatetimenow  %Y-%m-%d
    set suite variable  ${today}


Setup Parkland Carrier
    [Tags]  qTest
    [Documentation]  Get Parkland card, carrier, location from DB
            ...  select carrier_id from contract where issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 31) and status = 'A' order by lastupdated limit 1;
            ...  select card_num from cards where status = 'A' and carrier_id = {carrier_id} order by lastupdated limit 1;
            ...  select location_id from location where status = 'A' and supplier_id in (451755,451756) order by lastupdated limit 1;
            ...  Add permissions SILVER_BULLET_MGNTAPP and SILVER_BULLET_MGNTAPP_FOR_PARKLAND to carrier
    ${sql}  catenate  select carrier_id from contract where issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 31) and status = 'A' order by lastupdated limit 1;
    ${carrier_id}  query and strip  ${sql}  db_instance=TCH
    ${sql2}  catenate  select location_id from location where status = 'A' and supplier_id in (451755,451756) order by lastupdated limit 1;
    ${location_id}  query and strip  ${sql2}  db_instance=TCH
    ${sql3}  catenate  select card_num from cards where status = 'A' and carrier_id = ${carrier_id} order by lastupdated limit 1;
    ${card_num}  query and strip  ${sql3}  db_instance=TCH
    set test variable  ${carrier_id}
    set test variable  ${location_id}
    set test variable  ${card_num}
    ${invoice}    Evaluate    random.randint(100000, 999999)
    set test variable  ${invoice}
    Add User Role If Not Exists  ${carrier_id}  SILVER_BULLET_MGNTAPP  menu_visible=1
    Add User Role If Not Exists  ${carrier_id}  SILVER_BULLET_MGNTAPP_FOR_PARKLAND  menu_visible=1
    Open eManager  ${intern}  ${internPassword}
    Select Program > "User Administration" > "Customer Info Test"
    Select From List By Value  searchType  1
    Input Text  searchValue  ${carrier_id}
    Click Element  SearchCustomers
    Click Element  //*[@id="searchCustomerTable"]/tbody/tr/td[1]/a[text()='${carrier_id}']

Enter Parkland Location
    [Documentation]  enter parkland location id and click submit
    [Tags]  qtest
    input text  locationId  ${location_id}
    click button  submitPromptsButton

Enter Transaction info
    [Documentation]  Enter card_num, invoice, and date
    [Tags]  qtest
    [Arguments]  ${card_num}=${card_num}  ${invoice}=${invoice}  ${date}=${today}  ${time}=00:00:00
    input text  data.cardNumber  ${card_num}
    input text  data.invoice  ${invoice}
    input text  dateField  ${date}
    input text  timeField  ${time}
    click button  submitPromptsButton
    wait until element is enabled  submitPromptsButton
    click button  submitPromptsButton

#Verify fuel Products
#    [Tags]  qtest
#    [Documentation]  compare the products in the fuel type drop down. Should match Parkland products
#                ...  select abbrev from products where fps_partner = 'PARKLAND' and fuel_use = 1;
#    ${fuels}  query and strip to list  select abbrev from products where fps_partner = 'PARKLAND' and fuel_use = 1;
#    ${menu}  get selected list values  name="fuelItem.fuelType.itemNumber"

# id=msg-dialog

Enter Fuel Product
    [Tags]  qtest
    [Arguments]  ${fuel_value}=None
    [Documentation]  Select a fuel from drop down, enter qty and price, click add fuel item
    IF  ${fuel_value}!=None
        select from list by value  name="fuelItem.fuelType.itemNumber"  ${fuel_value}
    END
    input text  fuelItem.quantity  1
    input text  fuelItem.price  1.2345
    click button  addFuelItem
    sleep  1
    click button  submitPromptsButton

Enter Non Fuel Product
    [Tags]  qtest
    [Documentation]  Enter one or more non fuel products. Add HST/PST taxes
    [Arguments]  ${product}=None
#    IF  ${product}!=None
#        #select product and enter amount
#    END
    input text  data.hstGst  1.2345
    input text  data.pstQst  2.5432
    click button  submitPromptsButton


Verify Summary Page
    [Tags]  qtest
    [Documentation]  Sumbmit the transaction total and place transaction.
                ...  Verify summary page information and use trans_id given to verify database
    wait until page contains  2.54
    page should contain  1.23
    page should contain  2.54
    click button  submitPromptsButton
    page should contain  Transaction Total: is a required field
    input text  transactionTotal  4.00
    click button  submitPromptsButton
    wait until page contains  TRANSACTION OUT OF BALANCE|Total Balance
    page should contain  TRANSACTION OUT OF BALANCE|Total Balance
    input text  transactionTotal  5.01
    click button  submitPromptsButton
    page should contain  HST/GST
    page should contain  PST/QST
    page should contain  Transaction Id:
    ${trans_id}  get text  transId
    set test variable  ${trans_id}
