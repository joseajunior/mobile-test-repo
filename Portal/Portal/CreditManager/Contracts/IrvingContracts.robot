*** Settings ***
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot

Force Tags  Portal  Credit Manager

Test Teardown  Close Browser

*** Variables ***
${PortalIrvingUsername}    robot_irv@irving
${PortalIrvingUserId}    robot_irv
${IrvingDomainId}    2
${IrvingCreditDeptPermissionValue}    48
${PortalEFSUsername}    robot_efs@efsllc
${PortalEFSUserId}    robot_efs
${EFSDomainId}    1
${EFSEmployeeValue}    11
${EFSCreditDeptValue}    27
${EFSCreditDeptROValue}    32
${EFSAROracle}    21
## FIELDS ##
# Carrier Info
${nameTxtField}    Name
${statusDropdownField}    Status
${carrierTypeTxtField}    Carrier Type
${legalNameTxtField}    Legal Name
${creditGroupDropdownField}    Credit Group
${salesTerritoryDropdownField}    Sales Territory
${outsideSalesRepTxtField}    Outside Sales Rep
${insideSalesRepTxtField}    Inside Sales Rep
${accountManagerTxtField}    Account Manager
${phoneTxtField}    Phone
${cellTxtField}    Cell
${emailTxtField}    Email
${PDCACheckbox}    Member
${lvlTxtField}    Lvl
${dateTxtField}    Date
${createdDateTxtField}    Created Date
${lastUpdatedTxtField}    Last Updated
${firstTransTxtField}    First Trans
${renewalExpTxtField}    Renewal Exp
${zconCheckbox}    Z-Con dispatch
${useEngineOdometerCheckbox}    Use engine odometer
${minimalPromptingCheckbox}    Minimal Prompting
${wexNationalIDTxtField}    WEX National ID
# Contact Info
${firstNameTxtField}    First Name
${lastNameTxtField}    Last Name
${departmentTxtField}    Department
${addressTxtField}    Address
${cityTxtField}    City
${stateTxtField}    State
${countryTxtField}    Country
${postalCodeTxtField}    Postal Code
${faxTxtField}    Fax

*** Test Cases ***
Check read only permission for EFS Domain
    [Tags]  JIRA:PORT-710  qTest:55468716
    [Documentation]  Check for read only permission when login with EFS domain with EFS Credit Dept RO group and searching for an Irving Affiliate Billing Contract and an EFS contract
    [Setup]    Setup for EFS Credit Dept Permission    True

    Get Carrier from Irving Affiliate Billing Contract
    Open Browser And Login To Portal
    Go to Credit Manager
    Search by Carrier ID
    Go to Carrier Tab
    Assert EFS domain with EFS Credit Dept RO group
    Click to Return
    Search by Carrier ID    EFS
    Go to Carrier Tab
    Assert EFS domain with EFS Credit Dept RO group for EFS Contract

    [Teardown]    Teardown for EFS User    True

Check write permission for EFS Domain
    [Tags]  JIRA:PORT-710  qTest:55468747
    [Documentation]  Check for write permission when login with EFS domain with EFS Credit Dept group and searching for an Irving Affiliate Billing Contract and an EFS contract
    [Setup]    Setup for EFS Credit Dept Permission

    Get Carrier from Irving Affiliate Billing Contract
    Open Browser And Login To Portal
    Go to Credit Manager
    Search by Carrier ID
    Go to Carrier Tab
    Assert EFS domain with EFS Credit Dept group
    Click to Return
    Search by Carrier ID    EFS
    Go to Carrier Tab
    Assert EFS Domain with EFS Credit Dept Group for EFS Contract

    [Teardown]    Teardown for EFS User

Check write permission with Irving Domain
    [Tags]  JIRA:PORT-710  qTest:55468775
    [Documentation]  Check for write permission when login with Irving domain with Irving Credit Dept group and searching for an Irving Contract
    [Setup]    Setup for Irving Credit Dept Only Permission

    Get Carrier from Irving Contract
    Open Browser And Login To Portal With Irving Domain
    Go to Credit Manager
    Search by Carrier ID
    Go to Carrier Tab
    Assert Irving Domain with Irving Credit Dept Group

    [Teardown]    Teardown for Irving User

Check read only permission with Irving Domain
    [Tags]  JIRA:PORT-710  qTest:55468793
    [Documentation]  Check for read only permission when login with Irving domain with all Irving groups and searching for an Irving Affiliate Billing Contract

    Get Carrier from Irving Affiliate Billing Contract
    Open Browser And Login To Portal With Irving Domain
    Go to Credit Manager
    Search by Carrier ID
    Go to Carrier Tab
    Assert Irving Domain with All Groups

