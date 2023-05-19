*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  String
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../Variables/validUser.robot

Force Tags      eManager

Suite Setup  Setup
Suite Teardown  Teardown

*** Variables ***


*** Test Cases ***
Make Successful Payment for Parkland carrier
    [Tags]  Jira:ROCKET-424  Jira:ROCKET-85  Jira:ROCKET-167  qTest:54399878  PI:12  API:Y
    [Setup]  Find a Parkland carrier
    Login and get to Partner Online Payments
    Select payment  ${invoiceDetails['invoice']}
    Verify total amount  ${invoiceDetails['open_amount']}
    Verify Row has database info  ${invoiceDetails}
    Verify Available Credit
    Enter Email  test@wexinc.com
    Enter Confirm Email  test@wexinc.com
    enter comment  Here is my amazing comment
    Submit Payment
    Verify Payment is in database  ${invoiceDetails['carrier_id']}  ${invoiceDetails['invoice']}  ${invoiceDetails['open_amount']}
    [Teardown]  close browser

Make Successful Payment Long Comment
    [Tags]  Jira:ROCKET-424  Q1:2023  API:Y
    [Setup]  Find a Parkland carrier
    Login and get to Partner Online Payments
    Select payment  ${invoiceDetails['invoice']}
    Verify total amount  ${invoiceDetails['open_amount']}
    Verify Row has database info  ${invoiceDetails}
    Verify Available Credit
    Enter Email  test@wexinc.com
    Enter Confirm Email  test@wexinc.com
    ${comment}  Generate Random String  200
    enter comment  ${comment}
    Submit Payment
    Verify Payment is in database  ${invoiceDetails['carrier_id']}  ${invoiceDetails['invoice']}  ${invoiceDetails['open_amount']}
    [Teardown]  close browser

Payment Comment too long
    [Tags]  Jira:ROCKET-424  Q1:2023  API:Y
    [Setup]  Find a Parkland carrier
    Login and get to Partner Online Payments
    Select payment  ${invoiceDetails['invoice']}
    Verify total amount  ${invoiceDetails['open_amount']}
    Verify Row has database info  ${invoiceDetails}
    Verify Available Credit
    Enter Email  test@wexinc.com
    Enter Confirm Email  test@wexinc.com
    ${comment}  Generate Random String  201
    enter comment  ${comment}
    click button  doSubmit
    page should contain  A comment should not be more then 200 characters
    [Teardown]  close browser

Successful Payment - Payment date in Future
    [Tags]  Jira:ROCKET-424  Jira:ROCKET-85  Jira:ROCKET-167  qTest:116043881  PI:12  API:Y
    [Setup]  Find a Parkland carrier
    Login and get to Partner Online Payments
    Select Day in the Future
    Select payment  ${invoiceDetails['invoice']}
    Verify total amount  ${invoiceDetails['open_amount']}
    Verify Row has database info  ${invoiceDetails}
    Verify Available Credit
    Enter Email  test@wexinc.com
    Enter Confirm Email  test@wexinc.com
    enter comment  Here is my amazing comment
    Submit Payment
    Verify Payment Date is in Future  ${invoiceDetails['carrier_id']}  ${invoiceDetails['invoice']}  ${invoiceDetails['open_amount']}
    [Teardown]  close browser


Unsuccessful Payment - Missing Email
    [Tags]  Jira:ROCKET-424  Jira:ROCKET-85  Jira:ROCKET-167  qTest:116043883  PI:12  API:Y
    [Setup]  Find a Parkland carrier
    Login and get to Partner Online Payments
    Select payment  ${invoiceDetails['invoice']}
    Enter Confirm Email  ${EMPTY}
    Enter Email  test@wexinc.com
    Try to Submit  Email Address is required
    [Teardown]  close browser


Successful Payment - Missing Comment
    [Tags]  Jira:ROCKET-424  Jira:ROCKET-167  qTest:116043885  PI:12  API:Y
    [Setup]  Find a Parkland carrier
    Login and get to Partner Online Payments
    Select payment  ${invoiceDetails['invoice']}
    Verify total amount  ${invoiceDetails['open_amount']}
    Verify Row has database info  ${invoiceDetails}
    Verify Available Credit
    Enter Email  test@wexinc.com
    Enter Confirm Email  test@wexinc.com
    Submit Payment
    Verify Payment is in database  ${invoiceDetails['carrier_id']}  ${invoiceDetails['invoice']}  ${invoiceDetails['open_amount']}
    [Teardown]  close browser



Verify Available Credit - Verify Available Credit With No Invoices
    [Tags]  Jira:ROCKET-424  Jira:ROCKET-279  qTest:116042645  PI:14  API:Y
    [Setup]  Find a Parkland carrier
    Login and get to Partner Online Payments
    Select All Payments
    Enter Email  test@wexinc.com
    Enter Confirm Email  test@wexinc.com
    enter comment  Here is my amazing comment
    Submit Payment
    Go To  ${emanager}/cards/PartnerOnlinePayment.action
    Verify Available Credit
    [Teardown]  close browser


*** Keywords ***
Setup
    ${today}  getdatetimenow  %Y-%m-%d
    set suite variable  ${today}

