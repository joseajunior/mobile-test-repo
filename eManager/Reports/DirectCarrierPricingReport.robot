*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  String
Library  OperatingSystem  WITH NAME  os
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Setup for FRNT-312
Suite Teardown  Teardown for FRNT-312 Suite

Force Tags  eManager  Reports  Direct Carrier Pricing Report

*** Variables ***
${carrier}
${permission_status}
${report_name}    DirectCarrierPricingReport
${locationId}

*** Test Cases ***
Direct Carrier Pricing eManager Report - Contract ID
    [Tags]  JIRA:FRNT-312  qTest:44922521  JIRA:BOT-2481
    [Documentation]  This is to test if the Direct Carrier Pricing report can be pulled using Contract ID

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Radio Button 'Contract ID';
    Select a Contract ID From The Dropdown;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing eManager Report - Policy Number
    [Tags]  JIRA:FRNT-312  qTest:44922523  JIRA:BOT-2481
    [Documentation]  This is to test if the Direct Carrier Pricing report can be pulled using Policy

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Radio Button 'Policy Number';
    Select a Policy From The Dropdown;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing eManager Report - Card Number
    [Tags]  JIRA:FRNT-312  qTest:44922514  JIRA:BOT-2481
    [Documentation]  This is to test if the Direct Carrier Pricing report can be pulled using card number

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Radio Button 'Card Number';
    Select a Card From Look Up Cards;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing eManager Report - Supplier ID
    [Tags]  JIRA:FRNT-312  qTest:44922520  JIRA:BOT-2481
    [Documentation]  This is to test if the Direct Carrier Pricing report can be pulled using Supplier ID

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Radio Button 'Supplier ID';
    Select a Supplier ID From The Dropdown;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing eManager Report - Chain ID
    [Tags]  JIRA:FRNT-312  qTest:44922518  JIRA:BOT-2481
    [Documentation]  This is to test if the Direct Carrier Pricing report can be pulled using Chain ID

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Radio Button 'Chain ID';
    Select a Chain ID From The Dropdown;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing eManager Report - Location ID
    [Tags]  JIRA:FRNT-312  qTest:44922517  JIRA:BOT-2481
    [Documentation]  This is to test if the Direct Carrier Pricing report can be pulled using Location ID

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Radio Button 'Location ID';
    Insert Location;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing eManager Report - Calendar Test
    [Tags]  JIRA:FRNT-312  qTest:44922513  JIRA:BOT-2481
    [Documentation]  This is to test if the Direct Carrier Pricing report can not have Date Range From Calendar bigger Than 31 Days;

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Date Range From Calendar to be More Than 31 Days;
    Click Submit on Button;
    Validate Calendar Error Message;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing eManager Report - Scheduled Report
    [Tags]  JIRA:FRNT-312  qTest:44925775  JIRA:BOT-2481
    [Documentation]  This is to test if the user is able to get a scheduled report for Direct carrier pricing report

	Log into eManager With Your Carrier;
    Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    Select Radio Button 'Schedule Report';
    Click Submit on Button;
    Schedule Direct Carrier Pricing Report;
    Navigate to Select Program > Scheduled Jobs;
    Validate if Schedule Direct Carrier Pricing Report is Created;

    [Teardown]  Teardown for FRNT-312

Direct Carrier Pricing Report - Restricted chain displayed for CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747396  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are displayed for CT7 carriers in Direct Carrier Pricing Report

	Setup 'a' CT7 Carrier with Direct Carrier Pricing Report Permission
	Log into eManager With Your Carrier;
	Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
	Check the chain id dropdown 'has' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has' CT7 carrier chain id
	Check the search results 'has' CT7 carrier location id

	[Teardown]  Close Browser

Direct Carrier Pricing Report - Restricted chain not displayed for non CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747391  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are not displayed for non CT7 carriers in Direct Carrier Pricing Report

	Setup 'non' CT7 Carrier with Direct Carrier Pricing Report Permission
	Log into eManager With Your Carrier;
	Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Check the search results 'has no' CT7 carrier location id

    [Teardown]  Close Browser

*** Keywords ***
Setup for FRNT-312
    [Documentation]  Keyword Setup for FRNT-312

    Get Into DB  Mysql

#Get user_id from the last 30 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 30;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT member_id FROM member
    ...  WHERE mem_type='C' AND status='A'
    ...  AND member_id IN ${list_2}
    ...  AND member_id NOT IN ('103715','121841')
    ...  AND (SELECT COUNT(*) FROM cards WHERE member_id=carrier_id AND status='A')>0;

    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable  ${carrier}

    Ensure Carrier has User Permission  ${carrier.id}  DIRECT_CARRIER_PRICE_REPORT

