*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Suite Setup     Set Up My Suite
Suite Teardown  close all browsers
Force Tags  Portal  Application Manager  weekly
Documentation  This is for the search functionality on Application Manager Home page
...  adding and deleting attachments/comments inside an application
#this needs to be converted into keywords later
#this needs to run only weekly

*** Variables ***


*** Test Cases ***

Search and open an application with card type filter
    [Tags]  JIRA:BOT-1646  JIRA:BOT-1649  qTest:31182373  Regression  qTest:31182620
    [Documentation]  This is to test if an application can be searched using card type filter
    ...  also once the results are pulled, checking if all the columns are sortable

    Select card type  Smart Pay
    Click Portal Button  Search
    Wait Until Done Processing
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=20
    Wait Until Element Is Visible  xpath=//*[@id="resultsTable"]//descendant::*[contains(text(),'Smart Pay')]  timeout=60
    Check Search Results  App ID
    Check Search Results  Wkfw ID
    Check Search Results  Acct Org
    Check Search Results  Card Type
    Check Search Results  Status
    Check Search Results  Company
    Check Search Results  City
    Check Search Results  S/P
    Check Search Results  Vehicles
    Check Search Results  Revenue
    Check Search Results  Inside Rep
    Check Search Results  Outside Rep
    Check Search Results  Last Updated
    Check Search Results  MSA
    Check Search Results  Credit Done
    Double Click Element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]
    Wait Until Page Contains  text=Company Info & Sales  timeout=20
    Click Portal Button  Return  times=1
    Continue Return

Search and open an application with status filter
    [Tags]  JIRA:BOT-1647  qTest:31182579  Regression
    [Documentation]  This is to test if an application can be searched using status filter
    Select From List By Label  cardType  All
    Select From List By Label  appState  Complete
    Click Portal Button  Search
    Wait Until Done Processing
    Wait Until Element Is Visible  //*[@id="resultsTable"]  timeout=20
    Page Should Contain Element  xpath=//*[@id="resultsTable"]//descendant::*[contains(text(),'Complete')]
    Double Click Element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]
    Wait Until Page Contains  text=Company Info & Sales  timeout=20
    Click Portal Button  Return  times=1
    Continue Return

Search and open an application with credit line type filter
    [Tags]  JIRA:BOT-1648  qTest:31182580  Regression
    [Documentation]  This is to test if an application can be searched using Credit Line Type filter
    select from list by label  appState  All
    select from list by label  creditLineRequested  Open Line (OAC) Request
    click portal button  Search
    Wait Until Done Processing
    wait until element is visible  //*[@id="resultsTable"]  timeout=20
    double click element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]/td[1]
    wait until page contains  text=Company Info & Sales  timeout=20
    click portal button  Return  times=1
    Continue Return

Search by Field and Value for Company Name Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Documentation]  This is to test all Search Field and Search value combinations
    [Setup]  Return To Application Manager
    [Teardown]  Refresh Page
    Search by Field and Value  Company Name  Starts With  ${SearchValueCardAppl['company_name']}

Search by Field and Value for Company Name Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Company Name  Contains  ${SearchValueCardAppl['company_name']}


Search by Field and Value for Company Name Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Company Name  Equals  ${SearchValueCardAppl['company_name']}


Search by Field and Value for Company Name Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Company Name  Ends With  ${SearchValueCardAppl['company_name']}


Search by Field and Value for Application ID Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Application ID*  Equals  ${SearchValueCardAppl['app_id']}


Search by Field and Value for Workflow ID Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  test
    [Teardown]  Refresh Page
    Search by Field and Value  Workflow ID*  Equals  ${SearchValueContAppl['wrkflw_contract_id']}


Search by Field and Value for Carrier ID Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Carrier ID*  Equals  ${SearchValueCardAppl['carrier_id']}


Search by Field and Value for Contract ID Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Contract ID*  Equals  ${SearchValueContAppl['contract_id']}


Search by Field and Value for AR Number Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  AR Number*  Equals  ${SearchValueContAppl['ar_number']}


Search by Field and Value for Address Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Address  Starts With  ${SearchValueCardAppl['company_physical_address']}


Search by Field and Value for Address Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Address  Contains  ${SearchValueCardAppl['company_physical_address']}


Search by Field and Value for Address Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Address  Equals  ${SearchValueCardAppl['company_physical_address']}


Search by Field and Value for Address Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Address  Ends With  ${SearchValueCardAppl['company_physical_address']}


Search by Field and Value for City Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  City  Starts With  ${SearchValueCardAppl['company_physical_city']}


