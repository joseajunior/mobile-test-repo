*** Settings ***
Documentation  Tests every possible combination of policy and card limits given the limit source.
...  No preauthorization is ran to validate. Rather only database checks verify that the limits
...  updated on the card through Account Manager are correctly saved in the database.

Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  DateTime
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM  Card  refactor
Suite Setup  Setup and Connect
Suite Teardown  Disconnect

*** Test Cases ***
Add Time Restriction
    [Tags]  JIRA:BOT-1383  qTest:31355247  Regression
    [Setup]  Search For Policy And Clear All Time Restriction
    Open Account Manager
    Searh Customer  ${userName}
    Go to Policies Sub Menu
    Search And Select Policy  ${policy}
    Go To Time Restriction Sub Menu
    ${begin_time}  ${end_time}  ${day}  Add New Time Restriction
    Search Time Restrictions
    Handle Alert
    Match Time Restriction Screen  ${begin_time}  ${end_time}
    ${time_restriction_db}  Get Time Restriction From DB  ${userName}  ${policy}
    Match Time Restriction On DB  ${time_restriction_db}  ${begin_time}  ${end_time}
    [Teardown]  Run Keywords  Delete Inserted Time Restriction  ${begin_time}  ${end_time}  ${day}
    ...         AND  Close Browser

Delete Inserted Time Restriction
    [Tags]  JIRA:BOT-1384  qTest:31355521  Regression  qTest:31158584
    ${policy}  ${begin_time}  ${end_time}  ${day}  ${dayIndex}  Search Policy And Add a Random Time Restriction
    Open Account Manager
    Searh Customer  ${userName}
    Go to Policies Sub Menu
    Search And Select Policy  ${policy}
    Go To Time Restriction Sub Menu
    Search Time Restrictions
    Handle Alert
    Delete Inserted Time Restriction  ${begin_time}  ${end_time}  ${day}
    [Teardown]  Close Browser

*** Keywords ***
Setup and Connect
    Get Into DB  TCH
    Set Selenium Timeout  60

Save Backup
    ${query}  Catenate  SELECT lmtsrc FROM cards WHERE card_num = '${validCard}'
    ${card_lmtsrc}  Query And Strip  ${query}
    Set Test Variable  ${card_lmtsrc}  ${card_lmtsrc}

Search For Policy And Clear All Time Restriction
    ${policy}  Search Policy
    Start Setup Policy  ${userName}  ${policy}
    Clear Policy Time Restrictions
    Set Test Variable  ${policy}  ${policy}

Disconnect
    Disconnect From Database

Search Policy
    ${policy}  Search Policy From Carrier  ${userName}
    [Return]  ${policy}

Search Policy From Carrier
    [Arguments]  ${carrier}
    ${query}  Catenate  SELECT icardpolicy FROM cards c WHERE c.carrier_id = ${carrier} LIMIT 1
    ${policy}  Query And Strip  ${query}
    [Return]  ${policy}

Searh Customer
    [Arguments]  ${carrier}
    Wait Until Element is Enabled  //a[@id='Customer']
    Click on  //a[@id='Customer']
    Wait Until Element Is Visible  name=id
    refresh page
    Wait Until Element Is Visible  name=businessPartnerCode
    Select From List By Value  businessPartnerCode  EFS
    Wait Until Element is Enabled  //input[@name='id']
    Input Text  name=id  ${carrier}
    double click on  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0
    Wait Until Element is Visible  //button[text()='${carrier}']
    Set Focus To Element  //button[text()='${carrier}']
    click on  //button[text()='${carrier}']
    Wait Until Element Is Enabled  id=submit
    Go to Policies Sub Menu

Go to Policies Sub Menu
    Click Element  //span[text()='Policies']
    Wait Until Element is Visible  //div[@id='customerPoliciesSearchContainer']//button[@class='button searchSubmit']

Search Time Restrictions
    Click Submit Second Table

Click Submit Second Table
    double click on  text=Submit  exactMatch=False  index=2

Search And Select Policy
    [Arguments]  ${policy}
    Wait Until Element Is Visible  name=id
    Wait Until Element Is Enabled  name=id
    Input Text  name=id  ${policy}
    Click Element  //div[@id='customerPoliciesSearchContainer']//button[@class='button searchSubmit']
    Wait Until Element is Visible  //table[@id='DataTables_Table_0']//tr[1]//button
    ${policy}  Get Text   //table[@id='DataTables_Table_0']//tr[1]//button
    Set Focus To Element  //table[@id='DataTables_Table_0']//tr[1]//button
    click on  //table[@id='DataTables_Table_0']//tr[1]//button

Go To Time Restriction Sub Menu
    Wait Until Element is Visible  detailRecord.contractId
    Wait Until Element is Visible  //a[@id='TimeRestrictions']
    Click Element  //a[@id='TimeRestrictions']

