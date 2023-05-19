*** Settings ***
Library  DateTime
Library  BuiltIn
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup  Open Account Manager
Suite Teardown  Close All Browsers

Documentation  This is to test that an account manager can authenticate as a user whose verify is 1,2,3 or 4
...  without any errors i.e., verify =1, use member.member_id / member.passwd
...  for verify =2, use the carr_pswd.carrier_id /carr_pswd.passwd
...  for verify=3, use member.member_id / member.passwd
...  for verify=4, use call in ID and call in PIN

*** Variables ***


*** Test Cases ***

Authenticate Caller as a member.verify-1
    [Tags]
    [Documentation]  This is to test that an account manager should be able to
    ...  authenticate as a carrier whose verify=1 using carrier ID and password
    Get Into DB  TCH
    ${info}  Query And Strip To Dictionary  SELECT member_id, TRIM(passwd) AS password FROM member WHERE status='A' AND verify='1' limit 1
    Authenticate Caller  1  ${info["member_id"]}  ${info["password"]}

    [Teardown]  Run Keywords  Go Back To Record Search
    ...  AND  Wait Until Page Contains  text=Records  timeout=20

Authenticate Caller as a member.verify-2
    [Tags]
    [Documentation]  This is to test that an account manager should be able to
    ...  authenticate as a carrier whose verify=2 using carrier ID and password from carr_pswd table

    Set Test Variable  ${DB}  TCH
    Get Into DB  ${DB}
    ${query}  catenate  SELECT member_id
    ...     FROM member
    ...     WHERE status='A'
    ...     AND mem_type='C' AND verify='2'
    ...     AND pdca_member='Y' limit 1
    ${carrier_id}  Query And Strip  ${query}

    ${carrier_info}  Query And Strip To Dictionary
    ...     SELECT passwd, name FROM carr_pswd WHERE carrier_id=${carrier_id} LIMIT 1

    Authenticate caller  2  ${carrier_id}  ${carrier_info['passwd']}  ${carrier_info['name']}
    [Teardown]  Run Keywords  Go Back To Record Search
    ...  AND  Wait Until Page Contains  text=Records  timeout=20

Authenticate Caller as a member.verify-3
    [Tags]
    [Documentation]  This is to test that an account manager should be able to
    ...  authenticate as a carrier whose verify=3 using carrier ID and password
    Get Into DB  TCH
    ${info}  Query And Strip To Dictionary  SELECT member_id, TRIM(passwd) AS password FROM member WHERE status='A' AND verify='3' limit 1
    Authenticate Caller  3  ${info["member_id"]}  ${info["password"]}

    [Teardown]  Run Keywords  Go Back To Record Search
    ...  AND  Wait Until Page Contains  text=Records  timeout=20



*** Keywords ***

Authenticate caller
    [Arguments]  ${verify}  ${CustomerID}  ${Password}  ${Holder1}=${EMPTY}
    click element  //*[contains(text(),'Authenticate')]
    wait until element is enabled  authentication.proxiedCustomerId
    input text  authentication.proxiedCustomerId  ${CustomerID}
    sleep  2
    click button  //*[@id="submit"]
    sleep  1
    run keyword if  '${verify}'=='1'  input text  authentication.password  ${Password}
    ...  ELSE IF  '${verify}'=='2'  run keywords  select from list by value  authentication.userName  ${Holder1}  AND  input text  authentication.password  ${Password}
    ...  ELSE IF  '${verify}'=='3'  run keywords  input text  authentication.eManagerUserName  ${CustomerID}  AND  input text  authentication.password  ${Password}
    ...  ELSE  run keywords  input text  authentication.callInId  ${Password}  AND  input text  authentication.callInPin  ${Holder1}
    click button  //*[@id="submit"]
    wait until page contains  text=AUTHENTICATION VIEW  timeout=30
    click element  //*[contains(text(),'End Call')]
    Run Keyword and Ignore Error  click element  //*[contains(text(),'End Call')]
    wait until page contains  text=Records  timeout=20
