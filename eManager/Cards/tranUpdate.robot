*** Settings ***
Test Timeout  5 minutes
Documentation
...  This tests the new feature of add chains for resrictions and a new tran_update p which works like white list
...  This test Policy location, Policy Chain, Card Location and Card Chain Authorized and Unauthorized
...  This also tests location group management.

Library  DateTime
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  String
Library  otr_robot_lib.ssh.PySSH
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_robot_lib.auth.PyAuth.Transactions
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot

Force Tags    eManager  Cards  Locations  TranUpdate

Suite Setup  setup suite

*** Variables ***
${Ycarrier} =  100045
${Pcarrier} =  141526
${Ncarrier} =  133505

${Pcard} =  7083051014152600019
${Ycard} =  7083059961002501221
${Pcardid} =  1000002821180
${Ncard} =  7083050713350517047
${Ncardid} =  1000002904516

${pilot} =  231008
${pilotChain} =  1
${loves} =  516505
${lovesChain} =  2


*** Test Cases ***
##########################################
###      TRAN_UPDATE P TESTS           ###
##########################################
Policy Location for Tran_update = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  WASBUGGED: The system shows a message saying Successfully removed location from the list of authorized locations. But it is not occurring, it is not getting down into the box of Unauthorized locations, and also it is not reflecting in the database on table def_locs
    Set Suite Variable  ${DB}  TCH
    Make Sure Carrier Is Active  ${Pcarrier}
    Remove Authorized Policy Location  ${DB}  ${loves}  ${Pcarrier}  ${PcardPolicy}
    go to  ${emanager}/cards/PolicyLocationManagement.action?policy.policyNumber=${PcardPolicy}&sitePolicy=false
    click element  xpath=//*[@name="doCreatePolicyAuthorize"]
    input text  xpath=//*[@name="id"]  ${loves}
    click element  xpath=//*[@name="searchLocation"]
    click element  xpath=//*[@name="authorizeIds"]
    click element  xpath=//*[@name="saveUnauthorizedLocations"]

DB Check for Policy Location TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968
    ${output}=    query and strip  select location_id from def_locs where location_id = ${loves} and carrier_id = ${Pcarrier} and ipolicy = ${PcardPolicy}
    should be equal as strings  ${loves}  ${output}

Invalid Auth for Policy Location TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUPPolicyLocInvalid
    run keyword  Invalid Auth  ${Pcard}

Valid Auth for Policy Location TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    [Documentation]  THIS TEST IS WORKING and it is only failing in reason that in this same suite there is another test case that is bugged associated
#    SETUP THE CARD FOR TRANSACTION
#    LOAD CASH
    Log file name  TUPPolicyLocValid
    run keyword  Valid Auth  ${Pcard}

Policy Chain for Tran_update = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    Remove Authorized Policy Chain  ${DB}  ${lovesChain}  ${Pcarrier}  ${PcardPolicy}
    go to  ${emanager}/cards/PolicyChainManagement.action?policy.policyNumber=${PcardPolicy}&sitePolicy=false
    click element  xpath=//*[@name="createPolicyAuthorizeChain"]
    select checkbox      xpath=//*[@value='${lovesChain}' and @name='slcChainIds']
    click element  xpath=//*[@name="save"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully added chain number(s)(2)')]

DB Check for Policy Chain TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    ${output}=    query and strip  select chain_id from def_chains where chain_id = 2 and carrier_id = ${Pcarrier} and ipolicy = ${PcardPolicy}
    should be equal as strings  2  ${output}

Invalid Auth for Policy Chain TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUPPolicyChainInvalid
    run keyword  Invalid Auth  ${Pcard}

Valid Auth for Policy Chain TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
#    CARD SETUP
    Log file name  TUPPolicyChainValid
    run keyword  Valid Auth  ${Pcard}
    [Teardown]  Remove Policy Chain  ${lovesChain}  ${Pcard}  ${PcardPolicy}

