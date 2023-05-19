*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.auth.PyAuth.Transactions
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services
Suite Setup  Suite Setup
Suite Teardown  Suite Teardown

*** Variables ***
${sitepolicy}
${policyName}  BOT1632

*** Test Cases ***
Creating a new site policy
    [Tags]  JIRA:BOT-1632  qTest:30973463  Regression  JIRA:BOT-1980  refactor
    [Documentation]  Validate that you create a new site policy and Check if site policy created is in database.

    ${sitepolicy}  createNewSitePolicy  ${policyName}
    Check site policy  ${sitepolicy}  ${UserName}

    [Teardown]  Delete Policy  ${UserName}  ${sitepolicy}

*** Keywords ***
Suite Setup
    Ensure Member is Not Suspended  ${UserName}
    Log Into Card Management Web Services  ${validCard.carrier.id}  ${validCard.carrier.password}

Suite Teardown
    Logout
    Disconnect From Database

Check Site Policy
    [Arguments]  ${sitepolicy}  ${carrier}
    Get Into DB  TCH

    ${sitepolicy}  Convert to Integer  ${sitepolicy}

    ${query}  Catenate
    ...  SELECT ipolicy
    ...  FROM def_card WHERE id=${carrier} AND ipolicy=${sitepolicy};

    ${results}  Query and Strip To Dictionary  ${query}

    Should Be Equal  ${results["ipolicy"]}   ${sitepolicy}