*** Settings ***
Documentation
...  Intent: This suite covers strictly the Card Report in eManager. The report is downloaded and the content
...  is validated in all formats.

Library  otr_robot_lib.ws.CardManagementWS
Library  otr_robot_lib.reports.PyPDF
Library  otr_robot_lib.support.PyLibrary

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags    Reports  Cash Load Report  eManager

*** Variables ***

*** Test Cases ***
Cash Load Report
    [Teardown]  tearddown test
    [Tags]    JIRA:BOT-561  JIRA:BOT-1455  JIRA:BOT-1456  qTest:29094628  qTest:29094632  Regression  qTest:31432004  refactor
    [Documentation]  Make sure one of the cards for the carrier has a Driver Id.

    Set Test Variable  ${card_CashLoadReport}  ${validCard.card_num}

    Set Test Variable  ${contract_id}  11175
    Set Test Variable  ${ENV}  acpt
    Set Test Variable  ${DB}  tch
    Set Test Variable  ${DRID_VALUE}  1234
    Set Test Variable  ${NAME_VALUE}  JOHNDOE

    log into card management web services  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Globalize Current Card Details  ${card_CashLoadReport}

#Ensure That Card Will be Active
    Get Into DB  TCH
    ${sql}  catenate  UPDATE cards SET status='A' WHERE card_num ='7083050910386614554';
    TCH Logging  ${sql}
    Execute Sql String  ${sql}

    ${DRID}=  create dictionary  infoId=DRID  lengthCheck=false  matchValue=${DRID_VALUE}  maximum=0  minimum=0  reportValue=${EMPTY}  validationType=EXACT_MATCH  value=0
    ${NAME}=  create dictionary  infoId=NAME  lengthCheck=false  matchValue=${NAME_VALUE}  maximum=0  minimum=0  reportValue=${NAME_VALUE}  validationType=REPORT_ONLY  value=0
    setCardInfos  ${card_CashLoadReport}  ${FALSE}  ${DRID}  ${NAME}
    Tch Logging  \n PROMPTS SET FOR ${card_CashLoadReport} - DRID AND NAME.

    Tch Logging  \n INITIATING TEST
    Initiate Test
#   LOAD A CASH WITH AN SPECIFIC REFERENCE NUMBER, THAT WILL BE USED ON THE CASH LOAD REPORT SCREEN
    Tch Logging  \n OPENING EMANAGER
    Open eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To  ${emanager}/cards/CardLookup.action?returnPage=/CashAdvanceManagement.action&returnPageParamPrefix=card.
    Click Element  //*[@name='lookupInfoRadio' and @value='NUMBER']
    Input Text  cardSearchTxt  ${card_CashLoadReport}
    Click Button  searchCard
    ${DriverName}  get text  //*[@id="cardSummary"]/tbody/tr/td[contains(text(), 'JOHNDOE')]
    Set Global Variable  ${DriverName}
    Click Element  //table[@id="cardSummary"]//td[contains(text(), 'Active')]/parent::tr/td/a
    Input Text  amount  100
    ${reference}  Generate Random String  6  [NUMBERS]
    Set Global Variable  ${reference}
    Input Text  reference  ${reference}
    Click Button   processCashAdvance
    Tch Logging   \n LOADING 100 ON CARD ${card_CashLoadReport}.
#   GO TO CASH LOAD REPORT
    Tch Logging  \n GOING TO CASH LOAD REPORT AND DOWNLOADING CASH LOAD REPORT BASED ON THE REFERENCE AND DATE
    Go To  ${emanager}/cards/CashLoadReport.action
#    SELECT PARAMETERS TO THE REPORT
    Click Element  //*[@name="scheduleImmediateRadio" and @value="IMMEDIATE"]
    ${today}  getdatetimenow  %Y-%m-%d
    Input Text  startDate  ${today}
    Input Text  endDate  ${today}
    Input Text  refNum  ${reference}
    Select From List By Value  contractId  ${contract_id}
    Select From List By Value  viewFormat  2
#    Click Button  viewReport
    Tch Logging  \n DOWNLOADING FILE NOW
    Download Report
    Check Cash Load Report

*** Keywords ***
TeardDown test
    close pdf
    #    WE WANT A COPY OF THIS REPORT IN CASE THE SUITE FAILS OR FOR FUTURE REFERENCE.
    os.move file  ${filePath}  ${REPORTSDIR}
    ${newFilePath}=  os.normalize path  ${REPORTSDIR}
    tch logging  \nFile moved to:\n\t${newFilePath}  INFO

Suite Teardown
    reset card  ${card_CashLoadReport}
    close browser

Initiate Test
    get into db  ${DB}  ${ENV}

    @{files}=  os.list directory  ${default_download_path}  *CashLoadReport*
    FOR  ${i}  IN  @{files}
       ${file}=  os.normalize path  ${default_download_path}/${i}
       tch logging  Permanently removing ${file}  WARN
       os.remove file  ${default_download_path}/${i}
    END

