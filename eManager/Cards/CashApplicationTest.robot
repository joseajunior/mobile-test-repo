*** Settings ***
Test Timeout  5 minutes
Library  otr_robot_lib.support.PyLibrary

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyMath
Library  otr_model_lib.services.GenericService
Library  Process
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

*** Test Cases ***

Cash Application Accepted Character Test
    [Tags]  JIRA:BOT-275  refactor
    [Documentation]  Testing allowed characters in the comments section of Cash Applications
    Open eManager  ${robot_eManager_username}  ${robot_eManager_password}
    go to  ${emanager}/cards/CashApplication.action
    input text  carrierId  103866
    click on  search
    click on  paymentType
    click on  BUMP-2000.0  #Stratus Credit Bump
    input text  amount  1
    input text  confirmAmount  1
    input text  comment  @ # : $ * / . , + - = ~ | '
    click on  apply
    element should be visible  xpath=//*[@class="messages"]  Applied successfully

Cash Application Status Credit Bump for Amounts ABOVE $1000 Test
    [Tags]  JIRA:BOT-275  refactor
    [Documentation]  Testing that you can pay above 1000 for a Stratus Credit Bump in Cash Application
    go to  ${emanager}/cards/CashApplication.action
    input text  carrierId  103866
    click on  search
    click on  paymentType
    click on  BUMP-2000.0   #Status Credit Bump
    input text  amount  1001
    input text  confirmAmount  1001
    input text  comment  comment
    click on  apply
    element should be visible  xpath=//*[@class="messages"]  Applied successfully

Cash Application Status Credit Bump for Amounts BELOW $1000 Test
    [Tags]  JIRA:BOT-275  refactor
    [Documentation]  Testing that you can pay below 1000 for a Stratus Credit Bump in Cash Application
    go to  ${emanager}/cards/CashApplication.action
    input text  carrierId  103866
    click on  search
    click on  paymentType
    click on  BUMP-2000.0    #Status Credit Bump
    input text  amount  999
    input text  confirmAmount  999
    input text  comment  comment
    click on  apply
    element should be visible  xpath=//*[@class="messages"]  Applied successfully

Cash Application Not Allowed Character Test
    [Tags]  JIRA:BOT-275  refactor
    [Documentation]  Testing to make sure certain characters are not allowed through in the comment section of Cash Application.
    log to console  & denied
    ${character}=  assign string  &
    cash application denial  ${character}
    log to console  ( denied
    ${character}=  assign string  (
    cash application denial  ${character}
    log to console  ) denied
    ${character}=  assign string  )
    cash application denial  ${character}
    log to console  ` denied
    ${character}=  assign string  `
    cash application denial  ${character}
    log to console  ; denied
    ${character}=  assign string  ;
    cash application denial  ${character}
    log to console  ! denied
    ${character}=  assign string  !
    cash application denial  ${character}
    log to console  % denied
    ${character}=  assign string  %
    cash application denial  ${character}
    log to console  ^ denied
    ${character}=  assign string  ^
    cash application denial  ${character}
    log to console  " denied
    ${character}=  assign string  "
    cash application denial  ${character}
    log to console  { denied
    ${character}=  assign string  {
    cash application denial  ${character}
    log to console  } denied
    ${character}=  assign string  }
    cash application denial  ${character}
    log to console  [ denied
    ${character}=  assign string  [
    cash application denial  ${character}
    log to console  ] denied
    ${character}=  assign string  ]
    cash application denial  ${character}
    log to console  ? denied
    ${character}=  assign string  ?
    cash application denial  ${character}
    log to console  < denied
    ${character}=  assign string  <
    cash application denial  ${character}
    log to console  > denied
    ${character}=  assign string  >
    cash application denial  ${character}
    log to console  \\ denied
    ${character}=  assign string  \\
    cash application denial  ${character}

    close browser

*** Keywords ***
Cash Application Denial
    [Arguments]  ${character}
    go to  ${emanager}/cards/CashApplication.action
    input text  carrierId  103866
    click on  search
    click on  paymentType
    click on  BUMP-2000.0
    input text  amount  1
    input text  confirmAmount  1
    input text  comment  ${character}
    click on  apply
    element should be visible  xpath=//*[@class="popupWrapper"]  There was an error processing your request.


*** Variables ***


