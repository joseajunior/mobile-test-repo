*** Settings ***
Library  otr_robot_lib.ws.MicroServices
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_robot_lib.support.PyLibrary
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models
Resource  ../../Variables/validUser.robot

Suite Setup  Getting ready

Force Tags  Web Services

*** Variables ***
${modelCard}
&{DB_switch}  Imperial Oil=IMPERIAL  Irving Oil=IRVING   EFS (MIG)=EFSTS  EFS=EFSLLC  Shell Oil=SFJ_SHELL
    ...  Shell Mastercard=SHELL_NAV  FLEET ONE=FLEETONE  EFS (Shell)=SFJ_SHELL  Shell Flying J=SFJ_SHELL
    ...  Shell Flying J (Deprecated)=SFJ_SHELL  Shell Oil (Deprecated)=SFJ_SHELL
*** Test Cases ***
Card Product Limits Single Card
	[Tags]  JIRA:STAP-86  qTest:35277091  refactor
    ${cardproductlimits} =  card product limits  TCH  ${validCard.carrier.id}  ${validCard.num}
    Verify prod limits  ${cardproductlimits}

Card Product Limits Multi Card
	[Tags]  JIRA:STAP-86  qTest:35277092  refactor
    ${cardproductlimits} =  card product limits  TCH  ${validCard.carrier.id}  ${validCard.num}  ${modelCard.num}
    Verify prod limits  ${cardproductlimits}

Card Info Single Card
	[Tags]  JIRA:STAP-86  qTest:35277154  refactor
    ${cardinfo} =  card info  TCH  ${validCard.carrier.id}  ${validCard.num}
    Verify info prompts  ${cardinfo}

Card Info Multi Card
	[Tags]  JIRA:STAP-86  qTest:35277155  refactor
    ${cardinfo} =  card info  TCH  ${validCard.carrier.id}  ${validCard.num}  ${modelCard.num}
    Verify info prompts  ${cardinfo}

Card Location Single Card
	[Tags]  JIRA:STAP-86  qTest:35277055  refactor
    ${cardloc} =  card locations  TCH  ${validCard.carrier.id}  ${validCard.num}
    Verify loc  ${cardloc}

Card Location Multi Card
	[Tags]  JIRA:STAP-86  qTest:35277059  refactor
    ${cardloc} =  card locations  TCH  ${validCard.carrier.id}  ${validCard.num}  ${modelCard.num}
    Verify loc  ${cardloc}

Card Single Card
	[Tags]  JIRA:STAP-86  qTest:35277295  refactor
    ${card} =  cards  TCH  ${validCard.carrier.id}  ${validCard.num}
    Verify Card data  ${card}

Card Page request
	[Tags]  JIRA:STAP-86  qTest:35277301  refactor
    ${card} =  cards  TCH  ${validCard.carrier.id}  page=0  requestSize=30
    ${rowcount} =  assign int  0
    get into db  TCH
    ${count} =  get length  ${card}
    FOR  ${index}  IN RANGE  0  ${card['numberOfElements']}
        ${dbcardinfo}=  query to dictionaries  select trim(card_num) as card_num, lmtsrc, icardPolicy, infosrc, locsrc, status from cards where card_num = '${card['content'][${index}]['cardNumber']}'
        should be equal as strings  ${card['content'][${index}]['cardNumber']}  ${dbcardinfo[0]['card_num']}
        should be equal as strings  ${card['content'][${index}]['limitSource']}  ${dbcardinfo[0]['lmtsrc']}
        should be equal as strings  ${card['content'][${index}]['icardPolicy']}  ${dbcardinfo[0]['icardpolicy']}
        should be equal as strings  ${card['content'][${index}]['infoSource']}  ${dbcardinfo[0]['infosrc']}
        should be equal as strings  ${card['content'][${index}]['locationSource']}  ${dbcardinfo[0]['locsrc']}
        should be equal as strings  ${card['content'][${index}]['status']}  ${dbcardinfo[0]['status']}
    END
    ${totalcards} =  evaluate  str(${card['totalElements']})
    row count is equal to x  select * from cards where carrier_id = ${validCard.carrier.id}  ${totalcards}
    should be equal as strings  ${card['numberOfElements']}  30

