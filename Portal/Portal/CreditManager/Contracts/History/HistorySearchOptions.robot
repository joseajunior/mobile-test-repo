*** Settings ***
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  String
Library  DateTime
Library  otr_robot_lib.ui.web.PySelenium
Library  Collections

Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../../../../../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Force Tags  Portal  Credit Manager  weekly
Documentation  Changes fields in History tab in Credit Manager and checks returned values in UI and database in the DIT and ACPT environments.
...  Wont' run on SIT or STG due to missing data and access issues [STG].

Suite Teardown  close all browsers
Suite Setup  Get in to Portal
Test Setup  Select Credit Manager and Get Contract
Test Teardown  Return to Portal Home

*** Variables ***
${carrier_id_search_box}=  xpath://*[@id="searchForm"]//descendant::*[contains(text(),'Carrier ID')]/following-sibling::div/input
${search_button}=  xpath://*[@id="searchForm"]//descendant::*[contains(text(),'Search')]/../..
${history_tab}=  xpath://*[@id="accountDetail"]//descendant::*[contains(text(),'History')]/../..
${path_to_start_date}=  xpath://*[@id="historyForm"]//descendant::*[contains(text(),'Start Date')]//following-sibling::div/span/input
${path_to_end_date}=  xpath://*[@id="historyForm"]//descendant::*[contains(text(),'End Date')]//following-sibling::div/span/input
${path_to_display}=  xpath://*[@id="historyForm"]//descendant::*[contains(text(),'Display *')]//following-sibling::div/select
${path_to_view_level}=  xpath://*[@id="historyForm"]//descendant::*[contains(text(),'View Level')]//following-sibling::div/select
${all_items}=  I
${open_items}=  O
${invoices}=  S
${payments}=  P
${adjustments}=  A
${credit_items}=  C
${debit_items}=  D
${unbilled_items}=  U
${money_codes}=  M
${contract_val}=  A
${carrier_val}=  C
#used to change the order of carrier because it is switched from ar_number first from last if it's selected before contract
${lineorder}=  [21, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
#dictionary used to swap the order of items items in list, IF they are every added in different order.
&{table_headings}  AR Number=0  Type=1  Code=2  Description=3  Invoice Num=4  Invoice Date=5  Due Date=6  Amount=7  Late Fees=8  Total=9  Remaining=10  Currency=11  Reference ID=12  ID=13  Bank Account=14  Comments=15  Rev Date=16  Reversal Category=17  Reversal Reason=18  Reversal Comments=19  Created By=20  Updated By=21
${format_test_check_pass_or_fail}=  ${None}
@{code_list}=  Pending  CM  DM*  MC  INV  UNAPP  CM
@{desc_list}=  EFS USD FIFTHTHIRD ACH  Card Fee Credit  Unused Money Codes  A-Consolidated Inv  Daily Trans Summary  EFS Lockbox F3  A-Late Fee Credit  Bad Debt Recovered  GoodWill/LateFee W/O  Payment Fee Credit
@{type_list}=  Payment  Adjustment  Money Code  Invoice  Summary

*** Test Cases ***
Check Dropdowns and Date Formats
    [Tags]  JIRA:PORT-481  qTest:48151624
    [Documentation]  Test that checks ONCE if items are in lists and dates are formatted. This changes the test setup
    ...  removing this WILL BREAK THE TESTS
    ${format_and_values}=  validate date formats and dropdown values
    ${teardown}=  set variable if  '${format_and_values}'=='${True}'  NONE
    ...  Return to Portal Home
    run keyword if  '${teardown}'=='NONE'  set suite variable  ${format_test_check_pass_or_fail}  PASS
    ...  ELSE  set suite variable  ${format_test_check_pass_or_fail}  FAIL
    [Teardown]  ${teardown}

Open Items :Contract
    [Tags]  JIRA:PORT-481  qTest:48152317
    [Documentation]  Selects Open Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${open_items}
    Select Visible Fields
    Submit
    Check Table Columns
    #Check and Verify Data

All Items :Contract
    [Tags]  JIRA:PORT-481  qTest:48152758
    [Documentation]  Selects All Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${all_items}
    Select Visible Fields
    Submit
    Check Table Columns
    #Check and Verify Data

Invoices :Contract
    [Tags]  JIRA:PORT-481  qTest:48152771
    [Documentation]  Selects Invoices from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${invoices}
    Select Visible Fields
    Submit
    Check Table Columns

Payments :Contract
    [Tags]  JIRA:PORT-481  qTest:48152782
    [Documentation]  Selects Payments from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${payments}
    Select Visible Fields
    Submit
    Check Table Columns

Adjustments :Contract
    [Tags]  JIRA:PORT-481  qTest:48152791
    [Documentation]  Selects Adjustments from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${adjustments}
    Select Visible Fields
    Submit
    Check Table Columns

Debit Items :Contract
    [Tags]  JIRA:PORT-481  qTest:48152808
    [Documentation]  Selects Debit Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${debit_items}
    Select Visible Fields
    Submit
    Check Table Columns

Credit Items :Contract
    [Tags]  JIRA:PORT-481  qTest:48152813
    [Documentation]  Selects Credit Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${credit_items}
    Select Visible Fields
    Submit
    Check Table Columns

Unbilled Items :Contract
    [Tags]  JIRA:PORT-481  qTest:48152819
    [Documentation]  Selects Unbilled Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${unbilled_items}
    Select Visible Fields
    Submit
    Check Table Columns

Money Codes :Contract
    [Tags]  JIRA:PORT-481  qTest:48152824
    [Documentation]  Selects Money Codes from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${money_codes}
    Select Visible Fields
    Submit
    Check Table Columns

#######DATE CHANGES
Start Date No Change :Contract
    [Tags]  JIRA:PORT-481  qTest:48152854
    [Documentation]  Changes the Start Date field to a date that does not change End Date and checks the data returned
    Make Selection  Display *  ${money_codes}  Start Date  No Change
    Select Visible Fields
    Submit
    Check Table Columns

Start Date With Change :Contract
    [Tags]  JIRA:PORT-481  qTest:48152833
    [Documentation]  Changes Start Date field to a date that changes End Date as well and checks the data returned
    Make Selection  Display *  ${money_codes}  Start Date  For Change
    Select Visible Fields
    Submit
    Check Table Columns

End Date No Change :Contract
    [Tags]  JIRA:PORT-481  qTest:48152880
    [Documentation]  Changes End Date field to a date that does not change Start Date and checks the data returned
    Make Selection  Display *  ${money_codes}  End Date  No Change
    Select Visible Fields
    Submit
    Check Table Columns

End Date With Change :Contract
    [Tags]  JIRA:PORT-481  qTest:48152864
    [Documentation]  Changes End Date field to a date that changes Start Date as well and checks the data returned
    Make Selection  Display *  ${money_codes}  End Date  For Change
    Select Visible Fields
    Submit
    Check Table Columns

###########CARRIER###########
Open Items :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353537
    [Documentation]  Selects Open Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${open_items}
    Select Visible Fields
    Submit
    Check Table Columns

All Items :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353536
    [Documentation]  Selects All Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${all_items}
    Select Visible Fields
    Submit
    Check Table Columns

Invoices :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353535
    [Documentation]  Selects Invoices from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${invoices}
    Select Visible Fields
    Submit
    Check Table Columns

Payments :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353534
    [Documentation]  Selects Payments from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${payments}
    Select Visible Fields
    Submit
    Check Table Columns

Adjustments :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353533
    [Documentation]  Selects Adjustments from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${adjustments}
    Select Visible Fields
    Submit
    Check Table Columns

Debit Items :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353532
    [Documentation]  Selects Debit Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${debit_items}
    Select Visible Fields
    Submit
    Check Table Columns

Credit Items :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353531
    [Documentation]  Selects Credit Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${credit_items}
    Select Visible Fields
    Submit
    Check Table Columns

Unbilled Items :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353530
    [Documentation]  Selects Unbilled Items from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${unbilled_items}
    Select Visible Fields
    Submit
    Check Table Columns

Money Codes :Carrier
    [Tags]  JIRA:PORT-496 qTest:212353528
    [Documentation]  Selects Money Codes from drop down, selects appropriate fields to be visible in the table, checks that the page table data and database data matches.
    Make Selection  Display *  ${money_codes}
    Select Visible Fields
    Submit
    Check Table Columns

#######DATE CHANGES
Start Date No Change :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353527
    [Documentation]  Changes the Start Date field to a date that does not change End Date and checks the data returned
    Make Selection  Display *  ${money_codes}  Start Date  No Change
    Select Visible Fields
    Submit
    Check Table Columns

Start Date With Change :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353526
    [Documentation]  Changes Start Date field to a date that changes End Date as well and checks the data returned
    Make Selection  Display *  ${money_codes}  Start Date  For Change
    Select Visible Fields
    Submit
    Check Table Columns

End Date No Change :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353525
    [Documentation]  Changes End Date field to a date that does not change Start Date and checks the data returned
    Make Selection  Display *  ${money_codes}  End Date  No Change
    Select Visible Fields
    Submit
    Check Table Columns

End Date With Change :Carrier
    [Tags]  JIRA:PORT-496  qTest:212353529
    [Documentation]  Changes End Date field to a date that changes Start Date as well and checks the data returned
    Make Selection  Display *  ${money_codes}  End Date  For Change
    Select Visible Fields
    Submit
    Check Table Columns

Invalid Date Check
    [Tags]  JIRA:PORT-481  qTest:48153017
    [Documentation]  Used to check if the invalid input checks are working on input fields
    Check Invalid Inputs with Numbers


*** Keywords ***
Get in to Portal
    [Documentation]  logs into the portal application
    Open Browser to portal
    ${status}=  Log Into Portal
    Select Contract ID
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}

