*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.ws.CardManagementWS
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot


Suite Setup  Start Suite
Suite Teardown  End Suite

Force Tags  eManager

*** Variables ***

*** Test Cases ***
SmartPay Supports More Than 100 Allocations At Once
    [Tags]  JIRA:BOT-131  refactor

    Set Test Variable  ${carrier}  ${validCard.carrier.member_id}
    Initiate Test
    Go to SmartFunds Allocation Screen
    Search by Card  1
    ${count}  Get Element Count   //*[@id="cardSummary"]/tbody/tr
    Set Suite Variable  ${count}
    FOR  ${i}  IN RANGE  1  ${count}+1
       Input Text  //*[@id="cardSummary"]/tbody/tr[${i}]/descendant::input[1]  1
       run keyword if  ${i}>100  exit for loop
    END
    Submit Allocation
    Close Browser

Search by All Cards on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1165   qTest:29677194  Regression  refactor
    [Documentation]  Search cards by All Cards function.

    ${carrier_obj}  set carrier variable  146567
    ${carrier}  Set Test Variable  ${carrier_obj.member_id}
    Open eManager  ${carrier_obj.member_id}  ${carrier_obj.password}
    Go to SmartFunds Allocation Screen
    Search by All Cards
    Compare Information
    [Teardown]  close browser

Go To SmartFunds Funds Allocation using 103866*
    [Tags]  JIRA:BOT-1164   qTest:29677193  Regression  refactor
    [Documentation]  Log on eManager with carrier and go to SmartFunds screen.

    ${carrier}  set carrier variable  103866
    Open eManager  ${carrier}  ${carrier.password}
    Go to SmartFunds Allocation Screen

Search by Card # on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1166   qTest:29677195  Regression  refactor
    [Documentation]  Search card by Card # function.

    Go to SmartFunds Allocation Screen
    Search by Card  708305
    Compare Information  value=708305

Search by Card Unit on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1167   qTest:29677196  Regression  refactor
    [Documentation]  Search card by Unit function.

    Go to SmartFunds Allocation Screen
    Search by Unit  12345
    Compare Information  UNIT  12345

Search by Card Driver ID on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1168   qTest:29677197  Regression  refactor
    [Documentation]  Search card by Driver ID function.

    Go to SmartFunds Allocation Screen
    Search by Driver ID  1234
    Compare Information  DRID  1234

Search by Card X-Ref on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1169   qTest:29677198  Regression  refactor
    [Documentation]  Search card by X-Ref function.

    Go to SmartFunds Allocation Screen
    Search by X-ref  S
    Compare Information  X-ref  S

Search by Card Driver Name on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1170   qTest:29677199  Regression  refactor
    [Documentation]  Search card by Driver Name function.

    Go to SmartFunds Allocation Screen
    Search by Driver Name  John
    Compare Information  NAME  John

Search by Card Policy on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1171   qTest:29677200  Regression  refactor
    [Documentation]  Search card by Policy function.

    Go to SmartFunds Allocation Screen
    Search by Policy  2
    Compare Information  Policy  2

Allocate Money to One Card on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1172   qTest:29677201  Regression  refactor
    [Documentation]  Allocate money to a card.
    [Setup]  Keep Card(s) Active  7083050910386614885
    Go to SmartFunds Allocation Screen
    Search by Card  @{cards}
    Input Alocation Amount  @{cards}  20.00
    Submit SmartFunds Allocation
    Compare Card Balance After Allocation

Allocate Money to Two Cards on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1173   qTest:29677202  Regression  refactor
    [Documentation]  Allocate money to two cards.
    [Setup]  Keep Card(s) Active  7083050910386614885  7083050910386616070
    Go to SmartFunds Allocation Screen
    Search by Card  708305
    FOR  ${card}  IN  @{cards}
      Input Alocation Amount  ${card}  20.00
    END
    Submit SmartFunds Allocation
    Compare Card Balance After Allocation

Allocate Money with Leave on Card Option on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1174   qTest:29677203  Regression  refactor
    [Documentation]  Allocate money to a card with Leave on Card Option active.

    Go to SmartFunds Allocation Screen
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Input Alocation Amount  @{cards}  20.00
    Insert Leave on Card Option
    Submit SmartFunds Allocation
    Compare Card Balance After Allocation

Allocate Money with Reference ID Option on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1175   qTest:29677204  Regression  refactor
    [Documentation]  Allocate money to a card with Reference ID filled.

    Go to SmartFunds Allocation Screen
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Input Alocation Amount  @{cards}  20.00
    Insert Reference ID
    Submit SmartFunds Allocation
    Compare Card Balance After Allocation

