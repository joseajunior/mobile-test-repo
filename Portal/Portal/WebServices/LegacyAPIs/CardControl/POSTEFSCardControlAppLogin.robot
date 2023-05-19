*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Library         RequestsLibrary
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  send POST request to log into the EFS card control app
Force Tags  API  Mobile

*** Variables ***
${login}  /efs-json/user/login
${session_alias}  eManager

*** Test Cases ***
Successfully Log Into EFS Card Control App
    [Documentation]  send POST request to log into the EFS card control app
    [Tags]  PI:15  JIRA:OS5A-505  qTest:117438089
    [Setup]  Find A Random Card Number and Pin Number To Be Used In The API Request
    Log In To Mobile App

*** Keywords ***
Find A Random Card Number And Pin Number To Be Used In The API Request
    [Documentation]  Find Data To Be Used in Test
    Find Card Number And Pin Number
    RequestsLibrary.Create Session  ${session_alias}  ${emanager}${login}

Find Card Number And Pin Number
    [Documentation]  Select a Card Number with the Related Pin Number
     Get Into DB  tch
    ${tch_query}  Catenate  select trim(cp.card_num) as card_num, cp.pin, c.card_id
    ...  from card_pins cp inner join cards c on
    ...  c.card_num=cp.card_num
    ...  where substrB(TRIM(cp.card_num), 15) <> cp.pin and cp.status = 'A' and cp.valid = 'Y'
    ...  order by cp.set DESC
    ...  limit 50;
    ${query_results}  Query And Return Dictionary Rows  ${tch_query}

    Disconnect From Database
    ${my_cards}  evaluate  [d['card_num'] for d in ${query_results}]
    ${my_cards_str}  create list for query from list  ${my_cards}
    Get into DB  MySQL
    ${mysqlquery}  Catenate  select user_id
    ...  from sec_user where user_id in (${my_cards_str})
    ...  and status_id = 'A'
    ...  and (passwd_expire_date >= curdate()
    ...  or passwd_expire_date  is NULL)
    ${mysqlquery}  Query And Return Dictionary Rows  ${mysqlquery}
    ${mysqlquery}  evaluate  [d['user_id'] for d in ${mysqlquery}]

    ${intersectionoftwolists}  evaluate  [val for val in ${mysqlquery} if val in ${my_cards}]
    ${itemsinqueries}  evaluate  [d for d in ${queryresults} if d['card_num'] in ${intersectionoftwolists}]
    ${mytestdata}  evaluate  random.choice(${itemsinqueries})
    Set Test Variable  ${mytestdata}

Find Values For Validation
    [Documentation]  Find Values to Compare to Response Object
    Get Into DB  MySQL
    ${mysqlquery}  Catenate  select user_fname, user_lname
    ...  from sec_user
    ...  where user_id = '${mytestdata}[card_num]' limit 1
    ${mysqlquery}  Query And Return Dictionary Rows  ${mysqlquery}

    Disconnect From Database
    [Return]  ${mysqlquery}

Log In To Mobile App
    [Documentation]  send request to endpoint
    ${login_payload}    Catenate    {
    ...    "appVersion":"4.4.6",
    ...    "userName":${mytestdata}[card_num],
    ...    "password":${mytestdata}[pin],
    ...    "osVersion":"8.0",
    ...    "appName":"EFS_CardControl",
    ...    "appId":"EFS",
    ...    "osType":"android"
    ...    }
    ${response}  RequestsLibrary.POST On Session    ${session_alias}
    ...    ${emanager}${login}    ${login_payload}
    ${Data}  Find Values For Validation
    Status Should Be                 200  ${response}
    Should Be Equal As Strings  ${response.json()}[customerUserName]  ${mytestdata}[card_num]
    Should Be Equal As Strings  ${response.json()}[firstName]  ${Data}[0][user_fname]
    Should Be Equal As Strings  ${response.json()}[lastName]  ${Data}[0][user_lname]