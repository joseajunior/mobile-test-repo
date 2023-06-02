*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_enter_phone_title}                 xpath=//XCUIElementTypeStaticText[@name="EnterPhoneNumberLabel"]
${_phone_number_login}                xpath=//XCUIElementTypeTextField[@name="EnteredPhoneNumberField"]
${_next_phone_enter_phone_btn}        xpath=//XCUIElementTypeButton[@name="NextButton"]
${_having_trouble_enter_phone}        xpath=//XCUIElementTypeButton[@name="HavingTroubleButton"]

*** Keywords ***
Input "${phone_number}" As Phone Number
    Wait Until Element Is Visible    ${_phone_number_login}    timeout=10
    Clear Text    ${_phone_number_login}
    Input Text    ${_phone_number_login}    ${phone_number}
    # Click Element    ${_enter_phone_title}

Click On Next Button For Phone Login
    Wait Until Element Is Visible    ${_next_phone_enter_phone_btn}    timeout=10
    Click Element    ${_next_phone_enter_phone_btn}
    Wait Until Page Does Not Contain Element    ${_phone_number_login}    timeout=20