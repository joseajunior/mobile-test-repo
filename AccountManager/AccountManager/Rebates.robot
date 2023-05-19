*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.auth.PyAuth.Transactions
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM  Card  refactor

*** Variables ***
${contract_id}  283600

*** Test Cases ***
Adding a Rebate Specific Contract - End to End
    [Tags]  JIRA:BOT-1396  qTest:31750930  Regression  Tier:0
    [Documentation]  Make sure you can create a new Rebate on Account Manager and that it reflects on DB.

    ${today}  GetDateTimeNow  %m/%d/%YY
    ${tomorrow}  GetDateTimeNow  %m/%d/%YY  days=+3
    Set Suite Variable  ${rebate_name}  101 - All Transactions Rebate

    Get A Random Carrier From DB

    Open Account Manager
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Select Rebates Sub Tab
    Add A Rebate   101  ${contract_id}  0.0040  ${today}  ${tomorrow}
    Check Created Rebate On DB  ${carrier.id}  0.0040  101  ${contract_id}
    Delete Created Rebate  ${carrier.id}  ${contract_id}  0.0040  101

    [Teardown]  Close Browser

Adding a Rebate All Contracts
    [Tags]  qTest:31750610  Tier:0

    ${today}  GetDateTimeNow  %m/%d/%YY
    ${tomorrow}  GetDateTimeNow  %m/%d/%YY  days=+3
    Set Suite Variable  ${rebate_name}  101 - All Transactions Rebate

    Get A Random Carrier From DB

    Open Account Manager
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Select Rebates Sub Tab
    Add A Rebate   101  0  0.0040  ${today}  ${tomorrow}  #0 = All Contracts
    Check Created Rebate On DB  ${carrier.id}  0.0040  101  0
    Delete Created Rebate  ${carrier.id}  0  0.0040  101

    [Teardown]  Close Browser

Adding a Rebate - Fields Validation
    [Tags]  qTest:49945207  Tier:0
    [Setup]  Get A Random Carrier From DB

    Open Account Manager
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Select Rebates Sub Tab
    Add A Rebate - Fields Validation
    Check Rebate Was Not Added

    [Teardown]  Close Browser


Adding Tiers To Rebates
    [Tags]  JIRA:BOT-1396  qTest:31751310  Regression
    [Documentation]  Adding Tiers To Rebates according to FLT-1292
    [Setup]  Get A Random Carrier From DB
    Set Suite Variable  ${rebate_name}  101 - All Transactions Rebate

    Open Account Manager
    Search a carrier in Account Manager  EFS  ${carrier.id}
    Select Rebates Sub Tab
    Click On Reset Button
    If No Rebate Found, Add One
    Click On Tiers Button For a Rebate
    Fill In Form And Submit
    See The Update Message On Screen

    Validate Added Tiers On DB

    [Teardown]  Run Keywords  Delete Created Tiers
    ...     AND  Close Browser

*** Keywords ***
Get A Random Carrier From DB

    Get Into DB  TCH
    ${query}  catenate  SELECT member_id FROM member WHERE mem_type = 'C' AND status='A' LIMIT 10;
    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable  ${carrier}

    ${contract_id}  Query And Strip  SELECT contract_id FROM contract WHERE carrier_id=${carrier.id} AND status='A' LIMIT 1;
    Set Suite Variable  ${contract_id}


Search a carrier in Account Manager
    [Arguments]  ${BusinessPartner}  ${Customer}
    ${current}=  get location
    ${goback}=  evaluate  '/acct-mgmt/RecordSearch.action' not in '${current}'
    run keyword if  ${goback}  Go Back To Record Search
    ${stat}=  run keyword and return status  alert should be present
    run keyword if  ${stat}  run keyword and ignore error  handle alert
    click on  text=Customers
    wait until element is visible  businessPartnerCode
    select from list by value  businessPartnerCode  ${BusinessPartner}
    input text  id  ${Customer}
    double click on  text=Submit  exactMatch=False
    wait until element is visible   //button[text()="${Customer}"]
    sleep  1
    double click on  xpath=//button[text()="${Customer}"]
    wait until element is visible  xpath=//span[text()="Detail"]
    double click on  xpath=//span[text()="Detail"]
    wait until element is visible  //td[text()="${Customer}"]  timeout=60  error=Customer Did not load within 60 seconds

Select Rebates Sub Tab
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Check Element Exists  //*[@id="Rebates"]  timeout=30
    Click On  text=Rebates

Add A Rebate
    [Arguments]  ${rebate_type}  ${contract_id}  ${rebate_amt}  ${eff_date}  ${exp_date}


    Click On  //*[@id="customerRebatesSearchContainer"]//span[text()="ADD"]/parent::*
    Wait Until Element Is Visible  //*[@id="rebateTypeDefAdd"]  timeout=20
    Select From List By Value  //table[@id="rebateAddDialog"]//*[@id="rebateTypeDefAdd"]  ${rebate_type}   #ALL TRANSACTIONS REBATE
    Sleep  1
    ${contract_id}=  Convert To String  ${contract_id}
    Select From List By Value  //table[@id="rebateAddDialog"]//*[@id="contractIdDef"]  ${contract_id}
    Input Text  //table[@id="rebateAddDialog"]//*[@id="rebateFeeDef"]  ${rebate_amt}
    Input Text  //table[@id="rebateAddDialog"]//*[@id="effectiveAddDate"]  ${eff_date}
    Input Text  //table[@id="rebateAddDialog"]//*[@id="expireAddDate"]  ${exp_date}
    Click On  text=Submit
    Check Element Exists  text=${rebate_name}
    Check Element Exists  text=${rebate_amt}


Add A Rebate - Fields Validation

    Click On  text=ADD
    Wait Until Element Is Visible  //*[@id="rebateTypeDefAdd"]  timeout=20
    Click On  text=Submit


