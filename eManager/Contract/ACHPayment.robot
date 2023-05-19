*** Settings ***
Library  OperatingSystem  WITH NAME  os
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags      eManager  ACH Payment  Contract
Suite Setup     ACH Payment Setup
Suite Teardown  End Suite

*** Variables ***
${carrier}
${invoice}
${comment}
${contract_id}
${ar_number}
${ach_max_amt}
${ach_min_amt}
${user_id_list}

*** Test Cases ***
ACH Payment - Payment not Allowed on Contract
    [Tags]  JIRA:BOT-506  qTest:28861784  Regression  JIRA:BOT-2006  refactor    #ACH payment is not working on AWS-DIT
    [Documentation]  Not Possible to submit ACH transfer when cont_misc.ach_allowed = 'N'
    [Setup]  Set Contract ACH Flag to "N"

    Log Into eManager With Your Carrier
    Navigate to Select Program > Credit Management > ACH Payment
    Verify AR Number Not Available On Options

    [Teardown]  Finish Test

ACH Payment - Validate Maximum ACH Payment
    [Tags]  JIRA:BOT-506  JIRA:BOT-2006  refactor    #ACH payment is not working on AWS-DIT
    [Documentation]  Maximum ACH Payment Should be Smaller Than ach_trans.ach_max_amt.
    [Setup]  Set Contract ACH Flag to "Y"

    Log Into eManager With Your Carrier
    Navigate to Select Program > Credit Management > ACH Payment
    Select AR Number For Contract
    Get Over Maximum Amount
    Fullfil Necessary Data and Click on Save Button  ${amount}  ${invoice}  ${comment}
    You Should See an Error for The Maximum ACH amount

    [Teardown]  Finish Test

ACH Payment - Validate Minimum ACH Payment
    [Tags]  JIRA:BOT-506  JIRA:BOT-2006  refactor    #ACH payment is not working on AWS-DIT
    [Documentation]  Minimum ACH Payment Should be Greater Than ach_trans.ach_min_amt.
    [Setup]  Set Contract ACH Flag to "Y"

    Log Into eManager With Your Carrier
    Navigate to Select Program > Credit Management > ACH Payment
    Select AR Number For Contract
    Get Under Minimum Amount
    Fullfil Necessary Data and Click on Save Button  ${amount.__str__()}  ${invoice}  ${comment}
    You Should See an Error for The Minimum ACH amount

    [Teardown]  Finish Test

ACH Payment - Validate mandatory field, match emails and complete the ACH submission
    [Tags]  JIRA:BOT-506  qTest:28861786  Regression  JIRA:BOT-2006  refactor    #ACH payment is not working on AWS-DIT
    [Documentation]  Validate mandatory field, match emails and complete the ACH submission.
    [Setup]  Set Contract ACH Flag to "Y"

    Log Into eManager With Your Carrier
    Navigate to Select Program > Credit Management > ACH Payment
    Select AR Number For Contract
    Click on Save Button
    You Should see Errors for Amount Is Required And The Minimum ACH Amount
    Get Acceptable Amount
    Fullfil Necessary Data and Click on Save Button  ${amount.__str__()}  ${invoice}  ${comment}  ${email}  ${email}1
    You Should See An Error For Email Does Not Match
    Input Right E-mail and Click on Save Button  ${email}
    Sucessfull Payment Message
    Validate On DB

    [Teardown]  Finish Test

ACH Payment - Make A Payment Without Comment And Export Using The Three Options
    [Tags]  JIRA:BOT-1151  qTest:28861785  qTest:28861787  qTest:28861788  qTest:28861789  Regression  refactor    #This one needs that file management works on face robot.
    [Setup]  Set Contract ACH Flag to "Y"

    Log Into eManager With Your Carrier
    Navigate to Select Program > Credit Management > ACH Payment
    Select AR Number For Contract
    Fullfil Necessary Data and Click on Save Button  3
    Sucessfull Payment Message
    Export CSV Report
    Export Excel Report
    Export PDF Report
    Verify If Files Exists And Delete  csv
    Verify If Files Exists And Delete  xls
    Verify If Files Exists And Delete  pdf

    [Teardown]  Close Browser

