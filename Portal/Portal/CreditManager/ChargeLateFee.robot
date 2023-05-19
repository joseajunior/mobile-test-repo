*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Create Users
Suite Teardown  Delete Users
Force Tags  Portal  Credit Manager  weekly
Documentation  This file tests the user permission for using the Charge Late Fee option

*** Variables ***
${user_with_role}  port341_1
${user_with_group_role}  port341_2
${user_without_role_or_group}  port341_3
${user_password}  test123
${domain}  @efsllc
${credit_dept_group_id}  27
${credit_late_fee_group_id}  113
${max_iterations}  300
${carrier}  183513

*** Test Cases ***
Credit Manager - Limit Charge Late Fee Checkbox Access (user without the role and in a group without the role)
    [Tags]  JIRA:PORT-341  qTest:  Regression
    [Setup]  Open Browser And Login To Portal  ${user_without_role_or_group}${domain}  ${user_password}
    Go To Credit Manager And Select Contract  ${carrier}
    wait until done processing
    Open Fee Tab
    User Must Not Have Edit Permission
    [Teardown]  Close Browser

Credit Manager - Limit Charge Late Fee Checkbox Access (user with the role)
    [Tags]  JIRA:PORT-341  qTest:  Regression
    [Setup]  Open Browser And Login To Portal  ${user_with_role}${domain}  ${user_password}
    Go To Credit Manager And Select Contract  ${carrier}
    wait until done processing
    Open Fee Tab
    User Must Have Edit Permission
    [Teardown]  Close Browser

Credit Manager - Limit Charge Late Fee Checkbox Access (user in a group with the role)
    [Tags]  JIRA:PORT-341  qTest:  Regression
    [Setup]  Open Browser And Login To Portal  ${user_with_group_role}${domain}  ${user_password}
    Go To Credit Manager And Select Contract  ${carrier}
    wait until done processing
    Open Fee Tab
    User Must Have Edit Permission
    [Teardown]  Close Browser

*** Keywords ***
Open Browser And Login To Portal
    [Arguments]  ${user}=${PortalUsername}  ${password}=${PortalPassword}
    Open Browser to portal
    ${status}=  Log Into Portal  ${user}  ${password}
    wait until keyword succeeds  30s  5s  Log In Bandage  ${status}  ${user}  ${password}
    #TODO: remove Log In Bandage once 408 fix is implemented

Go To Credit Manager And Select Contract
    [Arguments]  ${carrier}=183513
    Set Test Variable  ${DB}  TCH
    Wait Until Page Contains Element  //*[@id="pmd_home"]  timeout=60
    Click Element  //*[@id="pmd_home"]
    Wait Until Element Is Visible  //*[text()[contains(.,"Credit Manager")]]  timeout=60
    Select Portal Program  Credit Manager
    Input Text  request.search.carrierId  ${carrier}
    Click Portal Button  Search
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  //*[@id="resultsTable"]//*[contains(text(), '${carrier}')]  timeout=120
    Double Click Element  //*[@id="resultsTable"]//*[contains(text(), '${carrier}')]


Open Fee Tab
    Wait Until Page Contains Element  //*[@name="request.contract.stmtCustomerName"]  timeout=60
    Click Element  //*[@class="jimg jfeesetup"]

User Must Not Have Edit Permission
    Element Should Be Disabled  //*[@name="__request.contract.serviceCharges" and @disabled="disabled"]

User Must Have Edit Permission
    Element Should Be Enabled  //*[@name="__request.contract.serviceCharges"]
    Click Element  //*[@name="__request.contract.serviceCharges"]

Create Users
    Open Browser And Login To Portal
    Go To Users Administration
    Delete User Cleanup  ${user_with_role}
    Create User  ${user_with_role}  ${user_password}
    Set Charge Late Fee Role
    wait until done processing
    Set Credit Dept Group
    wait until done processing
    Close Edit Page
    Delete User Cleanup  ${user_with_group_role}
    Create User  ${user_with_group_role}  ${user_password}
    Set Credit Dept Group
    wait until done processing
    Set Credit Late Fee Group
    wait until done processing
    Close Edit Page
    Delete User Cleanup  ${user_without_role_or_group}
    Create User  ${user_without_role_or_group}  ${user_password}
    Set Credit Dept Group
    wait until done processing
    Close Edit Page
    Close Browser

Delete Users
    [Timeout]  60 seconds
    Open Browser And Login To Portal
    Go To Users Administration
    wait until done processing
    Delete User  ${user_with_role}
    wait until done processing
    Delete User  ${user_with_group_role}
    wait until done processing
    Delete User  ${user_without_role_or_group}
    close all browsers

Go To Users Administration
    Wait Until Element Is Visible  //*[@id="pm_0"]  timeout=60
    Click Element  //*[@id="pm_0"]//following-sibling::*[1]
    Click Element  //*[@id="pm_1.0"]
    Wait Until Element Is Visible  //*[@id="userListTable"]  timeout=60

Create User
    [Arguments]  ${user}  ${password}
    Click Portal Button  Add
    Wait Until Done Processing
    Wait Until Element Is Visible  request.user.userid  timeout=60
    Input Text  request.user.userid  ${user}
    Input Text  request.user.name  Portal Test User
    Input Text  passwordNew  ${password}
    Input Text  _password  ${password}
    Save

