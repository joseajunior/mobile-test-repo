*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.setup.PySetup

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
${card}  ${validCard.num}
${amount}  1
${fromUniversal}  0
${smartfunds}  1

*** Test Cases ***

Valid Parameters For All Fields with FromUniversal=0
    [Documentation]  Insert all parameters and FromUniversal=0 expect a positive response.
    [Tags]  JIRA:BOT-1593  qTest:31036943  Regression  JIRA:BOT-1972  refactor
    ${check}  CreateCheck
    ${return}  registerCheck   ${card}  ${check}  ${amount}  ${fromUniversal}
    Should be Equal  ${return}  SUCCESS
    Validate If Check Was Authorized  ${card}  ${check}  ${amount}

Valid Parameters For All Fields with FromUniversal=1
    [Documentation]  Insert all parameters and FromUniversal=1 expect a positive response.
    [Tags]  JIRA:BOT-1593  qTest:31036944  Regression  JIRA:BOT-1972  refactor
    ${check}  CreateCheck
    ${return}  registerCheck   ${card}  ${check}  ${amount}  ${smartfunds}
    Should be Equal  ${return}  SUCCESS
    Validate If Check Was Authorized  ${card}  ${check}  ${amount}

Invalid Card Number
    [Documentation]  Insert Invalid Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036945  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    ${return}  registerCheck   1nv@l1d_c4rd  ${check}  ${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Typo Card Number
    [Documentation]  Insert Typo Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036946  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    ${return}  registerCheck   ${card}f  ${check}  ${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Empty Card Number
    [Documentation]  Insert an Empty Card Number parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036947  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    ${return}  registerCheck  ${empty}  ${check}  ${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Invalid Check Number
    [Documentation]  Insert Invalid Check Number parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036948  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    ${return}  registerCheck  ${card}  1nv@l1d_ch3ck  ${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Typo Check Number
    [Documentation]  Insert Typo Check Number parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036949  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    ${return}  registerCheck  ${card}  12457A4371  ${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Empty Check Number
    [Documentation]  Insert an Empty Check Number parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036950  Regression  JIRA:BOT-1972
    ${return}  registerCheck  ${card}  ${empty}  ${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Invalid Amount
    [Documentation]  Insert Invalid Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036951  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    Run Keyword And Expect Error  *  registerCheck  ${card}  ${check}  1nv@l1d_4m0unt  ${fromUniversal}

Typo Amount
    [Documentation]  Insert Typo Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036952  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    Run Keyword And Expect Error  *  registerCheck  ${card}  ${check}  ${amount}*  ${fromUniversal}

Empty Amount
    [Documentation]  Insert an Empty Amount parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036953  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    ${return}  registerCheck  ${card}  ${check}  ${empty}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Zero as Amount
    [Documentation]  Insert Zero as amount parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036954  Regression  JIRA:BOT-1972  refactor
    ${check}  CreateCheck
    ${return}  registerCheck  ${card}  ${check}  0  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Negative Amount
    [Documentation]  Insert a negative amount as parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036955  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    ${return}  registerCheck  ${card}  ${check}  -${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

Invalid fromUniversal
    [Documentation]  Insert Invalid fromUniversal parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036956  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    Run Keyword And Expect Error  *  registerCheck  ${card}  ${check}  ${amount}  FromUniversal

Typo fromUniversal
    [Documentation]  Insert Typo fromUniversal parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036957  Regression  JIRA:BOT-1972
    ${check}  CreateCheck
    Run Keyword And Expect Error  *  registerCheck  ${card}  ${check}  ${amount}  ${fromUniversal}*

Empty fromUniversal
    [Documentation]  Insert an Empty fromUniversal parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036958  Regression  JIRA:BOT-1972  refactor
    ${check}  CreateCheck
    ${return}  registerCheck  ${card}  ${check}  ${amount}  ${empty}
    Should Be Equal  ${return}  SUCCESS
    Validate If Check Was Authorized  ${card}  ${check}  ${amount}

Previously Registered Check
    [Documentation]  Insert an Previously Registered Check as check parameter and expect an error.
    [Tags]  JIRA:BOT-1593  qTest:31036959  Regression  JIRA:BOT-1972
    ${check}  Get Used Check
    ${return}  registerCheck  ${card}  ${check}  ${amount}  ${fromUniversal}
    Should Not Be Equal  ${return}  SUCCESS

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Start Setup Card  ${card}
    Setup Card Header  status=ACTIVE
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout

Validate If Check Was Authorized
    [Arguments]  ${card}  ${check}  ${amount}
    ${query}  Catenate  SELECT * FROM checks WHERE check_num='${check}' AND code='${card}' AND amount='${amount}';
    Row Count is Equal to X  ${query}  1

Get Used Check
    ${query}  Catenate  SELECT check_num FROM checks ORDER BY create_date DESC Limit 1;
    ${check}  Query and Strip  ${query}
    [Return]  ${check.__str__()}
