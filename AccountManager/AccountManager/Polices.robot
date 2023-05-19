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
Add a Policy
    [Tags]  qTest:49947614  Tier:0
    [Setup]  Get a Valid TCH Carrier

    Open Account Manager
    Search For ${carrier.id} And Go to Policies Tab
    Add Policy With Automation Policy As Policy Name And a Random Contract

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Delete Created Policy

Add a Policy - Field Validation
    [Tags]  JIRA:FRNT-1343  qTest:49947655  Tier:0
    [Setup]  Get a Valid TCH Carrier

    Open Account Manager
    Search For ${carrier.id} And Go to Policies Tab
    Click On Add And Validate Required Fields

    [Teardown]  Close Browser

*** Keywords ***
Add Policy With ${policyName} As Policy Name And a Random Contract
    Click On Add Button
    Input ${policyName} As Policy Name
    Select a Random Prompt Contract
    Click On Submit For Add Customer Policy
    You Should See a Add Successful Message On Screen

    Set Test Variable  ${policyName}

Delete Created Policy
    Get Into DB  TCH
    Execute SQL String  dml=DELETE FROM def_card WHERE id = '${carrier.id}' AND description = '${policyName}';
    Disconnect From Database

Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Add And Validate Required Fields
    Click On Add Button
    Click On Submit For Add Customer Policy
    You Should See The "Name is required." Error Message For Policy Name
    You Should See The "Contract is required." Error Message For Policy Contract

Click On Add Button
    Click Element  //*[@id="customerPoliciesSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On Searched ${customerId} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customerId}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customerId}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Add Customer Policy
    Click Element  //*[@id="customerPolicyAddActionForm"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

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

Input ${text} As Policy Name
    Input Text  //input[@name="policyDetail.name"]  ${text}

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Search For ${carrier} And Go to ${tab} Tab
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On ${tab} Tab

Select a Random Prompt Contract
    ${value}=  get value  //*[@name="policyDetail.contractId"]/option[2]
    Select From List By Value  //select[@name="policyDetail.contractId"]  ${value}

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="customerPoliciesMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The "${errorMessage}" Error Message For Policy Contract
    Check Element Exists  //label[@for="contractId" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Policy Name
    Check Element Exists  //label[@for="name" and @class="error" and text()="${errorMessage}"]
