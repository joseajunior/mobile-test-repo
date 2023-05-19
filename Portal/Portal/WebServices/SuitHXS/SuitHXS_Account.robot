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
Library  urllib.parse
Resource  otr_robot_lib/robot/PortalKeywords.robot

Force Tags  Web Services SuitHXS


*** Variables ***
${newEmail}  TestUpdate@efsllc.com
${newAddress1}  13930 HUMBER STATION Dr
${newAddress2}  ha ha
${newCity}  Someplace
${newStateProvince}  UT
${newZipPostal}  82301
${newPhone}  208-555-5566

*** Test Cases ***

Account API endpoint updateContact changes contact information
    [Documentation]  This api endpoint only updates the "BILL_TO" type of contact for thefollowing fields:
        ...  Address1, Address2, City, StateProvince, Zip, phone, OtherPhone, email
    [Tags]  Jira:PORT-580  qtest:51164002
    ${origContact}  Select and save a BILL_TO type contact info
    ${validParam}  Create valid input for udateContact API
    Call updateContact API  ${validParam}
    [teardown]  Return original contact values  ${origContact}


#    *********************This API may not be working and/or used at all********************
#Account API endpoint bumpCredit increases the credit limit temporarily
#    [Documentation]
#    [Tags]  Jira:PORT-580  qtest:51164002
#
#    ${validParam}  Create input for bumpCredit API
#    Call bumpCredit API  ${validParam}



*** Keywords ***

Return original contact values
    [Arguments]  ${originalContact}
        get into db  TCH
    ${query}  catenate  UPDATE contacts
        ...  SET fname = '${originalContact['firstname']}',
        ...  lname = '${originalContact['lastname']}',
        ...  email = '${originalContact['email']}',
        ...  delivery_type = '${originalContact['deliverytype']}',
        ...  fax = '${originalContact['fax']}',
        ...  phone = '${originalContact['phone']}',
        ...  address_1 = '${originalContact['address_1']}',
        ...  address_2 = '${originalContact['address_2']}',
        ...  city = '${originalContact['city']}',
        ...  state = '${originalContact['state']}',
        ...  zip = '${originalContact['zip']}',
        ...  country = '${originalContact['country']}'
        ...  WHERE contact_id = ${originalContact['contactid']}
    execute sql string  dml=${query}
    Disconnect From Database

Select and save a BILL_TO type contact info

    get into db  TCH
    ${query}  catenate  Select
        ...  conta.carrier_id as carrierId, contr.contract_id as contractId, conta.contact_id as contactId,
        ...   conta.delivery_type as deliveryType, conta.email as email, conta.fname as firstName,
        ...  contr.issuer_id as issuerId, conta.lname as lastName, conta.fax as fax, conta.phone as phone,
        ...  conta.address_1 as address_1, conta.address_2 as address_2, conta.city as city, conta.state as state,
        ...  conta.zip as zip, conta.country as country
        ...  from contacts conta, contract contr
        ...  where conta.contract_id = contr.contract_id
        ...  and conta.type='BILL_TO'
        ...  limit 1
    ${result}  Query And Strip To Dictionary  ${query}
    Disconnect From Database
    [return]  ${result}

Create valid input for udateContact API
    [Arguments]  ${issuerID}=105757  ${carrierId}=345016  ${contractId}=390054  ${contactId}=1015711

    ${validParam}  catenate  issuerId=${issuerID}&carrierId=${carrierId}&contractId=${contractId}&contactId=${contactId}
        ...  &email=${newEmail}
        ...  &address1=${newAddress1}
        ...  &address2=${newAddress2}
        ...  &city=${newCity}
        ...  &StateProvince=${newStateProvince}
        ...  &ZipPostal=${newZipPostal}
        ...  &phone=${newPhone}
    [return]  ${validParam}

Call updateContact API
    [Arguments]  ${validParam}
    ${status_code}  ${message}  ${return_message}  ${paramDict}  updateContact  ${validParam}
    should be equal as integers  ${status_code}  200  The status code from the webservice returned of ${status_code}
        ...  should be equal to 200, but returned ${status_code}
    should be equal as strings  ${message}  0  The message returned from the webservice of ${message} should be
        ...  0, but returned ${message}
    Check database values for updateContact  ${paramDict}

