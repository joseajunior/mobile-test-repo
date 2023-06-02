*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_card_image_add_card}     id=com.wex.fleet.driverdash.stage:id/nonccn_card_image
${_navigate_up_add_card}    xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/add_card_toolbar"]/android.widget.ImageButton[@content-desc="Navigate up"]
${_five_digits_entry}       id=com.wex.fleet.driverdash.stage:id/add_card_card_number_text
${_add_card_button}         xpath=//android.widget.Button[@text="ADD CARD" and @resource-id="com.wex.fleet.driverdash.stage:id/add_card_button"]

*** Keywords ***
Enter "${digits}" As The Five Digits Of The Card
    Wait Until Element Is Visible    ${_five_digits_entry}
    Clear Text    ${_five_digits_entry}
    Input Text    ${_five_digits_entry}    ${digits}
    Hide Keyboard
    Click Element    ${_card_image_add_card}

Click On Add Card Button From Add Card Screen
    Wait Until Element Is Visible    ${_add_card_button}
    Click Element    ${_add_card_button}
    Wait Until Page Does Not Contain Element    ${_add_card_button}