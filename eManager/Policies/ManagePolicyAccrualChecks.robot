*** Settings ***
Library  String
Library   otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup  Get Data To Be Used During Tests
Suite Teardown  Close All Browsers

Force Tags  eManager  Policy  AccountManager

Documentation    Test and validate the addition, updated and exclusion of Hubometer or Odometer Prompt (Accrual Checks) to a
          ...    Policy on EFS, Irving and Shell instances
          ...    The O5SA-532 added the minimum value for accrual checks due the adaptation to T-Check
          ...
          ...    PS.: This script may fail during the Shell testing and the following tests of this file will fail aswell,
          ...    due a minor bug with the prompts.

*** Variables ***
${minimumOne}
${maximumOne}
${minimumTwo}
${maximumTwo}
${minimum}
${maximum}

*** Test Cases ***
Validate Add, Update and Delete of Hubometer Prompt to a Policy on EFS
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117838466
    [Documentation]  Validate the addition, update and delete of a hubometer prompt into a policy
    [Setup]  Setting Up The Variables To The Test  EFS
    Verify or Open Account Manager
    Navigate To The Prompt List
    Add A Hubometer Prompt For Test
    Verify Page Shown Values  Hubometer  Exist
    Verify The Database  Hubometer  EFS  Exist
    Update The Hubometer Prompt
    Verify Page Shown Values  Hubometer  Exist
    Verify The Database  Hubometer  EFS  Exist
    Delete The Hubometer Prompt
    Verify Page Shown Values  Hubometer  NotExist
    Verify the Database  Hubometer  EFS  NotExist

Validate Add, Update and Delete of Odometer Prompt to a Policy on EFS
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117838466
    [Documentation]  Validate the addition, update and delete of a odometer prompt into a policy
    [Setup]  Setting Up The Variables To The Test  EFS
    Verify or Open Account Manager
    Navigate To The Prompt List
    Add A Odometer Prompt For Test
    Verify Page Shown Values  Odometer  Exist
    Verify The Database  Odometer  EFS  Exist
    Update The Odometer Prompt
    Verify Page Shown Values  Odometer  Exist
    Verify The Database  Odometer  EFS  Exist
    Delete The Odometer Prompt
    Verify Page Shown Values  Odometer  NotExist
    Verify the Database  Odometer  EFS  NotExist
    
Validate Add, Update and Delete of Hubometer Prompt to a Policy on Irving
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117838466
    [Documentation]  Validate the addition, update and delete of a hubometer prompt into a policy
    [Setup]  Setting Up The Variables To The Test  Irving
    Verify or Open Account Manager
    Navigate To The Prompt List
    Add A Hubometer Prompt For Test
    Verify Page Shown Values  Hubometer  Exist
    Verify The Database  Hubometer  Irving  Exist
    Update The Hubometer Prompt
    Verify Page Shown Values  Hubometer  Exist
    Verify The Database  Hubometer  Irving  Exist
    Delete The Hubometer Prompt
    Verify Page Shown Values  Hubometer  NotExist
    Verify the Database  Hubometer  Irving  NotExist

Validate Add, Update and Delete of Odometer Prompt to a Policy on Irving
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117838466
    [Documentation]  Validate the addition, update and delete of a odometer prompt into a policy
    [Setup]  Setting Up The Variables To The Test  Irving
    Verify or Open Account Manager
    Navigate To The Prompt List
    Add A Odometer Prompt For Test
    Verify Page Shown Values  Odometer  Exist
    Verify The Database  Odometer  Irving  Exist
    Update The Odometer Prompt
    Verify Page Shown Values  Odometer  Exist
    Verify The Database  Odometer  Irving  Exist
    Delete The Odometer Prompt
    Verify Page Shown Values  Odometer  NotExist
    Verify the Database  Odometer  Irving  NotExist
    
