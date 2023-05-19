*** Settings ***
Library         String
Library         otr_robot_lib.ws.PortalWS
Library         otr_model_lib.services.GenericService
Library         Collections
Library         otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library         otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library         otr_robot_lib.ws.RestAPI.RestAPIService
Resource        otr_robot_lib/robot/APIKeywords.robot

Documentation  Tests the GETListofPolicies endpoint in the OTR-Policies controller
...  within the Cards API Services

Force Tags  ditOnly  CardServicesAPI  API
Suite Setup  Check For My Automation User
Suite Teardown  Remove User if Still exists

*** Variables ***
&{default_options}      page=0  size=10

#TODO update test when O5SA-329 and 330 are implemented
*** Test Cases ***
GET List of Policies
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    [Setup]  Generate Data for Request
    Send GET API Request for List of Policies
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET List of Policies with Negative Paging
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    [Setup]  Generate Data for Request
    Send GET API Request for List of Policies with Negative Page
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET List of Policies with Negative Sizing
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    [Setup]  Generate Data for Request
    Send GET API Request for List of Policies with Negative Size
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET List of Policies with Paging Optionals
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    [Setup]  Generate Data for Request
    Send GET API Request for List of Policies with Paging Optionals
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET List of Policies with Valid Sort
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    [Setup]  Generate Data for Request
    Send GET API Request for List of Policies using Valid Sort
    Compare GET Endpoint Results
    [Teardown]  Remove User if Necessary

GET List of Policies with Large Policy Sort
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    [Setup]  Generate Data for Request
    Send GET API Request for List of Policies using Large Policy Sort
    [Teardown]  Remove User if Necessary

GET List of Policies with Negative Policy Sort
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    [Setup]  Generate Data for Request
    Send GET API Request for List of Policies using Negative Policy Sort
    [Teardown]  Remove User if Necessary

GET List of Policies with Invalid Token
    [Tags]  PI:13  JIRA:FIVE-161   qTest:54401258  OTR-Policies
    GET List of Policies Error with Invalid Token
    [Teardown]  Remove User if Necessary

*** Keywords ***
Generate Data for Request
    [Documentation]  gets necessary information to run tests
    [Arguments]  ${reset_user_status}=N
    Getting API URL
    ${api_data_value}  get variable value  $api_data  default
    ${user_value}  get variable value  $user_status  default
    IF  $api_data_value=='default'
        ${my_carrier_id}  Find Carrier in Oracle  A
        Set Suite Variable  ${my_carrier_id}
    END
    Create My User         persona_name=carrier_manager  entity_id=${my_carrier_id}  with_data=N  need_new_user=${reset_user_status}
    ${values}  Find Data to be Used for Requests  ${my_carrier_id}
    Set Suite Variable  ${api_data}  ${values}

Getting API URL
    [Documentation]  get url to be used for tests
    Get url for suite    ${cardsservice}

Find Data to be Used for Requests
    [Documentation]  get the data to be used in the request
    [Arguments]  ${my_carrier_id}
    Get into DB  TCH
    ${count}  Catenate  select count(*) from contract where carrier_id = ${my_carrier_id}
    ${count_results}  Query and Return Dictionary Rows  ${count}
    ${rand_num}  Evaluate  random.randint(0, (${count_results}[0][1] - 1))  random
    ${tch_query}  Catenate  select skip ${rand_num}
    ...  co.carrier_id,
    ...  co.ar_number,
    ...  co.contract_id,
    ...  ca.card_id,
    ...  CASE WHEN (SELECT COUNT(co1.issuer_id)
    ...             FROM contract co1, carrier_group_issuer cgi1
    ...             WHERE co1.carrier_id = ${my_carrier_id}
    ...             AND cgi1.issuer_id = co1.issuer_id) > 0 THEN TRIM('parent_funded')
    ...       WHEN (SELECT COUNT(co1.issuer_id)
    ...             FROM contract co1, carrier_group_issuer cgi1
    ...             WHERE co1.carrier_id = ${my_carrier_id}
    ...  AND cgi1.issuer_id = co1.issuer_id) < 0 THEN TRIM('credit')
    ...       ELSE 'carrier_parent'
    ...  END AS contract_type
    ...  from contract co, cards ca
    ...  where co.carrier_id = ${my_carrier_id}
    ...  and co.carrier_id = ca.carrier_id
    ...  and ca.payr_use != ''
    ...  limit 1
    ${url_values}  Query and Strip to Dictionary  ${tch_query}
    Disconnect from Database
    [Return]  ${url_values}

Send ${response_type} API Request for List of Policies
    [Documentation]  used to call the list of policies endpoint
    Send Request  response_type=${response_type}

