*** Settings ***
Library  OperatingSystem
Library  String
Library  ExcelRobot
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library  otr_robot_lib.ws.Oauth2.Oauth2APIService
Library  otr_robot_lib.ssh.PySSH  ${app_ssh_host}
Library  otr_robot_lib.ftp.PyFTP.FTPLibrary
Library  otr_robot_lib.support.RobotDebug
Resource  otr_robot_lib/robot/APIKeywords.robot

Suite Setup  Setup The Suite Environment For Testing
Suite Teardown  Tear Down The Suite Environment

Force Tags  API  MERCHANTSERVICEAPI  PHOENIX  T-CHECK  DITONLY

Documentation    Test the POST endpoint where uploads an file to a S3 bucket in AWS environment

*** Variables ***
${rootDir}  ${ROBOTROOT}/WebServices/Assets/MerchantFileUpload
${newType}  WEX_ONSITE_FUEL_FILE
${legacyType}  EFS_MOBILE_FUEL_FILE
${bucketName}  phoenix-onsite-fuel-dit-bucket

${failedFile}
${numberFailedRows}

*** Test Cases ***
#Legacy Files
Validate File Upload Endpoint For Legacy Files
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-614  Q2:2023  qTest:119484798
    [Setup]  Test Setup
    Make Request  ${legacyFilename}  ${legacyType}
    Validate The Response And Successful Parse
    Validate Successful Parsed Data  legacy
    [Teardown]  Test Teardown

