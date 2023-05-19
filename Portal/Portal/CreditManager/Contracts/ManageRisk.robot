*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  String
Library  otr_robot_lib.ui.web.PySelenium

Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Force Tags  Portal  Credit Manager  weekly
Documentation  This file updates the limits on the Credit Manager Home Page > Limits tab

Suite Setup  Open Browser And Login To Portal
Suite Teardown  Close Everything

*** Variables ***

*** Test Cases ***

Credit Manager - Manage Risk - Imperial Oil - Changing up for LA Limited Assessment
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the LA Limited Assessment option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  950877  2381

    Save Current Risk Rating
    Change Risk Rating to  LA Limited Assessment
    Assert Risk Rating  LA Limited Assessment

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - Imperial Oil - Changing up for C1 Very Low
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the C1 Very Low option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  950877  2381

    Save Current Risk Rating
    Change Risk Rating to  C1 Very Low
    Assert Risk Rating  C1 Very Low

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - Imperial Oil - Changing up for C2 Low
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the C2 Low option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  950877  2381

    Save Current Risk Rating
    Change Risk Rating to  C2 Low
    Assert Risk Rating  C2 Low

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - Imperial Oil - Changing up for C3 Medium
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the C3 Medium option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  950877  2381

    Save Current Risk Rating
    Change Risk Rating to  C3 Medium
    Assert Risk Rating  C3 Medium

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - Imperial Oil - Changing up for C4 High
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the C4 High option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  950877  2381

    Save Current Risk Rating
    Change Risk Rating to  C4 High
    Assert Risk Rating  C4 High

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - Imperial Oil - Changing up for C5 Very High
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the C5 Very High option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  950877  2381

    Save Current Risk Rating
    Change Risk Rating to  C5 Very High
    Assert Risk Rating  C5 Very High

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - EFS - Changing up for Limited Assessment
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the Limited Assessment option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  102810  2381

    Save Current Risk Rating
    Change Risk Rating to  Limited Assessment
    Assert Risk Rating  Limited Assessment

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - EFS - Changing up for Very Low
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the Very Low option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  102810  2381

    Save Current Risk Rating
    Change Risk Rating to  Very Low
    Assert Risk Rating  Very Low

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - EFS - Changing up for Low
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the Low option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  102810  2381

    Save Current Risk Rating
    Change Risk Rating to  Low
    Assert Risk Rating  Low

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - EFS - Changing up for Medium
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the Medium option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  102810  2381

    Save Current Risk Rating
    Change Risk Rating to  Medium
    Assert Risk Rating  Medium

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - EFS - Changing up for High
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the High option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  102810  2381

    Save Current Risk Rating
    Change Risk Rating to  High
    Assert Risk Rating  High

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - EFS - Changing up for Very High
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is possible to manage the risk rating in the Credit Manager. Assert if the Very High option is available for the user.
    [Setup]  Go To Credit Manager And Select Contract  102810  2381

    Save Current Risk Rating
    Change Risk Rating to  Very High
    Assert Risk Rating  Very High

   [Teardown]  Change Risk Rating to  ${originalRiskRating}

Credit Manager - Manage Risk - Imperial Oil - Check Disabled Risk Rating
    [Tags]  JIRA:PORT-56  JIRA:PORT-73  qTest:38988073
    [Documentation]  This test is to verify if it is not possible to manage the risk rating in the Credit Manager. Assert if the Risk Rating option is disabled for the user.
    [Setup]  Go To Credit Manager And Select Contract  950797  1858

    Assert Disabled Risk Rating


*** Keywords ***

Close Everything
    Close All Browsers

Open Browser And Login To Portal
    Open Browser to portal
    Log Into Portal  ${PortalUsername}  ${PortalPassword}

Go To Credit Manager And Select Contract
    [Arguments]  ${carrier}  ${contract}

    wait until element is enabled  //*[@id="pmd_home"]  timeout=60
    Click Element  //*[@id="pmd_home"]      #GO BACK TO THE HOME PAGE
    Wait Until Element Is Visible  //*[text()[contains(.,"Credit Manager")]]  timeout=60
    Select Portal Program  Credit Manager
    wait until element is visible  request.search.carrierId  timeout=60
    Input Text  request.search.carrierId  ${carrier}
    Click Portal Button  Search
    wait until element is enabled  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]  timeout=120
    Double Click Element  //*[@id="resultsTable"]//*[contains(text(), '${contract}')]

Change Risk Rating to
    [Arguments]  ${score}

    Wait Until Element Is Visible  //ul/li//span[text()='Setup']  timeout=60
    Click Element  //ul/li//span[text()='Setup']
    Wait Until Page Contains Element  request.contract.riskScore  timeout=100

    Select From List by Label  request.contract.riskScore  ${score}
    Click Portal Button  Save
    Wait Until Element Is Visible  //div[contains(text(),'The account was successfully saved')]  timeout=100
    Click Element  //div[contains(text(),'The account was successfully saved')]//a/*/*[text()="OK"]
    Wait Until Element Is Visible  //a/*/*[text()="Refresh"]
    Click Portal Button  Refresh

    ${status}  run keyword and return status  Wait Until Element Is Visible  //*[@id="refreshConfirm_content"]  timeout=30
    Run Keyword If  ${status}==${True}
    ...  Click Portal Button  Yes

    Wait Until Element Is Not Visible  //div[contains(text(),'Please wait while the selected contract is loaded')]  timeout=100

Assert Risk Rating
    [Arguments]  ${score}
    Wait Until Element Is Visible  //ul/li//span[text()='Setup']  timeout=60
    Click Element  //ul/li//span[text()='Setup']
    Wait Until Page Contains Element  request.contract.riskScore  timeout=100
    ${selectedScore}  get text  //select[@name='request.contract.riskScore']//option[contains(@selected,'selected')]
    Should Be Equal As Strings  ${score}  ${selectedScore}

Save Current Risk Rating
    Wait Until Element Is Visible  //ul/li//span[text()='Setup']  timeout=60
    Click Element  //ul/li//span[text()='Setup']
    Wait Until Page Contains Element  request.contract.riskScore  timeout=100
    ${currentRiskRating}  Get Selected List Label  request.contract.riskScore
    tch logging  \noriginalRiskRating:${currentRiskRating}
    set test variable  ${originalRiskRating}  ${currentRiskRating}

Assert Disabled Risk Rating
    Wait Until Element Is Visible  //ul/li//span[text()='Setup']  timeout=60
    Click Element  //ul/li//span[text()='Setup']
    Wait Until Page Contains Element  request.contract.riskScore  timeout=100
    Wait Until Page Contains Element  //*[contains(text(),'Risk')]//parent::div/following-sibling::div/select[@disabled='disabled']