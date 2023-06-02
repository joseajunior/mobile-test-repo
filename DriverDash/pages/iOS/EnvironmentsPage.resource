*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_north_america_region}       chain=**/XCUIElementTypeButton[`label == "North America"`]
${_europe_region}              chain=**/XCUIElementTypeButton[`label == "Europe"`]
${_unknown_region}             chain=**/XCUIElementTypeButton[`label == "Unknown"`]
${_sit_environment}            chain=**/XCUIElementTypeButton[`label == "sit"`]
${_staging_environment}        chain=**/XCUIElementTypeButton[`label == "staging"`]
${_production_environment}     chain=**/XCUIElementTypeButton[`label == "production"`]
${_local_environment}          chain=**/XCUIElementTypeButton[`label == "local"`]
${_start_btn}                  chain=**/XCUIElementTypeButton[`label == "Start"`]

*** Keywords ***
Select "${region}" Region
    TRY
        Wait Until Page Contains Element    ${_${region.replace(' ', '_').lower()}_region}
        Click Element    ${_${region.replace(' ', '_').lower()}_region}
    EXCEPT    message
        Fail    Not a valid region. Acceptable are: North America, Europe or Unknown
    END

Select "${env}" Environment
    TRY
        Wait Until Page Contains Element    ${_${env.replace(' ', '_').lower()}_environment}
        Click Element    ${_${env.replace(' ', '_').lower()}_environment}
        Click On Start Button For The Environment Screen
    EXCEPT    message
        Fail    Not a valid environment
    END

Click On Start Button For The Environment Screen
    Wait Until Page Contains Element    ${_START_BTN}
    Click Element    ${_START_BTN}

Select "${region}" Region And "${env}"
    Select "${region}" Region
    Select "${env}" Environment
    # Click On Start Button For The Environment Screen
    