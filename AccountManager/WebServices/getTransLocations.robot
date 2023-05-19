*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Web Services

*** Test Cases ***
Check TYPO on the locationId
    [Tags]  JIRA:BOT-1559  qTest:30701615  Regression
    [Documentation]  Validate that you cannot pull up translocations with a typo on locationId
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getTransLocations  231024F
    Should Not Be True  ${status}
    [Teardown]  Logout

Getting translocations for two differents locations
    [Tags]  tier:0  JIRA:BOT-1559  qTest:30701642  Regression
    [Documentation]  Validate that you can pull up translocations for two differents locations
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getTransLocations  231024  504150
    Should Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on locationId
    [Tags]  JIRA:BOT-1559  qTest:30701765  Regression
    [Documentation]  Validate that you cannot pull up TransLocations using an empty locationId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getTransLocations  ${EMPTY}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate EMPTY value on the second locationId
    [Tags]  JIRA:BOT-1559  qTest:30701783  Regression
    [Documentation]  Validate that you cannot pull up TransLocations using an empty on the locationId.
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${status}  Run Keyword And Return Status  getTransLocations  231024  ${EMPTY}
    Should Not Be True  ${status}
    [Teardown]  Logout

Validate TransLocations Informations
    [Tags]  tier:0  JIRA:BOT-1559  qTest:30701790  Regression
    [Documentation]  Validate TransLocations Informations
    [Setup]  log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}
    ${locationId}  set variable  231024
    ${transLocationsDetails}  getTransLocations  ${locationId}
    Check TransLocations  ${locationId}  ${transLocationsDetails}
    [Teardown]  Logout


*** Keywords ***
Check TransLocations
    [Arguments]  ${locationId}  ${transLocationsDetails}
    Get Into DB  tch
    ${query}  Catenate
    ...  SELECT address_1 as address1,
    ...  TRIM(address_2) as address2,
    ...  decode(irv_apt_num,' ',NULL,irv_apt_num) as apartmentNumber,
    ...  irv_bu_type as businessType,
    ...  irv_bu_id as businessUnit,
    ...  chain_id as chainId,
    ...  city,
    ...  src_country as country,
    ...  TRIM(taxing_entity) as entity,
    ...  location_id as id,
    ...  TRIM(loc_lat) as latitude,
    ...  TRIM(loc_type) as locType,
    ...  TRIM(loc_long) as longitude,
    ...  name,
    ...  opis_id as opisId,
    ...  phone,
    ...  DECODE(rfc_num,' ',NULL,rfc_num) as rfcNumber,
    ...  irv_site_id as site,
    ...  state,
    ...  status,
    ...  DECODE(irv_street_num,' ',NULL,irv_street_num) as streetNumber,
    ...  supplier_id as supplier,
    ...  TRIM(supplier_loc_code) as supplierLocCode,
    ...  TRIM(zip) AS ZIP,
    ...  irv_zone_id as zone,
    ...  z.zone_nm as zoneName,
    ...  l.gst_tax_id as gstTaxId,
    ...  l.qst_tax_id as qstTaxId,
    ...  l.prices_updated as pricesUpdated,
    ...  l.data_source as dataSource
    ...  FROM location l INNER JOIN zone z ON (l.irv_zone_id = z.zone_id)
    ...  WHERE location_id='${locationId}';

    ${results}  Query To Dictionaries  ${query}

    Remove From Dictionary  ${transLocationsDetails}  pemexId

    ${dict_match}  compare_dictionaries_as_strings  ${results[0]}  ${transLocationsDetails}
    should be true  ${dict_match}