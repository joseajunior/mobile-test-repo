*** Settings ***
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup    Setup Data
Test Teardown    Close Browser

*** Variables ***
${PortalUsername}
${PortalPassword}
${info}

*** Test Cases ***
Application Manager - Unnecessary Sensitive Data Transfer
    [Tags]    JIRA:ATLAS-2443    JIRA:BOT-5097    qTest:120565315   Q2:2023
    [Documentation]    SNN, bank account number and current supplier number masked in Reps & References

    Open browser and login to Portal
    Select Portal Program  Application Manager
    Perform app id search
    Open app id result and Rep & References tab
    Check SSNs and Account Numbers masked

*** Keywords ***
Setup Data
    [Documentation]    Setup data for Reps & References tab

    Get Into DB    TCH
    ${query}    Catenate    SELECT app_id, rep1_social_security_num, rep2_social_security_num, bank_account_num, current_supplier_account_num
    ...    FROM wrkflw_cardappl
    ...    WHERE current_supplier_account_num > ''
    ...    AND rep1_social_security_num != ''
    ...    AND rep2_social_security_num != ''
    ...    AND bank_account_num != ''
    ...    AND current_supplier_account_num != ''
    ...    ORDER BY created_date DESC
    ...    LIMIT 1;
    ${result}    Query And Strip to Dictionary    ${query}
    ${app_id}    Get From Dictionary    ${result}    app_id
    ${ssn1}    Get From Dictionary    ${result}    rep1_social_security_num
    ${ssn2}    Get From Dictionary    ${result}    rep2_social_security_num
    ${acc_number}    Get From Dictionary    ${result}    bank_account_num
    ${supplier_acc_number}    Get From Dictionary    ${result}    current_supplier_account_num
    ${info}    Create Dictionary    app_id=${app_id}    ssn1=${ssn1}    ssn2=${ssn2}    acc_number=${acc_number}
    ...    supplier_acc_number=${supplier_acc_number}
    Set Suite Variable    ${info}

Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=5

Open browser and login to Portal
    [Documentation]  Login to portal with efs domain user

    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalUsername}    ${PortalPassword}

Perform app id search
    [Documentation]    Search with general criteria to get some results

    Wait Until Element is Visible    name=searchValue
    Select From List By Value    name=searchField    app_id
    Select From List By Label    name=searchCondition    Equals
    Input Text    name=searchValue    ${info.app_id}
    Click Element    //span[text()='Search']
    Wait Until Element is Visible    //*[@id="wait_content"]
    Wait Until Element is Not Visible    //*[@id="wait_content"]

Open app id result and Rep & References tab
    [Documentation]    Open app id result and Rep & References tab

    Wait Until Element is Visible    (//*[@class='jtd' and text()='${info.app_id}'])[1]
    Double Click Element    (//*[@class='jtd' and text()='${info.app_id}'])[1]
    Wait Until Element is Visible    //*[@id="wait_content"]
    Wait Until Element is Not Visible    //*[@id="wait_content"]
    Wait Until Element is Visible    //*[text()='Reps & References']
    Click Element    //*[text()='Reps & References']
    Wait Until Page Contains    Company Representatives

Check SSNs and Account Numbers masked
    [Documentation]    All sensitive data must be masked

    ${ssn1_final}    Get Substring    ${info.ssn1}    -4
    Page Should Contain Element    //*[@id="rep1ssnDS" and @value='*****${ssn1_final}' and @type='hidden']
    ${ssn2_final}    Get Substring    ${info.ssn2}    -4
    Page Should Contain Element    //*[@id="rep2ssnDS" and @value='*****${ssn2_final}' and @type='hidden']
    ${acc_number_final}    Get Substring    ${info.acc_number}    -4
    Page Should Contain Element    //*[@id='bankNum' and @value='******${acc_number_final}']
    ${sup_acc_number_final}    Get Substring    ${info.supplier_acc_number}    -4
    Page Should Contain Element    //*[@id='supNum' and @value='******${sup_acc_number_final}']