*** Settings ***
Library         AppiumLibrary
Variables       ${CURDIR}${/}..${/}..${/}..${/}Configuration${/}credentials.yml
Resource        ${CURDIR}${/}..${/}..${/}..${/}Configuration${/}Placeholder.resource
Resource        ${CURDIR}${/}..${/}..${/}..${/}Resources${/}DatabaseKeywords.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}WelcomePage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}LoginPage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}TransactionsAlertsPage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}HomePage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}EnvironmentsPage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}MorePage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}ReceiptHistory.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}MyCardsPage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}TermsOfUsePage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}PrivacyPolicyPage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}EnterPhonePage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}EnterPhoneCode.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}EnterDriverIdPage.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}EarningRewards.resource
Resource        ${CURDIR}${/}..${/}..${/}pages${/}${platformName}${/}AddCardPage.resource


*** Variables ***
${REMOTE_URL}                   https://${USERNAME}:${ACCESS_TOKEN}@mobile-hub.lambdatest.com/wd/hub
${TIMEOUT}                      3000
${platformName}                 Android
${local}                        ${False}

# Local Android
${HOST}                         http://127.0.0.1:4723/wd/hub
${ANDROID_AUTOMATION_NAME}      UIAutomator2
${ANDROID_APP_LOCAL}            ${CURDIR}${/}..${/}..${/}demoapp${/}DriverDash.apk
${ANDROID_PLATFORM_NAME}        Android
${ANDROID_PLATFORM_VERSION}     %{ANDROID_PLATFORM_VERSION=13}


*** Test Cases ***
E2E Test Case Login/More/Logout
    [Setup]    Open Driver Dash Application
    Click On Get Started Button
    Login On Driver Dash With "dbrxom.driver" Username and "Tester23" Password
    Run Keyword And Ignore Error    Click On Ok On Popup
    Click On More Tab
    Test Receipt History
    Check/Uncheck Fingerprint Authentication
    Test My Cards
    Test Terms Of Use
    Test Privacy Policy
    Log Out Of The Application
    [Teardown]    Close Driver Dash Application

Login With Number
    [Tags]    db
    [Setup]    Open Driver Dash Application
    Click On Get Started Button
    Click On Don't Have Username or Password Button
    Input "${phone_number}" As Phone Number
    Click On Next Button For Phone Login
    ${code}    Get Code For Phone Number: ${phone_number}
    Input "${code}" As Code Number
    Click On Next Button On Code Page
    Input "${driver_id}" As Driver ID
    Click On Next Button On Driver Id Page
    Skip Earning Rewards Page
    Run Keyword And Ignore Error    Click On Ok On Popup
    Click On More Tab
    Log Out Of The Application
    [Teardown]    Close Driver Dash Application

Add And Remove Card
    [Setup]    Open Driver Dash Application
    [Teardown]    Close Driver Dash Application
    Click On Get Started Button
    Login On Driver Dash With "dbrxom.driver" Username and "Tester23" Password
    Run Keyword And Ignore Error    Click On Ok On Popup
    Click On Add Card Button From Home Page
    Click On Add Manually Card Button From Home Page
    Enter "00071" As The Five Digits Of The Card
    Click On Add Card Button From Add Card Screen
    Click On More Tab
    Click On My Cards
    Remove The Card With "00071" As The Five Digits
    Confirm Remove Card

Testing Database
    [Tags]    checked    test    db
    [Setup]    Connect To Postgres Database
    ${code}    Get Latest Code For "${phone_number}" Phone Number
    Log To Console    Code: ${code}
    [Teardown]    Disconnect From Database

*** Keywords ***
Open Driver Dash Application
    Set Appium Timeout    10
    IF    ${local}==${True}
        Open Application
        ...    ${HOST}
        ...    automationName=${ANDROID_AUTOMATION_NAME}
        ...    platformName=${ANDROID_PLATFORM_NAME}
        ...    platformVersion=${ANDROID_PLATFORM_VERSION}
        ...    app=${ANDROID_APP_LOCAL}
        ...    autoGrantPermissions=${True}
        ...    autoAcceptAlerts=${False}
    ELSE
        Open Application
        ...    ${REMOTE_URL}
        ...    platformName=${platformName}
        ...    platformVersion=${version}
        ...    deviceName=${deviceName}
        ...    visual=${visual}
        ...    network=${network}
        ...    isRealMobile=${isRealMobile}
        ...    app=${driver_dash_android_app}
        ...    name=Robot Framework Android Driver Dash Test
        ...    build=Appium Python Robot
        ...    autoGrantPermissions=${True}
        ...    autoAcceptAlerts=${False}
    END

Close Driver Dash Application
    Close Application

Test Receipt History
    Click On Receipt History
    Navigate Up To More Page From Receipt History Page

Test My Cards
    Click On My Cards
    Close My Cards Page

Test Terms Of Use
    Click On Terms Of Use
    Close Terms Of Use Page

Test Privacy Policy
    Click On Privacy Policy
    Close Privacy Policy Page

Login On Driver Dash With "${username}" Username and "${password}" Password
    Input "${username}" As Username
    Input "${password}" As Password
    Click On Login Button

Get Card Data
    ${digits}    Get Card's Last Five Digits
    ${owner}    Get Card's Owner
    ${card_company}    Get Card's Company Owner
    Log To Console    Card's Name: ${owner}${\n}Card's Company: ${card_company}${\n}Card Digits: ${digits}

Check/Uncheck Transaction Alerts
    ${status}    Get Transaction Alerts Status
    Log To Console    Transaction Alert Status: ${status}
    IF    ${status}
        Disable Transaction Alerts
        Enable Transaction Alerts
    ELSE
        Enable Transaction Alerts
        Disable Transaction Alerts
    END

Check/Uncheck Carwash Prompts
    ${status}    Get Carwash Prompts Status
    Log To Console    Carwash Prompts Status: ${status}
    IF    ${status}
        Disable Carwash Prompts
        Enable Carwash Prompts
    ELSE
        Enable Carwash Prompts
        Disable Carwash Prompts
    END

Check/Uncheck Fingerprint Authentication
    ${status}    Get Fingerprint Authentication Status
    Log To Console    Fingerprint Authentication Status: ${status}
    IF    ${status}
        Disable Fingerprint Authentication
        Enable Fingerprint Authentication
    ELSE
        Enable Fingerprint Authentication
        Disable Fingerprint Authentication
    END

Log Out Of The Application
    Click On Log Out
    Confirm Log Out

Get Code For Phone Number: ${number}
    Connect To Postgres Database
    ${code}    Get Latest Code For "${number}" Phone Number

    [Teardown]    Run Keyword and Ignore Error    Disconnect From Database
    RETURN    ${code}

Swipe Cards Until Find Card With ${digits} As Five Digits
    ${last_digits}    Get Card's Last Five Digits
    