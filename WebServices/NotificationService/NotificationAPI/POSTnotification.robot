*** Settings ***
Library     Collections
Library     String
Library     otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library     otr_robot_lib.ws.RestAPI.RestAPIService
Library     otr_model_lib.services.GenericService
Library     otr_robot_lib/support/DynamicTesting.py
Resource    otr_robot_lib/robot/APIKeywords.robot

Suite Setup     Generate data to use

Documentation  This is to test the endpoint [POST Send a notification with thymeleaf template]
...            OTR - Notification API is responsable to send out notifications like emails to users
...            URL: (https://notificationsvc.{env}.efsllc.com) - WEX OTR API's are secured with OKTA using OAuth2.

Force Tags   API  NotificationServiceAPI   ditOnly

*** Variables ***
${email}  POSTnotification_automation@wexinc.com
${templateNameAWS}  test_tl_template.html

*** Test Cases ***
############################### Notifications API ##################################
#-----------------------------------------------------------------------------------#
#              Endpoint POST:  /notifications/send                                  #
#-----------------------------------------------------------------------------------#
(Notifications API) POST - Test Sending Notification Successfully
    [Tags]              Q2:2023   JIRA:O5SA-575   qTest:120503417
    [Documentation]     This is to test (POST endpoint) to send notifications
    ...                 The API response should be 202
    Sending post request
    The API response should be 202 accepted
    Compare request and reponse with data stored in the database

(Notifications API) POST ERRORS - Testing the endpoint EXPECTED ERRORS
    [Tags]           Q2:2023  JIRA:O5SA-714  qTest:120516254
    [Documentation]  This is to test all EXPECTED ERRORS about the endpoint [POST to SEND notifications ]
    Creating a list of errors to run during EXPECTED ERRORS tests

*** Keywords ***
Generate data to use
    [Documentation]    Create fields to use as request body and connecting with notifications API
    Get URL For Suite  ${NotificationService}

    Set suite variable  ${sender}  Test automation

    ${to_list}  Create List  ${email}
    Set suite variable  ${to_list}

    Set suite variable  ${from}  ${email}
    Set suite variable  ${reply_to}  ${email}
    Set suite variable  ${subject}  Test Automation email

    ${template_value_map}  Create Dictionary    recipientName=recipient Name  text=This is the text body of the email message
    ...  regards=Thank you for your help  senderName=senderName
    Set suite variable  ${template_value_map}

Sending post request
    [Documentation]  Used to build a generic REQUEST structure of the endpoint (POST to send a Notification)
    [Arguments]  ${authorized}=AI  ${what_remove}=${NONE}  ${template_name}=${templateNameAWS}  ${reply_to}=${reply_to}
    ...  ${to_list}=${to_list}  ${from}=${from}  ${cc_list}=${NONE}  ${bcc_list}=${NONE}

    ${path_url}      create dictionary   None=send
    ${request_body}  Create Dictionary    sender=${sender}  to_list=${to_list}  from=${from}    reply_to=${reply_to}
    ...  subject=${subject}  template_name=${template_name}  template_value_map=${template_value_map}  cc_list=${cc_list}
    ...  bcc_list=${bcc_list}

    IF  ${what_remove}!=${NONE}
        FOR  ${remove}  IN   @{what_remove}
            Remove From Dictionary  ${request_body}  ${remove.lower()}
        END
    END

    ${result}   ${status}  Api request   POST  notifications  ${authorized}  ${path_url}   payload=${request_body}

    Set Suite Variable      ${result}
    Set Suite Variable      ${status}
    Set Suite Variable      ${request_body}

The API response should be 202 accepted
    [Documentation]  Cheking STATUS and values displayed in the API response

    Should Be Equal As Strings  ${status}                 202
    Should Be Equal As Strings  ${result}[name]           ACCEPTED
    Should Be Equal As Strings  ${result}[message]        SUCCESSFUL
    Should Be Equal As Strings  ${result}[details][type]  NotificationResponseDto
    Should Not Be Empty         ${result}[details][data][request_id]

Compare request and reponse with data stored in the database
    [Documentation]    Compare values sent in resquest body and got response body with stored in table notification_history
    ...  in postgress db

    Get into DB  postgresnotification
    ${query}  Catenate  select * from notification_history nh where request_id = '${result}[details][data][request_id]'
    ${notific_DB}   query to dictionaries   ${query}
    Disconnect from Database

    Should Be Equal As Strings    ${notific_DB}[0][request_id]      ${result}[details][data][request_id]
    Should Be Equal As Strings    ${notific_DB}[0][sender]          ${sender}
    ${date}  Convert To String    ${notific_DB}[0][date_sent]
    Should Not Be Empty           ${date}
    Should Be Equal As Strings    ${notific_DB}[0][from_address]    ${email}
    Should Be Equal As Strings    ${notific_DB}[0][recipient_list]  [${email}]
    Should Be Equal As Strings    ${notific_DB}[0][subject]         ${subject}
    Should Be Equal As Strings    ${notific_DB}[0][template_name]   ${templateNameAWS}
    Should Be Equal As Strings    ${notific_DB}[0][template_value_map][text]  ${template_value_map}[text]
    Should Be Equal As Strings    ${notific_DB}[0][template_value_map][recipientName]  ${template_value_map}[recipientName]
    Should Be Equal As Strings    ${notific_DB}[0][template_value_map][regards]  ${template_value_map}[regards]
    Should Be Equal As Strings    ${notific_DB}[0][template_value_map][senderName]  ${template_value_map}[senderName]

################################################### EXPECTED ERRORS ###################################################
ERROR - RESPONSE EXPECTED
    [Documentation]  Use to validade EXPECTED ERRORS of this endpoints (400, 401, 403, 404, 422)
    [Arguments]      ${code}=${NONE}   ${with_details}=${NONE}  ${issue_message}=${NONE}  ${field_message}=${NONE}

    IF  '${code}'=='401'
        Should Be Equal As Strings     ${status}  401
    ELSE IF  '${code}'=='500'
        Should Be Equal As Strings     ${status}  500
        Should Be Equal As Strings     ${result}[name]          NOTIFICATION_HISTORY_ERROR
        Should Be Equal As Strings     ${result}[error_code]    NOTIFICATION_HISTORY_ERROR
        Should Be Equal As Strings     ${result}[message]       Unable to parse and save Notification History
    ELSE IF  '${code}'=='422'
        Should Be Equal As Strings     ${status}                422
        IF        '${with_details}'=='YES'
            Should Be Equal As Strings     ${result}[name]                INVALID_EMAIL_ADDRESS
            Should Be Equal As Strings     ${result}[error_code]          INVALID_EMAIL_ADDRESS
            Should Not Be Empty            ${result}[details][0][value]
            Should Be Equal As Strings     ${result}[details][0][issue]   Invalid Email
            Should Be Equal As Strings     ${result}[message]             Invalid Email Address
        ELSE IF  '${with_details}'=='NO'
            Should Be Equal As Strings     ${result}[name]          NOTIFICATION_TEMPLATE_MISSING
            Should Be Equal As Strings     ${result}[error_code]    NOTIFICATION_TEMPLATE_MISSING
            Should Be Equal As Strings     ${result}[message]       Unable to find a template with that name
        END
    ELSE IF  '${code}'=='400'
        Should Be Equal As Strings     ${status}  400
        Should Be Equal As Strings     ${result}[name]                 BAD_REQUEST
        Should Be Equal As Strings     ${result}[details][0][field]    ${field_message}
        Should Be Equal As Strings     ${result}[details][0][issue]    ${issue_message}
        Should Be Equal As Strings     ${result}[message]              Invalid request input
    END

Creating a list of errors to run during EXPECTED ERRORS tests
    [Documentation]  Creating a List Of Errors To Run During EXPECTED ERRORS Tests
    ${error_list}   Create List
    ...  UNAUTHORIZED TOKEN    WITHOUT SENDER    WITHOUT FROM    WITHOUT TO_LIST    WITHOUT REPLY_TO
    ...  WITHOUT SUBJECT    WITHOUT TEMPLATE_NAME    WITHOUT TEMPLATE_VALUE_MAP    UNEXISTENT TEMPLATE_NAME
    ...  UNFORMATTED REPLY_TO    UNFORMATTED TO_LIST    UNFORMATTED FROM    UNFORMATTED CC_LIST  UNFORMATTED BCC_LIST
    ...  CC_LIST SENDER FORMAT    BCC_LIST SENDER FORMAT    REPLY_TO SENDER FORMAT    TO_LIST TOO MANY EMAILS

    ${test_to_run}  Evaluate  dict((j,j) for i,j in enumerate(${error_list}))
    Set Suite Variable  ${test_to_run}

    FOR  ${error}  IN  @{error_list}
         Add Test Case  (Notifications API) POST ERRORS - ${error}  TEST ERROR "${error}"
    END

TEST ERROR "${keyword}"
    [Documentation]  Calling all Test Keywords related to EXPECTED ERRORS that need to be executed
    Run Keyword If  '${keyword}' in $test_to_run  ERROR - ${test_to_run}[${keyword}]

ERROR - UNAUTHORIZED TOKEN
    [Documentation]  Testing the request WITH UNAUTHORIZED TOKEN, or using an INVALID ONE
    Sending Post Request  authorized=N
    ERROR - RESPONSE EXPECTED   code=401

ERROR - WITHOUT SENDER
    [Documentation]  Testing the request without the required field SENDER
    @{fields_to_remove}   Create List    sender
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED  code=400  field_message=sender  issue_message=must not be empty

ERROR - WITHOUT FROM
    [Documentation]  Testing the request without the required field FROM
    @{fields_to_remove}   Create List    from
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED  code=400  field_message=from  issue_message=from is required

ERROR - WITHOUT TO_LIST
    [Documentation]  Testing the request without the required field TO_LIST
    @{fields_to_remove}   Create List    to_list
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED  code=400  field_message=to_list  issue_message=Must provide at least one to email address

ERROR - WITHOUT REPLY_TO
    [Documentation]  Testing the request without the required field REPLY_TO
    @{fields_to_remove}   Create List    reply_to
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED  code=400   field_message=replyTo  issue_message=reply to is required

ERROR - WITHOUT SUBJECT
    [Documentation]  Testing the request without the required field SUBJECT
    @{fields_to_remove}   Create List    subject
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED  code=400  field_message=subject  issue_message=subject is required

ERROR - WITHOUT TEMPLATE_NAME
    [Documentation]  Testing the request without the required field TEMPLATE_NAME
    @{fields_to_remove}   Create List    template_name
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED  code=400  field_message=templateName  issue_message=template_name is required

ERROR - WITHOUT TEMPLATE_VALUE_MAP
    [Documentation]  Testing the request without the required field TEMPLATE_VALUE_MAP
    @{fields_to_remove}   Create List    template_value_map
    Sending Post Request  what_remove=@{fields_to_remove}
    ERROR - RESPONSE EXPECTED  code=400  field_message=templateValueMap  issue_message=template_value_map is required

ERROR - UNEXISTENT TEMPLATE_NAME
    [Documentation]  Testing the request with UNEXISTENT TEMPLATE on AWS
    Sending Post Request  template_name=WRONG_TEMPLATE_NAME.html
    ERROR - RESPONSE EXPECTED  code=422  with_details=NO

ERROR - UNFORMATTED REPLY_TO
    [Documentation]  Testing the request with an UNFORMATTED REPLY_TO email field
    Sending Post Request  reply_to=Automation
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - UNFORMATTED TO_LIST
    [Documentation]  Testing the request with an UNFORMATTED TO_LIST email field
    ${to_list_unformatted}  Create List  Automation
    Sending Post Request  to_list=${to_list_unformatted}
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - UNFORMATTED FROM
    [Documentation]  Testing the request with an UNFORMATTED FROM email field
    Sending Post Request  from=Automation
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - UNFORMATTED CC_LIST
    [Documentation]  Testing the request with an UNFORMATTED CC_LIST email field
    ${cc_list_unformatted}  Create List  Automation
    Sending Post Request  cc_list=${cc_list_unformatted}
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - UNFORMATTED BCC_LIST
    [Documentation]  Testing the request with an UNFORMATTED BCC_LIST email field
    ${bcc_list_unformatted}  Create List  Automation
    Sending Post Request  bcc_list=${bcc_list_unformatted}
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - CC_LIST SENDER FORMAT
    [Documentation]  Testing the request with the format "name <name@email.com>" on CC_LIST field
    ${cc_list_sender_info}  Create List  Automation <automation@email.com>
    Sending Post Request  cc_list=${cc_list_sender_info}
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - BCC_LIST SENDER FORMAT
    [Documentation]  Testing the request with the format "name <name@email.com>" on BCC_LIST field
    ${bcc_list_sender_info}  Create List  Automation <automation@email.com>
    Sending Post Request  bcc_list=${bcc_list_sender_info}
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - REPLY_TO SENDER FORMAT
    [Documentation]  Testing the request with the format "name <name@email.com>" on REPLY_TO field
    Sending Post Request  reply_to=Automation <automation@email.com>
    ERROR - RESPONSE EXPECTED  code=422  with_details=YES

ERROR - TO_LIST TOO MANY EMAILS
    [Documentation]  Testing the request with to many emails inside TO_LIST field
    ${too_many_emails}  Evaluate  ["automation@email.com"]*50
    Sending Post Request  to_list=${too_many_emails}
    ERROR - RESPONSE EXPECTED  code=500