Card Location for Tran_update = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968
    Remove Authorized Card Location  ${DB}  ${loves}  ${Pcard}
    go to  ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    input text  xpath=//*[@name='cardSearchTxt']  ${Pcard}
    click element  xpath=//*[@name='searchCard']
    click link  //*[@id="cardSummary"]/tbody/tr/td[1]/a
    Go to Locations then Update Locations
    Wait Until Page Contains Element  //*[@value='Authorize Location' and @name="doCreateAuthorize"]  timeout=30
    click element  xpath=//*[@value='Authorize Location' and @name="doCreateAuthorize"]
    input text  xpath=//*[@name='id' and @type="text"]     ${loves}
    click button     xpath=//*[@name='searchLocation']
    select checkbox      xpath=//*[@value='${loves}' and @name='authorizeIds']
    click element    xpath=//*[@name='saveUnauthorizedLocations']

DB Check for Card Location TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully removed location')]
    ${output}=    query and strip  select location_id from card_loc where location_id = ${loves} and card_num = '${Pcard}'
    should be equal as strings  ${loves}  ${output}

Invalid Auth for Card Location TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUPCardLocInvalid
    run keyword  Invalid Auth  ${Pcard}

Valid Auth for Card Location TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUPCardLocValid
    Run Keyword  Valid Auth  ${Pcard}
    [Teardown]  Remove Card Location  ${loves}  ${Pcardid}  ${Pcard}  ${PcardPolicy}

Card Chain for Tran_update = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    Remove Authorized Card Chain  ${DB}  ${lovesChain}  ${Pcard}
    go to  ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    input text  xpath=//*[@name='cardSearchTxt']  ${Pcard}
    click element  xpath=//*[@name='searchCard']
    click link  //*[@id="cardSummary"]/tbody/tr/td[1]/a
    Go to Locations then Update Chains
    Wait Until Page Contains Element  //*[@name='createCardAuthorizeChain']  timeout=30
    click element    xpath=//*[@name='createCardAuthorizeChain']
    select checkbox      xpath=//*[@value='${lovesChain}' and @name='slcChainIds']
    click element  xpath=//*[@name="save"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully added chain number(s)(2)')]

DB Check for Card Chain TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    ${output}=    query and strip  select chain_id from card_chain where chain_id = 2 and card_num = '${Pcard}'
    should be equal as strings  2  ${output}

Invalid Auth for Card Chain TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUPCardChainInvalid
    run keyword  Invalid Auth  ${Pcard}

Valid Auth for Card Chain TU = P
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUPCardChainValid
    run keyword  Valid Auth  ${Pcard}
    [Teardown]  Remove Card Chain  ${lovesChain}  ${Pcardid}  ${Pcard}  ${PcardPolicy}

#############################################
###      TRAN_UPDATE N TESTS              ###
#############################################

Policy Location for Tran_update = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  WASBUGGED: The system shows a message saying Successfully removed location from the list of authorized locations. But it is not occurring, it is not getting down into the box of Unauthorized locations, and also it is not reflecting in the database on table def_locs  refactor
    [Documentation]  According to the Location Setup Page on Wiki, when member.tran_update=N, in order for the transaction to run the location MUST NOT BE in the card_locs or def_locs table.
    Set Suite Variable  ${DB}  TCH
    Make Sure Carrier Is Active  ${Ncarrier}
    open emanager  ${Ncarrier}  ${Npassword}
    Remove Authorized Policy Location  ${DB}  ${pilot}  ${Ncarrier}  ${NcardPolicy}
    go to  ${emanager}/cards/PolicyLocationManagement.action?policy.policyNumber=${NcardPolicy}&sitePolicy=false
    click element  xpath=//*[@name="doCreatePolicyUnauthorize"]
    input text  xpath=//*[@name="id"]  ${pilot}
    click element  xpath=//*[@name="searchLocation"]
    click element  xpath=//*[@name="authorizeIds"]
    click element  xpath=//*[@name="saveUnauthorizedLocations"]

DB Check for Policy Location TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    [Documentation]  THIS TEST IS WORKING and it is only failing in reason that in this same suite there is another test case that is bugged associated
    Get Into DB  tch
    ${output}=    query and strip  select location_id from def_locs where location_id = ${pilot} and carrier_id = ${Ncarrier} and ipolicy =${NcardPolicy}
    should be equal as strings  ${pilot}  ${output}

