*** Settings ***
Documentation
...  = DATA NEEDED =
...  - DB: Database instance
...  - carrier: Carrier ID
...
...  = TEST SETUP =
...  - None
...
...  = TEST STEPS =
...  - Log in as the carrier in eManager
...  - Go to _Select Program > Reports/Exports > Transaction Export_
...  - Establish filters and submit the report
...  - If not scheduling a report, open the report and verify that
...  | all the data is filtered properly.
...
...  = TEARDOWN =
...  - Disconnect the database


Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  String
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyExcel
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Suite Setup  Start Suite
Test Teardown  End Test

Force Tags  eManager  Reports

*** Variables ***
# STATICALLY DEFINED VARIABLES
${DB}
${carrier}

# DYNAMICALLY DEFINED VARIABLES
${emanager}
${today}
@{filteredItems}

*** Test Cases ***
EFS Transaction Export
    [Tags]  JIRA:BOT-467  qTest:29085060  qTest:35245194  qTest:31876270  Regression  refactor  tier:0

    set test variable  ${DB}  TCH
    set test variable  ${carrier}  ${card_number.carrier.id}

    Initiate Test
    ${query}=  catenate
    ...  SELECT card_num,
    ...         location_id,
    ...         contract_id,
    ...         TRIM(TO_CHAR(trans_date,"%Y-%m-%d")) AS trans_date
    ...  FROM transaction
    ...  WHERE card_num = '${card_number.card_num}'
    ...  AND trans_date > '${year_past}${month_day} 00:00'
    ...  ORDER BY trans_date desc
    ...  LIMIT 1;
    ${filterData}=  query and strip to dictionary  ${query}
    Go To Transaction Export
    Enter Date Range  ${filterData.trans_date}  ${filterData.trans_date}
    Select Contract  ${card_number.policy.contract.id}
    Select Report Format  Excel Format
    Match By Card Number  ${card_number.card_num}
    Match By Location ID  ${filterData.location_id}
    Submit and Download Report
    Check Transaction Export In Excel

Transaction Export Report - Restricted chain displayed for CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747462  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are displayed for CT7 carriers in Transaction Export Report

	Setup 'a' CT7 Carrier with Transaction Export Report Permission
	Log Carrier into eManager with Transaction Export Report permission
	Go to Select Program > Reports/Exports > Transaction Export Report
	Check the main screen chain id dropdown 'has' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has' CT7 carrier chain id
	Check the search results 'has' CT7 carrier location id

	[Teardown]  Close Browser

Transaction Export Report - Restricted chain not displayed for non CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747459  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are not displayed for non CT7 carriers in Transaction Export Report

	Setup 'non' CT7 Carrier with Transaction Export Report Permission
	Log Carrier into eManager with Transaction Export Report permission
	Go to Select Program > Reports/Exports > Transaction Export Report
	Check the main screen chain id dropdown 'has no' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Check the search results 'has no' CT7 carrier location id

	[Teardown]  Close Browser

*** Keywords ***
Start Suite
    ${today}=  GetDateTimeNow  %Y-%m-%d
    ${month_day}=  GetDateTimeNow  -%m-%d
    ${year}=  GetDateTimeNow  %Y
    ${year_past}  evaluate  ${year} - 2
    Set Suite Variable  ${year_past}
    Set Suite Variable  ${month_day}

    Get Into DB  TCH
     ${query}  CATENATE  SELECT c.card_num AS card_num FROM cards c,
    ...    transaction t
    ...    WHERE c.card_num LIKE '708305%'
    ...    AND c.card_num NOT LIKE '%OVER'
    ...    AND t.card_num=c.card_num
    ...    AND t.trans_date > '${year_past}${month_day} 00:00'
    ...    AND c.card_type = 'TCH' LIMIT 100
    ${card_number}  Find Card Variable  ${query}
    Set Suite Variable  ${card_number}
    Set Suite Variable  ${today}
    Set Suite Variable  ${year}

Initiate Test
#    OPEN DB CONNECTION
    Get Into Db  ${DB}

#    IF ANY TRANSACTION EXPORT REPORT EXISTS IN THE DOWNLOADS DIRECTORY, THEN DELETE THEM ALL.
    @{files}=  os.list directory  ${default_download_path}  *transexport*
    FOR  ${i}  IN  @{files}
       os.remove file  ${default_download_path}/${i}
       tch logging  Permanently removing ${default_download_path}/${i}  WARN
    END

    Open eManager  ${card_number.carrier.id}  ${card_number.carrier.password}

End Test
#    UNPLUG EVERYTHING
    Disconnect From Database


Go To Transaction Export
    Go To  ${emanager}/cards/Transaction.action?outputMode=export
    ${status}  Run Keyword And Return Status  Wait Until Page Contains Element  //*[@for="transaction.title.legend.export"]  timeout=30
    Run Keyword IF  '${status}'=='${true}'  Tch Logging  You're inside the Transaction Export Screen
    ...  ELSE  Go To  ${emanager}/cards/Transaction.action?outputMode=export
    ...  AND  Wait Until Page Contains Element  //*[@for="transaction.title.legend.export"]  timeout=30
    Page should Contain Element  //*[@for="transaction.title.legend.export"]

