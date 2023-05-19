*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot


Force Tags  Account Manager

*** Test Cases ***
Update User Email Address
    [Tags]  JIRA:ROCKET-443  JIRA:ROCKET-349  qTest:118598021  API:Y  PI:15  checked
    [Setup]  Get a Valid TCH Carrier

    Login to Account Manager and Navigate to User Tab
    Get "0" user id and email change "${TRUE}"
    Change first user email and click update email  ${email}
    You Should See a Email address updated successfully. Message On Screen
    Verify Email Changes in sec user table

    [Teardown]  Clean up test

Click resend email link
    [Tags]  JIRA:ROCKET-443  JIRA:ROCKET-349  qTest:118598024  API:Y  PI:15
    [Setup]  Get a Valid TCH Carrier

    Login to Account Manager and Navigate to User Tab
    Get "0" user id and email change "${False}"
    Click on "0" Resend Email
    Click Submit on Pop up window
    You Should See a Welcome email has been successfully resent Message On Screen
    Check Audit table that is sent  ${sec_email}

    [Teardown]  Close Browser

Click resend email link with flt_auth_setup_completed
    [Tags]  JIRA:ROCKET-443  JIRA:ROCKET-343  API:Y  PI:15  qtest:118673311
    [Setup]  Get Parkland carrier with flt_auth_setup_completed

    Login to Account Manager and Navigate to User Tab
    Get "1" user id and email change "${False}"
    Click on "1" Resend Email
    Click Submit on Pop up window
    You Should See a Welcome email has been successfully resent Message On Screen
    Check Audit table that is sent  ${email}

    [Teardown]  Close Browser

Click resend email link without flt_auth_setup_completed
    [Tags]  JIRA:ROCKET-443  JIRA:ROCKET-343  API:Y  PI:15  qtest:118673312
    [Setup]  Get Parkland carrier without flt_auth_setup_completed

    Login to Account Manager and Navigate to User Tab
    Get "1" user id and email change "${False}"
    Click on "1" Resend Email
    Click Submit on Pop up window
    You Should See a Welcome email has been successfully resent Message On Screen
    Check Audit table that is sent  ${email}

    [Teardown]  Close Browser

*** Keywords ***
Login to Account Manager and Navigate to User Tab
    [Tags]    qtest
    [Documentation]   Follow TC-2113 to login to account manager
    ...  Once Logged in Click on Customer tab
    ...  Input carrier id from sql above and click submit
    ...  Click on hyperlink that is carrier id
    ...  On the bottom/lower set of tabs click on User Accounts
    ...  Click on Submit button to pull available users for that carrier
    Open Account Manager
    Search For ${carrier.id} And Go to User Accounts Tab
    page should contain  Resend Welcome Email
    Click On Submit For User Accounts Search

Check Audit table that is sent
    [Tags]    qtest
    [Documentation]   there are 3 possible tables to check teslsm.audit, audit.audit, and audit.standin_audit
    ...  Use the below sql to find the email in the database
    ...  Select DESCRIPTION
    ...  FROM {table}
    ...  WHERE CHANGEDATE > CURDATE()
    ...  AND   DESCRIPTION LIKE '%MailUtil%'
    ...  AND   DESCRIPTION LIKE '%Welcome%'
    ...  AND   DESCRIPTION LIKE '%to: {the email for the user}%'
    ...  ORDER BY CHANGEDATE DESC LIMIT 1;
    ...  OR
    ...  IF its your email go check your email :D
    [Arguments]    ${theemail}
    ${teslsmsql}  Catenate   Select DESCRIPTION
    ...  FROM teslsm.audit
    ...  WHERE CHANGEDATE > CURDATE()
    ...  AND   DESCRIPTION LIKE '%MailUtil%'
    ...  AND   DESCRIPTION LIKE '%Welcome%'
    ...  AND   DESCRIPTION LIKE '%${user_id}%'
    ...  AND   DESCRIPTION LIKE '%to: ${theemail}%'
    ...  ORDER BY CHANGEDATE DESC LIMIT 1;
    ${auditsql}  Catenate    Select DESCRIPTION
    ...  FROM audit.audit
    ...  WHERE CHANGEDATE > CURDATE()
    ...  AND   DESCRIPTION LIKE '%MailUtil%'
    ...  AND   DESCRIPTION LIKE '%Welcome%'
    ...  AND   DESCRIPTION LIKE '%${user_id}%'
    ...  AND   DESCRIPTION LIKE '%to: ${theemail}%'
    ...  ORDER BY CHANGEDATE DESC LIMIT 1;
    ${standinsql}  Catenate    Select DESCRIPTION
    ...  FROM audit.standin_audit
    ...  WHERE CHANGEDATE > CURDATE()
    ...  AND   DESCRIPTION LIKE '%MailUtil%'
    ...  AND   DESCRIPTION LIKE '%Welcome%'
    ...  AND   DESCRIPTION LIKE '%${user_id}%'
    ...  AND   DESCRIPTION LIKE '%to: ${theemail}%'
    ...  ORDER BY CHANGEDATE DESC LIMIT 1;
    ${results}=  Query And Strip  ${teslsmsql}  db_instance=mysql
    IF  ${results} is ${None}
         ${standin}  Query And Strip  SELECT value FROM setting WHERE name = 'use_standin_audit_table'  db_instance=mysql
      IF  '${standin}' == 'Y'
        ${results}=  Query And Strip  ${standinsql}  db_instance=mysql
      ELSE
         ${results}=  Query And Strip  ${auditsql}  db_instance=mysql
      END
    END
    Should Contain    ${results}  ${user_id}

Click Submit on Pop up window
    [Tags]  qtest
    [Documentation]    A popup window will show up with example of email
    ...  Click on the submit button for it to email the welcome email again
    Click Element  //button[@class="submitButton"]
    Wait Until Loading Spinners Are Gone

Click on first Resend Email
    [Tags]    qtest
    [Documentation]    On the far right side of each user is Resend Welcome email
    ...  If the link is not visible it is because no valid email is given
    ...  put in valid email then click the link to resend it
    IF  '${emailaddress}'=='null'
        Change first user email and click update email  ${email}
    END
    Wait Until Element Is Visible    //*[@id='resendWelcomeEmail_0']
    Click Element   //*[@id='resendWelcomeEmail_0']

Click on "${number}" Resend Email
    [Tags]    qtest
    [Documentation]    On the far right side of each user is Resend Welcome email
    ...  If the link is not visible it is because no valid email is given
    ...  put in valid email then click the link to resend it
    IF  '${emailaddress}'=='null'
        Change first user email and click update email  ${email}
    END
    Wait Until Element Is Visible    //*[@id='resendWelcomeEmail_${number}']
    Click Element   //*[@id='resendWelcomeEmail_${number}']

Clean up test
    [Tags]    qtest
    [Documentation]    if you changed the email address be a nice person and change it back
    Change first user email and click update email  ${emailaddress}
    Close Browser

Click On ${tab} Tab
    Click Element  //*[@id="${tab.replace(' ', '')}"]
    Wait Until Loading Spinners Are Gone

Click On Searched ${customerId} Customer #
    Wait Until Element Is Visible  //button[@class="id buttonlink" and text()="${customerId}"]  timeout=10
    Click Element  //button[@class="id buttonlink" and text()="${customerId}"]
    Wait Until Loading Spinners Are Gone

Click On Submit For Customer Search
    Click Element  //*[@id="customerSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Click On Submit For User Accounts Search
    Click Element  //*[@id="userAccountsSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Loading Spinners Are Gone

Get "${number}" user id and email change "${value}"
    Wait Until Element Is Enabled  //*[@id='userId_${number}']
    ${userid}  Get text    //*[@id='userId_${number}']
    ${emailaddress}  Get value    //*[@id='emailId_${number}']
    Set Test Variable  ${userid}
    Set Test Variable  ${emailaddress}
    IF  '${email}' == '${emailaddress}'
        IF  ${value} == ${TRUE}
            Set Test Variable  ${email}  efs.testers@wexinc.com
        END
    END

Change first user email and click update email
    [Tags]    qtest
    [Documentation]    Change the email address to something different then it already is
    ...  and click the update email button
    [Arguments]    ${theemail}
    Sleep    10
    IF  '${theemail}' == 'null'
        Double Click On  //*[@id='emailId_0']
        Input Text    //*[@id='emailId_0']  efs.testers@wexinc.com
    ELSE
        Double Click On  //*[@id='emailId_0']
        Input Text    //*[@id='emailId_0']  ${theemail}
    END
    Wait Until Element Is Enabled  //*[@id='updateEmailId_0']
    Click Button    //*[@id='updateEmailId_0']

