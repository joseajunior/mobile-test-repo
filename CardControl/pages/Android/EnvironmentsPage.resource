*** Settings ***
Library    AppiumLibrary
Resource    Activities.resource

*** Variables ***
${DIT_ENVIRONMENT}    com.efsllc.efsmobileapp.stage:id/dit_selector
${TEST_ENVIRONMENT}    com.efsllc.efsmobileapp.stage:id/test_selector
${DEV_ENVIRONMENT}    com.efsllc.efsmobileapp.stage:id/dev_selector
${SIT_ENVIRONMENT}    com.efsllc.efsmobileapp.stage:id/sit_selector
${DIT_AWS_ENVIRONMENT}    com.efsllc.efsmobileapp.stage:id/dit_aws_selector
${PARTNER_ENVIRONMENT}    com.efsllc.efsmobileapp.stage:id/partner_selector

*** Keywords ***
Select "${env}" Environment
    TRY
        Wait Until Page Contains Element    id=${${env.replace(' ', '_').upper()}_ENVIRONMENT}
        Click Element    id=${${env.replace(' ', '_').upper()}_ENVIRONMENT}
    EXCEPT    message
        Fail    Not a valid environment
    END