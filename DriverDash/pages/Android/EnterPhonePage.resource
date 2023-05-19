*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_phone_number_login}    id=com.wex.fleet.driverdash.stage:id/login_phone_number_edit_text
${_next_phone_btn}        id=com.wex.fleet.driverdash.stage:id/next_button
${_having_trouble}        id=com.wex.fleet.driverdash.stage:id/login_phone_button_trouble

*** Keywords ***
Input "${phone_number}" As Phone Number
    Wait Until Element Is Visible    ${_phone_number_login}    timeout=10
    Clear Text    ${_phone_number_login}
    Input Text    ${_phone_number_login}    ${phone_number}

Click On Next Button For Phone Login
    Wait Until Element Is Visible    ${_next_phone_btn}    timeout=10
    Click Element    ${_next_phone_btn}
    Wait Until Page Does Not Contain Element    ${_phone_number_login}    timeout=20