*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Set Up Suite
Suite Teardown  close browser
Force Tags  Portal  Credit Manager

*** Variables ***
${TODAY}
${DayBeforeYesterday}

*** Test Cases ***
Search By Transaction ID EFS LLC
    [Tags]  qTest:31156495  Regression  JIRA:BOT-1676  refactor
    [Teardown]  run keyword if test failed  refresh page
    Search By  Trans ID  760821798    startDate=2019-04-13  endDate=2019-04-15

Search By Transaction Number EFS LLC
    [Tags]  qTest:31156496  Regression  JIRA:BOT-1677  refactor
    [Teardown]  run keyword if test failed  refresh page
    Search By  Trans Num  201904130145  startDate=2019-04-13  endDate=2019-04-15

Search By Carrier ID EFS LLC
    [Tags]  qTest:31156497  Regression  JIRA:BOT-1678
    [Teardown]  run keyword if test failed  refresh page
    Search By  Carrier ID  103866  startDate=2019-04-20  endDate=2019-04-22

Search By Carrier Name EFS LLC
    [Tags]  qTest:31156498  Regression  JIRA:BOT-1679  refactor
    [Teardown]  run keyword if test failed  refresh page
    Search By  Name  ELECTRONIC FUNDS SOURCE  startDate=2019-04-20  endDate=2019-04-22

Search By AR Number EFS LLC
    [Tags]  qTest:31156499  Regression  JIRA:BOT-1680
    [Teardown]  run keyword if test failed  refresh page
    Search By  AR Number  0006219830048  startDate=2019-04-20  endDate=2019-04-22

Search By Min And Max Maount EFS LLC
    [Tags]  qTest:31156500  Regression  JIRA:BOT-1681
    [Teardown]  run keyword if test failed  refresh page
    Search By  Carrier ID  103866  MIN=1  MAX=100  startDate=2019-04-20  endDate=2019-04-22
    
Search By Transaction ID PILOT RV
    [Tags]  qTest:31179324  Regression  JIRA:BOT-1808
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans ID  468981911    startDate=2019-04-13  endDate=2019-04-15  orgLabel=Pilot Recreational Vehicle

Search By Transaction Number PILOT RV
    [Tags]  qTest:31179325  Regression  JIRA:BOT-1809
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans Num  201904130145  startDate=2019-04-13  endDate=2019-04-15  orgLabel=Pilot Recreational Vehicle

Search By Carrier ID PILOT RV
    [Tags]  qTest:31179326  Regression  JIRA:BOT-1810
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  orgLabel=Pilot Recreational Vehicle

Search By Carrier Name PILOT RV
    [Tags]  qTest:31179327  Regression  JIRA:BOT-1811
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Name  MICHAEL TORSAK  orgLabel=Pilot Recreational Vehicle

Search By AR Number PILOT RV
    [Tags]  qTest:31179328  Regression  JIRA:BOT-1813
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  AR Number  0010832201035  orgLabel=Pilot Recreational Vehicle

Search By Min And Max Maount PILOT RV
    [Tags]  qTest:31179329  Regression  JIRA:BOT-1814
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  MIN=1  MAX=100  orgLabel=Pilot Recreational Vehicle

Search By Transaction ID SHELL
    [Tags]  qTest:31996786  Regression  JIRA:BOT-1787
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans ID  760821798    startDate=2019-04-13  endDate=2019-04-15  orgLabel=Shell Canada Products

Search By Transaction Number SHELL
    [Tags]  qTest:31996787  Regression  JIRA:BOT-1788
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans Num  201904130145  startDate=2019-04-13  endDate=2019-04-15  orgLabel=Shell Canada Products

Search By Carrier ID SHELL
    [Tags]  qTest:31996788  Regression  JIRA:BOT-1789
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  orgLabel=Shell Canada Products

Search By Carrier Name SHELL
    [Tags]  qTest:31996789  Regression  JIRA:BOT-1790
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Name  MICHAEL TORSAK  orgLabel=Shell Canada Products

