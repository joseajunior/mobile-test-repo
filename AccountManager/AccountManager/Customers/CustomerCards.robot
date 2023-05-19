*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM
Suite Setup    Get a Valid TCH Carrier

*** Variables ***

*** Test Cases ***
Autorefresh limits for Cards in Add option
    [Tags]  Q2:2023    JIRA:OT-03  qTest:120530064    API:Y
    [Documentation]  Check if the Autorefresh limits for Cards in Add option are working

    Open Account Manager
    Go to Customers Tab
    Search For ${carrier.id}
    Click Customer Submit Button
    Click On Searched ${carrier.id} Customer #
    Go to Cards Tab
    Click On Cards Submit Button
    Select The First Card Of The Grid
    Go to Products Tab
    Set Product Source to Card and click in Submit Button
    Click On Add Button
    Select Type Refresh
    Select All in Refresh Days
    Check if All Refresh Days are Selecteds
    Unselect All in Refresh Days
    Check if All Refresh Days are Unselecteds
    [Teardown]  Close Browser

Autorefresh limits for Cards in Edit option
    [Tags]  Q2:2023    JIRA:OT-03  qTest:120530143    API:Y
    [Documentation]  Create a Cards Product then check if the Autorefresh limits for Cards while edit are working
    ...              and deletes the previously created product

    Open Account Manager
    Go to Customers Tab
    Search For ${carrier.id}
    Click Customer Submit Button
    Click On Searched ${carrier.id} Customer #
    Go to Cards Tab
    Click On Cards Submit Button
    Select The First Card Of The Grid
    Go to Products Tab
    Set Product Source to Card and click in Submit Button
    Create Product
    Search By Product Description Created
    Click On Products Submit Button
    Select The Created Product In The Grid To Update
    Select Type Refresh
    Select All in Refresh Days
    Check if All Refresh Days are Selecteds
    Unselect All in Refresh Days
    Check if All Refresh Days are Unselecteds
    Close Update Products Window
    Select The Created Product In The Grid And Delete
    [Teardown]  Close Browser

*** Keywords ***
Open Account Manager
    [Tags]  qtest
    [Documentation]    Open Account Manager
    Open eManager   ${intern}   ${internPassword}
    Go to   ${emanager}/acct-mgmt/RecordSearch.action
    Wait until loading spinners are gone

Go to Customers Tab
    [Tags]  qtest
    [Documentation]    Go to Customers Tab
    Wait Until Element Is Enabled  //a[@id='Customer']
    Click Element  //a[@id='Customer']

Search For ${carrier}
    [Tags]  qtest
    [Documentation]    Search For Carrier
    Input ${carrier} As Customer #

Input ${customer_id} As Customer #
    [Tags]  qtest
    [Documentation]    Input customer_id As Customer #
    Wait Until Element Is Enabled    //input[@name="id"]
    Input Text  //input[@name="id"]  ${customer_id}

Click Customer Submit Button
    [Tags]  qtest
    [Documentation]    Click Customer Submit Button
    Wait Until Element Is Enabled    //button[contains(text(),'Submit')]
    Click Element  //button[contains(text(),'Submit')]
    Wait Until Loading Spinners Are Gone

Click On Searched ${customerId} Customer #
    [Tags]  qtest
    [Documentation]    Click On Searched customerId Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customerId}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customerId}"]
    Wait Until Loading Spinners Are Gone

Go to Cards Tab
    [Tags]  qtest
    [Documentation]    Go to Cards Tab
    Wait Until Element Is Visible    //a[@id='Cards']
    Click Element  //a[@id='Cards']

Click On Cards Submit Button
    [Tags]  qtest
    [Documentation]    Click On Cards Submit Button
    Wait Until Element Is Visible    //*[@id="customerCardsSearchContainer"]//button[@class="button searchSubmit"]
    Click Element    //*[@id="customerCardsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Get a Valid TCH Carrier
    [Tags]  qtest
    [Documentation]    Get a Valid TCH Carrier
    ${query}=  Catenate  SELECT member_id, name
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND   status = 'A'
    ...  AND (member_id between 100000 and 100038)
    ...  AND member_id not in (100003, 100004, 100009, 100010, 100025, 100027, 100028, 100029, 100032, 100033, 100035)
    ...  ORDER BY member_id
    ...  LIMIT 50;

    ${carrier}  Find Carrier Variable  ${query}  member_id  TCH
    Set Suite Variable  ${carrier}

Select The First Card Of The Grid
    [Tags]  qtest
    [Documentation]    Select The First Card Of The Grid
    Wait Until Element Is Visible    //button[@class="cardNumber buttonlink" and //input[1]]
    Click Element    //button[@class="cardNumber buttonlink" and //input[1]]
    Wait Until Loading Spinners Are Gone

Go to Products Tab
    [Tags]  qtest
    [Documentation]    Go to Products Tab
    Wait Until Element Is Visible    //a[@id='Products']
    Click Element  //a[@id='Products']
    Wait Until Loading Spinners Are Gone

Set Product Source to Card and click in Submit Button
    [Tags]  qtest
    [Documentation]    GSet Product Source to Card and click in Submit Button
    Wait Until Element Is Visible    //*[@name="detailRecord.productSource"]
    Mouse over    //*[@name="detailRecord.productSource"]
    Select from list by value    //*[@name="detailRecord.productSource"]  CARD
    Click Element    //td[@id='cardFormButtons']//button[@id='submit']
    Wait Until Loading Spinners Are Gone

