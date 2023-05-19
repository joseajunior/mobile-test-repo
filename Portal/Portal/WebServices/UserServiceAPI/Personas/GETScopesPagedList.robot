*** Settings ***
Library   Collections
Library   String
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Library   otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library   otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Setup the environment to START
Suite Teardown  Remove User if Still exists

Documentation  This is to test the endpoint (GET all Scopes Paged list) at OTR - User Service API
...            This API is responsable to manage user and permissions within the WEX OTR system
...            URL: (https://usersvc.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags  API  userServiceAPI  Personas

*** Variables ***
${db}   postgrespgusers

*** Test Cases ***
#################################### Personas #######################################
#-----------------------------------------------------------------------------------#
#                       Endpoint GET:  /personas/scopes                             #
#-----------------------------------------------------------------------------------#
(Personas) GET - Testing the endpoint to see scopes paged list
    [Tags]           Q1:2023   JIRA:O5SA-190   JIRA:O5SA-335  qTest:54708083   Scopes
    [Documentation]  This is to test (GET endpoint) to see all Scopes Paged list
    ...              The API response should be 200, with all existents scopes displayed
    Use the GET endpoint to see scopes paged list
    The API response should be (status 200) with more details
    Compare the API response with the database

(Personas) GET - Testing the endpoint to see scopes paged list using "query options"
    [Tags]           Q1:2023   JIRA:O5SA-190   JIRA:O5SA-335  qTest:54708083   Scopes
    [Documentation]  This is to test (GET endpoint) to see all Scopes Paged list using "query options"
    ...              The API response should be 200, with scopes displayed and with correct information at field "pages"
    Use the GET endpoint to see scopes paged list  with_options=Y
    The API response should be (status 200) with more details  with_options=Y

(Personas) GET ERRORS - Testing the endpoint with "unauthorized token"
    [Tags]           Q1:2023   JIRA:O5SA-190   JIRA:O5SA-335  qTest:54708083   Scopes
    [Documentation]  This is to test an EXPECTED ERROR, when the endpoint is used with "unauthorized token"
    Use the GET endpoint with UNAUTHORIZED TOKEN

*** Keywords ***
Setup the environment to START
    Get URL For Suite   ${UserService}
    Create My User  persona_name=otruser_admin  application_name=OTR_eMgr  entity_id=${EMPTY}  with_data=N
    ...             need_new_user=Y

Sending get request
    [Documentation]  Build a generic REQUEST structure of the endpoint (GET a paged list off all scopes)
    [Arguments]  ${authorized}=Y    ${options}=N
    IF  '${options}'=='N'
        ${path_url}  Create Dictionary  None=scopes
        ${result}  ${status}  Api request   GET   personas   ${authorized}  ${path_url}  application=OTR_eMgr
    ELSE IF   '${options}'=='Y'
        ${size}  Generate Random String  length=1  chars=[NUMBERS]
        ${path_url}  Create Dictionary  None=scopes?size=${size}
        ${result}  ${status}  Api request   GET   personas   ${authorized}  ${path_url}  application=OTR_eMgr
        Set Test Variable  ${size}
    END
    Set Test Variable  ${result}
    Set Test Variable  ${status}

###################################################### HAPPY PATH #####################################################
Use the GET endpoint to see scopes paged list
    [Documentation]  Sending the request to see all scopes paged list
    [Arguments]    ${with_options}=N
    IF  '${with_options}'=='N'
        Sending Get Request
    ELSE IF  '${with_options}'=='Y'
        Sending Get Request  options=Y
    END

Checking DATA list
    [Documentation]  Use to check keys returned in response at DATA [ ]
    ${data_dic}   Convert To Dictionary  ${result}[details][data][0]
    ${keys_data}  Get Dictionary Keys    ${data_dic}

    Should Be Equal  ${keys_data}[2]  name
    Should Be Equal  ${keys_data}[1]  id
    Should Be Equal  ${keys_data}[0]  description

Checking LINKS list
    [Documentation]  Use to check keys returned in response at LINKS [ ]
    ${link_dic}   Convert To Dictionary  ${result}[links][0]
    ${keys_link}  Get Dictionary Keys    ${link_dic}

    Should Be Equal  ${keys_link}[1]  rel
    Should Be Equal  ${keys_link}[0]  href

Checking PAGE list
    [Documentation]  Use to check keys returned in response at PAGE [ ]
    [Arguments]    ${options}=N
    ${keys_page}  Get Dictionary Keys    ${result}[page]

    Should Be Equal  ${keys_page}[3]  totalPages
    Should Be Equal  ${keys_page}[2]  totalElements
    Should Be Equal  ${keys_page}[1]  size
    Should Be Equal  ${keys_page}[0]  number

    IF  '${options}'=='Y'
        IF  '${size}'=='0'
        # Whenever the SIZE field is not sent or the ZERO value is used, the default value presented
        # in the response body will be 10
            Should Be Equal As Strings  ${result}[page][size]  10
        ELSE
            Should Be Equal As Strings  ${result}[page][size]  ${size}
        END
    END

The API response should be (status 200) with more details
    [Documentation]     Cheking STATUS and KEYS returned into the API response
    [Arguments]    ${with_options}=N
    ${keys}  Get Dictionary Keys  ${result}

    Should Be Equal As Strings  ${status}                 200
    Should Be Equal As Strings  ${keys}[4]                page
    Should Be Equal             ${keys}[3]                name
    Should Be Equal As Strings  ${result}[name]           OK
    Should Be Equal             ${keys}[2]                message
    Should Be Equal As Strings  ${result}[message]        SUCCESSFUL
    Should Be Equal             ${keys}[1]                links
    Should Be Equal             ${keys}[0]                details
    Should Be Equal As Strings  ${result}[details][type]  ScopeDTO
    Checking DATA list
    Checking LINKS list
    Checking PAGE list          options=${with_options}

Query to find scopes storaged
    [Documentation]    Query to find scopes storaged
    Get into DB  ${db}
        ${query}    Catenate   select id, name, description from scope
        ${scope_dictionary}  query to dictionaries   ${query}
    Disconnect from Database

    Set Test Variable    ${scope_dictionary}

Compare the API response with the database
    [Documentation]    Use that keywork to compare the informations returned in the API response, with the data
    ...                storaged in the database
    Query To Find Scopes Storaged

    Should Be Equal As Strings    ${result}[details][data][0][id]           ${scope_dictionary}[0][id]
    Should Be Equal As Strings    ${result}[details][data][0][name]         ${scope_dictionary}[0][name]
    Should Be Equal As Strings    ${result}[details][data][0][description]  ${scope_dictionary}[0][description]

################################################### EXPECTED ERRORS ###################################################
Use the GET endpoint with UNAUTHORIZED TOKEN
    [Documentation]       Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Get Request   authorized=I
    IF    '${status}'=='401'
         Should Be Equal As Strings  ${status}  401
    ELSE
         Fail  TOKEN authorization validation failed
    END