*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyMath
Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  String
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager  SmartFunds

Test Teardown    Close Browser
Suite Setup    Setup Card for ACH Driver Profile

*** Variables ***
${card_password}=  a1s2d3f4
${card}


*** Test Cases ***
Carrier Creates Profile for a SmartCard
    [Documentation]  This test is to add a profile ID to a card_num if you were logged in as the carrier
    ...  and to verify that those changes were made within the database.

    [Tags]  QAT-699  BOT-138  JIRA:BOT-3569

    Log into eManager with a Carrier
    Go To SmartFunds Manage Cards
    Search Card Number  ${card.num}
    Click on Edit Driver Profile
    Input Driver Profile Data
    ...  firstName=aaa
    ...  lastName=bbb
    ...  address=123
    ...  city=Ogden
    ...  state=UT
    ...  postalCode=84044
    ...  dob=2000-01-01
    ...  lastFourSS=1111
    ...  email=efs.testers@efsllc.com
    ...  cellPhoneNumber=111-111-1111
    Assert Profile Changes  aaa  bbb  123  Ogden  UT  84044  2000-01-01  1111  efs.testers@efsllc.com  1111111111

Using Card Number to Create Own Profile
    [Documentation]  A card user creates their own profile using the card_num to log in and their pin to get into eManager.
    ...  It then verifies that those changes were made to the database.

    [Tags]  JIRA:QAT-699  JIRA:BOT-138  JIRA:BOT-1931  JIRA:BOT-3569  qTest:30354517  Regression

    Log into eManager with a SmartFunds Card
    Go To Edit SmartFunds Driver Profile
    Input Driver Profile Data
    ...  firstName=zzz
    ...  lastName=zzz
    ...  address=123
    ...  city=Ogden
    ...  state=UT
    ...  postalCode=84044
    ...  dob=2000-01-01
    ...  lastFourSS=1111
    ...  email=efs.testers@efsllc.com
    ...  cellPhoneNumber=111-111-1111
    Assert Profile Changes  zzz  zzz  123  Ogden  UT  84044  2000-01-01  1111  efs.testers@efsllc.com  1111111111

Log into eManager with a SmartFunds Card
    [Tags]  JIRA:BOT-1183  JIRA:BOT-3569  qTest:30354516  Regression
    [Documentation]  Log into eManager with a SmartFunds Card Using Password instead of Pin.

    Log into eManager with a SmartFunds Card Using Password
    Go To Edit SmartFunds Driver Profile

Edit SmartFunds Driver Profile
    [Tags]  JIRA:BOT-1184  JIRA:BOT-3569  qTest:30354517  Regression
    [Documentation]  Edit SmartFunds Driver Profile and then check if it is updated.

    Log into eManager with a SmartFunds Card
    Go To Edit SmartFunds Driver Profile
    Input Driver Profile Data
    Compare Driver Profile from Screen With Database

Check All Mandatory Fields and Proper Error Message on Smartfunds Driver Profile
    [Tags]  JIRA:BOT-1185  JIRA:BOT-3569  qTest:30354518  Regression
    [Documentation]  Remove data in each profile field and submit EVERYTHING should be mandatory.
    ...              Check for proper Error message when you leave any particular field blank.

    Log into eManager with a SmartFunds Card
    Go To Edit SmartFunds Driver Profile
    Check Mandatory Fields

Click on Transfer Acct on Smartfunds Driver Profile
    [Tags]  JIRA:BOT-1186  JIRA:BOT-3569  qTest:30354519  Regression
    [Documentation]  On SmartFunds Driver Profile screen Click on Transfer Acct button.

    Log into eManager with a SmartFunds Card
    Go To Edit SmartFunds Driver Profile
    Click on Transfer Account Button and Check Screen

*** Keywords ***
Go To Edit SmartFunds Driver Profile
    [Documentation]  Support Keyword for ACHDriverProfile.robot for Navigate to Edit Driver Profile screen.

    Go To  ${emanager}/cards/SmartPayEditDriverProfile.action
    Element Should be Visible  //*[text()='SmartFunds Driver Profile']

