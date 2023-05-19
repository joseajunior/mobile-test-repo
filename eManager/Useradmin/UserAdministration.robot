*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  Collections
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
#Resource  ../../SysopVirtualKeyboard/Keywords/VirtualKeyboard.robot

Suite Setup  Time to Setup
Suite Teardown  Close Everything
Force Tags  eManager

*** Variables ***
${myuser2}=  100047robot
${DB}  TCH
${carrier}
#${pass_carrier}
${carrier_id}  324878

*** Test Cases ***

User ID Length - More Than 4 Characters
     [Tags]  JIRA:BOT-116  deprecated
     Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
     Go To  ${emanager}/security/ManageUsers.action
     Click Button  CreateUser
     Input Text    user.userId  ad
     Input Text    user.userFname   a
     Input Text    user.userLname"   a
     Input Text    user.notifyEmail    efs.testers@efsllc.com
     Click Button   Save
     Page Should Contain  User ID can only contain numbers, letters and underscores and needs to be longer than four characters

Invalid User ID - No Special Characters
    [Tags]  JIRA:BOT-117  JIRA:BOT-1452  BUGGED:When entering special characters in the user name it used to show an error now it displays a white screen, and stops processing.  JIRA:BOT-2475  refactor
    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To Create User Inside eManager
    Input Text    user.userId    ad!  #SPECIAL CHARACTERS CAUSING SCREEN TO GO WHITE AND PROCESSING TO STOP
    Click Element  //*[@id="SaveButton"and @type="button"]
    Click On  text=OK
    Page Should Contain Element  xpath=//*[@class="errors"]//*[contains(text(), 'User ID can only contain numbers, letters and underscores and needs to be longer than four characters')]
    [Teardown]  Go Back To The HomePage       #EVEN WITH THE WITHE SCREEN MAKE SURE TO GO BACK TO THE LOGIN PAGE

User Invalid Password - No valid password
    [Tags]  JIRA:BOT-118  deprecated
    [Setup]  Go To Create User Inside eManager
    Input Text    //input[@name="user.userId"]  AutoTest123
    Input Text   //input[@name="user.userPasswd"]  1234567!
    Input Text   //input[@name="user.userPasswd2"]  1234567!
    Click Button   //input[@name="Save"]
    Click On  text=OK
    Page Should Contain Element  xpath=//*[@class="errors"]//*[contains(text(), 'Password must contain at least 3 distinct letters')]

Passwords Don't Match
    [Tags]  JIRA:BOT-119  deprecated
     Input Text   //input[@name="user.userPasswd"]  1234567
     Input Text   //input[@name="user.userPasswd2"]  123456
     Click Button   //input[@name="Save"]
     Click On  text=OK
     Page Should Contain Element  xpath=//*[@class="errors"]//*[contains(text(), 'The passwords you have entered')]

User ID Already In Use
    [Tags]  JIRA:BOT-120  refactor
    [Setup]  Go To Create User Inside eManager
    Input Text    user.userId    TEST456
    Input Text    user.userFname  Chester
    Input Text    user.userLname  Tester
    Click Element  //*[@id="SaveButton"and @type="button"]
    Click On  text=OK
    Page Should Contain Element  xpath=//*[@class="errors"]//*[contains(text(), 'The User ID is already in use')]
    [Teardown]  Go Back To The HomePage

Add User Required Fields
    [Tags]  JIRA:BOT-121  refactor
    [Setup]  Go To Create User Inside eManager
    Input Text  user.userId  FlibityGiblets
    Click Element   //*[@id="SaveButton"and @type="button"]
    Click On  text=OK
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'First Name is a required field')]
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Last Name is a required field')]
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Email Address is a required field')]
    [Teardown]  Go Back To The HomePage

Add an user and Update Profile First/Last Name
    [Tags]  JIRA:BOT-487  JIRA:BOT-1454  JIRA:BOT-1451  JIRA:BOT-1961  qTest:30747237  Regression  tier:0  refactor
    [Documentation]  Successfully creating an user, editing first name and last name in the profile
    ...  and deleting the user at the end to avoid 'User already exists' error
    [Setup]  Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Go To User Administration > Manage Users
    Click Button  CreateUser
    Input Text  user.userId  Automation
    Input Text  user.userFname  Robot
    Input Text  user.userLname  Automation
#    NO LONGER ON SCREEN
#    Input Text  user.userPasswd  Auto2468
#    Input Text  user.userPasswd2  Auto2468
    Input Text  user.notifyEmail  test@test.com
    Click Element   //*[@id="SaveButton"and @type="button"]
    Click On  text=OK
    Page Should Contain  Successfully created new User ID
    Go To User Administration > Manage Users
    Click Element  //*[@*][1]/descendant::*[text() = "Automation"]/parent::*/descendant::*[@name="LoadProfile"]
    ${Fname}=  get text  user.userFname
    ${Lname}=  get text  user.userLname
    Input Text  user.userFname  TCH123
    Input Text  user.userLname  TCH123
    Click Button  SaveProfile
    Page Should Contain  Profile information updated successfully
    [Teardown]  Run Keywords  Teardown
    ...  AND  Close Browser

