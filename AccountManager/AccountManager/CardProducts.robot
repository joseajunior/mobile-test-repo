*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  AM

*** Test Cases ***
Add a Product With Refreshing Week Days
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${validCard.num}
    Add a Random Product With Refreshing Week Days As Type
    Validate on Database TCH The New Product For ${validCard.num} With ${productId} As Limit ID

    [Teardown]  Run Keywords  Delete Created Product On TCH
     ...  AND  Close Browser

Add a Product - Field Validation
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${validCard.num}
    Click On Add Product And Submit Without Changing Fields

    [Teardown]  Close Browser

Add a Product - Field Validation With Type As Refresh
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${validCard.num}
    Click On Add Product And Submit With Type As Refresh To Validate The Required Fields

    [Teardown]  Close Browser

Add a Product - Field Validation With Type As Window
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${validCard.num}
    Click On Add Product And Submit With Type As Window To Validate The Required Fields

    [Teardown]  Close Browser

Add a Product With Refreshing Weekend Days
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${validCard.num}
    Add a Random Product With Refreshing Weekend Days As Type
    Validate on Database TCH The New Product For ${validCard.num} With ${productId} As Limit ID

    [Teardown]  Run Keywords  Delete Created Product On TCH
    ...  AND  Close Browser

Add a Product With Window Hours
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${validCard.num}
    Add a Random Product With Window As Type
    Validate on Database TCH The New Product For ${validCard.num} With ${productId} As Limit ID

    [Teardown]  Run Keywords  Delete Created Product On TCH
    ...  AND  Close Browser

*** Keywords ***
Add a Random Product With Refreshing Week Days As Type
    Click On Products Tab
    Click On Add Button For Products
    Select a Random Product
    Input a Random Number As Quantity/Amount
    Select Refresh As Product Type
    Input a Random Amount Value As Daily Max Amount
    Select The Week Days As Refresh Days
    Submit New Product
    You Should See a Add Successful Message On Screen

Add a Random Product With Refreshing Weekend Days As Type
    Click On Products Tab
    Click On Add Button For Products
    Select a Random Product
    Input a Random Number As Quantity/Amount
    Select Refresh As Product Type
    Input a Random Amount Value As Daily Max Amount
    Select The Weekend Days As Refresh Days
    Submit New Product
    You Should See a Add Successful Message On Screen

Add a Random Product With Window As Type
    Click On Products Tab
    Click On Add Button For Products
    Select a Random Product
    Input a Random Number As Quantity/Amount
    Select Window As Product Type
    Input a Random Amount Of Hours As Hours
    Submit New Product
    You Should See a Add Successful Message On Screen

Change Card Status Back To Active
    Get Into DB  ${DB}
    Execute SQL String  dml=UPDATE cards SET status = 'A' WHERE card_num = '${validCard.num}'

    Disconnect From Database

Change Card Status To ${status}
    Select ${status} As Status
    Click On Submit For Card Update

Check On DB ${DB} The New Status ${status} for The Card ${card}
    Get Into DB  ${DB}
    Set Test Variable  ${DB}

    ${data}=  Query And Strip To Dictionary  SELECT * FROM cards WHERE card_num = '${card}';
    Should Be Equal As Strings  ${data.status}  ${status}

    Disconnect From Database

Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Add Button For ${tab}
    Click Element  //*[@id="${primaryTab.lower()}${tab.replace(' ', '')}SearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20
    Wait Until Load Icon Disappear

Click On Add Product And Submit Without Changing Fields
    Click On Products Tab
    Click On Add Button For Products
    Submit New Product
    You Should See The "Product is required." Error Message For Product
    You Should See The "Quantity or Amount is required." Error Message For Product Amount
    You Should See The "Type is required." Error Message For Product Type

Click On Add Product And Submit With Type As ${type} To Validate The Required Fields
    Click On Products Tab
    Click On Add Button For Products
    Select ${type} As Product Type
    Submit New Product
    You Should See The "Product is required." Error Message For Product
    You Should See The "Quantity or Amount is required." Error Message For Product Amount
    Run Keyword If    '${type}'=='Refresh'
    ...    You Should See The "Please select refresh days." Error Message For Product Refresh Days
    ...  ELSE
    ...    You Should See The "Time Window is required." Error Message For Product Hours

Click On Delete Button For ${tab}
    Click Element  //*[@id="${primaryTab.lower()}${tab.replace(' ', '')}SearchContainer"]//span[text()="DELETE"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-dialog-title" and text()='Confirm Delete']  timeout=10

Click On Searched ${customer_id} Customer #
    Click Element  //button[@class="id buttonlink" and text()="${customer_id}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Add Prompt
    Click Element  //*[@id="cardPromptsAddUpdateActionForm"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Card Update
    Sleep  2s
    Click Element  //*[@id="cardActionFormContainer"]//button[@id="submit"]

Click On Submit For ${tab} Search
    Sleep  3s
    Click Element  //*[@id="${tab.lower()}SearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Confirm Prompt Deletion
    Click Element  //*[@id="cardPromptsDeleteDialogContainer"]//button[@class="submitButton" and @name='confirm']
    Wait Until Loading Spinners Are Gone

