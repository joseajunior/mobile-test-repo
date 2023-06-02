*** Settings ***
Library    WexRobotLib.MobileLibrary

*** Variables ***
${_enter_driver_id_title}        id=com.wex.fleet.driverdash.stage:id/textViewDriverId
${_driver_id_input}              id=com.wex.fleet.driverdash.stage:id/driver_id_edit_text
${_next_button_driver_id}        id=com.wex.fleet.driverdash.stage:id/buttonSubmit
${_having_trouble_driver_id}     id=com.wex.fleet.driverdash.stage:id/login_phone_button_trouble
${_navigate_up_driver_id}        xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/login_toolbar"]/android.widget.ImageButton[@content-desc="Navigate up"]

*** Keywords ***
Input "${driverId}" As Driver ID
    Wait Until Element Is Visible    ${_driver_id_input}
    Clear Text    ${_driver_id_input}
    Input Text    ${_driver_id_input}    ${driverId}
    Click Element    ${_enter_driver_id_title}

Click On Next Button On Driver Id Page
    Wait Until Element Is Visible    ${_next_button_driver_id}
    Click Element    ${_next_button_driver_id}
    Wait Until Page Does Not Contain Element    ${_driver_id_input}