Allocate a Negative Amount to One Card on SmartFunds Funds Allocation
    [Tags]  JIRA:BOT-1179   qTest:29677209  Regression  refactor
    [Documentation]  Select a contract on Select Program > Credit Management > Available Credit > Select Contract

    Go to SmartFunds Allocation Screen
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Input Alocation Amount  @{cards}  -10.00
    Submit SmartFunds Allocation
    Compare Card Balance After Allocation

Take a Card Down to Zero Funds Then Allocate a Negative Amount
    [Tags]  JIRA:BOT-1180   qTest:29677210  Regression  refactor
    [Documentation]  Select a contract on Select Program > Credit Management > Available Credit > Select Contract

    Go to SmartFunds Allocation Screen
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Get Card Balance From Screen
    Input Alocation Amount  @{cards}  -${cardBalanceList[0]}
    Submit SmartFunds Allocation
    Input Alocation Amount  @{cards}  -20.00
    Submit SmartFunds Allocation
    Validate Pop-Up for Negative Amount
    Input Alocation Amount  @{cards}  ${backupBalance[0]}
    Submit SmartFunds Allocation

Try and Allocate Zero for the Amount
    [Tags]  JIRA:BOT-1181   qTest:29677211  Regression  refactor
    [Documentation]  Select a contract on Select Program > Credit Management > Available Credit > Select Contract

    Go to SmartFunds Allocation Screen
    Input Card For Execution  7083050910386614885
    Search by Card  @{cards}
    Input Alocation Amount  @{cards}  0.00
    Submit SmartFunds Allocation
    Validate Pop-Up for Zero as Amount


*** Keywords ***
Start Suite
    ${date}=  getdatetimenow  %Y%m%d
    ${date}=  get substring  ${date}  2
    ${time}=  getdatetimenow  %H%M%S
    set suite variable  ${date}
    set suite variable  ${time}

Initiate Test
    [Arguments]  ${environment}=acpt
#    I LIKE TO PRINT A NEWLINE TO START. NOT NECESSARY.
    log to console  ${empty}

#    OPEN DB CONNECTION
    Get Into DB  TCH  ${environment}

    ${query}=  catenate
    ...  SELECT member_id, TRIM(passwd) AS passwd
    ...  FROM member
    ...  WHERE member_id = ${carrier}

    ${member}  Query And Strip To Dictionary  ${query}
    Open eManager  ${member['member_id']}  ${member['passwd']}

End Suite
    Disconnect From Database


Submit Allocation
    click on  Submit
    Select Window   NEW
    click on  Save
    Handle Alert
    Select Window   MAIN
    check element exists  text=SmartFunds Funds Allocation Report
    click on  backFromReport

Go to SmartFunds Allocation Screen
    [Documentation]  Navigates to SmartFunds Allocation Screen: Select Program > SmartFunds > SmartFunds Funds Allocation

    Go To  ${emanager}/cards/SmartPayAllocation.action
    ${status}  Run Keyword And Return Status  Element Should Be Visible  //input[@name='cardSearchTxt']
    Run Keyword IF  '${status}'=='${true}'  Tch Logging  You're Inside the SmartFunds Funds Allocation Page
    ...  ELSE  Go To  ${emanager}/cards/SmartPayAllocation.action

Search by All Cards
    Search Card  allCards  allCards

Search by Card
    [Arguments]  ${card}
    Search Card  ${card}

Search by Unit
    [Arguments]  ${unit}
    Search Card  ${unit}  UNIT

Search by Driver ID
    [Arguments]  ${driverId}
    Search Card  ${driverId}  DRIVERID

Search by X-ref
    [Arguments]  ${xref}
    Search Card  ${xref}  XREF

Search by Driver Name
    [Arguments]  ${driverName}
    Search Card  ${driverName}  DRIVERNAME

Search by Policy
    [Arguments]  ${policy}
    Search Card  ${policy}  POLICY

Search Card
    [Arguments]  ${value}  ${searchType}=NUMBER
    Click Radio Button  ${searchType}

    Run Keyword If  '${value}' != 'allCards'
    ...  Input Text  cardSearchTxt   ${value}

    Click Button  searchCard

Submit SmartFunds Allocation

    Get Card Balance From Screen
    Backup Card Balance
    Run Keyword If  ${cardBalancelist[0]} == 0 and ${amount} <= 0
    ...  Run Keywords  Click Button  Submit
    ...  AND  Handle Pop-Up
    ...  AND  Element Should Be Visible  submit
    ...  ELSE  Run Keywords  Click Button  Submit
    ...  AND  Select Window   NEW
    ...  AND  Check SmartFunds Summary Information
    ...  AND  Click Button  Save
    ...  AND  sleep  3
    ...  AND  Handle Alert
    ...  AND  sleep  3
    ...  AND  Select Window   MAIN
    ...  AND  Check Element Exists  text=SmartFunds Funds Allocation Report
    ...  AND  Check SmartFunds Funds Allocation Report
    ...  AND  sleep  3
    ...  AND  Click Button  backFromReport
    ...  AND  sleep  3

