*** Settings ***
Library   String
Library   Collections
Library   otr_model_lib.services.GenericService
Library   otr_robot_lib.ws.UserServiceAPI.UserAPIService
Library   otr_robot_lib.ws.RestAPI.RestAPIService
Library   otr_robot_lib.ui.web.PySelenium
Resource    otr_robot_lib/robot/APIKeywords.robot

Documentation  Test the endpoint GET totals (issued, value and charged) of Money Codes from the Money Codes controller in the Money Codes API

Force Tags  MoneyCodeAPI  API  ditOnly
Suite Setup  Script Startup
Suite Teardown  Remove User if Still exists
Test Teardown  Remove User if Necessary

*** Test Cases ***
GET Totals of MoneyCode From a Carrier
    [Documentation]  Test the successful scenario to GET totals of MoneyCodes from a carrier
    [Tags]  PI:14  JIRA:O5SA-360  qTest:116998690  MoneyCodeTotals
    GET MoneyCodes Totals Request
    Validate the MoneyCodes Totals Response

GET Totals of MoneyCode With An Invalid Token
    [Documentation]  Validating the behavior of the endpoint when using an invalid token
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Using An Invalid Token

GET Totals of MoneyCode With A Token Without Permission Related To The Carrier
    [Documentation]  Validating the behavior of the endpoint when using a token without permission related to the carrier
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Using An User Without Permission

GET Totals of MoneyCode With A Token With Permission Not Related To The Carrier
    [Documentation]  Validating the behavior of the endpoint when using a token with permission not related to the carrier
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Check Non Related Carrier

GET Totals of MoneyCode Not Sending The Carrier ID
    [Documentation]  Validating the behavior of the endpoint when not sending the carrier id
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Not Sending Carrier ID

GET Totals of MoneyCode Using An Invalid Carrier ID
    [Documentation]  Validating the behavior of the endpoint when sending an invalid carrier id
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Sending An Invalid Carrier ID

GET Totals of MoneyCode Using Letters As Carrier ID
    [Documentation]  Validating the behavior of the endpoint when sending letters as carrier id
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Sending Letters As Carrier ID

GET Totals of MoneyCode Sending The Range Parameter Empty
    [Documentation]  Validating the behavior of the endpoint when sending the 'range' query parameter empty
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Sending An Empty Range Parameter

GET Totals of MoneyCode Sending An Invalid Value As Range Parameter
    [Documentation]  Validating the behavior of the endpoint when sending the 'range' query parameter with an invalid value
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998691  MoneyCodeTotals
    GET MoneyCodes Totals When Sending An Invalid Range Parameter

GET Totals of MoneyCode From a Carrier With Authorized Old MoneyCode
    [Documentation]  Test the successful scenario to GET totals of MoneyCodes from a carrier when it have a old MoneyCode activated that day
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998690  MoneyCodeTotals  refactor
    Prepare Data To Check The Usage Of An Old MoneyCode
    Validate the MoneyCodes Totals Response  scenario=Old MoneyCode Used

GET Totals of MoneyCode From a Carrier That Does Not Have Activity That Day
    [Documentation]  Test the successful scenario to GET totals of MoneyCodes from a carrier when it doesn't have activity for the day
    [Tags]  PI:15  JIRA:O5SA-360  qTest:116998690  MoneyCodeTotals  refactor
    Prepare Data To Check A Carrier That Does Not Have Activity
    Validate the MoneyCodes Totals Response  scenario=No Activity

*** Keywords ***
Script Startup
    [Documentation]  Startup keyword to be used in the script Setup
    Check For My Automation User
    Generate Data For MoneyCodes Totals

