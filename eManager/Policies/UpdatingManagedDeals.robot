*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  ../../Variables/validUser.robot

Documentation  Test creating and updating location deals through Web E-Manager. \n\n
...   A user should not be able to edit a deal that is scheduled to start in 15 minutes or less. \n\n
...   He should only be allowed to expire it. \n\n

Suite Setup  Time to Setup
Suite Teardown  Time to Tear Down
Force Tags  eManager

*** Variables ***

${minutes}

*** Test Cases ***
Updating Managed deals(Maverik) - 15min --
    [Tags]  JIRA:BOT-208  refactor
    set test variable  ${minutes}  -00:15:00
    Open eManager  ${user_deal}  ${passwd_deal}
    Maximize Browser Window
    Test Supplier Selection
    Test Deal Creation
    Confirm Creation 10--
    tch logging  Updating Managed deals 15min -- successful!

Updating Managed deals(Maverik) - 15min ++
    [Tags]  JIRA:BOT-208  JIRA:BOT-1757  refactor
    set test variable  ${minutes}  00:15:00
    Test Deal Creation
    Confirm Creation 10++
    Check DB for New Deal
    Test Deal Editing 10++
    go to  ${emanager}/cards/CarrierManagedDeals.action?viewExistingDeals
    Test a Deal Editing Loophole
    Delete Deal
    tch logging  Updating Managed deals 15min ++ successful!

*** Keywords ***
Test Supplier Selection
    Mouse Over    id=menubar_1x2
    Mouse Over    id=TCHONLINE_MANAGEPRICINGx2
    Click Element    id=MANAGEPRICING_VIEW_EXISTING_DEALSx2
    Click Element   //*[text()='Select Supplier(s)']
    Unselect Checkbox  //*[@value="850000009" and @name="selectedSupplierIds"]
    Unselect Checkbox  //*[@value="900012" and @name="selectedSupplierIds"]
    Unselect Checkbox  //*[@value="850000007" and @name="selectedSupplierIds"]
    Unselect Checkbox  //*[@value="850000006" and @name="selectedSupplierIds"]
    Click Button  name=btnNext
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'You must select a supplier to continue')]
    Select Checkbox  //*[@value="900012" and @name="selectedSupplierIds"]
    Click Button  name=btnNext
    ${location}=  get text  //*[@id="locationViews"]/tbody/tr[1]/td[4]
    set global variable  ${location}
    Click Element  xpath=(//input[@name="selectedLocationIds"])[1]
    Click Button  name=btnNewDeal

Test Deal Creation
    ${datetime}=  get value  id=targetEffDts
    ${time} =	Add Time To Date	${datetime}  ${minutes}
    set global variable  ${time}
    Input Text  id=targetEffDts  ${time}
    Input Text  id=edtRetailMinus  0.100
    Click Button  id=chkInsertDeal

Check DB for New Deal
    Get into DB  tch
    ${output}=  query   SELECT location_id FROM location_deals WHERE carrier_id=${user_deal} AND location_id=${location} ORDER BY created DESC limit 1  db_instance=tch
    ${stripper}=  strip db query  ${output}
    should be equal as strings  ${stripper}  ${location}

Confirm Creation 10++
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'Deal Created')]

Confirm Creation 10--
    Page Should Contain Element  //*[@class="errors"]//*[contains(text(), 'Invalid Effective Date: new deals must start at least 15 minutes in the future.')]

Test Deal Editing 10++
    ${location}=  get text   //*[@id="locationViews"]/descendant::*/tr[1]/td[4]
    Click Element  //*[contains(text(),${location})]/../*[2]/img
    wait until element is visible  //*[@type="image" and @name="selectUpdateDealChoices"]
    click element  //*[@type="image" and @name="selectUpdateDealChoices"]
    Element Should Be Disabled  id=targetEffDts
    Element Should Be Enabled  id=targetExpDts
    Element Should Be Enabled  id=cbxDealType
    Element Should Be Enabled  id=edtRetailMinus
    tch logging  Expiration Date, Deal Type and Retail Minus are editable. Effective Date is disabled.

Test a Deal Editing Loophole
    ${location_id}=  get text   //*[@id="locationViews"]/descendant::*/tr[3]/td[4]
    Click Element  //*[contains(text(),${location})]/../*[2]/img
    wait until element is visible  //*[@type="image" and @name="selectUpdateDealChoices"]
    click element  //*[@type="image" and @name="selectUpdateDealChoices"]
    Element Should Be Disabled  id=targetEffDts
    Element Should Be Enabled  id=targetExpDts
    tch logging  All fields except the "Expiration Date" field are read-only.

Delete Deal
    go to  ${emanager}/cards/CarrierManagedDeals.action?viewExistingDeals
    Click Element  //*[contains(text(),${location})]/../*[2]/img
    wait until element is visible  //*[@type="image" and @name="chkExpireDeals"]
    click element  //*[@type="image" and @name="chkExpireDeals"]
    Click button  id=legAlerts_popup_ok
    Page Should Contain Element  //*[@class="messages"]//*[contains(text(), 'Deal Expired')]

    Get into DB  tch
    row count is 0  SELECT location_id FROM location_deals WHERE carrier_id=${user_deal} AND location_id=${location} ORDER BY created DESC limit 1

Time to Setup
    #Remove existing Deals to make sure we are clean
    get into db  tch
    execute sql string  dml=delete from location_deals where carrier_id=${user_deal} AND eff_dt > '2018-01-01 00:00'

Time to Tear Down
    close browser


