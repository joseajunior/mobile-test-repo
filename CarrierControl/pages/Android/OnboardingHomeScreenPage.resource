*** Settings ***
Library    WexRobotLib.MobileLibrary
Resource    Activities.resource

*** Variables ***
${_CONTINUE_BTN_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/onboarding_continue_button

*** Keywords ***
Click On Continue Button
    Wait Until Page Contains Element    ${_CONTINUE_BTN_LOCATOR}
    Click Element    ${_CONTINUE_BTN_LOCATOR}