Check database values for updateContact
    [Arguments]  ${paramDict}

    ${contractId}=  get from dictionary  ${paramDict}  contractId
    ${contactId}=  get from dictionary  ${paramDict}  contactId

    get into db  TCH
    ${query}  catenate  Select
        ...  conta.carrier_id as carrierId, contr.contract_id as contractId, conta.contact_id as contactId,
        ...  conta.email as email, conta.phone as phone,
        ...  conta.address_1 as address1, conta.address_2 as address2, conta.city as city, conta.state as StateProvince,
        ...  conta.zip as ZipPostal,
        ...  contr.issuer_id as issuerId
        ...  from contacts conta, contract contr
        ...  where conta.contract_id = contr.contract_id
        ...  and contr.contract_id=${contractId}
        ...  and conta.contact_id=${contactId}
    ${dbValues}  query and strip to dictionary  ${query}
    ${dbValues}  Convert the database values to strings  ${dbValues}
    Validate database values match values used for the updateContact API  ${dbValues}  ${paramDict}


Convert the database values to strings
    [Arguments]  ${dbValues}
    ${dbValues}=  evaluate  {str(key): str(value) for key, value in ${dbValues}.items()}
    [return]  ${dbValues}

Validate database values match values used for the updateContact API
    [Arguments]  ${dbValues}  ${paramDict}
    should be equal as strings  ${dbValues['carrierid'].strip()}  ${paramDict}[carrierId]  ignore_case=True
    should be equal  ${dbValues['city'].strip()}  ${paramDict}[city]  ignore_case=True
    should be equal  ${dbValues['contractid'].strip()}  ${paramDict}[contractId]  ignore_case=True
    should be equal  ${dbValues['contactid'].strip()}  ${paramDict}[contactId]  ignore_case=True
    should be equal  ${dbValues['email'].strip()}  ${paramDict}[email]  ignore_case=True
    should be equal  ${dbValues['phone'].strip()}  ${paramDict}[phone]  ignore_case=True
    should be equal  ${dbValues['address1'].strip()}  ${paramDict}[address1]  ignore_case=True
    should be equal  ${dbValues['address2'].strip()}  ${paramDict}[address2]  ignore_case=True
    should be equal  ${dbValues['stateprovince'].strip()}  ${paramDict}[StateProvince]  ignore_case=True
    should be equal  ${dbValues['zippostal'].strip()}  ${paramDict}[ZipPostal]  ignore_case=True
    should be equal  ${dbValues['issuerid'].strip()}  ${paramDict}[issuerId]  ignore_case=True


Create input for bumpCredit API
    [Arguments]  ${issuerID}=105757  ${contractId}=390054  ${bumpAmount}=$500  ${eManagerUserID}=riknowle
        ...  ${comments}=Automation Testing bumpCredit
    ${validParam}  create dictionary  issuerID=${issuerID}  contractId=${contractId}  bumpAmount=${bumpAmount}
       ...  eMgrUserid=${eManagerUserID}  comments=${comments}
    [return]  ${validParam}

Call bumpCredit API
    [Arguments]  ${validParam}

    ${status_code}  ${message}  ${return_message}  ${paramDict}  bumpCredit  ${validParam}
    should be equal as integers  ${status_code}  200  The status code from the webservice returned of ${status_code}
        ...  should be equal to 200, but returned ${status_code}
    should be equal as strings  ${message}  0  The message returned from the webservice of ${message} should be
        ...  0, but returned ${message}
    Check database values for bumpCredit  ${paramDict}

Check database values for bumpCredit
    [Arguments]  ${paramDict}

    ${contractId}=  get from dictionary  ${paramDict}  contractId
    ${contractIdValue}=  get from list  ${contractId}  0
    ${issuerId}=  get from dictionary  ${paramDict}  issuerId
    ${issuerIdValue}=  get from list  ${issuerId}  0
    ${contactId}=  get from dictionary  ${paramDict}  contactId
    ${contactIdValue}=  get from list  ${contactId}  0
    get into db  TCH
    ${query}  catenate  Select
        ...  conta.carrier_id as carrierId, contr.contract_id as contractId, conta.contact_id as contactId,
        ...   conta.delivery_type as deliveryType, conta.email as email, conta.fname as firstName,
        ...  contr.issuer_id as issuerId, conta.lname as lastName,
            ...  (select ig.org_id from issuer_group ig, issuer_misc im where im.issuer_id=${issuerIdValue}
                ...  and im.issuer_group_id = ig.issuer_group_id) as orgId
        ...  from contacts conta, contract contr
        ...  where conta.contract_id = contr.contract_id
        ...  and contr.contract_id=${contractIdValue}
        ...  and conta.contact_id=${contactIdValue}
    ${dbValues}  query and strip to dictionary  ${query}
    should be equal  ${dbValues}  ${paramDict}