Select Contract ID
    [Documentation]  selects a dynamic carrier that should always have a history tab
    ${carrier}  Find Carrier in Oracle  A
    set suite variable  ${carrier_id}  ${carrier}

Search for a Contract
    [Documentation]  Searches for a contract using the contract id
    wait until element is enabled  ${carrier_id_search_box}  timeout=120
    input text  ${carrier_id_search_box}  ${carrier_id}
    click element  ${search_button}

Select Contract
    [Documentation]  selects the correct contract and sets a the contract ar number as the suite variable
    wait until done processing
    wait until page contains element  xpath://*[@id="resultsTable"]  timeout=120
    wait until element is enabled  xpath://*[@id="resultsTable"]  timeout=120
    ${ar_number}=  get text  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]//../following-sibling::td  #//*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]/.././preceding-sibling::node()[position() < 2][self::td]
    set suite variable  ${ar_number}  ${ar_number}
    double click element  xpath://*[@id="resultsTable"]//descendant::*[contains(text(),'${carrier_id}')]
    wait until done loading contract

Select History Tab
    [Documentation]  selects the history tab within the contract
    wait until element is visible  ${history_tab}  timeout=60
    wait until element is enabled  ${history_tab}  timeout=60
    click element  ${history_tab}

Select Credit Manager and Get Contract
    [Documentation]  the suite setup
    run keyword if  '${PREV TEST STATUS}'=='FAIL' or '${TEST NAME}'=='Check Dropdowns and Date Formats'  Select Portal Program  Credit Manager
    run keyword if  '${PREV TEST STATUS}'=='FAIL' or '${TEST NAME}'=='Check Dropdowns and Date Formats'  Search for a Contract
    run keyword if  '${PREV TEST STATUS}'=='FAIL' or '${TEST NAME}'=='Check Dropdowns and Date Formats'  Select Contract
    run keyword if  '${PREV TEST STATUS}'=='FAIL' or '${TEST NAME}'=='Check Dropdowns and Date Formats'  Select History Tab
    run keyword if  '${TEST NAME}'=='Check Dropdowns and Date Formats'  setting history tab suite variables
    run keyword if  '${PREV TEST STATUS}'=='PASS'  setting original date values in test setup

