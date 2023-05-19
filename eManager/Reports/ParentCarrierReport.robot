*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/ReportKeywords.robot

Suite Setup  Setup for Parent Carrier Report
Suite Teardown  Turn ON Excel Report Flag to xls/xlsx

Force Tags  eManager  Reports  Parent Carrier Report

*** Variables ***
${card}
${carrier}
${db_data}
${excel_data}
${excelFile}
${permission_status}
${report_name}  ParentCarrierReport
${report_format}
${db_data_1}
${db_data_2}
${size_db_data_1}
${size_db_data_2}

*** Test Cases ***

Parent Carrier Report - Immediate Report
    [Documentation]  Create an Immediate Report for Parent Carrier Report, download and validate.
    [Tags]  JIRA:FRNT-1115  JIRA:FRNT-1180  JIRA:FRNT-1203  JIRA:FRNT-1223  qTest:48758856  JIRA:BOT-3253  JIRA:BOT-3277  JIRA:BOT-3278  JIRA:BOT-3279  PI:7

    Log into eManager with a Carrier that have Parent Carrier Report Permission;
    Navigate to Select Program > Reports/Exports > Parent Carrier Report;
    Select 'Immediate Report';
    Select Excel as Report Format;
    Download Excel Report File;
    Verify if Excel Report is Downloaded;
    Get Parent Carrier Report Excel Data;
    Get Parent Carrier Data From DB;
    Compare Parent Carrier Report Excel Data With Database;

    [Teardown]  Teardown for Parent Carrier Report

*** Keywords ***
Setup for Parent Carrier Report
    [Documentation]  Keyword Setup for Parent Carrier Report

    Turn OFF Excel Report Flag to xls/xlsx  #this should be temporary and will be remove in a near future, I hope so!

    Get Into DB  MySQL

#Get user_id from the last 250 logged to avoid mysql error.
    ${query}  Catenate  SELECT user_id FROM sec_user WHERE user_id REGEXP '^[0-9]+$' ORDER BY login_attempted DESC LIMIT 250;
    ${list}  Query And Strip To Dictionary  ${query}
    ${list_2}  Get From Dictionary  ${list}  user_id
    ${list_2}  Evaluate  ${list_2}.__str__().replace('[','(').replace(']',')')

    ${query}  Catenate  SELECT DISTINCT(parent) FROM carrier_group_xref cgx
    ...  WHERE cgx.parent IN ${list_2}
    ...  AND cgx.parent NOT IN ('103866','700001','308385','146567')  #Bad Carrier for this test
    ...  AND (SELECT count(*) FROM carrier_group_xref WHERE parent=cgx.parent) < 10;  #This is to not pick a carrier with multiple childs, I'm trying to make the test fast

    ${carrier}  Find Carrier Variable  ${query}  parent

    Ensure Carrier has User Permission  ${carrier.id}  PARENT_CARRIER_REPORT

    Set Suite Variable  ${carrier}

    #log to console  ${carrier.id}

Turn ${value} Excel Report Flag to xls/xlsx
    [Documentation]  This keyword will change the excel report format to xlsx if flag is ON and xls if flag is OFF.
    ...  This is a measure to deal with reports while we dont have support to xlsx files.

    Get Into DB  MySQL

    ${flag}  Set Variable If  '${value}'=='ON'  Y  N

    Execute SQL String  dml=UPDATE setting SET value = '${flag}' WHERE `PARTITION` = 'shared' AND name = 'com.tch.export.xlsx';

Teardown for Parent Carrier Report
    [Documentation]  Teardown for Parent Carrier Report.

    Close Browser
    Remove Report File  ${report_name}

    Run Keyword If  '${permission_status}'=='True'
    ...  Remove Carrier User Permission  ${carrier.id}  PARENT_CARRIER_REPORT

Log into eManager with a Carrier that have Parent Carrier Report Permission;
    [Documentation]  Login on Emanager

    Open eManager  ${carrier.id}  ${carrier.password}

Navigate to Select Program > Reports/Exports > Parent Carrier Report;
    [Documentation]  Go to Desired Page
    Go To  ${emanager}/cards/ParentCarrierReport.action

Select '${report_type}';

    Click Element  //input[@title='${report_type}']

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

