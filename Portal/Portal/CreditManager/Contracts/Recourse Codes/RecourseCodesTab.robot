*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  String
Library  DateTime
Library  otr_robot_lib.ui.web.PySelenium
Library  Collections

Library  otr_model_lib.Models
Resource  ../../../../Keywords/PortalKeywords.robot
Resource  ../../../../../Variables/validUser.robot
Resource  ../../../../Keywords/CreateApplicationKeywords.robot
Documentation  Checks features of the Recourse Code Tab agains the Database. Creates new user with appropriate permission and role.
...  deletes user when test is finished. This only works in AWS-DIT because required role exists there.

#TODO: fix other todos when fix for PORT-521 is implemented.

Suite Teardown  close all browsers
Suite Setup  Get in to Portal
Test Setup  Select Credit Manager and Get Contract
Test Teardown  Finish Test

*** Variables ***
####values
${aws-dit_carrier_id}=  355068
${aws-sit_carrier_id}=  355068
${user}=  port143
${user_password}=  test123
${user_domain}=  @efsllc
${max_iterations}=  300
${credit_dept_group_id}=  27
${m_cm_tab_recourse_role}=  M_CMTab_Recourse_Role
${efs_credit_dept_mgr}=  EFS Credit Dept Mgr

####locations
${carrier_id_search_box}=  xpath://*[@id="searchForm"]//descendant::*[contains(text(),'Carrier ID')]/following-sibling::div/input
${search_button}=  xpath://*[@id="searchForm"]//descendant::*[contains(text(),'Search')]/../..
${recourse_tab}=  xpath://*[contains(text(), 'Recourse Codes')]
${admin}=  xpath:/html/body/descendant::*[contains(text(), 'Admin')]
${log_out}=  xpath://*[@id="pmd_home"]/following-sibling::div/div/div[last()]
${log_out_ok}=  xpath://*[@id="confirmlogout_content"]//span[contains(@class, 'jimg jok')]
${portal_config}=  xpath://*[contains(text(),'Portal Configuration')]
#use this to find what role to manipulate
${user_id}=  xpath://*[@id="pmd_home"]/following-sibling::div
${user_id_input}=  xpath://*[@name='fUserid']
${user_data_save}=  xpath://*[@id="userdata"]//span[contains(@class, 'jimg jsave')]/../..
${domain}=  xpath://*[@name='fDomainId']
${port_config_ok}=  xpath://*[@id="userlist"]//span[contains(@class, 'jimg jok')]/../..

#roles
${role_tab_in_popup}=  xpath://*[@id="edituserListTable_content"]//span[contains(@class, 'jimg jrole')]
${role_table}=  xpath://*[@id="edituserListTable_content"]//table[contains(@containerid, 'userroles')]
${save_role_button}=  xpath://*[@id="userroles"]//span[contains(@class, 'jimg jsave')]
${close_role_button}=  xpath://*[@id="userroles"]//span[contains(@class, 'jimg jclose')]

#groups
${groups_table}=  xpath://*[@id="edituserListTable_content"]//table[contains(@containerid, 'userroles')]


*** Test Cases ***
Add Recourse Code
    [Tags]  JIRA:PORT-143  qTest:48216014  qTest:48216739
    [Documentation]  Add a single recourse code with valid inputs to editable fields and are checked in database when saved.
    ...  Added codes are deleted after test is ran.
    Add Code
    Check Data Formats
    Check Values In Table and DB
    Reset Tab

