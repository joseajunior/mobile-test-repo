*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown  Close Browser
Suite Teardown    Disconnect From Database

Force Tags  eManager

*** Variables ***
${carrier}

*** Test Cases ***
Compliance Requirements screen is displayed
    [Tags]    JIRA:ATLAS-1884    JIRA:BOT-3634    qTest:54017400    PI:11
    [Documentation]  Ensure the compliance requirements screen is displayed under certain conditions

    Setup Carrier 'with' Company Admin group and with Salesforce Data Capture permission
    Setup Salesforce Data Capture App Completed    N
    Log Carrier into eManager with Test Carrier
    Assert Compliance Requirements Screen    True

Compliance Requirements screen is not displayed for app_completed 'Y'
    [Tags]    JIRA:ATLAS-1884    JIRA:BOT-3634    qTest:54017403    PI:11
    [Documentation]  Ensure the compliance requirements screen is not displayed when app_completed is set to 'Y'

    Setup Carrier 'with' Company Admin group and with Salesforce Data Capture permission
    Setup Salesforce Data Capture App Completed    Y
    Log Carrier into eManager with Test Carrier
    Assert Compliance Requirements Screen

Compliance Requirements screen is not displayed for app_completed unset
    [Tags]    JIRA:ATLAS-1884    JIRA:BOT-3634    qTest:54017455    PI:11
    [Documentation]  Ensure the compliance requirements screen is not displayed when there's no record for the carrier on salesforce_data_capture table

    Setup Carrier 'with' Company Admin group and with Salesforce Data Capture permission
    Setup Salesforce Data Capture App Completed
    Log Carrier into eManager with Test Carrier
    Assert Compliance Requirements Screen

Compliance Requirements screen is not displayed for not ADMIN
    [Tags]    JIRA:ATLAS-1884    JIRA:BOT-3634    qTest:54017594    PI:11
    [Documentation]  Ensure the compliance requirements screen is not displayed when the user has no COMPANY_ADMIN group

    Setup Carrier 'without' Company Admin group and with Salesforce Data Capture permission
    Setup Salesforce Data Capture App Completed    N
    Log Carrier into eManager with Test Carrier
    Assert Compliance Requirements Screen

*** Keywords ***
Setup Carrier '${flag}' Company Admin group and with Salesforce Data Capture permission
    [Documentation]  Keyword Setup for Company Admin group and Salesforce Data Capture permission

    Get Into DB  MySQL
    ${condition}    Run Keyword If    '${flag}'=='with'    Set Variable    sugx.group_id='COMPANY_ADMIN'
    ...    ELSE    Set Variable    su.user_id NOT IN (SELECT DISTINCT user_id FROM sec_user_group_xref WHERE group_id='COMPANY_ADMIN')
    #Get user_id from the last 100 logged to avoid mysql error with/without COMPANY_ADMIN group
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_group_xref sugx ON su.user_id = sugx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]{6}$'
    ...    AND ${condition}
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    #Get carrier with/without COMPANY_ADMIN group
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status='A'
    ...  AND member_id IN ${carrier_list}
    ...  AND member_id NOT IN ('101509');
    ${carrier}    Find Carrier Variable  ${carrier_query}    member_id
    #Set SALESFORCE_DATA_CAPTURE permission to the carrier
    Ensure Carrier has User Permission    ${carrier.id}    SALESFORCE_DATA_CAPTURE
    #Set carrier as suite variable
    Set Suite Variable  ${carrier}

Setup Salesforce Data Capture App Completed
    [Documentation]  Setup app completed value in salesforce_data_capture table
    [Arguments]  ${value}=False

    # Query list
    ${salesforcedc_select_query}  Catenate  SELECT *
    ...    FROM salesforce_data_capture
    ...    WHERE carrier_id = '${carrier.id}';
    ${salesforcedc_update_query}  Catenate  UPDATE salesforce_data_capture
    ...    SET app_completed = '${value}'
    ...    WHERE carrier_id = '${carrier.id}';
    ${salesforcedc_insert_query}  Catenate  INSERT INTO salesforce_data_capture
    ...    VALUES ('${carrier.id}', '${value}');
    ${salesforcedc_delete_query}  Catenate  DELETE FROM salesforce_data_capture
    ...    WHERE carrier_id = '${carrier.id}';
    # For app_completed unset
    Run Keyword and Return If    '${value}' == 'False'    Execute Sql String    ${salesforcedc_delete_query}
    # For app_completed set
    ${has_value}    Run Keyword And Return Status    Row Count is Equal to X    ${salesforcedc_select_query}    1
    Run Keyword If    ${has_value}    Execute Sql String    ${salesforcedc_update_query}
    ...    ELSE    Execute Sql String    ${salesforcedc_insert_query}

Log Carrier into eManager with Test Carrier
    [Documentation]  Log carrier into eManager with Company Admin group and Salesforce Data Capture permission

    Open eManager  ${carrier.id}  ${carrier.password}

Assert Compliance Requirements Screen
    [Documentation]  Setup app completed value in salesforce_data_capture table
    [Arguments]  ${show}=False

    Wait Until Page Contains    Logged in as:
    Run Keyword If    ${show}    Page Should Contain    Compliance Requirements
    ...    ELSE    Page Should Not Contain    Compliance Requirements