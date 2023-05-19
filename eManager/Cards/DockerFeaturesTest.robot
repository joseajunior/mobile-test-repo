*** Settings ***
Test Timeout  5 minutes
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  eManager

*** Variables ***


*** Test Cases ***
Headless Chrome - Open Browser
    [Tags]  refactor
    Open eManager  ${validCard.carrier.id}  ${validCard.carrier.password}
    [Teardown]  Close Browser

MySQL DB Test
    [Tags]  refactor
    Get Into DB  MySQL
	${user_id}  Query And Strip  SELECT user_id FROM sec_user WHERE user_id = 'internRobot'
    tch logging  ${user_id}

Oracle DB Test
    [Tags]  refactor
    Get Into DB  tch
    ${ar_number}  Query And Strip  SELECT ar_number from transaction limit 1
    Get Into DB  Oracle
    ${query}=  catenate  SELECT attribute4 FROM hz_party_sites WHERE party_site_number='${ar_number}'
	${attribute4}  query to dictionaries  ${query}
    tch logging  ${attribute4}

Informix DB Test
    [Tags]  refactor
    Get Into DB  TCH
	${user_id}  Query And Strip  SELECT member_id FROM member WHERE member_id = 103866
    tch logging  ${user_id}

robot keywords test
    [Tags]  refactor
    ${co}  Get Contract by Card Number  ${validCard.card_num}
    tch logging  ${co}

ws
    [Tags]  refactor
    log into card management web services  ${validCard.carrier.member_id}  ${validCard.carrier.password}

Using ValidUser
    [Tags]  refactor
    tch logging  ${shell_carrier}
