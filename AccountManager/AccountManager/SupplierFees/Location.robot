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
Update error handling on Supplier Tabs - Locations
    [Tags]  Q2:2023    JIRA:OT-16  qTest:120504730    API:Y
    [Documentation]  Open, close and open again Add New Location Fee tabs to verify that the fields BY PRODUCT,
     ...             CHECK AUTH FEE TYPE and CURRENCY are filled in by default

    Open Account Manager
    Go to Supplier Fees Tab
    Go to Location Tab
    Click Add New Location Fee Button
    Close Add New Location Fee Window
    Click Add New Location Fee Button
    Check if CHECK AUTH FEE TYPE Dropdown is Selected
    Check if Assign To New Fee Id Dropdown is Selected
    Check if CURRENCY Dropdown is Selected
    [Teardown]  Close Browser

Check if Location fees to Shell are enabled
    [Tags]  Q2:2023    JIRA:OT-13  qTest:120528612    API:Y
    [Documentation]  Add location fees to Shell must be enabled

    Open Account Manager
    Go to Supplier Fees Tab
    Go to Location Tab
    Select DB Instance    SHELL_CANADA
    Click On Submit Button
    Click Add New Location Fee Button
    Check if Database is Correct    SHELL_CANADA
    [Teardown]  Close Browser

Check if Add Location fees to Imperial are enabled
    [Tags]  Q2:2023    JIRA:OT-13  qTest:120528612    API:Y
    [Documentation]  Add location fees to Imperial must be enabled

    Open Account Manager
    Go to Supplier Fees Tab
    Go to Location Tab
    Select DB Instance    IMPERIAL_OIL
    Click On Submit Button
    Click Add New Location Fee Button
    Check if Database is Correct    IMPERIAL_OIL
    [Teardown]  Close Browser

Check if Add Location fees to Irving are enabled
    [Tags]  Q2:2023    JIRA:OT-13  qTest:120528612    API:Y
    [Documentation]  Add location fees to Irving must be enabled

    Open Account Manager
    Go to Supplier Fees Tab
    Go to Location Tab
    Select DB Instance    IRVING_OIL
    Click On Submit Button
    Click Add New Location Fee Button
    Check if Database is Correct    IRVING_OIL
    [Teardown]  Close Browser

Check if Add Location fees to TCH are enabled
    [Tags]  Q2:2023    JIRA:OT-13  qTest:120528612    API:Y
    [Documentation]  Add location fees to TCH must be enabled

    Open Account Manager
    Go to Supplier Fees Tab
    Go to Location Tab
    Select DB Instance    EFS
    Click On Submit Button
    Click Add New Location Fee Button
    Check if Database is Correct    EFS
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

Go to Location Tab
    [Tags]  qtest
    [Documentation]    Go to Location Tab
    Wait Until Element Is Visible  //a[@id='sfsLocations']
    Click Element  //a[@id='sfsLocations']

Click Add New Location Fee Button
    [Tags]  qtest
    [Documentation]    Click Add New Location Fee Button
    Wait Until Element Is Visible  //span[contains(text(), "ADD NEW LOCATION FEE")]
    Click Element  //span[contains(text(), "ADD NEW LOCATION FEE")]

Close Add New Location Fee Window
    [Tags]  qtest
    [Documentation]    Close Add New Location Fee Window
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

Select DB Instance
    [Tags]  qtest
    [Documentation]    Select DB Instance
    [Arguments]    ${DB_INSTANCE}
    Wait Until Element Is Enabled    //*[@id="businessPartnerCode"]
    Mouse over    //*[@id="businessPartnerCode"]
    Select from list by value    //*[@id="businessPartnerCode"]  ${DB_INSTANCE}

Click On Submit Button
    [Tags]  qtest
    [Documentation]    Click On Submit Button
    Wait Until Element Is Enabled    //tbody/tr[2]/td[1]/div[2]/div[1]/div[2]/div[1]/div[1]/button[1]
    Click Element  //tbody/tr[2]/td[1]/div[2]/div[1]/div[2]/div[1]/div[1]/button[1]
    Wait Until Loading Spinners Are Gone

Check if Database is Correct
    [Tags]  qtest
    [Documentation]    Check if Database is Correct
    [Arguments]    ${DB_INSTANCE}
    Wait Until Element Is Enabled    //*[@id="businessPartnerCode"]
    ${selected_value}=    Get Selected List Value    //*[@id="businessPartnerCode"]
    Should Be Equal As Strings  ${selected_value}  ${DB_INSTANCE}