*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  AM

*** Variables ***

*** Test Cases ***
Change Location Information
    [Tags]  JIRA:BOT-675  qTest:27260629  refactor
    [Documentation]  Change location information – Like address and verify changes were saved
    [Setup]  Find Carrier With Multiple Parents Assigned

    Open eManager  ${intern}  ${internPassword}
    Navigate To Account Management -> Account Manager
    Select Customers Tab
    Select EFS LLC On Business Partner
    Input ${carrierId} On Customer
    Click On Submit Button
    Click ${carrierId} Customer# In Results
    Select 'Detail' page
    Click On Funding Parents
    You Should See a Pop-Up Window Showing Parents And Funding Parent If Set
    Close Funding Parents Pop-Up
    Select 'Relationship' page
    Select a True Funding Parent
    Submit Relationship
    You Should See a "Edit Successful" Message

    [Teardown]  Close Browser

*** Keywords ***
Click ${carrierId} Customer# In Results
    Click Element  //*[@class="id buttonlink" and contains(text(), '${carrierId}')]
    wait until page does not contain element  //*[@class="loading-img"]  timeout=60

Click All Submit Buttons
    ${submits}=  Get Webelements  //*[@id="submit"]
    FOR  ${button}  IN  @{submits}
        run keyword and return status  click element  ${button}
    END

Click On Funding Parents
    Click Element  //*[@class="buttonlink fundingParentsLink" ]

Click On Submit Button
    Click Element  //*[@class="button searchSubmit"]
    wait until page does not contain element  //*[@class="loading-img"]  timeout=60

Close Funding Parents Pop-Up
    Click Element  //button[@class="buttonlink right" and contains(text(), "Close")]

Find Carrier With Multiple Parents Assigned
    Get Into Db  TCH
    ${query}=  Catenate  SELECT carrier_id
    ...  FROM carrier_group_xref cgx
    ...  WHERE (cgx.effective_date IS NULL OR cgx.effective_date <= current)
    ...  AND (cgx.expire_date IS NULL OR cgx.expire_date > current)
    ...  GROUP BY carrier_id
    ...  HAVING count(*) > 1;

    ${result}=  query and strip to dictionary  ${query}
    ${carrierIds}=  Get from dictionary  ${result}  carrier_id
    ${carrierId}=  Evaluate  random.choice(${carrierIds})  random

    Set Test Variable  ${carrierId}

Get a Random Parent ID
    wait until page contains element  //*[@id="edit_funding"]/tbody/tr
    ${parents}=  get element count  //*[@id="edit_funding"]/tbody/tr
    ${number}=  Evaluate  random.choice(range(1,${parents}))  random
    ${parentId}=  Get Text  //*[@id="edit_funding"]/tbody/tr[@class="dataRow"]/td[@id="edit_funding_${number}_parentId"]

    [Return]  ${parentId}

Input ${customer_id} On Customer
    Input Text  id  ${customer_id}

Navigate To ${menu} -> ${menu_item}
    Hover Over  //*[@class="horz_nlsitem" and text()="Select Program"]
    Hover Over  //*[@class="nlsitem" and text()="${menu}"]
    Click Element  //*[@class="nlsitem" and text()="${menu_item}"]

Select a True Funding Parent
    ${parentId}=  Get a Random Parent ID
    click element  //*[@id="trueFundingParent" and @value="${parentId}"]

Select Customers Tab
    click element  //*[@id="Customer"]

Select 'Detail' page
    Click Element  //*[@id="Detail"]
    wait until page does not contain element  //*[@class="loading-img"]  timeout=60

Select 'Relationship' page
    Click Element  //*[@id="Relationship"]
    wait until page contains element  //*[@class="loading-img"]  timeout=60
    wait until page does not contain element  //*[@class="loading-img"]  timeout=60

Select EFS LLC On Business Partner
    select from list by value  businessPartnerCode  EFS

Submit Relationship
    Click All Submit Buttons

You Should See a "Edit Successful" Message
    page should contain  Edit Successful

You Should See a Pop-Up Window Showing Parents And Funding Parent If Set
    wait until page contains element  //*[@id="fundingParentsTemplateDialogContainer"]  timeout=10
    page should contain element  //*[@id="fundingParentsTemplateTable"]//label[contains(text(), 'Parent Cust')]
    page should contain element  //*[@id="fundingParentsTemplateTable"]//label[contains(text(), 'Parent Name')]
    page should contain element  //*[@id="fundingParentsTemplateTable"]//label[contains(text(), 'True Funding Parent')]
