*** Settings ***
Resource  ../../Variables/validUser.robot
Library  String
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.services.GenericService
Library  Collections
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models

Suite Setup  Setup WS
Suite Teardown  Teardown WS

Force Tags  Web Services  Shifty  Integration

*** Variables ***
${myCarrier}
${policy}

*** Test Cases ***
getLocationGroups with a valid policy
    [Tags]  JIRA:BOT-1896
    [Documentation]
    ${grps}=  getLocationGroups  policyNum=${policy}
    ${length}=  get length  ${grps}
    run keyword unless  ${length} > 0  ${myCarrier.id} on policy ${policy} should have had some location group rules/locations but did not

*** Keywords ***
Setup WS
    Get Into DB  TCH
    ${query}=  catenate  select dlg.carrier_id, dlg.ipolicy, count(*) from member m
    ...  right join def_loc_grp dlg on dlg.carrier_id = m.member_id
    ...  left join loc_group lg on dlg.grp_id = lg.group_id
    ...  where m.tran_update = 'Y'
    ...  group by carrier_id,ipolicy,lg.group_id

    ${rows}=  query and return dictionary rows  ${query}
    ${row}=  evaluate  random.choice(${rows})  random

    ${myCarrier}=  set carrier variable  ${row['carrier_id']}
    set suite variable  ${myCarrier}
    ${policy}=  set variable  ${row['ipolicy']}
    set suite variable  ${policy}
    Log Into Card Management Web Services  ${myCarrier.id}  ${myCarrier.password}

Teardown WS
    Logout