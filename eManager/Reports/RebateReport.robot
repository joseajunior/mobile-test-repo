*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Setup for Parent Carrier Report
Suite Teardown  Turn ON Excel Report Flag to xls/xlsx.

Force Tags  eManager  Reports  Rebate Report

*** Variables ***
${card}
${carrier}
${contract_id}
${db_data}
${excel_data}
${excelFile}
${last_trans_date}
${permission_status}
${report_name}  RebateReport
${report_format}
${size_db_data}

*** Test Cases ***

Rebate Report - Type 54
    [Documentation]  Create an Immediate Report for Rebate Report Type 54, download and validate.
    [Tags]  JIRA:FRNT-1146  JIRA:BOT-3299  PI:7    refactor    #Does not have good data on AWS_DIT

    Log into eManager with a Carrier that have Rebate Report Permission;
    Navigate to Select Program > Reports/Exports > Rebate Report;
    Select 'Immediate Report';
    Select Excel as Report Format;
    Set Report Date;
    Select Rebate Type 54 Option;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Get Rebate Report Excel Data;
    Get Rebate Report Data From DB;
    Compare Rebate Report Excel Data With Database;

    [Teardown]  Teardown for Rebate Report

*** Keywords ***
Setup for Parent Carrier Report
    [Documentation]  Keyword Setup for Parent Carrier Report

    Turn OFF Excel Report Flag to xls/xlsx.  #this should be temporary and will be remove in a near future, I hope so!

    Get Into DB  MySQL

#Get user_id from the last 100 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 100;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT distinct crd.carrier_id FROM carrier_rebate_def crd
    ...    JOIN transaction t ON crd.carrier_id=t.carrier_id
    ...    WHERE rebate_type = 54;

    ${carrier}  Find Carrier Variable  ${query}  carrier_id

    Ensure Carrier has User Permission  ${carrier.id}  REBATE_REPORT

    Set Suite Variable  ${carrier}

    #log to console  ${carrier.id}

    Get Last Transaction Date and Contract ID for Rebate Report

Turn ${value} Excel Report Flag to xls/xlsx.
    [Documentation]  This keyword will change the excel report format to xlsx if flag is ON and xls if flag is OFF.
    ...  This is a measure to deal with reports while we dont have support to xlsx files.

    Get Into DB  MySQL

    ${flag}  Set Variable If  '${value}'=='ON'  Y  N

    Execute SQL String  dml=UPDATE setting SET value = '${flag}' WHERE `PARTITION` = 'shared' AND name = 'com.tch.export.xlsx';

Teardown for Rebate Report
    [Documentation]  Teardown for Rebate Report.

    Close Browser
    Remove Report File  ${report_name}

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  REBATE_REPORT