Setting History Tab Suite Variables
    wait until element is enabled  ${path_to_display}  timeout=60
    ${original_display_dropdown}=  get value  ${path_to_display}
    ${original_start_date}=  get value  ${path_to_start_date}
    ${original_end_date}=  get value  ${path_to_end_date}
    ${original_view_level}=  get value  ${path_to_view_level}
    set suite variable  ${original_display_dropdown}  ${original_display_dropdown}
    set suite variable  ${original_start_date}  ${original_start_date}
    set suite variable  ${original_end_date}  ${original_end_date}
    set suite variable  ${original_view_level}  ${original_view_level}

Setting Original Date Values In Test Setup
    wait until element is enabled  ${path_to_display}  timeout=60
    input text  ${path_to_start_date}  ${original_start_date}
    input text  ${path_to_end_date}  ${original_end_date}
    Submit
    wait until done processing

Select Visible Fields
    [Documentation]  selects the fields that show up in the table in the history tab datagrid
    wait until done processing
    wait until element is enabled  xpath://*[@id="historyList"]//*[contains(@title, 'Settings')]  timeout=60
    click element  xpath://*[@id="historyList"]//*[contains(@title, 'Settings')]
    wait until element is enabled  xpath://*[@id="_j_dataGrid_fields"]  timeout=60
    ${fields}=  get element count  xpath://div[@id="_j_dataGrid_fields"]/*
    ${view_level}=  get value  ${path_to_view_level}

    #can remove fields from view in this for loop
    FOR  ${item}  IN RANGE  ${fields}
        ${is_checked}=  get element attribute  xpath://div[@id="_j_dataGrid_fields"]/div[${fields}]/input  checked
        ${value}=  get value  xpath://div[@id="_j_dataGrid_fields"]/div[${fields}]/input
        run keyword if  ('${is_checked}'!='${None}' or '${is_checked}'=='${None}') and '${value}'=='arNumber' and '${view_level}'=='Carrier'   click element  xpath://div[@id="_j_dataGrid_fields"]/div[${fields}]/input            #removing arnumber from selected fields                                              #removing id from selected fields
        run keyword if  '${is_checked}'=='${None}'  click element  xpath://div[@id="_j_dataGrid_fields"]/div[${fields}]/input
        ${fields}=  evaluate  ${fields} - 1
    END
    click element  xpath://*[@id="dataGridSettings_content"]/div/div[4]/a[1]
    wait until done processing


