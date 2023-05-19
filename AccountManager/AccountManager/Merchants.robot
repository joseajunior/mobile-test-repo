*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup  Starting Setup
Suite Teardown  Starting Teardown
Force Tags  AM


*** Variables ***
${policy}  1
${tran_u_original}
${location}

*** Test Cases ***

Mass Update On Policy
    [Tags]  JIRA:BOT-1393  qTest:32555547  Regression  refactor

    Open Account Manager
    Search A Carrier In Account Manager  EFS  ${efs_fleet_card.carrier.id}
    Click On  text=Policies
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${policy}
    Click On  text=Merchants
    Double Click On  text=Reset  exactMatch=False  index=2
    wait until loading spinners are gone
    ${merchants}=  select bulk merchants
    ${merc_count}=  get length  ${merchants}
    Click On  text=STATUS UPDATE
    Click On  text=Confirm
    wait until loading spinners are gone


    ${comma_separated}=  evaluate  ",".join(${merchants})
    Row Count Is Equal To X  SELECT * FROM def_locs WHERE ipolicy=${policy} and carrier_id = ${efs_fleet_card.carrier.id} AND location_id IN (${comma_separated})  ${merc_count.__str__()}

    select merchants  @{merchants}
    Click On  text=STATUS UPDATE
    Click On  text=Confirm

    wait until loading spinners are gone

    Row Count Is 0  SELECT * FROM def_locs WHERE ipolicy=${policy} and carrier_id = ${efs_fleet_card.carrier.id} AND location_id IN (${comma_separated})

Mass Update On Cards
    [Tags]  JIRA:BOT-1394  qTest:32555201  Regression  refactor

    search a carrier in account manager  EFS  ${efs_fleet_card.carrier.id}
    go to card  ${efs_fleet_card.num}
    Click On  text=Merchants
    Double Click On  text=Reset  exactMatch=False  index=2
    wait until loading spinners are gone
    ${merchants}=  Select Bulk Merchants
    ${merc_count}=  get length  ${merchants}
    Click On  text=STATUS UPDATE
    Click On  text=Confirm
    wait until loading spinners are gone
    ${comma_separated}=  evaluate  ",".join(${merchants})

    Row Count Is Equal To X  SELECT * FROM card_loc WHERE card_num='${efs_fleet_card.num}' AND location_id IN (${comma_separated})  ${merc_count.__str__()}

    select merchants  @{merchants}
    Click On  text=STATUS UPDATE
    Click On  text=Confirm

    Wait Until Loading Spinners Are Gone

    Row Count Is 0  SELECT * FROM card_loc WHERE card_num='${efs_fleet_card.num}' AND location_id IN (${comma_separated})

Unauthorize And Reauthorize a Location
    [Tags]  JIRA:BOT-1356  JIRA:BOT-1357  qTest:32625062  Regression  refactor

    ${location}=  set variable  ${efs_fleet_card.valid_location.id}
    Search For A Card  ${efs_fleet_card.num}
    Go to Merchant Sub Menu
    Select And Unauthorize Location  ${location}
    Ensure Location is Unauthorized On DB  ${location}
    Reauthorize Location  ${location}
    Ensure Location is Authorized On DB  ${location}

Apply Merchant Number Filter
    [Tags]  JIRA:BOT-1358  qTest:32625241  Regression  refactor
    ${location}=  set variable  ${efs_fleet_card.valid_location.id}
    Search For A Card  ${efs_fleet_card.num}
    Go to Merchant Sub Menu
    Apply Merchant Filter  ${location}
    Ensure Table Data Is Filtered By  Merchant #  ${location}
#    [Teardown]  Close Browser

Apply Name Filter
    [Tags]  JIRA:BOT-1358  qTest:32626576  Regression  refactor
    Apply Name Filter  FJ-TEXARKANA 606
    Ensure Table Data Is Filtered By  Name  FJ-TEXARKANA 606
#    [Teardown]  Close Browser

Apply Address Filter
    [Tags]  JIRA:BOT-1358  qTest:32626581  Regression  refactor
    Apply Address Filter  I-30 EXIT 7
    Ensure Table Data Is Filtered By  Address  I-30 EXIT 7
#    [Teardown]  Close Browser

Apply City Filter
    [Tags]  JIRA:BOT-1358  qTest:32626585  Regression  refactor
    Apply City Filter  Ogden
    Ensure Table Data Is Filtered By  City  Ogden
#    [Teardown]  Close Browser

Apply State Filter
    [Tags]  JIRA:BOT-1358  qTest:32626587  Regression  refactor
    Apply ST PROV Filter  UT
    Ensure Table Data Is Filtered By  ST/PROV  UT
#    [Teardown]  Close Browser