Validate Add, Update and Delete of Hubometer Prompt to a Policy on Shell
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117838466
    [Documentation]  Validate the addition, update and delete of a hubometer prompt into a policy
    [Setup]  Setting Up The Variables To The Test  Shell
    Verify or Open Account Manager
    Navigate To The Prompt List
    Add A Hubometer Prompt For Test
    Verify Page Shown Values  Hubometer  Exist
    Verify The Database  Hubometer  Shell  Exist
    Update The Hubometer Prompt
    Verify Page Shown Values  Hubometer  Exist
    Verify The Database  Hubometer  Shell  Exist
    Delete The Hubometer Prompt
    Verify Page Shown Values  Hubometer  NotExist
    Verify the Database  Hubometer  Shell  NotExist

Validate Add, Update and Delete of Odometer Prompt to a Policy on Shell
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117838466
    [Documentation]  Validate the addition, update and delete of a odometer prompt into a policy
    [Setup]  Setting Up The Variables To The Test  Shell
    Verify or Open Account Manager
    Navigate To The Prompt List
    Add A Odometer Prompt For Test
    Verify Page Shown Values  Odometer  Exist
    Verify The Database  Odometer  Shell  Exist
    Update The Odometer Prompt
    Verify Page Shown Values  Odometer  Exist
    Verify The Database  Odometer  Shell  Exist
    Delete The Odometer Prompt
    Verify Page Shown Values  Odometer  NotExist
    Verify the Database  Odometer  Shell  NotExist

Validate That The Fields Does Not Accept Negative Numbers
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117866948
    [Documentation]  Validate the error when trying to fill with negative values
    [Setup]  Setting Up The Variables To The Test  EFS
    Verify or Open Account Manager
    Navigate To The Prompt List
    Provoke Error  Negative
    Error Validation  Minimum  Numbers
    Error Validation  Maximum  Numbers

Validate That The Fields Does Not Accept Letters
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117866948
    [Documentation]  Validate the error when trying to fill with letters
    [Setup]  Setting Up The Variables To The Test  EFS
    Verify or Open Account Manager
    Navigate To The Prompt List
    Provoke Error  Letters
    Error Validation  Minimum  Numbers
    Error Validation  Maximum  Numbers

Validate That The Fields Must Be Filled
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117866948
    [Documentation]  Validate the error when trying to leave fields blank
    [Setup]  Setting Up The Variables To The Test  EFS
    Verify or Open Account Manager
    Navigate To The Prompt List
    Provoke Error  Blank
    Error Validation  Minimum  Required
    Error Validation  Maximum  Required

Validate That Is Not Possible To Add Minimum Bigger Than Maximum
    [Tags]    PI:15  JIRA:O5SA-532  qTest:117866948
    [Documentation]  Validate the error when trying to fill with negative values
    [Setup]  Setting Up The Variables To The Test  EFS
    Verify or Open Account Manager
    Navigate To The Prompt List
    Provoke Error  Inverse
    Error Validation  Message  Label

*** Keywords ***
Verify or Open Account Manager
    [Documentation]    Checks if the browser is open and logged into the emanager, if not it logs into it and goes to account manager
    @{browser_ids}  Get Browser Ids
    IF  '@{browser_ids}'=='@{EMPTY}'
        Open eManager  ${intern}  ${internPassword}  ${True}
    END

    Switch Browser    1
    Go To  ${emanager}/acct-mgmt/RecordSearch.action
    Run Keyword And Ignore Error    Alert Should Be Present    action=ACCEPT  timeout=3 s
    Wait Until Loading Spinners Are Gone

