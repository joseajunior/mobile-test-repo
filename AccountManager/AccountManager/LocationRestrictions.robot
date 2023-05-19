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


Documentation  Tests every possible combination of policy and card limits given the limit source.
...  No preauthorization is ran to validate. Rather only database checks verify that the limits
...  updated on the card through Account Manager are correctly saved in the database.

Force Tags  AM  refactor

*** Test Cases ***
Add a Location Restrictions - Location As Location Type
    [Tags]  qTest:49946538  Tier:0

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Management -> Account Manager
    Input ${username} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${username} Customer #
    Click On Location Restrictions Tab
    Click On Add Button
    Select "Location" As Location Type
    Input a Random Location ID As ID #
    Input Today As Effective Date
    Input Tomorrow As Expire Date
    Click On Submit For Add Location Restrictions by Parent
    You Should See a Add Successful Message On Screen

    [Teardown]  Close Browser

Add Location Restrictions - Field Validation
    [Tags]  JIRA:FRNT-1343  qTest:49946915  Tier:0

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Management -> Account Manager
    Input ${username} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${username} Customer #
    Click On Location Restrictions Tab
    Click On Add Button
    Click On Submit For Add Location Restrictions by Parent
    You Should See The "This field is required" Error Message For Location Restriction ID #
    You Should See The "Effective Date must be greater than or equal to Today!" Error Message For Location Restriction Effective Date

    [Teardown]  Close Browser

*** Keywords ***
Click On Add Button
    Click Element  //*[@id="customerLocationRestrictionsSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20

Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Searched ${customerId} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customerId}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customerId}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Add Location Restrictions by Parent
    Click Element  //*[@id="locationRestrictionsAddFormButtons"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Input ${customer_id} As Customer #
    Wait Until Element Is Visible  //*[@name="id"]
    Input Text  //*[@name="id"]  ${customer_id}

Input a Random Location ID As ID #
    Get Into DB  TCH
    ${query}=  Catenate  select location_id from location where status = 'A' limit 20;
    ${result}=  Query And Strip To Dictionary  ${query}
    ${locationIds}=  Get From Dictionary  ${result}  location_id
    ${locationId}=  Evaluate  random.choice(${locationIds})  random
    Input Text  //*[@id="locationRestrictionsAddActionFormContainer"]//input[@name="locationRestrictionsSummary.id"]  ${locationId}

Input Today As Effective Date
    ${today}=  GetDateTimeNow  %m/%d/%Y
    Input Text  //*[@id="locationRestrictionsAddActionFormContainer"]//input[@name="locationRestrictionsSummary.effectiveDate"]  ${today}

Input Tomorrow As Expire Date
    ${tomorrow}=  GetDateTimeNow  %m/%d/%Y  days=1
    Input Text  //*[@id="locationRestrictionsAddActionFormContainer"]//input[@name="locationRestrictionsSummary.expireDate"]  ${tomorrow}

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Select "${field}" As Location Type
    ${value}=  get value  //*[@id="locationRestrictionsAddActionFormContainer"]//select[@*="locationRestrictionsSummary.locationType"]/*[contains(text(), "${field}")]
    Select From List By Value  //*[@id="locationRestrictionsAddActionFormContainer"]//select[@name="locationRestrictionsSummary.locationType"]  ${value}

Select "${field}" As Allow w/override
    ${value}=  get value  //*[@id="locationRestrictionsAddActionFormContainer"]//select[@*="locationRestrictionsSummary.allowWOverride"]/*[contains(text(), "${field}")]
    Select From List By Value  //*[@id="locationRestrictionsAddActionFormContainer"]//select[@name="locationRestrictionsSummary.locationType"]  ${value}

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="customerLocationRestrictionsMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The "${errorMessage}" Error Message For Location Restriction ID #
    Check Element Exists  //label[@for="IdNum" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Location Restriction Effective Date
    Check Element Exists  //*[@for="effectiveAddDate" and @class="error" and text()="${errorMessage}"]
