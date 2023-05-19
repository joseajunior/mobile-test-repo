*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyTimer
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot

#Suite Setup  Set Robot Environment   devacpt
Suite Teardown  Ending
Force Tags  eManager  Reports

*** Variables ***

*** Test Cases ***
Reject Transaction Report for Users
    [Documentation]  Testing to see if the Failed Transaction Report works for a user of a carrier.
    [Tags]  JIRA:FLT-1506  Reports  refactor

    Open eManager  700001kev  testing1                                  #700001kev is a user under parent 700001
    Running Reject Transaction Report  700088  Y  C  NoDate  https://devacpt.efsllc.com/cards/TranRejectReport.action
    sleep  5
    page should contain  Document complete
    close window

Failed Transaction Report for Carrier (not users)
    [Documentation]  Verifying that the Failed Transaction Report works for a carrier. This test is for a Fleet One Carrier. ${/n}
    ...  There is no JIRA associated with this test. It was added to the test for FLT-1506, which is looking at users for carriers. ${/n}
    ...  This should be run in DevAcpt.
    [Tags]  Reports  JIRA:FLT-1516  refactor

    ${pw}=  get carrier password  700001
    Open eManager  700001  ${pw}
    Running Reject Transaction Report  700088  Y  C  NoDate  https://devacpt.efsllc.com/cards/TranRejectReport.action
    Sleep  5
    page should contain  Document complete

Reject Transaction Report for wrong child of parent
    [Documentation]  eManager was allowing reports to be run of children that didn't belong to that Parent. This test ${/n}
    ...  is to make sure that a Parent can't run reports for children that are not theirs.
    [Tags]  Child  Parent  JIRA:FLT-1516  refactor

    Running Reject Transaction Report  700100  N  NoCheck  D  https://devacpt.efsllc.com/cards/TranRejectReport.action
    Sleep  5
    page should not contain  Document complete

Transaction Report run as Fleet One Parent
    [Documentation]  Making sure that a Parent can't see non-children's transactions
    [Tags]  Children  Parent  JIRA:FLT-1516  refactor
    Running Transaction Report  700068  N  https://devacpt.efsllc.com/cards/Transaction.action?outputMode=report

Enhanced Transaction Report Fleet One Carrier Denial
    [Documentation]  Running an Enhanced Transaction Report for a Fleet carrier to make sure they cannot pull children that are not their own.
    [Tags]  Enhanced Transaction Report  Child  Parent  JIRA:FLT-1518  BUGGED:When opening the report it is showing not authorized, however if you go back and attempt again it will work. Not Reported  refactor
    Running Enhanced Transaction Report  700068  N  https://devacpt.efsllc.com/trn/TRNReport.action  3

Enhanced Transaction Report Fleet One Carrier Allowed
    [Documentation]  Running an Enhanced Transaction Report for a non-Fleet carrier to make sure they can pull their own children.
    [Tags]  Enhanced Transaction Report  Child  Parent  JIRA:FLT-1518  refactor
    Running Enhanced Transaction Report  700088  Y  https://devacpt.efsllc.com/trn/TRNReport.action
    close browser

Transaction Report run as Non-Fleet Parent for Child of another Parent
    [Documentation]  Running a transaction as a Parent for a Child of another Parent. This should not pull up any data. ${/n}
    ...  Should error and not pull data.
    [Tags]  Children  Parent  JIRA:FLT-1516  refactor

    ${pw}=  get carrier password  141996
    Open eManager  141996  ${pw}                                                                    #Parent carrier
    Running Transaction Report  103866  N  https://test.efsllc.com/cards/Transaction.action?outputMode=report

Reject Transaction Report on Acceptance with invalid child
    [Documentation]  eManager Reject Transaction Report run with a non-FleetOne carrier on Acceptance.
    [Tags]  Child  Parent  JIRA:FLT-1516  refactor
    Running Reject Transaction Report  103866  N  C  NoDate  https://test.efsllc.com/cards/TranRejectReport.action