Search by Field and Value for City Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  City  Contains  ${SearchValueCardAppl['company_physical_city']}


Search by Field and Value for City Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  City  Equals  ${SearchValueCardAppl['company_physical_city']}


Search by Field and Value for City Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  City  Ends With  ${SearchValueCardAppl['company_physical_city']}


Search by Field and Value for State Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  State*  Equals  ${SearchValueCardAppl['company_physical_state']}


Search by Field and Value for Contact Name Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Contact Name  Starts With  ${SearchValueCardAppl['company_contact']}


Search by Field and Value for Contact Name Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Contact Name  Contains  ${SearchValueCardAppl['company_contact']}


Search by Field and Value for Contact Name Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Contact Name  Equals  ${SearchValueCardAppl['company_contact']}


Search by Field and Value for Contact Name Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Contact Name  Ends With  ${SearchValueCardAppl['company_contact']}


Search by Field and Value for Phone/Cell/Fax Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Get Into DB  TCH
    ${phone}  run keyword if  '${efs_carrier}' != '${EMPTY}'  Query And Strip  SELECT cont_fax FROM member WHERE member_id=${efs_carrier}
    Search by Field and Value  Phone/Cell/Fax*  Equals  ${phone}


Search by Field and Value for Email Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2048 CREATED.
    [Teardown]  Refresh Page
    Search by Field and Value  Email  Starts With  ${SearchValueCardAppl['company_contact_email']}


Search by Field and Value for Email Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2048 CREATED.
    [Teardown]  Refresh Page
    Search by Field and Value  Email  Contains  ${SearchValueCardAppl['company_contact_email']}


Search by Field and Value for Email Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2048 CREATED.
    [Teardown]  Refresh Page
    Search by Field and Value  Email  Equals  ${SearchValueCardAppl['company_contact_email']}


Search by Field and Value for Email Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2048 CREATED.
    [Teardown]  Refresh Page
    Search by Field and Value  Email  Ends With  ${SearchValueCardAppl['company_contact_email']}


Search by Field and Value for Parent Corp Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Parent Corp  Starts With  ${SearchValueCardAppl['company_parent_corporation']}


Search by Field and Value for Parent Corp Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Parent Corp  Contains  ${SearchValueCardAppl['company_parent_corporation']}


Search by Field and Value for Parent Corp Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Parent Corp  Equals  ${SearchValueCardAppl['company_parent_corporation']}


Search by Field and Value for Parent Corp Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Parent Corp  Ends With  ${SearchValueCardAppl['company_parent_corporation']}


Search by Field and Value for Signer Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2049
    [Teardown]  Refresh Page
    Search by Field and Value  Signer  Starts With  ${SearchValueCardAppl['signers_name']}


Search by Field and Value for Signer Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2049
    [Teardown]  Refresh Page
    Search by Field and Value  Signer  Contains  ${SearchValueCardAppl['signers_name']}


Search by Field and Value for Signer Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2049
    [Teardown]  Refresh Page
    Search by Field and Value  Signer  Equals  ${SearchValueCardAppl['signers_name']}


Search by Field and Value for Signer Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression  BUGGED: UNKNOWN SEARCH CRITERIA. IT WORKS FROM SOME RECORDS ON DB AND DOESN'T FOR SOME OTHERS. BOT-2049
    [Teardown]  Refresh Page
    Search by Field and Value  Signer  Ends With  ${SearchValueCardAppl['signers_name']}


Search by Field and Value for Sales Rep Starts With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Sales Rep  Starts With  ${SearchValueSalesRep}


Search by Field and Value for Sales Rep Contains
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Sales Rep  Contains  ${SearchValueSalesRep}


Search by Field and Value for Sales Rep Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Sales Rep  Equals  ${SearchValueSalesRep}


Search by Field and Value for Sales Rep Ends With
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Sales Rep  Ends With  ${SearchValueSalesRep}


Search by Field and Value for Online App ID Equals
    [Tags]  JIRA:BOT-1650  qTest:31354887  Regression
    [Teardown]  Refresh Page
    Search by Field and Value  Online App ID*  Equals  ${SearchValueContAppl['gca_id']}


