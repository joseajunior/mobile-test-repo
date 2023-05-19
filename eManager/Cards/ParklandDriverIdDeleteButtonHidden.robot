*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup    Setup Parkland Carrier for View/Update Cards
Test Teardown  Close Browser

Force Tags  eManager

*** Variables ***
${carrier}

*** Test Cases ***
Hide delete button at the card level
    [Tags]    JIRA:FRNT-2087  JIRA:BOT-4933  qTest:56306617
    [Documentation]    Ensure that no Delete button exist on Card which has Driver id for Parkland carrier

    Log Carrier into eManager with View/Update Cards permission
    Go to Select Program > Manage Cards > View/Update Cards
    Select a card number
    Click on Add Prompts
    Add a Driver ID
    Assert Delete Button is Hidden

*** Keywords ***
Setup Parkland Carrier for View/Update Cards
    [Documentation]  Setup Parkland Carrier for View/Update Cards

    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT distinct member_id
       ...    FROM member m
       ...    INNER JOIN cards c
       ...    ON c.carrier_id = m.member_id
       ...    WHERE mem_type = 'C'
       ...    AND m.status = 'A'
       ...    AND member_id BETWEEN 2500000 AND 2999999;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_member_id}  Get From Dictionary  ${list}  member_id
    ${list_member_id}  Evaluate  ${list_member_id}.__str__().replace('[','(').replace(']',')')
    Get Into DB  MYSQL
    # Get user_id from the last 150 logged to avoid mysql error
    ${query}  Catenate  SELECT user_id
    ...    FROM sec_user
    ...    WHERE user_id REGEXP '^[0-9]+$'
    ...    AND user_id IN ${list_member_id}
    ...    ORDER BY login_attempted DESC LIMIT 150;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_user_id}  Get From Dictionary  ${list}  user_id
    ${list_user_id}  Evaluate  ${list_user_id}.__str__().replace('[','(').replace(']',')')
    Get Into DB    TCH
    # Get from member_id
    ${query}  Catenate  SELECT DISTINCT member_id
    ...    FROM member
    ...    WHERE member_id IN ${list_user_id}
    ...    AND member_id NOT IN ('2500019', '2500058', '2500052', '2500000', '2500001');
    # Find carrier with given query and set as suite variable
    ${carrier}    Find Carrier Variable    ${query}    member_id
    Set Suite Variable  ${carrier}
    # Ensure carrier has View/Update Cards permission
    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_CARDS

Log Carrier into eManager with View/Update Cards permission
    [Documentation]  Log carrier into eManager with View/Update Cards permission

    Open eManager  ${carrier.id}  ${carrier.password}    ChangeCompanyHeader=False
    Change Company Header    ${carrier.id}    C    parkland_carrier

Go to Select Program > Manage Cards > View/Update Cards
    [Documentation]  Go to Select Program > Manage Cards > View/Update Cards

    Go To  ${emanager}/cards/CardLookup.action
    Wait Until Page Contains     Lookup Information

Remove Override
    [Documentation]    Remove override from card

    Click Element    name=deleteCardOverride
    Select a card number

Select a card number
    [Documentation]  Select first card number from the list

    Click Button    name=searchCard
    Click Element   //*[@id="cardSummary"]/tbody/tr[1]/td[1]
    Wait Until Page Contains Element     //*[@value='BOTH']
    ${status}    Run Keyword And Return Status    Page Should Contain Element    name=deleteCardOverride
    Run Keyword If    '${status}'=='True'    Remove Override

Click on Add Prompts
    [Documentation]  Click to add a new prompt

    Click Element    //*[@value='BOTH']
    Click Button    name=saveCardInformation
    Wait Until Page Contains Element     name=createPromptCard
    Click Button    name=createPromptCard
    Wait Until Page Contains Element    name=cancel

Add Driver ID
    [Documentation]  Add Driver ID prompt

    Click Element   //select[@name='cardInfo.infoId']//option[@value='DRID']
    Click Button    name=validationInformation
    Wait Until Page Contains Element    name=cardInfo.matchValue
    Input Text      name=cardInfo.matchValue     1234
    Click Button    name=finishCardPromptNoValidationBtn
    Wait Until Page Contains     You have successfully created the prompt of

Add a Driver ID
    [Documentation]  Add a Driver ID prompt

    ${status}    Run Keyword And Return Status    Page Should Contain Element    //select[@name='cardInfo.infoId']//option[@value='DRID']
    Run Keyword If    '${status}'=='True'    Add Driver ID
    ...    ELSE    Click Element    name=cancel

Assert Delete Button is Hidden
    [Documentation]  Verify there is no delete button for Driver ID prompt

    Page Should Contain Element    //input[@value="DRID"]
    Page Should Not Contain Element    //input[@value="DRID"]//parent::form/input[@name="deleteCardPrompt"]