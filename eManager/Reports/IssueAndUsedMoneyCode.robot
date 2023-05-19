*** Settings ***
Documentation  This test suite ensures that an eManager report will download to the default
...  download directory.


Library  OperatingSystem  WITH NAME  os
Library  otr_mobel_lib.Models
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.reports.PyExcel
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  ../../Variables/validUser.robot

Suite Teardown  End Test

Force Tags  eManager  Reports

*** Variables ***
${address}  http://jbacpt2:8080
*** Test Cases ***
Issued Money Code and Money Code Used Report
    [Tags]  JIRA:BOT-542  JIRA:BOT-1735  JIRA:BOT-1059  qTest:30058505  Regression  refactor
    [Documentation]  Verify the dates show up in Issued Money Code Report and Money Code Used Report
    [Setup]  Run Keywords
    ...      Set Test Variable  ${user}  102536
    ...      AND  Get Into DB  TCH
             ${issued_to}  Generate Random String  6  [LETTERS]
             ${today}      GetDateTimeNow  %Y-%m-%d
             ${yesterday}  GetDateTimeNow  %Y-%m-%d  days=-1
             Set Test Variable  ${amount}  20
             Set Test Variable  ${issued_to}
             Set Test Variable  ${today}
             Set Test Variable  ${yesterday}
             Set Test Variable  ${location}  231010

    Setting Up Suite

#    --------------------------  SEARCH USER, CONTRACT AND PASSWORD  --------------------------
             ${query}  Catenate  SELECT contract_id, member_id, passwd
             ...                 FROM contract c INNER JOIN member m ON (c.carrier_id = m.member_id)
             ...                 WHERE m.member_id = ${user}
             ${output}  Query And Strip To Dictionary  ${query}
             ${pass}  Strip String  ${output.passwd}

#    -------------------------------------  ISSUE MONEY CODE  ----------------------------------
     log into card management web services  ${output.member_id}  ${pass}
     ${money_code}  issueMoneycode  ${output.contract_id}  ${amount}  ${issued_to}
     Set Suite Variable  ${money_code}

     Tch Logging  \n TODAY:${today}| YESTERDAY:${yesterday}
     Tch Logging  \n MEMBER_ID:${output.member_id}| PASSWD:${pass}| CONTRACT_ID:${output.contract_id}
     Tch Logging  \n MONEY_CODE:${money_code}

#   -------------------------------------  ISSUE MONEY CODE REPORT  -----------------------------
    Open Browser To eManager
    Log into eManager  ${user}  ${output.passwd}
    Go To  ${emanager}/cards/IssuedMoneyCodesReport.action
    Input Text  name=startDate  ${today}
    Input Text  name=endDate  ${today}

    Select From List By Value  viewFormat  4  #EXCEL
    Click Element  name=viewReport
    Wait Until element Is Visible  //a[contains(@href, "IssuedMoneyCodesReport.action") and text()="Click here to view the document"]  timeout=20
    Click Element  //a[contains(@href, "IssuedMoneyCodesReport.action") and text()="Click here to view the document"]
    Sleep  2
    Tch Logging  \n IssuedMoneyCodesReport DOWNLOADED
    Assert Money Code Report Type  IssuedMoneyCodesReport
    Get Excel Data From IssuedMoneyCodeReport
    Close Browser

#   -------------------------------------  AUTHORIZE MONEY CODE  ---------------------------------
    Tch logging  \n RUN A TRANSACTION FOR THE MONEY CODE
    ${AM}  Create AM String  TCH  ${location}  ${moneyCode}  ULSD=${amount}
    run rossAuth  ${AM}  ${logfile}.log

    ${CheckNum_Info}  catenate  SELECT ck.check_num FROM mon_codes mc, checks ck
    ...     WHERE mc.code_id=ck.ref_id AND mc.express_code=${moneyCode}
    ${CheckNumber}  Query And Strip  ${CheckNum_Info}
    Tch Logging  \n CHECK_NUMBER:${CheckNumber}

#   -------------------------------------  MONEY CODE USE REPORT ----------------------------------,
    Tch Logging  \n DOWNLOADING MONEY CODE USE REPORT
    Open Browser to eManager
    Log into eManager  ${user}  ${output.passwd}
    Go To   ${emanager}/cards/MoneyCodeUseReport.action
    Wait Until Element Is Visible  //*[@name="startDate"]  timeout=20
    Input Text  name=startDate  ${yesterday}
    Input Text  name=endDate  ${today}
    Select Checkbox  checkShow
    Input Text  checkNumber  ${CheckNumber}
    Select From List By Value  viewFormat  4  #EXCEL
    Execute JavaScript  window.scrollTo(0,2000)
    Click Element  name=viewReport
    Wait Until element Is Visible  //a[contains(@href, "MoneyCodeUseReport.action") and text()="Click here to view the document"]  timeout=20
    Click Element  //a[contains(@href, "MoneyCodeUseReport.action") and text()="Click here to view the document"]
    Tch Logging  \n MoneyCodeUseReport DOWNLOADED
    Assert Money Code Report Type  MoneyCodeUseReport
    Get Excel Data From MoneyCodeUseReport


