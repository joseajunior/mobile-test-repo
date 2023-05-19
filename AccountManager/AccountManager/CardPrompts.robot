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

Force Tags  AM
Suite Setup  start setup

*** Variables ***
${DB}  TCH
${cardNum}

*** Test Cases ***
Add Prompts For Card - Personal ID Number And Exact Match
    [Tags]  Tier:0  qtest:30738524

    Open Account Manager
    Search And Select Card ${cardNum}
    Click On Prompts Tab
    Add a Personal ID Number Prompt With Exact Match As Validation
    You Should See The Personal ID Number Prompt
    Validate on Database TCH The New Prompt For ${cardNum} With Info Id ${promptId} And ${value} As Info Validation

    [Teardown]  Run Keywords  Delete Created Prompt
    ...  AND  Close Browser

Edit Prompts For Card - Personal ID Number And Exact Match
    [Tags]  Tier:0  qtest:30738797

    Open Account Manager
    Search And Select Card ${cardNum}
    Click On Prompts Tab
    Add a Personal ID Number Prompt With Exact Match As Validation
    You Should See The ${promptName} Prompt
    Edit Value For Personal ID Number Prompt
    Validate on Database TCH The New Prompt For ${cardNum} With Info Id ${promptId} And ${value} As Info Validation

    [Teardown]  Run Keywords  Delete Created Prompt
    ...  AND  Close Browser

Delete Prompts For Card - Personal ID Number And Exact Match
    [Tags]  Tier:0  qtest:30738987

    Open Account Manager
    Search And Select Card ${cardNum}
    Click On Prompts Tab
    Add a Personal ID Number Prompt With Exact Match As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt

    [Teardown]  Close Browser

Parkland Carrier Driver ID Card Prompt
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52824623  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Driver ID Prompt With Exact Match As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

Parkland Carrier Driver Name Card Prompt
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52838156  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Driver Name Prompt With Report Only As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

Parkland Carrier Odometer Card Prompt Accrual
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52838167  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Odometer Prompt With Accrual Check As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

Parkland Carrier Subfleet Identifier Card Prompt
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52838177  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Subfleet Identifier Prompt With Report Only As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

Parkland Carrier Trip Number Card Prompt Report Only
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52838231  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Trip Number Prompt With Report Only As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

Parkland Carrier Trip Number Card Prompt Exact Match
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52838237  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Trip Number Prompt With Exact Match As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

Parkland Carrier Unit Number Card Prompt Report Only
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52838243  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Unit Number Prompt With Report Only As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

Parkland Carrier Unit Number Card Prompt Exact Match
    [Tags]  PI:10  JIRA:ROCKET-27  qtest:52838263  API:Y
    [Setup]  Find Parkland Card
    Open Account Manager
    Search And Select Parkland Card ${cardNum}
    Click On Prompts Tab
    Add a Unit Number Prompt With Exact Match As Validation
    You Should See The ${promptName} Prompt
    Delete Created Prompt
    [Teardown]  Close Browser

New Prompts for Ryder Carrier - Card
    [Tags]  JIRA:ROCKET-220  JIRA:ROCKET-155  qtest:55376637  PI:13  API:Y  test:test
    [Setup]  Find Ryder Card
    Search And Select Card ${ryder_carrier['card_num'].__str__().strip()}
    Add a Prompt With Validation  Location Code  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  LCCD  Z${value}
    Add a Prompt With Validation  Product Line Desc  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  PLDS  Z${value}
    Add a Prompt With Validation  Subproduct Line Code  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  SPLN  Z${value}
    Add a Prompt With Validation  Subproduct Line Desc  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  SLDS  Z${value}

    Add a Prompt With Validation  District Code  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  DSCD  Z${value}
    Add a Prompt With Validation  Domicile Location  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  DMLC  Z${value}
    Add a Prompt With Validation  Lessee Number  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  LSNB  Z${value}
    Add a Prompt With Validation  Customer Number  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  CUNB  Z${value}
    Add a Prompt With Validation  Vehicle Type  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  VHTP  Z${value}
    Add a Prompt With Validation  Vehicle Product Line  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  PDLN  Z${value}
    Add a Prompt With Validation  Class Code  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  CLCD  Z${value}
    Add a Prompt With Validation  VIN  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  VHNB  Z${value}
    Add a Prompt With Validation  Customer Vehicle Name  Report Only
    Verify Prompt for card  ${ryder_carrier['card_num']}  CVNM  Z${value}


    [Teardown]  close browser