Add All Recourse Codes
    [Tags]  JIRA:PORT-143  qTest:48216579  qTest:48216739
    [Documentation]  Adds ALL the codes currently available PLUS ONE (to check the error for adding if there aren't codes available).
    ...  All codes added have same valid data added to editable fields and are checked after saved.
    ...  Added codes are deleted after test is ran.
    Add All Codes plus One
    Check Data Formats
    Check Values In Table and DB
    Reset Tab

Edit Code Values
    [Tags]  JIRA:PORT-143  qTest:48216709  qTest:48216739
    [Documentation]  Adds new codes to recourse tab and edits the editable fields with valid values
    ...  after saving the values, it checks if the values are saved to the database.
    ...  Added codes are deleted after test is ran.
    Add Code and Edit Values
    Check Data Formats
    Check Values In Table and DB
    Reset Tab

Check Invalid Inputs
    [Tags]  JIRA:PORT-143  qTest:48875449  qTest:48216739  qTest:49688386
    [Documentation]  Adds new codes to the recourse tab and edits the editable fields with invalid values
    ...  after saving the values, it checks if the values are saved to database.
    ...  Added codes are deleted after test is ran.
    Add Code and Enter Invalid Inputs
    Check Data Formats
    Check Values in Table and DB
    Reset Tab

Check Not Visible
    [Tags]  JIRA:PORT-143  qTest:48214592
    [Documentation]  At this point the new user should be logged out and you should be in robot
    ...  robot should not have the role to see this tab. KEEP THIS AS THE LAST TEST!!
    ...  Added codes are deleted after test is ran.
    ####THIS TEST IS DONE IN THE TEARDOWN, THE LOG IS HERE SO THE TC RUNS############
    log to console  a log in test case  #keep here for test to run

*** Keywords ***
Get in to Portal
    [Documentation]  The suite setup. Logs into portal, cleans up stuff, creates a new role
    ...  and adds necessary roles and groups to user. Navigates to the page where test is to execute.
    Open Browser and Login To Portal
    Select Carrier ID
    Go to User Admin and Click Portal Configuration
    Check If New User Exists
    ${status}=  Create User  ${user}  ${user_password}
    Wait Until Done Processing
    Set Group  ${credit_dept_group_id}  ${status}
    Add Role  ${m_cm_tab_recourse_role}  ${status}
    Close Edit Page
    Close Browser
    Login With New User
    Select Portal Program  Credit Manager
    Search for a Contract
    Select Contract and Get Contract ID
    Select Recourse Codes Tab
    Save Current Contracts Codes

Save Current Contracts Codes
    [Documentation]  This saves the existing contract codes if they exist. Not used currently.
    ...  This was made if we decided to add the codes back to the database because they need to be inserted.
    Wait Until Element Is Enabled  ${recourse_tab}  timeout=30
    ${count_element}=  get element count  xpath://div[contains(text(), 'No data found.')]
    return from keyword if  ${count_element}>0
    ${row_index}=  get element attribute  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  recordindex
    ${x}=  set variable  ${row_index}
    ${x}=  evaluate  ${row_index} + 1
    ${j}=  get element count  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[1]//td
    @{table_data}=  Create List

    FOR  ${tr}  IN RANGE  ${x}
        ${t_list}=  table data for loop  ${x}  ${j}
        append to list  ${table_data}  ${t_list}
        run keyword if  '${x}'=='0'  exit for loop
        ${x}=  evaluate  ${x} - 1
    END
    reverse list  ${table_data}
    set suite variable  ${table_data}  ${table_data}
    log variables

Open Browser And Login To Portal
    [Documentation]  Opens the browser and logs in the specified user
    [Arguments]  ${user}=${PortalUsername}  ${password}=${PortalPassword}
    Open Browser to portal
    ${status}=  Log Into Portal  ${user}  ${password}
    #TODO remove when 408 fix is implemented
    Wait Until Keyword Succeeds  60s  5s  Log In Bandage  ${status}  ${user}  ${password}

Go to User Admin and Click Portal Configuration
    [Documentation]  Navigates to the Portal Configuration page in Portal
    wait until element is enabled  xpath://*[@id="dtmenu"]//*//img[contains(@src, '/ThemeWeb/icon/master-card-icon.png')]/../..  timeout=60
    Mouse Over  ${admin}
    Click Element  ${portal_config}
    Wait Until Element Is Visible  ${domain}  timeout=60

Create User
    [Documentation]  Used to create a new user in Portal
    [Arguments]  ${user}  ${password}
    Sleep  2s
    Wait Until Element Is Visible  xpath://*[@id="userlist"]//span[contains(@class, 'jimg jadd')]/../..  timeout=30
    Click Element  xpath://*[@id="userlist"]//span[contains(@class, 'jimg jadd')]/../..
    Wait Until Element Is Visible  request.user.userid  timeout=60
    Input Text  request.user.userid  ${user}
    Input Text  request.user.name  CM Recourse Role Test
    Input Text  passwordNew  ${password}
    Input Text  _password  ${password}
    Wait Until Element Is Enabled  ${user_data_save}  timeout=60
    Click Element  ${user_data_save}
    sleep  5s
    ${status}=  run keyword  Check for Error
    run keyword if  ${status}==${False}  Find User Again Because Something is Busted in Portal
    [Return]  ${status}

Find User Again Because Something is Busted in Portal
    [Documentation]  don't know why but can't delete users now but it could 4/21/2021. this is here to get around that
    wait until element is visible  xpath://*[contains(text(), 'Groups')]  timeout=60
    wait until element is enabled  xpath://*[contains(text(), 'Groups')]  timeout=60
    click element  xpath://*[contains(text(), 'Groups')]
    wait until element is visible  xpath://span[contains(@class, 'jimg juser')]  timeout=60
    wait until element is enabled  xpath://span[contains(@class, 'jimg juser')]  timeout=60
    click element  xpath://span[contains(@class, 'jimg juser')]
    Wait Until Done Processing
    #wait until element is enabled  ${user_id_input}  timeout=60
    Search User in Portal Configuration

Check for Error
    [Documentation]  checks if the created user already exists displayed.
   ${status}=  run keyword and return status  page should not contain element  xpath://*[@id="error_content"][contains(text(), 'Error saving user:')]
   return from keyword if  '${status}'=='${True}'
   wait until element is enabled  xpath://*[@id="error_content"]/div[2]/a/div/span[2]  timeout=60
   click element  xpath://*[@id="error_content"]/div[2]/a/div/span[2]
   click element  xpath://*[@id="userdata"]/form/a[2]/div/span[2]
   [Return]  ${status}

Set Group
    [Documentation]  Used to set the groups in the new user.
    [Arguments]  ${group_id}  ${status}
    run keyword if  ${status}==${False}  double click element  xpath://*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]
    Wait Until Element Is Visible  xpath://*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    Wait Until Element Is Enabled  xpath://*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]  timeout=120
    Click Element  xpath=//*[@id="edituserListTable_content"]//descendant::*[contains(text(),'Groups')]
    Sleep  1s
    Wait Until Element Is Enabled  requestScope.userGroups[0].userid  timeout=120
    FOR  ${i}  IN RANGE  0  ${max_iterations}
        ${status}=  Run Keyword And Return Status  Page Should Contain Element  request.userGroups[${i}].groupId
        Run Keyword If  '${status}'=='${False}'  Exit For Loop
        Wait Until Page Contains Element  request.userGroups[${i}].groupId  timeout=120
        ${value}=  Get Value  request.userGroups[${i}].groupId
        Run Keyword If  '${value}'=='${group_id}'  Run Keywords
        ...  Scroll Element Into View  requestScope.userGroups[${i}].userid
        ...  AND  Wait Until Element Is Visible  requestScope.userGroups[${i}].userid  timeout=30
        ...  AND  Wait Until Element Is Enabled  requestScope.userGroups[${i}].userid  timeout=120
        ...  AND  click or not  requestScope.userGroups[${i}].userid  #Click Element  requestScope.userGroups[${i}].userid
        ...  AND  Exit For Loop
    END
    Click Element  xpath://*[@id="usergroups"]//descendant::*[contains(text(),'Save')]
    Sleep  5s

Click or Not
    [Documentation]  ticks the checkbox if it's not ticked.
    [Arguments]  ${checkbox}
    ${checkbox}=  catenate  ${checkbox}
    ${is_checked}=  get element attribute  ${checkbox}  checked
    run keyword if  '${is_checked}'=='${None}'  click element  ${checkbox}

Add Role
    [Documentation]  Used to add a new role to the new user
    [Arguments]  ${role_to_assign}  ${status}
    Wait Until Element Is Visible  ${role_tab_in_popup}  timeout=60
    Wait Until Element Is Enabled  ${role_tab_in_popup}  timeout=60
    Click Element  ${role_tab_in_popup}
    wait until page does not contain  'Loading user roles...'  timeout=60
    wait until element is enabled  xpath://*[@id="userroles"]//span[contains(@class, 'jimg jsave')]/../..  timeout=60
    ${autogen}=  Get Element Attribute  ${role_table}  id
    wait until page contains element  xpath://*[@id="${autogen}"]/tbody/tr[2]/td[2]/div  timeout=60
    Scroll Element Into View  xpath://*[@id="${autogen}"]//div[contains(text(), '${role_to_assign}')]/preceding::div[1]/input[@type='checkbox']
    #will be true if the element is checked
    ${checked_status}=  Get Element Attribute  xpath://*[@id="${autogen}"]//div[contains(text(), '${role_to_assign}')]/preceding::div[1]/input[@type='checkbox']  checked
    Set Suite Variable  ${checked_status}  ${checked_status}
    click or not  xpath://div[contains(text(), '${role_to_assign}')]//preceding::div[1]//input[@type='checkbox']
    Click Element  ${save_role_button}
    Sleep  5s

Save User
    [Documentation]  Used to save the new user in Portal Administration
    Wait Until Element Is Enabled  ${save_role_button}  timeout=60
    Click Element  ${save_role_button}
    Wait Until Changes are Saved

Close Edit Page
    [Documentation]  Used to close the edit page in Portal Administration
    Wait Until Element Is Visible  ${close_role_button}  timeout=30
    Click Element  ${close_role_button}

Login With New User
    [Documentation]  Used to log in with the new user credentials
    Open Browser And Login To Portal  ${user}${user_domain}  ${user_password}

Search User in Portal Configuration
    [Documentation]  Used to search for a user in Portal Configuration
    wait until page contains element  ${user_id_input}  timeout=60
    Wait Until Element Is Enabled  ${user_id_input}  timeout=60
    ${stripped_domain}=  Strip My String  ${user_domain}  characters=@
    clear element text  ${user_id_input}
    Wait Until Element Is Enabled  ${user_id_input}  timeout=60
    Input Text  ${user_id_input}  ${user}
    Select From List By Label  ${domain}  ${stripped_domain}
    Click Element  ${port_config_ok}

Check If New User Exists
    [Documentation]  Used to delete the new user if it already exists
    Search User in Portal Configuration
    sleep  1s
    ${count_element}=  get element count  xpath://div[contains(text(), 'No data found.')]
    Run Keyword If  '${count_element}'=='0'  wait until keyword succeeds  60s  5s  Delete New User
    ...  ELSE  return from keyword

Delete New User
    [Documentation]  Used to delete a user, specifically the new user
    Sleep  5s  #keep this here for pause
    wait until page contains element  xpath://*[@id="userListTable"]  timeout=60
    Wait Until Element Is Visible  xpath://*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=60
    #Sleep  2s  #keep here to add little delay
    wait until page contains element  xpath://*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]  timeout=60
    Click Element  xpath://*[@id="userListTable"]//descendant::*[contains(text(),'${user}')]
    wait until element is enabled  xpath://*[@id="userlist"]//span[contains(@class, 'jimg jdelete')]/../..  timeout=60
    Click Element  xpath://*[@id="userlist"]//span[contains(@class, 'jimg jdelete')]/../..
    Wait Until Element Is Enabled  xpath://*[@id="deleteConfirm_content"]//span[contains(@class, 'jimg jok')]/../..  timeout=60
    Click Element  xpath://*[@id="deleteConfirm_content"]//span[contains(@class, 'jimg jok')]/../..
    #sleep  1s
    wait until page contains element  xpath://*[@id="userListTable"]
    ${count_element}=  get element count  xpath://div[contains(text(), 'No data found.')]
    return from keyword if  '${count_element}'=='1'


Finish Test
    [Documentation]  The test teardown. Checks tab and deletes user on fail. Goes home on failure
    Return From Keyword If  '${TEST STATUS}'=='PASS' and '${TEST NAME}'!='Check Not Visible'
    Run Keyword If  '${TEST STATUS}'!='FAIL' and '${TEST NAME}'=='Check Not Visible'  Check for Recourse Tab and Delete New User
    Run Keyword If  '${TEST STATUS}'=='FAIL' and '${TEST NAME}'!='Check Not Visible'  restart test on fail  #Wait Until Page Contains Element  xpath://*[@id="pmd_home"]  timeout=60
    #Run Keyword If  '${TEST STATUS}'=='FAIL' and '${TEST NAME}'!='Check Not Visible'  Click Element  xpath://div[@title="Go To Home Page"]

Restart Test on Fail
    close browser
    Login With New User

#TODO: need to insert the data from the original table back in. Already have the data, need to find a way to access data in nested list
Add Original Table Data to Tab
    [Documentation]  Could be used to add the tabled data back to tab
    ${insert}=  catenate  INSERT INTO contract_recourse_cd_xref (contract_id, carrier_id, recourse_code_id, recourse_amount, expire_date, last_updated)
    ...  VALUES
    ${list_of_table_data}=  evaluate  [elem for elem in ${table_data}]

Check for Recourse Tab and Delete New User
    [Documentation]  Checks if the Recourse Tab exists and Deletes the New User
    Check for Recourse Tab
    Find and Delete New User

Check for Recourse Tab
    [Documentation]  Checks for the Recourse tab, should only be used when testing if it's not visible.
    Close Browser
    Open Browser And Login To Portal
    Select Portal Program  Credit Manager
    Search for a Contract
    Select Contract and Get Contract ID
    wait until element is visible  xpath://*[@id="creditForm"]//span[contains(@class, 'jimg jcard')]  timeout=60
    element should not be visible  ${recourse_tab}
    click element  xpath://div[@title="Go To Home Page"]

Find and Delete New User
#    Close Browser
#    Open Browser And Login To Portal
    Go to User Admin and Click Portal Configuration
    Search User in Portal Configuration
    Delete New User

Select Credit Manager and Get Contract
    Run Keyword If  '${PREV TEST STATUS}'=='FAIL'  Select Portal Program  Credit Manager
    Run Keyword If  '${PREV TEST STATUS}'=='FAIL'  Search for a Contract
    Run Keyword If  '${PREV TEST STATUS}'=='FAIL'  Select Contract and Get Contract ID
    Run Keyword If  '${PREV TEST STATUS}'=='FAIL'  Select Recourse Codes Tab
    Run Keyword If  '${TEST NAME}'!='Check Not Visible'  Reset Tab

Search for a Contract
    [Documentation]  Searches for a contract using the contract id
    Wait Until Element Is Enabled  ${carrier_id_search_box}  timeout=120
    Input Text  ${carrier_id_search_box}  ${carrier_id}
    Click Element  ${search_button}

Select Carrier ID
    [Documentation]  selects a contract id depending on environment
    ############AS IS THIS ONLY WORKS FOR AWS-DIT AND AWS-SIT#######################
    ${carrier_id}=  Set Variable If  '${ENVIRONMENT}'=='aws-dit'  ${aws-dit_carrier_id}
    ...  '${ENVIRONMENT}'=='aws-sit'  ${aws-sit_carrier_id}
    ...  ${NONE}
    Set Suite Variable  ${carrier_id}  ${carrier_id}

Select Recourse Codes Tab
    Wait Until Element Is Enabled  xpath://*[@id="accountDetail"]/div[2]/ul/li[2]  timeout=60
    Click Element  ${recourse_tab}

Select Contract and Get Contract ID
    [Documentation]  selects the correct contract and sets a the contract ar number as the suite variable
    wait until done processing
    wait until page contains element  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is enabled  xpath://*[@id="resultsTable"]  timeout=120
    ${contract_id}=  get text  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]//../following-sibling::td[2]  #//*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]/.././preceding-sibling::node()[position() < 2][self::td]
    set suite variable  ${contract_id}  ${contract_id}
    double click element  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]
    wait until done loading contract

