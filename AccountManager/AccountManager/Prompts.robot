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
Suite Setup  start setup

*** Variables ***
${DB}  TCH
${cardNum}
${carrier}
${primaryTab}
${prompt}

*** Test Cases ***
All Prompts Appear According To The Prompt Source
    [Tags]  JIRA:BOT-1367  qTest:32539067  Regression
    [Documentation]  All Prompts Appear According To The Prompt Source

    Open Account Manager
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Prompts Tab
    Click On Reset Button
    Get info_id From DB For Carrier ${carrier} And Policy 1
    You Should See Subfleet Identifier If Info Id Is Equals To SSUB

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Prompts can be added
    [Tags]  JIRA:BOT-1368  qTest:31247185  Regression  qTest:30738524  Tier:0
    [Documentation]  Prompts can be added

    Open Account Manager
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 2
    Click On Prompts Tab
    Click On Reset Button
    Click On Add Button
    Select Driver ID As Prompt Name
    Select Exact Match As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Driver ID Prompt

    [Teardown]  Run Keywords  Delete Driver ID Prompt
    ...  AND  Close Browser

Prompts can be added - Field Validation
    [Tags]  JIRA:FRNT-1343  qTest:49945442  Regression  Tier:0
    [Documentation]  Prompts can be added - Field Validation
    Open Account Manager
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 2
    Click On Prompts Tab
    Click On Reset Button
    Click On Add Button
    Submit New Prompt
    You Should See The "Prompt is a required field." Error Message For Prompt Name
    You Should See The "This field is required." Error Message For Validation
    You Should See The "This field is required." Error Message For Method

    [Teardown]  Close Browser

Prompts can be Edited
    [Tags]  JIRA:BOT-1369  qTest:32538979  Regression
    [Documentation]  Prompts can be edited

    Open Account Manager
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 2
    Click On Prompts Tab
    Click On Reset Button
    Add Driver ID Prompt If Not Created
    Click On Driver ID Prompt
    Select Report Only As Validation
    Select Exact Match As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Edit Successful Message On Screen
    Check On DB TCH The New Value For Driver ID Prompt For ${carrier} Carrier And Police 2
    [Teardown]  Run Keywords  Delete Driver ID Prompt
    ...  AND  Close Browser
    ...  AND  Disconnect From Database

Prompts can be Deleted
    [Tags]  JIRA:BOT-1370  qTest:31247192  Regression  qTest:30738524
    [Documentation]  Prompts can  be deleted

    Open Account Manager
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 2
    Click On Prompts Tab
    Click On Reset Button
    Add Driver ID Prompt If Not Created
    Mark Checkbox for Driver ID Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen

    [Teardown]  Run Keywords  Close Browser

Prompts Can Be Added on Card Details
    [Tags]  JIRA:BOT-1336  qTest:32539067  Regression
    [Documentation]  Add a Prompt on Card Details Screen

    Open Account Manager
    Click On Cards Tab
    Select EFS LLC As Business Partner
    Input ${cardNum} As Card #
    Click On Submit For Card Search
    Click On Searched ${cardNum} Card #
    Click On Prompts Tab
    Add Driver License Prompt If Not Created
    Validate if Exact Match Prompt is Added on Database TCH For ${cardNum} With Info Id DLIC And ${value} As Info Validation

    [Teardown]  Run Keywords  Delete Driver License Prompt
    ...  AND  Close Browser
    ...  AND  Disconnect From Database

Parkland Carrier Driver ID Card Prompt
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Driver ID As Prompt Name
    Select Exact Match As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Driver ID Prompt
    Mark Checkbox for Driver ID Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

Parkland Carrier Driver Name Card Prompt
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Driver Name As Prompt Name
    Select Report Only As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Driver Name Prompt
    Mark Checkbox for NAME Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

Parkland Carrier Odometer Card Prompt Accrual
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Odometer As Prompt Name
    Select Accrual Check As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Odometer Prompt
    Mark Checkbox for ODRD Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

Parkland Carrier Subfleet Identifier Card Prompt
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Subfleet Identifier As Prompt Name
    Select Report Only As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Subfleet Identifier Prompt
    Mark Checkbox for SSUB Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

