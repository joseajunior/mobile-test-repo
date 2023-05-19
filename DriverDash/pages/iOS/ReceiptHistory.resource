*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_receipt_history_title}          xpath=//XCUIElementTypeNavigationBar[@name="Receipt history"]//XCUIElementTypeStaticText[@name="Receipt history"]
${_navigate_up_receipt_history}    xpath=//XCUIElementTypeNavigationBar[@name="Receipt history"]//XCUIElementTypeButton[@name="More"]

*** Keywords ***
Navigate Up To More Page From Receipt History Page
    Wait Until Page Contains Element    ${_navigate_up_receipt_history}
    Click Element    ${_navigate_up_receipt_history}
    Wait Until Page Does Not Contain Element    ${_receipt_history_title}