Add Code
    [Documentation]  Used to add codes to the Recourse Tab
    [Arguments]  ${amount}=1
    Wait Until Element Is Enabled  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jadd')]/../..  timeout=60
    wait until done processing
    wait until element is enabled  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jadd')]/../..  timeout=60
    Click Element  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jadd')]/../..
    sleep  2s
    wait until element is enabled  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jcancel')]/../..  timeout=60
    ${status}=  Check for Error Popup
    return from keyword if  '${status}'=='${False}'
    Enter Amount  ${amount}
    Sleep  1s
    Save Recourse Code
    wait until element is not visible  xpath://*[@id='success']  timeout=60


Check for Error Popup
    [Documentation]  used to check if the error popup appears when adding more codes than available.
    wait until element is visible  xpath://*[@id="editcontractRecourseCodesList_content"]  timeout=60
    ${status}=  run keyword and return status  element should not contain  xpath://*[@id="editcontractRecourseCodesList_content"]//div  There are no codes to add to this contract.
    [Return]  ${status}

Check Data Formats
    [Documentation]  used to check the format of certain elements in the table in recourse tab
    Get Table Data
    ${amount_regex}=  set variable  ^\\d+\\.\\d{2}$
    ${date_regex}=  set variable  ^[0-9]{4}-[0-9]{2}-[0-9]{2}$
    ${amount_list}=  evaluate  [i[1:-2] for i in ${new_table_data}]
    ${date_list}=  evaluate  [i[2:] for i in ${new_table_data}]

    ${amount_list}=  evaluate  [num for elem in ${amount_list} for num in elem]
    ${date_list}=  evaluate  [num for elem in ${date_list} for num in elem]
    Format Checker  ${amount_list}  ${amount_regex}
    Format Checker  ${date_list}  ${date_regex}

