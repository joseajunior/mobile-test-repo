*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown    Close Browser

*** Variables ***
${intern}
${internPassword}
${rxo_img_url}    https://emgr.efsllc.com/common/images/efs_carrier/xpo_logo.jpg

*** Test Cases ***
Carrier with XPO header with new branding
    [Tags]    JIRA:ATLAS-2178    JIRA:BOT-5005    qTest:117061101
    [Documentation]    Ensure carriers with XPO header has the new branding in Welcome New Carrier Email and
    ...    Welcome New Sub User Email

    Log into eManager with internal user
    Go to Select Program > Manage Company Defaults
    Search for 'xpo_carrier' Company Header
    Edit 'xpo_carrier' company header
    Verify RXO image url for 'Welcome New Carrier Email'
    Verify RXO image url for 'Welcome New Sub User Email'
    Cancel edition
    Search for 'xpo_carrier_salesforce' Company Header
    Edit 'xpo_carrier_salesforce' company header
    Verify RXO image url for 'Welcome New Carrier Email'
    Verify RXO image url for 'Welcome New Sub User Email'

*** Keywords ***
Log into eManager with internal user
    [Documentation]  Log into eManager with internal user

    Open eManager  ${intern}  ${internPassword}

Go to Select Program > Manage Company Defaults
    [Documentation]  Go to Select Program > Manage Company Defaults

    Go To  ${emanager}/security/ManageCompanyTypes.action

Search for '${company_header}' Company Header
    [Documentation]  Search company header in Manage Company Defaults screen

    Wait Until Element is Visible    name=filterTxt
    Input Text    name=filterTxt    ${company_header}

Edit '${company_header}' company header
    [Documentation]  Click to edit company header in Manage Company Defaults screen

    Wait Until Element is Visible    //td[text()='${company_header}']/parent::tr//input[@name="createCompanyType"]
    Click Element    //td[text()='${company_header}']/parent::tr//input[@name="createCompanyType"]

Verify RXO image url for '${section}'
    [Documentation]    Ensure RXO image url is correct

    Page Should Contain Element    //label[text()='${section}']/ancestor::fieldset//img[@src='${rxo_img_url}']

Cancel edition
    [Documentation]    Click to cancel edition and return to filter company defaults screen

    Click Element    name=cancel