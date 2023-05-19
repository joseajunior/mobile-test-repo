*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_USERNAME_LOCATOR}               chain=**/XCUIElementTypeTextField[`value == "Username"`]
${_PASSWORD_LOCATOR}               chain=**/XCUIElementTypeSecureTextField[`value == "Password"`]
${_SHOW_PASSWORD_LOCATOR}          chain=**/XCUIElementTypeButton[`label == "EyeNormal"`]
${_LOGIN_BTN_LOCATOR}              chain=**/XCUIElementTypeButton[`label == "Log in"`]
${_FORGOT_USER_PASS_LOCATOR}       chain=**/XCUIElementTypeButton[`label == "Forgot username or password?"`]
${_DONT_HAVE_USER_PASS_LOCATOR}    chain=**/XCUIElementTypeButton[`label == "Don't have a username and password?"`]

*** Keywords ***
Input "${username}" As Username
    Wait Until Page Contains Element    ${_USERNAME_LOCATOR}    
    Input Text    ${_USERNAME_LOCATOR}    ${username}

Input "${password}" As Password
    Wait Until Page Contains Element    ${_PASSWORD_LOCATOR}
    Input Password    ${_PASSWORD_LOCATOR}    ${password}

Click On Login Button
    Wait Until Page Contains Element    ${_LOGIN_BTN_LOCATOR}
    Click Element    ${_LOGIN_BTN_LOCATOR}
    Wait Until Page Does Not Contain Element    ${_LOGIN_BTN_LOCATOR}    timeout=30

Click On Forgot Username or Password Button
    Wait Until Page Contains Element    ${_FORGOT_USER_PASS_LOCATOR}
    Click Element    ${_FORGOT_USER_PASS_LOCATOR}
    Wait Until Page Does Not Contain Element    ${_LOGIN_BTN_LOCATOR}    timeout=30

Click On Don't Have Username or Password Button
    Wait Until Page Contains Element    ${_DONT_HAVE_USER_PASS_LOCATOR}
    Click Element    ${_DONT_HAVE_USER_PASS_LOCATOR}
    Wait Until Page Does Not Contain Element    ${_LOGIN_BTN_LOCATOR}    timeout=30
