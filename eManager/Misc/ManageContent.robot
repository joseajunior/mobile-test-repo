*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags   Manage Content    eManager

*** Test Cases ***
Open EFS Carrier
    [Documentation]  BOT-890
    [Tags]  JIRA:BOT-890  JIRA:BOT-1958  qTest:34224390  Regression  refactor

#    Set Robot Environment  devacpt

    Open eManager  ${intern}  ${internPassword}

    Mouse Over  id=menubar_1x2
    Click Element  TCHONLINE_MANAGE_CONTENTx2
    Select From List By Value  newsCompanyTypeId  YCP
    Select From List By Value  newsCompanyHeaderId  yellowcard_carrier
    Input Text  name=news.title  Yellow Card News
    Input Text  name=news.position  1
    ${TODAY}  getDateTimeNow  %Y-%m-%d
    Input Text  name=news.updateDate  ${TODAY}
    ${random}  Generate Random String  4  [NUMBERS]
    ${announcements}  Catenate  BOT-890 news n${random}
    Input Text  name=news.description  ${announcements}
    Click Element  name=addNews
    ${message}  Get Text  //ul[@class='messages']/li
    Should Be Equal As Strings  ${message}  Successfully updated news record.
#    Click Element  //a[contains(@href, 'logoffUser')]
    Close Browser

    Get Into DB  TCH
    Set Test Variable  ${carrier}  4999601
    ${pass_query}  Catenate  SELECT passwd FROM member WHERE member_id = ${carrier}
    ${carrier_pass}  Query And Strip  ${pass_query}

    Open eManager  ${carrier}  ${carrier_pass}
    Wait Until Element Is Visible   //table[@id='news']
    element should be visible  //table[@id='news']//strong[contains(text(), '${announcements}')]
    Close Browser




*** Keywords ***