Make Selection
    [Arguments]  @{options}
    #####use this pattern to find the TRUE FALSE of what is in the options list
    ${display}=  evaluate  "Display *" in """${options}"""
    ${view_level}=  evaluate  "View Level" in """${options}"""
    ${start_date}=  evaluate  "Start Date" in """${options}"""
    ${end_date}=  evaluate  "End Date" in """${options}"""
    #getting the path to the element
    ${display_path}=  run keyword if  '${display}'=='${TRUE}'  get path to element  Display *
    ${view_level_path}=  run keyword if  '${view_level}'=='${TRUE}'  get path to element  View Level
    ${start_date_path}=  run keyword if  '${start_date}'=='${TRUE}'  get path to element  Start Date
    ${end_date_path}=  run keyword if  '${end_date}'=='${TRUE}'  get path to element  End Date
    run keyword if  '${display}'=='${TRUE}' and '${start_date}'=='${TRUE}'  change value of filter  ${display_path}  @{options}
    ...  ELSE IF  '${display}'=='${TRUE}' and '${end_date}'=='${TRUE}'  change value of filter  ${display_path}  @{options}
    ...  ELSE IF  '${display}'=='${TRUE}'  change value of filter  ${display_path}  @{options}
    ...  ELSE IF  '${view_level}'=='${TRUE}'  change value of filter  ${view_level_path}  @{options}
    ...  ELSE IF  '${start_date}'=='${TRUE}'  change value of filter  ${start_date_path}  @{options}
    ...  ELSE IF  '${end_date}'=='${TRUE}'  change value of filter  ${end_date_path}  @{options}
    ...  ELSE  log to console  invalid selection

Get Path to Element
    [Arguments]  ${selection}
    [Documentation]  gets the selected element path
    wait until element is enabled  ${path_to_display}
    #set path if type is select or span
    ${selection_path}=  run keyword if  '${selection}'=='Display *' or '${selection}'=='View Level'  catenate  xpath://*[@id="historyForm"]//descendant::*[contains(text(),'${selection}')]//following-sibling::div/select
    ...  ELSE IF  '${selection}'=='Start Date' or '${selection}'=='End Date'  catenate  xpath://*[@id="historyForm"]//descendant::*[contains(text(),'${selection}')]//following-sibling::div/span/input
    ...  ELSE  log to console  not valid path
    [Return]  ${selection_path}

Change Value Of Filter
    [Arguments]  ${selection_path}  @{options}
    [Documentation]  changes the value of the usermanipulatable element
    wait until element is enabled  ${selection_path}  60s
    ${the_test}=  check test name  ${TEST NAME}
    ${name}=  get from list  ${the_test}  1
    ${test_name}=  get from list  ${the_test}  0

    ${contains_and_date}=  evaluate  "Date" in """${test_name}"""
    ${display}=  evaluate  "Display *" in """${options}"""
    ${view_level}=  evaluate  "View Level" in """${options}"""
    ${start_date}=  evaluate  "Start Date" in """${options}"""
    ${end_date}=  evaluate  "End Date" in """${options}"""
    ${options_length}=  get length  ${options}

    run keyword if  '${name}'=='Carrier'  select from list by value  ${path_to_view_level}  C
    ...  ELSE IF  '${name}'=='Contract'  select from list by value  ${path_to_view_level}  A
    ...  ELSE  log to console  invalid view level selection

    #this submit is necessary it's like a refresh for the view level
    Submit
    wait until done processing

    #choices doesn't return anything but I'm keeping it
    ${choice}=  run keyword if  ('${display}'=='${TRUE}' or '${view_level}'=='${TRUE}') and '${contains_and_date}'=='${FALSE}'  Check and Change Dropdown  ${selection_path}  @{options}
    ...  ELSE IF  ('${start_date}'=='${TRUE}' or '${end_date}'=='${TRUE}') and '${contains_and_date}'=='${FALSE}'  Make Date Change  ${selection_path}  @{options}
    ...  ELSE IF  '${contains_and_date}'=='${TRUE}'  Change Dropdown and Date  @{options}
    ...  ELSE  log to console  invalid selection

    #think this is for date, it is also necessary
    Submit
    ${current_start}=  get value  ${path_to_start_date}
    ${current_end}=  get value  ${path_to_end_date}
    run keyword if  '${options_length}'>='3'  check dates  ${current_start}  ${current_end}  @{options}

    #the submits in test cases are also necessary

