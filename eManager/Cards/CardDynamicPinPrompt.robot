*** Settings ***
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup    Run Keywords    Setup TCH Carrier and Card Number
Test Teardown    Logout and close browser
Suite Teardown    Disconnect From Database

*** Variables ***
${carrier}
${prompt}
${promptValue}

*** Test Cases ***
Card - Managed Dynamic Pin feature flag not enabled
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117483241    PI:15  refactor
    [Documentation]    Ensure dynamic pin is not available in card prompts when the flag is not enabled
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'off'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    # Check Control Number
    Delete card prompts available for dynamic pin from db
    Open the card details
    Dynamic pin dropdown must be displayed
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'CNTN' prompt added message
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check Personal ID Number
    Delete card prompts available for dynamic pin from db
    Click on 'Cancel'
    Click to add a new prompt
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'PPIN' prompt added message
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check Driver ID
    Delete card prompts available for dynamic pin from db
    Click on 'Cancel'
    Click to add a new prompt
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'DRID' prompt added message
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Remove permission and repeat steps
    Remove permission and repeat the steps to check no dynamic validation available

    [Teardown]    Run Keywords    Close Browser    Set Dynamic Feature Flag 'on'

Card - Carrier with no managed dynamic pin permission
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117483246    PI:15  refactor
    [Documentation]    Ensure dynamic pin is not available in card prompts when the permission is not set to the carrier
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Remove Manager Dynamic Pin Permission from Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    # Check for Driver ID
    Delete card prompts available for dynamic pin from db
    Set 'dynamic' validation 'DRID' prompt to card
    Open the card details
    Dynamic pin dropdown must not be displayed
    Dynamic pin 'Driver ID' prompt set must not have edit or delete button
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'CNTN' prompt added message
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check for Control Number
    Delete card prompts available for dynamic pin from db
    Set 'dynamic' validation 'CNTN' prompt to card
    Click on 'Cancel'
    Dynamic pin 'Control Number' prompt set must not have edit or delete button
    Click to add a new prompt
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'PPIN' prompt added message
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must not be displayed in the options list
    # Check for Personal ID Number
    Delete card prompts available for dynamic pin from db
    Set 'dynamic' validation 'PPIN' prompt to card
    Click on 'Cancel'
    Dynamic pin 'Personal ID Number' prompt set must not have edit or delete button
    Click to add a new prompt
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new 'DRID' prompt added message
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must not be displayed in the options list

Card - Setting new dynamic pin in prompts
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117483267    PI:15
    [Documentation]    Ensure dynamic pin can be set in card prompts when the permission is available for the carrier
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Delete card prompts available for dynamic pin from db
    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Open the card details
    Click Enable Dynamic Prompting button
    Click to add a new dynamic prompt
    Select 'Control Number' from prompt list
    Click on 'Confirm'
    Assert new 'dynamic' validation 'CNTN' added
    Delete card prompts available for dynamic pin from db
    Click Enable Dynamic Prompting button
    Click to add a new dynamic prompt
    Select 'Trip Number' from prompt list
    Click on 'Confirm'
    Assert new 'dynamic' validation 'TRIP' added

Card - Inactive/Policy dynamic pin in prompts
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117483276    PI:15  refactor
    [Documentation]    Ensure dynamic pin can be inactivated in card prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Delete card prompts available for dynamic pin from db
    Open the card details
    Dynamic pin dropdown must be displayed
    # Check for Inactive
    Set Dynamic Pin as 'Inactive' and save
    # Check Control Number, Driver ID and Personal ID Number
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Click on 'Cancel'
    # Check for Policy
    Set Dynamic Pin as 'Policy' and save
    # Check Control Number, Driver ID and Personal ID Number
    Click to add a new prompt
    Select 'Control Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Select 'Driver ID' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Click on 'Back'
    Select 'Personal ID Number' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list

