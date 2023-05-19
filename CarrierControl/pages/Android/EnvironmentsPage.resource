*** Settings ***
Library    AppiumLibrary
Resource    Activities.resource

*** Variables ***
${__PACKAGE_NAME}    com.efsllc.efscarriercontrol.stage
${DIT_ENVIRONMENT}    id=${__PACKAGE_NAME}:id/dit_selector
${DEV_ENVIRONMENT}    id=${__PACKAGE_NAME}:id/dev_selector
${SIT_ENVIRONMENT}    id=${__PACKAGE_NAME}:id/sit_selector
${PARTNER_ENVIRONMENT}    id=${__PACKAGE_NAME}:id/partner_selector

*** Keywords ***
Select "${env}" Environment
    TRY
        Wait Until Page Contains Element    ${${env.replace(' ', '_').upper()}_ENVIRONMENT}
        Click Element    ${${env.replace(' ', '_').upper()}_ENVIRONMENT}
    EXCEPT    message
        Fail    Not a valid environment
    END