Select Schedule Report
    Click On  scheduleImmediateRadio

Enter Date Range
    [Arguments]  ${startDate}  ${endDate}

#    DATE FORMAT MUST BE YYYY-mm-dd
    Input Text  transFilter.begDate  ${startDate}
    Input Text  transFilter.endDate  ${endDate}

Select Currency
    [Arguments]  ${currency}

#    INSPECT THE VALUES ON THIS DROPDOWN, NOT THE LABELS
    Select From List By Value  currency  ${currency}

Select Contract
    [Arguments]  ${contract}

    Unclick Radio Button  allContract
    Click On  ${contract.__str__()}
    Append To List  ${filteredItems}  ContractId=${contract}

Select Report Format
    [Arguments]  ${format}

#    FORMAT IS IDENTIFIED BY THE VISIBLE TEXT IN THE LIST
    select from list by label  exportFormat  ${format}

Match By Billing Invoice
    [Arguments]  ${invoice}

    click radio button  transFilter.statementId.doFilter
    input text  transFilter.statementId.value  ${invoice}

Match By Card Number
    [Arguments]  ${card}

#    INPUTTING THE CARD NUMBER IN THE FIELD WAS BROKEN WHEN THIS WAS CREATED.
#    THE WORKAROUND IS TO SEARCH FOR THE CARD NUMBER.

    Click Radio Button  transFilter.card.doFilter
    Click On  lookUpCards
    Input Text  cardSearchTxt  ${card}
    Click On  searchCard
    Click On  text=${card}
    Append To List  ${filteredItems}  CardNumber=${card}

Match By Location ID
    [Arguments]  ${location}

    Click Radio Button  transFilter.location.doFilter
    Input Text  locationId  ${location}
    Append To List  ${filteredItems}  LocationId=${location}

Match By Driver Name
    [Arguments]  ${name}

    Click Radio Button  transFilter.driver.doFilter
    Input Text  transFilter.driver.value  ${name}
    Append To List  ${filteredItems}  DriverName=${name}

Match By Driver ID
    [Arguments]  ${drid}

    Click Radio Button  transFilter.drid.doFilter
    Input Text  transFilter.drid.value  ${drid}
    Append To List  ${filteredItems}  DriverId=${drid}

Match By Unit
    [Arguments]  ${unit}

    Click Radio Button  transFilter.unit.doFilter
    Input Text  transFilter.unit.value  ${unit}
    Append To List  ${filteredItems}  Unit=${unit}

Match By Invoice
    [Arguments]  ${invoice}

    Click Radio Button  transFilter.invoice.doFilter
    Input Text  transFilter.invoice.value  ${invoice}
    Append To List  ${filteredItems}  Invoice=${invoice}

Match By Subfleet
    [Arguments]  ${subFleet}

    Click Radio Button  transFilter.subFleet.doFilter
    Input Text  transFilter.subFleet.value  ${subFleet}
    Append To List  ${filteredItems}  SubFleet=${subFleet}

Submit and Download Report
    Click On  Submit
    Check Element Is Null  text=Please wait while your document is loading  exactMatch=${False}  timeout=20
    Open New Window  text=Click here to view the document
    Sleep  2
#    CHECK THAT THE FILE EXISTS IN THE DOWNLOADS DIRECTORY
    os.file should exist  ${default_download_path}${/}*transexport*
    Tch Logging  \n\TRANSACTION EXPORT SUCCESSFULLY DOWNLOADED.  INFO
    Close Window
    Select Window  main

Submit and Schedule Report
    [Arguments]  ${frequency}  ${description}=${None}  ${email}=${None}

#    TODO

    [Return]

Check Transaction Export In Excel
#    THERE SHOULD ONLY BE ONE FILE WITH "MoneyCodeUserReport" IN ITS NAME SINCE "INITIATE TEST"
#    DELETED ALL OF THE OTHER ONES IN THE DOWNLOADS DIRECTORY. SO, GET THE ENTIRE FILE NAME...
    ${file}=  os.list directory  ${default_download_path}  *transexport*.xls

#    WE WANT A COPY OF THIS REPORT IN CASE THE SUITE FAILS OR FOR FUTURE REFERENCE. SO MOVE IT TO
#    THE REPORTS DIRECTORY.
    ${filePath}=  os.normalize path  ${default_download_path}${/}${file[0]}
    ${dateTime}=  getdatetimenow  %Y%m%d%H%M%S
    os.move file  ${filePath}  ${CURDIR}\\${REPORTSDIR}\\${file[0][:-4]}_${dateTime}.xls
    ${newFilePath}=  os.normalize path  ${CURDIR}\\${REPORTSDIR}\\${file[0][:-4]}_${dateTime}.xls
    tch logging  \nFile moved to:\n\t${newFilePath}  INFO

