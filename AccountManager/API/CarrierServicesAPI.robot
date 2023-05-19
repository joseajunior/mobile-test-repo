*** Settings ***
Library             String
Library             DateTime
Library             otr_robot_lib.ws.Oauth2.Oauth2APIService
Library             otr_robot_lib.ws.RestAPI.RestAPIService
Library             otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library             otr_robot_lib.ws.CarrierServicesAPI.CarrierAPIService
Resource            otr_robot_lib/robot/RobotKeywords.robot
Resource            otr_robot_lib/robot/APIKeywords.robot

Suite Setup         Carrier service suite setup
Suite Teardown      Automation User Teardown


*** Test Cases ***
Verify we can make a call with GET Carrier info by Alias and Parent ID
    [Documentation]    Search for a parent and child carrier after that we
    ...    make an insert for the child carrier with an alias, after we varify
    ...    the API returns 200, we delete the alias that we created.
    [Tags]    jira:rocket-236    qtest:55615421

    #endpoint needs to use the internal service token
    Run a query to search for a Parent carrier in Postgres and Insert into carrier_alias
    Get info inside of the API and match with alias
    Delete Parent Carrier Alias    ${child_carrier}    ${parent_Postgres}    ${super_token}

Create a new carrier family
    [Documentation]    Create a new carrier family (aka tag or classifier) by POSTing
    ...    the family natural id and unique alias flag to the API after that we
    ...    check that the family was inserted into the database and then delete it.
    [Tags]    pi:15    jira:rocket-322    qtest:117483280    api:y

    ${response}    Create random carrier family
    Should match carrier family natural id    ${carrier_family_natural_id}    ${response}
    Should match common carrier family fields    ${response}
    Check that unique alias flag is true    ${response}
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to create a duplicated carrier family
    [Documentation]    Try to create a duplicated carrier family (aka tag or classifier)
    ...    by POSTing the same family natural id to the API after that we check that
    ...    the family was not inserted into the database.
    [Tags]    pi:15    jira:rocket-322    qtest:117483403    api:y

    ${error_response}    Create duplicated carrier family
    Should match carrier family error response    ${error_response}    msg=Duplicate records
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to create a carrier family with empty natural id
    [Documentation]    Try to create a carrier family (aka tag or classifier) by POSTing
    ...    an empty natural id and after that we check that the API returned the
    ...    proper error.
    [Tags]    pi:15    jira:rocket-322    qtest:117483416    api:y

    ${response}    Create carrier family with empty natural id
    Should match carrier family error response    ${response}    carrierFamilyNaturalId    must not be blank

Try to create a carrier family without the unique alias flag
    [Documentation]    Try to create a carrier family (aka tag or classifier) POSTing an
    ...    empty or null unique alias flag and after that we check that the API returned
    ...    the proper error.
    [Tags]    pi:15    jira:rocket-322    qtest:117483417    api:y

    ${response}    Create carrier family with empty unique alias flag
    Should match carrier family error response    ${response}    aliasUniqueInFamily    must not be null