*** Keywords ***
Log Into eManager With Your Carrier
    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Credit Management > ACH Payment
    Mouse Over  id=menubar_1x2
    Mouse Over  xpath=//td[@class="nlsitem" and text()="Credit Management"]
    Click Element  xpath=//td[@class="nlsitem" and text()="ACH Payments"]

Select AR Number For Contract
    Select From List by Value  arnumber  ${ar_number}

Click on Save Button
    Click Element  saveButton

Verify AR Number Not Available On Options
    Element Should Not Be Visible  //option[@value='${ar_number}']

Fullfil Necessary Data and Click on Save Button
    [Arguments]  ${amount}  ${invoice}=${EMPTY}  ${comment}=${EMPTY}  ${email}=${EMPTY}  ${confirm_email}=${EMPTY}
    Input Text  amount  ${amount}
    Input Text  statement  ${invoice}
    Input Text  comments  ${comment}
    Input Text  email  ${email}
    Input Text  confirmEmail  ${confirm_email}
    Click Element  saveButton

You should see a Message of Payment not Allowed for this Contract.
    Element Should Contain  //div[@class='errors']//li  ACH Payment is currently not allowed. Please contact your Credit Manager.

Input Right E-mail and Click on Save Button
    [Arguments]  ${email}
    Input Text  confirmEmail  ${email}
    Click Element  saveButton

End Suite
    Set Contract ACH Flag to "Y"
    #Close All Browsers

Create Invoice Number
    [Documentation]  Returns a random number as the invoice. If the transaction is
    ...  an IMPERIAL or HUSKY transaction then the Test Case should truncate the
    ...  returned value to 4 digits.

    ${invoice}=  evaluate  random.randint(100000, 99999999)  random

    [Return]  ${invoice.__str__()}

Get Over Maximum Amount
    ${amount}  Evaluate  ${ach_max_amt} + 1
    Set Test Variable  ${amount}

Get Under Minimum Amount
    ${amount}  Evaluate  ${ach_min_amt} - 0.1
    Set Test Variable  ${amount}

Get Acceptable Amount
    ${amount}  Evaluate  ${ach_min_amt} + 1
    Set Test Variable  ${amount}

Export CSV Report
    Click Element    //*[@class="export csv"]
    # Time to save the file
    Sleep  3s

Export Excel Report
    Click Element    //*[@class="export excel"]
    # Time to save the file
    Sleep  3s

Export PDF Report
    Click Element    //*[@class="export pdf"]
    # Time to save the file
    Sleep  3s

Verify If Files Exists And Delete
    [Arguments]  ${extension}
    os.file should exist  ${default_download_path}${/}*aCHPaymentInfo*.${extension}
    os.Remove File  ${default_download_path}${/}*aCHPaymentInfo*.${extension}

ACH Payment Setup
    [Documentation]  Keyword to setup suite

    Get user_id From the Last "100" Logged to Avoid MySQL error.
    Get Carrier For Suite Execution
    Get Contract Info for Suite Execution
    Ensure Carrier has User Permission  ${carrier.id}  ACH_PAYMENTS

    #Set Variables
    Set Suite Variable  ${comment}  BOT-506 ACH Payment
    Set Suite Variable  ${email}  efs.testers@efsllc.com
    ${invoice}  Create Invoice Number
    Set Suite Variable  ${invoice}

Get user_id From the Last "${value}" Logged to Avoid MySQL error.
    [Documentation]  Keyword to get a list of carriers that already logged into MySQL

    Get Into DB  Mysql
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT ${value};
    ${list}  Query And Strip To Dictionary  ${query}
    ${user_id_list}  Get From Dictionary  ${list}  user_id
    ${user_id_list}  Evaluate  ${user_id_list}.__str__().replace('[','(').replace(']',')')

    Set Suite Variable  ${user_id_list}

