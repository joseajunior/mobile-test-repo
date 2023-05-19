*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH   ${app_ssh_host}
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  DateTime
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

Suite Setup  Add Permissions And Setup Data
Test Setup    Open Account Manager
Suite Teardown  Run Keywords    Remove Permissions and Close Browser    Disconnect From Database
Test Teardown    Close Browser

*** Variables ***
${efstester_email}    efswex-efs.testers@wexinc.com

*** Test Cases ***
Cancel A Scheduled Check Void Up Through The 30th Day
    [Tags]  JIRA:ATLAS-2099  JIRA:ATLAS-2175  qTest:116748310  PI:14
    [Documentation]  Confirm new primary tab 'Pending Check Void' is fully functional.

    Select Pending Check Voids Tab
    Test Submit Without Business Partner
    Set Business Partner
    Test Submit With Business Partner Only
    Search Using Check #
    Check EXPORT button
    Search Using Moneycode
    Search Using Create Date
    Search Using Scheduled Void Date
    Search Using Payee
    Search Using Amount
    Search Using Requested By
    Search Using Check Void Email
#    Search Using Reason Voided                 TODO: Can be enabled when ATLAS-2223 is completed
    Abort Cancel A Check Void Within 30 Days
    Cancel A Check Void Within 30 Days

    [Teardown]    Run Keywords    Close Browser    Teardown for cancel pending check void

Date edit update from email update in pending check void
    [Tags]    JIRA:BOT-5041   JIRA:ATLAS-2301    qTest:118907008    PI:15
    [Documentation]  Ensure date is correctly updated when updating the pending check void email from AM detail screen
    [Setup]    Run Keywords    Get schedule date    Open Account Manager

    Select Pending Check Voids Tab
    Set Business Partner
    Search Using Check Number
    Open pending check void detail screen
    Edit check email
    Check schedule date remains the same
    Check last updated date updated

Date update from cancel pending check void
    [Tags]    JIRA:BOT-5041    JIRA:ATLAS-2301    qTest:118907011    PI:15
    [Documentation]  Ensure cancel date and cancel by is correctly updated when cancelling pending check void
    [Setup]    Run Keywords    Setup pending check void to cancel    Get void user    Open Account Manager

    Select Pending Check Voids Tab
    Set Business Partner
    Search Using Check Number
    Cancel pending check void
    Check scheduled void canceled date updated
    Check scheduled void canceled by updated
    Check void user remains the same

    [Teardown]    Run Keywords    Close Browser    Teardown for cancel pending check void

*** Keywords ***
Abort Cancel A Check Void Within 30 Days
    Click Reset Button
    Input Text  //*/th[2]/input[@name="checkId"]  ${checkNumber}
    Click Submit Button
    Wait Until Element Contains  //*/tr[1]/td/button[contains(text(), '${checkNumber}')]  ${checkNumber}
    Click On  //*[@id="cancelBtn"]
    Click Button  Cancel
    Wait Until Loading Spinners Are Gone

Add Permissions And Setup Data
    Add User Role If Not Exists  ${intern}  AM_PENDINGCHECKVOID_SEARCH
    Add User Role If Not Exists  ${intern}  AM_PENDINGCHECKVOID_DETAIL
    Add User Role If Not Exists  ${intern}  AM_PENDINGCHECKVOID_EDIT
    Add User Role If Not Exists  ${intern}  AM_PENDINGCHECKVOID_CANCEL
    Setup Data For Pending Check Void

Cancel A Check Void Within 30 Days
    Setup pending check void to cancel
    Set Business Partner
    Search Using Check Number
    Click Reset Button
    Input Text  //*/th[2]/input[@name="checkId"]  ${checkNumber}
    Click Submit Button
    Wait Until Element Contains  //*/tr[1]/td/button[contains(text(), '${checkNumber}')]  ${checkNumber}
    Click On  //*[@id="cancelBtn"]
    Click Button  //*[@id="submitCancel"]
    Wait Until Element Is Visible  //*/th[2]/input[@name="checkId"]

