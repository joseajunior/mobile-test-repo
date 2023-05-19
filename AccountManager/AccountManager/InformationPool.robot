*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
#Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Variables ***
${policy}  2
${carrier_id}  145805

*** Test Cases ***
Add a prompt with a related prompt for a specific and for all policies
    [Tags]  JIRA:BOT-1372  qTest:32444858  Regression  qTest:31247765  qTest:31252899  qTest:31354744  qTest:31354955
    [Documentation]  Add a prompt with a related prompt for a specific and for all policies.
    ...  | Using ${carrier_id} in Account Manager

    Open eManager  internRobot  testing123
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${carrier_id}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${carrier_id}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${policy}
    Check Element Exists  text=${carrier_id}
    Click On  text=Information Pool
    Click On  text=ADD
    Select From List By Value  informationPoolsSummary.prompt  DRID
    Input Text  informationPoolsSummary.promptValue  987654
    Click On  //*[@name="informationPoolsSummary.availableForAllPolicies"]
    Select From List By Value  informationPoolsSummary.relatedPrompt  ODRD
    Input Text  informationPoolsSummary.relatedPromptValue  123456
    Double Click On  text=Submit
    Check Element Exists  text=DRIVER ID
    Check Element Exists  text=ODOMETER
    Get Into DB  TCH
    Row Count Is Equal To X  SELECT * FROM info_pool WHERE carrier_id=145805 AND info_id='DRID' AND related_id='ODRD'  1

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Edit an info pool item
    [Tags]  JIRA:BOT-1373  qTest:32445276  Regression
    [Documentation]  Edit an Info Pool Item
    ...  | Using ${carrier_id} in Account Manager

    Open eManager  internRobot  testing123
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${carrier_id}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${carrier_id}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${policy}
    Check Element Exists  text=${carrier_id}
    Click On  text=Information Pool
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=987654
    Input Text  informationPoolsSummary.promptValue  112233
    Select From List By Value  informationPoolsSummary.relatedPrompt  TRIP
    Double Click On  text=Submit
    Get Into DB  TCH
    Row Count Is Equal To X  SELECT * FROM info_pool WHERE carrier_id=145805 AND info_id='DRID' AND related_id='TRIP'  1

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Delete an info pool item
     [Tags]  JIRA:BOT-1374  qTest:32445292  Regression
    [Documentation]  Delete an Info Pool Item
    ...  | Using ${carrier_id} in Account Manager

    Open eManager  internRobot  testing123
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${carrier_id}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${carrier_id}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${policy}
    Check Element Exists  text=${carrier_id}
    Click On  text=Information Pool
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  //*[@promptvalue="112233" and @type="checkbox"]
    Click On  //*[@promptvalue="987654" and @type="checkbox"]
    Click On  text=DELETE
    Click On  text=Confirm
    Check Element Exists  text=Delete Successful
    Get Into DB  TCH
    Row Count Is Equal To X  SELECT * FROM info_pool WHERE carrier_id=145805 AND info_id='DRID' AND related_id='TRIP'  0

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

New Prompts for Ryder Carrier - Info Pool
    [Tags]  JIRA:ROCKET-220  JIRA:ROCKET-155  qtest:55376560  PI:13  API:Y
    [Setup]  Find Ryder Carrier
    Search a carrier in Account Manager  EFS  ${ryder_carrier['carrier_id']}
    Go To Policy Tab and select Policy 1
    Select Info Pools tab
    Add Prompt LCCD with LCCDV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  LCCD  LCCDV
    Add Prompt PLDS with PLDSV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  PLDS  PLDSV
    Add Prompt SPLN with SPLNV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  SPLN  SPLNV
    Add Prompt SLDS with SLDSV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  SLDS  SLDSV
    Add Prompt DSCD with DSCDV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  DSCD  DSCDV
    Add Prompt DMLC with DMLCV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  DMLC  DMLCV
    Add Prompt LSNB with LSNBV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  LSNB  LSNBV
    Add Prompt CUNB with CUNBV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  CUNB  CUNBV
    Add Prompt VHTP with VHTPV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  VHTP  VHTPV
    Add Prompt PDLN with PDLNV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  PDLN  PDLNV
    Add Prompt CLCD with CLCDV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  CLCD  CLCDV
    Add Prompt VHNB with VHNBV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  VHNB  VHNBV
    Add Prompt CVNM with CVNMV value
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  CVNM  CVNMV
    [Teardown]  close browser

InfoPool API for Ryder Child
    [Tags]  JIRA:ROCKET-215  qtest:56243265  PI:13  API:Y
    [Setup]  Find Ryder Child
    Setup Infopool Carrier
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Go To Policy Tab and select Policy 1
    Select Info Pools tab
    Test all the Prompts    ${carrier.id}

    [Teardown]  close browser

