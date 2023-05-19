*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyMath
Library  otr_model_lib.Models
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot

Suite Setup  Time To Setup
Suite Teardown  Closure

Force Tags  eManager

*** Variables ***
${user1}  Robot1
${pw1}  Robottest1
${user2}  Robot2
${pw2}  Robottest2
${i}
${carrier}  303396
${password}  112233
${company_id}
${shell_fps_card}
${shell_fps_card_pin}

*** Test Cases ***
Emanager Landing Page should shows the correct support number for a company with Header as Fleet One Carrier
    [Tags]  JIRA:FRNT-594  qTest:42360001  tier:0  refactor
    Open Emanager and Connect into DB
    Navigate to Manage Companies
    Select Search Type "Carrier ID" and Fill up the Search Value with with Carrier ID "${FLTCarrier}" then hit Lookup Company
    Edit the Company by Changing the Company Header to "Fleet One Carrier" and Submit the changes
    Get logged in with Carrier ID "${FLTCarrier}"
    Validate on Screen that it is correctly showing "800-359-7587" as EFS customer support number
    [Teardown]  Close Browser

Emanager Landing Page should shows the correct support number for a company with Header as Fleet One Partner Carrier
    [Tags]  JIRA:FRNT-594  qTest:42360001  refactor
    Open Emanager and Connect into DB
    Navigate to Manage Companies
    Select Search Type "Carrier ID" and Fill up the Search Value with with Carrier ID "${FLTCarrier}" then hit Lookup Company
    Edit the Company by Changing the Company Header to "Fleet One Partner Carrier" and Submit the changes
    Get logged in with Carrier ID "${FLTCarrier}"
    Validate on Screen that it is correctly showing "800-359-7587" as EFS customer support number
    [Teardown]  Close Browser

Emanager Landing Page should shows the correct support number for a company with Header as Fleet One Edge Carrier
    [Tags]  JIRA:FRNT-594  qTest:42360001  refactor
    Open Emanager and Connect into DB
    Navigate to Manage Companies
    Select Search Type "Carrier ID" and Fill up the Search Value with with Carrier ID "${FLTCarrier}" then hit Lookup Company
    Edit the Company by Changing the Company Header to "Fleet One Edge Carrier"Driver landing Page and Submit the changes
    Get logged in with Carrier ID "${FLTCarrier}"
    Validate on Screen that it is correctly showing "800-359-7587" as EFS customer support number
    [Teardown]  Close Browser

Emanager Landing Page should shows the correct support number for a company with Header as Fleet One Sunoco Carrier
    [Tags]  JIRA:FRNT-594  qTest:42360001  refactor
    Open Emanager and Connect into DB
    Navigate to Manage Companies
    Select Search Type "Carrier ID" and Fill up the Search Value with with Carrier ID "${FLTCarrier}" then hit Lookup Company
    Edit the Company by Changing the Company Header to "Fleet One Sunoco Carrier" and Submit the changes
    Get logged in with Carrier ID "${FLTCarrier}"
    Validate on Screen that it is correctly showing "800-359-7587" as EFS customer support number
    [Teardown]  Close Browser


Emanager Landing Page should shows the correct support number for a company with Header as Bridgestone/Firestone Carrier
    [Tags]  JIRA:FRNT-594  qTest:42360001  refactor
    Open Emanager and Connect into DB
    Navigate to Manage Companies
    Select Search Type "Carrier ID" and Fill up the Search Value with with Carrier ID "${FLTCarrier}" then hit Lookup Company
    Edit the Company by Changing the Company Header to "Bridgestone/Firestone Carrier" and Submit the changes
    Get logged in with Carrier ID "${FLTCarrier}"
    Validate on Screen that it is correctly showing "800-359-7587" as EFS customer support number
    [Teardown]  Close Browser

