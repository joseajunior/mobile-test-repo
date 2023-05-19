*** Settings ***
Library     AppiumLibrary
Resource    HomeBaseLocators.resource

*** Variables ***
${_more_recipt_history}               chain=**/XCUIElementTypeStaticText[`label == "Receipt history"`]
${_more_transaction_alerts}           xpath=//XCUIElementTypeStaticText[@label="Notification alerts"]/following-sibling::XCUIElementTypeSwitch[@name="BiometricSwitch"]
${_more_face_id_to_login}             xpath=//XCUIElementTypeStaticText[@label="Face ID to login"]/following-sibling::XCUIElementTypeSwitch[@name="BiometricSwitch"]
${_more_face_id_to_pay}               xpath=//XCUIElementTypeStaticText[@label="Face ID to pay"]/following-sibling::XCUIElementTypeSwitch[@name="BiometricSwitch"]
${_more_carwash_history}              xpath=//XCUIElementTypeStaticText[@label="Show carwash prompts"]/following-sibling::XCUIElementTypeSwitch[@name="BiometricSwitch"]
${_more_my_cards}                     chain=**/XCUIElementTypeStaticText[`label == "Remove a card"`]
${_more_call_customer_service}        chain=**/XCUIElementTypeStaticText[`label == "Call customer service"`]
${_more_terms_of_use}                 chain=**/XCUIElementTypeStaticText[`label == "Terms of Use"`]
${_more_privacy_policy}               chain=**/XCUIElementTypeStaticText[`label == "Privacy Policy"`]
${_more_licenses}                     chain=**/XCUIElementTypeStaticText[`label == "Licenses"`]
${_more_log_out}                      chain=**/XCUIElementTypeStaticText[`label == "Log out"`]
${_more_confirm_log_out}              xpath=//XCUIElementTypeAlert[@name="Are you sure?"]//XCUIElementTypeButton[@name="Log out"]
${_more_cancel_log_out}               xpath=//XCUIElementTypeAlert[@name="Are you sure?"]//XCUIElementTypeButton[@name="Cancel"]

*** Keywords ***
Click On Receipt History
    # Scroll Up    ${_recipt_history}
    Click Element    ${_more_recipt_history}

Get Transaction Alerts Status
    Wait Until Element Is Visible    ${_more_transaction_alerts}
    ${status}    Get Element Attribute    ${_more_transaction_alerts}    value
    IF    ${status}==1
        ${status}    Set Variable    ${True}
    ELSE
        ${status}    Set Variable    ${False}
    END
    Log To Console    Value: ${status}
    [Return]    ${status}

Enable Transaction Alerts
    # Scroll Up    ${_more_transaction_alerts}
    ${status}    Get Transaction Alerts Status
    IF    not ${status}
        Click Element    ${_more_transaction_alerts}
    END

Disable Transaction Alerts
    # Scroll Up    ${_more_transaction_alerts}
    ${status}    Get Transaction Alerts Status
    IF    ${status}
        Click Element    ${_more_transaction_alerts}
    END

Get Face ID To Login Status
    Wait Until Element Is Visible    ${_more_face_id_to_login}
    ${status}    Get Element Attribute    ${_more_face_id_to_login}    value
    IF    ${status}==1
        ${status}    Set Variable    ${True}
    ELSE
        ${status}    Set Variable    ${False}
    END
    Log To Console    Value: ${status}
    [Return]    ${status}

Enable Face ID To Login Authentication
    ${status}    Get Element Attribute    ${_more_face_id_to_login}    value
    IF    not ${status}
        Click Element    ${_more_face_id_to_login}
    END

Disable Face ID To Login Authentication
    ${status}    Get Element Attribute    ${_more_face_id_to_login}    value
    IF    ${status}
        Click Element    ${_more_face_id_to_login}
    END

Get Face ID To Pay Status
    Wait Until Element Is Visible    ${_more_face_id_to_pay}
    ${status}    Get Element Attribute    ${_more_face_id_to_pay}    value
    IF    ${status}==1
        ${status}    Set Variable    ${True}
    ELSE
        ${status}    Set Variable    ${False}
    END
    Log To Console    Value: ${status}
    [Return]    ${status}

Enable Face ID To Pay
    ${status}    Get Element Attribute    ${_more_face_id_to_pay}    value
    IF    not ${status}
        Click Element    ${_more_face_id_to_pay}
    END

Disable Face ID To Pay
    ${status}    Get Element Attribute    ${_more_face_id_to_pay}    value
    IF    ${status}
        Click Element    ${_more_face_id_to_pay}
    END

Get Carwash Prompts Status
    Wait Until Element Is Visible    ${_more_carwash_history}
    ${status}    Get Element Attribute    ${_more_carwash_history}    value
    IF    ${status}==1
        ${status}    Set Variable    ${True}
    ELSE
        ${status}    Set Variable    ${False}
    END
    Log To Console    Value: ${status}
    [Return]    ${status}

Enable Carwash Prompts
    # Scroll Up    ${_more_carwash_history}
    ${status}    Get Element Attribute    ${_more_carwash_history}    checked
    IF    not ${status}
        Click Element    ${_more_carwash_history}
    END

Disable Carwash Prompts
    # Scroll Up    ${_more_carwash_history}
    ${status}    Get Element Attribute    ${_more_carwash_history}    checked
    IF    ${status}
        Click Element    ${_more_carwash_history}
    END

Click On My Cards
    Wait Until Element Is Visible    ${_more_my_cards}
    Click Element    ${_more_my_cards}

Click On Call Customer Service
    Scroll Down      ${_more_call_customer_service}
    Click Element    ${_more_call_customer_service}

Click On Terms Of Use
    Scroll    ${_more_terms_of_use}    ${_more_recipt_history}
    Click Element    ${_more_terms_of_use}

Click On Privacy Policy
    Scroll    ${_more_privacy_policy}    ${_more_recipt_history}
    Click Element    ${_more_privacy_policy}

Click On Licenses
    Scroll    ${_more_licenses}    ${_more_recipt_history}
    Click Element    ${_more_licenses}

Click On Log Out
    Scroll    ${_more_log_out}    ${_more_recipt_history}    
    Click Element    ${_more_log_out}

Confirm Log Out
    Wait Until Element Is Visible    ${_more_confirm_log_out}
    Click Element    ${_more_confirm_log_out}

Cancel Log Out
    Wait Until Element Is Visible    ${_more_cancel_log_out}
    Click Element    ${_more_cancel_log_out}