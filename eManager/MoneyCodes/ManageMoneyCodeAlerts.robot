*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setup Carrier for Money Code Alerts
Test Teardown  Close Browser

Force Tags  eManager

*** Variables ***
${carrier}
${alertActionName}

*** Test Cases ***
Manage Money Code Alerts - Remove "Opt Out" in the drop down box
    [Tags]  qTest:29068047  JIRA:BOT-3572
    [Documentation]  There should be no 'OPT OUT' item in drop down box of Alert Action Name.

    Log Carrier into eManager with Money Code Alerts permission
    Go to Select Program > Manage Money Code Alerts
    Search for Carrier Id  ${carrier.id}
    Assert Alert Action Name drop down has no 'OPT OUT' option

*** Keywords ***
Setup Carrier for Money Code Alerts
    [Documentation]  Keyword Setup for Money Code Alerts

    Get Into DB  MySQL
    #Get user_id from the last 100 logged to avoid mysql error.
    ${carrierListQuery}  Catenate  SELECT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND surx.role_id='MONEY_CODE_FRAUD_CONFIG'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${queryResult}  Query And Strip To Dictionary  ${carrierListQuery}
    ${carrierList}  Get From Dictionary  ${queryResult}  user_id
    ${carrierList}  Evaluate  ${carrierList}.__str__().replace('[','(').replace(']',')')
    ${carrierQuery}  Catenate  SELECT member_id FROM member WHERE status='A' AND member_id IN ${carrierList}
    ${carrier}  Find Carrier Variable  ${carrierQuery}    member_id
    Set Suite Variable  ${carrier}

Log Carrier into eManager with Money Code Alerts permission
    [Documentation]  Log carrier into eManager with Manage Money Code Alerts permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Manage Money Code Alerts
    [Documentation]  Go to Select Program > Manage Money Code Alerts

    Go To  ${emanager}/cards/MoneyCodeFraudConfig.action

Search for Carrier Id
    [Arguments]  ${searchCarrierId}
    [Documentation]  Search for carrier id in Manage Money Code Alerts

    Input Text  carrierId  ${searchCarrierId}
    Click Element  submitCarrierId
    Page Should Contain  Create Manage Money Code Alerts

Assert Alert Action Name drop down has no '${item}' option
    [Documentation]  Check if Alert Action Name drop down doesn't contain OPT OUT

    ${alertActionName}  Get Text  //*[@name="actionNameSel" and @id="actionNameSel"]
    Should Not Contain  ${alertActionName}  ${item}