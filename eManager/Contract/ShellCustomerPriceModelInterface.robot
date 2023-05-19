*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Documentation  Ensure the Sliding Scale Price Model option works in E-manager.  \n\n
Suite Teardown  Close Browser
Force Tags  eManager

*** Test Cases ***
Shell Customer Price Model Interface - Model RTLSSCPL
    [Tags]  BOT-214  refactor
    set test variable  ${model}  RTLSSCPL
    set test variable  ${channel}  RTL
    set test variable  ${shell_contract}  19
    Add Shell Customer Price Model
    Check DB
    Delete Shell Customer Price Information     #...  THIS INFO IS BEING DELETED SO THAT THIS SCRIPT CAN BE RAN MULTIPLE TIMES


Shell Customer Price Model Interface - Model RTLNHF
    [Tags]  BOT-214  refactor
    set test variable  ${model}  RTLNHF
    set test variable  ${channel}  RTL
    set test variable  ${shell_contract}  19
    Add Shell Customer Price Model
    Check DB
    Delete Shell Customer Price Information

*** Keywords ***
Add Shell Customer Price Model
    Open Emanager  ${shell_carrier}  ${shell_password}
    Mouse Over    id=menubar_1x2
    Mouse Over    id=TCHONLINE_SHELLPRICEx2
    Click Element    id=SHELLPRICE_CUSTOMER_PRICEx2
    Click Element    name=add
    Input Text    name=customerPriceModel.contractId    ${shell_contract}
    Select From List By Label    name=selectChannel    ${channel}
    Select From List By Label    name=selectModel    ${model}
    Select From List By Value  name=selectScaleId  SS2
    Input Text    name=commitedPurchase.volume    50
    Click Element    name=save
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'You have successfully')]//parent::*//descendant::*

Check DB
    ${eff_date}=  getdatetimenow  %Y-%m-%d  days=+1
    set global variable  ${eff_date}

    get into DB     shell
    Row Count Is Equal To X   SELECT model FROM cust_price_model WHERE contract_id=${shell_contract} AND channel='${channel}' AND model='${model}' limit 1  1

Delete Shell Customer Price Information
    get into DB  shell
    execute sql string  dml=delete FROM cust_price_model WHERE contract_id=${shell_contract} AND channel='${channel}' AND model='${model}' AND efF_dt='${eff_date}'
    tch logging  Shell Customer Price Information Deleted
