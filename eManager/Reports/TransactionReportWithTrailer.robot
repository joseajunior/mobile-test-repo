*** Settings ***
Documentation
...  Run a transaction that includes a TRLR prompt and validate that it
...  appears in the Transaction Report With Trailer report.


Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyPDF
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot

Test Teardown  End Test

Force Tags  eManager  Reports

*** Variables ***
${DB}
${card}

*** Test Cases ***
Transaction Report With Trailer Number
    [Tags]  JIRA:BOT-1760  qTest:35241370  qTest:31883165  BUGGED:Trailer number in numeric format displays only 6 digits in transaction report.
    set test variable  ${DB}  TCH
    set test variable  ${card}  ${validCard.num}

#    PREPARE THE TEST FOR SUCCESS
    Initiate Test
#    RUN A TRANSACTION WITH A TRAILER NUMBER (TRLR SET UP IN "Initiate Test")
    Run Transaction  ${validCard.valid_location}
    ${invoice}=  Get Invoice From Transaction
    set test variable  ${invoice}
    tch logging  \n\tINVOICE NUMBER: ${invoice}  INFO
#    ONLY RUN A REPORT BASED ON THIS SINGULAR TRANSACTION
    Download Transaction Report With Trailer By Invoice
#    VALIDATE THE THE COLUMN "Trailer #" HAS THE RIGHT DATA.
    Check Report

Transaction Report With Trailer - Restricted chain displayed for CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747563  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are displayed for CT7 carriers in Transaction Report With Trailer

	Setup 'a' CT7 Carrier with Transaction Report With Trailer Permission
	Log Carrier into eManager with Transaction Report With Trailer permission
	Go to Select Program > Reports/Exports > Transaction Report With Trailer
	Check the main screen chain id dropdown 'has' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has' CT7 carrier chain id
	Check the search results 'has' CT7 carrier location id

	[Teardown]  Close Browser

Transaction Report With Trailer - Restricted chain not displayed for non CT7 carrier
    [Tags]  JIRA:FRNT-1968  JIRA:FRNT-1981  qTest:54747560  JIRA:BOT-3647
    [Documentation]  Ensure restricted locations are not displayed for non CT7 carriers in Transaction Report With Trailer

	Setup 'non' CT7 Carrier with Transaction Report With Trailer Permission
	Log Carrier into eManager with Transaction Report With Trailer permission
	Go to Select Program > Reports/Exports > Transaction Report With Trailer
	Check the main screen chain id dropdown 'has no' CT7 carrier chain id
	Select the Location ID and click the 'Look Up Location' button
	Check the chain id dropdown 'has no' CT7 carrier chain id
	Check the search results 'has no' CT7 carrier location id

	[Teardown]  Close Browser

*** Keywords ***
Initiate Test
#    OPEN DB CONNECTION
    get into db  ${DB}

#    GET CARRIER LOGIN DATA
    ${query}=  catenate
    ...  select m.member_id, m.passwd from member m, cards c
    ...  where m.member_id = c.carrier_id and c.card_num = '${card}'

    ${member}=  query and strip to dictionary  ${query}

    set test variable  ${member}

#    IF ANY MONEY CODE USE REPORT EXIST IN THE DOWNLOADS DIRECTORY, THEN DELETE THEM ALL.
    @{files}=  os.list directory  ${default_download_path}  *TransactionReportQuickway*
    print list  @{files}
    FOR  ${i}  IN  @{files}
        tch logging  Permanently removing ${default_download_path}/${i}  WARN
        os.remove file  ${default_download_path}/${i}
    END

    start setup card  ${card}
    setup card header  status=ACTIVE  infoSource=CARD
    setup card prompts  TRLR=N

#    NEED TO GO SUDO TO ACCESS FOLDERS IN QAAUTO
    go sudo

#    NEED DATE AND TIME IN ORDER TO CREATE UNIQUE LOG FILE NAMES.
    ${date}=  getdatetimenow  %Y%m%d
    ${date}=  get substring  ${date}  2
    ${time}=  getdatetimenow  %H%M%S
    ${month}=  getdatetimenow  %m

    ${logfile}=  create log file  TransReport
    set test variable  ${logfile}
    set test variable  ${date}
    set test variable  ${time}

End Test
#    UNPLUG EVERYTHING


Run Transaction
    [Arguments]  ${location}

#    JUST A BASIC TRANSACTION. NEED A TRLR NUMBER IN THE REPORT.
    ${ac}=  create ac string  ${DB}  ${location}  ${card}  ULSD=1.00
    tch logging  \n\tAC STRING: ${ac}  INFO
    run rossAuth  ${ac}  ${logfile}