Invalid Auth for Policy Location TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    [Documentation]  THIS TEST IS WORKING and it is only failing in reason that in this same suite there is another test case that is bugged associated
    Log file name  TUNPolicyLocInalid
    run keyword  Invalid Auth  ${Ncard}

Valid Auth for Policy Location TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUNPolicyLocValid
    Remove Authorized Policy Location  ${DB}  ${loves}  ${Ncarrier}  ${NcardPolicy}
    run keyword  Valid Auth  ${Ncard}

Policy Chain for Tran_update = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    Remove Authorized Policy Chain  ${DB}  ${pilotChain}  ${Ncarrier}  ${NcardPolicy}
    go to  ${emanager}/cards/PolicyChainManagement.action?policy.policyNumber=2&sitePolicy=false
    click element  xpath=//*[@name="createPolicyUnauthorizeChain"]
    select checkbox      xpath=//*[@value='${pilotChain}' and @name='slcChainIds']
    click element  xpath=//*[@name="save"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully added chain number(s)(1)')]

DB Check for Policy Chain TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    ${output}=    query and strip  select chain_id from def_chains where chain_id = 1 and carrier_id = ${Ncarrier} and ipolicy = ${NcardPolicy}
    should be equal as strings  1  ${output}

Invalid Auth for Policy Chain TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUNPolicyChainInvalid
    run keyword  Invalid Auth  ${Ncard}

Valid Auth for Policy Chain TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUNPolicyChainValid
    run keyword  Valid Auth  ${Ncard}
    [Teardown]  Remove Policy Chain  ${pilotChain}  ${Ncard}  ${NcardPolicy}

Card Location for Tran_update = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    Remove Authorized Card Location  ${DB}  ${pilot}  ${Ncard}
    go to  ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    input text  xpath=//*[@name='cardSearchTxt']  ${Ncard}
    click element  xpath=//*[@name='searchCard']
    click link  //*[@id="cardSummary"]/tbody/tr/td[1]/a
    Go to Locations then Update Locations
    Wait Until Page Contains Element  //*[@value='Unauthorize Location' and @name="doCreateUnauthorize"]  timeout=30
    click element  xpath=//*[@value='Unauthorize Location' and @name="doCreateUnauthorize"]
    input text  xpath=//*[@name='id' and @type="text"]  ${pilot}
    click button  xpath=//*[@name='searchLocation']
    select checkbox  xpath=//*[@value='${pilot}' and @name='authorizeIds']
    click element  xpath=//*[@name='saveUnauthorizedLocations']

DB Check for Card Location TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully removed location')]
    ${output}=    query and strip  select location_id from card_loc where location_id = ${pilot} and card_num = '${Ncard}'
    should be equal as strings  ${pilot}  ${output}

Invalid Auth for Card Location TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUNCardLocInvalid
    run keyword  Invalid Auth  ${Ncard}

Valid Auth for Card Location TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUNCardLocValid
    run keyword  Valid Auth  ${Ncard}
    [Teardown]  Remove Card Location  ${pilot}  ${Ncardid}  ${Ncard}  ${NcardPolicy}

Card Chain for Tran_update = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    Remove Authorized Card Chain  ${DB}  ${pilotChain}  ${Ncard}
    go to  ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    input text  xpath=//*[@name='cardSearchTxt']  ${Ncard}
    click element  xpath=//*[@name='searchCard']
    click link  //*[@id="cardSummary"]/tbody/tr/td[1]/a
    Go to Locations then Update Chains
    click element    xpath=//*[@name='createCardUnauthorizeChain']
    select checkbox      xpath=//*[@value='${pilotChain}' and @name='slcChainIds']
    click element  xpath=//*[@name="save"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'Successfully added chain number(s)(1)')]

DB Check for Card Chain TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    ${output}=    query and strip  select chain_id from card_chain where chain_id = 1 and card_num = '${Ncard}'
    should be equal as strings  1  ${output}

