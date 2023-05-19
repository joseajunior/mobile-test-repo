*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_LOGIN_LOGO_LOCATOR}    chain=**/XCUIElementTypeImage[`label == "WEXLogo"`]
${_LOGIN_TITLE_LOCATOR}    chain=**/XCUIElementTypeStaticText[`label == "CardControl"`]
${_CARD_NUMBER_LOCATOR}    chain=**/XCUIElementTypeTextField[`name == "Card Number Text Field"`]
${_PASSCODE_LOCATOR}        chain=**/XCUIElementTypeSecureTextField[`name == "PIN Passcode Text Field"`]
${_SHOW_PASSCODE_LOCATOR}    chain=**/XCUIElementTypeImage[`label == "show"`]
${_LOGIN_BTN_LOCATOR}        chain=**/XCUIElementTypeButton[`label == "Log in"`]
${_FORGOT_PASSCODE_LOCATOR}    chain=**/XCUIElementTypeButton[`label == "Forgot PIN or passcode"`]

*** Keywords ***
Input "${card_number}" Card Number
    Wait Until Page Contains Element    ${_CARD_NUMBER_LOCATOR}    
    Input Text    ${_CARD_NUMBER_LOCATOR}    ${card_number}

Input "${passcode}" PIN or Passcode
    Wait Until Page Contains Element    ${_PASSCODE_LOCATOR}
    Input Password    ${_PASSCODE_LOCATOR}    ${passcode}

Click On Login Button
    Wait Until Page Contains Element    ${_LOGIN_BTN_LOCATOR}
    Click Element    ${_LOGIN_BTN_LOCATOR}

Click On Forgot PIN or Passcode Button
    Wait Until Page Contains Element    ${_FORGOT_PASSCODE_LOCATOR}
    Click Element    ${_FORGOT_PASSCODE_LOCATOR}