Card - Inactive/Policy dynamic pin not available for existing dynamic pin
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117483279    PI:15  refactor
    [Documentation]    Ensure dynamic pin can not be inactivated when a dynamic pin is already set in card prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Delete card prompts available for dynamic pin from db
    Open the card details
    Set Dynamic Pin as 'Active' and save
    # Check for Driver ID
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'successfully'
    Set Dynamic Pin as 'Inactive' and save
    Assert 'Inactive' not available error message
    Set Dynamic Pin as 'Policy' and save
    Assert 'Policy' not available error message
    Delete 'Driver ID' ('DRID') dynamic validation prompt
    # Check for Control Number
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'successfully'
    Set Dynamic Pin as 'Inactive' and save
    Assert 'Inactive' not available error message
    Set Dynamic Pin as 'Policy' and save
    Assert 'Policy' not available error message
    Delete 'Control Number' ('CNTN') dynamic validation prompt
    # Check for Personal ID Number
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Set Dynamic Pin as 'Inactive' and save
    Assert 'Inactive' not available error message
    Set Dynamic Pin as 'Policy' and save
    Assert 'Policy' not available error message

Card - Dynamic pin can not be duplicated
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117483303    PI:15  refactor
    [Documentation]    Ensure another dynamic pin can not be set when there's already one created in card prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Delete card prompts available for dynamic pin from db
    Open the card details
    Set Dynamic Pin as 'Active' and save
    # Check for Driver ID
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'successfully'
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'expecting error'
    Click on 'Cancel'
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'expecting error'
    Click on 'Cancel'
    Delete 'Driver ID' ('DRID') dynamic validation prompt
    # Check for Personal ID Number
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'expecting error'
    Click on 'Cancel'
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'expecting error'
    Click on 'Cancel'
    Delete 'Personal ID Number' ('PPIN') dynamic validation prompt
    # Check for Control Number
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'successfully'
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'expecting error'
    Click on 'Cancel'
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'expecting error'

Card - Delete dynamic pin set
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117499311    PI:15  refactor
    [Documentation]    Ensure a dynamic pin can be deleted in card prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Delete card prompts available for dynamic pin from db
    Open the card details
    Set Dynamic Pin as 'Active' and save
    # Check for Driver ID
    Add a new 'Dynamic' validation 'Driver ID' ('DRID') prompt 'successfully'
    Delete 'Driver ID' ('DRID') dynamic validation prompt
    # Check for Personal ID Number
    Add a new 'Dynamic' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Delete 'Personal ID Number' ('PPIN') dynamic validation prompt
    # Check for Control Number
    Add a new 'Dynamic' validation 'Control Number' ('CNTN') prompt 'successfully'
    Delete 'Control Number' ('CNTN') dynamic validation prompt

Card - Dynamic option not available for other prompts
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117499660    PI:15    refactor
    [Documentation]    Ensure other prompts than Control Number, Driver ID and Personal ID has no dynamic option in
    ...    card prompts
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Delete card prompts available for dynamic pin from db
    Open the card details
    Click to add a new prompt
    Assert no dynamic option for prompts different than Control Number and Trip Number
    # TODO  Open 'Enable Dynamic Pormpting' and confirm only Control Number and Trip Number

Card - Edit to dynamic existing prompt
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117540243    PI:15  refactor
    [Documentation]    Ensure a prompt could be edit to dynamic if there isn't another dynamic prompt and if the card
    ...    has another dynamic prompt it could not be updated to dynamic
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Delete card prompts available for dynamic pin from db
    Set 'numeric' validation 'DRID' prompt to card
    Open the card details
    # Check for Driver ID
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new 'dynamic' validation 'DRID' edited
    Add a new 'Numeric' validation 'Control Number' ('CNTN') prompt 'successfully'
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new dynamic pin prompt error message
    Delete card prompts available for dynamic pin from db
    Set 'numeric' validation 'CNTN' prompt to card
    Click on 'Cancel'
    # Check for Control Number
    Click to edit new 'Control Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new 'dynamic' validation 'CNTN' edited
    Add a new 'Numeric' validation 'Personal ID Number' ('PPIN') prompt 'successfully'
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new dynamic pin prompt error message
    Delete card prompts available for dynamic pin from db
    Set 'numeric' validation 'PPIN' prompt to card
    Click on 'Cancel'
    # Check for Personal ID Number
    Click to edit new 'Personal ID Number' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new 'dynamic' validation 'PPIN' edited
    Add a new 'Numeric' validation 'Driver ID' ('DRID') prompt 'successfully'
    Click to edit new 'Driver ID' prompt
    Option 'Dynamic' must be displayed in the options list
    Select 'Dynamic' from validation list
    Click on 'Update'
    Assert new dynamic pin prompt error message