Assign carriers to a carrier family
    [Documentation]    Assign some carriers to a carrier family by POSTing a list of JSONs
    ...    containing the id, name and parent flag to the API URL containing the family
    ...    name, after that we check that those families were properly assinged to the
    ...    carrier family.
    [Tags]    pi:15    jira:rocket-322    qtest:117483418    api:y

    Create random carrier family
    @{carriers}    Create a list of carriers
    ${response}    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    FOR    ${sent}    ${created}    IN ZIP    ${carriers}    ${response}
        Should match sent and created carrier families    ${sent}    ${created}    ${carrier_family_natural_id}
    END
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to assign carriers to a carrier family that does not exist
    [Documentation]    Try to assign some carriers to a carrier family that does not
    ...    exist by POSTing a list of JSON carriers (id, name and parent flag) to
    ...    the API URL with a random family name, after that we check that the API
    ...    returned the proper error message.
    [Tags]    pi:15    jira:rocket-322    qtest:117483419    api:y

    ${carrier_family_natural_id}    Generate random string    10    12345ABCDE
    @{carriers}    Create a list of carriers
    ${response}    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    Should match carrier family error response    ${response}    msg=Family does not exists
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to assign carrier without id to a carrier family
    [Documentation]    Try to assign some carriers to a carrier family by POSTing a
    ...    list of JSON carriers (id, name and parent flag) with an empty or null id
    ...    to the API URL with a valid family name, after that we check that the API
    ...    returned the proper error message.
    [Tags]    pi:15    jira:rocket-322    qtest:117483420    api:y

    ${carrier_family_natural_id}    Generate random string    10    12345ABCDE
    @{carriers}    Create a list of carriers    1
    Set carrier id to nothing    ${carriers}
    ${response}    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    Should match carrier family error response    ${response}    carriers[0].id    must not be blank
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to assign carrier without a name to a carrier family
    [Documentation]    Try to assign some carriers to a carrier family by POSTing a
    ...    list of JSON carriers (id, name and parent flag) with an empty or null name
    ...    to the API URL with a valid family name, after that we check that the API
    ...    returned the proper error message.
    [Tags]    pi:15    jira:rocket-322    qtest:117483421    api:y

    ${carrier_family_natural_id}    Generate random string    10    12345ABCDE
    @{carriers}    Create a list of carriers    1
    Set carrier name to nothing    ${carriers}
    ${response}    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    Should match carrier family error response    ${response}    carriers[0].name    must not be blank
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to assign carrier without the is parent flag to a carrier family
    [Documentation]    Try to assign some carriers to a carrier family by POSTing a
    ...    list of JSON carriers (id, name and parent flag) with an empty or null parent
    ...    flag to the API URL with a valid family name, after that we check that the API
    ...    returned the proper error message.
    [Tags]    pi:15    jira:rocket-322    qtest:117483425    api:y

    ${carrier_family_natural_id}    Generate random string    10    12345ABCDE
    @{carriers}    Create a list of carriers    1
    Set carrier parent flag to nothing    ${carriers}
    ${response}    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    Should match carrier family error response    ${response}    carriers[0].isParent    must not be null
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to assign an empty carrier list to a carrier family
    [Documentation]    Try to assign an empty list of carriers to a carrier family by POSTing an
    ...    empty array to the API URL with a valid family name, after that we check
    ...    that the API returned the proper error message.
    [Tags]    pi:15    jira:rocket-322    qtest:117483426    api:y

    ${carrier_family_natural_id}    Generate random string    10    12345ABCDE
    ${response}    Assign an empty list of carriers to a family    ${carrier_family_natural_id}
    Should match carrier family error response    ${response}    carriers    must not be empty
    Cleanup carrier family database    ${carrier_family_natural_id}

Get the carrier family of a carrier
    [Documentation]    Retrieve the carrier family of a given carrier ID by issuing a GET
    ...    to the API URL containing the carrier id, after that we check that the API
    ...    returned the carrier data alongside the carrier family.
    [Tags]    pi:15    jira:rocket-322    qtest:117483427    api:y

    Create random carrier family
    @{carriers}    Create a list of carriers
    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    ${response}    Retrieve the carriers family    ${carriers}[0][id]
    Should match sent and created carrier families    ${carriers}[0]    ${response}    ${carrier_family_natural_id}
    Cleanup carrier family database    ${carrier_family_natural_id}

Try to get the carrier family of a carrier that does not exist
    [Documentation]    Retrieve the carrier family of a given carrier ID by issuing a GET
    ...    to the API URL containing a carrier id that does not exist, after that we
    ...    check that the API returned the carrier data alongside the carrier family.
    [Tags]    pi:15    jira:rocket-322    qtest:117483428    api:y

    ${carrier_id}    Generate random string    10    1234567890
    ${response}    Retrieve the carriers family    ${carrier_id}
    Check that the response has a not found error    ${carrier_id}    ${response}


Assign carriers that have already enrolled to a carrier family
    [Documentation]    Assign some carriers to a carrier family by POSTing a list of JSONs
    ...    containing the id, name and parent flag to the API URL containing the family
    ...    name. Then we try to assign the same carriers to the same carrier family
    ...    and check that 'already enrolled' status message in the response.
    [Tags]   JIRA:ROCKET-482  qTest:120328085  API:Y  Q1:2023

    ${response}    Create random carrier family
    Should match carrier family natural id    ${carrier_family_natural_id}    ${response}
    @{carriers}    Create a list of carriers    1
    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    ${response}    Assign a list of carriers to a family    ${carrier_family_natural_id}    ${carriers}
    ${uppercased_carrier_family}    String.Convert to uppercase    ${carrier_family_natural_id}
    Check that Carrier Already assigned to family returned  ${response}  ${uppercased_carrier_family}
    Cleanup carrier family database  ${carrier_family_natural_id}