Parkland Carrier Trip Number Card Prompt Report Only
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Trip Number As Prompt Name
    Select Report Only As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Trip Number Prompt
    Mark Checkbox for TRIP Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

Parkland Carrier Trip Number Card Prompt Exact Match
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Trip Number As Prompt Name
    Select Exact Match As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Trip Number Prompt
    Mark Checkbox for TRIP Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

Parkland Carrier Unit Number Card Prompt Report Only
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Unit Number As Prompt Name
    Select Report Only As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Unit Number Prompt
    Mark Checkbox for UNIT Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

Parkland Carrier Unit Number Card Prompt Exact Match
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623
    [Setup]  Find Parkland Card
    Open Account Manager
    Select Parkland As Business Partner Customer
    Input ${parkland_carrier_id} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${parkland_carrier_id} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1
    Click On Add Button
    Select Unit Number As Prompt Name
    Select Exact Match As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Unit Number Prompt
    Mark Checkbox for UNIT Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen
    [Teardown]  Close Browser

New Prompts for Ryder Carrier - Policy
    [Tags]  JIRA:ROCKET-220  JIRA:ROCKET-155  qtest:55399057  PI:13  API:Y  test:test
    [Setup]  Find Ryder Carrier
    Open Account Manager to Ryder Prompts
    Add a Prompt With Validation  Location Code  Report Only
    Verify Prompt in DB  ${ryder_carrier}  LCCD  Z${value}
    Add a Prompt With Validation  Product Line Desc  Report Only
    Verify Prompt in DB  ${ryder_carrier}  PLDS  Z${value}
    Add a Prompt With Validation  Subproduct Line Code  Report Only
    Verify Prompt in DB  ${ryder_carrier}  SPLN  Z${value}
    Add a Prompt With Validation  Subproduct Line Desc  Report Only
    Verify Prompt in DB  ${ryder_carrier}  SLDS  Z${value}

    Add a Prompt With Validation  District Code  Report Only
    Verify Prompt in DB  ${ryder_carrier}  DSCD  Z${value}
    Add a Prompt With Validation  Domicile Location  Report Only
    Verify Prompt in DB  ${ryder_carrier}  DMLC  Z${value}
    Add a Prompt With Validation  Lessee Number  Report Only
    Verify Prompt in DB  ${ryder_carrier}  LSNB  Z${value}
    Add a Prompt With Validation  Customer Number  Report Only
    Verify Prompt in DB  ${ryder_carrier}  CUNB  Z${value}
    Add a Prompt With Validation  Vehicle Type  Report Only
    Verify Prompt in DB  ${ryder_carrier}  VHTP  Z${value}
    Add a Prompt With Validation  Vehicle Product Line  Report Only
    Verify Prompt in DB  ${ryder_carrier}  PDLN  Z${value}
    Add a Prompt With Validation  Class Code  Report Only
    Verify Prompt in DB  ${ryder_carrier}  CLCD  Z${value}
    Add a Prompt With Validation  VIN  Report Only
    Verify Prompt in DB  ${ryder_carrier}  VHNB  Z${value}
    Add a Prompt With Validation  Customer Vehicle Name  Report Only
    Verify Prompt in DB  ${ryder_carrier}  CVNM  Z${value}
    [Teardown]  close browser

*** Keywords ***

Validate on Database ${DB} The New Prompt For ${card} with Info Id ${infoId} And ${infoValue} As Info Validation
    Get Into DB  ${DB}
    ${query}  Catenate  SELECT * FROM card_inf
    ...  WHERE card_num='${card}'
    ...  AND info_id='${infoId}'
    ...  AND info_validation='V${infoValue}'
    Row Count is Equal to X  ${query}  1

Add a ${prompt} Prompt With ${validation} As Validation
    Click On Add Button For Prompts
    Select ${prompt} For Prompt Name
    Select ${validation} As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen

Click On Add Button For ${tab}
    Click Element  //*[@id="${primaryTab.lower()}${tab.replace(' ', '')}SearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-widget-overlay ui-front"]  timeout=20
    Wait Until Load Icon Disappear

