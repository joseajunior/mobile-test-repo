*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  String
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyPDF
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Documentation  Pull a Money Code Use Report for a shell carrier.
...  Check if the info on mon_code and code_use are the same as it shows on PDF

Suite Teardown  Close Browser

Force Tags  eManager

*** Variables ***
${logfile}
${DB}
${log_dir}
${firstCode_id}

*** Test Cases ***
Money Code Use Report - Shell Carrier
    [Tags]  JIRA:BOT-234  refactor
    set test variable  ${contract_id}  19
    set test variable  ${shellcar_id}  400004
    set test variable  ${shellpasswd}  JW7O0N
    set test variable  ${amount}  300
    Issue Money Code
    Authorize Money Code
    Download Money Code Use Report
    Check MoneyCode Use Report

*** Keywords ***
Issue Money Code

    open emanager  ${shellcar_id}  ${shellpasswd}
    maximize browser window
    go to  ${emanager}/cards/MoneyCodeManagement.action
    Input Text    name=moneyCode.amount    ${amount}
    Input Text    name=moneyCode.issuedTo    BOT234
    Input Text    name=moneyCode.notes   this time is for realz
    Click Element    name=submit
    ${monCode}=  get text  //*[@class="messages"]//parent::li//descendant::*[1]
    set global variable  ${monCode}
    tch logging  MoneyCode:${monCode}
    ${firstCode_id}=  get text  //*[@class="messages"]//parent::li//descendant::*[3]
    set global variable  ${firstCode_id}
    tch logging  Money Code Issued Successfully!

Authorize Money Code
    ${validCheck} =  createCheck
    set global variable  ${validCheck}
    tch logging  CheckNum:${validCheck}
    sleep  2
    go to  https://test.efsllc.com/mgnt/CheckAuthorization.action

#Click on Security Pop Up
    ${passed}  Run Keyword And Return Status  Element Should Be Visible  //*[@class="ui-button-icon-primary ui-icon ui-icon-closethick"]
    Run Keyword if  ${passed}
    ...  Click Element  //*[@class="ui-button-icon-primary ui-icon ui-icon-closethick"]

    input text  name=checkNumber  ${validCheck}
    input text  name=dollarAmount  50
    click button  name=nextToCheckLocationPage
    input text  name=locationId  ${validLoc}
    input text  name=payee  BOT234
    input text  name=moneyCode  ${monCode}
    click button  name=submit
    click button  finish
    tch logging  Money Code Authorized Successfully!

Download Money Code Use Report
    go to  ${emanager}/cards/MoneyCodeUseReport.action
    ${yesterday}=  getdatetimenow  %Y-%m-%d  days=-1
    set global variable  ${yesterday}
    ${today}=  getdatetimenow  %Y-%m-%d
    set global variable  ${today}
    input text  startDate  ${yesterday}
    input text  endDate  ${today}
    Click Element  //*[@onclick="handleDisable(checkShow, checkNumber)" and @name="checkShow"]
    input text  name=checkNumber  ${validCheck}
    select from list by label  viewFormat  PDF
    click on  Submit
    open new window  text=Click here to view the document  timeout=60
    sleep  3
    close window
    select window  main
    tch logging  Money Code Downloaded Successfully!
    Close Browser

Initiate Test
    [Arguments]  ${DB}

#    I LIKE TO PRINT A NEWLINE TO START. NOT NECESSARY.
    log to console  ${empty}

#    OPEN DB CONNECTION
    get into db  ${DB}

#    IF ANY MONEY CODE USE REPORT EXIST IN THE DOWNLOADS DIRECTORY, THEN DELETE THEM ALL.
    @{files}=  os.list directory  ${default_download_path}  *TransactionReport*
    print list  @{files}
    FOR  ${i}  in  @{files}
       tch logging  Permanently removing ${default_download_path}/${i}  WARN
       os.remove file  ${default_download_path}/${i}
    END

Check MoneyCode Use Report
#    CHECK THAT THE FILE EXISTS IN THE DOWNLOADS DIRECTORY
    ${fileExists}=  os.file should exist  ${default_download_path}${/}*MoneyCodeUseReport*

