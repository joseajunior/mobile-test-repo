*** Settings ***
Library     WexRobotLib.MobileLibrary

*** Variables ***
${_setup_rewards}                  xpath=//XCUIElementTypeButton[@name="SetupRewardsButton"]
${_maybe_later_earning_rewards}    xpath=//XCUIElementTypeButton[@name="MaybeLaterRewardsButton"]

*** Keywords ***
Click On Setup Rewards Button On Earning Rewards Page
    Wait Until Element Is Visible    ${_setup_rewards}
    Click Element    ${_setup_rewards}
    Wait Until Page Does Not Contain Element    ${_setup_rewards}

Click On Maybe Later Button On Earning Rewards Page
    Wait Until Element Is Visible    ${_maybe_later_earning_rewards}
    Click Element    ${_maybe_later_earning_rewards}
    Wait Until Page Does Not Contain Element    ${_maybe_later_earning_rewards}

Skip Earning Rewards Page
    Click On Maybe Later Button On Earning Rewards Page