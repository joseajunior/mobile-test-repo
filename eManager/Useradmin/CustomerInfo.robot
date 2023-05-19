*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager  Customer Info  UserAdmin

*** Test Cases ***
Get Into Carrier With Customer Info
    [Documentation]  Ensure that you can login as carrier through customer service info access.
    [Tags]  JIRA:BOT-1049  qTest:30451701  Regression  refactor
    [Setup]  Open Emanager  ${intern}  ${internPassword}
    Navigate to Customer Info Screen
    Access Carrier Through Customer Info  ${validCard.carrier.member_id}
    Ensure Customer Info Logged In
    [Teardown]  Close Browser

Issue Money Code Logged as Customer Info
    [Documentation]  Ensure that isn't possible to issue a money code when logged in through customer service info access.
    [Tags]  JIRA:BOT-1049  qTest:30451841  Regression  refactor
    [Setup]  Open Emanager  ${intern}  ${internPassword}
    Navigate to Customer Info Screen
    Access Carrier Through Customer Info  ${validCard.carrier.member_id}
    Navite to Issue Money Code
    Issue a Money Code
    Assert Error Message  ERROR: Customer Service is not allowed to make changes here!
    [Teardown]  Close Browser

Add Cash Advance Funds to a Card Looged as Customer Info
    [Documentation]  Ensure that it's possible to add funds to a card(cash advance) logged through customer service info.
    [Tags]  JIRA:BOT-1049  qTest:30451889  Regression  refactor
    [Setup]  Open Emanager  ${intern}  ${internPassword}
    Navigate to Customer Info Screen
    Access Carrier Through Customer Info  ${validCard.carrier.member_id}
    Navigate to Cash Advance Screen
    Add Funds To a Card
    Assert Success Message  Successfully added $${amount} to card
    [Teardown]  Close Browser

*** Keywords ***
Navigate to Customer Info Screen
    Go To  ${emanager}/security/ManageCustomers.action

Access Carrier Through Customer Info
    [Arguments]  ${carrier}
    Select From List By Label  name=searchType  User Id
    Input Text  name=searchValue  ${carrier}
    Click Element  name=SearchCustomers
    Find and Select Carrier on Table  ${validCard.carrier.member_id}

Find and Select Carrier on Table
    [Arguments]  ${carrier}
    Click Element  //td[count(//th/a[text()='User ID'])]/a[text()='${carrier}']

Ensure Customer Info Logged In
    Page Should Contain Element  //a[@href="/security/ManageCustomers.action" and text()='Customer Info']

Navite to Issue Money Code
    Go To  ${emanager}/cards/MoneyCodeManagement.action

Issue a Money Code
    ${amount}  Generate Random String  2  [NUMBERS]
    ${issued_to}  Generate Random String  8  [LETTERS]
    ${notes}  Generate Random String  10  [LETTERS]
    Input Text  moneyCode.amount  ${amount}
    Input Text  moneyCode.issuedTo  ${issued_to}
    Input Text  moneyCode.notes  ${notes}
    Click Element  submitId

Assert Error Message
    [Arguments]  ${expected_message}
    ${screen_message}  Get Text  //div[@class='errors']/ol
    Should Be Equal As Strings  ${screen_message}  ${expected_message}

Navigate to Cash Advance Screen
    Go To  ${emanager}/cards/CardLookup.action?returnPage=/CashAdvanceManagement.action&returnPageParamPrefix=card.

Add Funds To a Card

    Click Element  //input[@name='lookupInfoRadio' and @value='NUMBER']
    ${card}=  Get a valid card  ${validCard.carrier.member_id}    TCH
    Input Text  name=cardSearchTxt  ${card}
    Click Element  name=searchCard
#    ${policy}  Get Valid Policy From Carrier
#    click element  xpath=//a[text()="SmartFunds"]
#    sleep  1
#    ${card}  Get Text  (//table[@id='cardSummary']//td[count(//th/a[text()='Status']/parent::th/preceding-sibling::th)+1 and contains(text(),'Active')]/parent::tr//a)[1]
#    Click Element  (//table[@id='cardSummary']//td[count(//th/a[text()='Status']/parent::th/preceding-sibling::th)+1 and contains(text(),'Active')]/parent::tr//a)[1]
    ${sub}=  get substring  ${card}  -4
    click element  //*[@id='cardSummary']//descendant::*[contains(text(),'${sub}')]
    ${amount}  Generate Random String  2  [NUMBERS]
    ${reference}  Generate Random String  8  [LETTERS]
    ${notes}  Generate Random String  10  [LETTERS]
    Input Text  amount  ${amount}
    Input Text  reference  ${reference}
    Input Text  note  ${notes}
    Click Element  processCashAdvance
    Set Test Variable  ${amount}
    Set Test Variable  ${card}


Get a valid card
    [Arguments]  ${carrier}  ${DB}
    get into db  ${DB}
    ${card}=  query and strip  select card_num from cards where carrier_id = '${carrier}' and status='A' and card_num not like '%OVER' order by last_used desc limit 1;
    [Return]  ${card}


#Get Valid Policy From Carrier
#    Get Into DB  tch
#    ${query}  Catenate
#    ...  SELECT dc.ipolicy FROM cards c
#    ...     INNER JOIN def_card dc ON (dc.ipolicy = c.icardpolicy AND c.carrier_id = dc.id)
#    ...  WHERE c.carrier_id = ${validCard.carrier.member_id}
#    ...  AND c.status = 'A'
#    ...  LIMIT 1
#    ${policy}  Query And Strip  ${query}
#    Disconnect From Database
#    [Return]  ${policy}

Assert Success Message
    [Arguments]  ${expected_message}
    ${screen_message}  Get Text  //ul/li
    Page should contain  ${expected_message}

