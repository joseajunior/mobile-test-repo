*** Settings ***
Library    WexRobotLib.DatabaseLibrary

*** Variables ***
${dbapiModuleName}    psycopg2
${dbHost}             db.stg-internal.wexfleetservice.com
${dbPort}             5432
${dbUsername}         qa_user
${dbPassword}         gCyXR2jMafZT2lxY
${dbName}             driverdash-service

*** Keywords ***
Connect To Postgres Database
    Load Credentials    ${dbapiModuleName}    ${dbName}    ${dbUsername}    ${dbPassword}    ${dbHost}    ${dbPort}

Get Latest Code For "${phonenumber}" Phone Number
    ${query}    Catenate    SELECT access_code_code FROM driverdashservice.access_code WHERE access_code_destination='${phonenumber}' ORDER BY date_created DESC LIMIT 1
    @{result}    Execute Query     query=${query}
    [Return]    ${result[0]['access_code_code']}