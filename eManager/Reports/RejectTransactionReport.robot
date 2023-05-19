*** Settings ***
Library  String
Library  OperatingSystem  WITH NAME  os
Library  otr_model_lib.Models
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Setup for Reject Transaction Report
Suite Teardown  Run Keywords    Turn ON Excel Report Flag to xls/xlsx.    Disconnect From Database

Force Tags  eManager  Reports  Reject Transaction Report

*** Variables ***
${card}
${card_number}
${carrier}
${db_data}
${excel_data}
${last_transaction_date}
${location_id}
${start_date}
${excelFile}
${match_by_card}
${match_by_location}
${permission_status}
${report_name}  RejectTransactionReport
${report_format}

*** Test Cases ***

Reject Transaction Report - Immediate Report
    [Documentation]  Create an Immediate Report for Reject Transaction Report, download and validate.
    [Tags]  JIRA:FRNT-1056  qTest:33318780  JIRA:BOT-3427  PI:6  tier:0

    Log into eManager with a Carrier that have Reject Transaction Report Permission;
    Navigate to Select Program > Reports/Exports > Reject Transaction Report;
    Select 'Immediate Report';
    Select Date Range for Reject Transaction Report;
    Select Excel as Report Format;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Get Reject Transaction Report Excel Data;
    Get Reject Transaction Report Data From Database;
    Compare Reject Transaction Report Excel Data With Database;

    [Teardown]  Teardown for Reject Transaction Report

Reject Transaction Report - Restricted chain displayed for CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747442  JIRA:BOT-3647  refactor
    [Documentation]  Ensure restricted locations are displayed for CT7 carriers in Reject Transaction Report

	Setup 'a' CT7 Carrier with Reject Transaction Report Permission
	Log into eManager with a Carrier that have Reject Transaction Report Permission;
	Navigate to Select Program > Reports/Exports > Reject Transaction Report;
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has' CT7 carrier chain id
	Check the search results 'has' CT7 carrier location id

	[Teardown]  Close Browser

Reject Transaction Report - Restricted chain not displayed for non CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747429  JIRA:BOT-3647  refactor
    [Documentation]  Ensure restricted locations are not displayed for non CT7 carriers in Reject Transaction Report

	Setup 'non' CT7 Carrier with Reject Transaction Report Permission
	Log into eManager with a Carrier that have Reject Transaction Report Permission;
	Navigate to Select Program > Reports/Exports > Reject Transaction Report;
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Check the search results 'has no' CT7 carrier location id

	[Teardown]  Close Browser

Reject Transaction Report for all parent carrier children
    [Tags]    JIRA:FRNT-2287     qTest:118895803     JIRA:BOT-5040    PI:15
    [Documentation]    Ensure Reject Transaction Report is being generated with no errors for all parent carrier children
    [Setup]    Setup Parent Carrier with Reject Transacton Report permission

    Log into eManager with a Carrier that have Reject Transaction Report Permission;
    Navigate to Select Program > Reports/Exports > Reject Transaction Report;
    Select 'Immediate Report';
    Select PDF as Report Format;
    Select option All for Child Carrier field
    Download and Check Report File

    [Teardown]  Teardown for Parent Carrier Reject Transaction Report

*** Keywords ***
Setup for Reject Transaction Report
    [Documentation]  Keyword Setup for Reject Transaction Report

    Turn OFF Excel Report Flag to xls/xlsx.  #this should be temporary and will be remove in a near future, I hope so!

    Get Into DB  MySQL

#Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT carrier_id FROM tran_reject
    ...  WHERE carrier_id IN ${list_2}
    ...  AND carrier_id NOT IN ('146567','344969','153156','103866','106651','701501','100644')  #bad carrier for this one
    ...  ORDER BY t_date DESC limit 50;

    ${carrier}  Find Carrier Variable  ${query}  carrier_id

    Ensure Carrier has User Permission  ${carrier.id}  REJECT_TRANS_REPORT

    Set Suite Variable  ${carrier}

    Get Last Transaction Reject for Carrier

Setup '${condition}' CT7 Carrier with Reject Transaction Report Permission
    [Documentation]  Setup for a/non CT7 carrier with Reject Transaction Report permission

    Get Into DB  Mysql
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 150;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')
    # Build query to get a/non CT7 carrier
    ${CT7Carrier}  Run Keyword If    '${condition}' == 'non'    Set Variable    not in    ELSE    Set Variable    in
    ${query}  Catenate  SELECT member_id FROM member m
    ...  JOIN contract c
    ...  ON m.member_id = c.carrier_id
    ...  WHERE m.mem_type='C'
    ...  AND m.status='A'
    ...  AND m.member_id ${CT7Carrier} (SELECT carrier_id FROM contract WHERE issuer_id in (194148, 194149))
    ...  AND m.member_id IN ${list_2}
    ...  AND m.member_id NOT IN ('381776');
    # Find carrier with given query and set as suite variable
    ${carrier}  Find Carrier Variable  ${query}  member_id
    Set Suite Variable  ${carrier}
    # Ensure carrier has Reject Transaction Report permission
    Ensure Carrier has User Permission  ${carrier.id}  REJECT_TRANS_REPORT

