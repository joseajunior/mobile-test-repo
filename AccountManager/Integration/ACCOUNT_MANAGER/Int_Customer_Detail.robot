*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.CardManagementWS
Library  otr_model_lib.Models
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/AuthKeywords.robot
Resource  ../../Variables/validUser.robot
#Resource  otr_robot_lib/robot/eManagerKeywords.robot
Resource  otr_robot_lib/robot/AccountManagerKeywords.robot

Suite Setup  Open Account Manager
Force Tags  Integration  Shifty

*** Test Cases ***
#Open Account Manager
#    Open Account
#    Open eManager  ${robot_emanager_username}  ${robot_emanager_password}
#    Maximize Browser Window
#    Hover Over  text=Select Program
#    Hover Over  text=Account Management
#    Click On  text=Account Manager

Open EFS Carrier
    [Documentation]  Using ${validCard.carrier.id} in Account Manager.

    [Tags]  TCH Instance  refactor

    Check Element Exists  text=Business Partner
    Input Text  //*[@name="id"]  ${validCard.carrier.id}
    Click On  text=Submit  exactMatch=False
    Click On  text=${validCard.carrier.id}

Detail Tab - Current Member Data (TCH)
    [Documentation]  Verifies the following information on the page exists in the DB:\n\n
    ...  * Carrier\n\n
    ...  * Carrier Name and Legal Name\n\n
    ...  * Carrier Address\n\n
    ...  * Carrier Phone Number\n\n
    ...  * Carrier E-mail Address\n\n
    ...  * Carrier Password\n\n
    ...  * Sales Territory\n\n
    ...  * Account Manager\n\n

    [Tags]  TCH Instance  JIRA:BOT-1507  qTest:32853279  Regression  qTest:30864051  refactor

    Click On  text=Detail
    Check Element Exists  text=Customer #  timeout=60
    Sleep  3
    ${original_member}=  Get Member Info  tch  ${validCard.carrier.id}
    ${detail}=  Get AM Detail Info

    Should Be Equal As Strings  ${original_member.id}  ${detail.id}
    Should Be Equal As Strings  ${original_member.name}  ${detail.name}
    Should Be Equal As Strings  ${original_member.street}  ${detail.street}
    Should Be Equal As Strings  ${original_member.city}  ${detail.city}
    Should Be Equal As Strings  ${original_member.state}  ${detail.state}
    Should Be Equal As Strings  ${original_member.zip}  ${detail.zip}
    Should Be Equal As Strings  ${original_member.country}  ${detail.country}
    Should Be Equal As Strings  ${original_member.phone}  ${detail.phone}
    Should Be Equal As Strings  ${original_member.email}  ${detail.email}
    Should Be Equal As Strings  ${original_member.legal_name}  ${detail.legal_name}
    Should Be Equal As Strings  ${original_member.password}  ${detail.password}
    Should Be Equal As Strings  ${original_member.sales_territory}  ${detail.sales_territory}
    Should Be Equal As Strings  ${original_member.acct_mgr}  ${detail.acct_mgr}

    [Teardown]  Close Browser

*** Keywords ***

Get AM Detail Info
    ${detail}=  create dictionary
    ...  id                 ${None}
    ...  name               ${None}
    ...  street             ${None}
    ...  city               ${None}
    ...  state              ${None}
    ...  zip                ${None}
    ...  country            ${None}
    ...  phone              ${None}
    ...  email              ${None}
    ...  legal_name         ${None}
    ...  password           ${None}
    ...  sales_territory    ${None}
    ...  acct_mgr           ${None}

    ${detail.id}=  get text  //*[text() = "Customer #"]/parent::*/following-sibling::*[1]
    ${detail.name}=  get value  //*[@name="detailRecord.name"]
    ${detail.street}=  get value  //*[@name="detailRecord.address1"]
    ${detail.city}=  get value  //*[@name="detailRecord.city"]
    ${detail.state}=  get selected list value  //*[@name="detailRecord.state"]
    ${detail.zip}=  get value  //*[@name="detailRecord.zip"]
    ${detail.country}=  get text  //*[text() = "Country"]/parent::*/following-sibling::*[1]/span
    ${detail.country}=  get first character  ${detail.country}
    ${detail.phone}=  get value  //*[@name="detailRecord.phone"]
    ${detail.email}=  get value  //*[@name="detailRecord.email"]
    ${detail.legal_name}=  get text  //*[text() = "Legal Business Name"]/parent::*/following-sibling::*[1]/span
    ${detail.sales_territory}=  get selected list value  //*[@name="detailRecord.salesTerritory"]
    ${detail.acct_mgr}=  get selected list value  //*[@name="detailRecord.accountManagerId"]
    click on  text=View
    ${detail.password}=  get value  //*[@name="detailRecord.customerPassword"]

    [Return]  ${detail}

Get Member Info
    [Arguments]  ${instance}  ${carrier_id}
    Get Into DB  ${instance}
    ${query}=  catenate
    ...  select m.member_id, m.name, m.add1, m.city, m.state, m.zip, m.country, m.cont_phone, m.email_addr, m.legal_name,
    ...  m.passwd, m.sales_territory, a.mgr_id
    ...  from member m, acct_mgr_xref a
    ...  where m.member_id = a.carrier_id and m.member_id = ${carrier_id}

    @{results}=  query and strip to list  ${query}
    ${zip}=  remove trailing spaces  @{results}[5]
    ${pass}=  remove trailing spaces  @{results}[10]
    ${am}=  assign string  @{results}[12]
    ${member}=  create dictionary
    ...  id                 @{results}[0]
    ...  name               @{results}[1]
    ...  street             @{results}[2]
    ...  city               @{results}[3]
    ...  state              @{results}[4]
    ...  zip                ${zip}
    ...  country            @{results}[6]
    ...  phone              @{results}[7]
    ...  email              @{results}[8]
    ...  legal_name         @{results}[9]
    ...  password           ${pass}
    ...  sales_territory    @{results}[11]
    ...  acct_mgr           ${am}

     disconnect from database
    [Return]  ${member}