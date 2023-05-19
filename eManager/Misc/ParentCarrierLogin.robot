*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Setup for Parent Login as Child
Suite Teardown  Turn ON Excel Report Flag to xls/xlsx

Force Tags  eManager

*** Variables ***
${carrier}
${child_carrier}
${permission_status}

*** Test Cases ***
Parent Login as Child - Valid Child
    [Documentation]  Login as Parent on a Valid Child.
    [Tags]  JIRA:FRNT-1118  JIRA:BOT-3279  PI:7

    Log into eManager with a Carrier that have Parent Login as Child Permission;
    Navigate to Select Program > Use Child Carrier Login;
    Login with a Carrier Child;
    Logout of Carrier Child;

    [Teardown]  Teardown for Parent Login as Child

Parent Login as Child - Child That not Belongs to Parent
    [Documentation]  Try to Login as Parent on a Child That not Belongs to Parent.
    [Tags]  JIRA:FRNT-1118  JIRA:BOT-3296  PI:8

    Log into eManager with a Carrier that have Parent Login as Child Permission;
    Navigate to Select Program > Use Child Carrier Login;
    Insert a Child that not Belongs to Parent on Search Field and Press ENTER;
    It Should not Be possible to Login with a Child that not Belongs to Parent;

    [Teardown]  Teardown for Parent Login as Child

*** Keywords ***
Setup for Parent Login as Child
    [Documentation]  Keyword Setup for Parent Carrier Report

    Get Into DB  MySQL

    Turn OFF Excel Report Flag to xls/xlsx  #this should be temporary and will be remove in a near future, I hope so!

#Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT DISTINCT(parent) FROM carrier_group_xref cgx
    ...  WHERE cgx.parent IN ${list_2}
    ...  AND cgx.parent NOT IN ('103866','141966')  #Bad Carrier for this test
    ...  AND (SELECT count(*) FROM carrier_group_xref WHERE parent=cgx.parent) < 10;  #This is to not pick a carrier with multiple childs, I'm trying to make the test fast

    ${carrier}  Find Carrier Variable  ${query}  parent

    Set Suite Variable  ${carrier}

    #log to console  ${carrier.id}

Teardown for Parent Login as Child
    [Documentation]  Teardown for Parent Login as Child.

    Close Browser

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  PARENT_AS_CHILD

Turn ${value} Excel Report Flag to xls/xlsx
    [Documentation]  This keyword will change the excel report format to xlsx if flag is ON and xls if flag is OFF.
    ...  This is a measure to deal with reports while we dont have support to xlsx files.

    Get Into DB  MySQL

    ${flag}  Set Variable If  '${value}'=='ON'  Y  N

    Execute SQL String  dml=UPDATE setting SET value = '${flag}' WHERE `PARTITION` = 'shared' AND name = 'com.tch.export.xlsx';

Log into eManager with a Carrier that have Parent Login as Child Permission;
    [Documentation]  Login on Emanager

    Ensure Carrier has User Permission  ${carrier.id}  PARENT_AS_CHILD
    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Use Child Carrier Login;
    [Documentation]  Go to Desired Page
    Go To  ${emanager}/cards/ChildCarrierCustInfoTest.action

Login with a Carrier Child;
    [Documentation]

    Pick a Child Carrier to Login With
    Click Element    //input[@name='lookupCarrierRadio' and @value='ID']
    Input Text    //input[@id='searchTxt']    ${child_carrier}
    Click Element    //input[@id='search']
    Wait Until Element Is Visible    //td[text()='${child_carrier}']
    Click Element    //td[text()='${child_carrier}']

Pick a Child Carrier to Login With
    [Documentation]

    Get Into DB    TCH
    ${query}    Catenate    SELECT carrier_id FROM carrier_group_xref WHERE parent='${carrier.id}' AND expire_date > TODAY Limit 1;
    ${child_carrier}    Query And Strip    ${query}

    Set Test Variable    ${child_carrier}

Insert a Child that not Belongs to Parent on Search Field and Press ENTER;
    [Documentation]

    Pick a Invalid Child Carrier to Login With
    Click Element    //input[@name='lookupCarrierRadio' and @value='ID']
    Input Text    //input[@id='searchTxt']    ${child_carrier}
    Press Keys    //input[@id='searchTxt']    \ue007    #ENTER

Pick a Invalid Child Carrier to Login With
    [Documentation]

    Get Into DB    TCH
    ${query}    Catenate    SELECT carrier_id FROM carrier_group_xref WHERE parent NOT IN ('${carrier.id}') AND expire_date > TODAY Limit 1;
    ${child_carrier}    Query And Strip    ${query}

    Set Test Variable    ${child_carrier}

Logout of Carrier Child;
    [Documentation]

    Click Element    //a[text()='Logout Child']

It Should not Be possible to Login with a Child that not Belongs to Parent;
    [Documentation]

    Wait Until Element is Visible    //div[@class="errors"]//*[contains(text(),"Error Selection Required")]