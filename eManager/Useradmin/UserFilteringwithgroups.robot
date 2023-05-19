*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  Collections
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager  User_Administration

*** Variables ***

*** Test Cases ***
User Filtering using groups
    [Tags]  JIRA:ROCKET-55  MANAGE_USERS  qTest:52623307
    [Documentation]  This is to test that when the necessary flag is ON,
    ...  sub users who are not company admins should only see other sub users
    ...  who share atleast one group
    [Setup]  Switch ON the flag for User Filtering
    Create three subusers and four groups
    ${pass_ONE}  Assign subusers to groups  SUBUSER_ONE  GROUP_1  GROUP_2
    ${pass_TWO}  Assign subusers to groups  SUBUSER_TWO  GROUP_2  GROUP_3
    ${pass_THREE}  Assign subusers to groups  SUBUSER_THREE  GROUP_3  GROUP_4
    Login as SUBUSER_ONE,${pass_ONE}
    Verify the user filtering  SUBUSER_ONE  SUBUSER_TWO
    Edit another SUBUSER_ONE's groups
    Verify the visible groups  GROUP_4
    Edit another SUBUSER_TWO's groups
    Verify the visible groups  GROUP_4
    Create a new subuser
    Verify that new subuser can be assigned only to certain groups  GROUP_1  GROUP_2
    Login as SUBUSER_TWO,${pass_TWO}
    Verify the user filtering  SUBUSER_ONE  SUBUSER_TWO  SUBUSER_THREE
    Create a new subuser
    Verify that new subuser can be assigned only to certain groups  GROUP_2  GROUP_3
    Login as SUBUSER_THREE,${pass_THREE}
    Verify the user filtering  SUBUSER_TWO  SUBUSER_THREE
    Edit another SUBUSER_TWO's groups
    Verify the visible groups  GROUP_1
    Edit another SUBUSER_THREE's groups
    Verify the visible groups  GROUP_1
    Create a new subuser
    Verify that new subuser can be assigned only to certain groups  GROUP_3  GROUP_4
    [Teardown]  run keywords  Delete all users and groups
    ...  AND  Switch OFF the flag for User Filtering
    ...  AND  close all browsers
    ...  AND  disconnect from database

*** Keywords ***
Switch ON the flag for User Filtering
    get into db  MYSQL
    ${companyID}  Pick a dynamic carrier
    set suite variable  ${companyID}
    ${sql}  catenate  select * from sec_company_attribute where company_id = '${companyID}' and type_id = '95'
    ${count}  row count  ${sql}
    ${sql1}  catenate  insert into sec_company_attribute values ('95','${companyID}','Y')
    run keyword if  ${count}==0  execute sql string  ${sql1}
    ${sql2}  catenate  update sec_company_attribute set value= 'Y' where company_id = '${companyID}' and type_id = '95'
    run keyword if  ${count}==1  execute sql string  ${sql2}

Switch OFF the flag for User Filtering
    get into db  MYSQL
    ${sql}  catenate  update sec_company_attribute set value= 'N' where company_id = '${companyID}' and type_id = '95'
    execute sql string  ${sql}

Pick a dynamic carrier
    Get Into DB  Mysql
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$'
     ...  AND company_id IS NOT NULL and company_id != '' ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${user_id_list}  Get From Dictionary  ${list}  user_id
    ${user_id_list}  Evaluate  ${user_id_list}.__str__().replace('[','(').replace(']',')')

    Set Suite Variable  ${user_id_list}

    ${query}  Catenate  SELECT DISTINCT(m.member_id) FROM member m
    ...     JOIN cards c ON c.carrier_id = m.member_id
    ...     JOIN transaction t ON t.card_num = c.card_num
    ...  WHERE m.status='A'
    ...  AND m.member_id between 100000 and 700000
    ...  AND t.trans_date > CURRENT - 3 units DAY
    ...  AND m.member_id IN ${user_id_list};

    ${carrier}  Find Carrier Variable  ${query}  member_id
    ${carrier}  set variable  ${carrier.id}
    Set Suite Variable  ${carrier}
    ${sql}  catenate  select company_id from sec_user where user_id = '${carrier}'
    ${companyID}  query and strip to dictionary  ${sql}
    [Return]  ${companyID['company_id']}