Card - Dynamic pin dropdown only displayed in prompts tab
    [Tags]    JIRA:ATLAS-2214    JIRA:BOT-5025    qTest:117760582    PI:15  refactor
    [Documentation]    Ensure dynamic pin dropdown only shows in prompts tab
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Open the card details
    Dynamic pin dropdown must be displayed
    Change to 'Limits' from 'Update Limits' tab
    Dynamic pin dropdown must not be displayed
    Change to 'Locations' from 'Location Group Management' tab
    Dynamic pin dropdown must not be displayed
    Change to 'Time Restrictions' from 'Update Time Restrictions' tab
    Dynamic pin dropdown must not be displayed

Card - View button pop-up shows correct prompt in message
    [Tags]    JIRA:ATLAS-2349    JIRA:ATLAS-2386    qTest:119358956    Q1:2023
    [Documentation]    When the **View** button is clicked ensure the pop-up message displays the correct prompt.
    ...  Card prompts will always take priority over policy prompts.
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Login Carrier with Cards to eManager
    Delete policy prompts available for dynamic pin from db
    Go to Select Program > Manage Policies > Manage Policies
    Get active policy number
    Delete policy prompts available for dynamic pin
    Go to Select Program > Manage Policies > Manage Policies
    Click Enable Dynamic Prompting button
    Select 'Trip Number' from drop-down list
    Click on 'Confirm'
    Delete card prompts available for dynamic pin from db
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Open the card details
    Set Policy Number and Information=BOTH
    Click **View** button and confirm message
    Click Enable Dynamic Prompting button
    Select 'Control Number' from drop-down list
    Click on 'Confirm'
    Click **View** button and confirm message

    [Teardown]  Run Keywords    Return info source back to start setting    Logout and close browser

Card - Home Screen Shows Correct Message
    [Tags]    JIRA:ATLAS-2386    qTest:120073350    Q1:2023
    [Documentation]    When logged in as a card user the home screen should show the following message:
    ...  "Use this value when prompted for <prompt> or for your PIN when using an ATM.
    ...  Prompt will expire in 30 minutes. You can request a new prompt at any time."
    [Setup]    Run Keywords    Set Dynamic Feature Flag 'on'    Add Managed Dynamic Pin Permission to Carrier

    Get Dynamic Prompt From DB
    Login With Card
    Confirm Message

*** Keywords ***
Add a new '${validation}' validation '${prompt}' ('${prompt_id}') prompt '${condition}'
    [Documentation]    Add new prompt validation to card

    Click to add a new prompt
    Select '${prompt}' from prompt list
    Click on 'Next'
    Option '${validation}' must be displayed in the options list
    Select '${validation}' from validation list
    Click on 'Next'
    Run Keyword If    '${validation}'=='Dynamic'    Click on 'Finish'
    ...    ELSE    Click on 'Next'
    ${validation}    String.Convert To Lower Case    ${validation}
    Run Keyword If    '${condition}'=='successfully'    Assert new '${validation}' validation '${prompt_id}' added
    ...    ELSE    Assert new dynamic pin prompt error message

Add Managed Dynamic Pin Permission to Carrier
    [Documentation]    Add managed dynamic pin permission to test carrier

    Ensure Carrier has User Permission    ${carrier.id}    MANAGED_DYNAMIC_PIN_ALLOWED

Assert '${status}' not available error message
    [Documentation]    Ensure status is not set when there is already a dynamic prompt added

    Page Should Contain    That card has one Dynamic Validation added. Remove it first to inactive Dynamic PIN.

Assert new '${prompt_id}' prompt added message
    [Documentation]    Check creation message

    Wait Until Page Contains    You have successfully created the prompt of (${prompt_id}).

