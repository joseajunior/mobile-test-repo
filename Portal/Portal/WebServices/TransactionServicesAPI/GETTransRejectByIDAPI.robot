*** Settings ***
Library  String
Library  Collections
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library  otr_robot_lib.ws.PortalWS
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the Trans Rejects API (currently only works in dit because okta service is set up there)
Force Tags     transactionServicesAPI  API  ditOnly  refactor

*** Variables ***
@{endpoints}  BYID

*** Test Cases ***
GET Trans Rejects
    [Documentation]  Test the successful scenario to GET Trans Rejects By ID
    [Tags]   PI:14  JIRA:O5SA-385  qTest:97962899
    [Setup]  Genetare Data for Request  BYID
    Send GET API Request for Trans Reject BYID
    Compare GET Endpoint Results for Trans Reject BYID
    [Teardown]  Remove Automation User

GET Trans Rejects using an Invalid or No Token
    [Tags]  PI:14  JIRA:O5SA-385    qTest:97962938
    GET Trans Reject Error with Invalid or No Token
    [Teardown]  Remove Automation User

GET Trans Rejects using a User Not Related to Carrier
    [Tags]  PI:14  JIRA:O5SA-385   qTest:97962938
    GET Trans Reject Error with User Not Related to Carrier
    [Teardown]  Remove Automation User

GET Trans Rejects using an Invalid Carrier ID
    [Tags]  PI:14  JIRA:O5SA-385   qTest:97962938
    GET Trans Reject Error with Invalid Carrier ID
    [Teardown]  Remove Automation User

GET Trans Rejects using Letters as Carrier ID
    [Tags]  PI:14 JIRA:O5SA-385   qTest:97962938
    GET Trans Reject Error with Letters as Carrier ID
    [Teardown]  Remove Automation User

GET Trans Reject using an Empty Carrier ID
    [Tags]  PI:14 JIRA:O5SA-385   qTest:97962938
    GET Trans Reject Error with Empty Carrier ID
    [Teardown]  Remove Automation User

GET Trans Reject using an Empty Reject ID
    [Tags]  PI:14  JIRA:O5SA-385   qTest:97962938
    GET Trans Reject Error with Empty Reject ID
    [Teardown]  Remove Automation User

GET Trans Reject using Letters as Reject ID
    [Tags]  PI:14  JIRA:O5SA-385   qTest:97962938
    GET Trans Reject Error with Letters as Reject ID
    [Teardown]  Remove Automation User


*** Keywords ***
Genetare Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${type}
    Getting API URL
    ${carrier_from_infx}  Find Carrier And ID in Informix For Trans Rejects
    Set Suite Variable   ${carrier_from_infx}
    Create My User   persona_name=carrier_manager   entity_id=${carrier_from_infx}[carrier_id]

Getting API URL
    Get url for suite   ${transactionservices}


Send ${request_type} API Request for Trans Reject ${type}
    Send Request  ${request_type.upper()}   ${type}
#    Compare Data for Card Cash  ${request_type}  ${card_type}  ${limit_src}  ${cash_type}


Compare ${request_type} Endpoint Results for Trans Reject ${type}
    Compare Data for Trans Reject  ${request_type.upper()}  ${type}

Find Carrier and ID in Informix For Trans Rejects
    [Documentation]    find data to be used during the test and make the request with it
    ${data_query}  Catenate     select t.carrier_id, t.reject_id
                   ...          from recent_rejected_trans t where t.carrier_id != 0
                   ...          limit 1
    Get Into DB  TCH
    ${data_info}  Query And Strip To Dictionary  ${data_query}
    Disconnect From Database
    [Return]  ${data_info}

Send Request
    [Arguments]  ${request_type}  ${type}
    Trans Rejects  ${request_type} ${type}

