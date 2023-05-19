*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_GET_STARTED_BUTTON}    id=com.wex.fleet.driverdash.stage:id/onboardingFragmentButtonContinue

*** Keywords ***
Click On Get Started Button
    Wait Until Page Contains Element    ${_GET_STARTED_BUTTON}
    Click Element    ${_GET_STARTED_BUTTON}