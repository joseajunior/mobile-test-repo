*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Test Cases ***
Add a Money Code Prompt
    [Tags]  qTest:49946282  Tier:0
    [Setup]  Get a Valid TCH Carrier

    Open Account Manager
    Search For ${carrier.id} Customer And Go To Money Code Prompts Tab
    Add New Prompt

    [Teardown]  Run Keywords  Delete Created Prompt
    ...  AND  Close Browser

Add a Money Code Prompts - Field Validation
    [Tags]  JIRA:FRNT-1343  qTest:49946354  Tier:0
    [Setup]  Get a Valid TCH Carrier

    Open Account Manager
    Search For ${carrier.id} Customer And Go To Money Code Prompts Tab
    Click On Add And Validate Required Fields

    [Teardown]  Close Browser

Edit a Money Code Prompt
    [Setup]  Get a Valid TCH Carrier

    Open Account Manager
    Search For ${carrier.id} Customer And Go To Money Code Prompts Tab
    Add New Prompt
    Edit Created Prompt Changing Required To Yes

    [Teardown]  Run Keywords  Delete Created Prompt
    ...  AND  Close Browser

Delete a Money Code Prompt
    [Setup]  Get a Valid TCH Carrier

    Open Account Manager
    Search For ${carrier.id} Customer And Go To Money Code Prompts Tab
    Add New Prompt
    Delete Created Prompt

    [Teardown]  Close Browser

*** Keywords ***
Add New Prompt
    Click On Add Button
    Select Any Item For "Prompt Name", Driver ID In This Case
    Select No As Required For New Prompt
    Click On Submit For Add Prompt
    You Should See a Add Successful Message On Screen

Click On ${prompt} Prompt To Edit
    Click Element  //button[@class="promptEdit buttonlink" and text()="${prompt}"]
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Add And Validate Required Fields
    Click On Add Button
    Click On Submit For Add Prompt
    You Should See The "This field is required." Error Message For Prompt Name
    You Should See The "This field is required." Error Message For Prompt Required

Click On Add Button
    Click Element  //*[@id="customerMoneyCodePromptsSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Delete Button
    Click Element  //*[@id="customerMoneyCodePromptsSearchContainer"]//span[text()="DELETE"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Searched ${customer_id} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customer_id}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customer_id}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Add Prompt
    Click Element  //*[@id="customerMoneyCodePromptsAddFormButtons"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Update Prompt
    Click Element  //*[@id="customerMoneyCodePromptsUpdateActionFormContainer"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click On Submit To Search Prompts
    Click Element  //*[@id="customerMoneyCodePromptsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Confirm Delete
    Click Element  //*[@id="customerMoneyCodePromptsDeleteDialogContainer"]//button[@class="submitButton" and @name='confirm']
    Wait Until Loading Spinners Are Gone

Delete Created Prompt
    Mark Checkbox For Driver ID As Prompt Name
    Click On Delete Button
    Confirm Delete
    You Should See a Delete Successful Message On Screen

Edit Created Prompt Changing Required To Yes
    Click On Driver ID Prompt To Edit
    Select Yes As Required For Update Prompt
    Click On Submit For Update Prompt
    You Should See a Edit Successful Message On Screen

Get a Valid TCH Carrier
    Get Into DB  TCH

    ${query}=  Catenate  SELECT *
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND (member_id between 100000 and 200000 OR member_id between 300000 and 389999)
    ...  LIMIT 100;

    ${carrier}  Find Carrier Variable  ${query}  member_id  TCH

    Set Test Variable  ${carrier}

Input ${customer_id} As Customer #
    Wait Until Element Is Visible  //*[@name="id"]
    Input Text  //*[@name="id"]  ${customer_id}

Mark Checkbox For ${prompt} As Prompt Name
    Click Element  //*[@id="customerMoneyCodePromptsSearchContainer"]//input[@type="checkbox" and @value="${prompt}"]

Search For ${customer} Customer And Go To ${tab} Tab
    Input ${customer} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${customer} Customer #
    Click On Money Code Prompts Tab

Select Any Item For "Prompt Name", ${field} In This Case
    Wait Until Load Icon Disappear
    ${value}=  get value  //*[@*="moneyCodePrompts.infoId"]/*[contains(text(), "${field}")]
    Select From List By Value  //select[@name="moneyCodePrompts.infoId"]  ${value}

Select ${value} As Required For New Prompt
    Select From List By Label  //*[@id="customerMoneyCodePromptsAddActionFormContainer"]//select[@name="moneyCodePrompts.reqdFlag"]  ${value}

Select ${value} As Required For Update Prompt
    Select From List By Label  //*[@id="customerMoneyCodePromptsUpdateActionFormContainer"]//select[@name="moneyCodePrompts.reqdFlag"]  ${value}

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="customerMoneyCodePromptsMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The "${errorMessage}" Error Message For Prompt Name
    Check Element Exists  //label[@for="moneyCodePrompts.infoId" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Prompt Required
    Check Element Exists  //label[@for="moneyCodePrompts.reqdFlag" and @class="error" and text()="${errorMessage}"]
