*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the UserService API to get User Profile by user id (currently only works in dit because okta service is set up there)
Force Tags     userServiceAPI  API  ditOnly

Suite Setup         Prepare Environment For Testing
Suite Teardown      Remove User If Still Exists

*** Variables ***
@{endpoints}  PAGELIST
&{default_options}  page=0  size=5

*** Test Cases ***
GET RPS For Personas By Paged List
    [Documentation]  Test the successful scenario to GET Persona By Paged List
    [Tags]   Q2:2023  JIRA:O5SA-342   qTest:54712767
    Send GET API Request for RPS for Personas
    Compare GET Endpoint Results for RPS for Personas PAGELIST

GET RPS for Personas using an Invalid or No Token
    [Tags]  Q2:2023  JIRA:O5SA-342   qTest:54712767
    GET RPS for Personas Error with Invalid or No Token

GET RPS for Personas with Negative Paging
    [Tags]   Q2:2023  JIRA:O5SA-342   qTest:54712767
    Send GET API Request for RPS for Personas with Negative Page
    Compare GET Endpoint Results for RPS for Personas PAGELIST

GET RPS for Personas with Different Paging Optionals
    [Tags]   Q2:2023  JIRA:O5SA-342   qTest:54712767
    Send GET API Request for RPS for Personas with Paging Optionals

*** Keywords ***

Prepare Environment For Testing
    [Documentation]  Keyword that will setup the environment to execute the test
    Get URL For Suite   ${UserService}
    Create My User  am_admin  OTR_eMgr  ${EMPTY}  N  Y  N
    ${persona_id}  Find a Persona
    Set Suite Variable  ${persona_id}

Find a Persona
    Get Into DB  postgrespgusers
    ${pg}  Catenate  select id from persona limit 1;
    ${query}  Query And Strip To Dictionary  ${pg}
    Disconnect From Database
    [Return]  ${query}


Send ${request_type} API Request for RPS for Personas
    Send Request  ${request_type.upper()}


Compare ${request_type} Endpoint Results for RPS for Personas ${type}
    Compare Data for RPS for Personas  ${request_type.upper()}  ${type}

Send Request
    [Arguments]  ${request_type}
    RPS for Personas  ${request_type}

RPS for Personas
    [Documentation]  Perform the request for Get RPS for Personas Paged List
    [Arguments]  ${request}  ${optionals}=${default_options}  ${secure}=Y

     ${headers}  Create Dictionary  content-type=application/json
     ${url_stuff}  create dictionary  None=${None}
      IF  '''${optionals}'''=='''${NONE}'''
        &{options_dict}  create dictionary  page=0  size=10
        set test variable  ${optionals}  ${options_dict}
    ELSE IF  '''${optionals}'''!='''${NONE}'''
        set test variable  ${optionals}   ${optionals}
    ELSE
        &{options_dict}  create dictionary  page=0  size=10
        set test variable  ${optionals}  ${options_dict}
    END

    ${url_stuff}  Create Dictionary  None=resource-permission-scopes

   ${response}  ${status}  API Request  GET  personas  ${secure}  ${url_stuff}  ${optionals}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for RPS for Personas

    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        ${result_from_DB}  Get Database Values for RPS for Personas  ${type}
        ${db_dict}  ${api_dict}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
        Lists should be equal  ${db_dict}  ${api_dict}
        Should Be Equal As Strings  ${response}[details][data][0][name]  ${db_dict}[0][name]
        Should Be Equal As Strings  ${response}[details][data][0][description]  ${db_dict}[0][description]
        Should Be Equal As Strings  ${response}[details][data][0][permission]  ${db_dict}[0][permission]
        Should Be Equal As Strings  ${response}[details][data][0][permission]  ${db_dict}[0][permission]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END


Get Database Values for RPS for Personas
    [Arguments]  ${type}  ${optionals}=${EMPTY}
    IF  '${type}'=='PAGELIST'
        ${db_values}  Get RPS for Personas Information from Database
    END
    [Return]  ${db_values}


Get RPS for Personas Information from Database
    [Documentation]  query to get trans reject information from database
    ${page}  ${size}  Check Options

   get into db  postgrespgusers
    ${query}  catenate  SELECT  r.permission, r.description,  r.name FROM
    ...  (( SELECT rps.description, rps.permission, rps.name FROM resource_permission_scope rps WHERE rps.id IN (SELECT rel.resource_permission_scope_id
    ...  FROM persona_resource_permission_scope_set rel WHERE rel.persona_id = '${persona_id}[id]')
    ...  LIMIT ${size})) r
    ${query}  query to dictionaries  ${query}
    Disconnect From Database
    [Return]  ${query}

Make Dictionaries
    [Documentation]  keeps some data in and formats datatypes, in list dictionaries so they can be compared.
    [Arguments]  ${type}  ${db_dict}   ${api_dict}
    IF  '${type}'=='PAGELIST'
        FOR  ${item}  IN  @{api_dict}
            Keep in Dictionary  ${item}  description  permission  name
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

#Pageable defaults are int, will ignore anything except the positive values
Send ${response_type} API Request for RPS for Personas with ${option}
    [Documentation]  used to call the card summaries endpoint
    IF  '${option.upper()}'=='NEGATIVE PAGE'
        &{options_dict}      Create Dictionary      page=-1  size=5
        Set Test Variable  ${optionals}  ${options_dict}
        RPS for Personas  GET   optionals=${optionals}

    ELSE IF  '${option.upper()}'=='NEGATIVE SIZE'
        &{options_dict}  Create Dictionary  page=0  size=-5
        Set Test Variable  ${optionals}  ${options_dict}
        RPS for Personas  GET   optionals=${optionals}

    ELSE IF  '${option.upper()}'=='PAGING OPTIONALS'
        &{letter_for_page}  Create Dictionary  page=a  size=5
        &{letter_for_size}  Create Dictionary  page=0  size=p
        #use numbers as the keys if needing to add different page/size options
        &{options_dict}  Create Dictionary  1=${letter_for_page}  2=${letter_for_size}
        Set Test Variable  ${optionals}  ${options_dict}
        RPS for Personas  GET   optionals=${optionals}
        Should Be Equal As Strings  ${status}  200
    END


GET RPS for Personas Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Get Pkce Token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        RPS for Personas  GET  secure=N
        Should Be Equal As Strings  ${status}  401
    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END