Invalid Auth for Card Chain TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUNCardChainInvalid
    run keyword  Invalid Auth  ${Ncard}

Valid Auth for Card Chain TU = N
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUNCardChainValid
    run keyword  Valid Auth  ${Ncard}
    [Teardown]  Remove Card Chain  ${pilotChain}  ${Ncardid}  ${Ncard}  ${NcardPolicy}

#############################################
###      TRAN_UPDATE Y TESTS              ###
#############################################

Policy Loc Grp for for Tran_update = Y
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    [Documentation]  When member.tran_update=Y  All locations are restricted except for what is allowed in a specific location
    ...     that is assigned to the carrier. A record must be in issr_loc for the issuer the carrier is assigned to for the
    ...     location being used.
    Set Suite Variable  ${DB}  TCH
    Make Sure Carrier Is Active  ${Ycarrier}
    Open eManager  ${Ycarrier}  ${Ypassword}
    Remove Authorized Policy Location Group  ${DB}  ${Ycarrier}  ${YcardPolicy}  1736
#    Remove Authorized Policy Location Group  ${Ycarrier}  ${YcardPolicy}  1401
    Go To  ${emanager}/cards/PolicyLocationGroupManagement.action?policy.policyNumber=${YcardPolicy}&sitePolicy=false
    Select Checkbox  xpath=//*[@value='1736' and @name='policyGroupIds']

Invalid Auth for Policy Location Group TU = Y
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUYPolicyInvalid
    Get Into DB  TCH
    ${issuer_id}  catenate  SELECT co.issuer_id
    ...     FROM cards c JOIN def_card dc ON c.icardpolicy = dc.ipolicy
    ...     AND c.carrier_id = dc.id JOIN contract co ON co.contract_id = dc.contract_id
    ...     WHERE c.card_num = '${Ycard}'
    ${issuer_id}  Query And Strip  ${issuer_id}

    ${status}  Run Keyword And Return Status  Row Count Is 0  SELECT * FROM issr_loc WHERE issuer_id=${issuer_id} AND location_id=${pilot}
    Run Keyword IF  '${status}'=='${False}'  execute sql string  dml=delete FROM issr_loc WHERE issuer_id=${issuer_id} AND location_id=${pilot}
    ...     ELSE  Tch Logging  You're good to go

    Run Keyword  Invalid Auth  ${Ycard}

Valid Auth for Policy Location Group TU = Y
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUYPolicyValid
    run keyword  Valid Auth  ${Ycard}
    [Teardown]  Remove Policy Loc Grp TU = Y

Card Loc Grp for for Tran_update = Y
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  JIRA:BOT-1968  refactor
    Remove Authorized Card Location Group  ${DB}  ${Ycard}  1736
#    Remove Authorized Card Location Group  ${Ycard}  1401
    go to  ${emanager}/cards/CardLookup.action
    select radio button  lookupInfoRadio  NUMBER
    input text  xpath=//*[@name='cardSearchTxt']  ${Ycard}
    click element  xpath=//*[@name='searchCard']
    click link  //*[@id="cardSummary"]/tbody/tr/td[1]/a
    Go to Locations then Location Group Management
    select checkbox  xpath=//*[@value='1736' and @name='cardGroupsIds']

Invalid Auth for Card Loc Grp TU = Y
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUYCardInvalid
    run keyword  Invalid Auth  ${Ycard}

Valid Auth for Card Loc Grp TU = Y
    [Tags]  JIRA:BOT-142  JIRA:FLT-384  JIRA:BOT-1812  refactor
    Log file name  TUYCardValid
    run keyword  Valid Auth  ${Ycard}
    [Teardown]  Remove Card Loc Grp TU = Y

