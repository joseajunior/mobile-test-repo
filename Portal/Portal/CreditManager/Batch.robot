*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium

Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Open Browser And Login To Portal
Suite Teardown  Close All Browsers
Force Tags  Portal  Credit Manager  weekly
Documentation  This is for the batch payments and adjustments creation functionality on Credit Manager

*** Variables ***
${ar_number}  0005249800413
${number}

*** Test Cases ***
Make Adjustments On Credit Manager
    [Tags]  JIRA:BOT-85  JIRA:PORT-404  qTest:31801949  Regression
    [Documentation]  Make sure you can submit an Adjustment through Credit Manager > Batch
    [Setup]  Open Batch Menu Option  Adjustments
    Wait For Batch Adjustments Screen
    Input Adjustments Values
    Save Adjustments
    Adjustments Are Properly Saved On Database
    [Teardown]  Run Keyword If Test Failed  Go Back To Credit Manager Home

Make Payments On Credit Manager
    [Tags]  JIRA:BOT-85  JIRA:PORT-404  qTest:34931707  Regression
    [Documentation]  Make sure you can submit a Payment through Credit Manager > Batch
    [Setup]  Open Batch Menu Option  Payments
    Wait For Batch Payments Screen
    Input Payments Values
    Save Payments

*** Keywords ***
Open Browser And Login To Portal
    Find AR Number
    Open Browser to portal
    Log Into Portal  ${PortalUsername}  ${PortalPassword}
#    wait until keyword succeeds  60s  5s  Log In Bandage  ${PortalUsername}  ${PortalPassword}
    Go To Credit Manager

Find AR Number
    ${carrier}  Find Carrier in Oracle  A
    Get into db  TCH
    ${query}  catenate  select ar_number from contract where carrier_id = '${carrier}'
    ${result}  query and strip  ${query}
    log to console  ${result}
    set suite variable  ${arnumber}  ${result}

Go To Credit Manager
    Wait Until Element Is Visible  //*[text()[contains(.,"Credit Manager")]]  timeout=60
    Select Portal Program  Credit Manager

Open Batch Menu Option
    [Arguments]  ${menu_option}
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Batch')]
    Click Element  //*[@class="menu"]//descendant::*[contains(text(),'${menu_option}')]

Go Back To Credit Manager Home
    Click Portal Button  Cancel
    Wait Until Page Contains Element  //*[@id="pmd_home"]  timeout=60
    Click Element  //*[@id="pmd_home"]
    Go To Credit Manager

Wait For Batch ${type} Screen
    Wait Until Element Is Visible  //div[@id='batchEntry_caption']/span[text()='Batch ${type}']  timeout=180
    Page Should Contain  Batch ${type}
    Page Should Contain  For Which Issuer Group?
    ${number}=  Generate Random String  4  [NUMBERS]
    Set Test Variable  ${number}

Input ${type}s Values
    Select From List By Value  //*[@id="batchEntry_content"]//*[@id="abc"]  10    #EFS
    Wait Until Element Is Visible  //*[@id="tabular[0].arNumber"]  timeout=60
    Input Text  //*[@id="tabular[0].arNumber"]  ${ar_number}
    Press Keys  //*[@id="tabular[0].arNumber"]   TAB
    Click Element  //*[@id="tabular[0].arNumber"]
    Press Keys  //*[@id="tabular[0].arNumber"]   TAB
    Wait Until Element Is Visible  //th[@datasource="carrierName"]//div[@class="jtd"]  timeout=60
    Wait Until Element Is Visible  //div[@id="tabular[0].adjInvNum"]//*[@name="request.tabular[0].adjInvNum"]  timeout=60
    Click Element  //*[@id="tabular[0].amount" and @name="requestScope.tabular[0].amount"]
    Input Text  //*[@id="tabular[0].amount"]  0.10
    Click Element  //*[@id="tabular[0].arNumber"]
    Press Keys  //*[@id="tabular[0].arNumber"]   TAB
    Wait Until Element Is Visible  request.tabular[0].transCode  timeout=10
    Run Keyword If  '${type}'=='Adjustment'  Select From List By Value  request.tabular[0].transCode  13075
    Run Keyword If  '${type}'=='Payment'  Select From List By Value  request.tabular[0].transCode  ACH
    Scroll Element Into View  //*[@id="tabular[0].description"]
    Input Text  //*[@id="tabular[0].description"]  ${type}${number}
    Input Text  //*[@id="tabular[1].arNumber"]  ${ar_number}
    Press Keys  //*[@id="tabular[1].arNumber"]   TAB
    Click Element  //*[@id="tabular[1].arNumber"]
    Press Keys  //*[@id="tabular[1].arNumber"]   TAB
    Wait Until Element Is Visible  //th[@datasource="carrierName"]//div[@class="jtd"]  timeout=60
    Wait Until Element Is Visible  //div[@id="tabular[1].adjInvNum"]//*[@name="request.tabular[1].adjInvNum"]  timeout=60
    Click Element  //*[@id="tabular[1].amount" and @name="requestScope.tabular[1].amount"]
    Input Text  //*[@id="tabular[1].amount"]  5.98
    Click Element  //*[@id="tabular[1].arNumber"]
    Press Keys  //*[@id="tabular[1].arNumber"]   TAB
    Wait Until Element Is Visible  request.tabular[1].transCode  timeout=10
    Run Keyword If  '${type}'=='Adjustment'  Select From List By Value  request.tabular[1].transCode  13075
    Run Keyword If  '${type}'=='Payment'  Select From List By Value  request.tabular[1].transCode  ACH
    Scroll Element Into View  //*[@id="tabular[1].description"]
    Input Text  //*[@id="tabular[1].description"]  ${type}${number}

Save ${type}s
    Click Portal Button  Submit
    Click Portal Button  Yes
    Wait Until Element Is Visible  //span[contains(text(),'OK')]/ancestor::a  timeout=60
    Click Element  //span[contains(text(),'OK')]/ancestor::a
    Sleep  5

Get Batch Adjustments On Database
    Get Into Db  TCH
    ${query}=  Catenate  SELECT * FROM contract_adjustment WHERE ar_number=${ar_number}
    ${db_value}=  Query and Strip to Dictionary  ${query}
    [Return]  ${db_value}

Get Batch Payments On Database
    #TODO: When automation is able to make Oracle connections on AWS, this implementation must be done

Adjustments Are Properly Saved On Database
    ${adjustments}=  Get Batch Adjustments On Database
    ${length}=  Get Length  ${adjustments['amount']}
    Should Be True  ${length} >= 2
    ${length}=  Evaluate  ${length} - 2
    Should Be Equal As Numbers  ${adjustments['amount']}[${length}]  -0.10
    Should Be Equal As Integers  ${adjustments['trans_code']}[${length}]  13075
    Should Be Equal As Strings  ${adjustments['description']}[${length}]  robot@efsllc - Adjustment${number}
    ${length}=  Evaluate  ${length} + 1
    Should Be Equal As Numbers  ${adjustments['amount']}[${length}]  -5.98
    Should Be Equal As Integers  ${adjustments['trans_code']}[${length}]  13075
    Should Be Equal As Strings  ${adjustments['description']}[${length}]  robot@efsllc - Adjustment${number}

Payments Are Properly Saved On Database
    Get Batch Payments On Database