*** Settings ***
Documentation  This Tests merch deal for company and location
...  Adds deals for Company any carrier, Location Any Carrier
...  Adds deals for Company specific carrier, Location specific Carrier
...  Runs transaction for each type of deal as deal is created to test Hierachy and that deals are given
...  Also checks that deals display on emanager
...  Note if there is another active deal it will not remove the correct deal
...  Things to add would be tests for an imperial merchant since those are different

Library  DateTime
Library  Process
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Library  Collections
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.setup.PySetup
Library  otr_robot_lib.auth.PyAuth.Transactions
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Suite Setup  Suite Setup
Suite Teardown  clean up

Force Tags  eManager

*** Variables ***
${location} =   504522
${CDACretailPrice} =  0.07000   #CDAC Company Deal Any Carrier
${LDACretailPrice} =  0.06000   #LDAC Location Deal Any Carrier
${CDCretailPrice} =  0.04000    #CDC Company Deal for a Carrier
${LDCretailPrice} =  0.03000    #LDC Location Deal for a Carrier
${loc_date_format}  %Y-%m-%d %H:%M
${today}
${tomorrow}
${nextday}
${yesterday}
${merchUserName}  900074admin
${merchPassword}  q1w2e3r4
${merchId}  900074

*** Test Cases ***
Add Company Deal for Any Carrier
    [Tags]  JIRA:TRS-28408  JIRA:BOT-193  refactor
    Get to Company Deal Any Carrier
    input text  xpath=//*[@name="targetEffDts"]  ${tomorrow}
    input text  xpath=//*[@name="targetExpDts"]  ${nextday}
    click element  xpath=//*[@name='selectedDeal.dealType']/option[@value='D']
    input text  xpath=//*[@name="selectedDeal.retailMinus"]  ${CDACretailPrice}
    click element  xpath=//*[@name="chkInsertDeal"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Deal Created')]
    page should contain element  xpath=//*[@title="Deal for carrierId: -1, contractId: -1, merchantLevel: Y, merchantId ${MERCHID}, ownerLevel: Y, ownerId: ${MERCHID}"]

    ${output} =    query and strip to list  SELECT * FROM company_deals where carrier_id = -1 and company_id = ${MERCHID} and eff_dt > '${today}';
    Should Be Equal As Strings    ${output[0]}  -1
    Should Be Equal As Strings    ${output[1]}  -1
    Should Be Equal As Strings    ${output[2]}  ${MERCHID}
    Should Be Equal As Strings    ${output[5]}  ${CDACretailPrice}

Add Location Deal for Any Carrier
   [Tags]  JIRA:TRS-28408  JIRA:BOT-193  JIRA:BOT-1853  qTest:32303316  Regression  refactor
    Get to Location Deal Any Carrier
    input text  xpath=//*[@name="targetEffDts"]  ${tomorrow}
    input text  xpath=//*[@name="targetExpDts"]  ${nextday}
    click element  xpath=//*[@name='selectedDeal.dealType']/option[@value='D']
    input text  xpath=//*[@name="selectedDeal.retailMinus"]  ${LDACretailPrice}
    click element  xpath=//*[@name="chkInsertDeal"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Deal Created')]
    page should contain element  xpath=//*[@title="Deal for carrierId: -1, contractId: -1, merchantLevel: L, merchantId ${location}, ownerLevel: Y, ownerId: ${MERCHID}"]


    ${output} =    query and strip to list  SELECT * FROM location_deals where carrier_id = -1 and location_id = ${location} and eff_dt > '${today}';
    Should Be Equal As Strings    ${output[0]}  -1
    Should Be Equal As Strings    ${output[1]}  -1
    Should Be Equal As Strings    ${output[2]}  ${location}
    Should Be Equal As Strings    ${output[5]}  ${LDACretailPrice}