Select ${prompt} For Prompt Name
    ${promptId}=  Get Value  //*[@id="cardPromptsAddUpdateActionForm"]//select[@name="promptSummary.promptId"]/option[contains(text(), '${prompt}')]
    Select From List By Value  //*[@id="cardPromptsAddUpdateActionForm"]//select[@name="promptSummary.promptId"]  ${promptId}
    Wait Until Load Icon Disappear

    Set Test Variable  ${promptId}
    Set Test Variable  ${promptName}  ${prompt}

start setup
    Get Into DB  ${DB}
    Set Suite Variable  ${cardNum}  ${validCard.card_num}
    Set Suite Variable  ${carrier}  ${validCard.carrier.id}

Add Driver License Prompt If Not Created
    ${added}=  Run Keyword And Return Status  Check Element Exists  //button[@class="promptEdit buttonlink" and text()='Driver License']
    Return From Keyword If  ${added}  ${added}
    Click On Add Button
    Wait Until Load Icon Disappear
    Select Driver License As Prompt Name
    Wait Until Load Icon Disappear
    Select Exact Match As Validation
    Wait Until Load Icon Disappear
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Driver License Prompt

Add Driver ID Prompt If Not Created
    ${added}=  Run Keyword And Return Status  Check Element Exists  //button[@class="promptEdit buttonlink" and text()='Driver ID']
    Return From Keyword If  ${added}  ${added}
    Click On Add Button
    Wait Until Load Icon Disappear
    Select Driver ID As Prompt Name
    Wait Until Load Icon Disappear
    Select Exact Match As Validation
    Wait Until Load Icon Disappear
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen
    You Should See The Driver ID Prompt

Check On DB ${DB} The New Value For Driver ID Prompt For ${carrierId} Carrier And Police ${ipolicy}
    Get Into DB  ${DB}
    ${query}=  catenate  SELECT TRIM(info_validation) FROM def_info WHERE carrier_id=${carrierId} AND ipolicy=${ipolicy} AND info_id='DRID'
    ${info_validation}=  Query And Strip  ${query}
    Should Be Equal As Strings  ${info_validation}  V${value}

Click On ${prompy} Prompt
    Wait Until Element Is Visible  //*[@class='promptEdit buttonlink' and text()='${prompy}']  timeout=10
    Click On  //*[@class='promptEdit buttonlink' and text()='${prompy}']
    Wait Until Load Icon Disappear

Click On Add Button
    Click Element  //span[text()="ADD"]/parent::*
    Wait Until Page Contains Element  promptSummary.promptId  timeout=20
    Wait Until Load Icon Disappear

Click On Cards Tab
    Click Element  //a[@id='Card']
    Wait Until Loading Spinners Are Gone

Click On Delete Button
    Click Element  //span[text()="DELETE"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-dialog-title" and text()='Confirm Delete']  timeout=10

Click On Prompt Tab
    Click Element  //*[@id="Prompts"]

Click On Searched ${cardNum} Card #
    Wait Until Element Is Visible  //button[@class="cardNumber buttonlink" and text()="${cardNum}"]  timeout=10
    Click Element  //button[@class="cardNumber buttonlink" and text()="${cardNum}"]
    Wait Until Loading Spinners Are Gone

Click On Searched ${customer_id} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customer_id}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customer_id}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Card Search
    [Tags]  qtest
    [Documentation]  Click Submit Button to search for card
    Click Element  //*[@id="cardSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    [Tags]  qtest
    [Documentation]  Click on Submit button to search for customer
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Polices
    [Tags]  qtest
    [Documentation]  Click submit to pull up policies
    Click Element  //*[@id="customerPoliciesSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Police ${police_number}
    [Tags]  qtest
    [Documentation]  Click on an available policy
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${police_number}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${police_number}"]
    Wait Until Loading Spinners Are Gone

Click On Polices Tab
    [Tags]  qtest
    [Documentation]  In the sub tabs click on Policy Tab
    Wait Until Element Is Visible  //*[@id="Policies"]  timeout=10
    Click Element  //*[@id="Policies"]
    Wait Until Loading Spinners Are Gone