InfoPool API for Non-Child
    [Tags]  JIRA:ROCKET-283  qtest:98667088  PI:14  API:Y
    [Setup]  Get a non-child carrier
    Setup Infopool Carrier
    Update Infopools Flag   Y
    Open Account Manager  ${intern}  ${internPassword}
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Go To Policy Tab and select Policy 1
    Select Info Pools tab
    Test all the Prompts    ${carrier.id}
    Update Infopools Flag   N

    [Teardown]  close browser

*** Keywords ***
Find Ryder Carrier
    [Tags]  qtest
    [Documentation]  Find a Ryder child carrier:
                    ...  select x.carrier_id, c.contract_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A';
    ${sql}  catenate   select x.carrier_id, c.contract_id
                    ...  from carrier_group_xref x
                    ...      INNER JOIN contract c
                    ...          ON c.carrier_id = x.carrier_id
                    ...  where parent = 197997
                    ...    and x.effective_date < current
                    ...    and x.expire_date > current
                    ...    and c.status = 'A'
                    ...  order by x.effective_date DESC
                    ...  Limit 1;
    ${ryder_carrier}  query and strip to dictionary  ${sql}  db_instance=tch
    set test variable  ${ryder_carrier}
    Open Account Manager  ${intern}  ${internPassword}
    set test variable  ${db}  tch

Search a carrier in Account Manager
    [Tags]  qtest
    [Documentation]  Login to account Manager follow TC-2113
    ...  On the customer tab enter carrier from above sql
    ...  Click Submit and Click on Carrier link
    [Arguments]  ${BusinessPartner}  ${Customer}
    ${current}=  get location
    ${goback}=  evaluate  '/acct-mgmt/RecordSearch.action' not in '${current}'
    run keyword if  ${goback}  Go Back To Record Search
    wait until element is visible  id
#    ${stat}=  run keyword and return status  alert should be present
#    run keyword if  ${stat}  run keyword and ignore error  handle alert
    click on  xpath=//span[text()="Customers"]
    wait until element is visible  businessPartnerCode
    select from list by value  businessPartnerCode  ${BusinessPartner}
    input text  id  ${Customer}
    double click on  xpath=//button[@class="button searchSubmit"]
    wait until element is visible   //button[text()="${Customer}"]
    sleep  2s
    double click on  xpath=//button[text()="${Customer}"]
    wait until element is visible  xpath=//span[text()="Detail"]
    double click on  xpath=//span[text()="Detail"]
    wait until element is visible  //td[text()="${Customer}"]  timeout=60  error=Customer Did not load within 60 seconds

Go To Policy Tab and select Policy ${num}
    [Tags]  qtest
    [Documentation]  Click on Policies tab
    ...  Click Submit to search for policies
    ...  Click on a Available Policy Number
    wait until element is visible  Policies
    click element  Policies
#    sleep  5s
    wait until element is visible  xpath=//*[@id="customerPoliciesSearchContainer"]/div[1]/button[1]
    click button  xpath=//*[@id="customerPoliciesSearchContainer"]/div[1]/button[1]
#    click element  xpath=//*[@id="customerPoliciesSearchContainer"]//class="searchInputContainer"//class="button searchSubmit"
    wait until element is visible  xpath=//*[@id="DataTables_Table_0"]/tbody/tr/td[1]/button
    click button  ${num}

Select Info Pools tab
    [Tags]  qtest
    [Documentation]  Click on the Information Pools tab
    wait until element is visible  InformationPools
    click element  InformationPools

Add Prompt ${prompt} with ${value} value
    [Tags]  qtest
    [Documentation]  remove the prompt if it exists on the screen by selecting it and clicking delete
    ...  Click add
    ...  Select ${value} from the Prompts dropdown list
    ...  Input a value for Prompt
    ...  Click Submit