Setup Parent Carrier with Reject Transacton Report permission
    [Documentation]    Get a parent carrier and set Reject Transaction Report and Carrier Group permissions to it

    Get into DB    TCH
    ${query}    Catenate    SELECT parent
    ...    FROM carrier_group_xref
    ...    GROUP BY parent
    ...    HAVING COUNT(*) > 1
    ...    ORDER BY parent;
    ${query_result}  Query And Strip To Dictionary  ${query}
    ${carrier_list}  Get From Dictionary  ${query_result}  parent
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    Get Into DB  Mysql
    ${query}  Catenate  SELECT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]+$'
    ...    AND user_id IN ${carrier_list}
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ${query_result}  Query And Strip To Dictionary  ${query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    Get into DB    TCH
    ${query}    Catenate    SELECT member_id
    ...    FROM member
    ...    WHERE member_id IN ${carrier_list};
    ${carrier}  Find Carrier Variable  ${query}  member_id
    Set Suite Variable  ${carrier}
    Ensure Carrier has User Permission  ${carrier.id}  REJECT_TRANS_REPORT
    Ensure Carrier has User Permission  ${carrier.id}  CARRIER_GROUP

Turn ${value} Excel Report Flag to xls/xlsx.
    [Documentation]  This keyword will change the excel report format to xlsx if flag is ON and xls if flag is OFF.
    ...  This is a measure to deal with reports while we dont have support to xlsx files.

    Get Into DB  MySQL

    ${flag}  Set Variable If  '${value}'=='ON'  Y  N

    Execute SQL String  dml=update setting SET value = '${flag}' WHERE `PARTITION` = 'shared' AND name = 'com.tch.export.xlsx';

Get Last Transaction Reject for Carrier
    [Documentation]
    [Arguments]  ${instance}=TCH

    Get Into DB  ${instance}

    ${query}  Catenate  SELECT TO_CHAR(reject_date, '%Y-%m-%d') AS date
    ...  FROM tran_reject
    ...  WHERE carrier_id = ${carrier.id}
    ...  ORDER BY t_date DESC limit 1;

    ${last_transaction}  Query and Strip to Dictionary  ${query}

    Set Suite Variable  ${last_transaction_date}  ${last_transaction['date']}

Teardown for Reject Transaction Report
    [Documentation]  Teardown for Transaction Report

    Close Browser
    Remove Report File  ${report_name}

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  REJECT_TRANS_REPORT

Log into eManager with a Carrier that have Reject Transaction Report Permission;
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Reports/Exports > Reject Transaction Report;
    [Documentation]  Go to Desired Page
    Go To  ${emanager}/cards/TranRejectReport.action
    Wait Until Page Contains    Match By (Optional):

Select '${report_type}';

    Click Element  //input[@title='${report_type}']

Select Date Range for Reject Transaction Report;
    [Documentation]  Select date range for Reject Transaction Report

    Input Text  //input[@name='startDate']  ${last_transaction_date.__str__()}
    Input Text  //input[@name='endDate']  ${last_transaction_date.__str__()}


Select Match By Card Number and Input Data;
    [Documentation]  Select match by option and input card number

    Select Checkbox  //input[@name='cardNumberDoFilter']
    Input Text  //input[@name='displayNumber']  ${card_number}

    Set Test Variable  ${match_by_card}  Yes

Select Match By Location Id and Input Data;
    [Documentation]  Select match by option and input card number

    Select Checkbox  //input[@name='locationIdDoFilter']
    Input Text  //input[@name='locationId']  ${location_id}

    Set Test Variable  ${match_by_Location}  Yes

Select ${report_format} as Report Format;
    [Documentation]  Options are Excel or PDF

    Select From List By label  viewFormat  ${report_format}

    Set Test Variable  ${report_format}

Select the Location ID
    Click Element    //input[@name="locationIdDoFilter"]

Click Look Up Location button
    Click Button    name=lookUpLocation

Select the Location ID and click the 'Look Up Location' button
    Select the Location ID
    Click Look Up Location button
    Wait Until Page Contains  Search Location Type

Download Excel Report File;
    [Documentation]  Keyword to download excel format file

    ${excelFile}  Download Report File  ${Report_Name}  xls

    Set Test Variable  ${excelFile}

Verify if Excel Report is Downloaded;
    [Documentation]  Keyword to check if excel Report is downloaded

    Assert if File is Dowloaded  ${report_name}.xls

Get Reject Transaction Report Excel Data;
#
    ${excel_data}  Get Values From Excel Rows  ${excelFile}

    FOR  ${i}  IN  @{excel_data}
      ${date}  Get From Dictionary  ${i}  date
      ${date}  Excel Date To String  ${date}  %Y-%m-%d
      Set To Dictionary  ${i}  date=${date}
      ${time}  Get From Dictionary  ${i}  time
      ${time}  Excel Date To String  ${time}  %H:%M
      Set To Dictionary  ${i}  time=${time}
    END

    Set Test Variable  ${excel_data}
#    log to console  ${excel_data}

Get Reject Transaction Report Data From Database;
    [Documentation]

    Get Into DB  TCH

    ${query}  Catenate  SELECT
    ...  TO_CHAR(reject_date,'%Y-%m-%d') AS date,
    ...  TO_CHAR(reject_date,'%H:%M') AS time,
    ...  TRIM(card_num) AS card_number,
    ...  nvl(TRIM(invoice),'') AS invoice,
    ...  l.location_id,
    ...  UPPER(l.name) AS location_name,
    ...  l.city AS location_city,
    ...  l.state AS state_prov,
    ...  err_code AS error_code,
    ...  RIGHT(TRIM(msg), LEN(TRIM(msg)) - 13) AS error_description
    ...  FROM tran_reject tr
    ...  JOIN location l ON (l.location_id=tr.location_id)
    ...  WHERE carrier_id='${carrier.id}'
    ...  AND t_date between ${last_transaction_date.__str__().replace('-','')} and ${last_transaction_date.__str__().replace('-','')};

   ${db_data}   Query To Dictionaries  ${query}

   Set Test Variable  ${db_data}
#   log to console  ${db_data}

Compare Reject Transaction Report Excel Data With Database;

    ${size}  Get List Size  ${db_data}

    FOR  ${i}  IN RANGE  0  ${size}
#    \  log to console  ${db_data[${i}]} ${excel_data[${i}]}
      Should be Equal as Strings  ${db_data[${i}]['date']}  ${excel_data[${i}]['date']}
      Should be Equal as Strings  ${db_data[${i}]['time']}  ${excel_data[${i}]['time']}
      Should be Equal as Strings  ${db_data[${i}]['card_number']}  ${excel_data[${i}]['card_number'].strip()}
      Should be Equal as Strings  ${db_data[${i}]['invoice']}  ${excel_data[${i}]['invoice'].strip()}
      Should be Equal as Numbers  ${db_data[${i}]['location_id']}  ${excel_data[${i}]['location_id']}
      Should Contain  ${db_data[${i}]['location_name']}  ${excel_data[${i}]['location_name']}
      Should be Equal as Strings  ${db_data[${i}]['location_city']}  ${excel_data[${i}]['location_city']}  ignore_case=True
      Should be Equal as Strings  ${db_data[${i}]['state_prov']}  ${excel_data[${i}]['state/prov']}
      Should be Equal as Numbers  ${db_data[${i}]['error_code']}  ${excel_data[${i}]['error_code'].strip()}
      Should be Equal as Strings  ${db_data[${i}]['error_description']}  ${excel_data[${i}]['error_description']}
    END

Check the chain id dropdown '${condition}' CT7 carrier chain id
    ${chainIds}    Get List Items    //select[@name='chainId']
    ${CT7Carrier}  Run Keyword If    '${condition}' == 'has'    List Should Contain Value    ${chainIds}    101 - WEX NAF C STORES
    ...  ELSE    List Should Not Contain Value    ${chainIds}    101 - WEX NAF C STORES

Check the search results '${condition}' CT7 carrier location id
    Get Into DB  TCH
    # Get chaind id 101 location id
    ${nonCT7query}  Catenate  SELECT location_id FROM location WHERE chain_id = '101';
    ${CT7query}  Catenate  SELECT il.location_id
    ...    FROM issr_loc il
    ...    INNER JOIN contract c
    ...    ON il.issuer_id = c.issuer_id
    ...    WHERE c.carrier_id = '${carrier.id}'
    ...    AND il.location_id
    ...    IN (SELECT location_id FROM location WHERE chain_id = '101')
    ...    ORDER BY location_id DESC;
    ${locationId}    Run Keyword If    '${condition}'=='has'    Query And Strip    ${CT7query}
    ...    ELSE    Query And Strip    ${nonCT7query}
    Input Text    name=id    ${locationId}
    Click Button    name=searchLocation
    Run Keyword If    '${condition}'=='has'    Wait Until Element is Visible    //td/a[contains(text(), '${locationId}')]
    ...    ELSE    Wait Until Page Contains    Search Location could not find data.

Select option All for Child Carrier field
    [Documentation]    Select option 'All' from child carrier field

    Click Element    name=parentCarrierIdDoFilter

Check for Valid PDF File
    [Documentation]    Opens and closes the pdf file generated
    ...    filepath is a suite variable from Download Report File

    Open PDF Doc  ${filepath}

Download and Check Report File
    [Documentation]    Download report and check if it will open with no issues

    Download Report File    ${report_name}    pdf
    Check for Valid PDF File

Teardown for Parent Carrier Reject Transaction Report
    [Documentation]  Teardown for Parent Carrier Reject Transaction Report

    Close PDF
    Close Browser
    Remove Report File  ${report_name}