#    -------------------------------------  ISSUE MONEY CODE REPORT  -------------------------------------
    Tch Logging  \n DOWNLOADING ISSUEMONEY CODE REPORT

    Go To   ${emanager}/cards/IssuedMoneyCodesReport.action
    Wait Until Element Is Visible  //*[@name="startDate"]  timeout=20
    Input Text  name=startDate  ${yesterday}
    Input Text  name=endDate  ${today}
    Sleep  20
    Select From List By Value  viewFormat  4  #EXCEL
    Click Element  name=viewReport
    Wait Until element Is Visible  //a[contains(@href, "IssuedMoneyCodesReport.action") and text()="Click here to view the document"]  timeout=10
    Click Element  //a[contains(@href, "IssuedMoneyCodesReport.action") and text()="Click here to view the document"]
    Tch Logging  \n IssuedMoneyCodesReport DOWNLOADED
    Assert Money Code Report Type  IssuedMoneyCodesReport
    Get Excel Data From IssuedMoneyCodeReport


    [Teardown]  Run Keywords
    ...         Disconnect From Database
    ...         AND  Logout

Issued Money Code Report Schedule Report
    [Tags]  JIRA:BOT-1060  qTest:30058506  Regression  refactor

    ${schedule}  Generate Random String  4  [NUMBERS]
    Set Suite Variable  ${schedule}

    Tch Logging  \n SCHEDULING AN ISSUED MONEY CODE REPORT

    Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Go To  ${emanager}/cards/IssuedMoneyCodesReport.action
    Select Radio Button  scheduleImmediateRadio  SCHEDULED
    Click Button  viewReport
    Wait Until Element Is Visible  jobFrequency  timeout=20
    Input Text  jobDescription  SchedIssuedMonCodeReport_${schedule}
    Tch Logging  \n JOB DESCRIPTION: SchedIssuedMonCodeReport_${schedule}
    Click Button  submitScheduledJob
    Wait Until Element Is Visible  //*[contains(text(),"You may also go to 'Scheduled Reports' from your menu to see the status of your report")]  timeout=20
    Page Should Contain Element  //*[contains(text(),"You may also go to 'Scheduled Reports' from your menu to see the status of your report")]
    Go To  ${emanager}/cards/JobList.action
    Wait Until Element Is Visible  //*[@id="scheduledJob"]//*[contains(text(),'SchedIssuedMonCodeReport_${schedule}')]  timeout=20
    Page Should Contain Element  //*[@id="scheduledJob"]//*[contains(text(),'SchedIssuedMonCodeReport_${schedule}')]

    [Teardown]  Close Browser

Edit a Scheduled Issued Money Code Report
    [Tags]  JIRA:BOT-1061  qTest:30128940  Regression  refactor

    Set Test Variable  ${EditMessage}  You have successfully Edited the Name (Issued Money Codes Report), Description (SchedIssuedMonCodeReport_${schedule}), and Frequency (WEEKLY).

    Tch Logging  \n EDITING A SchedIssuedMonCodeReport_${schedule} REPORT

    Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Go To  ${emanager}/cards/JobList.action
    Wait Until Element Is Visible  //*[@id="scheduledJob"]//*[contains(text(),'SchedIssuedMonCodeReport_${schedule}')]  timeout=20
    Page Should Contain Element  //*[@id="scheduledJob"]//*[contains(text(),'SchedIssuedMonCodeReport_${schedule}')]
    Click Element  //table[@id="scheduledJob"]//*[contains(text(), 'SchedIssuedMonCodeReport_${schedule}')]/parent::tr/td[7]
    Click Element  //*[@value="WEEKLY" and @name="jobFrequency"]
    Click Button  saveJob
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(),'You have successfully')]
    ${message}  get text  //*[@class="messages"]//*[contains(text(),'You have successfully')]
    Should Start With  ${message}  ${EditMessage}

    [Teardown]  Close Browser

Delete an Issued Money Code Report scheduled report
    [Tags]  JIRA:BOT-1062  qTest:30128978  Regression  refactor

    Tch Logging  \n DELETING A SchedIssuedMonCodeReport_${schedule} REPORT

    Open eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Go To  ${emanager}/cards/JobList.action
    Wait Until Element Is Visible  //*[@id="scheduledJob"]//*[contains(text(),'SchedIssuedMonCodeReport_${schedule}')]  timeout=20
    Page Should Contain Element  //*[@id="scheduledJob"]//*[contains(text(),'SchedIssuedMonCodeReport_${schedule}')]
    Click Element  //*[@id="recentJob"]//*[contains(text(), 'SchedIssuedMonCodeReport_${schedule}')]/parent::tr/td[8]
    Handle Alert
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'Job Successfully Deleted.')]

    [Teardown]  Close Browser