*** Keywords ***
Setup for EFS Credit Dept Permission
    [Documentation]    Set True if EFS Credit Dept RO permission is needed
    [Arguments]    ${isRO}=False

    Get Into DB  MYSQL
    ${insertDate}    Get Current Date Time to Insert in DB
    Remove All Permissions in DB    ${PortalEFSUserId}    ${EFSDomainId}
    Insert Permission in DB    ${PortalEFSUserId}    ${EFSDomainId}    ${EFSEmployeeValue}    ${insertDate}
    Insert Permission in DB    ${PortalEFSUserId}    ${EFSDomainId}    ${EFSAROracle}    ${insertDate}
    Run Keyword If    '${isRO}'=='False'    Insert Permission in DB    ${PortalEFSUserId}    ${EFSDomainId}    ${EFSCreditDeptValue}    ${insertDate}
    ...    ELSE    Insert Permission in DB    ${PortalEFSUserId}    ${EFSDomainId}    ${EFSCreditDeptROValue}    ${insertDate}
    Disconnect From Database

Setup for Irving Credit Dept Only Permission
    Get Into DB  MYSQL
    ${insertDate}    Get Current Date Time to Insert in DB
    Remove All Permissions in DB    ${PortalIrvingUserId}    ${IrvingDomainId}
    Insert Permission in DB    ${PortalIrvingUserId}    ${IrvingDomainId}    ${IrvingCreditDeptPermissionValue}    ${insertDate}
    Disconnect From Database

Get Carrier from Irving Contract
    Get into DB    IRVING
    ${query}    Catenate    SELECT carrier_id
    ...    FROM contract
    ...    WHERE status = 'A'
    ...    AND credit_limit > 0
    ...    ORDER BY created DESC;
    ${carrierId}    Query and Strip    ${query}
    Set Test Variable    ${carrierId}
    Disconnect from Database

Get Carrier from Irving Affiliate Billing Contract
    Get into DB    TCH
    ${query}    Catenate    SELECT carrier_id
    ...    FROM contract
    ...    WHERE issuer_id = 194497
    ...    AND status = 'A'
    ...    AND credit_limit > 0
    ...    AND carrier_id in (SELECT carrier_id FROM contract WHERE issuer_id != 194497)
    ...    ORDER BY created DESC;
    ${carrierId}    Query and Strip    ${query}
    Set Test Variable    ${carrierId}
    Disconnect from Database

Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=15

Open Browser And Login To Portal
    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalEFSUsername}    ${PortalPassword}

Open Browser And Login To Portal With Irving Domain
    Open Browser to portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalIrvingUsername}  ${PortalPassword}

Go to Credit Manager
    Select Portal Program    Credit Manager

Click to Return
    Click Element    //div[@id='carrierview']//*[text()='Return']

