*** Settings ***
Library  openpyxl.utils.datetime
Library  String
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ws.PortalWS
Library  otr_model_lib.services.GenericService
Library  sqlalchemy.orm.collections
Library  otr_robot_lib.ws.SecureFuel
Resource  otr_robot_lib/robot/PortalKeywords.robot


Suite Setup  Setup
Force Tags  Portal  Secure Fuel
Documentation  This file creates and tests Secure Fuel events

*** Variables ***
${invalid_token}  eyJhbGciOiJSUzUxMiIsInBrX3VybCI6Ii92Mi9wdWJsaWMta2V5IiwicHViX2tleV91cmwiOiIvdjIvcHVibGljLWtleS9iODA3N2VkZC0zZDkxLTRmYmMtOTY4ZC03ODZiMDViMjljNDkiLCJ0eXAiOiJKV1QiLCJ2aWQiOiJiODA3N2VkZC0zZDkxLTRmYmMtOTY4ZC03ODZiMDViMjljNDkifQ.eyJyb2xlcyI6WyJkaXQ6Y3JlZGl0Y29udHJhY3RhcGk6Y3JlYXRlIl0sImF1ZCI6ImNsaWQtNjU1MmZkZDEtNGUwMy00NDZiLWEyNDEtNWNlNTUzMzhlYmQ4IiwiZXhwIjoxNjE5MjEwNTgzLCJpYXQiOjE2MTkxODE3NjMsImlzcyI6Im1pY3JvLWF1dGgtc2VydmljZTp2MS40MC4wIn0.TOXZOh-6ndZFDLBow3Lf0r22JMHQGa_QKU01SB9x4wq14mRrVsh7VZx7lf9HKHItDN2EIvHB12YPB_ri-oRwadFDyWUTLo0i9RNWSc0i9GETaGdRmE_qZCr4Kjv9kzM-jNa-i6pNRUy-z5BmpKR5qrajOZ0Iec1vhkGYlE6LcL5TJb64Y_R94-ES4jOFTUQ6WRt0cex29ZV9MaqJEDpdXkr02_S6wWvVMFvmo4hRBFWxzGvzyCzMScw0OdRnKirAHbJ86xTzutXClKb2cRKUEsh0mJn7kQySbC9BgUs8M9gduytmewX0pOwrweeMWE3qrHcwuQEW2Wp17f5CKI6sjbytw6GTcb8NAnRmi0UWxG3hfw60UYDm1LLC2_C_3uo_KclPRUrv8MAu2O1sBl89wa9he_aTtQ-kqBIml90B5uHPQf7gxUYwWRrWspd8sphxic3S8WtMADSxx8aUl8VFmsZpUV9CBp9V9Inkh3bYRVXc7-GZIT112eMoltHK_LDBVdoNZLlc7LDMa1Dxoe620STv4UMmlneu0MZ3w487BHNXCe-K9s6wYHPs-KUaZBs-dC-7dSbTQ9lRAXt1okFMZr7DA6MrRGL079MA3PxYN87HoZNkKL5DC84pet5Qh8rF5-4oasmdK7iJbPzOZTYxNcSLRwuv-RpoQuS2dABa_ZY
${token}
${carrier_id}  103627
${unit_id}  328
@{events}
${optional_keys}  ["created", "driver_id", "get_tank_capacity_from_master_id", "is_tank_current_level_percentage", "odometer", "source_event_id", "speed", "tank_capacity", "tank_current_level"]

*** Test Cases ***
Submit a Single Event to Deprecated Endpoint
    [Tags]  JIRA:PORT-460  qTest:  49849571  Regression
    [Documentation]  This is to verify we can no longer submit a single secure fuel event
    ${code}  ${return}  Create Single Event  ${events}[0]  ${token}
    ${created_event}  Convert Return To Dict  ${return}
#    log to console  ${created_event}
    Events NOT Created with invalid API Endpoint  ${code}  ${created_event}

