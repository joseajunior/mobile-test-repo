*** Settings ***
Test Timeout  5 minutes
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  otr_robot_lib.ws.CardManagementWS
Library  Collections
Library  String
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Force Tags  Cards  Card Detail  eManager
Suite Setup  Setup Card Detail

*** Variables ***
${card}
${carrier}
${user_id_list}
${permission_status}
${minus_three_days}

*** Test Cases ***
Card Detail - Transaction Log Product Details - PARKLAND
    [Tags]  JIRA:ROCKET-193  qTest:55072190  API:Y  PI:13
    [Documentation]  This test will check if Transaction Log contains product descriptions.
    [Setup]  Find Parkland Carrier
    Switch to "${transaction['carrier_id']}" User
    Select Program > "Manage Cards" > "View/Update Cards"
    Select a Card on Card Lookup  ${transaction['card_num']}
    Click on Last Transaction  ${transaction['trans_id'].__str__()}
    Verify Product Descripton  ${transaction}
    [Teardown]  Close Browser

Card Detail - Transaction Log Product Details - Fleet One
    [Tags]  JIRA:ROCKET-193  qTest:55072665  API:Y  PI:13
    [Documentation]  This test will check if Transaction Log contains product descriptions.
    [Setup]  Find Fleet One Carrier
    Switch to "${transaction['carrier_id']}" User
    Select Program > "Manage Cards" > "View/Update Cards"
    Select a Card on Card Lookup  ${transaction['card_num']}
    Click on Last Transaction  ${transaction['trans_id'].__str__()}
    Verify Product Descripton  ${transaction}
    [Teardown]  Close Browser

Card Detail - Transaction Log Product Details - TCH
    [Tags]  JIRA:ROCKET-193  qTest:55072687  API:Y  PI:13
    [Documentation]  This test will check if Transaction Log contains product descriptions.
    [Setup]  Find TCH Carrier
    Switch to "${transaction['carrier_id']}" User
    Select Program > "Manage Cards" > "View/Update Cards"
    Select a Card on Card Lookup  ${transaction['card_num']}
    Click on Last Transaction  ${transaction['trans_id'].__str__()}
    Verify Product Descripton  ${transaction}
    [Teardown]  Close Browser

Card Detail - Transaction Log Product Details - SHELL
    [Tags]  JIRA:ROCKET-193  qTest:55072755  API:Y  PI:13
    [Documentation]  This test will check if Transaction Log contains product descriptions.
    [Setup]  Find SHELL Carrier
    Switch to "${transaction['carrier_id']}" User
    Select Program > "Manage Cards" > "View/Update Cards"
    Select a Card on Card Lookup  ${transaction['card_num']}
    Click on Last Transaction  ${transaction['trans_id'].__str__()}
    Verify Product Descripton  ${transaction}
    [Teardown]  Close Browser

Card Detail - Transaction Log Product Details - IRVING
    [Tags]  JIRA:ROCKET-193  qTest:55072867  API:Y  PI:13
    [Documentation]  This test will check if Transaction Log contains product descriptions.
    [Setup]  Find IRVING Carrier
    Switch to "${transaction['carrier_id']}" User
    Select Program > "Manage Cards" > "View/Update Cards"
    Select a Card on Card Lookup  ${transaction['card_num']}
    Click on Last Transaction  ${transaction['trans_id'].__str__()}
    Verify Product Descripton  ${transaction}
    [Teardown]  Close Browser

Card Detail - Transaction Log Product Details - IMPERIAL
    [Tags]  JIRA:ROCKET-193  qTest:55072976  API:Y  PI:13
    [Documentation]  This test will check if Transaction Log contains product descriptions.
    [Setup]  Find IMPERIAL Carrier
    Switch to "${transaction['carrier_id']}" User
    Select Program > "Manage Cards" > "View/Update Cards"
    Select a Card on Card Lookup  ${transaction['card_num']}
    Click on Last Transaction  ${transaction['trans_id'].__str__()}
    Verify Product Descripton  ${transaction}
    [Teardown]  Close Browser