Apply Country Filter
    [Tags]  JIRA:BOT-1358  qTest:32626591  Regression  refactor
    Apply Country Filter  USA
    Ensure Table Data Is Filtered By  Country  USA
#    [Teardown]  Close Browser

Apply Type Filter
    [Tags]  JIRA:BOT-1358  qTest:32626596  Regression  refactor
    Apply Type Filter  AFL
    Ensure Table Data Is Filtered By  Type  AFL
#    [Teardown]  Close Browser

Apply Status Filter
    [Tags]  JIRA:BOT-1358  qTest:32626598  Regression  BUGGED: Status Column is always EMPTY.
    Apply Status Filter  Authorized
    Ensure Table Data Is Filtered By  Status  Authorized
#    [Teardown]  Close Browser

Apply Source Filter
    [Tags]  JIRA:BOT-1358  qTest:32626599  Regression  refactor
    Apply Source Filter  Card
    Ensure Table Data Is Filtered By  Source  Card

Select All Locations
    [Tags]  JIRA:BOT-1359  qTest:32626604  Regression  refactor
#    Open Account Manager
    Search For A Card  ${efs_fleet_card.num}
    Go to Merchant Sub Menu
    Search All Locations
    Select All Locations
    Ensure That All Locations Are Selected On Screen
    [Teardown]  Close Browser

*** Keywords ***
Navigate To Account Manager
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Search For A Card
    [Arguments]  ${card_num}
    ${onsearch}=  Url Shows  /acct-mgmt/RecordSearch.action

    run keyword unless  ${onsearch}  navigate to account manager
    Wait Until Element is Enabled  //a[@id='Card']
    Click on  //a[@id='Card']
    Wait Until Element Is Visible  name=cardNumber
    refresh page
    Wait Until Element Is Visible  name=businessPartnerCode
    Select From List By Value  businessPartnerCode  EFS
    Wait Until Element is Enabled  //input[@name='cardNumber']
    Input Text  name=cardNumber  ${card_num}
    double click on  text=Submit  exactMatch=False  index=1
    Wait Until Element is Visible  id=DataTables_Table_0
    Wait Until Element is Visible  //button[text()='${card_num}']
    Set Focus To Element  //button[text()='${card_num}']
    click on  //button[text()='${card_num}']
    Wait Until Element Is Enabled  id=submit

Go to Merchant Sub Menu
    Wait Until Element is Visible  //a[@id='Merchants']
    Click Element  //a[@id='Merchants']

Select And Unauthorize Location
    [Arguments]  ${location}

    Wait Until Element Is Visible  name=merchantNumber
    input text  merchantNumber  ${location}
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  //*[@value="${location}" and @type="checkbox"]
    Click On  text=STATUS UPDATE
    Click On  text=Confirm
    Wait Until Element is Visible  //ul[@class='msgSuccess']/li

Ensure Location is Unauthorized On DB
    [Arguments]  ${location}
    ${query}  Catenate  SELECT 1 FROM card_loc WHERE card_num = '${efs_fleet_card.num}' AND location_id = ${location}
    Row Count Is Equal to X  ${query}  1

Ensure Location is Authorized On DB
    [Arguments]  ${location}
    Sleep  5
    ${query}  Catenate  SELECT 1 FROM card_loc WHERE card_num = '${efs_fleet_card.num}' AND location_id = ${location}
    Row Count Is 0  ${query}

Reauthorize Location
    [Arguments]  ${location}
    Click On  //*[@value="${location}" and @type="checkbox"]
    Click On  text=STATUS UPDATE
    Click On  text=Confirm
    Wait Until Element is Visible  //ul[@class='msgSuccess']/li

Select All Locations
    Click On  text=SELECT ALL

Ensure That All Locations Are Selected On Screen
    Sleep  5
    ${rows}  Get Element Count  //table[@id='DataTables_Table_1']//td[@class=' sorting_1']
    FOR  ${i}  IN RANGE  1  ${rows}
        Element Should Be Visible  //table[@id='DataTables_Table_1']//tr[${i}]//td/input[@disabled='disabled']
    END

Ensure Table Data Is Filtered By
    [Arguments]  ${column}  ${expected_value}
    Sleep  5
    click element  //*[@class='searchTable dataTable']//preceding-sibling::*[contains(text(),'Status')]
    sleep  3
    ${rows}  Get Element Count  //table[@id='DataTables_Table_1']//td[count(//div[@id='DataTables_Table_1_wrapper']//th[text()='${column}']/preceding-sibling::th)+1]
    FOR  ${i}  IN RANGE  1  ${rows}+1
        ${value}  Get Text  //table[@id='DataTables_Table_1']//tr[${i}]//td[count(//div[@id='DataTables_Table_1_wrapper']//th[text()='${column}']/preceding-sibling::th)+1]
        Should Contain  ${value}  ${expected_value.upper()}
    END