Get Cards by Policy
	[Tags]  JIRA:STAP-86  qTest:35277304  refactor
    ${pagesize} =  evaluate  10
    ${carrier} =  evaluate  ${validCard.carrier.id.__str__()}
    ${policy} =  evaluate  1

    ${cardsbypolicy} =  cards by policy  TCH  ${carrier}  ${policy}  0  ${pagesize}
#    log to console  ${cardsbypolicy}
    ${rowcount} =  assign int  0
    get into db  TCH
    ${count} =  get length  ${cardsbypolicy}
    FOR  ${index}  IN RANGE  0  ${cardsbypolicy['numberOfElements']}
        ${dbcardinfo}=  query to dictionaries  select trim(card_num) as card_num, lmtsrc, icardPolicy, infosrc, locsrc, status from cards where card_num = '${cardsbypolicy['content'][${index}]['cardNumber']}'
        should be equal as strings  ${cardsbypolicy['content'][${index}]['cardNumber']}  ${dbcardinfo[0]['card_num']}
        should be equal as strings  ${cardsbypolicy['content'][${index}]['limitSource']}  ${dbcardinfo[0]['lmtsrc']}
        should be equal as strings  ${cardsbypolicy['content'][${index}]['icardPolicy']}  ${policy}
        should be equal as strings  ${cardsbypolicy['content'][${index}]['infoSource']}  ${dbcardinfo[0]['infosrc']}
        should be equal as strings  ${cardsbypolicy['content'][${index}]['locationSource']}  ${dbcardinfo[0]['locsrc']}
        should be equal as strings  ${cardsbypolicy['content'][${index}]['status']}  ${dbcardinfo[0]['status']}
    END
    ${totalcards} =  evaluate  str(${cardsbypolicy['totalElements']})
    row count is equal to x  select * from cards where carrier_id = ${carrier} and icardpolicy = ${policy}  ${totalcards}
    should be equal as strings  ${cardsbypolicy['numberOfElements']}  ${pagesize}

Policy chain
	[Tags]  JIRA:STAP-86  qTest:35277308  refactor
    ${pagesize} =  evaluate  10
    ${carrier} =  evaluate  148697
    ${policy} =  evaluate  4

    ${policychain} =  policy chains  TCH  ${carrier}  ${policy}
    get into db  TCH
    ${dbresults}=  query to dictionaries  select * from def_chains where carrier_id = ${carrier} and ipolicy = ${policy}
    ${count} =  get length  ${policychain}
    FOR  ${index}  IN RANGE  0  ${count}
        should be equal as strings  ${policychain[${index}]['id']['carrierId']}  ${dbresults[${index}]['carrier_id']}
        should be equal as strings  ${policychain[${index}]['id']['iPolicy']}  ${dbresults[${index}]['ipolicy']}
        should be equal as strings  ${policychain[${index}]['id']['chainId']}  ${dbresults[${index}]['chain_id']}
    END
#
Xut
	[Tags]  JIRA:STAP-86  qTest:35277307  refactor
    ${xutcall}=  xut get card  TCH  ${validCard.carrier.id}  ${validCard.num}
    Verify Card data  ${xutcall}
    Verify info prompts  ${xutcall['cardInfo']}
    Verify loc  ${xutcall['cardLocations']}
    Verify prod limits  ${xutcall['cardProductLimits']}
    Verify loc group  ${xutcall['cardLocationGroups']}
    Verify limts prompts  ${xutcall['cardLimits']}
    Verify time  ${xutcall['cardTimes']}

Set card Status to Each Status
    [Tags]  JIRA:PORT-117  qTest:44065983  refactor
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  I
    Verify Card Status  ${modelCard.id}  I
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  H
    Verify Card Status  ${modelCard.id}  H
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  D
    Verify Card Status  ${modelCard.id}  D
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  U
    Verify Card Status  ${modelCard.id}  U
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  A
    Verify Card Status  ${modelCard.id}  A