Format Checker
    [Documentation]  loop for checking formats
    [Arguments]  ${list}  ${regex}
    FOR  ${i}  IN RANGE  len(${list})
        should match regexp  ${list}[${i}]  ${regex}
    END

Add All Codes plus One
    [Documentation]  Used when adding all the codes. Adds one more code after to check if error works too.
    Wait Until Element Is Enabled  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jadd')]/../..  timeout=60
    wait until done processing
    wait until element is enabled  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jadd')]/../..  timeout=60
    Click Element  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jadd')]/../..
    wait until element is enabled  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jsave')]/../..  timeout=60
    #wait until element is visible  xpath://*[contains(@name, 'recourseCodeId')]  timeout=60
    wait until element is visible  xpath://*[@id="editcontractRecourseCodesList"]  timeout=60
    wait until element is visible  xpath://*[contains(@name, 'recourseCodeId')]  timeout=120

    ${recourse_code_dropdown}=  get list items  xpath://*[contains(@name, 'recourseCodeId')]
    ${dropdown_length}=  get length  ${recourse_code_dropdown}
    ${x}=  set variable  ${dropdown_length}
    Click Element  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jcancel')]/../..
    FOR  ${codes}  IN RANGE  ${x}
        Add Code
        run keyword if  '${x}'=='0'  exit for loop
        ${x}=  evaluate  ${x} - 1
    END
    Add Code  #do this because all items should be added, error occurs if paths cant be found, which they shouldn't
    wait until element is enabled  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jcancel')]/../..  timeout=60
    Click Element  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jcancel')]/../..

