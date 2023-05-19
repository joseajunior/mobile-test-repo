*** Settings ***
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Force Tags  AM

Test Setup    Run Keywords    Setup Check Number    Open Account Manager
Test Teardown    Close Browser
Suite Teardown    Disconnect From Database

*** Variables ***
${check_num}
${exp_image_name}
${comment_id}
${comment}
${comment_date}
${comment_by}
${special_chars_input}    .,&-



*** Test Cases ***
Verify check image link
    [Tags]  JIRA:ATLAS-2064    JIRA:BOT-5023    qTest:117327219    PI:15
    [Documentation]    Ensure a check has the image linked in details in Checks/Money Codes tab in AM
    [Setup]    Run Keywords    Setup Check Number with Image    Open Account Manager

    Open Checks/Money Codes tab
    Search for Check Number
    Open Check Number from search result table
    Compare Check Image link

Add new check note
    [Tags]  JIRA:ATLAS-2064    JIRA:BOT-5023    qTest:117357863    PI:15
    [Documentation]    Ensure you can add new check note in check details in check/money codes tab in AM

    Open Checks/Money Codes tab
    Search for Check Number
    Open Check Number from search result table
    Create check comment
    Verify comment creation

Verify check notes history
    [Tags]  JIRA:ATLAS-2064    JIRA:BOT-5023    qTest:117357884    PI:15
    [Documentation]    Ensure notes are saved the history in check details check/money codes tab in AM

    Open Checks/Money Codes tab
    Search for Check Number
    Open Check Number from search result table
    Create check comment
    Verify comment creation
    Open comment history
    Check comment info in history
    Close comment history
    Create another check comment
    Verify another comment creation
    Open comment history
    Check comment info in history
    Close comment history

Edit check information
    [Tags]  JIRA:ATLAS-2064  JIRA:ATLAS-2369  JIRA:BOT-5023  qTest:117357929  PI:15  qTest:119675117  Q1:2023

    [Documentation]    Ensure check information can be updated in check details in check/money codes tab in AM having
    ...    edit check permission

    Open Checks/Money Codes tab
    Search for Check Number
    Open Check Number from search result table
    Update Check Info
    Assert new data in database
    Update Check Info  -1
    Assert new data in database

View only check information
    [Tags]  JIRA:ATLAS-2064    JIRA:BOT-5023    qTest:117357956    PI:15
    [Documentation]    Ensure check information is displayed in view only mode in check details in check/money codes
    ...    tab in AM not having the edit check permission
    [Setup]    Run Keywords    Remove Edit Check permission    Setup Check Number    Open Account Manager

    Open Checks/Money Codes tab
    Search for Check Number
    Open Check Number from search result table
    Check view only mode in checks

    [Teardown]    Run Keywords    Close Browser    Insert Edit Check permission

Allow special characters to Pending Check Void > Reason Voided field
    [Tags]    JIRA:ATLAS-2223    JIRA:BOT-5034    qTest:118534604    PI:15  ditOnly
    [Documentation]    Reason Voided field in checks detail screen should only allow these special characters . , & -

    Open Checks/Money Codes tab
    Search for Check Number
    Open Check Number from search result table
    Add reason voided value with special characters
    Assert reason voided special characters in db

*** Keywords ***
Setup Check Number
    [Documentation]    Get check number from database
    ...    withoutComment: set as true to get a check without comments set
    [Arguments]    ${withoutComment}=True

    ${cond}    Run Keyword If    '${withoutComment}'=='True'    Set Variable    WHERE c.check_num NOT IN (SELECT check_num FROM chk_comment)
    ...    ELSE    Set Variable    ${EMPTY}
    Get Into DB  TCH
    ${query}    Catenate    SELECT c.check_num
    ...    FROM checks c
    ...    INNER JOIN code_use cu
    ...    ON cu.check_num = c.check_num
    ...    ${cond}
    ...    ORDER BY use_time DESC
    ...    LIMIT 1;
    ${check_num}    Query And Strip    ${query}
    Set Test Variable    ${check_num}

Setup Check Number with Image
    [Documentation]    Get check number with image set from database

    Get Into DB  TCH
    ${query}    Catenate    SELECT checknumber, imagename
    ...    FROM tab_check_image_info
    ...    LIMIT 1;
    ${info}    Query And Strip to Dictionary    ${query}
    Set Test Variable    ${check_num}    ${info["checknumber"]}
    Set Test Variable    ${exp_image_name}    ${info["imagename"]}

Remove Edit Check permission
    [Documentation]    Remove AM_Edit_Check_Detail permission from groups and at user level

    Get Into DB    MYSQL
    Remove group permission    AM_Edit_Check_Detail    AM_TOOL    F1
    Remove group permission    AM_Edit_Check_Detail    OpsSup    F1
    Remove group permission    AM_Edit_Check_Detail    COMPANY_ADMIN    940a82f8a659c5326e42201013fcaa63
    Remove permission    AM_Edit_Check_Detail    internRobot