Get Data To Be Used During Tests
    [Documentation]    Get Carrier and Policy to use in the tests in EFS, Irving and Shell
    ${query}  Catenate  select di.carrier_id, di.ipolicy
                   ...  from def_info di
                   ...  join contract c on (di.carrier_id = c.carrier_id)
                   ...  where c.status = 'A' and di.ipolicy between 1 and 499
                   ...  and (select count(*) from def_info di where (di.info_id = 'ODRD' or di.info_id = 'HBRD') and di.ipolicy between 1 and 499 and di.carrier_id = c.carrier_id) = 0
                   ...  group by di.carrier_id, di.ipolicy order by di.carrier_id asc limit 500

    Get Into Db    TCH
    ${temp}  Query And Strip To Dictionary    ${query}
    Disconnect From Database
    ${len}  Get Length    ${temp}[carrier_id]
    ${len}  Evaluate    random.randint(0, $len-1)
    &{efsResult}  Create Dictionary  carrier_id=${temp}[carrier_id][${len}]    ipolicy=${temp}[ipolicy][${len}]
    Set Suite Variable  ${efsResult}

    Get Into Db    Irving
    ${temp}  Query And Strip To Dictionary    ${query}
    Disconnect From Database
    ${len}  Get Length    ${temp}[carrier_id]
    ${len}  Evaluate    random.randint(0, $len-1)
    &{irvingResult}  Create Dictionary  carrier_id=${temp}[carrier_id][${len}]    ipolicy=${temp}[ipolicy][${len}]
    Set Suite Variable  ${irvingResult}

    Get Into Db    Shell
    ${temp}  Query And Strip To Dictionary    ${query}
    Disconnect From Database
    ${len}  Get Length    ${temp}[carrier_id]
    ${len}  Evaluate    random.randint(0, $len-1)
    &{shellResult}  Create Dictionary  carrier_id=${temp}[carrier_id][${len}]    ipolicy=${temp}[ipolicy][${len}]
    Set Suite Variable  ${shellResult}

    ${minimumOne}  Evaluate    random.randint(0, 100)
    ${maximumOne}  Evaluate    random.randint($minimumOne+1, $minimumOne+1000)
    Set Suite Variable    ${minimumOne}
    Set Suite Variable    ${maximumOne}

    ${minimumTwo}  Evaluate    random.randint(0, 100)
    ${maximumTwo}  Evaluate    random.randint($minimumTwo+1, $minimumTwo+1000)
    Set Suite Variable    ${minimumTwo}
    Set Suite Variable    ${maximumTwo}

Setting Up The Variables To The Test
    [Documentation]  Set the variables of carrier_id and ipolicy based in the instance to be used during test
    [Arguments]    ${instance}
    IF  '${instance.upper()}'=='EFS'
        Set Test Variable  ${carrier_id}  ${efsResult}[carrier_id]
        Set Test Variable  ${ipolicy}  ${efsResult}[ipolicy]
    ELSE IF  '${instance.upper()}'=='IRVING'
        Set Test Variable  ${carrier_id}  ${irvingResult}[carrier_id]
        Set Test Variable  ${ipolicy}  ${irvingResult}[ipolicy]
    ELSE IF  '${instance.upper()}'=='SHELL'
        Set Test Variable  ${carrier_id}  ${shellResult}[carrier_id]
        Set Test Variable  ${ipolicy}  ${shellResult}[ipolicy]
    END

Wait Until Load Icon Disappear
    [Documentation]    this keyword waits until the loading icon disappears (the little loading besides some dropdown menus)
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10
    Wait Until Element Is Not Visible  //img[@class="select-element-loading-img"]  timeout=10

