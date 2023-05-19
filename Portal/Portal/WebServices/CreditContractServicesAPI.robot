*** Settings ***
Library  String
Library  Collections
Library  otr_robot_lib.ws.PortalWS
Library  otr_model_lib.services.GenericService
Library  otr_robot_lib.ws.RestAPI.RestAPIService
Library  otr_robot_lib.ws.CreditContractServicesAPI.CreditContractAPIService
Library  otr_robot_lib.ws.OKTA_Automation_User.OKTA_Automation_User
Resource  otr_robot_lib/robot/PortalKeywords.robot


Documentation  This is to test the Credit Contract API (currently only works in dit because okta service is set up there) --MORE ENDPOINTS COMING
Force Tags     CreditContractAPI    API  refactor

Suite Setup  Get Url For Suite    ${creditcontract}

*** Variables ***
@{limit_method}  NONE  OVERALL_CREDIT  DAILY  CREDIT_DAILY  TAB_DRAW_DOWN  LOAD_DRAW_DOWN  CHILD_CARRIER
@{endpoints}  INV  SUM  CC  CA  FUNDS  TOVERDUE BA
&{default_options}  page=0  size=10

*** Test Cases ***
##################################################### BANK ACCOUNTS ######################################################
GET Bank Accounts
    [Tags]  JIRA:O5SA-297  qTest:53707647   BANK_ACCOUNTS
    [Documentation]  test the get bankaccounts endpoints
    [Setup]  Create My User  bank_acct_mgr_all_types
    Test Request  BA
    Compare Data  BA
    Test Paging  BA
    Test Incorrect User  BA
    Test Invalid Token  BA
    [Teardown]  Remove Automation User

######################################################## PAYMENTS ########################################################

######################################################## INVOICES ########################################################

GET Open Invoices
    [Tags]  JIRA:PORT-603  JIRA:PORT-630  JIRA:FIVE-110  qTest:247070533    qTest:247070534     qTest:248545641     qTest:247071757     INVOICES
    [Documentation]  DEPRECATED test the get endpoints for invoices, should return 404
    [Setup]  Create My User  carrier_manager
    Test Request  INV
    Compare data  INV
    Test Paging  INV
    Test Sort  INV
    Test Incorrect User  INV
    Test Invalid Token  INV
    [Teardown]  Remove Automation User

GET Total Overdue Invoices
    [Tags]  PI:13  JIRA:O5SA-302  qTest:54171441    INVOICES
    [Documentation]  test the endpoint to get total number of overdue invoices
    [Setup]  Create My User  carrier_manager
    Test Request  TOVERDUE
    Compare data  TOVERDUE
    Test Incorrect User  TOVERDUE
    Test Invalid Token  TOVERDUE
    [Teardown]  Remove Automation User
#################################################### FUNDS TRANSFERS #####################################################
GET Funds Transfers
    [Tags]  JIRA:FIVE-118  qTest:54036369   FUNDS_TRANSFERS
    [Documentation]  test the get endpoint for funds transfer
    [Setup]  Create My User  carrier_pf_credit
    Test Request  FUNDS
    Compare data  FUNDS
    Test Paging  FUNDS
    Test Incorrect User  FUNDS
    Test Invalid Token  FUNDS
    [Teardown]  Remove Automation User

######################################################## CONTRACTS #######################################################
GET Contracts using carrier_id and contract_id
    [Tags]  JIRA:PORT-603  JIRA:PORT-630  FIVE-110  qTest:247070533     qTest:247070534     qTest:248545641     qTest:247071757   CONTRACTS
    [Documentation]  test the get contracts endpoints
    [Setup]  Create My User  carrier_manager
    Test Request  CC
    Compare Data  CC
    Test Paging  CC
    Test Incorrect User  CC
    Test Invalid Token  CC
    [Teardown]  Remove Automation User

GET Contracts using carrier_id and ar_number
    [Tags]  JIRA:PORT-603  JIRA:PORT-630  FIVE-110  qTest:247070533     qTest:247070534     qTest:248545641     qTest:247071757   CONTRACTS
    [Documentation]  test the get contracts endpoints
    [Setup]  Create My User  carrier_manager
    Test Request  CA
    Compare Data  CA
    Test Paging  CA
    Test Incorrect User  CA
    Test Invalid Token  CA
    [Teardown]  Remove Automation User

GET Contract Summaries
    [Tags]  JIRA:PORT-603  JIRA:PORT-630  JIRA:FIVE-110  qTest:247070533    qTest:247070534     qTest:248545641     qTest:247071757  CONTRACTS
    [Documentation]  test the get summaries endpoint
    [Setup]  Create My User  carrier_manager
    Test Request  SUM
    Compare data  SUM
    Test Paging  SUM
    Test Incorrect User  SUM
    Test Invalid Token  SUM
    [Teardown]  Remove Automation User


PATCH Contracts using carrier_id and contract_id
    [Tags]  JIRA:PORT-603   JIRA:FIVE-110    qTest:247071637    qTest:247071638  CONTRACTS
    [Documentation]  test the patch contract endpoint that uses carrier id and contract id
    [Setup]  Create My User  am_admin
    Test Request  CC
    Test Incorrect User  CC
    Test Invalid Token  CC
    [Teardown]  Clean up  CC

PATCH Contracts using carrier_id and ar_number
    [Tags]  JIRA:PORT-603  JIRA:FIVE-110    qTest:247071637     qTest:247071638  CONTRACTS
    [Documentation]  test the patch contract endpoint that uses carrier id and ar number
    [Setup]  Create My User  am_admin  #100004
    Test Request  CA
    Test Incorrect User  CA
    Test Invalid Token  CA
    [Teardown]  Clean up  CA

*** Keywords ***
#################GET####################
Get requests Contract Summaries
    [Documentation]  tests the summaries get request
    [Arguments]  ${type}  ${carrier}=${api_dict}[carrier_id]  ${optionals}=${default_options}
    IF  ${optionals}==${default_options}
        set test variable  ${optionals}  ${default_options}
    ELSE
        set test variable  ${optionals}  ${optionals}
    END
    ${carrier}  create dictionary  carriers=${carrier}  summaries=${None}
    IF  ${optionals}==${None}
        ${result}  ${status}  get contracts  ${carrier}
    ELSE
        ${result}  ${status}  get contracts  ${carrier}  ${optionals}
    END

    Check Result  ${result}
    [Return]  ${result}

