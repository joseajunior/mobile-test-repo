*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary

Force Tags  Web Services

Suite Setup  Setup WS

*** Test Cases ***

Set SmartPay Driver Info With Valid Parameters
    [Tags]  JIRA:BOT-1609  qTest:30917157  Regression  refactor
    [Documentation]  Make sure you can set the smartpay driver info.

    setSmartPayDriver  7083051014152600076  Ai  Misericordia  OGdenUtah  Ogden  UT  84401  USA  2019-04-03T00:00:00  1234  efs.testers@efsllc.com  555-555-555
    Check DB Data For SmartPay Driver

Set SmartPay Driver Info With Typo On The Parameters
    [Tags]  JIRA:BOT-1609  qTest:30917487  Regression  refactor
    [Documentation]  Make sure you can't set the smartpay driver info when you have a typo on any parameters

    ${status}  Run Keyword And Return Status  setSmartPayDriver  7083051014152600076  Ai  Misericordia  OGdenUtah  Ogden  UT  84401  USA  2019-0403T00:00:00  1234  efs.testers@efsllc.com  555-555-555
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setSmartPayDriver  7083051014152600076  Ai  Misericordia  OGdenUtah  Ogden  UT  84401  USA  2019-04-03T00:00:00  a  efs.testers@efsllc.com  555-555-555
    Should Not Be True  ${status}


Set SmartPay Driver Info When There's An EMPTY Parameter
    [Tags]  JIRA:BOT-1609  qTest:30917516  Regression
    [Documentation]  Make sure you can't set the smartpay driver info when you have a typo on any parameters.
    ...     For it to fail it has to be at least 8 empty parameters

    ${status}  Run Keyword And Return Status  setSmartPayDriver  ${EMPTY}  Ai  ${EMPTY}  ${EMPTY}  ${EMPTY}  UT1  ${EMPTY}  ${EMPTY}  ${EMPTY}  ${EMPTY}  efs.testers@efsllc.com  ${EMPTY}
    Should Not Be True  ${status}


Set SmartPay Driver Info When There's A Space Parameter
    [Tags]  JIRA:BOT-1609  qTest:30917528  Regression
    [Documentation]  Make sure you can't set the smartpay driver info when you have a typo on any parameters.
    ...     For it to fail it has to be at least 8 parameters with space

    ${status}  Run Keyword And Return Status  setSmartPayDriver  ${SPACE}  Ai  ${SPACE}  ${SPACE}  ${SPACE}  UT  ${SPACE}  ${SPACE}  ${SPACE}  ${SPACE}  efs.testers@efsllc.com  ${SPACE}
    Should Not Be True  ${status}

Set SmartPay Driver Info With Invalid Parameters
    [Tags]  JIRA:BOT-1609  qTest:30917567  Regression  refactor
    [Documentation]  Make sure you can't set the smartpay driver info when you have invalid parameters

    ${status}  Run Keyword And Return Status  setSmartPayDriver  7083051014152600076  Ai  Misericordia  OGdenUtah  Ogden  UT  84401  USA  2019-04?!@03T00:00:00  1234  efs.testers@efsllc.com  555-555-555
    Should Not Be True  ${status}

    ${status}  Run Keyword And Return Status  setSmartPayDriver  7083051014152600076  Ai  Misericordia  OGdenUtah  Ogden  UT  84401  USA  2019-04-03T00:00:00  a!s@d#  efs.testers@efsllc.com  555-555-555
    Should Not Be True  ${status}


*** Keywords ***

Setup WS
    Get Into DB  TCH
    log into card management web services  ${validCard.carrier.id}  ${validCard.carrier.password}

Check DB Data For SmartPay Driver

    ${query}  catenate
    ...  SELECT adp.* FROM ach_profile_card_xref acp, ach_driver_profile adp
    ...     WHERE acp.card_num = '7083051014152600076' AND acp.profile_id=adp.profile_id
    ${results}  Query And Strip To Dictionary  ${query}
    Tch Logging  \n RESULTS:${results}

    Should Be Equal As Strings  ${results["first_name"]}  Ai
    Should Be Equal As Strings  ${results["last_name"]}  Misericordia
    Should Be Equal As Strings  ${results["address"]}  OGdenUtah
    Should Be Equal As Strings  ${results["city"]}  Ogden
    Should Be Equal As Strings  ${results["state"]}  UT
    Should Be Equal As Numbers  ${results["postal_code"]}  84401
    Should Be Equal As Strings  ${results["country"]}  USA
    Should Be Equal As Strings  ${results["dob"]}  2019-04-03
    Should Be Equal As Numbers  ${results["lastfourss"]}  1234
    Should Be Equal As Strings  ${results["email_addr"]}  efs.testers@efsllc.com
    Should Be Equal As Strings  ${results["cell_phone"]}  555-555-55

