*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot


Force Tags  eManager

*** Test Cases ***
Validate company type on specialty login screens

        [Tags]    JIRA:BOT-126  refactor
        open automation browser  ${emanager}/security/RVLogin.action  ${browser}  download_folder=${default_download_path}  alias=eManager
        Maximize Browser Window
        Input Text    //input[@name="userId"]    1000004
        Click Button    //input[@name="logonUser"]
        Page Should Contain Element  xpath=//*[@class="errors"]//*[contains(text(), 'You have entered an invalid password')]

        [Teardown]  Close Browser

Pilot RV Card - Inactive a Card
        [Tags]  JIRA:BOT-129  refactor

        Set Test Variable  ${user}  1000004
        Set Test Variable  ${passwd}  V27JVH

        Set Test Variable  @{PASS}  1  2  3  4

        Open Browser to eManager
        Log into eManager  ${user}  ${passwd}
        Input Secure Entry Code  ${user}  @{PASS}

        Click Link    //a[@href="/cards/RVCardManagement.action"]
        Click Element  xpath=//*[@id="row"]/tbody/tr[3]/td[5]/img
        Input Text    //input[@name="cardName"]    AUTO TEST INACTIVE
        Select From List By Value    //select[@name="status"]    INACTIVE
        Input Text    //input[@name="controlNumber"]    9433
        Click Element    //input[@name="saveChanges"]
        Sleep  1
        ${cardNumber} =  get text  xpath=//*[@id="row"]/tbody/tr[3]/td[1]
        Set Suite Variable  ${cardNumber}
        Page Should Contain Element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]

Check if Card is INACTIVE
        [Tags]  JIRA:BOT-129  refactor
        Get Into DB  tch
        ${status}=  query and strip  SELECT status FROM card_status WHERE status = 'I' and card_num = '${cardNumber}'
        should be equal as strings  ${status}  I

Pilot RV Card - Activate a Card
        [Tags]  JIRA:BOT-129  refactor
        Click Element  xpath=//*[@id="row"]/tbody/tr[3]/td[5]/img
        Input Text    //input[@name="cardName"]    AUTO TEST ACTIVE
        Select From List By Value    //select[@name="status"]    ACTIVE
        Input Text    //input[@name="controlNumber"]    9434
        Click Element    //input[@name="saveChanges"]

Check if Card is ACTIVE
        [Tags]  JIRA:BOT-129  refactor

        page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]
        Get Into DB  tch
        ${status}=  query and strip  SELECT status FROM card_status WHERE status = 'A' and card_num = '${cardNumber}'
        should be equal as strings  ${status}  A

        [Teardown]  Close Browser

Log into Web eManager with PTRV Carrier
    [Tags]  JIRA:BOT-130  JIRA:BOT-1988  refactor
    # Variables for Test Execution
    ${carrier}  Set Variable  1000004
    ${validCard.carrier.password}    Get Carrier Password  ${carrier}
    ${endDate}  GetDateTimeNow  %Y-%m-%d

    Open eManager  ${carrier}  ${validCard.carrier.password}
    Set Test Variable  @{PASS}  1  2  3  4
    Input Secure Entry Code  ${carrier}  @{PASS}

    Get Start Date For Report  ${carrier}
    Submit Transaction Report  ${startDate}  ${endDate}
    Get Date and Amount For Validation
    Validate Report with Database  ${carrier}  ${transDate}  ${transAmount}

    [Teardown]  Close Browser

*** Keywords ***
Get Start Date For Report
    [Arguments]  ${carrier}
    ${query}  Catenate  SELECT TO_CHAR(trans_date,'%Y-%m-%d') AS trans_date
    ...  FROM TRANSACTION
    ...  WHERE carrier_id = '${carrier}'
    ...  ORDER BY trans_date DESC LIMIT 1
    ${startDate}  Query and Strip  ${query}
    Set Test Variable  ${startDate}

Submit Transaction Report
    [Arguments]  ${startDate}  ${endDate}
    Click Element  //a[contains(text(),'Home')]
    Click Link  //a[@href="/cards/RVStatements.action"]
    Input Text  startDate  ${startDate}
    Input Text  endDate  ${endDate}
    Click Button  submit

Get Date and Amount For Validation
    ${transDate}  Get Text   //table[@id='row']//tbody//tr[1]/td[count(//a[text()='Date']/parent::th/preceding-sibling::th)+1]
    Tch Logging  \n TRANS DATE:${transDate}
    ${transAmount}  Get Text  //table[@id='row']//tbody//tr[1]/td[count(//a[text()='Amount']/parent::th/preceding-sibling::th)+1]
    ${transAmount}   Strip My String  ${transAmount}  characters=($)
    Set Test Variable  ${transDate}
    Set Test Variable  ${transAmount}

Validate Report with Database
    [Arguments]  ${carrier}  ${transDate}  ${transAmount}
    Get Into DB  TCH
    Row Count is Equal to X  SELECT inv_total FROM transaction WHERE carrier_id = ${carrier} AND inv_total= ${transAmount} AND trans_date = '${transDate}';  1
    Tch Logging  \n IT MATCHES WITH DB!