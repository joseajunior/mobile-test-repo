*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Library  String
Library  DateTime
Library  Collections
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Portal  Credit Manager
Documentation  When an EFS Domain account is viewing an Irving Affiliate Billing Contract:
               ...  The contract tab is read only and cannot be modified
               ...  The History tab is hidden
               ...  The Trend tab is hidden
               ...  Tabs Limits, Setup, Fees, Payment and Recourse Codes are read only and cannot be modified

Test Setup  Open Browser And Login To Portal
Test Teardown  Close Browser

*** Variables ***
${contractID}  537811
${carrierID}  803816
${comparison}
#${PortalIrvingUsername}    robot_irv@irving
#${PortalIrvingUserId}    robot_irv
${username}  dbtest_EFS@efsllc
${password}  test123

*** Test Cases ***
Verify Contract Information cannot be modified on Contract tab
    [Tags]  JIRA:PORT-730  qTest:55647039
    [Documentation]  Confirm History and Trends tab are not visible
                 ...  Contract information cannot be modified on the Contract tab.  The Save button is also disabled
    Get Irving Affiliate Billing Contract
    Missing History And Trends Tab
    Confirm Contract Information Fields Are Disabled
    Check Disabled Buttons
    Confirm Limits Fields Are Disabled
    Confirm Setup Fields Are Disabled
    Confirm Fees Fields Are Disabled
    Confirm Payments Fields Are Disabled
    Confirm Recourse Codes Fields Are Disabled
    Check Return Button
#   TODO  Test top menu bar

*** Keywords ***
Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=15

Open Browser And Login To Portal
    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${username}    ${password}

Get Irving Affiliate Billing Contract
    Select Portal Program  Credit Manager
    Search Contract
    Wait Until Done Processing  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[2]/td[3]/div[contains(class(),'jtd')]
    Select Contract
    Wait Until Page Contains  Contract Information

Missing History And Trends Tab
    Page Should Not Contain  xpath=//span[contains(text(),'History')]
    Page Should Not Contain  xpath=//span[contains(text(),'Trends')]

Confirm Contract Information Fields Are Disabled
#   Name on Statement
    Element Should Be Disabled  //*[@id="creditForm"]/div[1]/div[1]/fieldset/div[1]/div[1]/div[1]/div[1]/div[2]/input
#   Status
    Element Should Be Disabled  //*[@id="status"]
#   Cards
    Element Should Be Disabled  //*[@id="creditForm"]/div[1]/div[1]/fieldset/div[1]/div[1]/div[1]/div[3]/div[2]/input
#   Language
    Element Should Be Disabled  //*/div[1]/div[5]/div[2]/select[@id="abc"]
#   Currency
    Element Should Be Disabled  //*[@id="contCurrency"]
#   Irving Status
    Element Should Be Disabled  //*[@id="irvStatus"]
#   Limit Method
    Element Should Be Disabled  //*[@id="limitMethod"]
#   Allowed Overrides
    Element Should Be Disabled  //*/div[3]/div[3]/div[2]/select[@id="abc"]
#   Terms
    Element Should Be Disabled  //*/div[4]/div[1]/div[3]/select[@id="abc"]
#   Statement Cycle
    Element Should Be Disabled  //*/div[4]/div[2]/div[3]/select[@id="abc"]
#   Statement Type
    Element Should Be Disabled  //*[@id="creditForm"]/div[1]/div[1]/fieldset/div[1]/div[1]/div[4]/div[4]/div[2]/input
#   Collector
    Element Should Be Disabled  //*[@id="selMgrCode"]
#   Account Type
    Element Should Be Disabled  //*[@id="selAcctType"]
#   Last Reviewed
    Element Should Be Disabled  //*[@id="revDt"]
#   Followup
    Element Should Be Disabled  //*[@id="nxtRvwDt"]
#   Action Date
    Element Should Be Disabled  //*[@id="actionDate"]

Check Disabled Buttons
#   Save button
    Page Should Contain Element  //*[@id="saveContractForm" and @class="jbtn disabled"]
#   Queues Edit button
    Page Should Contain Element  //*[@id="creditForm"]/div[1]/div[1]/fieldset/div[3]/a[@class="jbtn disabled"]
