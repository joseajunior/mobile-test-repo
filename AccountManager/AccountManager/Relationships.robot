*** Settings ***

Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  String
Library  otr_model_lib.services.GenericService
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot
Resource  ../../Variables/validUser.robot

Suite Setup  Start Suite
Suite Teardown  End Test

Force Tags  AM  Carrier Groups  refactor

*** Variables ***
${fundingParent}   143363
${referralParent}  167239
${fltoneparent}  700032
${fltonechild}  700140
${fltoneSecondChild}  700141
${fltoneSecondParent}  700034
${YESTERDAY}

*** Test Cases ***
Add Funding Parent to Child Account
    [Tags]  JIRA:BOT-1510  qTest:32445687  Regression  refactor
    [Teardown]  delete parent from child  Funding  ${USERNAME}  ${fundingParent}
    Search a carrier in Account Manager  EFS  ${USERNAME}
    Add Parent To Child  Funding  ${fundingParent}
    Check AR Numbers In Dropdown Match Child AR Numbers  ${USERNAME}  ${fundingParent}
    Validate Relationship in Database  Funding  ${username}  ${fundingParent}

Add Referral Parent to Child Account
    [Tags]  JIRA:BOT-1514  qTest:32445138  Regression
    [Teardown]  delete parent from child  Referral  ${USERNAME}    ${referralParent}
    Search a carrier in Account Manager  EFS  ${USERNAME}
    Add Parent To Child  Referral  ${referralParent}
    Validate Relationship in Database  Referral  ${username}  ${referralParent}

Set Expiration Date to Yesterday
    [Tags]  JIRA:BOT-1512  qTest:32445708  Regression
    [Teardown]  delete parent from child  Funding  ${USERNAME}  ${fundingParent}
    Search a carrier in Account Manager  EFS  ${USERNAME}
    Add Parent To Child  Funding  ${fundingParent}
    click on relationship tab
    set relationship expiration date  Funding  ${YESTERDAY}
    Submit Relationship Tab Data
    ${message}=  handle alert
    should contain  ${message}  the effective date must be before the expiration date

Set Effective Date to Yesterday
    [Tags]  JIRA:BOT-1511  qTest:32445707  Regression  refactor
    [Teardown]  delete parent from child  Funding  ${USERNAME}  ${fundingParent}
    Search a carrier in Account Manager  EFS  ${USERNAME}
    Add Parent To Child  Funding  ${fundingParent}
    click on relationship tab
    set relationship effective date  Funding  ${YESTERDAY}
    Submit Relationship Tab Data
    ${message}=  handle alert
    should contain  ${message}  the effective date cannot be changed from a future/current date to a date in the past

Apply Child discount
    [Tags]  JIRA:BOT-1511  qTest:32445723  Regression
    [Teardown]  delete parent from child  Funding  ${USERNAME}  ${fundingParent}
    Search a carrier in Account Manager  EFS  ${USERNAME}
    Add Parent To Child  Funding  ${fundingParent}
    Activate Child Discount Check Box  funding
    submit relationship tab data
    Validate Child Discount is Active  ${USERNAME}  funding

Current Group Children Are Correct
    [Tags]  JIRA:BOT-1520  qTest:32738725  Regression
    Search a carrier in Account Manager  EFS  ${fltoneparent}
    click on relationship tab
    click on child relationships button
    Validate Children On Screen  Group  ${fltoneparent}  expired=${False}

Current Referral Children Are Correct
    [Tags]  JIRA:BOT-1521  qTest:32738763  Regression
    Search a carrier in Account Manager  EFS  ${fltoneparent}
    click on relationship tab
    click on child relationships button
    Validate Children On Screen  Referral  ${fltoneparent}  expired=${False}

Current Expired Children Are Correct
    [Tags]  JIRA:BOT-1522  qTest:32738773  Regression
    Search a carrier in Account Manager  EFS  ${fltoneparent}
    click on relationship tab
    click on child relationships button
    Validate Children On Screen  Group  ${fltoneparent}  expired=${True}

