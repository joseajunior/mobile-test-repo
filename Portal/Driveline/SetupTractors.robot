*** Settings ***
Documentation
...  This is a Test Suite for SetupTractors section of Driveline application
...  This test is to validate all Setup-Tractors functionalities such as Add/Edit Tractors,
...  Status Changing, Add/Remove Jurisdiction.
...  In order to avoid fails, the TIMEOUT variable controls the time that the script
...  should wait in case the application goes slow or stop responding

Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ssh.PySSH
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.support.PyString
Library  otr_robot_lib.ui.web.PySelenium
Resource  otr_robot_lib/robot/RobotKeywords.robot
Resource  otr_robot_lib/robot/DrivelineKeywords.robot
Resource  ../../Variables/validUser.robot

Force Tags  Driveline  refactor
Suite Setup  Start Suite
Suite Teardown  close all browsers

*** Variables ***
${SuperUserTractor}
${SupportLevelTractor}
${CompanyAdminTractor}
${TIMEOUT}  15

*** Test Cases ***

Admin Super User should be able to create a new tractor
    [Tags]  JIRA:PORT-166  qTest:40009246
    [Documentation]  Validate if an Admin in Super User level with valid credentials can log into Driveline and create a new tractor
    ...  The user should have access to the Setup - Tractors - Add/Edit Tractors section.
    ...  The user should be able to Create a new tractor.
    [Setup]  Input Admin Super User Level Credentials and Then Click on Login
    Navigate to Setup - Tractors
    Click on Add Tractor Button
    Fill Up Reference ID Field and Click on Save Button  ${SuperUserTractor}

Admin Super User should be able to add a new Jurisdiction to AB - Alberta with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AB - Alberta with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AB - Alberta as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     [Setup]  Click on Tractor and Then Click on Jurisdiction  ${SuperUserTractor}
     Fill Up Gvwr field and Click on Add Button  AB - Alberta  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AB  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   AB  Pound
Admin Super User should be able to remove a Jurisdiction to AB - Alberta with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AB - Alberta with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AB - Alberta with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AB  Pound
Admin Super User should be able to add a new Jurisdiction to AB - Alberta with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AB - Alberta with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AB - Alberta as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AB - Alberta  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  AB  Kilogram
Admin Super User should be able to remove a Jurisdiction to AB - Alberta with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AB - Alberta with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AB - Alberta with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AB  Kilogram

Admin Super User should be able to add a new Jurisdiction to AG - Aguascalientes with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AG - Aguascalientes with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AG - Aguascalientes as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AG - Aguascalientes  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AG  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   AG  Pound
Admin Super User should be able to remove a Jurisdiction to AG - Aguascalientes with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AG - Aguascalientes with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AG - Aguascalientes with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AG  Pound
Admin Super User should be able to add a new Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AG - Aguascalientes as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AG - Aguascalientes  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  AG  Kilogram
Admin Super User should be able to remove a Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AG - Aguascalientes with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AG - Aguascalientes with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AG  Kilogram

Admin Super User should be able to add a new Jurisdiction to AK - Alaska with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AK - Alaska with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AK - Alaska as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AK - Alaska  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AK  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   AK  Pound
Admin Super User should be able to remove a Jurisdiction to AK - Alaska with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AK - Alaska with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AK - Alaska with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AK  Pound
Admin Super User should be able to add a new Jurisdiction to AK - Alaska with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AK - Alaska with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AK - Alaska as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AK - Alaska  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AK  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  AK  Kilogram
Admin Super User should be able to remove a Jurisdiction to AK - Alaska with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AK - Alaska with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AK - Alaska with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AK  Kilogram

Admin Super User should be able to add a new Jurisdiction to AL - Alabama with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AL - Alabama with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AL - Alabama as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AL - Alabama  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AL  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   AL  Pound
Admin Super User should be able to remove a Jurisdiction to AL - Alabama with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AL - Alabama with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AL - Alabama with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AL  Pound
Admin Super User should be able to add a new Jurisdiction to AL - Alabama with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AL - Alabama with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AL - Alabama as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AL - Alabama  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  AL  Kilogram
Admin Super User should be able to remove a Jurisdiction to AL - Alabama with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AL - Alabama with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AL - Alabama with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AL  Kilogram

Admin Super User should be able to add a new Jurisdiction to AR - Arkansas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AR - Arkansas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AR - Arkansas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AR - Arkansas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AR  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   AR  Pound
Admin Super User should be able to remove a Jurisdiction to AR - Arkansas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AR - Arkansas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AR - Arkansas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AR  Pound
Admin Super User should be able to add a new Jurisdiction to AR - Arkansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AR - Arkansas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AR - Arkansas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AR - Arkansas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  AR  Kilogram
Admin Super User should be able to remove a Jurisdiction to AR - Arkansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AR - Arkansas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AR - Arkansas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AR  Kilogram

Admin Super User should be able to add a new Jurisdiction to AS - American Samoa with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AS - American Samoa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AS - American Samoa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AS - American Samoa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AS  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   AS  Pound
Admin Super User should be able to remove a Jurisdiction to AS - American Samoa with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AS - American Samoa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AS - American Samoa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AS  Pound
Admin Super User should be able to add a new Jurisdiction to AS - American Samoa with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AS - American Samoa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AS - American Samoa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AS - American Samoa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  AS  Kilogram
Admin Super User should be able to remove a Jurisdiction to AS - American Samoa with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AS - American Samoa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AS - American Samoa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AS  Kilogram

Admin Super User should be able to add a new Jurisdiction to AZ - Arizona with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AZ - Arizona with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AZ - Arizona as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AZ - Arizona  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AZ  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   AZ  Pound
Admin Super User should be able to remove a Jurisdiction to AZ - Arizona with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AZ - Arizona with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AZ - Arizona with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AZ  Pound
Admin Super User should be able to add a new Jurisdiction to AZ - Arizona with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to AZ - Arizona with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AZ - Arizona as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AZ - Arizona  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AZ  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  AZ  Kilogram
Admin Super User should be able to remove a Jurisdiction to AZ - Arizona with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to AZ - Arizona with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AZ - Arizona with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AZ  Kilogram

Admin Super User should be able to add a new Jurisdiction to BC - Baja California with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BC - Baja California with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BC - Baja California as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - Baja California  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BC  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   BC  Pound
Admin Super User should be able to remove a Jurisdiction to BC - Baja California with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BC - Baja California with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - Baja California with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BC  Pound
Admin Super User should be able to add a new Jurisdiction to BC - Baja California with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BC - Baja California with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BC - Baja California as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - Baja California  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BC  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  BC  Kilogram
Admin Super User should be able to remove a Jurisdiction to BC - Baja California with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BC - Baja California with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - Baja California with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BC  Kilogram

Admin Super User should be able to add a new Jurisdiction to BC - British Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BC - British Columbia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BC - British Columbia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - British Columbia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BC  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   BC  Pound
Admin Super User should be able to remove a Jurisdiction to BC - British Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BC - British Columbia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - British Columbia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BC  Pound
Admin Super User should be able to add a new Jurisdiction to BC - British Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BC - British Columbia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BC - British Columbia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - British Columbia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BC  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  BC  Kilogram
Admin Super User should be able to remove a Jurisdiction to BC - British Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BC - British Columbia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - British Columbia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BC  Kilogram

Admin Super User should be able to add a new Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BN - Baja Caifornia Norte as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BN - Baja Caifornia Norte  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BN  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   BN  Pound
Admin Super User should be able to remove a Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BN - Baja Caifornia Norte with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BN - Baja Caifornia Norte with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BN  Pound
Admin Super User should be able to add a new Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BN - Baja Caifornia Norte as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BN - Baja Caifornia Norte  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BN  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  BN  Kilogram
Admin Super User should be able to remove a Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BN - Baja Caifornia Norte with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BN - Baja Caifornia Norte with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BN  Kilogram

Admin Super User should be able to add a new Jurisdiction to BS - Baja California Sur with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BS - Baja California Sur with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BS - Baja California Sur as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BS - Baja California Sur  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BS  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   BS  Pound
Admin Super User should be able to remove a Jurisdiction to BS - Baja California Sur with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BS - Baja California Sur with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BS - Baja California Sur with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BS  Pound
Admin Super User should be able to add a new Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BS - Baja California Sur as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BS - Baja California Sur  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BS  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  BS  Kilogram
Admin Super User should be able to remove a Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to BS - Baja California Sur with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BS - Baja California Sur with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BS  Kilogram

Admin Super User should be able to add a new Jurisdiction to CA - California with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CA - California with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CA - California as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CA - California  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CA  Pound
Admin Super User should be able to remove a Jurisdiction to CA - California with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CA - California with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CA - California with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CA  Pound
Admin Super User should be able to add a new Jurisdiction to CA - California with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CA - California with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CA - California as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CA - California  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CA  Kilogram
Admin Super User should be able to remove a Jurisdiction to CA - California with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CA - California with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CA - California with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CA  Kilogram

Admin Super User should be able to add a new Jurisdiction to CH - Chihuahua with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CH - Chihuahua with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CH - Chihuahua as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CH - Chihuahua  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CH  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CH  Pound
Admin Super User should be able to remove a Jurisdiction to CH - Chihuahua with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CH - Chihuahua with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CH - Chihuahua with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CH  Pound
Admin Super User should be able to add a new Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CH - Chihuahua as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CH - Chihuahua  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CH  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CH  Kilogram
Admin Super User should be able to remove a Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CH - Chihuahua with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CH - Chihuahua with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CH  Kilogram

Admin Super User should be able to add a new Jurisdiction to CL - Colima with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CL - Colima with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CL - Colima as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CL - Colima  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CL  Pound
Admin Super User should be able to remove a Jurisdiction to CL - Colima with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CL - Colima with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CL - Colima with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CL  Pound
Admin Super User should be able to add a new Jurisdiction to CL - Colima with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CL - Colima with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CL - Colima as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CL - Colima  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CL  Kilogram
Admin Super User should be able to remove a Jurisdiction to CL - Colima with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CL - Colima with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CL - Colima with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CL  Kilogram

Admin Super User should be able to add a new Jurisdiction to CM - Campeche with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CM - Campeche with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CM - Campeche as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CM - Campeche  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CM  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CM  Pound
Admin Super User should be able to remove a Jurisdiction to CM - Campeche with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CM - Campeche with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CM - Campeche with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CM  Pound
Admin Super User should be able to add a new Jurisdiction to CM - Campeche with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CM - Campeche with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CM - Campeche as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CM - Campeche  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CM  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CM  Kilogram
Admin Super User should be able to remove a Jurisdiction to CM - Campeche with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CM - Campeche with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CM - Campeche with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CM  Kilogram

Admin Super User should be able to add a new Jurisdiction to CO - Coahuila with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CO - Coahuila with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CO - Coahuila as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Coahuila  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CO  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CO  Pound
Admin Super User should be able to remove a Jurisdiction to CO - Coahuila with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CO - Coahuila with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Coahuila with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CO  Pound
Admin Super User should be able to add a new Jurisdiction to CO - Coahuila with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CO - Coahuila with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CO - Coahuila as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Coahuila  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CO  Kilogram
Admin Super User should be able to remove a Jurisdiction to CO - Coahuila with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CO - Coahuila with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Coahuila with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CO  Kilogram

Admin Super User should be able to add a new Jurisdiction to CO - Colorado with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CO - Colorado with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CO - Colorado as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Colorado  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CO  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CO  Pound
Admin Super User should be able to remove a Jurisdiction to CO - Colorado with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CO - Colorado with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Colorado with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CO  Pound
Admin Super User should be able to add a new Jurisdiction to CO - Colorado with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CO - Colorado with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CO - Colorado as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Colorado  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CO  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CO  Kilogram
Admin Super User should be able to remove a Jurisdiction to CO - Colorado with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CO - Colorado with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Colorado with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CO  Kilogram

Admin Super User should be able to add a new Jurisdiction to CS - Chiapas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CS - Chiapas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CS - Chiapas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CS - Chiapas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CS  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CS  Pound
Admin Super User should be able to remove a Jurisdiction to CS - Chiapas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CS - Chiapas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CS - Chiapas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CS  Pound
Admin Super User should be able to add a new Jurisdiction to CS - Chiapas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CS - Chiapas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CS - Chiapas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CS - Chiapas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CS  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CS  Kilogram
Admin Super User should be able to remove a Jurisdiction to CS - Chiapas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CS - Chiapas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CS - Chiapas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CS  Kilogram

Admin Super User should be able to add a new Jurisdiction to CT - Connecticut with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CT - Connecticut with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CT - Connecticut as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CT - Connecticut  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CT  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   CT  Pound
Admin Super User should be able to remove a Jurisdiction to CT - Connecticut with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CT - Connecticut with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CT - Connecticut with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CT  Pound
Admin Super User should be able to add a new Jurisdiction to CT - Connecticut with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to CT - Connecticut with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CT - Connecticut as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CT - Connecticut  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  CT  Kilogram
Admin Super User should be able to remove a Jurisdiction to CT - Connecticut with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to CT - Connecticut with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CT - Connecticut with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CT  Kilogram

Admin Super User should be able to add a new Jurisdiction to DC - District of Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DC - District of Columbia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DC - District of Columbia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DC - District of Columbia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DC  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   DC  Pound
Admin Super User should be able to remove a Jurisdiction to DC - District of Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DC - District of Columbia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DC - District of Columbia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DC  Pound
Admin Super User should be able to add a new Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DC - District of Columbia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DC - District of Columbia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  DC  Kilogram
Admin Super User should be able to remove a Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DC - District of Columbia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DC - District of Columbia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DC  Kilogram

Admin Super User should be able to add a new Jurisdiction to DE - Delaware with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DE - Delaware with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DE - Delaware as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DE - Delaware  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DE  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   DE  Pound
Admin Super User should be able to remove a Jurisdiction to DE - Delaware with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DE - Delaware with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DE - Delaware with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DE  Pound
Admin Super User should be able to add a new Jurisdiction to DE - Delaware with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DE - Delaware with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DE - Delaware as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DE - Delaware  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DE  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  DE  Kilogram
Admin Super User should be able to remove a Jurisdiction to DE - Delaware with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DE - Delaware with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DE - Delaware with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DE  Kilogram

Admin Super User should be able to add a new Jurisdiction to DF - Distritio Federal with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DF - Distritio Federal with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DF - Distritio Federal as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DF - Distritio Federal  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DF  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   DF  Pound
Admin Super User should be able to remove a Jurisdiction to DF - Distritio Federal with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DF - Distritio Federal with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DF - Distritio Federal with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DF  Pound
Admin Super User should be able to add a new Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DF - Distritio Federal as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DF - Distritio Federal  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DF  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  DF  Kilogram
Admin Super User should be able to remove a Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DF - Distritio Federal with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DF - Distritio Federal with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DF  Kilogram

Admin Super User should be able to add a new Jurisdiction to DG - Durango with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DG - Durango with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DG - Durango as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DG  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   DG  Pound
Admin Super User should be able to remove a Jurisdiction to DG - Durango with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DG - Durango with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DG - Durango with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DG  Pound
Admin Super User should be able to add a new Jurisdiction to DG - Durango with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to DG - Durango with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DG - Durango as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  DG  Kilogram
Admin Super User should be able to remove a Jurisdiction to DG - Durango with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to DG - Durango with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DG - Durango with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DG  Kilogram

Admin Super User should be able to add a new Jurisdiction to FL - Florida with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to FL - Florida with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting FL - Florida as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FL - Florida  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    FL  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   FL  Pound
Admin Super User should be able to remove a Jurisdiction to FL - Florida with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to FL - Florida with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to FL - Florida with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  FL  Pound
Admin Super User should be able to add a new Jurisdiction to FL - Florida with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to FL - Florida with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting FL - Florida as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FL - Florida  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  FL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  FL  Kilogram
Admin Super User should be able to remove a Jurisdiction to FL - Florida with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to FL - Florida with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to FL - Florida with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    FL  Kilogram

Admin Super User should be able to add a new Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting FM - Federated States of Micronesia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FM - Federated States of Micronesia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    FM  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   FM  Pound
Admin Super User should be able to remove a Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to FM - Federated States of Micronesia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to FM - Federated States of Micronesia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  FM  Pound
Admin Super User should be able to add a new Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting FM - Federated States of Micronesia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FM - Federated States of Micronesia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  FM  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  FM  Kilogram
Admin Super User should be able to remove a Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to FM - Federated States of Micronesia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to FM - Federated States of Micronesia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    FM  Kilogram

Admin Super User should be able to add a new Jurisdiction to GA - Georgia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GA - Georgia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GA - Georgia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GA - Georgia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   GA  Pound
Admin Super User should be able to remove a Jurisdiction to GA - Georgia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GA - Georgia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GA - Georgia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GA  Pound
Admin Super User should be able to add a new Jurisdiction to GA - Georgia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GA - Georgia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GA - Georgia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GA - Georgia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  GA  Kilogram
Admin Super User should be able to remove a Jurisdiction to GA - Georgia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GA - Georgia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GA - Georgia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GA  Kilogram

Admin Super User should be able to add a new Jurisdiction to GR - Guerrero with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GR - Guerrero with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GR - Guerrero as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GR - Guerrero  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GR  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   GR  Pound
Admin Super User should be able to remove a Jurisdiction to GR - Guerrero with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GR - Guerrero with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GR - Guerrero with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GR  Pound
Admin Super User should be able to add a new Jurisdiction to GR - Guerrero with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GR - Guerrero with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GR - Guerrero as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GR - Guerrero  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GR  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  GR  Kilogram
Admin Super User should be able to remove a Jurisdiction to GR - Guerrero with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GR - Guerrero with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GR - Guerrero with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GR  Kilogram

Admin Super User should be able to add a new Jurisdiction to GT - Guanajuato with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GT - Guanajuato with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GT - Guanajuato as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GT - Guanajuato  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GT  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   GT  Pound
Admin Super User should be able to remove a Jurisdiction to GT - Guanajuato with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GT - Guanajuato with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GT - Guanajuato with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GT  Pound
Admin Super User should be able to add a new Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GT - Guanajuato as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GT - Guanajuato  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  GT  Kilogram
Admin Super User should be able to remove a Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GT - Guanajuato with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GT - Guanajuato with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GT  Kilogram

Admin Super User should be able to add a new Jurisdiction to GU - Guam with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GU - Guam with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GU - Guam as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GU - Guam  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GU  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   GU  Pound
Admin Super User should be able to remove a Jurisdiction to GU - Guam with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GU - Guam with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GU - Guam with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GU  Pound
Admin Super User should be able to add a new Jurisdiction to GU - Guam with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to GU - Guam with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GU - Guam as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GU - Guam  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GU  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  GU  Kilogram
Admin Super User should be able to remove a Jurisdiction to GU - Guam with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to GU - Guam with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GU - Guam with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GU  Kilogram

Admin Super User should be able to add a new Jurisdiction to HG - Hidalgo with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to HG - Hidalgo with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting HG - Hidalgo as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HG - Hidalgo  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    HG  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   HG  Pound
Admin Super User should be able to remove a Jurisdiction to HG - Hidalgo with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to HG - Hidalgo with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to HG - Hidalgo with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  HG  Pound
Admin Super User should be able to add a new Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting HG - Hidalgo as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HG - Hidalgo  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  HG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  HG  Kilogram
Admin Super User should be able to remove a Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to HG - Hidalgo with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to HG - Hidalgo with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    HG  Kilogram

Admin Super User should be able to add a new Jurisdiction to HI - Hawaii with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to HI - Hawaii with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting HI - Hawaii as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HI - Hawaii  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    HI  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   HI  Pound
Admin Super User should be able to remove a Jurisdiction to HI - Hawaii with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to HI - Hawaii with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to HI - Hawaii with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  HI  Pound
Admin Super User should be able to add a new Jurisdiction to HI - Hawaii with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to HI - Hawaii with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting HI - Hawaii as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HI - Hawaii  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  HI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  HI  Kilogram
Admin Super User should be able to remove a Jurisdiction to HI - Hawaii with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to HI - Hawaii with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to HI - Hawaii with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    HI  Kilogram

Admin Super User should be able to add a new Jurisdiction to IA - Iowa with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to IA - Iowa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IA - Iowa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IA - Iowa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   IA  Pound
Admin Super User should be able to remove a Jurisdiction to IA - Iowa with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to IA - Iowa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IA - Iowa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IA  Pound
Admin Super User should be able to add a new Jurisdiction to IA - Iowa with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to IA - Iowa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IA - Iowa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IA - Iowa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  IA  Kilogram
Admin Super User should be able to remove a Jurisdiction to IA - Iowa with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to IA - Iowa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IA - Iowa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IA  Kilogram

Admin Super User should be able to add a new Jurisdiction to ID - Idaho with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ID - Idaho with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ID - Idaho as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ID - Idaho  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ID  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   ID  Pound
Admin Super User should be able to remove a Jurisdiction to ID - Idaho with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ID - Idaho with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ID - Idaho with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ID  Pound
Admin Super User should be able to add a new Jurisdiction to ID - Idaho with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ID - Idaho with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ID - Idaho as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ID - Idaho  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ID  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  ID  Kilogram
Admin Super User should be able to remove a Jurisdiction to ID - Idaho with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ID - Idaho with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ID - Idaho with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ID  Kilogram

Admin Super User should be able to add a new Jurisdiction to IL - Illinois with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to IL - Illinois with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IL - Illinois as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IL - Illinois  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IL  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   IL  Pound
Admin Super User should be able to remove a Jurisdiction to IL - Illinois with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to IL - Illinois with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IL - Illinois with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IL  Pound
Admin Super User should be able to add a new Jurisdiction to IL - Illinois with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to IL - Illinois with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IL - Illinois as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IL - Illinois  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  IL  Kilogram
Admin Super User should be able to remove a Jurisdiction to IL - Illinois with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to IL - Illinois with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IL - Illinois with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IL  Kilogram

Admin Super User should be able to add a new Jurisdiction to IN - Indiana with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to IN - Indiana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IN - Indiana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IN - Indiana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IN  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   IN  Pound
Admin Super User should be able to remove a Jurisdiction to IN - Indiana with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to IN - Indiana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IN - Indiana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IN  Pound
Admin Super User should be able to add a new Jurisdiction to IN - Indiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to IN - Indiana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IN - Indiana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IN - Indiana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  IN  Kilogram
Admin Super User should be able to remove a Jurisdiction to IN - Indiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to IN - Indiana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IN - Indiana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IN  Kilogram

Admin Super User should be able to add a new Jurisdiction to JA - Jalisco with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to JA - Jalisco with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting JA - Jalisco as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  JA - Jalisco  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    JA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   JA  Pound
Admin Super User should be able to remove a Jurisdiction to JA - Jalisco with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to JA - Jalisco with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to JA - Jalisco with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  JA  Pound
Admin Super User should be able to add a new Jurisdiction to JA - Jalisco with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to JA - Jalisco with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting JA - Jalisco as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  JA - Jalisco  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  JA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  JA  Kilogram
Admin Super User should be able to remove a Jurisdiction to JA - Jalisco with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to JA - Jalisco with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to JA - Jalisco with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    JA  Kilogram

Admin Super User should be able to add a new Jurisdiction to KS - Kansas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to KS - Kansas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting KS - Kansas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KS - Kansas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    KS  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   KS  Pound
Admin Super User should be able to remove a Jurisdiction to KS - Kansas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to KS - Kansas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to KS - Kansas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  KS  Pound
Admin Super User should be able to add a new Jurisdiction to KS - Kansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to KS - Kansas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting KS - Kansas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KS - Kansas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  KS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  KS  Kilogram
Admin Super User should be able to remove a Jurisdiction to KS - Kansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to KS - Kansas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to KS - Kansas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    KS  Kilogram

Admin Super User should be able to add a new Jurisdiction to KY - Kentucky with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to KY - Kentucky with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting KY - Kentucky as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KY - Kentucky  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    KY  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   KY  Pound
Admin Super User should be able to remove a Jurisdiction to KY - Kentucky with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to KY - Kentucky with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to KY - Kentucky with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  KY  Pound
Admin Super User should be able to add a new Jurisdiction to KY - Kentucky with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to KY - Kentucky with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting KY - Kentucky as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KY - Kentucky  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  KY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  KY  Kilogram
Admin Super User should be able to remove a Jurisdiction to KY - Kentucky with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to KY - Kentucky with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to KY - Kentucky with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    KY  Kilogram

Admin Super User should be able to add a new Jurisdiction to LA - Louisiana with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to LA - Louisiana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting LA - Louisiana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  LA - Louisiana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    LA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   LA  Pound
Admin Super User should be able to remove a Jurisdiction to LA - Louisiana with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to LA - Louisiana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to LA - Louisiana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  LA  Pound
Admin Super User should be able to add a new Jurisdiction to LA - Louisiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to LA - Louisiana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting LA - Louisiana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  LA - Louisiana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  LA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  LA  Kilogram
Admin Super User should be able to remove a Jurisdiction to LA - Louisiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to LA - Louisiana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to LA - Louisiana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    LA  Kilogram

Admin Super User should be able to add a new Jurisdiction to MA - Massachusetts with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MA - Massachusetts with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MA - Massachusetts as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MA - Massachusetts  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MA  Pound
Admin Super User should be able to remove a Jurisdiction to MA - Massachusetts with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MA - Massachusetts with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MA - Massachusetts with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MA  Pound
Admin Super User should be able to add a new Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MA - Massachusetts as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MA - Massachusetts  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MA  Kilogram
Admin Super User should be able to remove a Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MA - Massachusetts with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MA - Massachusetts with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MA  Kilogram

Admin Super User should be able to add a new Jurisdiction to MB - Manitoba with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MB - Manitoba with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MB - Manitoba as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MB - Manitoba  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MB  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MB  Pound
Admin Super User should be able to remove a Jurisdiction to MB - Manitoba with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MB - Manitoba with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MB - Manitoba with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MB  Pound
Admin Super User should be able to add a new Jurisdiction to MB - Manitoba with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MB - Manitoba with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MB - Manitoba as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MB - Manitoba  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MB  Kilogram
Admin Super User should be able to remove a Jurisdiction to MB - Manitoba with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MB - Manitoba with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MB - Manitoba with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MB  Kilogram

Admin Super User should be able to add a new Jurisdiction to MD - Maryland with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MD - Maryland with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MD - Maryland as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MD - Maryland  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MD  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MD  Pound
Admin Super User should be able to remove a Jurisdiction to MD - Maryland with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MD - Maryland with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MD - Maryland with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MD  Pound
Admin Super User should be able to add a new Jurisdiction to MD - Maryland with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MD - Maryland with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MD - Maryland as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MD - Maryland  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MD  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MD  Kilogram
Admin Super User should be able to remove a Jurisdiction to MD - Maryland with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MD - Maryland with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MD - Maryland with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MD  Kilogram

Admin Super User should be able to add a new Jurisdiction to ME - Maine with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ME - Maine with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ME - Maine as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ME - Maine  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ME  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   ME  Pound
Admin Super User should be able to remove a Jurisdiction to ME - Maine with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ME - Maine with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ME - Maine with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ME  Pound
Admin Super User should be able to add a new Jurisdiction to ME - Maine with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ME - Maine with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ME - Maine as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ME - Maine  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ME  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  ME  Kilogram
Admin Super User should be able to remove a Jurisdiction to ME - Maine with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ME - Maine with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ME - Maine with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ME  Kilogram

