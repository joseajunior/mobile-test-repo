*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.ws.CardManagementWS
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Documentation   Ensure that the Fuel Genius User Guide pulls up when you select help.

Suite Teardown  Close Browser
Force Tags  eManager

*** Test Cases ***
Fuel Genius User Guide
    [Tags]    JIRA:BOT-240  refactor
    open emanager  ${irvinguserName}  ${irvingpassword}
    Maximize Browser Window
    Click Link    //a[@href="/common/FuelGeniusDuideENGLISH.pdf"]
    Switch Window  url=${emanager}/common/FuelGeniusDuideENGLISH.pdf
    sleep  3
    Page Should Contain element  //*[@id='plugin' and @src='${emanager}/common/FuelGeniusDuideENGLISH.pdf']

*** Keywords ***