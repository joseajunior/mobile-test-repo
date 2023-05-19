*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Valid Full Input
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30995403  Regression
    Generate Data Input
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  ${day_count}  ${day_amt}  ${week_count}  ${week_amt}  ${month_count}  ${month_amt}
    ${velocity_limits}  Get Limits From Card
    Assert Velocity Limits Values  ${velocity_limits}

Valid Without Optional Input
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30995623  Regression
    ${velocity_src}  Set Variable  D
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal As Strings  ${velocity_src}  ${velocity_limits['velocity_src']}

Typo Card Number
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30995404  Regression
    Generate Data Input
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}f  ${velocity_src}  ${day_count}  ${day_amt}  ${week_count}  ${week_amt}  ${month_count}  ${month_amt}

Empty Card Number
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30995405  Regression
    Generate Data Input
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${EMPTY}  ${velocity_src}  ${day_count}  ${day_amt}  ${week_count}  ${week_amt}  ${month_count}  ${month_amt}

Invalid Card Number
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30995406  Regression
    Generate Data Input
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  1nv@l1d_c@rd  ${velocity_src}  ${day_count}  ${day_amt}  ${week_count}  ${week_amt}  ${month_count}  ${month_amt}

Typo Limit Source
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30996799  Regression
    ${velocity_src}  Set Variable  CF
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal As Strings  ${velocity_limits['velocity_src']}  C

Empty Limit Source
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30996800  Regression
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${EMPTY}

Invalid Limit Source
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30996801  Regression  BUGGED: IS IT POSSIBLE TO ADD THIS VALUE?  run
    ${velocity_src}  Set Variable  1nv@l1d_c@rd
    setCardRefreshingLimits  ${validCard.card_num}  *
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}
    Should Be Equal  ${message}  Could Not Set Card Refreshing limits

Typo Day Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997228  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  dayCntLimit=10f

Empty Day Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997229  Regression
    ${velocity_src}  Set Variable  C
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  dayCntLimit=${EMPTY}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal  ${velocity_limits['day_count']}  ${NONE}

Invalid Day Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997231  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  dayCntLimit=1nv@l1d

Typo Day Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997723  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  dayAmtLimit=10f

Empty Day Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997724  Regression
    ${velocity_src}  Set Variable  C
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  dayAmtLimit=${EMPTY}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal  ${velocity_limits['day_amt']}  ${NONE}

Invalid Day Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997725  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  dayAmtLimit=1nv@l1d

Typo Week Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997914  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  weekCntLimit=10f

Empty Week Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997915  Regression
    ${velocity_src}  Set Variable  C
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  weekCntLimit=${EMPTY}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal  ${velocity_limits['week_count']}  ${NONE}

Invalid Week Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997916  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  weekCntLimit=1nv@l1d

Typo Week Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997953  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  weekAmtLimit=10f

Empty Week Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997954  Regression
    ${velocity_src}  Set Variable  C
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  weekAmtLimit=${EMPTY}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal  ${velocity_limits['week_amt']}  ${NONE}

Invalid Week Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997955  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  weekAmtLimit=1nv@l1d

Typo Month Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997981  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  monCntLimit=10f

Empty Month Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997982  Regression
    ${velocity_src}  Set Variable  C
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  monCntLimit=${EMPTY}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal  ${velocity_limits['week_amt']}  ${NONE}

Invalid Month Count Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30997983  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  monCntLimit=1nv@l1d

Typo Month Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30998022  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  monAmtLimit=10f

Empty Month Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30998023  Regression
    ${velocity_src}  Set Variable  C
    setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  monAmtLimit=${EMPTY}
    ${velocity_limits}  Get Limits From Card
    Should Be Equal  ${velocity_limits['month_amt']}  ${NONE}

Invalid Month Amount Limit
    [Documentation]
    [Tags]  JIRA:BOT-1604  qTest:30998024  Regression
    ${velocity_src}  Set Variable  C
    ${message}  Run Keyword And Expect Error  *  setCardRefreshingLimits  ${validCard.card_num}  ${velocity_src}  monAmtLimit=1nv@l1d

*** Keywords ***
Setup WS
    Ensure Member is Not Suspended  ${validCard.carrier.id}
    Get Into DB  TCH
    Start Setup Card  ${validCard.card_num}
    Setup Card Contract  velocity_enabled=Y

    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Generate Data Input
    [Arguments]  ${velocity_src}=${NONE}  ${day_count}=${NONE}  ${day_amt}=${NONE}  ${week_count}=${NONE}  ${week_amt}=${NONE}  ${month_count}=${NONE}  ${month_amt}=${NONE}
    ${day_c}    Generate Random String  2  [NUMBERS]
    ${day_a}      Generate Random String  2  [NUMBERS]
    ${week_c}   Generate Random String  2  [NUMBERS]
    ${week_a}     Generate Random String  2  [NUMBERS]
    ${month_c}  Generate Random String  2  [NUMBERS]
    ${month_a}    Generate Random String  2  [NUMBERS]
    ${velocity_s}  Set Variable  C

    ${velocity_src}  Set Variable If  ${velocity_src}==${NONE}  ${velocity_s}  ${velocity_src}
    ${day_count}     Set Variable If  ${day_count}==${NONE}     ${day_c}    ${day_count}
    ${day_amt}       Set Variable If  ${day_amt}==${NONE}       ${day_a}    ${day_amt}
    ${week_count}    Set Variable If  ${week_count}==${NONE}    ${week_c}   ${week_count}
    ${week_amt}      Set Variable If  ${week_amt}==${NONE}      ${week_a}   ${week_amt}
    ${month_count}   Set Variable If  ${month_count}==${NONE}   ${month_c}  ${month_count}
    ${month_amt}     Set Variable If  ${month_amt}==${NONE}     ${month_a}  ${month_amt}

    Set Test Variable  ${velocity_src}  ${velocity_src}
    Set Test Variable  ${day_count}  ${day_count}
    Set Test Variable  ${day_amt}  ${day_amt}
    Set Test Variable  ${week_count}  ${week_count}
    Set Test Variable  ${week_amt}  ${week_amt}
    Set Test Variable  ${month_count}  ${month_count}
    Set Test Variable  ${month_amt}  ${month_amt}

Get Limits From Card
    ${query}  Catenate
    ...     SELECT velsrc AS velocity_src,
    ...            day_cnt_limit AS day_count,
    ...            day_amt_limit AS day_amt,
    ...            week_cnt_limit AS week_count,
    ...            week_amt_limit AS week_amt,
    ...            mon_cnt_limit AS month_count,
    ...            mon_amt_limit AS month_amt
    ...     FROM cards
    ...     WHERE card_num = '${validCard.card_num}'
    ${velocity_limits}  Query To Dictionaries  ${query}
    ${velocity_limits}  Get From List  ${velocity_limits}  0
    [Return]  ${velocity_limits}

Assert Velocity Limits Values
    [Arguments]  ${velocity_limits}
    Should Be Equal As Strings  ${velocity_src}  ${velocity_limits['velocity_src']}
    Should Be Equal As Numbers  ${day_count}    ${velocity_limits['day_count']}
    Should Be Equal As Numbers  ${day_amt}      ${velocity_limits['day_amt']}
    Should Be Equal As Numbers  ${week_count}   ${velocity_limits['week_count']}
    Should Be Equal As Numbers  ${week_amt}     ${velocity_limits['week_amt']}
    Should Be Equal As Numbers  ${month_count}  ${velocity_limits['month_count']}
    Should Be Equal As Numbers  ${month_amt}    ${velocity_limits['month_amt']}