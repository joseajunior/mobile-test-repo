*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_privacy_policy_title}                xpath=//XCUIElementTypeNavigationBar[@name="Privacy Policy"]/XCUIElementTypeStaticText[@name="Privacy Policy"]
${_navigate_up_privacy_policy}          xpath=//XCUIElementTypeNavigationBar[@name="Privacy Policy"]/XCUIElementTypeButton[@name="More"]

*** Keywords ***
Close Privacy Policy Page
    Wait Until Page Contains Element    ${_navigate_up_privacy_policy}    timeout=10s
    Click Element    ${_navigate_up_privacy_policy}
    Wait Until Page Does Not Contain Element    ${_privacy_policy_title}    timeout=10s