Set card Payroll Status to Each Status
    [Tags]  JIRA:PORT-117  qTest:44065989  refactor
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  payr_status=H
    Verify Card Payroll Status  ${modelCard.id}  H
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  ${None}  I
    Verify Card Payroll Status  ${modelCard.id}  I
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  ${None}  D
    Verify Card Payroll Status  ${modelCard.id}  D
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  ${None}  U
    Verify Card Payroll Status  ${modelCard.id}  U
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  ${None}  F
    Verify Card Payroll Status  ${modelCard.id}  F
    status_update  ${modelCard.carrier.id}  ${modelCard.id}  ${None}  A
    Verify Card Payroll Status  ${modelCard.id}  A

Verify Fail with Bad Token
    [Tags]  JIRA:PORT-117  qTest:44065984  refactor
    run keyword and expect error  MircoServiceExpection*Unauthorized*  status_update  ${modelCard.carrier.id}  ${modelCard.id}  ${None}  A  ${True}

Verify Fail with BAD Carrier
    [Tags]  JIRA:PORT-117  qTest:44065987
    Verify failed carrier message with letters  1a6fw  ${modelCard.id}  payr_status=H
#   ***This one is not yet part of the feature.  Carrier doesn't have to match card.
#    status_update  12345  ${modelCard.id}  payr_status=H
#    Verify wrong carrier message


Verify Fail with BAD Status
    [Tags]  JIRA:PORT-117  qTest:44065986
    Verify failed status  ${modelCard.carrier.id}  ${modelCard.id}  L

Verify Fail with BAD payr_status
    [Tags]  JIRA:PORT-117  qTest:44065988
    Verify failed payr_status message  ${modelCard.carrier.id}  ${modelCard.id}  payr_status=L

Verify Fail with BAD Card ID
    [Tags]  JIRA:PORT-117  qTest:44065985
    Verify failed card id  ${modelCard.carrier.id}  123467  payr_status=H

Verify searchcard Returns Error with non-numeric card number
    [Tags]  JIRA:PORT-253  qTest:44062755  refactor
    ${cardNumber}  set variable  1235ggjtd/:;dyhj
    Verify Non-numeric card error  ${cardNumber}

Verify searchcard Returns Error with Non-existing card
    [Tags]  JIRA:PORT-253  qTest:44062757  refactor
    ${cardNumber}  set variable  12345678910
    Verify Non-existing card error  ${cardNumber}

Verify searchcard Returns Error with Not Enough Digits
    [Tags]  JIRA:PORT-253  qTest:44062758  refactor
    ${cardNumber}  set variable  1235
    Verify Not Enough Digits card error  ${cardNumber}

Verify searchcard Returns correct card info EFSLLC
    [Tags]  JIRA:PORT-253  qTest:44062759  refactor
    ${cardQuery}  catenate  select c.card_num from cards c, def_card pol, contract con, issuer_misc im,
    ...  issuer_group ig where c.icardpolicy = pol.ipolicy and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id and c.carrier_id not between 700000 and 850000 limit 1;
    ${cardNumber}  find card variable  ${cardQuery}

    Verify Platform and Carrier ID  EFSLLC  ${cardNumber.card_num}

Verify searchcard Returns correct card info FLEETONE
    [Tags]  JIRA:PORT-253  qTest:44062760  refactor
    ${cardQuery}  catenate  select c.card_num from cards c, def_card pol, contract con, issuer_misc im,
    ...  issuer_group ig where c.icardpolicy = pol.ipolicy and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id and c.carrier_id between 700000 and 850000 limit 1;
    ${cardNumber}  find card variable  ${cardQuery}

    Verify Platform and Carrier ID  FLEETONE  ${cardNumber.card_num}

Verify searchcard Returns correct card info IMPERIAL
    [Tags]  JIRA:PORT-253  qTest:44062762  refactor

        ${cardQuery}  catenate  select c.card_num from cards c, def_card pol, contract con, issuer_misc im,
    ...  issuer_group ig where c.icardpolicy = pol.ipolicy and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id and c.carrier_id between 600000 and 7000000 limit 1;
    ${cardNumber}  find card variable  ${cardQuery}  instance=IMPERIAL
    Verify Platform and Carrier ID  IMPERIAL  ${cardNumber.card_num}