*** Keywords ***
Carrier service suite setup
    [Documentation]    Set up log directory and initialize Suite Variables
    ...    Create automation user to be used during the test
    ${todayDashed}    getDateTimeNow    %Y-%m-%d
    ${env}    Replace String    ${ENVIRONMENT}    aws-    ${EMPTY}
    set suite variable    ${todayDashed}
    set suite variable    ${env}
    set suite variable    ${user_client_id}    ${OTR_Test_user_Oauth2ClientID}
    Get Carrier Alias Authentication Token
    Create User For Persona    integration_support_specialist
    Get url for suite    ${CarrierServiceAPI}

Create User For Persona
    [Documentation]    Create a user using the given persona for the OTR_eMgr application
    [Arguments]    ${persona}

    Create My User    ${persona}    OTR_eMgr    ${NONE}    N

Automation User Teardown
    [Documentation]    Delete the automation user created

    Remove Automation User

OTR eMgr Api Request
    [Documentation]    Call the OTR eMgr Services Api
    [Arguments]    ${request_method}    ${endpoint}    ${payload}=${False}

    ${headers}    Create Dictionary    content-type=application/json
    IF    ${payload} == False
        ${response}    ${status}    Api Request
        ...    ${request_method}
        ...    ${endpoint}
        ...    Y
        ...    ${NONE}
        ...    ${NONE}
        ...    OTR_eMgr
        ...    ${headers}
    ELSE
        ${response}    ${status}    Api Request
        ...    ${request_method}
        ...    ${endpoint}
        ...    Y
        ...    ${NONE}
        ...    ${NONE}
        ...    OTR_eMgr
        ...    ${headers}
        ...    payload=${payload}
    END
    Return From Keyword    ${response}    ${status}

Run a query to search for a Parent carrier in Postgres and Insert into carrier_alias
    [Documentation]    We run a query to search for a 1 parent carrier from carrier_family_xref table
    ...    then we use that parent carrier to find a child carrier associated. Now we go back to
    ...    the carrier_alias table and insert a random alias.

    ${query}    Catenate    select carrier_id from carrier_family_carrier_xref where is_parent = 'true' limit 1
    ${parent_Postgres}    Query And Strip    ${query};    db_instance=postgrespgcarrierservices
    Set test variable    ${parent_Postgres}

    ${query}    Catenate    select carrier_id from carrier_group_xref
    ...    where parent = '${parent_Postgres}' AND effective_date<TODAY AND expire_date>TODAY limit 1
    ${child_carrier}    Query And Strip    ${query};    db_instance=TCH
    Set test variable    ${child_carrier}

    ${alias}    Generate random string    7    1234ABCD
    Set test variable    ${alias}
    ${todayDashed}    getDateTimeNow    %Y-%m-%d
    ${query}    Catenate    INSERT INTO carrier_alias
    ...    (updated_by,updated_date,carrier_family_natural_id,carrier_id,ALIAS)
    ...    VALUES ('carriersvc',DATE '${todayDashed}','RYDER','${child_carrier}','${alias}')
    Execute sql string    dml=${query};    db_instance=postgrespgcarrierservices

Get info inside of the API and match with alias
    [Documentation]    We make sure the parent carrier alias matches the alias we sent to
    ...    alias we generated originally

    ${API_output}    Get Parent Carrier Alias    ${parent_Postgres}    ${alias}    ${super_token}
    Tch Logging    Our alias is:${API_output[0]['alias']}
    Should be equal as strings    ${API_output[0]['alias']}    ${alias}
    Tch Logging    Nice! Both of our Aliases match!

Get Carrier Alias Authentication Token
    [Documentation]    Get the token to be used when calling the MicroService

    ${super_token}    Get Authorization Bearer    ${OTR_Internal_Services_Oauth2ClientID}
    ...    ${OTR_Internal_Services_Oauth2ClientSecret}    otr-service
    Set Suite Variable    ${super_token}    ${super_token['access_token']}