Get Parent Carrier Report Excel Data;
    [Documentation]  Keyword to get data from excel file.

    ${excel_data}  Get Values From Excel Rows  ${excelFile}
#
    FOR  ${i}  IN  @{excel_data}
      ${created_date}  Get From Dictionary  ${i}  created_date
      ${created_date}  Excel Date To String  ${created_date}  %Y-%m-%d
      Set To Dictionary  ${i}  created_date=${created_date}
    END
    #log to console  ${excel_data[0]}

    Set Test Variable  ${excel_data}

Get Parent Carrier Data From DB;
    [Documentation]  Keyword to get data from database.

    Get Data From carrier_group_xref
    Get Data From carrier_referral_xref

Get Data From carrier_group_xref
    [Documentation]  This keyword will get lines from carrier_group_xref table.

    Get Into DB  TCH

    ${query}  Catenate  SELECT DISTINCT cgx.carrier_id
    ...  ,CASE WHEN (m.alt_carrier_id IS NULL OR m.alt_carrier_id=0) THEN cgx.carrier_id ELSE m.alt_carrier_id END AS alt_carrier_id
    ...  ,TRIM(nvl(m.name,'')) AS carrier_name
    ...  ,m.created AS created_date
    ...  ,TRIM(nvl(c.city, '')) AS city
    ...  ,nvl(c.state,'') AS state
    ...  ,nvl(m.cont_fname,'') || ' ' || nvl(m.cont_lname,'') AS primary_contact
    ...  ,nvl(c.email,'') AS primary_email
    ...  ,COALESCE(df.fee_amt,0.0) AS monthly_card_fee
    ...  ,COALESCE(cm.orig_limit,0.0) AS credit_limit
    ...  ,CASE WHEN (db.status='A') THEN 'Y' ELSE 'N' END AS direct_bill
    ...  ,TRIM(nvl(cc.terms,'')) AS terms
    ...  ,TRIM(cc.ar_number) AS ar_number
    ...  ,cc.status AS contract_status
    ...  ,(COALESCE(c_p1_f1.fee_adder, 0.0) + COALESCE(p_p1_f1.fee_adder, 0.0)) as ftid1ExtendedP1AllProds
    ...  ,(COALESCE(c_p2_f1.fee_adder, 0.0) + COALESCE(p_p2_f1.fee_adder, 0.0)) as ftid1ExtendedP2Cash
    ...  ,(COALESCE(c_p3_f1.fee_adder, 0.0) + COALESCE(p_p3_f1.fee_adder, 0.0)) as ftid1ExtendedP3Fuel
    ...  ,(COALESCE(c_p4_f1.fee_adder, 0.0) + COALESCE(p_p4_f1.fee_adder, 0.0)) as ftid1ExtendedP4FuelCash
    ...  ,(COALESCE(c_p1_f2.fee_adder, 0.0) + COALESCE(p_p1_f2.fee_adder, 0.0)) as ftid2InNetwrokP1AllProds
    ...  ,(COALESCE(c_p2_f2.fee_adder, 0.0) + COALESCE(p_p2_f2.fee_adder, 0.0)) as ftid2InNetwrokP2Cash
    ...  ,(COALESCE(c_p3_f2.fee_adder, 0.0) + COALESCE(p_p3_f2.fee_adder, 0.0)) as ftid2InNetwrokP3Fuel
    ...  ,(COALESCE(c_p4_f2.fee_adder, 0.0) + COALESCE(p_p4_f2.fee_adder, 0.0)) as ftid2InNetwrokP4FuelCash
    ...  ,(COALESCE(c_p1_f3.fee_adder, 0.0) + COALESCE(p_p1_f3.fee_adder, 0.0)) as ftId3OutNetwrokP1AllProds
    ...  ,(COALESCE(c_p2_f3.fee_adder, 0.0) + COALESCE(p_p2_f3.fee_adder, 0.0)) as ftId3OutNetwrokP2Cash
    ...  ,(COALESCE(c_p3_f3.fee_adder, 0.0) + COALESCE(p_p3_f3.fee_adder, 0.0)) as ftId3OutNetwrokP3Fuel
    ...  ,(COALESCE(c_p4_f3.fee_adder, 0.0) + COALESCE(p_p4_f3.fee_adder, 0.0)) as ftId3OutNetwrokP4FuelCash
    ...  ,(COALESCE(c_p1_f4.fee_adder, 0.0) + COALESCE(p_p1_f4.fee_adder, 0.0)) as ftId4MiscAdderP1AllProds
    ...  ,(COALESCE(c_p2_f4.fee_adder, 0.0) + COALESCE(p_p2_f4.fee_adder, 0.0)) as ftId4MiscAdderP2Cash
    ...  ,(COALESCE(c_p3_f4.fee_adder, 0.0) + COALESCE(p_p3_f4.fee_adder, 0.0)) as ftId4MiscAdderP3Fuel
    ...  ,(COALESCE(c_p4_f4.fee_adder, 0.0) + COALESCE(p_p4_f4.fee_adder, 0.0)) as ftId4MiscAdderP4FuelCash

    ...  FROM (SELECT carrier_id, parent FROM carrier_group_xref WHERE (effective_date IS NULL OR effective_date <= current)
    ...  AND (expire_date IS NULL OR expire_date > current)) cgx  INNER JOIN member m on m.member_id = cgx.carrier_id
    ...  LEFT OUTER JOIN contacts c on c.carrier_id = cgx.carrier_id and c.type = 'BILL_TO'
    ...  LEFT OUTER JOIN contract cc on cc.carrier_id = cgx.carrier_id
    ...  LEFT OUTER JOIN driver_fees df on df.carrier_id = cgx.carrier_id AND cc.contract_id = df.contract_id AND df.fee_id = 118
    ...  LEFT OUTER JOIN direct_bills db on db.carrier_id = cgx.carrier_id
    ...  LEFT OUTER JOIN cont_misc cm on cc.contract_id = cm.contract_id

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f1 ON c_p1_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f1 ON p_p1_f1.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f1 ON c_p2_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f1 ON p_p2_f1.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f1 ON c_p3_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f1 ON p_p3_f1.owner_id=cgx.parent

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f1 ON c_p4_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 1  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f1 ON p_p4_f1.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 2  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f2 ON c_p1_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f2 ON p_p1_f2.owner_id=cgx.parent

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id )  t2  ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f2 ON c_p2_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f2 ON p_p2_f2.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f2 ON c_p3_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f2 ON p_p3_f2.owner_id=cgx.parent

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f2 ON c_p4_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id )t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f2 ON p_p4_f2.owner_id=cgx.parent

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 3  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f3 ON c_p1_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f3 ON p_p1_f3.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f3 ON c_p2_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f3 ON p_p2_f3.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 3  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f3 ON c_p3_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f3 ON p_p3_f3.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f3 ON c_p4_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f3 ON p_p4_f3.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f4 ON c_p1_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f4 ON p_p1_f4.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f4 ON c_p2_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f4 ON p_p2_f4.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f4 ON c_p3_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f4 ON p_p3_f4.owner_id=cgx.parent

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f4 ON c_p4_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f4 ON p_p4_f4.owner_id=cgx.parent

    ...  WHERE cgx.parent = ${carrier.id} ORDER BY cgx.carrier_id, ar_number, direct_bill DESC;

    ${db_data_1}  Query To Dictionaries  ${query}

    ${size_db_data_1}  Get List Size  ${db_data_1}

    Set Test Variable  ${db_data_1}
    Set Test Variable  ${size_db_data_1}