Admin Super User should be able to add a new Jurisdiction to MH - Marshall Islands with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MH - Marshall Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MH - Marshall Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MH - Marshall Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MH  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MH  Pound
Admin Super User should be able to remove a Jurisdiction to MH - Marshall Islands with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MH - Marshall Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MH - Marshall Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MH  Pound
Admin Super User should be able to add a new Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MH - Marshall Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MH - Marshall Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MH  Kilogram
Admin Super User should be able to remove a Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MH - Marshall Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MH - Marshall Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MH  Kilogram

Admin Super User should be able to add a new Jurisdiction to MI - Michigan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MI - Michigan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michigan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michigan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MI  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MI  Pound
Admin Super User should be able to remove a Jurisdiction to MI - Michigan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MI - Michigan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michigan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MI  Pound
Admin Super User should be able to add a new Jurisdiction to MI - Michigan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MI - Michigan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michigan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michigan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MI  Kilogram
Admin Super User should be able to remove a Jurisdiction to MI - Michigan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MI - Michigan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michigan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MI  Kilogram

Admin Super User should be able to add a new Jurisdiction to MI - Michoacan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MI - Michoacan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michoacan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michoacan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MI  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MI  Pound
Admin Super User should be able to remove a Jurisdiction to MI - Michoacan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MI - Michoacan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michoacan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MI  Pound
Admin Super User should be able to add a new Jurisdiction to MI - Michoacan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MI - Michoacan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michoacan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michoacan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MI  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MI  Kilogram
Admin Super User should be able to remove a Jurisdiction to MI - Michoacan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MI - Michoacan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michoacan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MI  Kilogram

Admin Super User should be able to add a new Jurisdiction to MN - Minnesota with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MN - Minnesota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MN - Minnesota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MN - Minnesota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MN  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MN  Pound
Admin Super User should be able to remove a Jurisdiction to MN - Minnesota with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MN - Minnesota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MN - Minnesota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MN  Pound
Admin Super User should be able to add a new Jurisdiction to MN - Minnesota with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MN - Minnesota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MN - Minnesota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MN - Minnesota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MN  Kilogram
Admin Super User should be able to remove a Jurisdiction to MN - Minnesota with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MN - Minnesota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MN - Minnesota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MN  Kilogram

Admin Super User should be able to add a new Jurisdiction to MO - Missouri with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MO - Missouri with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MO - Missouri as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Missouri  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MO  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MO  Pound
Admin Super User should be able to remove a Jurisdiction to MO - Missouri with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MO - Missouri with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Missouri with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MO  Pound
Admin Super User should be able to add a new Jurisdiction to MO - Missouri with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MO - Missouri with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MO - Missouri as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Missouri  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MO  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MO  Kilogram
Admin Super User should be able to remove a Jurisdiction to MO - Missouri with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MO - Missouri with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Missouri with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MO  Kilogram

Admin Super User should be able to add a new Jurisdiction to MO - Morelos with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MO - Morelos with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MO - Morelos as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Morelos  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MO  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MO  Pound
Admin Super User should be able to remove a Jurisdiction to MO - Morelos with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MO - Morelos with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Morelos with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MO  Pound
Admin Super User should be able to add a new Jurisdiction to MO - Morelos with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MO - Morelos with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MO - Morelos as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Morelos  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MO  Kilogram
Admin Super User should be able to remove a Jurisdiction to MO - Morelos with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MO - Morelos with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Morelos with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MO  Kilogram

Admin Super User should be able to add a new Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MP - Northern Mariana Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MP - Northern Mariana Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MP  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MP  Pound
Admin Super User should be able to remove a Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MP - Northern Mariana Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MP - Northern Mariana Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MP  Pound
Admin Super User should be able to add a new Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MP - Northern Mariana Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MP - Northern Mariana Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MP  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MP  Kilogram
Admin Super User should be able to remove a Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MP - Northern Mariana Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MP - Northern Mariana Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MP  Kilogram

Admin Super User should be able to add a new Jurisdiction to MS - Mississippi with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MS - Mississippi with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MS - Mississippi as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MS - Mississippi  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MS  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MS  Pound
Admin Super User should be able to remove a Jurisdiction to MS - Mississippi with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MS - Mississippi with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MS - Mississippi with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MS  Pound
Admin Super User should be able to add a new Jurisdiction to MS - Mississippi with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MS - Mississippi with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MS - Mississippi as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MS - Mississippi  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MS  Kilogram
Admin Super User should be able to remove a Jurisdiction to MS - Mississippi with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MS - Mississippi with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MS - Mississippi with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MS  Kilogram

Admin Super User should be able to add a new Jurisdiction to MT - Montana with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MT - Montana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MT - Montana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MT - Montana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MT  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MT  Pound
Admin Super User should be able to remove a Jurisdiction to MT - Montana with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MT - Montana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MT - Montana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MT  Pound
Admin Super User should be able to add a new Jurisdiction to MT - Montana with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MT - Montana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MT - Montana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MT - Montana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MT  Kilogram
Admin Super User should be able to remove a Jurisdiction to MT - Montana with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MT - Montana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MT - Montana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MT  Kilogram

Admin Super User should be able to add a new Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MX - Edo. Mexico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MX - Edo. Mexico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MX  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   MX  Pound
Admin Super User should be able to remove a Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MX - Edo. Mexico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MX - Edo. Mexico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MX  Pound
Admin Super User should be able to add a new Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MX - Edo. Mexico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MX - Edo. Mexico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MX  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  MX  Kilogram
Admin Super User should be able to remove a Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to MX - Edo. Mexico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MX - Edo. Mexico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MX  Kilogram

Admin Super User should be able to add a new Jurisdiction to NA - Nayarit with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NA - Nayarit with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NA - Nayarit as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NA - Nayarit  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NA  Pound
Admin Super User should be able to remove a Jurisdiction to NA - Nayarit with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NA - Nayarit with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NA - Nayarit with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NA  Pound
Admin Super User should be able to add a new Jurisdiction to NA - Nayarit with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NA - Nayarit with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NA - Nayarit as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NA - Nayarit  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NA  Kilogram
Admin Super User should be able to remove a Jurisdiction to NA - Nayarit with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NA - Nayarit with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NA - Nayarit with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NA  Kilogram

Admin Super User should be able to add a new Jurisdiction to NB - New Brunswick with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NB - New Brunswick with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NB - New Brunswick as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NB - New Brunswick  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NB  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NB  Pound
Admin Super User should be able to remove a Jurisdiction to NB - New Brunswick with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NB - New Brunswick with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NB - New Brunswick with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NB  Pound
Admin Super User should be able to add a new Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NB - New Brunswick as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NB - New Brunswick  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NB  Kilogram
Admin Super User should be able to remove a Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NB - New Brunswick with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NB - New Brunswick with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NB  Kilogram

Admin Super User should be able to add a new Jurisdiction to NC - North Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NC - North Carolina with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NC - North Carolina as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NC - North Carolina  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NC  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NC  Pound
Admin Super User should be able to remove a Jurisdiction to NC - North Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NC - North Carolina with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NC - North Carolina with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NC  Pound
Admin Super User should be able to add a new Jurisdiction to NC - North Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NC - North Carolina with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NC - North Carolina as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NC - North Carolina  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NC  Kilogram
Admin Super User should be able to remove a Jurisdiction to NC - North Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NC - North Carolina with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NC - North Carolina with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NC  Kilogram

Admin Super User should be able to add a new Jurisdiction to ND - North Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ND - North Dakota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ND - North Dakota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ND - North Dakota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ND  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   ND  Pound
Admin Super User should be able to remove a Jurisdiction to ND - North Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ND - North Dakota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ND - North Dakota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ND  Pound
Admin Super User should be able to add a new Jurisdiction to ND - North Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ND - North Dakota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ND - North Dakota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ND - North Dakota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ND  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  ND  Kilogram
Admin Super User should be able to remove a Jurisdiction to ND - North Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ND - North Dakota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ND - North Dakota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ND  Kilogram

Admin Super User should be able to add a new Jurisdiction to NE - Nebraska with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NE - Nebraska with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NE - Nebraska as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NE - Nebraska  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NE  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NE  Pound
Admin Super User should be able to remove a Jurisdiction to NE - Nebraska with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NE - Nebraska with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NE - Nebraska with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NE  Pound
Admin Super User should be able to add a new Jurisdiction to NE - Nebraska with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NE - Nebraska with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NE - Nebraska as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NE - Nebraska  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NE  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NE  Kilogram
Admin Super User should be able to remove a Jurisdiction to NE - Nebraska with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NE - Nebraska with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NE - Nebraska with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NE  Kilogram

Admin Super User should be able to add a new Jurisdiction to NH - New Hampshire with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NH - New Hampshire with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NH - New Hampshire as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NH - New Hampshire  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NH  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NH  Pound
Admin Super User should be able to remove a Jurisdiction to NH - New Hampshire with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NH - New Hampshire with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NH - New Hampshire with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NH  Pound
Admin Super User should be able to add a new Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NH - New Hampshire as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NH - New Hampshire  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NH  Kilogram
Admin Super User should be able to remove a Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NH - New Hampshire with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NH - New Hampshire with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NH  Kilogram

Admin Super User should be able to add a new Jurisdiction to NJ - New Jersey with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NJ - New Jersey with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NJ - New Jersey as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NJ - New Jersey  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NJ  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NJ  Pound
Admin Super User should be able to remove a Jurisdiction to NJ - New Jersey with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NJ - New Jersey with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NJ - New Jersey with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NJ  Pound
Admin Super User should be able to add a new Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NJ - New Jersey as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NJ - New Jersey  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NJ  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NJ  Kilogram
Admin Super User should be able to remove a Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NJ - New Jersey with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NJ - New Jersey with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NJ  Kilogram

Admin Super User should be able to add a new Jurisdiction to NL - Newfoundland with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NL - Newfoundland with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NL - Newfoundland as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Newfoundland  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NL  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NL  Pound
Admin Super User should be able to remove a Jurisdiction to NL - Newfoundland with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NL - Newfoundland with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Newfoundland with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NL  Pound
Admin Super User should be able to add a new Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NL - Newfoundland as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Newfoundland  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NL  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NL  Kilogram
Admin Super User should be able to remove a Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NL - Newfoundland with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Newfoundland with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NL  Kilogram

Admin Super User should be able to add a new Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NL - Nuevo Leon as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Nuevo Leon  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NL  Pound
Admin Super User should be able to remove a Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NL - Nuevo Leon with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Nuevo Leon with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NL  Pound
Admin Super User should be able to add a new Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NL - Nuevo Leon as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Nuevo Leon  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NL  Kilogram
Admin Super User should be able to remove a Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NL - Nuevo Leon with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Nuevo Leon with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NL  Kilogram

Admin Super User should be able to add a new Jurisdiction to NM - New Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NM - New Mexico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NM - New Mexico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NM - New Mexico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NM  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NM  Pound
Admin Super User should be able to remove a Jurisdiction to NM - New Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NM - New Mexico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NM - New Mexico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NM  Pound
Admin Super User should be able to add a new Jurisdiction to NM - New Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NM - New Mexico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NM - New Mexico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NM - New Mexico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NM  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NM  Kilogram
Admin Super User should be able to remove a Jurisdiction to NM - New Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NM - New Mexico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NM - New Mexico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NM  Kilogram

Admin Super User should be able to add a new Jurisdiction to NS - Nova Scotia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NS - Nova Scotia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NS - Nova Scotia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NS - Nova Scotia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NS  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NS  Pound
Admin Super User should be able to remove a Jurisdiction to NS - Nova Scotia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NS - Nova Scotia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NS - Nova Scotia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NS  Pound
Admin Super User should be able to add a new Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NS - Nova Scotia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NS - Nova Scotia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NS  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NS  Kilogram
Admin Super User should be able to remove a Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NS - Nova Scotia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NS - Nova Scotia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NS  Kilogram

Admin Super User should be able to add a new Jurisdiction to NT - Northwest Territories with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NT - Northwest Territories with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NT - Northwest Territories as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NT - Northwest Territories  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NT  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NT  Pound
Admin Super User should be able to remove a Jurisdiction to NT - Northwest Territories with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NT - Northwest Territories with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NT - Northwest Territories with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NT  Pound
Admin Super User should be able to add a new Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NT - Northwest Territories as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NT - Northwest Territories  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NT  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NT  Kilogram
Admin Super User should be able to remove a Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NT - Northwest Territories with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NT - Northwest Territories with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NT  Kilogram

Admin Super User should be able to add a new Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NU - Nunavut Territory as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NU - Nunavut Territory  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NU  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NU  Pound
Admin Super User should be able to remove a Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NU - Nunavut Territory with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NU - Nunavut Territory with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NU  Pound
Admin Super User should be able to add a new Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NU - Nunavut Territory as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NU - Nunavut Territory  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NU  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NU  Kilogram
Admin Super User should be able to remove a Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NU - Nunavut Territory with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NU - Nunavut Territory with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NU  Kilogram

Admin Super User should be able to add a new Jurisdiction to NV - Nevada with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NV - Nevada with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NV - Nevada as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NV - Nevada  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NV  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NV  Pound
Admin Super User should be able to remove a Jurisdiction to NV - Nevada with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NV - Nevada with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NV - Nevada with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NV  Pound
Admin Super User should be able to add a new Jurisdiction to NV - Nevada with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NV - Nevada with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NV - Nevada as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NV - Nevada  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NV  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NV  Kilogram
Admin Super User should be able to remove a Jurisdiction to NV - Nevada with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NV - Nevada with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NV - Nevada with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NV  Kilogram

Admin Super User should be able to add a new Jurisdiction to NY - New York with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NY - New York with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NY - New York as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NY - New York  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NY  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   NY  Pound
Admin Super User should be able to remove a Jurisdiction to NY - New York with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NY - New York with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NY - New York with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NY  Pound
Admin Super User should be able to add a new Jurisdiction to NY - New York with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to NY - New York with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NY - New York as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NY - New York  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  NY  Kilogram
Admin Super User should be able to remove a Jurisdiction to NY - New York with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to NY - New York with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NY - New York with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NY  Kilogram

Admin Super User should be able to add a new Jurisdiction to OA - Oaxaca with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OA - Oaxaca with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OA - Oaxaca as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OA - Oaxaca  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   OA  Pound
Admin Super User should be able to remove a Jurisdiction to OA - Oaxaca with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OA - Oaxaca with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OA - Oaxaca with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OA  Pound
Admin Super User should be able to add a new Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OA - Oaxaca as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OA - Oaxaca  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  OA  Kilogram
Admin Super User should be able to remove a Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OA - Oaxaca with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OA - Oaxaca with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OA  Kilogram

Admin Super User should be able to add a new Jurisdiction to OH - Ohio with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OH - Ohio with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OH - Ohio as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OH - Ohio  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OH  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   OH  Pound
Admin Super User should be able to remove a Jurisdiction to OH - Ohio with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OH - Ohio with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OH - Ohio with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OH  Pound
Admin Super User should be able to add a new Jurisdiction to OH - Ohio with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OH - Ohio with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OH - Ohio as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OH - Ohio  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  OH  Kilogram
Admin Super User should be able to remove a Jurisdiction to OH - Ohio with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OH - Ohio with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OH - Ohio with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OH  Kilogram

Admin Super User should be able to add a new Jurisdiction to OK - Oklahoma with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OK - Oklahoma with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OK - Oklahoma as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OK - Oklahoma  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OK  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   OK  Pound
Admin Super User should be able to remove a Jurisdiction to OK - Oklahoma with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OK - Oklahoma with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OK - Oklahoma with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OK  Pound
Admin Super User should be able to add a new Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OK - Oklahoma as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OK - Oklahoma  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OK  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  OK  Kilogram
Admin Super User should be able to remove a Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OK - Oklahoma with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OK - Oklahoma with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OK  Kilogram

Admin Super User should be able to add a new Jurisdiction to ON - Ontario with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ON - Ontario with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ON - Ontario as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ON - Ontario  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ON  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   ON  Pound
Admin Super User should be able to remove a Jurisdiction to ON - Ontario with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ON - Ontario with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ON - Ontario with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ON  Pound
Admin Super User should be able to add a new Jurisdiction to ON - Ontario with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ON - Ontario with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ON - Ontario as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ON - Ontario  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ON  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  ON  Kilogram
Admin Super User should be able to remove a Jurisdiction to ON - Ontario with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ON - Ontario with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ON - Ontario with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ON  Kilogram

Admin Super User should be able to add a new Jurisdiction to OR - Oregon with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OR - Oregon with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OR - Oregon as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OR - Oregon  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OR  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   OR  Pound
Admin Super User should be able to remove a Jurisdiction to OR - Oregon with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OR - Oregon with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OR - Oregon with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OR  Pound
Admin Super User should be able to add a new Jurisdiction to OR - Oregon with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OR - Oregon with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OR - Oregon as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OR - Oregon  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  OR  Kilogram
Admin Super User should be able to remove a Jurisdiction to OR - Oregon with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OR - Oregon with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OR - Oregon with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OR  Kilogram

Admin Super User should be able to add a new Jurisdiction to OT - State Unknown with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OT - State Unknown with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OT - State Unknown as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OT - State Unknown  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OT  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   OT  Pound
Admin Super User should be able to remove a Jurisdiction to OT - State Unknown with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OT - State Unknown with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OT - State Unknown with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OT  Pound
Admin Super User should be able to add a new Jurisdiction to OT - State Unknown with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to OT - State Unknown with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OT - State Unknown as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OT - State Unknown  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  OT  Kilogram
Admin Super User should be able to remove a Jurisdiction to OT - State Unknown with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to OT - State Unknown with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OT - State Unknown with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OT  Kilogram

Admin Super User should be able to add a new Jurisdiction to PA - Pennsylvania with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PA - Pennsylvania with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PA - Pennsylvania as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PA - Pennsylvania  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   PA  Pound
Admin Super User should be able to remove a Jurisdiction to PA - Pennsylvania with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PA - Pennsylvania with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PA - Pennsylvania with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PA  Pound
Admin Super User should be able to add a new Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PA - Pennsylvania as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PA - Pennsylvania  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  PA  Kilogram
Admin Super User should be able to remove a Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PA - Pennsylvania with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PA - Pennsylvania with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PA  Kilogram

Admin Super User should be able to add a new Jurisdiction to PE - Price Edward Island with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PE - Price Edward Island with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PE - Price Edward Island as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PE - Price Edward Island  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PE  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   PE  Pound
Admin Super User should be able to remove a Jurisdiction to PE - Price Edward Island with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PE - Price Edward Island with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PE - Price Edward Island with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PE  Pound
Admin Super User should be able to add a new Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PE - Price Edward Island as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PE - Price Edward Island  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PE  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  PE  Kilogram
Admin Super User should be able to remove a Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PE - Price Edward Island with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PE - Price Edward Island with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PE  Kilogram

Admin Super User should be able to add a new Jurisdiction to PR - Puerto Rico with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PR - Puerto Rico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PR - Puerto Rico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PR - Puerto Rico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PR  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   PR  Pound
Admin Super User should be able to remove a Jurisdiction to PR - Puerto Rico with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PR - Puerto Rico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PR - Puerto Rico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PR  Pound
Admin Super User should be able to add a new Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PR - Puerto Rico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PR - Puerto Rico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  PR  Kilogram
Admin Super User should be able to remove a Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PR - Puerto Rico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PR - Puerto Rico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PR  Kilogram

Admin Super User should be able to add a new Jurisdiction to PU - Puebla with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PU - Puebla with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PU - Puebla as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PU - Puebla  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PU  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   PU  Pound
Admin Super User should be able to remove a Jurisdiction to PU - Puebla with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PU - Puebla with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PU - Puebla with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PU  Pound
Admin Super User should be able to add a new Jurisdiction to PU - Puebla with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to PU - Puebla with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PU - Puebla as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PU - Puebla  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PU  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  PU  Kilogram
Admin Super User should be able to remove a Jurisdiction to PU - Puebla with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to PU - Puebla with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PU - Puebla with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PU  Kilogram

Admin Super User should be able to add a new Jurisdiction to QC - Quebec with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to QC - Quebec with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QC - Quebec as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QC - Quebec  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QC  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   QC  Pound
Admin Super User should be able to remove a Jurisdiction to QC - Quebec with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to QC - Quebec with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QC - Quebec with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QC  Pound
Admin Super User should be able to add a new Jurisdiction to QC - Quebec with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to QC - Quebec with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QC - Quebec as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QC - Quebec  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QC  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  QC  Kilogram
Admin Super User should be able to remove a Jurisdiction to QC - Quebec with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to QC - Quebec with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QC - Quebec with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QC  Kilogram

Admin Super User should be able to add a new Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QR - Quuintana Roo as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QR - Quuintana Roo  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QR  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   QR  Pound
Admin Super User should be able to remove a Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to QR - Quuintana Roo with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QR - Quuintana Roo with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QR  Pound
Admin Super User should be able to add a new Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QR - Quuintana Roo as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QR - Quuintana Roo  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QR  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  QR  Kilogram
Admin Super User should be able to remove a Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to QR - Quuintana Roo with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QR - Quuintana Roo with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QR  Kilogram

Admin Super User should be able to add a new Jurisdiction to QT - Queretaro with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to QT - Queretaro with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QT - Queretaro as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QT - Queretaro  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QT  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   QT  Pound
Admin Super User should be able to remove a Jurisdiction to QT - Queretaro with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to QT - Queretaro with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QT - Queretaro with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QT  Pound
Admin Super User should be able to add a new Jurisdiction to QT - Queretaro with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to QT - Queretaro with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QT - Queretaro as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QT - Queretaro  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  QT  Kilogram
Admin Super User should be able to remove a Jurisdiction to QT - Queretaro with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to QT - Queretaro with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QT - Queretaro with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QT  Kilogram

Admin Super User should be able to add a new Jurisdiction to RI - Rhode Island with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to RI - Rhode Island with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting RI - Rhode Island as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  RI - Rhode Island  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    RI  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   RI  Pound
Admin Super User should be able to remove a Jurisdiction to RI - Rhode Island with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to RI - Rhode Island with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to RI - Rhode Island with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  RI  Pound
Admin Super User should be able to add a new Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting RI - Rhode Island as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  RI - Rhode Island  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  RI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  RI  Kilogram
Admin Super User should be able to remove a Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to RI - Rhode Island with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to RI - Rhode Island with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    RI  Kilogram

Admin Super User should be able to add a new Jurisdiction to SC - South Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SC - South Carolina with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SC - South Carolina as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SC - South Carolina  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SC  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   SC  Pound
Admin Super User should be able to remove a Jurisdiction to SC - South Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SC - South Carolina with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SC - South Carolina with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SC  Pound
Admin Super User should be able to add a new Jurisdiction to SC - South Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SC - South Carolina with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SC - South Carolina as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SC - South Carolina  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  SC  Kilogram
Admin Super User should be able to remove a Jurisdiction to SC - South Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SC - South Carolina with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SC - South Carolina with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SC  Kilogram

Admin Super User should be able to add a new Jurisdiction to SD - South Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SD - South Dakota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SD - South Dakota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SD - South Dakota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SD  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   SD  Pound
Admin Super User should be able to remove a Jurisdiction to SD - South Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SD - South Dakota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SD - South Dakota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SD  Pound
Admin Super User should be able to add a new Jurisdiction to SD - South Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SD - South Dakota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SD - South Dakota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SD - South Dakota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SD  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  SD  Kilogram
Admin Super User should be able to remove a Jurisdiction to SD - South Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SD - South Dakota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SD - South Dakota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SD  Kilogram

Admin Super User should be able to add a new Jurisdiction to SI - Sinaloa with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SI - Sinaloa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SI - Sinaloa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SI - Sinaloa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SI  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   SI  Pound
Admin Super User should be able to remove a Jurisdiction to SI - Sinaloa with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SI - Sinaloa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SI - Sinaloa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SI  Pound
Admin Super User should be able to add a new Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SI - Sinaloa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SI - Sinaloa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SI  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  SI  Kilogram
Admin Super User should be able to remove a Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SI - Sinaloa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SI - Sinaloa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SI  Kilogram

Admin Super User should be able to add a new Jurisdiction to SK - Saskatchewan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SK - Saskatchewan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SK - Saskatchewan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SK - Saskatchewan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SK  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   SK  Pound
Admin Super User should be able to remove a Jurisdiction to SK - Saskatchewan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SK - Saskatchewan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SK - Saskatchewan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SK  Pound
Admin Super User should be able to add a new Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SK - Saskatchewan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SK - Saskatchewan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SK  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  SK  Kilogram
Admin Super User should be able to remove a Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SK - Saskatchewan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SK - Saskatchewan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SK  Kilogram

Admin Super User should be able to add a new Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SL - San Luis Potosi as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SL - San Luis Potosi  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   SL  Pound
Admin Super User should be able to remove a Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SL - San Luis Potosi with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SL - San Luis Potosi with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SL  Pound
Admin Super User should be able to add a new Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SL - San Luis Potosi as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SL - San Luis Potosi  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  SL  Kilogram
Admin Super User should be able to remove a Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SL - San Luis Potosi with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SL - San Luis Potosi with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SL  Kilogram

Admin Super User should be able to add a new Jurisdiction to SO - Sonora with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SO - Sonora with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SO - Sonora as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SO - Sonora  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SO  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   SO  Pound
Admin Super User should be able to remove a Jurisdiction to SO - Sonora with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SO - Sonora with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SO - Sonora with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SO  Pound
Admin Super User should be able to add a new Jurisdiction to SO - Sonora with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to SO - Sonora with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SO - Sonora as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SO - Sonora  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  SO  Kilogram
Admin Super User should be able to remove a Jurisdiction to SO - Sonora with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to SO - Sonora with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SO - Sonora with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SO  Kilogram

Admin Super User should be able to add a new Jurisdiction to TB - Tabasco with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TB - Tabasco with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TB - Tabasco as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TB - Tabasco  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TB  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   TB  Pound
Admin Super User should be able to remove a Jurisdiction to TB - Tabasco with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TB - Tabasco with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TB - Tabasco with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TB  Pound
Admin Super User should be able to add a new Jurisdiction to TB - Tabasco with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TB - Tabasco with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TB - Tabasco as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TB - Tabasco  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TB  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  TB  Kilogram
Admin Super User should be able to remove a Jurisdiction to TB - Tabasco with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TB - Tabasco with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TB - Tabasco with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TB  Kilogram

Admin Super User should be able to add a new Jurisdiction to TL - Tlaxcala with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TL - Tlaxcala with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TL - Tlaxcala as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TL - Tlaxcala  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   TL  Pound
Admin Super User should be able to remove a Jurisdiction to TL - Tlaxcala with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TL - Tlaxcala with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TL - Tlaxcala with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TL  Pound
Admin Super User should be able to add a new Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TL - Tlaxcala as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TL - Tlaxcala  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  TL  Kilogram
Admin Super User should be able to remove a Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TL - Tlaxcala with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TL - Tlaxcala with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TL  Kilogram

Admin Super User should be able to add a new Jurisdiction to TM - Tamaulipas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TM - Tamaulipas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TM - Tamaulipas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TM - Tamaulipas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TM  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   TM  Pound
Admin Super User should be able to remove a Jurisdiction to TM - Tamaulipas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TM - Tamaulipas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TM - Tamaulipas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TM  Pound
Admin Super User should be able to add a new Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TM - Tamaulipas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TM - Tamaulipas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TM  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  TM  Kilogram
Admin Super User should be able to remove a Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TM - Tamaulipas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TM - Tamaulipas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TM  Kilogram