Check Created Rebate On DB
    [Arguments]  ${carrier_id}  ${rebate_amt}  ${rebate_type}  ${contract_id}

    Get Into DB  TCH
    ${query}  catenate  SELECT TO_CHAR(rebate_fee, '&&.&&&&') AS rebate_fee
    ...     FROM carrier_rebate_def WHERE carrier_id=${carrier_id} AND  rebate_type=${rebate_type} AND contract_id=${contract_id}
    ${rebate_fee}  Query And Strip  ${query}

    Should Be Equal As Strings  ${rebate_fee}  0${rebate_amt}

Delete Created Rebate
    [Arguments]  ${carrier_id}  ${contract_id}  ${rebate_amt}  ${rebate_type}
    Get Into DB  TCH
    Execute SQL String  dml=DELETE FROM carrier_rebate_def WHERE carrier_id=${carrier_id} AND contract_id=${contract_id} AND rebate_fee='${rebate_amt}' AND rebate_type=${rebate_type};

Check Rebate Was Not Added
    Page Should Contain  text=This field is required
    Page Should Contain  text=Effective Date must be greater than or equal to Today!

Click On Reset Button
    Click On  //*[@id="customerRebatesSearchContainer"]//button[@class="button resetButton"]
    Wait Until Loading Spinners Are Gone

Click On Tiers Button For a Rebate
    ${rebaseId}=  Get Element Attribute  //*[@class="rebateTiers"]  rebatetypedef
    Click On  //*[@class="rebateTiers"]
    Wait Until Element Is Visible  //*[@id="tierPeriod"]  timeout=20
    Set Test Variable  ${rebaseId}

Delete Created Tiers
    #I'M DELETING THIS ON DB SO WE DON'T HAVE A LOT OF REBATES BEING CREATED EVERYTIME THIS SCRIPT RUNS
    Get Into DB  TCH
    Execute SQL String  dml=DELETE FROM carrier_rebate_def WHERE carrier_id = ${carrier.id} AND rebate_type = ${rebaseId} AND rebate_fee=0.0040
    Execute SQL String  dml=DELETE FROM carrier_rebate_tier_set WHERE carrier_id = ${carrier.id} AND rebate_type = ${rebaseId} ANd tier_type='V' AND tier_period='M'
    Execute SQL String  dml=DELETE FROM carrier_rebate_tier WHERE tier_level = 1 AND tier_set=${results.tier_set[0]}
    Execute SQL String  dml=DELETE FROM carrier_rebate_tier WHERE tier_level = 2 AND tier_set=${results.tier_set[0]}
    Execute SQL String  dml=DELETE FROM carrier_rebate_tier WHERE tier_level = 3 AND tier_set=${results.tier_set[0]}
    Execute SQL String  dml=DELETE FROM carrier_rebate_tier WHERE tier_level = 4 AND tier_set=${results.tier_set[0]}
    Disconnect From Database

Fill In Form And Submit
    Wait Until Element Is Visible  //*[@id="tierPeriod"]  timeout=20
    Select From List By Value  //*[@id="tierPeriod"]  M
    Wait Until Element Is Visible  //*[@id="tierType"]  timeout=20
    Select From List By Value  //*[@id="tierType"]  V
    Input Text  cell_1_2  19999      #Max Units Cell
    Input Text  cell_1_3  0          #Rebate Box
    Input Text  cell_2_2  40000
    Input Text  cell_2_3  0.004
    Input Text  cell_3_2  60000
    Input Text  cell_3_3  0.005
    Input Text  cell_4_3  0.006
    Click On  //*[@id="rebateTiersAddUpdateActionForm"]//button[@id="submit"]

If No Rebate Found, Add One
    ${exists}=  Run Keyword And Return Status  Check Element Exists  //td[@class="dataTables_empty" and text()="No records found."]
    ${today}  GetDateTimeNow  %m/%d/%YY
    ${tomorrow}  GetDateTimeNow  %m/%d/%YY  days=+3
    Run Keyword If  ${exists}  Add A Rebate   101  0  0.0040  ${today}  ${tomorrow}  #0 = All Contracts

See The Update Message On Screen
    Wait Until Element Is Visible  //*[@id="customerRebatesMessages"]/ul[@class="msgSuccess"]/li  timeout=10

Validate Added Tiers On DB
    Get Into DB  TCH
    ${query}=  catenate  SELECT * FROM carrier_rebate_tier ct
    ...     JOIN carrier_rebate_tier_set cs ON ct.tier_set = cs.tier_set WHERE cs.carrier_id = '${carrier.id}'
    ...     AND   cs.rebate_type = ${rebaseId} ORDER BY ct.tier_level ASC
    ${results}=  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    Set Test Variable  ${results}

    Should Be Equal As Strings  ${results["rebate_fee"][0]}  0.0000
    Should Be Equal As Strings  ${results["rebate_fee"][1]}  0.0040
    Should Be Equal As Strings  ${results["rebate_fee"][2]}  0.0050
    Should Be Equal As Strings  ${results["rebate_fee"][3]}  0.0060

    Should Be Equal As Strings  ${results["minimum"][0]}  0.0000
    Should Be Equal As Strings  ${results["minimum"][1]}  19999.0100
    Should Be Equal As Strings  ${results["minimum"][2]}  40000.0100
    Should Be Equal As Strings  ${results["minimum"][3]}  60000.0100

    Should Be Equal As Strings  ${results["maximum"][0]}  19999.0000
    Should Be Equal As Strings  ${results["maximum"][1]}  40000.0000
    Should Be Equal As Strings  ${results["maximum"][2]}  60000.0000
    Should Be Equal As Strings  ${results["maximum"][3]}  9999999.9900