Submit a Single Event
    [Tags]  JIRA:PORT-460  qTest: 49849570  Regression
    [Documentation]  This is to test if we can submit a single secure fuel event
    ${code}  ${return}  Create SecureFuel Events  ${event}  ${token}
    ${created_events}  Convert Return To Dict  ${return}
    Event Was Created As Expected  ${code}  ${created_events}

Submit a Batch of Events
    [Tags]  JIRA:PORT-460  qTest: 49849570  Regression
    [Documentation]  This is to test if we can submit a batch of secure fuel events
    ${code}  ${return}  Create SecureFuel Events  ${events}  ${token}
    ${created_events}  Convert Return To Dict  ${return}
    Events Were Created As Expected  ${code}  ${created_events}

Submit a Batch of Events With Invalid Values
    [Tags]  JIRA:PORT-460  qTest: 49849564  Regression
    [Documentation]  This is to test if we can submit a batch of invalid secure fuel events
    ${invalid_events}  Generate Invalid Events
    ${code}  ${return}  Create SecureFuel Events  ${invalid_events}  ${token}
    ${created_events}  Convert Return To Dict  ${return}
    Events Were Not Created  ${code}  ${created_events}


#############GET########################
Get Valid Events
    [Tags]  JIRA:PORT-461  qTest: 49849565  49849566
    [Documentation]  Tests the valid secure fuel get request with the carrier and carrier plus unit id
    Valid Events

Get Invalid Events
    [Tags]  JIRA:PORT-461  qTest: 49849706
    [Documentation]  Tests the invalid secure fuel events with invalid carrier, carrier and unit id, invalid token and invalid time
    ${code}=  Get Events  ${invalid_token}  ${carrier_id}  2017-02-26T17:52:00Z  2019-02-28T17:52:00Z  #this one should only return code since it uses invalid token
    Invalid Data

Submit a Batch of Events and Return with Pages
    [Tags]  JIRA:PORT-461  qTest: 49849565 49849566 50816671
    [Documentation]  Tests the valid secure fuel get request returns using pagination with the carrier and carrier plus unit id
    Valid Events Paginated

Check Paging Error Messages
    [Tags]  JIRA:PORT-461  qTest: 49849565 49849566 50816671
    [Documentation]  Checks the error messages thrown by the paging endpoints
    Errors with Paging

*** Keywords ***
Setup
    ${connection}=  connect to redis cluster
    set suite variable  ${connection}
    ${token}  Get Token
    Set Suite Variable  ${token}
    ${test_date}=  Get Current Date  result_format=%Y-%m-%dT%H:%M:%SZ
    set suite variable  ${test_date}
    Create Events
    Create Event

Convert Return To Dict
    [Arguments]  ${element}
    ${final_element}  Create Dictionary
    FOR    ${item}    IN    @{element.items()}
        Set To Dictionary  ${final_element}  ${item}[0]=${item}[1]
    END
    [Return]  ${final_element}

Create Event
    ${event_1}  Create Dictionary
    ...  customer_id=${carrier_id}
    ...  country=US
    ...  driver_id=driver123
    ...  event_time=${test_date}
    ...  latitude=1.0
    ...  longitude=0.08
    ...  odometer=1
    ...  position_time=2016-02-29T17:52:00Z
    ...  source=S
    ...  source_event_id=string
    ...  speed=0.0
    ...  tank_current_level=0.0
    ...  unit_id=${unit_id}
    @{event}=  Create List  ${event_1}
    Set Suite Variable  ${event}

