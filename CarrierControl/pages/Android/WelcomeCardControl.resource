*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_WINDOW_LOCATOR}             id=com.efsllc.efscarriercontrol.stage:id/tv_welcome_main
${_GET_STARTED_BUTTON}         id=com.efsllc.efscarriercontrol.stage:id/button_welcome

*** Keywords ***
Skip Welcome Page
    FOR    ${i}    IN RANGE    0    3
        Wait Until Element Is Visible    ${_WINDOW_LOCATOR}
        Swipe By Percent    90    50    10    50
    END
    Click Element    ${_GET_STARTED_BUTTON}
