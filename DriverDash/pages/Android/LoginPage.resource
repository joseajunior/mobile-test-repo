*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_USERNAME_LOCATOR}               id=com.wex.fleet.driverdash.stage:id/username_edit_text
${_PASSWORD_LOCATOR}               id=com.wex.fleet.driverdash.stage:id/password_edit_text
${_SHOW_PASSWORD_LOCATOR}          id=com.wex.fleet.driverdash.stage:id/text_input_end_icon
${_LOGIN_BTN_LOCATOR}              id=com.wex.fleet.driverdash.stage:id/do_login
${_FORGOT_USER_PASS_LOCATOR}       id=com.wex.fleet.driverdash.stage:id/forgot_username
${_DONT_HAVE_USER_PASS_LOCATOR}    id=com.wex.fleet.driverdash.stage:id/login_no_credentials_button

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