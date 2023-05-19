*** Settings ***
Documentation
...  These is a comprehensive test for CIPCheckService API wich tests both valid and invalid scenarios and ensures the main data validations are working

Library  String
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ws.PortalWS
Library  otr_model_lib.services.GenericService
Library  Collections

Suite Setup  Start Suite
Force Tags  Portal  Web Services

*** Variables ***

${carrier}  102574
${profileId}  100000
${type}  2528299
${personCip_context}  primary

*** Test Cases ***

Send a Valid Request to CIP Check Service
    [Tags]  JIRA:PORT-19  qTest:37689373
    [Documentation]  Validate that you can do a request for CIP Check Service
    ${transactionStatus}  Set Variable  'TransactionStatus': 'passed'
    ${productStatus}  Set Variable  'ProductStatus': 'pass'

    Build Request Body
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${transactionStatus}
    Assert Error Message  ${response}  ${productStatus}

Check INVALID on Phone Number
    [Tags]  JIRA:PORT-19  qTest:37747225
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an INVALID data on Phone Number
    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationDetail}  Set Variable  Number should not be null or empty and should be numeric

    Build Request Body
    Set To Dictionary  ${personCip_phones}  Number=abcdef
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check INVALID on CarrierId
    [Tags]  JIRA:PORT-19  qTest:37751117
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an INVALID data on CarrierId

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationDetail}  Set Variable  Please check the carrierId

    Build Request Body
    Set Test Variable  ${carrier}  102574aaa
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check INVALID on ProfileId
    [Tags]  JIRA:PORT-19  qTest:37751659
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an INVALID data on ProfileId

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationDetail}  Set Variable  Please check the profileId

    Build Request Body
    Set Test Variable  ${profileId}  123456aaa
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check INVALID on Zip5
    [Tags]  JIRA:PORT-19  qTest:37751777
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an INVALID data on Zip5

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationDetail}  Set Variable  Please check the Zip5 should be numeric

    Build Request Body
    Set To Dictionary  ${personCip_addresses}  Zip5=abcdef
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check INVALID on Country
    [Tags]  JIRA:PORT-19  qTest:37751894
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an INVALID data on Country

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  Country
    ${failedValidationDetail}  Set Variable  Please check the Country should be alphabetic

    Build Request Body
    Set To Dictionary  ${personCip_addresses}  Country=11111
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check INVALID on SSN Type
    [Tags]  JIRA:PORT-19  qTest:37751904
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an INVALID data on SSN Type

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${errorDetail}  Set Variable  Please check the Type of SSN the type should be ssn4

    Build Request Body
    Set To Dictionary  ${personCip_ssn}  Type=11111
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${errorDetail}

Check INVALID on DateOfBirth Month
    [Tags]  JIRA:PORT-19  qTest:37752172
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an INVALID data on DateOfBirth Month

    ${statusMessage}  Set Variable  SYNTACTICALLY INCORRECT DATA

    Build Request Body
    Set To Dictionary  ${personCip_dateOfBirth}  Month=15
    ${response}  Send Post Request to Webservice Expecting Error

    Assert Error Message  ${response}  ${statusMessage}

