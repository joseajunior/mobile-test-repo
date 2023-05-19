*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ssh.PySSH  ${authsshconnection}
Library  otr_robot_lib.auth.PyAuth.AuthLog
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

*** Variables ***

*** Test Cases ***
Adding a Site Policy
    [Tags]  qTest:30858892  Tier:0
    Get A Random Carrier From DB
    Setup A Site Policy

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Select Site Policies Sub Tab
    Add A Site Policy  TIER0SITEPOLICY${SitePolicy}  ${contract_id}
    Check The Site Policy Was Created  ${carrier.id}  TIER0SITEPOLICY${SitePolicy}
    Delete created Site Policy  ${carrier.id}  TIER0SITEPOLICY${SitePolicy}

    [Teardown]  Close Browser

Adding a Site Policy - Field Validation
    [Tags]  qTest:30858892  Tier:0
    Get A Random Carrier From DB
    Setup A Site Policy

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Select Site Policies Sub Tab
    Add A Site Policy With No Parameters
    Check Mandatoy Fields
    [Teardown]  Close Browser

New Prompts for Ryder Carrier - Site Policy
    [Tags]  JIRA:ROCKET-220  JIRA:ROCKET-155  qtest:55360863  PI:13  API:Y
    [Setup]  Find Ryder Carrier
    Search a carrier in Account Manager  EFS  ${ryder_carrier['carrier_id']}
    Select Site Policies Sub Tab
    Add A Site Policy  TESTSITEPOLICY${SitePolicy}  ${ryder_carrier['contract_id']}
    Check The Site Policy Was Created  ${ryder_carrier['carrier_id']}  TESTSITEPOLICY${SitePolicy}
    Select Site policy ${site_policy_number}
    Verify Prompt list has new prompts
    Add a Prompt With Validation and value  LCCD  Report Only  LCCDV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  LCCD  ZLCCDV
    Add a Prompt With Validation and value  PLDS  Report Only  PLDSV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  PLDS  ZPLDSV
    Add a Prompt With Validation and value  SPLN  Report Only  SPLNV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  SPLN  ZSPLNV
    Add a Prompt With Validation and value  SLDS  Report Only  SLDSV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  SLDS  ZSLDSV

    Add a Prompt With Validation and value  DSCD  Report Only  DSCDV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  DSCD  ZDSCDV
    Add a Prompt With Validation and value  DMLC  Report Only  DMLCV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  DMLC  ZDMLCV
    Add a Prompt With Validation and value  LSNB  Report Only  LSNBV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  LSNB  ZLSNBV
    Add a Prompt With Validation and value  CUNB  Report Only  CUNBV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  CUNB  ZCUNBV
    Add a Prompt With Validation and value  VHTP  Report Only  VHTPV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  VHTP  ZVHTPV
    Add a Prompt With Validation and value  PDLN  Report Only  PDLNV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  PDLN  ZPDLNV
    Add a Prompt With Validation and value  CLCD  Report Only  CLCDV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  CLCD  ZCLCDV
    Add a Prompt With Validation and value  VHNB  Report Only  VHNBV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  VHNB  ZVHNBV
    Add a Prompt With Validation and value  CVNM  Report Only  CVNMV
    Verify Prompt in DB  ${ryder_carrier['carrier_id']}  CVNM  ZCVNMV
    [Teardown]  Ryder Teardown
*** Keywords ***

Navigate To Account Manager
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Get A Random Carrier From DB

    Get Into DB  TCH
    ${query}  catenate  SELECT member_id FROM member WHERE mem_type = 'C' AND status='A' LIMIT 1;
    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable  ${carrier}

    ${contract_id}  Query And Strip  SELECT contract_id FROM contract WHERE carrier_id=${carrier.id} AND status='A' LIMIT 1;
    Set Suite Variable  ${contract_id}