Add Company Deal for Carrier
    [Tags]  JIRA:TRS-28408  JIRA:BOT-193  refactor
    Get to Company Deal Carrier
    input text  xpath=//*[@name="targetEffDts"]  ${tomorrow}
    input text  xpath=//*[@name="targetExpDts"]  ${nextday}
    click element  xpath=//*[@name='selectedDeal.dealType']/option[@value='D']
    input text  xpath=//*[@name="selectedDeal.retailMinus"]  ${CDCretailPrice}
    click element  xpath=//*[@name="chkInsertDeal"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Deal Created')]
    page should contain element  xpath=//*[@title="Deal for carrierId: ${efs_fleet_card.carrier.id}, contractId: ${efs_fleet_card.policy.contract.id}, merchantLevel: Y, merchantId ${MERCHID}, ownerLevel: Y, ownerId: ${MERCHID}"]

    ${output} =    query and strip to list  SELECT * FROM company_deals where carrier_id = ${efs_fleet_card.carrier.id} and company_id = ${MERCHID} and eff_dt > '${today}';
    Should Be Equal As Strings    ${output[0]}  ${efs_fleet_card.carrier.id}
    Should Be Equal As Strings    ${output[1]}  ${efs_fleet_card.policy.contract.id}
    Should Be Equal As Strings    ${output[2]}  ${MERCHID}
    Should Be Equal As Strings    ${output[5]}  ${CDCretailPrice}

Add Location Deal for Carrier
    [Tags]  JIRA:TRS-28408  JIRA:BOT-193  JIRA:BOT-1853  qTest:32303317  Regression  refactor
    Get to Location Deal Carrier
    input text  xpath=//*[@name="targetEffDts"]  ${tomorrow}
    input text  xpath=//*[@name="targetExpDts"]  ${nextday}
    click element  xpath=//*[@name='selectedDeal.dealType']/option[@value='D']
    input text  xpath=//*[@name="selectedDeal.retailMinus"]  ${LDCretailPrice}
    click element  xpath=//*[@name="chkInsertDeal"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Deal Created')]
    page should contain element  xpath=//*[@title="Deal for carrierId: ${efs_fleet_card.carrier.id}, contractId: ${efs_fleet_card.policy.contract.id}, merchantLevel: L, merchantId ${location}, ownerLevel: Y, ownerId: ${MERCHID}"]

    ${output} =    query and strip to list  SELECT * FROM location_deals where carrier_id = ${efs_fleet_card.carrier.id} and location_id = ${location} and eff_dt > '${today}';
    Should Be Equal As Strings    ${output[0]}  ${efs_fleet_card.carrier.id}
    Should Be Equal As Strings    ${output[1]}  ${efs_fleet_card.policy.contract.id}
    Should Be Equal As Strings    ${output[2]}  ${location}
    Should Be Equal As Strings    ${output[5]}  ${LDCretailPrice}


*** Keywords ***
Carrier Transaction
    [Arguments]  ${retailPrice}

    execute sql string  dml=update company_deals set eff_dt = '${yesterday}' where eff_dt = '${tomorrow}' and deal_owner = ${MERCHID}
    execute sql string  dml=update cards set status = 'A' where card_num ='${efs_fleet_card.num}'

    ${TODAY}  getdatetimenow  %Y%m%d%H%M%S
    ${filepath}  Create Log File  ManageDeals  ManageDeals${TODAY}
    ${string} =  Create AC String  TCH  ${location}  ${efs_fleet_card.num}  ULSD=10
    run rossAuth   ${string}  ${filepath}
    ${transid}  Get Transaction ID From Log File  ${filepath}
    set log file  ${filepath}  remote=${True}

    ${discount}  query and strip  Select (retail_ppu - ppu) as discount from trans_line where trans_id = ${transid}
    should be equal as numbers  ${discount}  ${retailPrice}

Clean up
    run command  sudo rm -f /home/qaauto/el_robot/file.err  /home/qaauto/el_robot/file.log
    execute sql string  dml=delete from location_deals where eff_dt = '${yesterday}' and location_id = ${location}
    execute sql string  dml=delete from company_deals where eff_dt = '${yesterday}' and deal_owner = ${MERCHID}
    close browser

Delete deal
    click element  xpath=//*[@name="expireDeal"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Deal Updated')]

Get to Company Deal Any Carrier
    go to  ${emanager}/merch/ManageDeals.action
    select radio button  searchBy  all
    click element  xpath=//*[@name='dealLevel']/option[@value='Y']
    click element  xpath=//*[@name="updateTabCarrier"]

Get to Company Deal Carrier
    go to  ${emanager}/merch/ManageDeals.action
    select radio button  searchBy  carrier
    click element  xpath=//*[@name='dealLevel']/option[@value='Y']
    input text  xpath=//*[@name="carrierId"]  ${efs_fleet_card.carrier.id}
    click element  xpath=//*[@name="updateTabCarrier"]
    click element  xpath=//*[@name='contract']/option[@value='${efs_fleet_card.policy.contract.id}']
    click element  xpath=//*[@name="updateTabCarrier"]