Check EXPORT button
    Click Element  //*[@id='pendingCheckVoidSearchContainer']//span[contains(text(), 'EXPORT')]
    Wait Until Page Contains  Export in Progress,please wait.
    Wait Until Page Does Not Contain  Export in Progress,please wait.

Click Reset Button
    Click Button  //*[@id="pendingCheckVoidSearchContainer"]//button[@class="button resetButton"]
    Wait Until Page Contains Element  //*/th[1]/select

Click Submit Button
    click element  //*[@id="pendingCheckVoidSearchContainer"]//button[@class="button searchSubmit"]

Remove Permissions and Close Browser
    Remove Carrier User Permission  ${intern}  AM_PENDINGCHECKVOID_SEARCH
    Remove Carrier User Permission  ${intern}  AM_PENDINGCHECKVOID_DETAIL
    Remove Carrier User Permission  ${intern}  AM_PENDINGCHECKVOID_EDIT
    Remove Carrier User Permission  ${intern}  AM_PENDINGCHECKVOID_CANCEL
    Close Browser

Search Using Amount
    Input Text  //*/th[7]/input[@name="amount"]  ${amount}
    Click Submit Button
    Wait Until Element Contains  //*/td[contains(text(), '${amount}')]  ${amount}
    Wait Until Loading Spinners Are Gone
    Page Should Contain  ${checkNumber}
    Clear Element Text  //*/th[7]/input[@name="amount"]

Search Using Check #
    Input Text  //*/th[2]/input[@name="checkId"]  ${checkNumber}
    Click Submit Button
    Wait Until Element Contains  //*/tr[1]/td/button[contains(text(), '${checkNumber}')]  ${checkNumber}
    Wait Until Loading Spinners Are Gone
    Page Should Contain  ${amount}
    Clear Element Text  //*/th[2]/input[@name="checkId"]


Search Using Check Void Email
   Input Text  //*/th[9]/input[@name="checkVoidEmail"]  ${email}
   Click Submit Button
   Wait Until Element Contains  //*/td[contains(text(), '${email}')]  ${email}
   Wait Until Loading Spinners Are Gone
   Page Should Contain  ${checkNumber}
   Clear Element Text  //*/th[9]/input[@name="checkVoidEmail"]

Search Using Create Date
    Input Text  //*/th[4]/input[@name="createDate"]  ${createDate}
    Click Submit Button
    Wait Until Element Contains  //*/tr[1]/td/button[contains(text(), '${checkNumber}')]  ${checkNumber}
    Wait Until Loading Spinners Are Gone
    Page Should Contain  ${checkNumber}
    Clear Element Text  //*/th[4]/input[@name="createDate"]

Search Using Moneycode
    IF  ${moneyCode} != ${NULL}
        Input Text  //*/th[3]/input[@name="moneyCode"]  ${moneyCode}
        Click Submit Button
        Wait Until Element Contains  //*/tr[1]/td[3]/button[contains(text(), '${moneyCode}')]  ${moneyCode}
        Wait Until Loading Spinners Are Gone
        Page Should Contain  ${checkNumber}
        Clear Element Text  //*/th[3]/input[@name="moneyCode"]
    ELSE
        return from keyword
    END

Search Using Payee
   Input Text  //*/th[6]/input[@name="payee"]  ${payee}
   Click Submit Button
   Wait Until Element Contains  //*/td[contains(text(), '${payee}')]  ${payee}
   Wait Until Loading Spinners Are Gone
   Page Should Contain  ${checkNumber}
   Clear Element Text  //*/th[6]/input[@name="payee"]

