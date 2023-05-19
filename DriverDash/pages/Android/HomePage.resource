*** Settings ***
Library     AppiumLibrary
Resource    ${CURDIR}${/}HomeBaseLocators.Resource

*** Variables ***
${_SAFETY_MESSAGE_OK}    id=android:id/button1
${_ADD_CARD}    id=com.wex.fleet.driverdash.stage:id/addCardTextButton
${_CARD_IMAGE}    id=com.wex.fleet.driverdash.stage:id/card_image
${_LAST_FIVE_DIGITS}    id=com.wex.fleet.driverdash.stage:id/last_five_digits
${_NICKNAME_FIELD}    id=com.wex.fleet.driverdash.stage:id/nickname_text_view
${_CARD_OWNER}    id=com.wex.fleet.driverdash.stage:id/emboss_line_one
${_CARD_COMPANY_OWNER}    id=com.wex.fleet.driverdash.stage:id/emboss_line_two
${_PAY_FOR_FUEL_BTN}    id=com.wex.fleet.driverdash.stage:id/home_button_pay_for_fuel
${_DRIVER_NAME}    id=com.wex.fleet.driverdash.stage:id/driver_name
${_DRIVER_COMPANY}    id=com.wex.fleet.driverdash.stage:id/driver_company
${_DRIVER_ICON}    id=com.wex.fleet.driverdash.stage:id/driver_icon_image
${_add_card_recently_home_page}    id=com.wex.fleet.driverdash.stage:id/addRecentsButton
${_add_card_manually_home_page}    id=com.wex.fleet.driverdash.stage:id/addManualButton
${0x}    ${None}
${0y}    ${None}
${fx}    ${None}
${fy}    ${None}

*** Keywords ***
Click On Add Card Button From Home Page
    Wait Until Page Contains Element    ${_ADD_CARD}
    Click Element    ${_ADD_CARD}

Add "${nickname}" As Nickname For Card
    Wait Until Page Contains Element    ${_ADD_CARD}
    Input Text    ${_NICKNAME_FIELD}    ${nickname}

Click On Pay For Fuel Button
    Wait Until Page Contains Element    ${_PAY_FOR_FUEL_BTN}
    Click Element    ${_PAY_FOR_FUEL_BTN}

Get Card's Last Five Digits
    Wait Until Page Contains Element    ${_LAST_FIVE_DIGITS}
    ${card_number}    Get Text    ${_LAST_FIVE_DIGITS}
    [Return]    ${card_number[-5:]}

Get Card's Owner
    Wait Until Page Contains Element    ${_CARD_OWNER}
    ${card_owner}    Get Text    ${_CARD_OWNER}
    [Return]    ${card_owner}

Get Card's Company Owner
    Wait Until Page Contains Element    ${_CARD_COMPANY_OWNER}
    ${card_company_owner}    Get Text    ${_CARD_COMPANY_OWNER}
    [Return]    ${card_company_owner}

Swipe Card To The Right
    IF    ${0x}==${None}
        ${0x}    ${0y}    ${fx}    ${fy}    __Get Element Bounds    ${_CARD_IMAGE}
        ${my}    Evaluate    (${0y}+${fy})/2
        Set Suite Variable    ${0x}
        Set Suite Variable    ${fx}
        Set Suite Variable    ${my}
    END
    Swipe    ${fx}    ${my}    ${0x}    ${my}

Swipe Card To The Left
    IF    ${0x}==${None}
        ${0x}    ${0y}    ${fx}    ${fy}    __Get Element Bounds    ${_CARD_IMAGE}
        ${my}    Evaluate    (${0y}+${fy})/2
        Set Suite Variable    ${0x}
        Set Suite Variable    ${fx}
        Set Suite Variable    ${my}
    END
    Swipe    ${0x}    ${my}    ${fx}    ${my}

Click On Ok On Popup
    Sleep    3s
    Wait Until Element Is Visible    ${_SAFETY_MESSAGE_OK}
    Click Element    ${_SAFETY_MESSAGE_OK}

Get Driver's Name
    Wait Until Element Is Visible    ${_DRIVER_NAME}
    ${name}    Get Text    ${_DRIVER_NAME}
    [Return]    ${name}

Get Driver's Company
    Wait Until Element Is Visible    ${_DRIVER_COMPANY}
    ${company}    Get Text    ${_DRIVER_COMPANY}
    [Return]    ${company}

Click On Add Manually Card Button From Home Page
    Wait Until Page Contains Element    ${_add_card_manually_home_page}
    Click Element    ${_add_card_manually_home_page}

Click On Add Recent Used Cards From Home Page
    Wait Until Page Contains Element    ${_add_card_recently_home_page}
    Click Element    ${_add_card_recently_home_page}

__Get Element Bounds
    [Arguments]    ${element}
    ${loc}    Get Element Attribute    ${element}    bounds
    @{l}    Set Variable    ${loc.replace('[', '').replace(']', ',').strip(',').split(',')}
    ${0x}    ${0y}    ${fx}    ${fy}    Set Variable    ${loc.replace('[', '').replace(']', ',').strip(',').split(',')}
    [Return]    ${0x}    ${0y}    ${fx}    ${fy}