Admin Super User should be able to add a new Jurisdiction to TN - Tennessee with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TN - Tennessee with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TN - Tennessee as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TN - Tennessee  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TN  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   TN  Pound
Admin Super User should be able to remove a Jurisdiction to TN - Tennessee with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TN - Tennessee with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TN - Tennessee with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TN  Pound
Admin Super User should be able to add a new Jurisdiction to TN - Tennessee with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TN - Tennessee with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TN - Tennessee as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TN - Tennessee  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  TN  Kilogram
Admin Super User should be able to remove a Jurisdiction to TN - Tennessee with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TN - Tennessee with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TN - Tennessee with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TN  Kilogram

Admin Super User should be able to add a new Jurisdiction to TX - Texas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TX - Texas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TX - Texas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TX - Texas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TX  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   TX  Pound
Admin Super User should be able to remove a Jurisdiction to TX - Texas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TX - Texas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TX - Texas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TX  Pound
Admin Super User should be able to add a new Jurisdiction to TX - Texas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to TX - Texas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TX - Texas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TX - Texas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TX  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  TX  Kilogram
Admin Super User should be able to remove a Jurisdiction to TX - Texas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to TX - Texas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TX - Texas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TX  Kilogram

Admin Super User should be able to add a new Jurisdiction to UT - Utah with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to UT - Utah with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting UT - Utah as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  UT - Utah  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    UT  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   UT  Pound
Admin Super User should be able to remove a Jurisdiction to UT - Utah with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to UT - Utah with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to UT - Utah with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  UT  Pound
Admin Super User should be able to add a new Jurisdiction to UT - Utah with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to UT - Utah with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting UT - Utah as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  UT - Utah  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  UT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  UT  Kilogram
Admin Super User should be able to remove a Jurisdiction to UT - Utah with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to UT - Utah with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to UT - Utah with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    UT  Kilogram

Admin Super User should be able to add a new Jurisdiction to VA - Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VA - Virginia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VA - Virginia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VA - Virginia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   VA  Pound
Admin Super User should be able to remove a Jurisdiction to VA - Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VA - Virginia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VA - Virginia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VA  Pound
Admin Super User should be able to add a new Jurisdiction to VA - Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VA - Virginia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VA - Virginia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VA - Virginia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  VA  Kilogram
Admin Super User should be able to remove a Jurisdiction to VA - Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VA - Virginia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VA - Virginia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VA  Kilogram

Admin Super User should be able to add a new Jurisdiction to VE - Veracruz with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VE - Veracruz with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VE - Veracruz as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VE - Veracruz  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VE  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   VE  Pound
Admin Super User should be able to remove a Jurisdiction to VE - Veracruz with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VE - Veracruz with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VE - Veracruz with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VE  Pound
Admin Super User should be able to add a new Jurisdiction to VE - Veracruz with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VE - Veracruz with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VE - Veracruz as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VE - Veracruz  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VE  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  VE  Kilogram
Admin Super User should be able to remove a Jurisdiction to VE - Veracruz with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VE - Veracruz with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VE - Veracruz with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VE  Kilogram

Admin Super User should be able to add a new Jurisdiction to VI - Virgin Islands with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VI - Virgin Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VI - Virgin Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VI - Virgin Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VI  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   VI  Pound
Admin Super User should be able to remove a Jurisdiction to VI - Virgin Islands with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VI - Virgin Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VI - Virgin Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VI  Pound
Admin Super User should be able to add a new Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VI - Virgin Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VI - Virgin Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  VI  Kilogram
Admin Super User should be able to remove a Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VI - Virgin Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VI - Virgin Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VI  Kilogram

Admin Super User should be able to add a new Jurisdiction to VT - Vermont with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VT - Vermont with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VT - Vermont as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VT - Vermont  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VT  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   VT  Pound
Admin Super User should be able to remove a Jurisdiction to VT - Vermont with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VT - Vermont with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VT - Vermont with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VT  Pound
Admin Super User should be able to add a new Jurisdiction to VT - Vermont with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to VT - Vermont with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VT - Vermont as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VT - Vermont  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  VT  Kilogram
Admin Super User should be able to remove a Jurisdiction to VT - Vermont with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to VT - Vermont with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VT - Vermont with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VT  Kilogram

Admin Super User should be able to add a new Jurisdiction to WA - Washington with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WA - Washington with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WA - Washington as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WA - Washington  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WA  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   WA  Pound
Admin Super User should be able to remove a Jurisdiction to WA - Washington with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WA - Washington with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WA - Washington with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WA  Pound
Admin Super User should be able to add a new Jurisdiction to WA - Washington with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WA - Washington with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WA - Washington as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WA - Washington  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  WA  Kilogram
Admin Super User should be able to remove a Jurisdiction to WA - Washington with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WA - Washington with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WA - Washington with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WA  Kilogram

Admin Super User should be able to add a new Jurisdiction to WI - Wisconsin with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WI - Wisconsin with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WI - Wisconsin as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WI - Wisconsin  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WI  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   WI  Pound
Admin Super User should be able to remove a Jurisdiction to WI - Wisconsin with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WI - Wisconsin with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WI - Wisconsin with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WI  Pound
Admin Super User should be able to add a new Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WI - Wisconsin as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WI - Wisconsin  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  WI  Kilogram
Admin Super User should be able to remove a Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WI - Wisconsin with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WI - Wisconsin with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WI  Kilogram

Admin Super User should be able to add a new Jurisdiction to WV - West Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WV - West Virginia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WV - West Virginia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WV - West Virginia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WV  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   WV  Pound
Admin Super User should be able to remove a Jurisdiction to WV - West Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WV - West Virginia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WV - West Virginia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WV  Pound
Admin Super User should be able to add a new Jurisdiction to WV - West Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WV - West Virginia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WV - West Virginia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WV - West Virginia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WV  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  WV  Kilogram
Admin Super User should be able to remove a Jurisdiction to WV - West Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WV - West Virginia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WV - West Virginia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WV  Kilogram

Admin Super User should be able to add a new Jurisdiction to WY - Wyoming with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WY - Wyoming with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WY - Wyoming as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WY - Wyoming  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WY  USA  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   WY  Pound
Admin Super User should be able to remove a Jurisdiction to WY - Wyoming with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WY - Wyoming with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WY - Wyoming with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WY  Pound
Admin Super User should be able to add a new Jurisdiction to WY - Wyoming with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to WY - Wyoming with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WY - Wyoming as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WY - Wyoming  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  WY  Kilogram
Admin Super User should be able to remove a Jurisdiction to WY - Wyoming with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to WY - Wyoming with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WY - Wyoming with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WY  Kilogram

Admin Super User should be able to add a new Jurisdiction to YT - Yukon Territory with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to YT - Yukon Territory with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting YT - Yukon Territory as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YT - Yukon Territory  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    YT  CAN  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   YT  Pound
Admin Super User should be able to remove a Jurisdiction to YT - Yukon Territory with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to YT - Yukon Territory with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to YT - Yukon Territory with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  YT  Pound
Admin Super User should be able to add a new Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting YT - Yukon Territory as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YT - Yukon Territory  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  YT  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  YT  Kilogram
Admin Super User should be able to remove a Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to YT - Yukon Territory with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to YT - Yukon Territory with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    YT  Kilogram

Admin Super User should be able to add a new Jurisdiction to YU - Yucatan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to YU - Yucatan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting YU - Yucatan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YU - Yucatan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    YU  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   YU  Pound
Admin Super User should be able to remove a Jurisdiction to YU - Yucatan with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to YU - Yucatan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to YU - Yucatan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  YU  Pound
Admin Super User should be able to add a new Jurisdiction to YU - Yucatan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to YU - Yucatan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting YU - Yucatan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YU - Yucatan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  YU  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  YU  Kilogram
Admin Super User should be able to remove a Jurisdiction to YU - Yucatan with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to YU - Yucatan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to YU - Yucatan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    YU  Kilogram

Admin Super User should be able to add a new Jurisdiction to ZA - Zacatecas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ZA - Zacatecas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ZA - Zacatecas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ZA - Zacatecas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ZA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SuperUserTractor}   ZA  Pound
Admin Super User should be able to remove a Jurisdiction to ZA - Zacatecas with Pound as weight unit
     [Tags]  JIRA:PORT-165  qTest:40106044  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ZA - Zacatecas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ZA - Zacatecas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ZA  Pound
Admin Super User should be able to add a new Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can Add a new Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ZA - Zacatecas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ZA - Zacatecas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ZA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SuperUserTractor}  ZA  Kilogram
Admin Super User should be able to remove a Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     [Tags]  JIRA:PORT-165  qTest:40113043  indepth
     [Documentation]  Validate if an Admin in Super User level can remove Jurisdictions to ZA - Zacatecas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ZA - Zacatecas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ZA  Kilogram

Admin Super User should not be able to add a new Jurisdiction with GVWR value higher than 9999999
     [Tags]  JIRA:PORT-165  qTest:40113560
     [Documentation]  Validate that an Admin in Super User level cannot Add a new Jurisdiction with a value higher than 9999999 in the GVWR field.
     ...  A message should appear saying is not possible to add Jurisdiction with a value higher than 9999999 in the GVWR field
     Set Test Variable  ${gvwr}  10000000
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Pound
     Validate on Screen that Jurisdiction was not added
Admin Super User should not be able to add a new Jurisdiction with the GVWR field empty
     [Tags]  JIRA:PORT-165  qTest:40113703
     [Documentation]  Validate that an Admin in Super User level cannot Add a new Jurisdiction with the GVWR field empty
     ...  A message should appear saying is not possible to add Jurisdiction with empty in the GVWR field
     Set Test Variable  ${gvwr}  ${EMPTY}
     Fill Up Gvwr field and Click on Add Button  VI - Virgin  Pound
     Validate on Screen that Jurisdiction was not added
Admin Super User should not be able to add a new Jurisdiction with the State/Province field empty
     [Tags]  JIRA:PORT-165  qTest:40106044
     [Documentation]  Validate that an Admin in Super User level cannot Add a new Jurisdiction with State/Province field empty
     ...  A message should appear saying is not possible to add Jurisdiction with State/Province field empty
     Fill Up Gvwr field and Click on Add Button  ${EMPTY}  Pound
     Validate on Screen that Jurisdiction was not added
     [Teardown]  Click Driveline Button  Close

Admin Super User should be able to change the tractor status to Inactive
    [Tags]  JIRA:PORT-161  qTest:39893126
    [Documentation]  Validate if an Admin in Super User level can change a tractor status to Inactive
    ...  by Clicking on the Tractor and then clicking on Retire button in Setup - Tractors screen.
    ...  Validate if an Admin in Super User level can find tractors in In-active status
    ...  using the Search tool in Setup - Tractors screen.
    ...  Validate if an Admin in Super User level can see the Tractor identified by the Status
    ...  as I when Inactive in Setup - Tractors screen.
    ...  Validate on Database if active_status column was populates with I.
    Click on Tractor and Then Click on Retire  ${SuperUserTractor}
    Select In-Active Status and Then Click on Search  ${SuperUserTractor}
    Validate on Screen if Tractor Status Was Changed for Inactive  ${SuperUserTractor}
    Validate on Database if Tractor Status Was Changed for Inactive  ${SuperUserTractor}
Admin Super User should be able to change the tractor status to Active
    [Tags]  JIRA:PORT-161  qTest:39893284
    [Documentation]  Validate if an Admin in Super User level can change a tractor status to Active
    ...  by Clicking on the Tractor and then clicking on Activate button in Setup - Tractors screen.
    ...  Validate if an Admin in Super User level can find tractors in Active status
    ...  using the Search tool in Setup - Tractors screen.
    ...  Validate if an Admin in Super User level can see the Tractor identified by the Status
    ...  as A when Inactive in Setup - Tractors screen.
    ...  Validate on Database if active_status column was populates with A.
    Click on Tractor and Then Click Activate  ${SuperUserTractor}
    Select Active Status and Then Click on Search  ${SuperUserTractor}
    Validate on Screen if Tractor Status Was Changed for Active  ${SuperUserTractor}
    Validate on Database if Tractor Status Was Changed for Active  ${SuperUserTractor}

Admin Super User should be able to close the Tractors tab
    [Tags]  JIRA:PORT-161  qTest:39893284
    [Documentation]  Validate if an Admin Super User can close the Tractors tab and do logout
    Right Click on Tractors Tab and Then Close
    [Teardown]  Navigate to My Account and Then Click on Logout

Admin in Support level should be able to create a new tractor
    [Tags]  JIRA:PORT-167  qTest:40009487
    [Documentation]  Validate if an Admin in Super User level with valid credentials can log into Driveline and create a new tractor
    ...  The user should have access to the Setup - Tractors - Add/Edit Tractors section.
    ...  The user should be able to Create a new tractor.
    [Setup]  Input an Admin Support level Credentials and Then Click on Login
    Navigate to Setup - Tractors
    Click on Add Tractor Button
    Fill Up Reference ID Field and Click on Save Button  ${SupportLevelTractor}

Admin Support User should be able to add a new Jurisdiction to AB - Alberta with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AB - Alberta with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AB - Alberta as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     [Setup]  Click on Tractor and Then Click on Jurisdiction  ${SupportLevelTractor}
     Fill Up Gvwr field and Click on Add Button  AB - Alberta  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AB  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   AB  Pound
Admin Support User should be able to remove a Jurisdiction to AB - Alberta with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AB - Alberta with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AB - Alberta with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AB  Pound
Admin Support User should be able to add a new Jurisdiction to AB - Alberta with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AB - Alberta with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AB - Alberta as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AB - Alberta  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  AB  Kilogram
Admin Support User should be able to remove a Jurisdiction to AB - Alberta with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AB - Alberta with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AB - Alberta with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AB  Kilogram

Admin Support User should be able to add a new Jurisdiction to AG - Aguascalientes with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AG - Aguascalientes with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AG - Aguascalientes as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AG - Aguascalientes  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AG  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   AG  Pound
Admin Support User should be able to remove a Jurisdiction to AG - Aguascalientes with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AG - Aguascalientes with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AG - Aguascalientes with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AG  Pound
Admin Support User should be able to add a new Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AG - Aguascalientes as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AG - Aguascalientes  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  AG  Kilogram
Admin Support User should be able to remove a Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AG - Aguascalientes with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AG - Aguascalientes with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AG  Kilogram

Admin Support User should be able to add a new Jurisdiction to AK - Alaska with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AK - Alaska with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AK - Alaska as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AK - Alaska  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AK  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   AK  Pound
Admin Support User should be able to remove a Jurisdiction to AK - Alaska with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AK - Alaska with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AK - Alaska with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AK  Pound
Admin Support User should be able to add a new Jurisdiction to AK - Alaska with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AK - Alaska with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AK - Alaska as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AK - Alaska  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AK  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  AK  Kilogram
Admin Support User should be able to remove a Jurisdiction to AK - Alaska with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AK - Alaska with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AK - Alaska with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AK  Kilogram

Admin Support User should be able to add a new Jurisdiction to AL - Alabama with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AL - Alabama with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AL - Alabama as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AL - Alabama  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AL  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   AL  Pound
Admin Support User should be able to remove a Jurisdiction to AL - Alabama with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AL - Alabama with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AL - Alabama with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AL  Pound
Admin Support User should be able to add a new Jurisdiction to AL - Alabama with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AL - Alabama with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AL - Alabama as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AL - Alabama  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  AL  Kilogram
Admin Support User should be able to remove a Jurisdiction to AL - Alabama with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AL - Alabama with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AL - Alabama with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AL  Kilogram

Admin Support User should be able to add a new Jurisdiction to AR - Arkansas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AR - Arkansas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AR - Arkansas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AR - Arkansas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AR  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   AR  Pound
Admin Support User should be able to remove a Jurisdiction to AR - Arkansas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AR - Arkansas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AR - Arkansas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AR  Pound
Admin Support User should be able to add a new Jurisdiction to AR - Arkansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AR - Arkansas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AR - Arkansas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AR - Arkansas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  AR  Kilogram
Admin Support User should be able to remove a Jurisdiction to AR - Arkansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AR - Arkansas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AR - Arkansas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AR  Kilogram

Admin Support User should be able to add a new Jurisdiction to AS - American Samoa with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AS - American Samoa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AS - American Samoa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AS - American Samoa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AS  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   AS  Pound
Admin Support User should be able to remove a Jurisdiction to AS - American Samoa with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AS - American Samoa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AS - American Samoa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AS  Pound
Admin Support User should be able to add a new Jurisdiction to AS - American Samoa with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AS - American Samoa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AS - American Samoa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AS - American Samoa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  AS  Kilogram
Admin Support User should be able to remove a Jurisdiction to AS - American Samoa with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AS - American Samoa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AS - American Samoa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AS  Kilogram

Admin Support User should be able to add a new Jurisdiction to AZ - Arizona with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AZ - Arizona with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AZ - Arizona as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AZ - Arizona  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AZ  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   AZ  Pound
Admin Support User should be able to remove a Jurisdiction to AZ - Arizona with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AZ - Arizona with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AZ - Arizona with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AZ  Pound
Admin Support User should be able to add a new Jurisdiction to AZ - Arizona with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to AZ - Arizona with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AZ - Arizona as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AZ - Arizona  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AZ  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  AZ  Kilogram
Admin Support User should be able to remove a Jurisdiction to AZ - Arizona with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to AZ - Arizona with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AZ - Arizona with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AZ  Kilogram

Admin Support User should be able to add a new Jurisdiction to BC - Baja California with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BC - Baja California with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BC - Baja California as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - Baja California  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BC  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   BC  Pound
Admin Support User should be able to remove a Jurisdiction to BC - Baja California with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BC - Baja California with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - Baja California with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BC  Pound
Admin Support User should be able to add a new Jurisdiction to BC - Baja California with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BC - Baja California with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BC - Baja California as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - Baja California  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BC  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  BC  Kilogram
Admin Support User should be able to remove a Jurisdiction to BC - Baja California with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BC - Baja California with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - Baja California with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BC  Kilogram

Admin Support User should be able to add a new Jurisdiction to BC - British Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BC - British Columbia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BC - British Columbia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - British Columbia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BC  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   BC  Pound
Admin Support User should be able to remove a Jurisdiction to BC - British Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BC - British Columbia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - British Columbia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BC  Pound
Admin Support User should be able to add a new Jurisdiction to BC - British Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BC - British Columbia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BC - British Columbia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - British Columbia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BC  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  BC  Kilogram
Admin Support User should be able to remove a Jurisdiction to BC - British Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BC - British Columbia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - British Columbia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BC  Kilogram

Admin Support User should be able to add a new Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BN - Baja Caifornia Norte as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BN - Baja Caifornia Norte  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BN  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   BN  Pound
Admin Support User should be able to remove a Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BN - Baja Caifornia Norte with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BN - Baja Caifornia Norte with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BN  Pound
Admin Support User should be able to add a new Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BN - Baja Caifornia Norte as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BN - Baja Caifornia Norte  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BN  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  BN  Kilogram
Admin Support User should be able to remove a Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BN - Baja Caifornia Norte with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BN - Baja Caifornia Norte with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BN  Kilogram

Admin Support User should be able to add a new Jurisdiction to BS - Baja California Sur with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BS - Baja California Sur with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BS - Baja California Sur as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BS - Baja California Sur  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BS  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   BS  Pound
Admin Support User should be able to remove a Jurisdiction to BS - Baja California Sur with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BS - Baja California Sur with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BS - Baja California Sur with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BS  Pound
Admin Support User should be able to add a new Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BS - Baja California Sur as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BS - Baja California Sur  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BS  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  BS  Kilogram
Admin Support User should be able to remove a Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to BS - Baja California Sur with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BS - Baja California Sur with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BS  Kilogram

Admin Support User should be able to add a new Jurisdiction to CA - California with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CA - California with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CA - California as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CA - California  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CA  Pound
Admin Support User should be able to remove a Jurisdiction to CA - California with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CA - California with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CA - California with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CA  Pound
Admin Support User should be able to add a new Jurisdiction to CA - California with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CA - California with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CA - California as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CA - California  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CA  Kilogram
Admin Support User should be able to remove a Jurisdiction to CA - California with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CA - California with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CA - California with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CA  Kilogram

Admin Support User should be able to add a new Jurisdiction to CH - Chihuahua with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CH - Chihuahua with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CH - Chihuahua as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CH - Chihuahua  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CH  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CH  Pound
Admin Support User should be able to remove a Jurisdiction to CH - Chihuahua with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CH - Chihuahua with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CH - Chihuahua with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CH  Pound
Admin Support User should be able to add a new Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CH - Chihuahua as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CH - Chihuahua  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CH  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CH  Kilogram
Admin Support User should be able to remove a Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CH - Chihuahua with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CH - Chihuahua with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CH  Kilogram

Admin Support User should be able to add a new Jurisdiction to CL - Colima with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CL - Colima with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CL - Colima as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CL - Colima  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CL  Pound
Admin Support User should be able to remove a Jurisdiction to CL - Colima with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CL - Colima with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CL - Colima with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CL  Pound
Admin Support User should be able to add a new Jurisdiction to CL - Colima with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CL - Colima with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CL - Colima as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CL - Colima  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CL  Kilogram
Admin Support User should be able to remove a Jurisdiction to CL - Colima with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CL - Colima with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CL - Colima with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CL  Kilogram

Admin Support User should be able to add a new Jurisdiction to CM - Campeche with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CM - Campeche with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CM - Campeche as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CM - Campeche  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CM  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CM  Pound
Admin Support User should be able to remove a Jurisdiction to CM - Campeche with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CM - Campeche with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CM - Campeche with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CM  Pound
Admin Support User should be able to add a new Jurisdiction to CM - Campeche with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CM - Campeche with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CM - Campeche as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CM - Campeche  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CM  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CM  Kilogram
Admin Support User should be able to remove a Jurisdiction to CM - Campeche with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CM - Campeche with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CM - Campeche with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CM  Kilogram

Admin Support User should be able to add a new Jurisdiction to CO - Coahuila with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CO - Coahuila with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CO - Coahuila as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Coahuila  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CO  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CO  Pound
Admin Support User should be able to remove a Jurisdiction to CO - Coahuila with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CO - Coahuila with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Coahuila with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CO  Pound
Admin Support User should be able to add a new Jurisdiction to CO - Coahuila with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CO - Coahuila with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CO - Coahuila as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Coahuila  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CO  Kilogram
Admin Support User should be able to remove a Jurisdiction to CO - Coahuila with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CO - Coahuila with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Coahuila with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CO  Kilogram

Admin Support User should be able to add a new Jurisdiction to CO - Colorado with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CO - Colorado with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CO - Colorado as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Colorado  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CO  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CO  Pound
Admin Support User should be able to remove a Jurisdiction to CO - Colorado with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CO - Colorado with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Colorado with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CO  Pound
Admin Support User should be able to add a new Jurisdiction to CO - Colorado with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CO - Colorado with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CO - Colorado as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Colorado  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CO  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CO  Kilogram
Admin Support User should be able to remove a Jurisdiction to CO - Colorado with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CO - Colorado with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Colorado with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CO  Kilogram

Admin Support User should be able to add a new Jurisdiction to CS - Chiapas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CS - Chiapas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CS - Chiapas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CS - Chiapas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CS  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CS  Pound
Admin Support User should be able to remove a Jurisdiction to CS - Chiapas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CS - Chiapas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CS - Chiapas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CS  Pound
Admin Support User should be able to add a new Jurisdiction to CS - Chiapas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CS - Chiapas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CS - Chiapas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CS - Chiapas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CS  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CS  Kilogram
Admin Support User should be able to remove a Jurisdiction to CS - Chiapas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CS - Chiapas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CS - Chiapas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CS  Kilogram

Admin Support User should be able to add a new Jurisdiction to CT - Connecticut with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CT - Connecticut with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CT - Connecticut as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CT - Connecticut  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CT  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   CT  Pound
Admin Support User should be able to remove a Jurisdiction to CT - Connecticut with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CT - Connecticut with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CT - Connecticut with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CT  Pound
Admin Support User should be able to add a new Jurisdiction to CT - Connecticut with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to CT - Connecticut with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CT - Connecticut as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CT - Connecticut  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  CT  Kilogram
Admin Support User should be able to remove a Jurisdiction to CT - Connecticut with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to CT - Connecticut with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CT - Connecticut with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CT  Kilogram

Admin Support User should be able to add a new Jurisdiction to DC - District of Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DC - District of Columbia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DC - District of Columbia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DC - District of Columbia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DC  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   DC  Pound
Admin Support User should be able to remove a Jurisdiction to DC - District of Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DC - District of Columbia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DC - District of Columbia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DC  Pound
Admin Support User should be able to add a new Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DC - District of Columbia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DC - District of Columbia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  DC  Kilogram
Admin Support User should be able to remove a Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DC - District of Columbia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DC - District of Columbia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DC  Kilogram

Admin Support User should be able to add a new Jurisdiction to DE - Delaware with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DE - Delaware with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DE - Delaware as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DE - Delaware  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DE  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   DE  Pound
Admin Support User should be able to remove a Jurisdiction to DE - Delaware with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DE - Delaware with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DE - Delaware with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DE  Pound
Admin Support User should be able to add a new Jurisdiction to DE - Delaware with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DE - Delaware with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DE - Delaware as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DE - Delaware  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DE  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  DE  Kilogram
Admin Support User should be able to remove a Jurisdiction to DE - Delaware with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DE - Delaware with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DE - Delaware with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DE  Kilogram

Admin Support User should be able to add a new Jurisdiction to DF - Distritio Federal with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DF - Distritio Federal with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DF - Distritio Federal as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DF - Distritio Federal  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DF  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   DF  Pound
Admin Support User should be able to remove a Jurisdiction to DF - Distritio Federal with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DF - Distritio Federal with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DF - Distritio Federal with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DF  Pound
Admin Support User should be able to add a new Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DF - Distritio Federal as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DF - Distritio Federal  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DF  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  DF  Kilogram
Admin Support User should be able to remove a Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DF - Distritio Federal with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DF - Distritio Federal with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DF  Kilogram

Admin Support User should be able to add a new Jurisdiction to DG - Durango with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DG - Durango with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DG - Durango as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DG  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   DG  Pound
Admin Support User should be able to remove a Jurisdiction to DG - Durango with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DG - Durango with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DG - Durango with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DG  Pound
Admin Support User should be able to add a new Jurisdiction to DG - Durango with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to DG - Durango with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DG - Durango as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  DG  Kilogram
Admin Support User should be able to remove a Jurisdiction to DG - Durango with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to DG - Durango with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DG - Durango with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DG  Kilogram

Admin Support User should be able to add a new Jurisdiction to FL - Florida with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to FL - Florida with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting FL - Florida as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FL - Florida  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    FL  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   FL  Pound
Admin Support User should be able to remove a Jurisdiction to FL - Florida with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to FL - Florida with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to FL - Florida with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  FL  Pound
Admin Support User should be able to add a new Jurisdiction to FL - Florida with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to FL - Florida with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting FL - Florida as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FL - Florida  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  FL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  FL  Kilogram
Admin Support User should be able to remove a Jurisdiction to FL - Florida with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to FL - Florida with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to FL - Florida with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    FL  Kilogram

Admin Support User should be able to add a new Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting FM - Federated States of Micronesia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FM - Federated States of Micronesia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    FM  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   FM  Pound
Admin Support User should be able to remove a Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to FM - Federated States of Micronesia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to FM - Federated States of Micronesia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  FM  Pound
Admin Support User should be able to add a new Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting FM - Federated States of Micronesia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FM - Federated States of Micronesia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  FM  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  FM  Kilogram
Admin Support User should be able to remove a Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to FM - Federated States of Micronesia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to FM - Federated States of Micronesia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    FM  Kilogram