Group ID Already Created
    [Tags]  JIRA:BOT-480
    [Documentation]  System should not allow a duplicate group ID
    [Setup]  Open eManager  ${carrier.member_id}  ${carrier.password}
    Go To User Administration > Manage Groups
    Click Button  createGroup
    Input Text  group.id.groupId  COMPANY_ADMIN
    Input Text  group.groupDesc   RobotTesting
    Click Button  saveGroup
    Page Should Contain  The Group ID has already been created. Please try a different one.
    [Teardown]  Close Browser

Invalid Group Description
    [Tags]  JIRA:BOT-600  refactor
    [Documentation]  To validate that an error message appears for an invalid group description
    [Setup]  Open eManager  ${carrier.member_id}  ${carrier.password}

    Go To User Administration > Manage Groups

    # EDIT GROUP WITH INVALID GROUP DESCRIPTION
    Click On  /descendant::input[@name="editGroup"][7]
    Input Text  //input[@name="group.groupDesc"]  WrongDesc!!!!!!
    Click Button  Update

    # EXPECTED RESULT
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'is not a valid Group Description')]
    [Teardown]  Close Browser

Profile First and Last Name Required
    [Tags]  JIRA:BOT-577
    [Documentation]  Validate that the an error appears for an not entering a first and last name.
    [Setup]  Open eManager  ${carrier.id}  ${carrier.password}

    Go To User Administration > Manage Users

    # edit user profile without Username and Password
    Click On  LoadProfile
    Clear Element Text  user.userFname
    Clear Element Text  user.userLname
    Click Button  Update

    # Expected Result
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'First Name is a required field')]
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Last Name is a required field')]
    [Teardown]  Close Browser

Profile Update Landing Page
    [Tags]  JIRA:BOT-490  refactor
    [Documentation]  Validate that a user can update the landing page for another user.
    Set Test Variable  ${user}  146567
    ${passswd}  Get Carrier Password  146567

    Open eManager  ${user}  ${passswd}
    Wait Until Page Contains Element  //*[contains(text(), 'ZIG ZAG EXPRESS LLC2')]  timeout=20
    Go To User Administration > Manage Users
    ${userID}=  get text  //table[@id='user']//tbody//td[contains(text(), 'thanos')]//parent::tr//td[1]
    Click Element  //table[@id='user']//tbody//td[contains(text(), 'thanos')]//parent::tr//td[6]

    Get Into DB  MYSQL
    ${query}=  catenate
    ...     SELECT r.role_desc FROM sec_role r, sec_user_role_xref x WHERE x.role_id = r.role_id AND x.user_id = '${userID}'
    ...     UNION
    ...     SELECT r.role_desc FROM sec_role r, sec_user_group_xref x, sec_role_group_xref gx WHERE r.role_id = gx.role_id
    ...     AND x.group_id = gx.group_id AND x.company_id = gx.company_id AND x.user_id = '${userID}'  ORDER BY role_desc ASC
    ${role_results}=  Query And Strip To Dictionary  ${query}

    Should Be Equal As Strings  ${role_results['role_desc'][0]}  Allow Card Override
    Should Be Equal As Strings  ${role_results['role_desc'][1]}  Allowed Contracts
    Should Be Equal As Strings  ${role_results['role_desc'][2]}  Allowed Policies

    Select From List By Value  user.userLanding  /cards/MoneyCodeManagement.action
    Click Element  SaveProfile

    Log into eManager  ${userID}  Snap1234
    Page Should Contain Element  //*[@class="mainmenu"]//*[contains(text(), 'Money Code Management')]
    [Teardown]  Close Browser

User Not Assigned to Group
    [Tags]  JIRA:BOT-505  refactor
    [Documentation]  To validate adding a user and assigning to a group.
    [Setup]  Run Keywords
    ...      Set Test Variable  ${sub_user}  R2D2
    ...      AND  Get Into DB  MySQL
    Open eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To User Administration > Manage Users
    Add User to Group  ${sub_user}  -- NONE --
    Wait Until Page Contains Element  //select[@name="selectedRoles"]/option
    ${permission_count}  Get Element Count  //select[@name="selectedRoles"]/option
    ${random_permission_index}  Evaluate  random.randint(1, ${permission_count})  random
    ${permission}  Get Text  //select[@name="selectedRoles"]/option[${random_permission_index}]
    Select From List By Label  name=selectedRoles  ${permission}
    Click Button  name=addRole

    get into db  mysql

#    Assert Results
    ${query}  Catenate  SELECT r.role_desc
    ...                 FROM sec_role r, sec_user_role_xref x
    ...                 WHERE x.role_id = r.role_id
    ...                 AND x.user_id = '${sub_user}'

    ${role_desc}  Query And Strip  ${query}
    ${query}  Catenate  SELECT * FROM sec_user WHERE user_id = '${sub_user}'
    ...                 AND company_id in (SELECT company_id FROM sec_user WHERE user_id = '${validCard.carrier.member_id}')
    ${output}  Query And Strip To Dictionary  ${query}
    TCH LOGGING  ${query}  INFO

    ${expire_date}  getdatetimenow  %Y-%m-%d  days=30
    ${create_date}  getdatetimenow  %Y-%m-%d

    Should Be Equal  ${output['user_id']}  ${sub_user}
    Should Be Equal  ${output['status_id']}  A
    Should Be Equal  ${output['user_fname']}  El
    Should Be Equal  ${output['user_lname']}  Robot
    Should Not Be Empty  ${output['user_passwd']}
    Should Be Equal as Strings  ${output['create_date']}  ${create_date}
    Should Be Equal  ${output['locale']}  en_US
    Should Be Equal  ${output['user_landing']}  /cards/Index.action

    [Teardown]  Run Keywords
    ...  go to  ${emanager}/security/ManageUsers.action
    ...  AND  Delete User ${sub_user}
    ...  AND  Close Browser

