*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services

*** Variables ***
${logged_in}
${response}

*** Test Cases ***

Webservice login as an invalid carrier password
    [Tags]
    [Documentation]  This test case will cover an attempt of login with a invalid password by stripping the last two
    ...  characters of the validCard carrier password.

    Call login Webservice with user "${validCard.carrier.id}" and password "${validCard.carrier.password[:-2]}"
    Make sure it was not possible to login
    Make sure that the user received "Invalid login" as proper error message

Webservice login as an invalid carrier
    [Tags]
    [Documentation]  This test case will cover an attempt of login with a invalid carrier by adding the 'error' word
    ...  at the end of validCard carrier.

    Call login Webservice with user "${validCard.carrier.id}error" and password "${validCard.carrier.password}"
    Make sure it was not possible to login
    Make sure that the user received "Invalid login" as proper error message

Webservice login as an inactive carrier

    [Tags]  refactor
    [Documentation]  This test case will conver a login attempt of a suspended/inactive carrier.
    [Setup]  Suspend user "${validCard.carrier.id}"

    Call login Webservice with user "${validCard.carrier.id}" and password "${validCard.carrier.password}"
    Make sure it was not possible to login
    Make sure that the user received "Contact Customer Service" as proper error message

    [Teardown]  Restore active status from user "${validCard.carrier.id}"

Webservice login as a valid carrier
    [Tags]  tier:0
    [Documentation]  This test case will cover an attempt of login with a valid carrier.

    Call login Webservice with user "${validCard.carrier.id}" and password "${validCard.carrier.password}"
    Make sure the user has logged in

Webservice login with an invalid user password
    [Tags]
    [Documentation]  This test case will cover an attempt of login with a invalid password by stripping the last two
    ...  characters of the user password.

    Call login Webservice with user "100025kev" and password "hoaWurS"
    Make sure it was not possible to login
    Make sure that the user received "Invalid login" as proper error message

Webservice login as an invalid user
    [Tags]
    [Documentation]  This test case will cover an attempt of login with a invalid user by adding the 'error' word
    ...  at the end of the valid user.

    Call login Webservice with user "100025keverror" and password "hoaWurS635"
    Make sure it was not possible to login
    Make sure that the user received "Invalid login" as proper error message


Webservice login as an inactive user

    [Setup]  Suspend user "100025kev"
    [Tags]  refactor
    Call login Webservice with user "100025kev" and password "hoaWurS635"
    Make sure it was not possible to login
    Make sure that the user received "Contact Customer Service" as proper error message

    [Teardown]  Restore active status from user "100025kev"

Webservice login as an valid user
    [Tags]  refactor  tier:0
    [Documentation]  This test case will cover an attempt of login with a valid user.

    Call login Webservice with user "100025kev" and password "hoaWurS635"
    Make sure the user has logged in

*** Keywords ***

Setting the user status to
    [Documentation]  This keyword will be used to set the user status to the given argument.
    ...  A = Active , I = Inactive , S = Suspended
    [Arguments]  ${user}  ${status}

    get into db  mysql
    ${query} =  catenate  dml=UPDATE sec_user SET status_id='${status}' WHERE user_id = '${user}';
    execute sql string  ${query}
    Sleep  5
    ${select} =  query and strip  SELECT status_id FROM sec_user WHERE user_id ='${user}';


######################### Steps ###########################


Suspend user "${user}"
    [Documentation]  This keyword will set the user status to suspended

    Setting the user status to  ${user}  S

Restore active status from user "${user}"
    [Documentation]  This keyword will set the user status to Active

    Setting the user status to  ${user}  A

Call login Webservice with user "${user}" and password "${password}"

    [Documentation]  This keyword will be used to call the Login web service and return two variables for validation
    ...  variable logged_in being a boolean and variable response being a string.

    ${logged_in}  ${response} =  Run Keyword And Ignore Error  log into card management web services  ${user}  ${password}  ${False}
    set test variable  ${logged_in}
    set test variable  ${response}

Make sure it was not possible to login

    [Documentation]  This keyword will validate that the user is not logged in.

    Should Contain  ${logged_in}  FAIL

Make sure the user has logged in
    [Documentation]  This keyword will validate that the user is logged in.

    Should Contain  ${logged_in}  PASS

Make sure that the user received "${error}" as proper error message

    [Documentation]  This keyword will validate that the user is receiving the proper error message.

    Should Contain  ${response}  ${error}

