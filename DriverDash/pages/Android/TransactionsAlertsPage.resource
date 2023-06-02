*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_TURN_ON_BTN_LOCATOR}    id=com.wex.fleet.driverdash.stage:id/notifications_turn_on_button
${_MAYBE_LATER_LOCATOR}    id=com.wex.fleet.driverdash.stage:id/notifications_maybe_later_button

*** Keywords ***
Click On Turn On Now Button
    Wait Until Element Is Visible    ${_TURN_ON_BTN_LOCATOR}    timeout=20
    Click Element    ${_TURN_ON_BTN_LOCATOR}
    Wait Until Page Does Not Contain Element    ${_TURN_ON_BTN_LOCATOR}    timeout=20

Click On Maybe Later Button
    Wait Until Element Is Visible    ${_MAYBE_LATER_LOCATOR}    timeout=20
    Click Element    ${_MAYBE_LATER_LOCATOR}
    Wait Until Page Does Not Contain Element    ${_MAYBE_LATER_LOCATOR}    timeout=20

Skip The Alert Page
    Click On Turn On Now Button