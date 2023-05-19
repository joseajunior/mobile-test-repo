*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  BuiltIn
Library  otr_robot_lib.ws.CardManagementWS
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot


Suite Setup  Time to Setup
Suite Teardown  Close Browser
Force Tags  eManager

*** Variables ***
${reference}

*** Test Cases ***
New Prompts for Ryder Carrier - Money Codes
    [Tags]  JIRA:ROCKET-219  qtest:55360808  PI:13  API:Y
    [Setup]  Find Ryder Carrier
    Switch to "${ryder_carrier}" User
    Select Program > "Money Codes" > "Issue Money Code"
    Verify New Prompts - Money Codes

    [Teardown]  close browser

Money Code Prompts Setup
    [Tags]    JIRA:BOT-155  qTest:28837364  Regression  refactor


    open emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Maximize Browser Window
    Mouse Over    menubar_1x2
    Mouse Over    TCHONLINE_MONEYCODESISSUEPROMPTx2
    Click Element   MONEYCODESISSUEPROMPT_MONEY_CODES_INFORx2
    Input Text    name=searchTxt   ${reference}
    Click Element    name=search
    select from list by value  infoIdSel  DRID
    Input Text    name=reportValue    1234567890
    Click Element    name=save
    Page Should Contain Element  //*[contains(text(),'Successfully')]/../*/*[contains(text(),'added')]  Page did not contain successful add message

Check Database for new Prompt
    [Tags]  qTest:28837354  Regression  JIRA:BOT-1907  refactor
        Get Into DB  tch
        ${code_validation}=  query and strip  SELECT code_validation FROM mon_codes_info WHERE info_id = 'DRID' AND money_code_id= ${reference}
        should be equal as strings  ${code_validation}  Z1234567890

Edit the Prompt
    [Tags]  JIRA:BOT-1907  refactor
     Click Element  //*[@id="row"]/tbody/tr/td[4]/form/input[14]
     Input Text  name=reportValue  0987654321
     Click Button  name=update
     Page Should Contain Element  //*[@class="messages"]//self::li

Check Database for edited Prompt
    [Tags]  JIRA:BOT-1907  refactor
        Get Into DB  tch
        ${code_validation}=  query and strip  SELECT code_validation FROM mon_codes_info WHERE info_id = 'DRID' AND money_code_id= ${reference}
        should be equal as strings  ${code_validation}  Z0987654321

Delete the Prompt
    [Tags]  JIRA:BOT-1907  refactor
     Click Element    //*[@id="row"]/tbody/tr/td[5]/form/input[14]
     Confirm Action
     Page Should Contain Element  //*[@class="messages"]//self::li

Check Database for deleted prompt
    [Tags]  JIRA:BOT-1907  refactor
        Get Into DB  tch
        row count is 0   SELECT code_validation FROM mon_codes_info WHERE info_id = 'DRID' AND money_code_id= ${reference}


*** Keywords ***
Time to Setup

    log into card management web services  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    ${newMonCode}=  issueMoneyCode  ${validCard.contract.contract_id}  50.00  That weird person
    get into db  tch
    ${reference}=  query and strip  select code_id from mon_codes where express_code = ${newMonCode}
    set global variable  ${reference}

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
    Open eManager  ${intern}  ${internPassword}
    set test variable  ${db}  tch

Verify New Prompts - Money Codes
    [Tags]  qtest
    [Documentation]  Verify the New Prompts are available:
                ...  LCCD – LOCATION CODE
                ...  PLDS – PRODUCT LINE DESC
                ...  SPLN – SUBPRODUCT LINE CODE
                ...  SLDS – SUBPRODUCT LINE DESC
    click element  addInfoBtn
    ${myPrompts}  get list items  infoSelect
    ${new_prompts}  create list  Location Code  Product Line Desc  Subproduct Line Code  Subproduct Line Desc
    list should contain sub list  ${myPrompts}  ${new_prompts}