#   Contact Information Add button
    Page Should Contain Element  //*[@id="contactInfoDiv"]/a[1][@class="jbtn disabled"]
#   Contact Information Edit button
    Page Should Contain Element  //*[@id="contactInfoDiv"]/a[2][@class="jbtn disabled"]
#   Contact Information Delete button
    Page Should Contain Element  //*[@id="contactInfoDiv"]/a[3][@class="jbtn disabled"]

Confirm Limits Fields Are Disabled
    Click On  //*[@id="creditForm"]/div[1]/div[3]/ul/li[1]/div/span[2]
    Sleep  1
#   Credit Avail
    Element Should Be Disabled  //*[@id="creditLimit"]
#   Curr Credit Avail
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[1]/div[1]/div[2]/div[2]/input
#   Daily Limit
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[1]/div[1]/div[4]/div[2]/input
#   Daily Avail
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[1]/div[1]/div[5]/div[2]/input
#   Credit Limit
    Element Should Be Disabled  //*[@id="crdLine"]
#   Last Changed By
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[1]/div[2]/div[2]/input
#   Last Changed Dt
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[1]/div[3]/div[2]/input
#   Prev Credit Limit
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[1]/div[5]/div[2]/input
#   Prev Changed By
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[1]/div[6]/div[2]/input
#   Prev Changed Dt
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[1]/div[7]/div[2]/input
#   Daily Cash Limit
    Element Should Be Disabled  //*[@id="tbDailyCadvLimit"]
#   Daily Cash Avail
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[1]/div[3]/div[3]/div[2]/input
#   Daily MC Limit
    Element Should Be Disabled  //*[@id="tbDailyMCLimit"]
#   Daily MC Avail
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[1]/div[3]/div[6]/div[2]/input
#   Trans Limit
    Element Should Be Disabled  //*[@id="transLimit"]
#   Cash Limit
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[3]/div[2]/div[2]/input
#   MC Limit
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[3]/div[3]/div[2]/input
#   PCH Amt
    Element Should Be Disabled  //*[@id="limits"]/fieldset/div[2]/div[3]/div[5]/div[2]/input

Confirm Setup Fields Are Disabled
    Click On  //*[@id="creditForm"]/div[1]/div[3]/ul/li[2]/div/span[2]
    Sleep  1
#   LOC Amount
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[1]/div[1]/div[2]/input
#   Expire Date
    Element Should Be Disabled  //*/div[1]/div[3]/div[2]/span/input[@class=" jreadonly"]
#   ACI Amount
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[2]/div[1]/div[2]/input
#   Expire Date
    Element Should Be Disabled  //*/div[2]/div[3]/div[2]/span/input[@class=" jreadonly"]
#   Bond Amount
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[3]/div[1]/div[2]/input
#   Expire Date
    Element Should Be Disabled  //*/div[3]/div[3]/div[2]/span/input[@class=" jreadonly"]
#   Finacials Date
    Element Should Be Disabled  //*/div[4]/div/div[2]/span/input[@class=" jreadonly"]
#   Guarantor
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[6]/div[1]/div[2]/input
#   Date
    Element Should Be Disabled  //*/div[6]/div[3]/div[2]/span/input[@class=" jreadonly"]
#   Net Income
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[7]/div[1]/div[2]/input
#   Net Equity
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[7]/div[2]/div[2]/input
#   EBITDA
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[7]/div[3]/div[2]/input
#   Debt/Eq
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[7]/div[5]/div[2]/input
#   Paydex #
    Element Should Be Disabled  //*[@id="paydex"]
#   Risk
    Element Should Be Disabled  //*[@id="setup"]/fieldset/div[7]/div[7]/div[2]/input

Confirm Fees Fields Are Disabled
    Click On  //*[@id="creditForm"]/div[1]/div[3]/ul/li[3]/div/span[2]
    Sleep  1
#   Fuel
    Element Should Be Disabled  //*[@id="contractfees"]/div[1]/div[3]/div[2]/input
#   Fees > Fuel+Cash
    Element Should Be Disabled  //*[@id="contractfees"]/div[1]/div[4]/div[2]/input
#   Fees > Cash
    Element Should Be Disabled  //*[@id="contractfees"]/div[1]/div[6]/div[2]/input
