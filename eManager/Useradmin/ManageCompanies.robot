*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
#Resource  ../../SysopVirtualKeyboard/Keywords/VirtualKeyboard.robot

Suite Setup  Time to Setup
Suite Teardown  Close Everything
Force Tags  eManager

*** Variables ***
${DB}  TCH
${ENV}  ${ENVIRONMENT}

*** Test Cases ***
Manage Company screen should not be allowed to change carrier id
    [Tags]  JIRA:BOT-948  refactor
    [Documentation]  We should not allow the carrier id to be changed in the Manage Companies screen.
    ...     It is setup as a Attribute to that company right now.
    ...     This has caused a carrier to act as another carrier.

    Set Test Variable  ${user}  internRobot
    Set Test Variable  ${passwd}  testing123
    Set Test Variable  @{PASS}  1  2  3  4
#
    Secure Entry Code Setup  Y  internRobot  146567
    Open eManager  ${user}  ${passwd}  ByPassSecureEntry=${False}
    Input Secure Entry Code  ${user}  @{PASS}
    Go To  ${emanager}/security/ManageCompanies.action
    Select From List By Value    searchType    1
    Input Text    searchValue    146567
    Click Element    searchCompany
    Click Element    //table[@id="manageCompaniesTable"]//span[contains(text(), 'TCH Carrier 146567')]/parent::td/parent::tr//a[contains(@href, '/security/ManageCompanies.action?EditCompany')]
    Input Text    companyAttributes[4].value  146#567
    Click Element    UpdateCompany
    ${carrier}  get value  companyAttributes[4].value
    Tch Logging  ${carrier}
    Should Not Be Equal  ${carrier}  146#567

    [Teardown]  Secure Entry Code Setup  N  146567

Customization of Bridgestone announcements in eManager
    [Tags]  qTest:28264552  refactor
    [Documentation]  Customization of Bridgestone announcements in eManager

    Set Test Variable  ${user}  internRobot
    Set Test Variable  ${passwd}  testing123
    Set Test Variable  @{PASS}  1  2  3  4

    Secure Entry Code Setup  Y  internRobot  146567
    Open Browser To eManager  Admin
    Log Into eManager  ${user}  ${passwd}  ByPassSecureEntry=${False}
    Input Secure Entry Code  ${user}  @{PASS}
    Go To  ${emanager}/security/ManageCompanies.action
    Select From List By Value    searchType    1
    Input Text    searchValue    146567
    Click Element    searchCompany
    Click Element    //table[@id="manageCompaniesTable"]//span[contains(text(), 'TCH Carrier 146567')]/parent::td/parent::tr//a[contains(@href, '/security/ManageCompanies.action?EditCompany')]
    Select From List By Value  company.companyHeader  bridgesFiresStone_carrier
    Click Element    UpdateCompany

    Get Into DB  TCH
    ${passwd}  Query And Strip  SELECT TRIM(passwd) AS passwd FROM member WHERE member_id=146567

    Open Browser To eManager  Avengers
    Log Into eManager  146567  ${passwd}
    Page Should Contain Element  //*[@id="f1extf" and @src="/common/html/bridgestoneAnnouncements.html"]
    Page Should Contain  Bridgestone Commercial Market Team

    Switch Browser  Admin
    Select From List By Value  company.companyHeader  efs_carrier
    Click Element    UpdateCompany


    [Teardown]  Secure Entry Code Setup  N  146567

*** Keywords ***
Time to Setup
    Get Into DB  ${DB}  ${ENV}

Close Everything
    Secure Entry Code Setup  Y  internRobot

    Disconnect from database


Secure Entry Code Setup
    [Arguments]  ${Flag}  @{users}
    FOR  ${user}  IN  @{users}
      set secure entry flag  ${user}  ${Flag}
    END

Set Secure Entry Flag
    [Arguments]  ${Use}  ${Flag}
    get into db  mysql
    execute sql string  dml=update sec_company_attribute set value='${Flag}' where company_id = (select company_id from sec_user where user_id like '${Use}') and type_id = 20;