Navigate To The Prompt List
    [Documentation]  Navigation in the account manager until it gets in the add prompt state
    Wait Until Element Is Visible    //th/input[@name='id']  #input the carrier_id in the search field
    Input Text    //th/input[@name='id']   ${carrier_id}

    Wait Until Element Is Visible    //*[@id='customerSearchContainer']//button[contains(text(),'Submit')]  #click the submit button to look for the carrier
    Click Button    //*[@id='customerSearchContainer']//button[contains(text(),'Submit')]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //button[text()='${carrier_id}']  #click the found carrier hyperlink
    Click Button    //button[text()='${carrier_id}']

    Wait Until Element Is Visible    //*[@id='Policies']  #click the policies tab
    Click Element    //*[@id='Policies']

    Wait Until Element Is Visible    //*[@class='dataTables_scrollHead']//input[@name='id']  #fill the policy number in the serach field
    Input Text    //*[@class='dataTables_scrollHead']//input[@name='id']  ${ipolicy}

    Wait Until Element Is Visible    //*[@id='customerPoliciesSearchContainer']//button[contains(text(),'Submit')]  #click the submit button
    Click Button    //*[@id='customerPoliciesSearchContainer']//button[contains(text(),'Submit')]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //*[@id='DataTables_Table_0']//button[text()="${ipolicy}"]  #click the found policy number hyperlink
    Scroll Element Into View    //*[@id='DataTables_Table_0']//button[text()="${ipolicy}"]
    Click Button    //*[@id='DataTables_Table_0']//button[text()="${ipolicy}"]

    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible    //*[@id='policyPromptsSearchContainer']//button[@class='button searchSubmit']  #click submit button in the new page to refresh the prompt list
    Click Button    //*[@id='policyPromptsSearchContainer']//button[@class='button searchSubmit']
    Wait Until Loading Spinners Are Gone


Add A ${distanceCounter} Prompt For ${error}
    [Documentation]  Navigate in the pop-up to add a hubometer or odometer prompt check
    Wait Until Loading Spinners Are Gone
    Wait Until Element Is Visible   //a[@id='ToolTables_DataTables_Table_0_1']  #click the Add button
    Click Element    //a[@id='ToolTables_DataTables_Table_0_1']

    Wait Until Element Is Visible   //select[@name='promptSummary.promptId']  #select the prompt (hubometer or odometer)
    IF  '${distanceCounter.upper()}'=='HUBOMETER'
        Wait Until Element Is Visible  //select[@name='promptSummary.promptId']/option[text()='Hubometer']
        Select From List By Label   //select[@name='promptSummary.promptId']  Hubometer  #select hubometer
    ELSE IF    '${distanceCounter.upper()}'=='ODOMETER'
        Wait Until Element Is Visible  //select[@name='promptSummary.promptId']/option[text()='Odometer']
        Select From List By Label   //select[@name='promptSummary.promptId']  Odometer  #select odometer
    END

    Wait Until Load Icon Disappear
    Wait Until Element Is Visible   //select[@name='promptSummary.validationCode']/option[text()='Accrual Check']  #select accrual check
    Select From List By Label   //select[@name='promptSummary.validationCode']  Accrual Check

    Wait Until Load Icon Disappear
    Wait Until Element Is Visible   //select[@name='promptSummary.methodCode']/option[text()='Value']  #select method value if needed
    ${selected}  Get Selected List Label  //select[@name='promptSummary.methodCode']
    IF  '${selected.upper()}'!='VALUE'
        Select From List By Label    //select[@name='promptSummary.methodCode']  Value
    END

    Set Suite Variable  ${minimum}  ${minimumOne}
    Set Suite Variable  ${maximum}  ${maximumOne}

    IF  '${error.upper()}'=='ERROR'
        Return From Keyword
    END

    Wait Until Element Is Visible  //input[@name='promptSummary.minimum']  #fill up the minimum field
    Input Text    //input[@name='promptSummary.minimum']  ${minimum}

    Wait Until Element Is Visible  //input[@name='promptSummary.maximum']  #fill up the maximum field
    Input Text    //input[@name='promptSummary.maximum']  ${maximum}

    Wait Until Element Is Visible  //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']  #Click Submit Button of the pop-up
    Click Button    //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']
    Wait Until Loading Spinners Are Gone

