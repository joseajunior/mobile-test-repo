*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Teardown  Close Browser
Force Tags  AM  Card Detail

*** Variables ***
${sfj_carrier}  404458
${ipolicy}  501

*** Test Cases ***
Site Policies for SFJ account (Shell database)
    [Tags]   JIRA:BOT-739  JIRA:BOT-1550  qTest:27261104  Regression  refactor
    [Documentation]  Ability to update contract on a Site Policy for SFJ Carriers, in Account Manager

    Login to Account Manager with an internal login
    Select Shell Partner and Enter in a SFJ Carrier id
    Click on subtab Site Policy and Select Policy
    Change Contract and Check DB for Contract Changed

*** Keywords ***
Login to Account Manager with an internal login
    Open eManager  ${robot_eManager_username}  ${robot_eManager_password}
    maximize browser window
    Mouse Over  menubar_1x2
    Mouse Over  TCHONLINE_THORx2
    Click Element  THOR_THOR_RECORD_SEARCHx2

Select Shell Partner and Enter in a SFJ Carrier id
#    Page Should Contain Element  //*[@id="DataTables_Table_0_wrapper"]//*[contains(text(), 'Business Partner')]
    check element exists  text=Business Partner
    Select From List By Value  businessPartnerCode  SHELL_CANADA
    Input Text  id  ${sfj_carrier}
    Click Button  //*[@class="button searchSubmit"]
    Click On  text=${sfj_carrier}

Click on subtab Site Policy and Select Policy
    Click On  SitePolicies
    double click on  text=Submit  exactMatch=False  index=2
    Click On  text=${ipolicy}

Change Contract and Check DB for Contract Changed
    Check Element Exists  text=Contract
    Select Different Random Value From List  //select[@name="detailRecord.contractId"]
    ${new_contract}  Get Selected List Label  //select[@name="detailRecord.contractId"]

    ${contract_num}  ${contract_space}  ${contract_type}   ${contract_type1}  ${contract_type2}  Strip Contract Value  ${new_contract}
    Click Button  submit

    Get Into DB  shell
    ${query}=  catenate
    ...  SELECT contract_id FROM def_card WHERE id=${sfj_carrier} AND  ipolicy=${ipolicy}
    ${result}=  query and strip  ${query}
    Should Be Equal as Strings  ${result}  ${contract_num}

Strip Contract Value
   [Arguments]   ${new_contract}
   log to console  \n
   @{columns}  Split String   ${new_contract}  ${space}
   ${contract_num}  Evaluate  '${columns[0]}'
   ${contract_space}  Evaluate  '${columns[1]}'
   ${contract_type}  Evaluate  '${columns[2]}'
   ${contract_type1}  Evaluate  '${columns[3]}'
   ${contract_type2}  Evaluate  '${columns[4]}'
   [Return]  ${contract_num}  ${contract_space}  ${contract_type}  ${contract_type1}  ${contract_type2}

Select Different Random Value From List
    [Arguments]  ${locator}  ${startIndex}=1  ${component}=select  ${childComponent}=option
    Wait Until Element Is Visible  xpath=${locator}
    ${selected_label}  Get Selected List Label  xpath=${locator}
    FOR  ${i}  IN RANGE  99999
        ${randomIndex}  Get Random Index From List Component  ${locator}  ${startIndex}
        ${randomIndex}  Convert To String  ${randomIndex}
        Select From List By Index  xpath=${locator}  ${randomIndex}
        ${current_label}  Get Selected List Label  ${locator}
        run keyword if  '${current_label}'!='${selected_label}'  Exit For Loop
    END

Get Random Index From List Component
    [Arguments]  ${locator}  ${startIndex}=0  ${component}=select  ${childComponent}=option
    ${countMaxIndex}  Get Element Count  ${locator}/${childComponent}
    ${countMaxIndex}  Evaluate  ${countMaxIndex}-1
    ${randonBetweenMaxIndex}  Evaluate  random.randint(${startIndex},${countMaxIndex})  modules=random
    [Return]  ${randonBetweenMaxIndex}