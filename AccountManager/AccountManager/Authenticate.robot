*** Settings ***
Library  DateTime
Library  BuiltIn
Library  String
Library  otr_model_lib.Models
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary

Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Test Teardown  Run Keywords    Close Browser    Disconnect From Database

Force Tags  AM

Documentation  This is to test that an account manager can authenticate as a user whose verify is 1,2,3 or 4
...  without any errors i.e., verify =1, use member.member_id / member.passwd
...  for verify =2, use the carr_pswd.carrier_id /carr_pswd.passwd
...  for verify=3, use member.member_id / member.passwd
...  for verify=4, use call in ID and call in PIN

*** Variables ***
${carrier}
${callin_id}
${callin_pin}
${subuser}
${number}
${name}

*** Test Cases ***
Authenticate Caller as a member.verify-1
    [Tags]  JIRA:BOT-1506  qTest:32027174  JIRA:BOT-2108  JIRA:FRNT-2130  JIRA:BOT-4960
    [Documentation]  This is to test that an account manager should be able to
    ...  authenticate as a carrier whose verify=1 using carrier ID and password
    [Setup]    Run Keywords    Setup Carrier for Verify '1'    Open Account Manager

    Authenticate caller  1  ${carrier.id}  ${carrier.password}

Authenticate Caller as a member.verify-2
    [Tags]  JIRA:BOT-1506  qTest:32026865  JIRA:BOT-2108  JIRA:FRNT-2130  JIRA:BOT-4960
    [Documentation]  This is to test that an account manager should be able to
    ...  authenticate as a carrier whose verify=2 using carrier ID and password from carr_pswd table
    [Setup]    Run Keywords    Setup Carrier for Verify '2'    Open Account Manager

    Authenticate caller  2  ${carrier.id}  ${carrier.password}  ${name}

Authenticate Caller as a member.verify-3
    [Tags]  JIRA:BOT-1506  qTest:32027211  JIRA:BOT-2108  JIRA:FRNT-2130  JIRA:BOT-4960
    [Documentation]  This is to test that an account manager should be able to
    ...  authenticate as a carrier whose verify=3 using carrier ID and password
    [Setup]    Run Keywords    Setup Carrier for Verify '3'    Open Account Manager

    Authenticate caller  3  ${carrier.id}  ${carrier.password}

Authenticate Caller as a member.verify-4
    [Tags]  JIRA:BOT-1506  qTest:32027212  JIRA:BOT-2108  JIRA:FRNT-2130  JIRA:BOT-4960
    [Documentation]  This is to test that an account manager should be able to
    ...  authenticate as a carrier whose verify=4 using carrier ID, call in ID and call in PIN
    [Setup]    Run Keywords    Setup Carrier for Verify '4'

    Authenticate caller  4  ${carrier.id}  ${callin_id}  ${callin_pin}

*** Keywords ***
Setup Carrier for Verify '${number}'
    [Documentation]  Get valid carrier with verify 1/2/3/4

    Set Test Variable    ${number}
    Run Keyword If    '${number}'=='1'    Get Carrier for Verify 1 or 3
    ...    ELSE IF    '${number}'=='2'    Get Carrier for Verify 2
    ...    ELSE IF    '${number}'=='3'    Get Carrier for Verify 1 or 3
    ...    ELSE    Get Carrier for Verify 4