*** Keywords ***
Setting Up Suite
    Tch Logging  \n CREATE THE LOGFILE
    Connect SSH  ${sshHost}  ${sshName}  ${sshPass}
    Go Sudo
    ${date}=  getdatetimenow  %Y%m%d%H%M%S
    ${MONTH}=  getdatetimenow  %m
    ${log_dir}=  catenate
    ...  /home/qaauto/el_robot/authStrings/rossAuthLogs/rossAuth/${MONTH}
    run command  if [ ! -d ${log_dir} ];then mkdir -p ${log_dir};fi
    run command  find ${log_dir} -type f -name '*' -mtime +365 -exec rm {} \\;
    #SETTING LOG FILE NAME ACCORDING TO SUITE NAME AND TEST NAME
    set test variable  ${logfile}  ${log_dir}/${SUITE NAME.replace(' ','_')}_${TEST NAME.replace(' ', '_')}_${date}
    set global variable  ${logfile}

End Test
    disconnect from database


Assert Money Code Report Type
    [Arguments]  ${report_type}
    Sleep  5
    @{file}=  os.list directory  ${default_download_path}  *${report_type}*
    Log To Console  ${file[0]}
    ${downloadpath}=  os.normalize path  ${default_download_path}
    ${filPath}=  Assign String  ${downloadpath}\\${file[0]}
    Tch Logging  \n MY FILE IS: ${filPath}  INFO
    Open Excel  ${filPath}
    ${sheets}=  get sheet names
    Tch Logging  \n SHEETS: ${sheets}
    ${rowCount}=  get row count  ${sheets[0]}
    Tch Logging  \n COUNT:${rowCount}
    ${columnCount}=  get column count  ${sheets[0]}
    Tch Logging  \n COLUMN_COUNT:${columnCount}

    Set Suite Variable   ${rowCount}
    Set Suite Variable   ${sheets}
    Set Suite Variable   ${columnCount}

Get Excel Data From IssuedMoneyCodeReport
    @{Excel_Data}  create list
    FOR  ${i}  in range  1  ${rowCount}
      ${vals}=  get row values  ${sheets[0]}  ${i}  ${True}
      append to list  ${Excel_Data}  ${vals}
    END

    ${Rows}  get dictionary values
    Tch Logging  \n ROW:${Rows}

    ${my_line}  set variable  None
    FOR  ${i}  in range  2  ${rowCount}+1
      ${ID}  Get From Dictionary  ${Rows}  B${i}
#    \  ${ID}  Get Substring  ${ID.__str__()}  0  -2
      Tch Logging  ID:${ID} TRANSFER_CODE:${money_code}
      ${my_line}  Set Variable if  '${ID}'=='${money_code}'  ${i}  ${my_line}
    END

    Tch Logging  MYLINE:${my_line}

    run keyword if  '${my_line}'=='None'  Tch Logging  NO MATCH FOR THE CODE ID  INFO
    ${issued_date}  Get From Dictionary  ${Rows}  K${my_line}
    ${issued_date}  Excel Date To String  ${issued_date}

    ${issued_date}  Get Substring  ${issued_date.__str__()}  0  -6
    Tch Logging  \n ISSUED DATE:'${issued_date}'

    ${MonCode_Query}  catenate  SELECT to_char(created, '%Y-%m-%d') as created FROM mon_codes WHERE express_code = '${money_code}'
    ${created}  Query And Strip  ${MonCode_Query}
    Should Be Equal As Strings  ${created}  ${issued_date}

    Delete Excel

Get Excel Data From MoneyCodeUseReport
    @{Excel_Data}  create list
    FOR  ${i}  in range  1  ${rowCount}
      ${vals}=  get row values  ${sheets[0]}  ${i}  ${True}
      Tch Logging  \n VALS:${vals}
      append to list  ${Excel_Data}  ${vals}
    END

    FOR  ${vals}  IN  @{Excel_Data}
      Tch Logging  \n CHECK EXCEL ROW:${vals}
      Check Excel Row on MoneyCodeUseReport  ${vals}
    END

Check Excel Row on MoneyCodeUseReport
    [Arguments]  ${row}

    ${MonCode_Query}  catenate  SELECT code_id, created, to_char(last_use, '%Y-%m-%d') as last_use FROM mon_codes WHERE express_code = '${money_code}'
    ${MonCode_Info}  Query And Strip To Dictionary  ${MonCode_Query}
    Tch logging  \n CODE ID:${MonCode_Info.code_id}
    Tch Logging  \n ROW:${row}

    ${last_use}  Set Variable  ${EMPTY}
    FOR  ${i}  IN  @{row}
      ${last_use}  Set Variable if  '${i[0]}'=='K2'  ${i[1]}  ${last_use}
    END
    tch logging  \n minha_data_linda:${last_use}
    ${last_use}  Excel Date To String  ${last_use}  %Y-%m-%d

    Tch Logging  \n DATE: ${last_use}

    Should Be Equal As Strings  ${MonCode_Info.code_id}  ${row[0][1]}
    Should Be Equal As Strings  ${MonCode_Info.last_use}  ${last_use}

    Tch Logging  \n IT CHECKS WITH THE DB!
    Delete Excel
