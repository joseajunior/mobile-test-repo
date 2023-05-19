*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/variables/CommonVariables.robot

Suite Setup    Run Keywords    Setup Fleet One Test Carrier for Term Change Notification    Remove Salesforce Data Capture Permission from Carrier
Test Teardown  Close Browser
Suite Teardown    Disconnect From Database

Force Tags  eManager

*** Variables ***
${carrier}
${datetime}

*** Test Cases ***
Carrier term change notification accepted
    [Tags]    JIRA:BOT-5036    JIRA:ATLAS-2274    qTest:118617133    PI:15
    [Documentation]  Ensure Term Change Notification is displayed and recorded when accepted for a carrier set in term
    ...    change request
    [Setup]    Run Keywords    Add Term Change Notification Permission to Carrier    Set Carrier in Term Change Request

    Log Carrier into eManager with Test Carrier
    Check Term Change Notification
    Click on 'ACCEPT ADDENDUM'
    Check home page
    Log out of eManager
    Log Carrier into eManager Again with Test Carrier
    Check home page
    Check for terms accepted in database

Carrier term change notification declined
    [Tags]    JIRA:BOT-5036    JIRA:ATLAS-2274    qTest:118755727    PI:15
    [Documentation]  Ensure Term Change Notification is displayed and recorded when declined for a carrier set in term
    ...    change request
    [Setup]    Run Keywords    Add Term Change Notification Permission to Carrier    Set Carrier in Term Change Request

    Log Carrier into eManager with Test Carrier
    Check Term Change Notification
    Click on 'DECLINE ADDENDUM'
    Check home page
    Log out of eManager
    Log Carrier into eManager Again with Test Carrier
    Check home page
    Check for terms declined in database

Carrier no company admin set in term change request
    [Tags]    JIRA:BOT-5036    JIRA:ATLAS-2274    qTest:118617135    PI:15
    [Documentation]  Ensure Term Change Notification is not displayed for a carrier set in term change request and
    ...    with Term Change Notification permission but not having company admin group
    [Setup]    Run Keywords    Add Term Change Notification Permission to Carrier    Set Carrier in Term Change Request
    ...    Remove Company Admin from Carrier

    [Teardown]    Run Keywords    Close Browser    Add Company Admin to Carrier

    Log Carrier into eManager with Test Carrier
    Check home page

Carrier set in term change request with no permission
    [Tags]    JIRA:BOT-5036    JIRA:ATLAS-2274    qTest:118617136    PI:15
    [Documentation]  Ensure Term Change Notification is not displayed for a carrier set in term change request and
    ...    with company admin group but without Term Change Notification permission
    [Setup]    Run Keywords    Remove Term Change Notification Permission from Carrier
    ...    Set Carrier in Term Change Request

    Log Carrier into eManager with Test Carrier
    Check home page

Carrier not set in term change request
    [Tags]    JIRA:BOT-5036    JIRA:ATLAS-2274    qTest:118664463    PI:15
    [Documentation]  Ensure Term Change Notification is not displayed for a carrier not set in term change request
    ...    but with company admin group and Term Change Notification permission
    [Setup]    Run Keywords    Add Term Change Notification Permission to Carrier    Term Change Request without Carrier

    Log Carrier into eManager with Test Carrier
    Check home page

*** Keywords ***
Setup Fleet One Test Carrier for Term Change Notification
    [Documentation]  Test carrier setup

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_company sc ON su.company_id = sc.company_id
    ...    JOIN sec_user_group_xref sugx ON su.user_id = sugx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]{6}$'
    ...    AND company_header = 'fleetone_carrier'
    ...    AND (su.user_id BETWEEN 100000 AND 200000
    ...    OR su.user_id BETWEEN 250000 AND 299999
    ...    OR su.user_id between 300000 AND 389999)
    ...    AND accepted_terms = 'Y'
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    #Get carrier with/without TERM_CHANGE_NOTIFICATION group
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND mem_type = 'C'
    ...  AND member_id IN ${carrier_list};
    ${carrier}    Find Carrier Variable  ${carrier_query}    member_id
    #Set carrier as test variable
    Set Suite Variable  ${carrier}

Add Term Change Notification Permission to Carrier
    [Documentation]    Give the carrier the Term Change Notification permission

    Ensure Carrier has User Permission    ${carrier.id}    TERM_CHANGE_NOTIFICATION

Remove Term Change Notification Permission from Carrier
    [Documentation]    Remove from carrier the Term Change Notification permission

    Remove Carrier User Permission    ${carrier.id}    TERM_CHANGE_NOTIFICATION

Remove Salesforce Data Capture Permission from Carrier
    [Documentation]    Remove from carrier the Salesforce Data Capture permission

    Remove Carrier User Permission    ${carrier.id}    SALESFORCE_DATA_CAPTURE

Manage User Groups
    [Arguments]    ${condition}    ${group}
    [Documentation]    Remove/Add group from/to carrier

    Open eManager    ${intern}    ${internPassword}
    Go To  ${emanager}/security/ManageUsers.action
    Wait Until Element is Visible    name=searchValue
    Input Text    name=searchValue    ${carrier.id}
    Click Element    name=searchUsers
    Wait Until Element is Visible    //*[@id='user']//td[text()='${carrier.id}']
    Click Element    //*[@id='user']//td[text()='${carrier.id}']/parent::tr//input[@name='ManageGroups']
    Wait Until Element is Visible    //option[@value="${group}"]
    Click Element    //option[@value="${group}"]
    Run Keyword If    '${condition}'=='add'    Click Element    name=addGroup
    ...    ELSE    Click Element    name=removeGroup
    Run Keyword If    '${condition}'=='add'    Wait Until Page Contains    Successfully added user to group ${group}
    ...    ELSE    Wait Until Page Contains    Successfully removed user from group ${group}
    Close Browser

