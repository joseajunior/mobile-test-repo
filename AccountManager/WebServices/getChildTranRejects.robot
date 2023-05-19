*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services  tier:0

*** Test Cases ***

Validate Child Transactions Rejecteds Informations
    [Tags]  tier:0  JIRA:BOT-1585  qTest:30885943  Regression  refactor
    [Documentation]  Validate all informations returned from getChildTranRejects
    [Setup]  log into card management web services  141996  19YI30

    ${startDate}  set variable  2019-01-01
    ${endDate}  set variable  2019-04-05

    ${ChildTranRejects}  getChildTranRejects   ${startDate}  ${endDate}
    remove from dictionary  ${ChildTranRejects}  tranDate

#TODO: We are not sure which the database table is the 'tranDate'

    Check Child Transactions Rejecteds  ${ChildTranRejects}  ${startDate}  ${endDate}  141996
    [Teardown]  Logout

*** Keywords ***
Check Child Transactions Rejecteds
    [Arguments]  ${ChildTranRejects}  ${startDate}  ${endDate}  ${parentCarrier}
    Get Into DB  tch

    ${query}  Catenate
    ...  SELECT cgx.carrier_id AS carrierId,
    ...  TRIM(card_num) AS cardNum,
    ...  TRIM(invoice) AS invoice,
    ...  l.location_id AS locId,
    ...  l.name AS locName,
    ...  l.city AS locCity,
    ...  l.state AS locState,
    ...  err_code AS errorCode,
    ...  TRIM(msg) AS errorDesc
    ...  FROM tran_reject tr
    ...  LEFT JOIN carrier_group_xref cgx ON (cgx.carrier_id = tr.carrier_id)
    ...  LEFT JOIN location l ON (tr.location_id = l.location_id)
    ...  WHERE parent=${parentCarrier}
    ...  AND cgx.expire_date > TODAY
    ...  AND pos_date between '${startDate} 00:00' AND '${endDate} 00:00'
    ...  ORDER BY t_date DESC;

    ${results}  Query and Strip To Dictionary  ${query}

    ${dict_match}  compare dictionaries as strings  ${results}  ${ChildTranRejects}
    should be true  ${dict_match}