Get Last Transaction Date and Contract ID for Rebate Report
    [Documentation]

    Get Into DB    TCH

    ${query}    Catenate    SELECT DISTINCT a.trans_id,
    ...    a.trans_date,
    ...    TO_CHAR(a.trans_date,'%Y-%m-%d') AS date,
    ...    a.contract_id,
    ...    a.invoice,
    ...    a.carrier_id,
    ...    substr(a.card_num,length(a.card_num) - 3,4) card_num,
    ...    a.location_id,
    ...    a.pref_total,
    ...    CASE
    ...    WHEN (SELECT CASE
    ...    WHEN cm.rebate_meta_data BETWEEN a.minimum AND a.maximum THEN (0.2*cm.rebate_meta_data)
    ...    ELSE (0.0*cm.rebate_meta_data)
    ...    END AS rebate_amt
    ...    FROM carrier_rebate_amt ca,
    ...    carrier_rebate_amt_meta cm,
    ...    (SELECT ct.minimum,
    ...    ct.maximum,
    ...    cs.carrier_id,
    ...    cs.contract_id,
    ...    ct.rebate_fee
    ...    FROM carrier_rebate_tier_set cs,
    ...    carrier_rebate_tier ct
    ...    WHERE ct.tier_set = cs.tier_set
    ...    AND cs.rebate_type = 54
    ...    AND ct.tier_level = 2
    ...    AND cs.carrier_id = '${carrier.id}'
    ...    AND cs.contract_id =0) a
    ...    WHERE ca.rebate_id = cm.rebate_id
    ...    AND cm.rebate_meta_type_id = 2
    ...    AND ca.carrier_id = a.carrier_id
    ...    AND ca.contract_id = a.contract_id
    ...    AND ca.rebate_date = DATE (last_day((to_date('2019-01-01 00:00','%Y-%m-%d %H:%M'))) + 1 UNITS DAY)) > 0.0 THEN (0.2 * b.qty)
    ...    ELSE (0.0 * b.qty)
    ...    END AS rebate_amt,
    ...    b.qty
    ...    FROM TRANSACTION a,
    ...    trans_line b
    ...    WHERE a.supplier_id = 338063    #Exxon Supplier ID necessary for Rebate 54
    ...    AND a.trans_id = b.trans_id
    ...    AND b.group_cat IN ('DSL','ULSD','GAS','RFR')
    ...    AND a.trans_date BETWEEN '2019-01-01 00:00' AND TODAY
    ...    AND a.carrier_id = '${carrier.id}'
    ...    AND (a.contract_id = 0 or 0 = 0)
    ...    ORDER BY trans_date DESC LIMIT 1;

    ${query}    Query And Strip to Dictionary    ${query}
    Set Suite Variable    ${last_trans_date}    ${query['date']}
    Set Suite Variable    ${contract_id}    ${query['contract_id']}

Log into eManager with a Carrier that have Rebate Report Permission;
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Reports/Exports > Rebate Report;
    [Documentation]  Go to Desired Page
    Go To  ${emanager}/cards/RebateReport.action

Select '${report_type}';

    Click Element  //input[@title='${report_type}']

Set Report Date;
    [Documentation]  Keyword to Set Rebate Date.

    Input Text    //input[@name='startDate']    ${last_trans_date}

Select Rebate Type 54 Option;
    [Documentation]  Keyword to Select Rebate Type 54 Option.

    ${status}    Run Keyword And Return Status   Element Should be Visible    //option[contains(@value,'${contract_id} - 54 - Rebates per gallon')]

    Run Keyword If    '${status}'=='True'
    ...    Select From List By Value    longDescSel    ${contract_id} - 54 - Rebates per gallon    #description is on carrier_rebate_type
    ...    ELSE    Select From List By Value    longDescSel    All - 54 - Rebates per gallon    #description is on carrier_rebate_type

Select ${report_format} as Report Format;
    [Documentation]  Options are Excel or CSV

    Select From List By label  viewFormat  ${report_format}

    Set Test Variable  ${report_format}

Download Excel Report File;
    [Documentation]  Keyword to download excel format file

    ${excelFile}  Download Report File  ${Report_Name}  xls

    Set Test Variable  ${excelFile}

Verify if Excel Report is Downloaded;
    [Documentation]  Keyword to check if excel Report is downloaded

    Assert if File is Dowloaded  ${report_name}.xls

Get Rebate Report Excel Data;
    [Documentation]  Keyword to get data from excel file.

    ${excel_data}  Get Values From Excel Rows  ${excelFile}
#
    :FOR  ${i}  IN  @{excel_data}
    \  ${date}  Get From Dictionary  ${i}  date
    \  ${date}  Excel Date To String  ${date}  %Y-%m-%d %H:%M:%S
    \  Set To Dictionary  ${i}  date=${date}

    #log to console  ${excel_data[0]}

    Set Test Variable  ${excel_data}

