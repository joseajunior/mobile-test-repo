*** Settings ***
Library     WexRobotLib.MobileLibrary
Resource    ${CURDIR}/pages/${platformName}/EnvironmentsPage.resource
Resource    ${CURDIR}/pages/${platformName}/WelcomeCardControl.resource
Resource    ${CURDIR}/pages/${platformName}/LoginPage.resource
# Resource    ${CURDIR}/pages/${platformName}/OnboardingHomeScreenPage.resource
# Resource    ${CURDIR}/pages/${platformName}/HomePage.resource
# Resource    ${CURDIR}/pages/${platformName}/RegisterCheckPage.resource

Test Setup  Open Carrier Control Application    local=${True}
Test Teardown  Close Card Control Application

*** Variables ***
# LAMBDATEST
${USERNAME}        emanuel.olivas
${ACCESS}          YZb0YwyI3HYdWa6zT9HcTsuk8cTXH1KGSONusFGyTAbRWfDmhH
${REMOTE_URL}      https://${USERNAME}:${ACCESS}@mobile-hub.lambdatest.com/wd/hub
${TIMEOUT}         3000
${platformName}    Android
${app}             lt://APP10160301891682355365346212

# LOCAL
${HOST}    http://127.0.0.1:4723/wd/hub
${ANDROID_AUTOMATION_NAME}    UIAutomator2
${ANDROID_APP}                ${CURDIR}${/}demoapp${/}carriercontrol46701.apk
${ANDROID_PLATFORM_NAME}      Android
${ANDROID_PLATFORM_VERSION}   %{ANDROID_PLATFORM_VERSION=13}

*** Test Cases ***
Testing from LambdaTest
    [Tags]    checked
    Select "DIT" Environment
    Skip Welcome Page
    Input "103866" As Username
    Input "151244" As Password
    Click On Login Button
    # Run Keyword And Ignore Error    Click On Continue Button
    # Click On Register Check Button
    # Input "1.00" As Amount
    # Click On Next Button

*** Keywords ***
Open Carrier Control Application
    [Arguments]    ${local}=${True}
    IF    ${local}==${True}
        Open Application  ${HOST}  automationName=${ANDROID_AUTOMATION_NAME}  platformName=${ANDROID_PLATFORM_NAME}  platformVersion=${ANDROID_PLATFORM_VERSION}  app=${ANDROID_APP}
    ELSE
        Open Application  ${REMOTE_URL}  platformName=${platformName}  platformVersion=${version}  deviceName=${deviceName}  visual=${visual}  network=${network}  isRealMobile=${isRealMobile}   app=${app}   name=Robot Framework Sample Test    build=Appium Python Robot
    END
    Set Appium Timeout    10

Close Card Control Application
    Close Application