Card Detail - Transaction Log
    [Tags]  JIRA:FRNT-710  JIRA:BOT-2478  qTest:44098668
    [Documentation]  This test will check if Transaction Log feature is working when carrier has the permission for it.
    [Setup]  Setup for FRNT-710

    Log into eManager with a "Carrier that have Location Group Permission".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Make Sure You Can See Transaction Log Hyperlink next to Show Status History Link.
    Click on the hyperlink and that will take the user to a new Transaction Log.
    User Should See the Most Recent Three Transactions for that Card.
    User Can Update the Date Range to See More Transactions.

    [Teardown]  Teardown for FRNT-710

Card Detail - Cross Reference - Change
    [Tags]  JIRA:QAT-12  JIRA:QAT-592  JIRA:QAT-253  JIRA:BOT-1945  qTest:32790291
    [Documentation]  This test will check if Cross Reference change feature is working.
    [Setup]  Setup Card Header  xref=xref  payrollUse=B  #Card needs do be Universal to change Xref

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Cross Reference to "TEST" on Card Detail;
    Validate If Card Cross Reference Changes To "TEST";

    [Teardown]  Close Browser

Card Detail - Cross Reference - Blank
    [Tags]  JIRA:QAT-12  JIRA:QAT-592  JIRA:QAT-253  JIRA:BOT-1945  qTest:32790291
    [Documentation]  This test will check if Cross Reference change feature is working.
    [Setup]  Setup Card Header  xref=xref  payrollUse=B

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Cross Reference to "BLANK" on Card Detail;
    Validate If Card Cross Reference Changes To "BLANK";

    [Teardown]  Close Browser

Card Detail - Hand Enter - Allow
    [Tags]  JIRA:QAT-592  JIRA:QAT-256  qTest:32790223
    [Documentation]  This test will check if Hand Enter change feature is working.
    [Setup]  Setup Card Header  handEnter=Disallow

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Hand Enter to "ALLOW" on Card Detail;
    Validate If Card Hand Enter Changes To "ALLOW";

    [Teardown]  Close Browser

Card Detail - Hand Enter - Disallow
    [Tags]  qTest:32790226
    [Documentation]  This test will check if Hand Enter change feature is working.
    [Setup]  Setup Card Header  handEnter=Allow

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Hand Enter to "DISALLOW" on Card Detail;
    Validate If Card Hand Enter Changes To "DISALLOW";

    [Teardown]  Close Browser

Card Detail - Hand Enter - Policy
    [Tags]  qTest:32790241
    [Documentation]  This test will check if Hand Enter change feature is working.
    [Setup]  Setup Card Header  handEnter=Allow

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Hand Enter to "POLICY" on Card Detail;
    Validate If Card Hand Enter Changes To "POLICY";

    [Teardown]  Close Browser

Card Detail - Info Source - Card
    [Tags]  JIRA:QAT-13  JIRA:QAT-252  qTest:32790075
    [Documentation]  This test will check if Info Source change feature is working.
    [Setup]  Setup Card Header  infoSource=Policy

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Info Source to "CARD" on Card Detail;
    Validate If Card Info Source Changes To "CARD";

    [Teardown]  Close Browser

Card Detail - Info Source - Policy
    [Tags]  JIRA:QAT-592  JIRA:QAT-255  qTest:32790253
    [Documentation]  This test will check if Info Source change feature is working.
    [Setup]  Setup Card Header  infoSource=Card

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Info Source to "POLICY" on Card Detail;
    Validate If Card Info Source Changes To "POLICY";

    [Teardown]  Close Browser

Card Detail - Info Source - BOTH
    [Tags]  JIRA:QAT-255  qTest:32790255
    [Documentation]  This test will check if Info Source change feature is working.
    [Setup]  Setup Card Header  infoSource=Policy

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Info Source to "BOTH" on Card Detail;
    Validate If Card Info Source Changes To "BOTH";

    [Teardown]  Close Browser

