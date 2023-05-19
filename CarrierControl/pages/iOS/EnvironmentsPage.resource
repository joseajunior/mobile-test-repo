*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_DIT_ENVIRONMENT}    xpath=//XCUIElementTypeButton[@name="DIT"]
${_TEST_ENVIRONMENT}    xpath=//XCUIElementTypeButton[@name="Test"]
${_DEV_ENVIRONMENT}    xpath=//XCUIElementTypeButton[@name="Development"]
${_SIT_ENVIRONMENT}    xpath=//XCUIElementTypeButton[@name="AWS-SIT"]
${_DIT_AWS_ENVIRONMENT}    xpath=//XCUIElementTypeButton[@name="AWS-DIT"]
${_PARTNER_ENVIRONMENT}    xpath=//XCUIElementTypeButton[@name="Partner"]
${_PRODUCTION_ENVIRONMENT}    xpath=//XCUIElementTypeButton[@name="Production"]
${_START_BTN}    xpath=//XCUIElementTypeButton[@name="Start Button"]

*** Keywords ***
Select "${env}" Environment
    TRY
        Wait Until Page Contains Element    id=${_${env.replace(' ', '_').upper()}_ENVIRONMENT}
        Click Element    id=${_${env.replace(' ', '_').upper()}_ENVIRONMENT}
        Click Element    ${_START_BTN}
    EXCEPT    message
        Fail    Not a valid environment
    END