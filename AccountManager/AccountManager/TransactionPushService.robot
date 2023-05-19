*** Settings ***
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource  otr_robot_lib/robot/APIKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot
Resource  otr_robot_lib/variables/CommonVariables.robot

Documentation  Verifies all information on the Customer Transaction Push Service tab in Account Manager and then
          ...  Validates that Carrier can successfully be enrolled in Transaction Push Service
Force Tags  AM  Transaction Push Service

Suite Setup         Setup
Suite Teardown      Teardown

*** Variables ***
@{field_list}  tpsFamily  tpsPostRqstUrl  tpsScope  tpsTokenRqstUrl  tpsUserName  tpsPassword

*** Test Cases ***
Test Reset fucntion
    [Documentation]    Verify that the Reset button clears a filled form
    [Tags]    JIRA:ROCKET-265  qTest:120215672  API:Y  Q1:2023
    Open Transaction Push Service tab
    Fill out Transaction Push Service fields
    Click Reset button
    Verify Reset Button

Test View Password button
    [Documentation]    Verify that the password changes to text after clicking VIEW button
    [Tags]    JIRA:ROCKET-265  qTest:120215673  API:Y  Q1:2023
    Open Transaction Push Service tab
    Verify View Password button

Test required field validation
    [Documentation]    Submit form with a missing required field and verified required field text is displayed
    [Tags]    JIRA:ROCKET-265  qTest:120215674  API:Y  Q1:2023
    Open Transaction Push Service tab
    Submit Partially Filled Form

Test Carrier can successfully be enrolled
    [Documentation]    Verify Success Message after filling out a form, clicking submit, and logging into Okta
    [Tags]    JIRA:ROCKET-265  JIRA:ROCKET-482  qTest:120215675  API:Y  Q1:2023
    Open Transaction Push Service tab
    Fill out Transaction Push Service fields
    Sleep  1
    Click Submit button
    Login to Okta
    Validate TCS Postgres
    Verify Success Message

Test failure when Carrier is already enrolled
    [Documentation]    Verify Failure Message when trying to enroll a Carrier that was previously enrolled
        ...  Note this test only works if the previous test passed as it uses the same Carrier.
    [Tags]    JIRA:ROCKET-265  JIRA:ROCKET-482  qTest:120215676  API:Y  Q1:2023
    Reload Page
    Open Transaction Push Service tab
    Fill out Transaction Push Service fields
    Sleep  1
    Click Submit button
    Login to Okta
    Verify Already Enrolled Message
    Validate TCS Postgres

*** Keywords ***
Setup
    [Documentation]    Create automation user to be used during the test
    ...  Login to eManager and Navigate to Account Manager
    ...  Search for Customer ID and open customer from result table
    Check For My Automation User
    Create My User    integration_support_specialist    OTR_eMgr    ${NONE}    N
    Open Emanager  ${intern}  ${internPassword}
    Navigate To Account Manager
    Get Customer
    Get Customer Name
    Search for Customer
    Open Customer from search result table

Teardown
    [Documentation]    Delete the automation user created. Delete from postgres DBs.
    Remove Automation User
    Remove TCS Postgres

Navigate To Account Manager
    [Documentation]    Navigate To Account Manager
    [Tags]    qTest
    Go To  ${emanager}/acct-mgmt/RecordSearch.action

Get Customer
    Get Into DB  TCH
    ${carrierId}  Query And Strip  select member_id from member where carrier_type = 'TCH' and status='A' and mem_type = 'C' and member_id NOT IN (324916, 100013);
    Set Suite Variable  ${carrierId}

Get Customer Name
    Get Into DB  TCH
    ${carrierName}  Query And Strip  select name from member where carrier_type = 'TCH' and status='A' and mem_type = 'C' and member_id = '${carrierId}'
    Set Suite Variable  ${carrierName}

Search for Customer
    [Documentation]    Search in customers tab by carrier id
    [Tags]    qTest
    Wait Until Element is Visible    //*[@name="id"]
    Input Text    name=id    ${carrierId}
    Click Element  //button[contains(text(),'Submit')]

Open Customer from search result table
    [Documentation]    Open customer details screen
    [Tags]    qTest
    Wait Until Element is Visible    //*[@class="id buttonlink" and text()='${carrierId}']
    Click Element    //*[@class="id buttonlink" and text()='${carrierId}']
    Page Should Contain     ${carrierId}

