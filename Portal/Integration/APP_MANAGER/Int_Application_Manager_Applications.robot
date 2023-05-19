*** Settings ***
Library  Process
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/PortalKeywords.robot

Suite Setup  Time To Setup
Suite Teardown  Close All Browsers
Force Tags  Integration  Shifty  Portal

*** Test Cases ***

Create An Application
    [Tags]

    Click Portal Button  Add
    Fill Out The App Required Info
    Execute JavaScript  window.scrollTo(2000,0)
    Sleep  5
    ${APP_ID}  Get Text  //*[@id="cardAppHeader"]/descendant::*[@class='hdrval'][1]
    Set Suite Variable  ${APP_ID}
    Tch Logging  APP ID:${APP_ID}
    Wait Until Page Contains  text=${APP_ID}  timeout=20
    Check DB For App ID  ${APP_ID}  EFS_OTR_ROBOT_BASIC${seq}

    [Teardown]  Refresh Page

Add A Comment On An Application
    [Setup]  Return to Application Manager

    Search For An Application  SearchValue=EFS_OTR_ROBOT_BASIC
    ${APPID}  Click Application By Index  1
    set test variable  ${APPID}
    Add a comment
    Check Comment Is Added On DB

    [Teardown]  Refresh Page

Edit A Comment On An Application
    [Setup]  Return to Application Manager

    Search For An Application  SearchValue=EFS_OTR_ROBOT_BASIC
    ${APPID}  Click Application By Index  1
    set test variable  ${APPID}

    Edit a comment
    Check Comment Is Edited On DB

*** Keywords ***

Time To Setup
    Open Browser to portal
    Log Into Portal
    Select Portal Program  Application Manager


Fill Out The App Required Info
    ${seq}  Generate Random String  3  [NUMBERS]
    Set Suite Variable  ${seq}
    wait until done processing
    Wait Until Page Contains  text=Company Info & Sales  timeout=20
    Sleep  2
    Execute JavaScript  window.scrollTo(0,2000)
    Wait Until Page Contains Element  //input[@name="request.cardApp.companyName"]  timeout=20
    Click Element   //input[@name="request.cardApp.companyName"]
    Input Text  //input[@name="request.cardApp.companyName"]  EFS_OTR_ROBOT_BASIC${seq}
    Click Portal Button  Save
    Wait Until Done Processing
    Sleep  3

Check DB For App ID
    [Arguments]  ${app_id}  ${company_name}
    Get Into DB  TCH
    ${appID}  Query And Strip  SELECT app_id FROM wrkflw_cardappl WHERE company_name='EFS_OTR_ROBOT_BASIC${seq}'
    Should Be Equal As Strings  ${appID}  ${APP_ID}


Add a comment
    Click Element  pm_notes
    Wait Until Element Is Visible  //*[@id="commentsDlg_caption"]
    ${comments_xpath}=  set variable  //div[contains(@class,'cmtitem')]
    ${comment_count}=  get element count  ${comments_xpath}
    Click Portal Button  Add  //*[@id="commentsDlg_content"]
    Wait Until Element Is Enabled  requestScope.comment.comment
    Input Text  requestScope.comment.comment  BlindDutchman is awesome
    Click Portal Button  Save  //*[@id="commentsAdd_content"]
    wait until keyword succeeds  15  1  Check If New Comment is Added  ${comment_count}

Check If New Comment is Added
    [Arguments]  ${previous_count}
    ${comments_xpath}=  set variable  //div[contains(@class,'cmtitem')]
    ${comment_count}=  get element count  ${comments_xpath}
    run keyword if  ${previous_count} == ${comment_count}  fail  A new Comment Has Not Been Added Yet

Edit a comment
    Click Element  pm_notes
    Wait Until Element Is Visible  //*[@id="commentsDlg_caption"]
    Wait Until Element Is Visible  //*[@id="commentsDlg_content"]//*//*//descendant::*[contains(string(),'BlindDutchman is awesome')]  timeout=20
    Double Click Element  //*[@id="commentsDlg_content"]//*//*//descendant::*[contains(string(),'BlindDutchman is awesome')]
    Sleep  1
    Clear Element Text  //textarea[@id="commentTextArea" and @name="requestScope.comment.comment"]          #WORKAROUND - RIGHT NOW IT'S EDITING THE COMMENT AND MESSING UP THE INFO BY INPUTING THE MESSAGE IN BETWEEN THE CHARACTERS
    Send Text To Element  requestScope.comment.comment  BlindDutchman is awesome and the best
    Click Portal Button  Save  //*[@id="commentsAdd_content"]
    Sleep  0.5
    Click Portal Button  Close  //*[@id="commentsDlg_content"]

Check Comment Is ${status} On DB

    Get Into DB  TCH
    ${comment}  Query And Strip  SELECT comment FROM app_comment WHERE app_id=${APP_ID} ORDER BY upd_dts DESC LIMIT 1

    Run Keyword IF  '${status}'=='Added'  Should Be Equal As Strings  ${comment}  BlindDutchman is awesome
    ...  ELSE IF  '${status}'=='Edited'  Should Be Equal As Strings  ${comment}  BlindDutchman is awesome and the best