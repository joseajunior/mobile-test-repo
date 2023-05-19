*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_code_number_input}        id=com.wex.fleet.driverdash.stage:id/login_code_edit_text
${_next_for_code_button}     id=com.wex.fleet.driverdash.stage:id/next_button
${_resend_code_button}       id=com.wex.fleet.driverdash.stage:id/login_code_resend_message
${_didnt_receive_button}     id=com.wex.fleet.driverdash.stage:id/login_code_message_not_received

*** Keywords ***
Input "${code}" As Code Number
    Wait Until Element Is Visible    ${_code_number_input}
    Clear Text    ${_code_number_input}
    Input Text    ${_code_number_input}    ${code}

Click On Next Button On Code Page
    Wait Until Element Is Visible    ${_next_for_code_button}
    Click Element    ${_next_for_code_button}
    Wait Until Page Does Not Contain Element    ${_code_number_input}    timeout=20