*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Portal  Credit Manager  weekly
Documentation  This file creates and update a letter on the Credit Manager Home Page > Letter Manager tab
Suite Setup  Open Browser And Login To Portal
Suite Teardown  Close Everything

*** Variables ***
${name}  Robot
${description}  Robot
${letter}  Letter
${subject}  Robot Subject
${edited_description}  New Robot Description
${edited_subject}  New Robot Subject

*** Test Cases ***
Create a Letter
    [Tags]  JIRA:BOT-1700  qTest:31431908  Regression
    [Documentation]  Make sure you can create and update letters through Credit Manager on Portal
    [Setup]  Go To Credit Manager And Open Letter Manager
    Create And Save Letter
    Is On Letter Manager Home

Check If The Letter Exists
    [Tags]  Regression
    [Documentation]  Make sure you can find a letter through Credit Manager on Portal
    Check If The Letter Exists

Edit a Letter
    [Tags]  JIRA:BOT-1701  qTest:31432002  Regression
    [Documentation]  Make sure you can edit a letter through Credit Manager on Portal
    Check If The Letter Exists
    Select Letter
    Edit And Save Letter
    Is On Letter Manager Home

Delete a Letter
    [Tags]  JIRA:BOT-1702  qTest:31432035  Regression
    [Documentation]  Make sure you can delete a letter through Credit Manager on Portal
    Check If The Letter Exists  ${edited_subject}
    Select Letter
    Delete Letter
    Is On Letter Manager Home
    Check If The Letter Not Exists  ${edited_subject}

*** Keywords ***

Close Everything
    Close All Browsers

Open Browser And Login To Portal
    Open Browser to portal
    Log Into Portal  ${PortalUsername}  ${PortalPassword}

Go To Credit Manager And Open Letter Manager
    Wait Until Element Is Visible  //*[text()[contains(.,"Credit Manager")]]  timeout=30
    Select Portal Program  Credit Manager
    Wait Until Element Is Visible  //*[@id="pm_3"]  timeout=20
    Click Element  //*[@id="pm_3"]

Create And Save Letter
    Wait Until Element Is Enabled  //*[@id="list"]/fieldset/a[1]  timeout=60
    Click Element  //*[@id="list"]/fieldset/a[1]
    Fill Letter  ${name}  ${description}  ${subject}  ${letter}
    Save Letter

Check If The Letter Exists
    [Arguments]  ${element}=${subject}
    Is On Letter Manager Home
    Page Should Contain Element  //*[@id="letterTable"]//descendant::*[contains(text(), '${element}')]

Check If The Letter Not Exists
    [Arguments]  ${element}=${subject}
    Is On Letter Manager Home
    Page Should Not Contain Element  //*[@id="letterTable"]//descendant::*[contains(text(), '${element}')]

Is On Letter Manager Home
    Wait Until Page Contains Element  //*[@id="letterTable"]  timeout=30
    Wait Until Element Is Enabled  //*[@id="letterTable"]/tbody/tr[2]/td[2]  timeout=30
    Wait Until Element Is Visible  //*[@id="letterTable"]  timeout=120


Select Letter
    Click Element  //*[@id="letterTable"]//descendant::*[contains(text(), '${name}')]

Edit And Save Letter
    Wait Until Element Is Enabled  //*[@id="list"]/fieldset/a[2]  timeout=60
    Click Element  //*[@id="list"]/fieldset/a[2]
    Fill Letter  ${name}  ${edited_description}  ${edited_subject}  ${letter}  True
    Save Letter

Save Letter
    Click Element  //*[@class="jimg jsave"]

Fill Letter
    [Arguments]  ${name}  ${description}  ${subject}  ${letter}  ${edit_mode}=False
    Wait Until Element Is Visible  //*[@id="letter"]  timeout=30
    Run Keyword If  '${edit_mode}'!='True'  Clear Element Text  request.letter.name  #name shouldn't be editable
    Wait Until Element Is Enabled  request.letter.description  timeout=120  #ac
    Clear Element Text  request.letter.description
    Wait Until Element Is Enabled  request.letter.subject  timeout=30  #ac
    Clear Element Text  request.letter.subject
    Run Keyword If  '${edit_mode}'!='True'  Input Text  request.letter.name  ${name}
    Input Text  request.letter.description  ${description}
    Input Text  request.letter.subject  ${subject}
    Wait Until Page Contains Element  xpath=//iframe[@id="wysiwygwysiwyg_editor"]
    Wait Until Element Is Visible  xpath=//iframe[@id="wysiwygwysiwyg_editor"]
    Select Frame  xpath=//iframe[@id="wysiwygwysiwyg_editor"]
    Wait Until Element Is Enabled  xpath=/html/body  timeout=30  #ac
    Input Text  xpath=/html/body   ${letter}
    Unselect Frame

Delete Letter
    Wait Until Element Is Enabled  //*[@id="list"]/fieldset/a[3]  timeout=30
    Click Element  //*[@id="list"]/fieldset/a[3]
    Wait Until Element Is Enabled  //*[@id="deleteConfirm_content"]/div[2]/a[1]  timeout=30
    Click Element  //*[@id="deleteConfirm_content"]/div[2]/a[1]
    Sleep  5