Add Code and Edit Values
    [Documentation]  Adds codes and edits values. Edits the editable values with valid values
    @{input_options}=  create list  future  past  #adds codes for as many are in this list. these values change what happens in Edit Values
    FOR  ${i}  IN RANGE  len(${input_options})
        Add Code
        sleep  0.5s
        wait until element is not visible  xpath://*[@id='success']  timeout=60
        wait until element is visible  xpath://*[@id="contractRecourseCodesList"]  timeout=60
        wait until page contains element  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  timeout=60
        click element  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]
        click element  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jedit')]
        #sleep  10s
        wait until element is enabled  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jsave')]/../..  timeout=60
        sleep  2s
        wait until element is visible  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Code Description')]/..//select  timeout=60
        ${is_disabled}=  get element attribute  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Code Description')]/..//select  disabled
        run keyword if  '${is_disabled}'!='true'  Fail  dropdown should be disabled and it is not
        ...  ELSE  Edit Values  ${input_options}[${i}]
    END
    sleep  5s
    #wait until changes are saved

Add Code and Enter Invalid Inputs
    [Documentation]  Adds codes and edits values. Edits the editable values with invalid values.
    @{invalid_options}=  create list  date  amount  both  #adds codes for as many are in this list. The values change what happens in Edit Invalid Values
    FOR  ${i}  IN RANGE  len(${invalid_options})
        Add Code
        wait until page contains element  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  timeout=60
        wait until element is not visible  xpath://*[@id='success']  timeout=60
        wait until element is visible  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  timeout=60
        click element  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]
        click element  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jedit')]
        wait until element is enabled  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jsave')]/../..  timeout=60
        sleep  2s
        wait until element is visible  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Code Description')]/..//select  timeout=60
        ${is_disabled}=  get element attribute  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Code Description')]/..//select  disabled
        run keyword if  '${is_disabled}'!='true'  Fail  dropdown should be disabled and it is not
        ...  ELSE  Edit Invalid Values  ${invalid_options}[${i}]
    END
    sleep  5s
    #wait until changes are saved