Click On Prompts Tab
    [Tags]  qtest
    [Documentation]  On the sub tabs click on Prompts Tab
    Wait Until Element Is Visible  //*[@id="Prompts"]  timeout=10
    Click Element  //*[@id="Prompts"]

Click On Reset Button
    [Tags]  qtest
    [Documentation]  To clear the search click reset button
    Click Element  //*[@id="policyPromptsSearchContainer"]//button[@class="button resetButton"]
    Wait Until Loading Spinners Are Gone

Confirm Prompt Deletion
    Click Element  //*[@id="policyPromptsDeleteDialogContainer" or @id="cardPromptsDeleteDialogContainer"]//button[@class="submitButton" and @name='confirm']
    Wait Until Loading Spinners Are Gone

Delete Driver ID Prompt
    Mark Checkbox For Driver ID Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen

Delete Driver License Prompt
    Mark Checkbox For Driver License Prompt
    Click On Delete Button
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen

Get a Valid Card From DB For ${carrier}
    Get Into DB  TCH
    ${query}=  Catenate  SELECT card_num FROM cards
    ...  WHERE card_type = 'TCH'
    ...  AND status = 'A'
    ...  AND carrier_id = ${carrier}
    ...  AND card_num NOT LIKE '%OVER'
    ...  LIMIT 50;

    ${data}=  Query And Strip To Dictionary  ${query}
    ${cardNums}=  Get From Dictionary  ${data}  card_num
    ${cardNum}=  Evaluate  random.choice(${cardNums})  random
    log to console  ${cardNum}

    Set Test Variable  ${cardNum}  ${cardNum.strip()}

    Disconnect From Database

Get info_id From DB For Carrier ${carrier} And Policy ${policy}
    Get Into DB  TCH
    ${query}=  Catenate  SELECT info_id FROM def_info WHERE carrier_id=${carrier} AND ipolicy=${policy}
    ${info_id}=  Query And Strip  ${query}

    Set Test Variable  ${info_id}

Input ${cardNum} As Card #
    Input Text  //*[@name="cardNumber"]  ${cardNum}

Input ${customer_id} As Customer #
    [Tags]  qtest
    [Documentation]  On the customer tab enter carrier from above sql
    ...  Click Submit and Click on Carrier link
    Wait Until Element Is Visible  //input[@name="id"]  timeout=10
    Input Text  //input[@name="id"]  ${customer_id}

Input a Random Number As Value
    ${value}=  Generate Random String  6  [NUMBERS]
    Input Text  promptSummary.value  ${value}

    Set Test Variable  ${value}

Mark Checkbox For Driver ID Prompt
    Click Element  //*[@value="DRID" and @type="checkbox"]

Mark Checkbox For Driver License Prompt
    Click Element  //*[@value="DLIC" and @type="checkbox"]

Mark Checkbox for ${prompt_id} Prompt
    Click Element  //*[@value="${prompt_id}" and @type="checkbox"]

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Select ${partner} As Business Partner
    Wait Until Element Is Visible  //select[@class='cardBusinessPartnerSelect searchFilter']
    Select From List By Label  //select[@class='cardBusinessPartnerSelect searchFilter']  ${partner}

Select ${partner} As Business Partner Customer
    Wait Until Element Is Visible  //select[@class='customerBusinessPartnerSelect searchFilter']
    Select From List By Label  //select[@class='customerBusinessPartnerSelect searchFilter']  ${partner}

Select ${method} As Method
    Select From List By Label  promptSummary.methodCode  ${method}

Select ${promptId} As Prompt Name
    Select From List By Label  promptSummary.promptId  ${promptId}
    Wait Until Load Icon Disappear

Select ${validation} As Validation
    Select From List By Label  promptSummary.validationCode  ${validation}
    Wait Until Load Icon Disappear

Submit New Prompt
    Click Element  //*[@id="policyPromptsAddUpdateFormButtons"or @id="cardPromptsAddUpdateActionForm"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Validate If Exact Match Prompt is Added on Database ${DB} For ${card} with Info Id ${infoId} And ${infoValue} As Info Validation
    Get Into DB  ${DB}
    ${query}  Catenate  SELECT * FROM card_inf
    ...  WHERE card_num='${card}'
    ...  AND info_id='${infoId}'
    ...  AND info_validation='V${infoValue}'
    Row Count is Equal to X  ${query}  1

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