Add New Time Restriction
    ${begin_time}  getDateTimeNow  %H:%M  hours=5
    ${end_time}  getDateTimeNow  %H:%M  hours=6
    ${day}  Set Variable  Friday
    Wait Until Element Is Visible  //input[@name='restriction']
    Wait Until Element Is Visible  //div[@id='policyTimeRestrictionsSearchContainer']//a/span[text()='ADD']
    Click Element  //div[@id='policyTimeRestrictionsSearchContainer']//a/span[text()='ADD']
    Select From List By Label  timeRestrictionSummary.id  ${day}
    Input Text  timeRestrictionSummary.startTime  ${begin_time}
    Input Text  timeRestrictionSummary.endTime  ${end_time}
    Click Element  //td[@id='policyTimeRestrictionsAddUpdateFormButtons']//button[@id='submit']
    [Return]  ${begin_time}  ${end_time}  ${day}

Match Time Restriction Screen
    [Arguments]  ${begin_time}  ${end_time}
    Match Table Column Value  Start Time  ${begin_time}
    Match Table Column Value  End Time  ${end_time}

Match Time Restriction On DB
    [Arguments]   ${time_restriction_db}  ${begin_time}  ${end_time}
    Should Be Equal As Strings  ${time_restriction_db['beg_time']}  ${begin_time}
    Should Be Equal As Strings  ${time_restriction_db['end_time']}  ${end_time}

Get Time Restriction From DB
    [Arguments]  ${carrier}  ${policy}
    ${query}  Catenate  SELECT TO_CHAR(beg_time,'%H:%M') as beg_time,
    ...                        TO_CHAR(end_time,'%H:%M') as end_time
    ...                 FROM def_time
    ...                 WHERE carrier_id = ${carrier}
    ...                 AND ipolicy = ${policy}
    ${output}  Query And Strip To Dictionary  ${query}
    [Return]  ${output}

Match Table Column Value
    [Arguments]  ${column_name}  ${expected_value}
    ${value}  Get Text  //table[@id='DataTables_Table_1']//tbody/tr/td[count(//th[text()='${column_name}']/preceding-sibling::th)+1]
    Should Be Equal As Strings  ${value}  ${expected_value}

Delete Inserted Time Restriction
    [Arguments]  ${begin_time}  ${end_time}  ${day}
    Wait Until Element Is Enabled  //table[@id='DataTables_Table_1']//tbody//tr//td[count(//th[text()='Restriction']/preceding-sibling::th)+1]/button[text()='${day}']/parent::td/parent::tr//td[count(//th[text()='Start Time']/preceding-sibling::th)+1][text()='${begin_time}']/parent::tr//td[count(//th[text()='End Time']/preceding-sibling::th)+1][text()='${end_time}']/parent::tr//input
    Click On  //table[@id='DataTables_Table_1']//tbody//tr//td[count(//th[text()='Restriction']/preceding-sibling::th)+1]/button[text()='${day}']/parent::td/parent::tr//td[count(//th[text()='Start Time']/preceding-sibling::th)+1][text()='${begin_time}']/parent::tr//td[count(//th[text()='End Time']/preceding-sibling::th)+1][text()='${end_time}']/parent::tr//input
    Click On  //div[@id='policyTimeRestrictionsSearchContainer']//a/span[text()='DELETE']
    Wait Until Element Is Enabled  //button[@name='confirm']
    Click On  //button[@name='confirm']

Search Policy And Add a Random Time Restriction
    ${policy}  Search Policy From Carrier  ${userName}
    ${begin_date}  getDateTimeNow  %Y-%m-%d
    ${begin_time}  getDateTimeNow  %H:%M:%S
    ${end_date}  getDateTimeNow  %Y-%m-%d
    ${end_time}  getDateTimeNow  %H:%M:%S

    ${beg_datetime}  getDateTimeNow  %Y-%m-%d %H:%M:%S
    ${end_datetime}  getDateTimeNow  %Y-%m-%d %H:%M:%S

    @{week}  Create List  Sunday  Monday  Tuesday  Wednesday  Thursday  Friday  Saturday
    ${day}  Evaluate  random.choice(${week})  random
    ${dayIndex}  Get Index From List  ${week}  ${day}
    ${dayIndex}  Evaluate  ${dayIndex}+1


    Start Setup Policy  ${userName}  ${policy}
    Setup Policy Time Restrictions  ${dayIndex.__str__()}  ${beg_datetime}  ${end_datetime}
    ${begin_time}  Add Time To Date  ${begin_time}  1 hour  result_format=%H:%M  date_format=%H:%M:%S
    ${end_time}  Add Time To Date  ${end_time}  1 hour  result_format=%H:%M  date_format=%H:%M:%S
    [Return]  ${policy}  ${begin_time}  ${end_time}  ${day}  ${dayIndex}