Assert new '${prompt_id}' prompt edited message
    [Documentation]    Check edition message

    Wait Until Page Contains    You have successfully edited the prompt of (${prompt_id}).

Assert new '${validation}' validation '${prompt}' added
    [Documentation]    Check new prompt added

    ${value}    Run Keyword If    '${validation}'=='dynamic'    Set Variable    D
    ...    ELSE IF    '${validation}'=='numeric'    Set Variable    N
    Assert new '${prompt}' prompt added message
    Assert new prompt added in db    ${prompt}    ${value}

Assert new '${validation}' validation '${prompt}' edited
    [Documentation]    Check new prompt edited

    ${value}    Run Keyword If    '${validation}'=='dynamic'    Set Variable    D
    ...    ELSE IF    '${validation}'=='numeric'    Set Variable    N
    Assert new '${prompt}' prompt edited message
    Assert new prompt added in db    ${prompt}    ${value}
Assert new dynamic pin prompt error message
    [Documentation]    Check dynamic validation duplicate not available message

    Page Should Contain    That card already has another dynamic validation recorded

Assert new prompt added in db
    [Documentation]    Check new prompt added via db
    [Arguments]    ${prompt_id}    ${expected_value}

    Get into DB    TCH
    ${query}    Catenate    SELECT info_validation
    ...    FROM card_inf
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND info_id = '${prompt_id}';
    ${value}    Query And Strip    ${query}
    Should be Equal as Strings    ${value}    ${expected_value}

Assert no dynamic option for prompts different than Control Number and Trip Number
    [Documentation]    Ensure dynamic validation is not an option from prompts where it should not be available

    ${list}    Get List Items    name=cardInfo.infoId
    FOR    ${option}    IN    @{list}
        Select '${option}' from prompt list
        Click on 'Next'
        Option 'Dynamic' must not be displayed in the options list
        Click on 'Back'
    END

Change to '${menu}' from '${option}' tab
    [Documentation]  Move from current tab

    ${id}    Run Keyword If    '${menu}'=='Limits'    Set Variable    cardLimits
    ...    ELSE IF    '${menu}'=='Locations'    Set Variable    cardLocation
    ...    ELSE IF    '${menu}'=='Time Restrictions'    Set Variable    cardTimeRestriction
    ${id}    Get Substring    ${menu}    0    -1
    ${id}    Catenate    card${id}
    ${id}    Evaluate    '${id}'.replace(' ','')
    Mouse Over    //*[contains(@id, 'cardMenubar') and contains(text(), '${menu}')]
    ${opt_xpath}    Set Variable    //*[contains(@id, '${id}') and contains(text(), '${option}')]
    Wait Until Element is Visible    ${opt_xpath}
    Click Element    ${opt_xpath}
    Wait Until Element is Visible    name=saveCardInformation

Check no dynamic validation available for '${prompt}' ('${prompt_id}')
    [Documentation]    Check dynamic validation not available for prompts in adition or edition

    Click to add a new prompt
    Select '${prompt}' from prompt list
    Click on 'Next'
    Option 'Dynamic' must not be displayed in the options list
    Select 'Numeric' from validation list
    Click on 'Next'
    Click on 'Next'
    Assert new '${prompt_id}' prompt added message
    Click to edit new '${prompt}' prompt
    Option 'Dynamic' must not be displayed in the options list

Click **View** button and confirm message
    ${viewMessage}  Catenate  Use this value when prompted for ${prompt} or for your PIN when using an ATM.
    ...    Prompt will expire in 30 minutes. You can request a new prompt at any time.
    Click Element    name=openDynamicModalB
    Wait Until Element Is Visible    //*[@id="dynamicMessage" and text()="${viewMessage}"]
    Page Should Contain Element    //*[@id="dynamicMessage" and text()="${viewMessage}"]
    Click Button    name=closeDynamicModal

Click Enable Dynamic Prompting button
    [Documentation]  Click 'Enable Dynamic Prompting' button and wait until 'Confirm' button is present
    Reload Page
    Wait Until Element Is Visible    //*/input[@name="enableDynamicPrompting"]
    Click Button    //*/input[@name="enableDynamicPrompting"]
    Wait Until Element Is Visible    //*/input[@name="addDynamicPin"]          # Confirm button

