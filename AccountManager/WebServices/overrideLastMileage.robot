*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${unit}  BOT1630
${mileage}  1

*** Test Cases ***

Valid Parameters For All Fields ODRD
    [Documentation]  Insert all parameters, using ODRD and expect a positive response.
    [Tags]  JIRA:BOT-1630  qTest:31079958  Regression
    ${mileage}  Generate Random String  6  [NUMBERS]
    overrideLastMileage  ${unit}  ODRD  ${mileage}
    Validate Last Mileage Override  ${unit}  ODRD  ${mileage}  ${validCard.carrier.id}

Valid Parameters For All Fields HBRD
    [Documentation]  Insert all parameters, using HDRD and expect a positive response.
    [Tags]  JIRA:BOT-1630  qTest:31079959  Regression
    ${mileage}  Generate Random String  6  [NUMBERS]
    overrideLastMileage  ${unit}  HBRD  ${mileage}
    Validate Last Mileage Override  ${unit}  HBRD  ${mileage}  ${validCard.carrier.id}

Invalid Code
    [Documentation]  Insert Invalid Code parameter and expect an error.
    [Tags]  JIRA:BOT-1630  qTest:31079961  Regression  BUGGED:Should not allow write with invalid code.
    overrideLastMileage  ${unit}  1nv@  ${mileage}
    Validate Last Mileage Override  ${unit}  1nv@  ${mileage}  ${validCard.carrier.id}  Invalid

Typo Code
    [Documentation]  Insert Typo Code parameter and expect an error.
    [Tags]  JIRA:BOT-1630  qTest:31079962  Regression
    Run Keyword And Expect Error  *  overrideLastMileage  ${unit}  HBRDf  ${mileage}

Empty Code
    [Documentation]  Insert an Empty Code parameter and expect an error.
    [Tags]  JIRA:BOT-1630  qTest:31079963  Regression  BUGGED:Should not allow write with empty code.
    overrideLastMileage  ${unit}  ${empty}  ${mileage}
    Validate Last Mileage Override  ${unit}  ${empty}  ${mileage}  ${validCard.carrier.id}  Invalid

Invalid Mileage
    [Documentation]  Insert Invalid Mileage parameter and expect an error.
    [Tags]  JIRA:BOT-1630  qTest:31079964  Regression
    Run Keyword And Expect Error  *  overrideLastMileage  ${unit}  HBRD  1nv@l1d

Typo Mileage
    [Documentation]  Insert Typo Mileage parameter and expect an error.
    [Tags]  JIRA:BOT-1630  qTest:31079965  Regression
    Run Keyword And Expect Error  *  overrideLastMileage  ${unit}  HBRD  ${mileage}f

Empty Mileage
    [Documentation]  Insert an Empty Mileageparameter and expect an error.
    [Tags]  JIRA:BOT-1630  qTest:31079966  Regression
    Run Keyword And Expect Error  *  overrideLastMileage  ${unit}  HBRD  ${empty}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Validate Last Mileage Override
    [Arguments]  ${unit}  ${code}  ${mileage}  ${carrier_id}  ${valid}=valid
    ${query}  Catenate  SELECT * FROM last_mile WHERE TRIM(unit)='${unit}' AND carrier_id='${carrier_id}' AND mileage=${mileage} AND code='${code}'
    Run Keyword If  '${valid}'=='valid'
    ...  Row Count Is Equal to X  ${query}  1
    ...  ELSE  Row Count Is Equal to X  ${query}  0