Trans Rejects
    [Documentation]  Perform the request for Trans Reject By Id
    [Arguments]  ${request}   ${carrier}=${carrier_from_infx}[carrier_id]   ${reject_id}=${carrier_from_infx}[reject_id]   ${secure}=Y

    ${headers}  Create Dictionary  content-type=application/json
    ${url_stuff}  create dictionary  None=${reject_id}   carriers=${carrier}

   ${response}  ${status}  API Request  GET  transaction-rejects  ${secure}  ${url_stuff}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for Trans Reject
    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        ${result_from_DB}  Get Database Values for Trans Rejects  ${type}
        Should Be Equal As Strings  ${response}[details][data][reject_id]  ${result_from_DB}[0][reject_id]
        Should Be Equal As Strings  ${response}[details][data][location_id]  ${result_from_DB}[0][location_id]
        Should Be Equal As Strings  ${response}[details][data][location_name]  ${result_from_DB}[0][location_name]
        Should Be Equal As Strings  ${response}[details][data][err_code]  ${result_from_DB}[0][err_code]
        Should Be Equal As Strings  ${response}[details][data][invoice]  ${result_from_DB}[0][invoice]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END

Get Database Values for Trans Rejects
    [Arguments]  ${type}  ${optionals}=${EMPTY}
    IF  '${type}'=='BYID'
        ${db_values}  Get Trans Reject Information from Database
    ELSE
        log to console  type ${type} not supported
    END
    [Return]  ${db_values}

Get Trans Reject Information from Database
    [Documentation]  query to get trans reject information from database

   get into db  TCH
    ${query}  catenate  SELECT t.reject_id AS reject_id,
    ...  TRIM(t.invoice) AS invoice,
    ...  t.card_last4, TRIM(t.location_city) AS location_city,
    ...  t.location_id, TRIM(t.location_name) AS location_name, t.location_state,
    ...  t.err_code,
    ...  t.reject_datetime
    ...  FROM recent_rejected_trans t
    ...  WHERE t.carrier_id = '${carrier_from_infx}[carrier_id]' and t.reject_id = '${carrier_from_infx}[reject_id]'
    ${query}  query to dictionaries  ${query}
    Disconnect From Database
    [Return]  ${query}

GET Trans Reject Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
     ${carrier_info}  get variable value  $carrier_from_infx  default
    IF  '''${carrier_info}'''=='''default'''
    ${carrier_from_infx}  Find Carrier And ID in Informix For Trans Rejects
    Set Suite Variable   ${carrier_from_infx}
    END
    Getting API URL

    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Create My User  persona_name=carrier_manager   entity_id=${carrier_from_infx}[carrier_id]
        Get Pkce Token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        Trans Rejects  GET  ${carrier_from_infx}[carrier_id]   ${carrier_from_infx}[reject_id]     N
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='USER NOT RELATED TO CARRIER'
        Get Into Db             TCH
        ${query_other}          Catenate                    select carrier_id from cards where carrier_id <> '${carrier_from_infx}[carrier_id]' and status = 'A' Limit 1;
        ${other_carrier_id}     Query To Dictionaries       ${query_other}
        Disconnect From Database
        Create My User  persona_name=carrier_manager  entity_id=${other_carrier_id}[0][carrier_id]
        Trans Rejects  GET  ${carrier_from_infx}[carrier_id]   ${carrier_from_infx}[reject_id]
        ${result}  Get Dictionary Keys   ${response}

        Should Be Equal As Strings  ${status}     403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='INVALID CARRIER ID'
        Create My User  persona_name=carrier_manager   entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects  GET  111  ${carrier_from_infx}[reject_id]

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='LETTERS AS CARRIER ID'
        Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects  GET  123ABC   ${carrier_from_infx}[reject_id]

        ${result}  Get Dictionary Keys   ${response}
        Should Be Equal As Strings  ${status}  403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='EMPTY CARRIER ID'
        Create My User  persona_name=carrier_manager   entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects  GET  ${EMPTY}   ${carrier_from_infx}[reject_id]

        Should Be Equal As Strings  ${status}  404
    ELSE IF  '${error.upper()}'=='EMPTY REJECT ID'
        Create My User  persona_name=carrier_manager   entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects   GET   ${carrier_from_infx}[carrier_id]   ${EMPTY}

        Should Be Equal As Strings  ${status}  401
     ELSE IF  '${error.upper()}'=='LETTERS AS REJECT ID'
        Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects  GET  ${carrier_from_infx}[carrier_id]  123ABC

        Should Be Equal As Strings  ${status}  400
    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END