Set Charge Late Fee Role
    Wait Until Element Is Visible  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Roles')]  timeout=120
    wait until element is enabled  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Roles')]  timeout=120
    Click Element  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Roles')]
    Wait Until Element Is Enabled  requestScope.userRoles[0].userid  timeout=120
    :FOR  ${i}  IN RANGE  0  ${max_iterations}
        ${status}  Run Keyword And Return Status  Page Should Contain Element  request.userRoles[${i}].roleName
        Run Keyword If  '${status}'=='${False}'  Exit For Loop
        wait until page contains element  request.userRoles[${i}].roleName  timeout=120
        ${value}=  Get Value  request.userRoles[${i}].roleName
        Run Keyword If  '${value}'=='M_CMTab_ChargeLateFee_Role'  Run Keywords
        ...  Scroll Element Into View  requestScope.userRoles[${i}].userid
        ...  AND  wait until element is visible  requestScope.userRoles[${i}].userid  timeout=30
        ...  AND  wait until element is enabled  requestScope.userRoles[${i}].userid  timeout=120
        ...  AND  Click Element  requestScope.userRoles[${i}].userid
        ...  AND  Exit For Loop
    END
    Click Element  xpath=//*[@id="userroles"]//descendant::*[contains(text(),'Save')]
    #TODO: Use Wait Until Changes are Saved keyword instead this Sleep
    Sleep  5

Set Credit Dept Group
    Wait Until Element Is Visible  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    wait until element is enabled  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    Click Element  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]
    Wait Until Element Is Enabled  requestScope.userGroups[0].userid  timeout=120
    :FOR  ${i}  IN RANGE  0  ${max_iterations}
        ${status}  Run Keyword And Return Status  Page Should Contain Element  request.userGroups[${i}].groupId
        Run Keyword If  '${status}'=='${False}'  Exit For Loop
        wait until page contains element  request.userGroups[${i}].groupId  timeout=120
        ${value}=  Get Value  request.userGroups[${i}].groupId
        Run Keyword If  '${value}'=='${credit_dept_group_id}'  Run Keywords
        ...  Scroll Element Into View  requestScope.userGroups[${i}].userid
        ...  AND  wait until element is visible  requestScope.userGroups[${i}].userid  timeout=30
        ...  AND  wait until element is enabled  requestScope.userGroups[${i}].userid  timeout=120
        ...  AND  Click Element  requestScope.userGroups[${i}].userid
        ...  AND  Exit For Loop
    END
    Click Element  xpath=//*[@id="usergroups"]//descendant::*[contains(text(),'Save')]
    #TODO: Use Wait Until Changes are Saved keyword instead this Sleep
    Sleep  5

Set Credit Late Fee Group
    Wait Until Element Is Visible  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    wait until element is enabled  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    Click Element  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]
    Wait Until Element Is Enabled  requestScope.userGroups[0].userid  timeout=120
    :FOR  ${i}  IN RANGE  0  ${max_iterations}
        ${status}  Run Keyword And Return Status  Page Should Contain Element  request.userGroups[${i}].groupId
        Run Keyword If  '${status}'=='${False}'  Exit For Loop
        wait until page contains element  request.userGroups[${i}].groupId  timeout=120
        ${value}=  Get Value  request.userGroups[${i}].groupId
        Run Keyword If  '${value}'=='${credit_late_fee_group_id}'  Run Keywords
        ...  Scroll Element Into View  requestScope.userGroups[${i}].userid
        ...  AND  wait until element is visible  requestScope.userGroups[${i}].userid  timeout=30
        ...  AND  wait until element is enabled  requestScope.userGroups[${i}].userid  timeout=120
        ...  AND  Click Element  requestScope.userGroups[${i}].userid
        ...  AND  Exit For Loop
    END
    Click Element  xpath=//*[@id="usergroups"]//descendant::*[contains(text(),'Save')]
    #TODO: Use Wait Until Changes are Saved keyword instead this Sleep
    Sleep  5

Close Edit Page
    Wait Until Element Is Visible  xpath=//*[@id="usergroups"]//descendant::*[contains(text(),'Close')]  timeout=30
    Click Element  xpath=//*[@id="usergroups"]//descendant::*[contains(text(),'Close')]

Delete User
    [Arguments]  ${user}
    Scroll Element Into View  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]
    wait until element is visible  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=120
    wait until element is enabled  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=120
    Click Element  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]
    Wait Until Element Is Enabled  //*[@id="userlist"]/a[3]  timeout=120
    Click Element  //*[@id="userlist"]/a[3]
    Wait Until Element Is Enabled  //*[@id="deleteConfirm_content"]/div[2]/a[1]  timeout=30
    Click Element  //*[@id="deleteConfirm_content"]/div[2]/a[1]
    Wait Until Page Does Not Contain  xpath=//*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=30

Save
    Wait Until Element Is Enabled  xpath=//*[@id="userdata"]/form/a[1]  timeout=60
    Click Element  xpath=//*[@id="userdata"]/form/a[1]

Delete User Cleanup
    [Arguments]  ${user}
    wait until element is enabled  //*[@id="userlist"]/form/div[3]/div[2]/input  timeout=60
    input text  //*[@id="userlist"]/form/div[3]/div[2]/input  ${user}
    click portal button  OK
    wait until done processing
    ${status}  run keyword and return status  page should not contain  No data found.
    run keyword if  '${status}'!='${False}'  click element  //*[@id="userListTable"]/tbody/tr[2]/td[2]/div/table
    run keyword if  '${status}'!='${False}'  Click Portal Button  Delete
    run keyword if  '${status}'!='${False}'  Click Portal Button  Yes