Update The ${distanceCounter} Prompt
    [Documentation]  Navigate in the pop-up to update a hubometer or odometer prompt check
    Set Suite Variable  ${minimum}  ${minimumTwo}
    Set Suite Variable  ${maximum}  ${maximumTwo}

    IF  '${distanceCounter.upper()}'=='HUBOMETER'  #set the xpath of the line based in the distance counter been used in the test
        ${xpath}  Set Variable    //button[text()='Hubometer']
    ELSE IF  '${distanceCounter.upper()}'=='ODOMETER'
        ${xpath}  Set Variable    //button[text()='Odometer']
    END

    Wait Until Element Is Visible    ${xpath}  #click in the hubometer or odometer hyperlink to open the update pop-up
    Click Button    ${xpath}

    Wait Until Load Icon Disappear
    Wait Until Element Is Visible  //input[@name='promptSummary.minimum']  #change the minimum field
    Input Text    //input[@name='promptSummary.minimum']  ${minimum}

    Wait Until Element Is Visible  //input[@name='promptSummary.maximum']  #change the maximum field
    Input Text    //input[@name='promptSummary.maximum']  ${maximum}

    Wait Until Element Is Visible  //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']  #click Submit button of the pop-up
    Click Button    //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']
    Wait Until Loading Spinners Are Gone

Delete The ${distanceCounter} Prompt
    [Documentation]  Navigate in the pop-up to delete a hubometer or odometer prompt check
    IF  '${distanceCounter.upper()}'=='HUBOMETER'
        ${xpath}  Set Variable    //input[@type='checkbox' and @value='HBRD']
    ELSE IF  '${distanceCounter.upper()}'=='ODOMETER'
        ${xpath}  Set Variable    //input[@type='checkbox' and @value='ODRD']
    END

    Wait Until Element Is Visible  ${xpath}    #Select the checkbox related of the line of hubometer or odometer
    Select Checkbox  ${xpath}

    Wait Until Element Is Visible  //*[@class='DTTT_container']//a[@id='ToolTables_DataTables_Table_0_2']    #Click the Delete button
    Click Element  //*[@class='DTTT_container']//a[@id='ToolTables_DataTables_Table_0_2']

    Wait Until Element Is Visible  //button[text()='Confirm']    #Click submit in the confirmation pop-up
    Click Button  //button[text()='Confirm']

Verify Page Shown Values
    [Documentation]    Verify the limit values of the Odometer or Hubometer prompt shown in the webpage
    [Arguments]    ${distanceCounter}  ${dataStance}
    IF  '${distanceCounter.upper()}'=='HUBOMETER'  #set the xpath of the field which stores the data entried during the test
        ${xpath}  Set Variable    //button[contains(text(), 'Hubometer')]/../../td[contains(text(), 'M:')]
    ELSE IF  '${distanceCounter.upper()}'=='ODOMETER'
        ${xpath}  Set Variable    //button[contains(text(), 'Odometer')]/../../td[contains(text(), 'M:')]
    END

    Wait Until Loading Spinners Are Gone
    IF  '${dataStance.upper()}'=='EXIST'
        Wait Until Element Is Visible  ${xpath}  #Get the value in the field and validate if it is correct
        Scroll Element Into View  ${xpath}
        ${shownValue}  Get Text  ${xpath}
        Should Be Equal As Strings    M:${minimum} ,X:${maximum}  ${shownValue}
    ELSE IF  '${dataStance.upper()}'=='NOTEXIST'
        Page Should Not Contain Element    ${xpath}  #Validate that the entry was deleted looking for the xpath
    END

Verify The Database
    [Documentation]
    [Arguments]  ${distanceCounter}  ${instance}  ${dataState}
    IF  '${instance.upper()}'=='EFS'
        ${instance}  Set Variable    TCH
    END

    IF  '${distanceCounter.upper()}'=='HUBOMETER'
        ${distanceCounter}  Set Variable    HBRD
    ELSE IF  '${distanceCounter.upper()}'=='ODOMETER'
        ${distanceCounter}  Set Variable    ODRD
    END

    ${query}  Catenate  Select trim(info_validation) as info_validation
                   ...  from def_info
                   ...  where carrier_id = '${carrier_id}'
                   ...  and ipolicy = '${ipolicy}'
                   ...  and info_id = '${distanceCounter}'
    Get Into Db    ${instance}
    ${query}  Query And Strip To Dictionary    ${query}
    Disconnect From Database

    IF  '${dataState.upper()}'=='EXIST'
        Should Be Equal As Strings    ${query}[info_validation]  R;TN;M${minimum};X${maximum}
    ELSE IF    '${dataState.upper()}'=='NOTEXIST'
        Should Be Empty    ${query}
    END