Edit Values
    [Documentation]  Changes values to with valid inputs
    [Arguments]  ${input_option}
    Change Amount
    Change Expiration  ${input_option}
    Save Recourse Code

Save Recourse Code
    [Documentation]  saves the recourse codes in credit manager
    wait until element is enabled  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jsave')]/../..  timeout=60
    Click Element  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jsave')]/../..
    wait until element is visible  xpath://*[@id='success']  timeout=60
    wait until keyword succeeds  30s  5s  Style String Contains  xpath://*[@id='success']  none

Style String Contains
    [Arguments]  ${xpath}  ${contains}
    ${style_attribute}=  get element attribute  ${xpath}  style
    ${status}=  run keyword and return status  should be true  '${contains}' in '''${style_attribute}'''

Edit Invalid Values
    [Documentation]  uses the keywords for invalid inputs
    [Arguments]  ${options}
    run keyword if  '${options}'=='date'  Test Invalid Characters
    ...  ELSE IF  '${options}'=='amount'  Test Zero Amount
    ...  ELSE IF  '${options}'=='both'  Test Valid Input and Invalid Characters

Test Valid Input and Invalid Characters
    [Documentation]  Used for testing the valid with invalid character inputs in editable fields
    Wait Until Element Is Visible  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    Wait Until Element Is Enabled  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    ${original_amount}=  run keyword if  '${TEST NAME}' == 'Add Code'  Get Value  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input
    run keyword if  '${TEST NAME}' == 'Add Code'  Set Test Variable  ${original_amount}  ${original_amount}

    Input Valid and Invalid Characters  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input
    Input Valid and Invalid Characters  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Expiration')]/..//input
    #######until fix is implemented
    #TODO: remove this when a fix PORT-521 is implemented for the bug
    Temp Fix for Bug

