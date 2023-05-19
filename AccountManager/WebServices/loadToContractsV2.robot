*** Settings ***
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Library  otr_robot_lib.ws.CarrierGroupWS
Library  otr_model_lib.services.GenericService
Library  Collections

Force Tags  Web Services

*** Test Cases ***
Successful Add Funds to child
    [Tags]  JIRA:AUTH-1477  qTest:43580818  PI:14
    Find Parent Carrier and Child
    Load Funds to Child  ${parent_id}  ${parent_pass}  ${childcarrier}  ${childcontract}  100.00  SuccessTest${random}
    Verify Funds loaded  100.00

#TODO refactor how webservices calls to get failure response
#currently webservice will failure entire test case
#Duplicate Load Funds to child
#    [Tags]  JIRA:AUTH-1477  qTest:  PI:14
#    Find Parent Carrier and Child
#    Load Funds to Child  ${parent_id}  ${parent_pass}  ${childcarrier}  ${childcontract}  100.00  DupTest${random}
#    Load Funds to Child  ${parent_id}  ${parent_pass}  ${childcarrier}  ${childcontract}  100.00  DupTest${random}
#
#Send Amount of Trans Limit
#    [Tags]  JIRA:AUTH-1477  qTest:  PI:14
#    Find Parent Carrier and Child
#    Load Funds to Child  ${parent_id}  ${parent_pass}  ${childcarrier}  ${childcontract}  ${overmax}  MaxTest${random}

*** Keywords ***
Find Parent Carrier and Child
    ${carriersql}  Catenate  select carrier_id,parent from carrier_group_xref where effective_date < TODAY and expire_date > TODAY limit 1
    ${xref}  Query And Strip To Dictionary    ${carriersql}  db_instance=TCH
    ${contractsql}  Catenate  select contract_id from contract where carrier_id = ${xref['carrier_id']}
    ${cont}  Query And Strip  ${contractsql}  db_instance=TCH
    ${tranlimitsql}  Catenate  select trans_limit from contract where carrier_id = ${xref['parent']}
    ${tranlimit}  Query And Strip  ${tranlimitsql}  db_instance=TCH
    Set Test Variable    ${childcarrier}  ${xref['carrier_id']}
    Set Test Variable    ${childcontract}  ${cont}
    Set Test Variable    ${parent_id}  ${xref['parent']}
    ${overmax}  Evaluate  ${tranlimit} + 10
    Set Test Variable  ${overmax}
    ${random}  Generate random string  5  0123456789
    Set Test Variable    ${random}
    ${parent_pass}  Get Carrier Password    ${parent_id}
    Set Test Variable  ${parent_pass}

Load Funds to Child
    [Arguments]    ${parent}  ${parent_pass}  ${child}  ${child_cont}  ${amount}  ${ref}
    execute sql string  dml=INSERT INTO teslsm.ws_ip_access (carrier_id,ip,allowed_methods) VALUES (${parent},'10.0.0.0/8','|all|');  db_instance=mysql
     log into carrier group web services  ${parent}  ${parent_pass}
     ${code}  ${description}  ${refid}  loadToContractsV2  Robot  ${child}  ${child_cont}  ${amount}  ${ref}
     Set Test Variable  ${code}
     Set Test Variable  ${description}
     Set Test Variable  ${refid}
     execute sql string  dml=delete from ws_ip_access where carrier_id = ${parent} and ip = '10.0.0.0/8'  db_instance=mysql

Verify Funds loaded
    [Arguments]    ${amount}
    Should Be Equal As Strings  ${code}  SUCCESS
    ${sql}  Catenate    SELECT *
    ...  FROM carrier_group_xfer
    ...  where child_contract_id = ${childcontract}
    ...  and cg_xfer_id = ${refid}
    ${results}  Query And Strip To Dictionary  ${sql}  db_instance=TCH
    Should Be Equal As Strings    ${results['amount']}  ${amount}