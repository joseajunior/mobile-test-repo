*** Settings ***

Library  otr_model_lib.services.GenericService
Library  otr_model_lib.Models
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.reports.PyExcel
Library  OperatingSystem  WITH NAME  os
Resource  ../../Variables/validUser.robot
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/eManagerKeywords.robot


Force Tags  eManager
#Suite Setup  Initiate Test
#Suite Teardown  Complete Test


*** Test Cases ***
French Translations for Card Type Column on Card Management
    [Tags]  JIRA:BOT-914
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for Card Type Column on Card Management Screen
    [Setup]  Run Keywords  Open Emanager Using Static Shell Carrier
    ...  AND  change language to french
    Open Lookup Card Screen

    #CHECK IF letters WAS translated to french
    TCH Logging  \nCHECK IF letters WAS translated to french
    page should contain  Sans objet
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Products in Description Column on Card Limits
    [Tags]  refactor
    [Setup]  Run Keywords  Open Emanager Using Static Shell Carrier
    ...  AND  change language to french
    [Template]  French Translations for ${product} Products in Description Column on Card Limits Should be ${french_product}
    AVIATION MERCHANDISE  MARCHANDISE AVIATION
    ANTI FREEZE  ANTIGEL
    AVIATION GAS  CARBURANT AVIATION
    DIESEL  CARBURANT DIESEL
    JET FUEL  CARBURÉACTEUR
    KEROSENE  KÉROSÈNE
    MISCELLANEOUS MERCHANDISE  MARCHANDISES DIVERSES
    NATURAL GAS  GAZ NATUREL
    OIL  HUILE
    OIL CHANGE  VIDANGE D’HUILE
    PROPANE  PROPANE
    REPAIR SERVICE  SERVICE DE RÉPARATION
    REEFER  COMB. UNITÉ FRIGORIFIQUE
    TIRES TIRE REPAIR  PNEUS/RÉPARATION DE PNEUS
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Groups Column on Manage Users Screen
    [Tags]  JIRA:BOT-914    refactor
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for Groups Column on Manage Users Screen
    [Setup]  Run Keywords  Open Emanager Using Static Shell Carrier
    ...  AND  change language to french
    Open Manage Users Screen

    #CHECK IF letters WAS translated to french
    TCH Logging  \nCHECKING IF letters WAS translated to french

    TCH Logging  \n\nCHECK IF Groups Column was translated to french
    page should contain  Admin. entreprise
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
#    ...  AND  Close Browser