Open Transaction Push Service tab
    [Documentation]    Open Transaction Push Service tab from Customer detail screen
    [Tags]    qTest
    Wait Until Element is Visible    //*[@id="TransactionPush"]
    Click Element    //*[@id="TransactionPush"]
    Wait Until Element is Visible   //*[@id="transactionPushFormButtons"]

Verify Reset button
    [Documentation]    Verifies all editable fields are empty and read-only fields contain correct value after clicking RESET button
    [Tags]    qtest
    ${tpsCarrierId}=	Get Value	id=tpsCarrierId
    ${tpsFamily}=       Get Value 	id=tpsFamily
    ${tpsPostRqstUrl}=	Get Value	id=tpsPostRqstUrl
    ${tpsScope}=        Get Value	id=tpsScope
    ${tpsCarrierName}=	Get Value	id=tpsCarrierName
    ${tpsTokenRqstUrl}=	Get Value	id=tpsTokenRqstUrl
    ${tpsUserName}=		Get Value	id=tpsUserName
    ${tpsPassword}=		Get Value	id=tpsPassword

    Should Be Equal As Strings         ${tpsCarrierId}  ${carrierId}
    Should Be Empty     ${tpsFamily}
    Should Be Empty     ${tpsPostRqstUrl}
    Should Be Empty     ${tpsScope}
    Should Be Equal As Strings         ${tpsCarrierName}  ${carrierName}
    Should Be Empty     ${tpsTokenRqstUrl}
    Should Be Empty     ${tpsUserName}
    Should Be Empty     ${tpsPassword}
    #Checkbox Should Not Be Selected    id=tpsIsParent
    ...  There is a bug with global Reset button that does not revert boxes to unchecked state
    ${authTypeStatus}=  Get Selected List Value    name=tpsAuthenticationType
    Should Be Equal As Strings  ${authTypeStatus}  client_credentials

Click Reset button
    [Documentation]    Click the RESEST button
    [Tags]    qtest
    Click Element  //*[@id="transactionPushFormButtons"]//*[@id="reset"]

Click Submit button
    [Documentation]    Click the SUBMIT button
    [Tags]    qtest
    Click Element  //*[@id="transactionPushFormButtons"]//*[@id="submitBtn"]

Login to Okta
    [Documentation]    Login to Okta as user with the following configuration; persona: integration_support_specialist app: OTR_eMgr
    [Tags]    qtest
    Wait Until Element Is Visible    id=okta-signin-submit
    Sleep  2
    Input Text  id=okta-signin-username  ${okta_automated_email}
    Input Text  id=okta-signin-password  ${automated_user_password}
    Click Element    id=okta-signin-submit
    Wait Until Element Is Not Visible    //div[@data-se='loading-beacon']

Fill out Transaction Push Service fields
    [Documentation]    Fill out all of the required fields
    [Tags]    qtest
    [Arguments]
    ...    ${carrier_id}=${carrierId}
    ...    ${carrier_name}=${carrierName}
    ...    ${family}=R265_NEW_FAMILY
    ...    ${token_request_url}=Robot_Test_reqURL
    ...    ${post_request_url}=Robot_Test_postReqURL
    ...    ${user_name}=Robot_Test_User
    ...    ${password}=Robot_Test_Password
    ...    ${scope}=Robot_Test_Scope
    ...    ${grant_type}=client_credentials
    ...    ${is_parent}=false

    ${enrollment}    Create Dictionary    carrierId=${carrier_id}    carrierName=${carrier_name}    family=${family}
    ...    tokenRequestURL=${token_request_url}    postRequestURL=${post_request_url}
    ...    username=${user_name}    password=${password}    scope=${scope}    grantType=${grant_type}
    ...    isParent=${is_parent}
    Set Suite Variable    ${enrollment}

    Input Text  id=tpsFamily  ${family}
    Input Text  id=tpsPostRqstUrl  ${post_request_url}
    Input Text  id=tpsScope  ${scope}
    Input Text  id=tpsTokenRqstUrl  ${token_request_url}
    Input Text  id=tpsUserName  ${user_name}
    Input Text  id=tpsPassword  ${password}
    Select From List By Label  name=tpsAuthenticationType  client_credentials
    #Select Checkbox  id=tpsIsParent

