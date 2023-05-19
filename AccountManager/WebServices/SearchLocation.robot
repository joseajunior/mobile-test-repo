*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Test Cases ***
Valid Full Input
    [Documentation]  Call searchLocation method on Web Service, fill all input parameter
    ...  and validate if it's returning locations according to the filters.
    [Tags]  JIRA:BOT-1577  qTest:30510795  Regression  refactor
    ${ws_location}  SearchLocation  location_id=231010  country=USA  state=AR  city=TEXARKANA  name=FJ-TEXARKANA 606  chainId=1
    Assert Location on DB  ${ws_location['locId']}

Valid Partial Input
    [Documentation]  Call searchLocation method on Web Service, fill a couple of input parameter(not all of them)
    ...  and validate if it's returning locations according to the filters.
    [Tags]  JIRA:BOT-1577  qTest:30511025  Regression
    ${ws_location}  SearchLocation  country=USA  state=AR  city=TEXARKANA  chainId=1
    FOR  ${loc}  IN  @{ws_location}
        Assert Location on DB  ${loc['locId']}
    END

Compare DB Result With WS
    [Documentation]
    [Tags]  JIRA:BOT-1577  refactor
    ${ws_locations}  SearchLocation  country=USA  city=SALT LAKE CITY  name=0
    ${db_locations}  Get Locations Count From DB  city=SALT LAKE CITY  name=0  country=USA
    ${ws_location_count}  Get Length  ${ws_locations}
    ${db_location_count}  Get Length  ${db_locations}
    Should Be Equal As Numbers  ${db_location_count}  ${ws_location_count}

Invalid Empty Input
    [Documentation]  Call searchLocation method on Web Service, do not input parameters and validate error message.
    [Tags]  JIRA:BOT-1577  qTest:30511153  Regression  refactor
    Run Keyword And Expect Error  *  searchLocation
    should contain  ${ws_error}  Must specify some search criteria.

Invalid Location Id
    [Documentation]  Call searchLocation method on Web Service using an invalid location id.
    [Tags]  JIRA:BOT-1577  qTest:30511181  Regression
    ${locations}  searchLocation  location_id=1nv@l1d_l0c@t10n
    Should Be Empty  ${locations}

TYPO Location Id
    [Documentation]  Call searchLocation method on Web Service with a TYPO on location id field.
    [Tags]  JIRA:BOT-1577  qTest:30511189  Regression
    ${locations}  searchLocation  location_id=${validLoc}f
    Should Be Empty  ${locations}

Invalid City
    [Documentation]  Call searchLocation method on Web Service using an invalid city name.
    [Tags]  JIRA:BOT-1577  qTest:30511218  Regression
    ${locations}  searchLocation  city=1nv@l1d_c1ty
    Should Be Empty  ${locations}

TYPO City
    [Documentation]  Call searchLocation method on Web Service with a TYPO city name.
    [Tags]  JIRA:BOT-1577  qTest:30511224  Regression
    ${locations}  searchLocation  city=OGDENf
    Should Be Empty  ${locations}

Invalid Name
    [Documentation]  Call searchLocation method on Web Service using an invalid name.
    [Tags]  JIRA:BOT-1577  qTest:30511237  Regression
    ${locations}  searchLocation  name=1nv@l1d_n@m3
    Should Be Empty  ${locations}

TYPO Name
    [Documentation]  Call searchLocation method on Web Service with a TYPO on name field.
    [Tags]  JIRA:BOT-1577  qTest:30511241  Regression
    ${locations}  searchLocation  city=FJ-TEXARKANA 606f
    Should Be Empty  ${locations}

Invalid Country
    [Documentation]  Call searchLocation method on Web Service using an invalid country.
    [Tags]  JIRA:BOT-1577  qTest:30511249  Regression
    ${locations}  searchLocation  country=1nv@l1d_c0untry
    Should Be Empty  ${locations}

TYPO Country
    [Documentation]  Call searchLocation method on Web Service with a TYPO on country field.
    [Tags]  JIRA:BOT-1577  qTest:30511258  Regression
    ${locations}  searchLocation  country=USAf
    Should Be Empty  ${locations}

Invalid Chain
    [Documentation]  Call searchLocation method on Web Service using an invalid chainId.
    [Tags]  JIRA:BOT-1577  qTest:30511270  Regression
    ${locations}  searchLocation  chainId=1nv@l1d_ch@1n
    Should Be Empty  ${locations}

TYPO Chain
    [Documentation]  Call searchLocation method on Web Service with a TYPO on chainId field.
    [Tags]  JIRA:BOT-1577  qTest:30511280  Regression
    ${locations}  searchLocation  chainId=1f
    Should Be Empty  ${locations}