Card Detail - Card Status - Active
    [Tags]  JIRA:QAT-13  JIRA:QAT-252  qTest:32789934  tier:0
    [Documentation]  This test will check if Card Status change feature is working.
    [Setup]  Setup Card Header  status=Inactive

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Status to "ACTIVE" on Card Detail;
    Validate If Card Status Changes To "ACTIVE";

    [Teardown]  Close Browser

Card Detail - Card Status - Inactive
    [Tags]  JIRA:QAT-13  JIRA:QAT-592  JIRA:QAT-252  qTest:32790074  tier:0
    [Documentation]  This test will check if Card Status change feature is working.
    [Setup]  Setup Card Header  status=Active

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Status to "INACTIVE" on Card Detail;
    Validate If Card Status Changes To "INACTIVE";

    [Teardown]  Close Browser

Card Detail - Card Status - Hold
    [Tags]  JIRA:QAT-13  JIRA:QAT-252  qTest:32790075
    [Documentation]  This test will check if Card Status change feature is working.
    [Setup]  Setup Card Header  status=Active

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Status to "HOLD" on Card Detail;
    Validate If Card Status Changes To "HOLD";

    [Teardown]  Close Browser

Card Detail - Show Status History - Recent Changes
    [Tags]  JIRA:FRNT-1055  JIRA:BOT-3246  qTest:33042815  PI:6
    [Documentation]  This test will check if Show Status History feature is working.
    [Setup]  Setup for FRNT-1055

    Log into eManager with a "Carrier".
    Navigate to Select Program > Manage Cards > View/Update Cards.
    Select a Card on Card Lookup  ${card.num}
    Change Card Status to "ACTIVE" on Card Detail;
    Go To Show Status History;
    User Should See the Most Recent Card Status Changes;

    [Teardown]  Close Browser

*** Keywords ***
Setup Card Detail
    [Documentation]   Keyword Setup for Card Detail Suite

    Get user_id From the Last "100" Logged to Avoid MySQL error.
    Get Carrier For Suite Execution
    Get Card For Suite Execution

Setup for FRNT-710
    [Documentation]  Keyword Setup for FRNT-710

    Ensure Carrier has User Permission  ${carrier.id}  TRANSACTION_LOG

#Date to set Date Range
    ${minus_three_days}  getDateTimeNow  %Y-%m-%d  days=-3
    Set Test Variable  ${minus_three_days}

Teardown for FRNT-710
    [Documentation]  Keyword Teardown for FRNT-710

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  TRANSACTION_LOG
    Close Browser

Setup for FRNT-1055
    [Documentation]  Keyword Setup for FRNT-1055

    Setup Card Header  status=Inactive

Log into eManager with a "${value}".
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Manage Cards > View/Update Cards.
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/CardLookup.action

Select a Card on Card Lookup
    [Arguments]  ${card}=${card.num}
    [Documentation]  Search for a card using card number as parameter.

    Select Radio Button  lookupInfoRadio  NUMBER
    Input Text  cardSearchTxt  ${card}
    Click Button  searchCard
    Click Element  //table[@id='cardSummary']//td//a[1]

Make Sure You Can See Transaction Log Hyperlink next to Show Status History Link.

    Element Should Be Visible  //a[contains(text(),'Transaction Log')]

Click on the hyperlink and that will take the user to a new Transaction Log.

    Click Element  //a[contains(text(),'Transaction Log')]

User Should See the Most Recent Three Transactions for that Card.
    [Documentation]  List Validation cheking item by item, there are chances to fail due to the crazy ordering on eManager.
