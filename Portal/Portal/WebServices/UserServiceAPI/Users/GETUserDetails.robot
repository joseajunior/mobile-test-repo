*** Settings ***
Library   String
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup  Prepare Environment For Testing
Suite Teardown  Remove User if Still Exists

Force Tags  API  UserService  Phoenix  ditOnly

Documentation    Test the GET endpoint which gets the details of a user
*** Test Cases ***
Validate Get User Details Endpoint
    [Tags]    Q1:2023  JIRA:O5SA-331  qTest:53846787
    [Documentation]    Test case to validate the get user details endpoint
    Make Request
    Validate Response

Validate Get User Details Endpoint Using Invalid Token
    [Tags]    Q1:2023  JIRA:O5SA-331  qTest:116224828
    [Documentation]    Test case to validate the get user details endpoint
    Make Request    secure=I
    Validate Response    intendStatus=401

Validate Get User Details Endpoint Using Empty User
    [Tags]    Q1:2023  JIRA:O5SA-331  qTest:116224828
    [Documentation]    Test case to validate the get user details endpoint
    Make Request    user=${EMPTY}
    Validate Response    intendStatus=401

*** Keywords ***
Prepare Environment For Testing
    [Documentation]    Keyword that will setup the environment to execute the test
    Get URL For Suite    ${UserService}
    Create User And Gather Data

Create User And Gather Data
    [Documentation]    Gather data to be used during test
    Get Into DB    postgrespgusers
    ${application}  Catenate    select oa.* from otr_application oa where oa.app_name in ('OTR_eMgr', 'Merchant Manager');
    ${application}  Query And Strip To Dictionary    ${application}

    ${persona}  Catenate    select p.* from persona p;
    ${persona}  Query And Strip To Dictionary    ${persona}

    Disconnect From Database
    IF  isinstance($application['app_name'], list)
        ${len}  Get Length    ${application}[app_name]
        ${len}  Evaluate    random.randint(0, $len-1)
        ${application}  Set Variable    ${application}[app_name][${len}]
        Set Suite Variable    ${application}
    END
    IF  isinstance($persona['name'], list)
        ${len}  Get Length    ${persona}[name]
        ${len}  Evaluate    random.randint(0, $len-1)
        ${persona}  Set Variable    ${persona}[name][${len}]
    END
    Create My User    persona_name=${persona}  application_name=${application}  entity_id=${EMPTY}  with_data=N

    Get Into DB    postgrespgusers
    ${user_info}  Catenate    select ou.id::text, ou.first_name, ou.last_name, ou.email, ou.cell_number
                       ...    from otr_user ou
                       ...    where ou.email = '${okta_automated_email}';
    ${user_info}  Query And Strip To Dictionary    ${user_info}
    Set Suite Variable    ${user_info}

    ${persona_info}  Catenate    select p.id::text, p.name, p.description
                          ...    from user_app_xref uax
                          ...    inner join persona p on p.id = uax.persona_id
                          ...    where uax.user_id='${user_info}[id]';
    ${persona_info}  Query And Strip To Dictionary    ${persona_info}
    Set Suite Variable    ${persona_info}

    ${permissions}  Catenate    select pr.persona_id, pr.resource_permission_scope_id::text
                         ...    from persona p
                         ...    inner join persona_resource_permission_scope_set pr on p.id = pr.persona_id
                         ...    where p.id='${persona_info}[id]';
    ${permissions}  Query And Strip To Dictionary    ${permissions}

    ${permission_map}  Create Dictionary
    ${authorities_temp}  Create List

    IF  isinstance($permissions['resource_permission_scope_id'], list)
        FOR  ${permission}  IN  @{permissions}[resource_permission_scope_id]
            &{query}  Lookup For Permission Information    ${user_info}[id]  ${permission}

            IF  $query['resource_name'] in $permission_map.keys()
                Append To List    ${permission_map}[${query}[resource_name]]  ${query}[permission]
            ELSE
                ${temp}  Create List    ${query}[permission]
                Set To Dictionary    ${permission_map}  ${query}[resource_name]  ${temp}
            END

            Append To List    ${authorities_temp}  ${query}[resource_name].${query}[permission]
            Set Suite Variable    ${permission_${query}[id]}  &{query}
        END
    ELSE
        &{query}  Lookup For Permission Information    ${user_info}[id]  ${permissions}[resource_permission_scope_id]
        ${temp}  Create List    ${query}[permission]
        Set To Dictionary    ${permission_map}  ${query}[resource_name]  ${temp}
        Append To List    ${authorities_temp}  ${query}[resource_name].${query}[permission]
        Set Suite Variable    ${permission_${query}[id]}  &{query}
    END

    ${authorities}  Create List
    IF  isinstance($authorities_temp, list)
        FOR  ${item}  IN  @{authorities_temp}
            ${temp}  Create Dictionary    authority  ${item}
            Append To List   ${authorities}  ${temp}
        END
    ELSE
        Set To Dictionary    ${authorities}  authority  ${authorities_temp}
    END

    Set Suite Variable    &{permission_map}
    Set Suite Variable    ${authorities}

    Disconnect From Database