Admin Support User should be able to add a new Jurisdiction to GA - Georgia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GA - Georgia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GA - Georgia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GA - Georgia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   GA  Pound
Admin Support User should be able to remove a Jurisdiction to GA - Georgia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GA - Georgia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GA - Georgia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GA  Pound
Admin Support User should be able to add a new Jurisdiction to GA - Georgia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GA - Georgia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GA - Georgia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GA - Georgia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  GA  Kilogram
Admin Support User should be able to remove a Jurisdiction to GA - Georgia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GA - Georgia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GA - Georgia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GA  Kilogram

Admin Support User should be able to add a new Jurisdiction to GR - Guerrero with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GR - Guerrero with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GR - Guerrero as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GR - Guerrero  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GR  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   GR  Pound
Admin Support User should be able to remove a Jurisdiction to GR - Guerrero with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GR - Guerrero with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GR - Guerrero with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GR  Pound
Admin Support User should be able to add a new Jurisdiction to GR - Guerrero with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GR - Guerrero with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GR - Guerrero as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GR - Guerrero  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GR  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  GR  Kilogram
Admin Support User should be able to remove a Jurisdiction to GR - Guerrero with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GR - Guerrero with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GR - Guerrero with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GR  Kilogram

Admin Support User should be able to add a new Jurisdiction to GT - Guanajuato with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GT - Guanajuato with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GT - Guanajuato as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GT - Guanajuato  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GT  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   GT  Pound
Admin Support User should be able to remove a Jurisdiction to GT - Guanajuato with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GT - Guanajuato with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GT - Guanajuato with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GT  Pound
Admin Support User should be able to add a new Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GT - Guanajuato as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GT - Guanajuato  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  GT  Kilogram
Admin Support User should be able to remove a Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GT - Guanajuato with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GT - Guanajuato with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GT  Kilogram

Admin Support User should be able to add a new Jurisdiction to GU - Guam with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GU - Guam with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GU - Guam as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GU - Guam  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GU  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   GU  Pound
Admin Support User should be able to remove a Jurisdiction to GU - Guam with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GU - Guam with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GU - Guam with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GU  Pound
Admin Support User should be able to add a new Jurisdiction to GU - Guam with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to GU - Guam with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GU - Guam as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GU - Guam  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GU  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  GU  Kilogram
Admin Support User should be able to remove a Jurisdiction to GU - Guam with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to GU - Guam with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GU - Guam with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GU  Kilogram

Admin Support User should be able to add a new Jurisdiction to HG - Hidalgo with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to HG - Hidalgo with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting HG - Hidalgo as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HG - Hidalgo  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    HG  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   HG  Pound
Admin Support User should be able to remove a Jurisdiction to HG - Hidalgo with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to HG - Hidalgo with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to HG - Hidalgo with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  HG  Pound
Admin Support User should be able to add a new Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting HG - Hidalgo as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HG - Hidalgo  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  HG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  HG  Kilogram
Admin Support User should be able to remove a Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to HG - Hidalgo with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to HG - Hidalgo with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    HG  Kilogram

Admin Support User should be able to add a new Jurisdiction to HI - Hawaii with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to HI - Hawaii with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting HI - Hawaii as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HI - Hawaii  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    HI  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   HI  Pound
Admin Support User should be able to remove a Jurisdiction to HI - Hawaii with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to HI - Hawaii with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to HI - Hawaii with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  HI  Pound
Admin Support User should be able to add a new Jurisdiction to HI - Hawaii with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to HI - Hawaii with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting HI - Hawaii as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HI - Hawaii  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  HI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  HI  Kilogram
Admin Support User should be able to remove a Jurisdiction to HI - Hawaii with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to HI - Hawaii with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to HI - Hawaii with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    HI  Kilogram

Admin Support User should be able to add a new Jurisdiction to IA - Iowa with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to IA - Iowa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IA - Iowa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IA - Iowa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   IA  Pound
Admin Support User should be able to remove a Jurisdiction to IA - Iowa with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to IA - Iowa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IA - Iowa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IA  Pound
Admin Support User should be able to add a new Jurisdiction to IA - Iowa with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to IA - Iowa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IA - Iowa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IA - Iowa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  IA  Kilogram
Admin Support User should be able to remove a Jurisdiction to IA - Iowa with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to IA - Iowa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IA - Iowa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IA  Kilogram

Admin Support User should be able to add a new Jurisdiction to ID - Idaho with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ID - Idaho with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ID - Idaho as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ID - Idaho  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ID  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   ID  Pound
Admin Support User should be able to remove a Jurisdiction to ID - Idaho with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ID - Idaho with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ID - Idaho with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ID  Pound
Admin Support User should be able to add a new Jurisdiction to ID - Idaho with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ID - Idaho with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ID - Idaho as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ID - Idaho  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ID  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  ID  Kilogram
Admin Support User should be able to remove a Jurisdiction to ID - Idaho with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ID - Idaho with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ID - Idaho with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ID  Kilogram

Admin Support User should be able to add a new Jurisdiction to IL - Illinois with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to IL - Illinois with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IL - Illinois as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IL - Illinois  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IL  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   IL  Pound
Admin Support User should be able to remove a Jurisdiction to IL - Illinois with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to IL - Illinois with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IL - Illinois with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IL  Pound
Admin Support User should be able to add a new Jurisdiction to IL - Illinois with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to IL - Illinois with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IL - Illinois as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IL - Illinois  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  IL  Kilogram
Admin Support User should be able to remove a Jurisdiction to IL - Illinois with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to IL - Illinois with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IL - Illinois with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IL  Kilogram

Admin Support User should be able to add a new Jurisdiction to IN - Indiana with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to IN - Indiana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IN - Indiana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IN - Indiana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IN  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   IN  Pound
Admin Support User should be able to remove a Jurisdiction to IN - Indiana with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to IN - Indiana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IN - Indiana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IN  Pound
Admin Support User should be able to add a new Jurisdiction to IN - Indiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to IN - Indiana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IN - Indiana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IN - Indiana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  IN  Kilogram
Admin Support User should be able to remove a Jurisdiction to IN - Indiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to IN - Indiana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IN - Indiana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IN  Kilogram

Admin Support User should be able to add a new Jurisdiction to JA - Jalisco with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to JA - Jalisco with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting JA - Jalisco as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  JA - Jalisco  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    JA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   JA  Pound
Admin Support User should be able to remove a Jurisdiction to JA - Jalisco with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to JA - Jalisco with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to JA - Jalisco with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  JA  Pound
Admin Support User should be able to add a new Jurisdiction to JA - Jalisco with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to JA - Jalisco with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting JA - Jalisco as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  JA - Jalisco  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  JA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  JA  Kilogram
Admin Support User should be able to remove a Jurisdiction to JA - Jalisco with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to JA - Jalisco with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to JA - Jalisco with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    JA  Kilogram

Admin Support User should be able to add a new Jurisdiction to KS - Kansas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to KS - Kansas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting KS - Kansas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KS - Kansas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    KS  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   KS  Pound
Admin Support User should be able to remove a Jurisdiction to KS - Kansas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to KS - Kansas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to KS - Kansas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  KS  Pound
Admin Support User should be able to add a new Jurisdiction to KS - Kansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to KS - Kansas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting KS - Kansas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KS - Kansas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  KS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  KS  Kilogram
Admin Support User should be able to remove a Jurisdiction to KS - Kansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to KS - Kansas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to KS - Kansas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    KS  Kilogram

Admin Support User should be able to add a new Jurisdiction to KY - Kentucky with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to KY - Kentucky with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting KY - Kentucky as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KY - Kentucky  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    KY  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   KY  Pound
Admin Support User should be able to remove a Jurisdiction to KY - Kentucky with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to KY - Kentucky with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to KY - Kentucky with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  KY  Pound
Admin Support User should be able to add a new Jurisdiction to KY - Kentucky with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to KY - Kentucky with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting KY - Kentucky as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KY - Kentucky  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  KY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  KY  Kilogram
Admin Support User should be able to remove a Jurisdiction to KY - Kentucky with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to KY - Kentucky with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to KY - Kentucky with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    KY  Kilogram

Admin Support User should be able to add a new Jurisdiction to LA - Louisiana with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to LA - Louisiana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting LA - Louisiana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  LA - Louisiana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    LA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   LA  Pound
Admin Support User should be able to remove a Jurisdiction to LA - Louisiana with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to LA - Louisiana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to LA - Louisiana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  LA  Pound
Admin Support User should be able to add a new Jurisdiction to LA - Louisiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to LA - Louisiana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting LA - Louisiana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  LA - Louisiana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  LA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  LA  Kilogram
Admin Support User should be able to remove a Jurisdiction to LA - Louisiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to LA - Louisiana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to LA - Louisiana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    LA  Kilogram

Admin Support User should be able to add a new Jurisdiction to MA - Massachusetts with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MA - Massachusetts with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MA - Massachusetts as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MA - Massachusetts  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MA  Pound
Admin Support User should be able to remove a Jurisdiction to MA - Massachusetts with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MA - Massachusetts with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MA - Massachusetts with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MA  Pound
Admin Support User should be able to add a new Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MA - Massachusetts as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MA - Massachusetts  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MA  Kilogram
Admin Support User should be able to remove a Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MA - Massachusetts with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MA - Massachusetts with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MA  Kilogram

Admin Support User should be able to add a new Jurisdiction to MB - Manitoba with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MB - Manitoba with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MB - Manitoba as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MB - Manitoba  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MB  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MB  Pound
Admin Support User should be able to remove a Jurisdiction to MB - Manitoba with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MB - Manitoba with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MB - Manitoba with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MB  Pound
Admin Support User should be able to add a new Jurisdiction to MB - Manitoba with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MB - Manitoba with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MB - Manitoba as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MB - Manitoba  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MB  Kilogram
Admin Support User should be able to remove a Jurisdiction to MB - Manitoba with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MB - Manitoba with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MB - Manitoba with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MB  Kilogram

Admin Support User should be able to add a new Jurisdiction to MD - Maryland with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MD - Maryland with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MD - Maryland as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MD - Maryland  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MD  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MD  Pound
Admin Support User should be able to remove a Jurisdiction to MD - Maryland with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MD - Maryland with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MD - Maryland with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MD  Pound
Admin Support User should be able to add a new Jurisdiction to MD - Maryland with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MD - Maryland with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MD - Maryland as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MD - Maryland  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MD  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MD  Kilogram
Admin Support User should be able to remove a Jurisdiction to MD - Maryland with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MD - Maryland with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MD - Maryland with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MD  Kilogram

Admin Support User should be able to add a new Jurisdiction to ME - Maine with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ME - Maine with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ME - Maine as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ME - Maine  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ME  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   ME  Pound
Admin Support User should be able to remove a Jurisdiction to ME - Maine with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ME - Maine with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ME - Maine with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ME  Pound
Admin Support User should be able to add a new Jurisdiction to ME - Maine with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ME - Maine with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ME - Maine as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ME - Maine  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ME  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  ME  Kilogram
Admin Support User should be able to remove a Jurisdiction to ME - Maine with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ME - Maine with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ME - Maine with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ME  Kilogram

Admin Support User should be able to add a new Jurisdiction to MH - Marshall Islands with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MH - Marshall Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MH - Marshall Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MH - Marshall Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MH  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MH  Pound
Admin Support User should be able to remove a Jurisdiction to MH - Marshall Islands with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MH - Marshall Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MH - Marshall Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MH  Pound
Admin Support User should be able to add a new Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MH - Marshall Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MH - Marshall Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MH  Kilogram
Admin Support User should be able to remove a Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MH - Marshall Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MH - Marshall Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MH  Kilogram

Admin Support User should be able to add a new Jurisdiction to MI - Michigan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MI - Michigan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michigan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michigan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MI  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MI  Pound
Admin Support User should be able to remove a Jurisdiction to MI - Michigan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MI - Michigan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michigan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MI  Pound
Admin Support User should be able to add a new Jurisdiction to MI - Michigan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MI - Michigan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michigan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michigan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MI  Kilogram
Admin Support User should be able to remove a Jurisdiction to MI - Michigan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MI - Michigan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michigan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MI  Kilogram

Admin Support User should be able to add a new Jurisdiction to MI - Michoacan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MI - Michoacan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michoacan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michoacan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MI  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MI  Pound
Admin Support User should be able to remove a Jurisdiction to MI - Michoacan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MI - Michoacan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michoacan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MI  Pound
Admin Support User should be able to add a new Jurisdiction to MI - Michoacan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MI - Michoacan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michoacan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michoacan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MI  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MI  Kilogram
Admin Support User should be able to remove a Jurisdiction to MI - Michoacan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MI - Michoacan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michoacan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MI  Kilogram

Admin Support User should be able to add a new Jurisdiction to MN - Minnesota with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MN - Minnesota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MN - Minnesota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MN - Minnesota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MN  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MN  Pound
Admin Support User should be able to remove a Jurisdiction to MN - Minnesota with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MN - Minnesota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MN - Minnesota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MN  Pound
Admin Support User should be able to add a new Jurisdiction to MN - Minnesota with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MN - Minnesota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MN - Minnesota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MN - Minnesota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MN  Kilogram
Admin Support User should be able to remove a Jurisdiction to MN - Minnesota with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MN - Minnesota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MN - Minnesota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MN  Kilogram

Admin Support User should be able to add a new Jurisdiction to MO - Missouri with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MO - Missouri with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MO - Missouri as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Missouri  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MO  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MO  Pound
Admin Support User should be able to remove a Jurisdiction to MO - Missouri with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MO - Missouri with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Missouri with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MO  Pound
Admin Support User should be able to add a new Jurisdiction to MO - Missouri with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MO - Missouri with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MO - Missouri as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Missouri  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MO  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MO  Kilogram
Admin Support User should be able to remove a Jurisdiction to MO - Missouri with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MO - Missouri with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Missouri with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MO  Kilogram

Admin Support User should be able to add a new Jurisdiction to MO - Morelos with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MO - Morelos with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MO - Morelos as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Morelos  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MO  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MO  Pound
Admin Support User should be able to remove a Jurisdiction to MO - Morelos with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MO - Morelos with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Morelos with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MO  Pound
Admin Support User should be able to add a new Jurisdiction to MO - Morelos with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MO - Morelos with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MO - Morelos as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Morelos  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MO  Kilogram
Admin Support User should be able to remove a Jurisdiction to MO - Morelos with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MO - Morelos with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Morelos with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MO  Kilogram

Admin Support User should be able to add a new Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MP - Northern Mariana Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MP - Northern Mariana Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MP  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MP  Pound
Admin Support User should be able to remove a Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MP - Northern Mariana Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MP - Northern Mariana Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MP  Pound
Admin Support User should be able to add a new Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MP - Northern Mariana Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MP - Northern Mariana Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MP  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MP  Kilogram
Admin Support User should be able to remove a Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MP - Northern Mariana Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MP - Northern Mariana Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MP  Kilogram

Admin Support User should be able to add a new Jurisdiction to MS - Mississippi with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MS - Mississippi with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MS - Mississippi as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MS - Mississippi  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MS  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MS  Pound
Admin Support User should be able to remove a Jurisdiction to MS - Mississippi with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MS - Mississippi with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MS - Mississippi with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MS  Pound
Admin Support User should be able to add a new Jurisdiction to MS - Mississippi with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MS - Mississippi with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MS - Mississippi as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MS - Mississippi  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MS  Kilogram
Admin Support User should be able to remove a Jurisdiction to MS - Mississippi with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MS - Mississippi with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MS - Mississippi with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MS  Kilogram

Admin Support User should be able to add a new Jurisdiction to MT - Montana with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MT - Montana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MT - Montana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MT - Montana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MT  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MT  Pound
Admin Support User should be able to remove a Jurisdiction to MT - Montana with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MT - Montana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MT - Montana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MT  Pound
Admin Support User should be able to add a new Jurisdiction to MT - Montana with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MT - Montana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MT - Montana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MT - Montana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MT  Kilogram
Admin Support User should be able to remove a Jurisdiction to MT - Montana with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MT - Montana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MT - Montana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MT  Kilogram

Admin Support User should be able to add a new Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MX - Edo. Mexico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MX - Edo. Mexico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MX  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   MX  Pound
Admin Support User should be able to remove a Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MX - Edo. Mexico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MX - Edo. Mexico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MX  Pound
Admin Support User should be able to add a new Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MX - Edo. Mexico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MX - Edo. Mexico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MX  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  MX  Kilogram
Admin Support User should be able to remove a Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to MX - Edo. Mexico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MX - Edo. Mexico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MX  Kilogram

Admin Support User should be able to add a new Jurisdiction to NA - Nayarit with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NA - Nayarit with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NA - Nayarit as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NA - Nayarit  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NA  Pound
Admin Support User should be able to remove a Jurisdiction to NA - Nayarit with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NA - Nayarit with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NA - Nayarit with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NA  Pound
Admin Support User should be able to add a new Jurisdiction to NA - Nayarit with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NA - Nayarit with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NA - Nayarit as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NA - Nayarit  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NA  Kilogram
Admin Support User should be able to remove a Jurisdiction to NA - Nayarit with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NA - Nayarit with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NA - Nayarit with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NA  Kilogram

Admin Support User should be able to add a new Jurisdiction to NB - New Brunswick with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NB - New Brunswick with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NB - New Brunswick as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NB - New Brunswick  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NB  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NB  Pound
Admin Support User should be able to remove a Jurisdiction to NB - New Brunswick with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NB - New Brunswick with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NB - New Brunswick with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NB  Pound
Admin Support User should be able to add a new Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NB - New Brunswick as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NB - New Brunswick  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NB  Kilogram
Admin Support User should be able to remove a Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NB - New Brunswick with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NB - New Brunswick with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NB  Kilogram

Admin Support User should be able to add a new Jurisdiction to NC - North Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NC - North Carolina with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NC - North Carolina as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NC - North Carolina  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NC  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NC  Pound
Admin Support User should be able to remove a Jurisdiction to NC - North Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NC - North Carolina with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NC - North Carolina with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NC  Pound
Admin Support User should be able to add a new Jurisdiction to NC - North Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NC - North Carolina with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NC - North Carolina as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NC - North Carolina  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NC  Kilogram
Admin Support User should be able to remove a Jurisdiction to NC - North Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NC - North Carolina with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NC - North Carolina with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NC  Kilogram

Admin Support User should be able to add a new Jurisdiction to ND - North Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ND - North Dakota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ND - North Dakota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ND - North Dakota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ND  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   ND  Pound
Admin Support User should be able to remove a Jurisdiction to ND - North Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ND - North Dakota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ND - North Dakota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ND  Pound
Admin Support User should be able to add a new Jurisdiction to ND - North Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ND - North Dakota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ND - North Dakota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ND - North Dakota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ND  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  ND  Kilogram
Admin Support User should be able to remove a Jurisdiction to ND - North Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ND - North Dakota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ND - North Dakota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ND  Kilogram

Admin Support User should be able to add a new Jurisdiction to NE - Nebraska with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NE - Nebraska with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NE - Nebraska as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NE - Nebraska  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NE  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NE  Pound
Admin Support User should be able to remove a Jurisdiction to NE - Nebraska with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NE - Nebraska with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NE - Nebraska with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NE  Pound
Admin Support User should be able to add a new Jurisdiction to NE - Nebraska with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NE - Nebraska with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NE - Nebraska as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NE - Nebraska  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NE  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NE  Kilogram
Admin Support User should be able to remove a Jurisdiction to NE - Nebraska with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NE - Nebraska with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NE - Nebraska with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NE  Kilogram

Admin Support User should be able to add a new Jurisdiction to NH - New Hampshire with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NH - New Hampshire with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NH - New Hampshire as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NH - New Hampshire  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NH  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NH  Pound
Admin Support User should be able to remove a Jurisdiction to NH - New Hampshire with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NH - New Hampshire with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NH - New Hampshire with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NH  Pound
Admin Support User should be able to add a new Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NH - New Hampshire as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NH - New Hampshire  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NH  Kilogram
Admin Support User should be able to remove a Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NH - New Hampshire with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NH - New Hampshire with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NH  Kilogram

Admin Support User should be able to add a new Jurisdiction to NJ - New Jersey with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NJ - New Jersey with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NJ - New Jersey as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NJ - New Jersey  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NJ  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NJ  Pound
Admin Support User should be able to remove a Jurisdiction to NJ - New Jersey with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NJ - New Jersey with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NJ - New Jersey with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NJ  Pound
Admin Support User should be able to add a new Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NJ - New Jersey as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NJ - New Jersey  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NJ  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NJ  Kilogram
Admin Support User should be able to remove a Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NJ - New Jersey with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NJ - New Jersey with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NJ  Kilogram

Admin Support User should be able to add a new Jurisdiction to NL - Newfoundland with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NL - Newfoundland with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NL - Newfoundland as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Newfoundland  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NL  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NL  Pound
Admin Support User should be able to remove a Jurisdiction to NL - Newfoundland with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NL - Newfoundland with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Newfoundland with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NL  Pound
Admin Support User should be able to add a new Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NL - Newfoundland as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Newfoundland  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NL  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NL  Kilogram
Admin Support User should be able to remove a Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NL - Newfoundland with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Newfoundland with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NL  Kilogram

Admin Support User should be able to add a new Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NL - Nuevo Leon as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Nuevo Leon  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NL  Pound
Admin Support User should be able to remove a Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NL - Nuevo Leon with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Nuevo Leon with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NL  Pound
Admin Support User should be able to add a new Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NL - Nuevo Leon as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Nuevo Leon  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NL  Kilogram
Admin Support User should be able to remove a Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NL - Nuevo Leon with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Nuevo Leon with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NL  Kilogram

Admin Support User should be able to add a new Jurisdiction to NM - New Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NM - New Mexico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NM - New Mexico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NM - New Mexico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NM  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NM  Pound
Admin Support User should be able to remove a Jurisdiction to NM - New Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NM - New Mexico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NM - New Mexico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NM  Pound
Admin Support User should be able to add a new Jurisdiction to NM - New Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NM - New Mexico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NM - New Mexico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NM - New Mexico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NM  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NM  Kilogram
Admin Support User should be able to remove a Jurisdiction to NM - New Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NM - New Mexico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NM - New Mexico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NM  Kilogram

Admin Support User should be able to add a new Jurisdiction to NS - Nova Scotia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NS - Nova Scotia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NS - Nova Scotia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NS - Nova Scotia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NS  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NS  Pound
Admin Support User should be able to remove a Jurisdiction to NS - Nova Scotia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NS - Nova Scotia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NS - Nova Scotia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NS  Pound
Admin Support User should be able to add a new Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NS - Nova Scotia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NS - Nova Scotia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NS  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NS  Kilogram
Admin Support User should be able to remove a Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NS - Nova Scotia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NS - Nova Scotia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NS  Kilogram

Admin Support User should be able to add a new Jurisdiction to NT - Northwest Territories with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NT - Northwest Territories with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NT - Northwest Territories as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NT - Northwest Territories  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NT  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NT  Pound
Admin Support User should be able to remove a Jurisdiction to NT - Northwest Territories with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NT - Northwest Territories with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NT - Northwest Territories with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NT  Pound
Admin Support User should be able to add a new Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NT - Northwest Territories as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NT - Northwest Territories  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NT  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NT  Kilogram
Admin Support User should be able to remove a Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NT - Northwest Territories with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NT - Northwest Territories with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NT  Kilogram

Admin Support User should be able to add a new Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NU - Nunavut Territory as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NU - Nunavut Territory  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NU  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NU  Pound
Admin Support User should be able to remove a Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NU - Nunavut Territory with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NU - Nunavut Territory with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NU  Pound
Admin Support User should be able to add a new Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NU - Nunavut Territory as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NU - Nunavut Territory  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NU  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NU  Kilogram
Admin Support User should be able to remove a Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NU - Nunavut Territory with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NU - Nunavut Territory with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NU  Kilogram

Admin Support User should be able to add a new Jurisdiction to NV - Nevada with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NV - Nevada with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NV - Nevada as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NV - Nevada  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NV  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NV  Pound
Admin Support User should be able to remove a Jurisdiction to NV - Nevada with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NV - Nevada with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NV - Nevada with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NV  Pound
Admin Support User should be able to add a new Jurisdiction to NV - Nevada with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NV - Nevada with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NV - Nevada as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NV - Nevada  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NV  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NV  Kilogram
Admin Support User should be able to remove a Jurisdiction to NV - Nevada with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NV - Nevada with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NV - Nevada with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NV  Kilogram

Admin Support User should be able to add a new Jurisdiction to NY - New York with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NY - New York with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NY - New York as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NY - New York  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NY  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   NY  Pound
Admin Support User should be able to remove a Jurisdiction to NY - New York with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NY - New York with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NY - New York with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NY  Pound
Admin Support User should be able to add a new Jurisdiction to NY - New York with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to NY - New York with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NY - New York as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NY - New York  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  NY  Kilogram
Admin Support User should be able to remove a Jurisdiction to NY - New York with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to NY - New York with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NY - New York with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NY  Kilogram

Admin Support User should be able to add a new Jurisdiction to OA - Oaxaca with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OA - Oaxaca with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OA - Oaxaca as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OA - Oaxaca  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   OA  Pound
Admin Support User should be able to remove a Jurisdiction to OA - Oaxaca with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OA - Oaxaca with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OA - Oaxaca with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OA  Pound
Admin Support User should be able to add a new Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OA - Oaxaca as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OA - Oaxaca  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  OA  Kilogram
Admin Support User should be able to remove a Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OA - Oaxaca with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OA - Oaxaca with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OA  Kilogram

Admin Support User should be able to add a new Jurisdiction to OH - Ohio with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OH - Ohio with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OH - Ohio as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OH - Ohio  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OH  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   OH  Pound
Admin Support User should be able to remove a Jurisdiction to OH - Ohio with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OH - Ohio with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OH - Ohio with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OH  Pound
Admin Support User should be able to add a new Jurisdiction to OH - Ohio with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OH - Ohio with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OH - Ohio as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OH - Ohio  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  OH  Kilogram
Admin Support User should be able to remove a Jurisdiction to OH - Ohio with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OH - Ohio with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OH - Ohio with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OH  Kilogram

Admin Support User should be able to add a new Jurisdiction to OK - Oklahoma with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OK - Oklahoma with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OK - Oklahoma as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OK - Oklahoma  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OK  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   OK  Pound
Admin Support User should be able to remove a Jurisdiction to OK - Oklahoma with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OK - Oklahoma with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OK - Oklahoma with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OK  Pound
Admin Support User should be able to add a new Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OK - Oklahoma as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OK - Oklahoma  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OK  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  OK  Kilogram
Admin Support User should be able to remove a Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OK - Oklahoma with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OK - Oklahoma with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OK  Kilogram

Admin Support User should be able to add a new Jurisdiction to ON - Ontario with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ON - Ontario with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ON - Ontario as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ON - Ontario  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ON  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   ON  Pound
Admin Support User should be able to remove a Jurisdiction to ON - Ontario with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ON - Ontario with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ON - Ontario with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ON  Pound
Admin Support User should be able to add a new Jurisdiction to ON - Ontario with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ON - Ontario with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ON - Ontario as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ON - Ontario  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ON  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  ON  Kilogram
Admin Support User should be able to remove a Jurisdiction to ON - Ontario with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ON - Ontario with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ON - Ontario with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ON  Kilogram