Add Company Admin to Carrier
    [Documentation]    Give the carrier Company Admin group

    Manage User Groups    add    COMPANY_ADMIN

Remove Company Admin from Carrier
    [Documentation]    Remove from carrier Company Admin group

    Manage User Groups    remove    COMPANY_ADMIN

Set Carrier in Term Change Request
    [Arguments]    ${condition}=add
    [Documentation]    Set carrier to term change request

    Get Into DB    MYSQL
    ${select_query}    Catenate    SELECT *
    ...    FROM carrier_term_change_request
    ...    WHERE carrier_id = '${carrier.id}';
    ${hasTermChangeRequest}    Run Keyword and Return Status    Row Count Is Greater Than X    ${select_query}    0
    ${delete_query}    Catenate    DELETE FROM carrier_term_change_request
    ...    WHERE carrier_id = '${carrier.id}';
    Run Keyword If    '${hasTermChangeRequest}'=='True'    Execute SQL String    ${delete_query}
    IF    '${condition}'=='add'
        ${insert_query}    Catenate    INSERT INTO carrier_term_change_request
        ...    (carrier_id, template_id, reason_id, new_credit_limit, requested_by)
        ...    VALUES (${carrier.id}, 'term_change_id', 'bad_payment_history', 5000.00, 'test');
        Execute SQL String    ${insert_query}
        Check for term request empty in database
    END

Term Change Request without Carrier
    [Documentation]    Ensure carrier is not in term change request

    Set Carrier in Term Change Request    remove

Log Carrier into eManager with Test Carrier
    [Documentation]  Log carrier into eManager

    Open eManager    ${carrier.id}    ${carrier.password}    hasTermChangeNotification=${True}    ChangeCompanyHeader=${False}

Log Carrier into eManager Again with Test Carrier
    [Documentation]  Log carrier into eManager

    Go To    ${emanager}/security/logon.jsp
    Log into eManager    ${carrier.id}    ${carrier.password}    hasTermChangeNotification=${True}    ChangeCompanyHeader=${False}

Check Term Change Notification
    ${text}    Catenate    We understand that a change like this can put real strain on your business. WEX values its
    ...    partnership with your fleet, and we want to work with you to ensure that you continue to have the funding you
    ...    need to keep the wheels moving. Fortunately, given your fleet's current payment cycle timing, you can make a
    ...    fairly simple adjustment in order to keep your fuel spend capacity up. If you instruct WEX to invoice your
    ...    fleet and debit your bank account two times per week, you can minimize or eliminate any negative impact to
    ...    your total gallons available. You will then be able to spend up to your entire credit limit more than once
    ...    per week.
    Page Should Contain    ${text}
    Page Should Contain    ADDENDUM TO WEX BANK PAYMENT AUTHORIZATION
    Page Should Contain    5,000.00
    Page Should Contain Element    name=accept
    Page Should Contain Element    name=decline

Click on '${button}'
    [Documentation]    Click on accept or decline buttons

    Click Element    //*[@value="${button}"]
    # Get CT time zone current date
    ${datetime}    Get Current Date    time_zone=UTC    increment=-6 hours    result_format=%Y-%m-%d %H:%M:00
    Set Test Variable    ${datetime}

Check login page
    [Documentation]    Ensure login page is displayed

    Wait Until Element is Visible    name=userId
    Page Should Not Contain    Logged in as:

Check home page
    [Documentation]    Ensure home page is displayed

    Wait Until Element is Visible    //a[contains(text(), "Logout")]
    Page Should Contain    Logged in as:

Check app completed and accepted by in database
    [Arguments]    ${expected_app_completed}=${EMPTY}    ${expected_accepted}=None    ${expected_datetime}=None
    [Documentation]    Check app complete and accepted by values in carrier_term_change_request table

    Disconnect From Database
    Get Into DB    MYSQL
    ${query}    Catenate    SELECT *
    ...    FROM carrier_term_change_request
    ...    WHERE carrier_id = '${carrier.id}';
    ${info}    Query and Strip to Dictionary    ${query}
    Should Be Equal as Strings    ${expected_app_completed}    ${info["app_completed"]}
    Should Be Equal as Strings    ${expected_accepted}    ${info["accepted_by"]}
    IF    '${expected_accepted}'!='None'
        ${status}    Run Keyword and Return Status    Should Be Equal as Strings    ${expected_datetime}    ${info["accepted_dts"]}
        IF  ${status}==False
            ${datetimeplusone}    Add Time To Date    ${expected_datetime}    1 minute    result_format=%Y-%m-%d %H:%M:00
            Should Be Equal as Strings    ${datetimeplusone}    ${info["accepted_dts"]}
        END
    END

Check for term request empty in database
    [Documentation]    Ensure term request is added but empty in carrier_term_change_request table

    Wait Until Keyword Succeeds    5 x    5 s    Check app completed and accepted by in database

Check for terms accepted in database
    [Documentation]    Ensure terms were accepted in carrier_term_change_request table

    Wait Until Keyword Succeeds    5 x    5 s    Check app completed and accepted by in database    Y    ${carrier.id}    ${datetime}

Check for terms declined in database
    [Documentation]    Ensure terms were declined in carrier_term_change_request table

    Wait Until Keyword Succeeds    5 x    5 s    Check app completed and accepted by in database    N    ${carrier.id}    ${datetime}