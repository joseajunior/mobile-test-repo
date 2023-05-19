*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyString
Library  Collections
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags  eManager

*** Variables ***

*** Test Cases ***

Make Online Payment - Required Comment Error Message
    [Tags]  JIRA:BOT-918  JIRA:BOT-1733  qTest:31547190  depricated  BUGGED:Need Statements on DEVACPT to validate test.
    [Documentation]  Authorize Online Payment and Validate Errors on Screen need to undepricate when data setup is right

#Set Environment For Emanager
#    Set Robot Environment  devacpt

#Open eManager and go to Online Payments
    Open Browser to eManager
    Log into eManager  700075  YDHHO0
    Mouse Over  id=menubar_1x2
    Mouse Over  xpath=//td[@class="nlsitem" and text()="Credit Management"]
    Click Element  xpath=//td[@class="nlsitem" and text()="Online Payments"]

#Select a Bank Account
    Wait Until Element is Visible  bankAccount
    Select From List By Label  bankAccount  WELLS FARGO BANK NA ending in 3456

#Select one Statement for Payment and Check if an Error Appear
    Select Checkbox  //table[@id='statements']//tbody//tr[1]//input[@type='checkbox']
    Click Element  doSubmit

    ${error}  Get Text  //*[@class="error"]
    Should Be Equal  ${error}  A comment is required when the payment amount does not match the Total Open Amount.

#Select all Statements, *Required Must Not Be Visible and No Error Must Appear.
    Select Checkbox  all_cb
    Element Should Not Be Visible  //span[@id='commentReq']

    Click Element  doSubmit
    Click Element  //div[@class='ui-dialog-buttonset']//*[contains(text(), 'Cancel')]
    Element Should Not Be Visible  //*[@class="error"]

    [Teardown]  Close Browser

Make a payment for $0.00
    [Tags]  JIRA:BOT-1140  qTest:29146873  Regression  refactor

    Set Test Variable  ${error_message}  You need to submit a payment larger than $1

    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${carrier}  103866

    Get Into DB  ${DB}
    ${ACHQuery}  catenate  SELECT c.ar_number, c.issuer_id
    ...     FROM cont_misc cm, contract c WHERE c.carrier_id=${carrier} AND cm.contract_id=c.contract_id limit 1;
    ${PaymentResults}  Query And Strip To Dictionary  ${ACHQuery}
   ${PaymentResults['issuer_id']}  Convert To String  ${PaymentResults['issuer_id']}

    Open Browser to eManager

    Log into eManager  ${validCard.carrier.member_id}  ${validCard.carrier.password}
    Hover Over  text=Select Program
    Hover Over  text=Credit Management
    Hover Over  text=Online Payments
    Click On  text=Online Payments
#   WEIRD THING WAS HAPPENING, SCREEN WASN'T LOADING PROPERLY SO I USED A RELOAD PAGE KEYWORD AS A WORKAROUND
    Reload Page
    Wait Until Element Is Visible  commentId  timeout=10
    Select From List By Value  //*[@name="issuer" and @id="issuer"]  ${PaymentResults['issuer_id']}
    Wait Until Page Contains Element  //*[@name="bankAccount" and @id="bankAccount"]  timeout=20
    Click On  //*[@id="bankAccount"]/option[2]
    Wait Until Element Is Visible  otherAmount  timeout=10
    Execute Javascript  document.getElementById("otherAmount").value=0.00
    Input Text  commentId  MakePaymentComment
    Click Button  doSubmit
    Wait Until Page Contains Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]  timeout=20
    Click Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]
    Sleep  2
    ${error}  Get Text  //*[@class="pmtError rowPmtError" and @title="You need to submit a payment larger than $1"]//parent::*
    Tch Logging  \n ERROR:"${error}"
    Should Be Equal As Strings  ${error}  ${error_message}
    [Teardown]  Close Browser

