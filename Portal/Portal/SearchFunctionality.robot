*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/PortalKeywords.robot
Resource  ../Variables/validUser.robot
Resource  otr_robot_lib/robot/CreateApplicationKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot

Force Tags  Application Manager
Suite Setup  Setup
Suite Teardown  Close All Browsers

#efs
#shell
#irving
#imperial

*** Variables ***
@{org_ids}  efs  irving  imperial  shell
@{efs_range}  100000  200000  300000  389999
@{shell_range}  500000  649999  400000  449999
@{imperial_range}  200001  299999  850000  899999
@{irving_range}  950000  997999

*** Test Cases ***

Search A TCH Application
    [Documentation]  Search for an shell application
    [Tags]  Search Application
    Find App Using  carrier_id  ${efs_carrier}

Search A Shell Application
    [Documentation]  Search for a shell application
    [Tags]  Search Application
    Find App Using  carrier_id  ${shell_carrier}

Search An Irving Application
    [Documentation]  Search for an irving application
    [Tags]  Search Application
    Find App Using  carrier_id  ${irving_carrier}

Search An Imperial Application
    [Documentation]  Search for an imperial application
    [Tags]  Search Application
    Find App Using  carrier_id  ${imperial_carrier}

Search By Card Type
    [Documentation]  Search using all card types within drop down
    [Tags]  Search Application
    Find Card Type Using

################similar test in application manager home
#Search By Application Status
#    [Tags]  Search Application
#    Find Status Using  Processed

Search By Credit Line Type
    [Tags]  Search Application
    Find CL Type Using

*** Keywords ***
Setup
    Open Browser to portal
    ${status}=  Log Into Portal
    wait until keyword succeeds  60s  5s  Log In Bandage  ${status}
    Select Portal Program   Application Manager
    Find Valid Carriers

Find App Using
    [Documentation]  Search using the Carrier ID option and equals condition
    [Arguments]  ${value}  ${criterion}
    wait until page contains element  //*[@id="searchForm"]/div[2]  60
    select from list by value  //*[@name="searchField"]  ${value}
    input text  //*[@name="searchValue"]  ${criterion}
    Click Portal Button  Search  times=1
    wait until done processing
    ${status}  run keyword and return status  page should not contain  No data found.  #page may not contain anything within the range
    run keyword if  ${status} == ${True}
    ...  run keywords
    ...  wait until page contains element  xpath=//*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]  timeout=60
    ...  AND  element should be visible  xpath=//*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody/tr[1]  #First row only
    ...  ELSE
    ...  log to console  results were found for ${criterion} in db, but table in portal returns no data.
    ...  Most likely selected something that isn't in the range to display.
    refresh page
#    log variables

Find Card Type Using
    [Documentation]  Searches all options in the card type drop down
    @{drop_down_labels}  get list items  //*[@name='cardType']
    FOR  ${label}  IN  @{drop_down_labels}
        select from list by label  //*[@name='cardType']  ${label}
        Click Portal Button  Search  times=1
        wait until done processing
        ${status}  run keyword and return status  page should not contain  No data found.  #page may not contain anything within the range
        run keyword if  ${status} == ${True}
        ...  run keywords
        ...  wait until page contains element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody  60
        ...  AND  element should be visible  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody
        ...  ELSE
        ...  log to console  no data returned in portal table for ${label}.
        refresh page
    END

#########similar test in application manager home.robot
#Find Status Using
#    [Arguments]  ${status}
#    select from list by value  //*[@id="searchForm"]/div[1]/div[1]/div[2]/div[2]/select  ${status}
#    click element  //*[@id="searchForm"]/div[1]/a/div
#    wait until page contains element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody  60
#    click element  //*[@id="pm_0"]

Find CL Type Using
    [Documentation]  Searches all options in the credit line type drop down
    @{drop_down_labels}  get list items  //*[@name='creditLineRequested']
    FOR  ${label}  IN  @{drop_down_labels}
        select from list by label  //*[@name='creditLineRequested']  ${label}
        Click Portal Button  Search  times=1
        wait until done processing
        ${status}  run keyword and return status  page should not contain  No data found.  #page may not contain anything within the range
        run keyword if  ${status} == ${True}
        ...  run keywords
        ...  wait until page contains element  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody  60
        ...  AND  element should be visible  //*[@id="resultsTable"]/tbody/tr[2]/td[2]/div/table/tbody
        ...  ELSE
        ...  log to console  no data returned in portal table for ${label}.
        refresh page
    END

Find Valid Carriers
    Get into DB  TCH
    FOR  ${item}  IN  @{org_ids}
        ${results}  create and execute query  ${item}
        set suite variable  ${${item}_carrier}  ${results}
        log to console  ${${item}_carrier}
    END

Create and Execute Query
    [Arguments]  ${item}
    log to console  item in create query ${item}
    ${range}=  run keyword if  '${item}' == 'efs'  set variable  @{efs_range}
    ...  ELSE IF  '${item}' == 'shell'  set variable  @{shell_range}
    ...  ELSE IF  '${item}' == 'irving'  set variable  @{irving_range}
    ...  ELSE IF  '${item}' == 'imperial'  set variable  @{imperial_range}
    ...  ELSE  set variable  ${EMPTY}
    return from keyword if  '''${range}''' == '${EMPTY}'
    ${conditional}  run keyword if  len(${range}) > 2  catenate  contract_id between ${range}[0] and ${range}[1] or contract_id between ${range}[2] and ${range}[3]
    ...  ELSE  catenate  contract_id between ${range}[0] and ${range}[1]
    ${query}  catenate  select carrier_id from contract where contract_id in
    ...  (select distinct(contract_id) from wrkflw_contract where ${conditional})
    ...  limit 100
    ${query_results}  query and strip to dictionary  ${query}
    ${results}  run keyword if  'carrier_id' in '''${query_results}'''  evaluate  random.choice(${query_results}[carrier_id])  modules=random
    ...  ELSE  set variable  ${EMPTY}
    [Return]  ${results}