Verify searchcard Returns correct card info IRVING
    [Tags]  JIRA:PORT-253  qTest:44062763  refactor

    ${cardQuery}  catenate  select c.card_num from cards c, def_card pol, contract con, issuer_misc im,
    ...  issuer_group ig where c.icardpolicy = pol.ipolicy and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id limit 1;
    ${cardNumber}  find card variable  ${cardQuery}  instance=IRVING
    Verify Platform and Carrier ID  IRVING  ${cardNumber.card_num}

Verify searchcard Returns correct card info MIG (EFSTS)  #This will be depricated when EFSTS is migrated to EFSLLC
    [Tags]  JIRA:PORT-253  qTest:44062764  refactor

    ${cardQuery}  catenate  select c.card_num from cards c, def_card pol, contract con, issuer_misc im,
    ...  issuer_group ig where c.icardpolicy = pol.ipolicy and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id limit 1;
    ${cardNumber}  find card variable  ${cardQuery}  instance=EFSMIG
    Verify Platform and Carrier ID  MIG  ${cardNumber.card_num}

Verify searchcard Returns correct card info SFJ_SHELL
    [Tags]  JIRA:PORT-253  qTest:44062766  refactor
    get into db  SHELL
    ${cardQuery}  catenate  select c.card_num from cards c, def_card pol, contract con, issuer_misc im,
    ...  issuer_group ig where c.icardpolicy = pol.ipolicy and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id and c.carrier_id not between 600000 and 7000000 limit 1;
    ${cardNumber}  find card variable  ${cardQuery}  instance=SHELL

    Verify Platform and Carrier ID  SFJ_SHELL  ${cardNumber.card_num}

Verify searchcard Returns correct card info SHELL_NAV
    [Tags]  JIRA:PORT-253  qTest:44062767  refactor
    get into db  SHELL
    ${cardQuery}  catenate  select c.card_num from cards c, def_card pol, contract con, issuer_misc im,
    ...  issuer_group ig where c.icardpolicy = pol.ipolicy and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id and c.carrier_id between 600000 and 7000000 limit 1;
    ${cardNumber}  find card variable  ${cardQuery}  instance=SHELL

    Verify Platform and Carrier ID  SHELL_NAV  ${cardNumber.card_num}


*** Keywords ***
Verify prod limits
    [Arguments]  ${dictionary}  ${partner}=TCH
    ${rowcount} =  assign int  0
    ${cards}  create list
    get into db  ${partner}
    ${count} =  get length  ${dictionary}
    FOR  ${index}  IN RANGE  0  ${count}
        ${dbcardprodlmt}=  query to dictionaries  select trim(clp.card_num) as card_num, clp.fps_partner, clp.prod_num, trim(p.abbrev) as abbrev, p.description, trim(p.restriction_group) as restriction_group, trim(p.tax_group) as tax_group, p.fuel_type, p.fuel_use, p.shell_fuel_type from card_lmt_prod clp left join products p on p.fps_partner = clp.fps_partner and p.num = clp.prod_num where clp.card_num = '${dictionary[${index}]['cardNumber']}' and clp.fps_partner = '${dictionary[${index}]['fpsPartner']}' and clp.prod_num = '${dictionary[${index}]['productNumber']}'
        append to list  ${cards}  ${dictionary[${index}]['cardNumber']}
        ${rowcount} =  evaluate  ${rowcount} + 1
        should be equal as strings  ${dictionary[${index}]['cardNumber']}  ${dbcardprodlmt[0]['card_num']}
        should be equal as strings  ${dictionary[${index}]['fpsPartner']}  ${dbcardprodlmt[0]['fps_partner']}
        should be equal as strings  ${dictionary[${index}]['productNumber']}  ${dbcardprodlmt[0]['prod_num']}
        should be equal as strings  ${dictionary[${index}]['product']['abbreviation']}  ${dbcardprodlmt[0]['abbrev']}
        should be equal as strings  ${dictionary[${index}]['product']['description']}  ${dbcardprodlmt[0]['description']}
        should be equal as strings  ${dictionary[${index}]['product']['restrictionGroup']}  ${dbcardprodlmt[0]['restriction_group']}
        should be equal as strings  ${dictionary[${index}]['product']['taxGroup']}  ${dbcardprodlmt[0]['tax_group']}
        should be equal as strings  ${dictionary[${index}]['product']['fuelType']}  ${dbcardprodlmt[0]['fuel_type']}
        should be equal as strings  ${dictionary[${index}]['product']['fuelUse']}  ${dbcardprodlmt[0]['fuel_use']}
        should be equal as strings  ${dictionary[${index}]['product']['shellFuelType']}  ${dbcardprodlmt[0]['shell_fuel_type']}
    END
    ${cards} =  evaluate  "','".join(${cards})
    ${rowcount} =  evaluate  str(${rowcount})
    row count is equal to x  select * from card_lmt_prod clp left join products p on p.fps_partner = clp.fps_partner and p.num = clp.prod_num where clp.card_num in ('${cards}') and clp.fps_partner = '${partner}'  ${rowcount}

