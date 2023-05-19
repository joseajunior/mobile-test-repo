*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH       #USED TO BE Library  SSHLibrary
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  ../../Keywords/PortalKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Integration  WebServices  Shifty
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***

*** Test Cases ***

Set Card With Valid Parameters
    [Tags]  qTest:34718085

    Start Setup Card  ${validCard.num}

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
    ...  ${validCard.num}
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

    ${cardHeader}  getCardHeader  ${validCard.num}
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
    ...  ${validCard.num}
    ...  ${false}
    ...  ${infos}

    ${cardInfos}  getCardInfos  ${validCard.num}
    Compare Dictionaries as Strings  ${cardInfos[0]}  ${infos}

    ${limits}  Create Dictionary
    ...  hours=1
    ...  limit=9999
    ...  limitId=OIL
    ...  minHours=0

    setCardLimits
    ...  ${validCard.num}
    ...  ${false}
    ...  ${limits}

    ${cardLimits}  getCardLimitsWS  ${validCard.num}
    Compare Dictionaries as Strings  ${cardLimits[0]}  ${limits}

    ${locations}  Create List
    ...  231001
    ...  231002
    ...  231003

    setCardLocations
    ...  ${validCard.num}
    ...  ${false}
    ...  @{locations}
    ${cardLocations}  getcardlocations  ${validCard.num}
    Lists Should be Equal  ${cardLocations}  ${locations}

    ${timeRestrictions}  Create Dictionary
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=6
    ...  endDate=${empty}
    ...  endTime=11:00

    setCardTimeRestrictions
    ...  ${validCard.num}
    ...  ${false}
    ...  ${timeRestrictions}
    Row Count is Equal to X  SELECT * FROM card_time WHERE TRIM(card_num)='${validCard.num}' AND beg_time=TO_DATE('${timeRestrictions['beginTime']}:00', '%H:%M:%S') AND end_time=TO_DATE('${timeRestrictions['endTime']}:00', '%H:%M:%S') AND day_of_week=TO_NUMBER('${timeRestrictions['day']}')-1  1

*** Keywords ***
Setup WS
    Get Into DB  TCH
    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    Logout