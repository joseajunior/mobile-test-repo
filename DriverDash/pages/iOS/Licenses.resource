*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_licenses_title}          xpath=//XCUIElementTypeNavigationBar[@name="Licenses"]/XCUIElementTypeStaticText[@name="Licenses"]
${_navigate_up_licenses}    xpath=//XCUIElementTypeNavigationBar[@name="Licenses"]/XCUIElementTypeButton[@name="More"]

*** Keywords ***
Close Licenses Page
    Wait Until Element Is Visible    ${_navigate_up_licenses}
    Click Element    ${_navigate_up_licenses}
    Wait Until Page Does Not Contain Element    ${_licenses_title}    timeout=15