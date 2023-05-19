*** Settings ***
Library  Process

Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Time to Setup
Force Tags  eManager

*** Variables ***
${carrier}  324878
${subuser}  324878Robot  #subuser does not exist in DIT and AWS-DIT
${passwd}  Tester123
${card}  7083051932487800006
${ipolicy}  1

*** Test Cases ***

Adding Prompt
    [Tags]  Fire  qTest:36065877  refactor
    [Documentation]  Make sure a sub user can add/edit/delete a prompt to a card
    Open eManager  ${subuser}  ${passwd}
    go to  ${emanager}/cards/CardLookup.action
    click element  //*[@id="cardSummary"]//descendant::*[contains(text(),'${card}')]
    Adding UNIT Prompt
    Validate Prompt in DB
    Delete Prompt

*** Keywords ***
Time to Setup
# change information source to card
    get into db  TCH
    execute sql string  dml=update cards SET infosrc = 'C' WHERE card_num = '${card}';
    execute sql string  dml=delete FROM card_inf WHERE card_num = '${card}' AND info_id = 'UNIT';
    execute sql string  dml=delete FROM def_info WHERE carrier_id = '${carrier}' AND ipolicy = '${ipolicy}' and info_id = 'UNIT';


Adding UNIT Prompt

    Click Element   name=createPromptCard
    click element  xpath=//*[@value='UNIT']
    click element  xpath=//*[@name='validationInformation']
    click element  xpath=//*[@value='EXACT_MATCH']
    click element  xpath=//*[@name='processValidationRules']
    input text   xpath=//*[@name='cardInfo.matchValue']  1234
    click element  xpath=//*[@name='finishCardPromptBtn']

Validate Prompt in DB
    Get Into DB  tch
    ${output}  Catenate  SELECT info_id FROM card_inf WHERE info_id = 'UNIT' AND card_num = '${card}'
    ${stripper}  Query And Strip  ${output}
    Should Be Equal As Strings  ${stripper}  UNIT

Delete Prompt
    sleep  2
    click element  //*[contains(text(),'Unit Number')]/..//*[@name='deleteCardPrompt']
    Handle Alert
    sleep  3
    close browser