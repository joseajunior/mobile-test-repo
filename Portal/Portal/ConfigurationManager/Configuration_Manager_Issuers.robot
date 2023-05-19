*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Portal  Configuration Manager

*** Test Cases ***
Issuer Contract Defaults Verify Checkboxes for Primary Inactive, Fees and Discount
    [Tags]  JIRA:PORT615  qTest:116456642  PI:14
    [Documentation]  On the Configuration Manager > Issuers > Defaults tab confirm the checkboxes for Primary Inactive,
    ...  Primary Fees and Primary Discount are present.  Also test that checkboxes can be changed and the changes are
    ...  shown in the table: contract_default.
    [Setup]  Set Up Suite

    Find Issuer
    Select Portal Program  Configuration Manager
    Click Configuration Manager Link  Issuers
    Select Issuer ID
    Validate Issuer Data Tab
    Backup Initial Checkbox Status
    Validate Defaults Tab And Checkbox Status Against Database

    [Teardown]  Return Checkboxes To Original State And Close Browser

*** Keywords ***
Backup Initial Checkbox Status
    Click On  //*[@id="issuerForm"]/div[1]/ul/li[4]/div/span
    Wait Until Page Contains  Carrier Defaults
    ${primaryInactiveStart}  Get Value  //*[@name="__request.contDef.prInactive"]
    Set Test Variable  ${primaryInactiveStart}
    ${primaryFeesStart}  Get Value  //*[@name="__request.contDef.feePrmCont"]
    Set Test Variable  ${primaryFeesStart}
    ${primaryDiscountStart}  Get Value  //*[@name="__request.contDef.dscPrmCont"]
    Set Test Variable  ${primaryDiscountStart}

Field Should Not Be Blank ${field}
    IF  '${field}'==''
        Find Issuer
        Click On  //*[@id="issuerForm"]/a[2]/div/span[1]
        Wait Until Element Contains  //*[@id="issuersList"]/tbody/tr[1]/td[2]/div/table/tbody/tr/th[1]/div  Issuer ID
        Select Issuer ID
        Validate Issuer Data Tab
    END

Find Issuer
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT issuer_id
    ...  FROM issuer_misc
    ...  WHERE issuer_group_id IN ((SELECT issuer_group_id
    ...                             FROM issuer_group
    ...                             WHERE ifx_instance = 'TCH'));
    ${issuer}  Find Random Row From Query  ${query}  column=issuer_id
    Set Test Variable  ${issuer}

Get Database Status For ${column1} ${column2} ${column3}
    Get Into DB  TCH
    ${query}  Catenate
    ...  SELECT ${column1}, ${column2}, ${column3}
    ...  FROM contract_default
    ...  WHERE issuer_id = ${issuer};
    ${result}  query and strip to dictionary  ${query}
    Set Test Variable  ${columnValue1}  ${result["${column1}"]}
    Set Test Variable  ${columnValue2}  ${result["${column2}"]}
    Set Test Variable  ${columnValue3}  ${result["${column3}"]}

Log Into Portal Successfully
    [Arguments]    ${username}    ${passwd}

    Log Into Portal    ${username}    ${passwd}
    Wait Until Element is Visible    //div[@id='pmd_home']    timeout=5

Return Checkboxes To Original State And Close Browser
    Wait Until Element Contains  //*[@id="issuersList"]/tbody/tr[1]/td[2]/div/table/tbody/tr/th[1]/div  Issuer ID
    Select Issuer ID
    Click On  //*[@id="issuerForm"]/div[1]/ul/li[4]/div/span
    Wait Until Page Contains  Carrier Defaults
    Run Keyword If  '${primaryInactiveStart}'=='Y'  Select Checkbox  //*[@name="__request.contDef.prInactive"]
    Run Keyword If  '${primaryFeesStart}'=='Y'  Select Checkbox  //*[@name="__request.contDef.feePrmCont"]
    Run Keyword If  '${primaryDiscountStart}'=='Y'  Select Checkbox  //*[@name="__request.contDef.dscPrmCont"]
    Click On  //*[@id="issuerForm"]/a[1]/div/span[1]
    Wait Until Element Contains  //*[@id="issuersList"]/tbody/tr[1]/td[2]/div/table/tbody/tr/th[1]/div  Issuer ID
    Close Browser

Select Issuer ID
    Wait Until Element Contains  //*[@id="issuersList"]/tbody/tr[1]/td[2]/div/table/tbody/tr/th[1]/div  Issuer ID
    Click Element  //*[@class="jtd" and text()="${issuer}"]
    Click Element  //*[@id="issuers_content"]//*[text()="Edit"]
    Wait Until Done Processing

Set Checkboxes to Checked
    Select Checkbox  //*[@name="__request.contDef.prInactive"]
    Select Checkbox  //*[@name="__request.contDef.feePrmCont"]
    Select Checkbox  //*[@name="__request.contDef.dscPrmCont"]
    Click On  //*[@id="issuerForm"]/a[1]/div/span[1]
    Wait Until Done Processing

Set Checkboxes To Unchecked
    Unselect Checkbox  //*[@name="__request.contDef.prInactive"]
    Unselect Checkbox  //*[@name="__request.contDef.feePrmCont"]
    Unselect Checkbox  //*[@name="__request.contDef.dscPrmCont"]
    Click On  //*[@id="issuerForm"]/a[1]/div/span[1]
    Wait Until Done Processing

Set Up Suite
    Open Browser to Portal
    Wait Until Keyword Succeeds    5 x    5 s    Log Into Portal Successfully    ${PortalUsername}  ${PortalPassword}

Validate Defaults Tab And Checkbox Status Against Database
    Click On  //*[@id="issuerForm"]/div[1]/ul/li[4]/div/span
    Wait Until Page Contains  Carrier Defaults
    ${accountDescriptor}  Get Value  //*[@id="abc" and @name="request.contDef.mgrCode"]
    Run keyword if  '${accountDescriptor}'==''  Select From List By Value  //*[@id="abc" and @name="request.contDef.mgrCode"]  1CHK
    Set Checkboxes to Checked
    Validate Primary Inactive= Y Primary Fees= P And Primary Discount= P
    Select Issuer ID
    Click On  //*[@id="issuerForm"]/div[1]/ul/li[4]/div/span
    Wait Until Page Contains  Carrier Defaults
    Set Checkboxes To Unchecked
    Validate Primary Inactive= N Primary Fees= S And Primary Discount= S

Validate Issuer Data Tab
    Element Should Be Enabled  //*[@id="abc" and @name="request.issuer.status"]
    ${status}  Get Value  //*[@id="abc" and @name="request.issuer.status"]
    Field Should Not Be Blank ${status}
    ${issrGrp}  Get Value  //*[@id="issGrpId"]
    Field Should Not Be Blank ${issrGrp}
    ${issrName}  Get Value  //*[@name="request.issuer.name"]
    Field Should Not Be Blank ${issrName}
    ${shortName}  Get Value  //*[@name="request.issuer.shortName"]
    Field Should Not Be Blank ${shortName}
    ${refId}  Get Value  //*[@name="request.issuer.issRefid"]
    Field Should Not Be Blank ${refId}
    ${firstName}  Get Value  //*[@name="request.issuer.contFname"]
    Field Should Not Be Blank ${firstName}
    ${lastName}  Get Value  //*[@name="request.issuer.contLname"]
    Field Should Not Be Blank ${lastName}
    ${address}  Get Text  //*[@name="request.issuer.address"]
    Field Should Not Be Blank ${address}
    ${city}  Get Value  //*[@name="request.issuer.city"]
    Field Should Not Be Blank ${city}
    ${state}  Get Value  //*[@name="request.issuer.state"]
    Field Should Not Be Blank ${state}
    ${postalCode}  Get Value  //*[@name="request.issuer.zip"]
    Field Should Not Be Blank ${postalCode}
    ${phone}  Get Value  //*[@name="request.issuer.contPhone"]
    Field Should Not Be Blank ${phone}

Validate Primary Inactive= ${status1} Primary Fees= ${status2} And Primary Discount= ${status3}
    Get Database Status For prinactive feeprmcont dscprmcont
    Should Be Equal  ${status1}  ${columnValue1}
    Should Be Equal  ${status2}  ${columnValue2}
    Should Be Equal  ${status3}  ${columnValue3}