*** Keywords ***
Setup Suite

    ${Ppassword}  Get Carrier Password  ${Pcarrier}
    ${Ypassword}  Get Carrier Password  ${Ycarrier}
    ${Npassword}  Get Carrier Password  ${Ncarrier}

    Set Suite Variable  ${Ppassword}
    Set Suite Variable  ${Ypassword}
    Set Suite Variable  ${Npassword}


    Get Into DB  TCH

    ${PcardPolicy}  get icardpolicy  ${Pcard}
    ${YcardPolicy}  get icardpolicy  ${Ycard}
    ${NcardPolicy}  get icardpolicy  ${Ncard}
    Set Suite Variable  ${PcardPolicy}
    Set Suite Variable  ${YcardPolicy}
    Set Suite Variable  ${NcardPolicy}


    #Making sure carrier has the correct tran_update
    ${presults} =  query and strip  SELECT tran_update FROM member where member_id = ${Pcarrier}
    run keyword if  '${presults}' != 'P'  execute sql string  dml=update member SET tran_update = 'P' where member_id = ${Pcarrier}
    ${yresults} =  query and strip  select tran_update from member where member_id = ${Ycarrier}
    run keyword if  '${yresults}' != 'Y'  execute sql string  dml=update member SET tran_update = 'Y' where member_id = ${Ycarrier}
    ${nresults} =  query and strip  select tran_update from member where member_id = ${Ncarrier}
    run keyword if  '${nresults}' != 'N'  execute sql string  dml=update member SET tran_update = 'N' where member_id = ${Ncarrier}

    #Making all cards on both for location source

    Make Sure Carrier Is Active  ${Pcarrier}
    Make Sure Carrier Is Active  ${Ycarrier}
    Make Sure Carrier Is Active  ${Ncarrier}

    Get Into DB  TCH
    start setup card  ${Pcard}
    setup card header  locationSource=BOTH
    Setup Card Limits  ULSD=500
    Sleep  2
    start setup card  ${Ncard}
    setup card header  locationSource=BOTH
    Setup Card Limits  ULSD=500
    Sleep  2
    start setup card  ${Ycard}
    setup card header  status=ACTIVE  locationSource=BOTH
    Setup Card Limits  ULSD=500

    Update Limit  ${Pcarrier}
    Update Limit  ${Ncarrier}
    Update Limit  ${Ycarrier}

    ${today} =    Get Current Date    result_format=%Y%m%d
    set global variable  ${today}
    open browser to emanager
    log into emanager  ${Pcarrier}  ${Ppassword}

Go Back to Policy Screen
    Go To  ${emanager}/cards/PolicyLocationManagement.action?policy.policyNumber=1&sitePolicy=false

Invalid Auth
    [Arguments]  ${card}

    ${string}  Create AC String  TCH  ${pilot}  ${card}  ULSD=10.00
    run rossAuth   ${string}  ${logfile}
    ${result}  Get Errors From Log File  ${logfile}
    tch logging  ${result}
    should contain  ${result.__str__()}  INVALID TRUCKSTOP

Valid Auth
    [Arguments]  ${card}

    ${string}  Create AC String  TCH  ${loves}  ${card}  ULSD=10.00
    Run RossAuth   ${string}  ${logfile}
    ${results}  Get Transaction ID From Log File  ${logfile}
    should not be empty  ${results}

Log file name
    [Arguments]  ${name}
    ${month}=    Get Current Date    result_format=%m
    ${today2}=    Get Current Date    result_format=%Y%m%d%H%M%S
    ${authDir}=  catenate
    ...  /home/qaauto/el_robot/authStrings/rossAuthLogs/TransUpdate
    run command  if[ ! -d ${authDir}];then mkdir -p ${authDir};fi
    run command  find ${authDir} -type f -name '*' -mtime +365 -exec rm {} \\;
    set test variable  ${logfile}  ${authDir}/${name}_${today2}.log
    set test variable  ${errfile}  ${authDir}/${name}_${today2}.err
    tch logging  ${logfile}

Remove Policy Chain
    [Arguments]  ${chain}  ${card}  ${policy}
    go to  ${emanager}/cards/PolicyChainManagement.action?policy.policyNumber=${policy}&sitePolicy=false
    run keyword if  ${card}== ${Ncard}  click element  xpath=//*[@name="createPolicyUnauthorizeChain"]
    run keyword if  ${card}== ${Pcard}  click element  xpath=//*[@name="createPolicyAuthorizeChain"]
    unselect checkbox      xpath=//*[@value='${chain}' and @name='slcChainIds']   #Selects locations
    click element  xpath=//*[@name="save"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'No chain to be saved')]