Get Carrier For Suite Execution
    [Documentation]  Keyword to Get a Carrier for Suite Execution
#
    ${query}  Catenate  SELECT m.member_id FROM member m
    ...  JOIN contract c ON m.member_id = c.carrier_id
    ...  JOIN cont_misc cm ON (c.contract_id = cm.contract_id)
    ...  WHERE c.status= 'A'
    ...  AND EXISTS (SELECT 1 FROM contract WHERE carrier_id = m.member_id and issuer_id = 105757)
    ...  AND m.status = 'A'
    ...  AND cm.ach_allowed = 'Y'
    ...  AND m.member_id IN ${user_id_list}
    ...  AND m.member_id NOT IN ('303327')
    ...  GROUP BY m.member_id
    ...  HAVING count(m.member_id) > 1;

    ${carrier}  Find Carrier Variable  ${query}  member_id

    Set Suite Variable  ${carrier}

Get Contract Info for Suite Execution
    [Documentation]  Keyword to Get a Contract info for Suite Execution

    Get Into DB  TCH
    ${query}  Catenate  SELECT c.contract_id,
    ...  c.contract_id,
    ...  c.ar_number,
    ...  cm.ach_max_amt,
    ...  cm.ach_min_amt
    ...  FROM contract c
    ...  INNER JOIN cont_misc cm ON (c.contract_id = cm.contract_id)
    ...  AND c.issuer_id IN ('105757')
    ...  AND cm.ach_allowed = 'Y'
    ...  AND c.carrier_id='${carrier.id}' LIMIT 1;

    ${achAllowed}  Query And Strip To Dictionary  ${query}

    Set Suite Variable  ${contract_id}  ${achAllowed['contract_id']}
    Set Suite Variable  ${ar_number}  ${achAllowed['ar_number'].strip()}
    Set Suite Variable  ${ach_max_amt}  ${achAllowed['ach_max_amt']}
    Set Suite Variable  ${ach_min_amt}  ${achAllowed['ach_min_amt']}

Set Contract ACH Flag to "${value}"
    Get Into DB  TCH
    Execute SQL String  dml=UPDATE cont_misc SET ach_allowed='${value}' WHERE contract_id='${contract_id}';

# Validation Keywords
You Should See an Error for The Maximum ACH amount
    Element Should Contain  //div[@class='errors']//li  The maximum ACH amount allowed is $ ${ach_max_amt}.0

You Should See an Error for The Minimum ACH amount
    Element Should Contain  //div[@class='errors']//li  The minimum ACH payment must be greater than $ ${ach_min_amt}.0

You Should see Errors for Amount Is Required And The Minimum ACH Amount
    Element Should Contain  //div[@class='errors']//li[1]  Amount: is a required field
    Element Should Contain  //div[@class='errors']//li[2]  The minimum ACH payment must be greater than $ ${ach_min_amt}.0

You Should See An Error For Email Does Not Match
    Element Should Contain  //div[@class='errors']//li  Confirm E-mail Address: is not match

Sucessfull Payment Message
    Element Should Contain  //*[@class="messages"]  You have successfully created the ACH Payment.

Validate On DB
    Get Into DB  TCH
    Wait Until Element Is Visible  //table[@id='row']//td[count(//a[text()='Statement/Invoice Number']) and text()="${invoice}"]/parent::tr/td[1]  timeout=20
    ${transactionId}  Get Text  //table[@id='row']//td[count(//a[text()='Statement/Invoice Number']) and text()="${invoice}"]/parent::tr/td[1]
    Row Count Is Equal To X  SELECT * FROM ach_trans WHERE ach_trans_id='${transactionId}'  1

Finish Test
    Close Browser
    Run Keyword If  ${permission_status}=='${true}'  Remove Carrier User Permission  ${member}  ACH_PAYMENTS