Make a payment for above the Max amount allowed
    [Tags]  JIRA:BOT-1142  qTest:29154105  Regression  refactor

    Set Test Variable  ${error_message}  Please enter a number less than or equal to the maximum allowed amount of 500

    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${carrier}  103866

    Get Into DB  ${DB}
    ${ACHQuery}  catenate  SELECT ach_max_amt, c.issuer_id
    ...     FROM cont_misc cm, contract c WHERE c.carrier_id=${carrier} AND cm.contract_id=c.contract_id limit 1;
    ${PaymentResults}  Query And Strip To Dictionary  ${ACHQuery}
   ${PaymentResults['issuer_id']}  Convert To String  ${PaymentResults['issuer_id']}

    Open Browser to eManager
    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Hover Over  text=Select Program
    Hover Over  text=Credit Management
    Hover Over  text=Online Payments
    Click On  text=Online Payments
#   WEIRD THING WAS HAPPENING, SCREEN WASN'T LOADING PROPERLY SO I USED A RELOAD PAGE KEYWORD AS A WORKAROUND
    Reload Page
    Wait Until Element Is Visible  commentId  timeout=10
    Select From List By Value  //*[@name="issuer" and @id="issuer"]  ${PaymentResults['issuer_id']}
    Select From List By Value  //*[@name="arNumber" and @id="arNumber"]  0006219830048
    Wait Until Page Contains Element  //*[@name="bankAccount" and @id="bankAccount"]  timeout=20
    Click On  //*[@id="bankAccount"]/option[2]
    Input Text  commentId  MakePaymentComment
    ${PaymentResults['ach_max_amt']}  Convert To Integer  ${PaymentResults['ach_max_amt']}
    ${MaxAmount}  Evaluate  ${PaymentResults['ach_max_amt']}+200.55
    Wait Until Element Is Visible  otherAmount  timeout=10
    Execute Javascript  document.getElementById("otherAmount").value=${MaxAmount}
    Click Button  doSubmit
    Sleep  2
    Wait Until Element Is Visible  //*[@class="error"]  timeout=30
    ${error}  Get Text  //*[@class="error"]
    Tch Logging  \n ERROR:"${error}"
    Should Be Equal As Strings  ${error}  ${error_message}

    [Teardown]  Close Browser

Make a Payment For an Amount Below The Minimum Amount
    [Tags]  JIR:BOT-1141  qTest:29157702  Regression  refactor



    Set Test Variable  ${error_message}  You need to submit a payment larger than $1
    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${carrier}  103866

    Get Into DB  ${DB}
    ${ACHQuery}  catenate  SELECT cm.ach_min_amt, c.issuer_id
    ...     FROM cont_misc cm, contract c WHERE c.carrier_id=${carrier} AND cm.contract_id=c.contract_id limit 1;
    ${PaymentResults}  Query And Strip To Dictionary  ${ACHQuery}
   ${PaymentResults['issuer_id']}  Convert To String  ${PaymentResults['issuer_id']}

    Open Browser to eManager
    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Hover Over  text=Select Program
    Hover Over  text=Credit Management
    Hover Over  text=Online Payments
    Click On  text=Online Payments
#   WEIRD THING WAS HAPPENING, SCREEN WASN'T LOADING PROPERLY SO I USED A RELOAD PAGE KEYWORD AS A WORKAROUND
    Reload Page
    Wait Until Element Is Visible  commentId  timeout=10
    Select From List By Value  //*[@name="issuer" and @id="issuer"]  ${PaymentResults['issuer_id']}
    Select From List By Value  //*[@name="arNumber" and @id="arNumber"]  0006219830048
    Wait Until Page Contains Element  //*[@name="bankAccount" and @id="bankAccount"]  timeout=20
    Click On  //*[@id="bankAccount"]/option[2]
    Wait Until Element Is Visible  otherAmount  timeout=10
    Input Text  commentId  MakePaymentComment
    ${PaymentResults['ach_min_amt']}  Convert To Integer  ${PaymentResults['ach_min_amt']}
    ${MinAmount}  Evaluate  ${PaymentResults['ach_min_amt']}-0.05
    Execute Javascript  document.getElementById("otherAmount").value=${MinAmount}

    Click Button  doSubmit
    Wait Until Element Is Visible  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]  timeout=30
    Click Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]
    Sleep  2
    Wait Until Element Is Visible  //*[@class="pmtError rowPmtError" and @title="You need to submit a payment larger than $1"]  timeout=10
    Wait Until Element Is Visible  //*[@id="payment_status"]/p  timeout=10
    ${error}  Get Text  //*[@id="payment_status"]/p
    Tch Logging  \n ERROR:"${error}"
    Should Be Equal As Strings  ${error}  ${error_message}

    [Teardown]  Close Browser