Create three subusers and four groups
    Open eManager  ${intern}  ${internPassword}
    Create a subuser  SUBUSER_ONE
    Create a subuser  SUBUSER_TWO
    Create a subuser  SUBUSER_THREE
    Create a group  GROUP_1
    Create a group  GROUP_2
    Create a group  GROUP_3
    Create a group  GROUP_4

Create a subuser
    [Arguments]  ${userID}
    go to  ${emanager}/security/ManageUsers.action
    select from list by label  searchType  Carrier ID
    input text  searchValue  ${carrier}
    click button  searchUsers
    sleep  1
    click button  btnAddNewUserToSingle
    wait until page contains  Create User
    input text  user.userId  ${userID}
    input text  user.userFname  SUB_ROBOT
    input text  user.userLname  USER_ROBOT
    input text  user.notifyEmail  WEXEFS-El-Robot@wexinc.com
    run keyword and ignore error  input text  user.userPasswd  tester123
    run keyword and ignore error  input text  user.userPasswd2  tester123
    click on  id=SaveButton
    run keyword and ignore error  click on  text=OK
    page should contain  Successfully created new User ID
    add user role if not exists  ${userID}  MANAGE_USERS  1

Create a group
    [Arguments]  ${groupID}
    go to  ${emanager}/security/ManageCompanies.action
    select from list by label  searchType  Carrier ID
    input text  searchValue  ${carrier}
    click button  searchCompany
    sleep  1
    click on  //*[@id='manageCompaniesTable']//*[contains(@href,'ManageGroups')]
    wait until page contains element  createGroup
    click button  createGroup
    input text  group.id.groupId  ${groupID}
    input text  group.groupDesc  ${groupID}
    click button  saveGroup
    page should contain  Successfully created new Group

Assign subusers to groups
    #Also resetting password
    [Arguments]  ${userID}  ${groupA}  ${groupB}
    go to  ${emanager}/security/ManageUsers.action
    select from list by label  searchType  User ID
    input text  searchValue  ${userID}
    click button  searchUsers
    sleep  1
    click on  ResetPassword
    page should contain  changed to
    ${pass}  get text  //*[@class='messages']
    ${pass}  get from string between 2 args  ${pass}  (  )  False
    input text  searchValue  ${userID}
    click button  searchUsers
    click on  ManageGroups
    select from list by value  inactiveGroups  ${groupA}
    click button  addGroup
    page should contain  Successfully added user to group
    select from list by value  inactiveGroups  ${groupB}
    click button  addGroup
    page should contain  Successfully added user to group
    [Return]  ${pass}

Login as ${user},${pass}
    Log into eManager  ${user}  ${pass}
    run keyword and ignore error  Handle Alert
    go to  ${emanager}/security/ManageUsers.action

Verify the user filtering
    [Arguments]  @{users}
    FOR  ${i}  IN  @{users}
      page should contain  ${i}
    END

Edit another ${user}'s groups
    go to  ${emanager}/security/ManageUsers.action
    click on  //*[@value='${user}']/following-sibling::input[@alt='Manage User Groups']

Verify the visible groups
    [Arguments]  ${group1}
    page should not contain  ${group1}

Create a new subuser
    go to  ${emanager}/security/ManageUsers.action
    Click button  CreateUser

Verify that new subuser can be assigned only to certain groups
    [Arguments]  @{exp_groups}
    ${groups}  get list items  groupId
    ${exp}  create list
    FOR  ${i}  IN  @{exp_groups}
      append to list  ${exp}  ${i}
    END
    remove values from list  ${groups}  -- None --
    lists should be equal  ${groups}  ${exp}

Delete all users and groups
    get into db  MYSQL
    execute sql string  delete from sec_user_group_xref where user_id in ('SUBUSER_ONE','SUBUSER_TWO','SUBUSER_THREE');
    execute sql string  delete from sec_group where group_id in ('GROUP_1','GROUP_2','GROUP_3');
    EXECUTE SQL STRING  delete from sec_user_role_xref where user_id in ('SUBUSER_ONE','SUBUSER_TWO','SUBUSER_THREE');
    execute sql string  delete from sec_user where user_id in ('SUBUSER_ONE','SUBUSER_TWO','SUBUSER_THREE');