Should match UUID
    [Documentation]    Match the given argument against an UUID pattern
    [Arguments]    ${uuid}

    Should match regexp    ${uuid}    [a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}

Should match common carrier family fields
    [Documentation]    Check that the id, updated_by and updated_date fields are properly set
    [Tags]    qtest
    [Arguments]    ${carrier_family}

    Should match UUID    ${carrier_family['id']}
    Should not be empty    ${carrier_family['updated_by']}
    Should be equal as strings    ${carrier_family['updated_date']}    ${todayDashed}

Should match carrier family natural id
    [Documentation]    Match the carrier family natural id against the database and the returned value from API
    [Tags]    qtest
    [Arguments]    ${generated_carrier_family}    ${carrier_family_created}

    ${query}    Catenate    select carrier_family_natural_id from carrier_family
    ...    where id = '${carrier_family_created["id"]}'
    ${carrier_family}    query and strip    ${query};    db_instance=postgrespgcarrierservices
    ${uppercased_carrier_family}    String.Convert to uppercase    ${generated_carrier_family}
    Should be equal as strings    ${carrier_family}    ${uppercased_carrier_family}
    Should be equal as strings    ${carrier_family}    ${carrier_family_created['carrier_family_natural_id']}

Should match carrier family error response
    [Documentation]    Match the error response from the carrier family creation
    [Tags]    qtest
    [Arguments]    ${response}    @{args}    ${msg}=Invalid request input

    Should Be Equal As Strings    ${response}[name]    BAD_REQUEST
    Should Be Equal As Strings    ${response}[message]    ${msg}
    IF    len(${args}) > 0
        Should Be Equal As Strings    ${response}[details][0][field]    ${args}[0]
        Should Be Equal As Strings    ${response}[details][0][issue]    ${args}[1]
    END

Create a list of carriers
    [Documentation]    Create a list of carriers containing id, name and parent flag
    [Tags]    qtest
    [Arguments]    ${count}=3

    @{carriers}    Create List
    FOR    ${i}    IN RANGE    ${count}
        ${carrier_id}    Evaluate    9998880 + ${i}
        ${carrier_name}    Catenate    Carrier Test    ${i}
        ${is_parent}    Evaluate    random.choice([True, False])    random
        ${carrier}    Create Dictionary    id=${carrier_id}    name=${carrier_name}    is_parent=${is_parent}
        Append To List    ${carriers}    ${carrier}
    END
    Return From Keyword    ${carriers}

Should match sent and created carrier families
    [Documentation]    Match the the carrier family we sent to the API against the one API created and returned to us
    [Tags]    qtest
    [Arguments]    ${sent}    ${created}    ${carrier_family_natural_id}

    ${uppercased_carrier_family}    String.Convert to uppercase    ${carrier_family_natural_id}
    Should be equal as strings    ${uppercased_carrier_family}    ${created['carrier_family_natural_id']}
    Should Be Equal As Numbers    ${sent['id']}    ${created['carrier_id']}
    Should Be Equal As Strings    ${sent['name']}    ${created['carrier_name']}
    Should Be Equal    ${sent['is_parent']}    ${created['is_parent']}
    Should match common carrier family fields    ${created}

Check that unique alias flag is true
    [Documentation]    Check that the alias_unique_in_family flag is set to true
    [Tags]    qtest
    [Arguments]    ${response}

    Should be true    ${response['alias_unique_in_family']}

Cleanup carrier family database
    [Documentation]    Cleans up the carrier family tables
    [Tags]    qtest
    [Arguments]    ${carrier_family_natural_id}

    ${query}    Catenate    delete from carrier_family_carrier_xref
    ...    where carrier_family_natural_id = upper('${carrier_family_natural_id}')
    Execute sql string    dml=${query};    db_instance=postgrespgcarrierservices

    ${query}    Catenate    delete from carrier_family
    ...    where carrier_family_natural_id = upper('${carrier_family_natural_id}')
    Execute sql string    dml=${query};    db_instance=postgrespgcarrierservices