Verify info prompts
    [Arguments]  ${dictionary}  ${partner}=TCH
    ${rowcount} =  assign int  0
    ${cards}  create list
    ${count} =  get length  ${dictionary}
    get into db  ${partner}
    FOR  ${index}  IN RANGE  0  ${count}
        ${dbcardinfo}=  query to dictionaries  select trim(card_num) as card_num, trim(info_id) as info_id,trim(info_validation) as info_validation from card_inf where card_num = '${dictionary[${index}]['cardNumber']}' and info_id = '${dictionary[${index}]['id']['infoId']}' and info_validation = '${dictionary[${index}]['infoValidation']}'
        append to list  ${cards}  ${dictionary[${index}]['cardNumber']}
        ${rowcount} =  evaluate  ${rowcount} + 1
        should be equal as strings  ${dictionary[${index}]['id']['cardNumber']}  ${dbcardinfo[0]['card_num']}
        should be equal as strings  ${dictionary[${index}]['id']['infoId']}  ${dbcardinfo[0]['info_id']}
        should be equal as strings  ${dictionary[${index}]['infoValidation']}  ${dbcardinfo[0]['info_validation']}
    END
    ${cards} =  evaluate  "','".join(${cards})
    ${rowcount} =  evaluate  str(${rowcount})
    row count is equal to x  select * from card_inf where card_num in ('${cards}')  ${rowcount}

Verify loc
    [Arguments]  ${dictionary}  ${partner}=TCH
    ${rowcount} =  assign int  0
    ${cards}  create list
    ${count} =  get length  ${dictionary}
    get into db  ${partner}
    FOR  ${index}  IN RANGE  0  ${count}
        ${dbcardloc}=  query to dictionaries  select trim(card_num) as card_num, location_id from card_loc where card_num = '${dictionary[${index}]['cardNumber']}' and location_id = '${dictionary[${index}]['id']['location']}'
        append to list  ${cards}  ${dictionary[${index}]['cardNumber']}
        ${rowcount} =  evaluate  ${rowcount} + 1
        should be equal as strings  ${dictionary[${index}]['id']['cardNumber']}  ${dbcardloc[0]['card_num']}
        should be equal as strings  ${dictionary[${index}]['id']['location']}  ${dbcardloc[0]['location_id']}
    END
    ${cards} =  evaluate  "','".join(${cards})
    ${rowcount} =  evaluate  str(${rowcount})
    row count is equal to x  select * from card_loc where card_num in ('${cards}')  ${rowcount}

Verify limts prompts
    [Arguments]  ${dictionary}  ${partner}=TCH
    ${rowcount} =  assign int  0
    ${cards}  create list
    ${count} =  get length  ${dictionary}
    get into db  ${partner}
    FOR  ${index}  IN RANGE  0  ${count}
        ${dbcardlmt}=  query to dictionaries  select trim(card_num) as card_num, trim(limit_id) as limit_id, limit, hours, minhours,ipolicy from card_lmt where card_num = '${dictionary[${index}]['cardNumber']}' and limit_id = '${dictionary[${index}]['limitId']}'
        append to list  ${cards}  ${dictionary[${index}]['cardNumber']}
        ${rowcount} =  evaluate  ${rowcount} + 1
        should be equal as strings  ${dictionary[${index}]['cardNumber']}  ${dbcardlmt[0]['card_num']}
        should be equal as strings  ${dictionary[${index}]['limitId']}  ${dbcardlmt[0]['limit_id']}
        should be equal as strings  ${dictionary[${index}]['limit']}  ${dbcardlmt[0]['limit']}
        should be equal as strings  ${dictionary[${index}]['hours']}  ${dbcardlmt[0]['hours']}
        should be equal as strings  ${dictionary[${index}]['minHours']}  ${dbcardlmt[0]['minhours']}
        should be equal as strings  ${dictionary[${index}]['iPolicy']}  ${dbcardlmt[0]['ipolicy']}
    END
    ${cards} =  evaluate  "','".join(${cards})
    ${rowcount} =  evaluate  str(${rowcount})
    row count is equal to x  select * from card_lmt where card_num in ('${cards}')  ${rowcount}