Check and Change Dropdown
    [Arguments]  ${selection_path}  @{options}
    [Documentation]  Changes the value of the dropdown if it's not that value already
    ${dropdown_values}=  get list items  ${selection_path}  values=True
    ${selected_value_set}=  evaluate  set(${options}) & set(${dropdown_values})
    ${selected_value}=  evaluate  list(${selected_value_set})[0]
    ${current_value}=  get value  ${selection_path}
    run keyword if  '${current_value}'!='${selected_value}'  select from list by value  ${selection_path}  ${selected_value}
    ${selected_value}=  run keyword if  '${current_value}'!='${selected_value}'  get value  ${selection_path}
    ...  ELSE  set variable  ${current_value}
    ${new_value}=  get value  ${selection_path}
    wait until keyword succeeds  60s  5s  should be equal  ${new_value}  ${selected_value}
    [Return]  ${selected_value}

Make Date Change
    [Arguments]  @{options}
    [Documentation]  setup to change date
    ${element_title}=  get from list  ${options}  0
    ${is_change}=  get from list  ${options}  1  #for change move start date back and end date forward, no change moves in oposite direction
    ${changed_date}=  run keyword if  '${element_title}'=='Start Date' and '${is_change}'=='For Change'  Change Date  ${element_title}  ${path_to_start_date}  ${path_to_end_date}  ${is_change}
    ...  ELSE IF  '${element_title}'=='Start Date' and '${is_change}'=='No Change'  Change Date  ${element_title}  ${path_to_start_date}  ${path_to_end_date}  ${is_change}
    ...  ELSE IF  '${element_title}'=='End Date' and '${is_change}'=='For Change'  Change Date  ${element_title}  ${path_to_start_date}  ${path_to_end_date}  ${is_change}
    ...  ELSE IF  '${element_title}'=='End Date' and '${is_change}'=='No Change'  Change Date  ${element_title}  ${path_to_start_date}  ${path_to_end_date}  ${is_change}
    ...  ELSE  log to console  wasn't caught in if else, add more or check if correct data was passed
    [Return]  ${changed_date}

Change Dropdown and Date
    [Arguments]  @{options}
    [Documentation]  changes the dropdown and date
    Check and Change Dropdown  ${path_to_display}  @{options}
    ${date_change}=  get from list  ${options}  2
    ${option}=  get from list  ${options}  3
    ${changed_values}=  Make Date Change  ${date_change}  ${option}
    [Return]  ${options}

check dates
    [Arguments]  ${start}  ${end}  @{options}
    [Documentation]  checks the entered dates to see if they are correct
    ${type}  get from list  ${options}  2
    ${change}  get from list  ${options}  3
    run keyword if  '${type}'=='Start Date' and '${change}'=='No Change'  run keywords  should not be equal  ${start}  ${original_start_date}
    ...  AND  should be equal  ${end}  ${original_end_date}
    ...  ELSE IF  '${type}'=='Start Date' and '${change}'=='For Change'  run keywords  should not be equal  ${start}  ${original_start_date}
    ...  AND  should not be equal  ${end}  ${original_end_date}
    ...  ELSE IF  '${type}'=='End Date' and '${change}'=='No Change'  run keywords  should be equal  ${start}  ${original_start_date}
    ...  AND  should not be equal  ${end}  ${original_end_date}
    ...  ELSE IF  '${type}'=='End Date' and '${change}'=='For Change'  run keywords  should not be equal  ${start}  ${original_start_date}
    ...  AND  should not be equal  ${end}  ${original_end_date}

Change Date
    [Arguments]  ${element_title}  ${start_date_path}  ${end_date_path}  ${is_change}
    [Documentation]  changes the date
    ${start}=  get value  ${start_date_path}
    ${end}=  get value  ${end_date_path}

    #the different date options, plus minus
    ${operator}=  set variable if  '${is_change}'=='For Change' and '${element_title}'=='Start Date'  -
    ...  '${is_change}'=='No Change' and '${element_title}'=='Start Date'  +
    ...  '${is_change}'=='No Change' and '${element_title}'=='End Date'  -
    ...  '${is_change}'=='For Change' and '${element_title}'=='End Date'  +
    ${new_date}=  run keyword if  '${element_title}'=='Start Date'  Adjust the Date  ${start}  years  ${operator}  10  ${is_change}  ${element_title}
    ...  ELSE IF  '${element_title}'=='End Date'  Adjust the Date  ${end}  years  ${operator}  10  ${is_change}  ${element_title}
    run keyword if  '${element_title}'=='Start Date'  input text  ${start_date_path}  ${new_date}
    ...  ELSE IF  '${element_title}'=='End Date'  input text  ${end_date_path}  ${new_date}