Add carrier family
    [Documentation]    Add a carrier family using the API
    [Arguments]    ${empty_natural_id}=${False}    ${unique_alias}=${True}    ${duplicate}=${False}

    IF    ${empty_natural_id} == True
        ${carrier_family_natural_id}    Set Variable    ${EMPTY}
    ELSE
        ${carrier_family_natural_id}    Generate random string    10    12345abcde
        Set test variable    ${carrier_family_natural_id}
    END
    ${family}    Create Dictionary    carrier_family_natural_id=${carrier_family_natural_id}
    ...    alias_unique_in_family=${unique_alias}
    ${response}    ${status}    OTR eMgr Api Request    POST    family    ${family}
    IF    ${duplicate} == True
        ${response}    ${status}    OTR eMgr Api Request    POST    family    ${family}
    END
    Return From Keyword    ${response}

Create random carrier family
    [Documentation]    Create a random carrier family natural id
    [Tags]    qtest

    ${response}    Add carrier family
    Return From Keyword    ${response}

Create duplicated carrier family
    [Documentation]    Tries to create a duplicated carrier family
    [Tags]    qtest

    ${response}    Add carrier family    duplicate=${True}
    Return From Keyword    ${response}

Create carrier family with empty natural id
    [Documentation]    Tries to create a carrier family with an empty natural id
    [Tags]    qtest

    ${response}    Add carrier family    empty_natural_id=${True}
    Return From Keyword    ${response}

Create carrier family with empty unique alias flag
    [Documentation]    Tries to create a carrier family with an empty unique alias flag
    [Tags]    qtest

    ${response}    Add carrier family    unique_alias=${EMPTY}
    Return From Keyword    ${response}

Assign a list of carriers to a family
    [Documentation]    Assign a list of carriers represented by a JSON containing id, name and parent flag
    ...    to a family
    [Tags]    qtest
    [Arguments]    ${carrier_family_natural_id}    ${carriers}

    ${carriers_payload}    Create Dictionary    carriers=${carriers}
    ${response}    ${status}    OTR eMgr Api Request    POST    family/${carrier_family_natural_id}/assignments
    ...    ${carriers_payload}
    Return From Keyword    ${response}

Assign an empty list of carriers to a family
    [Documentation]    Assign an empty list of carriers, represented by an empty JSON array, to a family
    [Tags]    qtest
    [Arguments]    ${carrier_family_natural_id}

    @{carriers}    Create List
    ${carriers_payload}    Create Dictionary    carriers=${carriers}
    ${response}    ${status}    OTR eMgr Api Request    POST    family/${carrier_family_natural_id}/assignments
    ...    ${carriers_payload}
    Return From Keyword    ${response}

Set carrier id to nothing
    [Documentation]    Set the carrier id field to nothing
    [Tags]    qtest
    [Arguments]    ${carriers}

    Set To Dictionary    ${carriers}[0]    id=${EMPTY}

Set carrier name to nothing
    [Documentation]    Set the carrier name field to nothing
    [Tags]    qtest
    [Arguments]    ${carriers}

    Set To Dictionary    ${carriers}[0]    name=${EMPTY}

Set carrier parent flag to nothing
    [Documentation]    Set the carrier parent flag field to nothing
    [Tags]    qtest
    [Arguments]    ${carriers}

    Set To Dictionary    ${carriers}[0]    is_parent=${EMPTY}

Retrieve the carriers family
    [Documentation]    Retrieve the family of a carrier
    [Tags]    qtest
    [Arguments]    ${carrier_id}

    ${response}    ${status}    OTR eMgr Api Request    GET    family/carriers/${carrier_id}
    Return From Keyword    ${response}

Check that the response has a not found error
    [Documentation]    Check that the response error has a not found message
    [Tags]    qtest
    [Arguments]    ${carrier_id}    ${response}

    ${url_path}    Catenate    SEPARATOR=    /family/carriers/    ${carrier_id}
    Should Be Equal As Numbers    ${response}[status]    404
    Should Be Equal As Strings    ${response}[error]    Not Found
    Should Be Equal As Strings    ${response}[path]    ${url_path}
    Should Contain    ${response}[timestamp]    ${todayDashed}

Check that Carrier Already assigned to family returned
    [Documentation]  Check that the response contains the status message
     ...  "Not assigned. Carrier already assigned to: carrier_family_natural_id"
    [Tags]  qTest
    [Arguments]  ${response}  ${uppercased_carrier_family}
    Should Contain      ${response[0]['status']}  Not assigned. Carrier already assigned to: ${uppercased_carrier_family}