Get Data From carrier_referral_xref
    [Documentation]  This keyword will get lines from carrier_referral_xref table.
    Get Into DB  TCH

    ${query}  Catenate  SELECT DISTINCT cgx.carrier_id
    ...  ,CASE WHEN (m.alt_carrier_id IS NULL OR m.alt_carrier_id=0) THEN cgx.carrier_id ELSE m.alt_carrier_id END AS alt_carrier_id
    ...  ,TRIM(nvl(m.name,'')) AS carrier_name
    ...  ,m.created AS created_date
    ...  ,TRIM(nvl(c.city, '')) AS city
    ...  ,nvl(c.state,'') AS state
    ...  ,nvl(m.cont_fname,'') || ' ' || nvl(m.cont_lname,'') AS primary_contact
    ...  ,nvl(c.email,'') AS primary_email
    ...  ,COALESCE(df.fee_amt,0.0) AS monthly_card_fee
    ...  ,COALESCE(cm.orig_limit,0.0) AS credit_limit
    ...  ,CASE WHEN (db.status='A') THEN 'Y' ELSE 'N' END AS direct_bill
    ...  ,TRIM(nvl(cc.terms,'')) AS terms
    ...  ,TRIM(cc.ar_number) AS ar_number
    ...  ,cc.status AS contract_status
    ...  ,(COALESCE(c_p1_f1.fee_adder, 0.0) + COALESCE(p_p1_f1.fee_adder, 0.0)) as ftid1ExtendedP1AllProds
    ...  ,(COALESCE(c_p2_f1.fee_adder, 0.0) + COALESCE(p_p2_f1.fee_adder, 0.0)) as ftid1ExtendedP2Cash
    ...  ,(COALESCE(c_p3_f1.fee_adder, 0.0) + COALESCE(p_p3_f1.fee_adder, 0.0)) as ftid1ExtendedP3Fuel
    ...  ,(COALESCE(c_p4_f1.fee_adder, 0.0) + COALESCE(p_p4_f1.fee_adder, 0.0)) as ftid1ExtendedP4FuelCash
    ...  ,(COALESCE(c_p1_f2.fee_adder, 0.0) + COALESCE(p_p1_f2.fee_adder, 0.0)) as ftid2InNetwrokP1AllProds
    ...  ,(COALESCE(c_p2_f2.fee_adder, 0.0) + COALESCE(p_p2_f2.fee_adder, 0.0)) as ftid2InNetwrokP2Cash
    ...  ,(COALESCE(c_p3_f2.fee_adder, 0.0) + COALESCE(p_p3_f2.fee_adder, 0.0)) as ftid2InNetwrokP3Fuel
    ...  ,(COALESCE(c_p4_f2.fee_adder, 0.0) + COALESCE(p_p4_f2.fee_adder, 0.0)) as ftid2InNetwrokP4FuelCash
    ...  ,(COALESCE(c_p1_f3.fee_adder, 0.0) + COALESCE(p_p1_f3.fee_adder, 0.0)) as ftId3OutNetwrokP1AllProds
    ...  ,(COALESCE(c_p2_f3.fee_adder, 0.0) + COALESCE(p_p2_f3.fee_adder, 0.0)) as ftId3OutNetwrokP2Cash
    ...  ,(COALESCE(c_p3_f3.fee_adder, 0.0) + COALESCE(p_p3_f3.fee_adder, 0.0)) as ftId3OutNetwrokP3Fuel
    ...  ,(COALESCE(c_p4_f3.fee_adder, 0.0) + COALESCE(p_p4_f3.fee_adder, 0.0)) as ftId3OutNetwrokP4FuelCash
    ...  ,(COALESCE(c_p1_f4.fee_adder, 0.0) + COALESCE(p_p1_f4.fee_adder, 0.0)) as ftId4MiscAdderP1AllProds
    ...  ,(COALESCE(c_p2_f4.fee_adder, 0.0) + COALESCE(p_p2_f4.fee_adder, 0.0)) as ftId4MiscAdderP2Cash
    ...  ,(COALESCE(c_p3_f4.fee_adder, 0.0) + COALESCE(p_p3_f4.fee_adder, 0.0)) as ftId4MiscAdderP3Fuel
    ...  ,(COALESCE(c_p4_f4.fee_adder, 0.0) + COALESCE(p_p4_f4.fee_adder, 0.0)) as ftId4MiscAdderP4FuelCash

    ...  FROM (SELECT carrier_id, parent_id FROM carrier_referral_xref WHERE (effective_date IS NULL OR effective_date <= current)
    ...  AND (expire_date IS NULL OR expire_date > current)) cgx  INNER JOIN member m on m.member_id = cgx.carrier_id
    ...  LEFT OUTER JOIN contacts c on c.carrier_id = cgx.carrier_id and c.type = 'BILL_TO'
    ...  LEFT OUTER JOIN contract cc on cc.carrier_id = cgx.carrier_id
    ...  LEFT OUTER JOIN driver_fees df on df.carrier_id = cgx.carrier_id AND cc.contract_id = df.contract_id AND df.fee_id = 118
    ...  LEFT OUTER JOIN direct_bills db on db.carrier_id = cgx.carrier_id
    ...  LEFT OUTER JOIN cont_misc cm on cc.contract_id = cm.contract_id

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f1 ON c_p1_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f1 ON p_p1_f1.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f1 ON c_p2_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f1 ON p_p2_f1.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f1 ON c_p3_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f1 ON p_p3_f1.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 1 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f1 ON c_p4_f1.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 1  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f1 ON p_p4_f1.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 2  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f2 ON c_p1_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f2 ON p_p1_f2.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id )  t2  ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f2 ON c_p2_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f2 ON p_p2_f2.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f2 ON c_p3_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f2 ON p_p3_f2.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f2 ON c_p4_f2.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 2 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id )t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f2 ON p_p4_f2.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 3  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f3 ON c_p1_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f3 ON p_p1_f3.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f3 ON c_p2_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f3 ON p_p2_f3.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 3  AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f3 ON c_p3_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN (SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f3 ON p_p3_f3.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f3 ON c_p4_f3.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 3 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f3 ON p_p4_f3.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 1 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p1_f4 ON c_p1_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 1 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p1_f4 ON p_p1_f4.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 2 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p2_f4 ON c_p2_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 2 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p2_f4 ON p_p2_f4.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 3 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p3_f4 ON c_p3_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 3 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p3_f4 ON p_p3_f4.owner_id=cgx.parent_id

    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 1 and product_type_id = 4 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )c_p4_f4 ON c_p4_f4.owner_id=cgx.carrier_id
    ...  LEFT OUTER JOIN ( SELECT t1.owner_id as owner_id, t1.fee_adder as fee_adder FROM carrier_fee_adder t1
    ...  JOIN (SELECT owner_id, max(adder_id) as max_adder_id FROM carrier_fee_adder
    ...  WHERE owner_type_id = 3 and product_type_id = 4 and fee_type_id = 4 AND (exp_date IS NULL OR exp_date > current)
    ...  GROUP BY owner_id ) t2 ON t1.owner_id=t2.owner_id AND t1.adder_id=t2.max_adder_id
    ...  )p_p4_f4 ON p_p4_f4.owner_id=cgx.parent_id

    ...  WHERE cgx.parent_id = ${carrier.id} ORDER BY cgx.carrier_id, ar_number, direct_bill DESC;

    ${db_data_2}  Query To Dictionaries  ${query}

    ${size_db_data_2}  Get List Size  ${db_data_2}

    Set Test Variable  ${db_data_2}
    Set Test Variable  ${size_db_data_2}

