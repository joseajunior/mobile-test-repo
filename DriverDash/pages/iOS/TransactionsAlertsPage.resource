*** Settings ***
Library     AppiumLibrary

*** Variables ***
${_CONTINUE_BTN_LOCATOR}    chain=**/XCUIElementTypeButton[`label == "Continue"`]

*** Keywords ***
Click On Continue Button
    Wait Until Element Is Visible    ${_CONTINUE_BTN_LOCATOR}    timeout=20
    Click Element    ${_CONTINUE_BTN_LOCATOR}

Skip The Alert Page
    Click On Continue Button
