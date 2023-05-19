*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown    Close Browser
Suite Teardown    Disconnect from Database

*** Variables ***
${carrier}
${subuser}
${intern}
${internPassword}

*** Test Cases ***
XPO carrier Announcements and Branding change to RXO
    [Tags]    JIRA:ATLAS-2178    JIRA:BOT-5005    qTest:117060982
    [Documentation]    Ensure XPO name and branding are changed to RXO in home page for carriers with XPO header
    [Setup]    Setup Carrier XPO header

    Log Carrier into eManager with XPO header
    Verify new RXO Announcements

XPO subuser Announcements and Branding change to RXO
    [Tags]    JIRA:ATLAS-2178    JIRA:BOT-5005    qTest:117071896
    [Documentation]    Ensure XPO name and branding are changed to RXO in home page for subusers with XPO header
    [Setup]    Setup Subuser XPO header

    Log into eManager with internal user
    Work as Subuser through Customer Info Test
    Verify new RXO Announcements

*** Keywords ***
Setup Carrier XPO header
    [Documentation]  Keyword Setup Carrier for Money Code Remaining Balance Report

    Get Into DB  MySQL
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    INNER JOIN sec_company sc
    ...    ON sc.company_id = su.company_id
    ...    WHERE su.user_id REGEXP '^[0-9]{6}$'
    ...    AND company_header = 'xpo_carrier'
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${isList}    Run Keyword and Return Status    Row Count Is Greater Than X    ${carrier_list_query}    1
    ${carrier_list}  Run Keyword If    '${isList}'=='True'
    ...    Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ...    ELSE    Set Variable    ('${carrier_list}')
    ${carrier_query}  Catenate  SELECT member_id
    ...    FROM member
    ...    WHERE status = 'A'
    ...    AND mem_type = 'C'
    ...    AND member_id IN ${carrier_list};
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Setup Subuser XPO header
    [Documentation]  Keyword Setup Carrier for Money Code Remaining Balance Report

    Setup Carrier XPO header
    ${subuser_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    INNER JOIN sec_company sc
    ...    ON sc.company_id = su.company_id
    ...    WHERE su.company_id IN (SELECT company_id FROM sec_user WHERE user_id = '${carrier.id}')
    ...    AND user_id != '${carrier.id}'
    ...    AND company_header = 'xpo_carrier'
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${subuser}  Query And Strip  ${subuser_list_query}
    Set Suite Variable  ${subuser}

Log Carrier into eManager with XPO header
    [Documentation]  Log Carrier into eManager with XPO header

    Open eManager  ${carrier.id}  ${carrier.password}  ChangeCompanyHeader=False

Log into eManager with internal user
    [Documentation]  Log into eManager with internal user

    Open eManager  ${intern}  ${internPassword}

Work as Subuser through Customer Info Test
    [Documentation]  Go to customer info test, search and open subuser

    Select Program > "User Administration" > "Customer Info Test"
    Search for User in Customer Info Test
    Open User in Customer Info Test

Search for User in Customer Info Test
    [Documentation]  Search user in customer info test screen
    [Arguments]    ${user}=${subuser}

    Wait Until Element is Visible    name=searchValue
    Input Text    name=searchValue    ${user}
    Click Button    name=SearchCustomers

Open User in Customer Info Test
    [Documentation]  Open search user on customer info test screen
    [Arguments]    ${user}=${subuser}

    Wait Until Element is Visible    //a[text()='${user}']
    Click Element    //a[text()='${user}']

Verify new RXO Announcements
    [Documentation]  Ensure XPO has changed to RXO in Announcements

    Page Should Contain    RXO Announcements
    Page Should Contain    Welcome to your RXO Account!
    Page Should Not Contain    XPO Announcements
    Page Should Not Contain    Welcome to your XPO Account!