Make Payments Until It Hits The Velocity
    [Tags]  JIRA:BOT-1138  qTest:29158745  Regression  qTest:29158783  JIRA:BOT-1144  JIRA:BOT-1145  JIRA:BOT-1148  BUGGED: it's picking up the previous payments and holding it accountable



    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${carrier}  ${validCard.carrier.member_id}
    Set Test Variable  ${error_message}  You have exceeded your ACH velocity limit.
    Set Test Variable  ${success_msg}  Payment Status: A payment of 10.00 was successfully submitted.

    Get Into DB  ${DB}

#    STORAGING OLD VALUES TO PUT IN BACK ON THE TEARDOWN
    Tch Logging  \n -Storaging the ach_(allowed and velocity) original values
    ${old_data_query}  catenate  SELECT cm.ach_allowed, cm.ach_velocity, c.ar_number, c.issuer_id
    ...     FROM cont_misc cm, contract c WHERE c.carrier_id=${carrier} AND cm.contract_id=c.contract_id limit 1;
    Tch Logging  \n QUERY:${old_data_query}
    ${Old_Results}  Query And Strip To Dictionary  ${old_data_query}
    ${Old_Results['issuer_id']}  Convert To String  ${Old_Results['issuer_id']}
    Tch Logging  ISSUER_ID:${Old_Results['issuer_id']}
    Set Global Variable  ${Old_Results['issuer_id']}
    Set Global Variable  ${Old_Results['ach_allowed']}
    Set Global Variable  ${Old_Results['ach_velocity']}
    Set Global Variable  ${Old_Results['ar_number']}


#   UPDATE FLAG AND VELOCITY
    Tch Logging  \n - Updating ach_(allowed and velocity) values
    ${cont_id_query}  catenate  SELECT contract_id FROM contract WHERE ar_number='${Old_Results['ar_number']}'
    ${contract_id}  Query And Strip  ${cont_id_query}
    Set Suite Variable  ${contract_id}
    execute sql string  dml=update cont_misc SET ach_allowed = 'Y', ach_velocity = 2 WHERE contract_id = ${contract_id}

#   SUBMIT THE FIRST PAYMENT
    Tch Logging  \n - Opening eManager to submit the first payment
    Open Browser to eManager
    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Go To  ${emanager}/cards/MakePayment2.action
    Select From List By Value  //*[@name="issuer" and @id="issuer"]  ${Old_Results['issuer_id']}
    Wait Until Element Is Visible  otherAmount  timeout=10
    Execute Javascript  document.getElementById("otherAmount").value=10.00
    Input Text  commentId  MakePaymentComment
    Click Button  doSubmit
    Click Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]
    Wait Until Element Is Visible  //*[@id="payConfData"]  timeout=20
    ${PayVerification}  Get Text  //*[@id="payConfData"]/text()[7]
    Should Be Equal As Strings  ${PayVerification}  ${success_msg}

