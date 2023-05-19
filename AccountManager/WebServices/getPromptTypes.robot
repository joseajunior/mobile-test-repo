*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***

Validate Prompt Types Informations
    [Tags]  JIRA:BOT-1584  qTest:30855323  Regression
    [Documentation]  Validate all informations returned from getPromptTypes
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

    ${promptTypes}  getPromptTypes

    Sort List  ${promptTypes}

    remove values from list  ${promptTypes}  CRDR

#    Check Prompt Types  ${promptTypes}
# We are not sure which the database table it is
    [Teardown]  Logout

*** Keywords ***
Check Prompt Types
    [Arguments]  ${promptTypes}
    Get Into DB  tch

    ${query}  Catenate
    ...  SELECT TRIM(tch_prompt) AS value
    ...  FROM prompt_ref;

    ${results}  Query and Strip To Dictionary  ${query}

    ${results}  get from dictionary  ${results}  value

    Sort List  ${results}

    remove values from list  ${results}  VEHN
    remove values from list  ${results}  SSEC

    should be equal  ${results}  ${promptTypes}