Delete Carrier ID User
    [Tags]  JIRA:BOT-524  refactor
    [Documentation]  To validate that an error message appears for trying to delete the Carrier ID User for a carrier company
    [Setup]  Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Go To User Administration > Manage Users
    Click Element  //table[@id='user']//tbody//td[contains(text(), 'DO NOT CHANGE IT')]//parent::tr//td[10]
    Handle Alert
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'You are not authorized to modify user ${validCard.carrier.member_id}}')]
    [Teardown]  Close Browser

Profile Update Locale
    [Tags]  JIRA:BOT-498  refactor
    [Documentation]  Validate that the locale can be updated for a user.
    [Setup]  Open eManager  ${carrier.member_id}  ${carrier.password}
    Go To User Administration > Manage Users
    Click Element  //table[@id='user']//tbody//td[contains(text(), 'socorro')]//parent::tr//td[6]
#    CHECK CURRENT LOCALE ON THE DB
    Get Into DB  MYSQL
    ${query}=  catenate  SELECT locale FROM sec_user WHERE user_id = 'socorrojesus'
    ${locale}=  Query And Strip  ${query}
    Tch Logging  CURRENT LOCALE:${locale}
#    CHANGING LOCALE
    Select From List By Value  user.locale.localeId  es_US
    Click Button  SaveProfile
#    CHECK THAT THE LOCALE WAS CHANGED
    ${query_1}=  catenate  SELECT locale FROM sec_user WHERE user_id = 'socorrojesus'
    ${NEW_locale}=  Query And Strip  ${query_1}
    Tch Logging  CURRENT LOCALE:${NEW_locale}
#    PUT LOCALE BACK TO THE ORIGINAL VALUE
    ${query_2}=  catenate  UPDATE sec_user SET locale = '${locale}' WHERE user_id = 'socorrojesus';
    Execute Sql String  ${query_2}
    Tch Logging  LOCALE IS BACK THE IT ORIGINAL VALUE!
    [Teardown]  Close Browser

Profile Retype Password Required
    [Tags]  JIRA:BOT-513  deprecated
    [Documentation]  Validate the error message for not entering a retype password.
    [Setup]  Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    ${userId}  Set Variable  socorrojesus

    Go To User Administration > Manage Users
    Click Element  //table[@id='user']//td[text()='${userId}']/parent::tr/td/form/input[@name='LoadProfile']

#Input and Save Values for Test Execution
    Input Text  //input[@name='user.userPasswd']  asdfghjk123
    Click Element  //input[@value='Change Password']

#Validate Error Message
    Element Should Contain  //div[@class='errors']//li  The userid or password you entered cannot be empty.
    [Teardown]  Close Browser

Profile Change Password
    [Tags]  JIRA:BOT-611  deprecated
    [Documentation]  Validate that a user can change their password.

#Setup for Test Case
    Get Into DB  MYSQL
    ${userId}  Set Variable  robottest
    ${random}  Generate Random String  2  [NUMBERS]
    ${newPassword}  Catenate  Letmein${random}

#Open eManager, navigate to Manage Users and Select a User
    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To User Administration > Manage Users
    Click Element  //table[@id='user']//td[text()='${userId}']/parent::tr/td/form/input[@name='LoadProfile']

#Input and Save Values for Test Execution
    Input Text  user.userPasswd  ${newPassword}
    Input Text  user.userPasswd2  ${newPassword}
    Click Element  //input[@value='Change Password']

#Check if Password was Updated
    Element Should Contain  //*[@class="messages"]  Your password has been successfully changed.

#Logout
    Click Element  //a[contains(text(),'Logout')]

#Login and Verify if Password was Changed Through eManager
    Input Text  userId  ${userId}
    Input Password  password  ${newPassword}
    Click Element  logonUser
    Element Should Contain  //td[@class='mainmenu']  Logged in as: ${userId}

    get into db  mysql  ${ENVIRONMENT}
#Verify if Password was Changed Through DB
    ${today}  GetDateTimeNow  %Y-%m-%d
    Row Count Is Equal to X  SELECT * FROM sec_user WHERE user_id='${userId}' AND passwd_updated = '${today}'  1
    [Teardown]  Go Back To The HomePage

Reset Password for Carrier ID User ID
    [Tags]  JIRA:BOT-584  JIRA:BOT-1961  refactor
    [Documentation]  To validate that an error message appears for trying to reset the password for
    ...  a Carrier ID User for a carrier company.

