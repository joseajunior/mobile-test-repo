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
Referral Level Management - Add a Child Carrier and Delete It Afterwards

    [Tags]    JIRA:BOT-153  refactor

    Open Emanager  ${user_ref}  ${pass_ref}
    Mouse Over    id=menubar_1x2
    Mouse Over    id=TCHONLINE_MGNTAPPx2
    Click Element    id=MGNTAPP_REFERAL_LEVEL_MANAGEMENTx2
    Click Element    name=radioSel
    Click Element    name=search
    Click Element    xpath=//*[@id="row"]/tbody/tr[2]/td[1]/input

    ${ccarID} =  get text  //*[@id="row"]/tbody/tr[2]/td[2]
    set global variable     ${ccarID}
    log to console  ${ccarID}

    Click Element    name=saveSelect
    Page Should Contain Element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully added.')]

    Get Into DB  tch
    row count is greater than x  SELECT carrier_id FROM carrier_group_rebate WHERE carrier_id = ${ccarID};  0

    Click Element    name=back
    Click Element    name=modifyExisChildCarrier
    Click Element    //*[text()="${ccarID}"]/parent::*/td[last()]/form/input[6]
    Confirm Action
    sleep  2
    Page Should Contain Element  xpath=//*[contains(text(),'Successfully ')]/../*/*[contains(text(),'deleted')]/../*[contains(text(),'(${ccarID})')]

*** Keywords ***