#    THERE SHOULD ONLY BE ONE FILE WITH "MoneyCodeUserReport" IN ITS NAME SINCE "INITIATE TEST"
#    DELETED ALL OF THE OTHER ONES IN THE DOWNLOADS DIRECTORY. SO, GET THE ENTIRE FILE NAME...
    ${file}=  os.list directory  ${default_download_path}  *MoneyCodeUseReport*.pdf

#    ... NORMALIZE THE PATH WITH APPROPRIATE SEPARATORS AND SUCH ...
    ${filePath}=  os.normalize path  ${default_download_path}${/}${file[0]}
    tch logging  Opening this file: \n\t${filepath}  INFO

#    ... AND OPEN THE PDF USING THE ABSOLUTE PATH TO THE FILE.
    open pdf doc  ${filePath}

#    UNCOMMENT THESE LINES TO GET THE COORDINATES OF EVERY TEXT ON THE FIRST PAGE OF THE PDF. THIS IS
#    USEFUL FOR IDENTIFYING HOW THE EXTRACTOR SEES THE PDF AND HOW YOU CAN PARSE THROUGH IT.
#
#    ${report}=  get raw pdf layout
#    print raw pdf

#    GET THE COORDINATES OF THE FIRST CODE ID = REF#...
    ${coordOfFirst}=  get pdf text coordinates  ${firstCode_id}
    ${filterRow}  get from dictionary  ${coordOfFirst[1]}  row

#   GET THE ROW THAT CODE IDS ARE ON
    ${pdfRow}=  get row from pdf  ${filterRow}  separator=${SPACE}

     get into db  shell
    ${query}=  catenate
     ...  SELECT u.code_use_id, m.code_id, trim(m.payee_name) AS payee_name,
     ...  case m.voided when 'N' then 'No' else 'Yes' end AS voided,
     ...  m.created, m.issued_to, u.check_num, m.who,
     ...  c.currency, case cm.one_time_use_codes when 'Y' then 'Yes' else 'No' end AS one_time_use,
     ...  case cm.exact_amt_codes when 'Y' then 'Yes' else 'No' end as exact_amt
     ...  FROM mon_codes m, contract c, code_use u, cont_misc cm,  issuer_type i
     ...  WHERE  m.carrier_id = c.carrier_id AND m.contract_id = c.contract_id
     ...  AND  c.issuer_id = i.issuer_id
     ...  AND  c.carrier_id = ${shellcar_id} AND m.express_code ='${monCode}'
     ...  AND c.contract_id = ${contract_id} AND m.code_id = u.code_id
     ...  ORDER BY u.code_use_id DESC limit 1
     ${results}=  query and strip to dictionary  ${query}

    ${stripped.voided}=  strip string  ${results.voided}
    ${stripper.one_time_use}=  strip string  ${results.one_time_use}
    ${stripper.exact_amt}=  strip string  ${results.exact_amt}

    should be equal as strings  ${results.code_id}  ${pdfRow[0]}
    should be equal as strings  ${stripped.voided}  ${pdfRow[1]}
    should be equal as strings  ${results.who}  ${pdfRow[3]}
    should be equal as strings  ${results.issued_to}  ${pdfRow[4]}
    should be equal as strings  ${results.check_num}  ${pdfRow[9]}
    should be equal as strings  ${results.currency}  ${pdfRow[12]}
    should be equal as strings  ${stripper.exact_amt}  ${pdfRow[13]}
    should be equal as strings  ${stripper.one_time_use}  ${pdfRow[14]}

    close pdf

    #    WE WANT A COPY OF THIS REPORT IN CASE THE SUITE FAILS OR FOR FUTURE REFERENCE.
    os.move file  ${filePath}  ${REPORTSDIR}\\${file[0]}
    ${newFilePath}=  os.normalize path  ${REPORTSDIR}\\${file[0]}
    tch logging  \nFile moved to:\n\t${newFilePath}  INFO