#Open eManager, navigate to Manage Users and Select a User
    Log into eManager  103866taco  abc1234
    Go To User Administration > Manage Users
    page should not contain element  //*[text()='103866']/..//input[@name='ResetPassword']
    Click Element  //*[text()='103866']/..//input[@name='LoadProfile']
    Page Should Contain  text=** Please contact your Account Manager if you need to change your password.
    [Teardown]  Go Back To The HomePage

Add User Permission
    [Tags]  JIRA:BOT-571  tier:0
    [Documentation]  Validate adding a role to an user.

    Get Into DB  MYSQL
    ${userId}  Set Variable  socorrojesus

#Open eManager, Navigate to Manage Users, Select an User and Enter on Permissions
    Open eManager  ${carrier.member_id}    ${carrier.password}
    Go To User Administration > Manage Users
    Click Element  //table[@id='user']//td[text()='${userId}']/parent::tr/td/form/input[@name='ManageRoles']

#Select, Add a Permission and Treat Values for Test Execution
    ${permission}  Get Value  //option[1]
    ${permissionText}  Get Text  //option[1]
    ${permissionText}  split string  ${permissionText}  >
    ${permissionText}  get substring  ${permissionText[0]}  0  -4
    Click Element  //option[1]
    Click Element  addRole

#Verify on Screen if Permission are Added
    Element Should Contain  //*[@class="messages"]  Successfully added new user permission ${permission}
    TCH Logging  \nSuccessfully added new user permission ${permission}

#Verify on DB if Permission are Added
    ${sql}  catenate  SELECT r.role_id, r.role_desc, x.menu_visible FROM sec_role r, sec_user_role_xref x
    ...  WHERE x.role_id = r.role_id
    ...  AND x.user_id = '${userId}' AND x.role_id = '${permission}'
    Row Count Is Equal to X  ${sql}  1

#Remove Permission
    Click Element  //table[@id='xref'][1]//td[contains(normalize-space(),'${permissionText}')]/parent::tr/td/form/input[@name='removeRole']
    Handle Alert

#Verify on Screen if Permission are Removed
    Element Should Contain  //*[@class="messages"]  Successfully removed user permission ${permissionText}
    TCH Logging  \nSuccessfully removed user permission ${permissionText}
    [Teardown]  Close Browser

Remove User Permission
    [Tags]  JIRA:BOT-606  tier:0  refactor
    [Documentation]  Validate removing a role to an user.

    Get Into DB  MYSQL
    ${userId}  Set Variable  socorrojesus

#Open eManager, Navigate to Manage Users, Select an User and Enter on Permissions
    Open eManager  ${carrier.member_id}    ${carrier.password}
    Go To User Administration > Manage Users
    Click Element  //table[@id='user']//td[text()='${userId}']/parent::tr/td/form/input[@name='ManageRoles']

#Select, Add a Permission and Treat Values for Test Execution
    ${permission}  Get Value  //option[1]
    ${permissionText}  Get Text  //option[1]
    ${permissionText}  split string  ${permissionText}  >
    ${permissionText}  get substring  ${permissionText[0]}  0  -4
    Click Element  //option[1]
    Click Element  addRole

#Remove Permission
    Click Element  //table[@id='xref'][1]//td[contains(normalize-space(),'${permissionText}')]/parent::tr/td/form/input[@name='removeRole']
    Handle Alert

#Verify on Screen if Permission are Removed
    TCH Logging  Successfully removed user permission ${permissionText}
    Element Should Contain  //*[@class="messages"]  Successfully removed user permission ${permissionText}

#Verify on DB if Permission are Removed
    ${sql}  catenate  SELECT r.role_id, r.role_desc, x.menu_visible FROM sec_role r, sec_user_role_xref x
    ...  WHERE x.role_id = r.role_id
    ...  AND x.user_id = '${userId}' AND x.role_id = '${permission}'
    Row Count Is Equal to X  ${sql}  0
    [Teardown]  Close Browser

User Assign and Remove from Group
    [Tags]  JIRA:BOT-517  tier:0  refactor
    [Documentation]  To validate that an user can be assigned to a group and removed from a group.

    Get Into DB  MYSQL
    ${userId}  Set Variable  robottest

#Open eManager, Navigate to Manage Users, Select an User and Enter on Permissions
    open emanager  ${carrier.member_id}    ${carrier.password}
    Go To User Administration > Manage Users
    Double Click Element  //table[@id='user']//td[text()='${userId}']/parent::tr/td/form/input[@name='ManageGroups']

#Add a Group to an User
    ${group}  Get Value  //option[1]
    log to console  ${group}
    ${groupText}  Get Text  //option[1]
    log to console  ${groupText}
    Click Element  //option[1]
    Click Element  addGroup

#Check if Group was Added
    Element Should Contain  //*[@class="messages"]  Successfully added user to group

#Verify on DB if Group was Added
    ${sql}  Catenate  SELECT g.group_desc FROM sec_group g, sec_user u, sec_user_group_xref ugx
    ...  WHERE ugx.company_id = g.company_id AND ugx.group_id = g.group_id
    ...  AND u.company_id = ugx.company_id AND u.user_id = ugx.user_id
    ...  AND u.user_id = '${userId}' AND group_desc = '${groupText}'
    Row Count Is Equal to X  ${sql}  1

#Remove Group from an User
    Click Element  //option[@value='${group}']
    Click Element  removeGroup