Input Alocation Amount
    [Arguments]  ${card}  ${amount}

    Input Text  //table[@id="cardSummary"]//a[text()='${card}']/parent::td/parent::tr//input[contains(@title,'Allocation')]  ${amount}
    Set Test Variable  ${amount}

Check SmartFunds Summary Information

    FOR  ${card}  IN  @{cards}
      ${allocationInfo}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Allocation']/parent::th/preceding-sibling::th)+1]
      ${leaveOnCardInfo}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Leave On Card']/parent::th/preceding-sibling::th)+1]
      ${referenceIdInfo}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Reference ID']/parent::th/preceding-sibling::th)+1]
      Should Be Equal  ${amount}  ${allocationInfo}
      Run Keyword If  '${leaveOnCardInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${leaveOnCardInfo}  ${leaveOnCard}
      Run Keyword If  '${referenceIdInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${referenceIdInfo}  ${referenceId}
    END

Check SmartFunds Funds Allocation Report

    ${newBalance}  Create List
    ${i}  Set Variable  0
    FOR  ${card}  IN  @{cards}
      ${status}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Status']/parent::th/preceding-sibling::th)+1]
      ${reportCardBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]
      ${allocation}  Get Text   //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Allocation']/parent::th/preceding-sibling::th)+1]
      ${reportNewBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='New Balance']/parent::th/preceding-sibling::th)+1]
      ${leaveOnCardInfo}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Leave On Card']/parent::th/preceding-sibling::th)+1]
      ${referenceIdInfo}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Reference ID']/parent::th/preceding-sibling::th)+1]
      ${reportCardBalance}  Strip String  ${reportCardBalance}  characters=$
      ${reportNewBalance}  Remove String  ${reportNewBalance}  $  ,
      ${test}  Remove String  ${cardBalanceList[${i}]}  ,
      ${sum}  Evaluate  ${test} + ${amount}
      Append To List  ${newBalance}  ${sum.__str__()}
      Should Be Equal  ${status}  Successful
      Should Be Equal  ${cardBalanceList[${i}]}  ${reportCardBalance}
      Should Be Equal  ${amount}  ${allocation}
      Should Be Equal as Numbers  ${reportNewBalance}  ${newBalance[${i}]}
      Run Keyword If  '${leaveOnCardInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${leaveOnCardInfo}  ${leaveOnCard}
      Run Keyword If  '${referenceIdInfo}' != '${EMPTY}'
      ...  Should Be Equal  ${referenceIdInfo}  ${referenceId}
      ${i}  Evaluate  ${i}+1
    END
    Set Test Variable  ${newBalance}

Get Card Balance From Screen

    @{cardBalanceList}  Create List
    FOR  ${card}  IN  @{cards}
      ${cardBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]
      ${cardBalance}  Strip String  ${cardBalance}  characters=$
      Append to List  ${cardBalanceList}  ${cardBalance}
    END
    Set Test Variable  ${cardBalanceList}

Compare Card Balance After Allocation

    Run Keyword If  '${amount}' < '0'
    ...  Normalize Amount  ${amount}

    ${i}  Set Variable  0
    FOR  ${card}  IN  @{cards}
      Wait Until Element is Visible  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]  timeout=20
      ${finalCardBalance}  Get Text  //table[@id="cardSummary"]//td[contains(normalize-space(),'${card}')]/parent::tr/td[count(//table[@id='cardSummary']//th/a[text()='Card Balance']/parent::th/preceding-sibling::th)+1]
      ${finalCardBalance}  Remove String  ${finalCardBalance}  $  ,
      Should Be Equal as Numbers  ${finalCardBalance}  ${newBalance[${i}]}
      Get Into DB  TCH
      ${query}  Catenate  select * from payr_cash_adv
      ...  where cash_adv_id = (select max(cash_adv_id)
      ...  from payr_cash_adv
      ...  where card_num='${card}'
      ...  and amount='${amount}'
      ...  and balance='${finalCardBalance}');
      Row Count is Equal to X  ${query}  1
      ${i}  Evaluate  ${i}+1
    END

Backup Card Balance

    Set Test Variable  ${backupBalance}  ${cardBalanceList}

Count Results on eManager

    ${cardsOnEmanager}  Get Element Count  //*[@id="cardSummary"]/tbody/tr
    Set Test Variable  ${cardsOnEmanager}

Count Cards on DB

    Get Into DB  TCH
    ${query}  Catenate  SELECT count(*)
    ...  FROM cards
    ...  WHERE carrier_id = ${carrier}
    ...  AND payr_use in ('P', 'B')
    ...  AND status != 'D'
    ...  AND card_num not like ('%OVER')
    ${cardsOnDb}  Query and Strip  ${query}
    Set Test Variable  ${cardsOnDb}

