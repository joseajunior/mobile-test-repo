*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_ALLOW_BTN}           xpath=//XCUIElementTypeAlert[@name="“DriverDash” Would Like to Send You Notifications"]//XCUIElementTypeButton[@name="Allow"]
${_DONT_ALLOW_BTN}      xpath=//XCUIElementTypeAlert[@name="“DriverDash” Would Like to Send You Notifications"]//XCUIElementTypeButton[@name="Don't Allow"]
${_face_id_cancel}      xpath=//XCUIElementTypeAlert[@name="Turn on Face ID in settings"]//XCUIElementTypeButton[@name="Cancel"]
${_face_id_settings}    xpath=//XCUIElementTypeAlert[@name="Turn on Face ID in settings"]//XCUIElementTypeButton[@name="SETTINGS"]

*** Keywords ***
Click On Allow Button
    Wait Until Element Is Visible    ${_ALLOW_BTN}
    Click Element    ${_ALLOW_BTN}

Click On Don't Allow Button
    Wait Until Element Is Visible    ${_DONT_ALLOW_BTN}
    Click Element    ${_DONT_ALLOW_BTN}

Click On Face ID Cancel Button
    Wait Until Element Is Visible    ${_face_id_cancel}
    Click Element    ${_face_id_cancel}

Click On Face ID Settings Button
    Wait Until Element Is Visible    ${_face_id_settings}
    Click Element    ${_face_id_settings}