Send Request
    [Documentation]  sends request to endpoint
    [Arguments]  ${carrier}=${api_data}[carrier_id]  ${optionals}=${default_options}  ${response_type}=GET  ${secure}=Y
    ${optionals_nested_len}  Evaluate  sum(len(k) for k in $optionals.keys() if k.isdigit())
    Set Test Variable  ${optionals_nested_len}
    ${url}  Create Dictionary  carriers=${carrier}
    IF  ${optionals}==${default_options}
        Set Test Variable  ${optionals}  ${default_options}
    END

    IF  ${optionals}==${NONE}
        ${response}  ${status}  Api Request  ${response_type}  card-policies  ${secure}  ${url}  application=OTR_eMgr
    ELSE
        IF  ${optionals_nested_len}>0
            FOR  ${i}  IN RANGE  ${optionals_nested_len}
                ${options}  Evaluate  $optionals.get('${i+1}')
                ${response}  ${status}  Api Request  ${response_type}  card-policies  ${secure}  ${url}  ${options}
                ...                                  application=OTR_eMgr
                Set Test Variable  ${response${i+1}}  ${response}
                Set Test Variable  ${status${i+1}}  ${status}
            END
        ELSE
            ${response}  ${status}  Api Request  ${response_type}  card-policies  ${secure}  ${url}  ${optionals}
            ...                                  application=OTR_eMgr
        END
    END

    Set Test Variable  ${optionals}  default
    Set Test Variable  ${response}
    Set Test Variable  ${status}


Compare GET Endpoint Results
    ${result_from_DB}  Get Endpoint values from DB
    ${db_result_status}  Run Keyword and Ignore Error  get variables  ${result_from_DB}
    IF  'FAIL' in '${db_result_status}[0]'
        Set Test Variable  ${result_from_DB}  ${result_from_DB}
    END
    IF  ${optionals_nested_len}==0
        Should Be Equal As Strings      ${response}[details][data][0][policy_number]        ${result_from_DB}[0][policy_number]
        Should Be Equal As Strings      ${response}[details][data][0][policy_type]        ${result_from_DB[0]['policy_type'].replace(" ", "_")}
        IF  ${result_from_DB}[0][policy_name]!=${NONE}
            Should Be Equal                 ${response}[details][data][0][policy_name]                 ${result_from_DB[0]['policy_name'].strip()}
        END
        Should Be Equal As Strings  ${status}  200
    ELSE
        FOR  ${i}  IN RANGE  ${optionals_nested_len}
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][policy_number]        ${result_from_DB}[0][policy_number]
            Should Be Equal As Strings      ${response${i+1}}[details][data][0][policy_type]        ${result_from_DB[0]['policy_type'].replace(" ", "_")}
            IF  ${result_from_DB}[0][policy_name]!=${NONE}
                Should Be Equal                 ${response${i+1}}[details][data][0][policy_name]                 ${result_from_DB[0]['policy_name'].strip()}
            END
            Should Be Equal As Strings  ${status${i+1}}  200
        END
    END


Get Endpoint values from DB
    [Documentation]  Query for getting list policies information from the database
    #should always do this, it's mainly for paging
    ${optionals_value}  Get Variable Value  $optionals  default
    ${page}  ${size}  Check Optionals
    IF  '${optionals_value}'=='default'
        ${optionals}  Set Variable  ${default_options}
    END

    IF  'page' in """${optionals}""" and 'size' in """${optionals}"""
        ${condition}  Set Variable  WHERE dc.id = '${api_data}[carrier_id]'
    ELSE
        ${condition}  Set Variable  WHERE dc.id = '${api_data}[carrier_id]' AND dc.policy = '${optionals}[policy]'
    END

    Get into DB  TCH
    ${query}  Catenate  SELECT SKIP ${page} FIRST ${size} dc.ipolicy AS policy_number,
    ...        CASE WHEN  dc.description != '' THEN TRIM(dc.description)
    ...        END AS policy_name,
    ...        pt.policy_type_desc AS policy_type
    ...  FROM def_card dc
    ...  INNER JOIN policy_type pt
    ...  ON pt.policy_type_id = dc.policy_type_id
    ...  ${condition}

    ${result_list}  Query to Dictionaries  ${query}
    [Return]  ${result_list}

Send ${response_type} API Request for List of Policies with ${option}
    [Documentation]  used to call the card summaries endpoint
    IF  '${option.upper()}'=='NEGATIVE PAGE'
        &{options_dict}      Create Dictionary      page=-1  size=5
        Set Test Variable  ${optionals}  ${options_dict}
        Send Request  optionals=${optionals}
    ELSE IF  '${option.upper()}'=='NEGATIVE SIZE'
        &{options_dict}  Create Dictionary  page=0  size=-5
        Set Test Variable  ${optionals}  ${options_dict}
        Send Request  optionals=${optionals}
    ELSE IF  '${option.upper()}'=='PAGING OPTIONALS'
        &{letter_for_page}  Create Dictionary  page=a  size=5
        &{letter_for_size}  Create Dictionary  page=0  size=p
        #use numbers as the keys if needing to add different page/size options
        &{options_dict}  Create Dictionary  1=${letter_for_page}  2=${letter_for_size}
        Set Test Variable  ${optionals}  ${options_dict}
        Send Request  optionals=${optionals}
    ELSE
        tch logging  case ${option.upper()} not handled
    END

