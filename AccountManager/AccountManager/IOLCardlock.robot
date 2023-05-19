*** Settings ***
Library  DateTime
Library  BuiltIn
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Test Cases ***

Stripes Sub-tab - New Record
    [Tags]  JIRA:BOT-3265  qTest:48188008  refactor

    Open eManager  ${username}  ${password}
    Navigate to IOL Cardlock Helpdesk -> Record Search
    Search for an EFS location ID
    Select Any Carrier
    Go to the Stripes Invoice sub-tab
    Add a New Stripe Rack
    Validate On DB That The Stripe Was Added

    [Teardown]  Run Keywords  Delete Created Stripe
    ...  AND  Close Browser

Stripes Sub-tab - New Record - Field Validation
    [Tags]  JIRA:BOT-3265  qTest:48188008  refactor

    Open eManager  ${username}  ${password}
    Navigate to IOL Cardlock Helpdesk -> Record Search
    Search for an EFS location ID
    Select Any Carrier
    Go to the Stripes Invoice sub-tab
    Click On Add And Validate The Required Fields

    [Teardown]  Close Browser

Stripes Sub-tab - Edit Record
    [Tags]  JIRA:BOT-3265  qTest:48188354  refactor

    Open eManager  ${username}  ${password}
    Navigate to IOL Cardlock Helpdesk -> Record Search
    Search for an EFS location ID
    Select Any Carrier
    Go to the Stripes Invoice sub-tab
    Add a New Stripe Rack
    Validate On DB That The Stripe Was Added
    Edit The Created Stripe
    You Should See The New Invoice Value

    [Teardown]  Run Keywords  Delete Created Stripe
    ...  AND  Close Browser

Stripes Sub-tab - Delete Record
    [Tags]  JIRA:BOT-3265  qTest:48188842  refactor

    Open eManager  ${username}  ${password}
    Navigate to IOL Cardlock Helpdesk -> Record Search
    Search for an EFS location ID
    Select Any Carrier
    Go to the Stripes Invoice sub-tab
    Add a New Stripe Rack
    Validate On DB That The Stripe Was Added
    Delete Created Stripe
    Stripe Should No Longer Be On The Screen

    [Teardown]  Close Browser

*** Keywords ***
Add a New Stripe Rack
    Click On Add Button
    Input Husky as Customer
    Input a Random Value For Invoice Ship To
    Input Today As Effective Date
    Input a Expire Date For After The Effective Date
    Submit Stripe Rack
    You Should See a Edit Successful Message On Screen

Click On Add And Validate The Required Fields
    Click On Add Button
    Submit Stripe Rack
    You Should See The This field is required Error For Stripe Customer
    You Should See The This field is required Error For Stripe Invoice
    You Should See The This field is required Error For Stripe Effective Date

Click On Add Button
    Wait Until Element Is Visible  //*[@id="StripesRackSearchContainer"]//span[text()="ADD"]/parent::*  timeout=10
    Click Element  //*[@id="StripesRackSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Delete Button
    Wait Until Element Is Visible  //*[@id="StripesRackSearchContainer"]//span[text()="DELETE"]/parent::*  timeout=10
    Click Element  //*[@id="StripesRackSearchContainer"]//span[text()="DELETE"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Confirm Delete
    Click Element  //*[@id="cardlockStripesRackDeleteDialogContainer"]//*[@class="submitButton" and @name="confirm"]

Delete Created Stripe
    Mark Checkbox For The Created Stripe
    Click On Delete Button
    Confirm Delete
    You Should See a Delete Successful Message On Screen

Edit Invoice Value
    Clear Element Text  cardlockStripeRack.invoiceShipTo
    Input a Random Value For Invoice Ship To

Edit The Created Stripe
    Select Stripe Created
    Edit Invoice Value
    Submit Stripe Rack
    You Should See a Edit Successful Message On Screen

Go to the Stripes Invoice sub-tab
    Click Element  //*[@id="StripesRack"]

Input ${customer} as Customer
    Input Text  cardlockStripeRack.customer  ${customer}

