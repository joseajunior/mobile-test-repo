*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM  refactor

*** Test Cases ***
Add a Money Code Alert With Notification and Automatic Shutoff And MoneyCode Daily Average Amount Report
    [Tags]  qTest:49947058  Tier:0

    Open Account Manager
    Search For ${username} And Go To Manage Money Code Alerts Tab
    Add a New Money Code Alert

    [Teardown]  Run Keywords  Delete Created Alert
    ...  AND  Close Browser

Add a Money Code Alert - Field Validation
    [Tags]  JIRA:FRNT-1343  qTest:49947381  Tier:0

    Open Account Manager
    Search For ${username} And Go To Manage Money Code Alerts Tab
    Click On Add Button
    Click On Submit For Create Manage Money Code Alerts
    You Should See The "This field is required." Error Message For Number previous weekdays
    You Should See The "This field is required." Error Message For Percent Threshold
    You Should See The "This field is required." Error Message For E-mail Address
    You Should See The "This field is required." Error Message For Confirm E-mail Address

    [Teardown]  Close Browser

Edit a Money Code Alert

    Open Account Manager
    Search For ${username} And Go To Manage Money Code Alerts Tab
    Add a New Money Code Alert
    Edit Created Alert
    You Should See a Edit Successful Message On Screen

    [Teardown]  Run Keywords  Delete Created Alert
    ...  AND  Close Browser

Delete a Money Code Alert

    Open Account Manager
    Search For ${username} And Go To Manage Money Code Alerts Tab
    Add a New Money Code Alert
    Delete Created Alert

    [Teardown]  Close Browser

*** Keywords ***
Add a New Money Code Alert
    Click On Add Button
    Select "Notification and Automatic Shutoff" As Alert Action Name
    Select "MoneyCode Daily Average Amount Report" As Alert Type
    Input 7 As Number previous calendar days
    Input a Random Value As Dollar Threshold
    Input efs.testers@efsllc.com As E-mail Address
    Input efs.testers@efsllc.com As Confirm E-mail Address
    Click On Submit For Create Manage Money Code Alerts
    You Should See a Add Successful Message On Screen

Change Dollar Threshold Value
    Input a Random Value As Dollar Threshold

Click On ${prompt} Prompt
    Click Element  //button[@class="promptEdit buttonlink" and text()="${prompt}"]
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Add Button
    Click Element  //*[@id="customerMoneyCodeAlertsSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Delete Button For Created Alert
    ${today}=  getDateTimeNow  %Y-%m-%d
    Wait Until Element Is Visible  //td[contains(text(), "${value}")]/parent::*//td[contains(text(), "${today}")]/parent::*//button[@name="moneyCodeDeleteConfigLink"]  timeout=10
    Click Element  //td[contains(text(), "${value}")]/parent::*//td[contains(text(), "${today}")]/parent::*//button[@name="moneyCodeDeleteConfigLink"]
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Edit Button For Created Alert
    ${today}=  getDateTimeNow  %Y-%m-%d
    Wait Until Element Is Visible  //td[contains(text(), "${value}")]/parent::*//td[contains(text(), "${today}")]/parent::*//button[@name="moneyCodeEditLink"]  timeout=10
    Click Element  //td[contains(text(), "${value}")]/parent::*//td[contains(text(), "${today}")]/parent::*//button[@name="moneyCodeEditLink"]
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Searched ${customer_id} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customer_id}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customer_id}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Create Manage Money Code Alerts
    Wait Until Element Is Visible  //*[@id="customerMoneyCodeAlertsAddUpdateFormButtons"]//button[@id="submit"]  timeout=10
    Click Element  //*[@id="customerMoneyCodeAlertsAddUpdateFormButtons"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    Wait Until Element Is Visible  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]  timeout=10
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Submit To Search Alerts
    Wait Until Element Is Visible  //*[@id="customerMoneyCodeAlertsSearchContainer"]//button[@class="button searchSubmit"]  timeout=10
    Click Element  //*[@id="customerMoneyCodeAlertsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Update To Confirm Changes On Alert
    Click Element  //*[@id="customerMoneyCodeAlertsAddUpdateActionForm"]//button[@id="submit" and text()='Update']
    Wait Until Loading Spinners Are Gone

Confirm Delete
    Click Element  //*[@id="moneyCodeDeleteConfigDialogContainer"]//button[@class="submitButton" and @name='confirm']
    Wait Until Loading Spinners Are Gone

Delete Created Alert
    Click On Delete Button For Created Alert
    Confirm Delete
    You Should See a Delete Successful Message On Screen

Edit Created Alert
    Click On Edit Button For Created Alert
    Change Dollar Threshold Value
    Click On Update To Confirm Changes On Alert
    You Should See a Edit Successful Message On Screen

Input ${customer_id} As Customer #
    Wait Until Element Is Visible  //*[@name="id"]
    Input Text  //*[@name="id"]  ${customer_id}

Input ${days} As Number previous calendar days
    Input Text  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//input[@name="daily"]  ${days}

Input ${email} As E-mail Address
    Input Text  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//input[@name="email"]  ${email}

Input ${confirmEmail} As Confirm E-mail Address
    Input Text  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//input[@name="confirmEmail"]  ${confirmEmail}

Input a Random Value As Dollar Threshold
    ${value}=  Generate Random String  3  [NUMBERS]
    Input Text  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer" or @id="customerMoneyCodeAlertsAddUpdateActionForm"]//input[@name="dollarValue"]  ${value}
    
    Set Test Variable  ${value}  ${value.__str__().lstrip('0')}

Mark Checkbox For ${prompt} As Prompt Name
    Click Element  //*[@id="customerMoneyCodePromptsSearchContainer"]//input[@type="checkbox" and @value="${prompt}"]

Search For ${carrier} And Go To ${tab} Tab
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On ${tab} Tab

Select "${field}" As Alert Action Name
    ${value}=  get value  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//select[@name="actionNameSel"]/*[contains(text(), "${field}")]
    Select From List By Value  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//select[@name="actionNameSel"]  ${value}

Select "${field}" As Alert Type
    ${value}=  get value  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//select[@name="reportTypeSel"]/*[contains(text(), "${field}")]
    Select From List By Value  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//select[@name="reportTypeSel"]  ${value}

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="customerMoneyCodeAlertsMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The "${errorMessage}" Error Message For Number previous weekdays
    Check Element Exists  //label[@for="sameDay" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Percent Threshold
    Check Element Exists  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//*[@name="percentValue"]/following-sibling::label[@class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For E-mail Address
    Check Element Exists  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//label[@for="email" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Confirm E-mail Address
    Check Element Exists  //*[@id="customerMoneyCodeAlertsAddUpdateModalContainer"]//*[@name="confirmEmail"]/following-sibling::label[@class="error" and text()="${errorMessage}"]