Input Valid and Invalid Characters
    [Documentation]  used for invalid characters with valid inputs. catenates invalid characters to beginning and end of valid inputs.
    [Arguments]  ${path}
    ${contains_amount}=  evaluate  "Amount" in """${path}"""
    ${random_chars}=  Generate Random String  8  [LETTERS]()-+=-%^&*!@#$
    ${random_num}=  Generate Random String  2  123456789
    ${curr_value}=  get value  ${path}
    clear element text  ${path}
    ${new_string}=  run keyword if  '${contains_amount}'=='${True}'  catenate  ${random_chars}${random_num}${random_chars}
    ...  ELSE  catenate  ${random_chars}${curr_value}${random_chars}
    Input Text  ${path}  ${new_string}

Test Zero Amount
    [Documentation]  used for zero amount test
    Wait Until Element Is Visible  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    Wait Until Element Is Enabled  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    ${original_amount}=  run keyword if  '${TEST NAME}' == 'Add Code'  Get Value  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input
    run keyword if  '${TEST NAME}' == 'Add Code'  Set Test Variable  ${original_amount}  ${original_amount}
    Input Zero and Check  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input

Input Zero and Check
    [Documentation]  inputs zero to amount field and handles the appropriate error
    [Arguments]  ${path}
    clear element text  ${path}
    input text  ${path}  0
    click element  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jsave')]
    wait until element is visible  xpath://*[@id="error_content"]//span[contains(@class, 'jimg jok')]  timeout=60
    element should be visible  xpath://*[@id="error_content"]//span[contains(@class, 'jimg jok')]
    click element  xpath://*[@id="error_content"]//span[contains(@class, 'jimg jok')]
    wait until element is not visible  xpath://*[@id="error_content"]//span[contains(@class, 'jimg jok')]  timeout=60
    wait until element is visible  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jcancel')]  timeout=60
    click element  xpath://*[@id="editcontractRecourseCodesList_content"]//span[contains(@class, 'jimg jcancel')]

Test Invalid Characters
    [Documentation]  used to insert invalid characters to appropriate fields
    @{input_list}=  Create List  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Expiration')]/..//input
    Wait Until Element Is Visible  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    Wait Until Element Is Enabled  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    ${original_amount}=  run keyword if  '${TEST NAME}' == 'Add Code'  Get Value  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input
    run keyword if  '${TEST NAME}' == 'Add Code'  Set Test Variable  ${original_amount}  ${original_amount}
    FOR  ${i}  IN RANGE  len(${input_list})
        Input Characters and Check  ${input_list}[${i}]
    END
    #######until fix is implemented
    #TODO: remove this when a fix is implemented for the bug
    Temp Fix for Bug

Temp Fix for Bug
    [Documentation]  temporary fix for bug where table disappears. Can remove when a fix for PORT-521 is implemented
    Save Recourse Code
    wait until element is not visible  xpath://*[@id='success']  timeout=60
    wait until element is enabled  xpath://*[@id="contractview"]//span[contains(@class, 'jimg jrefresh')]/../..  timeout=60
    click element  xpath://*[@id="contractview"]//span[contains(@class, 'jimg jrefresh')]/../..
    wait until done loading contract
    wait until element is enabled  ${recourse_tab}  timeout=60
    click element  ${recourse_tab}

Input Characters and Check
    [Documentation]  Inputs the invalid characters to editable fields
    [Arguments]  ${path}
    ${random_chars}=  Generate Random String  8  [LETTERS]()-+=-%^&*!@#$
    ${curr_text}=  get text  ${path}
    clear element text  ${path}
    Input Text  ${path}  ${random_chars}
    should be equal  ${curr_text}  ${EMPTY}

Change Amount
    [Documentation]  Used to make valid amount for editable field
    ${rand_num}=  Generate Random String  2  123456789
    Enter Amount  ${rand_num}

Change Expiration
    [Documentation]  Inputs the expiration data into the editable field based on the data_type specified.
    [Arguments]  ${date_type}
    ${curr_date}=  run keyword if  '${date_type}'=='future'  Get Current Date  result_format=%Y-%m-%d  increment=2 days
    ...  ELSE IF  '${date_type}'=='past'  Get Current Date  result_format=%Y-%m-%d  increment=-2 days
    ...  ELSE  log to console  ${date_type}  #here because I wanted something in the else
    ${date_string}=  convert to string  ${curr_date}
    wait until element is enabled  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Expiration')]/..//input  timeout=60
    clear element text  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Expiration')]/..//input
    input text  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Expiration')]/..//input  ${date_string}


