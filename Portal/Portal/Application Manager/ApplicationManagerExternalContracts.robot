*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Setup
Suite Teardown  close all browsers
Force Tags  Portal  Application Manager  weekly
Documentation  This is to test if a user can search and access external contracts
...  using every search filter
#this needs to be converted into keywords later
#this needs to run only weekly

*** Variables ***
${contract_type}

*** Test Cases ***

Search for external contracts with contract type Chanhassen MSA Agreements
    [Tags]  JIRA:BOT-1658  qTest:31652694  Regression
    [Documentation]  ​​This is to test if a user can search for an external contract using contract type filter
    Search on External Contracts  contractType  Chanhassen MSA Agreements

Search for external contracts with contract type Chanhassen OTR/Permits
    [Tags]  JIRA:BOT-1658  qTest:31652694  Regression
    Search on External Contracts  contractType  Chanhassen OTR/Permits

Search for external contracts with contract type Corporate MasterCard
    [Tags]  JIRA:BOT-1658  qTest:31652694  Regression
    Search on External Contracts  contractType  Corporate MasterCard

Search for external contracts with contract type Memphis MSA Agreements
    [Tags]  JIRA:BOT-1658  qTest:31652694  Regression
    Search on External Contracts  contractType  Memphis MSA Agreements

Search for external contracts with contract type NDA'S
    [Tags]  JIRA:BOT-1658  qTest:31652694  Regression
    Search on External Contracts  contractType  NDA'S
# rest of the filters doesnt have data

Search for external contracts with Sales Territory E1 - Tyler Atkin
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    [Documentation]  This is to test if a user can search for an external contract using Sales Territory filter
    Search on External Contracts  salesTerritory  E1 - Tyler Atkin

Search for external contracts with Sales Territory E2 - Lindsay Call
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    Search on External Contracts  salesTerritory  E2 - Lindsay Call

Search for external contracts with Sales Territory E3 - Cathy Johns
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    Search on External Contracts  salesTerritory  E3 - Cathy Johns

Search for external contracts with Sales Territory EN - Northeast Territory
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    Search on External Contracts  salesTerritory  EN - Northeast Territory

Search for external contracts with Sales Territory ES - Southeast Territory
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    Search on External Contracts  salesTerritory  ES - Southeast Territory

Search for external contracts with Sales Territory W1 - Ryan Knowles
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    Search on External Contracts  salesTerritory  W1 - Ryan Knowles

Search for external contracts with Sales Territory W2 - Ian Wilkinson
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    Search on External Contracts  salesTerritory  W2 - Ian Wilkinson

Search for external contracts with Sales Territory W3 - Open
    [Tags]  JIRA:BOT-1659  qTest:31652771  Regression
    Search on External Contracts  salesTerritory  W3 - Open

Search with Account Number
    [Tags]  JIRA:BOT-1660  qTest:31652774  Regression
    [Documentation]  This is to test if a user can search for an external contract using Account Number
    Search on External Contracts  referenceId  64739375839

Search with name contains
    [Tags]  JIRA:BOT-1661  qTest:31652775  Regression
    [Documentation]  This is to test if a user can search for an external contract using contract name
    Search on External Contracts  name  EL ROBOT

Search for external contract with Sales status
    [Tags]  JIRA:BOT-1662  qTest:31652808  Regression
    [Documentation]  This is to test if a user can search for an external contract using status filter
    Search on External Contracts  status  Sales

Search for external contract with Contract Approval status
    [Tags]  JIRA:BOT-1662  qTest:31652808  Regression
    Search on External Contracts  status  Contract Approval

Search for external contract with Assign Account status
    [Tags]  JIRA:BOT-1662  qTest:31652808  Regression
    Search on External Contracts  status  Assign Account

Search for external contract with Credit status
    [Tags]  JIRA:BOT-1662  qTest:31652808  Regression
    Search on External Contracts  status  Credit

Search for external contract with Proofing status
    [Tags]  JIRA:BOT-1662  qTest:31652808  Regression
    Search on External Contracts  status  Proofing

Search for external contracts with PSR being Yes
    [Tags]  JIRA:BOT-1663  qTest:31652809  Regression
    [Documentation]  This is to test if a user can search for an external contract using PSR filter
    Search on External Contracts  psr  Yes

Search for external contracts with PSR being No
    [Tags]  JIRA:BOT-1663  qTest:31652809  Regression
    Search on External Contracts  psr  No

Create a contract type
    [Tags]  JIRA:BOT-1664  qTest:31652879  Regression  JIRA:BOT-2031
    [Documentation]  This is to test if a user can add a contract type to the 'Contract Type' list
    ${contract_type}  Generate Random String  6  [LETTERS]
    Set Suite Variable  ${contract_type}

    click portal button  Contract Types  times=1
    wait until element is visible  xpath=//*[@id="extContTypes_content"]
    click portal button  Add  //*[@id="extContTypes_content"]  times=1
    wait until element is enabled  //*[@name="request.type.name"]
    input text  request.type.name  ${contract_type}
    click portal button  Save  times=1
    wait until element is enabled  xpath=//*[@id="extContTypes_content"]  timeout=10
    sleep  1
    click portal button  Close  times=1
    refresh page
    wait until element is enabled  xpath=//*[@name="request.search.contractType"]
    ${list}=  get list items   request.search.contractType
    list should contain value  ${list}  ${contract_type}

Delete a contract type
    [Tags]  JIRA:BOT-1664  qTest:31652882  Regression  JIRA:BOT-2031  refactor
    [Documentation]  This is to test if a user can delete a contract type from the 'Contract Type' list
    click portal button  Contract Types  times=1
    wait until element is enabled  //*[@id="typeList"]/tbody/tr[3]/td[2]/div/span[1]  timeout=30s
    scroll element into view  //*[@id="typeList"]//descendant::*[contains(text(),'${contract_type}')]
    wait until element is visible  xpath=//*[@id="extContTypes_content"]
    click element  //*[@id="typeList"]//descendant::*[contains(text(),'${contract_type}')]
    wait until element is enabled  //*[@id="extContTypes_content"]/a[3]/div  timeout=30
    click portal button  Delete  //*[@id="extContTypes_content"]  times=1
    click element  //*[@id="deleteConfirm_content"]/div[2]/a[1]/div
    wait until element is enabled  xpath=//*[@id="extContTypes_content"]  timeout=20
    click portal button  Close  times=1
    refresh page
    wait until element is enabled  xpath=//*[@name="request.search.contractType"]
    ${list}=  get list items  request.search.contractType
    list should not contain value  ${list}  ${contract_type}

*** Keywords ***
Setup
    Open Browser to portal
    ${status}=  Log Into Portal
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}
    Select Portal Program  Application Manager
    click element  //*[@id="pm_1"]
    wait until element is visible  id=searchForm