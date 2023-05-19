*** Settings ***
Test Timeout  5 minutes

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.ws.CardManagementWS
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown  Time to Teardown

Force Tags  eManager

*** Variables ***
# Final Variables
${USER}                    100511
${INACTIVE_CARD_STATUS}    I
${PROMPT_DRIVER_ID_NAME}   Driver ID
${PROMPT_DRIVER_ID_CODE}   DRID
${PROMPT_NAME_COLUMN}      2
${PROMPT_DELETE_COLUMN}    6
${TEST_VALUE}              CHANGE EMBOSS TEST

${card_num}
${original_emboss}  ${EMPTY}
${passwd}

*** Test Cases ***
Card without Card Misc Record
    [Tags]  refactor
    Open Browser And Log In
    Search a Card Without Misc Records
    Navigate To Manager Cards > View/Update Cards
    Search And Select Card
    Ensure you can select the card and each function works

Card with Card Misc Record
    [Tags]  refactor
    Open Browser And Log In
    Search a Card With Misc Records
    Change Card Emboss
    Navigate To Manager Cards > View/Update Cards
    Search And Select Card
    Ensure you can select the card and each function works

*** Keywords ***
Open Browser And Log In
    get into db  TCH
    Get Carrier Password
    open emanager   ${USER}  ${passwd}
    Maximize Browser Window

Navigate To Manager Cards > View/Update Cards
    Mouse Over      id=menubar_1x2
    Mouse Over      id=TCHONLINE_CARDSx2
    Click Element   id=CARDS_MANAGE_CARDSx2

Search And Select Card
    Click Element   xpath=//input[@value="NUMBER"]
    Input Text      xpath=//input[@name="cardSearchTxt"]  ${card_num}
    Click Element   name=searchCard
    Click Element   //a[contains(@href,'/cards/CardPromptManagement.action') and contains(@href,'${card_num.strip()}')]

Ensure you can select the card and each function works
    [Documentation]  Activate Card, Change Policy Information and Adding a new prompt.
    # Change Card Status to Active
    Click Element  xpath=//input[@name="card.header.status" and @value="ACTIVE"]
    # Change Information to Card
    Click Element  xpath=//input[@name="card.header.infoSource" and @value="CARD"]
    Click Element  name=saveCardInformation
    Element Should Be Visible  name=createPromptCard
    # Add Driver Id Prompt
    Click Element  name=createPromptCard
    Select From List By Value  name=cardInfo.infoId  ${PROMPT_DRIVER_ID_CODE}
    Click Element  name=validationInformation
    Click Element  name=processValidationRules
    Click Element  name=nextToCheckType
    Element Should Be Visible  xpath=//ul[@class='messages']//li  You have successfully created the prompt of (${PROMPT_DRIVER_ID_CODE})

Search a Card Without Misc Records
    ${query}  Catenate
    ...         SELECT card_num FROM cards c
    ...         WHERE NOT EXISTS (SELECT 1 FROM card_misc cm WHERE cm.card_num = c.card_num)
    ...         AND c.status != '${INACTIVE_CARD_STATUS}'
    ...         AND c.carrier_id = ${USER}
    ...         LIMIT 1
    ${card_num}  Query and Strip  ${query}
    set global variable  ${card_num}

Search a Card With Misc Records
    ${query}  Catenate
    ...         SELECT card_num FROM cards c
    ...         WHERE EXISTS (SELECT 1 FROM card_misc cm WHERE cm.card_num = c.card_num)
    ...         AND c.status != '${INACTIVE_CARD_STATUS}'
    ...         AND c.carrier_id = ${USER}
    ...         LIMIT 1
    ${card_num}  Query and Strip  ${query}
    set global variable  ${card_num}

Change Card Emboss
    Save Original Emboss
    execute sql string  dml=update card_misc SET second_line = '${TEST_VALUE}' WHERE card_num = '${card_num}'

Save Original Emboss
    ${original_emboss}  query and strip  SELECT second_line FROM card_misc WHERE card_num = '${card_num}'
    set global variable  ${original_emboss}

Get Carrier Password
    ${passwd}  Query and Strip  SELECT passwd FROM member m WHERE m.member_id = ${USER}
    set global variable  ${passwd}

Time to Teardown
    Restore Default Values
    Close Browser

Restore Default Values
    Navigate To Manager Cards > View/Update Cards
    Search And Select Card
    Element Should Be Visible  name=createPromptCard
    # Delete Driver Id Prompt
    ${count}  Get Element Count   //table[@id="card"]//tbody//tr
    set global variable  ${count}
    FOR  ${i}  IN RANGE  1  ${count}+1
       ${prompt}  Get Text  //table[@id="card"]//tbody//tr[${i}]//td[${PROMPT_NAME_COLUMN}]
       run keyword if  '${prompt}'=='${PROMPT_DRIVER_ID_NAME}'  Delete Prompt And Confirm   ${i}
       run keyword if  ${i}>10  exit for loop
    END
    # Change Information back to Policy
    Click Element  xpath=//input[@name="card.header.infoSource" and @value="POLICY"]
    Click Element  name=saveCardInformation
    run keyword if  '${original_emboss}'!='${EMPTY}'  Restore Card Emboss

Delete Prompt And Confirm
    [Arguments]  ${i}
    Click Element  xpath=//table[@id="card"]//tbody//tr[${i}]//td[${PROMPT_DELETE_COLUMN}]
    Confirm Action

Restore Card Emboss
    execute sql string  dml=update card_misc SET second_line = '${original_emboss}' WHERE card_num = '${card_num}'