Verify time
    [Arguments]  ${dictionary}  ${partner}=TCH
    ${rowcount} =  assign int  0
    ${cards}  create list
    ${count} =  get length  ${dictionary}
    get into db  ${partner}
    FOR  ${index}  IN RANGE  0  ${count}
        ${dbcardtime}=  query to dictionaries  select trim(card_num) as card_num, day_of_week, beg_time, end_time from card_time where card_num = '${dictionary[${index}]['cardNumber']}' and day_of_week = '${dictionary[${index}]['dayOfWeek']}'
        append to list  ${cards}  ${dictionary[${index}]['cardNumber']}
        ${rowcount} =  evaluate  ${rowcount} + 1
        should be equal as strings  ${dictionary[${index}]['cardNumber']}  ${dbcardtime[0]['card_num']}
        should be equal as strings  ${dictionary[${index}]['beginTime']}  ${dbcardtime[0]['beg_time']}
        should be equal as strings  ${dictionary[${index}]['dayOfWeek']}  ${dbcardtime[0]['day_of_week']}
        should be equal as strings  ${dictionary[${index}]['endTime']}  ${dbcardtime[0]['end_time']}
    END
    ${cards} =  evaluate  "','".join(${cards})
    ${rowcount} =  evaluate  str(${rowcount})
    row count is equal to x  select * from card_time where card_num in ('${cards}')  ${rowcount}

Verify loc group
    [Arguments]  ${dictionary}  ${partner}=TCH
    ${rowcount} =  assign int  0
    ${cards}  create list
    ${count} =  get length  ${dictionary}
    get into db  ${partner}
    FOR  ${index}  IN RANGE  0  ${count}
        ${dbcardloc}=  query to dictionaries  select trim(card_num) as card_num, grp_id from card_loc_grp where card_num = '${dictionary[${index}]['cardNumber']}'
        append to list  ${cards}  ${dictionary[${index}]['cardNumber']}
        ${rowcount} =  evaluate  ${rowcount} + 1
        should be equal as strings  ${dictionary[${index}]['id']['cardNumber']}  ${dbcardloc[0]['card_num']}
        should be equal as strings  ${dictionary[${index}]['id']['groupId']}  ${dbcardloc[0]['grp_id']}
    END
    ${cards} =  evaluate  "','".join(${cards})
    ${rowcount} =  evaluate  str(${rowcount})
    row count is equal to x  select * from card_loc_grp where card_num in ('${cards}')  ${rowcount}

Verify Card data
    [Arguments]  ${dictionary}  ${partner}=TCH
    ${rowcount} =  assign int  0
    ${cards}  create list
    get into db  TCH
    ${count} =  get length  ${dictionary}
    FOR  ${index}  IN RANGE  0  ${count}
        ${dbcardinfo}=  query to dictionaries  select trim(card_num) as card_num, lmtsrc, icardpolicy, infosrc, locsrc, status from cards where card_num = '${dictionary['cardNumber']}'
        should be equal as strings  ${dictionary['cardNumber']}  ${dbcardinfo[0]['card_num']}
        should be equal as strings  ${dictionary['limitSource']}  ${dbcardinfo[0]['lmtsrc']}
        should be equal as strings  ${dictionary['icardPolicy']}  ${dbcardinfo[0]['icardpolicy']}
        should be equal as strings  ${dictionary['infoSource']}  ${dbcardinfo[0]['infosrc']}
        should be equal as strings  ${dictionary['locationSource']}  ${dbcardinfo[0]['locsrc']}
        should be equal as strings  ${dictionary['status']}  ${dbcardinfo[0]['status']}
    END
    ${cards} =  evaluate  "','".join(${cards})
    ${rowcount} =  evaluate  str(${rowcount})
    row count is equal to x  select * from cards where card_num in ('${cards}')  ${rowcount}

