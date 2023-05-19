*** Settings ***
Test Timeout  5 minutes
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.setup.PySetup
Library  otr_robot_lib.auth.PyAuth.StringBuilder
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

Force Tags  eManager

*** Variables ***

*** Test Cases ***
Pull up Research Reject Trans Report
    [Tags]  JIRA:BOT-733  BUGGED: Can't Find Report on eManager side.
    [Documentation]  Pull up Research Reject Trans Report
    [Setup]  Setup Card To Ensure A Successfull Transaction
    Run a Transaction Using Invalid Unit Number
    Check rejection message on eManager
    [Teardown]  Close Browser

*** Keywords ***
Setup Card To Ensure A Successfull Transaction
    set test variable  ${card_num}  ${validCard.card_num}
    set test variable  ${location_id}  ${validCard.valid_location}
    start setup card  ${card_num}
    Setup Card Header  status=ACTIVE  infoSource=CARD  limitSource=CARD  payrollStatus=A  payrollUse=B
    Setup Card Prompts  UNIT=V1234
    Setup Card Limits  ULSD=100

Run a Transaction Using Invalid Unit Number

    Tch Logging  \n RUNNING A TRANSACTION USING INVALID UNIT NUMBER
    get into db  TCH
    start ac string
    set string location  ${location_id}
    set string card  ${card_num}
    use dynamic invoice
    add info prompt value to string  UNIT  ABC
    add fuel item to string  8192  1  3.00  2
    ${ACstring}=  finalize string
    ${AuthLog}=  create log file  rossAuth
    run rossAuth   ${ACstring}  ${AuthLog}
    tch logging  ${ACstring}
    set log file  ${AuthLog}
    auth log should contain error  INVALID UNIT NUMBER ENTRY
    ${error}=  get errors from log

Check rejection message on eManager

    tch logging  Checking for appropriate error message on eManager

    Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Go To  ${emanager}/cards/CardLookup.action
    Click Element   xpath=//input[@value="NUMBER"]
    Input Text      xpath=//input[@name="cardSearchTxt"]  ${card_num}
    Click Element   name=searchCard
    Click link   xpath=//*[@id='cardSummary']//descendant::*[contains(text(),'${card_num}')]
    Click Element  name=doDefault
    input text  transRejectSearch  1
    click button  search
    page should contain element  xpath=//*[@id="row"]//*[contains(text(),'UNIT NUMBER')]  page doesnt contain expected error