Remove Card Location
   [Arguments]  ${location}  ${cardid}  ${card}  ${policy}
   go to  ${emanager}/cards/CardLocationManagement.action?card.cardId=${cardid}&card.displayNumber=${card}&card.header.policyNumber=${policy}
   run keyword if  ${card}== ${Ncard}  click on  xpath=//*[@name='doCreateUnauthorize']
   run keyword if  ${card}== ${Pcard}  click on  xpath=//*[@name='doCreateAuthorize']
   input text  xpath=//*[@name='id' and @type="text"]  ${location}
   click button     xpath=//*[@name='searchLocation']
   select checkbox  xpath=//*[@value='${location}' and @name='unAuthorizeIds']
   click element  xpath=//*[@name='removeUnauthorizedLocations']

Remove Card Chain
    [Arguments]  ${chain}  ${cardid}  ${card}  ${policy}
    go to  ${emanager}/cards/CardChainManagement.action?card.cardId=${cardid}&card.displayNumber=${card}&card.header.policyNumber=${policy}
    run keyword if  ${card}== ${Ncard}  click on  xpath=//*[@name='createCardUnauthorizeChain']
    run keyword if  ${card}== ${Pcard}  click on  xpath=//*[@name='createCardAuthorizeChain']
    unselect checkbox      xpath=//*[@value='${chain}' and @name='slcChainIds']   #Selects chain
    click element  xpath=//*[@name="save"]
    page should contain element  xpath=//*[@class="messages"]//*[contains(text(), 'No chain to be saved')]
    close browser

Remove Policy Loc Grp TU = Y
  go to  ${emanager}/cards/PolicyLocationGroupManagement.action?policy.policyNumber=1&sitePolicy=false
  unselect checkbox      xpath=//*[@value='1736' and @name='policyGroupIds']

Remove Card Loc Grp TU = Y
    unselect checkbox   xpath=//*[@value='1736' and @name='cardGroupsIds']
    close browser

Remove Authorized Policy Location
    [Arguments]  ${DB}  ${location}  ${carrier}  ${policy}
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM def_locs WHERE location_id = ${location} AND carrier_id = ${carrier} AND ipolicy = ${policy}

Remove Authorized Policy Chain
    [Arguments]  ${DB}  ${chainId}  ${carrier}  ${policy}
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM def_chains WHERE chain_id = ${chainId} AND carrier_id = ${carrier} AND ipolicy = ${policy}

Remove Authorized Card Location
    [Arguments]  ${DB}  ${location}  ${cardNum}
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM card_loc WHERE location_id = ${location} AND card_num = '${cardNum}'

Remove Authorized Card Chain
    [Arguments]  ${DB}  ${chainId}  ${cardNum}
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM card_chain WHERE chain_id = ${chainId} AND card_num = '${cardNum}'

Remove Authorized Policy Location Group
    [Arguments]  ${DB}  ${carrier}  ${policy}  ${locationGroupId}
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM def_loc_grp WHERE carrier_id='${carrier}' AND ipolicy ='${policy}' AND grp_id='${locationGroupId}'

Remove Authorized Card Location Group
    [Arguments]  ${DB}  ${cardNum}  ${locationGroupId}
    Get Into DB  ${DB}
    execute sql string  dml=delete FROM card_loc_grp WHERE card_num='${cardNum}' AND grp_id='${locationGroupId}'

Get icardpolicy
    [Arguments]  ${cardNum}
    Get into DB  TCH
    ${icardpolicy}  query and strip  SELECT icardpolicy FROM cards WHERE card_num='${cardNum}';
    tch logging  \n${cardNum} HAS THE POLICY ${icardpolicy}
    [Return]  ${icardpolicy}

Go to ${menu} then ${menu_item}
    Mouse Over  //*[@class="horz_nlsitem" and text()=" ${menu}"]
    Click Element  //*[@class="nlsitem" and text()=" ${menu_item}"]