Verify Card Status
    [Arguments]  ${card_id}  ${status}
    get into db  TCH
    ${dbStatus} =  query and strip to dictionary  select status from cards where card_id in ('${card_id}')
    should be equal as strings  ${dbStatus["status"]}  ${status}  We expected database status to change to ${status} but the acutal database status was ${dbStatus["status"]}

Verify Card Payroll Status
    [Arguments]  ${card_id}  ${payr_status}
    get into db  TCH
    ${dbStatus} =  query and strip to dictionary  select payr_status from cards where card_id in ('${card_id}')
    should be equal as strings  ${dbStatus["payr_status"]}  ${payr_status}  We expected database payr_status to change to ${payr_status} but the acutal database payr_status was ${dbStatus["payr_status"]}

Verify failed carrier message with letters
    [Arguments]  ${carrier_id}  ${card_id}  ${status}
    ${status}  ${returnedMessage}  run keyword and ignore error  status update  ${carrier_id}  ${card_id}  ${status}
    ${successMessage}  set variable  SUCCESS
    should not be equal as strings  ${returnedMessage}  ${successMessage}  We expected an error message, not ${successMessage}, but the actual message was ${returnedMessage}

#***This one is not yet part of the feature.  Carrier doesn't have to match card.
#Verify wrong carrier message

Verify failed status
    [Arguments]  ${carrier_id}  ${card_id}  ${status}
    ${status}  ${returnedMessage}  run keyword and ignore error  status update  ${carrier_id}  ${card_id}  ${status}
    ${successMessage}  set variable  SUCCESS
    should not be equal as strings  ${returnedMessage}  ${successMessage}  We expected an error message, not ${successMessage}, but the actual message was ${returnedMessage}

Verify failed payr_status message
    [Arguments]  ${carrier_id}  ${card_id}  ${payr_status}
    ${status}  ${returnedMessage}  run keyword and ignore error  status update  ${carrier_id}  ${card_id}  ${payr_status}
    ${successMessage}  set variable  SUCCESS
    should not be equal as strings  ${returnedMessage}  ${successMessage}  We expected an error message, not ${successMessage}, but the actual message was ${returnedMessage}

Verify failed card id
    [Arguments]  ${carrier_id}  ${card_id}  ${payr_status}
    ${status}  ${returnedMessage}  run keyword and ignore error  status update  ${carrier_id}  ${card_id}  ${payr_status}
    ${successMessage}  set variable  SUCCESS
    should not be equal as strings  ${returnedMessage}  ${successMessage}  We expected an error message, not ${successMessage}, but the actual message was ${returnedMessage}

Verify Platform and Carrier ID
    [Arguments]  ${platform}  ${cardNumber}
    #This matches the platform and sets the database that will be searched to match results
    ${informixDB}  run keyword if  '${platform}' == 'IMPERIAL'  set variable  IMPERIAL
    ${informixDB}  run keyword if  '${platform}' == 'FLEETONE'  set variable  TCH  ELSE  set variable  ${informixDB}
    ${informixDB}  run keyword if  '${platform}' == 'IRVING'  set variable  IRVING  ELSE  set variable  ${informixDB}
    ${informixDB}  run keyword if  '${platform}' == 'MIG'  set variable  EFSMIG  ELSE  set variable  ${informixDB}
    ${informixDB}  run keyword if  '${platform}' == 'SFJ_SHELL'  set variable  SHELL  ELSE  set variable  ${informixDB}
    ${informixDB}  run keyword if  '${platform}' == 'SHELL_NAV'  set variable  SHELL  ELSE  set variable  ${informixDB}
    ${informixDB}  run keyword if  '${platform}' == 'EFSLLC'  set variable  TCH  ELSE  set variable  ${informixDB}

    #This calls "call cardsearch" for the returned API information
    ${cardsearchResults}  call_cardsearch  ${cardNumber}

    get into db  ${informixDB}
    ${crumbyquery}  catenate  select ig.name, c.carrier_id, c.card_num from cards c, def_card pol, contract con, issuer_misc im, issuer_group ig
    ...  where c.icardpolicy = pol.ipolicy
    ...  and c.carrier_id = pol.id
    ...  and pol.contract_id = con.contract_id
    ...  and con.issuer_id = im.issuer_id
    ...  and im.issuer_group_id = ig.issuer_group_id
    ...  and c.card_num= ('${cardNumber}')
    ...  limit 1
    ${dbStuff}  query and strip to dictionary  ${crumbyquery}

    should be equal as strings  ${dbStuff["carrier_id"]}  ${cardsearchResults['carrier_id']}  We expected a Carrier ID
    ...  of ${dbStuff["carrier_id"]}, but the Carrier ID returned was ${cardsearchResults['carrier_id']}
    ${platformName}=  set variable  ${dbStuff["name"]}
    should be equal as strings  ${DB_switch["${platformName}"]}  ${cardsearchResults['platform']}  We expected a Carrier
    ...  ID of DB Version ${platformName} >> ${DB_switch["${platformName}"]},
    ...  but the Carrier ID returned was ${cardsearchResults['platform']}

