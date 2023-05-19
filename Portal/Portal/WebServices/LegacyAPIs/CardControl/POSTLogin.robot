*** Settings ***
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  Script to test the login endpoint of the Card Control used by Android and iOS apps.

Suite Setup  Setup The Env And Get Data

*** Test Cases ***
POST Successful Login Request
    [Documentation]  Test the successful scenario to POST Login to access the Card Control
    [Tags]  PI:15  JIRA:O5SA-504  qTest:117494131  CardControl
    POST Card Control Login Request
    Validate The API Response    Success

POST Login Request With Invalid Username
    [Documentation]  Test the endpoint behavior when using an invalid username
    [Tags]  PI:15  JIRA:O5SA-504  qTest:117494131  CardControl
    POST Card Control Login Request  username=8888888888888888888
    Validate The API Response    Fail

POST Login Request With Invalid Password
    [Documentation]  Test the endpoint behavior when using an invalid password
    [Tags]  PI:15  JIRA:O5SA-504  qTest:117494131  CardControl
    POST Card Control Login Request  password=88888
    Validate The API Response    Fail

*** Keywords ***
Setup The Env And Get Data
    [Documentation]    gather the data to use during the tests
    Get Url For Suite    ${emanager}

    ${query}  Catenate    select trim(ca.card_num) as card_num, cp.pin from cards ca
                   ...    inner join card_pins cp on (ca.card_num = cp.card_num)
                   ...    where ca.status = 'A'
                   ...    and cp.status = 'A'
                   ...    and cp.valid = 'A'
                   ...    and cp.card_num not like ('%' || cp.pin || '%') limit 250;
    Get Into Db    TCH
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    ${len}  Get Length  ${query}[card_num]
    ${len}  Evaluate  random.randint(0, $len-1)

    Set Suite Variable    ${card_num}  ${query}[card_num][${len}]
    Set Suite Variable    ${pin_num}  ${query}[pin][${len}]

POST Card Control Login Request
    [Documentation]  Prepares and make the request to the Login Endpoint for Card Control
    [Arguments]  ${username}=${card_num}  ${password}=${pin_num}

    ${url_stuff}  Create Dictionary    user=login
    ${payload}  Create Dictionary    appVersion  4.4.6  userName  ${username}  password  ${password}  osVersion  8.0
                              ...    appName  EFS_CardControl  appId  EFS  osType  android

    ${response}  ${status}  API Request    POST  efs-json  N  ${url_stuff}  application=OTR_eMgr  payload=${payload}

    Set Test Variable    ${response}
    Set Test Variable    ${status}

Validate The API Response
    [Documentation]  Validates the API responses
    [Arguments]  ${expected}

    IF  '${expected.lower()}'=='success'
        Should Be Equal As Strings    200  ${status}
        Should Be Equal As Strings    ${card_num}  ${response}[customerUserName]
    ELSE IF  '${expected.lower()}'=='fail'
        Should Be Equal As Strings    200  ${status}
        Should Be Equal As Strings    ERROR  ${response}[type]
        Should Be Equal As Strings    ILE_InvalidCardLogin  ${response}[code]
        Should Be Equal As Strings    []  ${response}[messages]
    ELSE
        Fail  Expected result '${expected}' not implemented yet
    END