Apply Merchant Filter
    [Arguments]  ${merchant}
    Clear All Fields
    Input Filter  merchantNumber  ${merchant}
    Submit Filter

Apply Name Filter
    [Arguments]  ${name}
    Clear All Fields
    Input Filter  name  ${name}
    Submit Filter

Apply Address Filter
    [Arguments]  ${address}
    Clear All Fields
    Input Filter  address1  ${address}
    Submit Filter

Apply City Filter
    [Arguments]  ${city}
    Clear All Fields
    Input Filter  city  ${city}
    Submit Filter

Apply Source Filter
    [Arguments]  ${src}
    Clear All Fields
    Select From List By Value  //div[@id='cardMerchantsSearchContainer']//select[@name='source']  ${src.upper()}
    Submit Filter

Apply ST PROV Filter
    [Arguments]  ${state}
    Clear All Fields
    Select Filter By Value  stateProv  ${state}
    Submit Filter

Apply Country Filter
    [Arguments]  ${country}
    Clear All Fields
    Select Filter By Value  country  ${country}
    Submit Filter

Apply Type Filter
    [Arguments]  ${type}
    Clear All Fields
    Select Filter By Value  type  ${type}
    Submit Filter

Apply Status Filter
    [Arguments]  ${status}
    Clear All Fields
    Select Filter By Value  status  ${status}
    Submit Filter

Input Filter
    [Arguments]  ${field_name}  ${value}
    Input Text  name=${field_name}  ${value}

Select Filter By Value
    [Arguments]  ${field_name}  ${value}
    Select From List By Value  name=${field_name}  ${value.upper()}

Select Filter By Label
    [Arguments]  ${field_name}  ${value}
    Select From List By Label  name=${field_name}  ${value}

Submit Filter
    Double Click On  text=Submit  exactMatch=False  index=2
    wait until loading spinners are gone

Clear All Fields
    Sleep  2
    Input Text  name=merchantNumber  ${EMPTY}
    Input Text  name=name  ${EMPTY}
    Input Text  name=address1  ${EMPTY}
    Input Text  name=city  ${EMPTY}
    Input Text  name=discount  ${EMPTY}
    Select From List By Value  source  BOTH
    Select From List By Label  stateProv  Select
    Select From List By Label  country  Select
    Select From List By Label  type  Select
    Select From List By Label  status  Select

Search All Locations
    Wait Until Element Is Visible  name=merchantNumber
    Double Click On  text=Reset  exactMatch=False  index=2

Go to Card
    [Arguments]  ${card}
    ${onCustomer}=  Url Shows  acct-mgmt/Customer.action
    run keyword if  not ${onCustomer}  search a carrier in account manager  EFS  ${efs_fleet_card.carrier.id}

    Click Secondary Tab By Text  Cards
    wait until loading spinners are gone
    input text  cardNumber  ${card}
    Click Search Section Submit
    wait until loading spinners are gone
    scroll element into view  //*[text()='${card}']
    Click Search Section Button (or text that looks like a link that is a button) by Text  ${card}
    wait until loading spinners are gone

    ${onCardScreen}  Url Shows  /acct-mgmt/Card.action
    run keyword if  not ${onCardScreen}  fail  Policy Screen Did Not Load After Clicking Policy: ${card}


Select Bulk Merchants
    ${xpathVal}=  set variable  //*[@id="secondaryTabs"]//td//input[@type="checkbox" and string-length(@value) = 6]
    ${cnt}=  get element count  xpath=${xpathVal}

    ${num_of_merchs}=  evaluate  min(${cnt},5)+1

    @{list_of_merches}=  create list
    FOR  ${I}  IN RANGE  1  ${num_of_merchs}
        click element  xpath=(${xpathVal})\[${I}]
        scroll element into view  xpath=(${xpathVal})\[${I}]
        ${v}  get element attribute  xpath=(${xpathVal})\[${I}]  value
        append to list  ${list_of_merches}  ${v}
    END

    [Return]  ${list_of_merches}

Select Merchants
    [Arguments]  @{MERCHES}
    FOR  ${MERCH}  IN  @{MERCHES}
        click element  xpath=//*[@value="${MERCH}" and @type="checkbox"]
    END

Set Tran Update
    [Arguments]  ${Member}  ${Tran_Update}
    Execute SQL String  dml=UPDATE member set tran_update = '${Tran_Update}' where member_id = ${Member}


Starting Setup
    start setup card  ${efs_fleet_card.num}
    setup card header  locationSource=CARD
    get into db  tch
    set suite variable  ${tran_u_original}  ${efs_fleet_card.carrier.tran_update}
    set tran update  ${efs_fleet_card.carrier.id}  N

Starting Teardown
    set tran update  ${efs_fleet_card.carrier.id}  ${tran_u_original}