Reject Transaction Report on Acceptance with real child
    [Documentation]  eManager Reject Transaction Report with a valid child of a parent
    [Tags]  Child  Parent  JIRA:FLT-1516  refactor
    Running Reject Transaction Report  142989  Y  NoCheck  NoDate  https://test.efsllc.com/cards/TranRejectReport.action

Transaction Report run as Non-Fleet Parent for Legit Child
    [Documentation]  Running a transaction report to see if it works for a legit child from the carrier_group_xref table.
    [Tags]  Child  Parent  JIRA:FLT-1516  refactor
    Running Transaction Report  142989  Y  https://test.efsllc.com/cards/Transaction.action?outputMode=report  8

Enhanced Transaction Report Non-Fleet non-child
    [Documentation]  Running an Enhanced Transaction Report for a non-Fleet carrier to make sure they cannot pull children that are not their own.
    [Tags]  Enhanced Transaction Report  Child  Parent  JIRA:FLT-1518  BUGGED:When opening the report it is showing not authorized, however if you go back and attempt again it will work. Not Reported  refactor
    Running Enhanced Transaction Report  103866  N  https://test.efsllc.com/trn/TRNReport.action  3

Enhanced Transaction Report Non-Fleet real child
    [Documentation]  Running an Enhanced Transaction Report for a non-Fleet carrier making sure they can pull their own children
    [Tags]  Enhanced Transaction Report  Child  Parent  JIRA:FLT-1518  refactor
    Running Enhanced Transaction Report  142989  Y  https://test.efsllc.com/trn/TRNReport.action

    close browser
*** Keywords ***
Running Reject Transaction Report
    [Arguments]  ${child}  ${Value}  ${checkbox}  ${putdate}  ${url}  ${s}=0
    go to  ${url}
    Run keyword if  '${checkbox}'=='C'  click on  childCarrierDoFilter    #Checkbox for Child Carrier
    ${d}=  run keyword if  '{putdate}'=='D'  getdatetimenow  %Y-%m-%d
    run keyword if  '{putdate}'=='D'  input text  startDate  ${d}  AND  input text  endDate  ${d}
    input text  childCarrier  ${child}                                    #Input a child carrier
    click on  Submit
    Run keyword if  '${Value}'=='N'  page should contain  This Child Carrier does not belong to the parent or might have expired.
    ...  ELSE  page should not contain  This Child Carrier does not belong to the parent or might have expired.
    Run keyword if  '${Value}'=='N'  tch logging  ${child} is NOT a child of this parent.
    ...  ELSE  tch logging  Yes ${child} is a child of this parent.

Running Transaction Report
    [Arguments]  ${child}  ${Value}  ${url}  ${s}=0
    go to  ${url}
    click on  transFilter.carrierId.doFilter
    input text  transFilter.carrierId.value  ${child}
    Click on  viewReport
    sleep  ${s}
    Run keyword if  '${Value}'=='N'  page should contain  This Child Carrier does not belong to the parent or might have expired.
    ...  ELSE  page should not contain  This Child Carrier does not belong to the parent or might have expired.
    Run keyword if  '${Value}'=='N'  tch logging  ${child} is NOT a child of this parent.
    ...  ELSE  tch logging  Yes ${child} is a child of this parent.

Running Enhanced Transaction Report
    [Arguments]  ${child}  ${Value}  ${url}  ${s}=0
    go to  ${url}
    click on  matchByCk
    click on  runParams.childCarrierId.selected
    input text  runParams.childCarrierId.text  ${child}
    click on  runReport
    sleep  ${s}
    Run keyword if  '${Value}'=='N'  page should contain  This Child Carrier does not belong to the parent or might have expired.
    ...  ELSE  page should not contain  This Child Carrier does not belong to the parent or might have expired.
    Run keyword if  '${Value}'=='N'  tch logging  ${child} is NOT a child of this parent.
    ...  ELSE  tch logging  Yes ${child} is a child of this parent.