Click on '${button}'
    [Documentation]    Click button by its value

    Wait Until Element is Visible    //input[@value='${button}']
    Click Button    //input[@value='${button}']

Click to add a new dynamic prompt
    [Documentation]    Click to add a new prompt via details screen

    Click Element    name=cardInfo.infoId
    Wait Until Element is Visible    //*/option[@value="CNTN"]

Click to add a new prompt
    [Documentation]    Click to add a new prompt via details screen

    Click Element    name=createPromptCard
    Wait Until Element is Visible    name=validationInformation

Click to edit new '${prompt}' prompt
    [Documentation]    Click to edit a prompt

    ${edit_xpath}    Set Variable    //*[contains(text(), '${prompt}')]//parent::tr//input[@name="editInformation"]
    Wait Until Element is Visible    ${edit_xpath}
    Click Element    ${edit_xpath}

Confirm Message
    ${viewMessage}  Catenate  Use this value when prompted for ${prompt} or for your PIN when using an ATM.
    ...    Prompt will expire in 30 minutes. You can request a new prompt at any time.
    ${homeMessage}    Get Text    //*[@id="ARFORM"]/table/tbody/tr[4]/td
    Should Be Equal As Strings    ${viewMessage}    ${homeMessage}

Delete policy prompts available for dynamic pin
    [Documentation]    Delete dynamic validation prompts by clicking 'Disable Dynamic Prompting' button

    ${button}  Get Value  //*/form/input[8]
    IF  '${button}'=='Disable Dynamic Prompting'
        Click On  name=disableDynamicPrompting
        Wait Until Page Contains Element  name=deletedDynamicPin
        Click On  name=deletedDynamicPin
        Wait Until Page Contains Element  name=enableDynamicPrompting
    END

Delete '${prompt}' ('${prompt_id}') dynamic validation prompt
    [Documentation]    Delete dynamic validation prompt from card via details screen

    ${prompt_del_xpath}    Set Variable    //*[contains(text(), '${prompt}')]//parent::tr//input[@name="deleteCardPrompt"]
    Wait Until Page Contains Element    ${prompt_del_xpath}
    Delete prompt    ${prompt_del_xpath}
    Wait Until Page Does Not Contain Element    ${prompt_del_xpath}
    Get Into DB    TCH
    ${query}    Catenate    SELECT *
    ...    FROM card_inf
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND info_id = '${prompt_id}'
    ...    AND info_validation = 'D';
    Row Count Is Equal To X    ${query}    0

Delete prompt
    [Documentation]    Delete card prompt via details screen
    [Arguments]    ${xpath}

    Click Element    ${xpath}
    Handle Alert

Delete Prompt ${prompt}
#    [Arguments]  ${prompt}
    ${promptValue}  Run Keyword And Continue On Failure  Get Text  //*[@id="both"]/tbody/tr[*]/td[contains(text(),"${prompt}")]
    IF    '${promptValue}' == '${prompt}'
        click element  //*[contains(text(),'${prompt}')]/..//*[@name='deleteCardPrompt']
        Handle Alert
        wait until element is not visible  //*[contains(text(),'${prompt}')]/..//*[@name='deleteCardPrompt']  timeout=10  error=${prompt} prompt not deleted within 10 seconds
    END

Delete card prompt from db
    [Documentation]    Delete validation prompt from card via db
    [Arguments]    ${prompt_id}

    Get into DB    TCH
    ${query}    Catenate    DELETE FROM card_inf
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND info_id = '${prompt_id}';
    Execute SQL String    ${query}

Delete policy prompt from db
    [Documentation]    Delete validation prompt from policy via db
    [Arguments]    ${prompt_id}

    Get into DB    TCH
    ${query}    Catenate    DELETE FROM def_info
    ...    WHERE carrier_id = '${carrier.id}'
    ...    AND info_id = '${prompt_id}';
    Execute SQL String    ${query}