Get Rebate Report Data From DB;
    [Documentation]  Keyword to get data from database.

    Get Into DB    TCH

    ${query}    Catenate    SELECT DISTINCT a.trans_id,
    ...    a.trans_date,
    ...    a.invoice,
    ...    a.carrier_id,
    ...    substr(a.card_num,length(a.card_num) - 3,4) card_num,
    ...    a.location_id,
    ...    a.pref_total,
    ...    CASE
    ...    WHEN (SELECT CASE
    ...    WHEN cm.rebate_meta_data BETWEEN a.minimum AND a.maximum THEN (0.2*cm.rebate_meta_data)
    ...    ELSE (0.0*cm.rebate_meta_data)
    ...    END AS rebate_amt
    ...    FROM carrier_rebate_amt ca,
    ...    carrier_rebate_amt_meta cm,
    ...    (SELECT ct.minimum,
    ...    ct.maximum,
    ...    cs.carrier_id,
    ...    cs.contract_id,
    ...    ct.rebate_fee
    ...    FROM carrier_rebate_tier_set cs,
    ...    carrier_rebate_tier ct
    ...    WHERE ct.tier_set = cs.tier_set
    ...    AND cs.rebate_type = 54
    ...    AND ct.tier_level = 2
    ...    AND cs.carrier_id = '${carrier.id}'
    ...    AND cs.contract_id =0) a
    ...    WHERE ca.rebate_id = cm.rebate_id
    ...    AND cm.rebate_meta_type_id = 2
    ...    AND ca.carrier_id = a.carrier_id
    ...    AND ca.contract_id = a.contract_id
    ...    AND ca.rebate_date = DATE (last_day((to_date('${last_trans_date} 00:00','%Y-%m-%d %H:%M'))) + 1 UNITS DAY)) > 0.0 THEN (0.2 * b.qty)
    ...    ELSE (0.0 * b.qty)
    ...    END AS rebate_amt,
    ...    b.qty
    ...    FROM TRANSACTION a,
    ...    trans_line b
    ...    WHERE a.supplier_id = 338063    #Exxon Supplier ID necessary for Rebate 54
    ...    AND a.trans_id = b.trans_id
    ...    AND b.group_cat IN ('DSL','ULSD','GAS','RFR')
    ...    AND a.trans_date BETWEEN '${last_trans_date} 00:00' AND TODAY
    ...    AND a.carrier_id = '${carrier.id}'
    ...    AND (a.contract_id = 0 or 0 = 0)

    ${db_data}  Query To Dictionaries  ${query}
    ${size_db_data}  Get List Size  ${db_data}

    Set Test Variable    ${db_data}
    Set Test Variable    ${size_db_data}

Compare Rebate Report Excel Data With Database;
    [Documentation]  Compare Rebate Report Excel Data With Database.
#
    :FOR  ${i}  IN RANGE  0  ${size_db_data}
      #log to console  ${db_data[${i}]} ${excel_data[${i}]}
      Should be Equal as Strings  ${db_data[${i}]['trans_id']}  ${excel_data[${i}]['trans_id']}
      Should be Equal as Strings  ${db_data[${i}]['trans_date']}  ${excel_data[${i}]['date']}
      Should be Equal as Strings  ${db_data[${i}]['invoice']}  ${excel_data[${i}]['invoice']}
      Should be Equal as Strings  ${db_data[${i}]['carrier_id']}  ${excel_data[${i}]['carrier_id']}
      Should be Equal as Strings  ${db_data[${i}]['card_num']}  ${excel_data[${i}]['card_num']}
      Should be Equal as Strings  ${db_data[${i}]['location_id']}  ${excel_data[${i}]['location_id']}
      Should be Equal as Numbers  ${db_data[${i}]['pref_total']}  ${excel_data[${i}]['amount']}
      Should be Equal as Numbers  ${db_data[${i}]['rebate_amt']}  ${excel_data[${i}]['total_rebate']}
      Should be Equal as Numbers  ${db_data[${i}]['qty']}  ${excel_data[${i}]['quantity']}
    END
