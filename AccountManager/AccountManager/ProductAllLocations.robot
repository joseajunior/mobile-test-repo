*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Documentation  Tests every possible combination of policy and card limits given the limit source.
...  No preauthorization is ran to validate. Rather only database checks verify that the limits
...  updated on the card through Account Manager are correctly saved in the database.

Force Tags  AM

*** Test Cases ***
Add Product All Locations
    [Tags]  qTest:31751536  Tier:0  refactor
    [Setup]  Get a Valid TCH Carrier Without OLIC Product

    Open Account Manager
    Search For ${carrier.id} Customer And Go To Product All Locations Tab
    Add a New Location Product

    [Teardown]  Run Keywords  Delete Created Product
    ...  AND  Close Browser

Add a Product All Locations - Field Validation
    [Tags]  JIRA:FRNT-1343  qTest:49944686  Tier:0
    [Setup]  Get a Valid TCH Carrier Without OLIC Product

    Open Account Manager
    Search For ${carrier.id} Customer And Go To Product All Locations Tab
    Click On Add And Validate Required Fields

    [Teardown]  Close Browser

Delete a Product All Locations
    [Setup]  Get a Valid TCH Carrier Without OLIC Product
    [Tags]  refactor

    Open Account Manager
    Search For ${carrier.id} Customer And Go To Product All Locations Tab
    Add a New Location Product
    Delete Created Product

    [Teardown]  Close Browser

*** Keywords ***
Add a New Location Product
    Click On Add Button
    Select Any Item For "Product", Oil Change In This Case
    Input 1 As Active
    Input Today As Last Updated
    Click On Submit For Add Product
    You Should See a Add Successful Message On Screen

Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Add And Validate Required Fields
    Click On Add Button
    Click On Submit For Add Product
    You Should See The "Please Select a Product from the dropdown" Error Message For Product
    You Should See The "Active is required" Error Message For Product Active
    You Should See The "Please enter a date in the format mm/dd/yyyy" Error Message For Product Last Updated

Click On Add Button
    Click Element  //*[@id="customerProductAllLocationsSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Delete Button
    Click Element  //*[@id="customerProductAllLocationsSearchContainer"]//span[text()="DELETE"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Searched ${customer_id} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customer_id}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customer_id}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Add Product
    Click Element  //*[@id="customerProductAllLocationsAddFormButtons"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Submit To Search Locations
    Click Element  //*[@id="customerProductAllLocationsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Confirm Delete
    Click Element  //*[@id="customerProductAllLocationsDeleteDialogContainer"]//button[@class="submitButton" and @name='confirm']
    Wait Until Loading Spinners Are Gone

Delete Created Product
    Mark Checkbox For OLIC As Product
    Click On Delete Button
    Confirm Delete
    You Should See a Delete Successful Message On Screen

Get a Valid TCH Carrier Without ${limitId} Product
    Get Into DB  TCH

    ${query}=  Catenate  SELECT *
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND (member_id between 100000 and 200000 OR member_id between 300000 and 389999)
    ...  AND member_id NOT IN (SELECT carrier_id FROM loc_all_products WHERE limit_id = '${limitId}')
    ...  LIMIT 100;

    ${carrier}  Find Carrier Variable  ${query}  member_id  TCH

    Set Test Variable  ${carrier}


If ${message} Add a New Location
    ${notFound}=  Run Keyword And Return Status  Check Element Exists  //td[@class="dataTables_empty" and text()="${message}"]
    Return From Keyword If  ${notFound}==False  ${None}
    Click On Add Button
    Select Any Item For "Product", Oil Change In This Case
    Input 1 As Active
    Input Today As Last Updated
    Click On Submit For Add Product
    You Should See a Add Successful Message On Screen

Input ${text} As Active
    Input Text  //input[@name="customerDetail.active"]  ${text}

Input ${customer_id} As Customer #
    Input Text  //*[@name="id"]  ${customer_id}

Input Today As Last Updated
    ${today}=  GetDateTimeNow  %m/%d/%Y
    Input Text  //input[@name="customerDetail.lastUpdated"]  ${today}

Mark Checkbox For ${product} As Product
    Click Element  //input[@type="checkbox" and @product="${product}"]

Search For ${customer} Customer And Go To ${tab} Tab
    Input ${customer} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${customer} Customer #
    Click On ${tab} Tab

Select Any Item For "Product", Oil Change In This Case
    Wait Until Load Icon Disappear
    Select From List By Value  customerDetail.product  OLIC

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="customerProductAllLocationsMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The "${errorMessage}" Error Message For Product
    Check Element Exists  //label[@for="customerDetail.product" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Product Active
    Check Element Exists  //label[@for="customerDetail.active" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Product Last Updated
    Check Element Exists  //*[@name="customerDetail.lastUpdated"]/following-sibling::label[@class="error" and text()="${errorMessage}"]