#    ${sql}  catenate  delete from info_pool where info_id in ('${prompt}') and carrier_id = ${ryder_carrier['carrier_id']};
#    execute sql string  ${sql}  db_instance=${db}
    wait until element is visible  xpath=//*[@id="policyInformationPoolsSearchContainer"]
    click element  xpath=//*[@id="policyInformationPoolsSearchContainer"]//span[text()="ADD"]/parent::*
    wait until element is visible  policyInformationPoolsAddUpdateActionFormContainer
    ${prompt_path}  catenate  //*[@id="policyInformationPoolsAddUpdateActionForm"]//select[@name="informationPoolsSummary.prompt"]  #//*[@id="policyInformationPoolsAddUpdateActionForm"]/table/tbody/tr[2]/td/table/tbody/tr[2]/td[2]/select
    ${myPrompts}  get list items  ${prompt_path}  values=${TRUE}
    list should contain value  ${myPrompts}  ${prompt}
    wait until element is visible  ${prompt_path}
    select from list by value  ${prompt_path}  ${prompt}
    ${path}  catenate  //*[@id="policyInformationPoolsAddUpdateActionForm"]//*[@name="informationPoolsSummary.promptValue"]  #xpath=//*[@id="policyInformationPoolsAddUpdateActionForm"]/table/tbody/tr[2]/td/table/tbody/tr[3]/td[2]/input[1]
    wait until element is visible  ${path}
    input text  ${path}  ${value}
    ${submit}  catenate  //*[@id="policyInformationPoolsAddUpdateFormButtons"]//*[text()="Submit"]
    click element  ${submit}
    wait until page contains  Add Successful
    sleep  3

Verify Prompt in DB
    [Tags]  qtest
    [Arguments]  ${carrier_id}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select value from info_pool where carrier_id = {carrier_id} and info_id = '{INFO}';
    ${sql}  catenate  select value from info_pool where carrier_id = ${carrier_id} and info_id = '${info_id}';

    FOR  ${i}  IN RANGE  5
        ${db_value}  query and strip  ${sql}  db_instance=${db}
        exit for loop if  '${db_value}'!='None'
        sleep  1
    END
    should be equal as strings  ${db_value}  ${info_validation}

Find Ryder Child
    [Tags]  qtest
    [Documentation]  Find valid list of children for the Ryder Parent 197997:
            ...  select x.carrier_id
            ...  from carrier_group_xref x
            ...     INNER JOIN member m ON m.member_id = x.carrier_id
            ...  where parent = 197997
            ...    and x.carrier_id not between 2500000 and 2599999
            ...    and effective_date < current
            ...    and expire_date > current;
    ${db}  catenate  tch
    set test variable  ${db}
    ${sql}  catenate  select x.carrier_id
            ...  from carrier_group_xref x
            ...     INNER JOIN member m ON m.member_id = x.carrier_id
            ...  where parent = 197997
            ...    and x.carrier_id not between 2500000 and 2599999
            ...    and effective_date < current
            ...    and expire_date > current;
    ${ryder_children}  query and strip to list  ${sql}  db_instance=${db}
    set test variable  ${ryder_children}
    ${carrier.id}  evaluate  random.choice(${ryder_children})
    set test variable  ${carrier.id}
    Open Account Manager  ${intern}  ${internPassword}

Verify Prompt in postgres
    [Tags]  qtest
    [Arguments]  ${carrier_id}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select pool_value from infopool where carrier_id = {carrier_id} and pool_type = {info_id}
    ${sql}  catenate  select pool_value from infopool where carrier_id = ${carrier_id} and pool_type = '${info_id}';
    ${db_value}  query and strip to list  ${sql}  db_instance=infopool
    List Should Contain Value  ${db_value}  ${info_validation}

Test all the Prompts
    [Tags]  qtest
    [Documentation]  Log into account manager, search for the carrier. Go to policies tab, select a policy, click
            ...  information pool tab. Add one or more prompts with one or more related values.
            ...  Verify the prompts are added in postgres database:
            ...  select * from infopool where carrier_id = <carrier_id>> and pool_type = <pool_type>;
            ...  select * from related_values where pool_id = <pool_id>;
    [Arguments]    ${user_id}
    ${today}  getDateTimeNow  %d
    set test variable    ${today}
    FOR  ${prompt}  IN  @{prompt_list}
        ${value}  Generate Random String  6
        Add Prompt ${prompt} with ${value} value
        Verify Prompt in postgres  ${user_id}  ${prompt}  ${value}
        click element  xpath=//button[@promptcode="${prompt}" and @promptvalue="${value}"]
        Add Related values  ${prompt}  ${value}  ${user_id}
        exit for loop if    '${today}'!='01'
    END

