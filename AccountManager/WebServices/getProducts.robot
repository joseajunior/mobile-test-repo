*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS
Suite Teardown  Logout WS

*** Test Cases ***
Get Products Information
    [Tags]  JIRA:BOT-1611  qTest:30747230  Regression
    [Documentation]  Make sure you can fetch information from the getProducts webservice call.

    ${DB_info}  Get Product Info
    ${WS_info}  getProducts

    ${same_dict}  Compare List Dictionaries As Strings  ${DB_info}  ${WS_info}
    Should Be True  ${same_dict}

*** Keywords ***

Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Logout WS
    Logout

Get Product Info
    ${query}  catenate
    ...     SELECT TRIM(abbrev) AS code,
    ...     TRIM(description) AS description,
    ...     DECODE(fuel_type, NULL, 0, fuel_type) AS fuelType,
    ...     DECODE(fuel_use, NULL, 0, fuel_use) AS fuelUse,
    ...     TRIM(restriction_group) AS group,
    ...     DECODE(phrase_id, NULL, 0, phrase_id) AS phraseId,
    ...     TRIM(DECODE(shell_cl_product, NULL, '0', '32')) AS shellClProduct,
    ...     TRIM(DECODE(shell_fuel_type, NULL,'0','D','68','R','82','G','71','F','70','','32','X','88','Z','90','x','120','M','77','P','80', shell_fuel_type)) AS shellFuelType,
    ...     DECODE(shell_price_grp, '', NULL, shell_price_grp) AS shellPriceGroup
    ...     FROM products
    ...     WHERE fps_partner='TCH' ORDER BY code
    ${results}  Query To Dictionaries  ${query}
    [Return]  ${results}