Create Events
    [Arguments]  ${carrier_id}=103627  ${unit_id}=328
    ${event_1}  Create Dictionary
    ...  customer_id=${carrier_id}
    ...  country=US
    ...  driver_id=driver123
    ...  event_time=${test_date}
    ...  latitude=1.0
    ...  longitude=0.08
    ...  odometer=1
    ...  position_time=2016-02-29T17:52:00Z
    ...  source=S
    ...  source_event_id=string
    ...  speed=0.0
    ...  tank_current_level=0.0
    ...  unit_id=${unit_id}
    ${event_2}  Create Dictionary
    ...  customer_id=${carrier_id}
    ...  country=CA
    ...  driver_id=driver123
    ...  event_time=${test_date}
    ...  latitude=1.4
    ...  longitude=0.88
    ...  odometer=1
    ...  position_time=2016-02-29T17:52:00Z
    ...  source=S
    ...  source_event_id=string
    ...  speed=2.0
    ...  tank_current_level=0.0
    ...  unit_id=${unit_id}
    @{events}=  Create List  ${event_1}  ${event_2}
    ############THIS IS TO ENSURE THAT THE CUSTOMER ID DOESN'T CHANGE####################
#    run keyword if  '${PREV_TEST_NAME}'!='Submit a Batch of Events With Invalid Values'  set suite variable  ${pg1event}  ${event_1}
#    run keyword if  '${PREV_TEST_NAME}'!='Submit a Batch of Events With Invalid Values'  set suite variable  ${pg2event}  ${event_2}
    set suite variable  ${pg1event}  ${event_1}
    set suite variable  ${pg2event}  ${event_2}
    Set Suite Variable  ${events}
#    log to console  ${events}

Created Date Is Correct
    [Arguments]  ${event_date}
    ${current_date}    Get Current Date    result_format=%Y-%m-%d
    ${expected_date}  Convert Date  ${event_date}  result_format=%Y-%m-%d
    Should Be Equal As Strings  ${current_date}  ${expected_date}

Event Must Have Been Created
    [Arguments]  ${code}  ${data}
    Should Be Equal As Integers  ${code}  201
    Should Be Equal As Events  ${events}[0]  ${data}

Event Must Not Have Been Created
    [Arguments]  ${code}  ${data}
    Should Be Equal As Integers  ${code}  400
    Should Be Equal As Strings  ${data.country}  Invalid country code
    Should Be Equal As Strings  ${data.eventTime}  Invalid Event Time Date Format
    Should Be Equal As Strings  ${data.tankCurrentLevel}  Tank current level must be greater than or equal to 0
    Should Be Equal As Strings  ${data.positionTime}  Invalid Position Time Date Format
    Should Be Equal As Strings  ${data.source}  Invalid source code

Events Were Created As Expected
    [Arguments]  ${code}  ${created_events}
    Should Be Equal As Integers  ${code}  202
    Should Be Equal As Integers  ${created_events.acceptedRecordCount}  2
    Should Be Empty  ${created_events.failedRecords}

Event Was Created As Expected
    [Arguments]  ${code}  ${created_events}
    Should Be Equal As Integers  ${code}  202
    Should Be Equal As Integers  ${created_events.acceptedRecordCount}  1
    Should Be Empty  ${created_events.failedRecords}

Events Were Not Created
    [Arguments]  ${code}  ${created_events}
    Should Be Equal As Integers  ${code}  202
    Should Be Equal As Integers  ${created_events.acceptedRecordCount}  1
    Should Not Be Empty  ${created_events.failedRecords}

Events NOT Created with invalid API Endpoint
    [Arguments]  ${code}  ${data}
    Should Be Equal As Integers  ${code}  404

Generate Invalid Event
    [Arguments]  ${event}
    ${invalid_event}  copy dictionary  ${event}  deepcopy=True
    ${invalid_event.country}  Set Variable  BR
    ${invalid_event.tank_current_level}  Set Variable  -1
    ${invalid_event.source}  Set Variable  K
    ${invalid_event.position_time}  Set Variable  2016-02-29T17:52:00
    ${invalid_event.event_time}  Set Variable  2017-02-28T17:52:00
    [Return]  ${invalid_event}

Generate Invalid Events
    ${invalid_event}  Generate Invalid Event  ${events}[1]
    @{invalid_events}=  Create List  ${events}[0]  ${invalid_event}
    [Return]  ${invalid_events}