Search By AR Number SHELL
    [Tags]  qTest:31996790  Regression  JIRA:BOT-1791
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  AR Number  0010832201035  orgLabel=Shell Canada Products

Search By Min And Max Maount SHELL
    [Tags]  qTest:31996791  Regression  JIRA:BOT-1792
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  MIN=1  MAX=100  orgLabel=Shell Canada Products

Search By Transaction ID Imperial
    [Tags]  qTest:31996797  Regression  JIRA:BOT-1794
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans ID  760821798    startDate=2019-04-13  endDate=2019-04-15  orgLabel=Imperial Oil

Search By Transaction Number Imperial
    [Tags]  qTest:31996798  Regression  JIRA:BOT-1795
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans Num  201904130145  startDate=2019-04-13  endDate=2019-04-15  orgLabel=Imperial Oil

Search By Carrier ID Imperial
    [Tags]  qTest:31996799  Regression  JIRA:BOT-1796
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  orgLabel=Imperial Oil

Search By Carrier Name Imperial
    [Tags]  qTest:31996800  Regression  JIRA:BOT-1797
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Name  MICHAEL TORSAK  orgLabel=Imperial Oil

Search By AR Number Imperial
    [Tags]  qTest:31996801  Regression  JIRA:BOT-1798
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  AR Number  0010832201035  orgLabel=Imperial Oil

Search By Min And Max Maount Imperial
    [Tags]  qTest:31996802  Regression  JIRA:BOT-1799
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  MIN=1  MAX=100  orgLabel=Imperial Oil

Search By Transaction ID Irving
    [Tags]  qTest:31996807  Regression  JIRA:BOT-1801
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans ID  760821798    startDate=2019-04-13  endDate=2019-04-15  orgLabel=Irving Oil Marketing

Search By Transaction Number Irving
    [Tags]  qTest:31996808  Regression  JIRA:BOT-1802
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Trans Num  201904130145  startDate=2019-04-13  endDate=2019-04-15  orgLabel=Irving Oil Marketing

Search By Carrier ID Irving
    [Tags]  qTest:31996809  Regression  JIRA:BOT-1803
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  orgLabel=Irving Oil Marketing

Search By Carrier Name Irving
    [Tags]  qTest:31996810  Regression  JIRA:BOT-1804
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Name  MICHAEL TORSAK  orgLabel=Irving Oil Marketing

Search By AR Number Irving
    [Tags]  qTest:31996811  Regression  JIRA:BOT-1805
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  AR Number  0010832201035  orgLabel=Irving Oil Marketing

Search By Min And Max Maount Irving
    [Tags]  qTest:31996812  Regression  JIRA:BOT-1806
    [Teardown]  run keyword if test failed  refresh page
    Search By No Row Validation  Carrier ID  1000020  MIN=1  MAX=100  orgLabel=Irving Oil Marketing

Search by Trans ID SFJ
    [Tags]  JIRA:BOT-1816  qTest:32282632  Regression  refactor
    [Teardown]  run keyword if test failed  refresh page

    Search By Using SFJ Org ID  Trans ID  181345883  startDate=2019-01-01  endDate=2019-01-02

Search By Trans Num SFJ
    [Tags]  JIRA:BOT-1817  qTest:32282679  Regression  refactor
    [Teardown]  run keyword if test failed  refresh page

    Search By Using SFJ Org ID  Trans Num  11412419  startDate=2019-01-01  endDate=2019-01-02

Search By Carrier ID SFJ
    [Tags]  JIRA:BOT-1818  qTest:32282680  Regression  refactor
    [Teardown]  run keyword if test failed  refresh page

    Search By Using SFJ Org ID  Carrier ID  400004  startDate=2019-01-01  endDate=2019-01-02

Search By Carrier Name SFJ
    [Tags]  JIRA:BOT-1819  qTest:32282681  Regression  refactor
    [Teardown]  run keyword if test failed  refresh page
    Search By Using SFJ Org ID  Name  RHEINLAND TRANSPORTATION LTD  startDate=2019-01-01  endDate=2019-01-02

