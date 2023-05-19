*** Settings ***
Library    AppiumLibrary
Resource    Activities.resource

*** Variables ***
${_LOGIN_LOGO_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/login_logo
${_LOGIN_TITLE_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/title
${_CARD_NUMBER_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/card_number_edit_text
${_PASSCODE_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/pin_passcode_edit_text
${_SHOW_PASSCODE_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/text_input_end_icon
${_LOGIN_BTN_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/login_button
${_FORGOT_PASSCODE_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/forgot_password_button

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