Verify Non-numeric card error
    [Arguments]  ${cardNumber}
    #This calls "call cardsearch" for the returned API information
    ${cardsearchResults}  call_cardsearch  ${cardNumber}
    ${errorMessage}  catenate  We expected the error of "Invalid card number, entry is a non-numerical entry."
    ...  , but the error returned was ${cardsearchResults['error_description']}
    should be equal as strings  102  ${cardsearchResults['error_number']}  ${errorMessage}

Verify Non-existing card error
    [Arguments]  ${cardNumber}
    #This calls "call cardsearch" for the returned API information
    ${cardsearchResults}  call_cardsearch  ${cardNumber}
    ${errorMessage}  catenate  We expected the error of "Card not found, please review the
    ...  card number and try again.", but the error returned was ${cardsearchResults['error_description']}
    should be equal as strings  101  ${cardsearchResults['error_number']}  ${errorMessage}

Verify Not Enough Digits card error
    [Arguments]  ${cardNumber}
    #This calls "call cardsearch" for the returned API information
    ${cardsearchResults}  call_cardsearch  ${cardNumber}
    ${errorMessage}  catenate  We expected the error of "Invalid card number, entry is a non-numerical entry.",
    ...  but the error returned was ${cardsearchResults['error_description']}
    should be equal as strings  103  ${cardsearchResults['error_number']}  ${errorMessage}

Getting Ready
    ${ac_query}=  catenate  SELECT TRIM(c.card_num) as card_num
    ...    FROM cards c
    ...        JOIN def_card dc ON c.carrier_id = dc.id AND c.icardpolicy = dc.ipolicy
    ...        JOIN contract co ON dc.contract_id = co.contract_id
    ...        JOIN member m ON c.carrier_id = m.member_id
    ...    WHERE c.card_type = 'TCH'
    ...    AND c.card_num NOT LIKE '%OVER'
    ...    AND c.status = 'A'
    ...    AND c.payr_use = 'B'
    ...    AND c.last_used > today - 90
    ...    AND co.status = 'A'
    ...    AND m.status = 'A'
    ${modelCard}=  find card variable  ${ac_query}
    set suite variable  ${modelCard}
    start setup card  ${modelCard.num}

    Setup Card  ${validCard}
    Setup Card  ${modelCard}

Setup Card
    [Arguments]  ${card}
    Start Setup Card  ${card.card_num}
    Setup Card Limits  USLD=100  OIL=10
    Setup Card Prompts  DRID=V1234  UNIT=V3244
    Setup Card Location  231009  231008  231001

    log into card management web services  ${card.carrier_id}  ${card.carrier.password}
#    setcardlocations  ${validCard.card_numNum}  ${True}  231009  231008  231001
    setcardlocationgroups  ${card.card_num}  ${false}  1276
    ${restrictions}  Create Dictionary
    ...  beginDate=${empty}
    ...  beginTime=10:00
    ...  day=6
    ...  endDate=${empty}
    ...  endTime=11:00
    setcardtimerestrictions  ${card.card_num}  ${false}  ${restrictions}


