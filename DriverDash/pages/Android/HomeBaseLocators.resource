*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_home_tab}    id=com.wex.fleet.driverdash.stage:id/home_navigation
${_find_stations_tab}    id=com.wex.fleet.driverdash.stage:id/find_site_navigation
${_rewards_tab}    id=com.wex.fleet.driverdash.stage:id/rewards_navigation
${_more_tab}    id=com.wex.fleet.driverdash.stage:id/more_navigation

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