Download Report
    click Button  viewReport
    wait until page does not contain element  //*[contains(text(), "Please wait while your document is loading ...")]  60
    open new window  text=Click here to view the document
    sleep  0.1
    FOR  ${i}  IN RANGE  0  1000
       tch logging  alo ${i}
       ${status}=  run keyword and return status  os.file should exist  ${default_download_path}//*CashLoadReport*.pdf
       exit for loop if  ${status}==${True}
       sleep  0.01
       run keyword if  ${i}==999  run keywords
       ...  tch logging  Cash Load Report did not download to ${default_download_path}.  ERROR  AND
       ...  close window  AND
       ...  select window  main  AND
       ...  fail  Cash Load Report did not download.
    END
    close window
    select window  main

Check Cash Load Report
    Set Test Variable  ${card_num}  ${card_CashLoadReport}
    Set Test Variable  ${ReferenceRow}  ${DriverName}
    Set Test Variable  ${PromptValue}  ${DRID_VALUE}

#    CHECK THAT THE FILE EXISTS IN THE DOWNLOADS DIRECTORY
    ${fileExists}=  os.file should exist  ${default_download_path}${/}*CashLoadReport*
    Tch Logging  \n FILE EXISTS IN THE DIRECTORY
#    THERE SHOULD ONLY BE ONE FILE WITH "CashLoadReport" IN ITS NAME SINCE "INITIATE TEST"
#    DELETED ALL OF THE OTHER ONES IN THE DOWNLOADS DIRECTORY. SO, GET THE ENTIRE FILE NAME...
    ${file}=  os.list directory  ${default_download_path}  *CashLoadReport*.pdf
    Tch Logging  \n FILE IS IN ${default_download_path} DIRECTORY
#    ... NORMALIZE THE PATH WITH APPROPRIATE SEPARATORS AND SUCH ...
    ${filePath}=  os.normalize path  ${default_download_path}${/}${file[0]}
    set global variable  ${filePath}
    tch logging  Opening this file: \n\t${filepath}  INFO

#    ... AND OPEN THE PDF USING THE ABSOLUTE PATH TO THE FILE.
    open pdf doc  ${filePath}
    Tch Logging  \n FILE OPENED

#    UNCOMMENT THESE LINES TO GET THE COORDINATES OF EVERY TEXT ON THE FIRST PAGE OF THE PDF. THIS IS
#    USEFUL FOR IDENTIFYING HOW THE EXTRACTOR SEES THE PDF AND HOW YOU CAN PARSE THROUGH IT.

#    ${report}=  get raw pdf layout
#    print raw pdf

#    GET THE COORDINATES OF THE FIRST AND SECOND CHECK NUMBER...
    ${coordOfFirst}=  get pdf text coordinates  ${ReferenceRow}

#    ... GET THE ROW THAT THOSE CHECKS ARE ON...
    Tch Logging  GET THE ROW THAT THE CASH LOAD IS ON
#    Sleep  2
#    ${pdfRow1}=  get row from pdf  ${coordOfFirst[1].row}  separator=${SPACE}
    ${pdfRow}  get from dictionary  ${coordOfFirst[1]}  row
    Tch Logging  PDFROW:${pdfRow}
    ${pdfRow1}=  get row from pdf  ${pdfRow}  separator=${SPACE}
    Tch Logging  PDFROW:${pdfRow1}

    ${cadv_query}  catenate  SELECT * FROM cash_adv WHERE card_num='${card_CashLoadReport}' AND ref_num='${reference}'
    ${results_cadv}  Query And Strip To Dictionary  ${cadv_query}
    ${results_cadv.ref_num}  Strip String  ${results_cadv.ref_num}
    ${results_cadv.card_num}  Strip String  ${results_cadv.card_num}
    ${results_cadv.who}  Strip String  ${results_cadv.who}

    should be equal as strings  ${ReferenceRow}  ${pdfRow1[0]}
    should be equal as strings  ${PromptValue}  ${pdfRow1[1]}
    should be equal as strings  ${results_cadv.ref_num}  ${pdfRow1[2]}
    should be equal as numbers  ${results_cadv.card_num}  ${pdfRow1[3]}
    should be equal as strings  ${results_cadv.id}  ${pdfRow1[5]}
    should be equal as strings  ${results_cadv.when}  ${SPACE.join(['${pdfRow1[6]}','${pdfRow1[7]}'])}:00
    should be equal as strings  ${results_cadv.amount}  ${pdfRow1[8]}
    should be equal as strings  ${results_cadv.who}  ${pdfRow1[9]}

    Tch Logging  \n ALL DATA FROM CADV TABLE MATCHES THE CASH LOAD REPORT!