Current Expired Referral Children Are Correct
    [Tags]  JIRA:BOT-1523  qTest:32738774  Regression  refactor
    Search a carrier in Account Manager  EFS  ${fltoneparent}
    click on relationship tab
    click on child relationships button
    Validate Children On Screen  Referral  ${fltoneparent}  expired=${True}

Fleet One: Attempt to Add a parent that is a non-parent
    [Tags]  JIRA:BOT-1524  JIRA:FLT-1387  qTest:32738785  Regression  refactor
    Search a carrier in Account Manager  EFS  ${fltonechild}
    click on relationship tab
    Validate Error on Add Parent  Funding  ${fltoneSecondChild}  Parent Id is child.

Fleet One: Attempt to Add a parent to a parent
    [Tags]  JIRA:BOT-1524  JIRA:FLT-1387  qTest:32738786  Regression  refactor
    Search a carrier in Account Manager  EFS  ${fltoneparent}
    click on relationship tab
    Validate Error on Add Parent  Funding  ${fltoneSecondParent}  Customer ID is parent ID.

Fleet One: Attempt to Add an EFS parent to a Fleet One child
    [Tags]  JIRA:BOT-1524  JIRA:FLT-1387  qTest:32738787  Regression  refactor
    Search a carrier in Account Manager  EFS  ${fltoneparent}
    click on relationship tab
    Validate Error on Add Parent  Funding  ${USERNAME}  Invalid Parent Carrier Id.

Fleet One: Attempt to Add a Fleet One Parent to an EFS child
    [Tags]  JIRA:BOT-1524  JIRA:FLT-1387  qTest:32740481  Regression  refactor
    Search a carrier in Account Manager  EFS  ${USERNAME}
    click on relationship tab
    Validate Error on Add Parent  Funding  ${fltoneparent}  Invalid Parent Carrier Id.

Add Parent with out selecting group or referral
    [Tags]  JIRA:BOT-1511  qTest:32445728  Regression
    Search a carrier in Account Manager  EFS  ${USERNAME}
    Add Parent To Child  ${None}  ${fundingParent}
    element text should be  xpath=//label[@for='parentRadioChoice']  This field is required.  This field should be required was not displayed when not selecting group or refferal parent
    go back to record search

Un-Apply Child Discount
    [Tags]  JIRA:BOT-1511  qTest:32446078  Regression
    [Setup]  delete parent from child  Funding  ${username}  ${fundingParent}
    [Teardown]  delete parent from child  Funding  ${USERNAME}  ${fundingParent}
    open account manager
    Search a carrier in Account Manager  EFS  ${USERNAME}
    Add Parent To Child  Funding  ${fundingParent}
    Activate Child Discount Check Box  funding
    Inactivate Child Discount Check Box  funding
    submit relationship tab data
    Validate Child Discount is Inactive  ${USERNAME}  funding

*** Keywords ***
Start Suite
    Open Account Manager
    get into db  TCH

    ${YESTERDAY}=  getdatetimenow  %Y-%m-%d  days=-1
    set global variable  ${YESTERDAY}

#    IF THIS PARENT AND CHILD ALREADY HAVE A RELATIONSHIP, MAKE NOTE SO THAT IT CAN BE RESTORED AT THE END OF THE TEST
    ${origFundingParent}=  query and strip
    ...  select 'exists' from carrier_group_xref where carrier_id = ${USERNAME} and parent = ${fundingParent}
    ${origReferralParent}=  query and strip
    ...  select 'exists' from carrier_referral_xref where carrier_id = ${USERNAME} and parent_id = ${referralParent}

    run keyword if  '${origFundingParent}'=='exists'  delete parent from child  Funding  ${USERNAME}    ${fundingParent}
    run keyword if  '${origReferralParent}'=='exists'  delete parent from child  Referral  ${USERNAME}    ${referralParent}


End Test
    close all browsers
    disconnect from database

Delete Parent From Child
    [Arguments]  ${type}  ${child}  ${parent}