You Should See ${text} If Info Id Is Equals to ${info}
    Run Keyword If  '${info_id}'=='${info}'  Check Element Exists  //button[@class="promptEdit buttonlink" and text()='${text}']

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="policyPromptsMessages" or @id="cardPromptsMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The ${prompt} Prompt
    Check Element Exists  //button[@class="promptEdit buttonlink" and text()='${prompt}']

You Should See The "${errorMessage}" Error Message For Prompt Name
    Check Element Exists  //label[@for="promptSummary.promptId" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Validation
    Check Element Exists  //label[@for="promptSummary.validationCode" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Method
    Check Element Exists  //label[@for="promptSummary.methodCode" and @class="error" and text()="${errorMessage}"]

Find Parkland Card
    [Tags]  qtest
    [Documentation]  Find an ative card that belongs to a Parkland carrier: select carrier_id from cards where status = 'A' and carrier_id between 2500000 and 2600000;
    get into db  tch
    ${sql}  catenate   select carrier_id from cards where status = 'A' and carrier_id between 2500000 and 2500053;
    @{carriers}  query and return dictionary rows  ${sql}
    ${carrier_id}  evaluate  random.choice(${carriers})
    ${parkland_carrier_id}  catenate  ${carrier_id['carrier_id']}
    set test variable  ${parkland_carrier_id}
    ${sql}  catenate  select passwd from member where member_id = ${parkland_carrier_id};
    ${parkland_password}  query and strip  ${sql}
    set test variable  ${parkland_password}
    ${sql}  catenate   select card_id, card_num from cards where status = 'A' and carrier_id = ${parkland_carrier_id};
    @{cards}  query and return dictionary rows  ${sql}
    ${myCard}  evaluate  random.choice(${cards})
    ${cardNum}  catenate  ${myCard['card_num'].strip()}
    set test variable  ${cardNum}

Find Ryder Carrier
    [Tags]  qtest
    [Documentation]  Find a Ryder child carrier:
                    ...  select x.carrier_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A';
    ${sql}  catenate   select x.carrier_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...  order by x.effective_date DESC
                    ...  Limit 1;
    ${ryder_carrier}  query and strip  ${sql}  db_instance=tch
    set test variable  ${ryder_carrier}
    set test variable  ${db}  tch
    ${sql}  catenate  delete from def_info where info_id in ('LCCD','PLDS','SPLN','SLDS','DSCD','DMLC','LSNB','CUNB','VHTP','PDLN','CLCD','VHNB','CVNM') and carrier_id = ${ryder_carrier};
    execute sql string  ${sql}  db_instance=${db}

Verify Prompt in DB
    [Tags]  qtest
    [Arguments]  ${carrier_id}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select info_validation from def_info where carrier_id = arg0 and info_id = 'arg1';
    ${sql}  catenate  select info_validation from def_info where carrier_id = ${carrier_id} and info_id = '${info_id}';
    FOR  ${i}  IN RANGE  5
        ${db_value}  query and strip  ${sql}  db_instance=${db}
        exit for loop if  '${db_value}'!='None'
        sleep  1
    END
    should be equal as strings  ${db_value}  ${info_validation}

Open Account Manager to Ryder Prompts
    [Tags]  qtest
    [Documentation]  Login to account Manager follow TC-2113
    Open Account Manager
    Input ${ryder_carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${ryder_carrier} Customer #
    Click On Polices Tab
    Click On Submit For Polices
    Click On Police 1

Add a Prompt With Validation
    [Tags]  qtest
    [Arguments]  ${prompt}  ${validation}
    [Documentation]  Click Prompts Tab and click Add
    ...  Select Prompt arg0 from the first dropdown
    ...  Select Validation arg1 from the next drop down
    ...  Input text in the Value textbox
    ...  click the Submit button to finish adding the prompt
    ...  Should see Add Successful message
    Click On Add Button
    Select ${prompt} As Prompt Name
    Select ${validation} As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen