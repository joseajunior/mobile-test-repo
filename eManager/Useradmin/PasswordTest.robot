*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  Collections
Library  RequestsLibrary
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Suite Setup     SUITE:Setup
Suite Teardown  SUITE:Teardown

Force Tags  eManager

*** Variables ***
${CurrentPass}  kevins545
${myuser2}  pwrdrobot
${oldPassword}  aAuAYuI140
${DB}  TCH
${ENV}  ${ENVIRONMENT}
@{USERIDS}  robot  efs.testers@efsllc.com  wrsameuser  103866  7083050910386614430  7083050910386614885  notARealUser
@{special_characters}  ~  !  @  \#  $  %  ^  &  *  (  )  _  +  `  -  =  {  }  [  ]  |  \\  :  ;  "  '  <  >  ?  ,  .  /

*** Test Cases ***
Case Sensitive Password
    [Tags]  JIRA:BOT-665  Q1:2023
    [Documentation]  Validate that login process validates password case sensitvity.

    Set Test Variable  ${user_name}  robottest
    Set Test Variable  ${passwd}  Test123

    get into db  mysql
    ${sql}=  assign string  update sec_user set status_id = 'A', passwd_fail_count = 0 where user_id = '${user_name}'
    execute sql string  ${sql}

    Log into eManager  ${user_name}  ${passwd}

    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'The following errors have occurred')]
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'You have entered an invalid password or User ID.')]

User Password Length - Error Message
    [Tags]  JIRA:BOT-115  JIRA:BOT-485  JIRA:BOT-1452  Q1:2023

     Log into eManager  ${intern}  ${internPassword}
     Mouse Over   id=menubar_1x2
     Mouse Over  id=TCHONLINE_ADMINx2
     Click Element  id=ADMIN_MANAGE_USERSx2
     Click Button  //input[@name="CreateUser"]
     page should contain  * User ID can only contain numbers, letters and underscores and needs to be longer than four characters.
     page should contain  ** Password must have a minimum of seven characters, three of which must be distinct, and at least one digit. Avoid using special characters (e.g. ; ?)
     Input Text    //input[@name="user.userId"]  AutoTest123
     Input Text   //input[@name="user.userFname"]  Auto
     Input Text   //input[@name="user.userLname"]  Test
#     No longer valid input
     Input Text   //input[@name="user.userPasswd"]  12345
     Input Text   //input[@name="user.userPasswd2"]  12345
     Input Text   //input[@id="notifyEmail"]  yane.santos@efsllc.com
     Click Button   //input[@name="SaveUser"]
     Page Should Contain Element  xpath=//*[@class="errors"]//*[contains(text(), 'The password you have entered is not at least 7 characters in length')]
     Input Text   //input[@name="user.userPasswd"]  1234567
     Input Text   //input[@name="user.userPasswd2"]  123456
     Click Button   //input[@name="SaveUser"]
     Page Should Contain Element  xpath=//*[@class="errors"]//*[contains(text(), 'The passwords you have entered')]

Reset Password
    [Tags]  JIRA:BOT-511  Q1:2023
    [Documentation]  This test case purpose is to validate that you can reset the password for a user

    ${sql}  catenate  select passwd from member where member_id = 103866;
    ${automation_pass}  query and strip  ${sql}  db_instance=tch
    Log into eManager  103866  ${automation_pass}
    go to  ${emanager}/security/ManageUsers.action
    ${userID}  get text  //table[@id='user']//tbody//td[contains(text(), 'socorro')]//parent::tr//td[1]
    Tch Logging  USER_ID:${userID}
    Click Element  //table[@id='user']//tbody//td[contains(text(), 'socorro')]//parent::tr//td[9]
    ${passwd}=  get text  //*[@class="messages"]//*[contains(text(),'${userID} password has been changed to')]

    ${passwd}  split string  ${passwd}  (
    ${passwrd}  get substring  ${passwd[1]}  0  -2
    Tch Logging  PASSWORD:${passwrd}

    Click Element  //*[@href="/security/Logon.action?logoffUser"]
    Log into eManager  ${userID}  ${passwrd}
    wait until page contains  Logged in as
    Page Should Contain  Logged in as

Profile Invalid Password
    [Tags]  JIRA:BOT-526  Q1:2023
    [Documentation]  Validate the error message for not an invalid password

    ${sql}  catenate  select passwd from member where member_id = 103866;
    ${automation_pass}  query and strip  ${sql}  db_instance=tch
    Log into eManager  103866  ${automation_pass}
    go to  ${emanager}/security/ManageUsers.action
    Click Element  //table[@id='user']//tbody//td[contains(text(), 'socorro')]//parent::tr//td[6]
    Input Text  user.userPasswd  giberish
    Input Text  user.userPasswd2  giberis
    Click Button  changePassword
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), "The passwords you have entered don''t match.")]

Profile Password Required
    [Tags]  JIRA:BOT-531  Q1:2023
    [Documentation]  Validate the error message for not entering a password.

    ${sql}  catenate  select passwd from member where member_id = 103866;
    ${automation_pass}  query and strip  ${sql}  db_instance=tch
    Log into eManager  103866  ${automation_pass}
    go to  ${emanager}/security/ManageUsers.action
    Click Element  //table[@id='user']//tbody//td[contains(text(), 'socorro')]//parent::tr//td[6]
    Input Text  user.userPasswd  ${empty}
    Input Text  user.userPasswd2  giberis
    Click Button  changePassword
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), "The userid or password you entered cannot be empty.")]

Password NOT Allowed Character Test
    [Documentation]  Validate the error message when special character not allowed in password
    [Tags]  JIRA:BOT-275  Q1:2023
    Log into eManager  ${myuser2}   ${oldPassword}
    Go To  ${emanager}/security/ManageUsers.action?LoadProfile
    Input each special character

Show/Hide function for emanager login - logon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Close Browser
    Open Browser To eManager  security/logon.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - eumclogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/eumclogon.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - fleetOneLogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/fleetOneLogon.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - huskylogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/huskylogon.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - imperialMerchantLogin.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/imperialMerchantLogin.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - imperiallogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/imperiallogon.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - merchantLogin.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/merchantLogin.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - pnclogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/pnclogon.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - roadRangerLogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53180283  Q1:2023
    Go to any emanager login page   security/roadRangerLogon.jsp
    Type the "Password -OR- PIN/Passcoder" value
    Click on "Show Password" checkbox
    Click again on "Show Password" to uncheck the checkbox

Show/Hide function for emanager login - Invalid password - logon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/logon.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - eumclogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/eumclogon.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - fleetOneLogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/fleetOneLogon.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - huskylogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/huskylogon.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - imperialMerchantLogin.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/imperialMerchantLogin.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - imperiallogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/imperiallogon.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - merchantLogin.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/merchantLogin.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - pnclogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/pnclogon.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Show/Hide function for emanager login - Invalid password - roadRangerLogon.jsp
    [Tags]  JIRA:ROCKET-63   qTest:53186517  Q1:2023
    Go to any emanager login page   security/roadRangerLogon.jsp
    Type an invalid password in the "Password -OR- PIN/Passcoder" field
    Click on "Show Password" checkbox
    Click on "Logon" button
    The checkbox "Show Password" should still been checked and the password field should be cleared

Forgot Password function for sub-user with Mult Factor Check attribute enabled
    [Tags]  eManager  JIRA:ROCKET-440  qTest:119704974  Q1:2023
    [Documentation]  Validate that sub-users in Carrier with MF enabled recieve token prompt when using Forgot Password
    Go to any emanager login page  security/logon.jsp
    Click on "Forgot Password"
    Enter in sub-user ID with Multi-Factor Check attribute enabled
    Click The "Next" Button
    Validate "Token has been sent to the email associated with account" text appears

Do a POST Request and validate the response code and response body using valid ID, valid email, and invalid ID
    [Tags]  eManager  JIRA:ROCKET-440  JIRA:ROCKET-465  qTest:119704719  Q1:2023  API:Y
    [Documentation]  This test case verifies that the response code of the POST Request for the forgot password should
    ...  be 200 and the response body contains 'SUCCESS,password,FPW_...'

    FOR  ${userid}  IN  @{USERIDS}
        Create Session  efsllc  https://emgr.dit.efsllc.com/security  verify=true
        &{params}=  Create Dictionary  forgotSomething=forgotSomething  userIdOrEmail=${userid}  recoverType=password  efsLoginApp=hahaha
        ${response}=  POST On Session  efsllc  Forgot.action  ${params}
        Status Should Be  200  ${response}
        Should Contain    ${response.text}  SUCCESS,password,FPW_
    END

Attempt password reset with only session token
    [Tags]  eManager  JIRA:ROCKET-456  API:Y  Q1:2023  qTest:119955264
    [Documentation]  Captures session token from user that can reset password and attempts to use that token to reset
     ...  password by skipping security token and security questions
    Get session token for user that can reset password
    Send session token and new password

Forgot Password function for eManager - logon.jsp
    [Tags]  eManager  JIRA:ROCKET-440  JIRA:ROCKET-465  qTest:120565209  Q1:2023  API:Y
    [Documentation]  Validate 'token has been sent' popup and user input displays after entering in
     ...   user id, username, CC number, and email address in Forgot Password prompt - eManager
    FOR  ${userid}  IN  @{USERIDS}
        Set Test Variable    ${userid}
        Go to any emanager login page  security/logon.jsp
        Click on "Forgot Password"
        Enter In Any User Id Or Email Address  ${userid}
        Click The "Next" Button
        Validate "Token has been sent to the email associated with account" text appears
        Validate User input text appears
    END

Forgot Password function for eManager - parklandlogon.jsp
    [Tags]  eManager  JIRA:ROCKET-440  JIRA:ROCKET-465  qTest:120565213  Q1:2023  API:Y
    [Documentation]  Validate 'token has been sent' popup and user input displays after entering in
     ...   user id, username, CC number, and email address in Forgot Password prompt - parklandlogon
    FOR  ${userid}  IN  @{USERIDS}
        Set Test Variable    ${userid}
        Go to any emanager login page  security/parklandlogon.jsp
        Click on "Forgot Password"
        Enter In Any User Id Or Email Address  ${userid}
        Click The "Next" Button
        Validate "Token has been sent to the email associated with account" text appears
        Validate User input text appears
    END

Forgot Password function for eManager - pnclogon.jsp
    [Tags]  eManager  JIRA:ROCKET-440  JIRA:ROCKET-465  qTest:120565218  Q1:2023  API:Y
    [Documentation]  Validate 'token has been sent' popup and user input displays after entering in
     ...   user id, username, CC number, and email address in Forgot Password prompt - pnclogon
    FOR  ${userid}  IN  @{USERIDS}
        Set Test Variable    ${userid}
        Go to any emanager login page  security/pnclogon.jsp
        Click on "Forgot Password"
        Enter In Any User Id Or Email Address  ${userid}
        Click The "Next" Button
        Validate "Token has been sent to the email associated with account" text appears
        Validate User input text appears
    END

Forgot Password function for eManager - ryderLogin.jsp
    [Tags]  eManager  JIRA:ROCKET-440  JIRA:ROCKET-465  qTest:120565227  Q1:2023  API:Y
    [Documentation]  Validate 'token has been sent' popup and user input displays after entering in
     ...   user id, username, CC number, and email address in Forgot Password prompt - ryderLogin
    FOR  ${userid}  IN  @{USERIDS}
        Set Test Variable    ${userid}
        Go to any emanager login page  security/ryderLogin.jsp
        Click on "Forgot Password"
        Enter In Any User Id Or Email Address  ${userid}
        Click The "Next" Button
        Validate "Token has been sent to the email associated with account" text appears
        Validate User input text appears
    END

Forgot Password function for eManager - fleetOneLogin
    [Tags]  eManager  JIRA:ROCKET-440  JIRA:ROCKET-465  qTest:119668089  Q1:2023  API:Y
    [Documentation]  Validate 'token has been sent' popup and user input displays after entering in
     ...   user id, username, CC number, and email address in Forgot Password prompt - fleetOneLogin
    FOR  ${userid}  IN  @{USERIDS}
        Set Test Variable    ${userid}
        Go to any emanager login page  security/fleetOneLogin
        Click on "Forgot Password"
        Enter In Any User Id Or Email Address  ${userid}
        Click The "Next" Button
        Validate "Token has been sent to the email associated with account" text appears
        Validate User input text appears
    END
        Close Browser

Forgot Password function - Security Token
    [Tags]    eManager  JIRA:ROCKET-465  qTest:120565143  Q1:2023  API:Y  refactor
    [Documentation]  This test case verifies that a user with security questions is prompted to answer the questions
        ...  after entering their emailed security token
    Set Test Variable    ${userid}  PKL_testpassreset
    Open Browser To eManager  security/logon.jsp
    Click on "Forgot Password"
    Enter In Any User Id Or Email Address  ${userid}
    Click The "Next" Button
    Sleep  1
    Validate "Token has been sent to the email associated with account" text appears
    Validate User input text appears
    Get Securtiy Token
    Input Security Token  ${token}
    Confirm Security Question Prompt
    Close Browser

Forgot Password function - Contact Admin
    [Tags]    eManager  JIRA:ROCKET-465  qTest:120565144  Q1:2023  API:Y
    [Documentation]    This test case verifies that a user without security questions is prompted to contact admin
    ...  after entering their emailed security token
    Set Test Variable    ${userid}  testpassreset
    Open Browser To eManager  security/logon.jsp
    Click on "Forgot Password"
    Enter In Any User Id Or Email Address  ${userid}
    Click The "Next" Button
    Sleep  1
    Validate "Token has been sent to the email associated with account" text appears
    Validate User input text appears
    Get Securtiy Token
    Input Security Token  ${token}
    Confirm Contact Admin Prompt
    Close Browser

*** Keywords ***
SUITE:Setup
    Open Browser to eManager

SUITE:Teardown
    Close Browser

Change User Password
    [Arguments]  ${oldpassword}  ${newpassword}
    go to  ${emanager}/security/ResetPasswordWidget.action
    input text  xpath=//*[@name='oldPasswd']  ${oldpassword}
    input text  xpath=//*[@name='passwd']  ${newpassword}
    input text  xpath=//*[@name='reTypePasswd']  ${newpassword}
    click on  //*[@value='Change Password']

Check for Processing Error or Invalid Character Warning
    [Arguments]  ${error_message}
    ${status}=  Run Keyword And Return Status    Element Should Be Visible  //*[contains(text(),"${error_message}")]
    IF  ${status}==False
        Element Should Be Visible      //*[contains(text(),"There was an error processing your request.")]
        Tch Logging  Got processing error instead of may not contain any symbols message.
        Go To  ${emanager}/security/ManageUsers.action?LoadProfile
    ELSE
        Element Should Be Visible      //*[contains(text(),"${error_message}")]
        Tch Logging  Got 'Password may not contain any symbols' message
    END

Go to any emanager login page
    [Tags]    qTest
    [Arguments]      ${LOGIN_PAGE}
    Go To  ${emanager}/${LOGIN_PAGE}

Type the "Password -OR- PIN/Passcoder" value
    [Tags]    qTest
    Input Text  myPassword  ${CurrentPass}

Type an invalid password in the "Password -OR- PIN/Passcoder" field
    [Tags]    qTest
    Input Text  myPassword  wrongPassword

Click on "Show Password" checkbox
    [Tags]    qTest
    Click Element    showPassword
    Page Should Contain Element  //input[@id="myPassword" and @type="text"]

Click again on "Show Password" to uncheck the checkbox
    [Tags]    qTest
    Click Element    showPassword
    Page Should Contain Element  //input[@id="myPassword" and @type="password"]

Click on "Logon" button
    [Tags]    qTest
    Click Button  logonUser
    Page Should Contain Element    //*[contains(text(),'Login Error')]

The checkbox "Show Password" should still been checked and the password field should be cleared
    [Tags]    qTest
    Page Should Contain Element  //input[@id="myPassword" and @type="text"]

Click on "Forgot Password"
    [Tags]    qTest
    Click Element  //a[contains(@onclick,'passwordPopup')]
    Page Should Contain Element   //p[contains(text(),'Please enter your user id.')]  timeout=20

Enter in any user id or email address
    [Tags]    qTest
    [Arguments]  ${userInput}
    Input Text   //input[@id="userIdOrEmail"]  ${userInput}
    Set Suite Variable  ${userInput}

Enter in sub-user ID with Multi-Factor Check attribute enabled
    [Tags]    qTest
    Input Text   //input[@id="userIdOrEmail"]  2500551ECARLSON

Click the "Next" button
    [Tags]    qTest
    Click Element  //button[text()="Next"]

Validate "Please contact the account admin..." text appears
    [Tags]    qTest
    Wait Until Element Is Visible  //span[contains(text(),'Please contact the account administrator to reset password.')]  timeout=20

Validate "Token has been sent to the email associated with account" text appears
    [Tags]    qTest
    Wait Until Element Is Visible  //span[contains(text(),'Token has been sent to the email associated with account')]  timeout=20

Validate User input text appears
    [Tags]    qTest
    Wait Until Element Is Visible  //span[text()="${userid}"]  timeout=20

Get session token for user that can reset password
    [Tags]  qTest
    [Documentation]  Post an API request with userID that allows for resetting the password by answering security questions and capture the session token
    ...  https://emgr.dit.efsllc.com/security/Forgot.action?forgotSomething=forgotSomething&userIdOrEmail=2500551ECARLSON&recoverType=password&efsLoginApp=hahaha
    Create Session  efsllc  https://emgr.dit.efsllc.com/security  verify=true
    &{tokenParams}=  Create Dictionary  forgotSomething=forgotSomething  userIdOrEmail=2500551ECARLSON  recoverType=password  efsLoginApp=hahaha
    ${tokenResponse}=  POST On Session  efsllc  Forgot.action  ${tokenParams}
    Set Test Variable  ${sessionToken}  ${tokenResponse.text.split(',')[-1].split(',')[0]}
    Status Should Be  200  ${tokenResponse}

Send session token and new password
    [Tags]  qTest
    [Documentation]  Post an API request with the captured session token and attempt password reset
    ...  https://emgr.dit.efsllc.com/security/Forgot.action?checkPassword=&tempSession={sessionToken}&newPassword1=MyNewPass28&newPassword2=MyNewPass28
    Create Session  efsllc  https://emgr.dit.efsllc.com/security  verify=true
    ${newPassword}  Generate Random String  15
    &{newPassParams}=  Create Dictionary  checkPassword=  tempSession=${sessionToken}  newPassword1=${newPassword}  newPassword2=${newPassword}
    ${newPassResponse}=  POST On Session  efsllc  Forgot.action  ${newPassParams}
    Status Should Be  200  ${newPassResponse}
    Tch Logging  \n Expected API response: 'ERROR_BADUSER' | Received API response: '${newPassResponse.text}'
    Should Be Equal As Strings  ERROR_BADUSER  ${newPassResponse.text}

Get Securtiy Token
    [Tags]  qTest
    [Documentation]    Get the security token from the audit table
    ${sql}  catenate
    ...  SELECT DESCRIPTION
    ...  FROM audit.audit
    ...  WHERE CHANGEDATE > CURDATE()
    ...  AND DESCRIPTION LIKE '%Security Token%'
    ...  ORDER BY CHANGEDATE DESC LIMIT 1;
    ${token}  query and strip  ${sql}  db_instance=mysql
    ${token}=  get from string between 2 args  ${token}  Security Token is   .  ${False}
    Set Test Variable    ${token}

Input Security Token
    [Tags]    qTest
    [Documentation]    Input the security token from the email
    [Arguments]    ${token}
    Input Text  //input[@id="enteredToken"]  ${token}
    Click Element  //div[contains(@aria-describedby, 'validateToken-popup')]//button[text()="Next"]

Confirm Token Error
   [Tags]    qTest
   [Documentation]    Confirm the token error
   Wait Until Element Is Visible  //span[@id="TokenError"]

Confirm Security Question Prompt
    [Tags]    qTest
    [Documentation]    Confirm the security question prompt appears
    Wait Until Element Is Visible      //p[text()="Please answer the following security question:"]

Confirm Contact Admin Prompt
    [Tags]    qTest
    [Documentation]    Confirm the contact admin prompt appears
    Wait Until Element Is Visible    //*[@id="problem-popup"] //*[contains(text(),"Please contact the account administrator to reset password.")]

Input each special character
    [Tags]  qTest
    [Documentation]  Input each special character into the password field and confirm the error message appears
    FOR  ${special_character}  IN  @{special_characters}
        Input Text  oldPasswd   ${oldPassword}
        Input Text  user.userPasswd   Secret${special_character}007
        Input Text  user.userPasswd2  Secret${special_character}007
        Tch Logging  \nTrying invalid password Secret${special_character}007
        Click Button  changePassword
        Check for Processing Error or Invalid Character Warning  Password may not contain any symbols.
    END