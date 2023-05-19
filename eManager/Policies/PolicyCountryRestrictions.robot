*** Settings ***


Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Teardown  Teardown

Force Tags  eManager

*** Variables ***

*** Test Cases ***

Add Country Restriction
    [Documentation]  This test case is to check if a shell reskin carrier can add/delete a country restriction
    [Tags]  JIRA:FRNT-74  qTest:38674051  reskin  refactor
    Open Browser to eManager
    Log into eManager  ${reskin_carrier}  ${reskin_password}
    go to  ${emanager}/cards/CurrencyRestrictionsPolicy.action
    select from list by value  policy.policyNumber  2
    select radio button  radioHandEnter  false
    click button  Add Country Restrictions
    click on  //*[@id='currencyDialogReskin']
    select from list by label  currencyCodeId  UNITED STATES
    click button  //*[@id='currencyDialogReskin']//*[@id='saveCountryVbutton']
    wait until page contains  You have successfully restricted your Policy to (UNITED STATES).
    get into db  SHELL
    ${currency_code}  query and strip  select currency_code from def_currency where carrier_id='${reskin_carrier}' and ipolicy='2'
    should be equal as integers  ${currency_code}  840

Remove Country Restriction
    [Tags]  JIRA:FRNT-74  qTest:38674051  reskin  refactor
    select from list by value  //*[@id='policyCountryRestrictions']//*[contains(text(),'UNITED STATES')]//following::*[@id='efsDtActions']  Delete
    wait until page contains  You have successfully deleted your restriction to the country of (UNITED STATES).

*** Keywords ***

Teardown

    get into db  SHELL
    execute sql string  dml=delete FROM def_currency WHERE carrier_id = '${reskin_carrier}' AND ipolicy = 2 AND currency_code = 840;