#Check if Group was Removed
    Element Should Contain  //*[@class="messages"]  Successfully removed user from group ${group}

    get into db  mysql  ${ENVIRONMENT}
#Verify on DB if Group was Removed
    ${sql}  Catenate  SELECT g.group_desc FROM sec_group g, sec_user u, sec_user_group_xref ugx
    ...  WHERE ugx.company_id = g.company_id AND ugx.group_id = g.group_id
    ...  AND u.company_id = ugx.company_id AND u.user_id = ugx.user_id
    ...  AND u.user_id = '${userId}' AND group_desc = '${groupText}'
    Row Count Is Equal to X  ${sql}  0
    [Teardown]  Close Browser

Update Group Parameters
    [Tags]  JIRA:BOT-622  refactor
    [Documentation]  Edit Group Parameters.

    Get Into DB  MYSQL
    ${groupId}  Set Variable  test
    ${parameter}  Set Variable  MAXIMUM
    ${randomValue}  Generate Random String  4  [NUMBERS]

#Open eManager, Navigate to Manage Groups, Select an User and Enter on Permissions
    Open eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To User Administration > Manage Groups
    Click Element  //table[@id='manageGroupsTable']//td[text()='${groupId}']/parent::tr/td/form[@action='/security/ManageGroupRoles.action']/input[@name='editGroup']

#Select a Permission and Treat Values for Test Execution
    ${permissionText}  Get Text  //option[1]
    Click Element  //table[@id='xref'][1]//td[contains(normalize-space(),'Cash Advance')]/parent::tr/td/form/input[@name='editParamValue']
    Click Element  //table[@id='paramRow']//td[contains(normalize-space(),'${parameter}')]/parent::tr/td/input[@name='editValue']
    Input Text  newValue  ${randomValue}
    Click Element  saveValue

#Check if Password was Updated
    Element Should Contain  //*[@class="messages"]  Successfully Edited Value (${randomValue}) to the Parameter ID (${parameter}) .

#Verify on DB if Values Matches
    ${sql}  catenate  SELECT * FROM sec_group_role_param
    ...  WHERE company_id = (select company_id from sec_user WHERE user_id = '${validCard.carrier.member_id}}')
    ...  AND role_id = 'CASH_ADVANCE'
    ...  AND group_id = '${groupId}' AND param_value = '${randomValue}'
    Row Count Is Equal to X  ${sql}  1
    [Teardown]  close browser

Group Remove Permission
    [Tags]  JIRA:BOT-639  refactor
    [Documentation]  Validate removing a role from a group.

    Get Into DB  MYSQL
    ${groupId}  Set Variable  test

#Open eManager, Navigate to Manage Groups, Select an User and Enter on Permissions
    Open eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To User Administration > Manage Groups
    Click Element  //table[@id='manageGroupsTable']//td[text()='${groupId}']/parent::tr/td/form[@action='/security/ManageGroupRoles.action']/input[@name='editGroup']

#Select, Add a Permission and Treat Values for Test Execution
    ${permissionText}  Get Text  //option[1]
    Click Element  //option[1]
    Click Element  addRole

#Remove Permission
    Click Element  //table[@id='xref'][1]//td[contains(normalize-space(),'${permissionText}')]/parent::tr/td/form/input[@name='removeRole']
    Handle Alert

#Verify on DB if Permission are Removed
    Sleep  1
    ${sql}  catenate  SELECT r.role_desc FROM sec_role r, sec_role_group_xref gx, sec_user u WHERE r.role_id = gx.role_id
    ...  AND gx.group_id = '${groupID}' AND u.company_id = gx.company_id
    ...  AND u.user_id = '${validCard.carrier.member_id}}' AND r.role_desc = '${permissionText}'
    Row Count Is Equal to X  ${sql}  0
    [Teardown]  close browser

Reset Secure Entry Code
    [Tags]  JIRA:BOT-163  qTest:28813397  JIRA:BOT-1961  Regression  refactor
    [Documentation]  Check to make sure Account Managers can reset secure entry codes.
    [Setup]  Secure Entry Code Setup  Y  InternRobot  ${validCard.carrier.member_id}
    Get Into DB  TCH
    Set Test Variable  ${email}  efs.testers@efsllc.com
    Set Test Variable  ${expected_message}  Logged in as: ${validCard.carrier.member_id}
    open browser to emanager
    log into emanager  ${intern}  ${internPassword}  ${False}
    Input Secure Entry Code  ${intern}  @{internCode}
    Go To User Administration > Manage Users
    Input Text  name=searchValue  ${validCard.carrier.member_id}
    Click Button  searchUsers
    Click Element  xpath=//*[@value='${validCard.carrier.member_id}']//following-sibling::*[@name='LoadProfile']
    Click Button  name=resetPasscode
    Click Element  //a[contains(@href,'Logon.action?logoffUser')]
    Input Text  name=userId  ${validCard.carrier.member_id}
    get into db  tch
    Input Text  name=password  ${validCard.carrier.password}
    Click Button  name=logonUser
    Input Secure Entry Code  ${validCard.carrier.member_id}  @{internCode}
    Input Secure Entry Code  ${validCard.carrier.member_id}  @{internCode}
    Wait Until Element Is Visible  //span[contains(text(),"Logged in as")]  timeout=10
    ${text}  Get Text  //span[contains(text(),"Logged in as")]
    Should Be Equal  ${text}  ${expected_message}
    [Teardown]  Run Keywords  Secure Entry Code Setup  N  InternRobot  ${validCard.carrier.member_id}
    ...  AND  Close Browser

