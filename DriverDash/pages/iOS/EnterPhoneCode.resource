*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_code_number_input}        xpath=//XCUIElementTypeTextField[@name="ConfirmationCodeTextField"]
${_next_for_code_button}     xpath=//XCUIElementTypeButton[@name="NextButton"]
${_resend_code_button}       xpath=//XCUIElementTypeButton[@name="ResendCodeButton"]
${_didnt_receive_button}     xpath=//XCUIElementTypeButton[@name="DidNotReceiveLinkButton"]

*** Keywords ***
Input "${code}" As Code Number
    Wait Until Element Is Visible    ${_code_number_input}
    Clear Text    ${_code_number_input}
    Input Text    ${_code_number_input}    ${code}

Click On Next Button On Code Page
    Wait Until Element Is Visible    ${_next_for_code_button}
    Click Element    ${_next_for_code_button}
    Wait Until Page Does Not Contain Element    ${_code_number_input}    timeout=20