Get Driver Profile From DB
    [Documentation]  Support Keyword for ACHDriverProfile.robot to get Driver Profile data from Database.

    Get Into DB  TCH

    ${profile_id}  Query and Strip  SELECT profile_id FROM ach_profile_card_xref WHERE card_num='${card}'

    ${query}  Catenate  SELECT trim(first_name) AS first_name,
    ...  trim(last_name) AS last_name,
    ...  trim(address) AS address,
    ...  trim(city) AS city,
    ...  trim(state) AS state,
    ...  trim(postal_code) AS postal_code,
    ...  trim(country) AS country,
    ...  dob,
    ...  lastfourss,
    ...  trim(email_addr) AS email_addr,
    ...  trim(cell_phone) AS cell_phone
    ...  FROM ach_driver_profile WHERE profile_id='${profile_id}'

    ${profile}  Query And Strip To Dictionary  ${query}
    [Return]  ${profile}

Get Driver Profile From Screen
    [Documentation]  Support Keyword for ACHDriverProfile.robot to get Driver Profile data from Screen.

    ${first_name}  Get Value  smartPayDriver.firstName
    ${last_name}  Get Value  smartPayDriver.lastName
    ${address}  Get Value  smartPayDriver.address
    ${city}  Get Value   smartPayDriver.city
    ${state}  Get Value   smartPayDriver.state
    ${postal_code}  Get Value   smartPayDriver.postalCode
    ${dob}  Get Value   smartPayDriver.dob
    ${lastfourss}  Get Value   smartPayDriver.lastFourSS
    ${email_addr}  Get Value   smartPayDriver.email
    ${cell_phone}  Get Value   smartPayDriver.cellPhoneNumber

    Set Test Variable  ${first_name}
    Set Test Variable  ${last_name}
    Set Test Variable  ${address}
    Set Test Variable  ${city}
    Set Test Variable  ${state}
    Set Test Variable  ${postal_code}
    Set Test Variable  ${dob}
    Set Test Variable  ${lastfourss}
    Set Test Variable  ${email_addr}
    Set Test Variable  ${cell_phone}

Input Driver Profile Data
    [Arguments]  ${firstName}=EFS  ${lastName}=Tester  ${address}=1104 Country Hills Dr # 600  ${city}=Ogden  ${state}=UT  ${postalCode}=84403  ${dob}=2000-01-01  ${lastFourSS}=1111  ${email}=WEXEFS-El-Robot@wexinc.com  ${cellPhoneNumber}=555-555-5555
    [Documentation]  Input values on Edit Driver Profile screen and Submit.
    ...  Examples:
    ...  -------------------------------------
    ...  Input Driver Profile Data
    ...  ...  firstName=aaa
    ...  ...  lastName=bbb
    ...  ...  address=123
    ...  ...  city=Ogden
    ...  ...  state=UT
    ...  ...  postalCode=84044
    ...  ...  dob=2000-01-01
    ...  ...  lastFourSS=1111
    ...  ...  email=efs.testers@efsllc.com
    ...  ...  cellPhoneNumber=111-111-1111
    ...  -------------------------------------
    ...  Or you can call just the keyword with pre setup data : Input Driver Profile Data
    ...  -------------------------------------

    Input Text  smartPayDriver.firstName  ${firstName}
    Input Text  smartPayDriver.lastName   ${lastName}
    Input Text  smartPayDriver.address   ${address}
    Input Text  smartPayDriver.city  ${city}
    Select From List By Value  smartPayDriver.state  ${state}
    Input Text  smartPayDriver.postalCode  ${postalCode}
    Input Text  smartPayDriver.dob  ${dob}
    Input Text  smartPayDriver.lastFourSS  ${lastFourSS}
    Input Text  smartPayDriver.email  ${email}
    Input Text  smartPayDriver.cellPhoneNumber  ${cellPhoneNumber}

    Scroll Element Into View  submitEditDriverProfileForm
    Click On  submitEditDriverProfileForm

    Assert Message  SmartFunds driver profile updated

Backup Driver Profile
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Backup Driver Profile usign Database.

    ${backup_profile}  Get Driver Profile From DB
    Set Test Variable  ${backup_profile}

Compare Driver Profile from Screen With Database
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Assert Driver Profile Information.

    Get Driver Profile From Screen
    ${compare}  Get Driver Profile From DB
    ${cell_phone}  Remove String  ${cell_phone}  -

    Should Be Equal as Strings  ${first_name}  ${compare['first_name']}
    Should Be Equal as Strings  ${last_name}  ${compare['last_name']}
    Should Be Equal as Strings  ${address}  ${compare['address']}
    Should Be Equal as Strings  ${city}  ${compare['city']}
    Should Be Equal as Strings  ${state}  ${compare['state']}
    Should Be Equal as Strings  ${postal_code}  ${compare['postal_code']}
    Should Be Equal as Strings  ${dob}  ${compare['dob']}
    Should Be Equal as Strings  ${lastfourss}  ${compare['lastfourss']}
    Should Be Equal as Strings  ${email_addr}  ${compare['email_addr']}
    Should Be Equal as Strings  ${cell_phone}  ${compare['cell_phone']}

