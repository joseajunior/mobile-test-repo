*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

Suite Setup       SUITE:Setup
Suite Teardown    SUITE:Teardown

*** Variables ***
${code}   001T
${description}   Robot Prompt Test
${newDescription}    EDITED Robot Prompt

*** Test Cases ***
Create a New Prompt - ALL PARTNERS
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting All Partners checkbox
    Go to Info Prompts Page
    Create a New Prompt    ${true}
    Check New Prompt Added on UI   ${description}    TCH    SHELL    IRVING    IMPERIAL
    Check New Prompt Added on DB   ${description}    TCH    Shell    Irving    Imperial
    [Teardown]  TEST:Teardown   TCH    Shell    Irving    Imperial

Create a New Prompt - TCH
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting TCH as a partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}    TCH
    Check New Prompt Added on UI   ${description}    TCH
    Check New Prompt Added on DB   ${description}    TCH
    [Teardown]  TEST:Teardown   TCH

Create a New Prompt - SHELL
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting Shell as a partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}    SHELL
    Check New Prompt Added on UI   ${description}    SHELL
    Check New Prompt Added on DB   ${description}    Shell
    [Teardown]  TEST:Teardown   Shell

Create a New Prompt - IRVING
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting Irving as a partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}    IRVING
    Check New Prompt Added on UI   ${description}    IRVING
    Check New Prompt Added on DB   ${description}    Irving
    [Teardown]  TEST:Teardown   Irving

Create a New Prompt - IMPERIAL
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting Imperial as a partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}    IMPERIAL
    Check New Prompt Added on UI   ${description}    IMPERIAL
    Check New Prompt Added on DB   ${description}    Imperial
    [Teardown]  TEST:Teardown   Imperial

Create a New Prompt - TCH and IRVING
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting TCH and Irving as a partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}    TCH    IRVING
    Check New Prompt Added on UI   ${description}    TCH    IRVING
    Check New Prompt Added on DB   ${description}    TCH    Irving
    [Teardown]  TEST:Teardown   TCH    Irving

Create a New Prompt - TCH and SHELL and IMPERIAL
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting TCH, Shell and Imperial as a partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}    TCH    SHELL    IMPERIAL
    Check New Prompt Added on UI   ${description}    TCH    SHELL    IMPERIAL
    Check New Prompt Added on DB   ${description}    TCH    Shell   Imperial
    [Teardown]  TEST:Teardown   TCH    Shell   Imperial

Create a New Prompt - IRVING and IMPERIAL
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120239956   API:Y
    [Documentation]    Create a new prompt selecting Irving and Imperial as a partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}   IRVING    IMPERIAL
    Check New Prompt Added on UI   ${description}    IRVING    IMPERIAL
    Check New Prompt Added on DB   ${description}    Irving    Imperial
    [Teardown]  TEST:Teardown    Irving    Imperial

Edit Prompt Description - TCH
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120251587   API:Y
    [Documentation]    Edit prompt description on TCH partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}   TCH
    Check New Prompt Added on UI   ${description}    TCH
    Check New Prompt Added on DB   ${description}    TCH
    Edit a New Prompt
    Check New Prompt Added on UI   ${newDescription}    TCH
    Check New Prompt Added on DB   ${newDescription}    TCH
    [Teardown]  TEST:Teardown    TCH

Edit Prompt Description - SHELL
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120251587   API:Y
    [Documentation]    Edit prompt description on Shell partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}   SHELL
    Check New Prompt Added on UI   ${description}    SHELL
    Check New Prompt Added on DB   ${description}    Shell
    Edit a New Prompt
    Check New Prompt Added on UI   ${newDescription}    SHELL
    Check New Prompt Added on DB   ${newDescription}    Shell
    [Teardown]  TEST:Teardown    Shell

Edit Prompt Description - IRVING
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120251587   API:Y
    [Documentation]    Edit prompt description on Irving partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}   IRVING
    Check New Prompt Added on UI   ${description}    IRVING
    Check New Prompt Added on DB   ${description}    Irving
    Edit a New Prompt
    Check New Prompt Added on UI   ${newDescription}    IRVING
    Check New Prompt Added on DB   ${newDescription}    Irving
    [Teardown]  TEST:Teardown    Irving