Get Carrier for Verify 1 or 3
    [Documentation]  Get valid verify 1 or 3 carrier

    Get Into DB  MySQL
    # Get user_id from the last 150 logged to avoid mysql error.
    ${query}  Catenate  SELECT DISTINCT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]+$'
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ${query_result}  Query And Strip To Dictionary  ${query}
    ${user_id_list}  Get From Dictionary  ${query_result}  user_id
    ${user_id_list}  Evaluate  ${user_id_list}.__str__().replace('[','(').replace(']',')')
    ${query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND mem_type = 'C'
    ...  AND member_id IN ${user_id_list}
    ...  AND verify = ${number};
    ${carrier}  Find Carrier Variable  ${query}    member_id
    Set Test Variable  ${carrier}

Get Carrier for Verify 2
    [Documentation]  Get valid verify 2 carrier with valid user in company and its password

    Get Into DB  TCH
    ${query}  Catenate  SELECT DISTINCT carrier_id
    ...    FROM carr_pswd
    ...    WHERE carrier_id IN (SELECT member_id FROM member WHERE verify = 2 AND status = 'A')
    ...    ORDER BY carrier_id;
    ${query_result}  Query And Strip To Dictionary  ${query}
    ${carrier_id_list}  Get From Dictionary  ${query_result}  carrier_id
    ${carrier_id_list}  Evaluate  ${carrier_id_list}.__str__().replace('[','(').replace(']',')')
    Get Into DB  MySQL
    # Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT DISTINCT user_id
    ...    FROM sec_user
    ...    WHERE user_id IN ${carrier_id_list}
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${carrier.id}    Query And Strip    ${query}
    Set Test Variable    ${carrier.id}
    Get Into DB  TCH
    ${query}  Catenate  SELECT FIRST 1 name, passwd
    ...    FROM carr_pswd
    ...    WHERE carrier_id = '${carrier.id}';
    ${query}  Query And Strip To Dictionary  ${query}
    ${name}  Get From Dictionary  ${query}  name
    Set Test Variable    ${name}
    ${carrier.password}  Get From Dictionary  ${query}  passwd
    Set Test Variable    ${carrier.password}

Get Carrier for Verify 4
    [Documentation]  Get valid verify 4 carrier with call in id and call in pin

    Get Into DB  TCH
    ${query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND mem_type = 'C'
    ...  AND verify = ${number};
    ${query_result}  Query And Strip To Dictionary  ${query}
    ${carrier_id_list}  Get From Dictionary  ${query_result}  member_id
    ${carrier_id_list}  Evaluate  ${carrier_id_list}.__str__().replace('[','(').replace(']',')')
    Get Into DB  MySQL
    ${query}  Catenate  SELECT DISTINCT user_id
    ...    FROM sec_user
    ...    WHERE call_in_pin IS NOT NULL
    ...    AND call_in_id IS NOT NULL
    ...    AND call_in_id IS NOT NULL
    ...    AND (pin_expire_date IS NOT NULL OR pin_updated IS NOT NULL)
    ...    AND status_id = 'A'
    ...    AND user_id IN ${carrier_id_list}
    ...    LIMIT 1;
    ${subuser}    Query And Strip    ${query}
    Set Test Variable    ${subuser}
    ${query}  Catenate  SELECT a.value
    ...    FROM sec_company_attribute a
    ...    INNER JOIN sec_user u
    ...    ON u.company_id = a.company_id
    ...    WHERE u.user_id = '${subuser}'
    ...    AND a.type_id = 1;
    ${carrier.id}    Query And Strip    ${query}
    Set Test Variable    ${carrier.id}
    Renew Pin for Verify 4

Renew Pin for Verify 4
    [Documentation]  Renew call in id and call in pin for verify 4 to authenticate in account manager

    Open Manage Users
    Search and Edit User
    Generate Temporary Pin and Save It
    ${status}    Run Keyword and Return Status    Checkbox Should Be Selected    user.custServAccess
    Run Keyword If    '${status}'=='False'    Enable Customer Service Access
    Access Account Manager

Open Manage Users
    [Documentation]  Opens manage users screen

    Open eManager  ${intern}  ${internPassword}
    Go to  ${emanager}/security/ManageUsers.action
    Wait Until Element is Visible    searchValue

Search and Edit User
    [Documentation]  Search and click to edit user in manager users

    Input Text    searchValue    ${subuser}
    Click Element    searchUsers
    Wait Until Element is Visible    //*[text() = '${subuser}']//following::input[@title='Edit Profile']
    Click Element    //*[text() = '${subuser}']//following::input[@title='Edit Profile']

Generate Temporary Pin and Save It
    [Documentation]  Generates new call in id and call in pin to authenticate in account manager

    Wait Until Element is Visible    generateTemporaryPinCarrierAdmin
    Click Element    generateTemporaryPinCarrierAdmin
    Wait Until Page Contains    Profile information updated successfully for
    ${callin_id}    Get Value    user.callInId
    Set Test Variable    ${callin_id}
    ${callin_pin}    Get Value    user.callInPin
    Set Test Variable    ${callin_pin}

Enable Customer Service Access
    [Documentation]  Enable customer service access to authenticate in account manager

    Select Checkbox    user.custServAccess
    Click Element    SaveProfile
    Wait Until Page Contains    Profile information updated successfully for

Access Account Manager
    [Documentation]  Access account manager when already logged in

    Go to  ${emanager}/acct-mgmt/RecordSearch.action
    Wait Until Loading Spinners Are Gone

Authenticate caller
    [Documentation]  Opens authenticate and insert carrier credentials
    [Arguments]  ${verify}  ${customer_id}  ${password}  ${holder}=${EMPTY}

    Click Element    //*[contains(text(),'Authenticate')]
    Input Credential    proxiedCustomerId    ${customer_id}
    Click Button    ValidationButton
    Wait Until Element is Visible    //label[@for='authentication.reason']
    Click Button    //*[@id="authenticateFormButtons"]/button[2]
    Wait Until Element is Visible    //*[contains(text(),'Authenticate')]
    Click Element    //*[contains(text(),'Authenticate')]
    Input Credential    proxiedCustomerId    ${customer_id}
    Click Button  submit
    Wait Until Element is Visible    //*[@class="msgSuccess"]
    Run Keyword If  '${verify}'=='1'  Input Credential  password  ${password}
    ...  ELSE IF  '${verify}'=='2'  Run Keywords  Select Credential by Value  userName  ${holder}  AND  Input Credential  password  ${password}
    ...  ELSE IF  '${verify}'=='3'  Run Keywords  Input Credential  eManagerUserName  ${customer_id}  AND  Input Credential  password  ${password}
    ...  ELSE  Run Keywords  Input Credential  callInId  ${password}  AND  Input Credential  callInPin  ${holder}
    Click Button  submit
    Wait Until Page Contains  text=AUTHENTICATION VIEW  timeout=20
    Click Element  //*[contains(text(),'End Call')]
    Wait Until Page Contains  text=Records  timeout=20

Input Credential
    [Arguments]    ${path}    ${value}

    Wait Until Element is Visible    authentication.${path}
    Input Text    authentication.${path}    ${value}

Select Credential by Value
    [Arguments]    ${path}    ${value}

    Wait Until Element is Visible    authentication.${path}
    Select From List by Value    authentication.${path}    ${value}