GET requests Contract
    [Documentation]  keyword for GET contract endpoints using carrier_id and contract_id or ar_number.
    [Arguments]  ${type}  ${carrier}=${api_dict}[carrier_id]
    IF  '${type}'=='CA'
        ${url_info}  create dictionary  carriers=${carrier}  ar-numbers=${api_dict}[ar_number]
        ${results}  ${status}  get contracts  ${url_info}
    ELSE IF  '${type}'=='CC'
        ${url_info}  create dictionary  None=${api_dict}[contract_id]  carriers=${carrier}
        ${results}  ${status}  get contracts  ${url_info}
    END
    Check Result  ${results}
    [Return]  ${results}

Get requests Open Invoices
    [Documentation]  keyword for GET invoices endpoint
    [Arguments]  ${type}  ${carrier}=${api_dict}[carrier_id]  ${sort}=${None}  ${optionals}=${default_options}
    IF  '''${sort}'''=='''${NONE}''' and '''${optionals}'''=='''${NONE}'''
        &{options_dict}  create dictionary  page=0  size=10
        set test variable  ${optionals}  ${options_dict}
    ELSE IF  '''${sort}'''!='''${NONE}''' and '''${optionals}'''!='''${NONE}'''
        set to dictionary  ${optionals}  sort=${sort}
        set test variable  ${optionals}  ${optionals}
    ELSE IF  '''${sort}'''!='''${NONE}''' and '''${optionals}'''=='''${NONE}'''
        &{options_dict}  create dictionary  page=0  size=10  sort=${sort}
        set test variable  ${optionals}  ${options_dict}
    ELSE IF  '''${sort}'''=='''${NONE}''' and '''${optionals}'''!='''${NONE}'''
        set to dictionary  ${optionals}  sort=dueDate,desc
        set test variable  ${optionals}  ${optionals}
    ELSE
        &{options_dict}  create dictionary  page=0  size=10  sort=dueDate,desc
        set test variable  ${optionals}  ${options_dict}
    END
    ${url_info}  create dictionary  carriers=${carrier}  contracts=${api_dict}[contract_id]


    IF  ${optionals}==${None}
        ${result}  ${status}  get open invoices  ${url_info}
        Run keyword if  ${status}==404  pass execution  expected 404, test case will fail
    ELSE
        ${result}  ${status}  get open invoices  ${url_info}  ${optionals}
        Run keyword if  ${status}==404  pass execution  expected 404, test case will fail
    END
    Check Result  ${result}
    [Return]  ${result}

Get requests Funds Transfers
    [Documentation]  keyword for GET funds transfers endpoint
    [Arguments]  ${type}  ${carrier}=${api_dict}[carrier_id]  ${optionals}=${default_options}
    IF  ${optionals}==${default_options}
        set test variable  ${optionals}  ${default_options}
    ELSE
        set test variable  ${optionals}  ${optionals}
    END
    ${url_info}  create dictionary  carriers=${carrier}  contracts=${api_dict}[contract_id]

    IF  ${optionals}==${None}
        ${result}  ${status}  get fundstransfers  ${url_info}
    ELSE
        remove from dictionary  ${optionals}  sort
        ${result}  ${status}  get fundstransfers  ${url_info}  ${optionals}
    END
    Check Result  ${result}
    [Return]  ${result}

Get requests Total Overdue Invoices
    [Documentation]  keyword for GET total number of overdue invoices
    [Arguments]  ${type}  ${carrier}=${api_dict}[carrier_id]
    ${url_info}  create dictionary  carriers=${carrier}  contracts=${api_dict}[contract_id]
    ${result}  ${status}  get total overdue invoices  ${url_info}
    Check Result  ${result}
    [Return]  ${result}

Test Paging
    [Arguments]  ${type}
    ${type}  String.convert to upper case  ${type}
    GET request with Negative Page  ${type}
    GET request with Negative Size  ${type}
    Get with Paging Optionals  ${type}

Test Sort
    [Arguments]  ${type}
    ${type}  String.convert to upper case  ${type}
    get request with asc sort  ${type}
    get request with desc sort  ${type}

#change paging to use robot keywords instead of python keyword
GET request with Negative Page
    [Documentation]  keyword to test a negative pagenumber value for a request
    [Arguments]  ${item}
    &{options_dict}  create dictionary  page=-1  size=5
    set test variable  ${optionals}  ${options_dict}

    IF  '${item}' == 'CC'
        log to console  ${item} does not use paging
        Compare Data  ${item}
    ELSE IF  '${item}' == 'CA'
        log to console  ${item} does not use paging
    ELSE IF  '${item}' == 'SUM'
        Get requests Contract Summaries  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${options_dict}
        Compare Data  ${item}
    ELSE IF  '${item}' == 'INV'
        IF  'Open' in """${TEST_NAME}"""
            Get requests Open Invoices  type=${item}  carrier=${api_dict}[carrier_id]   optionals=${options_dict}
        END
        Compare Data  ${item}
    ELSE IF  '${item}'=='FUNDS'
        remove from dictionary  ${options_dict}  sort
        Get requests Funds Transfers  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${options_dict}
        Compare Data  ${item}
    ELSE IF  '${item}'=='BA'
        Get requests Bank Accounts  type=${item}  carrier=${api_dict}[carrier_id] contract=${api_dict}[contract_id] contract_type=${api_dict}[contract_type]  optionals=${options_dict}
        Compare Data  ${item}
    ELSE
        log to console  ${item} not yet implemented
    END

GET request with Negative Size
    [Documentation]  keyword to test a negative pagesize value for a request
    [Arguments]  ${item}
    &{options_dict}  create dictionary  page=1  size=-5
    set test variable  ${optionals}  ${options_dict}

    IF  '${item}' == 'CC'
        log to console  ${item} does not use paging
    ELSE IF  '${item}' == 'CA'
        log to console  ${item} does not use paging
    ELSE IF  '${item}' == 'BA'
        Get requests Bank Accounts  type=${item}  carrier=${api_dict}[carrier_id]
        Compare Data  ${item}
    ELSE IF  '${item}' == 'SUM'
        Get requests Contract Summaries  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${options_dict}
        Compare Data  ${item}
    ELSE IF  '${item}' == 'INV'
        ${values}  split string  ${TEST_NAME}
        IF  'Open' in """${TEST_NAME}"""
            Get requests Open Invoices  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${options_dict}
        END
        Compare Data  ${item}
    ELSE IF  '${item}'=='FUNDS'
        remove from dictionary  ${options_dict}  sort
        Get requests Funds Transfers  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${options_dict}
        Compare Data  ${item}
    ELSE
        log to console  ${item} not yet implemented
    END


