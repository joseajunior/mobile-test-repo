*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_my_cards_title}          xpath=//XCUIElementTypeNavigationBar[@name="Remove a card"]//XCUIElementTypeStaticText[@name="Remove a card"]
${_navigate_up_my_cards}    xpath=//XCUIElementTypeNavigationBar[@name="Remove a card"]//XCUIElementTypeButton[@name="More"]
${_add_card_btn}            xpath=//XCUIElementTypeNavigationBar[@name="Remove a card"]//XCUIElementTypeButton[@name="Add"]
${_delete_card_btn}         xpath=//XCUIElementTypeButton[@name="Delete"]
${_add_card_recently_my_cards}    xpath=//XCUIElementTypeButton[@name="Add recently used cards"]
${_add_card_manually_my_cards}    xpath=//XCUIElementTypeButton[@name="Enter manually"]

*** Keywords ***
Close My Cards Page
    Wait Until Page Contains Element    ${_navigate_up_my_cards}
    Click Element    ${_navigate_up_my_cards}
    Wait Until Page Does Not Contain Element    ${_my_cards_title}

Click On Add Card Button From My Cards
    Wait Until Page Contains Element    ${_add_card_btn}
    Click Element    ${_add_card_btn}

Click On Add Manually Card Button From My Cards
    Wait Until Page Contains Element    ${_add_card_manually_my_cards}
    Click Element    ${_add_card_manually_my_cards}

Click On Add Recent Used Cards From My Cards
    Wait Until Page Contains Element    ${_add_card_recently_my_cards}
    Click Element    ${_add_card_recently_my_cards}

Remove The Card With "${digits}" As The Five Digits
    ${card}    Set Variable    nsp=type=="XCUIElementTypeButton" AND name ENDSWITH "${digits}"
    Wait Until Page Contains Element    ${card}
    Click Element    ${card}
    Click Element    ${_delete_card_btn}
    Wait Until Page Does Not Contain Element    ${card}