Driver landing Page
    [Documentation]  Ensure regular cards have a landing page in E-manager.
    [Tags]  BOT-586  qTest:28814479  Regression  refactor
    Get Into DB  TCH
    ${query}  catenate
    ...  SELECT card_num, pin, * FROM card_pins WHERE card_num LIKE '708305%' AND status = 'A' AND valid = 'A' AND set > '2010-07-01 00:01' ORDER BY set DESC limit 1;
    ${login}  Query And Strip To Dictionary  ${query}
    tch logging  \n\n${query}

    open emanager  ${login['card_num']}  ${login['pin']}
    Go To  ${emanager}/cards/CashAdvanceReport.action

    Page Should Contain  Individual Card - One Time Cash History
    [Teardown]  Close Browser

TCHEXP Company Header
    [Tags]  JIRA:BOT-238  JIRA:BOT-2334  refactor
    [Documentation]  When a TCHEXP carrier logs into eManager for the first time, teslsm.sec_company.company_header should be "efs_carrier".

    Set Test Variable  ${partner_code}  TCH
    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${EFStemplate}  efs_template.jsp
    Set Test Variable  ${carrier_type}  efs_carrier

    Get Into DB  ${DB}
    ${info_passwd}  Query And Strip  SELECT TRIM(passwd) AS passwd FROM member WHERE member_id=${carrier}
    Open eManager  ${carrier}  ${info_passwd}
    Verify if the logo appears  ${EFStemplate}
    Validate the company_header
    Close Browser

    [Teardown]  Close Browser

SHELL Card Unsuccessful Login Setup
    [Documentation]  Looks up a SHELL card pin \n
    ...  Updates card pin \n
    ...  Uses SHELL card and pin to try to log in to eTrac \n

    [Tags]  JIRA:BOT-270, JIRA:QAT-817  Broken  refactor

    Get Into DB  SHELL
    execute sql string  dml=update card_pins SET status = 'A', valid = 'Y' WHERE card_num = ${shell_fps_card.card_num}

    Connect Ssh  ${sshconnection}  ${sshname}  ${sshpass}
    Run Command  cd /home/qaauto/el_robot
    Run Interactive Command  ./createPVV.pl
    Run Interactive Command  ${shell_fps_card.card_num}
    Run Interactive Command  ${shell_fps_card_pin}

    ${pin}  Set Variable  ${shell_fps_card_pin}

    ${newPin}=  Remove From String  Please Enter Pin:${space}  ${pin}
    Set Global Variable  ${newPin}
    Tch Logging  NewPin:${newPin}

    ${pvv}=  Remove From String  PVV is${space}  ${pin}
    Set Global Variable  ${pvv}
    Tch logging  NewPin:${pvv}

    execute sql string  dml=update card_pins SET pin = ${pvv}, atm_pin = ${newPin} WHERE card_num = '${shell_fps_card.card_num}';

    Get Into DB  SHELL
    ${pin}=  Query And Strip  select pin from card_pins where card_num = '${shell_fps_card.card_num}'
    should be equal as numbers  ${pin}  ${pvv}

    ${pin}=  query and strip  select atm_pin from card_pins where card_num = '${shell_fps_card.card_num}'
    should be equal as numbers  ${pin}  ${newPin}

#    [Teardown]  Close Browser

SHELL Card Unsuccessful Login
    [Tags]  Broken  qTest:28115662  Regression
    open automation browser  ${emanager}/security/shelllogon.jsp  ${browser}  download_folder=${default_download_path}  alias=eManager
    input text  xpath=//*[@name="userId"]  ${shell_fps_card.card_num}
    input text  xpath=//*[@name="password"]  ${shell_fps_card_pin}
    click element  xpath=//*[@name="logonUser"]
    page should contain element  xpath=//*[@class="errors"]//*[contains(text(), 'Login Error.')]
    [Teardown]  Close Browser

