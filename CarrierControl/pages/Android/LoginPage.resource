*** Settings ***
Library    WexRobotLib.MobileLibrary
Resource    Activities.resource

*** Variables ***
${__PACKAGE_NAME}                com.efsllc.efscarriercontrol.stage
${_LOGIN_TITLE_LOCATOR}          id=${__PACKAGE_NAME}:id/app_name_label
${_USERNAME_LOCATOR}             id=${__PACKAGE_NAME}:id/username_text_view
${_PASWORD_LOCATOR}              id=${__PACKAGE_NAME}:id/password_text_view
${_SHOW_PASSCODE_LOCATOR}        id=${__PACKAGE_NAME}:id/text_input_end_icon
${_LOGIN_BTN_LOCATOR}            id=${__PACKAGE_NAME}:id/login_button

*** Keywords ***
Input "${card_number}" As Username
    Wait Until Page Contains Element    ${_USERNAME_LOCATOR}
    Input Text    ${_USERNAME_LOCATOR}    ${card_number}

Input "${passcode}" As Password
    Wait Until Page Contains Element    ${_PASWORD_LOCATOR}
    Input Password    ${_PASWORD_LOCATOR}    ${passcode}

Click On Login Button
    Wait Until Page Contains Element    ${_LOGIN_BTN_LOCATOR}
    Click Element    ${_LOGIN_BTN_LOCATOR}
