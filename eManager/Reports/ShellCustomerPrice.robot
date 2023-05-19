*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Library  otr_robot_lib.reports.PyPDF
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Test Teardown  End Test

Force Tags  eManager  Reports

*** Variables ***
${card}

*** Test Cases ***

Shell Pricing Report
    [Tags]  JIRA:BOT-589  refactor
    [Documentation]  A document that shows current cardlock pricing.

#Open eManager and Download a Transaction Report
    open automation browser  ${emanager}/cards  ${browser}  download_folder=${default_download_path}  alias=eManager
    Maximize Browser Window
    Input Text  userId  ${shell_carrier}
    Input Password  password  ${shell_password}
    Click Element  logonUser
    go to  https://test.efsllc.com/cards/ShellCustReport.action
    Input Text  effectiveDate  2018-09-26
    Click Button  Submit
    Wait Until Element Is Visible  //a[contains(@href, "ShellCustReport.action") and text()="Click here to view the document"]  timeout=20
    Click Element  //a[contains(@href, "ShellCustReport.action") and text()="Click here to view the document"]

#Download PDF, Move to Report Directory and Open PDF
    Sleep  5
    ${fileExists}  os.file should exist  ${default_download_path}${/}*CustCLPriceReport*
    ${file}  os.list directory  ${default_download_path}  *CustCLPriceReport*.pdf
    ${filePath}  os.normalize path  ${default_download_path}${/}${file[0]}
    open pdf doc  ${filePath}

#Get PDF Data

    ${filter}  get pdf text coordinates  FJ Cardlock Pricing**
    tch logging  \n\n${filter}
    ${filterRow}  get from dictionary  ${filter[1]}  row
    tch logging  \n\n${filterRow}
    ${pdfData}  get row from pdf  ${filterRow}  separator=\t
    tch logging  \n\n${pdfData}
    ${pdfData}  Strip List Of Strings  ${pdfData}
    tch logging  \n\n${pdfData}
    
#Checking if the title FJ Cardlock Pricing is there
    should be equal as strings  ${pdfData[0]}  FJ Cardlock Pricing**

    close pdf
    os.move file  ${filePath}  ${REPORTSDIR}\\${file[0]}
    ${newFilePath}  os.normalize path  ${REPORTSDIR}\\${file[0]}
    tch logging  \nFile moved to:\n\t${newFilePath}  INFO


    [Teardown]  Close Browser

*** Keywords ***
Initiate Test
    [Arguments]  ${DB}  ${ENV}

#    I LIKE TO PRINT A NEWLINE TO START. NOT NECESSARY.
    log to console  ${empty}

#    OPEN DB CONNECTION
    get into db  ${DB}
    set test variable  ${setup}  ${ENV}
    tch logging  ENVIRONMENT SET TO ${ENV}  ALL
    tch logging  eManager URL: ${emanager}  ALL

#    IF ANY MONEY CODE USE REPORT EXIST IN THE DOWNLOADS DIRECTORY, THEN DELETE THEM ALL.
    @{files}=  os.list directory  ${default_download_path}  *TransactionReport*
    print list  @{files}
    FOR  ${i}  in  @{files}
       tch logging  Permanently removing ${default_download_path}/${i}  WARN
       os.remove file  ${default_download_path}/${i}
    END

End Test
#    UNPLUG EVERYTHING
    disconnect from database

