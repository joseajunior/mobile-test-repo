*** Settings ***
Library     WexRobotLib.MobileLibrary


*** Variables ***
${_privacy_policy_title}              xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/more_policy_toolbar"]/android.widget.TextView[@text="Privacy Policy"]
${_navigate_up_privacy_policy}        xpath=//android.view.ViewGroup[@resource-id="com.wex.fleet.driverdash.stage:id/more_policy_toolbar"]/android.widget.ImageButton[@content-desc="Navigate up"]


*** Keywords ***
Close Privacy Policy Page
    __If_Google_Chrome_Opened_Go_Back_To_App
    Wait Until Page Contains Element    ${_navigate_up_privacy_policy}    timeout=10s
    Click Element    ${_navigate_up_privacy_policy}
    Wait Until Page Does Not Contain Element    ${_privacy_policy_title}    timeout=10s

__If_Google_Chrome_Opened_Go_Back_To_App
    Sleep    4s
    ${current_activity}    Get Activity
    WHILE    'org.chromium.chrome.browser' in '${current_activity}'
        Go Back
        Sleep    1s
        ${current_activity}    Get Activity
    END