#   SUBMIT THE SECOND PAYMENT
    Tch Logging  \n - Submit the second payment
    Go To  ${emanager}/cards/MakePayment2.action
    Select From List By Value  //*[@name="issuer" and @id="issuer"]  ${Old_Results['issuer_id']}
    Wait Until Element Is Visible  otherAmount  timeout=10
    Execute Javascript  document.getElementById("otherAmount").value=10.00
    Input Text  commentId  MakePaymentComment
    Click Button  doSubmit
    Click Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]
    Wait Until Element Is Visible  //*[@id="payConfData"]  timeout=20
    ${PayVerification}  Get Text  //*[@id="payConfData"]/text()[7]
    Should Be Equal As Strings  ${PayVerification}  ${success_msg}

#   SUBMIT THE SECOND PAYMENT

    Tch Logging  \n -Submitting the Second Payment
    Go To  ${emanager}/cards/MakePayment2.action
    Select From List By Value  //*[@name="issuer" and @id="issuer"]  ${Old_Results['issuer_id']}
    Wait Until Element Is Visible  otherAmount  timeout=10
    Execute Javascript  document.getElementById("otherAmount").value=10.00
    Input Text  commentId  MakePaymentComment
    Click Button  doSubmit
    Click Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]
    Wait Until Element Is Visible  //*[@id="payment_status"]/p  timeout=10
    ${error}  Get Text  //*[@id="payment_status"]/p
    Tch Logging  \n ERROR:"${error}"
    Should Be Equal As Strings  ${error}  ${error_message}

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Get Into DB  ${DB}
    ...     AND  execute sql string  dml=update cont_misc SET ach_allowed = '${Old_Results['ach_allowed']}', ach_velocity = ${Old_Results['ach_velocity']} WHERE contract_id = ${contract_id}
    ...     AND  Tch Logging  Teardown Successful!

Make a payment for a negative amount
    [Tags]  JIRA:BOT-1712  qTest:29342241  Regression  refactor



    Set Test Variable  ${error_message}  You need to submit a payment larger than $1

    Set Test Variable  ${DB}  TCH
    Set Test Variable  ${carrier}  103866

    Get Into DB  ${DB}
    ${ACHQuery}  catenate  SELECT c.ar_number, c.issuer_id
    ...     FROM cont_misc cm, contract c WHERE c.carrier_id=${carrier} AND cm.contract_id=c.contract_id limit 1;
    ${PaymentResults}  Query And Strip To Dictionary  ${ACHQuery}
   ${PaymentResults['issuer_id']}  Convert To String  ${PaymentResults['issuer_id']}

    Open Browser to eManager
    Log into eManager  ${validCard.carrier.member_id}    ${validCard.carrier.password}
    Hover Over  text=Select Program
    Hover Over  text=Credit Management
    Hover Over  text=Online Payments
    Click On  text=Online Payments
#   WEIRD THING WAS HAPPENING, SCREEN WASN'T LOADING PROPERLY SO I USED A RELOAD PAGE KEYWORD AS A WORKAROUND
    Reload Page
    Wait Until Element Is Visible  commentId  timeout=10
    Select From List By Value  //*[@name="issuer" and @id="issuer"]  ${PaymentResults['issuer_id']}
    Select From List By Value  //*[@name="arNumber" and @id="arNumber"]  0006219830048
    Wait Until Page Contains Element  //*[@name="bankAccount" and @id="bankAccount"]  timeout=20
    Click On  //*[@id="bankAccount"]/option[2]

    Wait Until Element Is Visible  otherAmount  timeout=10
    Execute Javascript  document.getElementById("otherAmount").value=-10.00
    Input Text  commentId  MakePaymentComment
    Click Button  doSubmit
    Wait Until Page Contains Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]  timeout=30
    Click Element  //*[@class="ui-dialog-buttonset"]//*[contains(text(),'Ok')]
    Sleep  2
    ${error}  Get Text  //*[@class="pmtError rowPmtError" and @title="You need to submit a payment larger than $1"]//parent::*
    Tch Logging  \n ERROR:"${error}"
    Should Be Equal As Strings  ${error}  ${error_message}
    [Teardown]  Close Browser

*** Keywords ***
