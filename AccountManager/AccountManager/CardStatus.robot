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

Force Tags  AM
Suite Setup  start setup

*** Variables ***
${DB}  TCH
${cardNum}

*** Test Cases ***
Change Card Status To - Inactive
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${cardNum}
    Change Card Status to Inactive
    You Should See a Edit Successful Message For Card Update
    Check On DB TCH The New Status I for The Card ${cardNum}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Change Card Status Back To Active

Change Card Status To - Hold
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${cardNum}
    Change Card Status to Hold
    You Should See a Edit Successful Message For Card Update
    Check On DB TCH The New Status H for The Card ${cardNum}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Change Card Status Back To Active

Change Card Status To - Delete
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${cardNum}
    Change Card Status to Delete
    You Should See a Edit Successful Message For Card Update
    Check On DB TCH The New Status D for The Card ${cardNum}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Change Card Status Back To Active

Change Card Status To - Fraud
    [Tags]  Tier:0

    Open Account Manager
    Search And Select Card ${cardNum}
    Change Card Status to Fraud
    You Should See a Edit Successful Message For Card Update
    Check On DB TCH The New Status U for The Card ${cardNum}

    [Teardown]  Run Keywords  Close Browser
    ...  AND  Change Card Status Back To Active

*** Keywords ***

start setup
    Get Into DB  ${DB}
    Set Suite Variable  ${cardNum}  ${validCard.card_num}
    Set Suite Variable  ${carrier}  ${validCard.carrier.id}

Change Card Status Back To Active
    Get Into DB  ${DB}
    Execute SQL String  dml=UPDATE cards SET status = 'A' WHERE card_num = '${cardNum}'

    Disconnect From Database

Change Card Status To ${status}
    Select ${status} As Status
    Click On Submit For Card Update

Check On DB ${DB} The New Status ${status} for The Card ${card}
    Get Into DB  ${DB}

    ${data}=  Query And Strip To Dictionary  SELECT * FROM cards WHERE card_num = '${card}';
    Should Be Equal As Strings  ${data["status"]}  ${status}

    Disconnect From Database

Click On Searched ${customer_id} Customer #
    Click Element  //button[@class="id buttonlink" and text()="${customer_id}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Card Update
    Sleep  2s
    Click Element  //*[@id="cardActionFormContainer"]//button[@id="submit"]

Click On Submit For ${tab} Search
    Sleep  3s
    Click Element  //*[@id="${tab.lower()}SearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Get a ${DB} Card From DB
    Get Into DB  ${DB}
    Set Test Variable  ${DB}
    ${query}=  Catenate  SELECT card_num FROM cards
    ...  WHERE card_type = 'TCH'
    ...  AND status = 'A'
    ...  AND carrier_id = ${username}
    ...  AND card_num NOT LIKE '%OVER'
    ...  LIMIT 50;

    ${data}=  Query And Strip To Dictionary  ${query}
    ${cardNums}=  Get From Dictionary  ${data}  card_num
    ${cardNum}=  Evaluate  random.choice(${cardNums})  random

    Set Test Variable  ${cardNum}  ${cardNum.strip()}

    Disconnect From Database

Go To Cards Tab
    Click Element  //*[@id="Card"]
    Wait Until Loading Spinners Are Gone

    Set Test Variable  ${primaryTab}  Card

Input ${cardNum} As Card #
    Input Text  //*[@name="cardNumber"]  ${cardNum}

Open The Searched Card
    Click Element  //button[@class="cardNumber buttonlink" and text()="${cardNum}"]
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

Select ${status} As Status
    Select From List By Label  detailRecord.status  ${status}

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

You Should See a ${msgSuccess} Message For Card Update
    Wait Until Element Is Visible  //*[@id="cardActionFormContainer"]//ul[@class="msgSuccess"]//li[contains(text(), '${msgSuccess}')]  timeout=20
