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
Carrier Group Tier Deals
    [Tags]    JIRA:BOT-127  refactor
    open emanager  ${usertier}  ${passtier}
    Maximize Browser Window
    Mouse Over   id=menubar_1x2
    Mouse Over  id=TCHONLINE_CARRIERGROUPDEALSx2
    Mouse Over  id=CARRIERGROUPDEALS_CARRIER_GROUP_TIERSx2
    Click Element  id=CARRIERGROUPDEALS_CARRIER_GROUP_TIERSx2
    Click element  //input[@name="creatNew"]
    input text  //*[text()="Create New Tiers"]/parent::*/parent::*/table/tbody/tr/td[2]/input  Tier1011     #change de tier name before running the script
    Click Element    //input[@name="add"]
    Page Should Contain Element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully')]
    ${tierDesc} =  get text  xpath=//*[@class="odd"]//*[contains(text(), 'Tier1011')]       #be aware that the class' name may change depending on the alphabetical order
    set global variable  ${tierDesc}
    #log to console  ${tierDesc}

Check Database for new Tier
    [Tags]  refactor
        Get Into DB  tch
        ${tier_description}=  query and strip  SELECT tier_description FROM carrier_group_deal_tiers WHERE tier_description = '${tierDesc}'
        should be equal as strings  ${tier_description}  Tier1011

Carrier Group Tiers Assignment
    [Tags]  refactor
    Mouse Over   id=menubar_1x2
    Mouse Over  id=TCHONLINE_CARRIER_GROUP_TIERS_ASSIGNMENTx2
    Click Element  id=TCHONLINE_CARRIER_GROUP_TIERS_ASSIGNMENTx2
    Click Element    //input[@name="radioSel"]
    Input Text    //input[@name="searchTxt"]    Tier1011
    Click Button  //input[@name="search"]
    Sleep  2
    double click element  xpath=//*[@onclick="doSelect2(this, '140655','71303' );"]
    select from list by value  xpath=//*[@onclick="doSelect2(this, '140655','71303' );"]/*[last()]  38
    ${carrierID} =  get text  xpath=//*[@id="row"]/tbody/tr[8]/td[2]
    set global variable  ${carrierID}
    #log to console  ${carrierID}
    Click Element  //input[@value="Save"]
    Page Should Contain Element  xpath=//*[@class="messages"]//*[contains(text(), 'You have successfully assigned tiers')]

Check Database for New Tier Assignment
    [Tags]  refactor
         Get Into DB  tch
         ${child_carrier_id}=  query and strip  SELECT child_carrier_id FROM carrier_group_deal_tier_assignment WHERE tier_id = 38 AND child_carrier_id= ${carrierID}
         should be equal as strings  ${child_carrier_id}  140655

Delete The Tier
    [Tags]  refactor
    go to  ${emanager}/cards/CarrierGroupTiers.action
    click element  //input[@name='removeTiers' and @onclick="return handleMesssage('Are you sure you wish to delete the tier','Tier1011');"]
    sleep  1
    confirm action
    sleep  3

*** Keywords ***