Lookup For Permission Information
    [Documentation]    Keyword that will look up for the permission info
    [Arguments]    ${user_id}  ${permission_id}
    ${query}  Catenate    select rp.id::text, rp.permission, rp.description, rp.name,
                   ...     r.id::text as resource_id, r.name as resource_name, r.description as resource_description,
                   ...     s.id::text as scope_id, s.name as scope_name, s.description as scope_description
                   ...    from user_app_xref uax
                   ...    inner join persona p on uax.persona_id = p.id
                   ...    inner join persona_resource_permission_scope_set pr on p.id = pr.persona_id
                   ...    inner join resource_permission_scope rp on rp.id = pr.resource_permission_scope_id
                   ...    inner join resource r on r.id = rp.resource_id
                   ...    inner join scope s on s.id = rp.scope_id
                   ...    inner join otr_application oa on uax.app_client_id = oa.okta_app_client_id
                   ...    where uax.user_id = '${user_id}' and rp.id = '${permission_id}';
    &{query}  Query And Strip To Dictionary    ${query}
    [Return]    &{query}

Make Request
    [Documentation]    Keyword that makes the request and set avaliable the request status and response body
    [Arguments]    ${user}=${user_info}[email]  ${secure}=Y
    ${endpoint}  Create Dictionary    ${user}=userdetails

    ${response}  ${status}  API Request    GET  users  ${secure}  ${endpoint}  application=${application}

    Set Suite Variable    ${response}
    Set Suite Variable    ${status}

Validate Response
    [Documentation]    Validate the response
    [Arguments]    ${intendStatus}=200
    IF    '${intendStatus}'=='200'
        Should Be Equal As Strings    200  ${status}

        Should Be Equal As Strings    ${user_info}[id]  ${response}[user][id]
        Should Be Equal As Strings    ${user_info}[first_name]  ${response}[user][first_name]
        Should Be Equal As Strings    ${user_info}[last_name]  ${response}[user][last_name]
        Should Be Equal As Strings    ${user_info}[email]  ${response}[user][email]
        Should Be Equal As Strings    ${user_info}[cell_number]  ${response}[user][cell_number]

        Should Be Equal As Strings    ${persona_info}[id]  ${response}[user_persona][id]
        Should Be Equal As Strings    ${persona_info}[name]  ${response}[user_persona][name]
        Should Be Equal As Strings    ${persona_info}[description]  ${response}[user_persona][description]

        IF  isinstance($response['user_persona']['permissions'], list)
            FOR  ${permission_dict}  IN  @{response}[user_persona][permissions]
                ${permission}  Set Variable    ${permission_dict}[id]
                Should Be Equal As Strings    ${permission_${permission}}[id]  ${permission_dict}[id]
                Should Be Equal As Strings    ${permission_${permission}}[permission]  ${permission_dict}[permission]
                Should Be Equal As Strings    ${permission_${permission}}[description]  ${permission_dict}[description]
                Should Be Equal As Strings    ${permission_${permission}}[name]  ${permission_dict}[name]
                Should Be Equal As Strings    ${permission_${permission}}[name]  ${permission_dict}[rpsname]

                Should Be Equal As Strings    ${permission_${permission}}[resource_id]  ${permission_dict}[resource][id]
                Should Be Equal As Strings    ${permission_${permission}}[resource_name]  ${permission_dict}[resource][name]
                Should Be Equal As Strings    ${permission_${permission}}[resource_description]  ${permission_dict}[resource][description]

                Should Be Equal As Strings    ${permission_${permission}}[scope_id]  ${permission_dict}[scope][id]
                Should Be Equal As Strings    ${permission_${permission}}[scope_name]  ${permission_dict}[scope][name]
                Should Be Equal As Strings    ${permission_${permission}}[scope_description]  ${permission_dict}[scope][description]
            END
        ELSE
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][id]  ${permission_dict}[id]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][permission]  ${permission_dict}[permission]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][description]  ${permission_dict}[description]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][name]  ${permission_dict}[name]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][name]  ${permission_dict}[rpsname]

            Should Be Equal As Strings    @{response}[user_persona][permissions][0][resource_id]  ${permission_dict}[resource][id]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][resource_name]  ${permission_dict}[resource][name]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][resource_description]  ${permission_dict}[resource][description]

            Should Be Equal As Strings    @{response}[user_persona][permissions][0][scope_id]  ${permission_dict}[scope][id]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][scope_name]  ${permission_dict}[scope][name]
            Should Be Equal As Strings    @{response}[user_persona][permissions][0][scope_description]  ${permission_dict}[scope][description]
        END

        ${resp_permi}  Evaluate    {k: [v[i] for i in sorted(range(len(v)), key=lambda x: v[x])] for k, v in ${response['permission_map']}.items()}
        ${db_permi}  Evaluate    {k: [v[i] for i in sorted(range(len(v)), key=lambda x: v[x])] for k, v in ${permission_map}.items()}
        Dictionaries Should Be Equal    ${resp_permi}  ${db_permi}

        ${resp_auth}  Evaluate    sorted($response['authorities'], key=lambda d: d['authority'])
        ${db_auth}  Evaluate    sorted($authorities, key=lambda d: d['authority'])
        Lists Should Be Equal    ${resp_auth}  ${db_auth}

        Should Be Equal As Strings    ${user_info}[email]  ${response}[username]

    ELSE IF    '${intendStatus}'=='401'
        Should Be Empty    ${response}
        Should Be Equal As Strings    401  ${status}

    ELSE
        Fail    '${intendStatus}' not listed
    END