Enter Amount
    [Documentation]  Inputs the amount to editable fields to a valid amount
    [Arguments]  ${amount}
    Wait Until Element Is Visible  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    Wait Until Element Is Enabled  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  timeout=60
    ${original_amount}=  run keyword if  '${TEST NAME}' == 'Add Code'  Get Value  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input
    run keyword if  '${TEST NAME}' == 'Add Code'  Set Test Variable  ${original_amount}  ${original_amount}
    clear element text  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input
    Input Text  xpath://*[@id="editcontractRecourseCodesList_content"]/form//div[contains(text(), 'Amount')]/..//input  ${amount}

Check Values in Table and DB
    [Documentation]  compares the values in the table and database
    ${database_data}=  Get DB Data
    #log variables  #for debug purposes
    #this is using the suite variable from get table data
    lists should be equal  ${new_table_data}  ${database_data}


Get Table Data
    [Documentation]  gets the values in the recourse tab table
    Wait Until Element Is Enabled  ${recourse_tab}  timeout=30
    ${row_index}=  get element attribute  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  recordindex
    ${x}=  set variable  ${row_index}
    ${x}=  evaluate  ${row_index} + 1
    ${j}=  get element count  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[1]//td
    @{list_of_lists}=  Create List

    FOR  ${tr}  IN RANGE  ${x}
        ${data_list}=  table data for loop  ${x}  ${j}
        append to list  ${list_of_lists}  ${data_list}
        run keyword if  '${x}'=='0'  exit for loop
        ${x}=  evaluate  ${x} - 1
    END
    sort list  ${list_of_lists}
    set suite variable  ${new_table_data}  ${list_of_lists}

Table Data For Loop
    [Documentation]  Used to get and manipulate the table data
    [Arguments]  ${x}  ${j}
    @{data_list}=  create list
    FOR  ${td}  IN RANGE  ${j}
        exit for loop if  '${j}' < '0'
        ${cell}  get text  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[${x}]/td[${j}]/div
        run keyword if  '${j}'!='2'  append to list  ${data_list}  ${cell}      #removes the code description from table data for comparison
        ${j}=  evaluate  ${j} - 1
    END
    #need to be reverse when getting table data
    reverse list  ${data_list}
    [Return]  @{data_list}

Get DB Data
    [Documentation]  queries the database
    get into db  TCH
    ${query}=  catenate  SELECT
    ...  TRIM(recourse_code_id),
    ...  TO_CHAR(recourse_amount),
    ...  TO_CHAR(expire_date, '%Y-%m-%d'),
    ...  TO_CHAR(last_updated, '%Y-%m-%d')
    ...  FROM  contract_recourse_cd_xref
    ...  WHERE carrier_id = '${carrier_id}'
    ...  AND  contract_id = '${contract_id}'

    ${db_values}=  wait until keyword succeeds  2 min  30 sec  query  ${query}
    ${db_values}=  evaluate  [list(x) for x in ${db_values}]
    sort list  ${db_values}
    [Return]  ${db_values}

Reset Tab
    [Documentation]  Used to clear all codes in the Recourse Tab
    Wait Until Element Is Enabled  ${recourse_tab}  timeout=60
    wait until page contains element  xpath://*[@id="contractRecourseCodesList"]  timeout=60
    sleep  6s
    ${no_data_status}=  run keyword and return status  page should not contain  No data found.
    return from keyword if  '${no_data_status}'=='${False}'
    wait until page contains element  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  timeout=60
    ${row_index}=  get element attribute  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  recordindex
    ${x}=  set variable  ${row_index}
    ${x}=  evaluate  ${row_index} + 1

    FOR  ${tr}  IN RANGE  ${x}
        Sleep  0.5s
        Delete Codes
        run keyword if  '${x}'=='0'  exit for loop
        ${x}=  evaluate  ${x} - 1
    END

Delete Codes
    [Documentation]  deletes codes in the Recourse Tab
    wait until element is enabled  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jdelete')]/../..  timeout=60
    wait until element is visible  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]  timeout=60
    click element  xpath://*[@id="contractRecourseCodesList"]/tbody/tr[2]//tbody/tr[last()]/../..
    click element  xpath://*[@id="contractrecourse"]//span[contains(@class, 'jimg jdelete')]/../..
    wait until element is enabled  xpath://*[@id="deleteConfirm_content"]//span[contains(@class, 'jimg jok')]/../..  timeout=60
    click element  xpath://*[@id="deleteConfirm_content"]//span[contains(@class, 'jimg jok')]/../..
    wait until element is not visible  xpath://*[@id="deleteConfirm"]  timeout=60
    wait until element is enabled  ${recourse_tab}  timeout=60