Provoke Error
    [Documentation]    Provoke error to see the behavior
    [Arguments]      ${error}
    ${error}  String.Convert To Uppercase  ${error}

    ${count}  Get Element Count  //select[@name='promptSummary.methodCode']/option[text()='Value']
    IF  ${count}<1
        Go To  ${emanager}/acct-mgmt/RecordSearch.action
        Wait Until Loading Spinners Are Gone
        Navigate To The Prompt List
        Add A Odometer Prompt For Error
    END

    IF  '${error}'=='NEGATIVE'
        Wait Until Element Is Visible  //input[@name='promptSummary.minimum']  #change the minimum field
        Input Text    //input[@name='promptSummary.minimum']  -123

        Wait Until Element Is Visible  //input[@name='promptSummary.maximum']  #change the maximum field
        Input Text    //input[@name='promptSummary.maximum']  -123
    ELSE IF  '${error}'=='LETTERS'
        Wait Until Element Is Visible  //input[@name='promptSummary.minimum']  #change the minimum field
        Input Text    //input[@name='promptSummary.minimum']  two

        Wait Until Element Is Visible  //input[@name='promptSummary.maximum']  #change the maximum field
        Input Text    //input[@name='promptSummary.maximum']  four
    ELSE IF  '${error}'=='BLANK'
        Wait Until Element Is Visible  //input[@name='promptSummary.minimum']  #change the minimum field
        Input Text    //input[@name='promptSummary.minimum']  ${EMPTY}

        Wait Until Element Is Visible  //input[@name='promptSummary.maximum']  #change the maximum field
        Input Text    //input[@name='promptSummary.maximum']  ${EMPTY}
    ELSE IF  '${error}'=='INVERSE'
        Wait Until Element Is Visible  //input[@name='promptSummary.minimum']  #change the minimum field
        Input Text    //input[@name='promptSummary.minimum']  ${maximum}

        Wait Until Element Is Visible  //input[@name='promptSummary.maximum']  #change the maximum field
        Input Text    //input[@name='promptSummary.maximum']  ${minimum}
    END

    Wait Until Element Is Visible  //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']  #Click Submit Button of the pop-up
    Click Button    //*[@id='policyPromptsAddUpdateFormButtons']//button[@id='submit']

Error Validation
    [Documentation]    Validate the error shown
    [Arguments]    ${fieldName}  ${expectedError}
    ${fieldName}  String.Convert To Uppercase  ${fieldName}
    ${expectedError}  String.Convert To Uppercase  ${expectedError}

    IF  '${fieldName}'=='MINIMUM'  #save the object that will be verified
        ${message}  Get Text  //label[@id='promptSummary.minimum-error']
    ELSE IF  '${fieldName}'=='MAXIMUM'
        ${message}  Get Text  //label[@id='promptSummary.maximum-error']
    ELSE IF  '${fieldName}'=='MESSAGE'
        Wait Until Page Contains Element    //*[@id='policyPromptsAddUpdateMessages']/ul[3]/li
        ${message}  Get Text  //*[@id='policyPromptsAddUpdateMessages']/ul[3]/li
    END

    IF  '${expectedError}'=='REQUIRED'  #error that will be validated
        IF  '${fieldName}'=='MINIMUM'
            Should Be Equal As Strings    ${message}  Minimum is a required field.
        ELSE IF  '${fieldName}'=='MAXIMUM'
            Should Be Equal As Strings    ${message}  Maximum is a required field.
        END
    ELSE IF  '${expectedError}'=='NUMBERS'
        Should Be Equal As Strings    ${message}  Numbers only
    ELSE IF  '${expectedError}'=='LABEL'
        Should Be Equal As Strings    ${message}  Add Unsuccessful. updatePromptForPolicy ERROR
    END

    Verify the Database  Odometer  EFS  NotExist  #check if any entry was added in the DB