Admin Support User should be able to add a new Jurisdiction to OR - Oregon with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OR - Oregon with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OR - Oregon as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OR - Oregon  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OR  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   OR  Pound
Admin Support User should be able to remove a Jurisdiction to OR - Oregon with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OR - Oregon with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OR - Oregon with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OR  Pound
Admin Support User should be able to add a new Jurisdiction to OR - Oregon with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OR - Oregon with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OR - Oregon as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OR - Oregon  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  OR  Kilogram
Admin Support User should be able to remove a Jurisdiction to OR - Oregon with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OR - Oregon with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OR - Oregon with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OR  Kilogram

Admin Support User should be able to add a new Jurisdiction to OT - State Unknown with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OT - State Unknown with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OT - State Unknown as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OT - State Unknown  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OT  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   OT  Pound
Admin Support User should be able to remove a Jurisdiction to OT - State Unknown with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OT - State Unknown with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OT - State Unknown with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OT  Pound
Admin Support User should be able to add a new Jurisdiction to OT - State Unknown with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to OT - State Unknown with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OT - State Unknown as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OT - State Unknown  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  OT  Kilogram
Admin Support User should be able to remove a Jurisdiction to OT - State Unknown with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to OT - State Unknown with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OT - State Unknown with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OT  Kilogram

Admin Support User should be able to add a new Jurisdiction to PA - Pennsylvania with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PA - Pennsylvania with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PA - Pennsylvania as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PA - Pennsylvania  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   PA  Pound
Admin Support User should be able to remove a Jurisdiction to PA - Pennsylvania with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PA - Pennsylvania with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PA - Pennsylvania with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PA  Pound
Admin Support User should be able to add a new Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PA - Pennsylvania as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PA - Pennsylvania  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  PA  Kilogram
Admin Support User should be able to remove a Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PA - Pennsylvania with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PA - Pennsylvania with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PA  Kilogram

Admin Support User should be able to add a new Jurisdiction to PE - Price Edward Island with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PE - Price Edward Island with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PE - Price Edward Island as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PE - Price Edward Island  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PE  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   PE  Pound
Admin Support User should be able to remove a Jurisdiction to PE - Price Edward Island with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PE - Price Edward Island with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PE - Price Edward Island with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PE  Pound
Admin Support User should be able to add a new Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PE - Price Edward Island as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PE - Price Edward Island  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PE  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  PE  Kilogram
Admin Support User should be able to remove a Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PE - Price Edward Island with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PE - Price Edward Island with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PE  Kilogram

Admin Support User should be able to add a new Jurisdiction to PR - Puerto Rico with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PR - Puerto Rico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PR - Puerto Rico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PR - Puerto Rico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PR  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   PR  Pound
Admin Support User should be able to remove a Jurisdiction to PR - Puerto Rico with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PR - Puerto Rico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PR - Puerto Rico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PR  Pound
Admin Support User should be able to add a new Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PR - Puerto Rico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PR - Puerto Rico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  PR  Kilogram
Admin Support User should be able to remove a Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PR - Puerto Rico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PR - Puerto Rico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PR  Kilogram

Admin Support User should be able to add a new Jurisdiction to PU - Puebla with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PU - Puebla with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PU - Puebla as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PU - Puebla  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PU  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   PU  Pound
Admin Support User should be able to remove a Jurisdiction to PU - Puebla with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PU - Puebla with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PU - Puebla with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PU  Pound
Admin Support User should be able to add a new Jurisdiction to PU - Puebla with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to PU - Puebla with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PU - Puebla as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PU - Puebla  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PU  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  PU  Kilogram
Admin Support User should be able to remove a Jurisdiction to PU - Puebla with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to PU - Puebla with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PU - Puebla with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PU  Kilogram

Admin Support User should be able to add a new Jurisdiction to QC - Quebec with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to QC - Quebec with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QC - Quebec as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QC - Quebec  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QC  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   QC  Pound
Admin Support User should be able to remove a Jurisdiction to QC - Quebec with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to QC - Quebec with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QC - Quebec with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QC  Pound
Admin Support User should be able to add a new Jurisdiction to QC - Quebec with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to QC - Quebec with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QC - Quebec as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QC - Quebec  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QC  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  QC  Kilogram
Admin Support User should be able to remove a Jurisdiction to QC - Quebec with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to QC - Quebec with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QC - Quebec with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QC  Kilogram

Admin Support User should be able to add a new Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QR - Quuintana Roo as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QR - Quuintana Roo  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QR  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   QR  Pound
Admin Support User should be able to remove a Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to QR - Quuintana Roo with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QR - Quuintana Roo with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QR  Pound
Admin Support User should be able to add a new Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QR - Quuintana Roo as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QR - Quuintana Roo  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QR  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  QR  Kilogram
Admin Support User should be able to remove a Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to QR - Quuintana Roo with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QR - Quuintana Roo with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QR  Kilogram

Admin Support User should be able to add a new Jurisdiction to QT - Queretaro with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to QT - Queretaro with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QT - Queretaro as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QT - Queretaro  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QT  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   QT  Pound
Admin Support User should be able to remove a Jurisdiction to QT - Queretaro with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to QT - Queretaro with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QT - Queretaro with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QT  Pound
Admin Support User should be able to add a new Jurisdiction to QT - Queretaro with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to QT - Queretaro with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QT - Queretaro as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QT - Queretaro  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  QT  Kilogram
Admin Support User should be able to remove a Jurisdiction to QT - Queretaro with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to QT - Queretaro with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QT - Queretaro with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QT  Kilogram

Admin Support User should be able to add a new Jurisdiction to RI - Rhode Island with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to RI - Rhode Island with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting RI - Rhode Island as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  RI - Rhode Island  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    RI  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   RI  Pound
Admin Support User should be able to remove a Jurisdiction to RI - Rhode Island with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to RI - Rhode Island with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to RI - Rhode Island with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  RI  Pound
Admin Support User should be able to add a new Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting RI - Rhode Island as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  RI - Rhode Island  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  RI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  RI  Kilogram
Admin Support User should be able to remove a Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to RI - Rhode Island with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to RI - Rhode Island with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    RI  Kilogram

Admin Support User should be able to add a new Jurisdiction to SC - South Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SC - South Carolina with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SC - South Carolina as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SC - South Carolina  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SC  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   SC  Pound
Admin Support User should be able to remove a Jurisdiction to SC - South Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SC - South Carolina with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SC - South Carolina with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SC  Pound
Admin Support User should be able to add a new Jurisdiction to SC - South Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SC - South Carolina with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SC - South Carolina as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SC - South Carolina  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  SC  Kilogram
Admin Support User should be able to remove a Jurisdiction to SC - South Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SC - South Carolina with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SC - South Carolina with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SC  Kilogram

Admin Support User should be able to add a new Jurisdiction to SD - South Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SD - South Dakota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SD - South Dakota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SD - South Dakota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SD  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   SD  Pound
Admin Support User should be able to remove a Jurisdiction to SD - South Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SD - South Dakota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SD - South Dakota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SD  Pound
Admin Support User should be able to add a new Jurisdiction to SD - South Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SD - South Dakota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SD - South Dakota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SD - South Dakota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SD  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  SD  Kilogram
Admin Support User should be able to remove a Jurisdiction to SD - South Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SD - South Dakota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SD - South Dakota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SD  Kilogram

Admin Support User should be able to add a new Jurisdiction to SI - Sinaloa with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SI - Sinaloa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SI - Sinaloa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SI - Sinaloa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SI  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   SI  Pound
Admin Support User should be able to remove a Jurisdiction to SI - Sinaloa with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SI - Sinaloa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SI - Sinaloa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SI  Pound
Admin Support User should be able to add a new Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SI - Sinaloa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SI - Sinaloa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SI  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  SI  Kilogram
Admin Support User should be able to remove a Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SI - Sinaloa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SI - Sinaloa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SI  Kilogram

Admin Support User should be able to add a new Jurisdiction to SK - Saskatchewan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SK - Saskatchewan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SK - Saskatchewan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SK - Saskatchewan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SK  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   SK  Pound
Admin Support User should be able to remove a Jurisdiction to SK - Saskatchewan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SK - Saskatchewan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SK - Saskatchewan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SK  Pound
Admin Support User should be able to add a new Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SK - Saskatchewan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SK - Saskatchewan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SK  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  SK  Kilogram
Admin Support User should be able to remove a Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SK - Saskatchewan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SK - Saskatchewan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SK  Kilogram

Admin Support User should be able to add a new Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SL - San Luis Potosi as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SL - San Luis Potosi  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   SL  Pound
Admin Support User should be able to remove a Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SL - San Luis Potosi with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SL - San Luis Potosi with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SL  Pound
Admin Support User should be able to add a new Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SL - San Luis Potosi as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SL - San Luis Potosi  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  SL  Kilogram
Admin Support User should be able to remove a Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SL - San Luis Potosi with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SL - San Luis Potosi with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SL  Kilogram

Admin Support User should be able to add a new Jurisdiction to SO - Sonora with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SO - Sonora with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SO - Sonora as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SO - Sonora  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SO  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   SO  Pound
Admin Support User should be able to remove a Jurisdiction to SO - Sonora with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SO - Sonora with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SO - Sonora with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SO  Pound
Admin Support User should be able to add a new Jurisdiction to SO - Sonora with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to SO - Sonora with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SO - Sonora as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SO - Sonora  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  SO  Kilogram
Admin Support User should be able to remove a Jurisdiction to SO - Sonora with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to SO - Sonora with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SO - Sonora with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SO  Kilogram

Admin Support User should be able to add a new Jurisdiction to TB - Tabasco with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TB - Tabasco with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TB - Tabasco as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TB - Tabasco  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TB  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   TB  Pound
Admin Support User should be able to remove a Jurisdiction to TB - Tabasco with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TB - Tabasco with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TB - Tabasco with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TB  Pound
Admin Support User should be able to add a new Jurisdiction to TB - Tabasco with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TB - Tabasco with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TB - Tabasco as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TB - Tabasco  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TB  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  TB  Kilogram
Admin Support User should be able to remove a Jurisdiction to TB - Tabasco with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TB - Tabasco with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TB - Tabasco with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TB  Kilogram

Admin Support User should be able to add a new Jurisdiction to TL - Tlaxcala with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TL - Tlaxcala with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TL - Tlaxcala as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TL - Tlaxcala  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TL  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   TL  Pound
Admin Support User should be able to remove a Jurisdiction to TL - Tlaxcala with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TL - Tlaxcala with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TL - Tlaxcala with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TL  Pound
Admin Support User should be able to add a new Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TL - Tlaxcala as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TL - Tlaxcala  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  TL  Kilogram
Admin Support User should be able to remove a Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TL - Tlaxcala with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TL - Tlaxcala with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TL  Kilogram

Admin Support User should be able to add a new Jurisdiction to TM - Tamaulipas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TM - Tamaulipas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TM - Tamaulipas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TM - Tamaulipas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TM  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   TM  Pound
Admin Support User should be able to remove a Jurisdiction to TM - Tamaulipas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TM - Tamaulipas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TM - Tamaulipas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TM  Pound
Admin Support User should be able to add a new Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TM - Tamaulipas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TM - Tamaulipas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TM  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  TM  Kilogram
Admin Support User should be able to remove a Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TM - Tamaulipas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TM - Tamaulipas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TM  Kilogram

Admin Support User should be able to add a new Jurisdiction to TN - Tennessee with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TN - Tennessee with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TN - Tennessee as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TN - Tennessee  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TN  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   TN  Pound
Admin Support User should be able to remove a Jurisdiction to TN - Tennessee with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TN - Tennessee with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TN - Tennessee with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TN  Pound
Admin Support User should be able to add a new Jurisdiction to TN - Tennessee with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TN - Tennessee with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TN - Tennessee as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TN - Tennessee  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  TN  Kilogram
Admin Support User should be able to remove a Jurisdiction to TN - Tennessee with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TN - Tennessee with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TN - Tennessee with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TN  Kilogram

Admin Support User should be able to add a new Jurisdiction to TX - Texas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TX - Texas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TX - Texas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TX - Texas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TX  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   TX  Pound
Admin Support User should be able to remove a Jurisdiction to TX - Texas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TX - Texas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TX - Texas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TX  Pound
Admin Support User should be able to add a new Jurisdiction to TX - Texas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to TX - Texas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TX - Texas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TX - Texas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TX  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  TX  Kilogram
Admin Support User should be able to remove a Jurisdiction to TX - Texas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to TX - Texas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TX - Texas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TX  Kilogram

Admin Support User should be able to add a new Jurisdiction to UT - Utah with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to UT - Utah with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting UT - Utah as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  UT - Utah  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    UT  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   UT  Pound
Admin Support User should be able to remove a Jurisdiction to UT - Utah with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to UT - Utah with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to UT - Utah with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  UT  Pound
Admin Support User should be able to add a new Jurisdiction to UT - Utah with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to UT - Utah with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting UT - Utah as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  UT - Utah  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  UT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  UT  Kilogram
Admin Support User should be able to remove a Jurisdiction to UT - Utah with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to UT - Utah with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to UT - Utah with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    UT  Kilogram

Admin Support User should be able to add a new Jurisdiction to VA - Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VA - Virginia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VA - Virginia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VA - Virginia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   VA  Pound
Admin Support User should be able to remove a Jurisdiction to VA - Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VA - Virginia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VA - Virginia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VA  Pound
Admin Support User should be able to add a new Jurisdiction to VA - Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VA - Virginia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VA - Virginia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VA - Virginia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  VA  Kilogram
Admin Support User should be able to remove a Jurisdiction to VA - Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VA - Virginia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VA - Virginia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VA  Kilogram

Admin Support User should be able to add a new Jurisdiction to VE - Veracruz with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VE - Veracruz with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VE - Veracruz as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VE - Veracruz  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VE  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   VE  Pound
Admin Support User should be able to remove a Jurisdiction to VE - Veracruz with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VE - Veracruz with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VE - Veracruz with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VE  Pound
Admin Support User should be able to add a new Jurisdiction to VE - Veracruz with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VE - Veracruz with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VE - Veracruz as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VE - Veracruz  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VE  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  VE  Kilogram
Admin Support User should be able to remove a Jurisdiction to VE - Veracruz with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VE - Veracruz with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VE - Veracruz with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VE  Kilogram

Admin Support User should be able to add a new Jurisdiction to VI - Virgin Islands with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VI - Virgin Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VI - Virgin Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VI - Virgin Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VI  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   VI  Pound
Admin Support User should be able to remove a Jurisdiction to VI - Virgin Islands with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VI - Virgin Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VI - Virgin Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VI  Pound
Admin Support User should be able to add a new Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VI - Virgin Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VI - Virgin Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  VI  Kilogram
Admin Support User should be able to remove a Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VI - Virgin Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VI - Virgin Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VI  Kilogram

Admin Support User should be able to add a new Jurisdiction to VT - Vermont with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VT - Vermont with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VT - Vermont as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VT - Vermont  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VT  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   VT  Pound
Admin Support User should be able to remove a Jurisdiction to VT - Vermont with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VT - Vermont with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VT - Vermont with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VT  Pound
Admin Support User should be able to add a new Jurisdiction to VT - Vermont with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to VT - Vermont with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VT - Vermont as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VT - Vermont  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  VT  Kilogram
Admin Support User should be able to remove a Jurisdiction to VT - Vermont with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to VT - Vermont with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VT - Vermont with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VT  Kilogram

Admin Support User should be able to add a new Jurisdiction to WA - Washington with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WA - Washington with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WA - Washington as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WA - Washington  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WA  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   WA  Pound
Admin Support User should be able to remove a Jurisdiction to WA - Washington with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WA - Washington with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WA - Washington with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WA  Pound
Admin Support User should be able to add a new Jurisdiction to WA - Washington with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WA - Washington with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WA - Washington as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WA - Washington  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  WA  Kilogram
Admin Support User should be able to remove a Jurisdiction to WA - Washington with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WA - Washington with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WA - Washington with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WA  Kilogram

Admin Support User should be able to add a new Jurisdiction to WI - Wisconsin with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WI - Wisconsin with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WI - Wisconsin as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WI - Wisconsin  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WI  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   WI  Pound
Admin Support User should be able to remove a Jurisdiction to WI - Wisconsin with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WI - Wisconsin with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WI - Wisconsin with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WI  Pound
Admin Support User should be able to add a new Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WI - Wisconsin as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WI - Wisconsin  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  WI  Kilogram
Admin Support User should be able to remove a Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WI - Wisconsin with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WI - Wisconsin with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WI  Kilogram

Admin Support User should be able to add a new Jurisdiction to WV - West Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WV - West Virginia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WV - West Virginia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WV - West Virginia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WV  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   WV  Pound
Admin Support User should be able to remove a Jurisdiction to WV - West Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WV - West Virginia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WV - West Virginia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WV  Pound
Admin Support User should be able to add a new Jurisdiction to WV - West Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WV - West Virginia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WV - West Virginia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WV - West Virginia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WV  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  WV  Kilogram
Admin Support User should be able to remove a Jurisdiction to WV - West Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WV - West Virginia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WV - West Virginia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WV  Kilogram

Admin Support User should be able to add a new Jurisdiction to WY - Wyoming with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WY - Wyoming with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WY - Wyoming as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WY - Wyoming  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WY  USA  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   WY  Pound
Admin Support User should be able to remove a Jurisdiction to WY - Wyoming with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WY - Wyoming with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WY - Wyoming with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WY  Pound
Admin Support User should be able to add a new Jurisdiction to WY - Wyoming with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to WY - Wyoming with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WY - Wyoming as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WY - Wyoming  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  WY  Kilogram
Admin Support User should be able to remove a Jurisdiction to WY - Wyoming with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to WY - Wyoming with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WY - Wyoming with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WY  Kilogram

Admin Support User should be able to add a new Jurisdiction to YT - Yukon Territory with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to YT - Yukon Territory with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting YT - Yukon Territory as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YT - Yukon Territory  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    YT  CAN  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   YT  Pound
Admin Support User should be able to remove a Jurisdiction to YT - Yukon Territory with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to YT - Yukon Territory with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to YT - Yukon Territory with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  YT  Pound
Admin Support User should be able to add a new Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting YT - Yukon Territory as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YT - Yukon Territory  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  YT  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  YT  Kilogram
Admin Support User should be able to remove a Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to YT - Yukon Territory with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to YT - Yukon Territory with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    YT  Kilogram

Admin Support User should be able to add a new Jurisdiction to YU - Yucatan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to YU - Yucatan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting YU - Yucatan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YU - Yucatan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    YU  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   YU  Pound
Admin Support User should be able to remove a Jurisdiction to YU - Yucatan with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to YU - Yucatan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to YU - Yucatan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  YU  Pound
Admin Support User should be able to add a new Jurisdiction to YU - Yucatan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to YU - Yucatan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting YU - Yucatan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YU - Yucatan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  YU  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  YU  Kilogram
Admin Support User should be able to remove a Jurisdiction to YU - Yucatan with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to YU - Yucatan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to YU - Yucatan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    YU  Kilogram

Admin Support User should be able to add a new Jurisdiction to ZA - Zacatecas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ZA - Zacatecas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ZA - Zacatecas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ZA - Zacatecas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ZA  MEX  Pound
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}   ZA  Pound
Admin Support User should be able to remove a Jurisdiction to ZA - Zacatecas with Pound as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204660  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ZA - Zacatecas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ZA - Zacatecas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ZA  Pound
Admin Support User should be able to add a new Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can Add a new Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ZA - Zacatecas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ZA - Zacatecas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ZA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${SupportLevelTractor}  ZA  Kilogram
Admin Support User should be able to remove a Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     [Tags]  JIRA:PORT-172  qTest:40204869  indepth
     [Documentation]  Validate if an Admin in Support level can remove Jurisdictions to ZA - Zacatecas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ZA - Zacatecas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ZA  Kilogram

Admin Support User should not be able to add a new Jurisdiction with GVWR value higher than 9999999
     [Tags]  JIRA:PORT-172  qTest:40204941
     [Documentation]  Validate that an Admin in Support level cannot Add a new Jurisdiction with a value higher than 9999999 in the GVWR field.
     ...  A message should appear saying is not possible to add Jurisdiction with a value higher than 9999999 in the GVWR field
     Set Test Variable  ${gvwr}  10000000
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Pound
     Validate on Screen that Jurisdiction was not added
Admin Support User should not be able to add a new Jurisdiction with the GVWR field empty
     [Tags]  JIRA:PORT-172  qTest:40205022
     [Documentation]  Validate that an Admin in Support level cannot Add a new Jurisdiction with the GVWR field empty
     ...  A message should appear saying is not possible to add Jurisdiction with empty in the GVWR field
     Set Test Variable  ${gvwr}  ${EMPTY}
     Fill Up Gvwr field and Click on Add Button  VI - Virgin  Pound
     Validate on Screen that Jurisdiction was not added
Admin Support User should not be able to add a new Jurisdiction with the State/Province field empty
     [Tags]  JIRA:PORT-172  qTest:40205045
     [Documentation]  Validate that an Admin in Support level cannot Add a new Jurisdiction with State/Province field empty
     ...  A message should appear saying is not possible to add Jurisdiction with State/Province field empty
     Fill Up Gvwr field and Click on Add Button  ${EMPTY}  Pound
     Validate on Screen that Jurisdiction was not added
     [Teardown]  Click Driveline Button  Close

Admin in Support level should be able to change the tractor status to Inactive
    [Tags]  JIRA:PORT-160  qTest:39926415
    [Documentation]  Validate if an Admin in Support level can change a tractor status to Inactive
    ...  by Clicking on the Tractor and then clicking on Retire button in Setup - Tractors screen.
    ...  Validate if an Admin in Support level can find tractors in In-active status
    ...  using the Search tool in Setup - Tractors screen.
    ...  Validate if an Admin in Support level can see the Tractor identified by the Status
    ...  as I when Inactive in Setup - Tractors screen.
    ...  Validate on Database if active_status column was populates with I.
    Click on Tractor and Then Click on Retire  ${SupportLevelTractor}
    Select In-Active Status and Then Click on Search  ${SupportLevelTractor}
    Validate on Screen if Tractor Status Was Changed for Inactive  ${SupportLevelTractor}
    Validate on Database if Tractor Status Was Changed for Inactive  ${SupportLevelTractor}
Admin in Support level should be able to change the tractor status to Active
    [Tags]  JIRA:PORT-160  qTest:39928301
    [Documentation]  Validate if an Admin in Support level can change a tractor status to Active
    ...  by Clicking on the Tractor and then clicking on Activate button in Setup - Tractors screen.
    ...  Validate if an Admin in Support level can find tractors in Active status
    ...  using the Search tool in Setup - Tractors screen.
    ...  Validate if an Admin in Support level can see the Tractor identified by the Status
    ...  as A when Inactive in Setup - Tractors screen.
    ...  Validate on Database if active_status column was populates with A.
    Click on Tractor and Then Click Activate  ${SupportLevelTractor}
    Select Active Status and Then Click on Search  ${SupportLevelTractor}
    Validate on Screen if Tractor Status Was Changed for Active  ${SupportLevelTractor}
    Validate on Database if Tractor Status Was Changed for Active  ${SupportLevelTractor}

Admin in Support level should be able to close the Tractors tab
    [Tags]  JIRA:PORT-160  qTest:39928301
    [Documentation]  Validate if an Admin in Support level can close the Tractors tab and do logout
    Right Click on Tractors Tab and Then Close
    [Teardown]  Navigate to My Account and Then Click on Logout

Company Admin should be able to create a new tractor
    [Tags]  JIRA:PORT-168  qTest:40009487
    [Documentation]  Validate if a Company Admin with valid credentials can log into Driveline and create a new tractor
    ...  The user should have access to the Setup - Tractors - Add/Edit Tractors section.
    ...  The user should be able to Create a new tractor.
    [Setup]  Input Company Admin Credentials and Then Click on Login
    Navigate to Setup - Tractors
    Click on Add Tractor Button
    Fill Up Reference ID Field and Click on Save Button  ${CompanyAdminTractor}

Company Admin User should be able to add a new Jurisdiction to AB - Alberta with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AB - Alberta with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AB - Alberta as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     [Setup]  Click on Tractor and Then Click on Jurisdiction  ${CompanyAdminTractor}
     Fill Up Gvwr field and Click on Add Button  AB - Alberta  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AB  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   AB  Pound
Company Admin User should be able to remove a Jurisdiction to AB - Alberta with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  refactor
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AB - Alberta with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AB - Alberta with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AB  Pound
Company Admin User should be able to add a new Jurisdiction to AB - Alberta with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AB - Alberta with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AB - Alberta as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AB - Alberta  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  AB  Kilogram
Company Admin User should be able to remove a Jurisdiction to AB - Alberta with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AB - Alberta with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AB - Alberta with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AB  Kilogram

Company Admin User should be able to add a new Jurisdiction to AG - Aguascalientes with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AG - Aguascalientes with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AG - Aguascalientes as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AG - Aguascalientes  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AG  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   AG  Pound
Company Admin User should be able to remove a Jurisdiction to AG - Aguascalientes with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AG - Aguascalientes with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AG - Aguascalientes with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AG  Pound
Company Admin User should be able to add a new Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AG - Aguascalientes as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AG - Aguascalientes  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  AG  Kilogram
Company Admin User should be able to remove a Jurisdiction to AG - Aguascalientes with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AG - Aguascalientes with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AG - Aguascalientes with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AG  Kilogram

Company Admin User should be able to add a new Jurisdiction to AK - Alaska with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AK - Alaska with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AK - Alaska as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AK - Alaska  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AK  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   AK  Pound
Company Admin User should be able to remove a Jurisdiction to AK - Alaska with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AK - Alaska with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AK - Alaska with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AK  Pound
Company Admin User should be able to add a new Jurisdiction to AK - Alaska with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AK - Alaska with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AK - Alaska as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AK - Alaska  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AK  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  AK  Kilogram
Company Admin User should be able to remove a Jurisdiction to AK - Alaska with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AK - Alaska with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AK - Alaska with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AK  Kilogram

Company Admin User should be able to add a new Jurisdiction to AL - Alabama with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AL - Alabama with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AL - Alabama as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AL - Alabama  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AL  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   AL  Pound
Company Admin User should be able to remove a Jurisdiction to AL - Alabama with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AL - Alabama with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AL - Alabama with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AL  Pound
Company Admin User should be able to add a new Jurisdiction to AL - Alabama with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AL - Alabama with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AL - Alabama as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AL - Alabama  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  AL  Kilogram
Company Admin User should be able to remove a Jurisdiction to AL - Alabama with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AL - Alabama with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AL - Alabama with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AL  Kilogram

Company Admin User should be able to add a new Jurisdiction to AR - Arkansas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AR - Arkansas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AR - Arkansas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AR - Arkansas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AR  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   AR  Pound
Company Admin User should be able to remove a Jurisdiction to AR - Arkansas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AR - Arkansas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AR - Arkansas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AR  Pound
Company Admin User should be able to add a new Jurisdiction to AR - Arkansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AR - Arkansas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AR - Arkansas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AR - Arkansas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  AR  Kilogram
Company Admin User should be able to remove a Jurisdiction to AR - Arkansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AR - Arkansas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AR - Arkansas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AR  Kilogram

