*** Settings ***
Library    WexRobotLib.MobileLibrary
Resource    Activities.resource

*** Variables ***
${_AMOUNT_INPUT_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/register_check_amount_textedit
${_NEXT_BTN_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/rc_next_button
${_INFO_BTN_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/question_item
${_AVAILABLE_BALANCE_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/amount_subtext_textview
${_CLEAR_AMOUNT_BTN_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/text_input_end_icon
${_CLOSE_REGITER_BTN_LOCATOR}    xpath=android.widget.ImageButton[@content-desc="Navigate Up"]
${_CHECK_NUMBER_INPUTH_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/textinput_placeholder

*** Keywords ***
Close Register Check Window
    Wait Until Element Is Visible    ${_CLOSE_REGITER_BTN_LOCATOR}
    Click Element    ${_CLOSE_REGITER_BTN_LOCATOR}

Go Back To Amount Window
    Wait Until Element Is Visible    ${_CLOSE_REGITER_BTN_LOCATOR}
    Click Element    ${_CLOSE_REGITER_BTN_LOCATOR}

Input "${amount}" As Amount
    Wait Until Element Is Visible    ${_CLEAR_AMOUNT_BTN_LOCATOR}
    Click Element    ${_CLEAR_AMOUNT_BTN_LOCATOR}
    Input Text    ${_AMOUNT_INPUT_LOCATOR}    ${amount}

Click On Next Button
    Wait Until Element Is Visible    ${_NEXT_BTN_LOCATOR}
    Click Element    ${_NEXT_BTN_LOCATOR}

Click On Register Check Info Button
    Wait Until Element Is Visible    ${_INFO_BTN_LOCATOR}
    Click Element    ${_INFO_BTN_LOCATOR}