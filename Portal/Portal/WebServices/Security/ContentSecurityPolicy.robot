*** Settings ***
Library    RequestsLibrary
Library    OperatingSystem
Library    String

Suite Setup    Run Keywords    Setup Base URL    Setup Content Security Policy Value

*** Variables ***
${environment}
${base_url}
${exp_cont_sec_policy}

*** Test Cases ***
Checking Pages Content Security Policy
    [Tags]    JIRA:PORT-744    JIRA:BOT-5000    qTest:116943450    PI:14
    [Documentation]    Ensure portal pages contain content security policy with expected value

     Check Content Security Policy from Login Page
     Check Content Security Policy from Home Page
#    List of pages: Portal Configuration, Themes, Database Tool, Application Manager, External Contracts,
#    Processed Sales, Credit Manager, Queues, Letter Manager, Cash Application, Configuration Manager, AR Manager,
#    Oracle Stating
     Check Content Security Policy from Other Pages

*** Keywords ***
Setup Base URL
    [Documentation]    Setup base url from portal

    ${env}    Fetch From Right    ${environment}    -
    ${base_url}    Set Variable    https://portal.${env}.efsllc.com/
    Set Suite Variable    ${base_url}

Setup Content Security Policy Value
    [Documentation]    Setup content security policy value expected

    ${exp_cont_sec_policy}    Catenate    default-src 'none';
     ...    script-src 'self' 'unsafe-inline' 'unsafe-eval';
     ...    style-src 'self' 'unsafe-inline' 'unsafe-eval';
     ...    img-src * data: blob: 'unsafe-inline';
     ...    frame-src 'self';
     ...    font-src 'self';
     ...    connect-src 'self'
     Set Suite Variable    ${exp_cont_sec_policy}

Get Content Security Policy
    [Documentation]    Compare content security policy expected and from API
    [Arguments]    ${endpoint}    ${status}=401

    ${response}    RequestsLibrary.GET    ${base_url}${endpoint}    expected_status=${status}
    Should Be Equal As Strings    ${exp_cont_sec_policy}    ${response.headers["Content-Security-Policy"]}

Check Content Security Policy from Login Page
    [Documentation]    Ensure login page from Portal has content security policy with expected value

    Get Content Security Policy    JpPortal/    200

Check Content Security Policy from Home Page
    [Documentation]    Ensure home page from Portal has content security policy with expected value

    Get Content Security Policy    JpPortal/Home    200

Check Content Security Policy from Other Pages
    [Documentation]    Ensure other pages from Portal have content security policy with expected value
    ...    List of pages: Portal Configuration, Themes, Database Tool, Application Manager, External Contracts,
    ...    Processed Sales, Credit Manager, Queues, Letter Manager, Cash Application, Configuration Manager,
    ...    AR Manager, Oracle Stating

     @{urls}    Create List    JpPortal/configuration/index.jsp    JpPortal/Theme/preview?themeId=5    JpPortal/Adhoc
     ...    AppManagerWeb/Application?_pdtid=18    AppManagerWeb/ExtContract?_pdtid=18
     ...    AppManagerWeb/SalesProcessed?_pdtid=18    CreditManagerWeb/Customer?_pdtid=16
     ...    CreditManagerWeb/Queues?_pdtid=16    CreditManagerWeb/LetterManager?_pdtid=16
     ...    ArManagerWeb/CashApplication?_pdtid=16    ConfManagerWeb/index.jsp?_pdtid=21
     ...    ArManagerWeb/TransactionSearch?_pdtid=20    TCHStagingWeb/Customer?_pdtid=12
     FOR    ${url}    IN    @{urls}
         Get Content Security Policy    ${url}
     END
