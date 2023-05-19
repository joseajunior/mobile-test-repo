*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Test Teardown    Close Browser
Suite Teardown    Disconnect From Database

*** Variables ***
${cardnumber}
${partial_cardnumber}

*** Test Cases ***
Mastercard number not fully displayed in search result
    [Tags]    JIRA:FRNT-1994  JIRA:BOT-3660  qTest:55842689
    [Documentation]    Ensure mastercard number is not displayed entirely in manage users user id column
    [Setup]    Setup Mastercard and Feature Flag On

    Log into eManager with F1 user
    Go to Select Program > User Administration > Manage Users
    Search Mastercard Number
    Check 'Partial' Mastercard Number

Mastercard number fully displayed as submitter for flag off
    [Tags]    JIRA:FRNT-1994  JIRA:BOT-3660  qTest:55842850
    [Documentation]    Ensure mastercard number is displayed entirely in manage users user id column when feature
    ...    flag is off
    [Setup]    Setup Mastercard and Feature Flag Off

    Log into eManager with F1 user
    Go to Select Program > User Administration > Manage Users
    Search Mastercard Number
    Check 'Full' Mastercard Number

*** Keywords ***
Setup Mastercard Number
    [Documentation]  Setup a mastercard number that can be searched in manage users

    Get Into DB  MYSQL
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]{16}$'
    ...    AND user_id LIKE '55%'
    ...    ORDER BY login_attempted DESC
    ...    LIMIT 1;
    ${cardnumber}  Query And Strip  ${query}
    Set Test Variable  ${cardnumber}
    ${first_nums}    Get Substring    ${cardnumber}    0    6
    ${last_nums}    Get Substring    ${cardnumber}    -4
    ${partial_cardnumber}    Catenate    ${first_nums}******${last_nums}
    Set Test Variable  ${partial_cardnumber}

Set Masked Mastercard Feature Flag
    [Arguments]    ${value}=Y
    [Documentation]  Change masked mastercard feature flag to Y or N

    Get Into DB    MYSQL
    ${query}  Catenate  UPDATE setting
    ...    SET value = '${value}'
    ...    WHERE `PARTITION` = 'shared'
    ...    AND name = 'FLAG_OTREPIC-3575_1994';
    Execute SQL String    ${query}

Setup Mastercard and Feature Flag Off
    [Documentation]  Mastercard number fully displayed setup test

    Setup Mastercard Number
    Set Masked Mastercard Feature Flag    N

Setup Mastercard and Feature Flag On
    [Documentation]  Mastercard number partially displayed setup test

    Setup Mastercard Number
    Set Masked Mastercard Feature Flag

Log into eManager with F1 user
    [Documentation]  Log into eManager with F1 user

    Open eManager    ${intern}    ${internPassword}

Go to Select Program > User Administration > Manage Users
    [Documentation]  Go to Select Program > User Administration > Manage Users

    Go To  ${emanager}/security/ManageUsers.action
    Wait Until Page Contains Element    name=searchValue

Search Mastercard Number
    [Documentation]  Search for mastercard number in manage users screen

    Wait Until Element Is Visible    name=searchValue
    Input Text    name=searchValue    ${cardnumber}
    Click Element    name=searchUsers
    Wait Until Element is Visible    //*[@id="user"]//td[contains(text(), '55')]

Check '${condition}' Mastercard Number
    [Documentation]  Check if mastercard is fully or partially displayed in manage users screen

    Run Keyword If    '${condition}'=='Full'    Page Should Contain Element    //*[@id="user"]//td[text() = '${cardnumber}']
    ...    ELSE    Page Should Contain Element    //*[@id="user"]//td[text() = '${partial_cardnumber}']