Remove group permission
    [Documentation]    Remove permission inside a group
    [Arguments]    ${role_id}    ${group_id}    ${company_id}

    ${query}    Catenate    DELETE FROM sec_role_group_xref
    ...    WHERE role_id = '${role_id}'
    ...    AND group_id = '${group_id}'
    ...    AND company_id = '${company_id}';
    Execute SQL String    ${query}

Remove permission
    [Documentation]    Remove a permission at user level
    [Arguments]    ${role_id}    ${user_id}

    ${query}    Catenate    DELETE FROM sec_user_role_xref
    ...    WHERE role_id = '${role_id}'
    ...    AND user_id = '${user_id}';
    Execute SQL String    ${query}

Insert Edit Check permission
    [Documentation]    Add AM_Edit_Check_Detail permission to groups and at user level

    Get Into DB    MYSQL
    Insert group permission    AM_Edit_Check_Detail    AM_TOOL    F1    true
    Insert group permission    AM_Edit_Check_Detail    OpsSup    F1    false
    Insert group permission    AM_Edit_Check_Detail    COMPANY_ADMIN    940a82f8a659c5326e42201013fcaa63    false
    Insert permission    AM_Edit_Check_Detail    internRobot    false

Insert group permission
    [Documentation]    Insert permission inside a group
    [Arguments]    ${role_id}    ${group_id}    ${company_id}    ${visible_menu}

    ${query}    Catenate    INSERT INTO sec_role_group_xref
    ...    VALUES ('${role_id}', '${group_id}', '${company_id}', ${visible_menu});
    Execute SQL String    ${query}

Insert permission
    [Documentation]    Insert a permission at user level
    [Arguments]    ${role_id}    ${user_id}    ${visible_menu}

    ${query}    Catenate    INSERT INTO sec_user_role_xref
    ...    VALUES ('${user_id}', '${role_id}', ${visible_menu});
    Execute SQL String    ${query}

Open Checks/Money Codes tab
    [Documentation]    Open Checks/Money Codes tab in account manager

    Wait Until Element is Visible    id=Checks
    Click Element    id=Checks

Search for Check Number
    [Documentation]    Search in checks/money codes tab by check number

    Wait Until Element is Visible    //*[@class="dataTables_scrollHead"]//select[@class="checksBusinessPartnerSelect searchFilter" and @name="businessPartnerCode"]
    Select From List By Value    //*[@class="dataTables_scrollHead"]//select[@class="checksBusinessPartnerSelect searchFilter" and @name="businessPartnerCode"]    EFS
    Input Text    name=checkNumber    ${check_num}
    Click Element  //*[@id="checksSearchContainer"]//*[contains(text(),'Submit')]

Open Check Number from search result table
    [Documentation]    Open check number details screen

    Wait Until Element is Visible    //*[@class="checkNumber buttonlink" and text()='${check_num}']
    Click Element    //*[@class="checkNumber buttonlink" and text()='${check_num}']
    Wait Until Element is Visible    name=detailRecord.checkNumber

Compare Check Image link
    [Documentation]    Ensure check image has correct image link

    Page Should Contain    Check Image
    Click Element    //label[contains(text(), 'Check Image')]/parent::td/following-sibling::td/button
    ${image_name}    Get Element Attribute    //*[@id="check-image-src"]    src
    Should Contain    ${image_name}    ${exp_image_name}

Create check comment
    [Documentation]    Add a check note
    [Arguments]    ${comment}=testing

    Input Text    name=detailRecord.checkComment    ${comment}
    # ensure no invalid data is set
    Input Text    name=detailRecord.locationName    testing
    Input Text    name=detailRecord.payee    testing
    Input Text    name=detailRecord.settleId    1
    Input Text    name=detailRecord.settleAmount    1
    Submit new data waiting success message
    Get and set comment id

Submit new data waiting success message
    [Documentation]    Submit new data in check details and wait on sucess message

    Click Element    //button[contains(text(), 'Submit')]
    Wait Until Element is Visible    //*[@id="checksMessages"]//*[text()="Edit Successful"]

Create another check comment
    [Documentation]    Add another check note

    Create check comment    testing123

Get and set comment id
    [Documentation]    Get comment id for assertions

    Get Into DB  TCH
    ${query}    Catenate    SELECT comment_id
    ...    FROM chk_comment
    ...    WHERE check_num = '${check_num}'
    ...    ORDER BY comment_id DESC
    ...    LIMIT 1;
    ${comment_id}    Query And Strip    ${query}
    Set Test Variable    ${comment_id}

Verify comment creation
    [Documentation]    Check comment was correctly added in database
    [Arguments]    ${exp_comment}=testing

    Get Into DB  TCH
    ${query}    Catenate    SELECT TRIM(comment) as comment, TRIM(comment_by) as comment_by, comment_date
    ...    FROM chk_comment
    ...    WHERE check_num = '${check_num}'
    ...    AND  comment_id = '${comment_id}';
    ${info}    Query And Strip to Dictionary    ${query}
    ${exp_curdate}    Get Current Date    result_format=%Y%m%d
    Set Test Variable    ${comment}    ${info["comment"]}
    Set Test Variable    ${comment_date}    ${info["comment_date"]}
    Set Test Variable    ${comment_by}    ${info["comment_by"]}
    Should Be Equal as Strings    ${exp_comment}    ${comment}
    Should Be Equal as Strings    ${exp_curdate}    ${comment_date}
    Should Be Equal as Strings    internRobo    ${comment_by}

Verify another comment creation
    [Documentation]    Check second comment was correctly added in database

    Verify comment creation    testing123

Open comment history
    [Documentation]    Open comment history page in check details

    Page Should Contain    Comments History
    Click element    id=historyview
    Wait Until Element is Visible    id=commentshistorysection
    Wait Until Element is Visible    //*[@id="commentshistorysection"]//td[text()='${comment_id}']

Check comment info in history
    [Documentation]    Compare comment data from database and history page

    Check comment date in history
    Check comment in history
    Check comment by in history

Check comment date in history
    [Documentation]    Compare comment date from database and history page

    Get Text and Compare    //*[@id="commentshistorysection"]//td[text()='${comment_id}']/parent::tr/td[2]    ${comment_date}

Check comment in history
    [Documentation]    Compare comment from database and history page

    Get Text and Compare    //*[@id="commentshistorysection"]//td[text()='${comment_id}']/parent::tr/td[3]    ${comment}

Check comment by in history
    [Documentation]    Compare comment by from database and history page

    Get Text and Compare    //*[@id="commentshistorysection"]//td[text()='${comment_id}']/parent::tr/td[4]    ${comment_by}

Get Text and Compare
    [Documentation]    General keyword to compare a text element with expected text
    [Arguments]    ${xpath}    ${exp_data}

    ${data}    Get Text    ${xpath}
    Should Be Equal as Strings    ${data}    ${exp_data}

Close comment history
    [Documentation]    Close comment history page in check details

    Click Element    //button[contains(text(), 'Close')]

Update Check Info
    [Documentation]    Update amount, voided, when voided and date cleared in check details
    [Arguments]    ${settleId}=1    ${amount}=10    ${voided}=N    ${when_voided}=10/15/2022    ${date_cleared}=10/15/2022

    Input Text    name=detailRecord.amount    ${amount}
    Input Text    name=detailRecord.voided    ${voided}
    Input Text    name=detailRecord.dateVoided    ${when_voided}
    Input Text    name=detailRecord.dateCheckCleared    ${date_cleared}
    Replace possible invalid values   ${settleId}
    Submit new data waiting success message

Replace possible invalid values
    [Documentation]    Replace invalid values to be able to save new data
    [Arguments]    ${settleId}=1  ${text}=testing  ${settleAmount}=1

    Input Text    name=detailRecord.locationName  ${text}
    Input Text    name=detailRecord.payee  ${text}
    Input Text    name=detailRecord.settleId  ${settleId}
    Input Text    name=detailRecord.settleAmount  ${settleAmount}


Assert new data in database
    [Documentation]    Ensure update in database regarding new data set in check details
    [Arguments]    ${amount}=10.00    ${voided}=N    ${when_voided}=2022-10-15 00:00:00    ${date_cleared}=2022-10-15

    Get Into DB  TCH
    ${query}    Catenate    SELECT amount, voided, when_voided, bank_clr
    ...    FROM checks
    ...    WHERE check_num = '${check_num}';
    ${info}    Query And Strip to Dictionary    ${query}
    Should Be Equal as Strings    ${amount}    ${info["amount"]}
    Should Be Equal as Strings    ${voided}    ${info["voided"]}
    Should Be Equal as Strings    ${when_voided}    ${info["when_voided"]}
    Should Be Equal as Strings    ${date_cleared}    ${info["bank_clr"]}

Check view only mode in checks
    [Documentation]    Ensure data cannot be updated without AM_Edit_Check_Detail permission

    Element Should Not Be Visible    //*[@id="checksActionFormContainer"]//*[contains(text(),'Reset')]
    Element Should Not Be Visible    //*[@id="checksActionFormContainer"]//*[contains(text(),'Submit')]

Add reason voided value
    [Documentation]    Add a reason voided to the check
    [Arguments]    ${reason_voided_val}

    Input Text    name=detailRecord.voidedreason    ${reason_voided_val}
    Replace possible invalid values
    Submit new data waiting success message

Add reason voided value with special characters
    [Documentation]    Add a reason voided to the check with special characters

    Add reason voided value     ${special_chars_input}

Assert reason voided special characters in db
    [Documentation]    Ensure special characters in reason voided were saved to database

    Get Into DB    TCH
    ${query}    Catenate    SELECT voided_reason
    ...    FROM checks
    ...    WHERE check_num = '${check_num}';
    ${reason_voided_value}    Query And Strip    ${query}
    Should Be Equal As Strings    ${reason_voided_value}   ${special_chars_input}