Find a Parkland carrier
    [Tags]  qtest
    [Documentation]  Need to find a parkland carrier in TCH database
    ...  select member_id from member where carrier_type = 'PKLN'
    ...  with that list find a parkland carrier with invoice details in postgres pricing database
    ...  select * from invoice_detail where carrier_id in (<list from member table>) limit 1
    ...  copy down data from invoice details
    ...  ---------
    ...  now back to tch database to get password to be able to log in as carrier
    ...  select passwd from member where member_id = <carrier found from invoice_detail table>
    ...  ---------
    ...  Follow TC-4254 to make sure role PARTNER_ONLINE_PAYMENT is assigned to carrier
    ${informixmembersql}  catenate  select member_id from member where carrier_type = 'PKLN'
    ${parklandCarriers}  query and strip to dictionary  ${informixmembersql}  db_instance=TCH
    ${carrier_list}  create list for query  ${parklandCarriers['member_id'].__str__()}
    ${postgressql}  catenate  select * from invoice_detail where carrier_id in ('${carrier_list}')
    ...  and invoice not in (select invoice from payment_detail where carrier_id in ('${carrier_list}')) limit 1
    ${invoiceDetails}  query and strip to dictionary  ${postgressql}  db_instance=postgrespgpricing
    set test variable  ${invoiceDetails}
    ${carrier_query}  catenate  select * from member where member_id = ${invoiceDetails['carrier_id']}
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id    TCH
    Set Test Variable  ${carrier}
    ${cnt}  query and strip  select count(*) from sec_user where user_id = ${carrier.id}  db_instance=MYSQL
    IF  ${cnt} < 1
        Open eManager  ${intern}  ${internPassword}
        close browser
    END
    Open eManager  ${intern}  ${internPassword}
    Add User Role If Not Exists  ${carrier.id}  PARTNER_ONLINE_PAYMENT
    ${sql}  catenate  update cont_misc set ach_min_amt = 1, ach_max_amt = 99999 where contract_id = ${invoiceDetails['contract_id']};
    execute sql string  ${sql}  db_instance=tch
    Switch to "${carrier.id}" Carrier

Login and get to Partner Online Payments
    [Tags]  qtest
    [Documentation]  Login to emanager as carrier follow TC-1361
    ...  go to select program > credit management > Partner Online Payment
    Go To  ${emanager}/cards/PartnerOnlinePayment.action
    wait until element is visible  //*[@id="contractId"]
    sleep  2
    select from list by value  name:contractId  ${invoiceDetails['contract_id']}

Create List for query
    [Arguments]  ${dict}
    ${status}  run keyword and return status  should not be equal as strings  ${dict}  string
    return from keyword if  '${status}'=='${False}'
    ${qlist}=  evaluate  [x.__str__().strip() for x in ${dict}]
    ${qlist}=  evaluate  str(${qlist})[2:-2]
    [Return]  ${qlist}

Enter comment
    [Tags]  qtest
    [Documentation]  Input some text into the comments box
    [Arguments]  ${comment}
    input text  commentId  ${comment}

Enter Email
    [Tags]  qtest
    [Documentation]  Input some text into the email box
    [Arguments]  ${email}
    input text  email1  ${email}

Enter Confirm Email
    [Tags]  qtest
    [Documentation]  Input same text into the confirm email box as above
    [Arguments]  ${email}
    input text  email2  ${email}

Submit Payment
    [Tags]  qtest
    [Documentation]  Click on the Authorize Payment Button
    click button  doSubmit
    click button  //*[contains(text(), 'Ok')]
    page should contain  Your payment was processed

Try to Submit
    [Tags]  qtest
    [Documentation]  Try to click submit, should see arg0
    [Arguments]  ${error}
    run keyword and ignore error  click button  doSubmit
    page should contain  ${error}

Change Paydate to
    [Tags]  qtest
    [Documentation]  format is YYYY-MM-DD
    ..  dates in future are fine but date in past should error
    [Arguments]  ${paydate}
    input text  payDate  ${paydate}

Select payment
    [Tags]    qtest
    [Documentation]    Select the payment for the invoice found during setup step
    [Arguments]  ${invoice}
#    //*[@id="searchCustomerTable"]/tbody/tr/td[1]/a[text()='${user_id}']
    wait until element is visible  //td[@id=${invoice}]//input[@type='checkbox']
    click element  //td[@id=${invoice}]//input[@type='checkbox']

Verify Row has database info
    [Tags]    qtest
    [Documentation]    Using the invoice data verify UI has all the correct values
    ...  ie original amt, open amt, currency etc
    [Arguments]  ${invoicedict}
    ${origAmt}  get text  //td[@id=${invoicedict['invoice']} and @class=' rowOrigAmt']
    ${origAmt}    Remove String        ${origAmt}   ,    $
    ${origAmt}    Convert To Number    ${origAmt}
    should be equal as numbers  ${invoicedict['original_amount']}  ${origAmt}
    ${openAmt}  get text  //td[@id=${invoicedict['invoice']} and @class=' rowOpenAmt']
    ${openAmt}    Remove String        ${openAmt}   ,    $
    ${openAmt}    Convert To Number    ${openAmt}
    should be equal as numbers  ${invoicedict['open_amount']}  ${openAmt}
    ${curr}  get text  //td[@id=${invoicedict['invoice']} and @class=' rowCurrency']
    should be equal as strings  ${invoicedict['currency']}  ${curr}
    ${duedate}  get text  //td[@id=${invoicedict['invoice']} and @class=' rowDueDate']
    should be equal as strings  ${invoicedict['due_date']}  ${duedate}