#   Fees > Out of Area
    Element Should Be Disabled  //*[@id="contractfees"]/div[1]/div[7]/div/div[2]/input
#   Fees > Check
    Element Should Be Disabled  //*[@id="contractfees"]/div[1]/div[9]/div/div[2]/input
#   Fees > ATM
    Element Should Be Disabled  //*[@id="contractfees"]/div[1]/div[10]/div/div[2]/input
#   Options > Checks/Fee
    Element Should Be Disabled  //*[@id="contractfees"]/div[2]/div[3]/div[2]/input
#   Options > Int Rate
    Element Should Be Disabled  //*[@id="contractfees"]/div[2]/div[4]/div[2]/input
#   Min Bank > Fee
    Element Should Be Disabled  //*[@id="contractfees"]/div[3]/div/div[3]/div[2]/input
#   Min Bank > Amt
    Element Should Be Disabled  //*[@id="contractfees"]/div[3]/div/div[5]/div[2]/input

Confirm Payments Fields Are Disabled
    Click On  //*[@id="creditForm"]/div[1]/div[3]/ul/li[4]/div/span[2]
    Sleep  1
#   Payment Setup > Payment Method
    Element Should Be Disabled  //*[@id="pmtMethod"]
#   Payment Setup > Receiving Bank(ACH)
    Element Should Be Disabled  //*[@id="abc" and @value="0011512163"]
#   Payment Setup > Payment App Method
    Element Should Be Disabled  //*[@id="abc" and @value="INVOICE MATCH"]
#   Payment Setup > Lockbox Acct
    Element Should Be Disabled  //*[@id="abc" and @value="I2"]
#   On-Line Pay > Min Amt
    Element Should Be Disabled  //*[@id="achMinAmt"]
#   On-Line Pay > Max Amt
    Element Should Be Disabled  //*[@id="achMaxAmt"]
#   On-Line Pay > Velocity
    Element Should Be Disabled  //*[@id="achVelocity"]
#   On-Line Pay > Fee
    Element Should Be Disabled  //*[@id="phoneChkFee"]
#   Payment Credit Hold
    Element Should Be Disabled  //*[@id="paymentCreditHold_contract"]

Confirm Recourse Codes Fields Are Disabled
    Click On  //*[@id="creditForm"]/div[1]/div[3]/ul/li[5]/div/span
    Sleep  1
#   Add buttom
    Page Should Contain Element  //*[@id="contractrecourse"]/fieldset/a[1][@class="jbtn disabled"]
#   Edit button
    Page Should Contain Element  //*[@id="contractrecourse"]/fieldset/a[2][1][@class="jbtn disabled"]
#   Delete button
    Page Should Contain Element  //*[@id="contractrecourse"]/fieldset/a[3][1][@class="jbtn disabled"]

Check Return Button
#   Tools > Comments link
    Click On  //*[@id="commandMenu"]/div[1]/span[1]
    Sleep  1
#   Close button
    Click On  //*[@id="comments_content"]/a[3]
#   Coments button
    Click On  //*[@id="contractview"]/a[4]/div/span[1]
    Sleep  1
#   Close button
    Click On  //*[@id="comments_content"]/a[3]
#   Refresh button
    Click On  //*[@id="contractview"]/a[3]/div/span[1]
    Sleep  1
#   No button
    Click On  //*[@id="refreshConfirm_content"]/div[2]/a[2]/div/span[1]
    Sleep  1
#   Return button
    Click On  //*[@id="contractview"]/a[1]/div/span[1]
    Sleep  1
#   Yes button
    Click On  //*[@id="returnConfirm_content"]/div[2]/a[1]/div/span[1]
#   Search for contract again
    Search Contract
    Wait Until Done Processing  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[2]/td[3]/div[contains(class(),'jtd')]
#   Row 1 of search results
    Double Click On  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr
#    Select Contract
    Wait Until Page Contains  Contract Information

Search Contract
    wait until element is enabled  request.search.contractId  timeout=120
    input text  request.search.contractId  ${contractID}
    wait until element is enabled  request.search.carrierId  timeout=120
    input text  request.search.carrierId  ${carrierID}
    click portal button  Search

Select Contract
    wait until done processing
    wait until page contains element  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is visible  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is enabled  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is enabled  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]  timeout=120
    double click element  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]