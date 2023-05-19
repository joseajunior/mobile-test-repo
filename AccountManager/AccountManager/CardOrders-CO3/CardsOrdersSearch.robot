*** Settings ***
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

Suite Setup    Setup Columns Positions and Label
Test Teardown    Close Browser
Suite Teardown    Disconnect from Database

*** Variables ***
${carrier_id}
${column_data}
# xpaths
${submit}    //*[@id="cardOrder2SearchContainer"]//button[contains(text(), 'Submit')]
${business_partner}    //*[@class="dataTables_scrollHeadInner"]//select[@class="cardOrder2BusinessPartnerSelect searchFilter"]

*** Test Cases ***
Add new columns to Card Order search screen in Account Manager
    [Tags]   JIRA:ATLAS-1252    JIRA:BOT-5085    qTest:120182203    Q2:2023
    [Documentation]    Add new columns to Card Order search screen in Account Manager

    Open Account Manager
    Select Card Orders Tab
    Check new search columns
    Select 'EFS' business partner
    Input search data for each column and check

*** Keywords ***
Setup Columns Positions and Label
    ${new_columns}    Create List    Shipping Address Line 1    Shipping Address Line 2    City    State    Postal Code
    ${new_columns_label}    Create List    address_1    address_2    city    state    zip
    ${new_columns_value}    Create Dictionary    Card Style=6
    ${new_columns_db}    Create Dictionary
    ${position}    Set Variable    12
    ${i}    Set Variable    0
    FOR  ${column}  IN  @{new_columns}
        Set To Dictionary    ${new_columns_value}    ${column}=${position}
        Set To Dictionary    ${new_columns_db}    ${column}=${new_columns_label[${i}]}
        ${position}    Evaluate    ${position}+1
        ${i}    Evaluate    ${i}+1
    END
    Set Suite Variable    ${new_columns_value}
    Set Suite Variable    ${new_columns_db}

Get '${column}' '${type}' xpath
    ${position}    Set Variable    ${new_columns_value["${column}"]}
    ${xpath}    Run Keyword If    "${type}"=="label"    Set Variable    //*[@id="DataTables_Table_1_wrapper"]//th[${position}]/input
    ...    ELSE    Set Variable    //*[@id="DataTables_Table_1"]/tbody/tr[1]/td[${position}]
    [Return]    ${xpath}

Select Card Orders Tab
    Wait Until Element is Visible    //*[@id="CardOrder2"]/span
    Click Element    //*[@id="CardOrder2"]/span
    Execute javascript       document.body.style.zoom="60%"

Check new search columns
    FOR  ${column}  IN  @{new_columns_value}
        ${xpath}    Get '${column}' 'label' xpath
        Wait Until Element is Visible    ${xpath}
    END

Select '${bp}' business partner
    Wait Until Element is Visible    ${business_partner}
    Select From List By Value    ${business_partner}    ${bp}

Get '${column}' data
    ${column}    Set Variable    ${new_columns_db["${column}"]}
    Get Into DB    TCH
    ${query}    Catenate    SELECT carrier_id, TRIM(${column}) as ${column}
    ...    FROM contact_audit
    ...    WHERE ${column} is not null
    ...    AND carrier_id NOT IN ('103866')
    ...    LIMIT 1;
    ${result}    Query And Strip to Dictionary    ${query}
    ${carrier_id}    Get From Dictionary    ${result}    carrier_id
    Set Test Variable    ${carrier_id}
    ${column_data}    Get From Dictionary    ${result}    ${column}
    Set Test Variable    ${column_data}

Input search data for each column and check
    Remove From Dictionary    ${new_columns_value}    Card Style
    FOR  ${column}  IN  @{new_columns_value}
        ${data}    Get '${column}' data
        ${label_xpath}    Get '${column}' 'label' xpath
        Wait Until Element is Visible    ${label_xpath}
        Input Text    ${label_xpath}    ${column_data}
        Input Text    //*[@id="DataTables_Table_1_wrapper"]//th[3]/input    ${carrier_id}
        Execute javascript       document.body.style.zoom="100%"
        Wait Until Element is Enabled    ${submit}
        Click Element    ${submit}
        Wait Until Loading Spinners Are Gone
        ${xpath}    Get '${column}' 'result' xpath
        Wait Until Element is Visible    ${xpath}
        ${screen_data}    Get Text    ${xpath}
        Should Be Equal as Strings    ${screen_data}    ${column_data}
        Execute javascript       document.body.style.zoom="60%"
        Clear Element Text    ${label_xpath}
    END
