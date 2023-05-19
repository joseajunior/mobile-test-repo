*** Settings ***
Library  OperatingSystem
Library  Process
Library  DateTime
Library  BuiltIn
Library  otr_model_lib.services.GenericService
Library  String
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_robot_lib.ui.web.PasswordUtil  WITH NAME  PasswordUtil
Resource  ../../Variables/validUser.robot
#Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot


Suite Teardown  Teardown
Force Tags  eManager  member.verify
Documentation  This script tests call in ID and pin visibility and enablement with different permissions
...  also tests when to / not to prompt to change the call in pin

*** Variables ***
${user}  700233BD
${pass}  tester123

*** Test Cases ***

Call in ID and pin as a carrier(Company Admin)
    [Tags]  JIRA:BOT-1055  refactor
    [Documentation]  This is to test that a carrier with Manage Company role and Company Admin role
    ...  should be able to see and change the call in ID and should not be enter a new pin
    ...  but rather generate a temporary pin
    Open Browser to eManager
    Log into eManager  ${FLTCarrier}  ${FLTPassword}
    go to  ${emanager}/security/ManageUsers.action?LoadProfile
    click on  Groups
    element should be visible  //*[@name="activeGroups"]//descendant::*[text() = "Company Admin"]
    go to  ${emanager}/security/ManageUsers.action
    click element  //*[@*][1]/descendant::*[text() = "${user}"]/parent::*/descendant::*[@name="LoadProfile"]
    element should be enabled  user.callInId
    input text  user.callInId  7412
    element should be disabled  user.callInPin
    ${pin}=  get value  user.callInPin
    element should be visible  generateTemporaryPinCarrierAdmin
    click element  generateTemporaryPinCarrierAdmin
    page should contain  text=Temporary / Expires
    page should contain  text=Profile information updated successfully for (FLT_${user}).
    ${newpin}=  get value  user.callInPin
    should not be equal as strings  ${pin}  ${newpin}
    click button  SaveProfile
    log out of emanager
    close browser

Call in ID and pin as a user
    [Tags]  JIRA:BOT-1055  qTest:31032205  Regression  refactor
    [Documentation]  This is to test that the target user
    ...  should not be able to change the call in ID but should be enter a new pin
    ...  and that would be a permanent pin but masked after updating
   Open Browser to eManager
   Log into eManager  ${user}  ${pass}
   go to  ${emanager}/security/ManageUsers.action?LoadProfile
   element should be disabled  user.callInId
   element should be enabled  user.callInPin
   ${pin}=  get value  user.callInPin
   input text  user.callInPin  4782
   click button  SaveProfile
   page should not contain  text=Temporary
   ${newpin}=  get value  user.callInPin
   should be equal as strings  ${newpin}  ****
   log out of emanager
   close browser

Call in ID and pin as a Customer Info Test
    [Tags]  JIRA:BOT-1055  qTest:31036662  Regression  refactor
    [Documentation]  This is to test that a Customer service representative
    ...  should not be able to see and change the call in ID but should be enter a new pin
    ...  but it should be temporary pin
    Open Browser to eManager
    Log into eManager  ${intern}  ${internPassword}
    go to  ${emanager}/security/ManageCustomers.action
    select from list by label  searchType  User Id
    input text  searchValue  ${user}
    click button  SearchCustomers
    click link  //*[@id="searchCustomerTable"]//descendant::*[contains(text(),"${user}")]
    wait until page contains  text=Home Screen
    go to  ${emanager}/security/ManageUsers.action?LoadProfile
    element should be disabled  user.callInId
    element should be enabled  user.callInPin
    ${pin}=  get value  user.callInPin
    input text  user.callInPin  1278
    click button  SaveProfile
    page should contain  text=This is a temporary Call-In Pin/Security Code
    page should contain  text=Profile information updated successfully for (FLT_${user}).
    log out of emanager
    close browser

Call in ID and pin as a EFS Employee(also acting as Company Manager)
    [Tags]  JIRA:BOT-1055  qTest:31036665  Regression  qTest:31036701  refactor
    [Documentation]  This is to test that a EFS employee with Company Manager role
    ...  should be able to see and change the call in ID and should not be enter a new pin
    ...  but rather generate a temporary pin
    Open Browser to eManager
    Log into eManager  ${intern}  ${internPassword}
    go to  ${emanager}/security/ManageUsers.action
    select from list by label  searchType  User Id
    input text  searchValue  ${user}
    click button  searchUsers
    click element  //*[@*][1]/descendant::*[text() = "${user}"]/parent::*/descendant::*[@name="LoadProfile"]
    element should be enabled  user.callInId
    input text  user.callInId  7412
    element should be disabled  user.callInPin
    ${pin}=  get value  user.callInPin
    element should be visible  generateTemporaryPinCarrierAdmin
    click element  generateTemporaryPinCarrierAdmin
    page should contain  text=Temporary / Expires
    page should contain  text=Profile information updated successfully for (FLT_${user}).
    ${newpin}=  get value  user.callInPin
    should not be equal as strings  ${pin}  ${newpin}
    click button  SaveProfile
    log out of emanager
    close browser

Verify if call_in_pin prompts everytime pin_updated is null
    [Tags]  JIRA:BOT-1057  qTest:30739524  Regression  refactor
    [Documentation]  This is to test that the system will prompt for call_in_pin whenever pin_updated is null
    [Setup]  Setup the carrier  4
    Open eManager  ${FLTCarrier}  ${FLTPassword}
    check element exists  text=Change Temporary Pin
    input text  callInPin  7548
    click button  Update
    check element exists  text=Updated Pin Successfully!
    click button  Close
    check element exists  text=Select Program
    Log out of eManager
    close browser

Verify there will be no call_in_pin prompt once it is set
    [Tags]  JIRA:BOT-1057  qTest:30739561  Regression  refactor
    [Documentation]  This is to test that the system will not prompt for call_in_pin once the pin is set
    Open eManager  ${FLTCarrier}  ${FLTPassword}
    check element exists  text=Select Program
    Log out of eManager
    close browser

Verify there will be no call_in_pin prompt for member.verify!=4 users
    [Tags]  JIRA:BOT-1057  qTest:30740216  Regression  refactor
    [Documentation]  This is to test that the system will not prompt for call_in_pin for non verify 4 users
    ${member}=  Get a non member verify 4 user
    Open eManager  ${member['member_id']}  ${member['passwd'].strip()}
    check element exists  text=Select Program
    close browser

*** Keywords ***
Get a non member verify 4 user
    get into db  TCH
    ${member} =  query and strip to dictionary  select member_id,passwd from member where verify=1 and status = 'A' and mem_type = 'C' limit 1
    Change User Status  ${member['member_id']}  Active
    set Suite variable  ${member}
    [Return]  ${member}

Setup the carrier
    [Arguments]  ${setverify}
    get into db  TCH
    ${verify}=  query and strip to dictionary   select verify from member where member_id = ${FLTCarrier}
    set global variable  ${verify}
    execute sql string  dml=update member set verify=${setverify} where member_id = '${FLTCarrier}'
#   Setting the carrier to have an empty pin_updated and empty call in pin
    get into db  MYSQL
    execute sql string  dml=update sec_user set pin_updated=NULL, call_in_id= '1234', call_in_pin = NULL where user_id = '${FLTCarrier}';

Teardown
#    Set the verify back
    get into db  TCH
    execute sql string  dml=update member set verify='${verify['verify']}' where member_id = '${FLTCarrier}'
