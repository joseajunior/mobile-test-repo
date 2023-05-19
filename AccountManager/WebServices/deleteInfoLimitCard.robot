*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Test Cases ***
Delete Info Limit Card With Valid Parameters
    [Tags]  JIRA:BOT-1619  qTest:30803769  Regression
    [Documentation]  Deletes the info limit card from the system.
    ...     Creating a new card in the cards table and it adds a specific prompt that the system is looking
    ...     for at the end of the card #.  For example, you can have a trip # and policy assigned to the card.
    ...     Then you assign the prompt to a physical card.

    ${WS_INFO_CreateInfoLimit}  createInfoLmitCard  1  UNIT  7890
    Row Count Is Equal To X  SELECT * FROM cards WHERE card_num='${validCard.carrier.id}UNIT7890'  1
    ${WS_INFO_DeleteInfoLimit}  deleteInfoLimitCard  1  UNIT  7890
    ${query}  catenate
    ...     SELECT status FROM cards WHERE card_num='${validCard.carrier.id}UNIT7890'
    ${results}  Query And Strip  ${query}
    Should Be Equal As Strings  ${results}  D

Delete Info Limit Card With Typo On The Prompt Type
    [Tags]  JIRA:BOT-1619  qTest:30805922  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's a typo on the policy or infoId

    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  UNITA  7890
    Should Not Be True  ${status}

Delete Info Limit Card With An Invalid Policy Number
    [Tags]  JIRA:BOT-1619  qTest:37379479  Regression  JIRA:FRNT-55  refactor
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's a typo on the policy or infoId

    ${status}  Run Keyword And Return Status  createInfoLmitCard  9999  UNIT  7890
    Should Not Be True  ${status}
    should contain  ${ws_error}  Invalid policy number

Delete Info Limit Card With EMPTY On The Prompt Type
    [Tags]  JIRA:BOT-1619  qTest:30805945  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's an empty value on any of the parameters

    ${status}  Run Keyword And Return Status  createInfoLmitCard  ${EMPTY}  UNIT  7890
    Should Not Be True  ${status}

Delete Info Limit Card With EMPTY On The Policy Number
    [Tags]  JIRA:BOT-1619  qTest:30805945  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's an empty value on any of the parameters

    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  ${EMPTY}  7890
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRID  ${EMPTY}
    Should Not Be True  ${status}

Delete Info Limit Card With SPACE On The Policy Number
    [Tags]  JIRA:BOT-1619  qTest:30806297  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's a SPACE on the policy or infoId

    ${status}  Run Keyword And Return Status  createInfoLmitCard  ${SPACE}  UNIT  7890
    Should Not Be True  ${status}

Delete Info Limit Card With SPACE On The Prompt Type
    [Tags]  JIRA:BOT-1619  qTest:30806297  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's a SPACE on the policy or infoId
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  ${SPACE}  7890
    Should Not Be True  ${status}

Delete Info Limit Card With SPACE On The Value
    [Tags]  JIRA:BOT-1619  qTest:30806297  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's a SPACE on the policy or infoId
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRID  ${SPACE}
    Should Not Be True  ${status}

Delete Info Limit Card With Special Characters On The Policy Number
    [Tags]  JIRA:BOT-1619  qTest:30806507  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's special characters on the policy or infoId

    ${status}  Run Keyword And Return Status  createInfoLmitCard  1!  UNIT  7890
    Should Not Be True  ${status}

Delete Info Limit Card With Special Characters On The Prompt Type
    [Tags]  JIRA:BOT-1619  qTest:30806507  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's special characters on the policy or infoId
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRID@  7890
    Should Not Be True  ${status}

Delete Info Limit Card With Special Characters On The Value
    [Tags]  JIRA:BOT-1619  qTest:30806507  Regression
    [Documentation]  Make sure you can't delete the info limit card from the system when
    ...     there's special characters on the policy or infoId
    ${status}  Run Keyword And Return Status  createInfoLmitCard  1  DRID  1!2@3#
    Should Not Be True  ${status}



*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Tear Me Down
    Disconnect From Database
    Logout