#    DELETE THE PARENT/CHILD RELATIONSHIP
    ${table}=  run keyword if  '${type.lower()}'=='funding'  assign string  carrier_group_xref
    ...  ELSE IF  '${type.lower()}'=='referral'  assign string  carrier_referral_xref
    ...  ELSE  fail  Only "funding" or "referral" is permitted in this keyword name.
    ${parentColumn}=  run keyword if  '${type.lower()}'=='funding'  assign string  parent
    ...  ELSE IF  '${type.lower()}'=='referral'  assign string  parent_id
    ...  ELSE  fail  Only "funding" or "referral" is permitted in this keyword name.
    ${query}=  catenate
    ...  DELETE
    ...  FROM ${table}
    ...  WHERE carrier_id = ${child}
    ...  AND ${parentColumn} = ${parent}
    execute sql string  ${query}
    tch logging  \n\tREMOVED PARENT FROM CHILD:\n\t${query}  DEBUG

Add Parent To Child
    [Arguments]  ${type}  ${parent}
    click on relationship tab
    click on  text=Add Parent  index=1     # ADD PARENT
    input text  parentIdValue  ${parent}   # INPUT PARENT ID
    ${stat}=  evaluate  '${type}' != 'None'
    run keyword if  ${stat}  click radio button  ${type.upper()}    # SELECT "FUNDING" OR "REFERRAL"
    click on  text=Add Parent  index=2
    run keyword if  ${stat}  wait until element is not visible  xpath=//*[@aria-describedby="addParentModalContainer"]  timeout=20

Validate Error on Add Parent
    [Arguments]  ${type}  ${parent}  ${Error Message}
    click on relationship tab
    click on  text=Add Parent  index=1     # ADD PARENT
    input text  parentIdValue  ${parent}   # INPUT PARENT ID
    ${stat}=  evaluate  '${type}' != 'None'
    run keyword if  ${stat}  click radio button  ${type.upper()}    # SELECT "FUNDING" OR "REFERRAL"
    click on  text=Add Parent  index=2
    wait until element is visible  //div[@id="addParentMessages"]//ul[contains(@class,"msgError")]  15  Error Message Did Not Display In 15 seconds.
    element should contain  //div[@id="addParentMessages"]//ul[contains(@class,"msgError")]/li  ${Error Message}  ${Error Message} Was Not Found
    get text  //div[@id="addParentMessages"]//ul[contains(@class,"msgError")]

Click On Relationship Tab
    click on  text=Relationship

Validate Children On Screen
    [Arguments]  ${GroupOrReferral}  ${parent}  ${expired}=${False}

    ${group}=  evaluate  'funding' if '${GroupOrReferral}'.lower() == 'group' else 'referral'
    ${exp}=  evaluate  'Expired' if ${expired} else 'Current'
    ${rows}=  get element count  //*[@id='inverted${exp}_${group}']//tbody//tr
    ${dbRowCount}=  _get_db_relation_row_count  ${groupOrReferral}  ${parent}  ${expired}
    should be equal as numbers  ${rows}  ${dbRowCount}  msg=Account Manager shows ${rows} relations for ${exp} ${GroupOrReferral} Children the db shows ${dbRowCount}  values=${False}

    #Start on row to so that we don't include the title row
    FOR  ${row}  IN RANGE  2  ${rows+2}
        ${child}=  get table cell  //*[@id='inverted${exp}_${group}']  ${row}  1
        TCH LOGGING  Validating Child ${child} Relation Details  DEBUG
        ${db_row}=  _get_db_relation_details  ${GroupOrReferral}  ${parent}  ${child}  expired=${expired}
        ${name}=  get table cell  //*[@id='inverted${exp}_${group}']  ${row}  2
        ${effective}=  get table cell  //*[@id='inverted${exp}_${group}']  ${row}  3
        ${expiration}=  get table cell  //*[@id='inverted${exp}_${group}']  ${row}  4
        ${ch_discount}=  get table cell  //*[@id='inverted${exp}_${group}']  ${row}  5
        ${primary_parent}=  get table cell  //*[@id='inverted${exp}_${group}']  ${row}  6
        tch logging  Names: ${name} ${db_row["name"]}  DEBUG
        tch logging  Effective Date: ${effective} ${db_row["effective_date"]}  DEBUG
        tch logging  Expiration Date: ${expiration} ${db_row["expire_date"]}  DEBUG
        tch logging  Child Discount: ${ch_discount} ${db_row["allow_child_disc"]}  DEBUG
        tch logging  Primary Parent: ${primary_parent} ${db_row["primary_parent"]}  DEBUG
        should be equal as strings  ${name}  ${db_row["name"]}
        should be equal as strings  ${effective}  ${db_row['effective_date'].strftime('%Y-%m-%d')}
        should be equal as strings  ${expiration}  ${db_row['expire_date'].strftime('%Y-%m-%d')}
        should be equal as strings  ${ch_discount}  ${db_row["allow_child_disc"]}
        #Need to convert bolean value to string to compare db and table
        ${prim}=  evaluate  'Y' if ${db_row["primary_parent"]} is not None else ''
        should be equal  ${primary_parent}  ${prim}
    END