*** Keywords ***
Add a ${prompt} Prompt With ${validation} As Validation
    [Tags]  qtest
    [Documentation]  click to Add a Prompt
    ...  Select ${prompt} With ${validation} As Validation
    ...  Click submit
    ...  Should see a message saying Add Successfully
    Click On Add Button For Prompts
    Select ${prompt} For Prompt Name
    Select ${validation} As Validation
    Select Value As Method
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Add Successful Message On Screen

Add a Prompt With Validation
    [Tags]  qtest
    [Arguments]  ${prompt}  ${validation}
    [Documentation]  Click Prompts Tab and click Add
    ...  Select Prompt arg0 from the first dropdown
    ...  Select Validation arg1 from the next drop down
    ...  Input text in the Value textbox
    ...  click the Submit button to finish adding the prompt
    ...  Should see Add Successful message
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

Click On ${prompt} Prompt To Edit
    Click On  //*[@class='promptEdit buttonlink' and text()='${prompt}']
    Wait Until Load Icon Disappear
    Input a Random Number As Value
    Submit New Prompt
    You Should See a Edit Successful Message On Screen

Click On ${tab} Tab
    [Tags]  qtest
    [Documentation]  Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Delete Button For ${tab}
    Click Element  //*[@id="${primaryTab.lower()}${tab.replace(' ', '')}SearchContainer"]//span[text()="DELETE"]/parent::*
    Wait Until Page Contains Element  //*[@class="ui-dialog-title" and text()='Confirm Delete']  timeout=10

Click On Submit For ${tab} Search
    wait until element is visible  //*[@id="${tab.lower()}SearchContainer"]
    Click Element  //*[@id="${tab.lower()}SearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Confirm Prompt Deletion
    Click Element  //*[@id="cardPromptsDeleteDialogContainer"]//button[@class="submitButton" and @name='confirm']
    Wait Until Loading Spinners Are Gone

Delete Created Prompt
    [Tags]  qtest
    [Documentation]  Check the box next to the added prompt and click Delete button
    Mark Checkbox for ${promptId} Prompt
    Click On Delete Button For Prompts
    Confirm Prompt Deletion
    You Should See a Delete Successful Message On Screen

Edit Value For Personal ID Number Prompt
    Click On ${promptName} Prompt To Edit
    Run Keyword And Ignore Error  Input a Random Number As Value
    You Should See a Edit Successful Message On Screen

start setup
    Get Into DB  ${DB}
    Set Suite Variable  ${cardNum}  ${validCard.card_num}
    Set Suite Variable  ${carrier}  ${validCard.carrier.id}


Go To Cards Tab
    Click Element  //*[@id="Card"]
    Wait Until Loading Spinners Are Gone

    Set Test Variable  ${primaryTab}  Card

Input ${cardNum} As Card #
    Input Text  //*[@name="cardNumber"]  ${cardNum}

Input a Random Number As Value
    ${value}  Generate Random String  6  [NUMBERS]
    Input Text  //input[@name='promptSummary.value']  ${value}

    Set Test Variable  ${value}

Mark Checkbox for ${prompt_id} Prompt
    Click Element  //*[@value="${prompt_id}" and @type="checkbox"]

Open The Searched Card
    wait until element is visible  //button[@class="cardNumber buttonlink"]
    Click Element  //button[@class="cardNumber buttonlink" and text()="${cardNum}"]
    Wait Until Loading Spinners Are Gone

Search And Select Card ${cardNum}
    [Tags]  qtest
    [Documentation]  Click on the cards tab
    ...  input card number from query above
    ...  Click submit
    ...  Click on Card Hyperlink
    set test variable  ${cardNum}
    Go To Cards Tab
    Select EFS LLC As Business Partner
    Input ${cardNum} As Card #
    Click On Submit For Card Search
    Open The Searched Card

Search And Select Parkland Card ${cardNum}
    [Tags]  qtest
    [Documentation]  Open Account Manager and search for the chosen card
    Go To Cards Tab
    Select Parkland As Business Partner
    Input ${cardNum} As Card #
    Click On Submit For Card Search
    Open The Searched Card

Select ${partner} As Business Partner
    Wait Until Element Is Visible  //select[@class='${primaryTab.lower()}BusinessPartnerSelect searchFilter']
    Select From List By Label  //select[@class='${primaryTab.lower()}BusinessPartnerSelect searchFilter']  ${partner}

Select ${method} As Method
    Select From List By Label  promptSummary.methodCode  ${method}