Verify total amount
    [Tags]    qtest
    [Documentation]    Using the invoice data verify UI has correct total
    [Arguments]  ${total}
    ${uitotal}  get text  //span[@id='ftrTotalPmtAmtFormated']
    ${uitotal}    Remove String        ${uitotal}   ,    $
    ${uitotal}    Convert To Number    ${uitotal}
    should be equal as numbers  ${total}  ${uitotal}

Verify Payment is in database
    [Tags]    qtest
    [Documentation]    get into postgress database and run
    ...  select * from payment_detail where carrier_id = {carrier} and invoice = '{invoice}'
    ...  Verify payment is in the database
    [Arguments]  ${carrier}  ${invoice}  ${amt}
    sleep  5
    ${postgressql}  catenate  select * from payment_detail where carrier_id = ${carrier} and invoice = '${invoice}'
    ${paymentDetails}  query and strip to dictionary  ${postgressql}  db_instance=postgrespgpricing
    should be equal as strings  ${paymentDetails['batched']}  None
    should be equal as numbers  ${paymentDetails['payment_amount']}  ${amt}
    ${sql}  catenate  delete from payment_detail where carrier_id = ${carrier} and invoice = '${invoice}'
    execute sql string  ${sql}  db_instance=postgrespgpricing


Select Day in the Future
    sleep  2
    click element  //img[@title='...']
    click element  //span[@class='ui-icon ui-icon-circle-triangle-e']
    click element  //a[contains(text(), '2')]

Verify Payment Date is in Future
    [Tags]    qtest
    [Documentation]    get into postgress database and run
    ...  select * from payment_detail where carrier_id = {carrier} and invoice = '{invoice}'
    ...  Verify date is in future is in the database
    [Arguments]  ${carrier}  ${invoice}  ${amt}
    sleep  5
    ${postgressql}  catenate  select * from payment_detail where carrier_id = ${carrier} and invoice = '${invoice}'
    ${paymentDetails}  query and strip to dictionary  ${postgressql}  db_instance=postgrespgpricing
    should be equal as strings  ${paymentDetails['payment_type']}  onl
    should be equal as numbers  ${amt}  ${paymentDetails['payment_amount']}
    ${year}  getDateTimeNow  %Y
    ${month}  getdatetimenow  %m
    IF  '${month}'=='12'
        ${month}  set variable  01
        ${year}  convert to integer  ${year}
        ${year}  evaluate  ${year}+1
    ELSE
        ${month}  convert to integer  ${month}
        ${month}  evaluate  ${month}+1
        IF  ${month}<10
            ${month}  set variable  0${month}
        END
    END
    should be equal as strings  ${paymentDetails['payment_create'].__str__()}  ${year}-${month}-02 00:00:00

Verify Available Credit
    [Tags]  qtest  expect_results:UI should have the same available_credit as the database
    [Documentation]    Refresh screen by go to select program > credit management > Partner Online Payment
    ...  Use the query below to get database value
    ...  select sum(credit_limit) - sum(credit_bal) as available_credit from
    ...  contract where carrier_id = {carrier_id} and contract_id =  {'contract_id'}
    ${availableCreditSql}  catenate    select sum(credit_limit) - sum(credit_bal) as available_credit from
    ...  contract where carrier_id = ${invoiceDetails['carrier_id']} and contract_id =  ${invoiceDetails['contract_id']}
    ${availableCredit}  query and strip  ${availableCreditSql}  db_instance=tch
    wait until element is visible  //span[@id='availableCreditAmt']
    ${uiavailableCredit}  get text  //span[@id='availableCreditAmt']
    ${removeSpecial}      assign string  ${uiavailableCredit.replace('$' ,'')}
    ${finalAvailableCredit}     assign string  ${removeSpecial.replace(',' ,'')}
    FOR  ${i}  IN RANGE  5
        exit for loop if  ${availableCredit}==${finalAvailableCredit}
        sleep  1
        ${uiavailableCredit}  get text  //span[@id='availableCreditAmt']
        ${removeSpecial}      assign string  ${uiavailableCredit.replace('$' ,'')}
        ${finalAvailableCredit}     assign string  ${removeSpecial.replace(',' ,'')}
    END
    should be equal as numbers  ${availableCredit}  ${finalAvailableCredit}

Select All Payments
    [Tags]  qtest
    [Documentation]    select all payments needing made
    wait until element is visible  //*[@id="pay"]
    click element  //*[@id="pay"]

Teardown
    ${sql}  catenate  delete from payment_detail where payment_create = '${today}';
    execute sql string  ${sql}  db_instance=postgrespgpricing
