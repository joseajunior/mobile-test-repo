*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Documentation  This is to test the User Service API (currently only works in dit because okta service is set up there)
Force Tags     userServiceAPI  API  ditOnly

*** Variables ***
@{endpoints}  PAGELIST
&{default_options}  page=0  size=10

*** Test Cases ***
GET Personas By Paged List
    [Documentation]  Test the successful scenario to GET Persona By Paged List
    [Tags]   PI:14  JIRA:O5SA-332  qTest:53985812
    [Setup]  Getting API URL
    Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
    Send GET API Request for Personas
    Compare GET Endpoint Results for Personas PAGELIST
    [Teardown]  Remove Automation User

GET Personas with ASC Sort
    [Tags]  PI:14  JIRA:O5SA-332  qTest:53985812
    GET Personas with ASC Sort   PAGELIST
    Compare GET Endpoint Results for Personas PAGELIST
    [Teardown]  Remove Automation User

GET Personas with DESC Sort
    [Tags]  PI:14  JIRA:O5SA-332  qTest:53985812
    GET Personas with DESC Sort   PAGELIST
    Compare GET Endpoint Results for Personas PAGELIST
    [Teardown]  Remove Automation User

GET Personas using an Invalid or No Token
    [Tags]  PI:14  JIRA:O5SA-332  qTest:53985812
    GET Personas Error with Invalid or No Token
    [Teardown]  Remove Automation User

GET Personas using a User without permission
    [Tags]  PI:14  JIRA:O5SA-332  qTest:53985812
    GET Personas Error with User without permission
    [Teardown]  Remove Automation User

GET Personas with Negative Paging
    [Tags]   PI:14  JIRA:O5SA-332  qTest:53985812
    [Setup]  Getting API URL
    Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
    Send GET API Request for Personas with Negative Page
    Compare GET Endpoint Results for Personas PAGELIST
    [Teardown]  Remove Automation User

GET Personas with Negative Sizing
    [Tags]   PI:14  JIRA:O5SA-332  qTest:53985812
    [Setup]  Getting API URL
    Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
    Send GET API Request for Personas with Negative Size
    Compare GET Endpoint Results for Personas PAGELIST
    [Teardown]  Remove Automation User

GET Personas with Different Paging Optionals
    [Tags]   PI:14  JIRA:O5SA-332  qTest:53985812
    [Setup]  Getting API URL
    Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
    Send GET API Request for Personas with Paging Optionals
    [Teardown]  Remove Automation User

*** Keywords ***
Getting API URL
    Get URL For Suite   ${UserService}


Send ${request_type} API Request for Personas
    Send Request  ${request_type.upper()}


Compare ${request_type} Endpoint Results for Personas ${type}
    Compare Data for Personas  ${request_type.upper()}  ${type}

Send Request
    [Arguments]  ${request_type}
    Personas  ${request_type}

Personas
    [Documentation]  Perform the request for Get Personas Paged List
    [Arguments]  ${request}   ${sort}=${None}    ${optionals}=${default_options}  ${secure}=Y

     ${headers}  Create Dictionary  content-type=application/json
     ${url_stuff}  create dictionary  None=${None}
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
        set test variable  ${optionals}  ${optionals}
    ELSE
        &{options_dict}  create dictionary  page=0  size=10
        set test variable  ${optionals}  ${options_dict}
    END

   ${response}  ${status}  API Request  GET  personas  ${secure}  ${url_stuff}  ${optionals}  application=OTR_eMgr

    Set Test Variable  ${status}
    Set Test Variable  ${response}


Compare Data for Personas

    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${request_type}   ${type}
    IF  '${request_type}'=='GET'
        set test variable  ${api_result}  ${response}[details][data]
        Should Be Equal As Strings  ${status}  200
        ${result_from_DB}  Get Database Values for Personas  ${type}
        ${db_dict}  ${api_dict}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
        Lists should be equal  ${db_dict}  ${api_dict}
        Should Be Equal As Strings  ${response}[details][data][0][name]  ${db_dict}[0][name]
        Should Be Equal As Strings  ${response}[details][data][0][description]  ${db_dict}[0][description]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END


