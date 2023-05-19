*** Settings ***
Library  otr_robot_lib.support.PyLibrary

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.support.PyString
Library  Process
Library  otr_model_lib.services.GenericService
Library  OperatingSystem  WITH NAME  os
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setting Up
Suite Teardown  Tear Me Down

Force Tags  eManager


*** Test Cases ***
Submit without a valid date
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Execute JavaScript  document.getElementById('begDate').value='66666666666666'
    Execute JavaScript  document.getElementById('endDate').value='66666666666666'
    Click Element  id=viewAlertsatCarrierLevel1

    ${error_message}  Get Text  //div[@class='errors']/b
    Set Test Variable  ${future_start_date_message}  The following errors have occurred
    Should Be Equal As Strings  ${error_message}  ${future_start_date_message}

Choose a start date greater than today
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Set Test Variable  ${future_start_date_message}  The following errors have occurred

#    >> Choose a start date greater than today
    ${TOMORROW}  getDateTimeNow  %Y-%m-%d  days=+1
    Execute JavaScript  document.getElementById('begDate').value='${TOMORROW}'
    Execute JavaScript  document.getElementById('endDate').value='${TOMORROW}'
    Click Element  id=viewAlertsatCarrierLevel1
    ${error_message}  Get Text  //div[@class='errors']/b
    Should Be Equal As Strings  ${error_message}  ${future_start_date_message}

Choose a start date greater than the end date
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Set Test Variable  ${future_start_date_message}  The following errors have occurred

#   >> Choose a start date greater than the end date
    ${start_date}  getDateTimeNow  %Y-%m-%d  days=+2
    ${end_date}    getDateTimeNow  %Y-%m-%d  days=+1
    Execute JavaScript  document.getElementById('begDate').value='${start_date}'
    Execute JavaScript  document.getElementById('endDate').value='${end_date}'
    Click Element  id=viewAlertsatCarrierLevel1
    ${error_message}  Get Text  //div[@class='errors']/b
    Should Be Equal As Strings  ${error_message}  ${future_start_date_message}

Choose an end date before the start date
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Set Test Variable  ${future_start_date_message}  The following errors have occurred

#   >> Choose an end date before the start date
    ${start_date}  getDateTimeNow  %Y-%m-%d
    ${end_date}    getDateTimeNow  %Y-%m-%d  days=-1
    Execute JavaScript  document.getElementById('begDate').value='${start_date}'
    Execute JavaScript  document.getElementById('endDate').value='${end_date}'
    Click Element  id=viewAlertsatCarrierLevel1
    ${error_message}  Get Text  //div[@class='errors']/b
    Should Be Equal As Strings  ${error_message}  ${future_start_date_message}

Choose a Policy That Doesn't Have Any Data
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go To  ${emanager}/cards/PolicyPromptManagement.action

    Wait until element is visible  cardMenubar_1x2
    Mouse Over  cardMenubar_1x2
    Click Element  policyManagement_1x2

    Input Text  description  richest policy ever
    Click Element  createNewPolicy
    ${sucess_message}  Get Text  //ul[@class='messages']//li
    tch logging  ${sucess_message}
    ${policy_number}  Get Regexp Matches  ${sucess_message}  (\\d+)
    ${policy_number}  Get From List  ${policy_number}  0
    tch logging  ${policy_number}

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Select From List By Value  //select[@id='policySelected']  ${policy_number}
    ${card_event_time}  Convert Date  ${output['event_time']}  result_format=%Y-%m-%d
    ${start_event}  Add Time To Date  ${card_event_time}  -2 days  result_format=%Y-%m-%d
    ${end_event}  Add Time To Date  ${card_event_time}  2 days  result_format=%Y-%m-%d
    Execute JavaScript  document.getElementById('begDate').value='${start_event}'
    Execute JavaScript  document.getElementById('endDate').value='${end_event}'

    Click Element  id=viewAlertsatCarrierLevel1

    Set Test Variable  ${no_alerts_found_message}  The following errors have occurred
    ${error_message}  Get Text  //div[@class='errors']/b
    Should Be Equal As Strings  ${error_message}  ${no_alerts_found_message}

Choose a Card With No Data
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action
    tch logging  card ${output['card_num']}
    Click Element  id=alertSelectCard
    Sleep  5
    Click Element  name=lookUpCards
    Input Text  cardSearchTxt  ${output['card_num']}
    Click Element  searchCard

    Click Element  //*[@id="cardSummary"]//*[contains(text(),'${output['card_num']}')]
    Click Element  id=transAlertSubscription
    Click Element  id=fundingAlertSubscription
    Click Element  id=statusAlertSubscription
    Click Element  id=viewAlertsatCarrierLevel1

    Set Test Variable  ${no_alerts_found_message}  The following errors have occurred
    ${error_message}  Get Text  //div[@class='errors']/b
    Should Be Equal As Strings  ${error_message}  ${no_alerts_found_message}

Uncheck all Cardholder Alerts
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Set Test Variable  ${future_start_date_message}  The following errors have occurred