Get with Paging Optionals
    [Documentation]  Tests the paging of get requests
    [Arguments]  ${item}
    &{option1_dict}  create dictionary  page=a  size=5
    &{option2_dict}  create dictionary  page=0  size=p

    IF  '${item}' == 'CC'
       log to console  ${item} does not use paging
    ELSE IF  '${item}' == 'CA'
        log to console  ${item} does not use paging
    ELSE IF  '${item}' == 'SUM'
        Get requests Contract Summaries  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${option1_dict}
        set test variable  ${optionals}  ${option1_dict}
        Compare Data  ${item}
        Get requests Contract Summaries  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${option2_dict}
        set test variable  ${optionals}  ${option2_dict}
        Compare Data  ${item}
    ELSE IF  '${item}' == 'INV'
        IF  'Open' in """${TEST_NAME}"""
            Get requests Open Invoices  type=${item}  carrier=${api_dict}[carrier_id]   optionals=${option1_dict}
        END
        set test variable  ${optionals}  ${option1_dict}
        Compare Data  ${item}
        IF  'Open' in """${TEST_NAME}"""
            Get requests Open Invoices  type=${item}  carrier=${api_dict}[carrier_id]   optionals=${option2_dict}
        END
        set test variable  ${optionals}  ${option2_dict}
        Compare Data  ${item}
    ELSE IF  '${item}'=='FUNDS'
        Get requests Funds Transfers  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${option1_dict}
        set test variable  ${optionals}  ${option1_dict}
        Compare Data  ${item}
        Get requests Funds Transfers  type=${item}  carrier=${api_dict}[carrier_id]  optionals=${option2_dict}
        set test variable  ${optionals}  ${option2_dict}
        Compare Data  ${item}
     ELSE IF  '${item}'=='BA'
        Get requests Bank Accounts  type=${item}  carrier=${api_dict}[carrier_id]   optionals=${option1_dict}
        set test variable  ${optionals}  ${option1_dict}
        Compare Data  ${item}
        Get requests Bank Accounts  type=${item}  carrier=${api_dict}[carrier_id]   optionals=${option2_dict}
        set test variable  ${optionals}  ${option2_dict}
        Compare Data  ${item}
    ELSE
        log to console  ${item} not yet implemented
    END

GET request with ASC sort
    [Documentation]  Test request with ascending sort
    [Arguments]  ${type}
    #TODO add to as sorts are applied to endpoints

    IF  '${type}' == 'INV'
        IF  'Open' in """${TEST_NAME}"""
            Get requests Open Invoices  sort=dueDate,asc  type=${type}
        END
        Compare Data  ${type}
    ELSE
        log to console  ${type} not yet implemented
    END


GET request with DESC sort
    [Documentation]  Test request with descending sort
    [Arguments]  ${type}
    IF  '${type}' == 'INV'
        IF  'Open' in """${TEST_NAME}"""
            Get requests Open Invoices  sort=dueDate,desc  type=${type}
        END
        Compare Data  ${type}
    ELSE
        log to console  ${type} not yet implemented
    END


Get requests Bank Accounts
    [Documentation]  keyword for GET bank account endpoints using carrier_id and contract_id and contract_type.
    [Arguments]  ${type}  ${carrier}=${api_dict}[carrier_id]   ${optionals}=${default_options}


    IF  ${optionals}==${default_options}

        set test variable  ${optionals}  ${default_options}
    ELSE
        set test variable  ${optionals}  ${optionals}
    END
    ${url_info}  create dictionary  carriers=${api_dict}[carrier_id]   contracts=${api_dict}[contract_id]  contract-types=${api_dict}[contract_type]

    IF  ${optionals}==${None}
        ${result}  ${status}  get bank accounts  ${url_info}
    ELSE
        ${result}  ${status}  get bank accounts  ${url_info}   ${optionals}
    END
    Check Result  ${result}
    [Return]  ${result}
#########PATCH################

Change Contracts to Original Value
    [Documentation]  change the limit method back to the original value
    [Arguments]  ${type}
    get pkce token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr
    IF  '${og_limit_method}'!='${EMPTY}'
        ${og_method_dict}  create dictionary  limit_method=${og_limit_method}
        IF  '${type}'=='CA'
            ${url_stuff}  create dictionary  carriers=${api_dict}[carrier_id]  ar-numbers=${api_dict}[ar_number]
            ${result}  ${status}  patch contracts  ${url_stuff}  payload=${og_method_dict}
        ELSE IF  '${type}'=='CC'
            ${url_stuff}  create dictionary  None=${api_dict}[contract_id]  carriers=${api_dict}[carrier_id]
            ${result}  ${status}  patch contracts  ${url_stuff}  payload=${og_method_dict}
        END
        should be equal  ${result}[details][data][limit_method]  ${og_limit_method}
    END

PATCH requests Contracts
    [Documentation]  test for PATCH request.
    [Arguments]  ${type}
    ${limit_value}  evaluate  random.choice(@{limit_method})  random
    ${new_limit_method}  create dictionary  limit_method=${limit_value}
    IF  '${type}'=='CA'
        ${url_stuff}  create dictionary  carriers=${api_dict}[carrier_id]  ar-numbers=${api_dict}[ar_number]
        ${result}  ${status}  get contracts  ${url_stuff}
        Check Result  ${result}
        IF  'SUCCESSFUL' in """${result}"""
            set test variable  ${og_limit_method}  ${result}[details][data][limit_method]
            ${url_stuff}  create dictionary  carriers=${api_dict}[carrier_id]  ar-numbers=${api_dict}[ar_number]
            ${result}  ${status}  patch contracts  ${url_stuff}  payload=${new_limit_method}
        END
    ELSE IF  '${type}'=='CC'
        ${url_stuff}  create dictionary  carriers=${api_dict}[carrier_id]  ar-numbers=${api_dict}[ar_number]
        ${result}  ${status}  get contracts  ${url_stuff}
        Check Result  ${result}
        IF  'SUCCESSFUL' in """${result}"""
            set test variable  ${og_limit_method}  ${result}[details][data][limit_method]
            ${url_stuff}  create dictionary  None=${api_dict}[contract_id]  carriers=${api_dict}[carrier_id]
            ${result}  ${status}  patch contracts  ${url_stuff}  payload=${new_limit_method}
        END
    ELSE
        log to console  ${type} not implemented
    END