Group ID Required
    [Tags]  JIRA:BOT-580
    [Documentation]  To validate that an error message appears when not entering a group id
    [Setup]  Open eManager  ${carrier.member_id}  ${carrier.password}
    Go To User Administration > Manage Groups
    Click Button  Add Group

    # save a new group without Group Id
    Clear Element Text  //input[@name="group.id.groupId"]
    Input Text  //input[@name="group.groupDesc"]  Test Description
    Click Element  //*[@name="saveGroup" and @type="submit"]

    # Expected Result
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Group ID: is a required field')]
    [Teardown]  close browser

Group Description Is Required
    [Tags]  JIRA:BOT-621
    [Documentation]  To validate that an error message appears when not entering a group description.
    [Setup]  Open eManager  ${carrier.member_id}  ${carrier.password}
    Go To User Administration > Manage Groups
    Click Element  createGroup

    #Set Values for Test Execution
    ${randomValue}  Generate Random String  4  [NUMBERS]
    Input Text  group.id.groupId  ${randomValue}
    Click Element  saveGroup

#Validate Error Message
    Element Should Contain  //div[@class='errors']//li  Group Description: is a required field
    [Teardown]  close browser

DefaultCurrencyForShell
    [Tags]  JIRA:BOT-688
    [Documentation]  Ensure the wording in the Profile for Web Emanager for the new Triton Customer Type is correct.
    [Setup]  Run Keywords
    ...      Set Test Variable  ${user}  566055
    ...      AND  Set Test Variable  ${expected_message}  ** Please contact our customer service at 1-800-661-2278 if you need to change your password
    ...      AND  Get Into DB  SHELL
    ${pass}  Query And Strip  SELECT passwd FROM member WHERE member_id = ${user}

    Change Company Header  ${user}    type_id=TRITON    company_header=triton_slapshot

    Open eManager  ${user}  ${pass}  ChangeCompanyHeader=${False}
    Click Element  //a[contains(@href, 'ManageUsers.action?LoadProfile')]
    ${value}  Get Text  //tr[@class="error"]/td
    Should Be Equal As Strings  ${value}  ${expected_message}
    [Teardown]  Close Browser

Work in Behalf of Another User
    [Tags]  JIRA:BOT-674  refactor
    [Documentation]  Make sure you can select someone and work in behalf of them and stay logged in as them until you select
    ...     "Clear Current User" and once you clear it you can go to your own menus without it changing back to working in
    ...     behalf of the user you were working with previously.
#   KEYWORD THAT DEACTIVATES THE PASSWD PAD
    Set Test Variable  ${email}  efs.testers@efsllc.com
    Set Test Variable  ${expected_message}  Working as: 103866

#   OPENING EMANAGER
    Open eManager  ${intern}  ${internPassword}
    Go To User Administration Then Customer Info Test
    Select From List By Value  searchType  1
    Input Text  searchValue  103866
    Click Element  SearchCustomers
    Click Element  //*[@id="searchCustomerTable"]/tbody/tr/td[1]/a[text()='103866']
    ${working_carrier}  get text  //*[@class="mainmenu"]//tbody//tr[1]//td[2]
    ${working_carrier}  Strip My String  ${working_carrier}
    Should Contain  ${working_carrier}  ${validCard.carrier.member_id}
    Go To  ${emanager}/cards/MoneyCodeManagement.action
    Input Text  moneyCode.amount  100.00
    Input Text  moneyCode.issuedTo  Bátma
    Input Text  moneyCode.notes  nothing relevant
    Click Button  submit
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), "ERROR: Customer Service is not allowed to make changes here!")]
    Click Element  //*[@href="/security/ManageCustomers.action"]
    ${working_carrier}  get text  //*[@class="mainmenu"]//tbody//tr[1]//td[2]
    Should Contain  ${working_carrier}  ${validCard.carrier.member_id}
    Click Button  ClearCustomers
    ${original_carrier}  get text   //*[@class="mainmenu"]//tbody//tr[1]//td[2]
    Should Contain  ${original_carrier}  ${intern}
    [Teardown]  Run Keywords  Secure Entry Code Setup  N  internRobot  103866
    ...  AND  Close Browser