Adjust the Date
    [Arguments]  ${current_date_value}  ${year_month_day}  ${operator}  ${value_to_change_date_by}  @{is_change}
    [Documentation]  used to change the value to a valid date
    ${status}=  run keyword and return status  should not be empty  ${is_change}
    ${is_change_option}=  run keyword if  '${status}'=='${True}'  get from list  ${is_change}  0
    ${element_title}=  run keyword if  '${status}'=='${True}' and '${is_change_option}'!='add 1'  get from list  ${is_change}  1
    ${current_date_date}=  Convert Date  ${current_date_value}  result format=%Y-%m-%d

    ${value_to_change_date_by}=  run keyword if  '${year_month_day}'=='months'  evaluate  ${value_to_change_date_by} * 30
    ...  ELSE IF  '${year_month_day}'=='years'  evaluate  ${value_to_change_date_by} * 365
    ...  ELSE IF  '${year_month_day}'=='days'  evaluate  ${value_to_change_date_by} * 1
    ...  ELSE  set variable  9999999

    ${year_month_day}=  run keyword if  '${year_month_day}'=='months'  set variable  days
    ...  ELSE IF  '${year_month_day}'=='years'  set variable  days
    ...  ELSE IF  '${year_month_day}'=='days'  set variable  days
    ...  ELSE  set variable  wrong input
    convert to string  ${value_to_change_date_by}
    convert to string  ${year_month_day}
    ${time}=  run keyword  catenate  ${value_to_change_date_by}  ${year_month_day}
    ${new_date}=  run keyword if  '${operator}'=='+'  Add Time To Date  ${current_date_date}  ${time}  result_format=%Y-%m-%d
    ...  ELSE IF  '${operator}'=='-'  Subtract Time From Date  ${current_date_date}  ${time}  result_format=%Y-%m-%d
    ...  ELSE  set variable  0
    [Return]  ${new_date}


Compare Lists
    [Arguments]  ${list_of_lists}  ${db_value_copy}  ${list_of_list_copy}
    [Documentation]  compares lists with conditions, second one should only be used with carrier if they are used before a contract
    ${no_copy_status}=  run keyword and return status  lists should be equal  ${list_of_lists}  ${db_value_copy}  msg=LISTS ARE EQUAL
    #should only run if carrier is run first
    run keyword if  '${no_copy_status}'=='${False}'  lists should be equal  ${list_of_list_copy}  ${db_value_copy}  msg=LISTS ARE EQUAL

Get Table Headings
    wait until done processing
    wait until page contains element  xpath://*[@id='historydata']  timeout=120
    wait until element is visible  xpath://*[@id='historydata']  timeout=120
    wait until element is enabled  xpath://*[@id="historyList"]/tbody/tr[1]//div//th  timeout=120
    ${display_value}=  get value  ${path_to_display}
    ${x}=  set variable  1
    ${count_child}=  get element count  xpath://*[@id="historyList"]/tbody/tr[1]//div//th
    ${j}=  set variable  ${count_child-1}
    @{heading_list_of_lists}=  create list
    FOR  ${tr}  IN RANGE  ${x}
        ${data_list}=  heading data for loop  ${x}  ${j}
        set test variable  ${heading_row${x}}  ${data_list}
        append to list  ${heading_list_of_lists}  ${heading_row${x}}
        run keyword if  '${x}'=='0'  exit for loop
        ${x}=  evaluate  ${x} - 1
    END
    log variables
    ${heading_list_of_lists}=  evaluate  [item for element in $heading_list_of_lists for item in element]
    [Return]  @{heading_list_of_lists}

Check Table Columns
    [Documentation]  used to check if values show up in list after a submission. uses hard codes naive list to check most items aside from date.
    wait until done processing
    ${count_no_data_found}=  get element count  xpath://div[contains(text(), 'No data found.')]
    return from keyword if  '${count_no_data_found}' >= '1'
    ${table_options}=  combine lists  ${desc_list}  ${code_list}  ${type_list}
    IF  'Date' not in ${TEST NAME}
        FOR  ${item}  IN  ${table_options}
            ${status}  run keyword and return status  element should contain  //*[@id='historydata']//tbody//tbody//tr//td[contains(., "${item}")]  ${item}
            run keyword if  '${status}' == '${False}'  log to console ${status}: with ${item} probably not an issue since using naive list
        END
    ELSE IF  'Date' in ${TEST NAME}
            #checking for data values
            ${start}  get value  ${path_to_start_date}
            ${end}  get value  ${path_to_end_date}
            ${status_data}  run keyword and return status  element should contain  //*[@id='historydata']//tbody//tbody//tr//td[contains(., "${item}")]  ${item}
            run keyword if  '${status_data}' == '${False}'  log to console ${status}: with ${item} probably not an issue since using naive list
            #take the year from both selections and check for date similar in table
            ${first}  split string from left  ${start}  -  max_split  -1
            ${second}  split string from left  ${end}  -  max_split  -1
            ${status_date_start}  run keyword and return status  element should contain  //*[@id='historydata']//tbody//tbody//tr//td[contains(., "${first}[0]-")]  ${first}[0]-
            ${status_date_end}  run keyword and return status  element should contain  //*[@id='historydata']//tbody//tbody//tr//td[contains(., "${second}[0]-")]  ${second}[0]-
            IF  '${status_date_start}' == '${True}' or '${status_date_end}' == '${True}'
                ${start_text}=  get element text  //*[@id='historydata']//tbody//tbody//tr//td[contains(., "${first}[0]-")]
                ${end_text}=  get element text  //*[@id='historydata']//tbody//tbody//tr//td[contains(., "${second}[0]-")]
                IF  '${start_text}' != '${EMPTY}' and '${end_text}' != '${EMPTY}'
                    should be equal  ${start_text}  ${end_text}
                    should be true  ${start_text} >= ${start} or ${start_text} <= ${end}        #compare selected dates to date in table
                ELSE IF  '${start_text}' != '${Empty}'
                    should be true  ${start_text} >= ${start} or ${start_text} <= ${end}        #compare selected dates to date in table
                ELSE
                    should be true  ${end_text} >= ${start} or ${end_text} <= ${end}        #compare selected dates to date in table
                END
                #check if date is between end and start
            ELSE
                log to console  ${status}: date not in range selected
            END
    ELSE
        Fail  something is wrong
    END

