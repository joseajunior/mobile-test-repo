*** Settings ***
Library  String
Resource  otr_robot_lib/robot/RobotKeywords.robot
Library  otr_robot_lib.ws.CarrierGroupWS
Library  otr_model_lib.services.GenericService
Library  Collections

Force Tags  Web Services
Suite Setup  Setup WS
Suite Teardown  Tear Me Down

*** Variables ***

${numberOfCards}  4
${legalName}  John Due
${mailingAddress}  Nice Lake
${mailingCity}  ogden
${mailingCountry}  US
${mailingState}  UT
${mailingZip}  84405
${physicalAddress}  Flower street, 1010
${physicalCity}  ogden
${physicalCountry}  US
${physicalState}  UT
${physicalZip}  84405
${contactName}  John Due
${contactPhone}  999-999-9999
${email}  WEXEFS-El-Robot@wexinc.com
${language}  E

*** Test Cases ***
Create a Child Carrier
    [Tags]  JIRA:BOT-1904  qTest:32421942  refactor
    [Documentation]  Validate that you can create a Child Carrier

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Be True  ${status}

Create a Child Carrier and validate legalName
    [Tags]  JIRA:BOT-1904  qTest:32439691  refactor
    [Documentation]  Create a Child Carrier and validate legalName in database

    ${carrierId}  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    ${database_return}  Check updated data  name  ${carrierId}  ${legalName}

    Should be equal   ${database_return}  ${legalName}  ignore_case=${True}
Create a Child Carrier and validate mailingAddress
    [Tags]  JIRA:BOT-1904  qTest:32440227  refactor
    [Documentation]  Create a Child Carrier and validate mailingAddress in database

    ${carrierId}  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    ${database_return}  Check updated data  add1  ${carrierId}  ${mailingAddress}

    Should be equal   ${database_return}  ${mailingAddress}  ignore_case=${True}
Create a Child Carrier and validate mailingCity
    [Tags]  JIRA:BOT-1904  qTest:32440228  refactor
    [Documentation]  Create a Child Carrier and validate mailingCity in database

    ${carrierId}  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    ${database_return}  Check updated data  city  ${carrierId}  ${mailingCity}

    Should be equal   ${database_return}  ${mailingCity}  ignore_case=${True}
Create a Child Carrier and validate mailingState
    [Tags]  JIRA:BOT-1904  qTest:32440229  refactor
    [Documentation]  Create a Child Carrier and validate mailingState in database

    ${carrierId}  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    ${database_return}  Check updated data  state  ${carrierId}  ${mailingState}

    Should be equal   ${database_return}  ${mailingState}  ignore_case=${True}
Create a Child Carrier and validate mailingZip
    [Tags]  JIRA:BOT-1904  qTest:32440230  refactor
    [Documentation]  Create a Child Carrier and validate mailingZip in database

    ${carrierId}  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    ${database_return}  Check updated data  zip  ${carrierId}  ${mailingZip}

    Should be equal   ${database_return}  ${mailingZip}  ignore_case=${True}
Create a Child Carrier and validate firstName
    [Tags]  JIRA:BOT-1904  qTest:32440234  refactor
    [Documentation]  Create a Child Carrier and validate firstName in database

    ${firstName}  set variable  John

    ${carrierId}  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    ${database_return}  Check updated data  cont_fname  ${carrierId}  ${firstName}

    Should be equal   ${database_return}  ${firstName}  ignore_case=${True}
Create a Child Carrier and validate LastName
    [Tags]  JIRA:BOT-1904  qTest:32440235  refactor
    [Documentation]  Create a Child Carrier and validate firstName in database

    ${LastName}  set variable  Due

    ${carrierId}  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    ${database_return}  Check updated data  cont_lname  ${carrierId}  ${LastName}

    Should be equal   ${database_return}  ${LastName}  ignore_case=${True}

Check INVALID on the numberOfCards
    [Tags]  JIRA:BOT-1904  qTest:32423134
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on numberOfCards

    ${numberOfCards}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the legalName
    [Tags]  JIRA:BOT-1904  qTest:32423115  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on legalName

    ${legalName}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the mailingCity
    [Tags]  JIRA:BOT-1904  qTest:32423121  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on mailingCity

    ${mailingCity}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the mailingCountry
    [Tags]  JIRA:BOT-1904  qTest:32423122  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on mailingCountry

    ${mailingCountry}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the mailingState
    [Tags]  JIRA:BOT-1904  qTest:32423123  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on mailingState

    ${mailingState}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the mailingZip
    [Tags]  JIRA:BOT-1904  qTest:32423125  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on mailingZip

    ${mailingZip}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the physicalCity
    [Tags]  JIRA:BOT-1904  qTest:32423128  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on physicalCity

    ${physicalCity}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the contactName
    [Tags]  JIRA:BOT-1904  qTest:32423129  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on contactName

    ${contactName}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the contactPhone
    [Tags]  JIRA:BOT-1904  qTest:32423130  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on contactPhone

    ${contactPhone}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the email
    [Tags]  JIRA:BOT-1904  qTest:32423131  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on email

    ${email}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check INVALID on the language
    [Tags]  JIRA:BOT-1904  qTest:32423133  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a INVALID data on language

    ${language}  set variable  !nv@l1d

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}

Validate EMPTY value on numberOfCards
    [Tags]  JIRA:BOT-1904  qTest:32423159  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY numberOfCards

    ${numberOfCards}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on legalName
    [Tags]  JIRA:BOT-1904  qTest:32423160  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY legalName

    ${legalName}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on mailingAddress
    [Tags]  JIRA:BOT-1904  qTest:32423170  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY mailingAddress

    ${mailingAddress}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on mailingCity
    [Tags]  JIRA:BOT-1904  qTest:32423171  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY mailingCity

    ${mailingCity}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on mailingCountry
    [Tags]  JIRA:BOT-1904  qTest:32423173  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY mailingCountry

    ${mailingCountry}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on mailingState
    [Tags]  JIRA:BOT-1904  qTest:32423176  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY mailingState

    ${mailingState}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on mailingZip
    [Tags]  JIRA:BOT-1904  qTest:32423177  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY mailingZip

    ${mailingZip}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on physicalAddress
    [Tags]  JIRA:BOT-1904  qTest:32423179  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY physicalAddress

    ${physicalAddress}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on physicalCity
    [Tags]  JIRA:BOT-1904  qTest:32423180  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY physicalCity

    ${physicalCity}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on physicalCountry
    [Tags]  JIRA:BOT-1904  qTest:32423182  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY physicalCountry

    ${physicalCountry}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on physicalState
    [Tags]  JIRA:BOT-1904  qTest:32423183  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY physicalState

    ${physicalState}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on physicalZip
    [Tags]  JIRA:BOT-1904  qTest:32423185  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY physicalZip

    ${physicalZip}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on contactName
    [Tags]  JIRA:BOT-1904  qTest:32423186  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY contactName

    ${contactName}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on contactPhone
    [Tags]  JIRA:BOT-1904  qTest:32423189  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY contactPhone

    ${contactPhone}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on email
    [Tags]  JIRA:BOT-1904  qTest:32423193  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY email

    ${email}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Validate EMPTY value on language
    [Tags]  JIRA:BOT-1904  qTest:32423194  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with an EMPTY language

    ${language}  set variable  ${EMPTY}

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}

Check TYPO on the numberOfCards
    [Tags]  JIRA:BOT-1904  qTest:32423194
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on numberOfCards

    ${numberOfCards}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the mailingCountry
    [Tags]  JIRA:BOT-1904  qTest:32423199  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on mailingCountry

    ${mailingCountry}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the mailingState
    [Tags]  JIRA:BOT-1904  qTest:32423200  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on mailingState

    ${mailingState}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the mailingZip
    [Tags]  JIRA:BOT-1904  qTest:32423205  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on mailingZip

    ${mailingZip}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the physicalCountry
    [Tags]  JIRA:BOT-1904  qTest:32423207  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on physicalCountry

    ${physicalCountry}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the physicalState
    [Tags]  JIRA:BOT-1904  qTest:32423233  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on physicalState

    ${physicalState}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the physicalZip
    [Tags]  JIRA:BOT-1904  qTest:32423234  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on physicalZip

    ${physicalZip}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the contactPhone
    [Tags]  JIRA:BOT-1904  qTest:32423238  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on contactPhone

    ${contactPhone}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}
Check TYPO on the language
    [Tags]  JIRA:BOT-1904  qTest:32423239  BUGGED: It was not supposed to accept special characters or invalid data
    [Documentation]  Validate that you cannot create a Child Carrier with a typo on language

    ${language}  set variable  2FF

    ${status}  Run Keyword And Return Status  createChildCarrier  ${numberOfCards}  ${legalName}  ${mailingAddress}  ${mailingCity}  ${mailingCountry}  ${mailingState}  ${mailingZip}  ${physicalAddress}  ${physicalCity}  ${physicalCountry}  ${physicalState}  ${physicalZip}  ${contactName}  ${contactPhone}  ${email}  ${language}

    Should Not Be True  ${status}


*** Keywords ***
Check updated data
    [Arguments]  ${column}  ${memberId}  ${data}
    Get Into DB  tch

    ${query}  Catenate
    ...  select TRIM(TO_CHAR(${column})) from member where member_id='${memberId}' AND ${column}=upper('${data}');
    ${result}  Query and Strip  ${query}

    [Return]  ${result}

Setup WS
    log into carrier group web services  141996  19YI30

Tear Me Down
    log out of carrier group web services