Add Related Values
    [Arguments]  ${prompt}  ${value}  ${user_id}
    sleep  3s
    ${pool_id}  get pool id  ${prompt}  ${value}  ${user_id}
    wait until element is visible  remainingRelPrompts
    @{related_list}  Get List Items  remainingRelPrompts  values=True
    remove from list  ${related_list}  0
    @{rel_values}  create list
    FOR  ${rprompt}  IN  @{related_list}
        ${rvalue}  Generate Random String  6
        append to list  ${rel_values}  ${rvalue}
        wait until element is visible  remainingRelPrompts
        Select From List by Value  remainingRelPrompts  ${rprompt}
        Wait Until Element Is Enabled  newPromptId
        input text  newPromptId  ${rvalue}
        Wait Until Element Is Enabled  xpath=//button[@name="AddUpdate" and @id="btnSubmit"]
        click button  xpath=//button[@name="AddUpdate" and @id="btnSubmit"]
        Wait Until Page Contains  Add Successful
        wait until page does not contain  Add Successful
        exit for loop if    '${today}'!='01'
    END
    Verify "${rel_values}" on "${pool_id}"
    click element  //div[@id="policyInformationPoolsAddUpdateRelatedPromptsModalContainer"]/parent::div//button[contains(text(),'Close')]

Verify "${related_values}" on "${pool_id}"
    ${sql2}  catenate  select related_value from related_values where pool_id = ${pool_id}
    ${db_list}  query and strip to list  ${sql2}  db_instance=infopool
    Lists Should Be Equal  ${db_list}  ${related_values}  ignore_order=True
    ${sql3}  catenate  delete from related_values where pool_id = ${pool_id}
    execute sql string  ${sql3}  db_instance=infopool

Get pool id
    [Arguments]  ${prompt}  ${value}  ${user_id}
    ${sql}  catenate  select pool_id from infopool where pool_type = '${prompt}' and pool_value = '${value}' and carrier_id = ${user_id};
    ${pool_id}  query and strip  ${sql}  db_instance=infopool
    [Return]  ${pool_id}

Setup Infopool Carrier
    [Documentation]
                ...    Make sure that the carrier has MANAGE_INFOPOOL permission
    Ensure Carrier has User Permission  ${carrier.id}  MANAGE_INFOPOOL
    ${prompt_list}  create list  BLID
                            ...  BDAY
                            ...  CRDR
                            ...  CLCD
                            ...  CNTN
                            ...  CUNB
                            ...  CVNM
                            ...  CVNB
                            ...  DSCD
                            ...  DMLC
                            ...  DRID
                            ...  DLIC
                            ...  DLST
                            ...  NAME
                            ...  EXPT
                            ...  FSTI
                            ...  GLCD
                            ...  HBRD
                            ...  LSTN
                            ...  LSNB
                            ...  LCCD
                            ...  ODRD
                            ...  PONB
                            ...  PPIN
                            ...  PLDS
                            ...  HRRD
                            ...  RTMP
                            ...  SSUB
                            ...  SPLN
                            ...  SLDS
                            ...  TLOC
                            ...  TRLR
                            ...  TRIP
                            ...  LICN
                            ...  LCST
                            ...  UNIT
                            ...  VHNB
                            ...  PDLN
                            ...  VHTP
    set test variable  ${prompt_list}


Get a non-child carrier
    [Tags]  qtest
    [Documentation]    Look for a carrier id that isn't a child of any parent and is active:
            ...     SELECT FIRST 10 m.member_id FROM member m WHERE m.mem_type = 'C' AND m.status = 'A'
            ...     AND m.member_id not in (select carrier_id from carrier_group_xref UNION select carrier_id from carrier_referral_xref);
    ${sql}    catenate  SELECT FIRST 10 m.member_id FROM member m WHERE m.mem_type = 'C' AND m.status = 'A'
    ...     AND m.member_id not in (select carrier_id from carrier_group_xref UNION select carrier_id from carrier_referral_xref)
    ${carrier.id}   query and strip    ${sql}   db_instance=tch
    set test variable    ${carrier.id}


Update Infopools Flag
    [Tags]  qtest
    [Documentation]    Check if the member_meta table has an INFOPOOLAPI mm_key for the test's carrier and insert/update its flag.
            ...        update member_meta set mm_value = <Y/N> where mm_key = 'INFOPOOLAPI' and member_id = <carrier_id>
            ...        insert into member_meta (member_id,mm_key,mm_value) values (<carrier_id>,'INFOPOOLAPI', <Y/N>);
    [Arguments]    ${value}
    ${select_sql}   catenate    select member_id from member_meta where mm_key = 'INFOPOOLAPI' AND member_id = ${carrier.id}
    ${update_sql}    catenate    update member_meta set mm_value = '${value}' where mm_key = 'INFOPOOLAPI' and member_id = ${carrier.id}
    ${insert_sql}  catenate  insert into member_meta (member_id,mm_key,mm_value) values (${carrier.id},'INFOPOOLAPI', '${value}');

    ${member_id}    query and strip    ${select_sql}    db_instance=tch
    IF  ${member_id}==None
        execute sql string  dml=${insert_sql}  db_instance=tch
    ELSE
        execute sql string  dml=${update_sql}  db_instance=tch
    END