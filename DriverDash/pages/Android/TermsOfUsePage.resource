*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_terms_of_use_title}                xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/more_terms_toolbar"]/android.widget.TextView[@text="Terms of Use"]
${_navigate_up_terms_of_use}    xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/more_terms_toolbar"]/android.widget.ImageButton[@content-desc="Navigate up"]

*** Keywords ***
Close Terms of Use Page
    Wait Until Element Is Visible    ${_navigate_up_terms_of_use}    timeout=10
    Click Element    ${_navigate_up_terms_of_use}
    Wait Until Page Does Not Contain Element    ${_terms_of_use_title}    timeout=10