#   >> Uncheck all Cardholder Alerts.
     ${TODAY}  getDateTimeNow  %Y-%m-%d
    Execute JavaScript  document.getElementById('begDate').value='${TODAY}'
    Execute JavaScript  document.getElementById('endDate').value='${TODAY}'
    Click Element  id=transAlertSubscription
    Click Element  id=fundingAlertSubscription
    Click Element  id=statusAlertSubscription
    Click Element  id=viewAlertsatCarrierLevel1
    ${error_message}  Get Text  //div[@class='errors']/b
    Should Be Equal As Strings  ${error_message}  ${future_start_date_message}

All alerts appear on the list as seen in the trans_alerts table
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Select From List By Value  //select[@id='policySelected']  ${output['icardpolicy'].__str__()}
    ${card_event_time}  Convert Date  ${output['created']}  result_format=%Y-%m-%d
    ${start_event}  Add Time To Date  ${card_event_time}  -1 days  result_format=%Y-%m-%d
    ${end_event}  Add Time To Date  ${card_event_time}  1 days  result_format=%Y-%m-%d

    Execute JavaScript  document.getElementById('begDate').value='${start_event}'
    Execute JavaScript  document.getElementById('endDate').value='${end_event}'
    Click Element  id=statusAlertSubscription
    Click Element  id=statusAlertSubscription
    Sleep  1
    Click Element  id=viewAlertsatCarrierLevel1

    ${end_event}  Add Time To Date  ${end_event}  1 days  result_format=%Y-%m-%d  # Adding one more day because SQL Query filter consider hours.

    ${start_event}  Convert to String  ${start_event}
    ${end_event}  Convert to String  ${end_event}

    Get Into DB  TCH
    ${query_alerts}  Catenate
    ...  select count(*)
    ...  from trans_alert ta
    ...    left join ach_profile_card_xref apcx
    ...        on apcx.profile_id = ta.profile_id
    ...    left join card_inf cinf
    ...        on cinf.card_num=apcx.card_num
    ...        and cinf.info_id = 'NAME'
    ...    right join cards c
    ...     on apcx.card_num = c.card_num
    ...  where ta.created between '${start_event} 00:00:00' and '${end_event} 00:00:00'
    ...    and c.carrier_id = ${output['member_id']}
    ...    and c.icardpolicy = ${output['icardpolicy']}

    tch logging  ${query_alerts}  INFO
    ${total_alerts}  Query And Strip   ${query_alerts}
    tch logging  total_alerts:${total_alerts}

    ${screen_total_alerts}  Get Text  //td[contains(text(), 'results found,displaying all results.')]
    ${screen_total_alerts}  Remove String  ${screen_total_alerts}  results found,displaying all results.

    Should Be Equal As Numbers  ${screen_total_alerts}  ${total_alerts}

Filtered Alert Data Appears
    [Tags]  JIRA:BOT-910  JIRA:BOT-1726  refactor

    Go to  ${emanager}/cards/CardHolderAlertHistory.action

    Select From List By Value  //select[@id='policySelected']  ${output['icardpolicy'].__str__()}
    ${card_event_time}  Convert Date  ${output['event_time']}  result_format=%Y-%m-%d
    ${start_event}  Add Time To Date  ${card_event_time}  -1 days  result_format=%Y-%m-%d
    ${end_event}  Add Time To Date  ${card_event_time}  1 days  result_format=%Y-%m-%d

    Execute JavaScript  document.getElementById('begDate').value='${start_event}'
    Execute JavaScript  document.getElementById('endDate').value='${end_event}'

    Sleep  1
    Unselect checkbox  id=fundingAlertSubscription
    Unselect checkbox  id=statusAlertSubscription
    Click Element  id=viewAlertsatCarrierLevel1

    Set Test Variable  ${EXPECTED_ALERT}  WDRW
    FOR  ${i}  IN RANGE  1  ${total_table_lines}
      ${type_alert}  Get Text  //table[@id='cardHolderAlertHistoryModifiedModel']//tr[${i}]//td[2]
      Should Be Equal As Strings  ${type_alert}  ${EXPECTED_ALERT}
    END



*** Keywords ***
Setting Up
    ${output}  Get Valid Carrier
    set Suite variable  ${output}
    ${backup_secure_entry}  Backup and Update Entry Code Flag To N  ${output['member_id']}
    set global variable  ${backup_secure_entry}
    Open eManager  ${output['member_id']}  ${output['passwd']}

Tear Me Down

    Update Entry Code Flag  ${output['member_id']}  ${backup_secure_entry}
    Close Browser
    Reset Role  ${output['member_id']}
    disconnect from database

Get Valid Carrier
    Get Into DB  TCH
    ${query}  Catenate  SELECT UNIQUE c.card_carrier,
    ...          m.member_id,
    ...          m.passwd,
    ...          TRIM(a.card_num) AS card_num,
    ...          t.alert_type,
    ...          t.email_addr,
    ...          t.cell_phone,
    ...          t.amount,
    ...          t.card_status,
    ...          t.event_time,
    ...          t.created,
    ...          cards.icardpolicy,
    ...          SUBSTR(TRIM(a.card_num), -4) AS card_last_digits
    ...  FROM trans_alert t
    ...    INNER JOIN ach_profile_card_xref a ON a.profile_id = t.profile_id
    ...    INNER JOIN cards cards ON cards.card_num = a.card_num
    ...    INNER JOIN card_holder_alerts c ON c.card_carrier = cards.carrier_id
    ...    INNER JOIN member m ON m.member_id = cards.carrier_id
    ...  WHERE card_status = 'A'
    ...  LIMIT 1
    ${output}  Query And Strip To Dictionary  ${query}
    Add CardHolder Alert History to Carrier  ${output['member_id']}
    [Return]  ${output}

