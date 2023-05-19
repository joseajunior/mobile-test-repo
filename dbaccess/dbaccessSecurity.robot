*** Settings ***
Library  RequestsLibrary
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH   ${app_ssh_host}
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../../Variables/validUser.robot

*** Test Cases ***
dbaccess Confirm strict-transport-security Exists And x-frame-options=DENY
    [Tags]  JIRA:PORT-739  JIRA:PORT740  qTest:82920048

    ${env}=  Remove String  ${environment}  aws-
    Default Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}
    Login Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}
    About/Version Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}
    Query Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}
    Data Manipulation Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}
    Tables Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}
    Data Change Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}
    Audit Page: Check strict-transport-security Exists And x-frame-options=Deny  ${env}

*** Keywords ***
Default Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${default}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/
    ${strictTransportSecurity}=  get variable value  ${default.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${default.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

Login Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${login}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/login
    ${strictTransportSecurity}=  get variable value  ${login.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${login.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

About/Version Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${about}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/about
    ${strictTransportSecurity}=  get variable value  ${about.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${about.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

Query Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${query}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/query
    ${strictTransportSecurity}=  get variable value  ${query.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${query.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

Data Manipulation Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${dataManipulation}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/dml
    ${strictTransportSecurity}=  get variable value  ${dataManipulation.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${dataManipulation.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

Tables Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${tables}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/tables
    ${strictTransportSecurity}=  get variable value  ${tables.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${tables.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

Data Change Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${dataChange}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/data_changes
    ${strictTransportSecurity}=  get variable value  ${dataChange.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${dataChange.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

Audit Page: Check strict-transport-security Exists And x-frame-options=Deny
    [Arguments]  ${env}
    ${audit}  GET  https://dbaccess.${env}.efsllc.com/webapp/index.html#/audit
    ${strictTransportSecurity}=  get variable value  ${audit.headers['Strict-Transport-Security']}
    ${xFrameOption}=  Get Variable Value  ${audit.headers['X-Frame-Options']}
    Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'  ${strictTransportSecurity}
    Verify X-Frame-Options Is 'DENY'  ${xFrameOption}

Verify Strict-Transport-Security Is 'max-age=31536000 ; includeSubDomains'
    [Arguments]  ${strictTransportSecurity}
    should be equal as strings  ${strictTransportSecurity}  max-age=31536000 ; includeSubDomains

Verify X-Frame-Options Is 'DENY'
    [Arguments]  ${xFrameOption}
    Should Be Equal As Strings  ${xFrameOption}  DENY