#
    ${count}  Get Element Count  //table[@id='row']//tbody/tr
    Get Into DB  TCH

    ${query}  Catenate  SELECT preauth_date, location_id, invoice, preauth_id FROM preauth_transaction WHERE card_num='${card.num}'
    ...  AND preauth_date BETWEEN (CURRENT - 90 units DAY) AND CURRENT
    ...  ORDER BY preauth_date DESC Limit ${count};

    ${db}  Query to Dictionaries  ${query}

    FOR  ${row}  IN RANGE  0  ${count}
      ${date}  Get Table Value  ${row}  Date
      ${truckstop}  Get Table Value  ${row}  Truckstop
      ${invoice}  Get Table Value  ${row}  Invoice
      ${preauth_id}  Get Table Value  ${row}  Pre-auth Id
      Should Be Equal as Strings  ${date}:00  ${db[${row}]['preauth_date']}
      Should Be Equal as Strings  ${truckstop}  ${db[${row}]['location_id']}
      Should Be Equal as Strings  ${invoice}  ${db[${row}]['invoice']}
      Should Be Equal as Strings  ${preauth_id}  ${db[${row}]['preauth_id']}
   END

Get Table Value
    [Arguments]  ${row}  ${column}

    ${table_value}  Get Text  //table[@id='row']//tr[${row}+1]/td[count(//table[@id='row']//th/a[text()='${column}']/parent::th/preceding-sibling::th)+1]
    [Return]  ${table_value}

User Can Update the Date Range to See More Transactions.
    [Documentation]  List validation is simple because order by works differently on robot and eManager, check item by item was not working.

    Input Text  //input[@name='startDate']  ${minus_three_days}
    Click Element  //input[@id='submitButton']

    ${count}  Get Element Count  //table[@id='row']//tbody/tr

    Get Into DB  TCH

    ${query}  Catenate  SELECT preauth_date, location_id, invoice, preauth_id FROM preauth_transaction WHERE card_num='${card.num}'
    ...  AND preauth_date BETWEEN (CURRENT - 90 units DAY) AND CURRENT
    ...  AND preauth_date BETWEEN ('${minus_three_days} 00:00') AND CURRENT

    Row Count is Equal to X  ${query}  ${count.__str__()}

Get user_id From the Last "${value}" Logged to Avoid MySQL error.
    [Documentation]  Keyword to get a list of carriers that already logged into MySQL

    Get Into DB  Mysql
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' AND LENGTH(user_id) = 6 ORDER BY login_attempted DESC LIMIT ${value};
    ${list}  Query And Strip To Dictionary  ${query}
    ${user_id_list}  Get From Dictionary  ${list}  user_id
    ${user_id_list}  Evaluate  ${user_id_list}.__str__().replace('[','(').replace(']',')')

    Set Suite Variable  ${user_id_list}

Get Carrier For Suite Execution
    [Documentation]  Keyword to Get a Carrier for Suite Execution
#
    ${query}  Catenate  SELECT DISTINCT(m.member_id) FROM member m
    ...     JOIN cards c ON c.carrier_id = m.member_id
    ...     JOIN preauth_transaction t ON t.card_num = c.card_num
    ...  WHERE m.status='A'
    ...  AND c.status = 'A'
    ...  AND LEN(t.card_num) > 17
    ...  AND t.card_num NOT LIKE '5%'
    ...  AND t.preauth_date > CURRENT - 3 units DAY;
    ...  AND m.member_id IN ${user_id_list}
    ...  AND m.member_id NOT IN ('148697');

    ${carrier}  Find Carrier Variable  ${query}  member_id

    #${carrier}  Set Carrier Variable  148697

    Set Suite Variable  ${carrier}

    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_CARDS

Get Card For Suite Execution
    [Documentation]  Get a Card for Suite Test Execution
#
    ${query}  Catenate  SELECT pt.card_num FROM preauth_transaction pt
    ...  JOIN cards c ON pt.card_num = c.card_num
    ...  WHERE pt.carrier_id = ${carrier.id}
    ...  AND c.status = 'A'
    ...  AND LEN(pt.card_num) > 17
    ...  AND pt.card_num NOT LIKE '5%'
    ...  AND pt.preauth_date > CURRENT - 3 units DAY;

    ${card}  Find Card Variable  ${query}  card_num

#    ${card}  Set Card Variable  7083052034501600014

    Set Suite Variable  ${card}
    Start Setup Card  ${card.num}

Change Card Cross Reference to "${value}" on Card Detail;

    ${value}  Set Variable If  '${value}'=='BLANK'  ${empty}  ${value}

    Input Text  //input[@name='card.header.companyXRef']  ${value}
    Click Element  //input[@name='card.header.companyXRef']
    Click Element  //input[@id='saveCardInformationBtn']

