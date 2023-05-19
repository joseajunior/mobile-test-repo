*** Settings ***
Library  DateTime
Library  BuiltIn

Library  otr_model_lib.Models
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
#Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot


Documentation    Ensure the Contact Us page is correct for each company: TCH, Shell and Irving. \n

Suite Teardown  Close Browser
Force Tags  eManager

*** Test Cases ***
Contact Us Page - TCH
    [Tags]    JIRA:BOT-252  JIRA:BOT-1737  qTest:32227901  refactor


    Open Browser to eManager
    Log into eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Execute JavaScript    window.scrollTo(0,2000)
    Wait Until Element Is Visible  //a[@href="https://www.efsllc.com/customer-service/"]  timeout=15
    Click Element  //a[@href="https://www.efsllc.com/customer-service/"]
    ${titles}  Get Window Titles
    Select Window    title=${titles[1]}
    Wait Until Element Is Visible  //h2
    ${EFS_CUST_NUM}  Get Text  //h2
    Tch Logging  \n EFS CUSTOMER NUMBER:${EFS_CUST_NUM}

    Page Should Contain Element  //*[@name="your-name"]
    Page Should Contain Element  //*[@name="your-email"]
    Page Should Contain Element  //*[@name="your-phone"]
    Page Should Contain Element  //*[@name="your-comments"]
    Page Should Contain Element  //*[@value="SUBMIT"]

    ${services}  get element count  //h3[text()='Service Numbers']/parent::div//li
    FOR  ${i}  IN RANGE  1  ${services}+1
      ${info}  Get Text  //h3[text()='Service Numbers']/parent::div//li[${i}]
      ${info}  Split String  ${info}  \n
      tch logging  Setor ${i}: ${info[0]}
      tch logging  Phone ${i}: ${info[1]}
   END

    [Teardown]  Close Browser

Contact Us Page - Shell
    [Tags]    JIRA:BOT-252  refactor

    Open Browser to eManager
    Log into eManager  ${shell_carrier}  ${shell_password}
    Click Link   //a[@href="/cards/ContactUs.action"]
    page should contain element  //*[@class="mainmenu1"]//*[contains(text(), 'Contact Us')]
    page should contain element  //*[@class="bordered"]//*[contains(text(), 'Shell Fleet Contact Information')]
    ${grid_line}=  get text  //*[text() = " "]/parent::*/following-sibling::*[1]
    log to console  ${grid_line}
    set global variable  ${grid_line}
    ${email}  ${phone}  ${fax}  Get info From Contact Us Page - SHELL  ${grid_line}
    [Teardown]  Close Browser

Contact Us Page - Irving
    [Tags]    JIRA:BOT-252  refactor

    Open Browser to eManager
    Log into eManager  ${irvinguserName}  ${irvingpassword}
    Click Link   //a[@href="/cards/ContactUs.action"]
    page should contain element  //*[@class="mainmenu1"]//*[contains(text(), 'Contact Us')]
    page should contain element  //*[@class="bordered"]//*[contains(text(), 'Irving Contact Information')]
    ${grid_line_irving}=  get text  //legend[1]/parent::*
    set global variable  ${grid_line_irving}
    ${irv_phone}  ${irv_fax}  ${irv_email}  Get info From Contact Us Page - Irving  ${grid_line_irving}
    tch logging  ${irv_phone}
    tch logging  ${irv_fax}
    tch logging  ${irv_email}
    [Teardown]  Close Browser

*** Keywords ***
Get info From Contact Us Page - TCH
   [Arguments]  ${grid_line_tch}
   log to console  \n
    @{linestch}=   Split to lines    ${grid_line_tch}
    ${CustService}  Evaluate  '${linestch[1]}'
    ${CustService_phone}  Evaluate  '${linestch[2]}'
    ${Credit}  evaluate  '${linestch[4]}'
    ${Credit_phone}  evaluate  '${linestch[5]}'
    ${AccountManag}  evaluate  '${linestch[7]}'
    ${AccountManag_phone}  evaluate  '${linestch[8]}'
   [Return]  ${CustService}  ${CustService_phone}  ${Credit}  ${Credit_phone}  ${AccountManag}  ${AccountManag_phone}

Get info From Contact Us Page - SHELL
   [Arguments]  ${grid_line}
    log to console  \n
    @{lines}=   Split to lines    ${grid_line}
    ${email}  Evaluate  '${lines[0]}'
    ${phone}  Evaluate  '${lines[1]}'
    ${fax}  evaluate  '${lines[2]}'
   [Return]  ${email}  ${phone}  ${fax}

Get info From Contact Us Page - Irving
   [Arguments]  ${grid_line_irving}
   log to console  \n
    @{lines_irv}=   Split to lines    ${grid_line_irving}
    ${irv_phone}  Evaluate  '${lines_irv[2]}'
    ${irv_fax}  Evaluate  '${lines_irv[3]}'
    ${irv_email}  evaluate  '${lines_irv[4]}'
   [Return]  ${irv_phone}  ${irv_fax}  ${irv_email}