Delete card prompts available for dynamic pin from db
    [Documentation]    Delete dynamic validation prompts from card via db

    Delete card prompt from db    DRID
    Delete card prompt from db    TRIP
    Delete card prompt from db    PPIN
    Delete card prompt from db    CNTN

Delete policy prompts available for dynamic pin from db
    [Documentation]    Delete dynamic validation prompts from policy via db

    Delete policy prompt from db    DRID
    Delete policy prompt from db    TRIP
    Delete policy prompt from db    PPIN
    Delete policy prompt from db    CNTN

Dynamic pin '${prompt}' prompt set must not have edit or delete button
    [Documentation]    Dynamic pin prompt must no have edit or delete button displayed

    ${prompt_xpath}    Set Variable    //*[contains(text(), '${prompt}')]//parent::tr
    Page Should Not Contain Element    ${prompt_xpath}//input[@name="editInformation"]
    Page Should Not Contain Element    ${prompt_xpath}//input[@name="deleteCardPrompt"]

Dynamic pin dropdown must be displayed
    [Documentation]    Dynamic pin must be shown in details screen

    Page Should Contain    Dynamic PIN:
    Page Should Contain Element    name=card.header.dynamicPinFlag

Dynamic pin dropdown must not be displayed
    [Documentation]    Dynamic pin must not be shown in details screen

    Page Should Not Contain    Dynamic PIN:
    Page Should Not Contain Element    name=card.header.dynamicPinFlag

Ensure Carrier has TCH Company Header
    [Documentation]    Change carrier header to tch company header

    Change Company Header    ${carrier.id}    company_header=tch_carrier

Get active policy number
    ${policyNumber}    Get Value    //*[@id="plicyNumberSel"]/option[@selected="selected"]
    Set Test Variable    ${policyNumber}

Get Dynamic Prompt From DB
    Get Into DB    TCH
    ${query}    Catenate    SELECT info_id
    ...    FROM def_info
    ...    WHERE carrier_id = ${carrier.id}
    ...    AND   info_validation = 'D';
    ${policyPrompt}    Query And Strip    ${query}

    ${query}    Catenate    SELECT info_id
    ...    FROM card_inf
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND   info_validation = 'D';
    ${cardPrompt}    Query And Strip    ${query}

    IF    '${cardPrompt}' != '${EMPTY}'
        IF    '${cardPrompt}' == 'CNTN'
            Set Test Variable    ${prompt}    Control Number
        ELSE IF    '${cardPrompt}' == 'TRIP'
            Set Test Variable    ${prompt}    Trip Number
        END
    ELSE IF    '${policyPrompt}' != '${EMPTY}'
        IF    '${cardPrompt}' == 'CNTN'
            Set Test Variable    ${prompt}    Control Number
        ELSE IF    '${cardPrompt}' == 'TRIP'
            Set Test Variable    ${prompt}    Trip Number
        END
    END

Go to Select Program > Manage Cards > View/Update Cards
    [Documentation]  Go to Select Program > Manage Cards > View/Update Cards

    Go To  ${emanager}/cards/CardLookup.action

Go to Select Program > Manage Policies > Manage Policies
    [Documentation]  Go to Select Program > Manage Policies > Manage Policies

    Go To  ${emanager}/cards/PolicyPromptManagement.action
    Wait Until Page Contains Element  //input[@name="enableDynamicPrompting"]

Login Carrier with Cards to eManager
    [Documentation]    Login to emanager with test carrier

    Open eManager    ${carrier.id}    ${carrier.password}    ChangeCompanyHeader=False

Login With Card
    Open Emanager  ${intern}  ${internPassword}
    Go To  ${emanager}/security/ManageCustomers.action
    Select From List By Label    //select[@name="searchType"]    Card
    Select From List By Value    //select[@name="searchInstance"]    TCH
    Input Text    name=searchCarrier    ${carrier.id}
    Input Text    name=searchCard    ${carrier.cardnum}
    Click Button    //input[@name="searchCards"]
    Wait Until Element Is Visible    //*[@id="view"]//a[text()='${carrier.cardnum}']
    Click Element    //*[@id="view"]//a[text()='${carrier.cardnum}']
    Wait Until Element Is Visible    //*[@id="requestionDynamicPin"]

