*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Time To Setup
Suite Teardown  close all browsers
Force Tags  Portal  Credit Manager  Shifty
Documentation  This script covers the Carrier Tab Menu, Changing Carrier Status to Active, Inactive, and Closed

*** Test Cases ***

Set Carrier Status to Closed
    [Tags]  qTest:34242558  qTest:34015988  refactor
    [Documentation]  Validate that the Portal user can set carrier status to Closed
    [Setup]  Pull Up Carrier Tab Menu  ${card_num.carrier.id}  ${card_num.policy.contract.id}

    Set Carrier Status  C
    Validate Carrier Status  ${card_num.carrier.id}  C

Set Carrier Status to Inactive
    [Tags]  qTest:34242403  qTest:34015988  refactor
    [Documentation]  Validate that the Portal user can set carrier status to Inactive
    [Setup]  Pull Up Carrier Tab Menu  ${card_num.carrier.id}  ${card_num.policy.contract.id}

    Set Carrier Status  I
    Validate Carrier Status  ${card_num.carrier.id}  I

Set Carrier Status to Active
    [Tags]  qTest:34241984  qTest:34015988  refactor
    [Documentation]  Validate that the Portal user can set carrier status to Active
    [Setup]  Pull Up Carrier Tab Menu  ${card_num.carrier.id}  ${card_num.policy.contract.id}

    Set Carrier Status  A
    Validate Carrier Status  ${card_num.carrier.id}  A

*** Keywords ***

Time To Setup
    Open Browser to portal
    get into db  tch
    Set Valid Carrier and Card Number
    start setup card  ${card_num.num}
    Log Into Portal

Pull Up Carrier Tab Menu
    [Arguments]  ${carrier}  ${contract}
    Return to Portal Home
    Select Portal Program  Credit Manager    #Open Credit Manager
    Input Text  request.search.carrierId  ${carrier}
    Click Portal Button  Search
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]  timeout=120
    Double Click Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]
    Wait Until Page Contains Element  //div/ul/li//div//span[text()="Limits"]  timeout=60
    Click Element  //span[text()="Carrier"]    #Pull up the Carrier Tab
    Wait Until Page Contains Element  //select[@name="request.carrier.status"]  timeout=20

Set Carrier Status
    [Arguments]  ${carrier_status}
    Select From List By Value  //select[@name="request.carrier.status"]  ${carrier_status}
    Click Element  //div/*[contains(text(), "Save")]
    Wait Until Element Is Visible  //div/*[contains(text(), "The carrier was successfully saved.")]

Validate Carrier Status
    [Arguments]  ${carrier}  ${carrier_status}
    ${db_status}  query and strip  SELECT status FROM member WHERE member_id = ${carrier}
    Should Be Equal As Strings   ${db_status}  ${carrier_status}  Carrier status was not what we expected. Expected value was ${carrier_status}, actual value was ${db_status}


Set Valid Carrier and Card Number
    ${query}  Catenate  SELECT c.card_num
    ...                     FROM cards c
    ...                         INNER JOIN contract co ON (c.carrier_id = co.carrier_id)
    ...                         INNER JOIN member m ON (c.carrier_id = m.member_id)
    ...                     WHERE c.status = 'A'
    ...                     AND c.card_type = 'TCH'
    ...                     AND payr_status = 'A'
    ...                     AND	payr_use = 'B'
    ...                     AND mrcsrc = 'N'
    ...                     AND	payr_mrcsrc = 'Y'
    ...                     LIMIT 1
    ${card_num}=  find card variable  ${query}
    set suite variable  ${card_num}