#   OPEN THE EXCEL FILE AND RETRIEVE THE DATA
    tch logging  \nOpening this file: ${newFilePath}  INFO
    ${excelTable}=  Put Excel to Dictionary  ${newFilePath}
    print dictionary  ${excelTable}
    set global variable  ${excelTable}

#    CHECK THE FILTERS
    Validate That The Report Filtered Correctly

Validate That The Report Filtered Correctly
#    FOR EVERY FILTERED ITEM IN THE REPORT, VERIFY THAT THE FILTER WORKED.
    FOR  ${item}  IN  @{filteredItems}
       tch logging  \n\tCHECKING FILTERED ITEM: ${item}  INFO
       ${key}  ${value}  split string  ${item}  =
#    IF THIS FILTER IS THE CONTRACT ID, THEN MAKE SURE ALL OF THE TRANSACTION IDs ARE TIED
#    TO THE SAME CONTRACT ID.
       run keyword if  '${key}'=='ContractId'  run keywords
       ...  row count is 0
       ...  SELECT unique contract_id FROM transaction WHERE trans_id in ('${EMPTY+"','".join(${excelTable.TransactionId})}') AND contract_id <> ${value}
       ...  AND
       ...  continue for loop
#    IF THIS FILTER IS NOT ONE OF THE ABOVE SCENARIOS, THEN MAKE A COPY OF THE LIST (SO AS
#    TO NOT DISTORT THE ORIGINAL DATA) AND REMOVE THE FILTERED VALUE FROM THE COLUMN. IF
#    THE COLUMN IS EMPTY, THEN THE FILTER WORKED PROPERLY. OTHERWISE, SOMETHING LEAKED IN.
       ${values}=  copy list  ${excelTable.${key}}
       remove values from list  ${values}  ${value}  ${empty}
       should be empty  ${values}
       ...  msg=Expected report to be filtered by ${key} with the values ${value}, but these values were also found:\n${\\n.join(set(${values}))}
    END
Put Excel to Dictionary
    [Arguments]  ${filePath}  ${sheetIndex}=0

    os.file should exist  ${filePath}
    open excel  ${filePath}
    ${sheets}=  get sheet names
    ${columns}=  get column count  ${sheets[${sheetIndex}]}
    ${index}=  evaluate  0
    ${excelTable}=  create dictionary
#    FOR EVERY COLUMN ON THIS SHEET CONTAINING DATA, MODIFY THE DICTIONARY "excelTable" TO
#    HAVE KEY=TOP ROW (ASSUMING THAT IS THE HEADER ROW) AND VALUE=list(ALL VALUES IN THAT
#    COLUMN).
    FOR  ${column}  IN RANGE  0  ${columns}
       ${data}=  get column values  ${sheets[${sheetIndex}]}  ${column}
       continue for loop if  '${data[0][1]}'=='${EMPTY}'
       ${values}=  evaluate  [x[1] for x in ${data[1:]}]
       set to dictionary  ${excelTable}
       ...  ${data[0][1]}=${values}
    END
    [Return]  ${excelTable}

Setup '${condition}' CT7 Carrier with Transaction Export Report Permission
    [Documentation]  Setup for a/non CT7 carrier with Transaction Export permission

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
    # Ensure carrier has Transaction Export Report permission
    Ensure Carrier has User Permission  ${carrier.id}  TRANSACTION_EXPORT

Log Carrier into eManager with Transaction Export Report permission
    [Documentation]  Log carrier into eManager with Transaction Export Report permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Reports/Exports > Transaction Export Report
    [Documentation]  Go to Select Program > Reports/Exports > Transaction Export Report

    Go To  ${emanager}/cards/Transaction.action?outputMode=export
    Wait Until Page Contains    Match By (Optional):

Select the Location ID
    Click Element    //input[@name="transFilter.location.doFilter"]

Click Look Up Location button
    Click Button    name=lookUpLocation

Select the Location ID and click the 'Look Up Location' button
    Select the Location ID
    Click Look Up Location button
    Wait Until Page Contains  Search Location Type

Check the CT7 carrier chain id
    [Arguments]    ${condition}    ${chainIds}
    Run Keyword If    '${condition}' == 'has'    List Should Contain Value    ${chainIds}    101 - WEX NAF C STORES
    ...  ELSE    List Should Not Contain Value    ${chainIds}    101 - WEX NAF C STORES

Check the main screen chain id dropdown '${condition}' CT7 carrier chain id
    ${chainIds}    Get List Items    //select[@name="transFilter.chainId.value"]
    Check the CT7 carrier chain id    ${condition}    ${chainIds}

Check the chain id dropdown '${condition}' CT7 carrier chain id
    ${chainIds}    Get List Items    //select[@name='chainId']
    Check the CT7 carrier chain id    ${condition}    ${chainIds}

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