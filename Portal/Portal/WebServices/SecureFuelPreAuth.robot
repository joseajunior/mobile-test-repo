*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_model_lib.services.GenericService
Library  sqlalchemy.orm.collections
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Library  String
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ws.PortalWS
Library  openpyxl.utils.datetime
Library  otr_robot_lib.ws.SecureFuel
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/PortalKeywords.robot


Suite Setup  Setup

Force Tags  Portal  Secure Fuel

Documentation  This file creates and tests pre-auth requests for SecureFuel

Test Teardown  Set Sql Rows to Default

*** Variables ***
${token}
${carrier_id}
${unit_id}
${driver_id}=  driver123
@{events}
@{latitudeClose}
@{latitudeError}
@{longitudeClose}
@{longitudeError}


*** Test Cases ***

1 Secure Fuel PreAuth API Unit ID Not Found
    [Tags]  JIRA:PORT-467  qTest:50135188  Regression
    [Documentation]  This is to test the return of a SecureFuel Pre-Auth request where the Unit ID is not found
    Choose invalid unit_id
    Find carrier and Unit_ids  1
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${InvalidUnitID}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  -1  The error_code from the webservice
              ...   return of ${error_code} should be equal to -1
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no control record found  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no control record found


2 Secure Fuel PreAuth API Unit ID Found
    [Tags]  JIRA:PORT-467  qTest:50135273  qTest:50135273  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  0
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  0  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 0

3 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify
    [Tags]  JIRA:PORT-467  qTest:50135273  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table
        ...  and the position_verify is on/used (position_verify=1 and tank_verify = 0)
    Find carrier and Unit_ids  1
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1


4 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify & Tank Verify
    [Tags]  JIRA:PORT-467  qTest:50148813  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  2
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  1  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 1

5 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, & Invalid Proximity Validation
    [Tags]  JIRA:PORT-467  qTest:50162283  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  3
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  1  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 1

6 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, Invalid Proximity Valid, & No Event Record Valid
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  5
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  1  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 1



7 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify used to determine authorization
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  4
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1


8 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify Used, Invalid Proximity Valid, FAIL Proximity
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression  #test
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  5
    Delete Events in Redis for Carrier
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}  32  32
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  2  The action_code from the webservice
              ...   return of ${action_code} should be equal to 2
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Decline  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Decline
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  -1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to -1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  1  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 1

9 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify Used FAIL Proximity
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  2
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}  32  32
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal to no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  1  The action_code from the webservice
              ...   return of ${action_code} should be equal to 1
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Log Exception  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Log Exception
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  -1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to -1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  1  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 1

10 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, No Record Validate, No Record
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  6
    Delete Events in Redis for Carrier
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  -2  The error_code from the webservice
              ...   return of ${error_code} should be equal to -2
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no event data found  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no event data found
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  2  The action_code from the webservice
              ...   return of ${action_code} should be equal to 2
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Decline  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Decline
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  0  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 0

11 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, Invalid Proximity Valid, & No Event Record Valid | NO EVENT
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  5
    Delete Events in Redis for Carrier
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  -2  The error_code from the webservice
              ...   return of ${error_code} should be equal to -2
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no event data found  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no event data found
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  2  The action_code from the webservice
              ...   return of ${action_code} should be equal to 2
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Decline  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Decline
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  0  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 0

12 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, No Record Validate
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  6
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  1  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 1

13 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, No Record Validate | FAIL Proximity
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  6
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}  1  1
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  1  The action_code from the webservice
              ...   return of ${action_code} should be equal to 1
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Log Exception  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Log Exception
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  -1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to -1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  1  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 1

14 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, No Record Validate | NO RECORD
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  6
    Delete Events in Redis for Carrier
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}  1  1
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  -2  The error_code from the webservice
              ...   return of ${error_code} should be equal to -2
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no event data found  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no event data found
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  2  The action_code from the webservice
              ...   return of ${action_code} should be equal to 2
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Decline  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Decline
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  0  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 0

15 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify, No Record Validate | INVALID LOCATION
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the unit_id is in the unit_master table.
    Find carrier and Unit_ids  6
    set test variable  ${latitude}  ${EMPTY}
    set test variable  ${longitude}  ${EMPTY}
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}  1  1
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}  ${latitude}  ${longitude}  8011785
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  -4  The error_code from the webservice
              ...   return of ${error_code} should be equal to -4
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no merchant location  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no merchant location
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  0  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 0

16 Secure Fuel PreAuth API Unit ID Found w/ Position_Verify, Tank Verify Validate AvailableTankCapacity
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the tank_verify is 2 which is "Use".
    Find carrier and Unit_ids  4
    Delete Events in Redis for Carrier
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  2  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 2
    ${available_tank_capacity}  evaluate  ${result}.get("available_tank_capacity")
    should be equal as strings  ${available_tank_capacity}  ${availTankCap}  The available_tank_capacity from the webservice
              ...   return of ${available_tank_capacity} should be equal to ${availTankCap}

17 SecureFuel PreAuth Unit ID Found w/ Position_Verify, Tank Verify Validate AvailableTankCapacity Liter to Gallon
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the tank_verify is 2 which is "Use".
    Find carrier and Unit_ids  4
    Delete Events in Redis for Carrier
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}  country=CA
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  2  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 2
    ${available_tank_capacity}  evaluate  ${result}.get("available_tank_capacity")
    ${availTankCap}  evaluate  ${availTankCap}*.264172+${testVariables['tank_variance']}
    should be equal as strings  ${available_tank_capacity}  ${availTankCap}  The available_tank_capacity from the webservice
              ...   return of ${available_tank_capacity} should be equal to ${availTankCap}

18 SecureFuel PreAuth Unit ID Found w/ Position_Verify, Tank Verify Validate AvailableTankCapacity Gallon to Liter
    [Tags]  JIRA:PORT-467  qTest:50162094  Regression
    [Documentation]  This is to to check the Secure Fuel pre auth scenario if the tank_verify is 2 which is "Use".
    Find carrier and Unit_ids  7
    Delete Events in Redis for Carrier
    Create Events  ${testVariables['unit_id']}  ${testVariables['carrier_id']}  country=US
    ${preauth}  Build Preauth JSON  ${testVariables['unit_id']}
    ${statusCode}  ${result}  Send Preauth  ${preauth}  ${testVariables['carrier_id']}
    log to console  str(${result})
    should be equal as integers  ${statusCode}  200  The status code from the webservice of ${statusCode}
              ...  should equal 200
    ${error_code}  evaluate  ${result}.get("error_code")
    should be equal as strings  ${error_code}  0  The error_code from the webservice
              ...   return of ${error_code} should be equal to 0
    ${error_desc}  evaluate  ${result}.get("error_desc")
    should be equal as strings  ${error_desc}  no error  The error_desc from the webservice
              ...   return of ${error_desc} should be equal no error
    ${action_code}  evaluate  ${result}.get("action_code")
    should be equal as strings  ${action_code}  0  The action_code from the webservice
              ...   return of ${action_code} should be equal to 0
    ${action_desc}  evaluate  ${result}.get("action_desc")
    should be equal as strings  ${action_desc}  Authorize  The action_desc from the webservice
              ...   return of ${action_desc} should be equal to Authorize
    ${position_valid}  evaluate  ${result}.get("position_valid")
    should be equal as strings  ${position_valid}  1  The position_valid from the webservice
              ...   return of ${position_valid} should be equal to 1
    ${tank_handling}  evaluate  ${result}.get("tank_handling")
    should be equal as strings  ${tank_handling}  2  The tank_handling from the webservice
              ...   return of ${tank_handling} should be equal to 2
    ${available_tank_capacity}  evaluate  ${result}.get("available_tank_capacity")
    ${availTankCap}  evaluate  ${availTankCap}*3.7854+${testVariables['tank_variance']}
    should be equal as strings  ${available_tank_capacity}  ${availTankCap}  The available_tank_capacity from the webservice
              ...   return of ${available_tank_capacity} should be equal to ${availTankCap}.



*** Keywords ***
Setup
    ${connection}=  connect to redis cluster
    set suite variable  ${connection}
    ${token}  Get Token
    Set Suite Variable  ${token}

Create Redis Connection
    ${connection}=  Connect To Redis
    [Return]  ${connection}

#TODO: add number to add multiple?
Create Events
    [Arguments]  ${unit_id}  ${carrier_id}  ${latitude}=41.42377837923702  ${longitude}=-112.0515290480086  ${tank_capacity}=70  ${tank_current_level}=50  ${country}=US  #${number}=1
    ${event_1}  Create Dictionary
    ...  customer_id=${carrier_id}
    ...  country=${country}
    ...  driver_id=${driver_id}
    ...  event_time=2021-05-12T16:33:00Z
    ...  latitude=${latitude}
    ...  longitude=${longitude}
    ...  odometer=1
    ...  position_time=2021-05-12T18:01:00Z
    ...  source=S
    ...  source_event_id=1234
    ...  speed=0.0
    ...  tank_capacity=${tank_capacity}
    ...  tank_current_level=${tank_current_level}
    ...  unit_id=${unit_id}
    @{events}=  Create List  ${event_1}
    Set Suite Variable  ${events}
    ${availTankCap}  evaluate  ${tank_capacity}-${tank_current_level}
    ${availTankCap}  convert to number  ${availTankCap}
    set test variable  ${availTankCap}  ${availTankCap}
    log to console  ${events}
    log to console  ${token}
    ${code}  ${return}  Create SecureFuel Events  ${events}  ${token}

Delete Events in Redis for Carrier
    ${connection}=  connect to redis cluster
    ${test}  remove from redis  ${connection}  ${testVariables['carrier_id']}  ${testVariables['unit_id']}  ${driver_id}  0  -1


Send Preauth
    [Arguments]  ${preauthjson}  ${carrier_id}
    ${carrier_id}  convert to string  ${carrier_id}
    ${statusCode}  ${result}  PreAuth  ${preauthjson}  ${token}  ${carrier_id}
    log to console  ${statusCode}
    log to console  str(${result})
    [Return]  ${statusCode}  ${result}

Build Preauth JSON
    [Arguments]  ${unit_id}=1  ${latitude}=41.42377837923702  ${longitude}=-112.0515290480086  ${location_id}=123
    ${preauth}  catenate
          ...  {
          ...    "auth_time": "2021-05-12T18:00:00Z",
          ...    "driver_id": "${driver_id}",
          ...    "odometer_from_prompt": 10,
          ...    "rule_to_apply": 1,
          ...    "unit_id": "${unit_id}",
          ...    "location": {
          ...      "address": "string",
          ...      "city": "string",
          ...      "country": "US",
          ...      "latitude": "${latitude}",
          ...      "location_id": "${location_id}",
          ...      "longitude": "${longitude}",
          ...      "name": "string",
          ...      "state": "string"
          ...    }
          ...  }
    ${preauth}  evaluate  json.loads('''${preauth}''')  json
    [Return]  ${preauth}

Choose invalid unit_id
    get into db  TCH
    ${query}  catenate
    ...  SELECT m.member_id
    ...     FROM member m
    ...     LEFT JOIN unit_master um ON um.carrier_id = m.member_id
    ...     WHERE
    ...         m.mem_type != 'I'
    ...         AND um.carrier_id IS NULL
    ...     LIMIT 1
    ${InvalidUnitID} =  query and strip  ${query}
    ${InvalidUnitID}  convert to string  ${InvalidUnitID}
    set test variable  ${InvalidUnitID}  ${InvalidUnitID}