Create session timeout for Suspended Users
    [Tags]  JIRA:BOT-957  JIRA:BOT-2040  qTest:34905653  refactor
    [Documentation]  When eManager users status is changed to Deleted or Suspended, the user's eManager session needs to be immediately timed out following their next action.
    ...     This is particularly important in terms of fraud cases.

    #   OPEN AVENGERS CARRIER
    Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}  alias=commonCarrier
    Go To Money Codes Then Issue Money Code

    Open eManager  ${intern}  ${internPassword}  alias=internRobot
    Go To User Administration > Manage Users
    Input Text  searchValue  ${validCard.carrier.member_id}
    Click Button  searchUsers
    Click Element  //table[@id='user']//td[text()='${validCard.carrier.member_id}']/parent::tr/td/form/input[@name='LoadProfile']
    Select From List By Value  user.secUserStatus.statusId  S
    Click Button  SaveProfile

    Switch Browser  commonCarrier
    Go To  ${emanager}/cards/MoneyCodeManagement.action
    ${unauth}  get text  //*[@class="mainmenu"]
    Tch Logging  [${unauth}]
    Should be Equal As Strings  ${unauth}  Session Timeout

    [Teardown]   change user status  ${carr_id}  A
    ...  AND  Secure Entry Code Setup  N  internRobot  ${validCard.carrier.member_id}
    ...  AND  Switch Browser  commonCarrier
    ...  AND  Close Browser
    ...  AND  Switch Browser  interRobot
    ...  AND  Close Browser


Delete An Account And Try To Login
    [Tags]  BOT-1034  qTest:28814588  Regression  refactor
    [Documentation]  Validate that you can delete an user and after that you cant login on eManager.
#    LOGGING INTO EMANAGER AND CREATING AN USER
    Set Test Variable  ${avengers_carr}  146567
    ${avengers_passwd}  Get Carrier Password  ${avengers_carr}

    Open Browser to eManager
    Log into eManager  ${avengers_carr}  ${avengers_passwd}
    Go To User Administration > Manage Users
    Click Button  CreateUser
    Input Text  user.userId  AcquaBoy
    Input Text  user.userFname  WaterMera
    Input Text  user.userLname  AutomationAtItsFinest
    Input Text  user.userPasswd  abc123123
    Input Text  user.userPasswd2  abc123123
    Input Text  user.notifyEmail  test@test.com
    Click Button   SaveUser
    Page Should Contain  Successfully created new User ID

#   DELETE THE USER AND TRY TO LOGIN AGAIN
    Go To User Administration > Manage Users
    Click Element  //*[@*][1]/descendant::*[text() = "AcquaBoy"]/parent::*/descendant::*[@name="DeleteUser"]
    Handle Alert
    Page Should Contain  has been deleted from the system
    Click Link    //a[@href="/security/Logon.action?logoffUser"]
#    Log into eManager  AcquaBoy  abc123123
    Input Text  userId  AcquaBoy
    Input Password  password  abc123123
    Click Element  logonUser

    Wait Until Element Is Visible  //*[@class="errors"]//*[contains(text(),'Login Error')]  timeout=20
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(),'Login Error')]
    [Teardown]  Close Browser


Cannot Create User As Internal User
    [Tags]  JIRA:BOT-674  qTest:30196370  Regression  refactor
    [Documentation]  Make sure you cannot create an user as Internal User through Customer Info Test

#   KEYWORD THAT DEACTIVATES THE PASSWD PAD
    Set Test Variable  ${email}  efs.testers@efsllc.com
    Set Test Variable  ${expected_message}  Working as: ${validCard.carrier.member_id}
    Secure Entry Code Setup  Y  internRobot  ${validCard.carrier.member_id}

#   OPENING EMANAGER
    Open eManager  ${intern}  ${internPassword}  ${False}
    Input Secure Entry Code  ${intern}  @{internCode}
    Go To  ${emanager}//security/ManageCustomers.action
    Select From List By Value  searchType  1
    Input Text  searchValue  ${validCard.carrier.member_id}
    Click Element  SearchCustomers
    Click Element  //*[@id="searchCustomerTable"]/tbody/tr/td[1]/a[text()='${validCard.carrier.member_id}']
    Hover Over  text=Select Program
    Hover Over  text=User Administration
    Hover Over  text=Manage Users
    Click On  text=Manage Users
    Page Should Not Contain Element  btnAddNewUserToSingle


    [Teardown]  Run Keywords  Secure Entry Code Setup  N  internRobot  ${validCard.carrier.member_id}
    ...     AND  Close Browser


*** Keywords ***
Set Secure Entry Flag
    [Arguments]  ${Use}  ${Flag}
    get into db  mysql
    execute sql string  dml=update sec_company_attribute set value='${Flag}' where company_id = (select company_id from sec_user where user_id like '${Use}') and type_id = 20;

Check for Numbered Error or Error Message
    [Arguments]  ${error_message}
    ${stat}=  Run Keyword And Return Status  Element Should Be Visible  xpath=//*[contains(text(),'There was an error processing your request.')]
    run keyword and return if  ${stat}  tch logging  Numbered error was found  DEBUG

    ${stat2}=  Run Keyword And Return Status  Element Should Be Visible  xpath=//*[contains(text(),'${error_message}')]
    run keyword and return if  ${stat2}  tch logging  Error Message was found  DEBUG

    fail  Did not fine error message or numbered error

Secure Entry Code Setup
    [Arguments]  ${Flag}  @{users}
    FOR  ${user}  IN  @{users}
      set secure entry flag  ${user}  ${Flag}
   END

Add User to Group
    [Arguments]  ${user_id}  ${group_id}
    Set Test Variable  ${carrier.password}    test123
    Click Button  name=CreateUser
    Input Text  name=user.userId  ${user_id}
    Input Text  name=user.userFname  El
    Input Text  name=user.userLname  Robot