Invalid User ID and valid password
    [Documentation]  For an invalid user ID and valid password
    [Tags]  Regression

    Get Into DB  MySQL
    ${user_id}  Query And Strip  SELECT user_id FROM sec_user WHERE status_id='A' and user_id > 100000 ORDER BY create_date DESC limit 1
    Get Into DB  TCH
    ${info_passwd}  Query And Strip  SELECT TRIM(passwd) AS passwd FROM member WHERE member_id=${user_id}
    open emanager  ${user_id}1234  ${info_passwd}  ByPassSecureEntry=${False}
    Page Should Contain  Login Error

    [Teardown]  Close Browser

Invalid Carrier ID and valid password
    [Documentation]  For an invalid carrier ID and valid password
    [Tags]  qTest:28026048  Regression  BOT-1715  JIRA:BOT-2334

    Set Test Variable  ${DB}  TCH

    ${InvalidCarrier}  Generate Random String  8  [NUMBERS]

    Get Into DB  ${DB}
    ${info}  Query And Strip To Dictionary  SELECT member_id, trim(passwd) as passwd FROM member WHERE status='A' limit 1

    open emanager  ${InvalidCarrier}  ${info['passwd']}  ByPassSecureEntry=${False}
    Page Should Contain  Login Error


    [Teardown]  Close Browser

Valid Carrier ID and Invalid Password
    [Documentation]  To see if the E-Manager application allows for an Invalid Password to log into the system.
    [Tags]  qTest:28115662  JIRA:BOT-2334

    Open Browser To eManager
    Log into eManager  ${validCard.carrier.member_id}    5689@!$#    ByPassSecureEntry=${False}
    Page Should Contain Element  //*[contains(text(), 'You have entered an invalid password or User ID') or contains(text(), 'Login Error' )]

    [Teardown]  Close Browser

Invalid Password 5 times
    [Documentation]  For a valid user ID and invalid password for 5 times, with the 6th invalid login, acoount should be locked
    [Tags]  qTest:28116442  Regression  refactor

    TCH Logging  \n
    FOR  ${i}  IN RANGE  0  5
       Valid User ID and password  ${user2}  123456
       tch logging  Attempt ${i+1}
       close browser
    END
    Valid User ID and password  ${user2}  1234567
    tch logging  Robot2 is locked
    [Teardown]  Close Browser

Login with a security token set to send via email
    [Tags]  BOT-1028  qTest:28836865  Regression  tier:0
    [Documentation]  Validate you can login even when the security token is set to be sent via email.

    Set Test Variable  ${DB}  MYSQL

    Get Into DB  ${DB}
    ${query}  catenate  SELECT value FROM sec_company_attribute WHERE company_id = (SELECT company_id FROM sec_user WHERE user_id = ${validCard.carrier.member_id} LIMIT 1) AND   type_id = 50
    ${old_value}  Query And Strip  ${query}

    Set Suite Variable  ${old_value}

    Run Keyword If  '${old_value}'=='N'  execute sql string  dml=update sec_company_attribute SET value = 'Y' WHERE type_id = 50 AND company_id = '${validCard.carrier.member_id}'

    Open Browser to eManager
    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}

    [Teardown]  Run Keywords  Get Into DB  MYSQL
    ...     AND  execute sql string  dml=update sec_company_attribute SET value = '${old_value}' WHERE type_id = 50 AND company_id = '${validCard.carrier.member_id}'
    ...     AND  Disconnect From Database
    ...     AND  Close Browser

*** Keywords ***
Verify if the logo appears
    [Arguments]  ${template}

    Get Into DB  ${DB}
    ${query}=  query and strip  SELECT count(*) FROM instance i, carrier_instance ci WHERE i.partner_code = '${partner_code}' AND i.instance = ci.instance AND ci.carrier_id_min <= ${carrier} AND ci.carrier_id_max >= ${carrier}
    run keyword if  ${query}==1  tch logging  This is a ${partner_code} carrier.
    Wait Until Element Is Visible  //*[contains(comment(), "${EFStemplate}")]  timeout=30
    Check Element Exists  //*[contains(comment(), "${EFStemplate}")]
    tch logging  This carrier has a ${template} on the upper left-hand corner.

