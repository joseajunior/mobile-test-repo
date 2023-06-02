*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_home_tab}             chain=**/XCUIElementTypeButton[`label == "Wallet"`]
${_find_stations_tab}    chain=**/XCUIElementTypeButton[`label == "Find stations"`]
${_rewards_tab}          chain=**/XCUIElementTypeButton[`label == "Rewards"`]
${_more_tab}             chain=**/XCUIElementTypeButton[`label == "More"`]

*** Keywords ***
Click On Wallet Tab
    Wait Until Page Contains Element    ${_HOME_TAB}
    Click Element    ${_HOME_TAB}

Click On Find Stations Tab
    Wait Until Page Contains Element    ${_FIND_STATIONS_TAB}
    Click Element    ${_FIND_STATIONS_TAB}

Click On Rewards Tab
    Wait Until Page Contains Element    ${_REWARDS_TAB}
    Click Element    ${_REWARDS_TAB}

Click On More Tab
    Wait Until Page Contains Element    ${_MORE_TAB}
    Click Element    ${_MORE_TAB}