Search by Carrier ID
    [Arguments]    ${type}=Irving

    Wait Until Element is Visible    name=request.search.carrierId
    Input Text    name=request.search.carrierId    ${carrierId}
    Click Portal Button  Search
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=120
    Wait Until Page Contains Element  (//*[@id="resultsTable"]//tr[contains(@key, '${type}')]//*[contains(text(), '${carrierId}')])[1]  timeout=120
    Double Click Element  (//*[@id="resultsTable"]//tr[contains(@key, '${type}')]//*[contains(text(), '${carrierId}')])[1]
    Wait Until Element Is Not Visible    //div[@id='wait_content']    timeout=180

Go to Carrier Tab
    Wait Until Element is Visible    //span[text()="Carrier"]
    Click Element    //span[text()="Carrier"]
    Wait Until Page Contains    Carrier Info

Verify If Page Contains
    [Arguments]    ${xpath}    ${isReadOnly}=True

    Run Keyword If    '${isReadOnly}'=='True'    Page Should Contain Element    ${xpath}
    ...    ELSE    Page Should Not Contain Element    ${xpath}

Contact Text Field is Read Only
    [Arguments]    ${field}    ${isReadOnly}=True    ${isCarrierInfo}=True

    ${xpath}    Run Keyword If    '${isCarrierInfo}'=='True'    Set Variable    //div[contains(text(),'Carrier Info')]//ancestor::fieldset//div[text()='${field}']/following-sibling::div/input[@class=' jreadonly']
    ...    ELSE    Set Variable    //legend[text()='Contact Information - Bill To']/parent::fieldset//div[text()='${field}']/following-sibling::div/input[@class=' jreadonly']
    Verify If Page Contains    ${xpath}    ${isReadOnly}

Text Field is Read Only
    [Arguments]    ${field}    ${isReadOnly}=True    ${isCarrierInfo}=True

    Run Keyword And Return If    '${field}'=='Address'    Verify If Page Contains    //div[text()='${field}']/following-sibling::div/textarea[@class=' jreadonly']    ${isReadOnly}
    Run Keyword And Return If    '${field}'=='Phone' or '${field}'=='Cell' or '${field}'=='Email'    Contact Text Field is Read Only    ${field}    ${isReadOnly}    ${isCarrierInfo}
    Verify If Page Contains    //div[text()='${field}']/following-sibling::div//input[@class=' jreadonly']    ${isReadOnly}

Dropdown is Disabled
    [Arguments]    ${field}    ${isDisabled}=True

    Run Keyword And Return If    '${field}'=='Status'    Verify If Page Contains    //div[contains(text(),'Carrier Info')]//ancestor::fieldset//div[text()='${field}']/following-sibling::div/select[@disabled='disabled']    ${isDisabled}
    Verify If Page Contains    //div[text()='${field}']/following-sibling::div/select[@disabled='disabled']    ${isDisabled}

Checkbox is Disabled
    [Arguments]    ${field}    ${isDisabled}=True

    Verify If Page Contains    //label[text()='${field}']/preceding-sibling::input[@disabled='disabled']    ${isDisabled}

Assert Fields Read Only in All Cases
    # Carrier Info
    Text Field is Read Only    ${carrierTypeTxtField}
    Dropdown is Disabled    ${creditGroupDropdownField}
    Dropdown is Disabled    ${salesTerritoryDropdownField}
    Text Field is Read Only    ${outsideSalesRepTxtField}
    Text Field is Read Only    ${insideSalesRepTxtField}
    Text Field is Read Only    ${accountManagerTxtField}
    Text Field is Read Only    ${phoneTxtField}
    Text Field is Read Only    ${cellTxtField}
    Text Field is Read Only    ${emailTxtField}
    Text Field is Read Only    ${createdDateTxtField}
    Text Field is Read Only    ${lastUpdatedTxtField}
    Text Field is Read Only    ${firstTransTxtField}

Assert Fields Read Only in All Cases for EFS Domain
    # Carrier Info
    Checkbox is Disabled    ${PDCACheckbox}
    Checkbox is Disabled    ${zconCheckbox}
    Checkbox is Disabled    ${useEngineOdometerCheckbox}
    Checkbox is Disabled    ${minimalPromptingCheckbox}
    Text Field is Read Only    ${lvlTxtField}
    Text Field is Read Only    ${dateTxtField}
    Text Field is Read Only    ${wexNationalIDTxtField}    False

Assert EFS Domain with EFS Credit Dept RO Group
    # Carrier Info
    Assert Fields Read Only in All Cases
    Text Field is Read Only    ${nameTxtField}
    Dropdown is Disabled    ${statusDropdownField}
    Text Field is Read Only    ${legalNameTxtField}
    Text Field is Read Only    ${renewalExpTxtField}    False
    # Contact Info
    Text Field is Read Only    ${firstNameTxtField}
    Text Field is Read Only    ${lastNameTxtField}
    Text Field is Read Only    ${departmentTxtField}
    Text Field is Read Only    ${addressTxtField}
    Text Field is Read Only    ${cityTxtField}
    Text Field is Read Only    ${stateTxtField}
    Text Field is Read Only    ${countryTxtField}
    Text Field is Read Only    ${postalCodeTxtField}
    Text Field is Read Only    ${phoneTxtField}    isCarrierInfo=False
    Text Field is Read Only    ${cellTxtField}    isCarrierInfo=False
    Text Field is Read Only    ${faxTxtField}
    Text Field is Read Only    ${emailTxtField}    isCarrierInfo=False

Assert EFS Domain with EFS Credit Dept RO Group for EFS Contract
    Assert EFS Domain with EFS Credit Dept RO Group
    Assert Fields Read Only in All Cases for EFS Domain

Assert EFS Domain with EFS Credit Dept Group
    # Carrier Info
    Assert Fields Read Only in All Cases
    Text Field is Read Only    ${nameTxtField}    False
    Dropdown is Disabled    ${statusDropdownField}    False
    Text Field is Read Only    ${legalNameTxtField}    False
    Text Field is Read Only    ${renewalExpTxtField}    False
    # Contact Info
    Text Field is Read Only    ${firstNameTxtField}    False
    Text Field is Read Only    ${lastNameTxtField}    False
    Text Field is Read Only    ${departmentTxtField}    False
    Text Field is Read Only    ${addressTxtField}    False
    Text Field is Read Only    ${cityTxtField}    False
    Text Field is Read Only    ${stateTxtField}    False
    Text Field is Read Only    ${countryTxtField}    False
    Text Field is Read Only    ${postalCodeTxtField}    False
    Text Field is Read Only    ${phoneTxtField}    False    False
    Text Field is Read Only    ${cellTxtField}    False    False
    Text Field is Read Only    ${faxTxtField}    False
    Text Field is Read Only    ${emailTxtField}    False    False

Assert EFS Domain with EFS Credit Dept Group for EFS Contract
    Assert EFS Domain with EFS Credit Dept Group
    Assert Fields Read Only in All Cases for EFS Domain
    Text Field is Read Only    ${wexNationalIDTxtField}    False

Assert Irving Domain with Irving Credit Dept Group
    # Carrier Info
    Assert Fields Read Only in All Cases
    Text Field is Read Only    ${nameTxtField}    False
    Dropdown is Disabled    ${statusDropdownField}    False
    Text Field is Read Only    ${legalNameTxtField}    False
    Text Field is Read Only    ${renewalExpTxtField}    False
    # Contact Info
    Text Field is Read Only    ${firstNameTxtField}    False
    Text Field is Read Only    ${lastNameTxtField}    False
    Text Field is Read Only    ${departmentTxtField}    False
    Text Field is Read Only    ${addressTxtField}    False
    Text Field is Read Only    ${cityTxtField}    False
    Text Field is Read Only    ${stateTxtField}    False
    Text Field is Read Only    ${countryTxtField}    False
    Text Field is Read Only    ${postalCodeTxtField}    False
    Text Field is Read Only    ${phoneTxtField}    False    False
    Text Field is Read Only    ${cellTxtField}    False    False
    Text Field is Read Only    ${faxTxtField}    False
    Text Field is Read Only    ${emailTxtField}    False    False

Assert Irving Domain with All Groups
    Page Should Contain    IRVING AFFILIATE BILLING | Irving Affiliate Billing
    # Carrier Info
    Assert Fields Read Only in All Cases
    Text Field is Read Only    ${nameTxtField}
    Dropdown is Disabled    ${statusDropdownField}
    Text Field is Read Only    ${legalNameTxtField}
    Text Field is Read Only    ${renewalExpTxtField}
    # Contact Info
    Text Field is Read Only    ${firstNameTxtField}
    Text Field is Read Only    ${lastNameTxtField}
    Text Field is Read Only    ${departmentTxtField}
    Text Field is Read Only    ${addressTxtField}
    Text Field is Read Only    ${cityTxtField}
    Text Field is Read Only    ${stateTxtField}
    Text Field is Read Only    ${countryTxtField}
    Text Field is Read Only    ${postalCodeTxtField}
    Text Field is Read Only    ${phoneTxtField}    isCarrierInfo=False
    Text Field is Read Only    ${cellTxtField}    isCarrierInfo=False
    Text Field is Read Only    ${faxTxtField}
    Text Field is Read Only    ${emailTxtField}    isCarrierInfo=False

Get Current Date Time to Insert in DB
    ${insertDate}    Get Current Date    time_zone=UTC    exclude_millis=True
    ${insertDate}    Subtract Time From Date    ${insertDate}    05:00:00.000
    [Return]    ${insertDate}

Insert Permission in DB
    [Arguments]    ${userId}    ${domainId}    ${permissionValue}    ${insertDate}

    ${query}  Catenate    INSERT INTO jpportal.user_group (userid, domain_id, group_id, upd_by, upd_dts)
    ...    VALUES ('${userId}', ${domainId}, ${permissionValue}, '${PortalEFSUsername}', '${insertDate}');
    Execute Sql String  ${query}

Remove All Permissions in DB
    [Arguments]    ${userId}    ${domainId}

    ${query}  Catenate    DELETE FROM jpportal.user_group
    ...    WHERE userid = '${userId}'
    ...    AND domain_id = ${domainId};
    Execute Sql String  ${query}

Teardown for EFS User
    [Documentation]    Set True if EFS Credit Dept RO permission was given
    [Arguments]    ${isRO}=False

    @{efsPermissions}    Create List    12    13    14    15    17    18    19    20    22    23    24    25    26    27    28    29    30    31    32    33    34    35    38    39    40    41    42    44    45    47    72    80    103    104    109
    Run Keyword If    '${isRO}'=='False'    Remove Values From List    ${efsPermissions}    27
    ...    ELSE    Remove Values From List    ${efsPermissions}    32
    Get Into DB  MYSQL
    ${insertDate}    Get Current Date Time to Insert in DB
    FOR    ${permission}    IN    @{efsPermissions}
        Insert Permission in DB    ${PortalEFSUserId}    ${EFSDomainId}    ${permission}    ${insertDate}
    END
    Disconnect From Database
    Close Browser

Teardown for Irving User
    @{irvingPermissions}    Create List    16    49    50    51    52    53    54    55    56    57    58    59    60    61    62    63    64    110
    Get Into DB  MYSQL
    ${insertDate}    Get Current Date Time to Insert in DB
    FOR    ${permission}    IN    @{irvingPermissions}
        Insert Permission in DB    ${PortalIrvingUserId}    ${IrvingDomainId}    ${permission}    ${insertDate}
    END
    Disconnect From Database
    Close Browser