Delete Created Product On ${DB}
    Get Into DB  ${DB}

    Execute SQL String  dml=DELETE FROM card_lmt WHERE card_num = '${validCard.num}' And limit_id='${productId}';

    Disconnect From Database

Go To Cards Tab
    Click Element  //*[@id="Card"]
    Wait Until Loading Spinners Are Gone

    Set Test Variable  ${primaryTab}  Card

Input ${cardNum} As Card #
    Input Text  //*[@name="cardNumber"]  ${cardNum}

Input a Random Number As Quantity/Amount
    ${amount}=  Generate Random String  3  [NUMBERS]
    ${amount}=  Convert To Integer  ${amount}
    Input Text  productSummary.quantity  ${amount}

    Set Test Variable  ${amount}

Input a Random Amount Value As Daily Max Amount
    ${maxAmount}=  Evaluate  random.choice(range(1,${amount}))  random
    Input Text  productSummary.quantity  ${maxAmount}

Input a Random Amount Of Hours As Hours
    ${hours}=  Evaluate  random.choice(range(1,24))  random
    Input Text  productSummary.timeWindow  ${hours}

Mark Checkbox for ${prompt_id} Prompt
    Click Element  //*[@value="${prompt_id}" and @type="checkbox"]

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Open The Searched Card
    Click Element  //button[@class="cardNumber buttonlink" and text()="${validCard.num}"]
    Wait Until Loading Spinners Are Gone

Search And Select Card ${cardNum}
    Go To Cards Tab
    Select EFS LLC As Business Partner
    Input ${cardNum} As Card #
    Click On Submit For Card Search
    Open The Searched Card

Select ${partner} As Business Partner
    Wait Until Element Is Visible  //select[@class='${primaryTab.lower()}BusinessPartnerSelect searchFilter']
    Select From List By Label  //select[@class='${primaryTab.lower()}BusinessPartnerSelect searchFilter']  ${partner}

Select ${method} As Method
    Select From List By Label  promptSummary.methodCode  ${method}

Select ${status} As Status
    Select From List By Label  detailRecord.status  ${status}

Select a Random Product
    ${number}=  Evaluate  random.choice(range(2,51))  random
    ${productId}=  Get Value  //*[@id="cardProductsAddUpdateActionFormContainer"]//select[@name="productSummary.productCode"]/option[${number}]
    ${productName}=  Get Text  //*[@id="cardProductsAddUpdateActionFormContainer"]//select[@name="productSummary.productCode"]/option[${number}]
    Select From List By Value  //*[@id="cardProductsAddUpdateActionFormContainer"]//select[@name="productSummary.productCode"]  ${productId}

    Set Test Variable  ${productId}
    Set Test Variable  ${productName}

Select The Week Days As Refresh Days
    ${days}=  Create List  MON  TUE  WED  THU  FRI
    FOR  ${day}  IN  @{days}
        Click Element  //*[@id="cardProductsAddUpdateActionForm"]//input[@name="productSummary.refreshDays" and @value="${day}"]
    END

Select The Weekend Days As Refresh Days
    ${days}=  Create List  SUN  SAT
    FOR  ${day}  IN  @{days}
        Click Element  //*[@id="cardProductsAddUpdateActionForm"]//input[@name="productSummary.refreshDays" and @value="${day}"]
    END

Select ${type} As Product Type
    Select From List By Label  productSummary.type  ${type}

Submit New Product
    Click Element  //*[@id="cardProductsAddUpdateFormButtons"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Validate on Database ${DB} The New Product For ${card} With ${limitId} As Limit ID
    Get Into DB  ${DB}
    ${query}  Catenate  SELECT * FROM card_lmt
    ...  WHERE card_num='${card}'
    ...  AND limit_id='${limitId}'
    Row Count is Equal to X  ${query}  1

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

You Should See ${text} If Info Id Is Equals to ${info}
    Run Keyword If  '${info_id}'=='${info}'  Check Element Exists  //button[@class="promptEdit buttonlink" and text()='${text}']

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="cardProductsSearchContainer"]//ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See a ${msgSuccess} Message For Card Update
    Wait Until Element Is Visible  //*[@id="cardActionFormContainer"]//ul[@class="msgSuccess"]//li[contains(text(), '${msgSuccess}')]  timeout=20

You Should See The ${prompt} Prompt
    Check Element Exists  //button[@class="promptEdit buttonlink" and text()='${prompt}']

You Should See The "${errorMessage}" Error Message For Product
    Check Element Exists  //label[@for="productSummary.productCode" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Product Amount
    Check Element Exists  //label[@for="productSummary.quantity" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Product Type
    Check Element Exists  //*[@for="productSummary.type" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Product Refresh Days
    Check Element Exists  //label[@for="productSummary.refreshDays" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Product Hours
    Check Element Exists  //*[@for="productSummary.timeWindow" and @class="error" and text()="${errorMessage}"]
