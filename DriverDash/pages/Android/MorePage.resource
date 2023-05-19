*** Settings ***
Library     AppiumLibrary
Resource    ${CURDIR}${/}HomeBaseLocators.resource

*** Variables ***
${_more_recipt_history}               id=com.wex.fleet.driverdash.stage:id/more_receipt_history_text
${_more_transaction_alerts}           id=com.wex.fleet.driverdash.stage:id/more_transaction_alerts_switch
${_more_fingerprint_auth}             id=com.wex.fleet.driverdash.stage:id/more_biometric_switch
${_more_carwash_history}              id=com.wex.fleet.driverdash.stage:id/more_carwash_switch
${_more_my_cards}                     id=com.wex.fleet.driverdash.stage:id/more_remove_card
${_more_call_customer_service}        id=com.wex.fleet.driverdash.stage:id/more_call_customer_service_text
${_more_terms_of_use}                 id=com.wex.fleet.driverdash.stage:id/more_terms_button_text
${_more_privacy_policy}               id=com.wex.fleet.driverdash.stage:id/more_privacy_button_text
${_more_log_out}                      id=com.wex.fleet.driverdash.stage:id/more_logout_button_text
${_more_confirm_log_out}              xpath=//android.widget.LinearLayout[@resource-id="android:id/parentPanel"]//android.widget.Button[@text="LOG OUT"]
${_more_cancel_log_out}               xpath=//android.widget.LinearLayout[@resource-id="android:id/parentPanel"]//android.widget.Button[@text="CANCEL"]

*** Keywords ***
Click On Receipt History
    # Scroll Up    ${_more_recipt_history}
    Click Element    ${_more_recipt_history}

Get Transaction Alerts Status
    Wait Until Element Is Visible    ${_more_transaction_alerts}
    ${status}    Get Element Attribute    ${_more_transaction_alerts}    checked
    IF    '${status.lower()}'=='true'
        ${status}    Set Variable    ${True}
    ELSE
        ${status}    Set Variable    ${False}
    END
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

Get Fingerprint Authentication Status
    Wait Until Element Is Visible    ${_more_fingerprint_auth}
    ${status}    Get Element Attribute    ${_more_fingerprint_auth}    checked
    IF    '${status.lower()}'=='true'
        ${status}    Set Variable    ${True}
    ELSE
        ${status}    Set Variable    ${False}
    END
    [Return]    ${status}

Enable Fingerprint Authentication
    # Scroll Up    ${_more_fingerprint_auth}
    ${status}    Get Fingerprint Authentication Status
    IF    not ${status}
        Click Element    ${_more_fingerprint_auth}
    END

Disable Fingerprint Authentication
    # Scroll Up    ${_more_fingerprint_auth}
    ${status}    Get Fingerprint Authentication Status
    IF    ${status}
        Click Element    ${_more_fingerprint_auth}
    END

Get Carwash Prompts Status
    Wait Until Element Is Visible    ${_more_carwash_history}
    ${status}    Get Element Attribute    ${_more_carwash_history}    checked
    IF    '${status.lower()}'=='true'
        ${status}    Set Variable    ${True}
    ELSE
        ${status}    Set Variable    ${False}
    END
    [Return]    ${status}

Enable Carwash Prompts
    # Scroll Up    ${_more_carwash_history}
    ${status}    Get Carwash Prompts Status
    IF    not ${status}
        Click Element    ${_more_carwash_history}
    END

Disable Carwash Prompts
    # Scroll Up    ${_more_carwash_history}
    ${status}    Get Carwash Prompts Status
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
    Scroll    ${_more_recipt_history}    ${_more_terms_of_use}
    Click Element    ${_more_terms_of_use}

Click On Privacy Policy
    # Scroll    ${_more_recipt_history}    ${_more_privacy_policy}
    Click Element    ${_more_privacy_policy}

Click On Log Out
    Scroll    ${_more_recipt_history}    ${_more_log_out}
    Click Element    ${_more_log_out}

Confirm Log Out
    Wait Until Element Is Visible    ${_more_confirm_log_out}
    Click Element    ${_more_confirm_log_out}

Cancel Log Out
    Wait Until Element Is Visible    ${_more_cancel_log_out}
    Click Element    ${_more_cancel_log_out}