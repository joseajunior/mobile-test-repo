*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_continue_earning_rewards}       id=com.wex.fleet.driverdash.stage:id/loyalty_onboarding_continue
${_maybe_later_earning_rewards}    id=com.wex.fleet.driverdash.stage:id/loyalty_onboarding_later

*** Keywords ***
Click On Continue Button On Earning Rewards Page
    Wait Until Element Is Visible    ${_continue_earning_rewards}
    Click Element    ${_continue_earning_rewards}
    Wait Until Page Does Not Contain Element    ${_continue_earning_rewards}

Click On Maybe Later Button On Earning Rewards Page
    Wait Until Element Is Visible    ${_maybe_later_earning_rewards}
    Click Element    ${_maybe_later_earning_rewards}
    Wait Until Page Does Not Contain Element    ${_maybe_later_earning_rewards}

Skip Earning Rewards Page
    Click On Maybe Later Button On Earning Rewards Page

