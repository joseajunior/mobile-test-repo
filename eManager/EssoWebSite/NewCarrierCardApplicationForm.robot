*** Settings ***
Library  String
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup    Setup New Carrier Card Application URL
Test Teardown    Close Browser

*** Variables ***
${environment}
${url}
${browser}
${default_download_path}

*** Test Cases ***
No login needed to access New Carrier Card Application form
    [Tags]  JIRA:BOT-50004  JIRA:ATLAS-2220    qTest:117036377
    [Documentation]  Ensure New Carrier Card Application form is accessible without a login in eManager

    Open Browser to eManager
    Access New Carrier Card Application form
    Verify New Carrier Card Application form and no errors

*** Keywords ***
Setup New Carrier Card Application URL
    [Documentation]    Setup base url from portal

    ${env}    Fetch From Right    ${environment}    -
    ${url}    Set Variable    https://emgr.${env}.efsllc.com/cards/NewCarrierCardApplication.action?referredBy=imperial&appType=referral
    Set Suite Variable    ${url}

Access New Carrier Card Application form
    [Documentation]    Access the new carrier card application form

    Go To    ${url}

Verify New Carrier Card Application form and no errors
    [Documentation]    Check form content

    Page Should Not Contain    There was an error processing your request.
    Wait Until Element is Visible    //input[@value='Next']
    Page Should Contain    Customer Information
    Page Should Contain    Complete this application online
    Page Should Contain    Please Contact the Imperial Oil Key To The Highway Help Centre with any questions or concerns.