Get Tank Capacity Value
    Get Into Db  TCH
    ${query}  Catenate  SELECT tank1_capacity, tank2_capacity FROM unit_master WHERE carrier_id = ${carrier_id} AND unit_id = ${unit_id}
    ${db_value}  Query and Strip to Dictionary  ${query}
    ${sum}  Evaluate  ${db_value.tank1_capacity}+${db_value.tank2_capacity}
    [Return]  ${sum}


Should Be Equal As Events
    [Arguments]  ${passed_event}  ${created_event}
    Created Date Is Correct  ${created_event.created}
    ${tank_capacity}  Get Tank Capacity Value
    Should Be Equal As Strings  ${passed_event.customer_id}  ${created_event.customer_id}
    Should Be Equal As Strings  ${passed_event.country}  ${created_event.country}
    Should Be Equal As Strings  ${passed_event.driver_id}  ${created_event.driver_id}
    Should Be Equal As Strings  ${passed_event.event_time}  ${created_event.event_time}
    Should Be Equal As Strings  ${passed_event.latitude}  ${created_event.latitude}
    Should Be Equal As Strings  ${passed_event.longitude}  ${created_event.longitude}
    Should Be Equal As Integers  ${passed_event.odometer}  ${created_event.odometer}
    Should Be Equal As Strings  ${passed_event.position_time}  ${created_event.position_time}
    Should Be Equal As Strings  ${passed_event.source}  ${created_event.source}
    Should Be Equal As Strings  ${passed_event.source_event_id}  ${created_event.source_event_id}
    Should Be Equal As Numbers  ${passed_event.speed}  ${created_event.speed}
    Should Be Equal As Integers  ${tank_capacity}  ${created_event.tank_capacity}
    Should Be Equal As Numbers  ${passed_event.tank_current_level}  ${created_event.tank_current_level}
    Should Be Equal As Strings  ${passed_event.unit_id}  ${created_event.unit_id}

Unauthorized Code Is Returned From Request
    [Arguments]  ${code}
    Should Be Equal As Integers  ${code}  401

###################GET KEYWORDS#########################
Check Get
    [Documentation]  checks the valid and invalid secure fuel events and response codes
    [Arguments]  ${event}  ${code}
    ${invalid}=  evaluate  'Invalid' in '''${TEST NAME}'''
    run keyword if  '${invalid}'=='${False}'  Check Get Valid  ${event}
    ...  ELSE  Check Get Invalid  ${event}
    Check Code  ${code}

Modify Date
    [Documentation]  used to modify the time.
    [Arguments]  ${optional}=1 day
    ${end_time}  Add Time To Date  ${test_date}  ${optional}  result_format=%Y-%m-%dT%H:%M:%SZ
    ${start_time}  Subtract Time from Date  ${test_date}  ${optional}  result_format=%Y-%m-%dT%H:%M:%SZ
    [Return]  ${start_time}  ${end_time}


Check Get Valid
    [Documentation]  checks the valid GET secure fuel events
    [Arguments]  ${event}
    ${event}  set variable  ${event["sfEventsRecords"]}
    FOR  ${i}  IN RANGE  len(${event})
        ${exists}=  Check Key Exists  ${event[${i}]}
        run keyword if  '${exists}'=='${True}'  Check Redis Values and Get Return  ${event[${i}]}
    END

Check Get Invalid
    [Documentation]  Checks the invalid GET secure fuel events
    [Arguments]  ${event}
    ${status}=  run keyword and return status  dictionary should contain key  ${event}  sfEventsRecords
    run keyword and return if  '${status}'=='${False}'  check possible invalid returns  ${event}
    ${event_value}  set variable  ${event["sfEventsRecords"]}
    run keyword if  "${event_value}"=='@{EMPTY}'  Check Possible Invalid Returns  ${event}  ${event_value}

Check Possible Invalid Returns
    [Documentation]  Used to check the possible returns when invalid data is passed
    [Arguments]  ${event}  ${event_values}=${NONE}
    run keyword if  "${event_values}"!='${NONE}'  Invalid With Values  ${event}  ${event_values}
    ...  ELSE  Invalid No Values  ${event}

