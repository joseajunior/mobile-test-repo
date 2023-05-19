*** Settings ***
Library  otr_robot_lib.ssh.PySSH  ${app_ssh_host}
Library  otr_robot_lib.ws.SuitHXSWS
Library  OperatingSystem
Library  otr_robot_lib.support.PyLibrary
Library  otr_model_lib.services.GenericService
Library  sqlalchemy.orm.collections
Library  otr_robot_lib.support.PyMath
Library  otr_robot_lib.setup.PySetup
Library  otr_model_lib.Models

Force Tags  Web Services SuitHXS


*** Variables ***
${logdir}  /home/qaauto/el_robot/AppAttachment/

*** Test Cases ***

Shell App Begin Returns "Here!"
    [Documentation]
    [Tags]  Jira:PORT-573  qtest:51152390
    Call Shell App Begin

add Attachment Endpoint returns successful with file upload
    [Documentation]
    [Tags]  Jira:PORT-573  qtest:51152397
    Call addAttachment

save Shell Application Endpoint returns "Success" when correct input given
    [Documentation]
    [Tags]  Jira:PORT-573  qtest:51152386
    Create valid saveShellApp input
    ${vinput}  set variable  True
    Call Save Shell App  ${goodInput}  ${vinput}

save Shell Application Endpoint returns "Failure" when incorrect input given
    [Documentation]
    [Tags]  Jira:PORT-573  qtest:51152386
    Create invalid/incomplete saveShellApp input
    ${iinput}  set variable  False
    Call Save Shell App  ${badInput}  ${iinput}

*** Keywords ***

Call Shell App Begin
    ${status_code}  ${message}  ${return_message}  ShellAppbegin
    should be equal as integers  ${status_code}  404  The status code from the webservice returned of ${status_code}
        ...  should be equal to 404, but returned ${status_code}
    should be equal as strings  ${message}  Here!  The message returned from the webservice of ${message} should be
        ...  'Here!', but returned ${message}

Call Save Shell App
    [Arguments]  ${inputBody}  ${validInput}
    ${status_code}  ${message}  ${return_message}  saveShellApp  ${inputBody}
    run keyword and return if  ${validInput} == True  Validate valid input Save Shell App  ${status_code}  ${message}  ${return_message}
    run keyword and return if  ${validInput} == False  Validate invalid input Save Shell App  ${status_code}  ${message}  ${return_message}

Create invalid/incomplete saveShellApp input
    ${badInput}  catenate  '{ "cardAppl":"", "contract":"", "comments":"", "emboss":"", "provincialRestriction":"",
        ...  "referralMethod":"", "pnc":""}
    set test variable  ${badInput}  ${badInput}


