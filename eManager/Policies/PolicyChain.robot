*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyString
Library  Collections
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup    Prepare for updating Company Attribute
Suite Teardown    Rollback Company Attribute

*** Variables ***

*** Test Cases ***
Verify Chains are filtered for Unauthorize Chains
    [Tags]    JIRA:ROCKET-200  qTest:  PI:14
    [Setup]  Find Carrier  N
    Add To Attribute to Company Header by Carrier  ${carrier.id}  Allowed Chain Ids  1,2,3,5-10
    Add To Attribute to Company Header by Carrier  ${carrier.id}  Blocked Chain Ids  1,2,3
    Login and get to Unauth chain screen
    Verify Correct Chains Display
    Verify Other Chains Dont Display
    [Teardown]  Close Browser

*** Keywords ***
Find Carrier
    [Arguments]  ${tranUpdate}
    ${sql}  Catenate    select member_id from member where mem_type = 'C' and tran_update = '${tranUpdate}' and status = 'A' limit 150
    ${memlist}  Query And Strip To Dictionary  ${sql}  db_instance=TCH
    ${memlist}  Get From Dictionary  ${memlist}  member_id
    ${memlist}  Evaluate  ${memlist}.__str__().replace('[','(').replace(']',')')
    ${sql}  Catenate  select s.user_id from sec_user s, sec_company c
    ...  where s.company_id = c.company_id
    ...  and s.user_id in ${memlist}
    ...  and c.company_header = 'pnc_carrier'
    ...  limit 1
    ${carrier.id}  Query And Strip  ${sql}  db_instance=mysql
    ${sql}  Catenate    select passwd from member where member_id = ${carrier.id}
    ${carrier.passwd}  Query And Strip  ${sql}  db_instance=tch
    Set Test Variable    ${carrier.id}
    Set Test Variable    ${carrier.passwd}

Login and get to Unauth chain screen
    Open Browser To EManager
    #need to find a carrier that is tran_update=N
    Log Into EManager  ${carrier.id}  ${carrier.passwd}  ChangeCompanyHeader=${False}

    Go To  ${emanager}/cards/PolicyChainManagement.action?policy.policyNumber=1&sitePolicy=false
    Click Button    createPolicyUnauthorizeChain

Verify Correct Chains Display
    Page Should Contain    WILCO
    Page Should Contain    SPEEDWAY
    Page Should Contain    QUIK TRIP
    Page Should Contain    KANGAROO / PANTRY
    Page Should Contain    IMPERIAL OIL

Verify Other Chains Dont Display
    Page Should Not Contain    PILOT FLYING J
    Page Should Not Contain    TA/PETRO
    Page Should Not Contain    LOVES