*** Settings ***
Library  String
Library  Collections
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library  otr_robot_lib.ws.PortalWS
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the Trans Rejects API (currently only works in dit because okta service is set up there)
Force Tags     transactionServicesAPI  API  ditOnly  refactor

*** Variables ***
@{endpoints}  PAGELIST
&{default_options}  page=0  size=10

*** Test Cases ***
GET Trans Rejects
    [Documentation]  Test the successful scenario to GET Trans Rejects Paged List
    [Tags]   PI:14  JIRA:O5SA-353  qTest:97962976
    [Setup]  Genetare Data for Request  PAGELIST
    Send GET API Request for Trans Reject PAGELIST
    Compare GET Endpoint Results for Trans Reject PAGELIST
    [Teardown]  Remove Automation User

GET Trans Reject with ASC Sort
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962976
    GET Trans Reject with ASC Sort   PAGELIST
    Compare GET Endpoint Results for Trans Reject PAGELIST
    [Teardown]  Remove Automation User

GET Trans Reject with DESC Sort
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962976
    GET Trans Reject with DESC Sort   PAGELIST
    Compare GET Endpoint Results for Trans Reject PAGELIST
    [Teardown]  Remove Automation User

GET Trans Rejects using an Invalid or No Token
    [Tags]  PI:14  JIRA:O5SA-353    qTest:97962518
    GET Trans Reject Error with Invalid or No Token
    [Teardown]  Remove Automation User

GET Trans Rejects using a User Not Related to Carrier
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962518
    GET Trans Reject Error with User Not Related to Carrier
    [Teardown]  Remove Automation User

GET Trans Rejects using an Invalid Carrier ID
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962518
    GET Trans Reject Error with Invalid Carrier ID
    [Teardown]  Remove Automation User

GET Trans Rejects using Letters as Carrier ID
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962518
    GET Trans Reject Error with Letters as Carrier ID
    [Teardown]  Remove Automation User

GET Trans Reject using an Empty Carrier ID
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962518
    GET Trans Reject Error with Empty Carrier ID
    [Teardown]  Remove Automation User

GET Trans Reject with Negative Page
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962518
    GET Trans Reject with Negative Page   PAGELIST
    [Teardown]  Remove Automation User

GET Trans Reject with Negative Size
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962518
    GET Trans Reject with Negative Size   PAGELIST
    [Teardown]  Remove Automation User

GET Trans Reject with Paging Optionals
    [Tags]  PI:14  JIRA:O5SA-353   qTest:97962518
    GET Trans Reject with Paging Optionals   PAGELIST
    [Teardown]  Remove Automation User

*** Keywords ***
Genetare Data for Request
    [Documentation]  Create a user and get data to be used in request
    [Arguments]  ${type}
    Getting API URL
    ${carrier_from_infx}  Find Carrier in Informix For Trans Rejects
    Set Suite Variable   ${carrier_from_infx}
    Create My User   persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]

Getting API URL
    Get url for suite   ${transactionservices}


Send ${request_type} API Request for Trans Reject ${type}
    Send Request  ${request_type.upper()}   ${type}
#    Compare Data for Card Cash  ${request_type}  ${card_type}  ${limit_src}  ${cash_type}


Compare ${request_type} Endpoint Results for Trans Reject ${type}
#    [Arguments]  ${limit_src}  ${cash_type}
    Compare Data for Trans Reject  ${request_type.upper()}  ${type}