Validate the company_header
    Get Into DB  MySql
    Row Count Is Equal To X  SELECT * FROM sec_company WHERE company_id = (SELECT company_id FROM sec_user WHERE user_id = '${carrier}') AND company_header = '${carrier_type}'  1

Valid User ID and password
    [Arguments]  ${user}  ${pw}
    open emanager  ${user}  ${pw}
    maximize browser window
    run keyword if  '${user}'=='RobotTestUser'  page should contain  Login Error
    ...  ELSE IF    '${user}'=='143143'  page should contain  Login Error
    ...  ELSE IF    '${pw}'=='123456'  page should contain  Login Error
    ...  ELSE IF    '${user}'=='${user1}'    page should contain  Logged in as:
    ...  ELSE IF    '${user}'=='${user2}'  page should contain  Your account is locked

Closure
    [Documentation]  This is unlocking the locked user
    get into db  mysql
    ${yesterday}  getDateTimeNow  %Y-%m-%d  days=-1
    execute sql string  dml=update teslsm.sec_user set status_id = "A",passwd_fail_count = "0",update_date = DATE '${yesterday}' where user_id = "Robot2"
    tch logging  Robot2 Unlocked


Time To Setup
    get into db  tch
    ${sfps_query}=  catenate  SELECT * FROM cards
    ...    WHERE card_type = 'SHLH' AND card_num LIKE '700006%'
    ...    AND   card_num NOT LIKE '%OVER' AND   status = 'A' LIMIT 500
    ${shell_fps_card}=  find card variable  ${sfps_query}  instance=shell
    set suite variable  ${shell_fps_card}
    ${shell_fps_card_pin}  query and strip  SELECT pin FROM card_pins WHERE card_num='${shell_fps_card.num}'
    set suite variable  ${shell_fps_card_pin}

Open Emanager and Connect into DB
    open emanager  ${intern}  ${internPassword}
    Get Into DB  TCH

Navigate to Manage Companies
    Go to  ${emanager}/security/ManageCompanies.action
    Wait Until Element is Visible  name=searchCompany

Select Search Type "${searchBy}" and Fill up the Search Value with with Carrier ID "${carrierId}" then hit Lookup Company
    Wait Until Keyword Succeeds  45 sec  1 sec  Fill Up Search Form and Submit  ${searchBy}  ${carrierId}

Edit the Company by Changing the Company Header to "${newCompanyHeader}" and Submit the changes
    Wait Until Keyword Succeeds  45 sec  1 sec  Fill Up Edit Form and Submit  ${newCompanyHeader}

Fill Up Search Form and Submit
    [Arguments]  ${searchBy}  ${carrierId}
    Go to  ${emanager}/security/ManageCompanies.action
    Wait Until Element is Visible  name=searchCompany
    Select From List By label  name=searchType  ${searchBy}
    Input Text  name=searchValue  ${carrierId}
    Click Button  name=searchCompany
    Wait Until Element is Visible  //span[contains(text(),"${carrierId}")]

Fill Up Edit Form and Submit
    [Arguments]  ${newCompanyHeader}
    Click Element  //img[@title="Edit Company"]
    Wait Until Element is Visible  name=company.companyHeader
    Select From List By label  name=company.companyHeader  ${newCompanyHeader}
    Click Button  name=UpdateCompany
    Wait Until Element is Visible  //*[@class="messages"]//*[contains(text(), 'Successfully updated company')]

Get logged in with Carrier ID "${FLTCarrier}"
    Close Browser
    Open Emanager  ${FLTCarrier}  ${fltpassword}
    ${status}  run keyword and return status  Wait Until Element Is Visible  //*[@id="temporaryPin-dialog"]  timeout=30
    Run Keyword If  ${status}==${True}
    ...  Click Button  Close

Validate on Screen that it is correctly showing "${contactNumber}" as EFS customer support number
    Page Should Contain  ${contactNumber}