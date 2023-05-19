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

Documentation  send POST request to search for recent transactions on a card
Force Tags  API  Mobile

*** Variables ***
${login}  /efs-json/user/login
${transaction}  /efs-json/card/smartActivity
${session_alias}  eManager

*** Test Cases ***
Successfully Search For Recent Transactions On A Card
    [Documentation]  send POST request to search for recent transactions on a card
    [Tags]  PI:15  JIRA:OS5A-505  qTest:117506833
    [Setup]  Find A Random Card Number And Pin Number To Be Used In The API Request
    Log In To Mobile App
    Send Request To Get Recent Transactions
    Compare Database Values With Search Recent Transactions JSON Response

*** Keywords ***

Send Request To Get Recent Transactions
    [Documentation]  Generate list of recent transactions
    ${login_payload}  Catenate  {
    ...  "rows": 5,
    ...  "cardId": "${mytestdata}[card_id]",
    ...  "cardSide": "${mytestdata}[payr_use]"
    ...  }
    ${response}  RequestsLibrary.POST On Session    ${session_alias}
    ...  ${emanager}${transaction}
    ...  ${login_payload}
    Set Test Variable  ${response}

Retrieve Response Values from Database
    [Documentation]  Retrieves data for response comparison
    Get Into DB  tch
    ${tch_query}  Catenate  select to_char(trans_date,'%Y-%m-%dT%I:%M:00') as trans_date, trans_id, invoice
    ...  from transaction
    ...  where card_num = '${mytestdata}[card_num]'
    ...  order by trans_date desc, invoice
    ...  limit 5;
    ${transtableresponse}   Query And Return Dictionary Rows  ${tch_query}
    Set Test Variable  ${transtableresponse}
    Disconnect From Database

Compare Database Values With ${ENDPOINT} JSON Response
    [Documentation]  Compare Database Values with Response Object
    Retrieve Response Values from Database
    Status Should Be  200  ${response}

    Should Be Equal As Strings  ${response.json()}[rows][0][tranDate]  ${transtableresponse}[0][trans_date]
    Should Be Equal As Strings  ${response.json()}[rows][0][invoice]  ${transtableresponse[0]['invoice'].strip()}
    Should Be Equal As Strings  ${response.json()}[rows][0][tranId]  ${transtableresponse}[0][trans_id]

Find A Random Card Number And Pin Number To Be Used In The API Request
    [Documentation]  Find Data To Be Used in Test
    Find Card Number And Pin Number
    RequestsLibrary.Create Session  ${session_alias}  ${emanager}

Find Card Number And Pin Number
    [Documentation]  Select a Card Number with the Related Pin Number
     Get Into DB  tch
    ${tch_query}  Catenate  select trim(cp.card_num) as card_num, cp.pin, c.card_id, c.payr_use
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
    ${mysqlquery}  Catenate  select user_id from sec_user
    ...  where user_id in (${my_cards_str})
    ...  and status_id = 'A'
    ...  and (passwd_expire_date >= curdate()
    ...  or passwd_expire_date  is NULL)
    ${mysqlquery}  Query And Return Dictionary Rows  ${mysqlquery}
    ${mysqlquery}  evaluate  [d['user_id'] for d in ${mysqlquery}]
    Disconnect From Database

    ${intersectionoftwolists}  evaluate  [val for val in ${mysqlquery} if val in ${my_cards}]
    ${itemsinqueries}  evaluate  [d for d in ${queryresults} if d['card_num'] in ${intersectionoftwolists}]
    ${mytestdata}  evaluate  random.choice(${itemsinqueries})
    Set Test Variable  ${mytestdata}

Log In To Mobile App
    [Documentation]  Send Request to Endpoint
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