Get Count of Items in Results
    [Arguments]  ${value}  ${unique_value_list_length}
    [Documentation]  used to get the count of each item in the list returned by the queries based on the type
    ${sum_value}=  run keyword if  '''${lol}'''!='${None}'  evaluate  sum(x.count('${value}') for x in ${lol})
    set test variable  ${value${unique_value_list_length}}  ${sum_value}

Replace List Value with None
    [Arguments]  ${length}  ${value}  ${list}
    [Documentation]  Replaces the value of NONE with Empty
    run keyword if  '${value}'=='${None}' or '${value}'=='${null}'  set list value  ${list}  ${length}  ${EMPTY}

Get Data from Table
    [Arguments]  ${count}
    [Documentation]  Gets the table data from the history tab and returns a nested list
    wait until done processing
    wait until page contains element  xpath://*[@id='historydata']  timeout=120
    wait until element is visible  xpath://*[@id='historydata']  timeout=120
    wait until element is enabled  xpath://div[2]/table/tbody/tr[2]//following-sibling::td/div/table/tbody/tr[last()]  timeout=120

    ${display_value}=  get value  ${path_to_display}
    ${row_index}=  get element attribute  xpath://div[2]/table/tbody/tr[2]//following-sibling::td/div/table/tbody/tr[last()]  recordindex
    ${x}=  set variable  ${row_index}
    ${x}=  evaluate  ${row_index} + 1
    ${count_child}=  run keyword if  '${row_index}'=='0'  get element count  xpath://div[2]/table/tbody/tr[2]//following-sibling::td/div/table/tbody/tr//td
    ...  ELSE  get element count  //div[2]/table/tbody/tr[2]//following-sibling::td/div/table/tbody/tr[2]/td
    ${j}=  set variable  ${count_child}
    @{list_of_lists}=  create list

    FOR  ${tr}  IN RANGE  ${x}
        ${data_list}=  table data for loop  ${x}  ${j}
        set test variable  ${row${x}}  ${data_list}
        append to list  ${list_of_lists}  ${row${x}}
        run keyword if  '${x}'=='0'  exit for loop
        ${x}=  evaluate  ${x} - 1
    END

    log variables
    #lists come back and need to be reversed
    reverse list  ${list_of_lists}
    [Return]  @{list_of_lists}

Table Data For Loop
    [Arguments]  ${x}  ${j}
    [Documentation]  Used to get and manipulate the table data
    @{data_list}=  create list
    ${display}=  get value  ${path_to_display}
    FOR  ${td}  IN RANGE  ${j}
        exit for loop if  '${j}' < '0'
        ${cell}  get text  xpath://*[@id="historyList"]/tbody/tr[2]/td[2]/div/table/tbody/tr[${x}]/td[${j}]/div
        append to list  ${data_list}  ${cell}
        remove parentheses and change currency  ${data_list}  ${cell}
        ${j}=  evaluate  ${j} - 1
    END
    #need to be reverse when getting table data
    reverse list  ${data_list}
    ${new_length}=  get length  ${data_list}
    set test variable  ${new_length}  ${new_length}
    [Return]  @{data_list}

Heading Data For Loop
    [Arguments]  ${x}  ${j}
    [Documentation]  Used to get and manipulate the table data
    @{heading_test}=  create list
    ${display}=  get value  ${path_to_display}
    FOR  ${td}  IN RANGE  ${j}
        exit for loop if  '${j}' < '0'
        scroll element into view  xpath://*[@id="historyList"]/tbody/tr[1]//div//th[${j}]//div[1]
        ${cell}  get text  xpath://*[@id="historyList"]/tbody/tr[1]//div//th[${j}]//div[1]
        append to list  ${heading_test}  ${cell}
        ${j}=  evaluate  ${j} - 1
    END
    #list needs to be reversed when getting data
    reverse list  ${heading_test}
    ${new_length}=  get length  ${heading_test}
    [Return]  @{heading_test}