_get_db_relation_details
    [Arguments]  ${groupOrReferral}  ${parent}  ${child}  ${expired}=${False}

    ${is_referral}=  evaluate  '_id' if '${groupOrReferral}'.lower() == 'referral' else ''
    ${exp}=  evaluate  '<=' if ${expired} else '>'

    ${sql}=  catenate  SEPARATOR=
    ...  select cgx.carrier_id,m.name,cgx.effective_date,cgx.expire_date,cgx.allow_child_disc,${\n}
    ...  cgx.priority ,ppx.priority == 1 as primary_parent${\n}
    ...  from carrier_${groupOrReferral.lower()}_xref cgx${\n}
    ...     left join primary_parent_xref ppx${\n}
    ...        on cgx.carrier_id = ppx.carrier_id${\n}
    ...        and cgx.parent${is_referral} = ppx.parent_id${\n}
    ...    left join member m${\n}
    ...        on m.member_id = cgx.carrier_id${\n}
    ...  where cgx.parent${is_referral} = ${parent}${\n}
    ...  and cgx.carrier_id = ${child}${\n}
    ...  and cgx.expire_date ${exp} TODAY${\n}

    ${row}=  query and strip to dictionary  ${sql}

    [Return]  ${row}

_get_db_relation_row_count
    [Arguments]  ${groupOrReferral}  ${parent}  ${expired}=${False}

    ${is_referral}=  evaluate  '_id' if '${groupOrReferral}'.lower() == 'referral' else ''
    ${exp}=  evaluate  '<=' if ${expired} else '>'

    ${sql}=  catenate  SEPARATOR=
    ...  select cgx.carrier_id,m.name,cgx.effective_date,cgx.expire_date,cgx.allow_child_disc,${\n}
    ...  cgx.priority ,ppx.priority == 1 as primary_parent${\n}
    ...  from carrier_${groupOrReferral.lower()}_xref cgx${\n}
    ...     left join primary_parent_xref ppx${\n}
    ...        on cgx.carrier_id = ppx.carrier_id${\n}
    ...        and cgx.parent${is_referral} = ppx.parent_id${\n}
    ...    left join member m${\n}
    ...        on m.member_id = cgx.carrier_id${\n}
    ...  where cgx.parent${is_referral} = ${parent}${\n}
    ...  and cgx.expire_date ${exp} TODAY${\n}

    ${rowc}=  row count  ${sql}

    [Return]  ${rowc}


Click On Child Relationships Button
    ${onRelations}=  run keyword and return status  wait until element is visible  xpath=//button[contains(text(),'Child Relationships')]  timeout=10  error="Not Currently on Relationship Page"
    run keyword if  ${onRelations}  run keywords  click on  xpath=//button[contains(text(),'Child Relationships')]  AND  wait until element is visible  //button[contains(text(),'Parent Relationships')]  AND  SLEEP  5  AND  return from keyword

    ${OnChildren}=  run keyword and return status  wait until element is visible  //button[contains(text(),'Parent Relationships')]  timeout=10  error="Not Currently on Child Relations Page"
    run keyword if  ${OnChildren}  run keywords  tch logging  Already on Correct Tab Continuing  DEBUG  AND  return from keyword

    run keyword if  ${onRelations}  return from keyword  ELSE  FAIL  Not on the correct tab, expected to be on the Relationship tab in Parent Relations