Find carrier and Unit_ids
    [Arguments]  ${test_type}
    [Documentation]  test_type 0 is position_verify = 0 and tank_verify = 0 and invalid_proximity_validation_type= 0
                        ...  (log) and no_event_records_validation_type=0 (log)
                     ...  test_type 1 is position_verify = 1 and tank_verify = 0 and invalid_proximity_validation_type= 0
                        ...  (log) and no_event_records_validation_type=0 (log)
                     ...  test_type 2 is position_verify = 1 and tank_verify = 1 (log) and invalid_proximity_validation_type= 0
                        ...  (log) and no_event_records_validation_type=0 (log)
                     ...  test_type 3 is position_verify = 1 and tank_verify = 1 (Log) and
                        ...  invalid_proximity_validation_type= 1 (log) and no_event_records_validation_type=0 (log)
                     ...  test_type 4 is position_verify = 1 and tank_verify = 2 (Use) and invalid_proximity_validation_type= 0
                        ...  (log) and no_event_records_validation_type=0 (log)
                     ...  test_type 5 is position_verify = 1 and tank_verify = 1 and invalid_proximity_validation_type=1 (Decline) and
                        ...  no_event_records_validation_type=1 (decline)
                     ...  test_type 6 is position_verify = 1 and tank_verify = 1 and invalid_proximity_validation_type=0
                        ...  (log) and no_event_records_validation_type=1 (decline)
                     ...  test_type 7 is position_verify = 1 and tank_verify = 2 (Use) and invalid_proximity_validation_type= 0
                        ...  (log) and no_event_records_validation_type=0 (log) from Canada

    Run Keyword If  '${test_type}'=='0'  Get Carrier and Unit id query ${test_type}
    Run Keyword If  '${test_type}'=='1'  Get Carrier and Unit id query ${test_type}
    Run Keyword If  '${test_type}'=='2'  Get Carrier and Unit id query ${test_type}
    Run Keyword If  '${test_type}'=='3'  Get Carrier and Unit id query ${test_type}
    Run Keyword If  '${test_type}'=='4'  Get Carrier and Unit id query ${test_type}
    Run Keyword If  '${test_type}'=='5'  Get Carrier and Unit id query ${test_type}
    Run Keyword If  '${test_type}'=='6'  Get Carrier and Unit id query ${test_type}
    Run Keyword If  '${test_type}'=='7'  Get Carrier and Unit id query ${test_type}