Change Card Hand Enter to "${value}" on Card Detail;

    Click Element  //input[@name='card.header.handEnter' and @value='${value}']
    Click Element  //input[@id='saveCardInformationBtn']

Change Card Info Source to "${value}" on Card Detail;

    Click Element  //input[@name='card.header.infoSource' and @value='${value}']
    Click Element  //input[@id='saveCardInformationBtn']

Change Card Status to "${value}" on Card Detail;

    Click Element  //input[@name='card.header.status' and @value='${value}']
    Click Element  //input[@id='saveCardInformationBtn']

Go To Show Status History;
    Click Element  //a[@name='showStatusHistory']

User Should See the Most Recent Card Status Changes;
    [Documentation]  List Validation cheking item by item, there are chances to fail due to the crazy ordering on eManager.
#
    ${count}  Get Element Count  //table[@id='row']//tbody/tr
    Get Into DB  TCH

    ${query}  Catenate  SELECT
    ...  CASE WHEN status = 'A' THEN 'Active'
    ...       WHEN status = 'I' THEN 'Inactive'
    ...       ELSE 'Hold' END AS status,
    ...  trigger_date
    ...  FROM card_status WHERE card_num = '${card.num}' ORDER BY trigger_date DESC LIMIT ${count};

    ${db}  Query to Dictionaries  ${query}

    FOR  ${row}  IN RANGE  0  ${count}
      ${status}  Get Table Value  ${row}  Current Status
      ${updated_on}  Get Table Value  ${row}  Updated On
      Should Be Equal as Strings  ${status}  ${db[${row}]['status'].strip()}
      Should Be Equal as Strings  ${updated_on}  ${db[${row}]['trigger_date']}
    END

Validate If Card Cross Reference Changes To "${value}";
    [Documentation]  Check if Change is Reflected on Database.
#
    ${value}  Set Variable If  '${value}'=='BLANK'  None  ${value}

    Get Into DB  TCH
    ${xref}  Query And Strip  SELECT TRIM(coxref) AS coxref FROM cards where card_num = '${card.num}'

    Should be Equal as Strings  ${xref}  ${value}


Validate If Card Status Changes To "${value}";
    [Documentation]  Check if Change is Reflected on Database.
#
    ${card_status}  Set Variable If  '${value}'=='FRAUD'  U
    ${card_status}  Set Variable If  '${value}'=='ACTIVE'  A  ${card_status}
    ${card_status}  Set Variable If  '${value}'=='INACTIVE'  I  ${card_status}
    ${card_status}  Set Variable If  '${value}'=='HOLD'  H  ${card_status}

    Get Into DB  TCH
    Row Count Is Equal To X  SELECT 1 FROM cards WHERE status = '${card_status}' AND card_num = '${card.num}'  1

Validate If Card Hand Enter Changes To "${value}";
    [Documentation]  Check if Change is Reflected on Database.
#
    ${card_hand_enter}  Set Variable If  '${value}'=='ALLOW'  Y
    ${card_hand_enter}  Set Variable If  '${value}'=='POLICY'  D  ${card_hand_enter}
    ${card_hand_enter}  Set Variable If  '${value}'=='DISALLOW'  N  ${card_hand_enter}

    Get Into DB  TCH
    Row Count Is Equal To X  SELECT 1 FROM cards WHERE handenter = '${card_hand_enter}' AND card_num = '${card.num}'  1

Validate If Card Info Source Changes To "${value}";
    [Documentation]  Check if Change is Reflected on Database.
#
    ${card_info_source}  Set Variable If  '${value}'=='CARD'  C
    ${card_info_source}  Set Variable If  '${value}'=='POLICY'  D  ${card_info_source}
    ${card_info_source}  Set Variable If  '${value}'=='BOTH'  B  ${card_info_source}

    Get Into DB  TCH
    Row Count Is Equal To X  SELECT 1 FROM cards WHERE infosrc = '${card_info_source}' AND card_num = '${card.num}'  1