Backup and Update Entry Code Flag to N
    [Arguments]  ${member_id}
    Get Into DB  MySQL
    ${backup_secure_entry_query}  Catenate  SELECT value FROM sec_company_attribute WHERE company_id = (SELECT company_id FROM sec_user WHERE user_id like '${member_id}') AND type_id = 20
    ${number}  row count  ${backup_secure_entry_query}
    Run Keyword If  ${number}==0  Return From Keyword  None
    ${backup_secure_entry}  Query And Strip  ${backup_secure_entry_query}
    Update Entry Code Flag  ${member_id}  N
    [Return]  ${backup_secure_entry}

Update Entry Code Flag
    [Arguments]  ${member_id}  ${flag}
    Run Keyword If  '${flag}'=='None'  Return From Keyword  None
    Get Into DB  MySQL
    ${DML}  Catenate  UPDATE sec_company_attribute SET value='${flag}' WHERE company_id = (SELECT company_id FROM sec_user WHERE user_id like '${member_id}') AND type_id = 20;
    tch logging  ${DML}  INFO
    Execute SQL String  ${DML}

Set Secure Entry Flag
    [Arguments]  ${Use}  ${Flag}
    get into db  mysql
    execute sql string  dml=update sec_company_attribute set value='${Flag}' where company_id = (select company_id from sec_user where user_id like '${Use}') and type_id = 20;

Secure Entry Code Setup
    [Arguments]  ${Flag}  @{users}
    FOR  ${user}  in  @{users}
      set secure entry flag  ${user}  ${Flag}
    END

Delete Policy
    [Documentation]
    ...  Delete Policy Through DB
    ...
    ...  ARGS:
    ...  - Carrier: Carrier Id.
    ...  - PolicyNumber. iPolicy Number to Delete.
    ...  - DB: Database instance. TCH, SHELL, IRVING, IMPERIAL.
    ...
    ...  EXAMPLE:
    ...  - Delete Policy  103866  31  TCH

    [Arguments]  ${carrier}  ${policyNumber}  ${db}

    Get Into DB  ${db}
    TCH Logging  \nDeleting Policy

    #REMOVE POLICY LIMITS
    ${sql}  catenate  DELETE FROM def_lmts WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}
    TCH Logging  \n${sql}

    #REMOVE POLICY PROMPTS
    ${sql}  catenate  DELETE FROM def_info WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}
    TCH Logging  \n${sql}

    #REMOVE POLICY LOCATIONS
    ${sql}  catenate  DELETE FROM def_locs WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}
    TCH Logging  \n${sql}

    #REMOVE POLICY LOCATION GROUPS
    ${sql}  catenate  DELETE FROM def_loc_grp WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}
    TCH Logging  \n${sql}

    #REMOVE POLICY MCCs
    ${sql}  catenate  DELETE FROM mcfleet_def_mcc WHERE carrier_id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}
    TCH Logging  \n${sql}

    #REMOVE POLICY
    ${sql}  catenate  DELETE FROM def_card WHERE id = '${carrier}' AND ipolicy = '${policyNumber}'
    Execute SQL String  ${sql}
    TCH Logging  \n${sql}

    #UPDATE CARDS
    ${sql}  catenate  UPDATE cards SET icardpolicy = 1 WHERE icardpolicy = '${policyNumber}' AND carrier_id = '${carrier}'
    Execute SQL String  ${sql}
    TCH Logging  \n${sql}

    Disconnect From Database

Add CardHolder Alert History to Carrier
    [Arguments]  ${carrier}
    Get Into DB  MySQL
    Add Role to Carrier  ${carrier}  CARDHOLDER_ALERT_HISTORY

Add Role to Carrier
    [Arguments]  ${carrier}  ${role}

    ${query}  Catenate  SELECT 1 FROM sec_user_role_xref
    ...  WHERE user_id = '${carrier}' AND role_id =

    ${count_role}  Row Count  ${query}'${role}'

    Set SUITE Variable  ${has_role}  None
    Set suite Variable  ${role}  ${role}
    Run Keyword If  '${count_role}'=='0'  Run Keywords
    ...  Set Test Variable  ${has_role}  ${TRUE}
    ...  AND  execute sql string  dml=insert INTO sec_user_role_xref(user_id, role_id, menu_visible) VALUES (${carrier},'${role}',true)

Reset Role
    [Arguments]  ${carrier}
     Run Keyword If  '${has_role}'!='None'  Run Keywords
     ...  Get Into DB  MySQL
     ...  AND  execute sql string  dml=delete FROM sec_user_role_xref WHERE user_id = '${carrier}' AND role_id = '${role}'