Generate Data For MoneyCodes Totals
    [Documentation]  Create a user and get data to be used in request for MoneyCodes totals
    Get url for suite  ${MoneyCodesAPI}

    Get Into Db  TCH
    ${query}  Catenate  select mc.carrier_id
                   ...  from mon_codes mc
                   ...  inner join contract co on (mc.contract_id = co.contract_id)
                   ...  where co.mcode_bill_on_issue<>'Y'
                   ...  and mc.status = 'A'
                   ...  and (mc.created between today and today + 1)
                   ...  group by carrier_id;
    ${query}  Query And Strip To Dictionary    ${query}
    Disconnect From Database

    IF  len($query)<=0
        Get Into Db  TCH
        ${query}  Catenate  select co.carrier_id, cm.contract_id
                       ...  from contract co
                       ...  left join cont_misc cm on (cm.contract_id = co.contract_id)
                       ...  left join member m on (m.member_id = co.carrier_id and m.mem_type='C')
                       ...  where cm.max_money_code > '0' and co.status = 'A' and m.status='A' limit 250;
        ${query}  Query And Strip To Dictionary    ${query}
        Disconnect From Database

        ${len}  Get Length  ${query}[carrier_id]
        ${len}  Evaluate  random.randint(0, $len-1)

        &{query}  Create Dictionary  carrier_id=${query}[carrier_id][${len}]  contract_id=${query}[contract_id][${len}]

        Create My User  persona_name=carrier_manager  application_name=emgr  entity_id=${query}[carrier_id]  with_data=N

        ${requestBody}  Create Dictionary  amount=7.65  money_code_type=MULTI_USE  issued_to=Robot Daily Activity Auto  fee_type=BILL_LATER  contract_id=${query}[contract_id]  notes=Created for O5SA-360
        ${urlstuff}  Create Dictionary  carriers=${query}[carrier_id]
	    ${response}  ${status}  API Request  POST  money-codes  Y  ${urlstuff}  application=otr_emgr  payload=${requestBody}

        Should Be Equal As Numbers  201  ${status}
    END

    Set Suite Variable  @{carrier_list}  ${query}[carrier_id]

    IF  isinstance($query['carrier_id'], list)
        ${len}  Get Length  ${query}[carrier_id]
        ${len}  Evaluate  random.randint(0, $len-1)
        &{query}  Create Dictionary  carrier_id=${query}[carrier_id][${len}]
    END

    Get Into Db  TCH
    ${query}  Catenate  select carrier_id, count(code_id) as mc_count, NVL(SUM(original_amt), 0.00) as total_orginal_amt
                   ...  from mon_codes
                   ...  where carrier_id='${query}[carrier_id]'
                   ...  and status='A'
                   ...  and voided='N'
                   ...  and (created between today and today + 1)
                   ...  group by carrier_id;
    ${query}  Query And Strip To Dictionary    ${query}
    Disconnect From Database

    Set Suite Variable    ${carrier}  ${query}[carrier_id]
    Set Suite Variable    ${mc_count}  ${query}[mc_count]
    Set Suite Variable    ${total_orginal_amt}  ${query}[total_orginal_amt]

    Get Into Db  TCH
    ${query}  Catenate  Select NVL(SUM(original_amt), 0.00) as charged_amount
                   ...  from mon_codes where status = 'A' and voided = 'N'
                   ...  and carrier_id = '${carrier}'
                   ...  and (first_use between today and today + 1);
    ${query}  Query And Strip To Dictionary    ${query}
    Disconnect From Database

    Set Suite Variable    ${charged_amt}  ${query}[charged_amount]

    Create My User  persona_name=carrier_manager  application_name=emgr  entity_id=${carrier}  with_data=N
               ...  need_new_user=Y  legacy_user=N

GET MoneyCodes Totals Request
    [Documentation]  Make request to the endpoint GET Money Codes totals
    [Arguments]  ${remove}=N  ${whatRemove}=Nothing  ${range}=NotUsed  ${carrier_id}=${carrier}  ${secure}=Y
    ${url_stuff}              Create Dictionary      carriers=${carrier_id}

    IF  '${remove.upper()}'=='Y'
        Remove From Dictionary  ${url_stuff}  ${whatRemove.lower()}
    END

    IF  '${range.upper()}'!='NOTUSED'
        ${optional}  Create Dictionary  range=${range.lower()}
        ${response}  ${status}    API Request  GET  money-code-totals  ${secure}  ${url_stuff}  application=otr_emgr
        ...                                    options=${optional}
    ELSE
        ${response}  ${status}    API Request  GET  money-code-totals  ${secure}  ${url_stuff}  application=otr_emgr
    END

    Set Test Variable  ${status}
    Set Test Variable  ${response}