Get to Location Deal Any Carrier
    go to  ${emanager}/merch/ManageDeals.action
    click element  xpath=//*[@name='dealLevel']/option[@value='L']
    select radio button  searchBy  all
    click element  xpath=//*[@name="updateTabCarrier"]
    select checkbox  xpath=//*[@value="${location}"]
    click element  xpath=//*[@name="updateTabMembers"]

Get to Location Deal Carrier
    go to  ${emanager}/merch/ManageDeals.action
    select radio button  searchBy  carrier
    click element  xpath=//*[@name='dealLevel']/option[@value='L']
    input text  xpath=//*[@name="carrierId"]  ${efs_fleet_card.carrier.id}
    click element  xpath=//*[@name="updateTabCarrier"]
    click element  xpath=//*[@name='contract']/option[@value='${efs_fleet_card.policy.contract.id}']
    click element  xpath=//*[@name="updateTabCarrier"]
    select checkbox  xpath=//*[@value="${location}"]
    click element  xpath=//*[@name="updateTabMembers"]

Location transaction
    [Arguments]  ${retailPrice}

    execute sql string  dml=update location_deals set eff_dt = '${yesterday}' where eff_dt = '${tomorrow}' and location_id = ${location}
    execute sql string  dml=update cards set status = 'A' where card_num ='${efs_fleet_card.num}'

    ${TODAY}  getdatetimenow  %Y%m%d%H%M%S
    ${filepath}  Create Log File  ManageDeals  ManageDeals${TODAY}
    ${string} =  Create AC String  TCH  ${location}  ${efs_fleet_card.num}  ULSD=10.00
    run rossAuth   ${string}  ${filepath}
    set log file  ${filepath}  remote=${True}
    ${transid}  Get Transaction ID From Log File  ${filepath}
    ${discount}  query and strip  Select (retail_ppu - ppu) as discount from trans_line where trans_id = ${transid}
    should be equal as numbers  ${discount}  ${retailPrice}

Suite Setup
    get into db  tch
    ${today}=    getDateTimeNow  ${loc_date_format}
    ${tomorrow}=  getDateTimeNow  ${loc_date_format}  days=1
    ${nextday}=  getDateTimeNow  ${loc_date_format}  days=2
    ${yesterday}=  getDateTimeNow  ${loc_date_format}  days=-1
    Set Suite Variable  ${today}
    Set Suite Variable  ${tomorrow}
    Set Suite Variable  ${nextday}
    Set Suite Variable  ${yesterday}

#   SETUP THE CARD FOR TRANSACTIONS
    Start Setup Card  ${efs_fleet_card.num}
    Setup Card Header  limitSource=CARD  policyNumber=1  status=ACTIVE
    Setup Card Limits  ULSD=9999
    Setup Card Contract  status=A

    log into card management web services  ${efs_fleet_card.carrier.id}  ${efs_fleet_card.carrier.password}
    loadCash  ${efs_fleet_card.num}  300.00

#    ${location}  set variable  ${efs_fleet_card.valid_location}
#    set suite variable  ${location}

#   MAKE SURE THE CONTRACT IS NOT MASTER OTHERWISE IT WONT SHOW UP AT THE COMPANY DEALS
    ${is_master}  Query And Strip  SELECT is_master FROM contract WHERE contract_id=${efs_fleet_card.policy.contract.id}
    Run Keyword IF  '${is_master}'=='N'  Tch Logging  CONTRACT IS NOT MASTER. PROCEED WITH TESTING
    ...  ELSE  execute sql string  dml=update contract SET is_master='N' WHERE contract_id=${efs_fleet_card.policy.contract.id}

#   BY DOING THIS IT'S GUARANTEED THAT THE LOGIN ON THAT USER WILL ALWAYS BE SUCCESSFUL
    get into db  mysql
    ${passwd}  Query And Strip  SELECT user_passwd FROM sec_user WHERE user_id ='MERCH_${merchUserName}'
    execute sql string  dml=update sec_user SET user_passwd = 'c62d929e7b7e7b6165923a5dfc60cb56' WHERE user_id ='MERCH_${merchUserName}'
    get into db  tch
    Open Merchant Manager
    Log into Merchant Manager  ${merchUserName}  ${merchPassword}