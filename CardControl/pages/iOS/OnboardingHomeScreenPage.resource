*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_ALLOW_BTN_LOCATOR}    chain=**/XCUIElementTypeButton[`label == "Allow"`]
${_CONTINUE_BTN_LOCATOR}    chain=**/XCUIElementTypeButton[`label == "Continue"`]

*** Keywords ***
Click On Continue Button
    Wait Until Page Contains Element    ${_CONTINUE_BTN_LOCATOR}
    Run Keyword And Ignore Error    Click Element   ${_ALLOW_BTN_LOCATOR}
    Click Element    ${_CONTINUE_BTN_LOCATOR}