Setup '${condition}' CT7 Carrier with Direct Carrier Pricing Report Permission
    [Documentation]  Setup for a/non CT7 carrier with Direct Carrier Pricing Report permission

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
    # Ensure carrier has Direct Carrier Pricing Report permission
    Ensure Carrier has User Permission  ${carrier.id}  DIRECT_CARRIER_PRICE_REPORT

Teardown for FRNT-312
    [Documentation]  Keyword Teardown for FRNT-312

    Remove Report File  ${report_name}

    Close Browser

Teardown for FRNT-312 Suite
    [Documentation]  Keyword Suite Teardown for FRNT-312

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  DIRECT_CARRIER_PRICE_REPORT

Log into eManager with your carrier;
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Manage Cards > View/Update Cards;
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/CardLookup.action

Navigate to Select Program > Reports/Exports > Direct Carrier Pricing Report;
    [Documentation]  Go to Desired Page

    Go To  ${emanager}/cards/DirectCarrierPricingReport.action
    Wait Until Page Contains  Direct Carrier Pricing Report
    Wait Until Element is Visible    //input[@value='Submit']

Select Radio Button 'Schedule Report';
    Click Element  //input[@value='SCHEDULED']

Select Radio Button 'Contract ID';
    Click Element  //input[@value='cId']

Select Radio Button 'Policy Number';
    Click Element  //input[@value='pId']

Select Radio Button 'Card Number';
    Click Element  //input[@value='dNumber']

Select Radio Button 'Supplier ID';
    Click Element  //input[@value='sId']

Select Radio Button 'Chain ID';
    Click Element  //input[@value='chainId']

Select Radio Button 'Location ID';
    Click Element  //input[@value='lId']

Click Button 'Look Up Location';
    Click Element  //input[@name='lookUpLocation']

Select the Location ID and click the 'Look Up Location' button
    Select Radio Button 'Location ID';
    Click Button 'Look Up Location';
    Wait Until Page Contains  Lookup Location

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

Select a Contract ID From The Dropdown;
    Select From List By Index  //select[@id='contractId']  1

Select a Policy From The Dropdown;
    Select From List By Index  //select[@id='policyNumber']  1

Select a Card From Look Up Cards;
    Click Element  //input[@id='lookUpCards']
    Click Element  //table[@id='cardSummary']//td//a[1]

Select a Supplier ID From The Dropdown;
    Select From List By Index  //select[@id='supplierId']  2

Select a Chain ID From The Dropdown;
    Select From List By Index  //select[@id='chainId']  2

Insert Location;
    Input Text  //input[@id='locationId']  ${validLoc}

Select Date Range From Calendar to be More Than 31 Days;
    ${date}  getDateTimeNow  %Y-%m-%d  days=-32
    Input Text  //input[@name='startDate']  ${date}

Download Excel Report File;
    [Documentation]  Keyword to download excel format file

    ${excelFile}  Download Report File  ${Report_Name}  csv

    Set Test Variable  ${excelFile}

Verify if Excel Report is Downloaded;
    [Documentation]  Keyword to check if excel Report is downloaded

    Assert if File is Dowloaded  ${report_name}.csv

Assert Direct Carrier Pricing Report
    [Arguments]  ${report_name}=DirectCarrierPricingReport
    ${report_name}  Split String  ${report_name}  .
    os.File Should Exist  ${default_download_path}${/}*${report_name[0]}*${report_name[1]}
    ${file}  os.List Directory  ${default_download_path}  *${report_name[0]}*.${report_name[1]}
    ${filePath}  os.Normalize Path  ${default_download_path}${/}${file[0]}
    os.File Should Not Be Empty  ${filePath}
    Set Test Variable  ${filePath}

Validate Calendar Error Message;
    Element Should be Visible  //div[@class='errors']//li[contains(text(),'Start and End date allowing a maximum of a 31 day ')]

Schedule Direct Carrier Pricing Report;
    Input Text  //input[@name='jobDescription']  FRNT-312
    Click Element  submitScheduledJob
    Element Should be Visible  //i[contains(text(),"You may also go to 'Scheduled Reports' from your menu to see the status of your report")]

Navigate to Select Program > Scheduled Jobs;
     Go To  ${emanager}/cards/JobList.action

Validate if Schedule Direct Carrier Pricing Report is Created;
     [Arguments]   ${referenceID}=FRNT-312
     Click Element  //*[@id='scheduledJob']//*[@onclick="return handleMesssage('Are you sure you wish to delete this','${referenceID}')"]
     Handle alert

Click Submit on Button;
    Click Element  //input[@value='Submit']