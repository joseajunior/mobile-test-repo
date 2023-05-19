*** Settings ***
Test Timeout  5 minutes
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyMath
Library  otr_model_lib.services.GenericService
Library  Process
Library  otr_robot_lib.auth.PyAuth.AuthLog
Library  OperatingSystem  WITH NAME  os
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Suite Setup  Setup
Suite Teardown  Teardown
Force Tags  eManager

*** Variables ***
${SFC}  7666685053110000033
${SFcarrier}  505311
${SFpassword}  112233
${GC}  6037920700001550035
${GCcarrier}  100002

*** Test Cases ***

Shell Fleet Card Locking
    [Tags]  JIRA:BOT-211  JIRA:BOT-2000  qTest:35173395  qTest:31917382  refactor    #need a fix on create IC String
    [Documentation]  This test suite checks if the card locking functionality is working as expected
    ...  This test case first unlocks the card in setup, then runs a pre auth which locks the card
    ...  ONLY A SUCCESSFULL PRE-AUTH LOCKS THE CARD
    ...  A second pre auth should fail with appropriate 'locked' error
    ...  Then we unlock the card via account manager, check DB for the same
    ...  After card is unlocked, a pre auth followed by a post-auth i.e., a complete transaction should be successful.
    ...  First test case checks above functionality for shell card and second test case for TCH gift cards
    ...  8/20/2019 - ATTENTION! - THERE HAS BEEN A FUNCTIONALITY CHANGE THAT IS: ON THE SECOND PRE-AUTH IT'S CHECKING IF THERE'S A
    ...  PREVIOUS PRE-AUTH, IF THERE IS, IT'S CLEARING THE LOCK FROM THE CARD AND LOCKING IT AGAIN. SO THE LOG FILE WON'T SHOW ANY ERROR MESSAGE.
    [Setup]  Run Keywords  Get Into DB  SHELL
    ...     AND  Start Setup Card  ${SFC}  SHELL
    ...     AND  Setup Card Header  status=ACTIVE  infoSource=CARD  limitSource=CARD  locationSource=CARD
    ...     AND  Setup Card Limits  OIL=10
    ...     AND  Setup Card Location  512377

    Log To Console  ${EMPTY}

#   UPDATE TRAN_UPDATE TO P SO IT SO THE PRE-AUTH DOESNT FAIL DUE TO INVALID TRUCK STOP FOR CUSTOMER
    ${tran_update}  Query And Strip  SELECT tran_update FROM member WHERE member_id = ${SFcarrier}
    execute sql string  dml=update member SET tran_update = 'P' WHERE member_id = ${SFcarrier}

    DB check for card lock  ${SFC}  SHELL
    Run a Pre-Auth  SHELL  ${SFC}  512377  PPIN:3062
#    Run a Pre-Auth  SHELL  ${SFC}  512377  PPIN:3062    #SECOND PRE-AUTH SHOULD FAIL WITH CORRECT ERROR
#    Unlock The Card Through Acct Mngr  ${SFcarrier}  ${SFC}
#    Run a Pre-Auth  SHELL  ${SFC}  512377  PPIN:3062
    Run a Post-Auth  SHELL  ${SFC}  512377  PPIN:3062

    [Teardown]  Run Keywords  Get Into DB  SHELL
    ...     AND  execute sql string  dml=update member SET tran_update = '${tran_update}' WHERE member_id = ${SFcarrier}

Gift Card Locking
    [Tags]  JIRA:BOT-2000  qTest:35173426  refactor
    [Documentation]  This documentation is following the doc from the test case above
    ...  8/20/2019 - ATTENTION! - THERE HAS BEEN A FUNCTIONALITY CHANGE THAT IS: ON THE SECOND PRE-AUTH IT'S CHECKING IF THERE'S A
    ...  PREVIOUS PRE-AUTH, IF THERE IS, IT'S CLEARING THE LOCK FROM THE CARD AND LOCKING IT AGAIN.
    ...  SO THE LOG FILE WON'T SHOW ANY ERROR MESSAGE.
    [Setup]  Run Keywords  Start Setup Card  ${GC}
    ...     AND  Setup Card Limits  OIL=10
    ...     AND  Setup Card Location  505060

    Log To Console  ${EMPTY}

#   UPDATE TRAN_UPDATE TO P SO IT LOCKS THE CARD ON THE SECOND PRE AUTH
    ${tran_update}  Query And Strip  SELECT tran_update FROM member WHERE member_id = ${GCcarrier}
    execute sql string  dml=update member SET tran_update = 'P' WHERE member_id = ${GCcarrier}

    DB check for card lock  ${GC}  TCH
    Run a Pre-Auth  TCH  ${GC}  505060  ${EMPTY}