Compare Data
    [Arguments]  ${type}
    ${type}  String.convert to upper case  ${type}
    IF  '${type}'=='CC' or '${type}'=='CA'
        ${result_from_DB}  Get Database Values  ${type}
            ${db_dict}  ${api_dict}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
            Lists should be equal  ${db_dict}  ${api_dict}
    ELSE IF  '${type}'=='INV'
        ${result_from_DB}  Get Database Values  ${type}
            ${some_db_data}  ${some_api_data}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
            Lists should be equal  ${some_db_data}  ${some_api_data}
    ELSE IF  '${type}'=='FUNDS'
        ${result_from_DB}  Get Database Values  ${type}
            ${some_db_data}  ${some_api_data}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
            Lists should be equal  ${some_db_data}  ${some_api_data}
    ELSE IF  '${type}'=='SUM'
        ${result_from_DB}  Get Database Values  ${type}
        ${some_db_data}  ${some_api_data}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
         Lists should be equal  ${some_db_data}  ${some_api_data}
    ELSE IF  '${type}'=='TOVERDUE'
       ${result_from_DB}  Get Database Values  ${type}
            ${some_db_data}  ${some_api_data}  Make Dictionaries  ${type}  ${result_from_DB}  ${api_result}
            Lists should be equal  ${some_db_data}  ${some_api_data}
    ELSE IF  '${type}'=='BA'
            ${result_from_DB}  Get Database Values  ${type}
            ${db_dict}  ${api_dict}  Make Dictionaries  ${type}  ${result_from_DB}   ${api_result}
            Lists should be equal  ${db_dict}  ${api_dict}
    ELSE
        log to console  type ${type} not supported
        return from keyword
    END

Get Database Values
    [Arguments]  ${type}  ${optionals}=${EMPTY}
    IF  '${type}'=='CC' or '${type}'=='CA'
        ${db_values}  Get Contracts Request Information from Database
    ELSE IF  '${type}'=='INV'
        ${db_values}  Get Invoice Request Information from Database
    ELSE IF  '${type}'=='SUM'
        ${db_values}  Get Summaries Request Information from Database
    ELSE IF  '${type}'=='FUNDS'
        ${db_values}  Get Funds Request Information from Database
    ELSE IF  '${type}'=='TOVERDUE'
        ${db_values}  Get Overdue Invoice Request Information from Database
    ELSE IF  '${type}'=='BA'
        ${db_values}  Get Bank Account Information from Database
    ELSE
        log to console  type ${type} not supported
    END
    [Return]  ${db_values}

Get Overdue Invoice Request Information from Database
    [Documentation]  query to return total number of overdue invoices
    get into db  Oracle

    ${overdue_query}  catenate  SELECT COUNT(*) AS total_overdue_invoices
    ...  FROM apps.xxtch_ar_stmt_trx_v
    ...  WHERE ar_number = '${api_dict}[ar_number]'
    ...  AND   trx_status = 'OPEN'
    ...  AND   due_date < SYSDATE

    ${result}  query to dictionaries  ${overdue_query}
    [Return]  ${result}

Get Summaries Request Information from Database
    [Documentation]  a simple query for getting some information for summaries from the database

    ${page}  ${size}  Check Options

    get into db  TCH
    ${query}  catenate  SELECT  SKIP ${page} FIRST ${size}
    ...  TRIM(ar_number) AS ar_number, carrier_id, contract_id  #, issuer_id
    ...  FROM contract
    ...  WHERE carrier_id = '${api_dict}[carrier_id]'
    ${query}  query to dictionaries  ${query}
    [Return]  ${query}

Get Invoice Request Information from Database
    [Documentation]  Query for getting the invoice information from the database
    ${page}  ${size}  Check Options

    IF  'sort' in ${optionals}
        @{words}  split string  ${optionals}[sort]  ,
        ${field}  evaluate  re.sub(r'(?<![A-Z\W])(?=[A-Z])', '_', $words[0])  re
        ${field}  String.convert to lower case  ${field}
        ${sort}  set variable  ORDER BY ${field} ${words}[1]
    ELSE
        ${sort}  set variable  ORDER BY ct.trx_date DESC
    END

    get into db  Oracle
    IF  'Open' in """${TEST_NAME}"""
    ${query}  catenate  SELECT
    ...     customer_id AS invoice_id,
    ...     invoice_number,
    ...     ar_number,
    ...     invoice_date,
    ...     due_date,
    ...     original_amount,
    ...     open_amount,
    ...     pending_payments,
    ...     late_fees
    ...  FROM(
    ...  SELECT TO_CHAR(aropeninvo0_.customer_trx_id) AS customer_id,
    ...   aropeninvo0_.ar_number AS ar_number,
    ...   TO_CHAR(aropeninvo0_.due_date, 'YYYY-MM-DD') AS due_date,
    ...   TO_CHAR(aropeninvo0_.trx_date, 'YYYY-MM-DD') AS invoice_date,
    ...   aropeninvo0_.trx_number AS invoice_number,
    ...   TO_CHAR(aropeninvo0_.late_fees) AS late_fees,
    ...   TO_CHAR(aropeninvo0_.amount_due_remaining) AS open_amount,
    ...   TO_CHAR(aropeninvo0_.amount_due_original) AS original_amount,
    ...  TO_CHAR(aropeninvo0_.payments_pending) AS pending_payments,
    ...  row_number() OVER (${sort}) rnk
    ...    FROM apps.xxtch_ar_open_trx_v aropeninvo0_
    ...    WHERE aropeninvo0_.ar_number = '${api_dict}[ar_number]'
    ...    ${sort}
    ...  ) WHERE rnk BETWEEN ${page} AND ${size}
    ELSE IF  'Closed' in """${TEST_NAME}"""
        #TODO add the closed status query when finished
        log to console  closed status
    ELSE IF  'All' in """${TEST_NAME}"""
        #TODO add the all status query when finished
        log to console  all status
    ELSE
        log to console  in the else
    END

    ${query}  query to dictionaries  ${query}
    [Return]  ${query}