Search Using Reason Voided
    Input Text  //*[@class="dataTables_scrollHeadInner"]//input[@name="voidedReason"]  ${reason}
    Click Element  //*[@id="pendingCheckVoidSearchContainer"]//button[@class="button searchSubmit"]
    Wait Until Element Contains  //*/td[contains(text(), '${reason}')]  ${reason}
    Wait Until Loading Spinners Are Gone
    Page Should Contain  ${checkNumber}
    Clear Element Text  //*[@class="dataTables_scrollHeadInner"]//input[@name="voidedReason"]

Search Using Requested By
    Input Text  //*/th[8]/input[@name="requestedBy"]  ${requestedBy}
    Click Submit Button
    Wait Until Element Contains  //*/td[contains(text(), '${requestedBy}')]  ${requestedBy}
    Wait Until Loading Spinners Are Gone
    Page Should Contain  ${checkNumber}
    Clear Element Text  //*/th[8]/input[@name="requestedBy"]

Search Using Scheduled Void Date
    Input Text  //*/th[5]/input[@name="scheduledVoidDate"]  ${scheduledVoidDate}
    Click Submit Button
    Wait Until Element Contains  //*/td[contains(text(), '${scheduledVoidDate}')]  ${scheduledVoidDate}
    Wait Until Loading Spinners Are Gone
    Page Should Contain  ${checkNumber}
    Clear Element Text  //*/th[5]/input[@name="scheduledVoidDate"]

Select Pending Check Voids Tab
    Click On  //*[@id="PendingCheckVoid"]/span
    Wait Until Load Screen Icon Disappear From Screen

Set Business Partner
    Select From List By Value  //*[@class="dataTables_scrollHeadInner"]//select[contains(@class, 'pendingCheckVoidBusinessPartnerSelect')]  EFS

Setup Data For Pending Check Void
    get into db  TCH
    ${query}  Catenate
    ...  SELECT FIRST 1 c.check_num AS check_num,
    ...  mc.express_code AS money_code,
    ...  mc.carrier_id as carrier_id,
    ...  c.create_date AS create_date,
    ...  cv.schedule_date AS scheduled_void_date,
    ...  TRIM(c.payee) AS payee,
    ...  c.amount AS amount,
    ...  cv.void_user AS requested_by,
    ...  cv.check_void_email as email,
    ...  c.voided_reason AS reason
    ...  FROM checks c
    ...  INNER JOIN check_void cv on cv.check_num = c.check_num
    ...  LEFT JOIN code_use co ON c.check_num = co.check_num
    ...  LEFT JOIN mon_codes mc ON co.code_id = mc.code_id
    ...  WHERE c.voided = 'P';
    ${checkVoidData}  Query And Strip To Dictionary  ${query}
    Disconnect From Database
    Set Suite Variable  ${checkNumber}  ${checkVoidData["check_num"]}
    Set Suite Variable  ${moneyCode}  ${checkVoidData["money_code"]}
    ${createDate}  Convert Date  ${checkVoidData["create_date"]}  result_format=%Y-%m-%d
    Set Suite Variable  ${createDate}
    Set Suite Variable  ${scheduledVoidDate}  ${checkVoidData["scheduled_void_date"]}
    Set Suite Variable  ${payee}  ${checkVoidData["payee"]}
    Set Suite Variable  ${amount}  ${checkVoidData["amount"]}
    Set Suite Variable  ${requestedBy}  ${checkVoidData["requested_by"]}
    Set Suite Variable  ${email}  ${checkVoidData["email"]}
    Set Suite Variable  ${reason}  ${checkVoidData["reason"]}

Test Submit With Business Partner Only
    Click Submit Button
    Wait Until Element Is Visible   //*[@id="pendingCheckVoidMessages"]/ul[3]/li
    Wait Until Element Is Not Visible  //*[@id="pendingCheckVoidMessages"]/ul[3]/li

Test Submit Without Business Partner
    Click Submit Button
    Wait Until Element Contains  //*[@id="pendingCheckVoidMessages"]//li  Business Partner is required.
    Wait Until Element Does Not Contain  //*[@id="pendingCheckVoidMessages"]/ul[3]  Business Partner is required.

