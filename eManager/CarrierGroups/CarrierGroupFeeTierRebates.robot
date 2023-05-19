*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Test Teardown  Close Browser

Force Tags  eManager

*** Variables ***
${carrier}

*** Test Cases ***
Check fee list for Ryder
    [Tags]  JIRA:FRNT-2033  JIRA:BOT-3657  qTest:55485751
    [Documentation]    Ensure only Ryder fees are displayed in the dropdown from Carrier Group Fee Tier Rebates
    [Setup]    Setup Ryder Carrier for Carrier Group Fee Tier Rebates

    Log Carrier into eManager with Carrier Group Fee Tier Rebates permission
    Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tier Rebates
    Assert Ryder Fee Values

*** Keywords ***
Setup Ryder Carrier for Carrier Group Fee Tier Rebates
    [Documentation]  Keyword Setup for Carrier Group Fee Tier Rebates

    Get Into DB  MySQL
    ${carrier_list_query}  Catenate  SELECT user_id
    ...    FROM sec_user su
    ...    JOIN sec_company sc
    ...    ON su.company_id = sc.company_id
    ...    WHERE company_header = 'ryder_carrier'
    ...    AND user_id REGEXP '^[0-9]+$'
    ...    AND status_id = 'A'
    ...    AND user_id in (SELECT user_id FROM sec_user_role_xref WHERE role_id = 'CARRIER_GROUP_FEE_TIERS_REBATES' AND menu_visible=1)
    ...    ORDER BY user_id LIMIT 100;
    ${query_result}  Query And Strip To Dictionary  ${carrier_list_query}
    ${carrier_list}  Get From Dictionary  ${query_result}  user_id
    ${carrier_list}  Evaluate  ${carrier_list}.__str__().replace('[','(').replace(']',')')

    ${carrier_query}  Catenate  SELECT DISTINCT member_id
    ...    FROM member m
    ...    INNER JOIN carrier_group_fee_tiers ct
    ...    ON m.member_id = ct.parent_id
    ...    INNER JOIN carrier_group_fee_tier_assignment ca
    ...    ON ca.tier_id = ct.tier_id
    ...    WHERE ct.parent_id IN ${carrierList};
    ${carrier}  Find Carrier Variable  ${carrier_query}    member_id
    Set Suite Variable  ${carrier}

Log Carrier into eManager with Carrier Group Fee Tier Rebates permission
    [Documentation]  Log carrier into eManager with Carrier Group Fee Tier Rebates permission

    Open eManager  ${carrier.id}  ${carrier.password}  ChangeCompanyHeader=False

Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tier Rebates
    [Documentation]  Go to Select Program > Group Carrier Group Fees > Carrier Group Fee Tier Rebates

    Go To  ${emanager}/cards/CarrierGroupFeeTierRebates.action
    Wait Until Page Contains    Create New Carrier Group Fee Tier Rebates

Assert Ryder Fee Values
    [Documentation]  Get the values from Fee dropdown and compare with database

    ${fee_list}    Get List Items    name=cgftRebates.feeId
    Get Into DB  TCH
    ${fee_query}  Catenate  SELECT * FROM fee_types WHERE fee_id IN (501,504);
    ${fee_result}  Query And Strip To Dictionary  ${fee_query}
    ${db_fee_list}  Get From Dictionary  ${fee_result}  fee_desc
    Should Be Equal  ${db_fee_list}   ${fee_list}