Get Contracts Request Information from Database
    [Documentation]  Query(s) for getting Contracts information from the database
    get into db  TCH

    ${big_query}  catenate  SELECT contract0_.contract_id AS contract_id,
    ...   contract0_.carrier_id AS carrier_id,
    ...   TRIM(contract0_.ar_number) AS ar_number,
    ...   CASE
    ...     WHEN contract0_.atm_allowed = 'Y' THEN TRIM('True')
    ...     WHEN contract0_.atm_allowed = 'N' THEN TRIM('False')
    ...     ELSE TRIM('False')
    ...   END AS atm_allowed,
    ...   CASE
    ...     WHEN contract0_.carry_forward = 'Y' THEN TRIM('True')
    ...     WHEN contract0_.carry_forward = 'N' THEN TRIM('False')
    ...     ELSE TRIM('False')
    ...   END AS carry_forward,
    ...   CASE WHEN contract0_.cash_adv_fee::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.cash_adv_fee, '&.#'))
    ...         WHEN contract0_.cash_adv_fee::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.cash_adv_fee, '########################&.#'))
    ...         WHEN contract0_.cash_adv_fee::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.cash_adv_fee, '########################&.##'))
    ...         ELSE NULL
    ...   END AS cash_adv_fee,
    ...   contract0_.cash_trans_limit AS cash_trans_limit,
    ...   CASE WHEN contract0_.check_fee::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.check_fee, '&.#'))
    ...         WHEN contract0_.check_fee::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.check_fee, '########################&.#'))
    ...         WHEN contract0_.check_fee::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.check_fee, '########################&.##'))
    ...         ELSE NULL
    ...   END AS check_fee,
    ...   contract0_.chks_per_fee AS chks_per_fee,
    ...   CASE WHEN contract0_.combination_fee::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.combination_fee, '&.#'))
    ...         WHEN contract0_.combination_fee::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.combination_fee, '########################&.#'))
    ...         WHEN contract0_.combination_fee::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.combination_fee, '########################&.##'))
    ...         ELSE NULL
    ...   END AS combination_fee,
    ...   CASE WHEN contract0_.non_area_fee::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.non_area_fee, '&.#'))
    ...         WHEN contract0_.non_area_fee::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.non_area_fee, '########################&.#'))
    ...         WHEN contract0_.non_area_fee::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.non_area_fee, '########################&.##'))
    ...         ELSE NULL
    ...   END AS non_area_fee,
    ...   CASE WHEN contract0_.credit_limit::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.credit_limit, '&.#'))
    ...         WHEN contract0_.credit_limit::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.credit_limit, '########################&.#'))
    ...         WHEN contract0_.credit_limit::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.credit_limit, '########################&.##'))
    ...         ELSE NULL
    ...   END AS credit_limit,
    ...   contract0_.currency AS currency,
    ...   contract0_.cycle_code AS cycle_code,
    ...   CASE WHEN contract0_.daily_cadv_limit::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.daily_cadv_limit, '&.#'))
    ...         WHEN contract0_.daily_cadv_limit::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.daily_cadv_limit, '########################&.#'))
    ...         WHEN contract0_.daily_cadv_limit::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.daily_cadv_limit, '########################&.##'))
    ...         ELSE NULL
    ...   END AS daily_cadv_limit,
    ...   CASE WHEN contract0_.daily_code_limit::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.daily_code_limit, '&.#'))
    ...         WHEN contract0_.daily_code_limit::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.daily_code_limit, '########################&.#'))
    ...         WHEN contract0_.daily_code_limit::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.daily_code_limit, '########################&.##'))
    ...         ELSE NULL
    ...   END AS daily_code_limit,
    ...   CASE WHEN contract0_.daily_limit::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.daily_limit, '&.#'))
    ...         WHEN contract0_.daily_limit::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.daily_limit, '########################&.#'))
    ...         WHEN contract0_.daily_limit::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.daily_limit, '########################&.##'))
    ...         ELSE NULL
    ...   END AS daily_limit,
    ...   contract0_.description AS description,
    ...   CASE WHEN contract0_.limit_fee::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.limit_fee, '&.#'))
    ...         WHEN contract0_.limit_fee::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.limit_fee, '########################&.#'))
    ...         WHEN contract0_.limit_fee::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.limit_fee, '########################&.##'))
    ...         ELSE NULL
    ...   END AS limit_fee,
    ...   CASE WHEN contract0_.limit_fee_amt::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.limit_fee_amt, '&.#'))
    ...         WHEN contract0_.limit_fee_amt::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.limit_fee_amt, '########################&.#'))
    ...         WHEN contract0_.limit_fee_amt::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.limit_fee_amt, '########################&.##'))
    ...         ELSE NULL
    ...   END AS limit_fee_amt,
    ...   CASE WHEN contract0_.nsf = 'Y' THEN TRIM('True')
    ...        WHEN contract0_.nsf = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS nsf,
    ...   contract0_.credit_queue AS queue_id,
    ...   contract0_.status AS status,
    ...   TRIM(contract0_.terms) AS terms,
    ...   contract0_.trans_limit::VARCHAR(50) AS trans_limit,
    ...   CASE WHEN contract0_.is_master = 'Y' THEN TRIM('True')
    ...        WHEN contract0_.is_master = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS is_master,
    ...   CASE WHEN contract0_.contract_debit = 'Y' THEN TRIM('True')
    ...        WHEN contract0_.contract_debit = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS contract_debit,
    ...   contract0_.atm_fee AS atm_fee,
    ...   CASE WHEN contract0_.carrier_fee::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.carrier_fee, '&.#'))
    ...         WHEN contract0_.carrier_fee::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.carrier_fee, '########################&.#'))
    ...         WHEN contract0_.carrier_fee::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.carrier_fee, '########################&.##'))
    ...         ELSE NULL
    ...   END AS carrier_fee,
    ...   CASE WHEN contract0_.bill_on_master = 'Y' THEN TRIM('True')
    ...        WHEN contract0_.bill_on_master = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS bill_on_master,
    ...   CASE WHEN contract0_1_.collections = 'Y' THEN TRIM('True')
    ...        WHEN contract0_1_.collections = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS collections,
    ...   contract0_1_.fee_flag AS fee_flag,
    ...   CASE WHEN contract0_1_.fraud = 'Y' THEN TRIM('True')
    ...        WHEN contract0_1_.fraud = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS fraud,
    ...   contract0_1_.max_money_code AS max_money_code,
    ...   TRIM(contract0_1_.mgr_code) AS mgr_code,
    ...   CASE WHEN contract0_1_.reg_check_flag = 'Y' THEN TRIM('True')
    ...        WHEN contract0_1_.reg_check_flag = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS reg_check_flag,
    ...   contract0_1_.stmt_deliver_via AS stmt_deliver_via,
    ...   CASE WHEN contract0_1_.ach_allowed = 'Y' THEN TRIM('True')
    ...        WHEN contract0_1_.ach_allowed = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS ach_allowed,
    ...   contract0_1_.ach_velocity AS ach_velocity,
    ...   contract0_1_.ach_min_amt AS ach_min_amt,
    ...   contract0_1_.ach_max_amt AS ach_max_amt,
    ...   CASE WHEN contract0_1_.phone_chk_fee::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_1_.phone_chk_fee, '&.#'))
    ...         WHEN contract0_1_.phone_chk_fee::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_1_.phone_chk_fee, '########################&.#'))
    ...         WHEN contract0_1_.phone_chk_fee::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_1_.phone_chk_fee, '########################&.##'))
    ...         ELSE NULL
    ...   END AS phone_chk_fee,
    ...   TRIM(contract0_1_.comment_1) AS comment1,
    ...   TRIM(contract0_1_.comment_2) AS comment2,
    ...   CASE WHEN contract0_.credit_bal::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.credit_bal, '&.#'))
    ...         WHEN contract0_.credit_bal::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.credit_bal, '########################&.#'))
    ...         WHEN contract0_.credit_bal::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.credit_bal, '########################&.##'))
    ...         ELSE NULL
    ...   END AS credit_bal,
    ...   CASE WHEN contract0_.daily_bal::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(contract0_.daily_bal, '&.#'))
    ...         WHEN contract0_.daily_bal::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(contract0_.daily_bal, '########################&.#'))
    ...         WHEN contract0_.daily_bal::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(contract0_.daily_bal, '########################&.##'))
    ...         ELSE NULL
    ...   END AS daily_bal,
    ...   contract0_.issuer_id AS issuer_id
    ...   FROM contract contract0_
    ...   LEFT OUTER JOIN cont_misc contract0_1_ ON contract0_.contract_id = contract0_1_.contract_id
    ...   WHERE contract0_.carrier_id = ${api_dict}[carrier_id]
    ...   AND contract0_.contract_id = ${api_dict}[contract_id]

    ${big_query_dictionary}  query to dictionaries  ${big_query}
    ${result_list}  set variable  ${big_query_dictionary}

    ${irv_query}  catenate  SELECT
    ...   irvcontrac0_.aci_value AS aci_value,
    ...   irvcontrac0_.bond_value AS bond_value,
    ...   CASE WHEN irvcontrac0_.fin_on_file = 'Y' THEN TRIM('True')
    ...        WHEN irvcontrac0_.fin_on_file = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS fin_on_file,
    ...   CASE WHEN irvcontrac0_.guarantee = 'Y' THEN TRIM('True')
    ...        WHEN irvcontrac0_.guarantee = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS guarantee,
    ...   irvcontrac0_.guarantor_name AS guarantor_name,
    ...   irvcontrac0_.last_changed_by AS last_changed_by,
    ...   irvcontrac0_.last_contact AS last_contract,
    ...   CASE WHEN irvcontrac0_.letter_of_credit = 'Y' THEN TRIM('True')
    ...        WHEN irvcontrac0_.letter_of_credit = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS letter_of_credit,
    ...   irvcontrac0_.letter_value AS letter_value,
    ...   CASE WHEN irvcontrac0_.limit_method_locked = 'Y' THEN TRIM('True')
    ...        WHEN irvcontrac0_.limit_method_locked = 'N' THEN TRIM('False')
    ...        ELSE TRIM('False')
    ...   END AS limit_method_locked,
    ...   TO_CHAR(irvcontrac0_.loc_expire_date, '%Y-%m-%dT%HH:%M:%SZ') AS loc_expire_date,
    ...   CASE WHEN irvcontrac0_.net_income::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(irvcontrac0_.net_income, '&.#'))
    ...       WHEN irvcontrac0_.net_income::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(irvcontrac0_.net_income, '########################&.#'))
    ...       WHEN irvcontrac0_.net_income::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(irvcontrac0_.net_income, '########################&.##'))
    ...       ELSE NULL
    ...   END AS net_income,
    ...   CASE WHEN irvcontrac0_.net_worth::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(irvcontrac0_.net_worth, '&.#'))
    ...       WHEN irvcontrac0_.net_worth::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(irvcontrac0_.net_worth, '########################&.#'))
    ...       WHEN irvcontrac0_.net_worth::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(irvcontrac0_.net_worth, '########################&.##'))
    ...       ELSE NULL
    ...   END AS net_worth,
    ...   irvcontrac0_.prev_changed_by AS prev_changed_by,
    ...   CASE WHEN irvcontrac0_.prev_limit::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(irvcontrac0_.prev_limit, '&.#'))
    ...       WHEN irvcontrac0_.prev_limit::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(irvcontrac0_.prev_limit, '########################&.#'))
    ...       WHEN irvcontrac0_.prev_limit::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(irvcontrac0_.prev_limit, '########################&.##'))
    ...       ELSE NULL
    ...   END AS prev_limit,
    ...   CASE WHEN irvcontrac0_.risk_score::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(irvcontrac0_.risk_score, '&.#'))
    ...       WHEN irvcontrac0_.risk_score::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(irvcontrac0_.risk_score, '########################&.#'))
    ...       WHEN irvcontrac0_.risk_score::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(irvcontrac0_.risk_score, '########################&.##'))
    ...       ELSE NULL
    ...   END AS risk_score,
    ...   irvcontrac0_.sales_rep AS sales_rep,
    ...   irvcontrac0_.status_reason AS status_reason,
    ...   CASE WHEN irvcontrac0_.stress_score::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(irvcontrac0_.stress_score, '&.#'))
    ...       WHEN irvcontrac0_.stress_score::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(irvcontrac0_.stress_score, '########################&.#'))
    ...       WHEN irvcontrac0_.stress_score::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(irvcontrac0_.stress_score, '########################&.##'))
    ...       ELSE NULL
    ...   END AS stress_score,
    ...   statusreas1_.status_reason_id AS status_reason_id,
    ...   statusreas1_.reason AS reason
    ...   FROM irv_contract irvcontrac0_
    ...   LEFT OUTER JOIN status_reason statusreas1_ ON irvcontrac0_.status_reason = statusreas1_.status_reason_id
    ...   WHERE irvcontrac0_.contract_id = ${api_dict}[contract_id]

    ${irv_query_dictionary}  query to dictionaries  ${irv_query}

    ${issuer_query}  catenate  SELECT issuerinfo0_.issuer_id AS issuer_id,
    ...   TRIM(issuerinfo0_1_.name) AS issuer_name,
    ...   TRIM(issuerinfo0_1_.short_name) AS short_name,
    ...   issuergrou1_.issuer_group_id AS issuer_group_id,
    ...   issuergrou1_.ifx_instance AS ifx_instance,
    ...   TRIM(issuergrou1_.name) AS issuer_group_name,
    ...   issuergrou1_.org_id AS org_id
    ...   FROM issuer_misc issuerinfo0_
    ...   LEFT OUTER JOIN Member issuerinfo0_1_ ON issuerinfo0_.issuer_id = issuerinfo0_1_.member_id
    ...   LEFT OUTER JOIN issuer_group issuergrou1_ ON issuerinfo0_.issuer_group_id = issuergrou1_.issuer_group_id
    ...   WHERE issuerinfo0_.issuer_id = ${result_list}[0][issuer_id]

    ${issuer_query_dictionary}  query to dictionaries  ${issuer_query}

    ${issuer_info}  Create Dictionary  issuer_id=${issuer_query_dictionary}[0][issuer_id]  issuer_name=${issuer_query_dictionary}[0][issuer_name]  short_name=${issuer_query_dictionary}[0][short_name]
    ${issuer_group}  Create Dictionary  ifx_instance=${issuer_query_dictionary}[0][ifx_instance]  issuer_group_id=${issuer_query_dictionary}[0][issuer_group_id]  issuer_group_name=${issuer_query_dictionary}[0][issuer_group_name]  org_id=${issuer_query_dictionary}[0][org_id]
    ${issuer_group}  evaluate  {key:val for key, val in ${issuer_group}.items() if val != None if val != ''}
    ${issuer_group}  evaluate  dict(sorted(${issuer_group}.items()))
    Set To Dictionary   ${issuer_info}  issuer_group=&{issuer_group}

    #combining the dictionaries
    ${irv_and_big}  evaluate  {**${irv_query_dictionary}[0], **${big_query_dictionary}[0]}
    #removing the values that have those values
    ${irv_and_big}  evaluate  {key:val for key, val in ${irv_and_big}.items() if val != None if val != ''}
    Set To Dictionary  ${irv_and_big}  issuer_info=${issuer_info}
    ${final_dict}  evaluate  dict(sorted(${irv_and_big}.items()))
    remove from dictionary  ${final_dict}  issuer_id

    [Return]  ${final_dict}