*** Keywords ***
Get Locations Count From DB
    [Arguments]  ${location_id}=${EMPTY}  ${state}=${EMPTY}  ${city}=${EMPTY}  ${name}=${EMPTY}  ${country}=${EMPTY}  ${chain_id}=${EMPTY}
    ${base_query}  Catenate
    ...  SELECT DISTINCT l.location_id,
    ...                  l.state,
    ...                  l.city,
    ...                  l.address_1,
    ...                  l.address_2,
    ...                  phone,
    ...                  name
    ...  FROM contract co
    ...    JOIN issr_loc il ON il.issuer_id = co.issuer_id
    ...    JOIN location l ON il.location_id = l.location_id
    ...  WHERE co.carrier_id = ${userName}
    ${location_filter}  Set Variable If  '${location_id}' != '${EMPTY}'  AND l.location_id = ${location_id}  ${EMPTY}
    ${state_filter}  Set Variable If  '${state}' != '${EMPTY}'  AND l.state = '${state}'  ${EMPTY}
    ${city_filter}  Set Variable If  '${city}' != '${EMPTY}'  AND l.city like '%${city}%'  ${EMPTY}
    ${name_filter}  Set Variable If  '${name}' != '${EMPTY}'  AND l.name like '%${name}%'  ${EMPTY}
    ${country_filter}  Set Variable If  '${country}' != '${EMPTY}'  AND l.src_country = '${country}'  ${EMPTY}
    ${chain_filter}  Set Variable If  '${chain_id}' != '${EMPTY}'  AND l.chain_id = ${chain_id}  ${EMPTY}

    ${full_query}  Catenate  ${base_query}  ${location_filter}  ${state_filter}  ${city_filter}  ${name_filter}  ${country_filter}  ${chain_filter}
    ${locations}  Query To Dictionaries  ${full_query}
    [Return]  ${locations}

Get Data From DB
    [Arguments]  ${location_id}=${EMPTY}  ${state}=${EMPTY}  ${city}=${EMPTY}  ${name}=${EMPTY}  ${country}=${EMPTY}  ${chain_id}=${EMPTY}  ${query_limit}=10
    ${base_query}  Catenate
    ...  SELECT location_id,
    ...         state,
    ...         city,
    ...         name,
    ...         src_country,
    ...         chain_id
    ...  FROM location
    ...  WHERE 1 = 1
    ${limit_query}  Catenate  LIMIT ${query_limit}
#    ${limit_query}  Set Variable  ${EMPTY}
    ${location_filter}  Set Variable If  '${location_id}' != '${EMPTY}'  AND location_id = ${location_id}  ${EMPTY}
    ${state_filter}  Set Variable If  '${state}' != '${EMPTY}'  AND state = '${state}'  ${EMPTY}
    ${city_filter}  Set Variable If  '${city}' != '${EMPTY}'  AND city = '${city}'  ${EMPTY}
    ${name_filter}  Set Variable If  '${name}' != '${EMPTY}'  AND name = '${name}'  ${EMPTY}
    ${country_filter}  Set Variable If  '${country}' != '${EMPTY}'  AND src_country = '${country}'  ${EMPTY}
    ${chain_filter}  Set Variable If  '${chain_id}' != '${EMPTY}'  AND chain_id = ${chain_id}  ${EMPTY}

    ${full_query}  Catenate  ${base_query}  ${location_filter}  ${state_filter}  ${city_filter}  ${name_filter}  ${country_filter}  ${chain_filter}  ${limit_query}
    tch logging  ${full_query}  INFO

    Get Into DB  tch
    ${locations}  Query And Strip To Dictionary  ${full_query}
    Disconnect From Database
    [Return]  ${locations}

Find Value In List
    [Arguments]  ${value}  ${list}
    ${find}  Set Variable  ${False}
    FOR  ${tuple}  IN  @{list}
        ${find}  set variable if  '${tuple['locId']}'=='${value}'  ${True}  ${find}
        Run Keyword If  '${find}'=='${True}'  Exit For Loop
    END
    [Return]  ${find}

Assert Location on DB
    [Arguments]  ${location_id}
    Row Count Is Greater Than X  SELECT 1 FROM location WHERE location_id = ${location_id}  0

Search Location Name Which Contain Especial Char
    ${query}  Catenate  SELECT * FROM location WHERE name LIKE '%&%' LIMIT 1
    ${name}  Query And Strip  ${query}
    [Return]  ${name}

Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout