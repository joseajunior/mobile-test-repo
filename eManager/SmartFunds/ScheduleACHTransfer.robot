*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.Models
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Resource  otr_robot_lib/robot/eManagerKeywords.robot
#Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot


Documentation  This is a test suite for BOT-200 \n\n
...   This test is to schedule an ACH transfer \n\n

Suite Teardown  Close Browser
Force Tags  eManager

*** Variables ***
${SCH_type}
${TRS_type}
${TRS_value}
${cash}
${status}
${ACH_contract}  11175
${LeaveOnCard}
${card_ach}

*** Test Cases ***
Scheduled ACH - leave_on_card set N
    [Documentation]
    ...  When leave_on_ card is set to 'Y', there should be NO transfer. If set to 'N', there should be. \n\n

    [Tags]    BOT-200  refactor
    set test variable  ${LeaveOnCard}  N
    set test variable  ${card_ach}  7083050910386616252
    Schedule ACH transfer  TL  F  25.00
    Load cash on the card  200.00
    DB Setup
    Run the perl script
    sleep  5
    Checking the data in the DB  TL  F  25.00  200.00  WDRW
    Close Browser

Scheduled ACH - leave_on_card set Y
    [Tags]    BOT-200  refactor
    set test variable  ${LeaveOnCard}  Y
    set test variable  ${card_ach}  7083050910386616252
    Schedule ACH transfer  TL  F  20.00
    Load cash on the card  300.00
    DB Setup
    Run the perl script
    sleep  5
    Checking the data in the DB  TL  F  20.00  300.00  LOAD
    Delete Scheduled Transfer

*** Keywords ***
DB Setup
    get into db  TCH
    ${leave_onCard}=  catenate
    ...  UPDATE payr_cash_adv SET leave_on_card = '${LeaveOnCard}' WHERE card_num ='${card_ach}' AND id = 'LOAD' AND cash_adv_id = (SELECT MAX(cash_adv_id) FROM payr_cash_adv)
    execute sql string  ${leave_onCard}

Schedule ACH transfer
    [Arguments]     ${SCH_type}  ${TRS_type}  ${TRS_value}

       open emanager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
       Maximize Browser Window
       go to  url=${emanager}/cards/SmartPayScheduledAchTransfer.action
       click button   createNew
       click radio button   value=NUMBER
       input text  cardSearchTxt   ${card_ach}
       click button  searchCard
       click button   nextTab
       click radio button  xpath=//*[@id="fundsDest"]/tbody/tr[1]/descendant::input[1]
       ${radio_value}=  get value  //*[@id="fundsDest"]/tbody/tr[1]/descendant::input[1]
       set global variable  ${radio_value}
       click button    nextTab
       click radio button   //*[@value="N" and @name="ending"]
       ${yesterday}=  getdatetimenow  %Y-%m-%d  days=-1
       set global variable   ${yesterday}
       input text    targetEffDt  ${yesterday}
       click radio button   //*[@value="${SCH_type}" and @name="scheduleTypeCode"]
       click radio button   //*[@value="N" and @name="sendEmail"]
       click button  nextTab
       run keyword if   '${TRS_type}'=='P'  run keywords  click radio button  transferTypeCode  AND  select from list  transferPercent  ${TRS_value}
       run keyword if   '${TRS_type}'=='F'  input text  transferAmount   ${TRS_value}
       click button  checkNextTab
       click button  nextTab
       wait until element is visible   createNew
       tch logging   ACH Transfer Scheduled

Load cash on the card
         [Arguments]   ${cash}

         go to   ${emanager}/cards/SmartPayAllocation.action?am=SMARTPAY_LOAD_CARDS
         input text  cardSearchTxt  ${card_ach}
         click button   searchCard
         input text     //*[@id="cardSummary"]/tbody/tr[1]/descendant::input[1]   ${cash}
         click button   submit
         select window   new
         click button   save
         confirm action
         select window  main
         wait until element is visible  backFromReport
         click button  backFromReport
         tch logging   Loaded ${cash} on the card

Run the perl script
        tch logging   Running perl script
        connect ssh  ${sshConnection}  ${sshName}  ${sshPass}
        go sudo
        ${run}=  run command  /tch/run/createAchAcctSchedule.pl
        tch logging  Perl script successful

Checking the data in the DB
        [Arguments]   ${SCH_type}  ${TRS_type}  ${TRS_value}  ${cash}  ${status}
        get into db   tch
        ${DBleaveOnCard}=  query and strip  SELECT leave_on_card FROM payr_cash_adv WHERE card_num = '${card_ach}' AND id='${status}' AND leave_on_card='${LeaveOnCard}' ORDER BY when DESC limit 1
        tch logging  LeaveOnCard flag:${DBleaveOnCard}
        should be equal as strings  ${DBleaveOnCard}  ${LeaveOnCard}

        ${query}=  catenate
        ...  SELECT * FROM payr_cash_adv WHERE card_num = '${card_ach}' AND id='${status}' AND leave_on_card='${LeaveOnCard}' ORDER BY when DESC limit 1
        ${results}=  Query and Strip to Dictionary   ${query}
        should be equal as strings   ${results.id}  ${status}
        tch logging  CashAdvanceID:${results.cash_adv_id} and ID:${results.id}
        tch logging  When ID=WDRW and flag=N it means the transfer happened the way it should, when ID=LOAD and flag=Y it means the transfer did not happen.

Delete Scheduled Transfer
        go to  url=${emanager}/cards/SmartPayScheduledAchTransfer.action
        Click Radio Button  //*[@value="SEARCH" and @name="filterType"]
        Input Text  id=searchCardNum    ${card_ach}
        Click Button    id=startConfigure
        Click Element  //*[@id="scheduled"]/tbody/tr[1]/td[8]/input[2]
        Click Button  //*[@id="legAlerts_popup_ok"]
        Click Element  //*[@id="scheduled"]/tbody/tr[1]/td[8]/input[2]
        Click Button  //*[@id="legAlerts_popup_ok"]