Prepare Data To Check The Usage Of An Old MoneyCode
    [Documentation]  Prepare the Data to validate the behavior when an old MoneyCode is Used today
    ${query}  Catenate  select code_id, original_amt, express_code
                   ...  from mon_codes where when_voided is null
                   ...  and expire_date is null
                   ...  and expired is null
                   ...  and last_use is null
                   ...  and original_amt <> 0.00
                   ...  and amt_used = 0.00
                   ...  and status = 'A' and carrier_id = '${carrier}'
                   ...  and (created between today - 366 and today - 31)
                   ...  order by created desc limit 200;
    Get Into Db  TCH
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    IF  len($query)<=0
        ${query}  Catenate  select carrier_id, code_id, original_amt, express_code
                       ...  from mon_codes where when_voided is null
                       ...  and expire_date is null
                       ...  and expired is null
                       ...  and last_use is null
                       ...  and original_amt <> 0.00
                       ...  and amt_used = 0.00
                       ...  and (created between today - 366 and today - 31)
                       ...  order by created desc limit 200;
        Get Into Db  TCH
        ${query}  Query And Strip To Dictionary  ${query}
        Disconnect From Database

        ${alt_carrier_check}  Set Variable  yes
    ELSE
        ${alt_carrier_check}  Set Variable  no
    END

    ${len}  Get Length    ${query}[express_code]
    ${len}  Evaluate    random.randint(0, $len-1)

    IF  '${alt_carrier_check}'=='yes'
        ${temp_carrier}  Set Variable  ${query}[carrier_id][${len}]
        ${status}  ${response}  Replace Entity From User    ${auto_user_id}  ${temp_carrier} ${carrier}
        Should Be Equal As Numbers  200  ${status}
    ELSE
        ${temp_carrier}  Set Variable  ${carrier}
    END

    GET MoneyCodes Totals Request  carrier_id=${temp_carrier}
    Should Be Equal As Strings    200  ${status}
    Set Test Variable    ${responseBefore}  ${response}

    Set Test Variable    ${expressCode}  ${query}[express_code][${len}]
    Set Test Variable    ${checkAmount}  ${query}[original_amt][${len}]

    ${code_id}  Set Variable  ${query}[code_id][${len}]

    ${query}  Catenate  select c.check_num
                   ...  from checks c, mon_codes mc
                   ...  where c.code <> 'SETTLEMENT'
                   ...  and c.when_voided is null
                   ...  and mc.code_id = c.ref_id
                   ...  and (c.create_date between today - 366 and today - 91)
                   ...  order by c.create_date desc limit 200;
    Get Into Db  TCH
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    ${len}  Get Length    ${query}[check_num]
    ${len}  Evaluate    random.randint(0, $len-1)

    Set Test Variable    ${checkNumber}  ${query}[check_num][${len}]

    IF  '${checkNumber}'!='${EMPTY}'
        ${query}  Catenate  delete from checks
                       ...  where check_num = '${checkNumber}';
        Get Into Db  TCH
        Execute Sql String    ${query}
        Disconnect From Database
    ELSE
        Fail  Check Number not set for deletation
    END

    Reissue The Check On eManager

    GET MoneyCodes Totals Request  carrier_id=${temp_carrier}

Reissue The Check On eManager
    [Documentation]    Reissue the deleted check to use a Money Code in the eManager webpage

    ${authorizationUrl}  Set Variable  ${emanager}/mgnt/CheckAuthorization.action

    otr_robot_lib.ui.web.PySelenium.Open Automation Browser  url=${authorizationUrl}  browser=${browser}  download_folder=${default_download_path}  headless=True

    Wait Until Element Is Visible    //*[text()="OK"]
    Click Button    //*[text()="OK"]

    Wait Until Element Is Visible    //*[@name="checkNumber"]
    Input Text    //*[@name="checkNumber"]  ${checkNumber}

    Wait Until Element Is Visible    //*[@name="dollarAmount"]
    Input Text  //*[@name="dollarAmount"]  ${checkAmount}

    Wait Until Element Is Visible    //*[@name="nextToCheckLocationPage"]
    Click Element    //*[@name="nextToCheckLocationPage"]

    Wait Until Element Is Visible    //*[@name="locationId"]
    Input Text    //*[@name="locationId"]  231001

    Wait Until Element Is Visible    //*[@name="payee"]
    Input Text    //*[@name="payee"]  Robot Automation O5SA-360

    Wait Until Element Is Visible    //*[@name="moneyCode"]
    Input Text    //*[@name="moneyCode"]  ${expressCode}

    Wait Until Element Is Visible    //*[@name="saveButton"]
    Click Element    //*[@name="saveButton"]

    Wait Until Element Is Visible   //*[@name="finish"]

    ${authNumber}  Get Text  //*[text()="Your authorization number is:"]/../*[2]

    Close Browser

Prepare Data To Check A Carrier That Does Not Have Activity
    [Documentation]  Prepare the environment to validate the behavior when prompting a carrier without activity that day
    ${query}  Catenate  select mc.carrier_id
                   ...  from mon_codes mc
                   ...  inner join contract co on (mc.contract_id = co.contract_id)
                   ...  where co.mcode_bill_on_issue<>'Y'
                   ...  and mc.status = 'A'
                   ...  and (mc.created between today - 366 and today - 2)
                   ...  group by carrier_id limit 1;
    Get Into Db  TCH
    ${query}  Query And Strip To Dictionary  ${query}
    Disconnect From Database

    Create My User  persona_name=carrier_manager  application_name=emgr  entity_id=${query}[carrier_id]  with_data=N

    GET MoneyCodes Totals Request  carrier_id=${query}[carrier_id]