Send ${response_type} API Request for List of Policies using ${option} Sort

    IF  '${option.upper()}'=='LARGE POLICY'
        ${my_sort}  Create Sort Optionals  ${option.upper()}
        Send Request  optionals=${my_sort}
        Should be Equal as Strings  ${status}  204
    ELSE IF  '${option.upper()}'=='NEGATIVE POLICY'
        ${my_sort}  Create Sort Optionals  ${option.upper()}
        Send Request  optionals=${my_sort}
        Should be Equal as Strings  ${status}  400

    ELSE IF  '${option.upper()}'=='VALID'
        ${my_sort}  Create Sort Optionals  ${option.upper()}
        Send Request  optionals=${my_sort}
        Should be Equal as Strings  ${status}  200
    END

GET List of Policies Error with ${error}
    Getting API URL
    ${api_data_value}  Get Variable Value  $api_data_value  default
    IF  $api_data_value=='default'
        ${my_carrier_id}  Find Carrier in Oracle  A
        ${api_data}  Create Dictionary  carrier_id=${my_carrier_id}
        Set Suite Variable  ${api_data}
    END

    IF  '${error.upper()}'=='INVALID TOKEN'
        Send Request  secure=I
        Should be Equal as Strings  ${status}  401
    ELSE
        Fail  Error '${error.upper()}' not implemented. Status code: ${status}
    END

Create Sort Optionals
    [Documentation]  used to create sort optionals based on what arguments are passed
    [Arguments]  ${option}
    ${result_from_DB}  Get Endpoint values from DB
    IF  """${result_from_DB}"""!='${EMPTY}'
        ${rand_policy_number}  Evaluate  random.choice(list({x['policy_number'] for x in ${result_from_DB} if 'policy_number' in x}))  random
    ELSE
        ${rand_policy_number}  Generate Random String  1  [NUMBERS]
    END

    IF  '${option}'=='LARGE POLICY'
        ${number}  Generate Random String  3  [NUMBERS]
        &{option}  Create Dictionary  policy=${number}
        Return from Keyword  ${option}
    ELSE IF  '${option}'=='NEGATIVE POLICY'
        &{option}  Create Dictionary  policy=-1
        Return from Keyword  ${option}
    ELSE IF  '${option}'=='VALID'
        &{option}  Create Dictionary  policy=${rand_policy_number}
        Return from Keyword  ${option}
    END

Check Optionals
    [Documentation]  modify optionals (page and size) for sql queries to use
    ${check_page}  Run Keyword and Ignore Error  Get from Dictionary  ${optionals}  page
    ${check_size}  Run Keyword and Ignore Error  Get from Dictionary  ${optionals}  size

    IF  'PASS' in """${check_page}"""
        ${is_page_alpha}  Evaluate  $optionals['page'].isalpha()
    ELSE
        ${page}  Set Variable  0
    END

    IF  'PASS' in """${check_size}"""
        ${is_size_alpha}  Evaluate  $optionals['size'].isalpha()
    ELSE
        ${size}  Set Variable  10
    END

    Return from Keyword if  'FAIL' in """${check_page}""" and 'FAIL' in """${check_size}"""  ${page}  ${size}

    IF  ${is_page_alpha}==${FALSE}
        ${is_page_int}  Get from Dictionary  ${optionals}  page
    END

    IF  ${is_size_alpha}==${FALSE}
        ${is_size_int}  Get from Dictionary  ${optionals}  size
    END

    IF  ${is_page_alpha}==${TRUE}
        ${page}  Set Variable  0
    ELSE IF  ${is_page_int} <= 0
        ${page}  Set Variable  0
    ELSE IF  (${is_page_int} > 0 and ${is_size_int} < 0) or (${is_page_int} > 0 and ${is_size_alpha} == ${TRUE})
        ${new_page}  Evaluate  ${is_page_int}
        ${page}  Set Variable  ${new_page}
    ELSE IF  ${is_page_int} >= 0 and ${is_size_int} >= 0
        ${new_page}  Evaluate  ${is_page_int} * ${is_size_int}
        ${page}  Set Variable  ${new_page}
    ELSE
        ${page}  Set Variable  0
    END

    IF  ${is_size_alpha}==${TRUE}
        ${size}  Set Variable  10
    ELSE IF  ${is_size_int} <= 0
        ${size}  Set Variable  10
    ELSE
        ${size}  Set Variable  ${is_size_int}
    END
    ${size}  Convert to String  ${size}
    ${page}  Convert to String  ${page}
    [Return]  ${page}  ${size}