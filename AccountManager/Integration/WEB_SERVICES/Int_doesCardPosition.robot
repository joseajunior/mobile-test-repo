*** Settings ***

Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  Itegration  Shifty  Web Services

*** Test Cases ***
doesCardPosition for a customer that uses secure fuel
    [Tags]  qTest:30782883  BUGGED:Bugging for now, in aws prod there are no carriers set up like this... weird.... ;P
    [Documentation]  Validate that the is possible to check if the customer uses secure fuel.
    ...  The member needs to have either 1 or 2 on the secure_fuel_rules.member. 1 means it's a simple secure fuel
    ...  as to 2 means it's a secure fuel with prompt suppresion

    Get Into DB  TCH
    ${info}  find carrier variable  SELECT member_id as carrier_id AS passwd FROM member WHERE secure_fuel_rules='1'
    Log Into Card Management Web Services  ${info.id}  ${info.password}
    ${status}  doesCardPosition
    should be equal as strings  ${status}  true

    [Teardown]  Logout

doesCardPosition for a customer that do not uses secure fuel
    [Tags]  qTest:30782956
    [Documentation]  Validate that the is possible to check if the customer don't uses secure fuel

    Get Into DB  TCH
     ${info}  find carrier variable  SELECT member_id as carrier_id FROM member WHERE secure_fuel_rules='0'
     Log Into Card Management Web Services  ${info.id}  ${info.password}

    ${status}  doesCardPosition
    should be equal as strings  ${status}  false

    [Teardown]  Logout

*** Keywords ***
