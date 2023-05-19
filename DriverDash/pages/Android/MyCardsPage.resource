*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_my_cards_title}                xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/more_remove_card_toolbar"]/android.widget.TextView[@text="My Cards"]
${_navigate_up_my_cards}          xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/more_remove_card_toolbar"]/android.widget.ImageButton[@content-desc="Navigate up"]
${_add_card_btn}                  xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/more_remove_card_toolbar"]/android.widget.ImageView[@resource-id="com.wex.fleet.driverdash.stage:id/add_cards_imageview"]
${_confirm_remove_card}           xpath=//androidx.appcompat.widget.LinearLayoutCompat[@resource-id="com.wex.fleet.driverdash.stage:id/parentPanel"]//android.widget.Button[@resource-id="android:id/button1"]
${_cancel_remove_card}            xpath=//androidx.appcompat.widget.LinearLayoutCompat[@resource-id="com.wex.fleet.driverdash.stage:id/parentPanel"]//android.widget.Button[@resource-id="android:id/button2"]
${_add_card_recently_my_cards}    id=com.wex.fleet.driverdash.stage:id/addRecentsButton
${_add_card_manually_my_cards}    id=com.wex.fleet.driverdash.stage:id/addManualButton
${_card_removed_successfully}     xpath=//android.widget.TextView[@resource-id="com.wex.fleet.driverdash.stage:id/snackbar_text" and @text="Card Removed"]

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
    ${card}    Set Variable    xpath=//android.widget.TextView[@resource-id="com.wex.fleet.driverdash.stage:id/vh_remove_card_card_number" and contains(@text, "${digits}")]
    Wait Until Page Contains Element    ${card}
    Click Element    ${card}

Confirm Remove Card
    Wait Until Page Contains Element    ${_confirm_remove_card}
    Click Element    ${_confirm_remove_card}
    Wait Until Element Is Visible    ${_card_removed_successfully}

Cancel Remove Card
    Wait Until Page Contains Element    ${_cancel_remove_card}
    Click Element    ${_cancel_remove_card}