Invalid With Values
    [Arguments]  ${event}  ${event_values}
    ${records}=  set variable  ${event["totalRecordCount"]}
    should be equal as integers  0  ${records}
    should be equal as strings  ${event_values}  []

Invalid No Values
    [Arguments]  ${event}
    ${event}=  Convert to String  ${event}
    ${start_time_status}=  run keyword and return status  should be equal  {'getSecureFuelEventsByCarrierUnit.startTime': 'Invalid Date Format'}  ${event}
    ${end_time_status}=  run keyword and return status  run key word if  '${start_time_status}'!='${True}'  should be equal  {'getSecureFuelEventsByCarrierUnit.endTime': 'Invalid Date Format'}  ${event}
    run keyword if  '${start_time_status}'!='${True}' and '${end_time_status}'!='${True}'  should be equal  {'getSecureFuelEventsByCarrierUnit.endTime': 'Invalid Date Format', 'getSecureFuelEventsByCarrierUnit.startTime': 'Invalid Date Format'}  ${event}

Check Key Exists
    [Documentation]  checks if the key exists in the Redis database
    [Arguments]  ${dictionary}
    ${id}=  Get From Dictionary  ${dictionary}  id
    ${status}=  run keyword and return status  redis hash key should be exist  ${connection}  SecureFuelEvents  "SecureFuelEvent:${id}"
    [Return]  ${status}

Check Redis Values and Get Return
    [Documentation]  Compares the value in Redis with what was returned in the Get
    [Arguments]  ${dictionary}
    ${id}=  Get From Dictionary  ${dictionary}  id
    ${redis_data}=  get from redis hash  ${connection}  SecureFuelEvents  "SecureFuelEvent:${id}"
    ${redis_data}=  convert to string  ${redis_data}
    #removes outer part of the redis data
    ${redis_data}=  get regexp matches  ${redis_data}  {(.*?)}
    #removes the java.math.bigDecimal (did in two steps because regex was weird)
    ${redis_data}=  remove string using regexp  ${redis_data}[0]  (\\["java.math.BigDecimal"\\,(?=.))
    ${redis_data}=  remove string using regexp  ${redis_data}  (?<=.)\\]
    #########
    ${redis_dictionary}=  evaluate  json.loads('''${redis_data}''')  json
    #removed unnecessary portion of json returned on get
    remove from dictionary  ${redis_dictionary}  @class
    dictionaries should be equal  ${redis_dictionary}  ${dictionary}

Check Code
    [Documentation]  checks the response codes
    [Arguments]  ${code}
    ${code}=  convert to string  ${code}
    ${valid}=  evaluate  'Valid' in """${TEST NAME}"""
    ${invalid}=  evaluate  'Invalid' in """${TEST NAME}"""
    run keyword if  '${valid}'=='${True}'  should be equal  ${code}  200
    ...  ELSE IF  '${invalid}'=='${True}'  Invalid Response Code  ${code}  #should be equal  ${code} 400
    ...  ELSE  log to console  edge case

Invalid Response Code
    [Documentation]  used for invalid response code cases
    [Arguments]  ${code}
    ${400_status}=  run keyword and return status  should be equal  ${code}  400
    ${401_status}=  run keyword and return status  run keyword if  '${400_status}'!='${True}'  should be equal  ${code}  401
    ${404_status}=  run keyword and return status  run keyword if  '${400_status}'!='${True}' and '${401_status}'!='${True}'  ${code}  404
    run keyword if  '${400_status}'!='${True}' and '${401_status}'!='${True}' and '${404_status}'!='${True}'  should be equal  ${code}  200

Invalid Data
    [Documentation]  used for invalid GET secure fuel events
    ${code}  ${event}=  Get Events  ${token}  -4  2017-02-26T17:52:00Z  2019-02-28T17:52:00Z  328           #expect invalid carrier
    Check Get  ${event}  ${code}
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  2017-02-26T17:52:00  2019-02-28T17:52:00Z  3   #expect invalid unit id and time
    Check Get  ${event}  ${code}
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  2000-02-26T17:52:00Z  2012-02-28T17:52:00Z  #expect empty array
    Check Get  ${event}  ${code}