Get Funds Request Information from Database
    [Documentation]  query to get funds transfer information from database
    return from keyword if  '''${api_dict}[contract_type]''' != 'parent_funded'  @{EMPTY}
    ${page}  ${size}  Check Options

    get into db  TCH
    ${query}  catenate  SELECT  SKIP ${page} FIRST ${size}
    ...  CASE WHEN pd.amount::VARCHAR(50) LIKE '0.00' THEN TRIM(TO_CHAR(pd.amount, '&.#'))
    ...         WHEN pd.amount::VARCHAR(50) MATCHES '*.[0-9]0' THEN TRIM(TO_CHAR(pd.amount, '########################&.#'))
    ...         WHEN pd.amount::VARCHAR(50) MATCHES '*.?[1-9]' THEN TRIM(TO_CHAR(pd.amount, '########################&.##'))
    ...         ELSE NULL
    ...  END AS amount,
    ...  CASE
    ...     WHEN pd.status = 'C' THEN TRIM('CANCELLED')
    ...     WHEN pd.status = 'P' THEN TRIM('PENDING')
    ...     ELSE NULL
    ...  END AS fund_transfer_status,
    ...  pd.ppd_header_id AS bank_account_id,
    ...  TRIM(ph.dfi_account_number) AS account_nbr
    ...  FROM ach_ppd_contract_xref AS pcx
    ...  INNER JOIN ach_ppd_header AS ph
    ...  ON pcx.ppd_header_id = ph.ppd_header_id
    ...  INNER JOIN ach_ppd_detail AS pd
    ...  ON pcx.ppd_header_id = pd.ppd_header_id
    ...  WHERE pcx.contract_id = '${api_dict}[contract_id]'
    ...        AND pd.created_by != 'VERIFICATION SCRIPT'
    ...  ORDER BY pd.create_date DESC

    ${result_list}  query to dictionaries  ${query}
    [Return]  ${result_list}