Find Carrier in Informix For Trans Rejects
    [Documentation]    find data to be used during the test and make the request with it
    ${data_query}  Catenate     select t.carrier_id
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
    [Documentation]  Perform the request for Trans Reject Paged List
    [Arguments]  ${request}   ${carrier}=${api_dict}[carrier_id]    ${sort}=${None}    ${optionals}=${default_options}    ${secure}=Y

    ${headers}  Create Dictionary  content-type=application/json
    ${url_stuff}  create dictionary  carriers=${carrier}

      IF  '''${sort}'''=='''${NONE}''' and '''${optionals}'''=='''${NONE}'''
        &{options_dict}  create dictionary  page=0  size=10
        set test variable  ${optionals}  ${options_dict}
    ELSE IF  '''${sort}'''!='''${NONE}''' and '''${optionals}'''!='''${NONE}'''
        set to dictionary  ${optionals}  sort=${sort}
        set test variable  ${optionals}   ${optionals}
    ELSE IF  '''${sort}'''!='''${NONE}''' and '''${optionals}'''=='''${NONE}'''
        &{options_dict}  create dictionary  page=0  size=10  sort=${sort}
        set test variable  ${optionals}  ${options_dict}
    ELSE IF  '''${sort}'''=='''${NONE}''' and '''${optionals}'''!='''${NONE}'''
        set to dictionary  ${optionals}  sort=rejectTime,desc
        set test variable  ${optionals}  ${optionals}
    ELSE
        &{options_dict}  create dictionary  page=0  size=10  sort=rejectTime,desc
        set test variable  ${optionals}  ${options_dict}
    END

   ${response}  ${status}  API Request  GET  transaction-rejects  ${secure}  ${url_stuff}  ${optionals}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for Trans Reject
    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        ${result_from_DB}  Get Database Values for Trans Rejects  ${type}
        ${db_dict}  ${api_dict}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
        Lists should be equal  ${db_dict}  ${api_dict}
        Should Be Equal As Strings  ${response}[details][data][0][reject_id]  ${db_dict}[0][reject_id]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END

Get Database Values for Trans Rejects
    [Arguments]  ${type}  ${optionals}=${EMPTY}
    IF  '${type}'=='PAGELIST'
        ${db_values}  Get Trans Reject Information from Database
    ELSE
        log to console  type ${type} not supported
    END
    [Return]  ${db_values}

Get Trans Reject Information from Database
    [Documentation]  query to get trans reject information from database
    ${page}  ${size}  Check Options

        IF  'sort' in ${optionals}
        @{words}  split string  ${optionals}[sort]  ,
        ${field}  evaluate  re.sub(r'(?<![A-Z\W])(?=[A-Z])', '_', $words[0])  re
        ${field}  String.convert to lower case  ${field}
        ${sort}  set variable  ORDER BY reject_datetime ${words}[1]
    ELSE
        ${sort}  set variable  ORDER BY reject_datetime DESC
    END

   get into db  TCH
    ${query}  catenate  SELECT reject_id FROM
    ...  ( SELECT SKIP ${page} FIRST ${size} t.reject_id AS reject_id, t.card_bin, t.card_id, t.policy, t.carrier_id, t.err_code, t.err_code_id, t.err_desc,
    ...  t.invoice, t.card_last4, t.location_city, t.location_id, t.location_name, t.location_state, t.masked_card_num, t.message,
    ...  t.reject_datetime, t.request_type, t.request_type_desc, t.sys_type, t.sys_type_desc,t.t_date, t.t_time
    ...  FROM recent_rejected_trans t
    ...  WHERE t.carrier_id = '${api_dict}[carrier_id]' ${sort})
    ${query}  query to dictionaries  ${query}
    Disconnect From Database
    [Return]  ${query}

#change paging to use robot keywords instead of python keyword
GET Trans Reject with Negative Page
    [Documentation]  keyword to test a negative pagenumber value for a request
    [Arguments]  ${item}
    &{options_dict}  create dictionary  page=-1  size=5
    set test variable  ${optionals}  ${options_dict}
    Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
       IF  '${item}' == 'PAGELIST'
            Trans Rejects  GET  ${carrier_from_infx}[carrier_id]  ${options_dict}
             ${result}  Get Dictionary Keys  ${response}
               Should Be Equal As Strings  ${status}  500
    ELSE
        log to console  ${item} not yet implemented
    END

GET Trans Reject with Negative Size
    [Documentation]  keyword to test a negative pagesize value for a request
    [Arguments]  ${item}
    &{options_dict}  create dictionary  page=1  size=-5
    set test variable  ${optionals}  ${options_dict}
    Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
    IF  '${item}' == 'PAGELIST'
        Trans Rejects  GET  transaction-rejects   ${carrier_from_infx}[carrier_id]   ${options_dict}
         ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  403
    ELSE
        log to console  ${item} not yet implemented
    END


GET Trans Reject with Paging Optionals
    [Documentation]  Tests the paging of get requests
    [Arguments]  ${item}
    &{option1_dict}  create dictionary  page=a  size=5
    &{option2_dict}  create dictionary  page=0  size=p

    IF  '${item}' == 'PAGELIST'
        Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
        set test variable  ${optionals}  ${option1_dict}
        Trans Rejects  GET  transaction-rejects   ${carrier_from_infx}[carrier_id]   ${option1_dict}
        Should Be Equal As Strings  ${status}  403
        set test variable  ${optionals}  ${option2_dict}
        Trans Rejects  GET  transaction-rejects   ${carrier_from_infx}[carrier_id]   ${option2_dict}
        Should Be Equal As Strings  ${status}  403
    ELSE
        log to console  ${item} not yet implemented
    END