Validate the MoneyCodes Totals Response
    [Documentation]  Validate the status code and response body of the MoneyCodes totals return
    [Arguments]  ${scenario}=default  ${range}=day

    Should Be Equal As Numbers  200  ${status}

    IF  '${scenario.upper()}'=='DEFAULT'
        IF  '${range.upper()}'=='DAY'
            Should Be Equal As Numbers  ${mc_count}  ${response}[details][data][money_code_count]
            Should Be Equal As Numbers  ${total_orginal_amt}  ${response}[details][data][original_amount_total]
            Should Be Equal As Numbers  ${charged_amt}  ${response}[details][data][charged_amount_total]
        ELSE
            Fail    Range '${range}' not implemented
        END
    ELSE IF  '${scenario.upper()}'=='NO ACTIVITY'
            Should Be Equal As Numbers  0  ${response}[details][data][money_code_count]
            Should Be Equal As Numbers  0  ${response}[details][data][original_amount_total]
            Should Be Equal As Numbers  0  ${response}[details][data][charged_amount_total]
    ELSE IF  '${scenario.upper()}'=='OLD MONEYCODE USED'
        ${newCharged}  Set Variable    ${responseBefore}[details][data][charged_amount_total]
        ${newCharged}  Evaluate    float($newCharged) + float($checkAmount)

        Should Be Equal As Numbers  ${responseBefore}[details][data][money_code_count]  ${response}[details][data][money_code_count]
        Should Be Equal As Numbers  ${responseBefore}[details][data][original_amount_total]  ${response}[details][data][original_amount_total]
        Should Be Equal As Numbers  ${newCharged}  ${response}[details][data][charged_amount_total]
    END

GET MoneyCodes Totals When ${error}
    [Documentation]  Verify the behavior of the endpoint when sending possible invalid values during a request
    IF  '${error.upper()}'=='NOT SENDING CARRIER ID'
        GET MoneyCodes Totals Request  remove=Y  whatRemove=carriers

        Should Be Equal As Numbers  404  ${status}
    ELSE IF  '${error.upper()}'=='SENDING AN INVALID CARRIER ID' or '${error.upper()}'=='SENDING LETTERS AS CARRIER ID' or '${error.upper()}'=='CHECK NON RELATED CARRIER'

        IF  '${error.upper()}'=='SENDING AN INVALID CARRIER ID'
            GET MoneyCodes Totals Request  carrier_id=8888888
        ELSE IF  '${error.upper()}'=='SENDING LETTERS AS CARRIER ID'
            GET MoneyCodes Totals Request  carrier_id=ABCDEF
        ELSE IF  '${error.upper()}'=='CHECK NON RELATED CARRIER'
            ${query}  Catenate  select mc.carrier_id
                           ...  from mon_codes mc
                           ...  inner join contract co on (mc.contract_id = co.contract_id)
                           ...  where co.mcode_bill_on_issue<>'Y'
                           ...  and mc.status = 'A'
                           ...  and mc.carrier_id<>'${carrier}'
                           ...  and (mc.created between today - 365 and today + 1)
                           ...  group by carrier_id limit 1;
            Get Into Db  TCH
            ${query}  Query And Strip To Dictionary  ${query}
            Disconnect From Database

            GET MoneyCodes Totals Request  carrier_id=${query}[carrier_id]
        END

        Should Be Equal As Numbers  403  ${status}
        Should Be Equal As Strings  FORBIDDEN  ${response}[name]
        Should Be Equal As Strings  Access Denied  ${response}[message]
    ELSE IF  '${error.upper()}'=='SENDING AN EMPTY RANGE PARAMETER'
        GET MoneyCodes Totals Request  range=${EMPTY}

        Should Be Equal As Numbers  200  ${status}
    ELSE IF  '${error.upper()}'=='SENDING AN INVALID RANGE PARAMETER'
        GET MoneyCodes Totals Request  range=Invalid

        Should Be Equal As Numbers  200  ${status}
    ELSE IF  '${error.upper()}'=='USING AN INVALID TOKEN'
        GET MoneyCodes Totals Request  secure=I

        Should Be Equal As Numbers  401  ${status}
        Should be Equal  ${EMPTY}  ${response}
    ELSE IF  '${error.upper()}'=='USING AN USER WITHOUT PERMISSION'
        ${status}  ${response}  Assign Persona And Application To User    ${auto_user_id}  otr_tester_two  OTR_eMgr
        Should Be Equal As Numbers  200  ${status}

        GET MoneyCodes Totals Request

        Should Be Equal As Numbers  403  ${status}
        Should be Equal  ${EMPTY}  ${response}

        ${status}  ${response}  Assign Persona And Application To User    ${auto_user_id}  carrier_manager  OTR_eMgr
        Should Be Equal As Numbers  200  ${status}
    ELSE
        Fail  '${error}' is not an Expected Error
    END