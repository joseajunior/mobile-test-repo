*** Settings ***
Documentation       Test the CarrierPurchaseApproval endpoint that has the option to Approve or Reject a purchase

Library             String
Library             otr_robot_lib.ws.RestAPI.RestAPIService
Library             otr_robot_lib.ws.UserServiceAPI.UserAPIService
Resource            otr_robot_lib/robot/APIKeywords.robot

Suite Setup         Test Suite Setup
Suite Teardown      Remove User If Still Exists

Force Tags          API  DITONLY  MERCHANTERVICEAPI  PHOENIX


*** Variables ***
${approved}             CARRIER_APPROVED
${carrier_rejected}     CARRIER_REJECTED
${purchase_rejected}    PURCHASE_REJECTED


*** Test Cases ***
Validate Carrier Purchase Approval Endpoint Approve Successful Response 200
    [Documentation]  Test to validate the POST CarrierPurchaseApproval endpoint successful response when the carrier is approved
    [Tags]  JIRA:O5SA-646  Q2:2023  QTEST:120443196
    [Setup]  Replace Entity From User  ${auto_user_id}  ids=${carrier_ids}
    Send Request  ${ready_data}[0][carrier_id]  ${ready_data}[0][pre_purchase_id]
    Verify Response  200  ${ready_data}[0][pre_purchase_id]  ${approved}
    [Teardown]  Original Pre Purchase Status

Validate Carrier Purchase Approval Endpoint Carrier Rejected Successful Response 200
    [Documentation]  Test to validate the POST CarrierPurchaseApproval endpoint successful response when the carrier is rejected
    [Tags]  JIRA:O5SA-646  Q2:2023  QTEST:120443196
    Send Request
    ...  ${ready_data}[0][carrier_id]
    ...  ${ready_data}[0][pre_purchase_id]
    ...  reject_code=WRONG_DATE
    ...  reject_reason=Please fix date and resubmit
    Verify Response
    ...  200
    ...  ${ready_data}[0][pre_purchase_id]
    ...  ${carrier_rejected}
    ...  reject_code=WRONG_DATE
    ...  reject_reason=Please fix date and resubmit
    [Teardown]  Original Pre Purchase Status

Validate Carrier Purchase Approval Endpoint With Original Status Of Purchase Rejected Successful Response 200
    [Documentation]  Test to validate the POST CarrierPurchaseApproval endpoint successful response when the carrier has an original status of "Purchase Rejected"
    [Tags]  JIRA:O5SA-646  Q2:2023  QTEST:120443196
    Send Request  ${rejected_data}[0][carrier_id]  ${rejected_data}[0][pre_purchase_id]
    Verify Response  200  ${rejected_data}[0][pre_purchase_id]  ${purchase_rejected}

Validate Carrier Purchase Approval Endpoint Missing Required Pre Purchase ID Bad Request 400
    [Documentation]  Test to validate the POST CarrierPurchaseApproval endpoint error response when there are no pre purchase ids sent in the request
    [Tags]  JIRA:O5SA-646  Q2:2023  QTEST:120443197
    Send Request  ${ready_data}[0][carrier_id]
    Verify Response  400
    [Teardown]  Original Pre Purchase Status


*** Keywords ***
Test Suite Setup
    [Documentation]  Get data for test
    Get URL For Suite  ${MerchantService}
    Create My User  persona_name=carrier_onsite_fuel_manager  with_data=N
    Find Data

Find Data
    [Documentation]  Finds carrier_id and pre_purchase_id
    Get Into DB  postgresmerchants
    ${query}  Catenate  select pre_purchase_id, pre_purchase_status, reject_reason, reject_code, carrier_id
    ...  from pre_purchase
    ...  where pre_purchase_status = 'READY_FOR_CARRIER_APPROVAL'::pre_purchase_status_enum and length(carrier_id)>=6
    ...  limit 1;
    ${results}  Query To Dictionaries  ${query}
    Set Suite Variable  ${ready_data}  ${results}

    ${query}  Catenate
    ...  select pre_purchase_id, pre_purchase_status, reject_reason, reject_code, carrier_id from pre_purchase
    ...  where pre_purchase_status = 'PURCHASE_REJECTED'::pre_purchase_status_enum and length(carrier_id)>=6
    ...  limit 1;
    ${results}  Query To Dictionaries  ${query}
    Set Suite Variable  ${rejected_data}  ${results}
    Disconnect From Database
    IF  '${rejected_data}[0][carrier_id]' == '${ready_data}[0][carrier_id]'
        Set Suite Variable  ${carrier_ids}  ${rejected_data}[0][carrier_id]
    ELSE
        Set Suite Variable  ${carrier_ids}  ${rejected_data}[0][carrier_id] ${ready_data}[0][carrier_id]
    END

