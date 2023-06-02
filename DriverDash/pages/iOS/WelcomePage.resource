*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_GET_STARTED_BUTTON}    chain=**/XCUIElementTypeButton[`label == "Get started"`]

*** Keywords ***
Click On Get Started Button
    Wait Until Page Contains Element    ${_GET_STARTED_BUTTON}
    Click Element    ${_GET_STARTED_BUTTON}