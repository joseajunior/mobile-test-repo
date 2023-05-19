*** Settings ***
Library    AppiumLibrary
Resource    Activities.resource

*** Variables ***
${_CLOSE_SETTINGS_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/close_item
${_MASKED_CARD_NUMBER_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/masked_card_num
${_COMPANY_STATUS}    id=com.efsllc.efsmobileapp.stage:id/company_status_text
${_CHANGE_PIN_BTN_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/change_pin_passcode_button
${_USERNAME_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/listitem_main_text
${_ACCOUNT_INFO_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/listitem_secondary_text
${_EDIT_ACCOUNT_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/editbutton
${_LOG_OUT_BTN_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/log_out_button
${_HELP_SCREENS_LOCATOR}    xpath=//android.widget.TextView[text()="Help screens" and @resource-id="com.efsllc.efsmobileapp.stage:id/generic_text"]
${_PRIVACY_POLICY_LOCATOR}    xpath=//android.widget.TextView[text()="Privacy policy" and @resource-id="com.efsllc.efsmobileapp.stage:id/generic_text"]
${_TERMS_OF_USE_LOCATOR}    xpath=//android.widget.TextView[text()="Terms of use" and @resource-id="com.efsllc.efsmobileapp.stage:id/generic_text"]
${_CALL_SUPPORT_LOCATOR}    xpath=//android.widget.TextView[text()="Call customer support" and @resource-id="com.efsllc.efsmobileapp.stage:id/generic_text"]

*** Keywords ***
Close Settings Window
    Wait Until Page Contains Element    ${_CLOSE_SETTINGS_LOCATOR}
    Click Element    ${_CLOSE_SETTINGS_LOCATOR}
    Wait Activity    ${HOME_ACTIVITY}    10

Get Last Digits For The Card
    Wait Until Page Contains Element    ${_MASKED_CARD_NUMBER_LOCATOR}
    ${card}    Get Text    ${_MASKED_CARD_NUMBER_LOCATOR}
    [Return]    ${card}[:-4]

Get Account's Username
    Wait Until Page Contains Element    ${_USERNAME_LOCATOR}
    ${username}    Get Text    ${_USERNAME_LOCATOR}
    [Return]    ${username}

Get Account's Additional Information
    Wait Until Page Contains Element    ${_ACCOUNT_INFO_LOCATOR}
    ${info}    Get Text    ${_ACCOUNT_INFO_LOCATOR}
    ${email}  ${phone}  ${address}  ${ssn}  ${birthdate}  Set Variable    ${info.split('\n')}
    &{returned_dict}    Create Dictionary    email=${email}    phone=${phone}    address=${address}    ssn=${ssn}    birthdate=${birthdate}
    [Return]    ${returned_dict}

Click On Change PIN
    Wait Until Page Contains Element    ${_CHANGE_PIN_BTN_LOCATOR}
    Click Element    ${_CHANGE_PIN_BTN_LOCATOR}

Click On Edit Information
    Wait Until Page Contains Element    ${_EDIT_ACCOUNT_LOCATOR}
    Click Element    ${_EDIT_ACCOUNT_LOCATOR}

Click On Help Screens Support
    Wait Until Page Contains Element    ${_HELP_SCREENS_LOCATOR}
    Click Element    ${_HELP_SCREENS_LOCATOR}

Click On Privacy Policy Support
    Wait Until Page Contains Element    ${_PRIVACY_POLICY_LOCATOR}
    Click Element    ${_PRIVACY_POLICY_LOCATOR}

Click On Terms Of Use Support
    Wait Until Page Contains Element    ${_TERMS_OF_USE_LOCATOR}
    Click Element    ${_TERMS_OF_USE_LOCATOR}

Click On Call Customer Support
    Wait Until Page Contains Element    ${_CALL_SUPPORT_LOCATOR}
    Click Element    ${_CALL_SUPPORT_LOCATOR}

Click On Log Out Button
    Wait Until Page Contains Element    ${_LOG_OUT_BTN_LOCATOR}
    Click Element    ${_LOG_OUT_BTN_LOCATOR}
    Wait Activity    ${LOGIN_ACTIVITY}    10