Click On Add Button
    [Tags]  qtest
    [Documentation]    Click On Add Button
    Wait Until Element Is Enabled    //a[@id='ToolTables_DataTables_Table_2_1']
    Click Element  //a[@id='ToolTables_DataTables_Table_2_1']
    Wait Until Loading Spinners Are Gone

Select Type Refresh
    [Tags]  qtest
    [Documentation]    Select Type Refresh
    Wait Until Element Is Visible    //*[@name="productSummary.type"]
    Mouse over    //*[@name="productSummary.type"]
    Select from list by value    //*[@name="productSummary.type"]  REFRESH
    Wait Until Loading Spinners Are Gone

Select All in Refresh Days
    [Tags]  qtest
    [Documentation]    Select All in Refresh Days
    Wait Until Element Is Visible    //*[@name="productSummary.allRefreshDays"]
    Click Element    //*[@name="productSummary.allRefreshDays"]
    Wait Until Loading Spinners Are Gone

Check if All Refresh Days are Selecteds
    [Tags]  qtest
    [Documentation]    Check if All Refresh Days are Selecteds
    Checkbox Should Be Selected  //*[@name="productSummary.allRefreshDays"]
    Checkbox Should Be Selected  //*[@value="SUN"]
    Checkbox Should Be Selected  //*[@value="MON"]
    Checkbox Should Be Selected  //*[@value="TUE"]
    Checkbox Should Be Selected  //*[@value="WED"]
    Checkbox Should Be Selected  //*[@value="THU"]
    Checkbox Should Be Selected  //*[@value="FRI"]
    Checkbox Should Be Selected  //*[@value="SAT"]

Unselect All in Refresh Days
    [Tags]  qtest
    [Documentation]    Unselect All in Refresh Days
    Click Element    //*[@name="productSummary.allRefreshDays"]
    Wait Until Loading Spinners Are Gone

Check if All Refresh Days are Unselecteds
    [Tags]  qtest
    [Documentation]    Check if All Refresh Days are Unselecteds
    Checkbox Should Not Be Selected  //*[@name="productSummary.allRefreshDays"]
    Checkbox Should Not Be Selected  //*[@value="SUN"]
    Checkbox Should Not Be Selected  //*[@value="MON"]
    Checkbox Should Not Be Selected  //*[@value="TUE"]
    Checkbox Should Not Be Selected  //*[@value="WED"]
    Checkbox Should Not Be Selected  //*[@value="THU"]
    Checkbox Should Not Be Selected  //*[@value="FRI"]
    Checkbox Should Not Be Selected  //*[@value="SAT"]

Fill Mandatory Fields and Click On Submit Button
    [Tags]  qtest
    [Documentation]    Fill Mandatory Fields and Click On Submit Button
    Wait Until Element Is Enabled    //select[@name='productSummary.productCode']
    Mouse over    //select[@name='productSummary.productCode']
    Select from list by value    //select[@name='productSummary.productCode']  RFND
    Input Text  //input[@name="productSummary.quantity"]    3
    Click Element    //*[@value="SAT"]
    Click Element    //td[@id='cardProductsAddUpdateFormButtons']//button[@id='submit']

Click On Products Submit Button
    [Tags]  qtest
    [Documentation]    Click On Products Submit Button
    Wait Until Element Is Visible    //*[@id="cardProductsSearchContainer"]//button[@class="button searchSubmit"]
    Click Element    //*[@id="cardProductsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Search By Product Description Created
    [Tags]  qtest
    [Documentation]    Search By Product Description Created
    sleep    1
    Wait Until Element Is Visible    //input[@name="description"]
    Input Text  //input[@name="description"]    REFUND
    Press Keys   //input[@name="description"]   ENTER

Select The Created Product In The Grid To Update
    [Tags]  qtest
    [Documentation]    Select The Created Product In The Grid To Update
    Wait Until Element Is Visible    //button[@class="productsEdit buttonlink" and //input[1]]
    Click Element    //button[@class="productsEdit buttonlink" and //input[1]]
    Wait Until Loading Spinners Are Gone

Close Update Products Window
    [Tags]  qtest
    [Documentation]    Close Update Products Window
    Wait Until Element Is Visible    //button[@class="buttonlink right" and contains(text(), "Close")]
    Click Element    //button[@class="buttonlink right" and contains(text(), "Close")]

Select The Created Product In The Grid And Delete
    [Tags]  qtest
    [Documentation]    Select The Created Product In The Grid And Delete
    Wait Until Element Is Visible    //*[@value="RFND"]
    Click Element    //*[@value="RFND"]
    Wait Until Element Is Enabled    //a[@id='ToolTables_DataTables_Table_2_2']
    Click Element  //a[@id='ToolTables_DataTables_Table_2_2']
    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //button[@class="submitButton" and contains(text(), "Confirm")]
    Click Element    //button[@class="submitButton" and contains(text(), "Confirm")]

Create Product
    Click On Add Button
    Select Type Refresh
    Fill Mandatory Fields and Click On Submit Button