Compare Parent Carrier Report Excel Data With Database;
    [Documentation]  Compare Parent Carrier Report Excel Data With Database.
#
    ${size_total}  evaluate  ${size_db_data_1} + ${size_db_data_2}

    Validate Excel Data With DB  0  ${size_db_data_1}  ${db_data_1}  #This one will check carrier_group_xref values

    Run Keyword If  ${size_db_data_2} > 0
    ...  Validate Excel Data With DB  ${size_db_data_1}  ${size_total}  ${db_data_2}  #This one will check carrier_referral_xref values.

Validate Excel Data With DB
    [Arguments]  ${start}  ${end}  ${db_data}

    FOR  ${i}  IN RANGE  ${start}  ${end}
    #  log to console  ${db_data[${i}-${start}]} ${excel_data[${i}]}
      Should be Equal as Strings  ${db_data[${i}-${start}]['carrier_id']}  ${excel_data[${i}]['carrier_id']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['alt_carrier_id']}  ${excel_data[${i}]['alt_carrier_id']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['carrier_name']}  ${excel_data[${i}]['carrier_name']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['created_date']}  ${excel_data[${i}]['created_date']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['city']}  ${excel_data[${i}]['city']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['state']}  ${excel_data[${i}]['state']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['primary_contact']}  ${excel_data[${i}]['primary_contact']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['primary_email']}  ${excel_data[${i}]['primary_email']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['monthly_card_fee']}  ${excel_data[${i}]['monthly_card_fee']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['credit_limit']}  ${excel_data[${i}]['credit_limit']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['direct_bill']}  ${excel_data[${i}]['direct_bill']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['terms']}  ${excel_data[${i}]['terms']}
      Check Card Status  ${i}-${start}
      Should be Equal as Strings  ${db_data[${i}-${start}]['ar_number']}  ${excel_data[${i}]['ar_number']}
      Should be Equal as Strings  ${db_data[${i}-${start}]['contract_status']}  ${excel_data[${i}]['contract_status']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid1extendedp1allprods']}  ${excel_data[${i}]['fee_adder(extended_terms_fee/all_products)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid1extendedp2cash']}  ${excel_data[${i}]['fee_adder(extended_terms_fee/cash_advance_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid1extendedp3fuel']}  ${excel_data[${i}]['fee_adder(extended_terms_fee/fuel_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid1extendedp4fuelcash']}  ${excel_data[${i}]['fee_adder(extended_terms_fee/fuel&cash)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid2innetwrokp1allprods']}  ${excel_data[${i}]['fee_adder(in_network_fee/all_products)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid2innetwrokp2cash']}  ${excel_data[${i}]['fee_adder(in_network_fee/cash_advance_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid2innetwrokp3fuel']}  ${excel_data[${i}]['fee_adder(in_network_fee/fuel_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid2innetwrokp4fuelcash']}  ${excel_data[${i}]['fee_adder(in_network_fee/fuel&cash)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid3outnetwrokp1allprods']}  ${excel_data[${i}]['fee_adder(out_of_network_fee/all_products)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid3outnetwrokp2cash']}  ${excel_data[${i}]['fee_adder(out_of_network_fee/cash_advance_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid3outnetwrokp3fuel']}  ${excel_data[${i}]['fee_adder(out_of_network_fee/fuel_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid3outnetwrokp4fuelcash']}  ${excel_data[${i}]['fee_adder(out_of_network_fee/fuel&cash)_']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid4miscadderp1allprods']}  ${excel_data[${i}]['fee_adder(misc_adder_fee/all_products)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid4miscadderp2cash']}  ${excel_data[${i}]['fee_adder(misc_adder_fee/cash_advance_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid4miscadderp3fuel']}  ${excel_data[${i}]['fee_adder(misc_adder_fee/fuel_only)']}
      Should be Equal as Numbers  ${db_data[${i}-${start}]['ftid4miscadderp4fuelcash']}  ${excel_data[${i}]['fee_adder(misc_adder_fee/fuel&cash)']}
    END

Check Card Status
    [Arguments]  ${i}
    [Documentation]  This keyword will check the card status for each carrier.

    Get Into DB  TCH

    ${query}  Catenate  SELECT COUNT(*) FROM cards WHERE carrier_id = ${excel_data[${i}]['carrier_id']} AND status = 'A' AND card_num NOT LIKE '%OVER%';
    ${active_cards}  Query and Strip  ${query}
    Should be Equal as Numbers  ${active_cards}  ${excel_data[${i}]['active_cards']}

#    ${query}  Catenate  SELECT COUNT(*) FROM cards WHERE carrier_id = ${excel_data[${i}]['carrier_id']} AND status = 'I' AND card_num NOT LIKE '%OVER%';
#    ${inactive_cards}  Query and Strip  ${query}
#    Should be Equal as Numbers  ${inactive_cards}  ${excel_data[${i}]['inactive_cards']}
#
#    ${query}  Catenate  SELECT COUNT(*) FROM cards WHERE carrier_id = ${excel_data[${i}]['carrier_id']} AND status = 'H' AND card_num NOT LIKE '%OVER%';
#    ${hold_cards}  Query and Strip  ${query}
#    Should be Equal as Numbers  ${hold_cards}  ${excel_data[${i}]['hold_cards']}
#
#    ${query}  Catenate  SELECT COUNT(*) FROM cards WHERE carrier_id = ${excel_data[${i}]['carrier_id']} AND status = 'D' AND card_num NOT LIKE '%OVER%';
#    ${delete_cards}  Query and Strip  ${query}
#    Should be Equal as Numbers  ${delete_cards}  ${excel_data[${i}]['delete_cards']}
#
#    ${query}  Catenate  SELECT COUNT(*) FROM cards WHERE carrier_id = ${excel_data[${i}]['carrier_id']} AND status = 'U' AND card_num NOT LIKE '%OVER%';
#    ${fraud_cards}  Query and Strip  ${query}
#    Should be Equal as Numbers  ${fraud_cards}  ${excel_data[${i}]['fraud_cards']}