Logout and close browser
    Log Out Of eManager
    Close Browser

Open the card details
    [Documentation]    Open details screen from card number

    Click Element    //*[@id="cardSummary"]//a[text()='${carrier.cardnum}']
    Wait Until Page Contains Element    name=saveCardInformation
    Click Element    //*[@name='card.header.infoSource' and @value='CARD']
    Click Button    name=saveCardInformation
    Wait Until Page Contains Element    name=createPromptCard

Option '${validation}' must be displayed in the options list
    [Documentation]    Validation must be displayed in list

    ${validation}    String.Convert To Upper Case    ${validation}
    Wait Until Element is Visible    //input[@name='disableDynamicPrompting']
    Page Should Contain Element    //*/tbody/tr[3]/td[contains(text(), "Dynamic")]      # //select[@name="cardInfo.validationType"]/*[@value='${validation}']

Option '${validation}' must not be displayed in the options list
    [Documentation]    Validation must not be displayed in list

    ${validation}    String.Convert To Upper Case    ${validation}
    Wait Until Element is Visible    //input[@value='Cancel']
    Page Should Not Contain Element    //select[@name="cardInfo.validationType"]/*[@value='${validation}']

Remove Manager Dynamic Pin Permission from Carrier
    [Documentation]    Remove managed dynamic pin permission from test carrier

    Remove Carrier User Permission    ${carrier.id}    MANAGED_DYNAMIC_PIN_ALLOWED

Remove permission and repeat the steps to check no dynamic validation available
    [Documentation]    Repeat validations for no permission when feature flag is off

    Close Browser
    Remove Manager Dynamic Pin Permission from Carrier
    Login Carrier with Cards to eManager
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    # Check for Control Number
    Delete prompts available for dynamic pin from db
    Open the card details
    Dynamic pin dropdown must not be displayed
    Check no dynamic validation available for 'Control Number' ('CNTN')
    # Check for Driver ID
    Delete prompts available for dynamic pin from db
    Click on 'Cancel'
    Check no dynamic validation available for 'Driver ID' ('DRID')
    # Check for Personal ID Number
    Delete prompts available for dynamic pin from db
    Click on 'Cancel'
    Check no dynamic validation available for 'Personal ID Number' ('PPIN')

Return info source back to start setting
    Go to Select Program > Manage Cards > View/Update Cards
    Search card number
    Open the card details
    Click On    //*/input[@name="card.header.infoSource" and @value="${information}"]
    Click Button    name=saveCardInformation
    Wait Until Element Is Visible   name=saveCardInformation

Search card number
    [Documentation]    Search card number from test carrier

    Select Radio Button    lookupInfoRadio    NUMBER
    Input Text    name=cardSearchTxt    ${carrier.cardnum}
    Click Button    name=searchCard
    Wait Until Element is Visible    //*[@id="cardSummary"]//a[text()='${carrier.cardnum}']

Select '${prompt}' from drop-down list
    Click Element    name=cardInfo.infoId
    Wait Until Element is Visible    //*/option[@value="CNTN"]
    Select From List By Label    name=cardInfo.infoId    ${prompt}
    Set Test Variable  ${prompt}

Select '${prompt}' from prompt list
    [Documentation]    Select prompt from list

    Select From List By Label    name=cardInfo.infoId    ${prompt}

Select '${option}' from validation list
    [Documentation]    Select validation from list

    Select From List By Label    name=cardInfo.validationType    ${option}

Set '${validation}' validation '${prompt_id}' prompt to card
    [Documentation]    Set new prompt validation to card via db
    ...    note: it can be dynamic (D) or numeric (N)

    ${val}    Run Keyword If    '${validation}'=='dynamic'    Set Variable    D
    ...    ELSE IF    '${validation}'=='numeric'    Set Variable    N
    Get Into DB    TCH
    ${update_query}    Catenate    UPDATE card_inf
    ...    SET info_validation = '${val}'
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND info_id = '${prompt_id}';
    ${insert_query}    Catenate    INSERT INTO card_inf
    ...    VALUES ('${carrier.cardnum}', '${prompt_id}', '${val}');
    ${select_query}    Catenate    SELECT info_validation
    ...    FROM card_inf
    ...    WHERE card_num = '${carrier.cardnum}'
    ...    AND info_id = '${prompt_id}';
    ${value}    Query And Strip    ${select_query}
    Run Keyword If    '${value}'=='None'    Execute SQL String    ${insert_query}
    ...    ELSE IF    '${value}'!='${val}'    Execute SQL String    ${update_query}