Assert Message
    [Arguments]  ${expected_message}
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Assert Message on Screen.

    ${message}  Get Text  //ul[@class='messages']/li
    Should be Equal as Strings  ${message}  ${expected_message}

Assert Error Message
    [Arguments]  ${expected_message}
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Assert Error Message on Screen.

    ${error_message}  Get Text  //div[@class='errors']//li
    Should be Equal as Strings  ${error_message}  ${expected_message}

Remove E-Mail and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove e-mail data from field.

    ${email}  Get Value  smartPayDriver.email
    Clear Element Text  smartPayDriver.email
    Click On  submitEditDriverProfileForm
    Assert Error Message  Email is a required field
    Input Text  smartPayDriver.email  ${email}

Remove Phone Number and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove Phone Number data from field.

    ${phone}  Get Value  smartPayDriver.cellPhoneNumber
    Clear Element Text  smartPayDriver.cellPhoneNumber
    Click On  submitEditDriverProfileForm
    Assert Error Message  Phone # is a required field
    Input Text  smartPayDriver.cellPhoneNumber  ${phone}

Remove First Name and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove First Name data from field.

    ${first_name}  Get Value  smartPayDriver.firstName
    Clear Element Text  smartPayDriver.firstName
    Click On  submitEditDriverProfileForm
    Assert Error Message  First Name is a required field
    Input Text  smartPayDriver.firstName  ${first_name}

Remove Last Name and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove Last Name data from field.

    ${last_name}  Get Value  smartPayDriver.lastName
    Clear Element Text  smartPayDriver.lastName
    Click On  submitEditDriverProfileForm
    Assert Error Message  Last Name is a required field
    Input Text  smartPayDriver.lastName  ${last_name}

Remove Address and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove Address data from field.

    ${address}  Get Value  smartPayDriver.address
    Clear Element Text  smartPayDriver.address
    Click On  submitEditDriverProfileForm
    Assert Error Message  Address is a required field
    Input Text  smartPayDriver.address  ${address}

Remove City and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove City from field.

    ${city}  Get Value  smartPayDriver.city
    Clear Element Text  smartPayDriver.city
    Click On  submitEditDriverProfileForm
    Assert Error Message  City is a required field
    Input Text  smartPayDriver.city  ${city}

Remove State and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove State from field.

    ${state}  Get Value  smartPayDriver.state
    Select From List By Index  smartPayDriver.state  0
    Click On  submitEditDriverProfileForm
    Assert Error Message  State is a required field
    Select From List By Value  smartPayDriver.state  ${state}

Remove Postal Code and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove Postal Code from field.

    ${postal_code}  Get Value  smartPayDriver.postalCode
    Clear Element Text  smartPayDriver.postalCode
    Click On  submitEditDriverProfileForm
    Assert Error Message  Zip is a required field
    Input Text  smartPayDriver.postalCode  ${postal_code}

Remove Date of Birth and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove Date of Birth from field.

    ${dob}  Get Value  smartPayDriver.dob
    Clear Element Text  smartPayDriver.dob
    Click On  submitEditDriverProfileForm
    Assert Error Message  Date of Birth is a required field
    Input Text  smartPayDriver.dob  ${dob}

Remove Last Four SS and Submit
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Remove Last Four SS from field.

    ${lastfourss}  Get Value  smartPayDriver.lastFourSS
    Clear Element Text  smartPayDriver.lastFourSS
    Click On  submitEditDriverProfileForm
    Assert Error Message  Last 4 of Social Security/SIN is a required field
    Input Text  smartPayDriver.lastFourSS  ${lastfourss}

Click on Transfer Account Button and Check Screen
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Click on Transfer Account Button and Check Screen.

    Click on  gotoSmartPayTransferAccounts
    Element Should be Visible  //span[text()='SmartFunds Transfer Accounts']
    Element Should be Visible  smartPayTransferAccount.bankName
    Element Should be Visible  smartPayTransferAccount.routingNumber
    Element Should be Visible  smartPayTransferAccount.accountNumber
    Element Should be Visible  smartPayTransferAccount.accountOwnerName
    Element Should be Visible  smartPayTransferAccount.accountType
    Element Should be Visible  smartPayTransferAccount.accountNickname
    Element Should be Visible  submitNewTransferAccountForm
    Element Should be Visible  smartPayTransferAccountVar

