*** Settings ***
Library  Process
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot

Suite Teardown  Close Browser
Suite Setup  Open Portal And Login
Force Tags  Integration  Shifty  Portal

*** Test Cases ***

Create A Letter
    [Tags]  qTest:31431908  refactor
    [Setup]  Navigate To Credit Manager Then Letter Manager Page
    Click To Add New Letter
    Fill the Letter Header using "AUTO" as Name Prefix, "This is description" as Description and "This is subject" as Subject
    Input "This is BLind Dutchmen" as Letter Body and Save
    Make Sure Letter Named "${letter_name}" Was Successfully Created
    [Teardown]  Go To Portal Main Page

Edit A Letter
    [Tags]  qTest:31432002
    [Setup]  Navigate To Credit Manager Then Letter Manager Page
    Click To Add New Letter
    Fill the Letter Header using "AUTO" as Name Prefix, "This is description" as Description and "This is subject" as Subject
    Input "This is BLind Dutchmen" as Letter Body and Save
    Select a Letter Named "${letter_name}" and Edit It
    Change the Letter Body To "This is the best team" and Save
    Make Sure The Body of The Letter Named "${letter_name}" Was Successfully Edited To "This is the best team"
    [Teardown]  Go To Portal Main Page

Delete A Letter
    [Tags]  qTest:31432035  refactor
    [Documentation]  This is to test if a user can delete a letter in letter manager
    [Setup]  Navigate To Credit Manager Then Letter Manager Page
    Click To Add New Letter
    Fill the Letter Header using "AUTO" as Name Prefix, "This is description" as Description and "This is subject" as Subject
    Input "This is BLind Dutchmen" as Letter Body and Save
    Select a Letter Named "${letter_name}" and Delete It
    Make Sure Letter Named "${letter_name}" Was Successfully Deleted
    [Teardown]  Go To Portal Main Page

*** Keywords ***
Open Portal and Login
    Open Browser to portal
    Log Into Portal

Navigate To Credit Manager Then Letter Manager Page
    Select Portal Program  Credit Manager
    Wait Until Element Is Enabled  xpath=//*[text()="Letter Manager"]  timeout=60
    Click Element  //*[text()="Letter Manager"]
    Wait Until Url Contains  CreditManagerWeb/LetterManager  timeout=120

Click To Add New Letter
    Wait Until Element Is Visible  xpath=//*[@id="letterTable"]  timeout=60
    Click Portal Button  Add

Fill the Letter Header using "${name}" as Name Prefix, "${description}" as Description and "${subject}" as Subject
    Wait Until Element Is Visible  request.letter.name  timeout=60
    Wait Until Element Is Enabled  request.letter.name  timeout=60
    Wait Until Element Is Enabled  request.letter.description  timeout=60
    Wait Until Element Is Enabled  request.letter.subject  timeout=60
    Set Focus To Element  request.letter.name
    ${timestamp}  getDateTimeNow  %y%m%d_%H:%M:%S
    ${letter_name}  Catenate  ${name}_${timestamp}
    Input Text  request.letter.name  ${letter_name}
    Input Text  request.letter.description  ${description}_${timestamp}
    Input Text  request.letter.subject  ${subject}_${timestamp}
    Set Test Variable  ${letter_name}

Input "${body}" as Letter Body and Save
    Wait Until Element Is Visible  //iframe[@id="wysiwygwysiwyg_editor"]  timeout=60
    Wait Until Element Is Enabled  //iframe[@id="wysiwygwysiwyg_editor"]  timeout=60
    Set Focus To Element  //iframe[@id="wysiwygwysiwyg_editor"]
    Send Text To Element  //iframe[@id="wysiwygwysiwyg_editor"]  ${body}
    Click Portal Button  Save

Go To Portal Main Page
    Go To  ${portal}

Select a Letter Named "${name}" and Edit It
    Refresh Page
    Wait Until Element Is Visible  xpath=//table[@id="letterTable"]  timeout=60
    Wait Until Element Is Enabled  xpath=//table[@id="letterTable"]  timeout=60
    Set Focus To Element  xpath=//table[@id="letterTable"]/tbody//div[contains(@onscroll, "getChild")]//div[text()="${name}"]
    click element  //table[@id="letterTable"]/tbody//div[contains(@onscroll, "getChild")]//div[text()="${name}"]
    double click element  //table[@id="letterTable"]/tbody//div[contains(@onscroll, "getChild")]//div[text()="${name}"]

Select a Letter Named "${name}" and Delete It
    Refresh Page
    Wait Until Element Is Visible  xpath=//table[@id="letterTable"]  timeout=60
    Wait Until Element Is Enabled  xpath=//table[@id="letterTable"]  timeout=60
    Set Focus To Element  //table[@id="letterTable"]/tbody//div[contains(@onscroll, "getChild")]//div[text()="${name}"]
    Click Element  //table[@id="letterTable"]/tbody//div[contains(@onscroll, "getChild")]//div[text()="${name}"]
    Click Element  //a[contains(@href,"LetterManager/delete")]
    Wait Until Element Is Enabled  xpath=//div[@id="deleteConfirm"]  timeout=60
    Click Element  xpath=//div[@id="deleteConfirm"]//span[text()="Yes"]

Change the Letter Body To "${body}" and Save
    Input "${body}" as Letter Body and Save

Make Sure Letter Named "${name}" Was Successfully Created
    Wait Until Element Is Visible  xpath=//table[@id="letterTable"]  timeout=60
    Page Should Contain Element  //table[@id="letterTable"]/tbody//div[contains(@onscroll, "getChild")]//div[text()="${name}"]

Make Sure The Body of The Letter Named "${name}" Was Successfully Edited To "${body}"
    Select a Letter Named "${name}" and Edit It
    Wait Until Element Is Visible  //iframe[@id="wysiwygwysiwyg_editor"]  timeout=60
    Select Frame  //iframe[@id="wysiwygwysiwyg_editor"]
    Page Should Contain Element  //body[contains(text(),"${body}")]
    Unselect Frame

Make Sure Letter Named "${name}" Was Successfully Deleted
    Wait Until Element Is Visible  xpath=//table[@id="letterTable"]  timeout=60
    Page Should Not Contain Element  //table[@id="letterTable"]/tbody//div[contains(@onscroll, "getChild")]//div[text()="${name}"]