Check AR Numbers In Dropdown Match Child AR Numbers
    [Arguments]  ${child}  ${parent}
#    GET CHILD AR NUMBERS ....
    ${query}=  catenate
    ...  select ar_number from contract where carrier_id = ${child}
    ${arNumbers}=  query and strip to dictionary  ${query}
    wait until element is visible
    ...  //*[text()="${parent}"]/parent::*/descendant::*[contains(@id,"vendorId")]
    ...  10 seconds
    ${dropDownArNumbers}=  get list items
    ...  //*[text()="${parent}"]/parent::*/descendant::*[contains(@id,"vendorId")]

#    VALIDATE THAT THE AR NUMBERS IN THE DROPDOWN ARE THE CHILD'S AR NUMBERS
    FOR  ${dbArNumber}  IN  @{arNumbers['ar_number']}
        list should contain value  ${dropDownArNumbers}  ${dbArNumber.strip()}
    END

Validate Relationship in Database
    [Arguments]  ${type}  ${child}  ${parent}

#    Submit
    click on  submit  index=1
    check element is null  Remove

#    MAKE SURE THERE IS AT LEAST A RECORD IN EITHER THE FUNDING OR REFERRAL TABLES FOR THIS RELATIONSHIP.
#    NO VALUES ARE VALIDATED AT THIS TIME.

    ${table}=  run keyword if  '${type.lower()}'=='funding'  assign string  carrier_group_xref
    ...  ELSE IF  '${type.lower()}'=='referral'  assign string  carrier_referral_xref
    ...  ELSE  fail  Only "funding" or "referral" is permitted in this keyword name.

    ${parentColumn}=  run keyword if  '${type.lower()}'=='funding'  assign string  parent
    ...  ELSE IF  '${type.lower()}'=='referral'  assign string  parent_id
    ...  ELSE  fail  Only "funding" or "referral" is permitted in this keyword name.

    ${query}=  catenate
    ...  SELECT 'exists'
    ...  FROM ${table}
    ...  WHERE carrier_id = ${child}
    ...  AND ${parentColumn} = ${parent}

    ${exists}=  query and strip  ${query}

    run keyword if  '${exists}'!='exists'  fail  Expected parent/child relationship and found none.

Set Relationship Expiration Date
    [Arguments]  ${relationship_type}  ${date}  ${row}=1
    wait until element is visible  xpath=//*[@id='edit_${relationship_type.lower()}_${row}_expireDate']
    input text  xpath=//*[@id='edit_${relationship_type.lower()}_${row}_expireDate']  ${date}

Set Relationship Effective Date
    [Arguments]  ${relationship_type}  ${date}  ${index}=1
    wait until element is visible  xpath=//*[@id='edit_${relationship_type.lower()}_${index}_effectiveDate']
    input text  xpath=//*[@id='edit_${relationship_type.lower()}_${index}_effectiveDate']  ${date}

Activate Child Discount Check Box
    [Arguments]  ${relationship_type}  ${index}=1
    checkbox should not be selected  xpath=//*[@id='edit_${relationship_type}_${index}_allowChildDiscount']
    select checkbox  xpath=//*[@id='edit_${relationship_type}_${index}_allowChildDiscount']

Inactivate Child Discount Check Box
    [Arguments]  ${relationship_type}  ${index}=1
    checkbox should be selected  xpath=//*[@id='edit_${relationship_type}_${index}_allowChildDiscount']
    unselect checkbox  xpath=//*[@id='edit_${relationship_type}_${index}_allowChildDiscount']

Submit Relationship Tab Data
    wait until element is enabled  xpath=//*[@id="submit"]
    double click on  xpath=//*[@id="submit"]  index=1  exactMatch=${False}

Validate Child Discount is Active
    [Arguments]  ${child}  ${relationship_type}  ${index}=1
    checkbox should be selected  xpath=//*[@id='edit_${relationship_type}_${index}_allowChildDiscount']

Validate Child Discount is Inactive
    [Arguments]  ${child}  ${relationship_type}  ${index}=1
    checkbox should not be selected  xpath=//*[@id='edit_${relationship_type}_${index}_allowChildDiscount']