Original Pre Purchase Status
    [Documentation]  Changes new pre_purchase_status back to original pre_purchase_status
    Get Into DB  postgresmerchants
    ${query}  Catenate  UPDATE pre_purchase
    ...  SET reject_reason  = null,
    ...  reject_code  = null,
    ...  pre_purchase_status = 'READY_FOR_CARRIER_APPROVAL'::pre_purchase_status_enum
    ...  WHERE pre_purchase_id = ${ready_data}[0][pre_purchase_id];
    ${count}  Execute Sql String  dml=${query}
    Tch Logging  rows affected ${count}

Send Request
    [Documentation]  send the request to the POST Carrier Purchase Approvals endpoint
    [Arguments]
    ...  ${carrier_id}
    ...  ${pre_purchase_id}=${EMPTY}
    ...  ${secure}=Y
    ...  ${reject_code}=${NONE}
    ...  ${reject_reason}=${NONE}

    IF  '${pre_purchase_id}'=='${EMPTY}' and '${reject_code}'=='${NONE}' and '${reject_reason}'=='${NONE}'
        ${payload}  Create Dictionary  pre_purchase_id=${pre_purchase_id}
    ELSE IF  '${reject_code}'=='${NONE}' and '${reject_reason}'=='${NONE}'
        ${payload}  Create Dictionary  pre_purchase_id=${pre_purchase_id}
    ELSE
        ${payload}  Create Dictionary
        ...  pre_purchase_id=${pre_purchase_id}
        ...  reject_code=${reject_code}
        ...  reject_message=${reject_reason}
    END

    @{list}  Create List  ${payload}
    ${payload}  Create Dictionary  purchase_approve_list=@{list}

    ${url_stuff}  Create Dictionary  carriers=${carrier_id}

    ${response}  ${status}  Api Request  POST  carrier-purchase-approvals  ${secure}  ${url_stuff}  payload=${payload}
    Set Test Variable  ${responsebody}  ${response}
    Set Test Variable  ${statuscode}  ${status}

Verify Response
    [Documentation]  Compares values in the response body with the values in the database tables
    [Arguments]
    ...  ${status}
    ...  ${pre_purchase_id}=${EMPTY}
    ...  ${pre_purchase_status}=${NONE}
    ...  ${reject_reason}=${NONE}
    ...  ${reject_code}=${NONE}
    IF  '${status}' == '200'
        Should Be Equal As Strings  ${statuscode}  200
        Should Be Equal As Strings  ${responsebody}[name]  OK
        Should Be Equal As Strings  ${responsebody}[message]  SUCCESSFUL
        Should Be Equal As Strings  ${responsebody}[details][type]  PurchaseApproveRejectResponseDTO
        IF  '${pre_purchase_status}' == '${approved}' or '${pre_purchase_status}' == '${carrier_rejected}'
            Should Be Equal As Strings  ${responsebody}[details][data][pre_purchase_id][0]  ${pre_purchase_id}
        END

        Get Into DB  postgresmerchants
        ${query}  Catenate
        ...  select pre_purchase_id, pre_purchase_status, reject_reason, reject_code from pre_purchase
        ...  where pre_purchase_id = ${pre_purchase_id}
        ${results}  Query To Dictionaries  ${query}
        Disconnect From Database
        Should Be Equal As Strings  ${results}[0][pre_purchase_status]  ${pre_purchase_status}

        IF  '${reject_reason}' != '${NONE}' and '${reject_code}' != '${NONE}'
            Should Be Equal As Strings  ${results}[0][reject_reason]  ${reject_reason}
            Should Be Equal As Strings  ${results}[0][reject_code]  ${reject_code}
        END
    ELSE IF  '${status}' == '400'
        Should Be Equal As Strings  ${statuscode}  400
        Should Be Equal As Strings  ${responsebody}[name]  BAD_REQUEST
        IF  '${pre_purchase_id}'=='${EMPTY}'
            Should Be Equal As Strings  ${responsebody}[details][0][field]  purchaseApproveList[0].prePurchaseId
            Should Be Equal As Strings  ${responsebody}[details][0][issue]  pre_purchase_id is required
            Should Be Equal As Strings  ${responsebody}[message]  Invalid request input
        END
    END
