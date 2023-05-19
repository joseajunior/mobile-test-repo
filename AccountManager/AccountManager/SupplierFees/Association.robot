*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ssh.PySSH
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Variables ***

*** Test Cases ***
Update error handling on Supplier Tabs - Association
    [Tags]  Q2:2023    JIRA:OT-16  qTest:120504959    API:Y
    [Documentation]  Open, close and open again Add New Association Fee tabs to verify that the fields BY PRODUCT,
     ...             CHECK AUTH FEE TYPE and CURRENCY are filled in by default

    Open Account Manager
    Go to Supplier Fees Tab
    Go to Association Tab
    Click Add Button
    Close Add Window
    Click Add Button
    Check if CHECK AUTH FEE TYPE Dropdown is Selected
    Check if Assign To New Fee Id Dropdown is Selected
    Check if CURRENCY Dropdown is Selected
    [Teardown]  Close Browser

*** Keywords ***
Open Account Manager
    [Tags]  qtest
    [Documentation]    Open Account Manager
    Open eManager   ${intern}   ${internPassword}
    Go to   ${emanager}/acct-mgmt/RecordSearch.action
    Wait until loading spinners are gone

Go to Supplier Fees Tab
    [Tags]  qtest
    [Documentation]    Go to Supplier Fees Tab
    Wait Until Element Is Visible    //a[@id='SupplierFee']
    Click Element  //a[@id='SupplierFee']

Go to Association Tab
    [Tags]  qtest
    [Documentation]    Go to Association Tab
    Wait Until Element Is Visible  //a[@id='sfsAssociations']
    Click Element  //a[@id='sfsAssociations']

Click Add Button
    [Tags]  qtest
    [Documentation]    Click Add Button
    Wait Until Element Is Visible  //span[contains(text(), "ADD")]
    Click Element  //span[contains(text(), "ADD")]

Close Add Window
    [Tags]  qtest
    [Documentation]    Close Add Window
    Wait Until Element Is Enabled    //button[@class="buttonlink right" and contains(text(), "Close")]
    Click Element  //button[@class="buttonlink right" and contains(text(), "Close")]

Check if CHECK AUTH FEE TYPE Dropdown is Selected
    [Tags]  qtest
    [Documentation]    Check if CHECK AUTH FEE TYPE Dropdown is Selected
    sleep  1
    ${selected_value}=    Get Selected List Value    //*[@id="cbxFeeType"]
    Should Be Equal As Strings  ${selected_value}  P

Check if Assign To New Fee Id Dropdown is Selected
    [Tags]  qtest
    [Documentation]    Check if Assign To New Fee Id Dropdown is Selected
    ${selected_value}=    Get Selected List Value    //select[@name='detailRecord.cbxApplyFeeMode']
    Should Be Equal As Strings  ${selected_value}  N

Check if CURRENCY Dropdown is Selected
    [Tags]  qtest
    [Documentation]    Check if CURRENCY Dropdown is Selected
    ${selected_value}=    Get Selected List Value    //*[@name="detailRecord.flatCurrency"]
    Should Be Equal As Strings  ${selected_value}  U