Company Admin User should be able to add a new Jurisdiction to AS - American Samoa with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AS - American Samoa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AS - American Samoa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AS - American Samoa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AS  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   AS  Pound
Company Admin User should be able to remove a Jurisdiction to AS - American Samoa with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AS - American Samoa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AS - American Samoa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AS  Pound
Company Admin User should be able to add a new Jurisdiction to AS - American Samoa with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AS - American Samoa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AS - American Samoa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AS - American Samoa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  AS  Kilogram
Company Admin User should be able to remove a Jurisdiction to AS - American Samoa with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AS - American Samoa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AS - American Samoa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AS  Kilogram

Company Admin User should be able to add a new Jurisdiction to AZ - Arizona with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AZ - Arizona with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting AZ - Arizona as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AZ - Arizona  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    AZ  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   AZ  Pound
Company Admin User should be able to remove a Jurisdiction to AZ - Arizona with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AZ - Arizona with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to AZ - Arizona with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  AZ  Pound
Company Admin User should be able to add a new Jurisdiction to AZ - Arizona with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to AZ - Arizona with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting AZ - Arizona as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  AZ - Arizona  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  AZ  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  AZ  Kilogram
Company Admin User should be able to remove a Jurisdiction to AZ - Arizona with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to AZ - Arizona with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to AZ - Arizona with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    AZ  Kilogram

Company Admin User should be able to add a new Jurisdiction to BC - Baja California with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BC - Baja California with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BC - Baja California as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - Baja California  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BC  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   BC  Pound
Company Admin User should be able to remove a Jurisdiction to BC - Baja California with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BC - Baja California with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - Baja California with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BC  Pound
Company Admin User should be able to add a new Jurisdiction to BC - Baja California with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BC - Baja California with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BC - Baja California as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - Baja California  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BC  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  BC  Kilogram
Company Admin User should be able to remove a Jurisdiction to BC - Baja California with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BC - Baja California with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - Baja California with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BC  Kilogram

Company Admin User should be able to add a new Jurisdiction to BC - British Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BC - British Columbia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BC - British Columbia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - British Columbia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BC  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   BC  Pound
Company Admin User should be able to remove a Jurisdiction to BC - British Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BC - British Columbia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - British Columbia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BC  Pound
Company Admin User should be able to add a new Jurisdiction to BC - British Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BC - British Columbia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BC - British Columbia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BC - British Columbia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BC  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  BC  Kilogram
Company Admin User should be able to remove a Jurisdiction to BC - British Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BC - British Columbia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BC - British Columbia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BC  Kilogram

Company Admin User should be able to add a new Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BN - Baja Caifornia Norte as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BN - Baja Caifornia Norte  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BN  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   BN  Pound
Company Admin User should be able to remove a Jurisdiction to BN - Baja Caifornia Norte with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BN - Baja Caifornia Norte with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BN - Baja Caifornia Norte with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BN  Pound
Company Admin User should be able to add a new Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BN - Baja Caifornia Norte as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BN - Baja Caifornia Norte  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BN  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  BN  Kilogram
Company Admin User should be able to remove a Jurisdiction to BN - Baja Caifornia Norte with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BN - Baja Caifornia Norte with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BN - Baja Caifornia Norte with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BN  Kilogram

Company Admin User should be able to add a new Jurisdiction to BS - Baja California Sur with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BS - Baja California Sur with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting BS - Baja California Sur as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BS - Baja California Sur  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    BS  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   BS  Pound
Company Admin User should be able to remove a Jurisdiction to BS - Baja California Sur with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BS - Baja California Sur with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to BS - Baja California Sur with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  BS  Pound
Company Admin User should be able to add a new Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting BS - Baja California Sur as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  BS - Baja California Sur  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  BS  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  BS  Kilogram
Company Admin User should be able to remove a Jurisdiction to BS - Baja California Sur with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to BS - Baja California Sur with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to BS - Baja California Sur with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    BS  Kilogram

Company Admin User should be able to add a new Jurisdiction to CA - California with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CA - California with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CA - California as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CA - California  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CA  Pound
Company Admin User should be able to remove a Jurisdiction to CA - California with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CA - California with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CA - California with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CA  Pound
Company Admin User should be able to add a new Jurisdiction to CA - California with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CA - California with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CA - California as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CA - California  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CA  Kilogram
Company Admin User should be able to remove a Jurisdiction to CA - California with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CA - California with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CA - California with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CA  Kilogram

Company Admin User should be able to add a new Jurisdiction to CH - Chihuahua with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CH - Chihuahua with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CH - Chihuahua as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CH - Chihuahua  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CH  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CH  Pound
Company Admin User should be able to remove a Jurisdiction to CH - Chihuahua with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CH - Chihuahua with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CH - Chihuahua with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CH  Pound
Company Admin User should be able to add a new Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CH - Chihuahua as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CH - Chihuahua  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CH  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CH  Kilogram
Company Admin User should be able to remove a Jurisdiction to CH - Chihuahua with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CH - Chihuahua with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CH - Chihuahua with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CH  Kilogram

Company Admin User should be able to add a new Jurisdiction to CL - Colima with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CL - Colima with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CL - Colima as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CL - Colima  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CL  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CL  Pound
Company Admin User should be able to remove a Jurisdiction to CL - Colima with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CL - Colima with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CL - Colima with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CL  Pound
Company Admin User should be able to add a new Jurisdiction to CL - Colima with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CL - Colima with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CL - Colima as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CL - Colima  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CL  Kilogram
Company Admin User should be able to remove a Jurisdiction to CL - Colima with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CL - Colima with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CL - Colima with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CL  Kilogram

Company Admin User should be able to add a new Jurisdiction to CM - Campeche with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CM - Campeche with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CM - Campeche as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CM - Campeche  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CM  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CM  Pound
Company Admin User should be able to remove a Jurisdiction to CM - Campeche with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CM - Campeche with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CM - Campeche with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CM  Pound
Company Admin User should be able to add a new Jurisdiction to CM - Campeche with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CM - Campeche with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CM - Campeche as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CM - Campeche  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CM  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CM  Kilogram
Company Admin User should be able to remove a Jurisdiction to CM - Campeche with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CM - Campeche with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CM - Campeche with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CM  Kilogram

Company Admin User should be able to add a new Jurisdiction to CO - Coahuila with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CO - Coahuila with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CO - Coahuila as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Coahuila  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CO  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CO  Pound
Company Admin User should be able to remove a Jurisdiction to CO - Coahuila with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CO - Coahuila with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Coahuila with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CO  Pound
Company Admin User should be able to add a new Jurisdiction to CO - Coahuila with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CO - Coahuila with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CO - Coahuila as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Coahuila  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CO  Kilogram
Company Admin User should be able to remove a Jurisdiction to CO - Coahuila with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CO - Coahuila with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Coahuila with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CO  Kilogram

Company Admin User should be able to add a new Jurisdiction to CO - Colorado with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CO - Colorado with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CO - Colorado as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Colorado  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CO  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CO  Pound
Company Admin User should be able to remove a Jurisdiction to CO - Colorado with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CO - Colorado with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Colorado with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CO  Pound
Company Admin User should be able to add a new Jurisdiction to CO - Colorado with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CO - Colorado with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CO - Colorado as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CO - Colorado  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CO  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CO  Kilogram
Company Admin User should be able to remove a Jurisdiction to CO - Colorado with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CO - Colorado with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CO - Colorado with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CO  Kilogram

Company Admin User should be able to add a new Jurisdiction to CS - Chiapas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CS - Chiapas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CS - Chiapas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CS - Chiapas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CS  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CS  Pound
Company Admin User should be able to remove a Jurisdiction to CS - Chiapas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CS - Chiapas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CS - Chiapas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CS  Pound
Company Admin User should be able to add a new Jurisdiction to CS - Chiapas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CS - Chiapas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CS - Chiapas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CS - Chiapas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CS  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CS  Kilogram
Company Admin User should be able to remove a Jurisdiction to CS - Chiapas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CS - Chiapas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CS - Chiapas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CS  Kilogram

Company Admin User should be able to add a new Jurisdiction to CT - Connecticut with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CT - Connecticut with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting CT - Connecticut as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CT - Connecticut  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    CT  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   CT  Pound
Company Admin User should be able to remove a Jurisdiction to CT - Connecticut with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CT - Connecticut with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to CT - Connecticut with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  CT  Pound
Company Admin User should be able to add a new Jurisdiction to CT - Connecticut with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to CT - Connecticut with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting CT - Connecticut as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  CT - Connecticut  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  CT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  CT  Kilogram
Company Admin User should be able to remove a Jurisdiction to CT - Connecticut with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to CT - Connecticut with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to CT - Connecticut with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    CT  Kilogram

Company Admin User should be able to add a new Jurisdiction to DC - District of Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DC - District of Columbia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DC - District of Columbia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DC - District of Columbia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DC  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   DC  Pound
Company Admin User should be able to remove a Jurisdiction to DC - District of Columbia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DC - District of Columbia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DC - District of Columbia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DC  Pound
Company Admin User should be able to add a new Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DC - District of Columbia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DC - District of Columbia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  DC  Kilogram
Company Admin User should be able to remove a Jurisdiction to DC - District of Columbia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DC - District of Columbia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DC - District of Columbia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DC  Kilogram

Company Admin User should be able to add a new Jurisdiction to DE - Delaware with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DE - Delaware with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DE - Delaware as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DE - Delaware  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DE  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   DE  Pound
Company Admin User should be able to remove a Jurisdiction to DE - Delaware with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DE - Delaware with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DE - Delaware with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DE  Pound
Company Admin User should be able to add a new Jurisdiction to DE - Delaware with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DE - Delaware with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DE - Delaware as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DE - Delaware  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DE  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  DE  Kilogram
Company Admin User should be able to remove a Jurisdiction to DE - Delaware with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DE - Delaware with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DE - Delaware with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DE  Kilogram

Company Admin User should be able to add a new Jurisdiction to DF - Distritio Federal with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DF - Distritio Federal with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DF - Distritio Federal as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DF - Distritio Federal  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DF  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   DF  Pound
Company Admin User should be able to remove a Jurisdiction to DF - Distritio Federal with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DF - Distritio Federal with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DF - Distritio Federal with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DF  Pound
Company Admin User should be able to add a new Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DF - Distritio Federal as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DF - Distritio Federal  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DF  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  DF  Kilogram
Company Admin User should be able to remove a Jurisdiction to DF - Distritio Federal with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DF - Distritio Federal with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DF - Distritio Federal with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DF  Kilogram

Company Admin User should be able to add a new Jurisdiction to DG - Durango with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DG - Durango with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting DG - Durango as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    DG  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   DG  Pound
Company Admin User should be able to remove a Jurisdiction to DG - Durango with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DG - Durango with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to DG - Durango with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  DG  Pound
Company Admin User should be able to add a new Jurisdiction to DG - Durango with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to DG - Durango with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting DG - Durango as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  DG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  DG  Kilogram
Company Admin User should be able to remove a Jurisdiction to DG - Durango with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to DG - Durango with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to DG - Durango with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    DG  Kilogram

Company Admin User should be able to add a new Jurisdiction to FL - Florida with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to FL - Florida with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting FL - Florida as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FL - Florida  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    FL  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   FL  Pound
Company Admin User should be able to remove a Jurisdiction to FL - Florida with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to FL - Florida with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to FL - Florida with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  FL  Pound
Company Admin User should be able to add a new Jurisdiction to FL - Florida with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to FL - Florida with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting FL - Florida as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FL - Florida  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  FL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  FL  Kilogram
Company Admin User should be able to remove a Jurisdiction to FL - Florida with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to FL - Florida with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to FL - Florida with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    FL  Kilogram

Company Admin User should be able to add a new Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting FM - Federated States of Micronesia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FM - Federated States of Micronesia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    FM  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   FM  Pound
Company Admin User should be able to remove a Jurisdiction to FM - Federated States of Micronesia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to FM - Federated States of Micronesia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to FM - Federated States of Micronesia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  FM  Pound
Company Admin User should be able to add a new Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting FM - Federated States of Micronesia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  FM - Federated States of Micronesia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  FM  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  FM  Kilogram
Company Admin User should be able to remove a Jurisdiction to FM - Federated States of Micronesia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to FM - Federated States of Micronesia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to FM - Federated States of Micronesia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    FM  Kilogram

Company Admin User should be able to add a new Jurisdiction to GA - Georgia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GA - Georgia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GA - Georgia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GA - Georgia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   GA  Pound
Company Admin User should be able to remove a Jurisdiction to GA - Georgia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GA - Georgia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GA - Georgia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GA  Pound
Company Admin User should be able to add a new Jurisdiction to GA - Georgia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GA - Georgia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GA - Georgia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GA - Georgia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  GA  Kilogram
Company Admin User should be able to remove a Jurisdiction to GA - Georgia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GA - Georgia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GA - Georgia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GA  Kilogram

Company Admin User should be able to add a new Jurisdiction to GR - Guerrero with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GR - Guerrero with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GR - Guerrero as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GR - Guerrero  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GR  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   GR  Pound
Company Admin User should be able to remove a Jurisdiction to GR - Guerrero with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GR - Guerrero with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GR - Guerrero with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GR  Pound
Company Admin User should be able to add a new Jurisdiction to GR - Guerrero with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GR - Guerrero with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GR - Guerrero as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GR - Guerrero  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GR  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  GR  Kilogram
Company Admin User should be able to remove a Jurisdiction to GR - Guerrero with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GR - Guerrero with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GR - Guerrero with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GR  Kilogram

Company Admin User should be able to add a new Jurisdiction to GT - Guanajuato with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GT - Guanajuato with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GT - Guanajuato as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GT - Guanajuato  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GT  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   GT  Pound
Company Admin User should be able to remove a Jurisdiction to GT - Guanajuato with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GT - Guanajuato with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GT - Guanajuato with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GT  Pound
Company Admin User should be able to add a new Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GT - Guanajuato as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GT - Guanajuato  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  GT  Kilogram
Company Admin User should be able to remove a Jurisdiction to GT - Guanajuato with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GT - Guanajuato with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GT - Guanajuato with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GT  Kilogram

Company Admin User should be able to add a new Jurisdiction to GU - Guam with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GU - Guam with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting GU - Guam as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GU - Guam  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    GU  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   GU  Pound
Company Admin User should be able to remove a Jurisdiction to GU - Guam with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GU - Guam with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to GU - Guam with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  GU  Pound
Company Admin User should be able to add a new Jurisdiction to GU - Guam with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to GU - Guam with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting GU - Guam as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  GU - Guam  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  GU  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  GU  Kilogram
Company Admin User should be able to remove a Jurisdiction to GU - Guam with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to GU - Guam with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to GU - Guam with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    GU  Kilogram

Company Admin User should be able to add a new Jurisdiction to HG - Hidalgo with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to HG - Hidalgo with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting HG - Hidalgo as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HG - Hidalgo  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    HG  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   HG  Pound
Company Admin User should be able to remove a Jurisdiction to HG - Hidalgo with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to HG - Hidalgo with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to HG - Hidalgo with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  HG  Pound
Company Admin User should be able to add a new Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting HG - Hidalgo as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HG - Hidalgo  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  HG  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  HG  Kilogram
Company Admin User should be able to remove a Jurisdiction to HG - Hidalgo with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to HG - Hidalgo with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to HG - Hidalgo with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    HG  Kilogram

Company Admin User should be able to add a new Jurisdiction to HI - Hawaii with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to HI - Hawaii with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting HI - Hawaii as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HI - Hawaii  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    HI  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   HI  Pound
Company Admin User should be able to remove a Jurisdiction to HI - Hawaii with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to HI - Hawaii with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to HI - Hawaii with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  HI  Pound
Company Admin User should be able to add a new Jurisdiction to HI - Hawaii with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to HI - Hawaii with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting HI - Hawaii as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  HI - Hawaii  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  HI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  HI  Kilogram
Company Admin User should be able to remove a Jurisdiction to HI - Hawaii with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to HI - Hawaii with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to HI - Hawaii with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    HI  Kilogram

Company Admin User should be able to add a new Jurisdiction to IA - Iowa with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to IA - Iowa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IA - Iowa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IA - Iowa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   IA  Pound
Company Admin User should be able to remove a Jurisdiction to IA - Iowa with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to IA - Iowa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IA - Iowa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IA  Pound
Company Admin User should be able to add a new Jurisdiction to IA - Iowa with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to IA - Iowa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IA - Iowa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IA - Iowa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  IA  Kilogram
Company Admin User should be able to remove a Jurisdiction to IA - Iowa with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to IA - Iowa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IA - Iowa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IA  Kilogram

Company Admin User should be able to add a new Jurisdiction to ID - Idaho with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ID - Idaho with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ID - Idaho as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ID - Idaho  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ID  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   ID  Pound
Company Admin User should be able to remove a Jurisdiction to ID - Idaho with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ID - Idaho with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ID - Idaho with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ID  Pound
Company Admin User should be able to add a new Jurisdiction to ID - Idaho with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ID - Idaho with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ID - Idaho as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ID - Idaho  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ID  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  ID  Kilogram
Company Admin User should be able to remove a Jurisdiction to ID - Idaho with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ID - Idaho with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ID - Idaho with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ID  Kilogram

Company Admin User should be able to add a new Jurisdiction to IL - Illinois with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to IL - Illinois with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IL - Illinois as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IL - Illinois  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IL  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   IL  Pound
Company Admin User should be able to remove a Jurisdiction to IL - Illinois with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to IL - Illinois with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IL - Illinois with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IL  Pound
Company Admin User should be able to add a new Jurisdiction to IL - Illinois with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to IL - Illinois with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IL - Illinois as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IL - Illinois  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IL  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  IL  Kilogram
Company Admin User should be able to remove a Jurisdiction to IL - Illinois with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to IL - Illinois with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IL - Illinois with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IL  Kilogram

Company Admin User should be able to add a new Jurisdiction to IN - Indiana with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to IN - Indiana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting IN - Indiana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IN - Indiana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    IN  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   IN  Pound
Company Admin User should be able to remove a Jurisdiction to IN - Indiana with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to IN - Indiana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to IN - Indiana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  IN  Pound
Company Admin User should be able to add a new Jurisdiction to IN - Indiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to IN - Indiana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting IN - Indiana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  IN - Indiana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  IN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  IN  Kilogram
Company Admin User should be able to remove a Jurisdiction to IN - Indiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to IN - Indiana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to IN - Indiana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    IN  Kilogram

Company Admin User should be able to add a new Jurisdiction to JA - Jalisco with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to JA - Jalisco with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting JA - Jalisco as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  JA - Jalisco  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    JA  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   JA  Pound
Company Admin User should be able to remove a Jurisdiction to JA - Jalisco with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to JA - Jalisco with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to JA - Jalisco with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  JA  Pound
Company Admin User should be able to add a new Jurisdiction to JA - Jalisco with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to JA - Jalisco with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting JA - Jalisco as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  JA - Jalisco  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  JA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  JA  Kilogram
Company Admin User should be able to remove a Jurisdiction to JA - Jalisco with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to JA - Jalisco with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to JA - Jalisco with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    JA  Kilogram

Company Admin User should be able to add a new Jurisdiction to KS - Kansas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to KS - Kansas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting KS - Kansas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KS - Kansas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    KS  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   KS  Pound
Company Admin User should be able to remove a Jurisdiction to KS - Kansas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to KS - Kansas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to KS - Kansas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  KS  Pound
Company Admin User should be able to add a new Jurisdiction to KS - Kansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to KS - Kansas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting KS - Kansas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KS - Kansas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  KS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  KS  Kilogram
Company Admin User should be able to remove a Jurisdiction to KS - Kansas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to KS - Kansas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to KS - Kansas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    KS  Kilogram

Company Admin User should be able to add a new Jurisdiction to KY - Kentucky with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to KY - Kentucky with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting KY - Kentucky as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KY - Kentucky  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    KY  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   KY  Pound
Company Admin User should be able to remove a Jurisdiction to KY - Kentucky with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to KY - Kentucky with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to KY - Kentucky with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  KY  Pound
Company Admin User should be able to add a new Jurisdiction to KY - Kentucky with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to KY - Kentucky with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting KY - Kentucky as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  KY - Kentucky  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  KY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  KY  Kilogram
Company Admin User should be able to remove a Jurisdiction to KY - Kentucky with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to KY - Kentucky with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to KY - Kentucky with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    KY  Kilogram

Company Admin User should be able to add a new Jurisdiction to LA - Louisiana with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to LA - Louisiana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting LA - Louisiana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  LA - Louisiana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    LA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   LA  Pound
Company Admin User should be able to remove a Jurisdiction to LA - Louisiana with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to LA - Louisiana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to LA - Louisiana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  LA  Pound
Company Admin User should be able to add a new Jurisdiction to LA - Louisiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to LA - Louisiana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting LA - Louisiana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  LA - Louisiana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  LA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  LA  Kilogram
Company Admin User should be able to remove a Jurisdiction to LA - Louisiana with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to LA - Louisiana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to LA - Louisiana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    LA  Kilogram

Company Admin User should be able to add a new Jurisdiction to MA - Massachusetts with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MA - Massachusetts with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MA - Massachusetts as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MA - Massachusetts  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MA  Pound
Company Admin User should be able to remove a Jurisdiction to MA - Massachusetts with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MA - Massachusetts with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MA - Massachusetts with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MA  Pound
Company Admin User should be able to add a new Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MA - Massachusetts as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MA - Massachusetts  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MA  Kilogram
Company Admin User should be able to remove a Jurisdiction to MA - Massachusetts with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MA - Massachusetts with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MA - Massachusetts with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MA  Kilogram

Company Admin User should be able to add a new Jurisdiction to MB - Manitoba with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MB - Manitoba with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MB - Manitoba as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MB - Manitoba  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MB  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MB  Pound
Company Admin User should be able to remove a Jurisdiction to MB - Manitoba with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MB - Manitoba with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MB - Manitoba with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MB  Pound
Company Admin User should be able to add a new Jurisdiction to MB - Manitoba with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MB - Manitoba with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MB - Manitoba as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MB - Manitoba  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MB  Kilogram
Company Admin User should be able to remove a Jurisdiction to MB - Manitoba with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MB - Manitoba with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MB - Manitoba with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MB  Kilogram

Company Admin User should be able to add a new Jurisdiction to MD - Maryland with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MD - Maryland with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MD - Maryland as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MD - Maryland  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MD  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MD  Pound
Company Admin User should be able to remove a Jurisdiction to MD - Maryland with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MD - Maryland with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MD - Maryland with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MD  Pound
Company Admin User should be able to add a new Jurisdiction to MD - Maryland with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MD - Maryland with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MD - Maryland as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MD - Maryland  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MD  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MD  Kilogram
Company Admin User should be able to remove a Jurisdiction to MD - Maryland with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MD - Maryland with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MD - Maryland with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MD  Kilogram

Company Admin User should be able to add a new Jurisdiction to ME - Maine with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ME - Maine with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ME - Maine as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ME - Maine  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ME  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   ME  Pound
Company Admin User should be able to remove a Jurisdiction to ME - Maine with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ME - Maine with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ME - Maine with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ME  Pound
Company Admin User should be able to add a new Jurisdiction to ME - Maine with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ME - Maine with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ME - Maine as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ME - Maine  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ME  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  ME  Kilogram
Company Admin User should be able to remove a Jurisdiction to ME - Maine with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ME - Maine with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ME - Maine with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ME  Kilogram

Company Admin User should be able to add a new Jurisdiction to MH - Marshall Islands with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MH - Marshall Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MH - Marshall Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MH - Marshall Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MH  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MH  Pound
Company Admin User should be able to remove a Jurisdiction to MH - Marshall Islands with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MH - Marshall Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MH - Marshall Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MH  Pound
Company Admin User should be able to add a new Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MH - Marshall Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MH - Marshall Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MH  Kilogram
Company Admin User should be able to remove a Jurisdiction to MH - Marshall Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MH - Marshall Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MH - Marshall Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MH  Kilogram

Company Admin User should be able to add a new Jurisdiction to MI - Michigan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MI - Michigan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michigan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michigan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MI  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MI  Pound
Company Admin User should be able to remove a Jurisdiction to MI - Michigan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MI - Michigan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michigan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MI  Pound
Company Admin User should be able to add a new Jurisdiction to MI - Michigan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MI - Michigan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michigan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michigan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MI  Kilogram
Company Admin User should be able to remove a Jurisdiction to MI - Michigan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MI - Michigan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michigan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MI  Kilogram

Company Admin User should be able to add a new Jurisdiction to MI - Michoacan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MI - Michoacan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michoacan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michoacan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MI  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MI  Pound
Company Admin User should be able to remove a Jurisdiction to MI - Michoacan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MI - Michoacan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michoacan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MI  Pound
Company Admin User should be able to add a new Jurisdiction to MI - Michoacan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MI - Michoacan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MI - Michoacan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MI - Michoacan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MI  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MI  Kilogram
Company Admin User should be able to remove a Jurisdiction to MI - Michoacan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MI - Michoacan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MI - Michoacan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MI  Kilogram

Company Admin User should be able to add a new Jurisdiction to MN - Minnesota with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MN - Minnesota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MN - Minnesota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MN - Minnesota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MN  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MN  Pound
Company Admin User should be able to remove a Jurisdiction to MN - Minnesota with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MN - Minnesota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MN - Minnesota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MN  Pound
Company Admin User should be able to add a new Jurisdiction to MN - Minnesota with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MN - Minnesota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MN - Minnesota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MN - Minnesota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MN  Kilogram
Company Admin User should be able to remove a Jurisdiction to MN - Minnesota with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MN - Minnesota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MN - Minnesota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MN  Kilogram

Company Admin User should be able to add a new Jurisdiction to MO - Missouri with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MO - Missouri with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MO - Missouri as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Missouri  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MO  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MO  Pound
Company Admin User should be able to remove a Jurisdiction to MO - Missouri with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MO - Missouri with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Missouri with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MO  Pound
Company Admin User should be able to add a new Jurisdiction to MO - Missouri with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MO - Missouri with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MO - Missouri as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Missouri  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MO  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MO  Kilogram
Company Admin User should be able to remove a Jurisdiction to MO - Missouri with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MO - Missouri with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Missouri with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MO  Kilogram

Company Admin User should be able to add a new Jurisdiction to MO - Morelos with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MO - Morelos with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MO - Morelos as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Morelos  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MO  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MO  Pound
Company Admin User should be able to remove a Jurisdiction to MO - Morelos with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MO - Morelos with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Morelos with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MO  Pound
Company Admin User should be able to add a new Jurisdiction to MO - Morelos with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MO - Morelos with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MO - Morelos as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MO - Morelos  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MO  Kilogram
Company Admin User should be able to remove a Jurisdiction to MO - Morelos with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MO - Morelos with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MO - Morelos with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MO  Kilogram

Company Admin User should be able to add a new Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MP - Northern Mariana Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MP - Northern Mariana Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MP  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MP  Pound
Company Admin User should be able to remove a Jurisdiction to MP - Northern Mariana Islands with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MP - Northern Mariana Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MP - Northern Mariana Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MP  Pound
Company Admin User should be able to add a new Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MP - Northern Mariana Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MP - Northern Mariana Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MP  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MP  Kilogram
Company Admin User should be able to remove a Jurisdiction to MP - Northern Mariana Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MP - Northern Mariana Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MP - Northern Mariana Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MP  Kilogram