French Translations for Card Order Report
    [Tags]  JIRA:BOT-914  Reports  refactor
    [Documentation]  Order cards function in both the fleet & navigator
    [Setup]  Run Keywords  Open Emanager Using Static Shell Carrier
    ...  AND  change language to french
    Set Test Variable  ${expected_message}  Désolé, aucun enregistrement ne correspond à l’information suivante

    Mouse Over  id=menubar_1x2
    Mouse Over  id=TCHONLINE_CARDRPTx2
    Click Element  id=CARDRPT_CARD_ORDER_REPORTx2
    Select From List By Label  name=viewFormat  Excel
    Click Element  name=submit

    Wait Until Element Is Visible  //a[contains(@href, 'CardOrderReport.action') and text()]  timeout=30s
    Click Element  //a[contains(@href, 'CardOrderReport.action') and text()]

    os.Wait Until Created  ${default_download_path}*CardOrderReport*.xls

    @{file}  os.list directory  ${default_download_path}  *CardOrderReport*
    log to console  ${file[0]}
    ${downloadpath}  os.normalize path  ${default_download_path}
    ${filPath}  assign string  ${downloadpath}${/}${file[0]}

    open excel  ${filPath}
    ${sheets}  get sheet names
    ${first_line}  Get Row Values  ${sheets[0]}  0
    ${message}  Get From List  ${first_line}  1
    ${message}  Get From List  ${message}  1
    Should Be Equal As Strings  ${message}  ${expected_message}

    os.Remove File  ${filPath}
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Fuel Efficiency Report
    [Tags]  JIRA:BOT-914  Reports  refactor
    [Documentation]  Order cards function in both the fleet & navigator
    [Setup]  Run Keywords  Open Emanager Using Static Shell Carrier
    ...  AND  change language to french
    Set Test Variable  ${card_num_expected}             Numéro de carte
    Set Test Variable  ${driver_name_expected}          Nom du chauffeur
    Set Test Variable  ${unit_number_expected}          Numéro d’unité
    Set Test Variable  ${report_date_range_expected}    Période visée par le rapport
    Set Test Variable  ${miles_per_gallon_expected}     Milles par gallon
    Set Test Variable  ${kms_per_liter_expected}        Kilomètres par litre
    Set Test Variable  ${distance_traveled_expected}    Distance parcourue
    Set Test Variable  ${fill_expense_expected}         Dépenses en carburant
    Set Test Variable  ${unit_cost_expected}            Coût unitaire par kilomètre
    Set Test Variable  ${km_per_dollar_expected}        Kilomètre par dollar

    Set Test Variable  ${incorrect_odometer_date_expected}  Donnée du compteur kilom. erronée
    Set Test Variable  ${french_numeric_format_expected}    Désolé
    Set Test Variable  ${french_monetary_format_expected}   Désolé

    Mouse Over  id=menubar_1x2
    Mouse Over  id=TCHONLINE_CARDRPTx2
    Click Element  id=CARDRPT_FUEL_EFFICIENCY_REPORTx2
    Select From List By Label  name=viewFormat  Excel
    Click Element  name=submit

    Wait Until Element Is Visible    //a[contains(@href, 'FuelEfficiencyReport.action') and text()]  timeout=10s
    Click Element  //a[contains(@href, 'FuelEfficiencyReport.action') and text()]

    os.Wait Until Created  ${default_download_path}${/}*FuelEfficiencyReport*.xls

    @{file}  os.list directory  ${default_download_path}  *FuelEfficiencyReport*
    log to console  ${file[0]}
    ${downloadpath}  os.normalize path  ${default_download_path}
    ${filPath}  assign string  ${downloadpath}${/}${file[0]}

    open excel  ${filPath}
    ${sheets}  get sheet names
    ${first_line}  Get Row Values  ${sheets[0]}  0
    ${header_line}  Get Row Values  ${sheets[0]}  1
    tch logging  ${first_line}
    tch logging  ${header_line}

    ${report_date}          Get From List  ${first_line}         0
    ${report_date}          Get From List  ${report_date}        1
    ${card_num}             Get From List  ${header_line}        0
    ${card_num}             Get From List  ${card_num}           1
    ${driver_name}          Get From List  ${header_line}        1
    ${driver_name}          Get From List  ${driver_name}        1
    ${unit_number}          Get From List  ${header_line}        2
    ${unit_number}          Get From List  ${unit_number}        1
    ${miles_per_gallon}     Get From List  ${header_line}        3
    ${miles_per_gallon}     Get From List  ${miles_per_gallon}   1
    ${kms_per_liter}        Get From List  ${header_line}        4
    ${kms_per_liter}        Get From List  ${kms_per_liter}      1
    ${distance_traveled}    Get From List  ${header_line}        5
    ${distance_traveled}    Get From List  ${distance_traveled}  1
    ${fill_expense}         Get From List  ${header_line}        6
    ${fill_expense}         Get From List  ${fill_expense}       1
    ${unit_cost}            Get From List  ${header_line}        7
    ${unit_cost}            Get From List  ${unit_cost}          1
    ${km_per_dollar}        Get From List  ${header_line}        8
    ${km_per_dollar}        Get From List  ${km_per_dollar}      1

    should be equal as strings  ${card_num}  ${card_num_expected}
    should be equal as strings  ${driver_name}  ${driver_name_expected}
    should be equal as strings  ${unit_number}  ${unit_number_expected}
    should be equal as strings  ${miles_per_gallon}  ${miles_per_gallon_expected}
    should be equal as strings  ${kms_per_liter}  ${kms_per_liter_expected}
    should be equal as strings  ${distance_traveled}  ${distance_traveled_expected}
    should be equal as strings  ${fill_expense}  ${fill_expense_expected}
    should be equal as strings  ${unit_cost}  ${unit_cost_expected}
    should be equal as strings  ${km_per_dollar}  ${km_per_dollar_expected}

