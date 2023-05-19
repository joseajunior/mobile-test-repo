*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup  Setup
Suite Teardown  Close All Browsers
Force Tags  Portal  Application Manager  weekly  Regression  run
Documentation  This is to test if a user can search for sales using sales person or member ID
...  and access the results

*** Variables ***
${sales_user}  Bill Taylor

*** Test Cases ***
Retail Fuel Value Is Being Saved On Database
    [Tags]  JIRA:PORT-327  qTest:  Regression
    [Documentation]  This is to test a user can Retail Fuel option in Product dropdown
    Select A Sale
    Set Values For Product  Retail Fuel  56
    Save Values
    Verify Values Saved On Database  19  56

Retail Maintenance Value Is Being Saved On Database
    [Tags]  JIRA:PORT-327  qTest:  Regression
    [Documentation]  This is to test a user can Retail Maintenance option in Product dropdown
    Select A Sale
    Set Values For Product  Retail Maintenance  11
    Save Values
    Verify Values Saved On Database  20  11

Retail Other Value Is Being Saved On Database
    [Tags]  JIRA:PORT-327  qTest:  Regression
    [Documentation]  This is to test a user can Retail Other option in Product dropdown
    Select A Sale
    Set Values For Product  Retail Other  635
    Save Values
    Verify Values Saved On Database  21  635

Factoring Value Is Being Saved On Database
    [Tags]  JIRA:PORT-416  JIRA:PORT-390  qTest:  Regression
    [Documentation]  This is to test a user can Factoring option in Product dropdown
    Select A Sale
    Set Values For Product  Factoring  467
    Save Values
    Verify Values Saved On Database  22  467

Hotels Value Is Being Saved On Database
    [Tags]  JIRA:PORT-416  JIRA:PORT-390 qTest:  Regression
    [Documentation]  This is to test a user can Hotels option in Product dropdown
    Select A Sale
    Set Values For Product  Hotels  10
    Save Values
    Verify Values Saved On Database  23  10

Tires Value Is Being Saved On Database
    [Tags]  JIRA:PORT-416  JIRA:PORT-390  qTest:  Regression
    [Documentation]  This is to test a user can Tires option in Product dropdown
    Select A Sale
    Set Values For Product  Tires  323
    Save Values
    Verify Values Saved On Database  24  323

Tolls Fuel Value Is Being Saved On Database
    [Tags]  JIRA:PORT-416  JIRA:PORT-390  qTest:  Regression
    [Documentation]  This is to test a user can Tolls option in Product dropdown
    Select A Sale
    Set Values For Product  Tolls  1
    Save Values
    Verify Values Saved On Database  25  1

Toll Service Fee Fuel Value Is Being Saved On Database
    [Tags]  JIRA:PORT-416  JIRA:PORT-390  qTest:  Regression
    [Documentation]  This is to test a user can Toll Service Fee option in Product dropdown
    Select A Sale
    Set Values For Product  Toll Service Fee  600
    Save Values
    Verify Values Saved On Database  26  600

Search with Sales Person
    [Tags]  JIRA:BOT-1666  qTest:32214053
    [Documentation]  This is to test if a user can search sales using sales person value
    select from list by label  request.search.searchCondition  Adam Levy
    click portal button  Search
    wait until done processing
    wait until element is visible  xpath=//*[@id="salesProjectedList"]
    wait until page contains element  //*[@id="salesProjectedList"]/tbody/tr[2]/td[2]/div/table  timeout=60
    table should contain  xpath=//*[@id="salesProjectedList"]  Adam Levy

Search with Sales Member Id and access the results
    [Tags]  JIRA:BOT-1667  JIRA:BOT-1668  qTest:32214094
    [Documentation]  This is to test if a user can search sales using member ID value
    ...  and access the results
    refresh page
    wait until element is enabled  memberId
    input text  memberId  102230
    click portal button  Search
    wait until done processing
    wait until page contains element  //*[@id="salesProjectedList"]  timeout=60
    page should contain element  xpath=//*[@id="salesProjectedList"]
    table should contain  xpath=//*[@id="salesProjectedList"]  102230
    double click on  //*[@id="salesProjectedList"]/tbody/tr[2]/td[2]/div/table/tbody/tr/td[2]/div
    wait until element is visible  xpath=//*[@id="editsalesProjectedList_content"]
    click portal button  Cancel  //*[@id="editsalesProjectedList_content"]

*** Keywords ***
Setup
    Open Browser to portal
    ${status}=  Log Into Portal
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}
    Select Portal Program  Application Manager
    Hover Over  //*[@class='menu_content']/*/*[contains(text(),'Sales')]
    Click Element  //*[@id="pm_2.0"]
    Wait Until Element Is Visible  name=request.search.searchCondition
    Search A Sale

Exit From Editing Mode
    Click Portal Button  Cancel

Save Values
    Click Portal Button  Save
    Wait Until Done Processing

Search A Sale
    Click Element  xpath=//div[@id="pm_1"]/following-sibling::*[1]
    Click Element  xpath=//*[@id="nopad"]//descendant::*[contains(text(),'Processed Sales')]
    Select From List By Label  request.search.searchCondition  ${sales_user}
    Click Portal Button  Search

Select A Sale
    Wait Until Element Is Visible  //*[@id="salesProjectedList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]  timeout=30
    Wait Until Element Is Enabled  //*[@id="salesProjectedList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]  timeout=30
    Double Click Element  //*[@id="salesProjectedList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]
    Wait Until Done Processing

Set Values For Product
    [Arguments]  ${product}  ${projected_revenue}
    Select From List By Label  request.salesProjected.productId  ${product}
    Input Text  request.salesProjected.projectedRevenue  ${projected_revenue}

Verify If The Correct Product Is Selected
    [Arguments]  ${expected_product}
    Select A Sale
    ${selected_product}  Get Value  request.salesProjected.productId
    Should Be Equal As Integers  ${expected_product}  ${selected_product}

Verify If The Fields Can Be Selected
    Select From List By Label  request.salesProjected.productId  Retail Fuel
    Select From List By Label  request.salesProjected.productId  Retail Maintenance
    Select From List By Label  request.salesProjected.productId  Retail Other
    Select From List By Label  request.salesProjected.productId  Factoring
    Select From List By Label  request.salesProjected.productId  Hotels
    Select From List By Label  request.salesProjected.productId  Tires
    Select From List By Label  request.salesProjected.productId  Toll Service Fee
    Select From List By Label  request.salesProjected.productId  Tolls

Verify Values Saved On Database
    [Arguments]  ${product_id}  ${projected_revenue}
    Get Into Db  TCH
    ${query}  Catenate  SELECT sf.name, sp.product_id, sp.projected_revenue FROM sales_folk as sf
    ...  JOIN sales_projected as sp ON sp.sales_person = sf.number WHERE sf.name = '${sales_user}';
    ${sales_result}  Query And Strip To Dictionary  ${query}
    Should Be Equal As Integers  ${sales_result['product_id']}[0]  ${product_id}
    Should Be Equal As Integers  ${sales_result['projected_revenue']}[0]  ${projected_revenue}