Company Admin User should be able to add a new Jurisdiction to MS - Mississippi with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MS - Mississippi with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MS - Mississippi as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MS - Mississippi  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MS  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MS  Pound
Company Admin User should be able to remove a Jurisdiction to MS - Mississippi with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MS - Mississippi with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MS - Mississippi with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MS  Pound
Company Admin User should be able to add a new Jurisdiction to MS - Mississippi with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MS - Mississippi with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MS - Mississippi as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MS - Mississippi  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MS  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MS  Kilogram
Company Admin User should be able to remove a Jurisdiction to MS - Mississippi with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MS - Mississippi with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MS - Mississippi with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MS  Kilogram

Company Admin User should be able to add a new Jurisdiction to MT - Montana with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MT - Montana with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MT - Montana as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MT - Montana  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MT  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MT  Pound
Company Admin User should be able to remove a Jurisdiction to MT - Montana with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MT - Montana with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MT - Montana with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MT  Pound
Company Admin User should be able to add a new Jurisdiction to MT - Montana with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MT - Montana with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MT - Montana as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MT - Montana  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MT  Kilogram
Company Admin User should be able to remove a Jurisdiction to MT - Montana with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MT - Montana with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MT - Montana with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MT  Kilogram

Company Admin User should be able to add a new Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting MX - Edo. Mexico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MX - Edo. Mexico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    MX  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   MX  Pound
Company Admin User should be able to remove a Jurisdiction to MX - Edo. Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MX - Edo. Mexico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to MX - Edo. Mexico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  MX  Pound
Company Admin User should be able to add a new Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting MX - Edo. Mexico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  MX - Edo. Mexico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  MX  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  MX  Kilogram
Company Admin User should be able to remove a Jurisdiction to MX - Edo. Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to MX - Edo. Mexico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to MX - Edo. Mexico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    MX  Kilogram

Company Admin User should be able to add a new Jurisdiction to NA - Nayarit with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NA - Nayarit with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NA - Nayarit as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NA - Nayarit  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NA  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NA  Pound
Company Admin User should be able to remove a Jurisdiction to NA - Nayarit with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NA - Nayarit with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NA - Nayarit with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NA  Pound
Company Admin User should be able to add a new Jurisdiction to NA - Nayarit with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NA - Nayarit with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NA - Nayarit as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NA - Nayarit  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NA  Kilogram
Company Admin User should be able to remove a Jurisdiction to NA - Nayarit with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NA - Nayarit with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NA - Nayarit with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NA  Kilogram

Company Admin User should be able to add a new Jurisdiction to NB - New Brunswick with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NB - New Brunswick with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NB - New Brunswick as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NB - New Brunswick  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NB  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NB  Pound
Company Admin User should be able to remove a Jurisdiction to NB - New Brunswick with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NB - New Brunswick with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NB - New Brunswick with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NB  Pound
Company Admin User should be able to add a new Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NB - New Brunswick as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NB - New Brunswick  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NB  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NB  Kilogram
Company Admin User should be able to remove a Jurisdiction to NB - New Brunswick with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NB - New Brunswick with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NB - New Brunswick with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NB  Kilogram

Company Admin User should be able to add a new Jurisdiction to NC - North Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NC - North Carolina with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NC - North Carolina as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NC - North Carolina  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NC  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NC  Pound
Company Admin User should be able to remove a Jurisdiction to NC - North Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NC - North Carolina with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NC - North Carolina with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NC  Pound
Company Admin User should be able to add a new Jurisdiction to NC - North Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NC - North Carolina with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NC - North Carolina as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NC - North Carolina  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NC  Kilogram
Company Admin User should be able to remove a Jurisdiction to NC - North Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NC - North Carolina with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NC - North Carolina with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NC  Kilogram

Company Admin User should be able to add a new Jurisdiction to ND - North Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ND - North Dakota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ND - North Dakota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ND - North Dakota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ND  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   ND  Pound
Company Admin User should be able to remove a Jurisdiction to ND - North Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ND - North Dakota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ND - North Dakota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ND  Pound
Company Admin User should be able to add a new Jurisdiction to ND - North Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ND - North Dakota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ND - North Dakota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ND - North Dakota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ND  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  ND  Kilogram
Company Admin User should be able to remove a Jurisdiction to ND - North Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ND - North Dakota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ND - North Dakota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ND  Kilogram

Company Admin User should be able to add a new Jurisdiction to NE - Nebraska with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NE - Nebraska with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NE - Nebraska as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NE - Nebraska  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NE  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NE  Pound
Company Admin User should be able to remove a Jurisdiction to NE - Nebraska with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NE - Nebraska with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NE - Nebraska with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NE  Pound
Company Admin User should be able to add a new Jurisdiction to NE - Nebraska with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NE - Nebraska with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NE - Nebraska as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NE - Nebraska  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NE  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NE  Kilogram
Company Admin User should be able to remove a Jurisdiction to NE - Nebraska with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NE - Nebraska with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NE - Nebraska with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NE  Kilogram

Company Admin User should be able to add a new Jurisdiction to NH - New Hampshire with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NH - New Hampshire with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NH - New Hampshire as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NH - New Hampshire  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NH  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NH  Pound
Company Admin User should be able to remove a Jurisdiction to NH - New Hampshire with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NH - New Hampshire with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NH - New Hampshire with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NH  Pound
Company Admin User should be able to add a new Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NH - New Hampshire as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NH - New Hampshire  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NH  Kilogram
Company Admin User should be able to remove a Jurisdiction to NH - New Hampshire with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NH - New Hampshire with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NH - New Hampshire with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NH  Kilogram

Company Admin User should be able to add a new Jurisdiction to NJ - New Jersey with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NJ - New Jersey with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NJ - New Jersey as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NJ - New Jersey  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NJ  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NJ  Pound
Company Admin User should be able to remove a Jurisdiction to NJ - New Jersey with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NJ - New Jersey with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NJ - New Jersey with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NJ  Pound
Company Admin User should be able to add a new Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NJ - New Jersey as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NJ - New Jersey  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NJ  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NJ  Kilogram
Company Admin User should be able to remove a Jurisdiction to NJ - New Jersey with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NJ - New Jersey with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NJ - New Jersey with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NJ  Kilogram

Company Admin User should be able to add a new Jurisdiction to NL - Newfoundland with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NL - Newfoundland with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NL - Newfoundland as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Newfoundland  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NL  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NL  Pound
Company Admin User should be able to remove a Jurisdiction to NL - Newfoundland with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NL - Newfoundland with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Newfoundland with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NL  Pound
Company Admin User should be able to add a new Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NL - Newfoundland as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Newfoundland  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NL  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NL  Kilogram
Company Admin User should be able to remove a Jurisdiction to NL - Newfoundland with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NL - Newfoundland with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Newfoundland with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NL  Kilogram

Company Admin User should be able to add a new Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NL - Nuevo Leon as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Nuevo Leon  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NL  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NL  Pound
Company Admin User should be able to remove a Jurisdiction to NL - Nuevo Leon with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NL - Nuevo Leon with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Nuevo Leon with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NL  Pound
Company Admin User should be able to add a new Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NL - Nuevo Leon as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NL - Nuevo Leon  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NL  Kilogram
Company Admin User should be able to remove a Jurisdiction to NL - Nuevo Leon with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NL - Nuevo Leon with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NL - Nuevo Leon with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NL  Kilogram

Company Admin User should be able to add a new Jurisdiction to NM - New Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NM - New Mexico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NM - New Mexico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NM - New Mexico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NM  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NM  Pound
Company Admin User should be able to remove a Jurisdiction to NM - New Mexico with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NM - New Mexico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NM - New Mexico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NM  Pound
Company Admin User should be able to add a new Jurisdiction to NM - New Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NM - New Mexico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NM - New Mexico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NM - New Mexico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NM  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NM  Kilogram
Company Admin User should be able to remove a Jurisdiction to NM - New Mexico with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NM - New Mexico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NM - New Mexico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NM  Kilogram

Company Admin User should be able to add a new Jurisdiction to NS - Nova Scotia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NS - Nova Scotia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NS - Nova Scotia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NS - Nova Scotia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NS  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NS  Pound
Company Admin User should be able to remove a Jurisdiction to NS - Nova Scotia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NS - Nova Scotia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NS - Nova Scotia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NS  Pound
Company Admin User should be able to add a new Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NS - Nova Scotia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NS - Nova Scotia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NS  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NS  Kilogram
Company Admin User should be able to remove a Jurisdiction to NS - Nova Scotia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NS - Nova Scotia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NS - Nova Scotia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NS  Kilogram

Company Admin User should be able to add a new Jurisdiction to NT - Northwest Territories with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NT - Northwest Territories with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NT - Northwest Territories as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NT - Northwest Territories  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NT  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NT  Pound
Company Admin User should be able to remove a Jurisdiction to NT - Northwest Territories with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NT - Northwest Territories with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NT - Northwest Territories with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NT  Pound
Company Admin User should be able to add a new Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NT - Northwest Territories as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NT - Northwest Territories  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NT  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NT  Kilogram
Company Admin User should be able to remove a Jurisdiction to NT - Northwest Territories with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NT - Northwest Territories with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NT - Northwest Territories with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NT  Kilogram

Company Admin User should be able to add a new Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NU - Nunavut Territory as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NU - Nunavut Territory  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NU  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NU  Pound
Company Admin User should be able to remove a Jurisdiction to NU - Nunavut Territory with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NU - Nunavut Territory with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NU - Nunavut Territory with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NU  Pound
Company Admin User should be able to add a new Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NU - Nunavut Territory as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NU - Nunavut Territory  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NU  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NU  Kilogram
Company Admin User should be able to remove a Jurisdiction to NU - Nunavut Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NU - Nunavut Territory with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NU - Nunavut Territory with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NU  Kilogram

Company Admin User should be able to add a new Jurisdiction to NV - Nevada with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NV - Nevada with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NV - Nevada as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NV - Nevada  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NV  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NV  Pound
Company Admin User should be able to remove a Jurisdiction to NV - Nevada with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NV - Nevada with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NV - Nevada with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NV  Pound
Company Admin User should be able to add a new Jurisdiction to NV - Nevada with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NV - Nevada with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NV - Nevada as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NV - Nevada  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NV  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NV  Kilogram
Company Admin User should be able to remove a Jurisdiction to NV - Nevada with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NV - Nevada with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NV - Nevada with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NV  Kilogram

Company Admin User should be able to add a new Jurisdiction to NY - New York with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NY - New York with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting NY - New York as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NY - New York  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    NY  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   NY  Pound
Company Admin User should be able to remove a Jurisdiction to NY - New York with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NY - New York with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to NY - New York with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  NY  Pound
Company Admin User should be able to add a new Jurisdiction to NY - New York with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to NY - New York with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting NY - New York as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  NY - New York  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  NY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  NY  Kilogram
Company Admin User should be able to remove a Jurisdiction to NY - New York with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to NY - New York with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to NY - New York with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    NY  Kilogram

Company Admin User should be able to add a new Jurisdiction to OA - Oaxaca with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OA - Oaxaca with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OA - Oaxaca as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OA - Oaxaca  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OA  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   OA  Pound
Company Admin User should be able to remove a Jurisdiction to OA - Oaxaca with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OA - Oaxaca with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OA - Oaxaca with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OA  Pound
Company Admin User should be able to add a new Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OA - Oaxaca as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OA - Oaxaca  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  OA  Kilogram
Company Admin User should be able to remove a Jurisdiction to OA - Oaxaca with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OA - Oaxaca with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OA - Oaxaca with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OA  Kilogram

Company Admin User should be able to add a new Jurisdiction to OH - Ohio with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OH - Ohio with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OH - Ohio as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OH - Ohio  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OH  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   OH  Pound
Company Admin User should be able to remove a Jurisdiction to OH - Ohio with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OH - Ohio with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OH - Ohio with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OH  Pound
Company Admin User should be able to add a new Jurisdiction to OH - Ohio with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OH - Ohio with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OH - Ohio as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OH - Ohio  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OH  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  OH  Kilogram
Company Admin User should be able to remove a Jurisdiction to OH - Ohio with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OH - Ohio with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OH - Ohio with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OH  Kilogram

Company Admin User should be able to add a new Jurisdiction to OK - Oklahoma with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OK - Oklahoma with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OK - Oklahoma as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OK - Oklahoma  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OK  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   OK  Pound
Company Admin User should be able to remove a Jurisdiction to OK - Oklahoma with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OK - Oklahoma with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OK - Oklahoma with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OK  Pound
Company Admin User should be able to add a new Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OK - Oklahoma as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OK - Oklahoma  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OK  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  OK  Kilogram
Company Admin User should be able to remove a Jurisdiction to OK - Oklahoma with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OK - Oklahoma with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OK - Oklahoma with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OK  Kilogram

Company Admin User should be able to add a new Jurisdiction to ON - Ontario with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ON - Ontario with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ON - Ontario as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ON - Ontario  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ON  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   ON  Pound
Company Admin User should be able to remove a Jurisdiction to ON - Ontario with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ON - Ontario with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ON - Ontario with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ON  Pound
Company Admin User should be able to add a new Jurisdiction to ON - Ontario with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ON - Ontario with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ON - Ontario as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ON - Ontario  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ON  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  ON  Kilogram
Company Admin User should be able to remove a Jurisdiction to ON - Ontario with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ON - Ontario with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ON - Ontario with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ON  Kilogram

Company Admin User should be able to add a new Jurisdiction to OR - Oregon with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OR - Oregon with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OR - Oregon as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OR - Oregon  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OR  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   OR  Pound
Company Admin User should be able to remove a Jurisdiction to OR - Oregon with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OR - Oregon with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OR - Oregon with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OR  Pound
Company Admin User should be able to add a new Jurisdiction to OR - Oregon with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OR - Oregon with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OR - Oregon as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OR - Oregon  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  OR  Kilogram
Company Admin User should be able to remove a Jurisdiction to OR - Oregon with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OR - Oregon with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OR - Oregon with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OR  Kilogram

Company Admin User should be able to add a new Jurisdiction to OT - State Unknown with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OT - State Unknown with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting OT - State Unknown as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OT - State Unknown  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    OT  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   OT  Pound
Company Admin User should be able to remove a Jurisdiction to OT - State Unknown with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OT - State Unknown with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to OT - State Unknown with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  OT  Pound
Company Admin User should be able to add a new Jurisdiction to OT - State Unknown with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to OT - State Unknown with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting OT - State Unknown as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  OT - State Unknown  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  OT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  OT  Kilogram
Company Admin User should be able to remove a Jurisdiction to OT - State Unknown with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to OT - State Unknown with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to OT - State Unknown with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    OT  Kilogram

Company Admin User should be able to add a new Jurisdiction to PA - Pennsylvania with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PA - Pennsylvania with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PA - Pennsylvania as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PA - Pennsylvania  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   PA  Pound
Company Admin User should be able to remove a Jurisdiction to PA - Pennsylvania with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PA - Pennsylvania with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PA - Pennsylvania with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PA  Pound
Company Admin User should be able to add a new Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PA - Pennsylvania as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PA - Pennsylvania  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  PA  Kilogram
Company Admin User should be able to remove a Jurisdiction to PA - Pennsylvania with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PA - Pennsylvania with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PA - Pennsylvania with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PA  Kilogram

Company Admin User should be able to add a new Jurisdiction to PE - Price Edward Island with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PE - Price Edward Island with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PE - Price Edward Island as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PE - Price Edward Island  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PE  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   PE  Pound
Company Admin User should be able to remove a Jurisdiction to PE - Price Edward Island with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PE - Price Edward Island with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PE - Price Edward Island with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PE  Pound
Company Admin User should be able to add a new Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PE - Price Edward Island as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PE - Price Edward Island  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PE  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  PE  Kilogram
Company Admin User should be able to remove a Jurisdiction to PE - Price Edward Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PE - Price Edward Island with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PE - Price Edward Island with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PE  Kilogram

Company Admin User should be able to add a new Jurisdiction to PR - Puerto Rico with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PR - Puerto Rico with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PR - Puerto Rico as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PR - Puerto Rico  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PR  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   PR  Pound
Company Admin User should be able to remove a Jurisdiction to PR - Puerto Rico with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PR - Puerto Rico with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PR - Puerto Rico with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PR  Pound
Company Admin User should be able to add a new Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PR - Puerto Rico as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PR - Puerto Rico  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PR  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  PR  Kilogram
Company Admin User should be able to remove a Jurisdiction to PR - Puerto Rico with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PR - Puerto Rico with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PR - Puerto Rico with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PR  Kilogram

Company Admin User should be able to add a new Jurisdiction to PU - Puebla with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PU - Puebla with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting PU - Puebla as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PU - Puebla  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    PU  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   PU  Pound
Company Admin User should be able to remove a Jurisdiction to PU - Puebla with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PU - Puebla with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to PU - Puebla with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  PU  Pound
Company Admin User should be able to add a new Jurisdiction to PU - Puebla with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to PU - Puebla with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting PU - Puebla as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  PU - Puebla  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  PU  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  PU  Kilogram
Company Admin User should be able to remove a Jurisdiction to PU - Puebla with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to PU - Puebla with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to PU - Puebla with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    PU  Kilogram

Company Admin User should be able to add a new Jurisdiction to QC - Quebec with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to QC - Quebec with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QC - Quebec as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QC - Quebec  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QC  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   QC  Pound
Company Admin User should be able to remove a Jurisdiction to QC - Quebec with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to QC - Quebec with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QC - Quebec with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QC  Pound
Company Admin User should be able to add a new Jurisdiction to QC - Quebec with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to QC - Quebec with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QC - Quebec as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QC - Quebec  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QC  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  QC  Kilogram
Company Admin User should be able to remove a Jurisdiction to QC - Quebec with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to QC - Quebec with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QC - Quebec with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QC  Kilogram

Company Admin User should be able to add a new Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QR - Quuintana Roo as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QR - Quuintana Roo  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QR  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   QR  Pound
Company Admin User should be able to remove a Jurisdiction to QR - Quuintana Roo with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to QR - Quuintana Roo with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QR - Quuintana Roo with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QR  Pound
Company Admin User should be able to add a new Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QR - Quuintana Roo as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QR - Quuintana Roo  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QR  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  QR  Kilogram
Company Admin User should be able to remove a Jurisdiction to QR - Quuintana Roo with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to QR - Quuintana Roo with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QR - Quuintana Roo with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QR  Kilogram

Company Admin User should be able to add a new Jurisdiction to QT - Queretaro with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to QT - Queretaro with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting QT - Queretaro as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QT - Queretaro  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    QT  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   QT  Pound
Company Admin User should be able to remove a Jurisdiction to QT - Queretaro with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to QT - Queretaro with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to QT - Queretaro with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  QT  Pound
Company Admin User should be able to add a new Jurisdiction to QT - Queretaro with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to QT - Queretaro with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting QT - Queretaro as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  QT - Queretaro  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  QT  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  QT  Kilogram
Company Admin User should be able to remove a Jurisdiction to QT - Queretaro with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to QT - Queretaro with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to QT - Queretaro with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    QT  Kilogram

Company Admin User should be able to add a new Jurisdiction to RI - Rhode Island with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to RI - Rhode Island with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting RI - Rhode Island as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  RI - Rhode Island  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    RI  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   RI  Pound
Company Admin User should be able to remove a Jurisdiction to RI - Rhode Island with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to RI - Rhode Island with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to RI - Rhode Island with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  RI  Pound
Company Admin User should be able to add a new Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting RI - Rhode Island as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  RI - Rhode Island  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  RI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  RI  Kilogram
Company Admin User should be able to remove a Jurisdiction to RI - Rhode Island with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to RI - Rhode Island with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to RI - Rhode Island with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    RI  Kilogram

Company Admin User should be able to add a new Jurisdiction to SC - South Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SC - South Carolina with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SC - South Carolina as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SC - South Carolina  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SC  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   SC  Pound
Company Admin User should be able to remove a Jurisdiction to SC - South Carolina with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SC - South Carolina with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SC - South Carolina with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SC  Pound
Company Admin User should be able to add a new Jurisdiction to SC - South Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SC - South Carolina with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SC - South Carolina as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SC - South Carolina  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SC  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  SC  Kilogram
Company Admin User should be able to remove a Jurisdiction to SC - South Carolina with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SC - South Carolina with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SC - South Carolina with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SC  Kilogram

Company Admin User should be able to add a new Jurisdiction to SD - South Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SD - South Dakota with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SD - South Dakota as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SD - South Dakota  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SD  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   SD  Pound
Company Admin User should be able to remove a Jurisdiction to SD - South Dakota with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SD - South Dakota with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SD - South Dakota with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SD  Pound
Company Admin User should be able to add a new Jurisdiction to SD - South Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SD - South Dakota with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SD - South Dakota as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SD - South Dakota  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SD  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  SD  Kilogram
Company Admin User should be able to remove a Jurisdiction to SD - South Dakota with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SD - South Dakota with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SD - South Dakota with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SD  Kilogram

Company Admin User should be able to add a new Jurisdiction to SI - Sinaloa with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SI - Sinaloa with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SI - Sinaloa as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SI - Sinaloa  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SI  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   SI  Pound
Company Admin User should be able to remove a Jurisdiction to SI - Sinaloa with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SI - Sinaloa with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SI - Sinaloa with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SI  Pound
Company Admin User should be able to add a new Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SI - Sinaloa as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SI - Sinaloa  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SI  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  SI  Kilogram
Company Admin User should be able to remove a Jurisdiction to SI - Sinaloa with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SI - Sinaloa with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SI - Sinaloa with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SI  Kilogram

Company Admin User should be able to add a new Jurisdiction to SK - Saskatchewan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SK - Saskatchewan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SK - Saskatchewan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SK - Saskatchewan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SK  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   SK  Pound
Company Admin User should be able to remove a Jurisdiction to SK - Saskatchewan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SK - Saskatchewan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SK - Saskatchewan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SK  Pound
Company Admin User should be able to add a new Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SK - Saskatchewan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SK - Saskatchewan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SK  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  SK  Kilogram
Company Admin User should be able to remove a Jurisdiction to SK - Saskatchewan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SK - Saskatchewan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SK - Saskatchewan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SK  Kilogram

Company Admin User should be able to add a new Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SL - San Luis Potosi as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SL - San Luis Potosi  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SL  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   SL  Pound
Company Admin User should be able to remove a Jurisdiction to SL - San Luis Potosi with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SL - San Luis Potosi with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SL - San Luis Potosi with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SL  Pound
Company Admin User should be able to add a new Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SL - San Luis Potosi as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SL - San Luis Potosi  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  SL  Kilogram
Company Admin User should be able to remove a Jurisdiction to SL - San Luis Potosi with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SL - San Luis Potosi with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SL - San Luis Potosi with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SL  Kilogram

Company Admin User should be able to add a new Jurisdiction to SO - Sonora with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SO - Sonora with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting SO - Sonora as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SO - Sonora  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    SO  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   SO  Pound
Company Admin User should be able to remove a Jurisdiction to SO - Sonora with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SO - Sonora with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to SO - Sonora with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  SO  Pound
Company Admin User should be able to add a new Jurisdiction to SO - Sonora with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to SO - Sonora with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting SO - Sonora as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  SO - Sonora  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  SO  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  SO  Kilogram
Company Admin User should be able to remove a Jurisdiction to SO - Sonora with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to SO - Sonora with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to SO - Sonora with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    SO  Kilogram

Company Admin User should be able to add a new Jurisdiction to TB - Tabasco with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TB - Tabasco with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TB - Tabasco as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TB - Tabasco  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TB  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   TB  Pound
Company Admin User should be able to remove a Jurisdiction to TB - Tabasco with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TB - Tabasco with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TB - Tabasco with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TB  Pound
Company Admin User should be able to add a new Jurisdiction to TB - Tabasco with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TB - Tabasco with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TB - Tabasco as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TB - Tabasco  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TB  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  TB  Kilogram
Company Admin User should be able to remove a Jurisdiction to TB - Tabasco with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TB - Tabasco with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TB - Tabasco with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TB  Kilogram

Company Admin User should be able to add a new Jurisdiction to TL - Tlaxcala with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TL - Tlaxcala with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TL - Tlaxcala as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TL - Tlaxcala  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TL  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   TL  Pound
Company Admin User should be able to remove a Jurisdiction to TL - Tlaxcala with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TL - Tlaxcala with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TL - Tlaxcala with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TL  Pound
Company Admin User should be able to add a new Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TL - Tlaxcala as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TL - Tlaxcala  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TL  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  TL  Kilogram
Company Admin User should be able to remove a Jurisdiction to TL - Tlaxcala with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TL - Tlaxcala with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TL - Tlaxcala with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TL  Kilogram

Company Admin User should be able to add a new Jurisdiction to TM - Tamaulipas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TM - Tamaulipas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TM - Tamaulipas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TM - Tamaulipas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TM  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   TM  Pound
Company Admin User should be able to remove a Jurisdiction to TM - Tamaulipas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TM - Tamaulipas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TM - Tamaulipas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TM  Pound
Company Admin User should be able to add a new Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TM - Tamaulipas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TM - Tamaulipas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TM  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  TM  Kilogram
Company Admin User should be able to remove a Jurisdiction to TM - Tamaulipas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TM - Tamaulipas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TM - Tamaulipas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TM  Kilogram

Company Admin User should be able to add a new Jurisdiction to TN - Tennessee with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TN - Tennessee with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TN - Tennessee as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TN - Tennessee  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TN  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   TN  Pound
Company Admin User should be able to remove a Jurisdiction to TN - Tennessee with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TN - Tennessee with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TN - Tennessee with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TN  Pound
Company Admin User should be able to add a new Jurisdiction to TN - Tennessee with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TN - Tennessee with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TN - Tennessee as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TN - Tennessee  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TN  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  TN  Kilogram
Company Admin User should be able to remove a Jurisdiction to TN - Tennessee with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TN - Tennessee with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TN - Tennessee with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TN  Kilogram

Company Admin User should be able to add a new Jurisdiction to TX - Texas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TX - Texas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting TX - Texas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TX - Texas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    TX  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   TX  Pound
Company Admin User should be able to remove a Jurisdiction to TX - Texas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TX - Texas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to TX - Texas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  TX  Pound
Company Admin User should be able to add a new Jurisdiction to TX - Texas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to TX - Texas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting TX - Texas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  TX - Texas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  TX  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  TX  Kilogram
Company Admin User should be able to remove a Jurisdiction to TX - Texas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to TX - Texas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to TX - Texas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    TX  Kilogram

Company Admin User should be able to add a new Jurisdiction to UT - Utah with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to UT - Utah with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting UT - Utah as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  UT - Utah  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    UT  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   UT  Pound
Company Admin User should be able to remove a Jurisdiction to UT - Utah with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to UT - Utah with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to UT - Utah with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  UT  Pound
Company Admin User should be able to add a new Jurisdiction to UT - Utah with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to UT - Utah with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting UT - Utah as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  UT - Utah  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  UT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  UT  Kilogram
Company Admin User should be able to remove a Jurisdiction to UT - Utah with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to UT - Utah with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to UT - Utah with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    UT  Kilogram

Company Admin User should be able to add a new Jurisdiction to VA - Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VA - Virginia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VA - Virginia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VA - Virginia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   VA  Pound
Company Admin User should be able to remove a Jurisdiction to VA - Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VA - Virginia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VA - Virginia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VA  Pound
Company Admin User should be able to add a new Jurisdiction to VA - Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VA - Virginia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VA - Virginia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VA - Virginia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  VA  Kilogram
Company Admin User should be able to remove a Jurisdiction to VA - Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VA - Virginia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VA - Virginia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VA  Kilogram