Search a carrier in Account Manager
    [Arguments]  ${BusinessPartner}  ${Customer}
    [Tags]  qtest
    [Documentation]  On the customer tab enter carrier from above sql
    ...  Click Submit and Click on Carrier link
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
    sleep  1
    double click on  xpath=//button[text()="${Customer}"]
    wait until element is visible  xpath=//span[text()="Detail"]
    double click on  xpath=//span[text()="Detail"]
    wait until element is visible  //td[text()="${Customer}"]  timeout=60  error=Customer Did not load within 60 seconds

Select Site Policies Sub Tab
    [Tags]  qtest
    [Documentation]  Click On Site Policies Sub Tab
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Check Element Exists  //*[@id="SitePolicies"]  timeout=30
    Click On  xpath=//span[text()="Site Policies"]

Setup A Site Policy
    ${SitePolicy}  Generate Random String  5  [LETTERS]
    ${SitePolicy}  String.Convert To Upper Case  ${SitePolicy}
    Set Suite Variable  ${SitePolicy}

Add A Site Policy
    [Arguments]  ${SitePolicy}  ${contract_id}
    [Tags]  qtest
    [Documentation]  Click On Add button
    ...  Input a name and select a contract
    ...  click submit button
#    Sleep  3s
    wait until element is visible  xpath=//*[@id="customerSitePoliciesSearchContainer"]
    click element  xpath=//*[@id="customerSitePoliciesSearchContainer"]//span[text()="ADD"]/parent::*
#    Wait Until Page Contains  text=ADD
#    Click On  xpath=//*[@id="ToolTables_DataTables_Table_0_1"]/span
    Input Text  //*[@name="sitePolicyDetail.name"]  ${SitePolicy}
    ${contract_id}  Convert To String  ${contract_id}
    Select From List By Value  //*[@id="contractName"]  ${contract_id}
    Click Button  //*[@id="customerSitePolicyAddFormButtons"]//*[@id="submit"]

Add A Site Policy With No Parameters

    Wait Until Page Contains  text=ADD
    Sleep  1
    Click On  xpath=//span[text()="ADD"]
    Click Button  //*[@id="customerSitePolicyAddFormButtons"]//*[@id="submit"]

Check The Site Policy Was Created
    [Arguments]  ${carrier_id}  ${sitepolicy}
    [Tags]  qtest
    [Documentation]  SELECT ipolicy FROM def_card WHERE id = {carrier_id} AND description='{sitepolicy}'
    Get Into DB  TCH
    FOR  ${i}  IN RANGE  5
        ${sql}  catenate  SELECT ipolicy FROM def_card WHERE id = ${carrier_id} AND description='${sitepolicy}'
        ${db_value}  query and strip  ${sql}  db_instance=${db}
        exit for loop if  '${db_value}'!='None'
        sleep  1
    END
    Row Count Is Equal To X  SELECT * FROM def_card WHERE id = ${carrier_id} AND description='${sitepolicy}'  1
    ${sql}  catenate  SELECT ipolicy FROM def_card WHERE id = ${carrier_id} AND description='${sitepolicy}';
    ${site_policy_number}  query and strip  ${sql}  db_instance=tch
    set test variable  ${site_policy_number}

Check Mandatoy Fields
    Page Should Contain  text=Name is required
    Page Should Contain  text=Contract is required

Delete created Site Policy
    [Arguments]  ${carrier_id}  ${description}
    Execute SQL String  dml=DELETE FROM def_card WHERE id = ${carrier_id} AND description='${description}'  db_instance=tch

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
                    ...  ---------------
                    ...    Login to account Manager follow TC-2113
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
    Open eManager  ${intern}  ${internPassword}
    set test variable  ${db}  tch
    ${sql}  catenate  delete from def_info where info_id in ('LCCD','PLDS','SPLN','SLDS') and carrier_id = ${ryder_carrier['carrier_id']};
    execute sql string  ${sql}  db_instance=${db}
    Navigate To Account Manager
    Setup A Site Policy

Click On Prompts Sub Tab
    [Tags]  qtest
    [Documentation]  Click On Prompts Tab
    Click Element  //*[@id="Prompts"]
    Wait Until Loading Spinners Are Gone