Verify Email Changes in sec user table
    [Tags]  qtest
    [Documentation]    Query the mysql teslsm.sec_user table to make sure email is updated
    ...  select notify_email from teslsm.sec_user where user_id = {userid}
    ...  Verify that the email matches the one you just put in
    ${sql}  Catenate    select notify_email from teslsm.sec_user where user_id = ${userid}
    ${table_email}  Query And Strip    ${sql}  db_instance=mysql
    Should Be Equal As Strings    ${email}  ${table_email}

Get a Valid TCH Carrier
    [Tags]  qtest
    [Documentation]   Use the below query to find a valid TCH carrier
    ...  SELECT *
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND (member_id between 100000 and 200000 OR member_id between 300000 and 389999)
    ...  LIMIT 100;

    ${query}=  Catenate  SELECT *
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND (member_id between 100000 and 200000 OR member_id between 300000 and 389999)
    ...  LIMIT 100;

    ${carrier}  Find Carrier Variable  ${query}  member_id  TCH

    ${sql}  catenate  select user_id, notify_email from sec_user where user_id = '${carrier.id}';
    ${user}  query and strip to dictionary  ${sql}  mysql

    Set Test Variable  ${email}  WEXEFS-El-Robot@wexinc.com
    Set Test Variable  ${carrier}
    Set Test Variable  ${sec_email}  ${user['notify_email']}

Get Parkland carrier without flt_auth_setup_completed
    [Tags]  qtest
    [Documentation]   Use the below query to find a valid carrier
    ...  select user_id, notify_email from sec_user where company_id in (select company_id from sec_company where company_header = 'parkland_carrier')
    ...  and flt_auth_setup_completed is null and user_id REGEXP '^[0-9]+$' and notify_email is not null limit 1;
    ${sql}  catenate  select user_id, notify_email from sec_user where company_id in (select company_id from sec_company where company_header = 'parkland_carrier')
                    ...  and flt_auth_setup_completed is null and user_id REGEXP '^[0-9]+$' and notify_email is not null limit 1;
    ${user}  query and strip to dictionary  ${sql}  mysql
    ${query}  Catenate  SELECT *
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND member_id = ${user['user_id']};

    ${carrier}  Find Carrier Variable  ${query}  member_id  TCH

    Set Test Variable  ${carrier}
    Set Test Variable  ${email}  ${user['notify_email']}

Get Parkland carrier with flt_auth_setup_completed
    [Tags]  qtest
    [Documentation]   Use the below query to find a valid carrier
    ...  select user_id, notify_email from sec_user where company_id in (select company_id from sec_company where company_header = 'parkland_carrier')
    ...  and flt_auth_setup_completed is null and user_id REGEXP '^[0-9]+$' and notify_email is not null limit 1;
    ${sql}  catenate  select user_id, notify_email from sec_user where company_id in (select company_id from sec_company where company_header = 'parkland_carrier')
                    ...  and flt_auth_setup_completed is not null and user_id REGEXP '^[0-9]+$' and notify_email is not null limit 1;
    ${user}  query and strip to dictionary  ${sql}  mysql
    ${query}  Catenate  SELECT *
    ...  FROM member
    ...  WHERE mem_type = 'C'
    ...  AND status = 'A'
    ...  AND member_id = ${user['user_id']};

    ${carrier}  Find Carrier Variable  ${query}  member_id  TCH

    Set Test Variable  ${carrier}
    Set Test Variable  ${email}  ${user['notify_email']}

Input ${customer_id} As Customer #
    Wait Until Element Is Visible  //*[@name="id"]
    Input Text  //*[@name="id"]  ${customer_id}

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Search For ${carrier} And Go to ${tab} Tab
    Input ${carrier} As Customer #
    Click On Submit For Customer Search
    Click On Searched ${carrier} Customer #
    Click On ${tab} Tab

You Should See a ${msgSuccess} Message On Screen
    [Tags]  qtest
    [Documentation]    There will be a little message appear in the same row as the submit button
    Wait Until Element Is Visible  //*[@id="userAccountsMessages"]/ul[@class="msgSuccess"]/li[contains(text(), '${msgSuccess}')]
    page should contain  Resend Welcome Email

You Should See The "${errorMessage}" Error Message For Policy Contract
    Check Element Exists  //label[@for="contractId" and @class="error" and text()="${errorMessage}"]

You Should See The "${errorMessage}" Error Message For Policy Name
    Check Element Exists  //label[@for="name" and @class="error" and text()="${errorMessage}"]