#    Run a Pre-Auth  TCH  ${GC}  505060  ${EMPTY}
#    Unlock The Card Through Acct Mngr  ${GCcarrier}  ${GC}
#    Run a Pre-Auth  TCH  ${GC}  505060  ${EMPTY}
    Run a Post-Auth  TCH  ${GC}  505060  ${EMPTY}

    [Teardown]  Run Keywords  Get Into DB  TCH
    ...     AND  execute sql string  dml=update member SET tran_update = '${tran_update}' WHERE member_id = ${GCcarrier}

*** Keywords ***
Setup

#   CLEAR CARD_LOCK_DATE FOR SHELL SO IT DOESNT GET A CARD TRANSACTION REJECTION
    Get Into DB  SHELL
    execute sql string  dml=update cards SET card_lock_date = NULL WHERE card_num = '${SFC}'

#   ENSURE INFO SOURCE FROM CARD AND LIMIT SOURCE FROM BOTH
    Disconnect From Database

#   CLEAR CARD_LOCK_DATE FOR TCH SO IT DOESNT GET A CARD TRANSACTION REJECTION
    Get Into DB  TCH
    execute sql string  dml=update cards SET card_lock_date = NULL WHERE card_num = '${GC}'

DB Check For Card Lock
    [Arguments]  ${card}  ${DB}
    Tch Logging  DB CHECK FOR CARD LOCK
    Get Into DB  ${DB}
    ${lock}=  Query And Strip  SELECT card_lock_date FROM cards WHERE card_num = '${card}'
    Run Keyword IF  '${lock}'=='None'  Tch Logging  CARD IS UNLOCKED
    ...     ELSE  Tch Logging  CARD IS LOCKED

Run a Pre-Auth
    [Arguments]  ${DB}  ${card}  ${Location}  ${prompts}
     Tch Logging  RUN A PRE-AUTH

     ${Now}=  getDateTimeNow
     ${Month}=  getdatetimenow  %m

     Get Into DB  ${DB}
     Connect SSH  ${sshHost}  ${sshName}  ${sshPass}
     ${ICstring}=  Create IC String  ${DB}  ${Location}  ${card}  OIL
     ${log}=  Create Log File  rossAuthPreAuth${Month}${Now}
     run rossAuth   ${ICstring}  ${log}
     Set Log File  ${log}

#    CHECKING IF THE CARD GOT LOCKED ON THE LOG FILE AFTER THE PRE-AUTH
     ${LOGRESULTS}  Find All Regex In Auth Log  Entering CardSetLock
     ${LOGRESULTS}  Find All Regex In Auth Log  Entering CardLocked
     ${LOGRESULTS}  Find All Regex In Auth Log  Card is NOT locked
     ${LOGRESULTS}  Find All Regex In Auth Log  CardSetLock

#     GET THE GOOD RESPONSE FROM THE PRE-AUTH
     ${RESPONSE}  Get Responses From Log  0
     Should Be Equal As Strings  ${RESPONSE['type']}  PC
     DB Check For Card Lock  ${card}  ${DB}

Unlock The Card Through Acct Mngr
    [Arguments]  ${carrier}  ${card}
    [Documentation]  Unlocking card through Account Manager to check card locking
    ...  doesnt have any impact on card loading

    Open eManager  ${robot_emanager_username}  ${robot_emanager_password}
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${carrier}
    Click On  text=Submit  exactMatch=False
    Click On  text=${carrier}
    Click On  text=Cards
    Sleep  10
    Input Text  //*[@name="cardNumber"]  ${card}
    Click On  text=Submit  exactMatch=False  index=2  timeout=15
    Click On  xpath=//*[@class="cardNumber buttonlink"]
    Wait Until Page Contains  Card Locked Date     timeout=50
    Click On  //*[@id="cardActionForm"]//descendant::*[@class="unlock buttonlink"]
    Wait Until Page Contains  Card Locked Date     timeout=50
    Tch Logging  CARD IS UNLOCKED THROUGH ACCOUNT MANAGER

Run a Post-Auth
    [Arguments]  ${DB}  ${card}  ${Location}  ${prompts}

     Tch Logging  RUN A POST AUTH NOW
     ${Now}=  getDateTimeNow
     ${Month}=  getdatetimenow  %m

     Get Into DB  ${DB}
     Connect SSH  ${sshHost}  ${sshName}  ${sshPass}
     ${ACstring}=  Create AC String  ${DB}  ${Location}  ${card}  OIL=2.00
     ${log}  Create Log File  rossAuthPostAuth${Month}${Now}
     run rossAuth   ${ACstring}  ${log}
     ${TRANS_ID}  Get Transaction ID From Log File  ${log}
     Tch Logging  TRANS_ID:${TRANS_ID}
     DB Check For Card Lock  ${card}  ${DB}

Teardown
    Setup   #SO THAT CARD WILL NOT BE LOCKED IF ANY OF THE POST AUTHS FAIL
