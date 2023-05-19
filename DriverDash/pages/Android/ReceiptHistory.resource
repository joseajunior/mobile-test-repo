*** Settings ***
Library    AppiumLibrary

*** Variables ***
${_receipt_history_title}          xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/receipt_history_toolbar"]//android.widget.TextView[@text='Receipt History']
${_navigate_up_receipt_history}    xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/receipt_history_toolbar"]//android.widget.ImageButton[@content-desc='Navigate up']

*** Keywords ***
Navigate Up To More Page From Receipt History Page
    Wait Until Page Contains Element    ${_navigate_up_receipt_history}
    Click Element    ${_navigate_up_receipt_history}
    Wait Until Page Does Not Contain Element    ${_receipt_history_title}
