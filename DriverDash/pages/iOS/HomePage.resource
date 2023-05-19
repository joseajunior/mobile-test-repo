*** Settings ***
Library    AppiumLibrary
Resource    ${CURDIR}${/}HomeBaseLocators.resource

*** Variables ***
${_SAFETY_MESSAGE_OK}    chain=**/XCUIElementTypeAlert[`label == "Safety message"`]/**/XCUIElementTypeButton[`label == "OK"`]
${_ADD_CARD}             chain=**/XCUIElementTypeButton[`label == "add"`]
${_CARD_IMAGE}           chain=**/XCUIElementTypeCollectionView/**/XCUIElementTypeImage
${_CARD_DATA}            chain=**/XCUIElementTypeCollectionView/**/XCUIElementTypeStaticText
${_NICKNAME_FIELD}       xpath=//XCUIElementTypeImage[@name="cardDark"]/parent/XCUIElementTypeTextField
${_PAY_FOR_FUEL_BTN}     chain=**/XCUIElementTypeButton[`label == "Pay for fuel"`]
${_DRIVER_NAME}          xpath=//XCUIElementTypeStaticText[@name="UserIdentificationIdentifier"]
${_DRIVER_COMPANY}       xpath=//XCUIElementTypeStaticText[@name="CompanyNameIdentifier"]
${_DRIVER_ICON}          chain=**/XCUIElementTypeImage[`name == "UserIconIdentifier"`]
${_add_card_recently_home_page}    chain=**/XCUIElementTypeButton[`label == "Add recently used cards"`]
${_add_card_manually_home_page}    chain=**/XCUIElementTypeButton[`label == "Enter manually"`]

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
    __Get Card Data
    [Return]    ${_LAST_FIVE_DIGITS}

Get Card's Owner
    __Get Card Data
    [Return]    ${_CARD_OWNER}

Get Card's Company Owner
    __Get Card Data
    [Return]    ${_CARD_COMPANY_OWNER}

Swipe Card To The Right
    ${0x}    ${0y}    ${fx}    ${fy}    __Get Element Bounds    ${_CARD_IMAGE}
    ${my}    Evaluate    (${0y}+${fy})/2
    Swipe    ${fx}    ${my}    ${0x}    ${my}

Swipe Card To The Left
    ${0x}    ${0y}    ${fx}    ${fy}    __Get Element Bounds    ${_CARD_IMAGE}
    ${my}    Evaluate    (${0y}+${fy})/2
    Swipe    ${0x}    ${my}    ${fx}    ${my}

Click On Ok On Popup
    Wait Until Element Is Visible    ${_SAFETY_MESSAGE_OK}
    Run Keyword And Ignore Error    Click Element    ${_SAFETY_MESSAGE_OK}

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
    ${xy}    Get Element Location    ${element}
    ${fxy}    Get Element Size    ${element}
    ${fx}    Evaluate    ${xy['x']}+${fxy['width']}
    ${fy}    Evaluate    ${xy['y']}+${fxy['height']}
    [Return]    ${xy['x']}    ${xy['y']}    ${fx}    ${fy}

__Get Card Data
    Wait Until Element Is Visible    ${_CARD_IMAGE}
    ${data}    Get Webelements    ${_CARD_DATA}  #This should get 3 elements: censured card digits, las five digits, card's owner and company names
    ${_LAST_FIVE_DIGITS}    Get Text    ${data[-1]}
    Set Suite Variable    ${_LAST_FIVE_DIGITS}
    ${names}    Get Text    ${data[0]}
    ${_CARD_OWNER}    Evaluate    ' '.join(${names.split()[0:2]})
    Set Suite Variable    ${_CARD_OWNER}
    ${_CARD_COMPANY_OWNER}    Evaluate    ' '.join(${names.split()[2:]})
    Set Suite Variable    ${_CARD_COMPANY_OWNER}