Search By AR Number SFJ
    [Tags]  JIRA:BOT-1820  qTest:32282682  Regression  refactor
    [Teardown]  run keyword if test failed  refresh page
    Search By Using SFJ Org ID  AR Number  0005590600862  startDate=2019-01-01  endDate=2019-01-02

Search By Min And Max Amount SFJ
    [Tags]  JIRA:BOT-1821  qTest:32282685  Regression
    [Teardown]  run keyword if test failed  refresh page
    Search By  Carrier ID  400004  MIN=1  MAX=100  startDate=2019-01-01  endDate=2019-01-02

*** Keywords ***
Set Up Suite
    Open Browser to portal
    Log Into Portal
    Select Portal Program  AR Manager
    ${TODAY}=  getdatetimenow  %Y-%m-%d
    set global variable  ${TODAY}

    ${DayBeforeYesterday}=  getdatetimenow  %Y-%m-%d  days=-2
    set global variable  ${DayBeforeYesterday}

Search By
    [Arguments]  ${Input_Field}  ${input}  ${orgLabel}=EFS LLC  ${startDate}=${DayBeforeYesterday}  ${endDate}=${TODAY}  ${MIN}=${EMPTY}  ${MAX}=${EMPTY}

    select from list by label  orgId  ${orgLabel}
    input text  //*[text()="${Input_Field}"]/..//input  ${input}
    input text  transEndDate  ${endDate}
    input text  transStartDate  ${startDate}
    input text  minAmount  ${MIN}
    input text  maxAmount  ${MAX}

    click portal button  Search
    Wait Until Done Processing  60  Search Did Not Complete Within 60 Seconds
    input text  //*[text()="${Input_Field}"]/..//input  ${Empty}
    ${count}=  Get Element Count  //table[@id="resultsTable"]//tr[@onclick]
    run keyword if  ${count} < 1  Fail  Expected Results From the Search but recieved None

Search By Using SFJ Org ID
    [Arguments]  ${Input_Field}  ${input}  ${orgLabel}=SFJ  ${startDate}=${DayBeforeYesterday}  ${endDate}=${TODAY}  ${MIN}=${EMPTY}  ${MAX}=${EMPTY}

    select from list by label  orgId  ${orgLabel}
    input text  //*[text()="${Input_Field}"]/..//input  ${input}
    input text  transEndDate  ${endDate}
    input text  transStartDate  ${startDate}
    input text  minAmount  ${MIN}
    input text  maxAmount  ${MAX}

    click portal button  Search
    Wait Until Done Processing  60  Search Did Not Complete Within 60 Seconds
    input text  //*[text()="${Input_Field}"]/..//input  ${Empty}
    ${count}=  Get Element Count  //table[@id="resultsTable"]//tr[@onclick]
    run keyword if  ${count} < 1  Fail  Expected Results From the Search but recieved None

Search By No Row Validation
    [Documentation]  This is identical however it doesn't check the table for rows. Oracle is not currently running for PILOT RV so we have no data in protal in AR Manager
    [Arguments]  ${Input_Field}  ${input}  ${orgLabel}=EFS LLC  ${startDate}=${DayBeforeYesterday}  ${endDate}=${TODAY}  ${MIN}=${EMPTY}  ${MAX}=${EMPTY}

    select from list by label  orgId  ${orgLabel}
    input text  //*[text()="${Input_Field}"]/..//input  ${input}

    input text  transStartDate  ${startDate}
    input text  transEndDate  ${endDate}

    input text  minAmount  ${MIN}
    input text  maxAmount  ${MAX}

    click portal button  Search
    Wait Until Done Processing  60  Search Did Not Complete Within 60 Seconds
    input text  //*[text()="${Input_Field}"]/..//input  ${Empty}
    ${count}=  Get Element Count  //table[@id="resultsTable"]//tr[@onclick]
#    run keyword if  ${count} < 1  Fail  Expected Results From the Search but recieved None






