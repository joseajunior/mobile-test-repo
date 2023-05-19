*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Teardown  Close Browser
Force Tags  eManager

*** Test Cases ***
Child Carrier Load Report - Error on Dates
    [Tags]    JIRA:BOT-160  refactor
    
    open emanager  ${usertier}  ${passtier}
    Maximize Browser Window
    Mouse Over    id=menubar_1x2
    Mouse Over    id=TCHONLINE_CREDITMGMTx2
    Click Element    id=CREDITMGMT_CHILD_CARRIER_LOAD_RPTx2
    Input Text    name=endDate    2018-01-10
    Click Element    name=search
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'End Date cannot be before Start Date.')]
    Input Text    name=startDate    2014-02-28
    Click Element    name=search
    Page Should Contain Element  //*[@id="row"]

*** Keywords ***