#    Report data message is not translating to French
#    should contain  ${report_date}  ${report_date_range_expected}

    os.Remove File  ${filPath}
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Product in Product Type Column on Fuel Tax Report
    [Tags]  refactor
    [Setup]  Run Keywords  Open Emanager Using Static Shell Carrier
    ...  AND  change language to french
    [Template]  French Translations for ${product} in Product Type Column on Fuel Tax Report Should be ${french_product}
    AVGS – AVIATION GAS  CRBA - CARBURANT AVIATION
    BDSL - BIODIESEL  BDSL - BIODIESEL
    DEF – DIESEL EXHAUST FLUID UREA  LED - LIQUIDE D'ÉCHAPP. DIESEL
    DSL – DIESEL  DSL - CARBURANT DIESEL
    DSLM – MEXICAN DIESEL  DSLM - DIESEL MEXICAIN
    FURN – FURNACE OIL  MDOM - MAZOUT DOMESTIQUE
    GAS – GASOLINE  ESS - ESSENCE
    JET – JET FUEL  CRBR - CARBURÉACTEUR
    KERO – KEROSENE  KERO - KÉROSÈNE
    MDSL – TAX EXEMPT DIESEL  DSLT - DIESEL EXONÉRÉ DE TAXE
    MGAS – TAX EXEMPT GAS  ESST - ESSENCE EXONÉRÉE DE TAXE
    MRFR – MARKED RFR  CCUF - COMB. COLOR. UNITÉ FRIG
    NGAS – NATURAL GAS  GAZN - GAZ NATUREL
    PROP – PROPANE  PROP - PROPANE
    RFR – REEFER  CUF - COMB. UNITÉ FRIGORIFIQUE
    RFRM – MEXICAN REEFER  CUFM - COMB. UNITÉ FRIG. MEXICAIN
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Disclaimers on Shell Customer Price Report Screen
    [Setup]  Run Keywords  Open Emanager Using Static Shell Carrier
    ...  AND  change language to french
    [Template]  French Translations for Disclaimers on Shell Customer Price Report
    Déclaration no 1  (S'applique aux clients qui acceptent de recevoir du courrier électronique)  Le client demande et consent expressément à recevoir de SFJ par courrier électronique un avis de courtoisie de toute modification des prix contractuels, quel que soit la date à laquelle un tel changement prend effet. Le client reconnaît et accepte expressément ce qui suit : (i) les avis de changement de prix ne sont envoyés par courrier électronique qu'à titre gracieux et SFJ n'est pas tenue de transmettre de tels avis; (ii) des difficultés techniques ou des problèmes liés aux services publics peuvent à l'occasion empêcher la transmission ou la réception du courrier électronique et SFJ n'assume aucune responsabilité à l'égard de telles défaillances; (iii) il incombe exclusivement au client d'indiquer son adresse de courrier électronique à SFJ et de l'informer de tout changement d'adresse; (iv) les changements de prix seront affichés et pourront être consultés au moyen de E-manager, une application Web que fournit SFJ; (v) le client est réputé avoir choisi de recevoir des avis par voie électronique au nom de ses employés et de ses représentants; (vi) avec ou sans préavis, SFJ se réserve expressément le droit de modifier les prix contractuels et non contractuels lorsqu'elle l'estime souhaitable (y compris, de façon non limitative, les prix indiqués dans un avis envoyé conformément aux présentes); (vii) les avis concernant les prix n'ont pas pour objet de présenter au client une offre qu'il peut choisir d'accepter ou de refuser, et le client ne peut interpréter ces avis comme constituant une telle offre; (viii) le client ne dispose d'aucun droit de contestation des changements de prix indiqués dans un avis.
    Déclaration no 2  (S'applique aux clients qui refusent de recevoir du courrier électronique)  Le client reconnaît expressément avoir refusé de recevoir par courrier électronique les avis de courtoisie de SFJ concernant la modification des prix contractuels. Le client reconnaît et accepte en outre ce qui suit : (i) SFJ peut en tout temps modifier les prix et, ayant refusé de recevoir des avis par voie électronique, le client et toute personne agissant pour son compte ou en son nom ne pourront recevoir les avis relatifs à de tels changements des prix contractuels; (ii) SFJ se réserve expressément le droit de modifier les prix contractuels et non contractuels lorsqu'elle l'estime souhaitable, avec ou sans préavis; (iii) le client renonce à la possibilité de recevoir des avis par voie électronique au nom de ses employés et de ses représentants; (iv) le client ne dispose d'aucun droit de contestation des changements de prix.
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Prompt Type Column on Card Management
    [Tags]  JIRA:BOT-914  refactor
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for Prompt Type Column on Card Management Screen
    [Setup]  Run Keywords  Open Emanager Using 2nd Static Shell Carrier
    ...  AND  change language to french
    Open Lookup Card Screen

    #CHECK IF letters WAS translated to french
    TCH Logging  \nCHECK IF letters WAS translated to french
    page should contain  Chauffeur et compt. kilom
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Card Order
    [Tags]  JIRA:BOT-914  BUGGED:After selecting the policy we are getting an error despite the carrier having the correct permissions and policy  refactor
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for second Disclaimers on Shell Customer Price Report Screen
    [Setup]  Run Keywords  Open Emanager Using 2nd Static Shell Carrier
    ...  AND  change language to french

    Open Order Cards Screen
    select from list by index  cardPolicy  1

    Element Should Be Visible  //select[@name='cardAssignment']/option[text()='Sélectionner un option']
    Element Should Be Visible  //select[@name='productRestrictions']/option[text()='Sélectionner un option']
    Element Should Be Visible  //select[@name='cardOrder.promptCode']/option[text()='Sélectionner un message']
    Element Should Be Visible  //select[@name='cardOrder.maillanguage']/option[contains(text(),'Sélectionner une langue')]
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Home Screen - Quick Link
    [Tags]  JIRA:BOT-914  BUGGED:SIM-915 Document doesn't has french translation for this test case. Error message should appear in French but it is in English.    refactor
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for second Disclaimers on Shell Customer Price Report Screen
    [Setup]  Run Keywords  Open Emanager Using 2nd Static Shell Carrier
    ...  AND  change language to french

    Click Element  //a[contains(@href,'/cards/Index.action')]

    ${shell_station_locator}  Get Text  //a[contains(@href,'products-services/shell-for-drivers/station-locator.html')]

    Should Be Equal As Strings  ${shell_station_locator}  Localisateur de stations-service Shell
    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Info Pool
    [Tags]  JIRA:BOT-914  BUGGED:the letters was not translated to french    refactor
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for second Disclaimers on Shell Customer Price Report Screen
    [Setup]  Run Keywords  Open Emanager Using 2nd Static Shell Carrier
    ...  AND  change language to french

    Open Infor Pool Management Screen

    Select From List By Label  ipolicy  Toutes les configurations
    Select From List By Index  prompt  1
    Click Element  redirectToAddInfoPool
    Click Element  addInfoPool

    ${error_message}  Get Text  //div[@class='errors']//li
    tch logging  ${error_message}
    Should Not Be Equal As Strings  ${error_message}  Policy, prompt, and value are all required.
    Click Element  cancel

    Select From List By Label  ipolicy  Toutes les configurations
    Select From List By Index  prompt  1
    Select From List By Index  prompt  0
    Click Element  redirectToAddInfoPool

    ${error_message}  Get Text  //div[@class='errors']//li
    tch logging  ${error_message}
    Should Not Be Equal As Strings  ${error_message}  You must select a valid policy and prompt to add a new info pool item. Re-select the policy to reload the prompts and select a value for each before adding or refreshing.

    [Teardown]  Run Keywords  reset language to english  ${carrier.member_id}
    ...  AND  Close Browser

French Translations for Allowed Contracts in Permissions Inactive Column on adding Permissions to User
    [Tags]  refactor
    [Setup]  Run Keywords  Open Emanager Using Intern Robot Carrier
    ...  AND  change language to french
    ...  AND  Define Static Shell Carrier
    [Template]  French Translations for ${item} in Permissions Inactive Column on adding Permissions to User Should Be ${french_item}
    Contracts  Contrats autorisés
    Policies  Configurations autorisées
    Subfleets  Sous-parcs autorisés
    [Teardown]  Run Keywords  reset language to english  ${intern}
    ...  AND  Close Browser

French Translations for Denied Contracts in Permissions Inactive Column on adding Permissions to User
    [Tags]  refactor
    [Setup]  Run Keywords  Open Emanager Using Intern Robot Carrier
    ...  AND  change language to french
    ...  AND  Define Static Shell Carrier
    [Template]  French Translations for ${item} in Permissions Inactive Column on adding Permissions to User Should Be ${french_item}
    Contracts  Contrats refusés
    Policies  Configurations refusées
    Subfleets  Sous-parcs refusés
    [Teardown]  Run Keywords  reset language to english  ${intern}
    ...  AND  Close Browser

*** Keywords ***
Open Emanager Using Static Shell Carrier
    ${carrier}  Set Carrier Variable  527959  instance=Shell
    Set Test Variable  ${carrier}
    Open eManager  ${carrier.member_id}  ${carrier.password}

Open Emanager Using 2nd Static Shell Carrier
    ${carrier}  Set Carrier Variable  600000  instance=Shell
    Set Test Variable  ${carrier}
    Open eManager  ${carrier.member_id}  ${carrier.password}

Open Emanager Using Intern Robot Carrier
    Open eManager  ${intern}  ${internPassword}

Define Static Shell Carrier
    ${carrier}  Set Carrier Variable  527959  instance=Shell
    Set Test Variable  ${carrier}

French Translations for ${product} Products in Description Column on Card Limits Should be ${french_product}
    [Tags]  JIRA:BOT-914
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for ${product} Product in Description Column on Card Limits Screen

    #GETTING A SHELL CARD
    tch logging  \n\n GETTING A ACTIVE SHELL CARD PARKED ON CARRIER ${carrier.member_id}
    ${card_num}  Query And Strip  query=select card_num from cards where carrier_id='${carrier.member_id}' and status='A' limit 1  db_instance=Shell
    ${card_num}  Strip String  ${card_num}
    tch logging  \nCARD NUMBER: ${card_num}

    Open Lookup Card Screen

    #OPEN CARD PROMPT DETAIL SCREEN
    TCH Logging  \nOPEN CARD PROMPT DETAIL SCREEN
    Click Element  //a[text()='${card_num}']

    #OPEN UPDATE LIMITS SCREEN
    TCH Logging  \nOPEN UPDATE LIMITS SCREEN
    Wait until element is visible  //*[@class="horz_nlsitem" and text()=" Limites"]
    Mouse Over  //*[@class="horz_nlsitem" and text()=" Limites"]
    Click Element  //*[@class="nlsitem" and text()=" Mettre à jour les limites"]

    #CHECK IF ${product} product was translated to french
    TCH Logging  \n\nCHECK IF ${product} product was translated to french
    page should contain  ${french_product}

French Translations for ${product} in Product Type Column on Fuel Tax Report Should be ${french_product}
    [Tags]  JIRA:BOT-914
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for Product Type Column on Fuel Tax Report Screen
    #   OPEN MANAGE USER SCREEN
    TCH Logging  \nOPEN MANAGE USER SCREEN
    Open Fuel Tax Report Screen

    #CHECK IF letters WAS translated to french
    TCH Logging  \nCHECKING IF letters WAS translated to french

    TCH Logging  \n\nCHECK IF ${product} product was translated to french
    page should contain  ${french_product}

French Translations for ${item} in Permissions Inactive Column on adding Permissions to User Should Be ${french_item}
    [Tags]  JIRA:BOT-914
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for Permissions Inactive Column on Manage Users Roles

    #   OPEN MANAGE USER SCREEN
    TCH Logging  \nOPEN MANAGE USER SCREEN
    Open Manage Users Screen

    input text  searchValue  ${carrier.member_id}
    click element  searchUsers
    click element  ManageRoles

    #CHECK IF letters WAS translated to french
    TCH Logging  \nCHECKING IF letters WAS translated to french
    TCH Logging  \n\nCHECK IF Allowed ${item} in Permissions Inactive was translated to french
    page should contain  ${french_item}

French Translations for Disclaimers on Shell Customer Price Report
    [Tags]  JIRA:BOT-914
    [Documentation]  Verify if English letters have been modified or properly translated to french letters
    ...  for second Disclaimers on Shell Customer Price Report Screen
    [Arguments]  ${msg_1}  ${msg_2}  ${msg_3}
    #   OPEN MANAGE USER SCREEN
    TCH Logging  \nOPEN MANAGE USER SCREEN
    Open Shell Custom Screen

#CHECK IF letters WAS translated to french
    TCH Logging  \nCHECKING IF letters WAS translated to french

    TCH Logging  \n\nCHECK IF Disclaimer # was translated to french
    page should contain  ${msg_1}
    page should contain  ${msg_2}
    page should contain  ${msg_3}

Open Lookup Card Screen
    go to  ${emanager}/cards/CardLookup.action

Open Manage Users Screen
    go to  ${emanager}/security/ManageUsers.action

Open Shell Custom Screen
    go to  ${emanager}/cards/ShellCustReport.action

Open Fuel Tax Report Screen
    go to  ${emanager}/cards/FuelTaxReport.action

Open Profile User
    go to  ${emanager}/security/ManageUsers.action?LoadProfile

Open Infor Pool Management Screen
    Go To  ${emanager}/cards/InfoPoolManagement.action

Open Order Cards Screen
    go to  ${emanager}/cards/OrderCards.action

Change Language to French
    Open Profile User
    Select From List By Value  user.locale.localeId  fr_CA
    Click button  SaveProfile
    Wait Until Element Is Visible  //ul[@class="messages"]/li[contains(text(), "L'information du profil est mise à jour avec succès pour")]  timeout=60

Reset Language to English
    [Arguments]  ${user}
    get into db  mysql
    execute sql string  dml=update sec_user set locale = 'en_US' where user_id = '${user}'
    get into db  shell