Check EMPTY on CarrierId
    [Tags]  JIRA:PORT-19  qTest:37752231
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on CarrierId

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationDetail}  Set Variable  Please check the carrierId

    Build Request Body
    Set Test Variable  ${carrier}  ${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on ProfileId
    [Tags]  JIRA:PORT-19  qTest:37752835
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on ProfileId

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationDetail}  Set Variable  Please check the profileId

    Build Request Body
    Set Test Variable  ${profileId}  ${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on FirstName
    [Tags]  JIRA:PORT-19  qTest:37752838
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on FirstName

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  FirstName
    ${failedValidationDetail}  Set Variable  Please check the FirstName

    Build Request Body
    Set To Dictionary  ${personCip_name}  FirstName=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on LastName
    [Tags]  JIRA:PORT-19  qTest:37752843
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on LastName

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  LastName
    ${failedValidationDetail}  Set Variable  Please check the LastName

    Build Request Body
    Set To Dictionary  ${personCip_name}  LastName=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on SSN Number
    [Tags]  JIRA:PORT-19  qTest:37752846
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on SSN Number

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  SSN Number
    ${failedValidationDetail}  Set Variable  Please check the length of SSN Number should be 4 digits in length

    Build Request Body
    Set To Dictionary  ${personCip_ssn}  Number=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on SSN Type
    [Tags]  JIRA:PORT-19  qTest:37752856
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on SSN Type

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  SSN Type
    ${failedValidationDetail}  Set Variable  Please check the Type of SSN the type should be ssn4

    Build Request Body
    Set To Dictionary  ${personCip_ssn}  Type=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on DateOfBirth Year
    [Tags]  JIRA:PORT-19  qTest:37752859
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on DateOfBirth Year

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  DateOfBirth
    ${failedValidationDetail}  Set Variable  Please check the Year , Month , Day of the DateOfBirth

    Build Request Body
    Set To Dictionary  ${personCip_dateOfBirth}  Year=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on DateOfBirth Month
    [Tags]  JIRA:PORT-19  qTest:37752869
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on DateOfBirth Month

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  DateOfBirth
    ${failedValidationDetail}  Set Variable  Please check the Year , Month , Day of the DateOfBirth

    Build Request Body
    Set To Dictionary  ${personCip_dateOfBirth}  Month=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on DateOfBirth Day
    [Tags]  JIRA:PORT-19  qTest:37752873
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on DateOfBirth Day

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  DateOfBirth
    ${failedValidationDetail}  Set Variable  Please check the Year , Month , Day of the DateOfBirth

    Build Request Body
    Set To Dictionary  ${personCip_dateOfBirth}  Day=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on Phone Number
    [Tags]  JIRA:PORT-19  qTest:37752874
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on Phone Number

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  Number
    ${failedValidationDetail}  Set Variable  Number should not be null or empty and should be numeric

    Build Request Body
    Set To Dictionary  ${personCip_phones}  Number=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}

Check EMPTY on Phone Context
    [Tags]  JIRA:PORT-19  qTest:37752876
    [Documentation]  Validate that you cannot do a request for CIP Check Service with an EMPTY value on Phone Context

    ${statusMessage}  Set Variable  VALIDATION FAILED
    ${failedValidationValue}  Set Variable  Context(Phone)
    ${failedValidationDetail}  Set Variable  Context should not be null or empty, should be of the following Types

    Build Request Body
    Set To Dictionary  ${personCip_phones}  Context=${EMPTY}
    ${response}  Send Post Request to Webservice

    Assert Error Message  ${response}  ${statusMessage}
    Assert Error Message  ${response}  ${failedValidationValue}
    Assert Error Message  ${response}  ${failedValidationDetail}


*** Keywords ***
Start Suite
    log into credit monitoring service  emanager  password

Build Request Body

    ${personCip_name}  Create Dictionary
    ...  FirstName=John
    ...  LastName=Doe

    ${personCip_addresses}  Create Dictionary
    ...  StreetAddress1=1104 Country Hills Drive Suite #600
    ...  City=Ogden
    ...  State=UT
    ...  Zip5=84403
    ...  Country=US
    ...  Context=primary

    ${personCip_ssn}  Create Dictionary
    ...  Number=4567
    ...  Type=ssn4

    ${personCip_dateOfBirth}  Create Dictionary
    ...  Year=1976
    ...  Month=10
    ...  Day=6

    ${personCip_phones}  Create Dictionary
    ...  Number=9494949494
    ...  Context=mobile

    Set Test Variable  ${personCip_name}
    Set Test Variable  ${personCip_addresses}
    Set Test Variable  ${personCip_ssn}
    Set Test Variable  ${personCip_dateOfBirth}
    Set Test Variable  ${personCip_phones}

Send Post Request to Webservice

    ${response}  cip check service  ${carrier}  ${profileId}  ${type}  ${personCip_name}  ${personCip_addresses}  ${personCip_ssn}  ${personCip_dateOfBirth}  ${personCip_phones}  ${personCip_context}

    [Return]  ${response}

Send Post Request to Webservice Expecting Error

    ${response}  run keyword and expect error  *  cip check service  ${carrier}  ${profileId}  ${type}  ${personCip_name}  ${personCip_addresses}  ${personCip_ssn}  ${personCip_dateOfBirth}  ${personCip_phones}  ${personCip_context}

    [Return]  ${response}

Assert Error Message
    [Arguments]  ${response}  ${errorMessage}
    ${response}  Convert To String  ${response}
    Should Contain  ${response}  ${errorMessage}