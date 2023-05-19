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

*** Test Cases ***

Valid Parameters For All Fields
    [Documentation]  Insert all parameters and expect a positive response.
    [Tags]  JIRA:BOT-1594  qTest:31049668  Regression  refactor
    ${return}  getSmartPayDriver   ${validCard.card_num}
    Should Not Be Empty  ${return}

Invalid Card Number
    [Documentation]  Insert Invalid Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1594  qTest:31049669  Regression
    Run Keyword And Expect Error  *  getSmartPayDriver   1nv@l1d_c4rd

Typo Card Number
    [Documentation]  Insert Typo Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1594  qTest:31049670  Regression
    Run Keyword And Expect Error  *  getSmartPayDriver   ${validCard.card_num}f

Empty Card Number
    [Documentation]  Insert an Empty Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1594  qTest:31049671  Regression
    Run Keyword And Expect Error  *  getSmartPayDriver   ${empty}

*** Keywords ***
Setup WS
    Get Into DB  TCH
    ${info}  catenate  SELECT m.member_id, TRIM(m.passwd) as passwd
    ...     FROM member m, cards c WHERE m.member_id=c.carrier_id
    ...     AND c.card_num='${validCard.card_num}'
    ${info}  Query And Strip To Dictionary  ${info}
    log into card management web services  ${info['member_id']}  ${info['passwd']}

Teardown WS
    Disconnect From Database
    Logout
