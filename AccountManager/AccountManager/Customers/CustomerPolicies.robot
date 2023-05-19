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
Autorefresh limits for Policies in Add option
    [Tags]  Q2:2023    JIRA:OT-03  qTest:120529512    API:Y
    [Documentation]  Check if the Autorefresh limits for Policies in Add option are working

    Open Account Manager
    Go to Customers Tab
    Search For ${carrier.id}
    Click Customer Submit Button
    Click On Searched ${carrier.id} Customer #
    Go to Policies Tab
    Click On Policies Submit Button
    Select The First Policy Of The Grid
    Go to Products Tab
    Click On Add Button
    Select Type Refresh
    Select All in Refresh Days
    Check if All Refresh Days are Selecteds
    Unselect All in Refresh Days
    Check if All Refresh Days Are Unselecteds And Close The Window
    [Teardown]  Close Browser

Autorefresh limits for Policies in Edit option
    [Tags]  Q2:2023    JIRA:OT-03  qTest:120530053    API:Y
    [Documentation]  Check if the Autorefresh limits for Policies while edit are working

    Open Account Manager
    Go to Customers Tab
    Search For ${carrier.id}
    Click Customer Submit Button
    Click On Searched ${carrier.id} Customer #
    Go to Policies Tab
    Click On Policies Submit Button
    Select The First Policy Of The Grid
    Go to Products Tab
    Click On Products Submit Button
    Select The First Product In The Grid To Update
    Select Type Refresh
    Select All in Refresh Days
    Check if All Refresh Days are Selecteds
    Unselect All in Refresh Days
    Check if All Refresh Days Are Unselecteds And Close The Window
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

Go to Policies Tab
    [Tags]  qtest
    [Documentation]    Go to Policies Tab
    Wait Until Element Is Visible    //a[@id='Policies']
    Click Element  //a[@id='Policies']

Click On Policies Submit Button
    [Tags]  qtest
    [Documentation]    Click On Policies Submit Button
    Wait Until Element Is Visible    //*[@id="customerPoliciesSearchContainer"]
    Click Element    //*[@id="customerPoliciesSearchContainer"]
    Wait Until Loading Spinners Are Gone

Select The First Policy Of The Grid
    [Tags]  qtest
    [Documentation]    Select The First Policy Of The Grid
    Wait Until Element Is Visible    //button[@class="id buttonlink" and //input[1]]
    Click Element    //button[@class="id buttonlink" and //input[1]]
    Wait Until Loading Spinners Are Gone

Go to Products Tab
    [Tags]  qtest
    [Documentation]    Go to Products Tab
    Wait Until Element Is Visible    //a[@id='Products']
    Click Element  //a[@id='Products']
    Wait Until Loading Spinners Are Gone

Click On Add Button
    [Tags]  qtest
    [Documentation]    Click On Add Button
    Wait Until Element Is Enabled    //a[@id='ToolTables_DataTables_Table_1_1']
    Click Element  //a[@id='ToolTables_DataTables_Table_1_1']
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

Check if All Refresh Days Are Unselecteds And Close The Window
    [Tags]  qtest
    [Documentation]    Check if All Refresh Days Are Unselecteds And Close The Window
    Checkbox Should Not Be Selected  //*[@name="productSummary.allRefreshDays"]
    Checkbox Should Not Be Selected  //*[@value="SUN"]
    Checkbox Should Not Be Selected  //*[@value="MON"]
    Checkbox Should Not Be Selected  //*[@value="TUE"]
    Checkbox Should Not Be Selected  //*[@value="WED"]
    Checkbox Should Not Be Selected  //*[@value="THU"]
    Checkbox Should Not Be Selected  //*[@value="FRI"]
    Checkbox Should Not Be Selected  //*[@value="SAT"]
    Wait Until Element Is Visible    //button[@class="buttonlink right" and contains(text(), "Close")]
    Click Element    //button[@class="buttonlink right" and contains(text(), "Close")]

Click On Products Submit Button
    [Tags]  qtest
    [Documentation]    Click On Products Submit Button
    Wait Until Element Is Visible    //*[@id="policyProductsSearchContainer"]//button[@class="button searchSubmit"]
    Click Element    //*[@id="policyProductsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Select The First Product In The Grid To Update
    [Tags]  qtest
    [Documentation]    Select The First Product In The Grid To Update
    Wait Until Element Is Visible    //button[@class="productsEdit buttonlink" and //input[1]]
    Click Element    //button[@class="productsEdit buttonlink" and //input[1]]
    Wait Until Loading Spinners Are Gone