Create List of List
    [Arguments]  ${x}  @{list}
    [Documentation]  Loop used to create list of list for the table data
    @{list_of_lists}=  create list
    ${display}=  get value  ${path_to_display}
    FOR  ${data}  IN RANGE  ${x}

        set test variable  ${row${x}}  ${list}
        run keyword if  '${x}'=='0'  exit for loop
        append to list  ${list_of_lists}  ${row${x}}
    END
    # list needs to be revered when getting table data
    reverse list  ${list_of_lists}
    [Return]  @{list_of_lists}

Remove Parentheses and Change Currency
    [Arguments]  ${list}  ${value}
    [Documentation]  Removes the parentheses and the commas in the currency values
    ${index}=  get index from list  ${list}  ${value}
    ${value}=  strip my string  ${value}  left  (
    ${value}=  strip my string  ${value}  right  )
    set list value  ${list}  ${index}  ${value}

Check Invalid Inputs with Numbers
    [Documentation]  Used to Validate that the Start and End date inputs are working
    wait until element is visible  ${path_to_display}  timeout=60
    wait until element is enabled  ${path_to_display}  timeout=60
    select from list by value  ${path_to_display}  ${all_items}
    input text  ${path_to_end_date}  1234
    input text  ${path_to_start_date}  1234
    ${end_color}=  get element attribute  ${path_to_end_date}  style
    ${start_color}=  get element attribute  ${path_to_start_date}  style
    ${check_end_color}=  evaluate  "red" in """${end_color}"""
    ${check_start_color}=  evaluate  "red" in """${start_color}"""
    return from keyword if  '${check_end_color}'=='${True}' and '${check_start_color}'=='${True}'

Check Invalid Inputs with String
    [Documentation]  Used to Validate that the Start and End date inputs are working
    wait until element is visible  ${path_to_display}  timeout=60
    wait until element is enabled  ${path_to_display}  timeout=60
    select from list by value  ${path_to_display}  ${all_items}
    clear element text  ${path_to_end_date}
    clear element text  ${path_to_start_date}
    input text  ${path_to_end_date}  :(adf^7.>
    input text  ${path_to_start_date}  </aF-0
    ${value_end}=  get value  ${path_to_end_date}
    ${value_start}=  get value  ${path_to_start_date}
    return from keyword if  '${value_end}'=='${original_end_date}' and '${value_start}'=='${original_start_date}'


Check Test Name
    [Arguments]  ${TEST NAME}
    [Documentation]  Used to split the testname to get whether it's for a contract or carrier
    ${type_list}=  String.split string from right  ${TEST NAME}  :
    [Return]  ${type_list}

Submit
    [Documentation]  Selects the submit button
    wait until element is enabled  xpath://*[@id="historyview"]//descendant::*[contains(text(),'Submit')]/../..  timeout=60
    ${test_value}=  get value  ${path_to_display}
    click element  xpath://*[@id="historyview"]//descendant::*[contains(text(),'Submit')]/../..
    ${test_new_value}=  get value  ${path_to_display}

Return to Portal Home
    [Documentation]  Modified version of keyword that exists in portal keywords file
    return from keyword if  '${TEST STATUS}'=='PASS'
    Wait Until Page Contains Element  //*[@id="pmd_home"]  timeout=60
    click element  xpath=//div[@title="Go To Home Page"]

validate date formats and dropdown values
    [Documentation]  used for validation of formats
    ${date_regex}=  set variable  ^[0-9]{4}-[0-9]{2}-[0-9]{2}$
    wait until element is enabled  ${path_to_display}  60s
    ${display_values}=  get list items  ${path_to_display}  values=True
    ${view_values}=  get list items  ${path_to_view_level}  values=True
    ${start}=  get value  ${path_to_start_date}
    ${end}=  get value  ${path_to_end_date}
    @{display_default}=  create list  I  O  S  P  A  C  D  U  M
    @{view_default}=  create list  A  C

    ${start_format_status}=  run keyword and return status  should match regexp  ${start}  ${date_regex}
    ${end_format_status}=  run keyword and return status  should match regexp  ${end}  ${date_regex}
    ${display_format_status}=  run keyword and return status  lists should be equal  ${display_default}  ${display_values}
    ${view_format_status}=  run keyword and return status  lists should be equal  ${view_default}  ${view_values}
    return from keyword if  '${start_format_status}'=='${True}' and '${end_format_status}'=='${True}' and '${display_format_status}'=='${True}' and '${view_format_status}'=='${True}'  ${True}