Count Cards on DB With Prompts
    [Arguments]  ${prompt}  ${value}

    Get Into DB  TCH
    ${query}  Catenate  SELECT count(*)
    ...  FROM cards c, card_inf ci
    ...  WHERE c.carrier_id = ${carrier}
    ...  AND c.payr_use in ('P', 'B')
    ...  AND c.card_num not like ('%OVER')
    ...  AND c.card_num=ci.card_num
    ...  AND c.status != 'D'
    ...  AND ci.info_id='${prompt}'
    ...  AND UPPER(ci.info_validation) like UPPER('%${value}%')
    ${cardsOnDb}  Query and Strip  ${query}
    Set Test Variable  ${cardsOnDb}

Count Cards on DB With Card #
    [Arguments]  ${value}

    Get Into DB  TCH
    ${query}  Catenate  SELECT count(*)
    ...  FROM cards
    ...  WHERE carrier_id = ${carrier}
    ...  AND payr_use in ('P', 'B')
    ...  AND cardoverride='0'
    ...  AND status != 'D'
    ...  AND card_num like '%${value}%'
    ${cardsOnDb}  Query and Strip  ${query}
    Set Test Variable  ${cardsOnDb}

Count Cards on DB With X-ref
    [Arguments]  ${value}

    TCH Logging  X-ref:${value}
    Get Into DB  TCH
    ${query}  Catenate  SELECT count(*)
    ...  FROM cards
    ...  WHERE carrier_id = ${carrier}
    ...  AND payr_use in ('P', 'B')
    ...  AND card_num not like ('%OVER')
    ...  AND status != 'D'
    ...  AND UPPER(coxref) like '%${value}%'
    ${cardsOnDb}  Query and Strip  ${query}
    Set Test Variable  ${cardsOnDb}

Count Cards on DB With Policy
    [Arguments]  ${value}

    TCH Logging  Policy:${value}
    Get Into DB  TCH
    ${query}  Catenate  SELECT count(*)
    ...  FROM cards
    ...  WHERE carrier_id = ${carrier}
    ...  AND payr_use in ('P', 'B')
    ...  AND card_num not like ('%OVER')
    ...  AND status != 'D'
    ...  AND icardpolicy='${value}'
    ${cardsOnDb}  Query and Strip  ${query}
    Set Test Variable  ${cardsOnDb}

Compare Information
    [Arguments]  ${prompt}=F  ${value}=F

    Count Results on eManager
    Run Keyword If  '${prompt}'=='F' and '${value}'=='F'
    ...  Count Cards on DB
    ...  ELSE IF  '${prompt}'=='X-ref'
    ...  Count Cards on DB With X-ref  ${value}
    ...  ELSE IF  '${prompt}'=='Policy'
    ...  Count Cards on DB With Policy  ${value}
    ...  ELSE IF  '${prompt}'=='F' and '${value}'!='F'
    ...  Count Cards on DB With Card #  ${value}
    ...  ELSE  Count Cards on DB With Prompts  ${prompt}  ${value}
    TCH Logging   ${prompt}-database:${cardsOnDb} emanager:${cardsOnEmanager}
    Should be Equal  ${cardsOnDb}  ${cardsOnEmanager}

Insert Leave on Card Option
    Set Focus to Element  submit
    Click Element  //*[@id="cardSummary"]/tbody/tr[1]/descendant::input[2]
    Set Test Variable  ${leaveOnCard}  Yes

Insert Reference ID
    Set Focus to Element  submit
    ${referenceId}  Generate Random String  6
    Input Text  //*[@id="cardSummary"]/tbody/tr[1]/descendant::input[3]  ${referenceId}
    Set Test Variable  ${referenceId}

Handle Pop-Up

    ${message}  Handle Alert  timeout=15
    Set Test Variable  ${message}

Validate Pop-Up for Zero as Amount

    Should Be Equal  ${message}  Please enter a valid amount.

Validate Pop-Up for Negative Amount

    Should Contain  ${message}  Amount removed (${amount}) may not exceed card balance ${cardBalanceList[0]}.

Input Card For Execution
    [Arguments]  @{cardsList}

    @{cards}  Create List  @{cardsList}
    Set Test Variable  @{cards}

Normalize Amount
    [Arguments]  ${amount}

    ${amount}  Strip String  ${amount}  characters=-
    Set Test Variable  ${amount}

Select Card

    Click Element  //table[@id='cardSummary']//tbody//td[count(//table[@id='cardSummary']//th/a[text()='Card #']/parent::th/preceding-sibling::th)+1]

Keep Card(s) Active
    [Arguments]  @{cardsList}
    @{cards}  Create List  @{cardsList}
    FOR  ${i}  IN  @{cards}
      Start Setup Card  ${i}
      Setup Card Header  status=ACTIVE
    END
    Set Test Variable  @{cards}