Get Invoice From Transaction
    ${transId}=  get transaction id from log file  ${logfile}
    ${invoice}=  query and strip  select invoice from transaction where trans_id = ${transId}

    [Return]  ${invoice}

Download Transaction Report With Trailer By Invoice
#    DOWNLOAD THE TRANSACTION REPORT WITH TRAILER FOR A DATE RANGE OF TODAY AS A PDF.
    open emanager  ${validCard.carrier.id}  ${validCard.carrier.password}
    go to  ${emanager}/cards/Transaction.action?outputMode=trailer
    ${today}=  getdatetimenow  %Y-%m-%d %H:%M:%S
    input text  transFilter.begDate  ${today}
    input text  transFilter.endDate  ${today}
    select from list by label  viewFormat  PDF
#    FILTER THE REPORT BY THE ONE INVOICE NUMBER
    click radio button  transFilter.invoice.doFilter
    input text  transFilter.invoice.value  ${invoice}
    click on  Submit
    open new window  text=Click here to view the document  timeout=60
#    SLEEP TO ALLOW THE FILE TO DOWNLOAD
    sleep  3
    close window
    select window  main
    close browser

Check Report
#    CHECK THAT THE FILE EXISTS IN THE DOWNLOADS DIRECTORY
    ${fileExists}=  os.file should exist  ${default_download_path}${/}*TransactionReportQuickway*

#    THERE SHOULD ONLY BE ONE FILE WITH "MoneyCodeUserReport" IN ITS NAME SINCE "INITIATE TEST"
#    DELETED ALL OF THE OTHER ONES IN THE DOWNLOADS DIRECTORY. SO, GET THE ENTIRE FILE NAME...
    ${file}=  os.list directory  ${default_download_path}  *TransactionReportQuickway*.pdf

#    ... NORMALIZE THE PATH WITH APPROPRIATE SEPARATORS AND SUCH ...
    ${filePath}=  os.normalize path  ${default_download_path}${/}${file[0]}
    tch logging  Opening this file: \n\t${filepath}  INFO

#    ... AND OPEN THE PDF USING THE ABSOLUTE PATH TO THE FILE.
    open pdf doc  ${filePath}

#    WE WANT A COPY OF THIS REPORT IN CASE THE SUITE FAILS OR FOR FUTURE REFERENCE.
#    os.move file  ${filePath}  ${REPORTSDIR}\\${file[0]}
#    ${newFilePath}=  os.normalize path  ${REPORTSDIR}\\${file[0]}
#    tch logging  \nFile moved to:\n\t${newFilePath}  INFO

#    UNCOMMENT THESE LINES TO GET THE COORDINATES OF EVERY TEXT ON THE FIRST PAGE OF THE PDF. THIS IS
#    USEFUL FOR IDENTIFYING HOW THE EXTRACTOR SEES THE PDF AND HOW YOU CAN PARSE THROUGH IT.

#    SETUP THE REPORT FROM TOP TO BOTTOM
    get raw pdf layout  sort_by=row  sort_reversed=${True}

#     UNCOMMENT THIS TO VIEW THE ENTIRE PDF
#    print raw pdf

#    TRLR NUMBER, CREATED BY pyLibrary.getRequiredPrompts, IS DEFINED BY TODAY'S DATE
    ${trailer}=  getdatetimenow  %Y%m%d

#    GET THE COORDINATES OF THE "Trailer #" COLUMN AND THE ROW WITH THE INVOICE NUMBER.
    ${row}=  get pdf text coordinates  ${invoice.strip()}
    ${column}=  get pdf text coordinates  Trailer #
    ${pdfTrailer}=  get pdf table by coordinates
    ...  top=${row[1].row}
    ...  bottom=${row[1].row}
    ...  right=${column[1].column}
    ...  left=${column[1].column}
    tch logging  \n\tTRAILER NUMBER ACCORDING TO THE PDF: ${pdfTrailer[0]}  INFO
    should be equal as strings  ${pdfTrailer[0]}  ${trailer}

    close pdf

Setup '${condition}' CT7 Carrier with Transaction Report With Trailer Permission
    [Documentation]  Setup for a/non CT7 carrier with Transaction Report With Trailer permission

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
    # Ensure carrier has Transaction Report With Trailer permission
    Ensure Carrier has User Permission  ${carrier.id}  TRANS_REPORT_TRAILER

Log Carrier into eManager with Transaction Report With Trailer permission
    [Documentation]  Log carrier into eManager with Transaction Report With Trailer permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Reports/Exports > Transaction Report With Trailer
    [Documentation]  Go to Select Program > Reports/Exports > Transaction Report With Trailer

    Go To  ${emanager}/cards/Transaction.action?outputMode=trailer
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