Get Bank Account Information from Database
    [Documentation]  query to get bank account information from database
    ${page}  ${size}  Check Options

    get into db  Oracle
    ${query}  catenate  SELECT bank_account_id FROM (SELECT
    ...     bank_account_id, row_number() OVER (ORDER BY primary_flag desc, acct_creation_date desc, bank_account_num , xxtch_ar_cust_stg_id) rnk
    ...  FROM apps.xxtch_ar_cust_bank_acct_v
    ...    WHERE ar_number = '${api_dict}[ar_number]' and bank_acct_enabled_flag = 'Y'
    ...  ORDER BY primary_flag desc, acct_creation_date desc, bank_account_num , xxtch_ar_cust_stg_id)  WHERE rnk BETWEEN ${page} AND ${size}
    ${query_list}  query to dictionaries  ${query}
    Disconnect From Database
    [Return]  ${query_list}

Check Result
    [Documentation]  used to check the result and set a variable based on the result
    [Arguments]  ${result}
    IF  ${result} == ${None}
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    ELSE IF  """${result}[name]""" == 'OK' or """${result}[name]""" == 'CREATED'
        set test variable  ${api_result}  ${result}[details][data]
    ELSE
        @{empty_list}=  Create list
        set test variable  ${api_result}  ${empty_list}
    END