Get Database Values for Personas
    [Arguments]  ${type}  ${optionals}=${EMPTY}
    IF  '${type}'=='PAGELIST'
        ${db_values}  Get Personas Information from Database
    ELSE
        log to console  type ${type} not supported
    END
    [Return]  ${db_values}


Get Personas Information from Database
    [Documentation]  query to get trans reject information from database
    ${page}  ${size}  Check Options

     IF  'sort' in ${optionals}
        IF  '''${optionals}[sort]'''!='''${NONE}'''
            @{words}  split string  ${optionals}[sort]  ,
            ${field}  evaluate  re.sub(r'(?<![A-Z\W])(?=[A-Z])', '_', $words[0])  re
            ${field}  String.convert to lower case  ${field}
            ${sort}  set variable  ORDER BY name ${words}[1]
        ELSE
            ${sort}  set variable  ${EMPTY}
        END
    ELSE
            ${sort}  set variable  ${EMPTY}
        END


   get into db  postgrespgusers
    ${query}  catenate  SELECT p.name, p.description FROM
    ...  (( SELECT persona0_.id as id,
    ...   persona0_.description as description, persona0_.name as name, persona0_.updated_by as updated_by,
    ...  persona0_.updated as updated from persona persona0_
    ...  ${sort} LIMIT ${size})) p
    ${query}  query to dictionaries  ${query}
    Disconnect From Database
    [Return]  ${query}

Make Dictionaries
    [Documentation]  keeps some data in and formats datatypes, in list dictionaries so they can be compared.
    [Arguments]  ${type}  ${db_dict}   ${api_dict}
    IF  '${type}'=='PAGELIST'
        FOR  ${item}  IN  @{api_dict}
            Keep in Dictionary  ${item}  name  description
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


GET Personas with ASC Sort
    [Documentation]  Test request with descending sort
    [Arguments]  ${type}
    Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
    IF  '${type}' == 'PAGELIST'
     Personas  GET  name,asc
    ELSE
        log to console  ${type} not yet implemented
    END


GET Personas with DESC Sort
    [Documentation]  Test request with descending sort
    [Arguments]  ${type}
    Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
    IF  '${type}' == 'PAGELIST'
        Personas  GET  name,desc
    ELSE
        log to console  ${type} not yet implemented
    END

#Pageable defaults are int, will ignore anything except the positive values
Send ${response_type} API Request for Personas with ${option}
    [Documentation]  used to call the card summaries endpoint
    IF  '${option.upper()}'=='NEGATIVE PAGE'
        &{options_dict}      Create Dictionary      page=-1  size=5
        Set Test Variable  ${optionals}  ${options_dict}
        Personas  GET   optionals=${optionals}

    ELSE IF  '${option.upper()}'=='NEGATIVE SIZE'
        &{options_dict}  Create Dictionary  page=0  size=-5
        Set Test Variable  ${optionals}  ${options_dict}
        Personas  GET   optionals=${optionals}

    ELSE IF  '${option.upper()}'=='PAGING OPTIONALS'
        &{letter_for_page}  Create Dictionary  page=a  size=5
        &{letter_for_size}  Create Dictionary  page=0  size=p
        #use numbers as the keys if needing to add different page/size options
        &{options_dict}  Create Dictionary  1=${letter_for_page}  2=${letter_for_size}
        Set Test Variable  ${optionals}  ${options_dict}
        Personas  GET   optionals=${optionals}
        Should Be Equal As Strings  ${status}  200


    ELSE
        tch logging  case ${option.upper()} not handled
    END


GET Personas Error with ${error}
    [Documentation]  Checks the appropriate response is being sent
    Getting API URL
    IF  '${error.upper()}'=='INVALID OR NO TOKEN'
        Create My User  persona_name=am_admin  with_data=N  legacy_user=Y
        Get Pkce Token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
        Personas  GET  secure=N
        Should Be Equal As Strings  ${status}  401

    ELSE IF  '${error.upper()}'=='USER WITHOUT PERMISSION'
        Create My User  persona_name=carrier_manager  with_data=N  legacy_user=Y
        Personas  GET
        Should Be Equal As Strings  ${status}     403

    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END