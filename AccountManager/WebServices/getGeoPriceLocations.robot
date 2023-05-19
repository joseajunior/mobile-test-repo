*** Settings ***
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Teardown WS

*** Variables ***
#DEFAULT INFO ABOUT 231010 LOCATION
${card_num}  7083050910386614158
${latitude}  33.513515
${longitude}  -93.948545
${search_range}  0
${tax_flag}  1

*** Test Cases ***
Valid Input
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30894393  Regression  refactor
    ${ws_price_locations}  Get Price Locations From WS  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    ${db_price_locations}  Get Price Locations From DB  ${card_num}
    Format Response  ${ws_price_locations}
    ${db_ws_match}  Compare Dictionaries As Strings  ${ws_price_locations}  ${db_price_locations}
    Should Be True  ${db_ws_match}

Check TYPO on Card Number
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30894802  Regression
    Set Test Variable  ${card_num}  ${card_num}f
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate EMPTY value on Card Number
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895072  Regression
    Set Test Variable  ${card_num}  ${EMPTY}
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate Invalid value on Card Number
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895306  Regression
    Set Test Variable  ${card_num}  1nv@l1d_c@rd
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Check TYPO on Latitude
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895541  Regression
    Set Test Variable  ${latitude}  ${latitude}ff
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate EMPTY value on Latitude
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895592  Regression
    Set Test Variable  ${latitude}  ${EMPTY}
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate Invalid value on Latitude
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895595  Regression
    Set Test Variable  ${latitude}  1nv@l1d_l@t1tud3
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Check TYPO on Longitude
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895603  Regression
    Set Test Variable  ${longitude}  ${longitude}ff
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate EMPTY value on Longitude
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895644  Regression
    Set Test Variable  ${longitude}  ${EMPTY}
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate Invalid value on Longitude
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895710  Regression
    Set Test Variable  ${longitude}  1nv@l1d_l0ng1tud3
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Check TYPO on Search Range
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895714  Regression
    Set Test Variable  ${search_range}  ${search_range}ff
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate EMPTY value on Search Range
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895719  Regression
    Set Test Variable  ${search_range}  ${EMPTY}
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Validate Invalid value on Search Range
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895725  Regression
    Set Test Variable  ${search_range}  1nv@l1d_s34rch_r4ng3
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  ERROR running command

Check TYPO on Tax Flag
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895727  Regression
    Set Test Variable  ${tax_flag}  ${tax_flag}f
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  in valid string -1f for boolean value

Validate EMPTY value on Tax Flag
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895734  Regression  refactor
    Set Test Variable  ${tax_flag}  ${EMPTY}
    ${ws_price_locations}  Get Price Locations From WS  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    ${db_price_locations}  Get Price Locations From DB  ${card_num}
    Format Response  ${ws_price_locations}
    ${db_ws_match}  Compare Dictionaries As Strings  ${ws_price_locations}  ${db_price_locations}
    Should Be True  ${db_ws_match}

Validate Invalid value on Tax Flag
    [Documentation]
    [Tags]  JIRA:BOT-1601  qTest:30895739  Regression
    Set Test Variable  ${tax_flag}  1nv@l1d_t4x_fl4g
    ${error_message}  Run Keyword And Expect Error  *  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    should contain  ${error_message}  in valid string -1nv@l1d_t4x_fl4g for boolean value


*** Keywords ***
Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Teardown WS
    Disconnect From Database
    logout

Get Price Locations From WS
    [Arguments]  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    ${ws_price_locations}  getGeoPriceLocations  ${card_num}  ${latitude}  ${longitude}  ${search_range}  ${tax_flag}
    [Return]  ${ws_price_locations}

Format Response
    [Arguments]  ${price_locations}
    tch logging  \n
    FOR  ${price_loc}  IN  ${price_locations}
        ${price}  Convert To Number  ${price_loc['price']}  2
        ${latitude}  Convert To Number  ${price_loc['latitude']}  6
        ${longitude}  Convert To Number  ${price_loc['longitude']}  6
        Set To Dictionary  ${price_loc}  price=${price}
        Set To Dictionary  ${price_loc}  latitude=${latitude}
        Set To Dictionary  ${price_loc}  longitude=${longitude}
    END

Get Price Locations From DB
    [Arguments]  ${card_num}
    ${query}  Catenate
    ...  SELECT l.location_id AS locid,
    ...         name,
    ...         address_1 AS addr1,
    ...         address_2 AS addr2,
    ...         city,
    ...         state,
    ...         TRIM(zip) AS zip,
    ...         src_country AS country,
    ...         phone,
    ...         chain_id AS chainid,
    ...         TRIM(loc_lat) AS latitude,
    ...         TRIM(loc_long) AS longitude,
    ...         round(tl.ppu,2) as price,
    ...         NULL::INTEGER as amenities
    ...   FROM location l
    ...       INNER JOIN transaction t ON l.location_id = t.location_id
    ...       INNER JOIN trans_line tl ON t.trans_id = tl.trans_id
    ...   WHERE t.card_num = '${card_num}'
    ...   ORDER BY t.trans_date desc
    ...   LIMIT 1
    ${output}  Query To Dictionaries  ${query}
    [Return]  ${output[0]}