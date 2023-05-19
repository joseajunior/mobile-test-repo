*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  BuiltIn
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Teardown  Close Browser
Force Tags  eManager

*** Test Cases ***
TA Discount Setup
    [Tags]    JIRA:BOT-162  refactor
     open emanager  ${user_ref}  ${pass_ref}
     Maximize Browser Window
     Mouse Over   id=menubar_1x2
     Click Element    TCHONLINE_TA_DISCOUNTSETUPx2
     Click Element    name=radioSel
     Click Element   name=search
     ${ch_carID} =  get text   //*[@id="row"]/tbody/tr[2]/td[1]
     set global variable  ${ch_carID}

     Click Element  //*[text()='${ch_carID}']/parent::*/td[10]
     Input Text   name=tpAccountNum  1122334455
     Click Button  name=add
     Page Should Contain Element  //*[@class="messages"]//self::li

Check DB for new TA
    [Tags]  refactor
        Get Into DB  tch
        ${tp_account_num}=  query and strip  SELECT tp_account_num FROM tp_billing WHERE carrier_id= ${ch_carID}
        should be equal as strings  ${tp_account_num}  1122334455

Edit the TA added
    [Tags]  refactor
    Click Element  //*[text()='${ch_carID}']/parent::*/td[10]
    Input Text  name=tpAccountNum  111#22$33%44&
    Click Button  name=update
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Your Account Number must contain only numbers.')]
    Input Text   name=tpAccountNum   1122334455
    Click Element  //*[@name="tpTchId"]/option[2]
    Click Button  name=update

Chekc DB for edited TA
    [Tags]  refactor
        Get Into DB  tch
        ${tp_tch_id}=  query and strip  SELECT tp_tch_id FROM tp_billing WHERE carrier_id= ${ch_carID}
        should be equal as strings  ${tp_tch_id}  N

Delete TA created
    [Tags]  refactor
    Click Element  //*[text()='${ch_carID}']/parent::*/td[11]
    confirm action
    Page Should Contain Element  //*[@class="messages"]//self::li

Check DB for deleted TA
        [Tags]  refactor
        Get Into DB  tch
        row count is 0  SELECT tp_account_num FROM tp_billing WHERE carrier_id= ${ch_carID}


*** Keywords ***