Input a Random Value For Invoice Ship To
    ${invoice}  Generate Random String  6  [NUMBERS]

    Input Text  cardlockStripeRack.invoiceShipTo  ${invoice}
    Set Test Variable  ${invoice}

Input Today As Effective Date
    ${today}  GetDateTimeNow  %m/%d/%Y

    Input Text  cardlockStripeRack.effectiveDate  ${today}

    Set Test Variable  ${effectiveDate}  ${today}

Input a Expire Date For After The Effective Date
    ${today}  GetDateTimeNow  %m/%d/%Y  days=2

    Input Text  cardlockStripeRack.expireDate  ${today}

    Set Test Variable  ${expireDate}  ${today}

Mark Checkbox For The Created Stripe
    Wait Until Element Is Visible  //*[@class="searchTableContainer"]//td[text()="${invoice}"]/parent::*//input[@class="id" and @type="checkbox"]  timeout=10
    Click Element  //*[@class="searchTableContainer"]//td[text()="${invoice}"]/parent::*//input[@class="id" and @type="checkbox"]

Navigate to ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Search for an EFS location ID
    Wait Until Element Is Visible  //*[@id="DataTables_Table_0_wrapper"]//*[contains(text(), 'EFS Location ID')]  timeout=10
    Click Element  //*[@id="DataTables_Table_0_wrapper"]//*[contains(text(), 'EFS Location ID')]

Select Any Carrier
    Wait Until Element Is Visible  //*[@id="DataTables_Table_0"]/tbody/tr[2]/td[1]  timeout=10
    ${count}=  get element count  //table[@id="DataTables_Table_0"]/tbody/tr
    ${number}=  Evaluate  random.choice(range(1,${count}))  random
    Click Element  //*[@id="DataTables_Table_0"]/tbody/tr[${number}]/td[1]
    Wait Until Element Is Visible  //*[@id="cardlockActionFormContainer"]/table/tbody/tr[2]/td/table/tbody/tr[2]/td[2]  timeout=10
    ${locationId}=  Get Text  //*[@id="cardlockActionFormContainer"]/table/tbody/tr[2]/td/table/tbody/tr[2]/td[2]
    Set Test Variable  ${locationId}

Select Stripe Created
    Click Element  //*[@shipto="${invoice}"]

Stripe Should No Longer Be On The Screen
    Wait Until Page Does Not Contain Element  //*[contains(text(), "${invoice}")]  timeout=10

Submit Stripe Rack
    Wait Until Element Is Visible  //*[@id="cardlockStripesRackAddActionFormContainer"]//*[@id="submit"]  timeout=10
    Click Element  //*[@id="cardlockStripesRackAddActionFormContainer"]//*[@id="submit"]

Validate On DB That The Stripe Was Added
    Get Into DB  IMPERIAL
    ${query}  Catenate  SELECT * FROM Imperial_Cardlock_STRIPES_Rack_xRef WHERE location_id='${locationId}' AND invoice_ship_to='${invoice}';
    ${result}  Query And Strip To Dictionary  ${query}
    Should Not Be Empty  ${result}

Validate On DB That The Stripe Was Removed
    Get Into DB  IMPERIAL
    ${query}  Catenate  SELECT * FROM Imperial_Cardlock_STRIPES_Rack_xRef WHERE location_id='${locationId}' AND invoice_ship_to='${invoice}';
    ${result}  Query And Strip To Dictionary  ${query}
    Should Be Empty  ${result}

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="StripesRackSearchContainer"]//ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The ${errorMessage} Error For Stripe Customer
    Wait Until Element Is Visible  //*[@for="cardlockStripeRack.customer" and text()="${errorMessage}"]

You Should See The ${errorMessage} Error For Stripe Invoice
    Wait Until Element Is Visible  //*[@for="cardlockStripeRack.invoiceShipTo" and text()="${errorMessage}"]

You Should See The ${errorMessage} Error For Stripe Effective Date
    Wait Until Element Is Visible  //*[@for="effectiveDate" and text()="${errorMessage}"]

You Should See The New Invoice Value
    Wait Until Element Is Visible  //*[contains(text(), "${invoice}")]  timeout=10