Add an attachment inside an application
    [Tags]  JIRA:BOT-1652  qTest:31182709  Regression
    [Documentation]  This is to test if a user is able to add an attachement inside an application
    Open Portal application  ${SearchValueCardAppl['app_id']}
    Click Element  pm_attach
    Wait Until Element Is Visible  //*[@id="attachmentDlg"]
    Click Portal Button  Add  //*[@id="attachmentDlg"]  times=1
    Select Frame  //iframe[contains(@src,'_add.jsp?appId=${SearchValueCardAppl['app_id']}')]
    Wait Until Element Is Visible  //*[@name="source1"]  timeout=30
    ${file}=  Set Local File  ${ROBOTROOT}\\Portal\\Assets\\Attachment.txt
    Choose File  //*[@name="source1"]  ${file}
    Click Portal Button  Save  times=1
    [Teardown]  Refresh Page

Delete an attachment inside an application
    [Tags]  JIRA:BOT-1652  qTest:31182715  Regression
    [Documentation]  This is to test if a user is able to delete an attachement inside an application
    Open Portal application  ${SearchValueCardAppl['app_id']}
    Click Element  pm_attach
    wait until element is visible  //*[@id="attachmentDlg_content"]//div[text()='Attachment.txt']
    click element  //*[@id="attachmentDlg_content"]//div[text()='Attachment.txt']
    click portal button  Delete  //*[@id="attachmentDlg"]  times=1
    click portal button  Yes  times=1
    Wait Until Element Is Visible  //*[@id="attachmentDlg"]
    click portal button  Close  //*[@id="attachmentDlg"]  times=1
    [Teardown]  Refresh Page
#
Go to Applications - Comments tab - Add a comment
    [Tags]  JIRA:BOT-1653  qTest:31247024  qTest:34898685  qTest:34898369  Regression
    [Documentation]  ​​This to test if a user can add a comment inside an application
    Open Portal application  ${SearchValueCardAppl['app_id']}
    click element  pm_notes
    wait until element is visible  //*[@id="commentsDlg_caption"]
    click portal button  Add  //*[@id="commentsDlg_content"]  times=1
    wait until element is enabled  requestScope.comment.comment
    input text  requestScope.comment.comment  BlindDutchman is awesome
    Wait Until Element Is Visible  //*[@id="commentsAdd_content"]
    click portal button  Save  //*[@id="commentsAdd_content"]  times=1
    [Teardown]  Refresh Page

Go to Applications - Comments tab - Edit a comment
    [Tags]  JIRA:BOT-1653  qTest:31247113  Regression
    [Documentation]  ​​This to test if a user can edit a comment inside an application
    Open Portal application  ${SearchValueCardAppl['app_id']}
    click element  pm_notes
    wait until element is visible  //*[@id="commentsDlg_content"]//*//*//descendant::*[contains(string(),'BlindDutchman is awesome')]  timeout=20
    click element  //*[@id="commentsDlg_content"]//*//*//descendant::*[contains(string(),'BlindDutchman is awesome')]
    Wait Until Element Is Visible  //*[@id="commentsDlg_content"]
    click portal button  Edit  //*[@id="commentsDlg_content"]  times=1
    Wait Until Element Is Visible  requestScope.comment.comment  timeout=30
    Input Text  requestScope.comment.comment  and the best
    click portal button  Save  //*[@id="commentsAdd_content"]  times=1
    click portal button  Close  //*[@id="commentsDlg_content"]  times=1
    Wait Until Element Is Not Visible  //*[@id="commentsAdd_content"]
    Page Should Contain Element  //*[@id="commentsDlg_content"]//*//*//descendant::*[contains(string(),'and the best')]
    [Teardown]  Refresh Page
#
##Go to Applications - Logs - Application Change Log- Refresh with a different date
#
Go to Applications - Logs - Workflow Log
    [Tags]  JIRA:BOT-1655  qTest:31354886  Regression
    [Documentation]  This is to test if Workflow log pulls the workflow history of a specific contract
    [Setup]  Return To Application Manager
    Open Portal application  ${SearchValueCardAppl['app_id']}
    Wait Until Done Processing
    Open contract inside application  ${SearchValueContAppl['wrkflw_contract_id']}
    Hover Over  //*[@id="pm_amdrop"]
    Click Element  //*[@id="pm_history"]
    Wait Until Element Is Visible  //*[@id="hitoryDlg_content"]  timeout=20
    Element Should Contain  //*[@id="hitoryDlg_content"]  Workflow created.  message=It's Not There
    Click Portal Button  Close  //*[@id="hitoryDlg_content"]  times=1

#Go to Applications - Logs - Workflow Change Log - Refresh with a different date

*** Keywords ***

Select card type
    [Arguments]  ${cardType}
    wait until element is visible  //*[@name="cardType"]  timeout=60  error=Could not find Card Type drop down within 60 seconds
    wait until page contains element  //*[@name="cardType"]//option[text()="${cardType}"]
    Select From List By Label  cardType  ${cardType}