Wait Until Load Screen Icon Disappear From Screen
    Run Keyword And Ignore Error  Wait Until Element Is Visible  //*[@class="loading-img"]  timeout=10
    Wait Until Element Is Not Visible    //*[@class="loading-img"]  timeout=10

Get info from check void table
    [Arguments]    ${column}
    Get into DB    TCH
    ${query}    Catenate    SELECT ${column}
    ...    FROM check_void
    ...    WHERE check_num = '${checkNumber}';
    ${data}    Query And Strip    ${query}
    [Return]    ${data}

Get schedule date
    ${schedule_date}    Get info from check void table    schedule_date
    Set Test Variable    ${schedule_date}

Get void user
    ${void_user}    Get info from check void table    void_user
    Set Test Variable    ${void_user}

Search Using Check Number
    Input Text  //*/th[2]/input[@name="checkId"]  ${checkNumber}
    Click Submit Button
    Wait Until Element Contains  //*/tr[1]/td/button[contains(text(), '${checkNumber}')]  ${checkNumber}
    Wait Until Loading Spinners Are Gone

Open pending check void detail screen
    Wait Until Page Contains Element    //*/tr[1]/td/button[contains(text(), '${checkNumber}')]
    Click Element  //*/tr[1]/td/button[contains(text(), '${checkNumber}')]
    Wait Until Page Contains Element    //*[@id="detailTitleLabel" and text()="Pending Check Void"]

Edit check email
    Wait Until Element is Visible    name=detailRecord.checkVoidEmail
    Input Text    name=detailRecord.checkVoidEmail    ${efstester_email}
    Click Element    id=submit
    Wait Until Element is Visible    //*[@id="pendingCheckVoidMessages"]/ul[@class="msgSuccess"]

Check info in check void table
    [Arguments]    ${column}    ${exp_data}
    ${data}    Get info from check void table    ${column}
    Should Be Equal as Strings    ${exp_data}    ${data}

Check schedule date remains the same
    Check info in check void table    schedule_date    ${schedule_date}

Check void user remains the same
    Check info in check void table    void_user    ${void_user}

Check last updated date updated
    ${currdate}    Get Current Date    result_format=%Y-%m-%d
    Check info in check void table    last_updated    ${currdate}

Check email updated
    Check info in check void table    check_void_email    ${efstester_email}

Setup pending check void to cancel
    Get into DB    TCH
    ${query}    Catenate    SELECT c.check_num FROM checks c INNER JOIN check_void cv ON cv.check_num = c.check_num
    ...    WHERE voided = 'Y' ORDER BY create_date DESC LIMIT 100;
    ${checkNumber}    Query And Strip To Dictionary     ${query}
    ${checkNumber}  Evaluate  random.choice(${checkNumber['check_num']})  random
    Set Test Variable  ${checkNumber}
    ${query}    Catenate    UPDATE checks SET voided = 'P' WHERE check_num = '${checkNumber}';
    Execute SQL String    ${query}

Cancel pending check void
    Wait Until Element Contains  //*/tr[1]/td/button[contains(text(), '${checkNumber}')]  ${checkNumber}
    Click On  //*[@id="cancelBtn"]
    Click Button  //*[@id="submitCancel"]
    Wait Until Page Contains    The pending check void was successfully cancelled

Check scheduled void canceled date updated
    ${currdate}    Get Current Date    	result_format=%Y-%m-%d
    Check info in check void table    scheduled_void_canceled    ${currdate}

Check scheduled void canceled by updated
    Check info in check void table    scheduled_void_canceled_by    ${intern}

Teardown for cancel pending check void
    Get into DB    TCH
    ${query}    Catenate    UPDATE checks SET voided = 'Y' WHERE check_num = '${checkNumber}';
    Execute SQL String    ${query}