Valid Events
    [Documentation]  Used for the valid GET secure fuel events
    ${carrier_id}  set variable  163597
    ${unit_id}  set variable  1
    ${start_date}  ${end_date}=  Modify Date
    create events  ${carrier_id}  ${unit_id}
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}
    Check Get  ${event}  ${code}
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  1
    Check Get  ${event}  ${code}

Valid Events Paginated
    [Documentation]  Used for the valid GET secure fuel events

    ${page_size}  set variable  5
    ${page_num}  set variable  1
    ${start_date}  ${end_date}=  Modify Date
#    ${start}  set variable  2017-02-26T17:52:00Z
#    ${end}  set variable  2019-02-28T17:52:00Z
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  pg_num=${page_num}  pg_size=${page_size}
    Check Event to Paginated Returned Get  ${event}  ${code}  ${pg1event}  ${page_num}  ${page_size}  ${start_date}  ${end_date}

    ${page_size}  set variable  1
    ${page_num}  set variable  5
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  pg_num=${page_num}  pg_size=${page_size}
    Check Event to Paginated Returned Get  ${event}  ${code}  ${pg2event}  ${page_num}  ${page_size}  ${start_date}  ${end_date}

    ${page_size}  set variable  1
    ${page_num}  set variable  10
    ${unit}  set variable  328

    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  ${unit}  pg_num=${page_num}  pg_size=${page_size}
    Check Event to Paginated Returned Get  ${event}  ${code}  ${pg1event}  ${page_num}  ${page_size}  ${start_date}  ${end_date}  ${unit}

    ${page_size}  set variable  1
    ${page_num}  set variable  5

    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  ${unit}  pg_num=${page_num}  pg_size=${page_size}
    Check Event to Paginated Returned Get  ${event}  ${code}  ${pg2event}  ${page_num}  ${page_size}  ${start_date}  ${end_date}  ${unit}

Check Event to Paginated Returned Get
    [Documentation]  Used to check the paginated event.
    [Arguments]  ${APIEvent}  ${code}  ${CreatedEvent}  ${page_num}  ${page_size}  ${start}  ${end}  ${unit}=${None}
    ${events}=  set variable  ${APIEvent["sfEventsRecords"]}
    ${record_count}=  set variable  ${APIEvent["totalRecordCount"]}
    #making copy of event so we can compare it to received list
    ${copy_event}  copy list  ${events}  deepcopy=True
    ${test}=  Order List  ${copy_event}
    lists should be equal  ${test}  ${events}
    should be equal as integers  ${code}  200   The paginated API's return code from the webservice
              ...   returned ${code} should be equal to 200
    run keyword if  len(${events})!=${page_size}  Check Page Number and Size  ${events}  ${record_count}  ${page_num}  ${page_size}  #Fail  msg=page size should be larger
    FOR  ${i}  IN RANGE  len(${events})
        ${loop_dict}  set variable  ${events[${i}]}
        dictionary should contain value  ${loop_dict}  ${carrier_id}
        ${e_time}  get from dictionary  ${loop_dict}  event_time
        Check Dates  ${e_time}  ${start}  ${end}
        run keyword if  ${unit}!=${None}  dictionary should contain value  ${loop_dict}  ${unit}

    END


Order List
    [Documentation]  Used to order list based on event time and return the list.
    [Arguments]  ${events}
    ${ordered_list}=  evaluate  sorted(${events}, key = lambda item: datetime.datetime.strptime(item['event_time'], '%Y-%m-%dT%H:%M:%SZ'))  modules=datetime  #add reverse to make desc
    [Return]  ${ordered_list}