Company Admin User should be able to add a new Jurisdiction to VE - Veracruz with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VE - Veracruz with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VE - Veracruz as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VE - Veracruz  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VE  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   VE  Pound
Company Admin User should be able to remove a Jurisdiction to VE - Veracruz with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VE - Veracruz with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VE - Veracruz with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VE  Pound
Company Admin User should be able to add a new Jurisdiction to VE - Veracruz with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VE - Veracruz with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VE - Veracruz as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VE - Veracruz  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VE  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  VE  Kilogram
Company Admin User should be able to remove a Jurisdiction to VE - Veracruz with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VE - Veracruz with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VE - Veracruz with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VE  Kilogram

Company Admin User should be able to add a new Jurisdiction to VI - Virgin Islands with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VI - Virgin Islands with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VI - Virgin Islands as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VI - Virgin Islands  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VI  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   VI  Pound
Company Admin User should be able to remove a Jurisdiction to VI - Virgin Islands with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VI - Virgin Islands with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VI - Virgin Islands with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VI  Pound
Company Admin User should be able to add a new Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VI - Virgin Islands as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VI - Virgin Islands  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  VI  Kilogram
Company Admin User should be able to remove a Jurisdiction to VI - Virgin Islands with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VI - Virgin Islands with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VI - Virgin Islands with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VI  Kilogram

Company Admin User should be able to add a new Jurisdiction to VT - Vermont with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VT - Vermont with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting VT - Vermont as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VT - Vermont  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    VT  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   VT  Pound
Company Admin User should be able to remove a Jurisdiction to VT - Vermont with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VT - Vermont with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to VT - Vermont with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  VT  Pound
Company Admin User should be able to add a new Jurisdiction to VT - Vermont with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to VT - Vermont with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting VT - Vermont as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  VT - Vermont  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  VT  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  VT  Kilogram
Company Admin User should be able to remove a Jurisdiction to VT - Vermont with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to VT - Vermont with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to VT - Vermont with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    VT  Kilogram

Company Admin User should be able to add a new Jurisdiction to WA - Washington with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WA - Washington with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WA - Washington as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WA - Washington  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WA  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   WA  Pound
Company Admin User should be able to remove a Jurisdiction to WA - Washington with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WA - Washington with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WA - Washington with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WA  Pound
Company Admin User should be able to add a new Jurisdiction to WA - Washington with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WA - Washington with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WA - Washington as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WA - Washington  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WA  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  WA  Kilogram
Company Admin User should be able to remove a Jurisdiction to WA - Washington with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WA - Washington with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WA - Washington with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WA  Kilogram

Company Admin User should be able to add a new Jurisdiction to WI - Wisconsin with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WI - Wisconsin with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WI - Wisconsin as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WI - Wisconsin  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WI  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   WI  Pound
Company Admin User should be able to remove a Jurisdiction to WI - Wisconsin with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WI - Wisconsin with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WI - Wisconsin with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WI  Pound
Company Admin User should be able to add a new Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WI - Wisconsin as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WI - Wisconsin  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WI  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  WI  Kilogram
Company Admin User should be able to remove a Jurisdiction to WI - Wisconsin with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WI - Wisconsin with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WI - Wisconsin with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WI  Kilogram

Company Admin User should be able to add a new Jurisdiction to WV - West Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WV - West Virginia with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WV - West Virginia as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WV - West Virginia  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WV  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   WV  Pound
Company Admin User should be able to remove a Jurisdiction to WV - West Virginia with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WV - West Virginia with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WV - West Virginia with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WV  Pound
Company Admin User should be able to add a new Jurisdiction to WV - West Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WV - West Virginia with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WV - West Virginia as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WV - West Virginia  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WV  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  WV  Kilogram
Company Admin User should be able to remove a Jurisdiction to WV - West Virginia with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WV - West Virginia with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WV - West Virginia with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WV  Kilogram

Company Admin User should be able to add a new Jurisdiction to WY - Wyoming with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WY - Wyoming with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting WY - Wyoming as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WY - Wyoming  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    WY  USA  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   WY  Pound
Company Admin User should be able to remove a Jurisdiction to WY - Wyoming with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WY - Wyoming with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to WY - Wyoming with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  WY  Pound
Company Admin User should be able to add a new Jurisdiction to WY - Wyoming with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to WY - Wyoming with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting WY - Wyoming as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  WY - Wyoming  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  WY  USA  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  WY  Kilogram
Company Admin User should be able to remove a Jurisdiction to WY - Wyoming with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to WY - Wyoming with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to WY - Wyoming with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    WY  Kilogram

Company Admin User should be able to add a new Jurisdiction to YT - Yukon Territory with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to YT - Yukon Territory with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting YT - Yukon Territory as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YT - Yukon Territory  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    YT  CAN  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   YT  Pound
Company Admin User should be able to remove a Jurisdiction to YT - Yukon Territory with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to YT - Yukon Territory with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to YT - Yukon Territory with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  YT  Pound
Company Admin User should be able to add a new Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting YT - Yukon Territory as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YT - Yukon Territory  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  YT  CAN  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  YT  Kilogram
Company Admin User should be able to remove a Jurisdiction to YT - Yukon Territory with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to YT - Yukon Territory with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to YT - Yukon Territory with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    YT  Kilogram

Company Admin User should be able to add a new Jurisdiction to YU - Yucatan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to YU - Yucatan with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting YU - Yucatan as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YU - Yucatan  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    YU  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   YU  Pound
Company Admin User should be able to remove a Jurisdiction to YU - Yucatan with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to YU - Yucatan with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to YU - Yucatan with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  YU  Pound
Company Admin User should be able to add a new Jurisdiction to YU - Yucatan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to YU - Yucatan with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting YU - Yucatan as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  YU - Yucatan  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  YU  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  YU  Kilogram
Company Admin User should be able to remove a Jurisdiction to YU - Yucatan with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to YU - Yucatan with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to YU - Yucatan with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    YU  Kilogram

Company Admin User should be able to add a new Jurisdiction to ZA - Zacatecas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ZA - Zacatecas with Pound as weight unit
     ...  The user should have access to the Setup - Tractors - Jurisdiction section
     ...  The user should be able to Create a new Jurisdiction selecting ZA - Zacatecas as province and Pound as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ZA - Zacatecas  Pound
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit    ZA  MEX  Pound
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}   ZA  Pound
Company Admin User should be able to remove a Jurisdiction to ZA - Zacatecas with Pound as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205304  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ZA - Zacatecas with Pound as weight unit
     ...  The user should be able to Remove Jurisdictions to ZA - Zacatecas with Pound as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove  ZA  Pound
Company Admin User should be able to add a new Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can Add a new Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     ...  The user should be able to Create a new Jurisdiction selecting ZA - Zacatecas as province and Kilogram as weight unit
     ...  The user should be able to see State/Province code, country, and the weight unit
     ...  Jurisdiction should be on  tractor_jurisdiction table on driveline database
     Fill Up Gvwr field and Click on Add Button  ZA - Zacatecas  Kilogram
     Validate on Screen if Jurisdiction has State/Province code, country and the weight unit  ZA  MEX  Kilogram
     Validate if Jurisdiction is on Database  ${CompanyAdminTractor}  ZA  Kilogram
Company Admin User should be able to remove a Jurisdiction to ZA - Zacatecas with Kilogram as weight unit
     [Tags]  JIRA:PORT-173  qTest:40205347  indepth
     [Documentation]  Validate if a Company Admin user can remove Jurisdictions to ZA - Zacatecas with Kilogram as weight unit
     ...  The user should be able to Remove Jurisdictions to ZA - Zacatecas with Kilogram as weight unit by Right Click on Jurisdiction and Then Click on Remove
     Right Click on Jurisdiction and Then Click on Remove    ZA  Kilogram

Company Admin User should not be able to add a new Jurisdiction with GVWR value higher than 9999999
     [Tags]  JIRA:PORT-173  qTest:40205411
     [Documentation]  Validate that a Company Admin user cannot Add a new Jurisdiction with a value higher than 9999999 in the GVWR field.
     ...  A message should appear saying is not possible to add Jurisdiction with a value higher than 9999999 in the GVWR field
     Set Test Variable  ${gvwr}  10000000
     Fill Up Gvwr field and Click on Add Button  DG - Durango  Pound
     Validate on Screen that Jurisdiction was not added
Company Admin User should not be able to add a new Jurisdiction with the GVWR field empty
     [Tags]  JIRA:PORT-173  qTest:40205419
     [Documentation]  Validate that a Company Admin user cannot Add a new Jurisdiction with the GVWR field empty
     ...  A message should appear saying is not possible to add Jurisdiction with empty in the GVWR field
     Set Test Variable  ${gvwr}  ${EMPTY}
     Fill Up Gvwr field and Click on Add Button  VI - Virgin  Pound
     Validate on Screen that Jurisdiction was not added
Company Admin User should not be able to add a new Jurisdiction with the State/Province field empty
     [Tags]  JIRA:PORT-173  qTest:40205431
     [Documentation]  Validate that a Company Admin user cannot Add a new Jurisdiction with State/Province field empty
     ...  A message should appear saying is not possible to add Jurisdiction with State/Province field empty
     Fill Up Gvwr field and Click on Add Button  ${EMPTY}  Pound
     Validate on Screen that Jurisdiction was not added
    [Teardown]  Click Driveline Button  Close

Company Admin should be able to change the tractor status to Inactive
    [Tags]  JIRA:PORT-162  qTest:40025369
    [Documentation]  Validate if a Company Admin User level can change a tractor status to Inactive
    ...  by Clicking on the Tractor and then clicking on Retire button in Setup - Tractors screen.
    ...  Validate if a Company Admin can find tractors in In-active status
    ...  using the Search tool in Setup - Tractors screen.
    ...  Validate if a Company Admin can see the Tractor identified by the Status
    ...  as I when Inactive in Setup - Tractors screen.
    ...  Validate on Database if active_status column was populates with I.
    Click on Tractor and Then Click on Retire  ${CompanyAdminTractor}
    Select In-Active Status and Then Click on Search  ${CompanyAdminTractor}
    Validate on Screen if Tractor Status Was Changed for Inactive  ${CompanyAdminTractor}
    Validate on Database if Tractor Status Was Changed for Inactive  ${CompanyAdminTractor}
Company Admin should be able to change the tractor status to Active
    [Tags]  JIRA:PORT-162  qTest:40025381
    [Documentation]  Validate if a Company Admin can change a tractor status to Active
    ...  by Clicking on the Tractor and then clicking on Activate button in Setup - Tractors screen.
    ...  Validate if a Company Admin can find tractors in Active status
    ...  using the Search tool in Setup - Tractors screen.
    ...  Validate if a Company Admin can see the Tractor identified by the Status
    ...  as A when Inactive in Setup - Tractors screen.
    ...  Validate on Database if active_status column was populates with A.
    Click on Tractor and Then Click Activate  ${CompanyAdminTractor}
    Select Active Status and Then Click on Search  ${CompanyAdminTractor}
    Validate on Screen if Tractor Status Was Changed for Active  ${CompanyAdminTractor}
    Validate on Database if Tractor Status Was Changed for Active  ${CompanyAdminTractor}

Company Admin should be able to close the Tractors tab
    [Tags]  JIRA:PORT-162  qTest:40025381
    [Documentation]  Validate if an Company Admin can close the Tractors tab and do logout
    Right Click on Tractors Tab and Then Close
    [Teardown]  Navigate to My Account and Then Click on Logout

Admin Super User should be able to remove tractors created by Admin Super User
    [Tags]  JIRA:PORT-166  qTest:40009246
    [Documentation]  Validate if an Admin in Super User level can remove tractors
    ...  The user should have access to Admin - Tractor section.
    ...  The user should be able to find tractors using the Search tool in the Admin - Tractors section.
    ...  The user should be able to Remove Tractors.
    [Setup]  Input Admin Super User Level Credentials and Then Click on Login
    Navigate to Admin - Fuel Tax - Tractors
    Fill Up Company Name Field and Click on Refresh Button  ${SuperUserTractor}  ${DrivelineAdminCompany}
    Right Click on Tractor and Then Click on Remove  ${SuperUserTractor}
Admin Super User should be able to remove tractors created by an Admin Support Level user
    [Tags]  JIRA:PORT-166  qTest:40009246
    [Documentation]  Validate if an Admin in Super User level can remove tractors
    ...  The user should have access to Admin - Tractor section.
    ...  The user should be able to find tractors using the Search tool in the Admin - Tractors section.
    ...  The user should be able to Remove Tractors.
    [Setup]  Navigate to Admin - Fuel Tax - Tractors
    Fill Up Company Name Field and Click on Refresh Button  ${SupportLevelTractor}  ${DrivelineAdminCompany}
    Right Click on Tractor and Then Click on Remove  ${SupportLevelTractor}
Admin Super User should be able to remove tractors created by Company Admin user
    [Tags]  JIRA:PORT-166  qTest:40009246  refactor
    [Documentation]  Validate if an Admin in Super User level can remove tractors
    ...  The user should have access to Admin - Tractor section.
    ...  The user should be able to find tractors using the Search tool in the Admin - Tractors section.
    ...  The user should be able to Remove Tractors.
    [Setup]  Navigate to Admin - Fuel Tax - Tractors
    Fill Up Company Name Field and Click on Refresh Button  ${CompanyAdminTractor}  ${DrivelineClientCompany}
    Right Click on Tractor and Then Click on Remove  ${CompanyAdminTractor}
    [Teardown]  Navigate to My Account and Then Click on Logout

*** Keywords ***
Right Click on Tractors Tab and Then Close
    Unselect Frame
    Wait Until Page Contains Element  //span[contains(@id,'tab')]/span[contains(text(),'Tractors')]
    Open Context Menu  //span[contains(@id,'tab')]/span[contains(text(),'Tractors')]
    Click Element  //a[contains(@id,'menuitem')]/span[contains(text(),'Close Tab')]
Navigate to Setup - Tractors
    Wait Until Page Contains  Setup
    Execute JavaScript  DrivelineCore.openTab('MANAGE_TRACTOR_PAGE_ID');
    Wait Until Page Contains Element  //iframe[contains(@src,'/driveline/core/ManageTractorsExt.action?NewTractorPage&disableClick=false')]
    ${loaderId}  Generate Random String  7  [NUMBERS]
    Assign ID to Element  //*/td[img[contains(@src, '/driveline/common/images/icon/loading16.gif')]]  Loader${loaderId}
    Wait Until Element Is Not Visible  Loader${loaderId}
    ${loaderId}  Generate Random String  7  [NUMBERS]
    Assign ID to Element   //*/div[contains(@id, 'loadmask') and text()='Loading...']  Loader${loaderId}
    Wait Until Element Is Not Visible  Loader${loaderId}
Click on Add Tractor Button
    Assign ID to Element  //iframe[contains(@src,'/driveline/core/ManageTractorsExt.action?NewTractorPage&disableClick=false')]  TractorIframe
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  3 sec  Execute JavaScript  frames["TractorIframe"].contentDocument.getElementById("tractorAddButtonId").click();
    Wait Until Element Is Not Visible  //*/div[contains(@id, 'loadmask') and text()='Loading...']
    Wait Until Element Is Not Visible  //img[contains(@src, '/driveline/common/images/icon/loading16.gif')]
Click on Jurisdictions Button
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  3 sec  Execute JavaScript  document.getElementById("jurisdictionsToolId").click();
    Wait Until Element Is Not Visible  //*/div[contains(@id, 'loadmask') and text()='Loading...']
    Wait Until Element Is Not Visible  //img[contains(@src, '/driveline/common/images/icon/loading16.gif')]
Fill Up Reference ID Field and Click on Save Button
    [Arguments]  ${tractorReference}
    Select Frame  //iframe[contains(@src,'/driveline/core/ManageTractorsExt.action?NewTractorPage&disableClick=false')]
    Wait Until Element Is Visible  companyTractor.equipmentOwnershipType
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  3 sec  Check if values was inserted
    Input Text  name=companyTractor.tractorRefNo  ${tractorReference}
    Execute JavaScript  document.getElementById("addEditWinToolsSaveButtonId").click();
    Wait Until Element is Visible  //td/div[contains(text(),'${tractorReference}')]
Check if values was inserted
    ${companyTractor}  get value  companyTractor.gvwrAmount
    ${fuelTaxCompanyTractor}  get value  fuelTaxCompanyTractor.maxAxleCnt
    Should be equal  ${companyTractor}  80000
    Should be equal  ${fuelTaxCompanyTractor}  5
Check if input was filled up
    [Arguments]  ${text}  ${inputfield}
    ${currentText}  get value  ${inputfield}
    Should contain  ${currentText}  ${text}
Search a Tractor by status
    [Arguments]  ${tractorReference}  ${status}
    Wait Until Element is Visible  filter.status
    Click Element  //div[contains(@id, 'trigger-picker')]
    Click Element  //li[contains(text(), '${status}')]
    Click Driveline Button  Search
    Wait Until Element is Visible  //td/div[contains(text(),'${tractorReference}')]
Navigate to Admin - Fuel Tax - Tractors
    Unselect Frame
    Execute JavaScript  window.location.href='Main.action';
    Wait Until Page Contains  Admin
    Execute JavaScript  DrivelineCore.openTab('ADMIN_TRACTORS_PAGE_ID');
    Wait Until Page Contains Element  //iframe[contains(@src,'/driveline/admin/ManageFuelTaxTractors.action?&disableClick=false')]
    ${loaderId}  Generate Random String  7  [NUMBERS]
    Assign ID to Element  //*/td[img[contains(@src, '/driveline/common/images/icon/loading16.gif')]]  Loader${loaderId}
    Wait Until Element Is Not Visible  Loader${loaderId}
    ${loaderId}  Generate Random String  7  [NUMBERS]
    Assign ID to Element   //*/div[contains(@id, 'loadmask') and text()='Loading...']  Loader${loaderId}
    Wait Until Element Is Not Visible  Loader${loaderId}
Fill Up Company Name Field and Click on Refresh Button
    [Arguments]  ${tractorReference}  ${companyID}
    Wait Until Page Contains Element  //iframe[contains(@src,'/driveline/admin/ManageFuelTaxTractors.action?&disableClick=false')]
    Select Frame  //iframe[contains(@src,'/driveline/admin/ManageFuelTaxTractors.action?&disableClick=false')]
    Wait Until Element is Visible  selectedCompany
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  1 sec  Search Tractor by Company Name  ${tractorReference}  ${companyID}
Search Tractor by Company Name
    [Arguments]  ${tractorReference}  ${companyID}
    ${fullCompanyName}  Set Variable If  '${companyID}'=='57803'  57803 - Fuel Tax Auto-Test1  57802 - AutoTest
    Click Element  selectedCompany
    Input Text  selectedCompany  ${fullCompanyName}
    Check if input was filled up  ${fullCompanyName}  selectedCompany
    Click Driveline Button  Refresh
    Wait Until Element is Visible  //td/div[contains(text(),'${tractorReference}')]
    Unselect Frame
Right Click on Tractor and Then Click on Remove
    [Arguments]  ${tractorReference}
    Wait Until Page Contains Element  //iframe[contains(@src,'/driveline/admin/ManageFuelTaxTractors.action?&disableClick=false')]
    Select Frame  //iframe[contains(@src,'/driveline/admin/ManageFuelTaxTractors.action?&disableClick=false')]
    Click Element  //td/div[contains(text(),'${tractorReference}')]
    Open Context Menu  //td/div[contains(text(),'${tractorReference}')]
    Click Element  //a[contains(@id, 'menuitem')]/span[contains(text(), 'Remove')]
    Wait Until Element is Visible  //div[contains(@id,'messagebox') and contains(text(),'Confirm')]
    Click Driveline Button  Yes
    ${loaderId}  Generate Random String  7  [NUMBERS]
    Assign ID to Element   //*/div[contains(@id, 'loadmask') and text()='Loading...']  Loader${loaderId}
    Wait Until Element Is Not Visible  Loader${loaderId}
    Unselect Frame
Click on Tractor and Then Click on Retire
    [Arguments]  ${tractorReference}
    Click Element  //td/div[contains(text(),'${tractorReference}')]
    Click Driveline Button  Retire
    Wait Until Element Is Not Visible  //td/div[contains(text(),'${tractorReference}')]
Click on Tractor and Then Click Activate
    [Arguments]  ${tractorReference}
    Click Element  //td/div[contains(text(),'${tractorReference}')]
    Click Driveline Button  Activate
    Wait Until Element Is Not Visible  //td/div[contains(text(),'${tractorReference}')]
Select In-Active Status and Then Click on Search
    [Arguments]  ${tractorReference}
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  3 sec  Search a Tractor by status  ${tractorReference}  In-Active
Select Active Status and Then Click on Search
    [Arguments]  ${tractorReference}
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  3 sec  Search a Tractor by status  ${tractorReference}  Active
Validate on Screen if Tractor Status Was Changed for Inactive
    [Arguments]  ${tractorReference}
    ${status}  Get Text  //td/div[contains(text(),'${tractorReference}')]/parent::td/following-sibling::td[2]/div
    Should be Equal  ${status}  I
Validate on Screen if Tractor Status Was Changed for Active
    [Arguments]  ${tractorReference}
    ${status}  Get Text  //td/div[contains(text(),'${tractorReference}')]/parent::td/following-sibling::td[2]/div
    Should be Equal  ${status}  A
Validate on Screen if Jurisdiction has State/Province code, country and the weight unit
    [Arguments]  ${stateProvinceCode}  ${country}  ${weightUOM}
    ${weightUOM}  Set Variable If  '${weightUOM}'=='Pound'  LB  KG
    Wait Until Element is Visible  //td/div[contains(text(),'${country}')]
    Wait Until Element is Visible  //td/div[contains(text(),'${stateProvinceCode}')]
    Wait Until Element is Visible  //td/div[contains(text(),'${weightUOM}')]
Validate on Screen that Jurisdiction was not added
    Element Should Not Be Visible  //td/div[contains(text(),'LB')]
Input Admin Super User Level Credentials and Then Click on Login
    Log Into Driveline  ${drivelineusername}  ${drivelinepassword}
Input an Admin Support level Credentials and Then Click on Login
    Log Into Driveline  ${DrivelineSupportUsername}  ${DrivelineSupportPassword}
Input Company Admin Credentials and Then Click on Login
    Log Into Driveline  ${DrivelineCompanyAdminUsername}  ${DrivelineCompanyAdminPassword}
Validate on Database if Tractor Status Was Changed for Inactive
    [Arguments]  ${tractorReference}
    ${statusdb}  Query And Strip  SELECT active_status FROM company_tractor WHERE tractor_ref_no='${tractorReference}';
    Should be Equal  ${statusdb}  I
Validate on Database if Tractor Status Was Changed for Active
    [Arguments]  ${tractorReference}
    ${statusdb}  Query And Strip  SELECT active_status FROM company_tractor WHERE tractor_ref_no='${tractorReference}';
    Should be Equal  ${statusdb}  A
Navigate to My Account and Then Click on Logout
    Click Driveline Button  My Account
    Click Element  //a/span[text()="Logout"]
    Wait Until Element is Visible  username
    Wait Until Element is Visible  password
Remove the Tractor
    [Arguments]  ${tractorReference}  ${companyID}
    Navigate to Admin - Fuel Tax - Tractors
    Fill Up Company Name Field and Click on Refresh Button  ${tractorReference}  ${companyID}
    Right Click on Tractor and Then Click on Remove  ${tractorReference}
Start Suite
    Set Selenium Implicit Wait  1
    Set Selenium Timeout  20
    Open Browser to Driveline
    ${reference}  Generate Random String  5  [NUMBERS]
    Set Suite Variable  ${SuperUserTractor}  AdmSU_${reference}
    Set Suite Variable  ${SupportLevelTractor}  Support_${reference}
    Set Suite Variable  ${CompanyAdminTractor}  AdmCo_${reference}
    ${gvwr}  Generate Random String  5  [NUMBERS]
    ${gvwr}  Remove String  ${gvwr}  0
    Set Suite Variable  ${gvwr}
    Get Into DB  driveline
Click on Tractor and Then Click on Jurisdiction
    [Arguments]  ${tractorReference}
    Click Element  //td/div[contains(text(),'${tractorReference}')]
    Click on Jurisdictions Button
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  3 sec  Check if input was filled up  Pound  tractorJurisdiction.weightUom
Fill Up Gvwr field and Click on Add Button
    [Arguments]  ${stateProvince}  ${weightUom}
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  3 sec  Input Gvwr Weight  ${stateProvince}  ${weightUom}
Input Gvwr Weight
    [Arguments]  ${stateProvince}  ${weightUom}
    Input Text  name=tractorJurisdiction.stateProvCode  ${stateProvince}
    Check if input was filled up  ${stateProvince}  tractorJurisdiction.stateProvCode
    Input Text  name=tractorJurisdiction.registeredGvwrWeight  ${gvwr}
    Check if input was filled up  ${gvwr}  tractorJurisdiction.registeredGvwrWeight
    Click Element  //input[contains(@name, "tractorJurisdiction.weightUom")]/parent::div/following-sibling::div[1]
    Click Element  //li[contains(text(), '${weightUom}')]
    Check if input was filled up  ${weightUom}  tractorJurisdiction.weightUom
    Execute JavaScript  document.getElementById("jurisMenuAddButtonId").click();
Validate if Jurisdiction is on Database
    [Arguments]  ${tractorReference}  ${state_prov_code}  ${weight_uom}
    ${weight_uom}  Set Variable If  '${weight_uom}'=='Pound'  LB  KG
    ${query}  catenate  SELECT tjurisdict.state_prov_code, tjurisdict.weight_uom, tjurisdict.registered_gvwr_weight FROM tractor_jurisdiction tjurisdict, company_tractor tcompany
    ...  WHERE tjurisdict.tractor_id = tcompany.tractor_id
    ...  AND tcompany.tractor_ref_no ='${tractorReference}'
    ...  AND tjurisdict.active_status = 'A'
    ...  AND tjurisdict.state_prov_code = '${state_prov_code}';
    ${jurisdiction}  Query And Strip To Dictionary  ${query}
    Should be Equal As Strings  ${jurisdiction.state_prov_code}  ${state_prov_code}
    Should be Equal As Strings  ${jurisdiction.weight_uom}  ${weight_uom}
    Should be Equal As Strings  ${jurisdiction.registered_gvwr_weight}  ${gvwr}
Right Click on Jurisdiction and Then Click on Remove
    [Arguments]  ${state_prov_code}  ${weight_uom}
    ${weight_uom}  Set Variable If  '${weight_uom}'=='Pound'  LB  KG
    Wait Until Keyword Succeeds  ${TIMEOUT} sec  6 sec  Open Context Menu and Remove Jurisdiction  ${state_prov_code}  ${weight_uom}
Open Context Menu and Remove Jurisdiction
    [Arguments]  ${state_prov_code}  ${weight_uom}
    ${jurisdiction}  catenate  //td/div[contains(text(),'${gvwr}')]/parent::td/preceding-sibling::td[2]/div[contains(text(),'${state_prov_code}')]/parent::td/following-sibling::td[3]/div[contains(text(),'${weight_uom}')]
    Click Element  ${jurisdiction}
    Open Context Menu  ${jurisdiction}
    Click Element  //a[contains(@id, 'jurisMenuListRemove')]/span[contains(text(), 'Remove')]
    Wait Until Element Is Not Visible  ${jurisdiction}