#TODO add the dict compare
Get Carrier and Unit id query 0
    [Documentation]  position_verify = 0 and tank_verify = 0 (off) and invalid_proximity_validation_type= 0 (log) and no_event_records_validation_type=0 (log)
    get into db  TCH
    ${dict_compare}  create dictionary  tank1_capacity=${99}  tank2_capacity=${99}  time_variance=${90}  tank_verify=0  position_verify=0  speed_tolerance=${0}  invalid_proximity_validation_type=${0}  no_event_records_validation_type=${0}  fueling_threshold=${0}
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 0
        ...              AND sfg.tank_verify = 0
        ...              AND sfg.invalid_proximity_validation_type = 0
        ...              AND sfg.no_event_records_validation_type = 0
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Get Carrier and Unit id query 1
    [Documentation]  position_verify = 1 and tank_verify = 0 (off) and invalid_proximity_validation_type= 0 (log) and no_event_records_validation_type=0 (log)
    get into db  TCH
    ${dict_compare}  create dictionary  tank1_capacity=${0}  tank2_capacity=${0}  time_variance=${90}  tank_verify=0  position_verify=1  speed_tolerance=${60}  invalid_proximity_validation_type=${0}  no_event_records_validation_type=${0}  fueling_threshold=${0}
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 0
        ...              AND sfg.tank_verify = 0
        ...              AND sfg.invalid_proximity_validation_type = 0
        ...              AND sfg.no_event_records_validation_type = 0
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Get Carrier and Unit_id query 2
    [Documentation]  position_verify = 1 and tank_verify = 1 (log) and invalid_proximity_validation_type= 0 (log) and no_event_records_validation_type=0 (log)
    get into db  TCH
    ${dict_compare}  create dictionary  tank1_capacity=${120}  tank2_capacity=${120}  time_variance=${90}  tank_verify=1  position_verify=1  speed_tolerance=${60}  invalid_proximity_validation_type=${0}  no_event_records_validation_type=${0}  fueling_threshold=${0}
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 1
        ...              AND sfg.tank_verify = 1
        ...              AND sfg.invalid_proximity_validation_type = 0
        ...              AND sfg.no_event_records_validation_type = 0
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Get Carrier and Unit_id query 3
    [Documentation]  position_verify = 1 and tank_verify = 1 (log) and invalid_proximity_validation_type= 1 (log) and no_event_records_validation_type=0 (log)
    ${dict_compare}  create dictionary  tank1_capacity=${101}  tank2_capacity=${101}  time_variance=${90}  tank_verify=1  position_verify=1  speed_tolerance=${70}  invalid_proximity_validation_type=${1}  no_event_records_validation_type=${0}  fueling_threshold=${0}
    get into db  TCH
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 1
        ...              AND sfg.tank_verify = 1
        ...              AND sfg.invalid_proximity_validation_type = 1
        ...              AND sfg.no_event_records_validation_type = 0
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Get Carrier and Unit_id query 4
    [Documentation]  position_verify = 1 and tank_verify = 2 (Use) and invalid_proximity_validation_type= 0 (log) and no_event_records_validation_type=0 (log)
    ${dict_compare}  create dictionary  tank1_capacity=${300}  tank2_capacity=${0}  time_variance=${90}  tank_verify=2  position_verify=1  speed_tolerance=${65}  invalid_proximity_validation_type=${0}  no_event_records_validation_type=${0}  fueling_threshold=${0}
    get into db  TCH
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 1
        ...              AND sfg.tank_verify = 2
        ...              AND sfg.invalid_proximity_validation_type = 0
        ...              AND sfg.no_event_records_validation_type = 0
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Get Carrier and Unit_id query 5
    [Documentation]  position_verify = 1 and tank_verify = 1 and invalid_proximity_validation_type=1 (decline) and no_event_records_validation_type=1 (decline)
    ${dict_compare}  create dictionary  tank1_capacity=${101}  tank2_capacity=${101}  time_variance=${90}  tank_verify=1  position_verify=1  speed_tolerance=${70}  invalid_proximity_validation_type=${1}  no_event_records_validation_type=${1}  fueling_threshold=${0}
    get into db  TCH
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 1
        ...              AND sfg.tank_verify = 1
        ...              AND sfg.invalid_proximity_validation_type = 1
        ...              AND sfg.no_event_records_validation_type = 1
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Get Carrier and Unit_id query 6
    [Documentation]  position_verify = 1 and tank_verify = 1 and invalid_proximity_validation_type=0 (Log) and no_event_records_validation_type=1 (decline)
    ${dict_compare}  create dictionary  tank1_capacity=${101}  tank2_capacity=${101}  time_variance=${90}  tank_verify=1  position_verify=1  speed_tolerance=${70}  invalid_proximity_validation_type=${0}  no_event_records_validation_type=${1}  fueling_threshold=${0}
    get into db  TCH
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 1
        ...              AND sfg.tank_verify = 1
        ...              AND sfg.invalid_proximity_validation_type = 0
        ...              AND sfg.no_event_records_validation_type = 1
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Get Carrier and Unit_id query 7
    [Documentation]  position_verify = 1 and tank_verify = 2 (Use) and invalid_proximity_validation_type= 0 (log) and no_event_records_validation_type=0 (log)
    ${dict_compare}  create dictionary  tank1_capacity=${100}  tank2_capacity=${0}  time_variance=${2000}  tank_verify=2  position_verify=1  speed_tolerance=${100}  invalid_proximity_validation_type=${0}  no_event_records_validation_type=${0}  fueling_threshold=${0}
    get into db  TCH
    ${query}  catenate
        ...  SELECT um.carrier_id, um.unit_id, um.group_id, um.tank1_capacity, um.tank2_capacity, sfg.time_variance, sfg.tank_verify,
        ...     sfg.position_verify, sfg.speed_tolerance, sfg.invalid_proximity_validation_type,
        ...     sfg.no_event_records_validation_type, sfg.fueling_threshold, sfg.tank_variance FROM unit_master um
        ...      LEFT JOIN secure_fuel_group sfg
        ...          ON um.group_id = sfg.group_id
        ...          AND um.carrier_id=sfg.carrier_id
        ...              WHERE sfg.position_verify = 1
        ...              AND sfg.tank_verify = 2
        ...              AND sfg.invalid_proximity_validation_type = 0
        ...              AND sfg.no_event_records_validation_type = 0
        ...              AND sfg.country_uom = 'C'
        ...              LIMIT 1
    &{testVariables}  query and strip to dictionary  ${query}
    ${testVariables}  Update Sql Row  ${dict_compare}  ${testVariables}  ${query}
    set test variable  ${testVariables}  ${testVariables}