Validate File Upload Endpoint For Legacy Files With Empty Invoice Number
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-622  Q2:2023  qTest:119554276
    [Setup]  Test Setup
    Modify The Excel File  legacy  invoice number  ${EMPTY}  row=random
    Make Request  ${legacyFilename}  ${legacyType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid invoice number  ${failedFile}
    [Teardown]  Test Teardown  legacy  invoice number  reset  dataType=NUMBER

Validate File Upload Endpoint For Legacy Files With Invoice Number as String
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment with the filed INVOICE_NUMBER informed as STRING
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-622  Q2:2023  qTest:119554276
    [Setup]  Test Setup
    Modify The Excel File  legacy  invoice number  INVALID  row=random
    Make Request  ${legacyFilename}  ${legacyType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid invoice number  ${failedFile}
    [Teardown]  Test Teardown  legacy  invoice number  reset  dataType=NUMBER

Validate File Upload Endpoint For Legacy Files With Empty Invoice Date
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-622  Q2:2023  qTest:119554276
    [Setup]  Test Setup
    Modify The Excel File  legacy  invoice date  ${EMPTY}  row=random
    Make Request  ${legacyFilename}  ${legacyType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid invoice date  ${failedFile}
    [Teardown]  Test Teardown  legacy  invoice date  reset

Validate File Upload Endpoint For Legacy Files With Empty Fuel Type
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-622  Q2:2023  qTest:119554276
    [Setup]  Test Setup
    Modify The Excel File  legacy  fuel type  ${EMPTY}  row=random
    Make Request  ${legacyFilename}  ${legacyType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid fuel type  ${failedFile}
    [Teardown]  Test Teardown  legacy  fuel type  reset

Validate File Upload Endpoint For Legacy Files With Empty Gallons
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-622  Q2:2023  qTest:119554276
    [Setup]  Test Setup
    Modify The Excel File  legacy  gallons  ${EMPTY}  row=random
    Make Request  ${legacyFilename}  ${legacyType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid quantity  ${failedFile}
    [Teardown]  Test Teardown  legacy  gallons  reset

Validate File Upload Endpoint For Legacy Files With Empty Total Amount
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-622  Q2:2023  qTest:119554276
    [Setup]  Test Setup
    Modify The Excel File  legacy  total amount  ${EMPTY}  row=random
    Make Request  ${legacyFilename}  ${legacyType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid amount  ${failedFile}
    [Teardown]  Test Teardown  legacy  total amount  reset

#New Files
Validate File Upload Endpoint For New Files
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-616  Q2:2023  qTest:120000253
    [Setup]  Test Setup
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Validate Successful Parsed Data  new
    [Teardown]  Test Teardown

Validate File Upload Endpoint For New Files With Empty Invoice Number
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  invoice number  ${EMPTY}  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid invoice number
    [Teardown]  Test Teardown  new  invoice number  reset  dataType=NUMBER

Validate File Upload Endpoint For New Files With Invoice Number as String
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment with the filed INVOICE_NUMBER informed as STRING
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  invoice number  INVALID  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid invoice number
    [Teardown]  Test Teardown  new  invoice number  reset  dataType=NUMBER

Validate File Upload Endpoint For New Files With Empty Card ID
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  card id  ${EMPTY}  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid card
    [Teardown]  Test Teardown  new  card id  reset

Validate File Upload Endpoint For New Files With Empty Location ID
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  location id  ${EMPTY}  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid location
    [Teardown]  Test Teardown  new  location id  reset

Validate File Upload Endpoint For New Files With Empty Purchase Datetime
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  purchase datetime  ${EMPTY}  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid invoice date
    [Teardown]  Test Teardown  new  purchase datetime  reset

Validate File Upload Endpoint For New Files With Empty Product
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  product  ${EMPTY}  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid product
    [Teardown]  Test Teardown  new  product  reset

Validate File Upload Endpoint For New Files With Empty Quantity
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  quantity  ${EMPTY}  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid quantity
    [Teardown]  Test Teardown  new  quantity  reset

Validate File Upload Endpoint For New Files With Empty Amount
    [Documentation]  Test case to validate the file upload endpoint which is used to save a sent file into the S3 bucket
                ...  in the AWS enviroment
    [Tags]  JIRA:O5SA-528  JIRA:O5SA-624  Q2:2023  qTest:120000254
    [Setup]  Test Setup
    Modify The Excel File  new  amount  ${EMPTY}  row=random
    Make Request  ${newFilename}  ${newType}
    Validate The Response And Successful Parse
    Download File From S3 Bucket  rejected  ${failedFile}
    Validate The Failed Parsed Rows  invalid amount
    [Teardown]  Test Teardown  new  amount  reset

#API expected errors
Try To Make A Request With An Invalid Token
    [Documentation]  Test case to check the behavior of the API with an invalid Token
    [Tags]  JIRA:O5SA-528  Q2:2023  qTest:118539308
    [Setup]  Test Setup
    Make Request  ${newFilename}  ${newType}  secure=I  error=Y
    Validate The API Response    401
    [Teardown]  Test Teardown

Try To Make A Request With An Invalid File Type
    [Documentation]  Test case to check the behavior of the API with an invalid Token
    [Tags]  JIRA:O5SA-528  Q2:2023  qTest:118539308
    [Setup]  Test Setup
    Make Request  ${newFilename}  invalid  error=Y
    Validate The API Response    400  empty
    [Teardown]  Test Teardown

Try To Make A Request With An Invalid Merchant ID
    [Documentation]  Test case to check the behavior of the API with an invalid Token
    [Tags]  JIRA:O5SA-528  Q2:2023  qTest:118539308
    [Setup]  Test Setup
    Make Request  ${newFilename}  ${newType}  merchantId=888888  error=Y
    Validate The API Response    403
    [Teardown]  Test Teardown

Try To Make A Request With Unmatched Merchant
    [Documentation]  Test case to check the behavior of the API with an invalid Token
    [Tags]  JIRA:O5SA-528  Q2:2023  qTest:118539308
    [Setup]  Test Setup
    Make Request  ${legacyFilename}  ${newType}  error=Y
    Validate The API Response    400  unmatched merchant
    [Teardown]  Test Teardown

Try To Make A Request With Invalid Card Number
    [Documentation]  Test case to check the behavior of the API with an invalid Token
    [Tags]  JIRA:O5SA-528  Q2:2023  qTest:118539308
    [Setup]  Test Setup
    Make Request  ${newFilename}  ${legacyType}  error=Y
    Validate The API Response    400  invalid card number
    [Teardown]  Test Teardown

Try To Make A Request With A User Without Permission
    [Documentation]  Test case to check the behavior of the API with an invalid Token
    [Tags]  JIRA:O5SA-528  Q2:2023  qTest:118539308
    [Setup]  Test Setup  dif merchant
    Make Request  ${newFilename}  ${newType}  merchantId=${difMerchant}  error=Y
    Validate The API Response    403
    [Teardown]  Test Teardown

*** Keywords ***
#Data Setups and Teardowns
Setup The Suite Environment For Testing
    [Documentation]  Keyword that will setup the environment to execute the test
    Get URL For Suite  ${MerchantService}
    Setting Directories
    Setting Data
    Create My User  persona_name=merchant_onsite_fuel_manager  application_name=merch
               ...  entity_id=${merchantInfo}[merchant_id]  with_data=N

Setting Directories
    [Documentation]  keyword that will setup the base directories in the linux machine and local
    ${scriptDir}  Catenate  /tch/run
    Set Suite Variable  ${scriptDir}

    ${path}  Normalize Path  ${rootDir}/OnUse
    Create Directory  ${path}
    Set Suite Variable  ${onUseDir}  ${path}

Setting Data
    [Documentation]  Setup the user and get data to be used during test
    ${query}  Catenate  select location_id from mobile_fuel_config limit 500;
    Get Into DB  TCH
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    ${list}  Create List For Query From List  ${query}[location_id]
    ${query}  Catenate  select * from on_site_merchants where location_id in (${list});
    Get Into DB  postgresmerchants
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    IF  isinstance($query['id'], list)
        ${len}  Get Length  ${query}[id]
        ${len}  Evaluate  random.randint(0, $len-1)
        ${query}  Create Dictionary  id  ${query}[id][${len}]  merchant_name  ${query}[merchant_name][${len}]
                                ...  card_id  ${query}[card_id][${len}]  location_id  ${query}[location_id][${len}]
                                ...  carrier_id  ${query}[carrier_id][${len}]  update_date  ${query}[update_date][${len}]
                                ...  updated_by  ${query}[updated_by][${len}]  merchant_id  ${query}[merchant_id][${len}]
                                ...  location_name  ${query}[location_name][${len}]
    END

    Set Suite Variable  ${merchantInfo}  ${query}

    ${query}  Catenate  select * from cards where card_id = ${merchantInfo}[card_id];
    Get Into DB  TCH
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    Set Suite Variable  ${cardInfo}  ${query}

    Get Into DB  postgresmerchants
    ${query}  Catenate  select osm.location_id, osm.location_name
                   ...  from on_site_merchants osm
                   ...  where osm.card_id = '${cardInfo}[card_id]' and osm.merchant_id = '${merchantInfo}[merchant_id]';
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database
    Set Suite Variable  ${locInfo}  ${query}

    ${cardNumLastEight}  Set Variable  ${cardInfo}[card_num]
    ${cardNumLastEight}  Strip String  ${cardNumLastEight}
    ${cardNumLastEight}  Get Substring  ${cardNumLastEight}  -8

    ${dateNew}  Get Current Date  result_format=%Y%m%d
    ${dateLegacy}  Get Current Date  result_format=%m%d%Y

    ${newFormats}  Create List  xls  xlsx
    ${legacyFormats}  Create List  xls  xlsx

    ${format}  Evaluate  random.choice(${newFormats})
    ${norm_basefile}  Normalize Path  ${rootDir}/BaseFiles/merchantId_YYYYMMDD.${format}
    ${newFilename}  Normalize Path  ${onUseDir}/${merchantInfo}[merchant_id]_${dateNew}.${format}
    Copy File  ${norm_basefile}  ${newFilename}
    Edit Excel File With Data  new  ${newFilename}
    Set Suite Variable  ${newFilename}  ${merchantInfo}[merchant_id]_${dateNew}.${format}

    ${format}  Evaluate  random.choice(${legacyFormats})
    ${norm_basefile}  Normalize Path  ${rootDir}/BaseFiles/8cardnum_MMDDYYYY.${format}
    ${legacyFilename}  Normalize Path  ${onUseDir}/${cardNumLastEight}_${dateLegacy}.${format}
    Copy File  ${norm_basefile}  ${legacyFilename}
    Edit Excel File With Data  legacy  ${legacyFilename}
    Set Suite Variable  ${legacyFilename}  ${cardNumLastEight}_${dateLegacy}.${format}

#TC Keywords
Edit Excel File With Data
    [Documentation]  Keyword that will setup the excel file to make the request
    [Arguments]  ${fileType}  ${path}
    ${fileType}  String.Convert To Lowercase  ${fileType}

    ${numberEntries}  Evaluate  random.randrange(2, 4)
    ${rowCounter}  Set Variable  0

    Set Suite Variable  ${rowEntries${fileType}}  ${numberEntries}

    Open Excel To Write  file_path=${path}  override=True

    IF  '${fileType}'=='new'
        ${date}  Get Current Date  result_format=%Y-%m-%dT%H:%M:%S.000
        ${purchaseDate}  Subtract Time From Date  ${date}  90 days  result_format=%Y-%m-%dT%H:%M:%S.000
                                             ...  exclude_millis=true  date_format=%Y-%m-%dT%H:%M:%S.000
        Set Suite Variable  ${newDateOG}  ${purchaseDate}

        FOR  ${x}  IN RANGE  ${numberEntries}
            ${rowCounter}  Evaluate  ${rowCounter}+1

            ${invoiceNumber_random}  Generate Random String  10  [NUMBERS]
            ${invoiceNumber}  Convert To Integer  ${invoiceNumber_random}

            ${prodType}  Create List  fuel  merch
            ${prodType}  Evaluate  random.choice(${prodType})

            ${product}  Find Product  new  ${prodType}

            IF  '${prodType.lower()}'=='fuel'
                ${quantity}  Evaluate  random.uniform(0.5, 20.0)
                ${quantity}  Convert To Number  ${quantity}  3
            ELSE IF  '${prodType.lower()}'=='merch'
                ${quantity}  Evaluate  random.uniform(0.5, 20.0)
                ${quantity}  Convert To Number  ${quantity}  0
            END

            ${ppu}  Evaluate  random.uniform(0.5, 5.0)
            ${amount}  Evaluate  ${ppu}*${quantity}
            ${ppu}  Convert To Number  ${ppu}  3
            ${amount}  Convert To Number  ${amount}  3

            #prompts are hardcoded because the effort to make it dynamicly with the card would be worthless
            #due to not be validated what is sent but if the information was correctly formatted into json in the DB
            ${prompts}  Set Variable  LICN:12369741; PPIN:0333; UNIT:1234

            Write To Cell  First Sheet  ${0}  ${rowCounter}  ${invoiceNumber}  NUMBER
            Write To Cell  First Sheet  ${1}  ${rowCounter}  ${cardInfo}[card_id]  NUMBER
            Write To Cell  First Sheet  ${2}  ${rowCounter}  ${locInfo}[location_id]  TEXT
            Write To Cell  First Sheet  ${3}  ${rowCounter}  ${purchaseDate}  TEXT
            Write To Cell  First Sheet  ${4}  ${rowCounter}  ${product}  TEXT
            Write To Cell  First Sheet  ${5}  ${rowCounter}  ${quantity}  TEXT
            Write To Cell  First Sheet  ${6}  ${rowCounter}  ${ppu}  TEXT
            Write To Cell  First Sheet  ${7}  ${rowCounter}  ${amount}  TEXT
            Write To Cell  First Sheet  ${8}  ${rowCounter}  ${prompts}  TEXT

            ${tempDate}  Convert Date  ${purchaseDate}  date_format=%Y-%m-%dT%H:%M:%S.000  result_format=%m/%d/%Y

            &{rowInfo}  Create Dictionary  invoice_number  ${invoiceNumber}  card_id  ${cardInfo}[card_id]
                                      ...  location_id  ${locInfo}[location_id]  purchase_datetime  ${tempDate}
                                      ...  product  ${product}  quantity  ${quantity}  ppu  ${ppu}  amount  ${amount}
                                      ...  prompts  ${prompts}  product_type  ${prodType}
            Set Suite Variable  &{newRow${rowCounter}}  &{rowInfo}
        END
    ELSE IF  '${fileType}'=='legacy'
        ${customerName}  Set Variable  Test Automation Customer
        ${address}  Set Variable  Test Automation Address
        ${city}  Set Variable  Test Automation City
        ${state}  Set Variable  Test Automation State

        ${date}  Get Current Date  result_format=%m/%d/%Y
        ${invoiceDate}  Subtract Time From Date  ${date}  90 days  result_format=%m/%d/%Y
                                            ...  exclude_millis=true  date_format=%m/%d/%Y

        ${ticketId}  Generate Random String  6  [NUMBERS]

        ${transDate}  Subtract Time From Date  ${date}  2 days  result_format=%m/%d/%Y
                                          ...  exclude_millis=true  date_format=%m/%d/%Y

        FOR  ${x}  IN RANGE  ${numberEntries}
            ${rowCounter}  Evaluate  ${rowCounter}+1

            ${invoiceNumber_random}  Generate Random String  10  [NUMBERS]
            ${invoiceNumber}  Convert To Integer  ${invoiceNumber_random}

            ${fuelType}  Find Product  legacy

            ${unitNumber}  Generate Random String  6  [NUMBERS]

            ${gallons}  Evaluate  random.uniform(0.5, 20.0)
            ${gallons}  Convert To Number  ${gallons}  3

            ${ppu}  Evaluate  random.uniform(0.5, 5.0)
            ${totalAmount}  Evaluate  ${ppu}*${gallons}
            ${totalAmount}  Convert To Number  ${totalAmount}  3

            Write To Cell  First Sheet  ${0}  ${rowCounter}  ${customerName}  TEXT
            Write To Cell  First Sheet  ${1}  ${rowCounter}  ${address}  TEXT
            Write To Cell  First Sheet  ${2}  ${rowCounter}  ${city}  TEXT
            Write To Cell  First Sheet  ${3}  ${rowCounter}  ${state}  TEXT
            Write To Cell  First Sheet  ${4}  ${rowCounter}  ${invoiceNumber}  NUMBER
            Write To Cell  First Sheet  ${5}  ${rowCounter}  ${invoiceDate}  TEXT
            Write To Cell  First Sheet  ${6}  ${rowCounter}  ${ticketId}  TEXT
            Write To Cell  First Sheet  ${7}  ${rowCounter}  ${transDate}  TEXT
            Write To Cell  First Sheet  ${8}  ${rowCounter}  ${fuelType}  TEXT
            Write To Cell  First Sheet  ${9}  ${rowCounter}  ${unitNumber}  TEXT
            Write To Cell  First Sheet  ${10}  ${rowCounter}  ${gallons}  TEXT
            Write To Cell  First Sheet  ${11}  ${rowCounter}  ${totalAmount}  NUMBER

            &{rowInfo}  Create Dictionary  customer_name  ${customerName}  address  ${address}
                                      ...  city  ${city}  state  ${state}  invoice_number  ${invoiceNumber}
                                      ...  invoice_date  ${invoiceDate}  ticket_id  ${ticketId}
                                      ...  transaction_date  ${transDate}  fuel_type  ${fuelType}
                                      ...  unit_number  ${unitNumber}  gallons  ${gallons}
                                      ...  total_amount  ${totalAmount}
            Set Suite Variable  &{legacyRow${rowCounter}}  &{rowInfo}
        END
    ELSE
        Fail  '${fileType}' not supported
    END

    Save Excel

Find Product
    [Documentation]  keyword that will search for a random product
    [Arguments]  ${fileType}  ${productType}=None
    ${fileType}  String.Convert To Lowercase  ${fileType}
    ${productType}  String.Convert To Lowercase  ${productType}
    IF  '${fileType}'=='new'
        IF  '${productType}'=='fuel'
            ${product}  Set Variable  and fuel_type<>0
        ELSE IF  '${productType}'=='merch'
            ${product}  Set Variable  and fuel_type=0
        END
        ${condition}  Set Variable  abbrev not in ('UNKN', 'STAX') ${product}
    ELSE IF  '${fileType}'=='legacy'
        ${condition}  Set Variable  abbrev in ('ULSD', 'ULSR', 'DEFD')
    ELSE
        Fail  '${fileType}' is not a implemented option to look for products
    END
    ${query}  Catenate  select trim(abbrev) from products where fps_partner = 'TCH' and ${condition};
    Get Into DB  TCH
    ${query}  Query And Strip To List  ${query}
    ${query}  Evaluate  random.choice(${query})
    [Return]  ${query}

Modify The Excel File
    [Documentation]  Keyword that will make changes in the excel file or reset it to defaul value
    [Arguments]  ${fileType}  ${field}  ${value}  ${row}=${EMPTY}  ${dataType}=TEXT
    ${fileType}  String.Convert To Lowercase  ${fileType}
    ${field}  String.Convert To Lowercase  ${field}
    ${dataType}  String.Convert To Uppercase  ${dataType}
    IF  '${row}'=='random'
        ${temp}  Evaluate  random.randint(1, ${rowEntries${fileType}})
        Set Suite Variable  ${drawnFailedRow}  ${temp}
        ${row}  Set Variable  ${temp}
    END

    IF  '${value}'=='reset'
        ${row}  Set Variable  ${drawnFailedRow}
        IF  '${fileType}'=='new'
            IF  '${field}'=='invoice number'
                ${value}  Set Variable  ${newRow${row}}[invoice_number]
                ${dataType}  Set Variable  NUMBER
            ELSE IF  '${field}'=='card id'
                ${value}  Set Variable  ${newRow${row}}[card_id]
                ${dataType}  Set Variable  NUMBER
            ELSE IF  '${field}'=='location id'
                ${value}  Set Variable  ${newRow${row}}[location_id]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='purchase datetime'
                ${value}  Set Variable  ${newDateOG}
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='product'
                ${value}  Set Variable  ${newRow${row}}[product]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='quantity'
                ${value}  Set Variable  ${newRow${row}}[quantity]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='amount'
                ${value}  Set Variable  ${newRow${row}}[amount]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='prompts'
                ${value}  Set Variable  ${newRow${row}}[prompts]
                ${dataType}  Set Variable  TEXT
            ELSE
                Fail  Legacy File does not have '${field}' to be reseted
            END
        ELSE IF  '${fileType}'=='legacy'
            IF  '${field}'=='customer name'
                ${value}  Set Variable  ${legacyRow${row}}[customer_name]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='address'
                ${value}  Set Variable  ${legacyRow${row}}[address]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='city'
                ${value}  Set Variable  ${legacyRow${row}}[city]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='state'
                ${value}  Set Variable  ${legacyRow${row}}[state]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='invoice number'
                ${value}  Set Variable  ${legacyRow${row}}[invoice_number]
                ${dataType}  Set Variable  NUMBER
            ELSE IF  '${field}'=='invoice date'
                ${value}  Set Variable  ${legacyRow${row}}[invoice_date]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='ticket id'
                ${value}  Set Variable  ${legacyRow${row}}[ticket_id]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='transaction date'
                ${value}  Set Variable  ${legacyRow${row}}[transaction_date]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='fuel type'
                ${value}  Set Variable  ${legacyRow${row}}[fuel_type]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='gallons'
                ${value}  Set Variable  ${legacyRow${row}}[gallons]
                ${dataType}  Set Variable  TEXT
            ELSE IF  '${field}'=='total amount'
                ${value}  Set Variable  ${legacyRow${row}}[total_amount]
                ${dataType}  Set Variable  NUMBER
            ELSE
                Fail  Legacy File does not have '${field}' to be reseted
            END
        ELSE
            Fail  '${fileType}' file type not supported to be reseted
        END
    END

    IF  '${fileType}'=='new'
        ${path}  Normalize Path  ${onUseDir}/${newFilename}
        Open Excel To Write  file_path=${path}  override=True
        IF  '${field}'=='invoice number'
            Write To Cell  First Sheet  ${0}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='card id'
            Write To Cell  First Sheet  ${1}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='location id'
            Write To Cell  First Sheet  ${2}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='purchase datetime'
            Write To Cell  First Sheet  ${3}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='product'
            Write To Cell  First Sheet  ${4}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='quantity'
            Write To Cell  First Sheet  ${5}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='ppu'
            Write To Cell  First Sheet  ${6}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='amount'
            Write To Cell  First Sheet  ${7}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='prompts'
            Write To Cell  First Sheet  ${8}  ${row}  ${value}  ${dataType}
        ELSE
            Fail  Modification of the '${field}' not implemented yet for new files
        END
    ELSE IF  '${fileType}'=='legacy'
        ${path}  Normalize Path  ${onUseDir}/${legacyFilename}
        Open Excel To Write  file_path=${path}  override=True
        IF  '${field}'=='customer name'
            Write To Cell  First Sheet  ${0}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='address'
            Write To Cell  First Sheet  ${1}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='city'
            Write To Cell  First Sheet  ${2}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='state'
            Write To Cell  First Sheet  ${3}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='invoice number'
            Write To Cell  First Sheet  ${4}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='invoice date'
            Write To Cell  First Sheet  ${5}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='ticket id'
            Write To Cell  First Sheet  ${6}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='transaction date'
            Write To Cell  First Sheet  ${7}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='fuel type'
            Write To Cell  First Sheet  ${8}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='gallons'
            Write To Cell  First Sheet  ${10}  ${row}  ${value}  ${dataType}
        ELSE IF  '${field}'=='total amount'
            Write To Cell  First Sheet  ${11}  ${row}  ${value}  ${dataType}
        ELSE
            Fail  Modification of the '${field}' not implemented yet for legacy files
        END
    ELSE
        Fail  '${fileType}' file type not supported
    END

    Save Excel

Tear Down The Suite Environment
    [Documentation]  Keyword used in to Tear Down The Suite Environment
    Remove User If Still Exists

    Save Excel
    Remove Directory  ${onUseDir}  recursive=true

#Test Setup and Teardown
Test Setup
    [Documentation]  Keyword to setup the download directories for the test case
    [Arguments]    ${special}==None
    ${downloadsDir}  Normalize Path  ${onUseDir}/Downloaded/
    Create Directory  ${downloadsDir}
    Set Test Variable  ${downloadsDir}

    ${sshDownDir}  Set Variable  /OnSiteFuel
    ${stdout}  Execute Command  mkdir -p ${sshDownDir}  sudo=True
    Execute Command  chmod -R 777 ${sshDownDir}
    Execute Command  cd ${sshDownDir}
    Set Test Variable  ${sshDownDir}

    IF  '${special.lower()}'=='dif merchant'
        ${query}  Catenate  select osm.merchant_id from on_site_merchants osm
                       ...  where osm.merchant_id <> '${merchantInfo}[merchant_id]'
                       ...  order by random() limit 1;
        Get Into DB  postgresmerchants
        ${difMerchant}  Query And Strip To Dictionary  ${query}
        Set Test Variable  ${difMerchant}  ${difMerchant}[merchant_id]
    END

Test Teardown
    [Documentation]  Keyword to teardown what have been done during the test
    [Arguments]  ${fileType}=${EMPTY}  ${field}=${EMPTY}  ${value}=${EMPTY}  ${row}=${EMPTY}  ${dataType}=TEXT
    IF  '${fileType}'!='${empty}'
        IF  '${dataType}'=='TEXT'
             Modify The Excel File  ${fileType}  ${field}  ${value}  ${row}=${EMPTY}  ${dataType}=TEXT
        ELSE IF  '${dataType}'=='NUMBER'
             Modify The Excel File  ${fileType}  ${field}  ${value}  ${row}=${EMPTY}  ${dataType}=NUMBER
        END
    END

    Remove Directory  ${downloadsDir}  recursive=true
    ${removeDir}  Catenate  sudo rm -rf ${sshDownDir}
    Execute Command  ${removeDir}

#File Upload And Parse Status
Make Request
    [Documentation]  Keyword that makes the request and set the response and status as suite variables
                ...  This keywords is using cURL command because the API Request from RestAPI.py does not support files
                ...  as payload
                ...  ${file} is the variable of the filepath, can be legacy_filename or new_filename variables
                ...  ${type} is the fileType sent, can be EFS_MOBILE_FUEL_FILE or WEX_ONSITE_FUEL_FILE
    [Arguments]  ${filename}  ${type}  ${secure}=Y  ${merchantId}=${merchantInfo}[merchant_id]  ${app}=merch
            ...  ${username}=${NONE}  ${password}=${NONE}  ${error}=N
    ${app}  Find Application Information  ${app}
    ${path}  Normalize Path  ${onUseDir}/${filename}

    IF  '${secure}' in ('I', 'Y')
        ${token}  Get Bearer Token PKCE  ${okta_automated_email}  ${automated_user_password}  ${app}[0][app_name]
        ${token}  Set Variable  ${token}[access_token]

        IF  '${secure.upper()}'=='I'
            ${token}  Catenate  a  ${token}
        END
    ELSE
        ${token}  Set Variable  ${EMPTY}
    END

    ${error}  String.Convert To Lowercase  ${error}
    IF  '${error}'=='empty body'
        ${body}  Set Variable    ${EMPTY}
    ELSE
        ${body}  Set Variable    ${path}
    END

    #the margin exceeded here due to '...' break the command
    ${runURL}  Catenate  curl --include --location --request POST "${MerchantService}/merchants/${merchantId}/file-upload?fileType=${type}" --header "Authorization: Bearer ${token}" --form "file=@\"${body}\""
    ${result}  Run  ${runURL}
    ${result}  Convert To String  ${result}

    ${status}  Get Regexp Matches  ${result}  (\\d{3})\\s(?i)\\ndate
    ${status}  Remove String Using Regexp  ${status}[0]  \\s(?i)\\ndate

    #if it is a successful upload, checks if the file is in the and get the response body, if not, just gether the response body
    IF  '${error.upper()}'=='N'
        ${response}  Get Regexp Matches  ${result}  {"name":.*}}}
        ${response}  Evaluate  json.loads($response[0])  json
        Download File From S3 Bucket  accepted  ${filename}  check=yes  batch_id=${response}[details][data][batch_id]
    ELSE
        ${response}  Get Regexp Matches  ${result}  {"name":.*}
        IF  ${response}!=[]
            ${response}  Evaluate  json.loads($response[0])  json
        END
    END

    Set Test Variable  ${response}
    Set Test Variable  ${status}

Validate The API Response
    [Documentation]  keyword that will validate the API response
    [Arguments]  ${expectedStatus}  ${expectedBody}=None
    ${expectedBody}  String.Convert To Lowercase  ${expectedBody}

    IF  ${expectedStatus}==202
        Should Be Equal As Strings  ${status}  202
        Should Be Equal As Strings  ${response}[name]  ACCEPTED
        Should Be Equal As Strings  ${response}[message]  SUCCESSFUL
        Should Be Equal As Strings  ${response}[details][type]  FileUploadResponseDTO
        ${st}  Evaluate    isinstance(${response}[details][data][batch_id], int)
        Should Be Equal As Strings  ${response}[details][data][status]  Accepted
        Should Be Equal As Strings  ${response}[details][data][links]  []
    ELSE IF  ${expectedStatus}==400
        Should Be Equal As Strings  ${status}  400
        IF  '${expectedBody}'=='no file'
            Should Be Equal As Strings  ${response}[name]  DO_UPLOAD_FILE
            Should Be Equal As Strings  ${response}[error_code]  DO_UPLOAD_FILE
            Should Be Equal As Strings  ${response}[message]  Please upload the file.
        ELSE IF    '${expectedBody}'=='unmatched merchant'
            Should Be Equal As Strings  ${response}[name]  DOES_NOT_MATCH_MERCHANT_ID
            Should Be Equal As Strings  ${response}[error_code]  DOES_NOT_MATCH_MERCHANT_ID
            Should Be Equal As Strings  ${response}[message]  Merchant Id doesn't match
        ELSE IF    '${expectedBody}'=='invalid card number'
            Should Be Equal As Strings  ${response}[name]  INVALID_CARD_NUMBER
            Should Be Equal As Strings  ${response}[error_code]  INVALID_CARD_NUMBER
            Should Be Equal As Strings  ${response}[message]  Invalid Card Number
        ELSE IF    '${expectedBody}'=='empty'
            Should Be Empty    ${response}
        END
    ELSE IF  ${expectedStatus}==401
        Should Be Equal As Strings  ${status}  401
    ELSE IF  ${expectedStatus}==403
        Should Be Equal As Strings  ${status}  403
    ELSE IF  ${expectedStatus}==415
        Should Be Equal As Strings  ${status}  415
    END

Validate The Response And Successful Parse
    [Documentation]  This keyword will validate the API response using the JsonAuth response and some information from
                ...  the database
    Validate The API Response    202

    Get Into Db  postgresmerchants
    ${database}  Wait Until Keyword Succeeds  1 min  10 sec
                                         ...  Verify The Database Parse File Status  ${response}[details][data][batch_id]
    Disconnect From Database

    IF  'failed_count' in ${database}[file_process_results]
        Set Test Variable  ${failedFile}  ${database}[file_process_results][failed_file_name]
    END

    Set Test Variable  ${batchHistory}  ${database}

Verify The Database Parse File Status
    [Documentation]  keyword that will return the database information if the status is not accepted
    [Arguments]  ${batch_id}
    ${database}  Catenate  select * from batch_history where batch_id=${batch_id};
    ${database}  Query And Strip To Dictionary  ${database}
    IF  '${database}[status]'!='Accepted'
        Return From Keyword  ${database}
    ELSE
        Fail  Parsing Async Call Not completed
    END

#Parse validation
Download File From S3 Bucket
    [Documentation]  Download a file from the AWS S3 Bucket
    [Arguments]  ${subdir}  ${filename}=${EMPTY}  ${check}=no  ${expectedRC}=0  ${batch_id}=${EMPTY}
    IF  '${batch_id}'!='${EMPTY}'
        Get Into DB  postgresmerchants
        ${query}  Catenate  select file_name from batch_history where batch_id = '${batch_id}';
        ${filename}  Query And Strip    ${query}
        Disconnect From Database
    END
    Set FTP Host  ${appsshConnection}
    FTP Login  ${sshNAME}  ${sshpass}  SFTP

    #the margin exceeded here due to '...' break the command
    ${command}  Catenate  ${scriptDir}/awsS3SFTP.sh -b ${bucketName} -c pull -f ${filename} --origin-outdir=${merchantInfo}[merchant_id]/${subdir.lower()}  --local-outdir=${sshDownDir}

    ${stdout}  Wait Until Keyword Succeeds  15 sec  3 sec  Execute Command  ${command}  expectedRC=${expectedRC}

    IF  '${check.lower()}'=='no'
        Execute Command  chmod 777 ${sshDownDir}/${filename}
        ${tempPath}  Normalize Path  ${downloadsDir}/${filename}
        otr_robot_lib.ftp.PyFTP.FTPLibrary.Download File  ${sshDownDir}/${filename}  ${tempPath}
    END

Validate Successful Parsed Data
    [Documentation]  Keyword that will check the parse done by the Asychronous parse call
    [Arguments]  ${fileType}  ${batch_id}=${response}[details][data][batch_id]
    ${fileType}  String.Convert To Lowercase  ${fileType}
    Should Be Equal As Strings  ${batchHistory}[status]  Completed

    Get Into DB  postgresmerchants
    ${query}  Catenate  select pre_purchase_id, card_id, carrier_id, carrier_name, batch_id,
                   ...  to_char(pos_date, 'MM/DD/YYYY') as pos_date, pos_offset, invoice_number, location_id, location_name,
                   ...  prompts, fuel_products, merch_products, total_amount, updated_by, update_date
                   ...  from pre_purchase
                   ...  where batch_id = ${batch_id} order by pre_purchase_id asc;
    ${prePurchase}  Query And Return Dictionary Rows  ${query}
    Disconnect From Database

    IF  '${fileType}'=='new'
        ${rowNumber}  Set Variable  0
        FOR  ${row}  IN  @{prePurchase}
            ${rowNumber}  Evaluate  ${rowNumber}+1

            IF  ${row}[prompts]!=${NONE}
                #the margin exceeded here due to '...' break the comparison
                ${tempPrompt}  Set Variable
                ...  [{'info_id': 'LICN', 'info_value': '12369741'}, {'info_id': ' PPIN', 'info_value': '0333'}, {'info_id': ' UNIT', 'info_value': '1234'}]
            ELSE
                ${tempPrompt}  Set Variable  ${NONE}
            END

            Get Into DB  TCH
            ${tempProd}  Catenate  select fuel_use, fuel_type, trim(abbrev) as abbrev, description from products
            ...  where fps_partner = 'TCH' and abbrev = '${newRow${rowNumber}}[product]';
            ${tempProd}  Query And Strip To Dictionary  ${tempProd}
            Disconnect From Database

            IF    '${newRow${rowNumber}}[product_type]'=='fuel'
                ${tempProd}  Create Dictionary  ppu  ${newRow${rowNumber}}[ppu]  cost  ${newRow${rowNumber}}[amount]
                                           ...  fuel_use  ${tempProd}[fuel_use]  quantity  ${newRow${rowNumber}}[quantity]
                                           ...  fuel_type  ${tempProd}[fuel_type]  product_id  ${tempProd}[abbrev]
                                           ...  product_description  ${tempProd}[description]
            ELSE IF    '${newRow${rowNumber}}[product_type]'=='merch'
                ${tempProd}  Create Dictionary  product_cost  ${newRow${rowNumber}}[amount]
                                           ...  product_quantity  ${newRow${rowNumber}}[quantity]
                                           ...  product_id  ${tempProd}[abbrev]
                                           ...  product_description  ${tempProd}[description]
            END

            Should Be Equal As Strings  ${row}[card_id]  ${cardInfo}[card_id]
            Should Be Equal As Strings  ${row}[batch_id]  ${batch_id}
            Should Be Equal As Strings  ${row}[pos_date]  ${newRow${rowNumber}}[purchase_datetime]
            Should Be Equal As Strings  ${row}[pos_offset]  0
            Should Be Equal As Integers  ${row}[invoice_number]  ${newRow${rowNumber}}[invoice_number]
            Should Be Equal As Strings  ${row}[location_id]  ${locInfo}[location_id]
            Should Be Equal As Strings  ${row}[location_name]  ${locInfo}[location_name]  ignore_case=true
            Should Be Equal As Strings  ${row}[prompts]  ${tempPrompt}
            IF  '${newRow${rowNumber}}[product_type]'=='fuel'
                Dictionaries Should Be Equal  ${row}[fuel_products][0]  ${tempProd}
                Should Be Equal As Strings  ${row}[merch_products]  None
            ELSE IF  '${newRow${rowNumber}}[product_type]'=='merch'
                Should Be Equal As Strings  ${row}[fuel_products]  None
                Dictionaries Should Be Equal  ${row}[merch_products][0]  ${tempProd}
            END
            Should Be Equal As Numbers  ${row}[total_amount]  ${newRow${rowNumber}}[amount]
            Should Be Equal As Strings  ${row}[updated_by]  ${auto_user_id}
            Should Not Be Empty  '${row}[update_date]'
        END
    ELSE IF  '${fileType}'=='legacy'
        ${cardNumLastEight}  Set Variable  ${cardInfo}[card_num]
        ${cardNumLastEight}  Strip String  ${cardNumLastEight}
        ${cardNumLastEight}  Get Substring  ${cardNumLastEight}  -8

        ${rowNumber}  Set Variable  0
        FOR  ${row}  IN  @{prePurchase}
            ${rowNumber}  Evaluate  ${rowNumber}+1

            IF  ${row}[prompts]!=${NONE}
                ${tempPrompt}  Create Dictionary  info_id  UNIT  info_value  ${legacyRow${rowNumber}}[unit_number]
                ${tempPrompt}  Create List  ${tempPrompt}
            ELSE
                ${tempPrompt}  Set Variable  ${NONE}
            END

            Get Into DB  TCH
            ${tempFuel}  Catenate  select fuel_use, fuel_type, trim(abbrev) as abbrev, description from products
                              ...  where fps_partner = 'TCH' and abbrev = '${legacyRow${rowNumber}}[fuel_type]';
            ${tempFuel}  Query And Strip To Dictionary  ${tempFuel}
            Disconnect From Database

            ${tempPPU}  Evaluate  round((${legacyRow${rowNumber}}[total_amount]/${legacyRow${rowNumber}}[gallons]), 3)
            ${tempFuel}  Create Dictionary  ppu  ${tempPPU}  cost  ${legacyRow${rowNumber}}[total_amount]
                                       ...  fuel_use  ${tempFuel}[fuel_use]  quantity  ${legacyRow${rowNumber}}[gallons]
                                       ...  fuel_type  ${tempFuel}[fuel_type]  product_id  ${tempFuel}[abbrev]
                                       ...  product_description  ${tempFuel}[description]

            Should Be Equal As Strings  ${row}[card_id]  ${cardInfo}[card_id]
            Should Be Equal As Strings  ${row}[batch_id]  ${batch_id}
            Should Be Equal As Strings  ${row}[pos_date]  ${legacyRow${rowNumber}}[invoice_date]
            Should Be Equal As Strings  ${row}[pos_offset]  0
            Should Be Equal As Integers  ${row}[invoice_number]  ${legacyRow${rowNumber}}[invoice_number]
            Should Be Equal As Strings  ${row}[location_id]  ${locInfo}[location_id]
            Should Be Equal As Strings  ${row}[location_name]  ${locInfo}[location_name]  ignore_case=true
            Should Be Equal As Strings  ${row}[prompts]  ${tempPrompt}
            Dictionaries Should Be Equal  ${row}[fuel_products][0]  ${tempFuel}
            Should Be Equal As Strings  ${row}[merch_products]  ${NONE}
            Should Be Equal As Strings  ${row}[total_amount]  ${legacyRow${rowNumber}}[total_amount]
            Should Be Equal As Strings  ${row}[updated_by]  ${auto_user_id}
            Should Not Be Empty  '${row}[update_date]'
        END
    ELSE
        Fail  Validation the parse for '${fileType}' file type not implemented
    END

Read The Rows From The Failed File
    [Documentation]  keyword that will read the lines from the failed file and parse them into variables to be used
    [Arguments]  ${filename}
    ${path}  Normalize Path  ${downloadsDir}/${filename}
    ${sheetName}  Set Variable    ${SPACE}Rejected Purchases${SPACE}
    Open Excel  ${path}
    ${rows}  Get Row Count  ${sheetName}
    ${rows}  Evaluate  ${rows}-1
    Set Test Variable  ${numberFailedRows}  ${rows}

    ${failedCard}  Read Cell Data  ${sheetName}  ${1}  ${1}  NUMBER
    ${failedLoc}  Read Cell Data  ${sheetName}  ${2}  ${1}  NUMBER
    ${failedBatch}  Read Cell Data  ${sheetName}  ${5}  ${1}  NUMBER

    ${failedRowNum}  Read Cell Data  ${sheetName}  ${0}  ${1}  NUMBER
    ${failedError}  Read Cell Data  ${sheetName}  ${7}  ${1}  TEXT

    ${failedRow}  Create Dictionary  original_row_number  ${failedRowNum}  card_id  ${failedCard}
                                ...  location_id  ${failedLoc}  batch_id  ${failedBatch}
                                ...  error_message  ${failedError}
    Set Test Variable  ${failedRow}
    Save Excel

Validate The Failed Parsed Rows
    [Documentation]  keyword that will validate the generated filed with the failed transactions
    [Arguments]  ${error}  ${filenName}=${failedFile}
    ${error}  String.Convert To Lowercase  ${error}
    ${errorDic}  Create Dictionary  card loc relation  Card and Location relation does not exist\n
                               ...  invalid product  Invalid Product.  invalid amount  Invalid Amount\n
                               ...  invalid quantity  Invalid Quantity\n  invalid prompt  Invalid Format for Prompts\n
                               ...  invalid location  Location does not exist\n
                               ...  invalid invoice date  Invalid Invoice Date\n
                               ...  invalid invoice number  Invalid Invoice Number\n
                               ...  invalid fuel type  Invalid Fuel Type\n
                               ...  invalid card  Card does not exist\n

    Read The Rows From The Failed File  ${filenName}
    #It is adding one because the row count used in the robot starts from 0 but the system starts to count from 1
    ${failedRowNum}  Evaluate    ${drawnFailedRow}+1

    Should Be Equal As Strings  1  ${numberFailedRows}
    Should Be Equal As Numbers  ${failedRow}[original_row_number]  ${failedRowNum}
    Should Be Equal As Strings  ${failedRow}[error_message]  ${errorDic}[${error}]
