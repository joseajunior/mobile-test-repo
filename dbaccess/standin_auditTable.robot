*** Settings ***
Library  otr_robot_lib.support.PyLibrary
Library  otr_robot_lib.ui.web.PySelenium
Library  otr_robot_lib.support.PyString
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.setup.PySetup
Library  otr_robot_lib.ssh.PySSH   ${app_ssh_host}
Resource  otr_robot_lib/robot/eManagerKeywords.robot

*** Test Cases ***
Test Audit Table vs Standin Audit Table
    [Tags]  JIRA:ATLAS-2275  qTest:118473162  PI:15  API:Y
    [Documentation]  Show the functionality of switching the value=(Y or N) of setting table where
    ...  name=setting.use_standin_audit_table.
    Check Status Of setting.use_standin_audit_table Flag
    Get Counts To Confirm Correct Table Is Being Used
    Toggle setting.value Where name=use_standin_audit_table
    Wait For JBoss Server To Update
    Get Counts To Confirm Correct Table Is Being Used
    Toggle setting.value Where name=use_standin_audit_table
    Disconnect From Database

*** Keywords ***
Check Status Of setting.use_standin_audit_table Flag
    [Tags]  qTest
    [Documentation]  Log into MySQL database and check the status setting.value where name=setting.use_standin_audit_table
    ...  SELECT value FROM setting WHERE name = 'use_standin_audit_table'
    ${flag}  Query And Strip  SELECT value FROM setting WHERE name = 'use_standin_audit_table';  db_instance=MySQL
	Set Test Variable  ${flag}
	Disconnect From Database

Get Table Count
    ${auditCount}  Query And Strip  SELECT COUNT(*) FROM audit.audit AS audit_rows;  db_instance=MySQL
    Set Test Variable  ${auditCount}
    ${standinAuditCount}  Query And Strip  SELECT COUNT(*) FROM audit.standin_audit AS standin_rows;  db_instance=MySQL
    Set Test Variable  ${standinAuditCount}

Get Counts To Confirm Correct Table Is Being Used
    [Tags]    qtest
    [Documentation]    Run query a few times with a few second interval between next run to see if switch has happened
    ...  SELECT COUNT(*) FROM audit.audit AS audit_rows
    ...  SELECT COUNT(*) FROM audit.standin_audit AS standin_rows;
    FOR  ${index}  IN RANGE  5
      Get Table Count
      IF  ${index}==0
        Set Test Variable  ${previousAuditCount}  ${auditCount}
        Set Test Variable  ${previousStandinAuditCount}  ${standinAuditCount}
        Continue For Loop
      END
      IF  '${flag}'=='N'
        Evaluate  ${auditCount} >= ${previousAuditCount}
        Evaluate  ${standinAuditCount} == ${previousStandinAuditCount}
      ELSE IF  '${flag}'=='Y'
        Evaluate  ${auditCount} == ${previousAuditCount}
        Evaluate  ${standinAuditCount} >= ${previousStandinAuditCount}
      END
      Set Test Variable  ${previousAuditCount}  ${auditCount}
      Set Test Variable  ${previousStandinAuditCount}  ${standinAuditCount}
      Sleep  5
    END


Toggle setting.value Where name=use_standin_audit_table
    [Tags]  qtest
    [Documentation]    update setting set value='{flag Y or N}' where name='use_standin_audit_table'
    IF  '${flag}'=='N'
#        Execute SQL String  update setting set value='Y' where name='use_standin_audit_table' and `partition` = 'shared';  db_instance=MySQL
        Execute SQL String  dml=update setting set value='Y' where name='use_standin_audit_table' and `partition` = 'shared';  db_instance=MySQL
    ELSE IF  '${flag}'=='Y'
        Execute SQL String  dml=update setting set value='N' where name='use_standin_audit_table' and `partition` = 'shared';  db_instance=MySQL
    END

Wait For JBoss Server To Update
    [Tags]    qtest
    [Documentation]    It normally takes about 3 minutes to switch
    Sleep  180
