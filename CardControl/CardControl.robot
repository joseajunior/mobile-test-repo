*** Settings ***
Library     AppiumLibrary
Resource    ${CURDIR}/pages/${platformName}/EnvironmentsPage.resource
Resource    ${CURDIR}/pages/${platformName}/LoginPage.resource
Resource    ${CURDIR}/pages/${platformName}/OnboardingHomeScreenPage.resource
Resource    ${CURDIR}/pages/${platformName}/HomePage.resource
# Resource    ${CURDIR}/pages/${platformName}/RegisterCheckPage.resource

Test Setup  Open Card Control Application    local=${False}
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
${ANDROID_APP}                ${CURDIR}${/}demoapp${/}cardcontrol47469.apk
${ANDROID_PLATFORM_NAME}      Android
${ANDROID_PLATFORM_VERSION}   %{ANDROID_PLATFORM_VERSION=13}

*** Test Cases ***
Testing from LambdaTest
    [Tags]    checked
    Select "Partner" Environment
    Input "7083059961002500561" Card Number
    Input "9854" PIN or Passcode
    Click On Login Button
    Run Keyword And Ignore Error    Click On Continue Button
    Click On Register Check Button
    Input "1.00" As Amount
    Click On Next Button

*** Keywords ***
Open Card Control Application
    [Arguments]    ${local}=${True}
    IF    ${local}==${True}
        Open Application  ${HOST}  automationName=${ANDROID_AUTOMATION_NAME}  platformName=${ANDROID_PLATFORM_NAME}  platformVersion=${ANDROID_PLATFORM_VERSION}  app=${ANDROID_APP}
    ELSE
        Open Application  ${REMOTE_URL}  platformName=${platformName}  platformVersion=${version}  deviceName=${deviceName}  visual=${visual}  network=${network}  isRealMobile=${isRealMobile}   app=${app}   name=Robot Framework Sample Test    build=Appium Python Robot
    END
    Set Appium Timeout    10

Close Card Control Application
    Close Application