Edit Prompt Description - IMPERIAL
    [Tags]   Q2:2023   JIRA:ROCKET-411   qtest:120251587   API:Y
    [Documentation]    Edit prompt description on Imperial partner
    Go to Info Prompts Page
    Create a New Prompt    ${false}   IMPERIAL
    Check New Prompt Added on UI   ${description}    IMPERIAL
    Check New Prompt Added on DB   ${description}    Imperial
    Edit a New Prompt
    Check New Prompt Added on UI   ${newDescription}    IMPERIAL
    Check New Prompt Added on DB   ${newDescription}    Imperial
    [Teardown]  TEST:Teardown    Imperial

*** Keywords ***
SUITE:Setup
    [Documentation]   Initialize the test suite
    Open EManager   ${intern}   ${internPassword}
    Ensure User Permission for Testing

SUITE:Teardown
    [Documentation]   Close browser
    Close Browser

Ensure User Permission for Testing
    [Tags]  qtest
    [Documentation]   Ensure that the user has the right permissions
    Ensure Carrier has User Permission    ${intern}    INFO_PROMPTS
    Ensure Carrier has User Permission    ${intern}    PARKLAND_COMPANY_MANAGER
    Ensure Carrier has User Permission    ${intern}    PARKLAND_CUSTOMER_INFO_NO_PASS

Go to Info Prompts Page
    [Tags]  qtest
    [Documentation]   Go to Info Prompts page on eManager
    Go to   ${emanager}/mgnt/InfoPrompts.action
    Wait Until Page Contains    Info Prompts

Create a New Prompt
    [Tags]  qtest
    [Documentation]   Create a new prompt under Info Prompts page on eManager
    [Arguments]    ${allPartners}=${false}    @{partners}
    Click Button  addNew
    Input Text    name=prompt.code     ${code}
    Input Text    name=prompt.description     ${description}
    IF     ${allPartners} == ${false}
        Click Element    //*[@id="allPartner"]
        Checkbox Should Not Be Selected    //*[@id="allPartner"]
        Select From List By Value    id=partners    @{partners}
    ELSE
        Checkbox Should Be Selected    //*[@id="allPartner"]
    END
    Wait Until Element Is Visible     name=addValue
    Click Element    //*[@name="addValue"]
    Page Should Contain     You have successfully Added the Prompt (${code})

Edit a New Prompt
    [Tags]  qtest
    [Documentation]   Edit a prompt under Info Prompts page on eManager
    Click Element     //*[@id="row"]/tbody/tr[1]/td[5]/form/input[6]
    Input Text     name=prompt.description     ${newDescription}
    Click Element    //*[@name="updateValue"]
    Page Should Contain    You have successfully Updated the Prompt (${code})

Check New Prompt Added on UI
    [Tags]  qtest
    [Documentation]   Check if the new prompt was add on Info Prompts page
    [Arguments]    ${description}    @{partners}
    Click Element    //a[contains(text(),'Code')]
    Wait Until Page Contains    ${code}
    ${count}    Evaluate   1
    FOR    ${partner}    IN    @{partners}
        Page Should Contain Element    //*[@id="row"]/tbody/tr[${count}]/td[contains(text(),'${code}')]
        Page Should Contain Element    //*[@id="row"]/tbody/tr[${count}]/td[contains(text(),'${description}')]
        Page Should Contain Element    //*[@id="row"]/tbody/tr[${count}]/td[contains(text(),'${partner}')]
        ${count}    Evaluate   ${count}+1
    END

Check New Prompt Added on DB
    [Tags]  qtest
    [Documentation]   Check if the new prompt was add on the database:
        ...    SELECT * FROM info_req WHERE info_id = 'code' AND info_desc = 'description'
    [Arguments]    ${description}    @{db_instances}
    FOR   ${db}   IN   @{db_instances}
        Get Into DB  ${db}
        ${query}  Catenate    SELECT * FROM info_req WHERE info_id = '${code}' AND info_desc = '${description}'
        ${status}  Run Keyword And Return Status  Row Count is Equal to X   ${query}   1
        Should Be True    '${status}'=='${True}'
    END

Delete Added Prompts
    [Tags]  qtest
    [Documentation]   Delete added prompts
    [Arguments]    @{db_instances}
    FOR   ${db}   IN   @{db_instances}
        Get Into DB  ${db}
        ${query}   Catenate    DELETE FROM info_req WHERE info_id = '${code}'
        Execute Sql String    ${query}
    END

TEST:Teardown
    [Documentation]   Test teardown to delete added prompts
    [Arguments]    @{db_instances}
    Delete Added Prompts    @{db_instances}