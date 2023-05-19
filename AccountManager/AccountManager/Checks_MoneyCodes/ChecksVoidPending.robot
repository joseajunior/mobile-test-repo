*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Test Cases ***
Check Status of Checks Detial Page for Voided Field
    [Tags]  Jira:FRNT-2094  qTest:116202911
    [Documentation]  Confirm new value 'P' (pending) is showing in database checks.voided
    ...  and Account Manager > Checks/Money Codes > ChecksDetail Voided
    [Setup]  Open Account Manager

    Select Checks/Money Codes Tab
    Search By Check Number
    Click On Searched Check ${chkNumber}
    Confirm Voided Value Matches Database

    [Teardown]  Run Keywords  Close Browser

*** Keywords ***
Click On Searched Check ${chkNumber}
    Click Element  //*[@class="checkNumber buttonlink" and contains(text(), '${chkNumber}')]
    Wait Until Load Screen Icon Disappear From Screen

Click Submit Button
    Click Element  //*[@id="checksSearchContainer"]//*[contains(text(),'Submit')]
    Wait Until Load Screen Icon Disappear From Screen

Confirm Voided Value Matches Database
    ${voidedStatus}  Get Value  //*[@name="detailRecord.voided"]
    Should Be Equal  ${voidedStatus}  ${voidedValue}

Search By Check Number
    [Arguments]  ${DB}=TCH
    Get Into DB  ${DB}
    ${query}  Catenate
    ...  SELECT *
    ...  FROM checks
    ...  WHERE voided = 'P'
    ...  AND   create_date > CURRENT- 31 units day
    ...  ORDER BY create_date DESC
    ...  limit 1;
    ${return}  Query and Strip to Dictionary  ${query}
    Set Test Variable  ${chkNumber}  ${return["check_num"]}
    Set Test Variable  ${voidedValue}  ${return["voided"]}
    Select From List By Value  //*[@class="dataTables_scrollHead"]//select[@class="checksBusinessPartnerSelect searchFilter" and @name="businessPartnerCode"]  EFS
    Input Text  checkNumber  ${chkNumber}
    Click Submit Button

Select Checks/Money Codes Tab
    Click Element  //*[@id="Checks"]
    Wait Until Load Screen Icon Disappear From Screen

Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@class="loading-img"]  timeout=10
    Wait Until Element Is Not Visible    //*[@class="loading-img"]  timeout=10