Check Page Number and Size
    [Documentation]  Used to check the page number to determine events per page. The max number varies based on the page size.
    [Arguments]  ${events}  ${record_count}  ${page_num}  ${page_size}
    ${possible_pages}  evaluate  ${record_count} / ${page_size}
    ${possible_pages}  run keyword if  ${possible_pages} > 0.0 and ${possible_pages} < 1.0  set variable  1.0
    ...  ELSE  set variable  ${possible_pages}
    ${partial_pages}  evaluate  ${possible_pages} % 1
    ${full_pages}  evaluate  ${possible_pages} - ${partial_pages}
    ${status}=  run keyword and return status  should be true  ${page_num}<=${full_pages}
    run keyword if  '${status}'=='${True}'  should not be empty  ${events}  msg=expected some items in event  #should be true  len(${events})>0
    ...  ELSE  should be empty  ${events}  msg=expected events to be empty

Check Dates
    [Documentation]  Used to check the dates in the response.
    [Arguments]  ${e_time}  ${start}  ${end}
    ${e_date}  Convert Date  ${e_time}  result_format=%Y-%m-%dT%H:%M:%SZ
    ${start_time}  Convert Date  ${start}  result_format=%Y-%m-%dT%H:%M:%SZ
    ${start_time}  subtract date from date  ${start_time}  ${e_date}
    ${end_time}  Convert Date  ${end}  result_format=%Y-%m-%dT%H:%M:%SZ
    ${end_time}  subtract date from date  ${end_time}  ${e_date}
    run keyword if  $start_time>0 or $end_time<0  Fail  msg=some dates don't fall in the range ${start} and ${end}

Errors with Paging
    [Documentation]  Used for get with pagination errors. Modify the paging options to check errors that occur.

    #check the error with page num 0
    ${page_size}  set variable  1
    ${page_num}  set variable  0
    ${start_date}  ${end_date}=  Modify Date
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  pg_num=${page_num}  pg_size=${page_size}
    Pagination Options and Errors  ${code}  ${event}  ${page_size}  ${page_size}

    #check error with page size 0
    ${page_size}  set variable  0
    ${page_num}  set variable  1
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  pg_num=${page_num}  pg_size=${page_size}
    Pagination Options and Errors  ${code}  ${event}  ${page_size}  ${page_size}

    #check string in page size
    ${page_size}  set variable  a
    ${page_num}  set variable  2
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  pg_num=${page_num}  pg_size=${page_size}
    Pagination Options and Errors  ${code}  ${event}  ${page_size}  ${page_size}

    #check string in page num
    ${page_size}  set variable  2
    ${page_num}  set variable  a
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  pg_num=${page_num}  pg_size=${page_size}
    Pagination Options and Errors  ${code}  ${event}  ${page_size}  ${page_size}

    #check string in both page num and page size
    ${page_size}  set variable  b
    ${page_num}  set variable  a
    ${code}  ${event}=  Get Events  ${token}  ${carrier_id}  ${start_date}  ${end_date}  pg_num=${page_num}  pg_size=${page_size}
    Pagination Options and Errors  ${code}  ${event}  ${page_size}  ${page_size}



Pagination Options and Errors
    [Documentation]  Used with the error handling and handling or pagination options
    [Arguments]  ${code}  ${event}  ${page_size}  ${page_num}
    ${size_type}  run keyword if  ${code}!=400  evaluate  type(${page_size}).__name__
    ${num_type}  run keyword if  ${code}!=400  evaluate  type(${page_num}).__name__
    run keyword if  """${page_size}"""<="""0"""  dictionary should contain value  ${event}  PageSize must be greater than or equal to 1
    ...  ELSE IF  """${page_num}"""<="""0"""  dictionary should contain value  ${event}  PageNumber must be greater than or equal to 1
    ...  ELSE IF  """${size_type}"""=="""string""" or """${page_num}"""=="""string"""  should not be empty  ${event}
    ...  ELSE IF  """${size_type}"""=="""string""" or """${page_num}"""=="""int"""  should not be empty  ${event}
    ...  ELSE IF  """${size_type}"""=="""int""" or """${page_num}"""=="""string"""  should not be empty  ${event}
    ...  ELSE  should not be empty  ${event}


