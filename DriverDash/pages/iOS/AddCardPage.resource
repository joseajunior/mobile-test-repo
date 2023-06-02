*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_navigate_up_add_card}    xpath=//XCUIElementTypeNavigationBar[@name="Add card"]/XCUIElementTypeButton
${_five_digits_entry}       xpath=//XCUIElementTypeTextField[@name="CardNumberTextField"]
${_add_card_button}         xpath=//XCUIElementTypeButton[@name="SubmitAddCardButton"]

*** Keywords ***
Enter "${digits}" As The Five Digits Of The Card
    Wait Until Element Is Visible    ${_five_digits_entry}
    Clear Text    ${_five_digits_entry}
    Input Text    ${_five_digits_entry}    ${digits}

Click On Add Card Button
    Wait Until Element Is Visible    ${_add_card_button}
    Click Element    ${_add_card_button}
    Wait Until Page Does Not Contain Element    ${_add_card_button}