Set Dynamic Feature Flag '${cond}'
    [Documentation]    Set feature flag on or off

    Get Into DB    MYSQL
    ${flag_value}    Run Keyword If    '${cond}'=='on'    Set Variable    Y
    ...    ELSE    Set Variable    N
    ${query}    Catenate    UPDATE setting
    ...    SET value = '${flag_value}'
    ...    WHERE `partition` = 'shared'
    ...    AND name ='FLAG_OTREPIC-3901';
    Execute SQL String    ${query}

Set Dynamic Pin as '${status}' and save
    [Documentation]    Set dynamic pin dropdown to Active, Inactive or Policy in card details screen

    Select From List By Label    name=card.header.dynamicPinFlag    ${status}
    Click Button    name=saveCardInformation
    Wait Until Element is Visible    name=createPromptCard

Set Policy Number and Information=BOTH
    [Documentation]  Set the Information source to BOTH

    ${information}  Get Value  name=card.header.infoSource
    Set Test Variable  ${information}
    Select From List By Value   name=card.header.policyNumber   ${policyNumber}
    Click ON    //*/input[@name="card.header.infoSource" and @value="BOTH"]
    Click Button    name=saveCardInformation
    Wait Until Element Is Visible   name=openDynamicModalB

Setup Carrier Card Number
    [Documentation]    Get a valid card number from selected carrier

    Get Into DB    TCH
    ${query}    Catenate    SELECT TRIM(c.card_num) AS card_num, c.created
     ...    FROM cards c
     ...    INNER JOIN card_pins cp ON c.card_num = cp.card_num
     ...    WHERE c.carrier_id = '${carrier.id}'
     ...    AND c.card_num NOT LIKE '%OVER'
     ...    AND cp.passcode != 'NULL'
     ...    AND c.status = 'A'
     ...    AND c.cardoverride = '0'
     ...    LIMIT 1;
    ${card_info}    Query And Strip to Dictionary    ${query}
    Set Suite Variable    ${carrier.cardnum}    ${card_info["card_num"]}

Setup TCH Carrier and Card Number
    [Documentation]    Get carrier and card number for the tests

    Setup TCH Carrier with Cards
    Setup Carrier Card Number

Setup TCH Carrier with Cards
    [Documentation]    Get a valid tch carrier with cards available and ensure it has TCH company header

    Get Into DB    TCH
    ${query}    catenate    SELECT m.member_id, m.passwd
    ...    FROM cards c
    ...    INNER JOIN card_pins cp ON c.card_num = cp.card_num
    ...    INNER JOIN member m ON c.carrier_id = m.member_id
    ...    WHERE cp.passcode != 'NULL'
    ...    AND   c.status = 'A'
    ...    AND   m.mem_type = 'C'
    ...    LIMIT 1;
#    ${query}    Catenate    SELECT member_id, passwd
#    ...    FROM member m
#    ...    INNER JOIN cards c
#    ...    ON c.carrier_id = m.member_id
#    ...    WHERE mem_type = 'C'
#    ...    AND m.status = 'A'
#    ...    AND (member_id BETWEEN 100000 AND 200000
#    ...    OR member_id BETWEEN 250000 AND 299999
#    ...    OR member_id BETWEEN 300000 AND 389999)
#    ...    LIMIT 1;
    ${carrier_info}    Query And Strip to Dictionary    ${query}
    ${carrier}    Create Dictionary    id=${carrier_info["member_id"]}    password=${carrier_info["passwd"]}
    Set Suite Variable    ${carrier}
#    Ensure Carrier has TCH Company Header