Make Dictionaries
    [Documentation]  keeps some data in and formats datatypes, in list dictionaries so they can be compared.
    [Arguments]  ${type}  ${db_dict}   ${api_dict}
    IF  '${type}'=='PAGELIST'
        FOR  ${item}  IN  @{api_dict}
            Keep in Dictionary  ${item}  reject_id  carrier_id
        END
    END
    [Return]  ${db_dict}  ${api_dict}

Check Options
    ${is_page_alpha}  evaluate  $optionals['page'].isalpha()
    ${is_size_alpha}  evaluate  $optionals['size'].isalpha()
    IF  ${is_page_alpha}==${FALSE}
        ${is_page_int}  get from dictionary  ${optionals}  page
    END

    IF  ${is_size_alpha}==${FALSE}
        ${is_size_int}  get from dictionary  ${optionals}  size
    END

    IF  ${is_page_alpha}==${TRUE}
        ${page}  set variable  0
    ELSE IF  ${is_page_int} <= 0
        ${page}  set variable  0
    ELSE IF  (${is_page_int} > 0 and ${is_size_int} < 0) or (${is_page_int} > 0 and ${is_size_alpha} == ${TRUE})
        ${new_page}  evaluate  ${is_page_int} * 10
        ${page}  set variable  ${new_page}
    ELSE IF  ${is_page_int} >= 0 and ${is_size_int} >= 0
        ${new_page}  evaluate  ${is_page_int} * ${is_size_int}
        ${page}  set variable  ${new_page}
    ELSE
        ${page}  set variable  0
    END

    IF  ${is_size_alpha}==${TRUE}
        ${size}  set variable  10
    ELSE IF  ${is_size_int} <= 0
        ${size}  set variable  10
    ELSE
        ${size}  set variable  ${is_size_int}
    END

    [Return]  ${page}  ${size}

GET Trans Reject with ASC Sort
    [Documentation]  Test request with descending sort
    [Arguments]  ${type}
     Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
    IF  '${type}' == 'PAGELIST'
        Trans Rejects  GET  ${carrier_from_infx}[carrier_id]   rejectTime,asc
    ELSE
        log to console  ${type} not yet implemented
    END


GET Trans Reject with DESC Sort
    [Documentation]  Test request with descending sort
    [Arguments]  ${type}
     Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
    IF  '${type}' == 'PAGELIST'
        Trans Rejects  GET  ${carrier_from_infx}[carrier_id]   rejectTime,desc
    ELSE
        log to console  ${type} not yet implemented
    END


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
        Trans Rejects  GET  ${carrier_from_infx}[carrier_id]   ${NONE}   ${NONE}   N
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='USER NOT RELATED TO CARRIER'
        Get Into Db             TCH
        ${query_other}          Catenate                    select carrier_id from cards where carrier_id <> '${carrier_from_infx}[carrier_id]' and status = 'A' Limit 1;
        ${other_carrier_id}     Query To Dictionaries       ${query_other}
        Disconnect From Database
        Create My User  persona_name=carrier_manager  entity_id=${other_carrier_id}[0][carrier_id]
        Trans Rejects  GET  ${carrier_from_infx}[carrier_id]
        ${result}  Get Dictionary Keys   ${response}

        Should Be Equal As Strings  ${status}     403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='INVALID CARRIER ID'
        Create My User  persona_name=carrier_manager   entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects  GET  111

        ${result}  Get Dictionary Keys  ${response}
        Should Be Equal As Strings  ${status}  403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='LETTERS AS CARRIER ID'
        Create My User  persona_name=carrier_manager  entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects  GET  123ABC

        ${result}  Get Dictionary Keys   ${response}
        Should Be Equal As Strings  ${status}  403
        Should Be Equal As Strings  ${result}[1]  name
        Should Be Equal As Strings  ${result}[0]  message
    ELSE IF  '${error.upper()}'=='EMPTY CARRIER ID'
        Create My User  persona_name=carrier_manager   entity_id=${carrier_from_infx}[carrier_id]
        Trans Rejects  GET  ${EMPTY}
        Should Be Equal As Strings  ${status}  401
    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END