Create valid saveShellApp input
    ${goodInput}  catenate  request.cardAppl.orgId=102&request.cardAppl.companyName=Michelle%20D%20Donnelly&request.cardAppl.nameOnCards=Freddy%20Man&request.cardAppl.companyOrganizationType=Individual&request.cardAppl.companyPhysicalAddress=454%20Davis%20Drive&request.cardAppl.companyPhysicalCity=Port%20Colborne&request.cardAppl.companyPhysicalState=ON&request.cardAppl.companyPhysicalZip=L3K%203M2&request.cardAppl.companyPhysicalCountry=CA&request.cardAppl.companyMailingAddress=454%20Davis%20Drive&request.cardAppl.companyMailingCity=Port%20Colborne&request.cardAppl.companyMailingState=ON&request.cardAppl.companyMailingZip=L3K%203M2&request.cardAppl.companyMailingCountry=CA&request.cardAppl.companyContact=Micheal%20Donnelly&request.cardAppl.companyContactTelephoneNum=9058356617&request.cardAppl.companyContactCellPhoneNum=9058356617&request.cardAppl.companyContactFaxNum=9058356617&request.cardAppl.companyContactEmail=richard.knowles%40wexinc.com&request.cardAppl.signersName=Micheal%20Donnelly&request.cardAppl.totalNumCompanyVehicles=1&request.cardAppl.employeeId=6&request.cardAppl.associationId=137260&request.cardAppl.shellAirMiles=123456&request.cardAppl.optOutContact=Y&request.cardAppl.companyParentCorporation=CHECKER%20CABS%20RIDESHARE%20PROGRAM&request.cardAppl.salesTerritory=OW&request.cardAppl.applicantSsn=275023117&request.cardAppl.applicantDateOfBirth=1995-01-16&request.cardAppl.applicantName=Michelle%20Donnelly&request.contract.cardType=28&request.contract.receivedVia=ONLINE&request.contract.status=Sales%20Approval&request.contract.language=1&request.contract.shellProducts=FUEL_WASH&request.contract.creditLineAmt=1000&request.contract.cardStyle=312&request.contract.reqTerms=1008&request.contract.terms=1008&request.contract.reqCycleCode=5016&request.contract.cycleCode=5016&request.contract.lockbox=S1&request.contract.issuerId=161738&request.contract.mgrCode=1MAN&request.contract.statementFormat=36&request.contract.billToAddress1=454%20Davis%20Drive&request.contract.billToCity=Port%20Colborne&request.contract.billToState=ON&request.contract.billToZip=L3K%203M2&request.contract.billToCountry=CA&request.contract.shipToAddress1=454%20Davis%20Drive&request.contract.shipToCity=Port%20Colborne&request.contract.shipToState=ON&request.contract.shipToZip=L3K%203M2&request.contract.shipToCountry=CA&request.contract.billToFname=Michelle%20D%20Donnelly&request.contract.serviceCharge=Y&request.contract.autoCreateCards=Y&request.contract.autoComplete=Y&request.contract.restrictCurrency=CAD&request.contract.currency=CAD&request.contract.uom=LITERS&request.contract.numOfCards=1&request.contract.reqPaymentFrequency=MONTHLY&request.contract.reqPaymentMethod=ACH%20Draft&request.contract.bankRoutingNumber=0123123&request.contract.bankAccountNumber=1234567890&request.contract.bankAccountType=D&request.provincialRestriction%5B0%5D.province=AB&request.emboss%5B0%5D.line2=Micheal%20Donnelly%201&request.comments%5B0%5D.comment=Information%20received%20in%20online%20application%3A%3Cbr%2F%3EContact%20Preference%3A%20email%3Cbr%2F%3EPayment%20Method%3A%20null%3Cbr%2F%3EBank%20Reference%20Address%3A%20null%3Cbr%2F%3EInstitution%20Number%3A%20123%3Cbr%2F%3ETransit%20Branch%20Number%3A%20123%3Cbr%2F%3EBank%20Account%20Number%3A%201234567890%3Cbr%2F%3EBank%20Name%3A%20Canada%20Bank%3Cbr%2F%3EBranch%20Name%3A%20Canada%20Bank%3Cbr%2F%3EBranch%20Address%3A%20454%20Davis%20Drive%3Cbr%2F%3EBranch%20City%3A%20Port%20Colborne%3Cbr%2F%3EBranch%20Province%3A%20ON%3Cbr%2F%3EBranch%20Postal%20Code%3A%20L3K%203M%3Cbr%2F%3E&request.comments%5B0%5D.updBy=SHELL%20ONLINE%20APP
    set test variable  ${goodInput}  ${goodInput}

Call addAttachment
    Get File to send
    ${status_code}  ${message}  ${return_message}  addAttachment  ${filename}  ${filepath}  123456
    should be equal as integers  ${status_code}  200  The status code from the webservice returned of ${status_code}
        ...  should be equal to 200, but returned ${status_code}
    should be equal as strings  ${message}  0  The message returned from the webservice of ${message} should be
        ...  '0', but returned ${message}
##TO DO  check the app server to verify the file got uploaded.

Get File to send
    set test variable  ${filename}  TestaddAttachment.txt
    ${filepath}  catenate  ${logdir}TestaddAttachment.txt
    ${header}  Catenate  This file is to be sent through the SuitHXS Restful endpoint /ShellApp/addAttachment.\n
    Create Binary File   ${filepath}  ${header}
    set test variable  ${filepath}  ${filepath}

Get AppId from wrkflw_contract table
    [Arguments]  ${message}
    get into db  TCH
    ${query}  catenate
    ...  Select app_id
    ...  from wrkflw_contract
    ...  Where app_id = ${message}
    ${returnedAppId}  query and strip  ${query}
    [return]  ${returnedAppId}

Validate valid input Save Shell App
    [Arguments]  ${status_code}  ${message}  ${return_message}
    should be equal as integers  ${status_code}  200  The status code from the webservice returned of ${status_code}
        ...  should be equal to 200, but returned ${status_code}
    ${databaseAppId}  Get AppId from wrkflw_contract table  ${message}
    should be equal as strings  ${message}  ${databaseAppId}  The message returned from the webservice of ${message} should be
        ...  ${databaseAppId}, but returned ${message}

Validate invalid input Save Shell App
    [Arguments]  ${status_code}  ${message}  ${return_message}
    should be equal as integers  ${status_code}  200  The status code from the webservice returned of ${status_code}
        ...  should be equal to 200, but returned ${status_code}
    should be equal as strings  ${message}  -1  The message returned from the webservice of ${message} should be
        ...  -1, but returned ${message}