#    No Longer Valid Fields
#    Input Text  name=user.userPasswd  ${validCard.carrier.password}
#    Input Text  name=user.userPasswd2  ${validCard.carrier.password}
    Input Text  id=notifyEmail  efs.testers@efsllc.com
    Select From List By Label  name=user.locale.localeId  English U.S.
    Select From List By Value  name=groupId  ${group_id}
    Click Button   //input[@name="Save"]
    Click On  text=OK

Time to Setup

    Get Into DB  MySQL

#Get user_id from the last 10 logged to avoid mysql error.
    ${query}  Catenate  SELECT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_group_xref sugx ON su.user_id = sugx.user_id
    ...    JOIN sec_company sc on su.company_id = sc.company_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND sc.company_header NOT IN ('tch_carrier','None')
    ...    AND sugx.group_id='COMPANY_ADMIN'
    ...    AND (SELECT COUNT(*) FROM sec_user WHERE company_id=su.company_id) > 1
    ...    ORDER BY login_attempted DESC LIMIT 10;

    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT member_id FROM member
    ...  WHERE member_id IN ${list_2}
    ...  AND status='A'
    ...  AND member_id NOT IN ('103866','142195','102698','143544','100025','3000306','100045','600003','170057','4999601','303346','152676','164576','146567');  #bad carrier for this one

    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable    ${carrier}


Change User Password
    [Arguments]  ${oldpassword}  ${newpassword}
    go to  ${emanager}/security/ResetPasswordWidget.action
    Input Text  xpath=//*[@name='oldPasswd']  ${oldpassword}
    Input Text  xpath=//*[@name='passwd']  ${newpassword}
    Input Text  xpath=//*[@name='reTypePasswd']  ${newpassword}
    Click On  //*[@value='Change Password']

Close Everything
    Secure Entry Code Setup  Y  internRobot
    Disconnect from database

Delete User ${user_id}
    Click Element  xpath=//table[@id='user']//td[text()='${user_id}']/parent::tr/td/form[contains(@onclick,'Are you sure you wish to delete user Id:')]
    Handle Alert
    Element Should Be Visible  xpath=//ul[@class="messages"]/li
    ${message}  Get Text  xpath=//ul[@class="messages"]/li
    Should Be Equal  ${message}  User(${user_id}) has been deleted from the system.

Setup Carriers Can Delete Their Users
    Get Into DB  ${DB}  ${ENV}
    ${query}  Catenate  SELECT TRIM(passwd) FROM member WHERE member_id = ${CARRIER}
    ${carrier_pass}  Query And Strip  ${query}

    Set Test Variable  ${carrier_pass}

Log in
    [Arguments]  ${myusername}  ${validCard.carrier.password}

    go to  ${emanager}/security/index.jsp
    Log into eManager  ${myusername}  ${validCard.carrier.password}

update pass in db
    [Arguments]  ${CurrentPass}  ${NewPass}  ${dbVal}
    Change User Password  ${CurrentPass}  ${NewPass}
    validate password change  ${NewPass}
    get into db  tch
    execute sql string  dml=update automation SET value = '${dbVal}' WHERE identifier = '100047robot';
    log to console  automation table has been set with a value of ${dbVAl}.

validate password change
    [Arguments]  ${pssd}
    Element Should Be Visible  xpath=/html/body/pre  Password changed successfully
    log to console  ${pssd} This is the new password
    sleep  1

Validate If User ${user_id} Does Not Exist In MySQL
    Disconnect From Database
    Get Into DB  MySQL  ${ENV}
    ${query}  Catenate  SELECT * FROM teslsm.sec_user WHERE user_id = '${user_id}'
    ${count}  row count  ${query}
    Disconnect From Database
    Get Into DB  ${DB}  ${ENV}
    ${zero}  convert to number  0
    Should Be Equal  ${count}  ${zero}

Go To Create User Inside eManager
    Go To User Administration > Manage Users
    Click Button  //input[@name="CreateUser"]

Teardown
#    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To User Administration > Manage Users
    Click Element  //*[@*][1]/descendant::*[text() = "Automation"]/parent::*/descendant::*[@name="DeleteUser"]
    Handle Alert
    Page Should Contain  has been deleted from the system
    Go Back To The HomePage

Go To User Administration > Manage Users
    Go To  ${emanager}/security/ManageUsers.action

Go To User Administration > Manage Groups
    Go To  ${emanager}/security/ManageGroups.action

Go To ${menu} Then ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

    ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //*[@class="mainmenu"]/parent::*/descendant::span[1]  timeout=20
    Run Keyword IF  '${status}'=='${True}'  Tch Logging  ${menu_item} Page
    ...  ELSE  Run Keywords  Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    ...  AND  Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Go Back To The HomePage
    Go To  ${emanager}/cards/Index.action
    ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //*[@class="mainmenu"]//*[contains(text(),'Logged in as:')]  timeout=30
    Run Keyword IF  '${status}'=='${true}'  Tch Logging  HomePage of ${validCard.carrier.member_id}}
    ...  ELSE  Run Keywords  Go To  ${emanager}/cards/Index.action
    ...  AND  Wait Until Page Contains Element  //*[@class="mainmenu"]//*[contains(text(),'Logged in as:')]  timeout=30