Search by Field and Value
    [Arguments]  ${SearchField}  ${Condition}  ${SearchValue}  ${validateOnScreen}=${True}

    Select From List By Label  searchField  ${SearchField}
    Select From List By Label  searchCondition  ${Condition}
    Run Keyword If  '${SearchValue}' == 'None'  Input Text  searchValue  ${EMPTY}
    ...  ELSE  Input Text  searchValue  ${SearchValue}
    Click Portal Button  Search
    Wait Until Done Processing
    Wait Until Element Is Visible  xpath=//*[@id="resultsTable"]  timeout=60
    ${rowsFound}=  Get Element Count  //*[@id="resultsTable"]//table[@onmousedown]//tr
    Run Keyword IF  ${validateOnScreen}  Should Be Greater Than  ${rowsFound}  0  Expected At Least 1 Row to Populate

Return To Application Manager
    Return to Portal Home
    Select Portal Program  Application Manager

Set Up My Suite
     Get Into DB  TCH

    ${SearchQuery0}  catenate  SELECT wrkflw_cardappl.app_id
    ...     FROM wrkflw_cardappl inner join wrkflw_contract
    ...     on wrkflw_cardappl.app_id = wrkflw_contract.app_id
    ...     WHERE company_name IS NOT NULL AND company_name <> ''
    ...     AND company_parent_corporation IS NOT NULL
    ...     AND company_contact_email IS NOT NULL AND company_contact_email <> ''
    ...     AND signers_name IS NOT NULL AND signers_name <> ''
    ...     AND wrkflw_contract_id IS NOT NULL
    ...     AND gca_id IS NOT NULL
    ...     AND ar_number IS NOT NULL
    ...     ORDER BY created_date DESC limit 1;
    ${appID}  Query And Strip To Dictionary  ${SearchQuery0}

    ${SearchQuery1}  catenate  SELECT company_name, app_id, carrier_id,
    ...     company_physical_address, company_physical_city, company_physical_state,
    ...     company_contact, company_contact_email, company_parent_corporation, signers_name
    ...     FROM wrkflw_cardappl
    ...     WHERE app_id = '${appID['app_id']}' limit 1;
    ${SearchValueCardAppl}  Query And Strip To Dictionary  ${SearchQuery1}
    Set Suite Variable  ${SearchValueCardAppl}

    ${SearchQuery2}  catenate  SELECT wrkflw_contract_id, gca_id, ar_number, contract_id
    ...     FROM wrkflw_contract
    ...     WHERE wrkflw_contract_id IS NOT NULL
    ...     AND gca_id IS NOT NULL
    ...     AND ar_number IS NOT NULL
    ...     AND app_id = '${SearchValueCardAppl['app_id']}'  limit 1
    ${SearchValueContAppl}  Query And Strip To Dictionary  ${SearchQuery2}
    Set Suite Variable  ${SearchValueContAppl}

    ${SearchQuery3}  catenate  SELECT f.name AS name
    ...     FROM sales_folk f,sales_territory t, wrkflw_cardappl ca
    ...     WHERE t.code = ca.sales_territory AND ca.org_id IN (101,102,103,104,105,125,165,185,81,125)
    ...     AND f.number = t.inside_sales_rep AND f.name IS NOT NULL limit 1
    ${SearchValueSalesRep}  Query And Strip  ${SearchQuery3}
    Set Suite Variable  ${SearchValueSalesRep}

    Open Browser to portal
    ${status}=  Log Into Portal
    wait until keyword succeeds  5x  5s  Log In Bandage  ${status}
    Select Portal Program  Application Manager

Continue Return
    ${status}=  run keyword and return status  element should not be visible  //*[@id="confirm"]/table
    run keyword if  ${status} == ${False}  Click Portal Button  Yes  //*[@id="confirm"]/table  times=1

Check Search Results
    [Arguments]  ${column}
    #App ID, Wkfw ID, Acct Org, Card Type, Status, Company, City, S/P, Vehicles, Revenue, Inside Rep, Outside Rep, Last Updated, MSA, Credit Done
    Scroll Element Into View  //*[@id="resultsTable"]//*[contains(@class,'sort')]/div[contains(string(),'${column}')]
    Wait Until Element Is Visible  //*[@id="resultsTable"]//*[contains(@class,'sort')]/div[contains(string(),'${column}')]  20s
    Element Should Be Enabled  //*[@id="resultsTable"]//*[contains(@class,'sort')]/div[contains(string(),'${column}')]