Validate TCS Postgres
    [Documentation]    Query the trans/tcs service postgres database and validate that the information has been stored
    ...    correctly.
    ...    SELECT token_request_id FROM token_request WHERE url='tokenRequestURL' AND username='username'
    ...    AND grant_type='grantType' AND scope='scope'
    ...    Use the ID from above to find the classifier:
    ...    SELECT classifier_id FROM classifier_config WHERE classifier_name='family'
    ...    AND post_url='postRequestURL' AND token_request_id = previous_query_id
    ...    Check the carrier service postgres if the carrier got added to the new family
    ...    SELECT id FROM carrier_family_carrier_xref where carrier_id = 'carrierId'
    ...    AND family = 'family'
    [Tags]    qtest
    ${sql}    Catenate    SELECT token_request_id FROM token_request WHERE url='${enrollment['tokenRequestURL']}'
    ...    AND username='${enrollment['username']}' AND grant_type='${enrollment['grantType']}'
    ...    AND scope='${enrollment['scope']}'
    ${token_request_id}    Query And Strip    ${sql}    db_instance=postgrespgtransservice
    Should Not Be Empty    ${token_request_id.__str__()}
    Set Suite Variable    ${token_request_id}
    ${sql}    Catenate    SELECT classifier_id FROM classifier_config WHERE classifier_name='${enrollment['family']}'
    ...    AND post_url='${enrollment['postRequestURL']}' AND token_request_id = ${token_request_id}
    ${classifier_id}    Query And Strip    ${sql}    db_instance=postgrespgtransservice
    Should Not Be Empty    ${classifier_id.__str__()}
    Set Suite Variable    ${classifier_id}
    ${sql}    Catenate    SELECT id FROM carrier_family_carrier_xref where carrier_id = '${enrollment['carrierId']}'
    ...    AND carrier_family_natural_id = '${enrollment['family']}'
    ${family_id}    Query And Strip    ${sql}    db_instance=postgrespgcarrierservices
    Should Not Be Empty    ${family_id.__str__()}
    Set Suite Variable    ${family_id}

Remove TCS Postgres
    [Documentation]    Clean the database from test data:
    ...    delete  from carrier_family_carrier_xref where id = family_id
    ...    delete from token_request where token_request_id = token_request_id
    ...    delete from classifier_config where classifier_id = classifier_id
    [Tags]    qtest
    ${sql}    Catenate    delete from classifier_config where classifier_id = ${classifier_id}
    Execute Sql String    ${sql}    db_instance=postgrespgtransservice
    ${sql}    Catenate    delete from token_request where token_request_id = ${token_request_id}
    Execute Sql String    ${sql}    db_instance=postgrespgtransservice
    ${sql}    Catenate    delete from carrier_family_carrier_xref where id = '${family_id}'
    Execute Sql String    ${sql}    db_instance=postgrespgcarrierservices

Verify Success Message
    [Documentation]    Confirm that the Success message appears at the top of the screen
    [Tags]    qTest
    Wait Until Element Is Visible  //*[@id="transactionPushMessages"]//li[contains(text(),"Add Successful.")]
    ...  timeout=10  error=Failed to enroll carrier ${carrierId}. Review log group /ecs/phnx-carrierservice-dit

Verify Already Enrolled Message
    [Documentation]    Confirm that the Already Enrolled success message appears at the top of the screen
    [Tags]    qTest
    Wait Until Element Is Visible    //*[@id="transactionPushMessages"]//li[text()="Carrier/family already enrolled. The Response returned from the API is 201"]  timeout=5

Submit Partially Filled Form
    [Documentation]    Submit form with a missing required field, repeat for all required fields
    [Tags]  qTest
    FOR  ${field}  IN  @{field_list}
        Fill out Transaction Push Service fields
        Clear Element Text  id=${field}
        Click Submit Button
        Wait Until Element Is Visible    //label[text()="This field is required."]
        Click Reset Button
    END

Verify View Password button
    [Documentation]    Verify that clicking the VIEW button changes the password field to text
    [Tags]    qTest
    Input Text  id=tpsPassword  MySecretP4$$w0rD
    Click Element  (//button[text()='View'])[2]
    ${type}=  Get Element Attribute    id=tpsPassword   type
    Should Be Equal As Strings    ${type}  text
    Click Element  (//button[text()='View'])[2]
    ${type}=  Get Element Attribute    id=tpsPassword   type
    Should Be Equal As Strings    ${type}  password