Select ${prompt} For Prompt Name
    ${promptId}=  Get Value  //*[@id="cardPromptsAddUpdateActionForm"]//select[@name="promptSummary.promptId"]/option[contains(text(), '${prompt}')]
    Select From List By Value  //*[@id="cardPromptsAddUpdateActionForm"]//select[@name="promptSummary.promptId"]  ${promptId}
    Wait Until Load Icon Disappear

    Set Test Variable  ${promptId}
    Set Test Variable  ${promptName}  ${prompt}

Select ${validation} As Validation
    Select From List By Label  promptSummary.validationCode  ${validation}
    Wait Until Load Icon Disappear

Submit New Prompt
    Click Element  //*[@id="policyPromptsAddUpdateFormButtons"or @id="cardPromptsAddUpdateActionForm"]//button[@id="submit"]
    Wait Until Loading Spinners Are Gone

Validate on Database ${DB} The New Prompt For ${card} with Info Id ${infoId} And ${infoValue} As Info Validation
    Get Into DB  ${DB}
    ${query}  Catenate  SELECT * FROM card_inf
    ...  WHERE card_num='${card}'
    ...  AND info_id='${infoId}'
    ...  AND info_validation='V${infoValue}'
    Row Count is Equal to X  ${query}  1

Wait Until Load Icon Disappear
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

You Should See a ${msgSuccess} Message On Screen
    Wait Until Element Is Visible  //*[@id="policyPromptsMessages" or @id="cardPromptsMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]  timeout=10

You Should See The ${prompt} Prompt
    [Tags]  qtest
    [Documentation]  You Should See The ${prompt} Prompt added
    Wait Until Element Is Visible  //button[@class="promptEdit buttonlink" and text()='${prompt}']

Find Parkland Card
    [Tags]  qtest
    [Documentation]  Find an ative card that belongs to a Parkland carrier: select carrier_id,card_num from cards where status = 'A' and carrier_id between 2500000 and 2600000;
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

Find Ryder Card
    [Tags]  qtest
    [Documentation]  Find a Ryder child carrier:
                    ...  select x.carrier_id, d.card_num
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...      INNER JOIN cards d
                    ...          ON c.carrier_id = d.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...    and d.status = 'A';
                    ...  -------------------
                    ...  Login to account Manager follow TC-2113
    ${sql}  catenate   select x.carrier_id, d.card_num, d.card_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...      INNER JOIN cards d
                    ...          ON c.carrier_id = d.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...    and d.status = 'A'
                    ...  order by x.effective_date DESC
                    ...  Limit 1;
    close browser
    Open Account Manager
    ${ryder_carrier}  query and strip to dictionary  ${sql}  db_instance=${db}
    set test variable  ${ryder_carrier}
    ${sql}  catenate  delete from card_inf where info_id in ('LCCD','PLDS','SPLN','SLDS','DSCD','DMLC','LSNB','CUNB','VHTP','PDLN','CLCD','VHNB','CVNM') and card_num = '${ryder_carrier['card_num']}';
    execute sql string  ${sql}  db_instance=${db}

Search a carrier in Account Manager
    [Arguments]  ${BusinessPartner}  ${Customer}
    [Tags]  qtest
    [Documentation]
    ${current}  get location
    ${goback}  evaluate  '/acct-mgmt/RecordSearch.action' not in '${current}'
    run keyword if  ${goback}  Go Back To Record Search
    wait until element is visible  id
#    ${stat}=  run keyword and return status  alert should be present
#    run keyword if  ${stat}  run keyword and ignore error  handle alert
    click on  xpath=//span[text()="Customers"]
    wait until element is visible  businessPartnerCode
    select from list by value  businessPartnerCode  ${BusinessPartner}
    input text  id  ${Customer}
    double click on  xpath=//button[@class="button searchSubmit"]
    wait until element is visible   //button[text()="${Customer}"]
    sleep  1
    double click on  xpath=//button[text()="${Customer}"]
    wait until element is visible  xpath=//span[text()="Detail"]
    double click on  xpath=//span[text()="Detail"]
    wait until element is visible  //td[text()="${Customer}"]  timeout=60  error=Customer Did not load within 60 seconds

Verify Prompt for card
    [Tags]  qtest
    [Arguments]  ${card_num}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select info_validation from card_inf where card_num = {card_num} and info_id = {INFO};
    ${sql}  catenate  select info_validation from card_inf where card_num = '${card_num}' and info_id = '${info_id}';
    FOR  ${i}  IN RANGE  5
        ${db_value}  query and strip  ${sql}  db_instance=${db}
        exit for loop if  '${db_value}'!='None'
        sleep  1
    END
    should be equal as strings  ${db_value}  ${info_validation}