Check Mandatory Fields
    [Documentation]  Support Keyword for ACHDriverProfile.robot to Check Mandatory Fields Works.

    Remove E-Mail and Submit
    Compare Driver Profile from Screen With Database
    Remove Phone Number and Submit
    Compare Driver Profile from Screen With Database
    Remove First Name and Submit
    Compare Driver Profile from Screen With Database
    Remove Last Name and Submit
    Compare Driver Profile from Screen With Database
    Remove Address and Submit
    Compare Driver Profile from Screen With Database
    Remove City and Submit
    Compare Driver Profile from Screen With Database
    Remove State and Submit
    Compare Driver Profile from Screen With Database
    Remove Postal Code and Submit
    Compare Driver Profile from Screen With Database
    Remove Date of Birth and Submit
    Compare Driver Profile from Screen With Database
    Remove Last Four SS and Submit
    Compare Driver Profile from Screen With Database

Setup Card for ACH Driver Profile
    [Documentation]    Set card number and pin from database

    ${query}  Catenate  SELECT card_num
    ...  FROM card_pins
    ...  WHERE set > '2021-01-01 00:00'
    ...  AND valid='A'
    ...  AND status='A';
    #Set card number
    ${card}  Find Card Variable  ${query}  card_num
    Set Suite Variable  ${card}

    ${pinQuery}  Catenate  SELECT pin
    ...    FROM card_pins
    ...    WHERE card_num = '${card}';
    #Set card pin
    Get Into DB  tch
    ${card_passwd}  query and strip  ${pinQuery}
    Set Suite Variable  ${card_passwd}

Assert Profile Changes
    [Arguments]  ${expectedFirstName}  ${expectedLastName}  ${expectedAddress}  ${expectedCity}  ${expectedState}
    ...  ${expectedPostalCode}  ${expectedDob}  ${expectedLastFourss}  ${expectedEmailAddress}  ${expectedCellPhone}
    [Documentation]    Check profile changes

    Get Into DB  tch
    ${profileID}=  query and strip  select profile_id from ach_profile_card_xref where card_num = '${card}';
    ${profileQuery}=  query and strip to dictionary  select * from ach_driver_profile where profile_id = ${profileID};
    #Check profile changes
    should be equal as strings  ${expectedFirstName}  ${profileQuery['first_name']}
    should be equal as strings  ${expectedLastName}  ${profileQuery['last_name']}
    should be equal as strings  ${expectedAddress}  ${profileQuery['address']}
    should be equal as strings  ${expectedCity}  ${profileQuery['city']}
    should be equal as strings  ${expectedState}  ${profileQuery['state']}
    should be equal as strings  ${expectedPostalCode}  ${profileQuery['postal_code']}
    should be equal as strings  ${expectedDob}  ${profileQuery['dob']}
    should be equal as strings  ${expectedLastFourss}  ${profileQuery['lastfourss']}
    should be equal as strings  ${expectedEmailAddress}  ${profileQuery['email_addr']}
    should be equal as strings  ${expectedCellPhone}  ${profileQuery['cell_phone']}

Log into eManager with a SmartFunds Card Using Password
    [Documentation]    Log into eManager with a SmartFunds Card using Password

    Open eManager  7083050910386614885  ${card_password}  False

Log into eManager with a SmartFunds Card
    [Documentation]    Log into eManager with a SmartFunds Card

    Open eManager  ${card}  ${card_passwd}  False

Log into eManager with a Carrier
    [Documentation]    Log into eManager with a Carrier

    Open eManager  ${card.carrier.id}  ${card.carrier.password}

Go To SmartFunds Manage Cards
    [Documentation]    Go to Select Program > SmartFunds > SmartFunds Card Management

    Go to  ${emanager}/cards/SmartPayCardLookup.action?am=SMARTPAY_TRANSFER

Search Card Number
    [Arguments]  ${cardNumber}
    [Documentation]    Search by card number

    Click on  //input[@value='NUMBER']
    Input text  cardSearchTxt  ${cardNumber}
    Click on  searchCard

Click on Edit Driver Profile
    [Documentation]    Click edit icon on card table

    Click on  //a[contains(@href, 'Edit')]
