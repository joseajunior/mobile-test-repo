*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_NAVIGATE_UP_LOCATOR}    chain=**/XCUIElementTypeButton[`label == "person.circle"`]
${_RECURRING_CASH_AMOUNT_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/recurring_cash_amount
${_ONE_TIME_CASH__AMOUNT_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/one_time_cash_amount
${_REGISTER_CHECK_LOCATOR}    chain=**/XCUIElementTypeButton[`label == "Register Check"`]
${_FUEL_CHECK-IN_LOCATOR}    chain=**/XCUIElementTypeButton[`label == ", Fuel Check-in"`]
${_HOME_TAB_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/home_navigation
${_TRANSACTIONS_TAB_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/transactions_navigation
${_FIND_FUEL_TAB_LOCATOR}    id=com.efsllc.efsmobileapp.stage:id/plan_route_navigation

*** Keywords ***
Open Account Page
    Wait Until Page Contains Element    ${_NAVIGATE_UP_LOCATOR}
    Click Element    ${_NAVIGATE_UP_LOCATOR}

Click On Register Check Button
    Wait Until Page Contains Element    ${_REGISTER_CHECK_LOCATOR}
    Click Element    ${_REGISTER_CHECK_LOCATOR}

Click On One Time Cash Amount
    Wait Until Page Contains Element    ${_ONE_TIME_CASH__AMOUNT_LOCATOR}
    Click Element    ${_ONE_TIME_CASH__AMOUNT_LOCATOR}
