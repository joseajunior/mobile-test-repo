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

*** Test Cases ***
Set Card With Valid Parameters
    [Tags]  JIRA:BOT-1561  qTest:31823622  Regression  refactor
    [Documentation]  Make sure you can set the card with valid parameters.

    Start Setup Card  ${card}

    ${header}  Create Dictionary
    ...  companyXRef=Test BOT-1561
    ...  handEnter=BOTH
    ...  infoSource=BOTH
    ...  limitSource=BOTH
    ...  locationOverride=0
    ...  locationSource=BOTH
    ...  overrideAllLocations=False
    ...  payrollStatus=FOLLOWS
    ...  override=0
    ...  policyNumber=5
    ...  status=ACTIVE
    ...  payrollUse=Y
    ...  payrollAtm=ALLOW
    ...  payrollChk=ALLOW
    ...  payrollAch=ALLOW
    ...  payrollWire=ALLOW
    ...  payrollDebit=ALLOW

    setCardHeader
    ...  ${card}
    ...  companyXRef=Test BOT-1561
    ...  handEnter=BOTH
    ...  infoSource=BOTH
    ...  limitSource=BOTH
    ...  locationOverride=0
    ...  locationSource=BOTH
    ...  overrideAllLocations=False
    ...  payrollStatus=FOLLOWS
    ...  override=0
    ...  policyNumber=5
    ...  status=ACTIVE
    ...  payrollUse=Y
    ...  payrollAtm=ALLOW
    ...  payrollChk=ALLOW
    ...  payrollAch=ALLOW
    ...  payrollWire=ALLOW
    ...  payrollDebit=ALLOW

    ${cardHeader}  getCardHeader  ${card}
    Compare Dictionaries as Strings  ${cardHeader[0]}  ${header}

    ${infos}  create dictionary
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0

    setCardInfos
    ...  ${card}
    ...  ${false}
    ...  ${infos}

    ${cardInfos}  getCardInfos  ${card}
    Compare Dictionaries as Strings  ${cardInfos[0]}  ${infos}

    ${limits}  Create Dictionary
    ...  hours=1
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=0

    setCardLimits
    ...  ${card}
    ...  ${false}
    ...  ${limits}

    ${cardLimits}  getCardLimitsWS  ${card}
    Compare Dictionaries as Strings  ${cardLimits[0]}  ${limits}

    ${locations}  Create List
    ...  231001
    ...  231002
    ...  231003

    setCardLocations
    ...  ${card}
    ...  ${false}
    ...  @{locations}
    ${cardLocations}  getcardlocations  ${card}
    Lists Should be Equal  ${cardLocations}  ${locations}

#Bugged:its not setting location groups
#    setCardLocationGroups
#    ...  ${card}
#    ...  ${false}
#    ...  2870
#    Row Count is Equal to X  SELECT * FROM card_loc_grp WHERE TRIM(card_num)='${card}' AND grp_id='2870'  1

    ${timeRestrictions}  Create Dictionary
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=6
    ...  endDate=${empty}
    ...  endTime=11:00

    setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  ${timeRestrictions}
    Row Count is Equal to X  SELECT * FROM card_time WHERE TRIM(card_num)='${card}' AND beg_time=TO_DATE('${timeRestrictions['beginTime']}:00', '%H:%M:%S') AND end_time=TO_DATE('${timeRestrictions['endTime']}:00', '%H:%M:%S') AND day_of_week=TO_NUMBER('${timeRestrictions['day']}')-1  1

Set Card With Empty Parameters
    [Tags]  JIRA:BOT-1561  qTest:31823623  Regression
    [Documentation]  Make sure you can not set card with empty values
    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=${EMPTY}
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=${EMPTY}
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=${EMPTY}
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=${EMPTY}
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=${EMPTY}
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=${EMPTY}
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=${EMPTY}
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=${empty}
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=${empty}
    ...  limitId=OIL
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=9999
    ...  limitId=${empty}
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=${empty}
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLocations
    ...  ${card}
    ...  ${false}
    ...  ${empty}
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLocationGroups
    ...  ${card}
    ...  ${false}
    ...  ${empty}
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=${empty}
    ...  day=4
    ...  endDate=${empty}
    ...  endTime=11:00
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=${empty}
    ...  endDate=${empty}
    ...  endTime=11:00
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=4
    ...  endDate=${empty}
    ...  endTime=${empty}
    Should Not Be True  ${return}

Set Card With Invalid Parameters
    [Tags]  JIRA:BOT-1561  qTest:31823624  Regression
    [Documentation]  Make sure you can not set card with invalid values
    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=1nv@l1d
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=1nv@l1d
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1nv@l1d
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=1nv@l1d
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=1nv@l1d
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=1nv@l1d
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=1nv@l1d
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1nv@l1d
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=1nv@l1d
    ...  limitId=OIL
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=9999
    ...  limitId=1nv@l1d
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=1nv@l1d
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLocations
    ...  ${card}
    ...  ${false}
    ...  1nv@l1d
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLocationGroups
    ...  ${card}
    ...  ${false}
    ...  1nv@l1d
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=1nv@l1d
    ...  day=4
    ...  endDate=${empty}
    ...  endTime=11:00
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=1nv@l1d
    ...  endDate=${empty}
    ...  endTime=11:00
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=4
    ...  endDate=${empty}
    ...  endTime=1nv@l1d
    Should Not Be True  ${return}

Set Card With Typo on The Parameters
    [Tags]  JIRA:BOT-1561  qTest:31823625  Regression
    [Documentation]  Make sure you can not set card with Typo values
    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNITf
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=falsef
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234f
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0f
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0f
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCHf
    ...  value=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardInfos
    ...  ${card}
    ...  ${false}
    ...  infoId=UNIT
    ...  lengthCheck=false
    ...  matchValue=1234
    ...  maximum=0
    ...  minimum=0
    ...  reportValue=${EMPTY}
    ...  validationType=EXACT_MATCH
    ...  value=0f
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1f
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=9999f
    ...  limitId=OIL
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=9999
    ...  limitId=OILf
    ...  minHours=0
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLimits
    ...  ${card}
    ...  ${false}
    ...  hours=1
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=0f
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLocations
    ...  ${card}
    ...  ${false}
    ...  231010f
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardLocationGroups
    ...  ${card}
    ...  ${false}
    ...  2816f
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=10:00f
    ...  day=4
    ...  endDate=${empty}
    ...  endTime=11:00
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=4f
    ...  endDate=${empty}
    ...  endTime=11:00
    Should Not Be True  ${return}

    ${return}  Run Keyword And Return Status  setCardTimeRestrictions
    ...  ${card}
    ...  ${false}
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=4
    ...  endDate=11:00f
    ...  endTime=${empty}
    Should Not Be True  ${return}

Set Card Invalid Policy
    [Tags]  qTest:37377647  JIRA:FRNT-55  refactor
    start setup card  ${card}

    run keyword and return status  setCardHeader  ${card}  policyNumber=9999
    should contain  ${ws_error}  Invalid policy number


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout
