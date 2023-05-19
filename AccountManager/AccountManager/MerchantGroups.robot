*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot


Force Tags  AM  refactor

*** Test Cases ***
Add Groups To A Merchant Groups
    [Tags]  JIRA:BOT-1390  qTest:32152839  WASBUGGED: It is impossible to find any records when trying to add a merchant group.  Regression
    [Documentation]  Using ${carrier_id} in Account Manager

    Get Into DB  TCH
    ${MerchantInfo}  Query And Strip To Dictionary  SELECT dc.* , lg.name FROM def_loc_grp dc, loc_grp lg, member m WHERE dc.carrier_id=m.member_id AND m.tran_update='Y' AND lg.carrier_id=dc.carrier_id limit 1;

    Open eManager  ${intern}  ${internPassword}
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${MerchantInfo["carrier_id"]}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${MerchantInfo["carrier_id"]}
    Click On  text=Policies
    double click on  text=Submit  exactMatch=False  index=2
    Click On  text=${MerchantInfo["ipolicy"]}
    Check Element Exists  text=${MerchantInfo["carrier_id"]}
    Click On  text=Merchant Groups
    Click On  text=ADD  timeout=20
    Check Element Exists  text=Merchant Group Name

    Input Text  //*[@id="policyMerchantGroupsAvailableSearchContainer"]//*[@name="merchantGroupName"]  Anything
    Click On  //*[@id="policyMerchantGroupsAddEditFormButtons"]//*[@id="submit"]
    Page Should Contain   Please select at least one record.

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Unauthorize A Location
    [Tags]  JIRA:BOT-1386  qTest:32444280  Regression
    [Documentation]  Unauthorize a Location From a Merchant Group

#   CHECK IF CARRIER HAS tran_update='Y' SO THAT IT HAS ACCESS TO MERCHANT GROUPS TAB.
    Get Into DB  TCH
    ${MerchantInfo}  catenate  SELECT dc.*, lg.name, lge.location_id
    ...     FROM def_loc_grp dc, loc_grp lg, loc_grp_exp lge, member m
    ...     WHERE dc.carrier_id=m.member_id AND m.tran_update='Y' AND lg.carrier_id=dc.carrier_id AND lge.grp_id=lg.grp_id limit 1;
    ${MerchantInfo}  Query And Strip To Dictionary  ${MerchantInfo}

#   CHECK IF THERE'S A RECORD FOR THE LOCATION IN THE DEF_LOCS TABLE. IF THERE IS, DELETE IT.
    ${status}  Run Keyword And Return Status   Row Count Is Equal To X  SELECT * FROM def_locs WHERE location_id=${MerchantInfo["location_id"]} AND carrier_id=${MerchantInfo["carrier_id"]}  0
    Run Keyword IF  '${status}'=='${true}'  Tch Logging  ${MerchantInfo["location_id"]} LOCATION IS AUTHORIZED.
    ...     ELSE  Execute SQL String  dml=DELETE FROM def_locs WHERE carrier_id = ${MerchantInfo["carrier_id"]} AND location_id = ${MerchantInfo["location_id"]} AND ipolicy = ${MerchantInfo["ipolicy"]}

    Open eManager  ${intern}  ${internPassword}
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${MerchantInfo["carrier_id"]}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${MerchantInfo["carrier_id"]}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${MerchantInfo["ipolicy"]}
    Check Element Exists  text=${MerchantInfo["carrier_id"]}
    Click On  text=Merchant Groups
    Wait Until Page Contains Element  //*[@id="policyMerchantGroupsSearchContainer"]//*[@class="button searchSubmit"]  timeout=30
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${MerchantInfo["name"]}
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  //*[@value="${MerchantInfo["location_id"]}"]
    Double Click On  text=STATUS UPDATE
    Click On  text=Confirm
    Check Element Exists  text=Merchant Authorization changes were updated.
    Row Count Is Equal To X  SELECT * FROM def_locs WHERE location_id=${MerchantInfo["location_id"]} AND carrier_id=${MerchantInfo["carrier_id"]}  1

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Authorize A Location
    [Tags]  JIRA:BOT-1387  qTest:32444265  Regression
    [Documentation]  Authorize a Location From a Merchant Group

    Get Into DB  TCH
    ${MerchantInfo}  catenate  SELECT dc.*, lg.name, lge.location_id
    ...     FROM def_loc_grp dc, loc_grp lg, loc_grp_exp lge, member m
    ...     WHERE dc.carrier_id=m.member_id AND m.tran_update='Y' AND lg.carrier_id=dc.carrier_id AND lge.grp_id=lg.grp_id limit 1;
    ${MerchantInfo}  Query And Strip To Dictionary  ${MerchantInfo}

#   CHECK IF THERE'S NO RECORD FOR THE LOCATION IN THE DEF_LOCS TABLE. IF THERE IS, INSERT IT.
    ${status}  Run Keyword And Return Status   Row Count Is Equal To X  SELECT * FROM def_locs WHERE location_id=${MerchantInfo["location_id"]} AND carrier_id=${MerchantInfo["carrier_id"]}  1
    Run Keyword IF  '${status}'=='${true}'  Tch Logging  LOCATION ${MerchantInfo["location_id"]} IS UNAUTHORIZED.
    ...     ELSE  Execute SQL String  dml=INSERT INTO def_locs (carrier_id, location_id, ipolicy) VALUES (${MerchantInfo["carrierId"]}, ${MerchantInfo["location_id"]}, ${MerchantInfo["ipolicy"]})

    Open eManager  ${intern}  ${internPassword}
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${MerchantInfo["carrier_id"]}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${MerchantInfo["carrier_id"]}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${MerchantInfo["ipolicy"]}
    Check Element Exists  text=${MerchantInfo["carrier_id"]}
    Click On  text=Merchant Groups
    Wait Until Page Contains Element  //*[@id="policyMerchantGroupsSearchContainer"]//*[@class="button searchSubmit"]  timeout=30
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${MerchantInfo["name"]}
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  //*[@value="${MerchantInfo["location_id"]}"]
    Double Click On  text=STATUS UPDATE
    Click On  text=Confirm
    Check Element Exists  text=Merchant Authorization changes were updated.
    Row Count Is Equal To X  SELECT * FROM def_locs WHERE location_id=${MerchantInfo["location_id"]} AND carrier_id=${MerchantInfo["carrier_id"]}  0

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Apply Filters When Editing The Merchant Group Locations
    [Tags]  JIRA:BOT-1388  JIRA:BOT-1965  qTest:32444328  Regression
    [Documentation]  Apply Filters When Editing The Merchant Group Locations

    Get Into DB  TCH
    ${MerchantInfo}  catenate  SELECT dc.*, lg.name, lge.location_id, l.city
    ...     FROM def_loc_grp dc, loc_grp lg, loc_grp_exp lge, location l, member m
    ...     WHERE dc.carrier_id = m.member_id AND lg.carrier_id=dc.carrier_id AND m.tran_update = 'Y'
    ...     AND l.location_id = lge.location_id AND lge.grp_id = lg.grp_id limit 1
    ${MerchantInfo}  Query And Strip To Dictionary  ${MerchantInfo}

    Open eManager  ${intern}  ${internPassword}
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${MerchantInfo["carrier_id"]}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${MerchantInfo["carrier_id"]}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${MerchantInfo["ipolicy"]}
    Check Element Exists  text=${MerchantInfo["carrier_id"]}
    Click On  text=Merchant Groups
    Wait Until Page Contains Element  //*[@id="policyMerchantGroupsSearchContainer"]//*[@class="button searchSubmit"]  timeout=30
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${MerchantInfo["name"]}
    Double Click On  text=Reset  exactMatch=False  index=2
    Input Text  merchantNumber  ${MerchantInfo["location_id"]}
    Press Key  merchantNumber  \\13    #ASCII code for ENTER key
    Check Element Exists  text=${MerchantInfo["location_id"]}
    Clear Element Text  merchantNumber
    Input Text  city  ${MerchantInfo["city"]}
    Press Key  city  \\13         #ASCII code for ENTER key
    Check Element Exists  text=${MerchantInfo["location_id"]}

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

SELECT ALL Button Works
    [Tags]  JIRA:BOT-1389  qTest:32444422  Regression
    [Documentation]  Make sure the Select All button Works

    Get Into DB  TCH
        ${MerchantInfo}  catenate  SELECT dc.*, lg.name, lge.location_id, l.city
    ...     FROM def_loc_grp dc, loc_grp lg, loc_grp_exp lge, location l, member m
    ...     WHERE dc.carrier_id = m.member_id AND lg.carrier_id=dc.carrier_id AND m.tran_update = 'Y'
    ...     AND l.location_id = lge.location_id AND lge.grp_id = lg.grp_id limit 1
    ${MerchantInfo}  Query And Strip To Dictionary  ${MerchantInfo}

    #   GET THE LOCATIONS
    ${locationID}  Query And Strip To Dictionary  SELECT lge.location_id FROM loc_grp_exp lge, loc_grp lg WHERE lge.grp_id=lg.grp_id AND lg.carrier_id=${MerchantInfo["carrier_id"]} AND lg.name='${MerchantInfo["name"]}';

    Open eManager  ${intern}  ${internPassword}
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${MerchantInfo["carrier_id"]}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${MerchantInfo["carrier_id"]}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${MerchantInfo["ipolicy"]}
    Check Element Exists  text=${MerchantInfo["carrier_id"]}
    Click On  text=Merchant Groups
    Wait Until Page Contains Element  //*[@id="policyMerchantGroupsSearchContainer"]//*[@class="button searchSubmit"]  timeout=30
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=${MerchantInfo["name"]}
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  text=SELECT ALL
    Element Should Be Disabled  //*[@value="${locationID['location_id'][0]}"]
    Element Should Be Disabled  //*[@value="${locationID['location_id'][1]}"]
    Element Should Be Disabled  //*[@value="${locationID['location_id'][2]}"]
    Element Should Be Disabled  //*[@value="${locationID['location_id'][3]}"]
    Element Should Be Disabled  //*[@value="${locationID['location_id'][4]}"]
    Element Should Be Disabled  //*[@value="${locationID['location_id'][5]}"]
    Element Should Be Disabled  //*[@value="${locationID['location_id'][6]}"]

    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database

Remove Groups To A Merchant Groups
    [Tags]  JIRA:BOT-1392  qTest:32150270  Regression
    [Documentation]

    Get Into DB  TCH
    ${MerchantInfo}  catenate  SELECT dc.*, lg.name, lge.location_id, l.city
    ...     FROM def_loc_grp dc, loc_grp lg, loc_grp_exp lge, location l, member m
    ...     WHERE dc.carrier_id = m.member_id AND lg.carrier_id=dc.carrier_id AND m.tran_update = 'Y'
    ...     AND l.location_id = lge.location_id AND lge.grp_id = lg.grp_id limit 1
    ${MerchantInfo}  Query And Strip To Dictionary  ${MerchantInfo}

    Open eManager  ${intern}  ${internPassword}
    Maximize Browser Window
    Hover Over  text=Select Program  timeout=3
    Hover Over  text=Account Management
    Click On  text=Account Manager
    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${MerchantInfo["carrier_id"]}
    Double Click On  text=Submit  exactMatch=False
    Click On  text=${MerchantInfo["carrier_id"]}
    Click On  text=Policies
    Double Click On  text=Submit  exactMatch=False  index=2
    Click On  text=${MerchantInfo["ipolicy"]}
    Check Element Exists  text=${MerchantInfo["carrier_id"]}
    Click On  text=Merchant Groups
    Wait Until Page Contains Element  //*[@id="policyMerchantGroupsSearchContainer"]//*[@class="button searchSubmit"]  timeout=30
    Double Click On  text=Reset  exactMatch=False  index=2
    Click On  //*[@value="${MerchantInfo["grp_id"]}"]
    Click On  text=DELETE
    Click On  text=Confirm
    Check Element Exists  text=Delete Successful

    Get Into DB  TCH
    Execute SQL String  dml=INSERT INTO def_loc_grp (carrier_id, policy, grp_id, ipolicy) VALUES (${MerchantInfo["carrier_id"]}, NULL, ${MerchantInfo["grp_id"]}, ${MerchantInfo["ipolicy"]})

    Double Click On  text=Reset  exactMatch=False  index=2
    Check Element Exists  text=${MerchantInfo["name"]}
    [Teardown]  Run Keywords  Close Browser
    ...     AND  Disconnect From Database


*** Keywords ***