Test Request
    [Arguments]  ${type}
    ${type}  String.convert to upper case  ${type}
    IF  '${type}'=='CC' or '${type}'=='CA'
        IF  'GET' in """${TEST_NAME}"""
            GET requests Contract  type=${type}
        ELSE IF  'PATCH' in """${TEST_NAME}"""
            PATCH requests Contracts  type=${type}
        END
    ELSE IF  '${type}'=='INV'
        IF  'Open' in """${TEST_NAME}"""
            Get requests Open Invoices  type=${type}
        END
    ELSE IF  '${type}'=='SUM'
        Get requests Contract Summaries  type=${type}
    ELSE IF  '${type}'=='FUNDS'
        Get requests Funds Transfers  type=${type}
    ELSE IF  '${type}'=='TOVERDUE'
        Get requests Total Overdue Invoices  type=${type}
    ELSE IF  '${type}'=='BA'
         Get requests Bank Accounts  type=${type}
    ELSE
        log to console  ${type} endpoint not automated yet
    END

Make Dictionaries
    [Documentation]  keeps some data in and formats datatypes, in list dictionaries so they can be compared.
    [Arguments]  ${type}  ${db_dict}  ${api_dict}
    IF  '${type}'=='SUM'
        FOR  ${item}  IN  @{api_dict}
            Keep in Dictionary  ${item}  ar_number  carrier_id  contract_id
        END
    ELSE IF  '${type}'=='FUNDS'
        FOR  ${item}  IN  @{api_dict}
            Keep in Dictionary  ${item}  amount  fund_transfer_status  bank_account_id  account_nbr
            ${masked_account_nbr}  Format Account Number  ${item}[account_nbr]
            ${amount}  Convert to String  ${item}[amount]
            Set to Dictionary  ${item}  amount=${amount}
            Set to Dictionary  ${item}  account_nbr=${masked_account_nbr}
        END
    ELSE IF  '${type}'=='INV'
        FOR  ${item}  IN  @{api_dict}
            Keep in Dictionary  ${item}  ar_number  due_date  invoice_date  invoice_id  invoice_number  late_fees  open_amount  original_amount  pending_payments
            ${late_fees}  Convert to String  ${item}[late_fees]
            ${open_amount}  Convert to String  ${item}[open_amount]
            ${original_amount}  Convert to String  ${item}[original_amount]
            ${pending_payments}  Convert to String  ${item}[pending_payments]
#            ${amount_due}  Convert to String  ${item}[amount_due]
            Set to Dictionary  ${item}  late_fees=${late_fees}  open_amount=${open_amount}  original_amount=${original_amount}  pending_payments=${pending_payments}
        END
    ELSE IF  '${type}'=='TOVERDUE'

        ${api_dict}  Create List  ${api_dict}
    ELSE IF  '${type}'=='BA'
        FOR  ${item}  IN  @{api_dict}
            Keep in Dictionary  ${item}  carrier_id  contract_id  bank_account_id  contract_type
        END

    ELSE IF  '${type}'=='CC' or '${type}'=='CA'
        #really simplifying dictionaries from api results and db results
        Remove from Dictionary  ${api_dict}  unbilled_amt  payment_application_type  contract_type  created  last_trans  last_revision  last_due_date  available_balance_daily  available_credit  next_action  links  next_review  orig_limit  fin_date  bond_exp_date  aci_exp_date  guarantee_date  prev_changed  last_changed  language  limit_method  service_charges
        ${api_dict}  evaluate  dict(sorted(${api_dict}.items()))
        #these evaluates convert everything in the dictionary to a string and remove the issuer_info dictionary (couldn't get them to work in them because I needed them sorted)
        ${api_dict}  evaluate  {str(key): str(val) for key, val in ${api_dict}.items() if key != 'issuer_info'}
        ${db_dict}  evaluate  {str(key): str(val) for key, val in ${db_dict}.items() if key != 'issuer_info'}
        ${api_dict}  Create List  ${api_dict}
        ${db_dict}  Create List  ${db_dict}

    END
    [Return]  ${db_dict}  ${api_dict}

Check Options
    ${is_page_alpha}  evaluate  $optionals['page'].isalpha()
    ${is_size_alpha}  evaluate  $optionals['size'].isalpha()
    IF  ${is_page_alpha}==${FALSE}
        ${is_page_int}  get from dictionary  ${optionals}  page
    END

    IF  ${is_size_alpha}==${FALSE}
        ${is_size_int}  get from dictionary  ${optionals}  size
    END

    IF  ${is_page_alpha}==${TRUE}
        ${page}  set variable  0
    ELSE IF  ${is_page_int} <= 0
        ${page}  set variable  0
    ELSE IF  (${is_page_int} > 0 and ${is_size_int} < 0) or (${is_page_int} > 0 and ${is_size_alpha} == ${TRUE})
        ${new_page}  evaluate  ${is_page_int} * 10
        ${page}  set variable  ${new_page}
    ELSE IF  ${is_page_int} >= 0 and ${is_size_int} >= 0
        ${new_page}  evaluate  ${is_page_int} * ${is_size_int}
        ${page}  set variable  ${new_page}
    ELSE
        ${page}  set variable  0
    END

    IF  ${is_size_alpha}==${TRUE}
        ${size}  set variable  10
    ELSE IF  ${is_size_int} <= 0
        ${size}  set variable  10
    ELSE
        ${size}  set variable  ${is_size_int}
    END

    [Return]  ${page}  ${size}

Test Invalid Token
    [Documentation]  test with a bad (modified) token
    [Arguments]  ${type}
    get pkce token  ${okta_automated_email}  ${automated_user_password}  OTR_eMgr  BAD
    set to dictionary  ${api_dict}  carrier_id  ${original_carrier_id}
    Test Request  ${type}
    should be empty  ${api_result}

Test Incorrect User
    [Documentation]  test with a user that shouldn't have access i.e token for carrier 100004, tries 00004
    [Arguments]  ${type}
    set test variable  ${original_carrier_id}  ${api_dict}[carrier_id]
    ${carrier_id}  set variable  ${original_carrier_id}
    ${invalid_carrier}  evaluate  $carrier_id[1:]
    set to dictionary  ${api_dict}  carrier_id  ${invalid_carrier}
    Test Request  ${type}
    should be empty  ${api_result}

Format Account Number
    [Documentation]  adds a mask to the account number field retrieved from database
    [Arguments]  ${account_nbr}
    ${account_nbr}  strip string  ${account_nbr}
    ${masked_account_nbr}  evaluate  re.sub('(?<=.{6}).(?=.{4})', '*', '${account_nbr}')  re
    [Return]  ${masked_account_nbr}

Clean up
    [Documentation]  change data to original values and other necessary steps for teardown
    [Arguments]  ${type}

    ${type}  String.convert to upper case  ${type}
    Change Contracts to Original Value  ${type}
    Remove Automation User