Find Parkland Carrier
    [Tags]  qtest
    [Documentation]  Find a Parkland carrier transaction:
        ...  select t.carrier_id, t.card_num, l.cat, p.description, l.num, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
        ...  from trans_line l
        ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
        ...           join transaction t on l.trans_id = t.trans_id
        ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
        ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 31)
        ...    and trans_date
        ...      > current - 30 units day)
        ...    and p.fps_partner = 'PARKLAND'
        ...    and p.description != 'PLUS'
        ...  order by t.trans_id DESC limit 1;
    ${sql}  catenate  select t.carrier_id, t.card_num, l.cat, p.description, l.num, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
        ...  from trans_line l
        ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
        ...           join transaction t on l.trans_id = t.trans_id
        ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
        ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 31)
        ...    and trans_date
        ...      > current - 30 units day)
        ...    and p.fps_partner = 'PARKLAND'
        ...    and p.description != 'PLUS'
        ...  order by t.trans_id DESC limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=tch
    set test variable  ${transaction}
    Open eManager  ${intern}  ${internPassword}

Find Fleet One Carrier
    [Tags]  qtest
    [Documentation]  Find a fleet one carrier transaction:
                ...  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 26)
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'TCH'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${sql}  catenate  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 26)
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'TCH'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=tch
    set test variable  ${transaction}
    Open eManager  ${intern}  ${internPassword}

Find TCH Carrier
    [Tags]  qtest
    [Documentation]  Find a TCH carrier transaction:
                ...  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 10)
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'TCH'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${sql}  catenate  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id = 10)
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'TCH'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=tch
    set test variable  ${transaction}
    Open eManager  ${intern}  ${internPassword}

Find SHELL Carrier
    [Tags]  qtest
    [Documentation]  Find a SHELL carrier transaction:
                ...  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id in (11,17,18))
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'SHELL'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${sql}  catenate  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id in (11,17,18))
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'SHELL'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=shell
    set test variable  ${transaction}
    Open eManager  ${intern}  ${internPassword}

Find IRVING Carrier
    [Tags]  qtest
    [Documentation]  Find an Irving carrier transaction:
                ...  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id in (5,16,30))
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'IRVING'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${sql}  catenate  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id in (5,16,30))
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'IRVING'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=irving
    set test variable  ${transaction}
    Open eManager  ${intern}  ${internPassword}

Find IMPERIAL Carrier
    [Tags]  qtest
    [Documentation]  Find an imperial carrier transaction:
                ...  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id in (4,12))
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'IMPERIAL'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${sql}  catenate  select t.carrier_id, t.card_num, l.cat, p.description, l.trans_id, TO_CHAR(t.trans_date, '%m/%d/%Y') as trans_date
                ...  from trans_line l
                ...           join products p on l.cat = p.abbrev and l.fuel_type = p.fuel_type and l.num = p.num
                ...           join transaction t on l.trans_id = t.trans_id
                ...  where l.trans_id in (select trans_id from transaction where extra_3 != 7
                ...    and issuer_id in (select issuer_id from issuer_misc where issuer_group_id in (4,12))
                ...    and trans_date
                ...      > current - 3 units day)
                ...    and p.fps_partner = 'IMPERIAL'
                ...    and p.description != 'PLUS'
                ...  order by t.trans_id DESC limit 1;
    ${transaction}  query and strip to dictionary  ${sql}  db_instance=imperial
    set test variable  ${transaction}
    Open eManager  ${intern}  ${internPassword}

Click on Last Transaction
    [Tags]  qtest
    [Documentation]  Click on the last transaction for the customer or click More transactions and select one
    [Arguments]  ${trans_id}
    Go To  ${emanager}/cards/TransactionDetail.action?transactionId=${trans_id}

Verify Product Descripton
    [Tags]  qtest
    [Documentation]  Verify the product description is displayed under products
    [Arguments]  ${product}
    ${description}  catenate  ${product['cat']} - ${product['description']}
    page should contain  ${description}