Ryder Teardown
    close browser
    IF  ${site_policy_number} > 505
        Delete created Site Policy  ${ryder_carrier['carrier_id']}  TESTSITEPOLICY${SitePolicy}
    END

Select Site policy ${num}
    [Tags]  qtest
    [Documentation]  Click submit to search Site Policies
    ...  select one of the availabe site policies by clicking on hyperlink
    wait until element is visible  xpath=//*[@id="customerSitePoliciesSearchContainer"]//button[@class="button searchSubmit"]
    click element  xpath=//*[@id="customerSitePoliciesSearchContainer"]//button[@class="button searchSubmit"]
    wait until loading spinners are gone
    Wait Until Element Is enabled  xpath=//*[text()=${num}]
    Click element  //*[text()=${num}]

Add a Prompt With Validation and value
    [Tags]  qtest
    [Arguments]  ${prompt}  ${validation}  ${value}
    [Documentation]  Click Prompts Tab and click Add
    ...  Select Prompt arg0 from the first dropdown
    ...  Select Validation arg1 from the next drop down
    ...  Input text in the Value textbox
    ...  click the Submit button to finish adding the prompt
    ${add_button_id}  catenate  xpath=//*[@id="policyPromptsSearchContainer"]//span[text()="ADD"]/parent::*
    wait until page contains element  ${add_button_id}
    click element  ${add_button_id}
    wait until page contains element  policyPromptsAddUpdateActionForm
    Wait Until Mini Loading Spinners Are Gone
    ${prompt_path}  catenate  //*[@id="policyPromptsAddUpdateActionForm"]//select[@name='promptSummary.promptId']
    select from list by value  ${prompt_path}  ${prompt}
    Wait Until Mini Loading Spinners Are Gone
    wait until page contains element  promptSummary.validationCode
    ${validation_path}  catenate  //*[@id="policyPromptsAddUpdateActionForm"]//select[@name='promptSummary.validationCode']
    ${myValidation}  get list items  ${validation_path}
    list should contain value  ${myValidation}  ${validation}
    select from list by label  ${validation_path}  ${validation}
    Wait Until Mini Loading Spinners Are Gone
    ${valuepath}  catenate  //*[@id="policyPromptsAddUpdateActionForm"]//input[@name="promptSummary.value"]
    wait until element is visible  ${valuepath}
    input text  ${valuepath}  ${value}
    click button  //*[@id="policyPromptsAddUpdateFormButtons"]//*[@id="submit"]

Verify Prompt in DB
    [Tags]  qtest
    [Arguments]  ${carrier_id}  ${info_id}  ${info_validation}
    [Documentation]  Verify values chaged in the DB:
                ...  select info_validation from def_info where carrier_id = {carrier_id} and info_id = '{INFO}';
    ${sql}  catenate  select info_validation from def_info where carrier_id = ${carrier_id} and info_id = '${info_id}';
    FOR  ${i}  IN RANGE  5
        ${db_value}  query and strip  ${sql}  db_instance=${db}
        exit for loop if  '${db_value}'!='None'
        sleep  1
    END
    should be equal as strings  ${db_value}  ${info_validation}

Verify Prompt list has new prompts
    [Tags]  qtest
    [Documentation]  Click add button
    ...  open prompt list and verify the new prompts are availible
    ...  click cancel
    ${add_button_id}  catenate  xpath=//*[@id="policyPromptsSearchContainer"]//span[text()="ADD"]/parent::*
    wait until page contains element  ${add_button_id}
    click element  ${add_button_id}
    wait until page contains element  policyPromptsAddUpdateActionForm
    Wait Until Mini Loading Spinners Are Gone
    ${prompt_path}  catenate  //*[@id="policyPromptsAddUpdateActionForm"]//select[@name='promptSummary.promptId']
    ${myPrompts}  get list items  ${prompt_path}
    ${new_prompts}  create list  Location Code  Product Line Desc  Subproduct Line Code  Subproduct Line Desc
    list should contain sub list  ${myPrompts}  ${new_prompts}
    click button  //*[@id="policyPromptsAddUpdateFormButtons"]//*[@name="cancel"]