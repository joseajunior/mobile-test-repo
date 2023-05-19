*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setup Carrier for Tax Update
Test Teardown  Close Browser

Force Tags  eManager

*** Variables ***
${carrier}

*** Test Cases ***
Add new tax columns
    [Tags]    JIRA:FRNT-2086    JIRA:BOT-4968    qTest:89556180
    [Documentation]  On the Tax Update Screen, new filters added to the UIand new Changes made in the Order of table columns

    Log Carrier into eManager with Tax Update permission
    Go to Select Program > Management Application > Tax Update
    Verify the changes for column order
    Verify the filter changes

*** Keywords ***
Setup Carrier for Tax Update
    [Documentation]  Keyword Setup Carrier for Tax Update

    Get Into DB  MySQL
    # Get user_id from the last 100 logged to avoid mysql error.
    ${carrier_list_query}  Catenate  SELECT DISTINCT su.user_id
    ...    FROM sec_user su
    ...    JOIN sec_user_role_xref surx ON su.user_id = surx.user_id
    ...    WHERE su.user_id REGEXP '^[0-9]+$'
    ...    AND surx.role_id='TAX_UPDATE'
    ...    AND surx.menu_visible=1
    ...    ORDER BY login_attempted DESC LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')
    ${carrier_query}  Catenate  SELECT member_id
    ...  FROM member
    ...  WHERE status = 'A'
    ...  AND mem_type = 'C'
    ...  AND member_id IN ${carrier_list}
    ...  AND member_id NOT BETWEEN 400000 AND 649999;
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Log Carrier into eManager with Tax Update permission
    [Documentation]  Log carrier into eManager with Tax Update permission

    Open eManager  ${carrier.id}  ${carrier.password}

Go to Select Program > Management Application > Tax Update
    [Documentation]  Go to Select Program > Management Application > Tax Update

    Go To  ${emanager}/cards/TaxUpdate.action
    Wait Until Page Contains    Taxes

Check Sibling
    [Documentation]  Check first column's following sibling label
    [Arguments]    ${first_column}    ${expected_column}

    ${sibling}    Get Text    //th[text()='${first_column}']/following-sibling::th[1]
    Should Be Equal As Strings    ${sibling}    ${expected_column}

Verify the changes for column order
    [Documentation]  Check the columns order

    Check Sibling    State/Province    Taxing Entity
    Check Sibling    Taxing Entity    Taxing Entity Desc
    Check Sibling    Group    Effective Date
    Check Sibling    Effective Date    Description
    Check Sibling    Description    Fuel Type

Check Dropdown Label
    [Documentation]  Check element's label
    [Arguments]    ${path}    ${expected_label}

    ${label}    Get Text    ${path}
    Should Be Equal As Strings    ${label}    ${expected_label}

Check Entity Dropdown is not Empty
    [Documentation]  Get entity items and check its length

    Wait Until Page Contains Element    //*[@id="entity"]/option[1]
    ${list}    Get List Items    entity
    ${entity_lenght}    Get Length    ${list}
    Should Not Be Equal As Numbers    ${entity_lenght}    0

Start and End Date Are Disabled
    [Documentation]  Start and End date are disabled

    Page Should Contain Element    //*[@id="filterStartDate" and @disabled]
    Page Should Contain Element    //*[@id="filterEndDate" and @disabled]

Start and End Date Are Enabled
    [Documentation]  Start and End date are enabled

    Page Should Not Contain Element    //*[@id="filterStartDate" and @disabled]
    Page Should Not Contain Element    //*[@id="filterEndDate" and @disabled]

Verify the filter changes
    [Documentation]  Check filter changes

    Check Dropdown Label    //*[@id="state"]/parent::*/preceding-sibling::*/label    State/Province
    Select From List By Index    state    1
    Check Dropdown Label    //*[@id="entity"]/parent::td/preceding-sibling::td[1]/label    Taxing Entity Desc
    Check Entity Dropdown is not Empty
    Page Should Contain Element    showFutureTaxes
    Start and End Date Are Enabled
    Select Checkbox    showFutureTaxes
    Start and End Date Are Disabled