*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services

*** Variables ***
${logged_out}
${response}
${status}

*** Test Cases ***

Webservice logout
    [Tags]  tier:0
    [Documentation]  Validate that's possible to logout from WS.
    [Setup]  Login with a valid carrier

    Call logout Webservice
    Verify that the user was logged out successfully

Logout and call a web service
    [Tags]
    [Documentation]  Validate that it's not possible to call another service once you performed the logout.
    [Setup]  Login with a valid carrier

    Call logout Webservice
    Call a different Webservice method
    Make sure that it was not possible to call another Webservice when logged out
    Make sure that the user received "Could Not Get Contract Credit Limits" as proper error message

*** Keywords ***

Login with a valid carrier
    [Documentation]  This keyword will call the Login Webservice with a valid carrier to support the logout test.

    Log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Call logout Webservice
    [Documentation]  This keyword will call the Logout Webservice.

    Logout

Verify that the user was logged out successfully
    [Documentation]  This keyword will verify if the user was logged out.

    ${status}  ${response} =  Run Keyword And Ignore Error  getCard  ${validCard}
    Should Contain  ${status}  FAIL

    set test variable  ${status}
    set test variable  ${response}

Call a different Webservice method

    ${status}  ${response} =  Run Keyword And Ignore Error  getCreditLimits  ${validCard.contract}
    set test variable  ${status}
    set test variable  ${response}

Make sure that it was not possible to call another Webservice when logged out

    Should Contain  ${status}  FAIL

Make sure that the user received "${error}" as proper error message

    [Documentation]  This keyword will validate that the user is receiving the proper error message.

    Should Contain  ${response}  ${error}