Update Sql Row
    [Arguments]  ${dictionary_to_compare}  ${dictionary_from_query}  ${select_query}
    [Documentation]  creates copies of dictionaries passed, these are used in later keywords. Also decides whether
    ...  whether queried rows need updating or not based on dictionaries passed.
    ${copy_testVariables}  copy dictionary  ${dictionary_from_query}
    set test variable  ${variables_to_reset}  ${dictionary_from_query}  #variable used to recover in test teardown
    remove from dictionary  ${copy_testVariables}  carrier_id  unit_id  group_id  tank_variance
    ${status}  run keyword and return status  dictionaries should be equal  ${dictionary_to_compare}  ${copy_testVariables}
    set test variable  ${dict_comp_status}  ${status}
    ${the_dictionary}  run keyword if  '${status}'=='${False}'  Updating Sql Rows  ${dictionary_from_query}  ${dictionary_to_compare}  ${select_query}    #change from true to false
    ${return_dictionary}  run keyword if  '${status}'=='${True}'  set variable  ${dictionary_from_query}
    ...  ELSE  set variable  ${the_dictionary}
    [Return]  ${return_dictionary}

Updating Sql Rows
    [Arguments]  ${dictionary_from_query}  ${dictionary_to_compare}  ${select_query}
    [Documentation]  this executes the updates on sql rows
    ${um_update}  catenate  UPDATE unit_master SET tank1_capacity = '${dictionary_to_compare['tank1_capacity']}', tank2_capacity = '${dictionary_to_compare['tank1_capacity']}'
    ...  where carrier_id = '${dictionary_from_query['carrier_id']}' and unit_id = '${dictionary_from_query['unit_id']}'
    ${sfg_update}  catenate  UPDATE secure_fuel_group SET time_variance = '${dictionary_to_compare['time_variance']}', tank_verify = '${dictionary_to_compare['tank_verify']}',
    ...  position_verify = '${dictionary_to_compare['position_verify']}', speed_tolerance = '${dictionary_to_compare['speed_tolerance']}',
    ...  invalid_proximity_validation_type = '${dictionary_to_compare['invalid_proximity_validation_type']}', no_event_records_validation_type = '${dictionary_to_compare['no_event_records_validation_type']}',
    ...  fueling_threshold = '${dictionary_to_compare['fueling_threshold']}' where carrier_id = '${dictionary_from_query['carrier_id']}' and group_id='${dictionary_from_query['group_id']}'
    &{updated_query}  query and strip to dictionary  ${select_query}
    execute sql string  ${um_update}
    execute sql string  ${sfg_update}
    [Return]  ${updated_query}

Set Sql Rows to Default
    [Documentation]  used in test teardown to reset the changes for sql row updates. this updates the rows to original state.
    return from keyword if  '${dict_comp_status}'=='${True}'
    ${um_update}  catenate  UPDATE unit_master SET tank1_capacity = '${variables_to_reset['tank1_capacity']}', tank2_capacity = '${variables_to_reset['tank1_capacity']}'
    ...  where carrier_id = '${variables_to_reset['carrier_id']}' and unit_id = '${variables_to_reset['unit_id']}'
    ${sfg_update}  catenate  UPDATE secure_fuel_group SET time_variance = '${variables_to_reset['time_variance']}', tank_verify = '${variables_to_reset['tank_verify']}',
    ...  position_verify = '${variables_to_reset['position_verify']}', speed_tolerance = '${variables_to_reset['speed_tolerance']}',
    ...  invalid_proximity_validation_type = '${variables_to_reset['invalid_proximity_validation_type']}', no_event_records_validation_type = '${variables_to_reset['no_event_records_validation_type']}',
    ...  fueling_threshold = '${variables_to_reset['fueling_threshold']}' where carrier_id = '${variables_to_reset['carrier_id']}' and group_id='${variables_to_reset['group_id']}'
    execute sql string  ${um_update}
    execute sql string  ${sfg_update}